#!/usr/bin/env python3
"""R783 exact R781 registered-only study reconciliation. No native or signing changes."""
import pathlib,sys,re
root=pathlib.Path(sys.argv[1])
p=root/'family-diary.js'
s=p.read_text()
anchor="async function dbAll(table='entries')"
assert s.count(anchor)==1
s=s.replace(anchor,"""// Read only the canonical, explicitly curated diary store; never read gallery index.
w.MoaStudyCurated783=async function(day){
 if(day){const entry=await dbGet('curated',day);return entry?[entry]:[]}
 return await dbAll('curated');
};
"""+anchor)
p.write_text(s)
p=root/'moa-r755-inline-ai.js'
s=p.read_text()
def rep(old,new):
 global s
 assert s.count(old)==1,(s.count(old),old[:140])
 s=s.replace(old,new,1)
def fn(name,new):
 global s
 s,n=re.subn(r'^function '+re.escape(name)+r'\(.*$',lambda _:new,s,count=1,flags=re.M)
 assert n==1,name
helper=r"""
// R783 registered-only reconciliation. The authoritative source is family-diary curated,
// not the current screen, gallery index, automatic entries, or remote timeline.
let registered783=null,scanAt783=0,scanDirty783=true,pumping783=false,scopeError783='',stats783=null;
const SCAN783=60000, BATCH783=24;
function normalize783(rows){
 if(!Array.isArray(rows))throw Error('등록 달력 목록 확인 실패');
 const found=new Map();
 for(const row of rows){
  if(!row||row.selectionMode==='automatic'||!/^\d{4}-\d{2}-\d{2}$/.test(String(row.day||'')))continue;
  const hidden=new Set((Array.isArray(row.removedMediaIds)?row.removedMediaIds:[]).map(String)),notes=new Map();
  const ids=new Set((Array.isArray(row.photoIds)?row.photoIds:[]).map(String));
  for(const m of Array.isArray(row.moments)?row.moments:[]){
   if(!m||!Array.isArray(m.photoIds))continue;
   const t=new Date(Number(m.at));
   if(!Number.isFinite(t.getTime()))continue;
   const day=t.getFullYear()+'-'+String(t.getMonth()+1).padStart(2,'0')+'-'+String(t.getDate()).padStart(2,'0');
   if(day!==row.day)continue;
   for(const raw of m.photoIds){const id=String(raw);ids.add(id);if(typeof m.note==='string'&&m.note.trim())notes.set(id,(notes.get(id)||'')+'\n'+m.note.trim())}
  }
  for(const id of ids){
   if(!/^v?[0-9]{1,18}$/.test(id)||hidden.has(id))continue;
   const key=row.day+'|'+id,note=[typeof row.body==='string'?row.body:'',notes.get(id)||''].filter(Boolean).join('\n').slice(0,12000);
   found.set(key,{day:row.day,id,note,updated:Number(row.updatedAt)||Date.parse(row.day+'T12:00:00')||0});
  }
 }
 return found;
}
function classify783(m){
 m=String(m||'');
 if(/사용자 중지|사용자 취소|^취소$/.test(m))return 'paused';
 if(/사용량|요청 제한|quota|rate.limit|HTTP 429\b/i.test(m))return 'quota';
 if(/권한|인증|계정 연결|계정을 연결|HTTP (?:401|403)\b/i.test(m))return 'auth';
 if(/모델을 선택|모델을 다시|모델을 사용할 수 없|모델 설정/.test(m))return 'model';
 if(/저장 공간|저장 실패|저장소/i.test(m))return 'storage';
 if(/미디어 ID 오류|원본 사진·영상만 지원|원본.*(?:없|찾을 수 없)|파일.*(?:없|찾을 수 없)/i.test(m))return 'source';
 return retryable779(m)?'transient':'other';
}
function delay783(q,kind,now){
 if(kind==='paused'){q.state='paused';q.nextAt=0;return}
 if(kind==='auth'||kind==='model'){q.state='blocked';q.nextAt=0;return}
 q.state='pending';
 if(kind==='quota'){prefs.quotaUntil783=Math.max(Number(prefs.quotaUntil783)||0,now+3600000);q.nextAt=prefs.quotaUntil783;return}
 if(kind==='storage'||kind==='source'||kind==='other'){q.nextAt=now+(kind==='source'?21600000:3600000);return}
 const a=Math.max(1,Number(q.attempt)||1);
 if(a>=MAX_AUTO779){q.attempt=0;q.nextAt=now+1800000;return}
 q.nextAt=now+[15000,60000,180000,600000][Math.min(3,a-1)];
}
function migrateQueue783(now){
 let changed=false;
 for(const [k,q] of Object.entries(pending)){
  if(!registered783?.has(k)||!q||typeof q!=='object')continue;
  if(q.state==='failed'&&!q.policy783){q.policy783=true;q.kind783=classify783(q.error);delay783(q,q.kind783,now);changed=true}
 }
 return changed;
}
function tally783(){
 if(!registered783)return null;
 let done=0,partial=0,missing=0,running=0,waiting=0,blocked=0,delayed=0;
 for(const [k] of registered783){
  if(complete779(state.lessons[k])){done++;continue}
  if(validLesson(state.lessons[k]))partial++;else missing++;
  const q=pending[k];
  if(q?.state==='running')running++;
  else if(q?.state==='blocked'||q?.state==='paused'||q?.state==='failed')blocked++;
  else if(q?.nextAt>Date.now())delayed++;
  else waiting++;
 }
 return {total:registered783.size,done,partial,missing,running,waiting,blocked,delayed};
}
function wake783(){scanDirty783=true;schedule771(100)}
function reconcile783(now){
 let changed=migrateQueue783(now);
 // Only after a successful authoritative snapshot. Never erase any learning card.
 for(const [k,q] of Object.entries(pending)){
  if(!q||typeof q!=='object'||q.state!=='running'&&(!registered783.has(k)||complete779(state.lessons[k]))){delete pending[k];changed=true}
 }
 let slots=Math.max(0,BATCH783-Object.entries(pending).filter(([k,q])=>registered783.has(k)&&(q.state==='running'||q.state==='pending'&&!(q.nextAt>now))).length);
 // Newly committed days first. No photo decoding, gallery scan or AI request here.
 for(const [k,r] of [...registered783].sort((a,b)=>b[1].updated-a[1].updated||b[0].localeCompare(a[0]))){
  if(slots<=0)break;
  if(pending[k]||complete779(state.lessons[k]))continue;
  pending[k]={day:r.day,id:r.id,note:'',state:'pending',attempt:0,policy783:true,nextAt:0,needsDiscovery:!!seed777(k,'all')};slots--;changed=true;
 }
 if(changed&&!persist771())throw Error('자동 학습 작업 저장 실패');
 stats783=tally783();
}
async function scan783(){
 if(!storageReady771||!studyDB771)throw Error('학습 카드 저장소 확인 필요');
 if(typeof window.MoaStudyCurated783!=='function')throw Error('직접 추가 달력 연결 대기');
 const now=Date.now();
 if(!registered783||scanDirty783||now-scanAt783>=SCAN783){
  const begin=Date.now();scanDirty783=false;
  try{registered783=normalize783(await window.MoaStudyCurated783());scanAt783=Date.now();prefs.lastScanMs783=scanAt783-begin;scopeError783=''}catch(e){scanDirty783=true;registered783=null;throw e}
 }
 reconcile783(now);
}
function progress783(){
 stats783=tally783();const t=stats783;
 if(!prefs.auto)return '자동 생성 꺼짐 · 직접 추가한 달력만 대상';
 if(scopeError783)return '자동 생성 대기 · '+scopeError783;
 if(!t)return '자동 생성 켜짐 · 직접 추가한 달력 확인 중';
 const pct=t.total?Math.floor(t.done*100/t.total):0;
 return '직접 추가 '+t.total+'개 · 완료 '+t.done+' ('+pct+'%) · 미생성 '+t.missing+' · 일부 누락 '+t.partial+' · 처리 중 '+t.running+' · 대기 '+t.waiting+' · 재시도 '+t.delayed+' · 보류 '+t.blocked+
  (prefs.quotaUntil783>Date.now()?' · 사용량 제한 해제 대기':'')+
  (!state.connected?' · 계정 확인 대기':!autoModel781()?' · 자동 모델 확인 필요':'')+
  (Number.isFinite(prefs.lastScanMs783)?' · 목록 확인 '+prefs.lastScanMs783+'ms':'')+
  (prefs.lastJobMs783?' · 최근 AI 처리 '+Math.round(prefs.lastJobMs783/1000)+'초':'');
}
function retryAll783(){
 for(const [k,q] of Object.entries(pending))if(q.state!=='running'&&(q.state==='blocked'||q.state==='paused'||q.state==='failed'||q.nextAt>Date.now())){
  if(q.kind783==='quota'&&prefs.quotaUntil783>Date.now())continue;
  q.state='pending';q.attempt=0;q.nextAt=0;q.kind783='';q.error='';
 }
 sessionBlocked781=false;sessionRetries779=0;state.autoChecking=false;persist771();wake783();
}
function setAuto783(on){
 if(on&&!prefs.auto&&!confirm('직접 추가한 달력의 기존 및 신규 원본 사진·영상 프레임(음성 제외)과 일기 글을 연결된 ChatGPT에 자동 전송해 누락 학습 카드를 채웁니다. 전체 갤러리 및 원격 미디어는 제외하며 언제든 끌 수 있습니다. 켤까요?'))return false;
 prefs.auto=!!on;state.autoChecking=false;sessionBlocked781=false;sessionRetries779=0;
 if(!on&&state.job?.auto&&!state.job.saving){const j=state.job;finishJob(j);if(pending[j.key])pending[j.key].state='pending';command('cancel',{},j.id).catch(()=>{})}
 if(on){for(const q of Object.values(pending))if(q.state==='paused'){q.state='pending';q.nextAt=0;q.attempt=0}}
 persist771();wake783();autoStatus771();sync();return true;
}
function mountAutoSettings783(){
 const settings=document.querySelector('section.page[data-page="settings"]');
 const list=Array.from(settings?.querySelectorAll('.section')||[]).find(s=>s.querySelector('.section-title')?.textContent.trim()==='앱')?.querySelector('.rows');
 if(!list||document.getElementById('moa-r783-auto-study'))return;
 const li=el('li');li.id='moa-r783-auto-study';li.className='moa-r98-settings';
 const d=el('details','','moa-r99-disclosure'),h=el('summary','자동 학습 관리','moa-r99-summary'),body=el('div','','moa-r98-controls');
 const label=el('label','직접 추가한 달력 자동 학습','moa-r98-control'),toggle=el('input'),info=el('p','','moa-r98-hint');
 toggle.type='checkbox';toggle.id='moa-r783-auto-toggle';toggle.checked=!!prefs.auto;label.append(toggle);info.id='moa-r783-auto-info';
 toggle.onchange=()=>{if(!setAuto783(toggle.checked))toggle.checked=!!prefs.auto};
 body.append(label,info,button('보류 작업 다시 확인',()=>retryAll783()));d.append(h,body);li.append(d);list.append(li);
 for(const type of ['click','change','input'])li.addEventListener(type,e=>e.stopPropagation());
 d.addEventListener('toggle',()=>{if(d.open){wake783();autoStatus771()}});
}
function recoverBlocked783(){
 let changed=false;
 for(const q of Object.values(pending))if(q.state==='blocked'&&(q.kind783==='auth'||q.kind783==='model'&&autoModel781()&&autoModel781()!==q.model783)){q.state='pending';q.nextAt=0;q.attempt=0;q.kind783='';changed=true}
 if(changed)persist771();
}
async function pumpScoped783(){
 mountAutoSettings783();autoStatus771();
 if(state.job||!storageReady771)return;
 // Manual receipts keep their exact pre-existing recovery path.
 let active;try{active=JSON.parse(localStorage.getItem(ACTIVE777)||'null')}catch{}
 if(active&&!active.auto&&restore777())return;
 if(!prefs.auto||document.hidden)return;
 try{await scan783();scopeError783=''}catch(e){scopeError783=String(e.message||e);autoStatus771();return}
 if(!prefs.auto||document.hidden||state.job)return;
 drain779();
 if(active?.auto&&registered783.has(active.key)&&restore777())return;
 if(active?.auto&&!registered783.has(active.key)){write777(ACTIVE777,null);command('cancel',{},active.id).catch(()=>{})}
 const now=Date.now();
 if(Number(prefs.quotaUntil783)>now){autoStatus771();return}
 if(!Object.entries(pending).some(([k,q])=>registered783.has(k)&&q.state!=='paused'&&q.state!=='running'))return;
 if(!state.connected){
  if((sessionBlocked781||sessionRetries779>=3)&&now>=Number(prefs.authCheckAfter783||0)){sessionBlocked781=false;sessionRetries779=0}
  if(!state.autoChecking&&!sessionBlocked781&&sessionRetries779<3){state.autoChecking=true;prefs.authCheckAfter783=now+1800000;persist771();request('session')}
  return;
 }
 const model=autoModel781();if(!model){autoStatus771();return}
 recoverBlocked783();
 const ready=Object.entries(pending).filter(([k,q])=>registered783.has(k)&&q.state==='pending'&&!(q.nextAt>now)).sort((a,b)=>registered783.get(b[0]).updated-registered783.get(a[0]).updated||b[0].localeCompare(a[0]));
 if(!ready.length){autoStatus771();return}
 const [k,q]=ready[0];
 // Recheck the one day in the committed store immediately before any upload.
 let fresh;try{fresh=normalize783(await window.MoaStudyCurated783(q.day)).get(k)}catch(e){scopeError783='등록 확인 실패 · '+String(e.message||e);autoStatus771();return}
 if(!fresh){registered783.delete(k);delete pending[k];persist771();wake783();return}
 if(!prefs.auto||document.hidden||state.job||complete779(state.lessons[k]))return;
 if(!state.connected||autoModel781()!==model||Number(prefs.quotaUntil783)>Date.now())return;
 q.state='running';q.attempt=Number(q.attempt||0)+1;q.nextAt=0;
 if(!persist771()){q.state='pending';q.nextAt=Date.now()+3600000;scopeError783='자동 학습 작업 저장 실패';autoStatus771();return}
 const existing=state.lessons[k],body={media:q.id,day:q.day,note:String(q.note||fresh.note||'').slice(0,12000),model,subject:'all',remote:false,place:'',auto:true,autoPlace:!!prefs.autoPlace};
 const seed=seed777(k,'all');if(seed){body.seed777=seed;body.missing781=missing781(existing)}
 request('generate',body);autoStatus771();
}
"""
rep("function complete779(x)",helper+"\nfunction complete779(x)")
fn("migrate779","function migrate779(){/* Deferred until canonical scope is available. */}")
fn("queue771","function queue771(day,id,note=''){if(prefs.auto)wake783();return false}")
fn("drain779",r"""function drain779(){if(!registered783||!storageReady771||!prefs.auto)return;let rows;try{rows=JSON.parse(localStorage.getItem(INBOX779)||'{}')}catch{return}if(!rows||typeof rows!=='object'||Array.isArray(rows))return;let changed=false,queueChanged=false;for(const [k,r] of Object.entries(rows)){if(!r||!registered783.has(k)||complete779(state.lessons[k])){delete rows[k];changed=true;continue}const q=pending[k];if(q){if(!q.note&&typeof r.note==='string'&&r.note&&q.state!=='running'){q.note=r.note.slice(0,12000);queueChanged=true}delete rows[k];changed=true}}if(queueChanged&&!persist771())return;if(changed)write777(INBOX779,Object.keys(rows).length?rows:null)}""")
fn("autoStatus771","function autoStatus771(){const msg=progress783(),v=state.view;if(v?.autoInfo)v.autoInfo.textContent=msg;if(v?.autoToggle783)v.autoToggle783.checked=!!prefs.auto;const info=document.getElementById('moa-r783-auto-info'),toggle=document.getElementById('moa-r783-auto-toggle');if(info)info.textContent=msg;if(toggle)toggle.checked=!!prefs.auto}")
fn("pump771","function pump771(){if(pumping783)return;pumping783=true;void pumpScoped783().catch(e=>{scopeError783=String(e.message||e);autoStatus771()}).finally(()=>{pumping783=false})}")
fn("finishAuto771",r"""function finishAuto771(j,ok,message=''){if(j?.op==='generate'&&pending[j.key]){const q=pending[j.key];if(complete779(state.lessons[j.key])){delete pending[j.key];if(j.auto)prefs.lastJobMs783=Math.max(1,Date.now()-j.start);persist771()}else if(j.auto){q.error=String(message||'일부 과목 누락').slice(0,200);q.policy783=true;q.kind783=classify783(q.error);q.model783=j.body?.model||'';delay783(q,q.kind783,Date.now());if(q.kind783==='auth'){state.connected=false;sessionBlocked781=true;prefs.authCheckAfter783=Date.now()+1800000}persist771()}}autoStatus771();schedule771(1200)}""")
# Use the existing card primary storage, but avoid serializing a growing entire mirror for every success.
rep("const next={...state.lessons,[k]:lesson};try{const mirror=JSON.stringify(next);if(!primary||mirror.length<1500000)localStorage.setItem(K,mirror)}catch(e){if(!primary)throw e}state.lessons=next;return true",
"""if(primary){state.lessons[k]=lesson;if(Object.keys(state.lessons).length<=120){try{const mirror=JSON.stringify(state.lessons);if(mirror.length<1500000)localStorage.setItem(K,mirror)}catch{}}return true}const next={...state.lessons,[k]:lesson};localStorage.setItem(K,JSON.stringify(next));state.lessons=next;return true""")
# Keep original manual controls and model choice; use same shared switch in settings.
rep("새로 추가한 사진·영상 7과목 자동 생성","직접 추가한 달력의 누락 학습 자동 생성")
old=s[s.index("auto.onchange=()=>{if(auto.checked&&!confirm("):s.index("const autoMode=el('select')")]
assert "prefs.auto=auto.checked" in old
rep(old,"auto.onchange=()=>{if(!setAuto783(auto.checked))auto.checked=!!prefs.auto};")
rep("v.autoInfo=autoInfo;autoStatus771();","v.autoInfo=autoInfo;v.autoToggle783=auto;autoStatus771();")
old=s[s.index("button('실패 작업 다시 시도',()=>{"):s.index("details.append(row,autoRow")]
assert old.endswith("));")
rep(old,"button('실패 작업 다시 시도',()=>retryAll783()));")
rep("if(state.connected){state.autoChecking=false;sessionBlocked781=false;sessionRetries779=0;schedule771()}else{state.autoChecking=false;sessionBlocked781=true;sessionRetries779=3;autoStatus771()}","if(state.connected){state.autoChecking=false;sessionBlocked781=false;sessionRetries779=0;prefs.authCheckAfter783=0;recoverBlocked783();wake783()}else{state.autoChecking=false;sessionBlocked781=true;sessionRetries779=3;prefs.authCheckAfter783=Date.now()+1800000;persist771();autoStatus771()}")
rep("else{sessionBlocked781=true;sessionRetries779=3}","else{sessionBlocked781=true;sessionRetries779=3;prefs.authCheckAfter783=Date.now()+1800000;persist771()}")
rep("window.addEventListener('moa:study-media-committed',e=>{const d=e.detail||{};if(d.nativeCommit779)drain779();else queue771(d.day,d.id,d.note)})","window.addEventListener('moa:study-media-committed',wake783);window.addEventListener('moa:native-diary-committed',wake783)")
rep("if(!document.hidden){state.autoChecking=false;if(!sessionBlocked781)sessionRetries779=0;schedule771()}","if(!document.hidden){state.autoChecking=false;if(!sessionBlocked781)sessionRetries779=0;wake783()}")
rep("if(!sessionBlocked781){state.autoChecking=false;sessionRetries779=0}schedule771()","if(!sessionBlocked781){state.autoChecking=false;sessionRetries779=0}wake783()")
rep("setInterval(()=>{if(prefs.auto&&!document.hidden&&!state.job)pump771()},15000)","setInterval(()=>{mountAutoSettings783();if(prefs.auto&&!document.hidden&&!state.job)pump771()},15000)")
# Settings mount after UI construction, no mutation loop.
rep("queueNewMedia:queue771};","queueNewMedia:queue771,mountAutoSettings:mountAutoSettings783};")
p.write_text(s)
p=root/'family-diary.js';s=p.read_text()
rep(" const appList=appSection?.querySelector('.rows');"," const appList=appSection?.querySelector('.rows');\n try{w.MoaInline755?.mountAutoSettings?.()}catch(_){}")
p.write_text(s)
print('R783 guarded exact R781 web patch applied')
