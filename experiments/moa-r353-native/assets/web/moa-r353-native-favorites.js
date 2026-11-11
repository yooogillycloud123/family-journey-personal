/* MOA R353 — native moment-record favorites bridge.
   From immutable R345 first-party save engine. No diary-card controls, no custom Naver writer.
   Native popup records the explicit checkbox/list; do not infer opt-in from global defaults.
*/
(()=>{'use strict';
const KEY='moa.r353.native.favorites.jobs.v1';
const MAX=800;
let tasks={};try{tasks=JSON.parse(localStorage.getItem(KEY)||'{}')||{}}catch(_){tasks={}}
function persist(){const rows=Object.entries(tasks);if(rows.length>MAX){rows.sort((a,b)=>(a[1].updated||0)-(b[1].updated||0));tasks=Object.fromEntries(rows.slice(-MAX));}try{localStorage.setItem(KEY,JSON.stringify(tasks))}catch(_){}}
function put(id,change){tasks[id]={...(tasks[id]||{}),...change,updated:Date.now()};persist();return tasks[id]}
function prefs(){return window.MoaR349Prefs||{naverFolder:'내 장소',naverMode:'offscreen'}}
const norm=v=>{const x=String(v||'');return /^\d{1,18}\|v$/.test(x)?'v'+x.slice(0,-2):x};
function candidate(photoId){const F=window.FamilyJourneyNaver;if(typeof F?.candidates!=='function')return null;let rows=[];
 try{rows=F.candidates().filter(p=>Array.isArray(p.photoIds)&&p.photoIds.some(v=>norm(v)===norm(photoId)))}catch(_){}
 return rows.length===1?rows[0]:null;
}
function chosenList(job){const explicit=String(job.list||'').trim();return (explicit||String(prefs().naverFolder||'내 장소').trim()||'내 장소').slice(0,70)}
function perform(id){const job=tasks[id];if(!job||job.status!=='QUEUED')return false;
 const F=window.FamilyJourneyNaver;if(typeof F?.saveFromDiaryGps!=='function'){put(id,{status:'AWAIT_ENGINE'});return false}
 const p=candidate(id);if(!p){put(id,{status:'NEEDS_LOCATION'});return false}
 // Idempotency: one explicit native request timestamp gets at most one browser submit.
 const list=chosenList(job),memo=String(job.memo||'').slice(0,400);
 put(id,{status:'DISPATCHING',effectiveList:list});
 let called=false;
 try{called=F.saveFromDiaryGps(p,'',memo,list,result=>{
   const code=String(result?.state||'UNVERIFIED');
   if(code==='NAVER_READBACK_VERIFIED')put(id,{status:'VERIFIED',code});
   else if(['WEB_SAVE_QUEUED_UNVERIFIED','SAVE_SUBMITTED_UNVERIFIED','SEARCHING','LIST_READY'].includes(code))put(id,{status:'SUBMITTED_UNVERIFIED',code});
   else if(/(?:LOGIN|NEEDS|FAILED|UNAVAILABLE|AMBIGUOUS|NO_FRAME|UI_CHANGED|NOT_READY|NOT_STARTED|DUPLICATE)/.test(code))put(id,{status:code,code});
   else put(id,{code});
 },{mode:'web'});}catch(_){put(id,{status:'DISPATCH_ERROR'});return false}
 if(!called){const latest=tasks[id];if(latest&&latest.status==='DISPATCHING')put(id,{status:'DISPATCH_REJECTED'});}
 return called;
}
function nativeCommitted(drafts){for(const d of Array.isArray(drafts)?drafts:[]){
 if(d?.naverQuickFavorite!==true)continue; // checked in ACTUAL Android popup only
 const id=norm(d.id);if(!/^v?\d{1,19}$/.test(id))continue;
 const requestAt=Number(d.naverQuickRequestedAt)||0;
 if(!Number.isSafeInteger(requestAt)||requestAt<1)continue;
 const token=id+':'+requestAt;const prev=tasks[id];
 if(prev&&(prev.token===token||['VERIFIED','SUBMITTED_UNVERIFIED','DISPATCHING'].includes(prev.status)))continue;
 const note=String(d.note||d.voiceAutoTranscript||'').trim().slice(0,400);
 put(id,{token,requestedAt:requestAt,list:String(d.naverQuickList||'').trim().slice(0,70),memo:note,status:'QUEUED',started:Date.now(),source:'NATIVE_MOMENT_RECORD'});
 perform(id);
 }}
function retryPending(){for(const [id,job] of Object.entries(tasks)){
  if(!['AWAIT_ENGINE','NEEDS_LOCATION'].includes(job.status))continue;
  if(Date.now()-(job.started||0)>1800000)continue;
  if(!candidate(id))continue;put(id,{status:'QUEUED'});perform(id);
 }}
function init(){window.addEventListener('moa:r349-native-committed',e=>nativeCommitted(e.detail?.drafts));
 window.addEventListener('focus',()=>setTimeout(retryPending,700));
 document.addEventListener('visibilitychange',()=>{if(!document.hidden)setTimeout(retryPending,800)});
 setInterval(retryPending,7000);
 window.MoaR353NativeFavorites={get:id=>tasks[norm(id)]||null,check:retryPending};
}
if(document.readyState==='loading')document.addEventListener('DOMContentLoaded',init,{once:true});else init();
})();
