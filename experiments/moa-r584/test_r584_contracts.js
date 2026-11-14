const fs=require('fs'),vm=require('vm'),assert=require('node:assert/strict');
const ROOT=process.env.MOA_R584_ROOT||'/mnt/data/moa_r584';
const src=fs.readFileSync(ROOT+'/moa-r483-vertical-calendar.js','utf8');
const cut=(a,b)=>{const start=src.indexOf(a),end=src.indexOf(b,start+a.length);assert(start>=0&&end>start,[a,b]);return src.slice(start,end)};
const repair=cut('// R584: When original native Gallery','// R495: user preference');
const data=cut('// R580: BOTH detail diary','function mainCover(');
const day='2026-11-15',other='2026-11-12';
let store=new Map();
const mk=(d,ids,version)=>({day:d,photoIds:ids,updatedAt:version,moments:ids.map((id,k)=>({uid:'m'+k,at:Date.parse(d+'T07:28:00')+k*60000,photoIds:[id],note:'memo'+k}))});
store.set(day,mk(day,['13501'],1));store.set(other,mk(other,['94501'],1));
const ui={open:true,page:'calendar',date:day,month:new Date(day+'T12:00:00'),source:'curated',idx:0,media:[]};
const state={curatedEntries:new Map(),entries:new Map(),byId:new Map(),byDay:new Map(),byVideoDay:new Map(),load:false};
const view={hidden:false,classList:{add(){},remove(){}},querySelector(){return {remove(){}}}};
const calls=[],modes=[],notices=[];
function req(getter){const r={};queueMicrotask(()=>{r.result=getter();r.onsuccess?.()});return r}
const db=async()=>({transaction:(t,mode)=>{
 assert.equal(t,'curated');modes.push(mode);
 return {objectStore:()=>({get:key=>req(()=>store.get(key)),getAll:range=>req(()=>[...store.values()].filter(x=>x.day>=range.lower&&x.day<=range.upper))})}
},close(){}});
const win={__moaR507NativePending:false,__moaR567ProgrammaticCloseUntil:0,__moaR511InlineArm:false,__moaR511NativeArmed:false,
 MoaLocalAudio:{closeNativeGallery(){calls.push('closeNative')}},FamilyJourneyDiary:{loadIndex(force){calls.push('loadIndex:'+force);state.load=true}}};
const ctx={ui,view,window:win,getState:()=>state,db,Date,Math,JSON,Map,Set,Number,String,Array,console,
 setTimeout,clearTimeout,r507Timer:0,r507Opened:false,r576Opening:false,r576BlockedSignature:'',r523DayExiting:false,r531Advanced:false,r515RecoveryAttempts:0,r551LostAttempts:0,
 r507Generation:1,r515LastNativeMount:0,r578CalendarKey:undefined,r475LastDataKey:'',
 r507StopInline(){calls.push('stopNative');ctx.r507Opened=false;win.__moaR507NativePending=false;},
 r527BeginDay(){calls.push('beginDay')},r507StartInline(){calls.push('openNative');ctx.r507Opened=true;win.__moaR507NativePending=true},
 renderMedia(){calls.push('renderMedia')},render(){calls.push('render')},notify:x=>notices.push(x),
 valid:d=>/^2026-11-\d\d$/.test(d),safeMedia:id=>/^(?:\d{1,19}|v\d{1,18})$/.test(String(id)),
 IDBKeyRange:{bound:(lower,upper)=>({lower,upper})},dayOf:d=>new Date(d).toISOString().slice(0,10)
};
vm.createContext(ctx);vm.runInContext(repair+'\n'+data,ctx);
const run=expr=>vm.runInContext(expr,ctx);let pass=0;
async function test(name,fn){await fn();pass++;console.log('PASS',name)}
(async()=>{
 await test('month rehydration shows native Quick Record before MediaStore index',async()=>{
  assert.equal(await run('r580HydrateCalendarMonth(true)'),true);
  assert.equal(state.curatedEntries.get(day).photoIds[0],'13501');
 });
 await test('day saved ID has one canonical provisional card',async()=>{
  ui.page='day';assert.equal(await run('r578HydrateSelectedDay(true)'),true);
  assert.deepEqual(Array.from(ui.media,x=>x.id),['13501']);assert(calls.includes('openNative'));
 });
 await test('new committed ID rebinds original gallery ONCE, even if previously mounted',async()=>{
  const originalOpens=calls.filter(x=>x==='openNative').length;
  store.set(day,mk(day,['13501','13502'],3));
  assert.equal(await run('r578HydrateSelectedDay(true)'),true);
  await new Promise(resolve=>setTimeout(resolve,570));
  assert.deepEqual(Array.from(ui.media,x=>x.id),['13501','13502']);
  assert.equal(calls.filter(x=>x==='openNative').length,originalOpens+1);
  assert.equal(calls.filter(x=>x==='stopNative').length,1);
 });
 await test('same IDs but text-only diary update does NOT restart gallery',async()=>{
  const old=calls.filter(x=>x==='stopNative').length;
  store.set(day,{...store.get(day),body:'changed memo',updatedAt:4});
  await run('r578HydrateSelectedDay(true)');await new Promise(resolve=>setTimeout(resolve,250));
  assert.equal(calls.filter(x=>x==='stopNative').length,old);
 });
 await test('one-tap recovery re-reads same original DB, forces missing index and reopens',async()=>{
  const old=calls.filter(x=>x==='stopNative').length;
  const ok=await run('r584RecoverGallery()');assert.equal(ok,true);
  assert.equal(calls.filter(x=>x==='stopNative').length,old+1);
  assert(calls.includes('loadIndex:true'));await new Promise(resolve=>setTimeout(resolve,310));
  assert(calls.at(-1)==='openNative');
 });
 await test('empty saved day does not open invalid gallery or mutate recorded photos',async()=>{
  ui.date='2026-11-21';ui.media=[];ctx.r507Opened=false;win.__moaR507NativePending=false;state.load=false;
  const opens=calls.filter(x=>x==='openNative').length;
  const ok=await run('r584RecoverGallery()');assert.equal(ok,false);assert.equal(calls.filter(x=>x==='openNative').length,opens);
 });
 await test('another date is isolated from committed IDs',async()=>{assert.deepEqual([...run('mediaFor("2026-11-12").map(x=>x.id)')],['94501']);});
 await test('all read-only sync transactions never modify IndexedDB',async()=>{assert(modes.length>0&&modes.every(m=>m==='readonly'));});
 await test('R567 filmstrip geometry restored; R580 translation removed',async()=>{
  const j=fs.readFileSync(ROOT+'/MoaR507InlineGalleryProvider.java','utf8');
  assert(j.includes('lp.height=dp(a,expanded?137:82)'));
  assert(!j.includes('r576TightenMeasuredRail'));
  assert(!j.includes('float drawnBottom=f[1]'));
 });
 console.log(JSON.stringify({passes:pass,status:'PASS',device:'NOT TESTED'},null,2));
})().catch(e=>{console.error(e);process.exitCode=1});
