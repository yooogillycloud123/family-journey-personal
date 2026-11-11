/* MOA R357: thin opt-in transfer between the ORIGINAL native moment recorder and
 * the ORIGINAL R345 Naver WebView engine. No diary-card UI. No duplicated writer.
 * A native draft is not eligible until exact IndexedDB token/record ACK.
 */
(()=>{'use strict';
const KEY='moa.r357.native.favorite.results.v1';
const jobs=new Map();
function read(){try{return JSON.parse(localStorage.getItem(KEY)||'{}')||{}}catch(_){return {}}}
function save(k,step){try{
 const all=read();all[k]={step,at:Date.now()};const rows=Object.entries(all).sort((a,b)=>b[1].at-a[1].at).slice(0,160);
 localStorage.setItem(KEY,JSON.stringify(Object.fromEntries(rows)));
 document.dispatchEvent(new CustomEvent('moa:r357-favorite-progress',{detail:{id:k,step}}));
 }catch(_){}}
function validRecord(d){return d&&d.naverQuickFavorite===true&&/^(?:v?[0-9]{1,19})$/.test(String(d.id||''));}
function precisePoint(id){
 const st=window.FamilyJourneyDiary?.state;
 if(!st)return null;
 const p=[...(st.photos||[]),...(st.videos||[])].find(x=>String(x.id)===String(id));
 if(!p)return null;
 const lat=Number(p.lat),lon=Number(p.lon);
 if(!Number.isFinite(lat)||!Number.isFinite(lon)||lat<33||lat>39||lon<124||lon>132)return null;
 return {...p,lat,lon,id:String(id)};
}
function folderName(d){
 const explicit=String(d.naverQuickList||'').trim();
 let defaultName='내 장소';
 try{defaultName=String(window.MoaR349Prefs?.naverFolder||localStorage.getItem('fj.naver.targetlist')||'내 장소').trim()||'내 장소'}catch(_){}
 return (explicit||defaultName).slice(0,70);
}
function memoText(d){return String(d.note||d.voiceAutoTranscript||'').trim().slice(0,400);}
function dispatchOne(d){
 const key=String(d.id)+':'+String(d.naverQuickRequestedAt||0);
 const old=read()[key];if(old&&old.step!=='NEEDS_PHOTO_INDEX'&&old.step!=='NEEDS_GPS')return;
 if(jobs.has(key))return;
 const p=precisePoint(d.id);
 if(!p){save(key,'NEEDS_GPS_OR_PHOTO_INDEX');return;}
 const api=window.FamilyJourneyNaver;
 if(!api||typeof api.saveFromDiaryGps!=='function'){save(key,'NAVER_ENGINE_NOT_READY');return;}
 const list=folderName(d),memo=memoText(d);
 jobs.set(key,true);save(key,'DISPATCHED_UNVERIFIED');
 try{
  const started=api.saveFromDiaryGps(p,'',memo,list,ev=>{
   const state=String(ev?.state||'UNKNOWN');
   // Keep first-party readback status, never promote QUEUED/CLICKED to success.
   save(key,state);
   if(['NAVER_READBACK_VERIFIED','READBACK_UNAVAILABLE','PLACE_AMBIGUOUS','NAVER_UI_CHANGED','LIST_NOT_FOUND_NO_CREATE','LIST_DUPLICATE_NAME','LOGIN_REQUIRED','WEB_LOGIN_REQUIRED','WEB_SUBMIT_NOT_STARTED','NEEDS_GPS','ADDRESS_UNAVAILABLE','NEEDS_ADDRESS'].includes(state))jobs.delete(key);
  },{mode:'web'});
  if(started===false){jobs.delete(key);save(key,'ENGINE_DID_NOT_START');}
 }catch(_){jobs.delete(key);save(key,'ENGINE_EXCEPTION');}
}
function onCommitted(drafts,ack){
 const confirmed=new Set((ack?.acked||[]).map(String));
 for(const draft of drafts)if(validRecord(draft)&&confirmed.has(String(draft.id)))dispatchOne(draft);
}
function wrap(){
 const orig=window.__moaNativeSync;
 if(typeof orig!=='function'||orig.__moaR357Wrapped)return false;
 function wrapped(packet){
  const out=orig.apply(this,arguments);
  if(out!=='ACCEPTED')return out;
  let data;try{data=typeof packet==='string'?JSON.parse(packet):packet}catch(_){return out}
  const token=String(data?.token||''), drafts=(data?.drafts||[]).filter(validRecord);
  if(!token||!drafts.length)return out;
  let count=0;
  const poll=()=>{
   const ack=window.__moaNativeAckByToken?.[token];
   if(ack){onCommitted(drafts,ack);return;}
   if(++count<75)setTimeout(poll,200);
  };
  setTimeout(poll,10);
  return out;
 }
 wrapped.__moaR357Wrapped=true;
 window.__moaNativeSync=wrapped;return true;
}
// Use only the existing native IDB-commit path; no second MediaStore observer.
if(!wrap()){
 let attempts=0;const timer=setInterval(()=>{if(wrap()||++attempts>=90)clearInterval(timer)},120);
}
window.MoaR357QuickBridge={readStatus:()=>read(),folderName,precisePoint};
})();
