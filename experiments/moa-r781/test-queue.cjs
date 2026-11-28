// Exercise the actual patched production queue functions in a deterministic mock VM.
const fs=require('node:fs'),vm=require('node:vm'),assert=require('node:assert/strict');
const source=fs.readFileSync(process.argv[2],'utf8');
const names=['autoModel781','missing781','complete779','retryable779','migrate779','queue771','drain779','pump771','finishAuto771'];
let parts=names.map(n=>{let l=source.split('\n').find(x=>x.startsWith('function '+n+'('));assert.ok(l,n);return l});
const now=100000, requests=[],timers=[],map=new Map(), ctx={
 prefs:{auto:true,autoPlace:true,model:'gpt-6.2-astra'},state:{models:[{slug:'gpt-6.2-astra',label:'GPT-6.2 Astra'},{slug:'gpt-6.2-sol',label:'GPT-6.2 Sol'}],model:'gpt-6.2-astra',connected:true,lessons:{}},
 pending:{},MAX_AUTO779:5,sessionRetries779:0,sessionBlocked781:false,storageReady771:true,document:{hidden:false},Date:{now:()=>now},ACTIVE777:'active',INBOX779:'inbox',
 localStorage:{getItem:k=>map.get(k)||null},write777:(k,v)=>v?map.set(k,JSON.stringify(v)):map.delete(k),
 subjectCards:x=>x?.subjects||[],validLesson:x=>!!x?.valid,subjectEn773:x=>!!x.en,discovery773:x=>x.discovery||[],
 seed777:(k)=>{const l=ctx.state.lessons[k];return l?.valid&&l.subjects.length===6?{...l,subjects:l.subjects.map(({discovery,...x})=>x)}:null},
 persist771:()=>true,schedule771:d=>timers.push(d),autoStatus771:()=>{},status:()=>{},request:(op,body)=>requests.push({op,body}),restore777:()=>false
};
vm.createContext(ctx);vm.runInContext(parts.join('\n'),ctx);
const ids=['math','science','social','history','geography','korean'],k='2026-11-28|123',full={valid:true,subjects:ids.map(id=>({id,en:true,discovery:[1,2,3]}))},partial={valid:true,subjects:ids.map((id,i)=>({id,en:true,discovery:i===0?[]:[1,2,3]}))};
let n=0;function check(name,fn){fn();n++;console.log('PASS '+name)}
check('auto chooses exact available Sol; manual Astra remains selected',()=>{assert.equal(ctx.autoModel781(),'gpt-6.2-sol');assert.equal(ctx.state.model,'gpt-6.2-astra')});
check('explicit selected-model override',()=>{ctx.prefs.autoModelMode781='selected';assert.equal(ctx.autoModel781(),'gpt-6.2-astra');delete ctx.prefs.autoModelMode781});
check('no silent fallback to unavailable Sol',()=>{const old=ctx.state.models;ctx.state.models=old.slice(0,1);assert.equal(ctx.autoModel781(),'');ctx.state.models=old});
check('all seven plus discovery required',()=>{assert.ok(ctx.complete779(full));assert.equal(ctx.complete779(partial),false);assert.deepEqual(Array.from(ctx.missing781(partial)),['math'])});
check('partial fresh saved receipt not discarded',()=>{ctx.state.lessons[k]=partial;assert.equal(ctx.queue771('2026-11-28','123','memo'),true);assert.equal(ctx.pending[k].needsDiscovery,true)});
check('duplicate receipt does not duplicate request',()=>{assert.equal(ctx.queue771('2026-11-28','123','memo'),false);assert.equal(Object.keys(ctx.pending).length,1)});
check('pump chooses Sol and only missing discovery',()=>{ctx.pump771();const x=requests.at(-1);assert.equal(x.op,'generate');assert.equal(x.body.model,'gpt-6.2-sol');assert.equal(x.body.media,'123');assert.equal(x.body.autoPlace,true);assert.deepEqual(Array.from(x.body.missing781),['math']);assert.ok(x.body.seed777)});
check('retryable network errors get bounded backoff',()=>{ctx.finishAuto771({op:'generate',key:k,auto:true,subject:'all'},false,'HTTP 503');assert.equal(ctx.pending[k].state,'pending');assert.equal(ctx.pending[k].nextAt,now+15000);ctx.pending[k].attempt=4;ctx.finishAuto771({op:'generate',key:k,auto:true,subject:'all'},false,'응답 시간 초과');assert.equal(ctx.pending[k].nextAt,now+600000)});
check('fifth failed attempt stops retry',()=>{ctx.pending[k].attempt=5;ctx.finishAuto771({op:'generate',key:k,auto:true,subject:'all'},false,'응답 시간 초과');assert.equal(ctx.pending[k].state,'failed')});
check('quota, auth, explicit cancellation not looped',()=>{for(const s of ['HTTP 429','quota exceeded','인증이 만료','사용자 중지','요청 취소'])assert.equal(ctx.retryable779(s),false)});
check('prior transient failed job gets one migration, no quota retry',()=>{ctx.pending[k]={day:'2026-11-28',id:'123',state:'failed',attempt:3,error:'응답 시간 초과',retryPolicy779:true};ctx.pending.other={state:'failed',attempt:1,error:'HTTP 429'};ctx.migrate779();assert.equal(ctx.pending[k].state,'pending');assert.equal(ctx.pending.other.state,'failed');assert.ok(ctx.pending[k].retryPolicy781)});
check('successful all-stage save clears only matching queue job',()=>{ctx.state.lessons[k]=full;ctx.finishAuto771({op:'generate',key:k,subject:'all',auto:true},true);assert.equal(ctx.pending[k],undefined);assert.ok(ctx.pending.other)});
check('consent off prevents new queued media',()=>{ctx.prefs.auto=false;assert.equal(ctx.queue771('2026-11-28','456'),false)});
for(const name of ['family-diary.js','moa-r697-vertical-calendar.js']){
 const f=fs.readFileSync(require('node:path').join(require('node:path').dirname(process.argv[2]),name),'utf8');
 const code=f.split('\n').find(x=>x.trim().startsWith('function storeStudyReceipts781('));assert.ok(code,name);
 const storage=new Map(),c={localStorage:{getItem:k=>storage.get(k)||null,setItem:(k,v)=>storage.set(k,v)}};
 vm.createContext(c);vm.runInContext(code,c);
 check(name+' consent-off receipt suppression',()=>{assert.equal(c.storeStudyReceipts781('2026-11-28',['123']),false);assert.equal(storage.size,0)});
 check(name+' durable local commit receipt and exact ID deduplication',()=>{
  storage.set('moa.study.preferences.v771','{"auto":true}');
  assert.ok(c.storeStudyReceipts781('2026-11-28',['123','v456','invalid']));
  const key='moa.study.commit-inbox.v779', old=JSON.parse(storage.get(key));old['2026-11-28|123'].note='original note';storage.set(key,JSON.stringify(old));
  assert.ok(c.storeStudyReceipts781('2026-11-28',['123','789']));
  const q=JSON.parse(storage.get(key));assert.equal(Object.keys(q).length,3);assert.equal(q['2026-11-28|123'].note,'original note');assert.equal(q['2026-11-28|v456'].nativeCommit779,true);
 });
}
check('HTTP 408 is retryable but ordinary HTTP 4xx is blocked',()=>{assert.ok(ctx.retryable779('HTTP 408'));assert.equal(ctx.retryable779('HTTP 403'),false)});

console.log(n+' mock function tests PASS; no real AI, Android, or database validation');
