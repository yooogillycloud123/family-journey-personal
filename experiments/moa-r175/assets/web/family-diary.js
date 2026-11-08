/* FamilyJourney R23: owner's original date diary + curated photo diary.
 * Preserves R22 IndexedDB 'entries' and MediaStore photo-index; no copied assets.
 * Time and photo ID metadata remain on device; only explicit sharing leaves device.
 */
(function(w){'use strict';
const $=s=>document.querySelector(s), pad=n=>String(n).padStart(2,'0');
const dateOf=t=>{const d=new Date(Number(t));return Number.isFinite(d.getTime())?`${d.getFullYear()}-${pad(d.getMonth()+1)}-${pad(d.getDate())}`:''};
const timeOf=t=>{const d=new Date(Number(t));return `${pad(d.getHours())}:${pad(d.getMinutes())}`};
const isVideo=p=>!!p&&(!!p.video||String(p.id).startsWith('v'));
const counts=a=>{const n=a.filter(p=>!isVideo(p)).length,v=a.length-n;return `${n}장${v?' · 영상 '+v+'개':''}`};
const durationText=ms=>{let n=Math.floor(Math.max(0,Number(ms)||0)/1000);return `${pad(Math.floor(n/60))}:${pad(n%60)}`};
const readable=d=>{const x=new Date(d+'T12:00:00');return x.toLocaleDateString('ko-KR',{year:'numeric',month:'long',day:'numeric',weekday:'long'})};
const elem=(tag,cls,value)=>{const n=document.createElement(tag);if(cls)n.className=cls;if(value!==undefined)n.textContent=String(value);return n};
const button=(label,cb,cls='')=>{const b=elem('button','fd23-btn '+cls,label);b.type='button';if(cb)b.onclick=cb;return b};
const nav=(op,data)=>{try{if(w.NativeHost?.post){w.NativeHost.post(op,JSON.stringify(data||{}));return true}}catch(e){}try{w.webkit.messageHandlers[op].postMessage(data||{});return true}catch(e){return false}};
const DB='familyjourney-diary-v1';let pendingDb=null;
const manuallyCurated=x=>!!x&&(x.selectionMode==='manual'||(x.selectionMode===undefined&&Array.isArray(x.photoIds)&&x.photoIds.length>0));
// R37: keep completed gallery thumbnails visible across camera rescans and app relaunches.
// In-memory LRU is transient; a small, bounded cache of ONLY calendar covers is
// kept in the existing on-device diary IndexedDB (no original photo copies).
// R197: never show a 130px cover as the permanent day tile; request 400px photo previews.
const R38_BIG_THUMB=400;
const R37_RAM_LIMIT=18*1024*1024,R37_COVER_LIMIT=5*1024*1024;
const r37Ram=new Map();let r37RamBytes=0,r37Cover={},r37CoverOrder=[],r37CoverBytes=0,r37SaveTimer=0;
function r37Bytes(v){return v?String(v).length*2:0}
function r37Remember(k,v){if(!v||!v.startsWith('data:image/')||r37Bytes(v)>256*1024)return;
 if(r37Ram.has(k)){r37RamBytes-=r37Bytes(r37Ram.get(k));r37Ram.delete(k)}
 r37Ram.set(k,v);r37RamBytes+=r37Bytes(v);
 while(r37RamBytes>R37_RAM_LIMIT&&r37Ram.size){const old=r37Ram.keys().next().value;r37RamBytes-=r37Bytes(r37Ram.get(old));r37Ram.delete(old)}
}
function r37RememberCover(id,v){if(!v||!v.startsWith('data:image/')||r37Bytes(v)>128*1024)return;
 if(r37Cover[id])r37CoverBytes-=r37Bytes(r37Cover[id]);
 r37Cover[id]=v;r37CoverBytes+=r37Bytes(v);r37CoverOrder=r37CoverOrder.filter(x=>x!==id);r37CoverOrder.push(id);
 while(r37CoverBytes>R37_COVER_LIMIT&&r37CoverOrder.length){const old=r37CoverOrder.shift();r37CoverBytes-=r37Bytes(r37Cover[old]);delete r37Cover[old]}
 clearTimeout(r37SaveTimer);r37SaveTimer=setTimeout(()=>{
   dbPut('meta','thumb-cover-cache-r37',{items:r37Cover,order:r37CoverOrder,version:1}).catch(()=>{});
 },850);
}
function r37Apply(n,v,k){if(!v||!v.startsWith('data:image/'))return false;
 n.alt='';n.onerror=()=>{n.classList.add('fd37-pending');n.removeAttribute('src')};
 n.onload=()=>{n.classList.remove('fd37-pending')};
 n.classList.add('fd37-pending');n.src=v;r37Remember(k,v);
 if(n.complete&&n.naturalWidth>0)n.classList.remove('fd37-pending');return true;
}
// R74: non-persistent last-displayed thumbnail buffer. The old 18MB R37
// LRU may evict visible 250px images and render() destroys DOM image nodes.
// This tiny screen-first cache keeps ONLY data URLs that were actually loaded;
// it is never included in user diary data, backups or gallery index.
const R74_PREVIEW_MAX=14*1024*1024;
const r74Preview=new Map();let r74PreviewBytes=0;
function r74Keep(key,src){
 if(typeof src!=='string'||!src.startsWith('data:image/')||src.length>350000)return;
 const old=r74Preview.get(key);
 if(old){r74PreviewBytes-=r37Bytes(old);r74Preview.delete(key)}
 r74Preview.set(key,src);r74PreviewBytes+=r37Bytes(src);
 while(r74PreviewBytes>R74_PREVIEW_MAX&&r74Preview.size){
  const first=r74Preview.keys().next().value;
  r74PreviewBytes-=r37Bytes(r74Preview.get(first));r74Preview.delete(first);
 }
}
function r74KeepVisible(){
 if(!S.root)return;
 for(const img of S.root.querySelectorAll('img[data-photo-id]')){
  if(!img.complete||img.naturalWidth<=0)continue;
  const id=String(img.dataset.photoId||'');
  if(R73.confirmedMissing.has(id)&&r73Media(id)===null)continue;
  const src=img.getAttribute('src');
  r74Keep((img.dataset.thumbSize||'130')+':'+id,src);
 }
}
function r74DropMissing(){
 for(const id of R73.confirmedMissing){
  if(r73Media(id)!==null)continue;
  for(const key of [...r74Preview.keys()])if(key.endsWith(':'+id)){
   r74PreviewBytes-=r37Bytes(r74Preview.get(key));r74Preview.delete(key);
  }
 }
}
function r37Snapshot(){if(!S.root)return;
 for(const n of S.root.querySelectorAll('img[data-photo-id]')){
  const id=n.dataset.photoId,src=n.getAttribute('src');
  if(src&&src.startsWith('data:image/'))r37Remember((n.dataset.thumbSize||'130')+':'+id,src);
 }
}
function r37IndexIdentical(a,b){if(a.length!==b.length)return false;
 for(let i=0;i<a.length;i++){if(String(a[i].id)!==String(b[i].id)||+a[i].t!==+b[i].t||(Number(a[i].duration)||0)!==(Number(b[i].duration)||0))return false}
 return true;
}

function database(){if(pendingDb)return pendingDb;
 pendingDb=new Promise((yes,no)=>{const r=indexedDB.open(DB,2);
  r.onupgradeneeded=()=>{
   const d=r.result,tx=r.transaction;
   const auto=d.objectStoreNames.contains('entries')?tx.objectStore('entries'):d.createObjectStore('entries',{keyPath:'day'});
   if(!d.objectStoreNames.contains('meta'))d.createObjectStore('meta');
   const curated=d.objectStoreNames.contains('curated')?tx.objectStore('curated'):d.createObjectStore('curated',{keyPath:'day'});
   // Copy R23 selected-photo diaries without losing a single old record.
   // Explicit R23 manual entries move to the curated-only store; R22 legacy
   // photoIds are COPIED, not deleted, because their origin is ambiguous.
   auto.openCursor().onsuccess=e=>{
    const cursor=e.target.result;if(!cursor)return;
    const record=cursor.value;
    if(manuallyCurated(record)){
      curated.put({...record,selectionMode:'manual',migratedFrom:'R23'});
      if(record.selectionMode==='manual')cursor.delete();
    }
    cursor.continue();
   };
  };
  r.onsuccess=()=>yes(r.result);r.onerror=()=>{pendingDb=null;no(r.error)};
  r.onblocked=()=>{pendingDb=null;no(new Error('다른 일기 창에서 데이터베이스를 사용 중입니다.'))};
 });return pendingDb;
}
async function dbGet(table,key){const db=await database();return new Promise((yes,no)=>{const r=db.transaction(table,'readonly').objectStore(table).get(key);r.onsuccess=()=>yes(r.result||null);r.onerror=()=>no(r.error)})}
async function dbAll(table='entries'){const db=await database();return new Promise((yes,no)=>{const r=db.transaction(table,'readonly').objectStore(table).getAll();r.onsuccess=()=>yes(r.result||[]);r.onerror=()=>no(r.error)})}
async function dbPut(table,key,item){const db=await database();return new Promise((yes,no)=>{const tx=db.transaction(table,'readwrite'),s=tx.objectStore(table);if(table==='entries'||table==='curated')s.put(item);else s.put(item,key);tx.oncomplete=yes;tx.onerror=()=>no(tx.error)})}
async function dbDelete(table,day){const db=await database();return new Promise((yes,no)=>{const tx=db.transaction(table,'readwrite');tx.objectStore(table).delete(day);tx.oncomplete=yes;tx.onerror=()=>no(tx.error)})}
function sortedByDate(list){const map=new Map();for(const p of list){if(!p||!/^[0-9]{1,19}$/.test(String(p.id))||!Number.isFinite(+p.t))continue;const day=dateOf(+p.t);if(!day)continue;const set=map.get(day)||[];set.push({id:String(p.id),t:+p.t,approx:!!p.approx});map.set(day,set)}for(const set of map.values())set.sort((a,b)=>a.t-b.t);return map}
function sortedVideos(list){const m=new Map();for(const p of list){if(!p||!/^v[0-9]{1,18}$/.test(String(p.id))||!Number.isFinite(+p.t))continue;const d=dateOf(+p.t),a=m.get(d)||[];a.push({id:String(p.id),t:+p.t,video:true,duration:Number(p.duration)||0,approx:!!p.approx});m.set(d,a)}for(const a of m.values())a.sort((x,y)=>x.t-y.t);return m}
const FIVE_MIN_MS=5*60*1000;
// R193: presentation-only grouping, leaves original timestamp, native voice IDs,
// IndexedDB activity keys and capture-related photoIds untouched.
const R193_BUCKET_KEY='moa.diary.group.minutes.v1';
const R193_PHOTO_SIZE_KEY='moa.diary.photo.columns.v1';
const R193_BUCKET_CHOICES=[5,10,15,20,30,45,60,90,120,180,240,360,480,720,1440];
const R195_STICKY_HEADER_KEY='moa.diary.day.header.sticky.v1';
function r193GroupMinutes(){
 try{const raw=localStorage.getItem(R193_BUCKET_KEY),n=Number(raw);
  return raw!==null&&Number.isInteger(n)&&n>=5&&n<=1440&&n%5===0?n:60;
 }catch(e){return 60}
}
function r195StickyHeader(){try{return localStorage.getItem(R195_STICKY_HEADER_KEY)!=='off'}catch(e){return true}}
function r193PhotoColumns(){try{const n=Number(localStorage.getItem(R193_PHOTO_SIZE_KEY));return [1,2,3].includes(n)?n:2}catch(e){return 2}}
function segments(list,minutes=r193GroupMinutes()){
 const all=[...list].sort((a,b)=>a.t-b.t),result=[];
 const bucket=Math.max(5,Number(minutes)||5)*60*1000;
 for(const p of all){
  const offset=new Date(Number(p.t)).getTimezoneOffset()*60000;
  const slot=Math.floor((Number(p.t)-offset)/bucket);
  let last=result[result.length-1];
  if(!last||last.slot!==slot){const groupStart=slot*bucket+offset;last={start:p.t,end:p.t,photos:[],slot,bucket,groupStart,groupEnd:groupStart+bucket};result.push(last)}
  last.end=p.t;last.photos.push(p);
 }
 return result;
}
const S={root:null,ready:false,open:false,page:'calendar',mode:'curated',date:dateOf(Date.now()),today:dateOf(Date.now()),month:new Date(new Date().getFullYear(),new Date().getMonth(),1),pickerMonth:new Date(new Date().getFullYear(),new Date().getMonth(),1),pickerPage:0,selection:new Set(),manual:false,editing:false,entries:new Map(),curatedEntries:new Map(),photos:[],videos:[],byDay:new Map(),byVideoDay:new Map(),byId:new Map(),cached:false,load:false,req:0,buffer:[],photoViewer:false,dirty:false,editorSnapshot:null,covers:{curated:{},automatic:{}}};
// R73: selected-photo instant timeline from ALREADY COMMITTED curated records.
// This is a presentation-only layer. Never write these provisional media rows
// to the photo-index cache, or silently erase a diary when a gallery photo
// was deleted externally. Background FULL MediaStore scan is still mandatory.
const R73={fast:new Map(),confirmedMissing:new Set(),scanStarted:0,lastVerified:0,openedAt:0,firstCuratedMs:null,lastFullScanMs:null};
function r73HydrateSelected(){
 const fast=new Map();
 for(const entry of S.curatedEntries.values()){
  if(!entry||!Array.isArray(entry.photoIds)||!Array.isArray(entry.moments))continue;
  const allowed=new Set(entry.photoIds.map(String));
  const excluded=new Set((entry.removedMediaIds||[]).map(String));
  for(const m of entry.moments){
   const when=Number(m?.at);
   if(!Number.isFinite(when)||when<946684800000||when>Date.now()+86400000)continue;
   if(dateOf(when)!==entry.day)continue;
   for(const sourceId of (m.photoIds||[])){
    const id=String(sourceId);
    if(!/^(?:[0-9]{1,19}|v[0-9]{1,18})$/.test(id)||!allowed.has(id)||excluded.has(id))continue;
    if(!fast.has(id))fast.set(id,{id,t:when,video:id[0]==='v',approx:false,r73Provisional:true});
   }
  }
 }
 R73.fast=fast;
}
function r73Media(id){
 id=String(id);
 const live=S.byId.get(id);if(live)return live;
 if(R73.confirmedMissing.has(id)){const pending=R73.fast.get(id);return pending&&pending.t>=R73.lastVerified-15000?pending:null;}
 return R73.fast.get(id)||null;
}
function r73ReconcileFullIndex(){
 // Only a successfully completed native full-library response can disprove
 // provisional ID presence. Newly captured rows may be pending during a scan;
 // require an older-than-scan timestamp with a safety margin before hiding.
 const cutoff=R73.scanStarted-15000;
 for(const [id,p] of R73.fast){
  if(S.byId.has(id))R73.confirmedMissing.delete(id);
  else if(p.t<cutoff)R73.confirmedMissing.add(id);
 }
 R73.lastVerified=Date.now();
 R73.lastFullScanMs=R73.lastVerified-R73.scanStarted;
}
function status(msg,err){const n=$('#fd23-status');if(n){n.textContent=msg;n.classList.toggle('error',!!err)}}
function metaStatus(){return `사진 ${S.photos.length.toLocaleString('ko-KR')}장 · 영상 ${S.videos.length.toLocaleString('ko-KR')}개 · 자동 일기 ${S.entries.size}일 · 선택 일기 ${S.curatedEntries.size}일 · 원본 기기에 보관`}

// R41: OPPORTUNISTIC Samsung-camera capture companion. The WebView cannot
// observe MediaStore while backgrounded: it reconciles on return to MOA.
// Never present this mode as a real-time overlay in Samsung Camera.
const MM_KEY='moa.moment.v1', MM_HISTORY_KEY='moa.moment.seen.v1';
// R58 native-integrated release. The older R42 foreground camera-return
// popup is a second competing UI: the user already records a memo in native.
// Keep its underlying code intact for rollback, but never run it in R58.
const MOA_R58_SINGLE_NATIVE_CAPTURE=true;
function mmNativeBridge(){try{
 const n=w.MoaMomentNative;
 return n&&typeof n.enabled==='function'&&typeof n.setEnabled==='function'?n:null;
}catch(e){return null}}
function mmNativeRunning(){try{return !!mmNativeBridge()?.enabled()}catch(e){return false}}

let mmEnabled=false,mmArmedAt=0,mmSeen=new Set(),mmQueue=[],mmBusy=false,mmTimer=0,mmRefreshTimer=0,mmPendingPopup=null,mmInitialized=false,mmLastScan=0;
try{
 const mode=JSON.parse(localStorage.getItem(MM_KEY)||'{}');
 mmEnabled=mode.enabled===true;mmArmedAt=Number(mode.armedAt)||0;
 const saved=JSON.parse(localStorage.getItem(MM_HISTORY_KEY)||'[]');
 mmSeen=new Set(Array.isArray(saved)?saved.map(String):[]);
}catch(e){mmEnabled=false}
// In integrated R58, the legacy foreground flag must never create a second
// memo UI. Actual native service enabled state comes from its JS bridge.
if(MOA_R58_SINGLE_NATIVE_CAPTURE){mmEnabled=false;mmQueue=[];mmPendingPopup=null}
function mmPersist(){try{
 localStorage.setItem(MM_KEY,JSON.stringify({enabled:mmEnabled,armedAt:mmArmedAt}));
 // bounded; stable across restarts and no user images or diary text in localStorage
 const ids=[...mmSeen];if(ids.length>10000)mmSeen=new Set(ids.slice(-9500));
 localStorage.setItem(MM_HISTORY_KEY,JSON.stringify([...mmSeen]));
}catch(e){}}
function mmToggle(){
 if(MOA_R58_SINGLE_NATIVE_CAPTURE){
  // UI ON/OFF now controls the actual Android foreground camera watcher.
  // It no longer toggles the separate R42 foreground/on-return observer.
  const native=mmNativeBridge();
  if(!native){
   // The camera watcher can still be active while the WebView bridge has not
   // loaded: R58 incorrectly labelled this state as OFF and blocked the user.
   // A separate R59 native InboxSync now persists notes without this bridge.
   const info=document.querySelector('.fd41-toolbar p');
   if(info)info.textContent='빠른 설정 [모아 기록] 타일에서 켜거나 끌 수 있습니다. 브리지 확인 중에도 촬영 메모는 보존되며 모아에서 동기화됩니다.';
   return;
  }
  try{
   const desired=!mmNativeRunning();
   native.setEnabled(desired);
   mmEnabled=false;mmQueue=[];mmPersist();
   document.getElementById('fd41-modal')?.remove();mmPendingPopup=null;
   if(S.open){render();setTimeout(()=>{if(S.open)render()},700);setTimeout(()=>{if(S.open)render()},1900)}
  }catch(e){alert('모아 네이티브 감시 변경 실패: '+String(e))}
  return;
 }
 mmEnabled=!mmEnabled;
 if(mmEnabled){
  mmArmedAt=Date.now();mmSeen=new Set([...S.photos,...S.videos].map(p=>String(p.id)));
  mmQueue=[];mmPersist();
  if(!S.load)loadIndex(false);
 }else{clearTimeout(mmTimer);mmQueue=[];mmPersist()}
 if(S.open)render();
}
function mmButton(){
 const available=MOA_R58_SINGLE_NATIVE_CAPTURE?!!mmNativeBridge():true;
 const running=available?(MOA_R58_SINGLE_NATIVE_CAPTURE?mmNativeRunning():mmEnabled):false;
 const label=!available?'촬영 감시 · 빠른 설정에서 확인':running?'촬영 즉시 기록 ON · 끄기':'촬영 즉시 기록 OFF · 켜기';
 const b=button(label,mmToggle,'fd41-switch'+(running?' fd41-on':''));
 b.setAttribute('aria-pressed',available?String(running):'mixed');
 return b;
}
function mmToolbar(){
 const bar=elem('section','fd41-toolbar');
 bar.append(mmButton());
 bar.append(elem('p','',MOA_R58_SINGLE_NATIVE_CAPTURE?
  (!mmNativeBridge()?'모아가 네이티브 감시 상태를 확인하는 중입니다. 빠른 설정 [모아 기록] 타일에서 ON/OFF를 확인하세요. 촬영 직후 메모는 임시 보존되고 모아를 열 때 일기로 동기화됩니다.':
   mmNativeRunning()?'삼성 카메라 [바로 기록]으로 메모를 한 번 저장하세요. 모아를 열면 중복 팝업 없이 일기에 반영합니다.':'촬영 감시는 꺼져 있습니다. 이 버튼 또는 빠른 설정 [모아 기록]으로 켜 주세요.'):
  (mmEnabled?'삼성 카메라로 사진·영상 촬영 후 모아로 돌아오면 해당 시간대의 사진·영상에 메모를 연결해요.':'필요할 때만 켜세요. 꺼져 있을 때는 새 사진을 기록하지 않아요.')));
 const pending=[...S.curatedEntries.values()].flatMap(e=>(e.moments||[]).filter(m=>!m.note).map(m=>({day:e.day,m}))).sort((a,b)=>b.m.at-a.m.at);
 // Old empty R42 moments remain accessible through day editing; never
 // auto-launch the R42 memo writer in the native-only R58 workflow.
 if(pending.length&&!MOA_R58_SINGLE_NATIVE_CAPTURE){bar.append(button(`기록 대기 ${pending.length}건`,()=>mmOpenPending(pending[0]),'fd41-pending'))}
 if(MOA_R58_SINGLE_NATIVE_CAPTURE){
  const proof=w.__moaR60LastDelivery;
  const syncStatus=w.__moaNativeSyncStatus;
  const extra=elem('p','fd60-sync-status');extra.id='fd60-sync-status';
  extra.textContent=proof?.state==='INDEXEDDB_COMMITTED'?
    `최근 기록 ${proof.acked}건 일기 저장 확인 · 촬영 시간대에 연결됨`:
    proof?.state==='FAILED'?
      `최근 기록 ${proof.count}건 중 ${proof.failed?.length||0}건 저장 확인 실패 · 초안 보존`:
      proof?.state==='RECEIVED'||proof?.state==='VALIDATING'?'사진 메모 수신 · 일기 저장 확인 중':
      syncStatus?.state==='COMMITTED'?'최근 기록 일기 저장 확인됨':
      !mmNativeBridge()?'네이티브 연결 상태 미확인 · 저장 확인이 필요합니다.':'촬영한 메모는 모아 일기 저장 확인 후 표시됩니다.';
  bar.append(extra);
  bar.append(button('저장 상태 확인',()=>{
    const last=w.__moaR60LastDelivery;
    const status=w.__moaNativeSyncStatus;
    alert('모아 R61 저장 진단\n'+
      'Native bridge: '+(mmNativeBridge()?'CONNECTED':'NOT EXPOSED')+'\n'+
      'Java inbox last packet: '+JSON.stringify(last||null)+'\n'+
      'Web native polling: '+JSON.stringify(status||null)+'\n'+
      '사진 색인: '+S.photos.length+'장, 영상 '+S.videos.length+'개\n'+
      '사진 색인 읽는 중: '+S.load+'\n'+
      '선택 일기: '+S.curatedEntries.size+'일');
  },'fd60-health-check'));
 }

 return bar;
}
function mmOpenPending(item){if(!item||MOA_R58_SINGLE_NATIVE_CAPTURE)return;mmShowEditor(item.day,item.m.uid)}
function mmNativeCoveredIds(){
 // Synchronously consult the real native inbox BEFORE R42's on-return prompt.
 // This check only suppresses duplicate prompts for photos already captured by
 // the native service. The R42 fallback is fully retained otherwise.
 try{
  const api=w.MoaMomentNative;
  if(!api||typeof api.drafts!=='function')return new Set();
  const items=JSON.parse(api.drafts()||'[]');
  return new Set(Array.isArray(items)?items.map(x=>String(x?.id||'')).filter(x=>/^(?:v[0-9]{1,18}|[0-9]{1,19})$/.test(x)):[]);
 }catch(e){return new Set();}
}
function mmCandidates(next){
 if(MOA_R58_SINGLE_NATIVE_CAPTURE)return []; // NEVER enqueue a second memo
 if(!mmEnabled||!mmArmedAt)return [];
 const nativeCovered=mmNativeCoveredIds();
 if(nativeCovered.size){
  for(const id of nativeCovered)mmSeen.add(id);
  mmQueue=mmQueue.filter(x=>!nativeCovered.has(String(x.id)));
  mmPersist();
  // Native UI already handled these photos; don't open R42's duplicate prompt.
  if(mmPendingPopup){
   const p=mmPendingPopup;
   const m=(S.curatedEntries.get(p.day)?.moments||[]).find(x=>x.uid===p.uid);
   if(m&&(m.photoIds||[]).some(id=>nativeCovered.has(String(id)))){
    document.getElementById('fd41-modal')?.remove();mmPendingPopup=null;
   }
  }
 }
 const hidden=new Set((S.curatedEntries.get(dateOf(Date.now()))?.removedMediaIds||[]).map(String));
 const now=Date.now();
 return next.filter(p=>p&&(/^(?:v\d{1,18}|\d{1,19})$/.test(String(p.id)))&&!mmSeen.has(String(p.id))&&!nativeCovered.has(String(p.id))&&!hidden.has(String(p.id))&&Number.isFinite(+p.t)&&+p.t>=mmArmedAt-2500&&+p.t<=now+60000);
}
async function mmHandleIndex(photos){
 if(!mmEnabled||!photos.length)return;
 const candidates=mmCandidates(photos);
 if(!candidates.length)return;
 // photoId is stable MediaStore ID. The diary database is checked again when saved.
 for(const p of candidates){
  if(mmQueue.some(q=>String(q.id)===String(p.id)))continue;
  mmQueue.push({id:String(p.id),t:+p.t});
 }
 clearTimeout(mmTimer);mmTimer=setTimeout(mmFlush,1250);
}
async function mmFlush(){
 if(MOA_R58_SINGLE_NATIVE_CAPTURE){mmQueue=[];return}
 if(mmBusy||!mmQueue.length||!mmEnabled)return;
 mmBusy=true;const batch=mmQueue.splice(0);
 const grouped=new Map();
 for(const p of batch){const day=dateOf(p.t);if(!day)continue;
  if(!grouped.has(day))grouped.set(day,[]);grouped.get(day).push(p);
 }
 try{
 for(const [day,photos] of grouped){
  const existing=await dbGet('curated',day)||{day,photoIds:[],selectionMode:'manual',title:'',body:'',tags:[],feeling:'',activities:{},source:'moment-capture'};
  const ids=new Set((existing.photoIds||[]).map(String));
  const appended=[];
  const excluded=new Set((existing.removedMediaIds||[]).map(String));
  for(const p of photos){if(!ids.has(p.id)&&!excluded.has(p.id)){ids.add(p.id);appended.push(p)}}
  if(!appended.length){for(const p of photos)mmSeen.add(p.id);continue}
  const moments=Array.isArray(existing.moments)?existing.moments.map(m=>({...m,photoIds:[...(m.photoIds||[])]})):[];
  // One memory entry for bursts within 30 seconds; avoid 5 popups for 5 shots.
  const first=appended[0];const last=moments[moments.length-1];
  if(last&&!last.note&&Math.abs(first.t-last.at)<=30000){
   last.photoIds=[...new Set([...(last.photoIds||[]),...appended.map(x=>x.id)])];
  }else moments.push({uid:'m'+Date.now()+'_'+first.id,at:first.t,photoIds:appended.map(x=>x.id),note:'',createdAt:Date.now()});
  const entry={...existing,day,photoIds:[...ids],moments,selectionMode:'manual',updatedAt:Date.now()};
  await dbPut('curated',day,entry); // persist before saying 'added'
  S.curatedEntries.set(day,entry);
  for(const p of photos)mmSeen.add(p.id);
  mmPersist();
  if(document.visibilityState==='visible'&&day===dateOf(Date.now()))mmPrompt(day,moments[moments.length-1]);
 }
 if(S.open&&!S.editing)render();
 }catch(e){mmQueue.unshift(...batch.filter(p=>!mmSeen.has(p.id)));if(S.open)status('순간 기록 저장 실패 · 다음에 다시 시도: '+String(e),true)}
 finally{mmBusy=false; if(mmQueue.length&&mmEnabled){clearTimeout(mmTimer);mmTimer=setTimeout(mmFlush,4000)}}
}
function mmPrompt(day,m){
 if(MOA_R58_SINGLE_NATIVE_CAPTURE)return;
 // A native overlay already collected (or is collecting) a memo for this media.
 // Never force the user to write the same thing again in a second WebView popup.
 const nativeIds=mmNativeCoveredIds();
 if((m.photoIds||[]).some(id=>nativeIds.has(String(id))))return;
 if(mmPendingPopup)return;
 mmPendingPopup={day,uid:m.uid};
 mmShowEditor(day,m.uid);
}
function mmShowEditor(day,uid){
 document.getElementById('fd41-modal')?.remove();mmPendingPopup={day,uid};
 const entry=S.curatedEntries.get(day),m=(entry?.moments||[]).find(x=>x.uid===uid);
 if(!m){mmPendingPopup=null;return}
 const shade=elem('div','fd41-shade');shade.id='fd41-modal';
 const card=elem('section','fd41-card');
 const title=elem('h3','','촬영한 사진·영상 '+(m.photoIds||[]).length+'개 · 촬영 기록');
 const stamp=elem('p','fd41-stamp',readable(day)+' '+timeOf(m.at));
 const desc=elem('p','fd41-help','이 글은 해당 사진·영상 아래의 기록에 보관됩니다. 원본 사진과 연결된 음성은 유지됩니다.');
 const input=elem('textarea');input.rows=4;input.maxLength=2000;input.placeholder='예: 아인이가 그네를 타면서 너무 즐거워했어.';input.value=m.note||'';
 const speech=button('🎙 음성으로 말하기',()=>mmVoiceToTextarea(input,speech),'fd42-microphone');
 const buttons=elem('div','fd41-buttons');
 buttons.append(button('저장',async()=>{
   const txt=input.value.trim();
   try{
    const current=await dbGet('curated',day);if(!current)throw new Error('일기 기록 없음');
    const target=(current.moments||[]).find(x=>x.uid===uid);
    if(!target)throw new Error('사진 기록이 변경되었습니다.');
    const groupKey=mmGroupKey(current,target);
    const before=String(target.note||'').trim();
    const activities={...(current.activities||{})};
    const oldLine=before?(timeOf(target.at)+' · '+before):'';
    // Revisions update their own line, never duplicate earlier messages.
    const base=String(activities[groupKey]||'');
    if(oldLine&&base.includes(oldLine))activities[groupKey]=base.replace(oldLine,'').replace(/\n{2,}/g,'\n').trim();
    if(txt)activities[groupKey]=mmAppendActivity(activities[groupKey],target,txt);
    const updated={...current,activities,moments:(current.moments||[]).map(x=>x.uid===uid?{...x,note:txt,activityKey:groupKey,updatedAt:Date.now()}:x),updatedAt:Date.now()};
    await dbPut('curated',day,updated);S.curatedEntries.set(day,updated);
    shade.remove();mmPendingPopup=null;
    if(S.open)render();
   }catch(e){alert('순간 기록 저장 실패: '+e)}
 },'primary'),button('나중에',()=>{shade.remove();mmPendingPopup=null}),button('이 날짜 일기',()=>{
   shade.remove();mmPendingPopup=null;open().then(()=>{S.month=new Date(day+'T12:00:00');S.month.setDate(1);chooseDay(day)})
 }));
 card.append(title,stamp,desc,input,speech,buttons);shade.append(card);document.body.append(shade);
 input.focus();
}
function mmGroupKey(entry,m){
 // A moment belongs to the visible time segment containing its media IDs.
 const all=(entry?.photoIds||[]).map(x=>r73Media(x)).filter(Boolean);
 const groups=segments(all,5);
 const match=groups.find(g=>g.photos.some(p=>(m.photoIds||[]).includes(String(p.id))));
 return match?String(match.start):String(m.at);
}
function mmGroupNotes(entry,g,section){
 const moments=Array.isArray(entry.moments)?entry.moments:[];
 const ids=new Set(g.photos.map(p=>String(p.id)));
 const corresponding=moments.filter(m=>(m.photoIds||[]).some(id=>ids.has(String(id)))).sort((a,b)=>a.at-b.at);
 for(const m of corresponding){
  const id=String(m.uid||''), note=String(m.note||'').trim();
  const already=String((entry.activities||{})[String(g.start)]||'');
  // R41 notes remain visible right here even before the activity schema is migrated.
  if(note&& !already.includes(note)){
   const p=elem('p','fd23-activity fd42-old-note',timeOf(m.at)+' · '+note);section.append(p);
  }
  if(!note){
   const buttonRow=elem('div','fd42-awaiting');
   buttonRow.append(elem('small','','◷ '+timeOf(m.at)+' 촬영 · 아직 기록하지 않음'));
   buttonRow.append(button('이 시간 메모하기',()=>mmShowEditor(entry.day,id),'fd42-note-btn'));
   section.append(buttonRow);
  }
 }
}
function mmAppendActivity(base,m,text){
 // De-duplicate repeated save and preserve existing manual prose.
 const marker=timeOf(m.at)+' · '+text;
 if(!text||String(base||'').includes(marker))return String(base||'');
 const previous=String(base||'').trim();return previous?previous+'\n'+marker:marker;
}
// R78 opt-in speech-to-text for the existing diary fields. One tap, one
// result, never saves or uploads automatically. All original save/delete and
// time grouping are untouched. Existing STT editor can use this same engine.
// R80: one user action and one native SpeechRecognizer. Live provisional text
// replaces previous partials instead of accumulating duplicate paragraphs.
const r78PendingVoice=new Map();let r78VoiceSequence=0;
function r80VisibleSpeech(pending,words,isFinal){
 const input=pending.input;
 if(!input||!input.isConnected||!words)return;
 const speech=String(words).trim();if(!speech)return;
 if(pending.original===undefined){
   pending.original=input.value;
   pending.start=typeof input.selectionStart==='number'?input.selectionStart:input.value.length;
   pending.end=typeof input.selectionEnd==='number'?input.selectionEnd:pending.start;
   pending.lastRendered=input.value;
 }
 // The user might edit manually while dictating; retain their newest text.
 if(input.value!==pending.lastRendered){
   pending.original=input.value;
   pending.start=typeof input.selectionStart==='number'?input.selectionStart:input.value.length;
   pending.end=typeof input.selectionEnd==='number'?input.selectionEnd:pending.start;
 }
 const before=pending.original.slice(0,pending.start),after=pending.original.slice(pending.end);
 const prefix=before&&!/\s$/.test(before)?' ':'';
 const suffix=after&&!/^\s/.test(after)?' ':'';
 const visible=before+prefix+speech+suffix+after;
 input.value=visible;
 pending.lastRendered=visible;
 if(typeof input.setSelectionRange==='function'){
   const cursor=(before+prefix+speech).length;
   input.setSelectionRange(cursor,cursor);
 }
 input.dispatchEvent(new Event('input',{bubbles:true}));
 pending.partial= !isFinal;
 if(isFinal){pending.committed=true;pending.original=undefined;}
}
window.__moaVoiceNativeResult=function(token,payload,phase){
 const pending=r78PendingVoice.get(String(token));if(!pending)return;
 const {input,btn,initial}=pending;
 if(phase==='listening'){
   btn.textContent='⏹ 음성 종료';btn.disabled=false;return;
 }
 if(phase==='permission_wait'){
   btn.textContent='마이크 권한 승인 대기…';btn.disabled=true;return;
 }
 if(phase==='partial'){r80VisibleSpeech(pending,payload,false);return;}
 if(phase==='success'){r80VisibleSpeech(pending,payload,true);return;}
 if(phase==='error'||phase==='permission'){
   alert(String(payload||'음성 인식에 실패했습니다. 다시 시도해 주세요.'));
 }
 if(phase==='finished'||phase==='error'||phase==='permission'){
   btn.textContent=initial;btn.disabled=false;
   r78PendingVoice.delete(String(token));
 }
};
// R81: the live native WebChromeClient sends a short readiness heartbeat.
// Never show WebView's raw window.prompt dialog while the native listener is
// unavailable. Wait for the foreground Android bridge, then dispatch once.
// The successfully tested native memo SpeechRecognizer is not reimplemented.
function r81NativeVoiceInvoke(token,action,success,failure){
 // R149 native fallback: preserve the original Diary editor/callbacks and
 // existing host, but route user speech through the dedicated Android recognizer.
 // Avoid the older 4.5s stalled Chrome heartbeat when the native bridge is ready.
 try{
   const nativeAudio=window.MoaLocalAudio;
   if(nativeAudio&&typeof nativeAudio.speechStart==='function'){
     if(action==='start'){nativeAudio.speechStart(token);success();return;}
     if(action==='end'&&typeof nativeAudio.speechStop==='function'){
       nativeAudio.speechStop(token);success();return;
     }
   }
 }catch(audioErr){failure(audioErr);return;}
 const started=Date.now();
 const run=()=>{
   if(action==='start'&&!r78PendingVoice.has(token))return;
   try{
     const bridge=window.MoaVoiceNative;
     if(bridge&&typeof bridge[action]==='function'){
       bridge[action](token);success();return;
     }
     const heartbeat=Number(window.__moaR81VoiceChromeLiveAt||0);
     if(heartbeat>0&&Date.now()-heartbeat<650){
       const command=action==='start'?'MOA_R79_NATIVE_VOICE':'MOA_R80_NATIVE_VOICE_END';
       const ack=window.prompt(command,token);
       if(ack==='MOA_R79_ACCEPTED'){success();return;}
       throw Error('native prompt handler did not confirm');
     }
   }catch(err){failure(err);return;}
   if(Date.now()-started<4500){setTimeout(run,115);return;}
   failure(Error('R81 foreground native voice bridge never became available'));
 };
 run();
}
function r80VoiceEnd(token){
 r81NativeVoiceInvoke(token,'finish',()=>{},()=>{
   const p=r78PendingVoice.get(token);
   if(p){p.btn.textContent='⏹ 음성 종료';p.btn.disabled=false;}
 });
 return true;
}
function r78VoiceText(input,button){
 for(const [token,pending] of r78PendingVoice.entries()){
   if(pending.btn===button){
     button.textContent='최종 음성 인식 중…';button.disabled=true;
     r80VoiceEnd(token);
     return true;
   }
 }
 for(const [token,pending] of r78PendingVoice.entries()){
   pending.btn.textContent=pending.initial;pending.btn.disabled=false;
   r78PendingVoice.delete(token);
 }
 const token='v'+String(Date.now())+String(++r78VoiceSequence%10000).padStart(4,'0');
 const initial=button.textContent;
 button.textContent='음성 준비 중…';button.disabled=true;
 r78PendingVoice.set(token,{input,btn:button,initial,partial:false,committed:false});
 r81NativeVoiceInvoke(token,'start',()=>{},()=>{
   r78PendingVoice.delete(token);
   button.textContent='음성 연결 실패 · 다시 누르기';button.disabled=false;
   // R82: when Android native binding is missing, surface an actual, single
   // safe diagnostic instead of appearing to listen and silently doing nothing.
   // This never saves or changes the text being edited.
   const diag='R83 '+[
     'H'+(window.__moaR83HostDirect?'1':'0'),
     'V'+((window.MoaVoiceNative&&typeof window.MoaVoiceNative.start==='function')?'1':'0'),
     'C'+((Date.now()-Number(window.__moaR81VoiceChromeLiveAt||0)<1500)?'1':'0'),
     'N'+((window.NativeHost&&typeof window.NativeHost.post==='function')?'1':'0'),
     'M'+((window.MoaMomentNative&&typeof window.MoaMomentNative.enabled==='function')?'1':'0')
   ].join(' ');
   button.title='연결 실패 '+diag+' · 기존 글은 그대로 유지됩니다.';
   alert('모아 음성 인식 네이티브 연결이 시작되지 않았습니다.\n진단: '+diag+'\n작성 중인 글은 보존됩니다.');
 });
 return true;
}
function r78VoiceButton(input,label){
 const btn=elem('button','fd78-voice-field','🎙 음성 입력');btn.type='button';
 btn.setAttribute('aria-label',label+' 음성으로 입력');
 btn.style.cssText='display:inline-flex;align-items:center;justify-content:center;gap:5px;min-height:40px;padding:8px 14px;margin:6px 0 13px;border:1px solid #e5caca;border-radius:11px;background:#fff3ee;color:#9c6274;font-size:14px;font-weight:600';
 btn.addEventListener('click',()=>r78VoiceText(input,btn));
 return btn;
}

// R87: per-field confirmed clear; not a diary/record deletion.
// A late native STT callback for this field must not repopulate emptied text.
function r87ClearText(input,label){
 if(!input||!input.isConnected)return;
 if(!input.value){status('이 입력칸에는 지울 내용이 없습니다.');return;}
 if(!confirm(label+' 입력 내용을 모두 지울까요?\n\n이 입력칸의 글자만 지웁니다. 다른 제목·본문·시간대 메모 및 원본 사진은 유지됩니다. \n일기 저장을 누르기 전에는 저장된 기록도 변경되지 않습니다.'))return;
 for(const [token,pending] of r78PendingVoice.entries()){
   if(pending.input!==input)continue;
   r78PendingVoice.delete(token);
   pending.btn.textContent=pending.initial;
   pending.btn.disabled=false;
   try{if(window.MoaVoiceNative&&typeof window.MoaVoiceNative.cancel==='function')window.MoaVoiceNative.cancel();}catch(e){}
 }
 input.value='';
 input.dispatchEvent(new Event('input',{bubbles:true}));
 try{input.focus({preventScroll:true})}catch(e){input.focus()}
 status(label+' 입력 내용만 지웠습니다. 저장하기 전에는 기존 일기가 유지됩니다.');
}
function r87VoiceAndClear(input,label){
 const row=elem('div','fd87-voice-clear-row');
 row.style.cssText='display:flex;align-items:center;flex-wrap:wrap;gap:8px;margin:5px 0 13px';
 const mic=r78VoiceButton(input,label);mic.style.margin='0';
 const clear=button('내용 전체 지우기',()=>r87ClearText(input,label),'fd87-clear-field');
 clear.setAttribute('aria-label',label+' 입력 내용 전체 지우기 · 확인 후 삭제');
 clear.title='이 입력칸의 글자만 모두 지웁니다. 삭제 확인창이 표시됩니다.';
 clear.style.cssText='display:inline-flex;align-items:center;justify-content:center;min-height:40px;padding:8px 12px;margin:0;border:1px solid #e8d7d3;border-radius:11px;background:#fffaf7;color:#9b5963;font-size:14px;font-weight:600';
 row.append(mic,clear);
 return row;
}

function mmVoiceToTextarea(input,button){
 // R79: native one-shot only; avoid WebView Web Speech permission rejection.
 if(r78VoiceText(input,button))return;
 alert('모아 내장 음성 인식이 준비되지 않았습니다. 입력 내용은 보존됩니다.');
 input.focus();
}
// R60: R59 omitted media-index refresh whenever the R42 web observer was
// disabled. New camera media then NEVER appeared in the current photo diary,
// even after native SharedPreferences memo was written successfully.
let mmR60LastIndexRead=0;
function mmR60RefreshMedia(reason){
 if(document.visibilityState==='hidden')return;
 const now=Date.now();
 if(S.load||now-mmR60LastIndexRead<4500)return;
 mmR60LastIndexRead=now;
 // Keep the cached diary visible while requesting the newest MediaStore rows.
 // Never erase curated moments or re-enable the R42 auto-modal.
 init().then(()=>{if(!S.load)loadIndex(false)}).catch(e=>{
  w.__moaR60LastMediaError={at:Date.now(),reason,error:String(e)};
 });
}
function mmRefreshWhenBack(){
 if(MOA_R58_SINGLE_NATIVE_CAPTURE){
  document.getElementById('fd41-modal')?.remove();mmPendingPopup=null;
  // The native bridge refresh is independent from web R42 fallback toggle.
  if(typeof w.__moaR54RefreshNative==='function')w.__moaR54RefreshNative();
  mmR60RefreshMedia('foreground-return');
  return;
 }
 if(!mmEnabled||document.visibilityState!=='visible')return;
 const now=Date.now();if(now-mmLastScan<4500)return;mmLastScan=now;
 // Existing native operation, no second camera or Accessibility permission.
 init().then(()=>{if(!S.load)loadIndex(false)}).catch(()=>{});
}
function mmInstallLifecycle(){
 if(mmInitialized)return;mmInitialized=true;
 document.addEventListener('visibilitychange',()=>{if(document.visibilityState==='visible')setTimeout(mmRefreshWhenBack,750)});
 w.addEventListener('focus',()=>setTimeout(mmRefreshWhenBack,850));
 w.addEventListener('pageshow',()=>setTimeout(mmRefreshWhenBack,1100));
 // OS can pause a backgrounded WebView; this only runs while MOA is visible.
 setInterval(()=>{if(MOA_R58_SINGLE_NATIVE_CAPTURE){if(S.open&&document.visibilityState==='visible'&&Date.now()-mmR60LastIndexRead>=30000)mmR60RefreshMedia('diary-visible')}else if(mmEnabled&&document.visibilityState==='visible'&&Date.now()-mmLastScan>=30000)mmRefreshWhenBack()},15000);
 if(mmEnabled)setTimeout(mmRefreshWhenBack,2800);
}

// R96: only top/bottom jumps. Unlock middle grip, drag anywhere, tap again
// to pin. The position and lock survive diary reopens and app restarts.
// This layer only manipulates the diary container's scrollTop and its own UI.
const R96_POSITION_KEY='moa.r96.diary-nav-position.v1';
let r96Rail=null,r96Up=null,r96Down=null,r96Grip=null,r96Tick=false,r96Drag=null,r96SuppressClick=false;
let r169Pointer=null,r169HoldTimer=null,r169StopTap=false;
let r175RailContextDisabled=false;
let r96State={locked:true,x:1,y:1};
// R97: R96 behavior preserved; comfort preferences are independent and local-only.
const R97_PREFS_KEY='moa.r97.diary-nav-comfort.v1';
let r97Prefs={autoHide:true,size:1,opacity:.84,edgeSnap:true,enabled:true,hideDelay:3.2};
let r97Collapsed=false,r97Timer=null,r97Panel=null,r97LongTimer=null,r97LongUsed=false;
function r97Read(){
 try{const p=JSON.parse(localStorage.getItem(R97_PREFS_KEY)||'null');if(!p)return;
  if(typeof p.autoHide==='boolean')r97Prefs.autoHide=p.autoHide;
  if(typeof p.edgeSnap==='boolean')r97Prefs.edgeSnap=p.edgeSnap;
  if(typeof p.enabled==='boolean')r97Prefs.enabled=p.enabled;
  if(Number.isFinite(p.hideDelay))r97Prefs.hideDelay=Math.max(1,Math.min(30,p.hideDelay));
  if(Number.isFinite(p.size))r97Prefs.size=Math.max(.8,Math.min(1.3,p.size));
  if(Number.isFinite(p.opacity))r97Prefs.opacity=Math.max(.45,Math.min(1,p.opacity));
 }catch(e){}
}
function r97Save(){try{localStorage.setItem(R97_PREFS_KEY,JSON.stringify(r97Prefs))}catch(e){}}
function r97CancelIdle(){if(r97Timer){clearTimeout(r97Timer);r97Timer=null}}
function r97Collapse(){
 if(!r96Rail||!r97Prefs.autoHide||!r96State.locked||r96Drag||r97Panel?.isConnected||r96Rail.hidden)return;
 r97Collapsed=true;r96Rail.classList.add('r97-collapsed');r96Rail.setAttribute('aria-label','빠른 이동 버튼 펼치기');
 r96Up.disabled=false;r96Down.disabled=false;
 r96Rail.style.opacity=String(r97Prefs.opacity);
 r96RestorePosition();
}
function r97Expand(){
 if(!r96Rail)return;
 r97Collapsed=false;r96Rail.classList.remove('r97-collapsed');
 r96Rail.setAttribute('aria-label','위아래 이동 · 위치 고정');
 r97ApplyStyle();r96Update();r97ScheduleIdle();
}
function r97ScheduleIdle(){
 r97CancelIdle();if(!r97Prefs.autoHide||!r96State.locked||r97Collapsed||r97Panel?.isConnected||r96Rail?.hidden)return;
 r97Timer=setTimeout(r97Collapse,Math.round(r97Prefs.hideDelay*1000));
}
function r97ApplyStyle(){
 if(!r96Rail)return;
 r96Rail.style.setProperty('--r97-scale',String(r97Prefs.size));
 r96Rail.style.opacity=String(r97Prefs.opacity);
 if(!r97Prefs.autoHide&&r97Collapsed)r97Expand();
 if(!r97Prefs.enabled){r97CancelIdle();r97Collapsed=false;r96Rail.classList.remove('r97-collapsed');}
 r96RestorePosition();
 r96Queue();
}
function r97Snap(){
 if(!r96Rail||!r97Prefs.edgeSnap)return;
 const rect=r96Rail.getBoundingClientRect(),bounds=r96Range();
 const mid=rect.left+rect.width/2;
 r96Place(mid<window.innerWidth/2?bounds.left:bounds.right,rect.top,true);
}
function r97ClosePanel(){if(r97Panel){r97Panel.remove();r97Panel=null;}r97ScheduleIdle()}
function r97Settings(){
 r97Expand();r97CancelIdle();if(r97Panel?.isConnected){r97ClosePanel();return;}
 const panel=elem('aside');panel.id='moa-r97-nav-settings';panel.setAttribute('aria-label','빠른 이동 버튼 설정');
 const title=elem('strong','','빠른 이동 버튼 설정');panel.append(title);
 const makeToggle=(name,key)=>{const label=elem('label');const c=document.createElement('input');c.type='checkbox';c.checked=r97Prefs[key];c.onchange=()=>{r97Prefs[key]=c.checked;r97Save();r97ApplyStyle();if(key==='edgeSnap'&&c.checked)r97Snap();};label.append(c,document.createTextNode(' '+name));panel.append(label)};
 const makeRange=(name,key,min,max,step)=>{const label=elem('label','',name);const r=document.createElement('input');r.type='range';r.min=min;r.max=max;r.step=step;r.value=r97Prefs[key];r.setAttribute('aria-label',name);r.oninput=()=>{r97Prefs[key]=Number(r.value);r97Save();r97ApplyStyle()};label.append(r);panel.append(label)};
 makeToggle('자동 숨김','autoHide');
 makeRange('숨김 대기시간 (초)','hideDelay','1','30','.5');
 makeRange('버튼 크기','size','.8','1.3','.05');
 makeRange('버튼 투명도','opacity','.45','1','.05');
 makeToggle('놓으면 가까운 가장자리로 정렬','edgeSnap');
 const row=elem('div','r97-actions');const reset=elem('button','','위치 초기화');reset.type='button';reset.onclick=()=>{r96State.x=1;r96State.y=1;r96Persist();r96RestorePosition();r97ScheduleIdle()};
 const close=elem('button','','닫기');close.type='button';close.onclick=r97ClosePanel;row.append(reset,close);panel.append(row);
 document.body.append(panel);r97Panel=panel;
}

function r96Read(){
 try{
  const stored=JSON.parse(localStorage.getItem(R96_POSITION_KEY)||'null');
  if(!stored||typeof stored!=='object')return;
  r96State.locked=true; // R169: no exposed lock; every rail can be repositioned by long-press.
  if(Number.isFinite(stored.x))r96State.x=Math.max(0,Math.min(1,stored.x));
  if(Number.isFinite(stored.y))r96State.y=Math.max(0,Math.min(1,stored.y));
 }catch(e){} // Private storage may be disabled; in-memory behavior still works.
}
function r96Persist(){
 try{localStorage.setItem(R96_POSITION_KEY,JSON.stringify(r96State));}catch(e){}
}
function r96Range(){
 // Keep the movable overlay clear of Android status/header and the bottom tabs.
 const vw=Math.max(150,window.innerWidth||document.documentElement.clientWidth||360);
 const vh=Math.max(200,window.innerHeight||document.documentElement.clientHeight||700);
 const width=r96Rail?.offsetWidth||46,height=r96Rail?.offsetHeight||112;
 return {left:6,right:Math.max(6,vw-width-6),top:48,bottom:Math.max(48,vh-height-84)};
}
function r96Clamp(v,lo,hi){return Math.max(lo,Math.min(hi,v))}
function r96Place(left,top,save){
 if(!r96Rail)return;
 const b=r96Range();left=r96Clamp(left,b.left,b.right);top=r96Clamp(top,b.top,b.bottom);
 r96Rail.style.right='auto';r96Rail.style.bottom='auto';
 r96Rail.style.left=left+'px';r96Rail.style.top=top+'px';
 if(save){
  r96State.x=b.right>b.left?(left-b.left)/(b.right-b.left):1;
  r96State.y=b.bottom>b.top?(top-b.top)/(b.bottom-b.top):1;
  r96Persist();
 }
}
function r96RestorePosition(){
 if(!r96Rail||r96Drag)return;
 const b=r96Range();
 r96Place(b.left+(b.right-b.left)*r96State.x,b.top+(b.bottom-b.top)*r96State.y,false);
}
function r96KeyboardActive(){
 const a=document.activeElement;
 return !!(a&&S.root&&S.root.contains(a)&&a.matches&&a.matches('input,textarea,[contenteditable="true"]'));
}
function r96Update(){
 if(!r96Rail||!S.root)return;
 const max=Math.max(0,S.root.scrollHeight-S.root.clientHeight);
 const visible=r97Prefs.enabled&&S.open&&!S.root.hidden&&max>80&&!r96KeyboardActive();
 r96Rail.hidden=!visible;
 if(!visible){r97CancelIdle();r97ClosePanel();return;}
 r96RestorePosition();
 if(r97Collapsed)return;
 r97ScheduleIdle();
 const scroll=r96Clamp(S.root.scrollTop,0,max);
 // R177: use aria-disabled, not HTML disabled, so a long press is still received
 // on the upper/lower button at the current scroll boundary.
 r96Up.setAttribute('aria-disabled',scroll<5?'true':'false');
 r96Down.setAttribute('aria-disabled',max-scroll<5?'true':'false');
}
function r96Queue(){
 if(r96Tick)return;
 r96Tick=true;
 const done=()=>{r96Tick=false;r96Update()};
 if(typeof requestAnimationFrame==='function')requestAnimationFrame(done);
 else setTimeout(done,0);
}
function r96Jump(toBottom){
 if(!S.open||!S.root)return;
 const max=Math.max(0,S.root.scrollHeight-S.root.clientHeight);
 // Always instant on thousands of photos, without changing any diary state.
 S.root.scrollTop=toBottom?max:0;
 r96Queue();r97Expand();
}
function r96UpdateGrip(){
 if(!r96Grip||!r96Rail)return;
 const movable=!r96State.locked;
 r96Grip.textContent=movable?'⠿':'🔒';
 const label=movable?'버튼 이동 가능. 가운데를 끌어서 위치 이동, 한 번 누르면 고정':'버튼 고정됨. 누르면 위치 이동 가능';
 r96Grip.setAttribute('aria-label',label);r96Grip.title=label;
 r96Rail.classList.toggle('r96-unlocked',movable);
 if(movable)r97Expand();else r97ScheduleIdle();
}
function r96OnGripDown(e){
 if(e.isPrimary===false)return;
 r97CancelIdle();r97LongUsed=false;
 if(r97LongTimer)clearTimeout(r97LongTimer);
 r97LongTimer=setTimeout(()=>{r97LongUsed=true;r97Settings()},750);
 if(r96State.locked||r96Drag)return;
 const box=r96Rail.getBoundingClientRect();
 r96Drag={id:e.pointerId,x:e.clientX,y:e.clientY,left:box.left,top:box.top,moved:false};
 try{r96Grip.setPointerCapture(e.pointerId)}catch(err){}
}
function r96OnGripMove(e){
 const d=r96Drag;if(!d||e.pointerId!==d.id)return;
 const dx=e.clientX-d.x,dy=e.clientY-d.y;
 if(Math.abs(dx)>4||Math.abs(dy)>4)d.moved=true;
 if(d.moved){if(r97LongTimer){clearTimeout(r97LongTimer);r97LongTimer=null;}r96Place(d.left+dx,d.top+dy,false);e.preventDefault?.();}
}
function r96OnGripEnd(e){
 if(r97LongTimer){clearTimeout(r97LongTimer);r97LongTimer=null;}
 const d=r96Drag;if(!d||e.pointerId!==d.id){r97ScheduleIdle();return;}
 r96Drag=null;
 if(d.moved){
  const rect=r96Rail.getBoundingClientRect();r96Place(rect.left,rect.top,true);r97Snap();
  r96SuppressClick=true;
  setTimeout(()=>{r96SuppressClick=false;},500); // A suppressed synthetic click cannot poison the next real tap.
 }
 try{if(r96Grip.hasPointerCapture(e.pointerId))r96Grip.releasePointerCapture(e.pointerId)}catch(err){}
 r97ScheduleIdle();
}
function r96TogglePin(){
 if(r97LongUsed){r97LongUsed=false;return;}
 if(r96SuppressClick){r96SuppressClick=false;return;}
 r96State.locked=!r96State.locked;
 r96Persist();r96UpdateGrip();if(r96State.locked)r97Snap();
}
// R169: one-handed fast scroll rail; tap for arrows, HOLD anywhere to move.
// The gesture never requires a center lock button. User preferences and
// the existing ~1-second auto-collapse are preserved.
function r169RailDown(e){
 if(e.isPrimary===false||(e.pointerType==='mouse'&&e.button!==0)||r169Pointer)return;
 if(r169HoldTimer)clearTimeout(r169HoldTimer);
 const box=r96Rail.getBoundingClientRect();
 r169Pointer={id:e.pointerId,x:e.clientX,y:e.clientY,left:box.left,top:box.top,active:false,moved:false};
 // The rail and BOTH arrow buttons have touch-action:none.  Do not rely on a
 // disabled child target or a WebView long-click/contextmenu event.
 r169HoldTimer=setTimeout(()=>{
  r169HoldTimer=null;if(!r169Pointer||r169Pointer.id!==e.pointerId)return;
  r169Pointer.active=true;r96Drag=r169Pointer;r97CancelIdle();
  r96Rail.classList.add('r169-dragging');
  try{r96Rail.setPointerCapture(e.pointerId)}catch(_){}
 },330);
}
function r169RailMove(e){
 const d=r169Pointer;if(!d||e.pointerId!==d.id)return;
 if(!d.active){return;} // R175: do not cancel hold for natural fingertip micro-movement.
 const dx=e.clientX-d.x,dy=e.clientY-d.y;
 if(Math.abs(dx)>2||Math.abs(dy)>2)d.moved=true;
 if(d.moved){r96Place(d.left+dx,d.top+dy,false);e.preventDefault?.();}
}
function r169RailUp(e){
 if(r169HoldTimer){clearTimeout(r169HoldTimer);r169HoldTimer=null;}
 const d=r169Pointer;if(!d||e.pointerId!==d.id)return;
 r169Pointer=null;
 if(d.active){
  r96Drag=null;r96Rail.classList.remove('r169-dragging');
  if(d.moved){const bounds=r96Rail.getBoundingClientRect();r96Place(bounds.left,bounds.top,true);}
  r169StopTap=true;
  setTimeout(()=>{r169StopTap=false;},380);
  try{if(r96Rail.hasPointerCapture(e.pointerId))r96Rail.releasePointerCapture(e.pointerId)}catch(_){}
  r97ScheduleIdle();
 }
}
function r96InitNav(){
 if(r96Rail)return;
 if(!document.getElementById('moa-r96-nav-style')){
  const css=elem('style');css.id='moa-r96-nav-style';
  css.textContent=`
#moa-r98-scroll-settings{display:block;padding:0;margin:8px 0 14px;border-radius:16px;background:#f4f8fc;border:1px solid #e5edf4;list-style:none;overflow:hidden}
#moa-r98-scroll-settings .moa-r99-summary{display:flex;align-items:center;gap:12px;min-height:70px;padding:12px 14px;cursor:pointer;list-style:none;touch-action:manipulation;-webkit-tap-highlight-color:transparent}
#moa-r98-scroll-settings .moa-r99-summary::-webkit-details-marker{display:none}
#moa-r98-scroll-settings .moa-r99-heading-text{display:flex;flex:1;min-width:0;flex-direction:column;gap:4px}
#moa-r98-scroll-settings .moa-r99-subtitle{font-size:12px;color:#7d8996}
#moa-r98-scroll-settings .moa-r99-chevron{color:#9aa5b3;font-size:24px;transition:transform .15s}
#moa-r98-scroll-settings details[open] .moa-r99-chevron{transform:rotate(180deg)}
#moa-r98-scroll-settings .moa-r98-controls{padding:0 14px 14px;border-top:1px solid #e5edf4}
#moa-r98-scroll-settings .moa-r98-control{position:relative;z-index:1}
#moa-r98-scroll-settings .moa-r98-control input{pointer-events:auto!important;touch-action:manipulation}
#moa-r98-scroll-settings .moa-r98-range input[type=range]{touch-action:pan-y}
#moa-r98-scroll-settings .moa-r98-heading{display:flex;align-items:center;gap:12px;margin-bottom:10px}
#moa-r98-scroll-settings .moa-r98-icon{display:grid;place-items:center;width:42px;height:42px;border-radius:12px;background:#e5f3f1;color:#078e7c;font:bold 23px system-ui}
#moa-r98-scroll-settings strong{font-size:16px;color:#293543}
#moa-r98-scroll-settings p{margin:3px 0;color:#7d8996;font-size:12px;line-height:1.5}
#moa-r98-scroll-settings .moa-r98-control{display:flex;align-items:center;justify-content:space-between;gap:12px;min-height:48px;border-top:1px solid #e5edf4;color:#344353;font-size:14px}
#moa-r98-scroll-settings .moa-r98-control input[type=checkbox]{width:23px;height:23px;accent-color:#0b927f;flex-shrink:0}
#moa-r98-scroll-settings .moa-r98-range{display:grid;grid-template-columns:1fr auto;gap:4px 12px;padding:9px 0}
#moa-r98-scroll-settings .moa-r98-range input[type=range]{grid-column:1/-1;width:100%;accent-color:#0b927f}
#moa-r98-scroll-settings .moa-r98-range output{font-size:13px;color:#0b927f;font-weight:700}
#moa-r98-scroll-settings input:disabled{opacity:.35}
#moa-r98-scroll-settings .moa-r98-hint{margin:10px 0 0;color:#6b7787}
#moa-r96-rail[hidden]{display:none!important}
#moa-r96-rail{transform:scale(var(--r97-scale,1));transform-origin:center center;transition:opacity .2s ease,transform .2s ease}
#moa-r96-rail.r97-collapsed{width:28px!important;height:45px!important;min-height:45px!important;border-radius:14px!important;overflow:hidden!important;background:#fff!important;cursor:pointer}
#moa-r96-rail.r97-collapsed button{display:none!important}
#moa-r96-rail.r97-collapsed:after{content:'↕';display:grid;place-items:center;color:#a84e69;font:bold 23px/45px system-ui;width:100%;height:45px}
#moa-r97-nav-settings{position:fixed;z-index:2147483600;right:12px;bottom:calc(90px + env(safe-area-inset-bottom));width:min(290px,calc(100vw - 24px));padding:16px;background:#fff;color:#283241;border:1px solid #ead4d9;border-radius:18px;box-shadow:0 8px 30px #17233555;display:flex;flex-direction:column;gap:12px;font:14px/1.45 system-ui}
#moa-r97-nav-settings label{display:flex;justify-content:space-between;align-items:center;gap:12px}
#moa-r97-nav-settings input[type=range]{width:125px;accent-color:#ad526a}
#moa-r97-nav-settings input[type=checkbox]{accent-color:#ad526a}
#moa-r97-nav-settings .r97-actions{display:flex;gap:8px}
#moa-r97-nav-settings button{padding:10px;border:0;border-radius:10px;background:#f5e9ed;color:#813d55;flex:1;font:inherit}

#moa-r96-rail{touch-action:none!important;-webkit-touch-callout:none!important;position:fixed;z-index:30;left:auto;right:8px;top:auto;bottom:calc(84px + env(safe-area-inset-bottom));width:46px;display:flex;flex-direction:column;align-items:center;overflow:hidden;border:1px solid #ead4d9;border-radius:22px;background:rgba(255,255,255,.97);box-shadow:0 3px 16px #26364935;user-select:none;-webkit-user-select:none}
#moa-r96-rail button{display:grid;place-items:center;flex:0 0 auto;width:44px;height:41px;min-height:41px;margin:0;padding:0;border:0;background:transparent;color:#ad526a;font:bold 24px/1 system-ui;cursor:pointer;touch-action:none!important;-webkit-user-select:none;user-select:none}
#moa-r96-rail button[aria-disabled="true"]{color:#bdc3cb;opacity:.5}
#moa-r96-rail .r96-grip{height:29px;min-height:29px;background:#fcf3f4;color:#697887;font-size:17px;touch-action:none;cursor:pointer}
#moa-r96-rail.r96-unlocked{border:1.5px dashed #ac657a;background:#fff9f8}
#moa-r96-rail.r96-unlocked .r96-grip{color:#a24767;cursor:grab}
#moa-r96-rail.r96-unlocked .r96-grip:active{cursor:grabbing}
#moa-r96-rail.r169-dragging{outline:2px solid #b65978;box-shadow:0 4px 22px #751a4777;touch-action:none;cursor:grabbing}
@media (max-width:360px){#moa-r96-rail{width:44px}#moa-r96-rail button{width:42px}}
`;
  document.head.append(css);
 }
 r96Read();r97Read();
 r96Rail=elem('nav');r96Rail.id='moa-r96-rail';r96Rail.hidden=true;
 r96Rail.setAttribute('aria-label','위아래 이동 · 위치 고정');
 r96Up=elem('button','r96-top','↑');r96Up.type='button';r96Up.setAttribute('aria-label','일기 맨 위로 즉시 이동');
 r96Up.onclick=()=>r96Jump(false);
 // R169: the center lock/grip is removed. Hold the whole rail to move.
 r96Down=elem('button','r96-bottom','↓');r96Down.type='button';r96Down.setAttribute('aria-label','일기 맨 아래로 즉시 이동');
 r96Down.onclick=()=>r96Jump(true);
 r96Rail.append(r96Up,r96Down);
 document.body.append(r96Rail);
 r96Rail.addEventListener('click',e=>{
   if(r169StopTap){e.preventDefault();e.stopImmediatePropagation();return;}
   if(r97Collapsed){e.preventDefault();e.stopImmediatePropagation();r97Expand();}
 },true);
 r96Rail.addEventListener('pointerdown',()=>{if(!r97Collapsed)r97CancelIdle()},{passive:true});
 r96Rail.addEventListener('pointerup',()=>{if(!r97Collapsed)r97ScheduleIdle()},{passive:true});
 r96Rail.addEventListener('contextmenu',e=>{e.preventDefault();e.stopPropagation();},true);
 r96Rail.addEventListener('pointerdown',r169RailDown,true);
 r96Rail.addEventListener('pointermove',r169RailMove,true);
 r96Rail.addEventListener('pointerup',r169RailUp,true);
 r96Rail.addEventListener('pointercancel',r169RailUp,true);
 r96State.locked=true;r96Persist();r96UpdateGrip();r97ApplyStyle();
 r96Rail.style.touchAction='none';
 // R177: child buttons must never override the gesture recognizer with pan/zoom.
 r96Up.style.touchAction='none';r96Down.style.touchAction='none';
 S.root.addEventListener('scroll',r96Queue,{passive:true});
 S.root.addEventListener('focusin',r96Queue);
 S.root.addEventListener('focusout',()=>setTimeout(r96Queue,120));
 window.addEventListener('resize',()=>{r96Queue();r97ApplyStyle()},{passive:true});
}
function r98MountAppSettings(){
 const settings=document.querySelector('section.page[data-page="settings"]');
 const appSection=Array.from(settings?.querySelectorAll('.section')||[]).find(s=>s.querySelector('.section-title')?.textContent.trim()==='앱');
 const appList=appSection?.querySelector('.rows');
 if(!appList||document.getElementById('moa-r98-scroll-settings'))return;
 const li=elem('li');li.id='moa-r98-scroll-settings';li.className='moa-r98-settings';
 // Native <details> is intentionally used instead of a simulated clickable row:
 // Android WebView owns open/close and touch/keyboard semantics, no app navigation handler can swallow it.
 const disclosure=elem('details','moa-r99-disclosure');
 const summary=elem('summary','moa-r99-summary');
 summary.innerHTML='<span class="moa-r98-icon" aria-hidden="true">↕</span><span class="moa-r99-heading-text"><strong>화면 빠른 이동 패널</strong><span class="moa-r99-subtitle">위·아래 이동 버튼 설정</span></span><span class="moa-r99-chevron" aria-hidden="true">⌄</span>';
 disclosure.append(summary);
 const controls=elem('div','moa-r98-controls');disclosure.append(controls);li.append(disclosure);
 appList.insertBefore(li,appList.firstChild);
 // Default collapsed on every settings visit; user explicitly requested compact settings.
 // Do not use capture-phase click listeners that overwrite native checkbox/range interactions.
 const inputs=new Map();const outputs=new Map();
 function sync(){
  for(const [key,input] of inputs){
   if(input.type==='checkbox')input.checked=!!r97Prefs[key];else input.value=String(r97Prefs[key]);
  }
  for(const [key,node] of outputs){
   node.textContent=key==='hideDelay'?Number(r97Prefs.hideDelay).toFixed(1)+'초':Math.round(r97Prefs[key]*100)+'%';
  }
  const enabled=!!r97Prefs.enabled;
  inputs.get('autoHide').disabled=!enabled;
  inputs.get('hideDelay').disabled=!enabled||!r97Prefs.autoHide;
  for(const key of ['size','opacity','edgeSnap'])inputs.get(key).disabled=!enabled;
 }
 function commit(key,value){
  r97Prefs[key]=value;
  r97Save();
  r97ApplyStyle();
  if(key==='edgeSnap'&&value&&r96State.locked)r97Snap();
  if(key==='enabled'&&!value)r97CancelIdle();else r97ScheduleIdle();
  sync();
 }
 function addSwitch(label,key){
  const row=elem('label','moa-r98-control');const name=elem('span','',label);
  const input=elem('input');input.type='checkbox';input.dataset.r98Pref=key;
  // Native change is the only source of truth; do not reset checked in a parent click capture.
  input.addEventListener('change',()=>commit(key,input.checked));
  row.append(name,input);controls.append(row);inputs.set(key,input);
 }
 function addRange(label,key,min,max,step){
  const row=elem('label','moa-r98-control moa-r98-range');const title=elem('span','',label);
  const val=elem('output');val.dataset.r98Value=key;
  const input=elem('input');input.type='range';input.min=min;input.max=max;input.step=step;input.dataset.r98Pref=key;input.setAttribute('aria-label',label);
  input.addEventListener('input',()=>commit(key,Number(input.value)));
  input.addEventListener('change',()=>commit(key,Number(input.value)));
  row.append(title,val,input);controls.append(row);inputs.set(key,input);outputs.set(key,val);
 }
 addSwitch('빠른 이동 패널 사용','enabled');
 addSwitch('사용하지 않을 때 자동 숨김','autoHide');
 addRange('자동 숨김 대기시간','hideDelay','1','30','.5');
 addRange('버튼 크기','size','.8','1.3','.05');
 addRange('버튼 투명도','opacity','.45','1','.05');
 addSwitch('가까운 화면 가장자리로 정렬','edgeSnap');
 controls.append(elem('p','moa-r98-hint','일기 화면에서 가운데 🔒 버튼을 눌러 잠금을 풀고 드래그한 뒤 다시 눌러 고정하세요.'));
 // Keep existing app-wide click delegation from interpreting a tap inside this settings card.
 // Do not preventDefault: native summary, labels, checkboxes and sliders must retain click behavior.
 li.addEventListener('click',e=>e.stopPropagation());
 li.addEventListener('change',e=>e.stopPropagation());
 li.addEventListener('input',e=>e.stopPropagation());
 disclosure.addEventListener('toggle',()=>{if(disclosure.open)sync()});
 sync();
}

// R193: Android Back/Escape closes the innermost visible layer, not calendar.
function r193CloseTopLayer(){
 const capture=document.getElementById('fd41-modal');if(capture){
  const cancel=[...capture.querySelectorAll('button')].find(b=>b.textContent.trim()==='나중에');
  if(cancel)cancel.click();else capture.remove();return true;
 }
 if(document.getElementById('moa-r191-day-shade')){
  if(S.root.querySelector('.moa-r193-settings'))r191OpenDaySheet(false);
  else r191CloseDaySheet();return true;
 }
 if(document.getElementById('moa-r149-voice-modal')){
  const editor=document.querySelector('#moa-r149-voice-modal .moa-r155-editor');
  if(editor){editor.querySelector('.moa-r155-cancel')?.click();if(editor.isConnected)editor.remove();return true}
  const openDrawer=[...document.querySelectorAll('#moa-r149-voice-modal .moa-r167-voice-drawer:not([hidden])')].at(-1);
  if(openDrawer){const row=openDrawer.closest('.moa-r167-voice-row');row?.querySelector('.moa-r167-voice-expand')?.click();return true}
  if(w.MoaVoiceDiaryNative?.close?.())return true;
 }
 const openFold=[...S.root?.querySelectorAll?.('.moa-r191-media-tile details[open],.moa-r191-group-note[open],.moa-r193-audio-attach[open]')||[]].at(-1);
 if(openFold){openFold.open=false;return true;}
 return false;
}
function showTab(){const n=$('#tabbar');if(n)for(const b of n.querySelectorAll('button'))b.classList.toggle('active',b.dataset.tab==='diary')}
function mount(){if(S.root)return;S.root=elem('section','fd23-root');S.root.id='fj-diary-root';S.root.hidden=true;S.root.setAttribute('aria-label','가족 사진 일기');document.body.append(S.root);r96InitNav();r98MountAppSettings();
 const bar=$('#tabbar');if(bar&&!bar.querySelector('[data-tab="diary"]')){const b=elem('button');b.dataset.tab='diary';b.type='button';b.innerHTML='<svg viewBox="0 0 24 24" width="24" height="24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="4" width="18" height="17" rx="2"/><path d="M7 2v5M17 2v5M3 10h18M7 14h4M7 17h7"/></svg><span>일기</span>';bar.insertBefore(b,bar.querySelector('[data-tab="settings"]'));b.addEventListener('click',e=>{e.preventDefault();e.stopImmediatePropagation();open()},true);bar.addEventListener('click',e=>{if(!e.target.closest('[data-tab="diary"]')&&S.open)close(false)},true)}
 document.addEventListener('keydown',e=>{
  if(!S.open||!['Escape','Backspace'].includes(e.key)||e.target.closest('input,textarea,[contenteditable]'))return;
  if(r193CloseTopLayer()){e.preventDefault();e.stopImmediatePropagation()}
 },true);
 const prev=w.__fjBackOverlay;
 w.__fjBackOverlay=function(){
  // Native Android Back calls this before offering app exit.
  // Dismiss only the top overlay, never an entire app with an open location sheet.
  if($('#fj-naver-photo-full')||$('#fj-naver-photo-sheet'))return typeof prev==='function'?prev():false;
  const viewer=$('#viewer-root');
  if(viewer&&!viewer.hidden){$('#viewer-close')?.click();return true;}
  const place=$('#place-root');
  if(place&&!place.hidden){$('#place-close')?.click();return true;}
  const map=$('#map-root');
  if(map&&!map.hidden){$('#map-close')?.click();return true;}
  if(r193CloseTopLayer())return true;
  if(S.open){back();return true}
  return typeof prev==='function'?prev():false;
 };
}
async function init(){if(S.ready)return;S.ready=true;try{const [entries,curated,r76Saved]=await Promise.all([dbAll('entries'),dbAll('curated'),dbGet('meta',R76_THUMBS_KEY).catch(()=>null)]);S.entries=new Map(entries.map(x=>[x.day,x]));S.curatedEntries=new Map(curated.map(x=>[x.day,x]));r73HydrateSelected();r76Hydrate(r76Saved);if(S.open&&!S.editing){render();if(R73.firstCuratedMs===null)R73.firstCuratedMs=Date.now()-R73.openedAt;}const savedCovers=await dbGet('meta','calendar-covers-r29');if(savedCovers&&typeof savedCovers==='object')S.covers={curated:savedCovers.curated||{},automatic:savedCovers.automatic||{}};const cached=await dbGet('meta','photo-index');if(cached&&Array.isArray(cached.photos)){S.photos=cached.photos.filter(p=>!isVideo(p));S.videos=Array.isArray(cached.videos)?cached.videos:[];updateIndex();S.cached=cached.mediaIndexVersion===26}
  const thumbCache=await dbGet('meta','thumb-cover-cache-r37');
  if(thumbCache&&thumbCache.version===1&&thumbCache.items){
   for(const id of (thumbCache.order||Object.keys(thumbCache.items))){
    const v=thumbCache.items[id];if(typeof v==='string'&&v.startsWith('data:image/')&&r37Bytes(v)<128*1024){r37Cover[id]=v;r37CoverOrder.push(id);r37CoverBytes+=r37Bytes(v);r37Remember('130:'+id,v)}
   }
  }
 }catch(e){status('일기 저장소 열기 실패: '+e,true)}}
function updateIndex(){S.byDay=sortedByDate(S.photos);S.byVideoDay=sortedVideos(S.videos);S.byId=new Map();for(const p of S.photos)S.byId.set(String(p.id),{id:String(p.id),t:+p.t,approx:!!p.approx});for(const p of S.videos)S.byId.set(String(p.id),{id:String(p.id),t:+p.t,video:true,approx:!!p.approx,duration:+p.duration||0});}
async function refreshCuratedFromDatabase(){if(S.editing)return;try{const list=await dbAll('curated');S.curatedEntries=new Map(list.map(x=>[x.day,x]));r73HydrateSelected();if(S.open&&R73.firstCuratedMs===null)R73.firstCuratedMs=Date.now()-R73.openedAt;}catch(e){status('선택 일기 새 기록 확인 실패 · 다시 열어주세요: '+String(e),true)}} async function open(){mount();R73.openedAt=Date.now();R73.firstCuratedMs=null;S.open=true;S.mode='curated';S.page='calendar';S.editing=false;S.dirty=false;S.root.hidden=false;showTab();render();await init();if(!S.open)return;await refreshCuratedFromDatabase();if(!S.open)return;render();mmR60RefreshMedia('diary-open')}

function close(home){S.open=false;S.editing=false;S.root.hidden=true;r96Update();if(home)try{w.__photoMap?.showTab('home')}catch(e){}}
function back(){if(S.page==='picker'){S.page='day';S.dirty=false;render();return}if(S.page==='day'){if(S.editing&&S.dirty&&!confirm('저장하지 않은 변경사항을 닫을까요?'))return;S.page='calendar';S.editing=false;S.dirty=false;render();return}close(true)}
function chooseMode(m){S.mode=m;S.page='calendar';S.editing=false;S.dirty=false;render()}
function entriesForMode(){return S.mode==='curated'?S.curatedEntries:S.entries}
function chooseDay(day,newEntry=false){
 if(!/^\d{4}-\d{2}-\d{2}$/.test(day))return;
 S.date=day;S.page='day';S.editing=false;S.dirty=false;S.editorSnapshot=null;
 S.manual=S.mode==='curated';
 const entry=entriesForMode().get(day);
 S.selection=new Set(S.manual?(entry?.photoIds||[]).map(String):[]);
 if(newEntry&&!entry){S.manual=true;S.editing=true;}
 render();S.root.scrollTop=0;
}
function newCurated(){const picked=$('#fd23-newdate')?.value||S.today;const a=new Date(picked+'T12:00:00');if(!/^\d{4}-\d{2}-\d{2}$/.test(picked)||!Number.isFinite(a.getTime())||dateOf(a.getTime())!==picked){alert('먼저 일기를 기록할 날짜를 선택해 주세요.');return}S.month=new Date(a.getFullYear(),a.getMonth(),1);chooseDay(picked,true);openPicker()}

// R197: WebView redraws/Android external intents must not collapse the day's
// previously opened media cards, record panels, or visible media batches.
let r197LastDayUI=null;
function r197CaptureDayUI(){
 if(!S.root||S.root.dataset.page!=='day')return null;
 const media={};
 for(const tile of S.root.querySelectorAll('.moa-r191-media-tile[data-moa-media-id]')){
  const id=tile.dataset.moaMediaId;
  media[id]={
   memo:!!tile.querySelector('.moa-r191-memo-fold')?.open,
   tools:!!tile.querySelector('.moa-r191-tools-fold')?.open,
   attach:!!tile.querySelector('.moa-r193-audio-attach')?.open,
   geo:!!tile.querySelector('.fd29-geo-panel:not([hidden])')
  };
 }
 const groups={};
 for(const group of S.root.querySelectorAll('.fd23-log[data-group-start]'))
  groups[group.dataset.groupStart]=group.querySelectorAll('.moa-r191-media-tile').length;
 return {key:(S.root.dataset.moaRenderedMode||S.mode)+'|'+(S.root.dataset.moaRenderedDay||S.date),media,groups,scroll:S.root.scrollTop};
}
function r197RestoreDayUI(snapshot){
 if(!snapshot||S.page!=='day'||snapshot.key!==S.mode+'|'+S.date)return;
 for(const group of S.root.querySelectorAll('.fd23-log[data-group-start]')){
  const need=Math.min(400,Number(snapshot.groups[group.dataset.groupStart])||0);
  let guard=0;
  while(group.querySelectorAll('.moa-r191-media-tile').length<need&&guard++<30){
   const more=group.querySelector('button.fd31-more');if(!more)break;more.click();
  }
 }
 for(const tile of S.root.querySelectorAll('.moa-r191-media-tile[data-moa-media-id]')){
  const keep=snapshot.media[tile.dataset.moaMediaId];if(!keep)continue;
  const memo=tile.querySelector('.moa-r191-memo-fold'),tools=tile.querySelector('.moa-r191-tools-fold');
  if(memo)memo.open=keep.memo;if(tools)tools.open=keep.tools;
  if(keep.geo&&tools){const btn=tools.querySelector('.fd29-position');if(btn)btn.click()}
  const attach=tile.querySelector('.moa-r193-audio-attach');if(attach)attach.open=keep.attach;
 }
 S.root.scrollTop=snapshot.scroll;
}
function render(){if(!S.open||!S.root)return;
 const daySnapshot=S.page==='day'?(r197CaptureDayUI()||r197LastDayUI):null;
 if(daySnapshot)r197LastDayUI=daySnapshot;
 r74KeepVisible();r37Snapshot();const previousScroll=S.root.scrollTop;S.root.replaceChildren();S.root.dataset.page=S.page;const banner=elem('div','fd23-banner',S.load?'사진 날짜 정보 읽는 중…':!S.ready?'일기 자료를 불러오는 중 · 달력은 먼저 표시됩니다':metaStatus());banner.id='fd23-status';S.root.append(banner);
 if(S.page==='calendar'||S.page==='curated'){const h=elem('header','fd23-header');h.append(elem('div','fd23-heading','우리 가족 사진 일기'));S.root.insertBefore(h,banner);
  const switcher=elem('div','fd23-modes');switcher.append(button('내가 고른 사진 일기',()=>chooseMode('curated'),S.mode==='curated'?'active':''),button('자동 사진 달력',()=>chooseMode('automatic'),S.mode==='automatic'?'active':''));S.root.append(switcher);
  renderCalendar();
 }else if(S.page==='day')renderDay();else if(S.page==='picker')renderPicker();
 if(previousScroll>0)S.root.scrollTop=previousScroll;
 if(S.page==='day'&&daySnapshot)r197RestoreDayUI(daySnapshot);
 r96Queue();
}
function renderCalendar(){
 const curated=S.mode==='curated';
 if(curated){const lead=elem('p','fd23-hint','내가 직접 고른 사진과 가족 일기가 메인입니다. 자동 사진 달력은 별도 보조 기능으로 유지돼요.');S.root.append(lead)}
 const row=elem('div','fd23-month');row.append(button('‹',()=>month(-1),'circle'),elem('strong','',`${S.month.getFullYear()}년 ${S.month.getMonth()+1}월`),button('›',()=>month(1),'circle'));S.root.append(row);
 const actions=elem('div','fd23-actions');actions.append(button('오늘',()=>{S.month=new Date(S.today+'T12:00:00');S.month.setDate(1);render()}));if(!curated)actions.append(button('사진 다시 읽기',()=>loadIndex(true)));actions.append(button('일기 백업',exportNotes));S.root.append(actions);
 const grid=elem('div','fd23-calendar');for(const day of ['일','월','화','수','목','금','토'])grid.append(elem('span','fd23-week',day));
 const y=S.month.getFullYear(),m=S.month.getMonth(),start=new Date(y,m,1).getDay(),days=new Date(y,m+1,0).getDate(),count=Math.ceil((start+days)/7)*7;
 for(let i=0;i<count;i++){
  const d=new Date(y,m,i-start+1),day=dateOf(d.getTime()),entry=entriesForMode().get(day),auto=S.byDay.get(day)||[];
  const vids=S.byVideoDay.get(day)||[];const removed=new Set((entry?.removedMediaIds||[]).map(String));
  const ids=(curated?(entry?.photoIds||[]):auto.map(p=>p.id).concat(vids.map(p=>p.id))).filter(id=>!removed.has(String(id)));
  const items=ids.map(id=>curated?r73Media(id):S.byId.get(String(id))).filter(Boolean);
  const cell=elem('button','fd23-cell'+(d.getMonth()!==m?' other':'')+(day===S.today?' today':''));cell.type='button';cell.onclick=()=>chooseDay(day);
  const top=elem('div','fd23-daynum');top.append(elem('strong','',d.getDate()));if(ids.length)top.append(elem('span','',counts(items)));cell.append(top);
  if(items.length){const coverId=String((S.covers[S.mode]||{})[day]||'');const chosenCover=items.find(p=>p.id===coverId)||items[0];const cover=elem('img','fd23-cover');cover.dataset.photoId=String(chosenCover.id);cover.alt='달력 대표 미디어';cell.append(cover);if(isVideo(chosenCover))cell.append(elem('span','fd26-calendar-play','▶'))}else if(ids.length)cell.append(elem('span','fd23-empty',ids.some(id=>R73.confirmedMissing.has(String(id)))?'원본 없음 · 메모 보존':'원본 확인 중'));else cell.append(elem('span','fd23-empty'));
  if(entry)cell.append(elem('span','fd23-note-dot','●'));
  grid.append(cell)
 }
 S.root.append(grid);
 S.root.append(elem('p','fd23-hint',curated?'날짜를 누르면 선택한 사진과 일기를 볼 수 있어요. 빈 날짜도 눌러 새 일기를 만들 수 있어요.':'날짜를 누르면 그날 촬영된 모든 사진을 볼 수 있어요. 직접 선택한 사진 일기는 별도 탭에만 표시돼요.'));
 // R92: calendar first. The existing ON/OFF and status panel stays intact.
 if(curated)S.root.append(mmToolbar());
 if(curated){const pc=elem('section','fd25-pc-import');pc.append(elem('h3','','PC 사진도 우리 가족 일기에'));pc.append(elem('p','','PC에서 휴대폰으로 복사한 사진 여러 장 또는 ZIP 묶음을 앱으로 가져옵니다. EXIF 촬영일을 우선 보존하며 사진 원본은 외부 서버로 전송하지 않아요.'));const start=button('＋ PC 사진·ZIP 가져오기',()=>{if(!nav('diaryImportPc',{}))status('PC 사진 불러오기는 Android APK에서 지원합니다.',true);else status('파일 선택창에서 PC에서 옮긴 사진이나 ZIP을 선택하세요.')},'primary wide');pc.append(start);S.root.append(pc);const actions2=elem('div','fd23-curated-create');const label=elem('label','','일기 날짜');const inp=elem('input');inp.id='fd23-newdate';inp.type='date';inp.value=S.date||S.today;label.append(inp);actions2.append(label,button('＋ 원하는 사진으로 새 일기 만들기',newCurated,'primary wide'));S.root.append(actions2)}
 else S.root.append(button('＋ 내가 고른 사진 일기로 이동',()=>chooseMode('curated'),'primary wide'));
 thumbs(grid.querySelectorAll('img[data-photo-id]'),130);
}
function month(diff){S.month=new Date(S.month.getFullYear(),S.month.getMonth()+diff,1);render()}
function renderCurated(){renderCalendar()}
function visibleDayPhotos(){
  const current=entriesForMode().get(S.date),hidden=new Set((current?.removedMediaIds||[]).map(String));
  if(S.manual)return [...S.selection].filter(id=>!hidden.has(String(id))).map(id=>r73Media(id)).filter(Boolean).sort((a,b)=>a.t-b.t);
  return [...(S.byDay.get(S.date)||[]),...(S.byVideoDay.get(S.date)||[])].filter(p=>!hidden.has(String(p.id))).sort((a,b)=>a.t-b.t);
}
async function setCalendarCover(mediaId){
 const id=String(mediaId),photos=visibleDayPhotos();
 if(!photos.some(p=>p.id===id)){status('이 날짜에 포함된 사진·영상만 대표로 설정할 수 있어요.',true);return;}
 const previous=(S.covers[S.mode]||{})[S.date];
 if(!S.covers[S.mode])S.covers[S.mode]={};
 S.covers[S.mode][S.date]=id;
 try{
  await dbPut('meta','calendar-covers-r29',S.covers);
  for(const b of S.root.querySelectorAll('[data-cover-id]')){
   const on=b.dataset.coverId===id;b.textContent=on?'✓ 대표 지정됨':'달력 대표';b.classList.toggle('selected',on);
   b.setAttribute('aria-pressed',String(on));
  }
  status('달력 대표 사진·영상을 저장했어요. 달력으로 돌아가면 변경된 표지가 보여요.');
 }catch(e){
  if(previous===undefined)delete S.covers[S.mode][S.date];else S.covers[S.mode][S.date]=previous;
  status('대표 표지를 저장하지 못했어요: '+e,true);
 }
}
// R193 photo voice links reference actual stable M4A IDs and never infer by time.
function r193DayVoices(day){
 let files=[];try{files=JSON.parse(w.MoaLocalAudio?.list?.(day)||'[]')}catch(e){}
 return new Map((Array.isArray(files)?files:[]).filter(f=>f&&/^[A-Za-z0-9_-]{8,90}\.m4a$/.test(String(f.id||''))).map(f=>[String(f.id),f]));
}
async function r193CreatePhotoMoment(p){
 if(!S.manual)return status('사진별 메모는 내가 고른 사진 일기에서 작성할 수 있어요.',true);
 const id=String(p.id),day=S.date;
 if(!/^(?:v[0-9]{1,18}|[0-9]{1,19})$/.test(id))return;
 try{
  const previous=await dbGet('curated',day);
  const entry=previous||{day,photoIds:[],selectionMode:'manual',title:'',body:'',tags:[],feeling:'',activities:{},moments:[]};
  if((entry.removedMediaIds||[]).map(String).includes(id)){status('일기에서 제외한 사진은 먼저 복원해 주세요.',true);return}
  const moments=Array.isArray(entry.moments)?[...entry.moments]:[];
  let target=moments.find(m=>(m.photoIds||[]).map(String).includes(id));
  if(!target){target={uid:'photo-'+id+'-'+Date.now(),at:Number(p.t)||Date.now(),photoIds:[id],note:'',voiceIds:[],createdAt:Date.now()};moments.push(target)}
  const updated={...entry,moments,photoIds:[...new Set([...(entry.photoIds||[]).map(String),id])],updatedAt:Date.now()};
  await dbPut('curated',day,updated);S.curatedEntries.set(day,updated);S.selection.add(id);
  render();mmShowEditor(day,String(target.uid));
 }catch(e){status('사진 메모 준비 실패: '+e,true)}
}
async function r193ConnectPhotoVoice(day,uid,fileId){
 if(!/^[A-Za-z0-9_-]{8,90}\.m4a$/.test(String(fileId)))return;
 const available=r193DayVoices(day);if(!available.has(fileId)){status('원본 음성 파일을 찾지 못했습니다.',true);return}
 try{
  const entry=await dbGet('curated',day);if(!entry)throw Error('일기 기록이 없습니다');
  if((entry.moments||[]).some(m=>m.uid!==uid&&(m.voiceIds||[]).includes(fileId))){status('이 녹음은 이미 다른 사진에 연결돼 있어요.',true);return}
  const moments=(entry.moments||[]).map(m=>m.uid===uid?{...m,voiceIds:[...new Set([...(m.voiceIds||[]),fileId])],updatedAt:Date.now()}:m);
  if(!moments.some(m=>m.uid===uid))throw Error('연결할 사진 메모를 찾지 못했습니다');
  const updated={...entry,moments,updatedAt:Date.now()};await dbPut('curated',day,updated);S.curatedEntries.set(day,updated);
  render();status('선택한 녹음을 이 사진에 연결했습니다. 원본 M4A는 그대로 유지됩니다.');return true;
  }catch(e){status('녹음 연결 실패: '+e,true);return false}
}
// Native M4A record_saved callback for an explicitly selected photo.
// Native bytes remain in the original day folder. Only ID reference enters diary DB.
w.__moaPhotoVoiceSaved=async function(day,mediaId,fileId){
 mediaId=String(mediaId);fileId=String(fileId);
 if(!/^\d{4}-\d{2}-\d{2}$/.test(day)||!/^(?:v[0-9]{1,18}|[0-9]{1,19})$/.test(mediaId))return false;
 if(!/^[A-Za-z0-9_-]{8,90}\.m4a$/.test(fileId)||!r193DayVoices(day).has(fileId))return false;
 try{
  const entry=await dbGet('curated',day);if(!entry||(entry.removedMediaIds||[]).map(String).includes(mediaId)||!(entry.photoIds||[]).map(String).includes(mediaId))return false;
  if((entry.moments||[]).some(m=>!(m.photoIds||[]).map(String).includes(mediaId)&&(m.voiceIds||[]).includes(fileId)))return false;
  const moments=(entry.moments||[]).map(m=>({...m}));
  let current=moments.find(m=>(m.photoIds||[]).map(String).includes(mediaId));
  if(!current){
   const info=r73Media(mediaId);current={uid:'photo-'+mediaId+'-'+Date.now(),at:Number(info?.t)||Date.now(),photoIds:[mediaId],note:'',voiceIds:[],createdAt:Date.now()};moments.push(current);
  }
  current.voiceIds=[...new Set([...(current.voiceIds||[]),fileId])];current.updatedAt=Date.now();
  const updated={...entry,moments,updatedAt:Date.now()};await dbPut('curated',day,updated);S.curatedEntries.set(day,updated);
  if(S.open&&S.date===day&&S.page==='day'&&!S.editing)render();
  w.MoaVoiceTimelineRefresh?.();return true;
 }catch(e){status('원본 음성은 보존됐지만 사진 연결 저장에 실패했습니다: '+e,true);return false}
};
function r193StartPhotoRecording(photo){
 if(!S.manual)return status('사진별 녹음은 내가 고른 사진 일기에서 사용할 수 있어요.',true);
 if(!w.MoaVoiceDiaryNative?.recordForPhoto?.(S.date,String(photo.id)))
  status('원본 녹음 기능에 연결하지 못했어요. 먼저 날짜별 음성 녹음 기능을 확인해 주세요.',true);
}
function r193PhotoAudio(m,day,body,voiceIndex){
 const ids=[...new Set((Array.isArray(m.voiceIds)?m.voiceIds:[]).map(String))];
 for(const fileId of ids){
  const file=voiceIndex?.get(fileId);if(!file){body.append(elem('small','moa-r193-voice-missing','연결된 음성 파일을 확인할 수 없어요.'));continue}
  const row=elem('div','moa-r193-photo-voice');
  const play=button('▶ 듣기',()=>w.MoaVoicePlaybackUI?.play?.(day,fileId,play),'moa-r193-audio-play');
  play.dataset.moaAudioPlay=day+'/'+fileId;play.dataset.moaAudioTitle='사진 음성';
  play.dataset.moaAudioCompact='true';
  play.setAttribute('aria-label','이 사진에 남긴 음성 재생');
  row.append(play);body.append(row);
 }
}

// R197: a real in-app audio attachment sheet, instead of Android's blind
// time/size-only select list. The chosen original photo and exact M4A metadata
// stay visible together; no data is modified before explicit confirmation.
function r197OpenVoiceAttachSheet(photo,entry,moment,available){
 document.getElementById('moa-r197-voice-picker')?.remove();
 const day=entry?.day||S.date;
 const shade=elem('div','moa-r197-voice-shade');shade.id='moa-r197-voice-picker';
 const panel=elem('section','moa-r197-voice-sheet');
 panel.setAttribute('role','dialog');panel.setAttribute('aria-modal','true');
 panel.setAttribute('aria-label','이 사진에 연결할 원본 음성 선택');
 const close=()=>shade.remove();
 const head=elem('div','moa-r197-voice-head');
 head.append(elem('strong','','사진 확인 · 기존 녹음 연결'),button('닫기',close));
 panel.append(head);
 const photoRow=elem('div','moa-r197-voice-photo');
 const thumb=elem('img');thumb.dataset.photoId=String(photo.id);thumb.alt='지금 녹음을 연결할 바로 그 사진';
 const live=S.root.querySelector('.moa-r191-media-tile[data-moa-media-id="'+String(photo.id)+'"] img');
 if(live?.src)thumb.src=live.src;
 const photoDesc=elem('div','','');
 photoDesc.append(elem('strong','','연결 대상 사진·영상'));
 photoDesc.append(elem('p','','촬영 '+new Date(Number(photo.t)||Date.now()).toLocaleString('ko-KR')));
 photoDesc.append(elem('small','','위 사진을 확인하고 아래 녹음을 직접 들어본 뒤 연결하세요.'));
 photoRow.append(thumb,photoDesc);panel.append(photoRow);
 panel.append(elem('p','moa-r197-voice-note','저장된 음성을 재생·일시정지하거나 녹음 당시 저장한 텍스트를 읽어볼 수 있습니다. 연결하지 않아도 원본은 보존됩니다.'));
 const list=elem('div','moa-r197-voice-list');
 let chosen=null;
 for(const file of available){
  const fileId=String(file.id),record=elem('label','moa-r197-voice-choice');
  const note=w.MoaVoicePlaybackUI?.metaFor?.(day,fileId)||{};
  const choice=elem('input');choice.type='radio';choice.name='moa-r197-voice-choice';
  choice.value=fileId;choice.addEventListener('change',()=>{chosen=fileId;confirm.disabled=false});
  const main=elem('div','moa-r197-voice-detail');
  const line=elem('strong','moa-r197-voice-title',String(note.title||'원본 음성 기록'));
  main.append(line);
  const info=elem('div','moa-r197-voice-file-meta',
   new Date(Number(file.time)||Date.now()).toLocaleString('ko-KR')+' · '+Math.round(Math.max(0,Number(file.bytes)||0)/1024)+'KB');
  main.append(info);
  const playback=button('▶ 00:00 / '+(w.MoaVoicePlaybackUI?.totalLabel?.(day,fileId)||'--:--'),
   ()=>w.MoaVoicePlaybackUI?.play?.(day,fileId,playback),'moa-r197-voice-play');
  playback.dataset.moaAudioPlay=day+'/'+fileId;playback.dataset.moaAudioTitle=note.title||'원본 음성';
  main.append(playback);
  const recognized=String(note.transcript||note.autoTranscript||'').trim();
  const noteBox=elem('div','moa-r197-voice-transcript',
   recognized||'저장된 녹음 텍스트 없음 · 재생해서 내용을 확인할 수 있습니다.');
  main.append(noteBox);
  record.append(choice,main);list.append(record);
 }
 panel.append(list);
 const footer=elem('div','moa-r197-voice-footer');
 const confirm=button('선택한 음성을 이 사진에 연결',async()=>{
  if(!chosen)return;confirm.disabled=true;
  const ok=await r193ConnectPhotoVoice(day,String(moment.uid),chosen);
  if(ok){close();r197HighlightLinkedPhoto(String(photo.id),true);}
  else confirm.disabled=false;
 },'primary');
 confirm.disabled=true;
 footer.append(button('취소',close),confirm);panel.append(footer);
 shade.append(panel);document.body.append(shade);
 shade.addEventListener('click',e=>{if(e.target===shade)close()});
 panel.addEventListener('keydown',e=>{if(e.key==='Escape'){e.preventDefault();e.stopPropagation();close()}});
 if(!thumb.src)thumbs([thumb],400);
 // Android Back must close the nearest modal and never jump to the calendar.
 for(const k of ['__fjBackOverlay','__photoMapBack']){
  const old=w[k];if(typeof old!=='function'||old.__moaR197VoicePicker)continue;
  const wrapped=function(...args){
   const picker=document.getElementById('moa-r197-voice-picker');
   if(picker){picker.remove();return true}return old.apply(this,args);
  };wrapped.__moaR197VoicePicker=true;w[k]=wrapped;
 }
}
function r197HighlightLinkedPhoto(id,linked=true){
 const target=S.root?.querySelector('.moa-r191-media-tile[data-moa-media-id="'+String(id)+'"]');
 if(target)r197MarkVoiceDestination(target,linked);
}
function r197MarkVoiceDestination(target,exact){
 if(!target||!target.isConnected)return;
 for(const x of S.root.querySelectorAll('.moa-r197-voice-destination'))x.classList.remove('moa-r197-voice-destination');
 for(const x of S.root.querySelectorAll('.moa-r197-voice-badge'))x.remove();
 target.classList.add('moa-r197-voice-destination');
 const badge=elem('span','moa-r197-voice-badge',
  exact?'이 녹음이 연결된 사진':'이 시간대 녹음 · 연결된 사진 없음');
 target.insertBefore(badge,target.firstChild);
 const focus=()=>{if(target.isConnected)target.scrollIntoView({behavior:'smooth',block:'center',inline:'nearest'})};
 focus();setTimeout(focus,150); // voice sheet has finished closing
 setTimeout(()=>{if(target.isConnected){badge.remove();target.classList.remove('moa-r197-voice-destination')}},10000);
}


// R197: two-finger inline zoom inside a diary card, without launching gallery.
// On zoom, card stays in day timeline; second ordinary tap resets it.
function r197EnableInlinePinch(item,picture){
 let startSpan=0,startScale=1,zoom=1,lastMidX=0,lastMidY=0;
 let dx=0,dy=0,blockTapUntil=0;
 const length=t=>Math.hypot(t[0].clientX-t[1].clientX,t[0].clientY-t[1].clientY);
 const middle=t=>({x:(t[0].clientX+t[1].clientX)/2,y:(t[0].clientY+t[1].clientY)/2});
 const paint=()=>{
  picture.style.transform='translate('+dx+'px,'+dy+'px) scale('+zoom+')';
  item.classList.toggle('moa-r197-inline-zoom',zoom>1.025);
  item.setAttribute('aria-label',zoom>1.025?'사진 확대됨 · 탭하면 원래 크기':'사진 확대 보기 · 두 손가락으로 화면 안에서 확대 가능');
 };
 item.addEventListener('touchstart',e=>{
  if(e.touches.length===2){startSpan=Math.max(1,length(e.touches));startScale=zoom;
   const pt=middle(e.touches);lastMidX=pt.x;lastMidY=pt.y;
   blockTapUntil=Date.now()+700;e.preventDefault();}
 },{passive:false});
 item.addEventListener('touchmove',e=>{
  if(e.touches.length!==2||!startSpan)return;
  const mid=middle(e.touches);
  dx+=mid.x-lastMidX;dy+=mid.y-lastMidY;lastMidX=mid.x;lastMidY=mid.y;
  zoom=Math.max(1,Math.min(3.25,startScale*length(e.touches)/startSpan));
  if(zoom<1.04){zoom=1;dx=0;dy=0}
  const limitX=Math.max(0,(zoom-1)*item.clientWidth/2);
  const limitY=Math.max(0,(zoom-1)*item.clientHeight/2);
  dx=Math.max(-limitX,Math.min(limitX,dx));dy=Math.max(-limitY,Math.min(limitY,dy));
  paint();blockTapUntil=Date.now()+700;e.preventDefault();
 },{passive:false});
 item.addEventListener('touchend',e=>{if(e.touches.length<2)startSpan=0},{passive:true});
 return ()=>{if(Date.now()<blockTapUntil)return true;
  if(zoom>1.025){zoom=1;dx=dy=0;paint();return true}
  return false;};
}

function videoFriendlyTile(p,chosen,entry,voiceIndex){
 const tile=elem('div','fd26-tile moa-r191-media-tile'),video=isVideo(p),id=String(p.id);
 tile.dataset.moaMediaId=id;tile.dataset.moaMediaTime=String(Number(p.t)||0);
 const item=elem('button','fd23-photo'+(video?' fd26-video':''));item.type='button';
 item.setAttribute('aria-label',video?'동영상 재생':'사진 확대 보기');
 const pic=elem('img');pic.dataset.photoId=id;pic.alt=video?'동영상 미리보기':'사진 미리보기';item.append(pic);
 if(video)item.append(elem('span','fd26-video-mark','▶ '+durationText(p.duration)));
 const pinchGuard=video?()=>false:r197EnableInlinePinch(item,pic);
 item.onclick=()=>{if(pinchGuard())return;video?nav('diaryPlayVideo',{id}):openGallery(chosen,chosen.findIndex(x=>x.id===id));};
 tile.append(item);

 const related=(entry?.moments||[]).filter(m=>(m.photoIds||[]).some(mid=>String(mid)===id));
 const hasText=related.some(m=>String(m.note||'').trim()),hasVoice=related.some(m=>(m.voiceIds||[]).length);
 const memo=elem('details','moa-r191-tile-fold moa-r191-memo-fold');
 memo.dataset.recordState=hasVoice||hasText?'filled':'empty';
 const memoTitle=elem('summary','','기록');
 memoTitle.setAttribute('aria-label',hasVoice?'이 사진의 메모와 음성 기록 펼치기':hasText?'사진 메모 펼치기':'이 사진에 메모 추가');
 memo.append(memoTitle);
 const memoBody=elem('div','moa-r191-memo-body');
 if(related.length){
  for(const m of related){
   const note=String(m.note||'').trim();
   if(note)memoBody.append(elem('p','moa-r191-capture-text',note));
   r193PhotoAudio(m,entry?.day||S.date,memoBody,voiceIndex);
   if(m.uid&&S.manual){
    memoBody.append(button(note?'수정':'메모 추가',()=>mmShowEditor(entry.day,String(m.uid)),'moa-r191-tile-edit'));
    memoBody.append(button('녹음',()=>r193StartPhotoRecording(p),'moa-r191-tile-edit moa-r195-record-button'));
   }
  }
 }else {
  memoBody.append(elem('p','moa-r191-memo-empty','아직 기록이 없어요. 나중에도 추가할 수 있어요.'));
  if(S.manual){memoBody.append(button('메모 추가',()=>r193CreatePhotoMoment(p),'moa-r191-tile-edit'));
   memoBody.append(button('녹음',()=>r193StartPhotoRecording(p),'moa-r191-tile-edit moa-r195-record-button'))}
 }
 if(S.manual&&related.length){
  // Legacy native capture records were ACKed without their audio IDs in old
  // releases. Allow explicit user-directed attachment, never time guessing.
  const assigned=new Set((entry?.moments||[]).flatMap(m=>Array.isArray(m.voiceIds)?m.voiceIds:[]));
  const available=[...(voiceIndex?.values()||[])].filter(f=>!assigned.has(f.id));
  if(available.length&&related[0]?.uid){
   memoBody.append(button('기존 녹음 찾아 연결',
    ()=>r197OpenVoiceAttachSheet(p,entry,related[0],available),'moa-r197-attach-open'));
  }
 }
 memo.append(memoBody);tile.append(memo);

 const actions=elem('details','moa-r191-tile-fold moa-r191-tools-fold');
 actions.append(elem('summary','','기능'));
 const body=elem('div','moa-r191-tools-body');
 body.append(button('공유',()=>nav(video?'diaryShareVideo':'sharePhoto',{id}),'fd29-quick'));
 body.append(button('갤러리',()=>nav(video?'diaryOpenVideoGallery':'openInGallery',{id}),'fd29-quick'));
 const cover=button((S.covers[S.mode]||{})[S.date]===id?'✓ 대표':'대표 사진',()=>setCalendarCover(id),'fd29-cover-btn'+((S.covers[S.mode]||{})[S.date]===id?' selected':''));
 cover.dataset.coverId=id;cover.setAttribute('aria-pressed',String((S.covers[S.mode]||{})[S.date]===id));body.append(cover);
 let panel=null;
 const position=button('위치',()=>{
  if(!panel){panel=elem('div','fd28-geochip fd29-geo-panel');body.append(panel);w.FamilyJourneyDiaryGeo?.attach(panel,id);position.textContent='위치 접기';position.setAttribute('aria-expanded','true');return;}
  const expanded=panel.hidden;panel.hidden=!expanded;position.textContent=expanded?'위치 접기':'위치';position.setAttribute('aria-expanded',String(expanded));
 },'fd29-position');
 position.setAttribute('aria-expanded','false');body.append(position);
 const remove=button('삭제',()=>removeOneDiaryMedia(id),'fd56-remove-one');
 remove.setAttribute('aria-label','이 사진·영상만 일기에서 제외 (원본은 삭제하지 않음)');
 remove.title='일기에서만 제외하며 휴대폰의 원본은 보존합니다.';
 body.append(remove);
 actions.append(body);tile.append(actions);
 return tile;
}
// R193: display-only preferences, never rewrite IndexedDB diary group keys.
function r193OpenDisplaySettings(){
 if(!S.open||S.page!=='day')return;
 document.getElementById('moa-r191-day-shade')?.remove();
 const shade=elem('div','moa-r191-day-shade');shade.id='moa-r191-day-shade';
 const panel=elem('section','moa-r191-day-panel moa-r193-settings');panel.setAttribute('role','dialog');panel.setAttribute('aria-modal','true');
 panel.append(elem('h3','','사진일기 보기 설정'));
 const bucketLabel=elem('label','moa-r193-setting-row','사진·영상 시간대 묶음 · 최대 24시간');
 const bucket=elem('select');for(const n of R193_BUCKET_CHOICES){const o=elem('option','',n>=60?(n/60)+'시간':n+'분');o.value=String(n);bucket.append(o)}
 const option=elem('option','','직접 지정 (5분 단위)');option.value='custom';bucket.append(option);
 const current=r193GroupMinutes();bucket.value=R193_BUCKET_CHOICES.includes(current)?String(current):'custom';
 bucketLabel.append(bucket);panel.append(bucketLabel);
 const customRow=elem('label','moa-r193-setting-row moa-r195-custom-minutes','직접 지정 · 5~1440분');
 const custom=elem('input');custom.type='number';custom.min='5';custom.max='1440';custom.step='5';custom.inputMode='numeric';custom.value=String(current);
 custom.setAttribute('aria-label','시간 묶음 직접 지정, 분 단위');customRow.append(custom);panel.append(customRow);
 customRow.hidden=bucket.value!=='custom';bucket.addEventListener('change',()=>{customRow.hidden=bucket.value!=='custom';if(!customRow.hidden)custom.focus()});
 const sizeLabel=elem('label','moa-r193-setting-row','사진 표시 크기');const size=elem('select');
 for(const [n,label] of [[1,'크게 · 한 줄에 1장'],[2,'보통 · 한 줄에 2장'],[3,'작게 · 한 줄에 3장']]){const o=elem('option','',label);o.value=n;size.append(o)}
 size.value=String(r193PhotoColumns());sizeLabel.append(size);panel.append(sizeLabel);
 const stickyLabel=elem('label','moa-r193-setting-row moa-r195-sticky-row');
 const stickyText=elem('span','','상단 날짜·관리 메뉴 틀 고정');
 const sticky=elem('input');sticky.type='checkbox';sticky.checked=r195StickyHeader();
 sticky.setAttribute('aria-label','상단 날짜 메뉴 고정 켜기 또는 끄기');stickyLabel.append(stickyText,sticky);panel.append(stickyLabel);
 panel.append(elem('p','moa-r193-setting-help','표시 방식만 바뀝니다. 5분~24시간 범위를 지정해도 원래 사진 촬영 시간, 음성 녹음과 메모 데이터는 그대로 유지됩니다.'));
 const actions=elem('div','moa-r193-settings-actions');
 actions.append(button('관리 메뉴',()=>r191OpenDaySheet(false)),button('적용',()=>{
  const minutes=bucket.value==='custom'?Number(custom.value):Number(bucket.value);
  if(!Number.isInteger(minutes)||minutes<5||minutes>1440||minutes%5!==0){alert('시간대는 5~1440분 사이 5분 단위로 지정해 주세요.');custom.focus();return;}
  try{localStorage.setItem(R193_BUCKET_KEY,String(minutes));localStorage.setItem(R193_PHOTO_SIZE_KEY,size.value);localStorage.setItem(R195_STICKY_HEADER_KEY,sticky.checked?'on':'off')}catch(e){}
  shade.remove();render();status('사진일기 보기 설정을 적용했어요.');
 },'primary'));
 panel.append(actions);shade.append(panel);S.root.append(shade);
 shade.addEventListener('click',e=>{if(e.target===shade)r191OpenDaySheet(false)});
 panel.addEventListener('keydown',e=>{if(e.key==='Escape'){e.preventDefault();e.stopPropagation();r191OpenDaySheet(false)}});
}
// R191: date-level action sheet, no duplicate top buttons.
function r191CloseDaySheet(){
 const shade=document.getElementById('moa-r191-day-shade');
 if(!shade)return;
 if(S.editing){
  if(S.dirty&&!confirm('저장하지 않은 일기 수정을 취소할까요?'))return;
  S.editing=false;S.dirty=false;render();return;
 }
 shade.remove();
}
function r191OpenDaySheet(edit=false){
 if(!S.open||S.page!=='day')return;
 if(edit&&!S.editing){S.editing=true;S.dirty=false;render()}
 document.getElementById('moa-r191-day-shade')?.remove();
 const shade=elem('div','moa-r191-day-shade');shade.id='moa-r191-day-shade';
 const panel=elem('section','moa-r191-day-panel');
 panel.dataset.moaR193View=edit?'editor':'menu';
 panel.setAttribute('role','dialog');panel.setAttribute('aria-modal','true');
 panel.setAttribute('aria-label','날짜별 일기 관리');
 const head=elem('header','moa-r191-sheet-head');
 head.append(elem('strong','',readable(S.date)+(edit?' · 일기 수정':' · 관리')));
 const close=button('닫기 ×',r191CloseDaySheet,'moa-r191-sheet-close');head.append(close);panel.append(head);
 if(edit){
   // Reuse the existing original form, live field bindings, save/remove paths.
   const form=S.root.querySelector(':scope > .fd23-editor');
   if(form){form.classList.add('moa-r191-sheet-editor');panel.append(form)}
   const quick=S.root.querySelector(':scope > .fd68-editor-quickbar');
   if(quick){
    quick.style.cssText='position:sticky;bottom:0;z-index:2;display:flex;gap:5px;padding:7px;background:#fff9fc;border-top:1px solid #e8d5df;border-radius:12px;';
    panel.append(quick);
   }
 }else{
   const actions=elem('div','moa-r191-day-menu');
   const add=(label,fn,danger=false)=>{
    const control=button(label,()=>{shade.remove();fn()},danger?'moa-r191-menu-danger':'moa-r191-menu-action');
    actions.append(control);return control;
   };
   add('▦ 이 날짜 전체 사진·영상 보기',()=>{
    if(!w.MoaUnifiedDiary?.openSheet?.())S.root.querySelector('#moa-r133-open-day-list')?.click();
   });
   add('🎙 음성 녹음·저장 목록',()=>{
    if(w.MoaVoiceDiaryNative?.open)w.MoaVoiceDiaryNative.open();
    else S.root.querySelector('#moa-r149-open')?.click();
   });
   if(S.manual){
     add('＋ 사진·동영상 추가·변경',openPicker);
     add('▣ 이 날 사진·영상 전체 선택',()=>{
      const auto=S.byDay.get(S.date)||[],videos=S.byVideoDay.get(S.date)||[];
      S.selection=new Set([...auto,...videos].map(p=>String(p.id)));
      S.editing=true;S.dirty=true;render();r191OpenDaySheet(true);
     });
   }
   add('⚙ 보기 설정 · 시간대·사진 크기·상단 고정',()=>r193OpenDisplaySettings());
   add('상단 날짜·메뉴 고정: '+(r195StickyHeader()?'켜짐 · 끄기':'꺼짐 · 켜기'),()=>{
    const turnOn=!r195StickyHeader();
    try{localStorage.setItem(R195_STICKY_HEADER_KEY,turnOn?'on':'off')}catch(_){}
    S.root.dataset.moaR195Sticky=turnOn?'on':'off';
    status('상단 날짜·메뉴 고정 '+(turnOn?'켜짐':'꺼짐'));
   });
   add('✎ 제목·본문·시간대 메모 · 일기 수정',()=>r191OpenDaySheet(true));
   if(entriesForMode().get(S.date))
     add('일기 삭제',()=>remove(),true);
   panel.append(actions);
 }
 shade.append(panel);S.root.append(shade);
 shade.addEventListener('click',e=>{if(e.target===shade)r191CloseDaySheet()});
 panel.addEventListener('keydown',e=>{if(e.key==='Escape'){e.preventDefault();r191CloseDaySheet()}});
 close.focus({preventScroll:true});
}
// R191: legacy group activity may contain a copy of the same photo-bound native
// capture memo. Hide only duplicated display text; never modify persisted data.
function r191GroupOnlyActivity(entry,g){
 // Read existing 5-minute activity entries without rewriting original keys.
 const parts=[];
 for(const [key,raw] of Object.entries(entry?.activities||{})){
  const ts=Number(key);if(Number.isFinite(ts)&&ts>=g.groupStart&&ts<g.groupEnd&&String(raw).trim())parts.push(String(raw));
 }
 let text=parts.join('\n');
 for(const m of (entry?.moments||[])){
  if(!(m.photoIds||[]).some(id=>g.photos.some(p=>String(p.id)===String(id))))continue;
  const note=String(m.note||'').trim();if(!note)continue;
  const marker=timeOf(m.at)+' · '+note;
  if(text.includes(marker))text=text.replace(marker,'');
 }
 return text.replace(/\n{3,}/g,'\n\n').trim();
}
function renderDay(){const day=S.date,entry=entriesForMode().get(day),auto=S.byDay.get(day)||[],chosen=visibleDayPhotos();
 S.root.dataset.moaRenderedDay=day;S.root.dataset.moaRenderedMode=S.mode;
 S.root.dataset.moaR193Columns=String(r193PhotoColumns());
 S.root.dataset.moaR195Sticky=r195StickyHeader()?'on':'off';
 const voiceIndex=r193DayVoices(day);
 const header=elem('div','fd23-top');header.append(button('‹ 달력으로',back,'soft'),elem('strong','',readable(day)),button('⋯',()=>r191OpenDaySheet(S.editing),'soft moa-r191-day-menu-trigger'));S.root.insertBefore(header,S.root.firstChild);
 const stat=elem('div','fd23-daystats');stat.append(elem('div','',`사진 ${chosen.filter(p=>!isVideo(p)).length}장 · 동영상 ${chosen.filter(isVideo).length}개 · ${S.manual?'내가 고른 기록':'이날 촬영한 전체 기록'}`));if(auto.length||(S.byVideoDay.get(day)||[]).length)stat.append(elem('small','',`이날 촬영한 사진 ${auto.length}장 · 영상 ${(S.byVideoDay.get(day)||[]).length}개`));S.root.append(stat);
 const jump=elem('div','fd23-shortcuts');
 if(S.manual){
  jump.append(button('사진·동영상 추가·변경',openPicker,'primary'),button('이날 사진·영상 전체 선택',()=>{S.selection=new Set([...auto,...(S.byVideoDay.get(day)||[])].map(p=>p.id));S.editing=true;S.dirty=true;render()},''));
 }else{
  jump.append(elem('span','fd23-mode-note','자동 사진 달력: 이날 촬영 사진 전체를 표시합니다.'));
 }
 jump.append(button(entry?'일기 수정':'일기 작성',()=>{S.editing=true;render()}));S.root.append(jump);
 // R42: minute memories appear next to their photos IN the existing timeline, never in a separate block.
 {const intro=elem('section','fd23-written');intro.append(elem('h2','',entry?.title||'우리 가족의 하루'));if(entry?.body)intro.append(elem('p','',entry.body));if(entry?.feeling||entry?.tags?.length)intro.append(elem('small','',[entry.feeling,(entry.tags||[]).join(' · ')].filter(Boolean).join(' · ')));S.root.append(intro)}
 if(!chosen.length)S.root.append(elem('div','fd23-emptymsg',S.manual?'직접 고른 사진·동영상이 없어요. [사진·동영상 추가·변경]에서 골라 보세요.':'이 날짜에 촬영된 사진이 없어요.'));
 const groups=segments(chosen);
 const timeline=elem('div','fd23-timeline');timeline.append(elem('h3','','사진·영상으로 보는 하루'));
 for(const g of groups){
  const section=elem('section','fd23-log'),dt=elem('div','fd23-logtime');
  section.dataset.groupStart=String(g.groupStart);section.dataset.groupEnd=String(g.groupEnd);
  section.dataset.moaTimelineDay=day;
  dt.append(elem('strong','',timeOf(g.groupStart)+' ~ '+timeOf(g.groupEnd-60000)),elem('span','',counts(g.photos)));
  if(dateOf(g.start)!==day)dt.append(elem('small','','· '+dateOf(g.start)+' 촬영'));
  section.append(dt);
  const activity=r191GroupOnlyActivity(entry,g);if(activity){const info=elem('details','moa-r191-group-note');info.append(elem('summary','','이 시간대 메모'),elem('p','fd23-activity',activity));section.append(info)}
  // Per-capture moments appear under the exact photoIds, not at group top.
  const strip=elem('div','fd23-strip');section.append(strip);
  // The initial 12 and video-first affordance retain R29's original behavior.
  // Later batches are strictly 30, and each tap appends rather than replacing images.
  const first=g.photos.slice(0,12),initial=[...first];
  for(const v of g.photos.filter(isVideo).slice(0,10))if(!initial.some(p=>p.id===v.id))initial.push(v);
  const shown=new Set(initial.map(p=>p.id));
  for(const p of initial)strip.append(videoFriendlyTile(p,chosen,entry,voiceIndex));
  const remainder=g.photos.filter(p=>!shown.has(p.id));let offset=0;
  if(remainder.length){
   const more=button('',()=>{
    const batch=remainder.slice(offset,offset+30);offset+=batch.length;
    for(const p of batch)strip.append(videoFriendlyTile(p,chosen,entry,voiceIndex));
    thumbs([...strip.querySelectorAll('img[data-photo-id]')].filter(n=>!n.src),R38_BIG_THUMB);
    if(offset>=remainder.length)more.remove();else more.textContent=`사진·영상 더 보기 (${remainder.length-offset}개 남음)`;
   },'fd31-more');
   more.textContent=`사진·영상 더 보기 (${remainder.length}개 남음)`;section.append(more);
  }
  timeline.append(section);
 }
 if(S.manual&&entry){
  const visibleIds=new Set(chosen.map(p=>String(p.id)));
  const excluded=new Set((entry.removedMediaIds||[]).map(String));
  const detached=(entry.moments||[]).filter(m=>{
   const active=(m.photoIds||[]).map(String).filter(id=>!excluded.has(id));
   return String(m.note||'').trim()&&active.length&&active.every(id=>!visibleIds.has(id));
  });
  if(detached.length){
   const recovery=elem('section','fd23-written');
   recovery.append(elem('h3','',detached.some(m=>(m.photoIds||[]).some(id=>R73.confirmedMissing.has(String(id))))?'원본 사진을 찾지 못함 · 메모 보존됨':'원본 사진 확인 중 · 메모는 안전하게 보존됨')); 
   for(const m of detached)recovery.append(elem('p','fd23-activity',timeOf(m.at)+' · '+String(m.note)));
   timeline.append(recovery);
  }
 }
 S.root.append(timeline);if(chosen.length)thumbs(timeline.querySelectorAll('img[data-photo-id]'),R38_BIG_THUMB);
 if(S.editing)renderEditor(entry,chosen); // R191 editor is moved into ⋯ sheet, never duplicated at bottom.
 const bottom=elem('div','fd23-daynav');const prev=new Date(day+'T12:00:00');prev.setDate(prev.getDate()-1);const next=new Date(day+'T12:00:00');next.setDate(next.getDate()+1);bottom.append(button('‹ 전날',()=>chooseDay(dateOf(prev.getTime()))),button('날짜 달력',()=>{S.page='calendar';render()}),button('다음날 ›',()=>chooseDay(dateOf(next.getTime()))));S.root.append(bottom)
}

// R56: remove ONE photo or video from a day's diary without clearing the
// whole date, deleting the original media file, or losing other moments.
async function removeOneDiaryMedia(id){
 id=String(id);
 if(S.editing&&S.dirty){alert('작성 중인 일기를 먼저 저장한 다음 사진·영상을 제외해 주세요.');return}
 if(!confirm('이 사진·영상만 일기에서 제외할까요? 원본 사진·영상은 갤러리에 그대로 남습니다.'))return;
 const day=S.date,table=S.manual?'curated':'entries';
 try{
  const current=await dbGet(table,day)||{day,selectionMode:S.manual?'manual':'automatic',photoIds:[],moments:[],activities:{}};
  // Keep every original moment/note untouched. Its photo association becomes
  // invisible while excluded, and undo restores both image AND its diary note.
  const originalMoments=Array.isArray(current.moments)?current.moments:[];
  const removedMediaIds=[...new Set([...(current.removedMediaIds||[]).map(String),id])];
  const updated={...current,day,photoIds:(current.photoIds||[]).map(String).filter(x=>x!==id),moments:originalMoments,removedMediaIds,updatedAt:Date.now()};
  await dbPut(table,day,updated);
  entriesForMode().set(day,updated);
  r76Forget(id);
  S.selection.delete(id);
  mmSeen.add(id);mmQueue=mmQueue.filter(x=>String(x.id)!==id);mmPersist();
  if((S.covers[S.mode]||{})[day]===id){
   const all={...S.covers, [S.mode]:{...(S.covers[S.mode]||{})}};
   delete all[S.mode][day];
   await dbPut('meta','calendar-covers-r29',all);S.covers=all;
  }
  S.editing=false;S.dirty=false;render();status('선택한 사진·영상 1개만 일기에서 제외했습니다. 원본은 보존됩니다.');
 }catch(e){status('개별 사진·영상 제외 실패: '+e,true)}
}
async function restoreOneDiaryMedia(id){
 id=String(id);if(S.editing&&S.dirty){alert('작성 중인 일기를 먼저 저장해 주세요.');return}
 const day=S.date,table=S.manual?'curated':'entries';
 try{
  const previous=await dbGet(table,day);if(!previous)return;
  const next={...previous,removedMediaIds:(previous.removedMediaIds||[]).map(String).filter(x=>x!==id),updatedAt:Date.now()};
  // Restore a curated image to the chosen-photo list. Automatic diaries show
  // it from the ordinary photo index once the exclusion tombstone is removed.
  if(S.manual)next.photoIds=[...new Set([...(previous.photoIds||[]).map(String),id])];
  await dbPut(table,day,next);entriesForMode().set(day,next);
  if(S.manual)S.selection.add(id);
  S.editing=false;S.dirty=false;render();status('일기에 다시 표시했습니다.');
 }catch(e){status('사진·영상 복원 실패: '+e,true)}
}
function renderMediaManager(form,entry,photos){
 const panel=elem('section','fd56-manage');panel.append(elem('h4','','사진·영상 개별 관리'));
 panel.append(elem('p','fd23-hint','원하는 항목만 일기에서 제외할 수 있습니다. 원본 갤러리 파일은 삭제되지 않습니다.'));
 const list=elem('div','fd56-manage-list');
 for(const p of photos){
  const row=elem('div','fd56-manage-row');
  row.append(elem('span','',timeOf(p.t)+' · '+(isVideo(p)?'영상':'사진')+' · ID '+p.id));
  row.append(button('이 항목만 제외',()=>removeOneDiaryMedia(p.id),'fd56-remove-one'));
  list.append(row);
 }
 const hidden=(entry?.removedMediaIds||[]).map(String);
 for(const id of hidden){
  const row=elem('div','fd56-manage-row');
  row.append(elem('span','','제외됨 · '+(id.startsWith('v')?'영상':'사진')+' · ID '+id));
  row.append(button('다시 표시',()=>restoreOneDiaryMedia(id),'fd56-restore-one'));
  list.append(row);
 }
 if(!photos.length&&!hidden.length)list.append(elem('p','','관리할 사진·영상이 없습니다.'));
 panel.append(list);form.append(panel);
}

function renderEditor(entry,photos){const form=elem('section','fd23-editor');form.append(elem('h3','','일기 작성·수정'));// R85: the user's R83 Golden recognizer now writes into a MULTILINE title.
 // Preserve the exact id, value, maxlength, voice button and original save path.
 // No schema changes; on-screen wrapping + vertical resize are display-only.
 const title=elem('textarea');title.id='fd23-title';title.rows=2;
 title.placeholder='오늘의 제목';title.maxLength=120;title.value=entry?.title||'';
 title.setAttribute('aria-label','일기 제목');title.setAttribute('enterkeyhint','next');
 title.style.cssText='min-height:58px;max-height:240px;resize:vertical;overflow-y:auto;white-space:pre-wrap;overflow-wrap:anywhere;box-sizing:border-box;line-height:1.55';
 let titleAutoHeight=0,titleManualHeight=0;
 const r85FitTitle=()=>{
   if(!title.isConnected)return;
   // Preserve a manual drag-resize while still expanding with longer text.
   const shown=title.getBoundingClientRect().height;
   if(titleAutoHeight&&Math.abs(shown-titleAutoHeight)>3)
     titleManualHeight=Math.max(58,Math.min(240,shown));
   const oldTop=title.scrollTop;
   title.style.height='auto';
   const needed=Math.max(58,Math.min(240,title.scrollHeight+2));
   const desired=Math.max(needed,titleManualHeight);
   title.style.height=desired+'px';titleAutoHeight=desired;
   title.scrollTop=oldTop;
 };
 title.addEventListener('input',r85FitTitle);
 form.append(title,r87VoiceAndClear(title,'일기 제목'));const body=elem('textarea');body.id='fd23-body';body.placeholder='그날 있었던 일과 기억하고 싶은 이야기를 자유롭게 적어 주세요.';body.maxLength=12000;body.setAttribute('enterkeyhint','enter');body.value=entry?.body||'';form.append(body,r87VoiceAndClear(body,'일기 본문'));const tags=elem('input');tags.type='text';tags.id='fd23-tags';tags.placeholder='태그 (쉼표로 구분)';tags.value=(entry?.tags||[]).join(', ');form.append(tags);const feeling=elem('select');feeling.id='fd23-feeling';for(const [key,label] of [['','오늘의 기분'],['happy','행복'],['calm','평온'],['active','신남'],['thankful','감사'],['tired','피곤'],['sad','속상함']]){const o=elem('option','',label);o.value=key;feeling.append(o)}feeling.value=entry?.feeling||'';form.append(feeling);
 const activities=elem('div','fd23-activity-editor');activities.append(elem('h4','','시간대별 메모'));for(const g of segments(photos,5)){const t=elem('label','',timeOf(g.start)+' · '+counts(g.photos));const input=elem('textarea');input.rows=3;input.maxLength=2000;input.setAttribute('enterkeyhint','enter');input.setAttribute('aria-label',timeOf(g.start)+' 활동 내용');input.placeholder='이 시간대에 있었던 일을 여러 줄로 적어 보세요. ↵ 줄바꿈 가능';input.dataset.activityKey=String(g.start);input.value=(entry?.activities||{})[String(g.start)]||'';t.append(input,r87VoiceAndClear(input,timeOf(g.start)+' 시간대별 메모'));activities.append(t)}form.append(activities);
 renderMediaManager(form,entry,photos);
 for(const n of form.querySelectorAll('input,textarea,select'))n.addEventListener('input',()=>{S.dirty=true});const buttons=elem('div','fd23-actions');buttons.append(button('일기 저장',save,'primary'),button('취소',()=>{S.editing=false;S.dirty=false;render()}));const originalDelete=entry?button('일기 삭제',remove,'danger'):null;if(originalDelete)buttons.append(originalDelete);form.append(buttons);
 // R68: the original editing fields, time notes and lower destructive controls
 // remain intact. Add always-reachable save + two jump links above bottom tab.
 form.style.paddingBottom='110px';
 const shortcutBar=elem('div','fd68-editor-quickbar');
 shortcutBar.setAttribute('role','toolbar');
 shortcutBar.setAttribute('aria-label','일기 작성 빠른 이동 및 저장');
 shortcutBar.style.cssText='position:fixed;left:10px;right:10px;bottom:calc(69px + env(safe-area-inset-bottom));z-index:55;display:flex;gap:6px;align-items:center;padding:8px;background:#fffaf6;border:1px solid #e9d9d2;border-radius:17px;box-shadow:0 -3px 18px #0002';
 const gotoField=(target)=>{
   if(!target)return;
   try{target.scrollIntoView({behavior:'smooth',block:'center'})}catch(e){target.scrollIntoView()}
 };
 const shortcutTitle=button('제목·본문',()=>gotoField(title),'soft');
 const shortcutMemo=button('시간대 메모',()=>gotoField(activities),'soft');
 const shortcutSave=button('일기 저장',save,'primary');
 // Same delete handler as the bottom original control, including its confirm().
 // A new unsaved entry has no delete control, so the shortcut stays hidden.
 const shortcutDelete=originalDelete?button('일기 삭제',remove,'danger'):null;
 if(shortcutDelete){
   shortcutDelete.setAttribute('aria-label','현재 날짜 일기 삭제 · 삭제 확인창 표시');
   shortcutDelete.title='현재 날짜의 일기를 삭제합니다. 확인을 누르기 전에는 삭제되지 않습니다.';
   shortcutDelete.style.color='#a84a54';
 }
 for(const x of [shortcutTitle,shortcutMemo,shortcutSave,shortcutDelete].filter(Boolean)){
   x.style.flex='1 1 0';x.style.minWidth='0';x.style.padding='11px 3px';x.style.fontSize='12px';x.style.borderRadius='10px';
   shortcutBar.append(x);
 }
 S.root.append(form,shortcutBar);
 // Wait until attached: textarea.scrollHeight is not measurable off-DOM.
 if(typeof requestAnimationFrame==='function')requestAnimationFrame(r85FitTitle);
 else setTimeout(r85FitTitle,0)
}
async function save(){const previous=entriesForMode().get(S.date)||{};const doc={day:S.date,title:$('#fd23-title')?.value.trim()||'',body:$('#fd23-body')?.value.trim()||'',tags:($('#fd23-tags')?.value||'').split(',').map(s=>s.trim()).filter(Boolean).slice(0,20),feeling:$('#fd23-feeling')?.value||'',activities:{...(previous.activities||{})},photoIds:S.manual?[...S.selection]:[],selectionMode:S.manual?'manual':'automatic',removedMediaIds:[...(previous.removedMediaIds||[])],moments:Array.isArray(previous.moments)?previous.moments:[],updatedAt:Date.now(),source:'owner'};
 for(const item of S.root.querySelectorAll('[data-activity-key]')){if(item.value.trim())doc.activities[item.dataset.activityKey]=item.value.trim();else delete doc.activities[item.dataset.activityKey]}
 try{const table=S.manual?'curated':'entries';await dbPut(table,doc.day,doc);entriesForMode().set(doc.day,doc);S.editing=false;S.dirty=false;render();status('일기를 저장했습니다 · 원본 사진은 그대로 유지돼요')}catch(e){status('일기를 저장하지 못했습니다: '+e,true)}
}
async function remove(){if(!confirm('이 날짜의 일기 내용을 삭제할까요? 원본 사진은 삭제되지 않습니다.'))return;try{const table=S.manual?'curated':'entries';await dbDelete(table,S.date);entriesForMode().delete(S.date);S.selection.clear();S.editing=false;S.dirty=false;render();status('일기 삭제 완료 · 원본 사진 보존')}catch(e){status('삭제 실패: '+e,true)}}
function openPicker(){// Avoid losing unsaved editor edits on picker round trip.
 if(S.editing&&S.dirty){const snapshot={title:$('#fd23-title')?.value,body:$('#fd23-body')?.value,tags:$('#fd23-tags')?.value,feeling:$('#fd23-feeling')?.value,activities:{}};for(const x of S.root.querySelectorAll('[data-activity-key]'))snapshot.activities[x.dataset.activityKey]=x.value;S.editorSnapshot=snapshot}else S.editorSnapshot=null;
 r197LastDayUI=r197CaptureDayUI();
 S.page='picker';S.pickerMonth=new Date(S.month);S.pickerPage=0;S.manual=true;render()}
function renderPicker(){
 const head=elem('header','fd23-top');head.append(button('‹ 일기로 돌아가기',()=>{S.page='day';render()},'soft'),elem('strong','','사진·동영상 여러 개 선택'),elem('span','fd23-chip',`${S.selection.size}개`));S.root.append(head);
 const description=elem('p','fd23-hint','기기 갤러리의 사진·동영상을 촬영일별로 표시합니다. 아래로 스크롤하면 더 불러옵니다. 원본은 복사되지 않아요.');S.root.append(description);
 const filters=elem('div','fd23-month');filters.append(button('‹',()=>pickerMonth(-1),'circle'),elem('strong','',`${S.pickerMonth.getFullYear()}년 ${S.pickerMonth.getMonth()+1}월`),button('›',()=>pickerMonth(1),'circle'));S.root.append(filters);
 const opts=elem('div','fd23-actions');opts.append(button('해당 월 전체 선택',()=>{const photos=pickerPhotos();for(const p of photos)S.selection.add(p.id);S.dirty=true;render()}),button('선택 모두 해제',()=>{S.selection.clear();S.dirty=true;render()}));S.root.append(opts);
 const photos=pickerPhotos(),limit=60;
 // Start with 60 assets, then append the next 60 to the SAME DOM grid on demand.
 // Preserve all thumbnail handlers, selection state and scroll position.
 let count=0;const total=elem('p','fd23-hint','');S.root.append(total);
 const grid=elem('div','fd23-picker-grid');S.root.append(grid);
 const allCounts=new Map();for(const p of photos){const k=dateOf(p.t);allCounts.set(k,(allCounts.get(k)||0)+1)}
 let displayedDate='';
 const paging=elem('div','fd23-actions');S.root.append(paging);
 const more=button('사진·영상 더 보기',()=>appendBatch(),'fd32-more');paging.append(more);
 const foot=elem('div','fd23-picker-foot');foot.append(elem('strong','',`선택 ${S.selection.size}개`),button('선택한 사진·동영상으로 일기 구성',()=>{S.page='day';S.editing=true;S.dirty=true;render();restoreEditor()},'primary'));S.root.append(foot);
 function appendBatch(){
  if(count>=photos.length)return;
  const end=Math.min(photos.length,count+limit),fragment=document.createDocumentFragment();
  for(const p of photos.slice(count,end)){
   const captured=dateOf(p.t);
   if(captured!==displayedDate){
    const divider=elem('div','fd23-picker-date');divider.append(elem('strong','',readable(captured)),elem('span','',`${allCounts.get(captured)||0}개 · 원본 촬영일`));fragment.append(divider);displayedDate=captured;
   }
   const tile=elem('button','fd23-pickerphoto'+(S.selection.has(p.id)?' sel':''));tile.type='button';tile.dataset.id=p.id;tile.setAttribute('aria-pressed',S.selection.has(p.id)?'true':'false');
   const image=elem('img');image.dataset.photoId=p.id;tile.append(image,elem('span','fd23-pickercheck',S.selection.has(p.id)?'✓':'+'));
   if(isVideo(p))tile.append(elem('span','fd26-picker-video','▶ '+durationText(p.duration)));
   tile.onclick=()=>{if(S.selection.has(p.id))S.selection.delete(p.id);else S.selection.add(p.id);S.dirty=true;tile.classList.toggle('sel',S.selection.has(p.id));tile.setAttribute('aria-pressed',S.selection.has(p.id)?'true':'false');tile.querySelector('.fd23-pickercheck').textContent=S.selection.has(p.id)?'✓':'+';head.querySelector('.fd23-chip').textContent=S.selection.size+'개';foot.querySelector('strong').textContent=`선택 ${S.selection.size}개`;};fragment.append(tile);
  }
  const images=[...fragment.querySelectorAll('img')];grid.append(fragment);count=end;
  total.textContent=`${photos.length.toLocaleString()}개 중 ${count.toLocaleString()}개 표시`;
  more.textContent=`사진·영상 더 보기 (${(photos.length-count).toLocaleString()}개 남음)`;
  more.hidden=count>=photos.length;
  thumbs(images,R38_BIG_THUMB);
 }
 appendBatch();
 // Only load another batch after a real scroll and when the paging sentinel
 // approaches the bottom of the visible diary panel. No scroll jumps or rerender.
 let loading=false;
 const onScroll=()=>{
  if(!S.root.contains(grid)){S.root.removeEventListener('scroll',onScroll);return;}
  if(loading||count>=photos.length)return;
  if(more.getBoundingClientRect().top>window.innerHeight+240)return;
  loading=true;appendBatch();setTimeout(()=>{loading=false},90);
 };
 S.root.addEventListener('scroll',onScroll,{passive:true});
}
function pickerPhotos(){let a=[];for(const [day,photos] of [...S.byDay,...S.byVideoDay]){const d=new Date(day+'T12:00:00');if(d.getFullYear()===S.pickerMonth.getFullYear()&&d.getMonth()===S.pickerMonth.getMonth())a.push(...photos)}return a.sort((a,b)=>b.t-a.t)}
function pickerMonth(delta){S.pickerMonth=new Date(S.pickerMonth.getFullYear(),S.pickerMonth.getMonth()+delta,1);S.pickerPage=0;render()}
function restoreEditor(){const e=S.editorSnapshot;if(!e)return;const title=$('#fd23-title'),body=$('#fd23-body'),tags=$('#fd23-tags'),feeling=$('#fd23-feeling');if(title)title.value=e.title||'';if(body)body.value=e.body||'';if(tags)tags.value=e.tags||'';if(feeling)feeling.value=e.feeling||'';for(const a of S.root.querySelectorAll('[data-activity-key]'))if(e.activities[a.dataset.activityKey])a.value=e.activities[a.dataset.activityKey];S.editorSnapshot=null}
function openGallery(photos,i){const p=photos[i];if(isVideo(p)){nav('diaryPlayVideo',{id:p.id});return}const images=photos.filter(p=>!isVideo(p)),index=images.findIndex(p=>p.id===photos[i]?.id);const fn=w.FamilyJourneyNaver?.openFullGallery;if(typeof fn==='function'&&index>=0){fn(images.map(p=>p.id),index,readable(S.date)+' · 일기');return}alert('기존 사진 확대 뷰어를 열지 못했습니다. 사진 앱에서 확인해 주세요.')}
// R75: loaded calendar covers (130px) are a legitimate preview for the
// exact same MediaStore id. Show one instantly on a day 250px card, then
// swap in a sharp thumbnail from an independent native worker. Never
// invent a thumbnail for a missing or excluded photo.
// R76: persistent, private, bounded thumbnail cache for EACH selected diary
// photo, not just the calendar's one 130px cover. Separate from diary records.
// A replacement/reused MediaStore ID is NEVER allowed to reuse an old thumb:
// the id and original capture timestamp must both match the curated source.
const R76_THUMBS_KEY='thumb-selected-r76-v1';
const R76_MAX_CHARS=5*1024*1024,R76_PER_IMAGE_CHARS=180000,R76_MAX_ENTRIES=160;
const r76Thumbs=new Map();let r76ThumbChars=0,r76SaveTimer=0,r76Saving=false,r76NeedsSave=false;
function r76Selected(id){
 id=String(id);for(const entry of S.curatedEntries.values())
  if((entry.photoIds||[]).map(String).includes(id)
    &&!(entry.removedMediaIds||[]).map(String).includes(id))return true;
 return false;
}
function r76Time(id){const item=r73Media(String(id));return item&&Number.isFinite(+item.t)?Math.trunc(+item.t):0;}
function r76Allowed(id,t){
 id=String(id);return /^(?:v[0-9]{1,18}|[0-9]{1,19})$/.test(id)
   &&r76Selected(id)&&+t>0&&Math.abs(+t-r76Time(id))<1500
   &&!(R73.confirmedMissing.has(id)&&r73Media(id)===null);
}
function r76Forget(id,write=true){
 id=String(id);const old=r76Thumbs.get(id);if(!old)return;
 r76ThumbChars-=old.image.length;r76Thumbs.delete(id);
 if(write)r76ScheduleSave();
}
function r76Remember(id,size,image){
 id=String(id);if(![130,250,400].includes(size)||typeof image!=='string'
    ||!image.startsWith('data:image/')||image.length>R76_PER_IMAGE_CHARS)return;
 const t=r76Time(id);if(!r76Allowed(id,t))return;
 const old=r76Thumbs.get(id);
 // Never replace a ready sharp image with a lower-resolution calendar preview.
 if(old&&old.size>size&&old.t===t)return;
 if(old)r76ThumbChars-=old.image.length;
 r76Thumbs.delete(id);r76Thumbs.set(id,{id,t,size,image,seen:Date.now()});
 r76ThumbChars+=image.length;
 while((r76Thumbs.size>R76_MAX_ENTRIES||r76ThumbChars>R76_MAX_CHARS)&&r76Thumbs.size){
   const first=r76Thumbs.keys().next().value;
   const drop=r76Thumbs.get(first);r76ThumbChars-=drop.image.length;r76Thumbs.delete(first);
 }
 r76ScheduleSave();
}
function r76ScheduleSave(){
 clearTimeout(r76SaveTimer);r76NeedsSave=true;
 r76SaveTimer=setTimeout(r76Flush,1700);
}
async function r76Flush(){
 if(r76Saving)return;r76Saving=true;
 try{
  while(r76NeedsSave){r76NeedsSave=false;
   await dbPut('meta',R76_THUMBS_KEY,{version:1,savedAt:Date.now(),
     items:[...r76Thumbs.values()]});}
 }catch(e){/* never obstruct a user's original diary save or preview */}
 finally{r76Saving=false;}
}
function r76Hydrate(saved){
 if(!saved||saved.version!==1||!Array.isArray(saved.items))return;
 // Filter the cache BEFORE first calendar/day render, not after async native scanning.
 for(const item of saved.items){
  if(!item||typeof item.image!=='string'||item.image.length>R76_PER_IMAGE_CHARS
    ||!item.image.startsWith('data:image/')||![130,250,400].includes(item.size)
    ||!r76Allowed(item.id,item.t))continue;
  r76Thumbs.set(String(item.id),{id:String(item.id),t:+item.t,size:item.size,
    image:item.image,seen:Number(item.seen)||0});
  r76ThumbChars+=item.image.length;
  r74Keep(item.size+':'+item.id,item.image);
  r37Remember(item.size+':'+item.id,item.image);
  if(item.size===130)r37RememberCover(String(item.id),item.image);
 }
 while((r76Thumbs.size>R76_MAX_ENTRIES||r76ThumbChars>R76_MAX_CHARS)&&r76Thumbs.size){
   const first=r76Thumbs.keys().next().value;
   r76ThumbChars-=r76Thumbs.get(first).image.length;r76Thumbs.delete(first);
 }
}
function r76PruneAfterFullIndex(){
 let changed=false;
 for(const [id,item] of [...r76Thumbs])if(!r76Allowed(id,item.t)){
  r76Forget(id,false);changed=true;
  for(const key of [130,250,400]){
   const k=key+':'+id;
   if(r74Preview.has(k)){r74PreviewBytes-=r37Bytes(r74Preview.get(k));r74Preview.delete(k);}
   if(r37Ram.has(k)){r37RamBytes-=r37Bytes(r37Ram.get(k));r37Ram.delete(k);}
  }
 }
 if(changed)r76ScheduleSave();
}
// Private debugging; no media IDs, note text, paths, images or personal details.
w.__moaR76ThumbStats=()=>({persistentCount:r76Thumbs.size,
 persistentApproxKiB:Math.round(r76ThumbChars/1024),bridge:typeof w.MoaQuickThumb?.request==='function',
 galleryScanActive:!!S.load});

function r75Peek(id,size){
 if(R73.confirmedMissing.has(id)&&r73Media(id)===null)return null;
 const exact=size+':'+id;
 const image=r74Preview.get(exact)||r37Ram.get(exact)||(size===130?r37Cover[id]:null);
 if(image)return {image,low:false};
 if(size>130){const small=r74Preview.get('130:'+id)||r37Ram.get('130:'+id)||r37Cover[id];
  if(small)return {image:small,low:true};}
 if(size===130){const big=r74Preview.get('250:'+id)||r37Ram.get('250:'+id)||r74Preview.get('400:'+id)||r37Ram.get('400:'+id);
  if(big)return {image:big,low:false};}
 return null;
}
function r75PaintMatching(id,size,x){
 id=String(id);if(typeof x!=='string'||!x.startsWith('data:image/'))return;
 if(R73.confirmedMissing.has(id)&&r73Media(id)===null)return;
 const key=size+':'+id;r74Keep(key,x);r37Remember(key,x);r76Remember(id,size,x);
 if(size===130)r37RememberCover(id,x);
 if(S.open&&S.root)for(const live of S.root.querySelectorAll('img[data-photo-id]')){
  if(!live.isConnected||String(live.dataset.photoId)!==id)continue;
  if(String(live.dataset.thumbSize||size)!==String(size))continue;
  if(live.getAttribute('src')&&live.dataset.thumbLow!=='1')continue;
  live.dataset.thumbLow='0';r37Apply(live,x,key);
 }
}
// Optional first-priority worker lives in the same APK and uses existing
// READ_MEDIA permission. If the JS interface is not attached on this One UI
// build, legacy HostActivity requests remain unchanged.
w.__moaQuickThumbResult=function(id,size,base64){
 if(!/^(?:v[0-9]{1,18}|[0-9]{1,19})$/.test(String(id)))return;
 if(![130,250,400].includes(Number(size)))return;
 r75PaintMatching(String(id),Number(size),base64);
};
async function thumbs(nodes,size){
 const arr=[...nodes].filter(n=>n.dataset.photoId&&(!n.getAttribute('src')||n.dataset.thumbLow==='1'));
 if(!arr.length)return;
 const pending=[];
 for(const n of arr){
  const id=String(n.dataset.photoId),key=size+':'+id;
  n.dataset.thumbSize=String(size);n.alt='';
  const found=r75Peek(id,size);
  if(found){n.dataset.thumbLow=found.low?'1':'0';r37Apply(n,found.image,found.low?'130:'+id:key);
    if(found.low)pending.push(n);
  }else{n.dataset.thumbLow='0';n.classList.add('fd37-pending');pending.push(n);}
 }
 if(!pending.length)return;
 const ids=[...new Set(pending.map(n=>String(n.dataset.photoId)))];
 const quick=typeof w.MoaQuickThumb?.request==='function';
 if(quick){
  for(let i=0;i<ids.length;i+=12){try{w.MoaQuickThumb.request(JSON.stringify(ids.slice(i,i+12)),size)}catch(e){}}
 }
 // The old thumbnail path is a mandatory safe fallback, but let the
 // independent quick worker deliver first when present. No extra wait if
 // the quick bridge is unavailable.
 if(quick)await new Promise(done=>setTimeout(done,220));
 if(typeof w.__requestThumbs!=='function')return;
 const still=ids.filter(id=>{
  if(R73.confirmedMissing.has(id)&&r73Media(id)===null)return false;
  return pending.some(n=>n.isConnected&&String(n.dataset.photoId)===id
    &&(!n.getAttribute('src')||n.dataset.thumbLow==='1'));
 });
 for(let i=0;i<still.length;i+=32){const batch=still.slice(i,i+32);
  try{const map=await w.__requestThumbs(batch,size);
   for(const id of batch){const x=map.get(id);
    if(x?.startsWith('data:image/'))r75PaintMatching(id,size,x);
   }
  }catch(e){}
 }
}
function loadIndex(force){if(S.load)return;S.explicitEmpty=!!force;S.load=true;R73.scanStarted=Date.now();S.req++;S.buffer=[];status('사진·동영상 촬영 날짜를 읽는 중…');const r=S.req;if(!nav('diaryIndex',{id:r,force:!!force})){S.load=false;status('Android 사진 색인 연결에 실패했습니다.',true)}setTimeout(()=>{if(S.load&&S.req===r){S.load=false;status('사진 목록 응답 지연 · 다시 읽어 주세요.',true)}},60000)}
w.__fjDiaryChunk=async(id,batch,done)=>{
 if(id!==S.req||!S.load)return;
 S.buffer.push(...(Array.isArray(batch)?batch:[]));if(!done)return;
 S.load=false;const explicitEmpty=!!S.explicitEmpty;S.explicitEmpty=false;
 const nextPhotos=S.buffer.filter(p=>!isVideo(p)),nextVideos=S.buffer.filter(isVideo);S.buffer=[];
 // On a transient MediaStore response, do NOT erase a populated gallery.
 // Explicit user-initiated full reload can still reconcile an empty library.
 if(!nextPhotos.length&&!nextVideos.length&&(S.photos.length||S.videos.length)&&!explicitEmpty){
  status('사진 목록 갱신 지연 · 이전 사진은 유지합니다.');return;
 }
 if(r37IndexIdentical(S.photos,nextPhotos)&&r37IndexIdentical(S.videos,nextVideos)){
  const oldMissing=new Set(R73.confirmedMissing);
  S.cached=true;r73ReconcileFullIndex();r74DropMissing();r76PruneAfterFullIndex();
  const changed=oldMissing.size!==R73.confirmedMissing.size||[...oldMissing].some(id=>!R73.confirmedMissing.has(id));
  if(mmEnabled)mmHandleIndex([...nextPhotos,...nextVideos]).catch(()=>{});
  if(S.open&&!S.editing&&changed)render();else if(S.open)status(metaStatus());return;
 }
 r37Snapshot();S.photos=nextPhotos;S.videos=nextVideos;updateIndex();r73ReconcileFullIndex();r74DropMissing();r76PruneAfterFullIndex();S.cached=true;
 try{await dbPut('meta','photo-index',{photos:S.photos,videos:S.videos,mediaIndexVersion:26,savedAt:Date.now()})}catch(e){}
 if(mmEnabled)mmHandleIndex([...nextPhotos,...nextVideos]).catch(()=>{});
 if(S.open)render();
};
w.__fjDiaryError=(id,e)=>{if(id!==S.req)return;S.load=false;status('사진 목록 오류: '+e,true)};
w.__fjPcImportStatus=(message)=>{if(S.open)status(String(message))};
w.__fjPcImportComplete=(result)=>{const added=Number(result&&result.imported||0),skipped=Number(result&&result.skipped||0),failed=Number(result&&result.failed||0);
 const cloudMsg=document.getElementById('sd-msg')||document.getElementById('source-msg');
 if(cloudMsg)cloudMsg.textContent='PC·클라우드 사진 가져오기: '+added+'장 추가, '+skipped+'장 건너뜀, '+failed+'장 실패. 일기에서 사진 다시 읽기로 확인하세요.';
if(added>0){status(`PC 사진 ${added}장 가져옴 · ${skipped}장 건너뜀 · ${failed}장 실패. 사진 날짜 정보를 다시 읽습니다.`);loadIndex(true)}else status(`PC 사진 가져오기 결과: ${added}장 · 건너뜀 ${skipped}장 · 실패 ${failed}장`)};
async function exportNotes(){const notes=[...S.entries.values()].sort((a,b)=>a.day.localeCompare(b.day)),curatedNotes=[...S.curatedEntries.values()].sort((a,b)=>a.day.localeCompare(b.day)),data={schema:'familyjourney-diary-v3',notes,curatedNotes,calendarCovers:S.covers,exportedAt:new Date().toISOString()};const blob=new Blob([JSON.stringify(data,null,2)],{type:'application/json'}),url=URL.createObjectURL(blob),a=elem('a');a.href=url;a.download='가족여행_일기_'+S.today+'.json';a.click();setTimeout(()=>URL.revokeObjectURL(url),6000);status('일기 글과 사진 ID 백업 요청 · 사진 원본은 포함되지 않음')}
function start(){mount();mmInstallLifecycle()}if(document.readyState==='loading')document.addEventListener('DOMContentLoaded',start);else start();
// MOA_R42_NATIVE_INBOX_V1 -- additive; NEVER disables the R42 camera-return fallback.
// Called by a native ActivityLifecycleCallbacks+WebView.evaluateJavascript handshake.
// Native draft retention: the Android side removes a draft ONLY after reading the
// matching token ack from this page, which is published after IndexedDB commit.
let mmNativeWriteQueue=Promise.resolve();
const mmNativeAckByToken=Object.create(null);
// Serialize R42 camera-return writes with native photo-note writes. Without
// this, concurrent dbGet/dbPut transactions can overwrite each other's notes.
const mmNativeR42Flush=mmFlush;
mmFlush=function(...args){
 const pending=mmNativeWriteQueue.catch(()=>{}).then(()=>mmNativeR42Flush(...args));
 mmNativeWriteQueue=pending.catch(()=>{});
 return pending;
};
w.__moaNativeAckByToken=mmNativeAckByToken;
function mmNativeCleanDraft(raw){
 if(!raw||typeof raw!=='object')return null;
 const id=String(raw.id??'');
 if(!/^(?:v[0-9]{1,18}|[0-9]{1,19})$/.test(id))return null;
 const at=Number(raw.at);
 // MediaStore timestamps are milliseconds since epoch; do not use receipt time.
 if(!Number.isSafeInteger(at)||at<946684800000||at>Date.now()+86400000)return null;
 const text=String(raw.note??'').trim().slice(0,2000);
 // The native Quick Record stores original M4A IDs in voiceRecords/voiceFileId.
 // Previous releases silently dropped them at this handshake, leaving the
 // recording above the photos or detached. Keep ONLY exact-day file IDs.
 const day=dateOf(at),voiceIds=[];
 const addVoice=(v,d)=>{
  const file=String(v||'');if(d===day&&/^[A-Za-z0-9_-]{8,90}\.m4a$/.test(file)&&!voiceIds.includes(file))voiceIds.push(file);
 };
 addVoice(raw.voiceFileId,String(raw.voiceDay||''));
 if(Array.isArray(raw.voiceRecords))for(const rec of raw.voiceRecords.slice(0,50))if(rec&&typeof rec==='object')addVoice(rec.id,String(rec.day||''));
 return {id,at,note:text,voiceIds,memoSaved:raw.memoSaved===true||text.length>0};
}
async function mmNativeSaveDraft(d){
 const day=dateOf(d.at);
 if(!day)throw new Error('native capture date invalid');
 // Never silently overwrite an in-progress editor snapshot. Retry this draft.
 if(S.editing&&S.date===day)throw new Error('diary editor active; retry on resume');
 const existing=await dbGet('curated',day)||{
  day,photoIds:[],selectionMode:'manual',title:'',body:'',tags:[],feeling:'',
  activities:{},moments:[],source:'moment-capture'
 };
 // User explicitly removed this media from the diary. Never resurrect it from
 // a still-retained native draft; original gallery file remains untouched.
 if((existing.removedMediaIds||[]).map(String).includes(d.id))return {id:d.id,ackable:true,excluded:true};
 const photoIds=[...new Set([...(existing.photoIds||[]).map(String),d.id])];
 const moments=Array.isArray(existing.moments)?existing.moments.map(m=>({...m,photoIds:[...(m.photoIds||[])]})):[];
 let target=moments.find(m=>(m.photoIds||[]).some(id=>String(id)===d.id));
 if(!target){
  target={uid:'native-'+d.id,at:d.at,photoIds:[d.id],note:'',createdAt:Date.now()};
  moments.push(target);
 }
 const prior=String(target.note||'').trim();
 if(d.voiceIds?.length){
  target.voiceIds=[...new Set([...(Array.isArray(target.voiceIds)?target.voiceIds:[]),...d.voiceIds])];
  target.updatedAt=Date.now();
 }
 // Preserve a user-edited note. A duplicate native delivery must not overwrite it.
 if(d.note && prior!==d.note && !prior.includes(d.note)){
  target.note=prior?prior+'\n'+d.note:d.note;
  target.updatedAt=Date.now();
 }
 // A native draft only adds its photo and moment. Existing title, prose,
 // activities, tags, and all other photos/moments remain untouched.
 const updated={...existing,day,photoIds,moments,updatedAt:Date.now()};
 await dbPut('curated',day,updated); // transaction oncomplete is awaited
 const confirmed=await dbGet('curated',day);
 if(!confirmed||(confirmed.photoIds||[]).map(String).indexOf(d.id)<0||
   !(confirmed.moments||[]).some(m=>(m.photoIds||[]).map(String).includes(d.id)&&(!d.note||String(m.note||'').includes(d.note))))
   throw new Error('INDEXEDDB_READBACK_NOT_CONFIRMED');
 S.curatedEntries.set(day,confirmed);r73HydrateSelected();
 mmSeen.add(d.id);mmPersist();
 return {id:d.id,ackable:d.memoSaved||Boolean(String(target.note||'').trim())};
}
w.__moaNativeSync=function(packet){
 w.__moaR60LastDelivery={at:Date.now(),state:'RECEIVED',count:0};
 let body;
 try{body=typeof packet==='string'?JSON.parse(packet):packet;}catch(e){return 'INVALID_PACKET'}
 const token=String(body?.token??'');
 if(!/^[A-Za-z0-9_-]{8,80}$/.test(token)||!Array.isArray(body?.drafts)||body.drafts.length>80)return 'INVALID_PACKET';
 const captures=body.drafts.map(mmNativeCleanDraft).filter(Boolean);
 w.__moaR60LastDelivery={at:Date.now(),state:'VALIDATING',count:captures.length};
 if(captures.length!==body.drafts.length)return 'INVALID_DRAFT';
 // Serializes concurrent native callbacks so a later write does not overwrite a
 // previous date's photoIds/moments between dbGet and dbPut.
 mmNativeWriteQueue=mmNativeWriteQueue.catch(()=>{}).then(async()=>{
  const acked=[],failed=[];
  for(const draft of captures){
   try{const done=await mmNativeSaveDraft(draft);if(done.ackable)acked.push(done.id);else failed.push({id:draft.id,reason:'MEMO_PENDING'});}
   catch(e){failed.push({id:draft.id,reason:String(e).slice(0,160)})}
  }
  mmNativeAckByToken[token]={token,acked,failed,committedAt:Date.now()};
  w.__moaR60LastDelivery={at:Date.now(),state:failed.length?'FAILED':'INDEXEDDB_COMMITTED',
   count:captures.length,acked:acked.length,failed:failed.slice(0,5)};
  // Prevent page memory growth during long recording sessions.
  const previousTokens=Object.keys(mmNativeAckByToken);
  for(let i=0;i<previousTokens.length-80;i++)delete mmNativeAckByToken[previousTokens[i]];
  if(S.open&&!S.editing){
   if(S.mode==='curated'&&S.page==='day'&&acked.length){
    // Current day timeline refreshes immediately, without leaving/re-entering.
    const day=S.date;
    const doc=S.curatedEntries.get(day);
    if(doc&&acked.some(id=>(doc.photoIds||[]).map(String).includes(String(id))))
      S.selection=new Set((doc.photoIds||[]).map(String));
   }
   render();
  }
  // Native must update the MediaStore index before photos can be displayed.
  if(acked.length&&!S.load)loadIndex(false);
 });
 return 'ACCEPTED';
};

function mmSuppressNativePrompt(covered){
 const p=mmPendingPopup;if(!p)return;
 const moment=(S.curatedEntries.get(p.day)?.moments||[]).find(x=>x.uid===p.uid);
 if(moment&&(moment.photoIds||[]).some(id=>covered.has(String(id)))){
  document.getElementById('fd41-modal')?.remove();mmPendingPopup=null;
 }
}
document.addEventListener('visibilitychange',()=>{if(!document.hidden&&S.open&&!S.editing)refreshCuratedFromDatabase().then(render)});window.addEventListener('focus',()=>{if(S.open&&!S.editing)refreshCuratedFromDatabase().then(render)});
w.__moaR73SyncDiagnostics=()=>({firstCuratedMs:R73.firstCuratedMs,lastFullScanMs:R73.lastFullScanMs,selectedMediaRefs:R73.fast.size,missingOriginalCount:R73.confirmedMissing.size});
// R195: the voice manager's "기록 위치" navigates to an existing diary item.
// It never opens a popup/viewer and NEVER guesses a photo association by time.
async function r195JumpToAudioLocation(day,fileId){
 if(!/^\d{4}-\d{2}-\d{2}$/.test(String(day))||! /^[A-Za-z0-9_-]{8,90}\.m4a$/.test(String(fileId)))return false;
 try{
  if(!S.open)await open();
  const curated=S.curatedEntries.get(day);
  const attached=(curated?.moments||[]).find(m=>(Array.isArray(m.voiceIds)?m.voiceIds:[]).map(String).includes(String(fileId)));
  const attachedId=(attached?.photoIds||[]).map(String).find(x=>!(curated?.removedMediaIds||[]).map(String).includes(x)&& (curated?.photoIds||[]).map(String).includes(x))||'';
  if(attached&&curated&&S.mode!=='curated'){S.mode='curated';}
  if(S.date!==day||S.page!=='day')chooseDay(day);
  const dayFiles=r193DayVoices(day),info=dayFiles.get(fileId);
  if(!info&&!attached)return false;
  let time=Number(info?.time)||Number(attached?.at)||0;
  const store=localStorage.getItem('moa.voice.timeline.links.v1');
  try{
   const val=JSON.parse(store||'{}')[day+'/'+fileId];
   if(/^([01]\d|2[0-3]):[0-5]\d$/.test(String(val))){
    const translated=Date.parse(day+'T'+val+':00');
    if(Number.isFinite(translated))time=translated;
   }
  }catch(e){}
  await new Promise(ok=>requestAnimationFrame(()=>requestAnimationFrame(ok)));
  let target=null;
  if(attachedId){
   const selector='.moa-r191-media-tile[data-moa-media-id="'+attachedId+'"]';
   target=S.root.querySelector(selector);
   // Existing 30-item lazy batches stay intact: only extend the target group.
   const itemTime=Number(S.byId.get(attachedId)?.t)||Number(attached?.at)||0;
   const group=[...S.root.querySelectorAll('.fd23-log')].find(n=>itemTime>=Number(n.dataset.groupStart)&&itemTime<Number(n.dataset.groupEnd));
   for(let attempt=0;!target&&group&&attempt<100;attempt++){
    const more=group.querySelector('button.fd31-more');if(!more)break;
    more.click();target=group.querySelector(selector);
   }
   if(target){
    const memo=target.querySelector('details.moa-r191-memo-fold');if(memo)memo.open=true;
   }
  }
  if(!target&&time>0){
   target=[...S.root.querySelectorAll('.fd23-log')].find(n=>time>=Number(n.dataset.groupStart)&&time<Number(n.dataset.groupEnd))||null;
  }
  if(!target){
   status('이 날짜에 연결된 사진·영상이 보이지 않습니다. 원본 음성은 그대로 보존됩니다.',true);
   return false;
  }
  r197MarkVoiceDestination(target,!!(attachedId&&target.dataset.moaMediaId===attachedId));
  return true;
 }catch(e){
  status('녹음 위치로 이동하지 못했습니다: '+String(e),true);
  return false;
 }
}
w.MoaDiaryNavigateToVoice=r195JumpToAudioLocation;
w.FamilyJourneyDiary={open,close,selectDay:chooseDay,loadIndex,suppressNativePrompt:mmSuppressNativePrompt,momentToggle:mmToggle,momentStatus:()=>({enabled:mmEnabled,armedAt:mmArmedAt,pending:!!mmPendingPopup}),get state(){return S},groups:segments,localDay:dateOf};
})(window);

// MOA_R60_NATIVE_BRIDGE_ACK_GUARD — replaces R54 compatibility wrapper only.
// ACCEPTED only means queued; a durable IDB commit is acknowledged asynchronously.
// R49 native side lacks a persistent seen tombstone: never call native.ack here.
(function(){
  let lastCommittedPayload='',inFlight=false,retryAfter=0;
  const RETRY_DELAY_MS=2000, ACK_TIMEOUT_MS=12000;
  function report(state,detail){
    window.__moaNativeSyncStatus={state,detail:String(detail||''),at:Date.now()};
  }
  function waitForCommit(token){
    return new Promise((resolve,reject)=>{
      const deadline=Date.now()+ACK_TIMEOUT_MS;
      function poll(){
        const item=window.__moaNativeAckByToken&&window.__moaNativeAckByToken[token];
        if(item){resolve(item);return}
        if(Date.now()>=deadline){reject(new Error('NO_COMMIT_ACK'));return}
        setTimeout(poll,200);
      }
      poll();
    });
  }
  async function readNative(){
    if(inFlight||Date.now()<retryAfter)return;
    try{
      const native=window.MoaMomentNative;
      if(!native||typeof native.drafts!=='function'||typeof window.__moaNativeSync!=='function'){
        report('WAIT_NATIVE_BRIDGE','native.drafts or IDB consumer not ready');return;
      }
      const drafts=JSON.parse(native.drafts()||'[]');
      if(Array.isArray(drafts)){
        const covered=new Set(drafts.map(d=>String(d?.id||'')));
        if(window.FamilyJourneyDiary?.state){
          const state=window.FamilyJourneyDiary.state;
          // Only close R42's extra popup if it is for a native-covered media ID.
          window.FamilyJourneyDiary?.suppressNativePrompt?.(covered);
        }
      }
      if(!Array.isArray(drafts)){report('INVALID_NATIVE_DRAFTS','not an array');return}
      const ready=drafts.filter(x=>x&&(x.memoSaved===true||String(x.note||'').trim().length>0)).slice(0,80);
      if(!ready.length){report('NO_SAVED_MEMO','native drafts may still be awaiting user input');return}
      const key=JSON.stringify(ready.map(x=>[x.id,x.at,String(x.note||''),x.memoSaved===true,x.voiceFileId,x.voiceRecords]));
      if(key===lastCommittedPayload)return;
      inFlight=true;
      const token='moar60_'+Date.now().toString(36)+'_'+Math.random().toString(36).slice(2,11);
      report('PENDING_COMMIT',ready.length+' drafts');
      const received=window.__moaNativeSync({token,drafts:ready});
      if(received!=='ACCEPTED')throw new Error('IDB_CONSUMER_REJECTED '+received);
      const ack=await waitForCommit(token);
      const acknowledged=new Set(Array.isArray(ack.acked)?ack.acked.map(String):[]);
      const failed=Array.isArray(ack.failed)?ack.failed:[];
      if(failed.length===0&&ready.every(x=>acknowledged.has(String(x.id)))){
        // R57 native DEX stores seen:<id> atomically with every new capture.
        // Thus ACK after a verified diary commit can remove the native draft
        // without rediscovering the same photo and generating another alert.
        // Do NOT remove a draft on ACCEPTED / failed or pending writes.
        if(typeof native.ack==='function'){
          for(const id of acknowledged){
            try{native.ack(id);}catch(e){console.warn('MOA draft cleanup after commit:',id,e);}
          }
        }
        lastCommittedPayload=key; // ONLY after IndexedDB transaction completes.
        report('COMMITTED',acknowledged.size+' records in diary');
        // A successful write is a real IndexedDB commit. Native capture alerts
        // are NOT cancelled here: existing R49 DEX owns their notifications.
      }else{
        retryAfter=Date.now()+RETRY_DELAY_MS;
        report('RETRY_PENDING',JSON.stringify(failed).slice(0,400));
      }
    }catch(e){
      retryAfter=Date.now()+RETRY_DELAY_MS;
      report('RETRY_PENDING',String(e).slice(0,300));
    }finally{inFlight=false}
  }
  window.__moaR54RefreshNative=readNative;
  document.addEventListener('visibilitychange',()=>{if(!document.hidden)setTimeout(readNative,350)});
  window.addEventListener('focus',()=>setTimeout(readNative,350));
  window.addEventListener('pageshow',()=>setTimeout(readNative,400));
  setInterval(readNative,5000);
  setTimeout(readNative,600);
})();