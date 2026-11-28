const fs=require('fs'),vm=require('vm'),assert=require('assert'),{webcrypto}=require('crypto');
const src=fs.readFileSync(process.argv[2],'utf8');
const day='2026-11-28';const cards=new Map();const rows=[{day,selectionMode:'manual',photoIds:['123','456','789','remote-9'],removedMediaIds:['789'],body:'test'},{day:'2026-11-27',selectionMode:'automatic',photoIds:['555']}];
const pref='moa.study.preferences.v771',auth='moa.study.auth.failure.v789',queue='moa.study.queue.v771';
const store=new Map([[pref,JSON.stringify({auto:true,background785:true,autoModelMode781:'sol',autoPlace:false,authCheckAfter783:Date.now()+1800000})]]);
const localStorage={getItem:k=>store.has(k)?store.get(k):null,setItem:(k,v)=>store.set(k,String(v)),removeItem:k=>store.delete(k)};
const db={transaction(){const tx={};tx.objectStore=()=>({openCursor(){const req={};let it=cards.entries();function next(){const n=it.next();req.result=n.done?null:{key:n.value[0],value:n.value[1],continue:()=>setImmediate(next)};req.onsuccess?.();if(n.done)setImmediate(()=>tx.oncomplete?.())}setImmediate(next);return req},get(k){const req={};setImmediate(()=>{req.result=cards.get(k);req.onsuccess?.()});return req},put(v,k){cards.set(k,JSON.parse(JSON.stringify(v)));setImmediate(()=>tx.oncomplete?.());return {}}});return tx}};
const indexedDB={open(){const r={result:db};setImmediate(()=>r.onsuccess?.());return r}};
const node=()=>({append(){},addEventListener(){},setAttribute(){},style:{}});
const document={hidden:true,head:node(),createElement:node,querySelector(){return null},getElementById(){return null},addEventListener(){}};
const fields={title:'t',explanation:'e',question:'q',answer:'a',activity:'x'},disc={topic:'science',confidence:'general_knowledge',title:'t',question:'q',answer:'a',link:'l',en:{title:'t',question:'q',answer:'a',link:'l'}};
const lesson={summary:'s',en:'English',ko:'한국어',story:'Story',storyKo:'이야기',words:[{en:'word',ko:'뜻',example:'Example'}],quiz:[{question:'q',choices:['a','b','c'],answer:0}],subjects:['math','science','social','history','geography','korean'].map(id=>({id,...fields,en:fields,confidence:'general_knowledge',discovery:[disc,disc,disc]}))};
const idle=()=>new Promise(r=>setTimeout(r,8));
function worker(fail=false){
 const requests=[],w={indexedDB,MoaBackground785:true,MoaStudyCurated783:async d=>d?rows.filter(x=>x.day===d):rows,addEventListener(){}};
 w.MoaPeerControl={request:async msg=>{const j=JSON.parse(Buffer.from(msg.split(':').at(-1),'base64url').toString());requests.push(j);if(j.op==='session')setImmediate(async()=>{if(fail){await w.MoaInline755.event({id:j.id,type:'error',message:'HTTP 429 사용량 제한'});return}await w.MoaInline755.event({id:j.id,type:'models',models:[{slug:'gpt-6.2-sol',label:'GPT-6.2 Sol'}]});await w.MoaInline755.event({id:j.id,type:'session',connected:true})});if(j.op==='generate')setImmediate(async()=>{await w.MoaInline755.event({id:j.id,type:'progress',message:'AI 응답 수신 중'});await w.MoaInline755.event({id:j.id,type:'studyCore777',text:JSON.stringify(lesson)});await w.MoaInline755.event({id:j.id,type:'studyResult777',text:JSON.stringify(lesson)})});return true}};
 const ctx={window:w,document,localStorage,indexedDB,crypto:webcrypto,TextEncoder,Uint8Array,btoa:s=>Buffer.from(s,'binary').toString('base64'),setTimeout:()=>0,clearTimeout(){},setInterval(){},console,confirm:()=>true};vm.createContext(ctx);vm.runInContext(src,ctx);
 return {w,requests,async run(){await idle();let result;for(let i=0;i<80;i++){result=w.MoaInline755.backgroundTick785();await idle();if(result.startsWith('done:')||result==='stop')return result}throw Error('worker never stopped')}};
}
(async()=>{
 // The physical symptom: stale prior pending-auth timestamp after successful connection, incomplete rows.
 let a=worker(),r=await a.run();console.log('run1',r,a.requests.map(x=>x.op+':'+(x.media||'')));
 assert.equal(a.requests.filter(x=>x.op==='session').length,1);assert.deepEqual(a.requests.filter(x=>x.op==='generate').map(x=>x.media).sort(),['123','456']);assert.equal(cards.size,2);
 assert.equal(JSON.parse(store.get(pref)).authCheckAfter783,0);assert(!store.has(auth));assert.equal(a.requests.filter(x=>x.op==='studyAck777').length,2);
 // Restarted worker must not re-generate a complete card. Fresh committed media is generated.
 rows[0].photoIds.push('999');a=worker();r=await a.run();assert.deepEqual(a.requests.filter(x=>x.op==='generate').map(x=>x.media),['999']);assert.equal(cards.size,3);
 // Actual quota failure persists across fresh worker and is not mistaken for old stale hold.
 rows[0].photoIds.push('1000');a=worker(true);r=await a.run();assert.equal(a.requests.filter(x=>x.op==='session').length,1);assert.equal(a.requests.filter(x=>x.op==='generate').length,0);assert.equal(JSON.parse(store.get(auth)).kind,'quota');
 a=worker();r=await a.run();assert.equal(a.requests.filter(x=>x.op==='session').length,0);assert.equal(a.requests.filter(x=>x.op==='generate').length,0);assert(r.includes('사용량'));
 const p=JSON.parse(store.get(pref));p.auto=false;store.set(pref,JSON.stringify(p));assert.equal(a.w.MoaInline755.backgroundTick785(),'stop');
 console.log('PASS: stale pre-request auth migration, one-session multi-card drain, durable success across restart, no duplicate/removed/remote, genuine quota hold and OFF');
})().catch(e=>{console.error(e);process.exitCode=1});
