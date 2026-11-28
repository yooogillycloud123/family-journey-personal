#!/usr/bin/env python3
"""Extend the verified R783 learning pipeline with exclusive OS-managed background worker."""
from pathlib import Path
import sys,re
p=Path(sys.argv[1]);s=p.read_text()
def rep(a,b,n=1):
 global s
 assert s.count(a)==n,(s.count(a),a[:150]);s=s.replace(a,b)
def fn(name,new):
 global s
 s,n=re.subn(r'^function '+re.escape(name)+r'\(.*$',lambda _:new,s,count=1,flags=re.M)
 assert n==1,name
rep('let settings785=null;', '''let settings785=null;
const BG785=window.MoaBackground785===true, CFG785=['auto','background785','wifi785','charge785','autoPlace','model','autoModelMode781','accent','rate','repeat'];
const BGREV785='moa.study.bg.revision.v785', BGSTATUS785='moa.study.bg.status.v785', BGRETRY785='moa.study.bg.retry.v785', BGMODELS785='moa.study.bg.models.v785';
let bgNative785=null,bgCfgAt785=0,bgCfgKey785='',bgCfgBusy785=false,bgProcessed785=false,bgRecoverAt785=0,bgRetrySeen785='',bgReloadAt785=0,bgRevision785='',bgModelsSeen785='',bgScopeReady785=false;
''')
rep("auto:false,autoPlace:false},pending={}","auto:false,autoPlace:false,background785:true,wifi785:false,charge785:false},pending={}")
rep("const ACTIVE777='moa.study.active.v777',RETRY777=", "const LEGACYACTIVE785='moa.study.active.v777',ACTIVE777=BG785?'moa.study.active.bg785':LEGACYACTIVE785,RETRY777=")
# Preserve user config and background runtime cooldown independently. Only the owning engine
# writes the shared queue, and background receipt is not the manual receipt.
fn('persist771',r"""function persist771(){try{let disk={};try{disk=JSON.parse(localStorage.getItem(PREF771)||'{}')||{}}catch{}if(BG785){for(const k of CFG785)if(Object.prototype.hasOwnProperty.call(disk,k))prefs[k]=disk[k];localStorage.setItem(PREF771,JSON.stringify({...disk,...prefs}));}else if(prefs.background785){const next={...disk};for(const k of CFG785)if(Object.prototype.hasOwnProperty.call(prefs,k))next[k]=prefs[k];localStorage.setItem(PREF771,JSON.stringify(next));}else localStorage.setItem(PREF771,JSON.stringify(prefs));if(BG785||!prefs.background785)localStorage.setItem(QUEUE771,JSON.stringify(pending));return true}catch(e){status('자동 학습 저장 공간 확인 · '+e.message);return false}}""")
rep("function wake783(){scanDirty783=true;schedule771(100)}",r"""function wake783(){scanDirty783=true;if(!BG785)configure785();schedule771(100)}""")
helper=r"""
function readQueue785(){try{const x=JSON.parse(localStorage.getItem(QUEUE771)||'{}');if(x&&typeof x==='object'&&!Array.isArray(x))pending=x}catch{}}
function readConfig785(){
 try{const disk=JSON.parse(localStorage.getItem(PREF771)||'{}');for(const k of CFG785)if(Object.prototype.hasOwnProperty.call(disk,k))prefs[k]=disk[k];return true}catch{return false}
}
function legacyKey785(){try{return JSON.parse(localStorage.getItem(LEGACYACTIVE785)||'null')?.key||''}catch{return ''}}
function configure785(retry=false){
 if(BG785||bgCfgBusy785||!window.MoaPeerControl?.request)return;
 const body={enabled:!!(prefs.auto&&prefs.background785),wifi:!!prefs.wifi785,charge:!!prefs.charge785,retry:!!retry};
 const k=[body.enabled,body.wifi,body.charge].join('|'),now=Date.now();
 if(!retry&&k===bgCfgKey785&&now-bgCfgAt785<12000)return;
 bgCfgBusy785=true;bgCfgAt785=now;bgCfgKey785=k;
 command('bgConfig785',body).catch(()=>{bgCfgKey785='';bgNative785={error:'백그라운드 예약 연결 대기'}}).finally(()=>{bgCfgBusy785=false;autoStatus771()});
}
function invalidateBackground785(day){if(BG785)return;scanDirty783=true;if(prefs.auto&&prefs.background785)command('bgInvalidate785',{day:String(day||'')}).catch(()=>{});wake783()}
async function readCard785(k){if(!studyDB771)return null;return await new Promise((resolve,reject)=>{const tx=studyDB771.transaction('cards','readonly'),r=tx.objectStore('cards').get(k);r.onsuccess=()=>resolve(r.result||null);r.onerror=()=>reject(r.error);tx.onabort=()=>reject(tx.error||Error('학습 읽기 중단'))})}
async function reloadForeground785(){
 if(BG785||!studyDB771)return;
 const rev=localStorage.getItem(BGREV785)||'',now=Date.now();
 if(rev!==bgRevision785||now-bgReloadAt785>60000){
  const rows=await new Promise((resolve,reject)=>{const tx=studyDB771.transaction('cards','readonly'),r=tx.objectStore('cards').openCursor(),a={};r.onsuccess=()=>{const c=r.result;if(c){if(typeof c.key==='string'&&validLesson(c.value))a[c.key]=c.value;c.continue()}};tx.oncomplete=()=>resolve(a);tx.onerror=()=>reject(tx.error);tx.onabort=()=>reject(tx.error||Error('학습 다시 읽기 중단'))});
  const k=state.view?key(state.view):'',before=state.lessons[k],after=rows[k];state.lessons={...state.lessons,...rows};bgRevision785=rev;bgReloadAt785=now;
  if(k&&after&&JSON.stringify(before)!==JSON.stringify(after)&&!state.voice)render();
 }
 readQueue785();
 try{const raw=localStorage.getItem(BGMODELS785)||'',m=JSON.parse(raw||'null');if(raw!==bgModelsSeen785&&m&&Date.now()-m.at<1800000&&Array.isArray(m.models)&&!state.job){bgModelsSeen785=raw;state.models=m.models;state.modelRevision++;state.model=state.models.some(a=>a.slug===prefs.model)?prefs.model:(state.models[0]?.slug||'');state.connected=!!m.connected;sync()}}catch{}
}
async function allowedRegistration785(k){const [day,id]=String(k).split('|');return normalize783(await window.MoaStudyCurated783(day)).has(day+'|'+id)}
function bgDelay785(){
 const now=Date.now();
 if(!prefs.auto||!prefs.background785)return -1;
 if(Number(prefs.quotaUntil783)>now)return Math.max(1000,prefs.quotaUntil783-now);
 if(!state.connected&&Number(prefs.authCheckAfter783)>now)return Math.max(1000,prefs.authCheckAfter783-now);
 if(scopeError783)return 900000;
 if(!registered783)return 30000;
 const legacy=legacyKey785(),rows=Object.entries(pending).filter(([k,q])=>k!==legacy&&registered783.has(k)&&!complete779(state.lessons[k])&&q.state==='pending');
 if(rows.some(([,q])=>!(q.nextAt>now)))return 2000;
 if(rows.length)return Math.max(1000,Math.min(...rows.map(([,q])=>Math.max(1000,(q.nextAt||0)-now))));
 const t=tally783();
 return t&&t.done<t.total?1800000:900000; // bounded no-AI reconciliation catches later committed media
}
function backgroundTick785(){
 if(!BG785)return 'stop';
 if(!readConfig785()||!prefs.auto||!prefs.background785)return 'stop';
 if(!storageReady771)return 'loading';
 if(state.job){
  if(state.job.restored&&Date.now()-bgRecoverAt785>10000){bgRecoverAt785=Date.now();recover777()}
  return 'running';
 }
 if(pumping783)return 'working';
 if(bgProcessed785)return 'done:'+Math.max(1000,bgDelay785());
 try{const retry=localStorage.getItem(BGRETRY785)||'';if(retry&&retry!==bgRetrySeen785){bgRetrySeen785=retry;retryAll783();localStorage.removeItem(BGRETRY785)}}catch{}
 if(bgScopeReady785){
  const now=Date.now(),t=tally783();
  if(scopeError783||Number(prefs.quotaUntil783)>now||(!state.connected&&Number(prefs.authCheckAfter783)>now)||state.connected&&!autoModel781()||t&&t.done===t.total)return 'done:'+Math.max(1000,bgDelay785());
  const legacy=legacyKey785();
  const ready=Object.entries(pending).some(([k,q])=>k!==legacy&&registered783?.has(k)&&q.state==='pending'&&!(q.nextAt>now)&&!complete779(state.lessons[k]));
  const old=localStorage.getItem(ACTIVE777);
  if(!ready&&!old)return 'done:'+Math.max(1000,bgDelay785());
 }
 pump771();return 'working';
}
"""
rep('function progress783(){',helper+'\nfunction progress783(){')
# UI reports actual scheduler/worker state; not a simulated status.
rep("const msg=progress783(),v=state.view;","let msg=progress783();if(BG785){try{localStorage.setItem(BGSTATUS785,JSON.stringify({at:Date.now(),message:msg}))}catch{}}else if(prefs.auto&&prefs.background785){try{const x=JSON.parse(localStorage.getItem(BGSTATUS785)||'null');if(x&&Date.now()-x.at<600000&&x.message)msg=x.message}catch{}msg+=' · '+(bgNative785?.error|| (bgNative785?.running?'백그라운드 작업 실행 중':bgNative785?.scheduled?'Android 예약됨':'백그라운드 예약 확인 중'))}const v=state.view;")
# Worker does not use the original screen lifecycle or the UI's manual receipt.
rep("if(state.job||!storageReady771)return;\n // Manual receipts",'''if(state.job||!storageReady771)return;
 if(!BG785&&prefs.background785){
  configure785();
  if(restore777())return;
  try{await reloadForeground785();if(prefs.auto&&typeof window.MoaStudyCurated783==='function')registered783=normalize783(await window.MoaStudyCurated783());scopeError783=''}catch(e){scopeError783=String(e.message||e)}
  autoStatus771();return;
 }
 if(BG785&&!readConfig785())return;
 // Manual receipts''')
rep('!prefs.auto||document.hidden','!prefs.auto||(!BG785&&document.hidden)',3)
rep("try{await scan783();scopeError783=''}catch(e){scopeError783=String(e.message||e);autoStatus771();return}","try{await scan783();scopeError783='';if(BG785)bgScopeReady785=true}catch(e){scopeError783=String(e.message||e);if(BG785)bgScopeReady785=true;autoStatus771();return}")
rep("if(!state.connected){\n  if((sessionBlocked781", "if(!state.connected){\n  if(BG785&&Number(prefs.authCheckAfter783)>now)return;\n  if((sessionBlocked781")
rep("const ready=Object.entries(pending).filter(([k,q])=>registered783.has(k)&&q.state==='pending'","const ready=Object.entries(pending).filter(([k,q])=>(!BG785||legacyKey785()!==k)&&registered783.has(k)&&q.state==='pending'")
rep("if(!fresh){registered783.delete(k);delete pending[k];persist771();wake783();return}","if(!fresh){registered783.delete(k);delete pending[k];persist771();wake783();return}\n if(BG785){try{const stored=await readCard785(k);if(validLesson(stored))state.lessons[k]=stored}catch(e){scopeError783='학습 저장소 다시 확인 필요';return}if(!readConfig785()||!prefs.background785||legacyKey785()===k)return}")
rep("function retryAll783(){","function retryAll783(){\n if(!BG785&&prefs.background785){try{localStorage.setItem(BGRETRY785,String(Date.now()))}catch{}configure785(true);return;}")
rep("if(on){for(const q of Object.values(pending))if(q.state==='paused'){q.state='pending';q.nextAt=0;q.attempt=0}}","if(on){if(!BG785&&prefs.background785){try{localStorage.setItem(BGRETRY785,String(Date.now()))}catch{}}else for(const q of Object.values(pending))if(q.state==='paused'){q.state='pending';q.nextAt=0;q.attempt=0}}")
rep('let timer771=0;function schedule771(delay=900){clearTimeout(timer771);','let timer771=0;function schedule771(delay=900){if(BG785)return;clearTimeout(timer771);')
rep("function finishAuto771(j,ok,message=''){","function finishAuto771(j,ok,message=''){if(BG785&&j?.auto&&j.op==='generate')bgProcessed785=true;")
# Background result import checks registration again; durable card is written before receipt ack.
rep("async function save(k,lesson){let primary=false;","async function save(k,lesson){if(BG785&&!(await allowedRegistration785(k)))throw Error('직접 등록에서 제외된 학습 대상');let primary=false;")
rep("if(primary){state.lessons[k]=lesson;","if(primary){state.lessons[k]=lesson;if(BG785){try{localStorage.setItem(BGREV785,String(Date.now())+'|'+k)}catch{}}")
rep("if(primary){state.lessons[k]", "if(BG785&&!primary)throw Error('백그라운드 학습 저장 실패');if(primary){state.lessons[k]")
rep("async function event(e){if(e.type==='studyLocalAnswer')","async function event(e){if(e.type==='bgStatus785'){bgNative785=e;autoStatus771();return}if(e.type==='studyLocalAnswer')")
rep("if(!prefs.model&&state.model){prefs.model=state.model;persist771()}","if(!BG785&&!prefs.model&&state.model){prefs.model=state.model;persist771()}")
rep("state.connected=!!e.connected;finishJob(j);","state.connected=!!e.connected;if(BG785){try{localStorage.setItem(BGMODELS785,JSON.stringify({at:Date.now(),connected:state.connected,models:state.models}))}catch{}}finishJob(j);")
# Prevent headless's original periodic UI timers from competing with the scheduler.
rep("if(prefs.auto&&!document.hidden&&!state.job)pump771()","if(!BG785&&prefs.auto&&!document.hidden&&!state.job)pump771()")
rep("if(!state.job&&!document.hidden&&resumeTicks777<8)","if(!BG785&&!state.job&&!document.hidden&&resumeTicks777<8)")
rep("else if(state.job?.restored&&!document.hidden&&++resumeTicks777%5===0)","else if(!BG785&&state.job?.restored&&!document.hidden&&++resumeTicks777%5===0)")
rep("mountAutoSettings:mountAutoSettings783};","mountAutoSettings:mountAutoSettings783,backgroundTick785,invalidateBackground:invalidateBackground785};")
rep("migrate779();schedule771();document.addEventListener", "migrate779();if(!BG785){configure785();window.addEventListener('storage',e=>{if(e.key===BGREV785||e.key===BGSTATUS785||e.key===BGMODELS785){void reloadForeground785().then(autoStatus771).catch(()=>{})}})}schedule771();document.addEventListener")
p.write_text(s)
print('R785 background JS ownership, settings, receipt and storage patch applied')
