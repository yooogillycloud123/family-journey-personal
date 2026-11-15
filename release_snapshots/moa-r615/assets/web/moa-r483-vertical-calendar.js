/* MOA R469 | R463 Golden-additive, one shared diary/MediaStore/voice storage, UI-only additions.
 * No new IndexedDB schema; never replaces native Gallery DEX or original audio functions.
 */
(()=>{'use strict';
const KEY='moa.r469.view.v1', DB='familyjourney-diary-v1', coverKey='calendar-covers-r29', R495_SCROLL_KEY='moa.r495.calendar.scroll.v1';
const getState=()=>window.FamilyJourneyDiary?.state;
const $=(q,r=document)=>r.querySelector(q);
const valid=d=>/^\d{4}-(0[1-9]|1[0-2])-(0[1-9]|[12]\d|3[01])$/.test(d||'')&&Number.isFinite(new Date(d+'T12:00:00').getTime())&&dayOf(new Date(d+'T12:00:00'))===d;
const dayOf=d=>{const x=new Date(d);return `${x.getFullYear()}-${String(x.getMonth()+1).padStart(2,'0')}-${String(x.getDate()).padStart(2,'0')}`;};
const safeMedia=id=>/^(?:[0-9]{1,19}|v[0-9]{1,18})$/.test(String(id));
const isVideo=p=>!!p&&(p.video===true||String(p.id).startsWith('v'));
const dateLabel=d=>new Date(d+'T12:00:00').toLocaleDateString('ko-KR',{year:'numeric',month:'long',day:'numeric',weekday:'short'});
let ui={source:'curated',audioPlaying:false,open:false,page:'calendar',selected:dayOf(Date.now()),month:new Date(new Date().getFullYear(),new Date().getMonth(),1),date:'',media:[],idx:0,fast:false,tools:false,rail:false,info:false,clip:0,clips:[],voiceExpanded:false,dirty:false,photoToken:0,gesture:null,dragTarget:null,videoFallback:false,requestGeneration:0};
let view=null, observer=null, pending=0, backInstalled=false;
let r475ExitUntilHidden=false, r475AutostartScheduled=false, r475CalendarRefreshPending=false, r475LastDataKey='';
// R507 in-card high-fidelity native engine. Original R463 classes6/17 unchanged.
// The Android ContentProvider projects the original native Gallery's OWN host
// over the exact HTML photo-card bounds; WebView does not decode content:// video.
// On missing provider / unsupported activity / invalid MediaStore ID, retain the
// full R503 web presentation and never launch an unexpected fullscreen viewer.
let r507Generation=0,r507Timer=0,r507Opened=false;
// R602: nonpersonal native lifecycle reason codes to distinguish failure stages.
const r602Diag={events:[],last:'INIT',nativeOpen:false};
function r602Mark(code,extra={}){
 const row={event:String(code),at:Date.now(),...extra};
 r602Diag.last=row.event;r602Diag.events.push(row);
 if(r602Diag.events.length>24)r602Diag.events.shift();
 return row;
}
window.__moaR602JavaReport=(stage)=>r602Mark(String(stage));
window.__moaR602GalleryDiagnostic=()=>JSON.stringify({
 version:602,last:r602Diag.last,events:r602Diag.events.slice(-18),
 visibleDay:ui.open&&ui.page==='day',count:ui.media.length,
 bridge:!!window.__moaR507BridgeReady,arm:!!window.__moaR511NativeArmed,
 pending:!!window.__moaR507NativePending,opened:!!r507Opened,
 mounted:!!view?.classList.contains('moa-r507-native-mounted')});
// R594: never leave the photo day in an invisible native-owner state after
// the original Gallery has refused a media list or never mounted.
let r594NativeIndexMap=[],r594MountWatchdog=0,r594RetryUsed=false;
// R596: the saved diary entry is the ONE source of truth. The Web photo rail
// stays usable until the original Android compositor has REALLY mounted.
// The photo reader never writes/duplicates the user's curated day or M4A.
let r596WebTimer=0,r596LastState='';
function r596ClearWebTimer(){clearTimeout(r596WebTimer);r596WebTimer=0;}
function r596ShowWeb(reason){
 if(!ui.open||ui.page!=='day'||r523DayExiting||!view||view.hidden||
    view.classList.contains('moa-r507-native-mounted'))return false;
 const first=!view.classList.contains('moa-r596-web-ready');
 view.classList.add('moa-r596-web-ready');
 view.classList.remove('moa-r519-native-entering','moa-r547-native-owner');
 if(first){
  ui.tools=true;const tools=$('.moa-r469-tools',view);if(tools)tools.hidden=false;
  ui.rail=true;toggleRail();
 }
 const state=getState();const known=ui.media.filter(m=>state?.byId?.has(String(m.id))).length;
 r596LastState=reason;
 window.__moaR596GalleryStatus={reason,day:ui.date,total:ui.media.length,
  indexed:known,scanning:!!state?.load,nativeMounted:false,time:Date.now()};
 return true;
}
function r596ScheduleWeb(){
 r596ClearWebTimer();const token=r507Generation,day=ui.date;
 r596WebTimer=setTimeout(()=>{
  if(ui.open&&ui.page==='day'&&ui.date===day&&token===r507Generation&&
     !r507Opened&&!window.__moaR507NativePending&&
     !view?.classList.contains('moa-r507-native-mounted'))
    r596ShowWeb('NATIVE_OPEN_NOT_ACCEPTED');
 },5600);
}
function r596ClearWeb(){
 r596ClearWebTimer();view?.classList.remove('moa-r596-web-ready');
}

function r594ClearMountWatchdog(){clearTimeout(r594MountWatchdog);r594MountWatchdog=0;}
function r594Fallback(reason){
 if(!ui.open||ui.page!=='day'||r523DayExiting||view?.classList.contains('moa-r507-native-mounted'))return false;
 r602Mark('FALLBACK_'+reason);
 view?.classList.add('moa-r594-native-failed');
 r596ShowWeb(reason);
 window.__moaR594LastFailure={day:ui.date,reason,at:Date.now(),count:ui.media.length};
 notify('원본 갤러리 연결 중에도 저장된 사진과 바로기록을 볼 수 있어요');
 r472RefreshVisibleThumbs();
 return true;
}
function r594ClearFallback(){view?.classList.remove('moa-r594-native-failed');r596ClearWeb();r594ClearMountWatchdog();}
function r594RequestIndexOnce(){
 if(r594RetryUsed)return;
 r594RetryUsed=true;
 const st=getState();
 try{if(!st?.load)window.FamilyJourneyDiary?.loadIndex?.(false);}catch(_){ }
 const token=r507Generation,day=ui.date,started=Date.now();
 const retryAfterIndex=()=>{
  if(!ui.open||ui.page!=='day'||ui.date!==day||r523DayExiting||r507Opened||
     (token!==r507Generation&&window.__moaR507NativePending))return;
  // R594: a MediaStore scan may be slower than 1.7 seconds. Do not burn the
  // only automatic retry while the original index is still rebuilding.
  if(getState()?.load&&Date.now()-started<18000){setTimeout(retryAfterIndex,900);return;}
  window.__moaR511NativeArmed=false;window.__moaR511InlineArm=false;
  r507StartInline();
 };
 setTimeout(retryAfterIndex,1250);
}

// JS close/reopen must never be misclassified as a user Back.
window.__moaR567ProgrammaticCloseUntil=0;
let r515RecoveryAttempts=0,r515LastNativeMount=0;
let r551LostAttemptAt=0,r551LostAttempts=0;
window.__moaR551NativeLost=function(token){
 if(Number(token)!==window.__moaR527DayToken||!ui.open||ui.page!=='day'||
    r523DayExiting||r531Advanced)return false;
 const now=Date.now();
 if(now-r551LostAttemptAt<1500)return false;
 if(now-r551LostAttemptAt>15000)r551LostAttempts=0;
 r551LostAttemptAt=now;
 if(++r551LostAttempts>4){notify('갤러리 연결 상태 확인이 필요합니다. 상단 설정에서 다시 표시할 수 있습니다.');return false;}
 // Native provider already confirmed isOpen=false. Do not close a second time.
 ++r507Generation;clearTimeout(r507Timer);r507Timer=0;
 r507Opened=false;window.__moaR507NativePending=false;
 window.__moaR511InlineArm=false;window.__moaR511NativeArmed=false;
 view?.classList.remove('moa-r507-native-mounted');
 view?.classList.add('moa-r519-native-entering','moa-r547-native-owner');
 r507Timer=setTimeout(()=>{if(ui.open&&ui.page==='day'&&!r523DayExiting)r507StartInline()},260);
 return true;
};
// R519: native bridge takes ownership at day-entry; do not paint obsolete Web controls.
let r519EntryTimer=0;
// R523: distinguish deliberate day exit/native Back from media errors.
let r523DayExiting=false;
// R527: each *user-initiated* day entry owns a new native session. A Back exit
// must not poison the next calendar tile open, and a stale close callback from
// the prior native host must not exit the new day.
let r527DayToken=0;
window.__moaR527DayToken=0;
let r527GeometryPort=null, r527FrameQueued=false, r527LastSentAt=0;
let r527LastRect='';
// R543: R535's proven native card remains visible throughout scroll.
// Do NOT set its alpha to zero or replace it with an unsynchronized proxy.
function r539EndProxy(){view?.classList.remove('moa-r539-scroll-proxy');}
function r539OnDayScroll(){} // normal R527 position push is the only scroll owner
function r539WakeNative(){return window.__moaR543RepairInline?.()||false;}
window.__moaR539AppVisible=()=>false; // no unsolicited close on visibilitychange
const r527TrustedOrigin=()=>location.origin==='https://familyjourney.local';
function r527BeginDay(){
 r523DayExiting=false;r515RecoveryAttempts=0;r600RestoreAttempts=0;
 window.__moaR527DayToken=++r527DayToken;
 r527LastRect='';r539EndProxy();
}

function r527SyncGeometry(force=false){
 if(!ui.open||ui.page!=='day'||r523DayExiting||!window.__moaR507NativePending||!r527GeometryPort)return;
 if(r527FrameQueued&&!force)return;
 r527FrameQueued=true;
 requestAnimationFrame(()=>{
  r527FrameQueued=false;
  if(!ui.open||ui.page!=='day'||r523DayExiting||!window.__moaR507NativePending||!r527GeometryPort)return;
  const stage=view?.querySelector('.moa-r469-stage');if(!stage||!stage.isConnected)return;
  const rect=stage.getBoundingClientRect();
  if(rect.width<100||rect.height<100)return;
  // one-way browser scroll-frame -> native compositor position update: no
  // evaluateJavascript round trip, no tracking-poll correction/lead prediction.
  const values=[window.__moaR527DayToken,rect.left,rect.top,rect.width,rect.height,innerWidth,innerHeight];
  const key=values.map(n=>Math.round(n*10)/10).join(',');
  const now=performance.now();if(key===r527LastRect&&!force)return;
  // At 120 Hz do not discard alternate animation frames. Same-rect packets are already deduplicated.
  r527LastSentAt=now;r527LastRect=key;
  try{r527GeometryPort.postMessage(key)}catch(_){r527GeometryPort=null}
 });
}
window.addEventListener('message',ev=>{
 if(!r527TrustedOrigin()||ev.data!=='MOA_R527_POSITION_CHANNEL'||!ev.ports?.length)return;
 try{r527GeometryPort?.close()}catch(_){}
 r527GeometryPort=ev.ports[0];r527LastRect='';r527SyncGeometry(true);
},false);
window.__moaR527BridgeListenReady=true;
window.addEventListener('resize',()=>r527SyncGeometry(true),{passive:true});
window.visualViewport?.addEventListener('resize',()=>r527SyncGeometry(true),{passive:true});
// R511 pre-draw guard arm state; do not start native fullscreen before the provider is ready.
window.__moaR511InlineArm=false;window.__moaR511NativeArmed=false;
window.__moaR507NativePending=false;
// R600: a bitmap is asynchronous and is NOT evidence that native Gallery
// failed. Preserve native dock/rail and let original ImageView finish decoding.
window.__moaR596NativePhotoUnready=function(dayToken){
 if(Number(dayToken)!==window.__moaR527DayToken)return false;
 window.__moaR600NativeState={reason:'PHOTO_DECODING',dayToken,at:Date.now()};
 return true;
};
let r600RestoreAttempts=0,r600LastRestore=0;
function r600PreferNativeAfterReturn(reason){
 if(!ui.open||ui.page!=='day'||r523DayExiting||r531Advanced||
    view?.classList.contains('moa-r507-native-mounted')||
    r507Opened||window.__moaR507NativePending)return false;
 const now=Date.now();if(r600RestoreAttempts>=2||now-r600LastRestore<1300)return false;
 const token=window.__moaR527DayToken,day=ui.date;
 r600RestoreAttempts++;r600LastRestore=now;
 setTimeout(()=>{
  if(!ui.open||ui.page!=='day'||ui.date!==day||
     token!==window.__moaR527DayToken||r523DayExiting||r531Advanced||
     r507Opened||window.__moaR507NativePending||
     view?.classList.contains('moa-r507-native-mounted'))return;
  window.__moaR600NativeState={reason,at:Date.now(),attempt:r600RestoreAttempts};
  window.__moaR511InlineArm=false;window.__moaR511NativeArmed=false;
  r507StartInline();
 },430);
 return true;
}
window.__moaR507NativeMounted=function(mounted,dayToken){
 r602Mark(mounted?'NATIVE_MOUNT_ACK':'NATIVE_UNMOUNT',{hasToken:dayToken!==undefined});
 // A stale Gallery callback from an earlier date/Activity must NEVER hide
 // the current day's working photo/browser controls.
 if(dayToken!==undefined&&Number(dayToken)!==window.__moaR527DayToken)return;
 if(!ui.open||ui.page!=='day')mounted=false;
 if(view){view.classList.toggle('moa-r507-native-mounted',!!mounted);
   if(mounted){view.classList.remove('moa-r519-native-entering');view.classList.add('moa-r547-native-owner');}
   else view.classList.remove('moa-r547-native-owner','moa-r519-native-entering');}
 if(mounted){r600RestoreAttempts=0;r594ClearFallback();window.__moaR567ProgrammaticCloseUntil=0;r515RecoveryAttempts=0;r551LostAttempts=0;r515LastNativeMount=Date.now();clearTimeout(r519EntryTimer);r519EntryTimer=0;r527SyncGeometry(true);}
 if(!mounted){window.__moaR507NativePending=false;r507Opened=false;
   if(!r600PreferNativeAfterReturn('NATIVE_UNMOUNTED'))r596ShowWeb('NATIVE_UNMOUNTED');}
};
// R515: a transient Activity/WebView update must not demote the in-card native Gallery.
window.__moaR515RecoverInline=function(){
 // Never restart a native Gallery when Android Back has closed it.
 if(r523DayExiting||!ui.open||ui.page!=='day'||!window.__moaR507NativePending)return false;
 if(++r515RecoveryAttempts>2){notify('갤러리 연결 상태 확인 중 · 상단 설정에서 다시 표시할 수 있습니다.');return false;}
 r507Opened=false;window.__moaR507NativePending=false;window.__moaR511InlineArm=false;window.__moaR511NativeArmed=false;
 view?.classList.remove('moa-r507-native-mounted');
 if(view)view.classList.add('moa-r519-native-entering');
 clearTimeout(r507Timer);r507Timer=setTimeout(()=>{if(ui.open&&ui.page==='day')r507StartInline()},260);
 return true;
};
window.__moaR507NativeSelected=function(index){
 if(!ui.open||ui.page!=='day'||!window.__moaR507NativePending)return;
 const original=Number(index);const at=r594NativeIndexMap[original]??original;
 if(!Number.isSafeInteger(at)||at<0||at>=ui.media.length)return;
 if(ui.idx!==at){ui.idx=at;r472UpdatePager();}
};
// R531: the original R463 Gallery remains the only fullscreen media owner.
let r531Advanced=false;
window.__moaR539AdvancedActive=()=>r531Advanced;
window.__moaR531ShowAdvanced=function(){
 if(!ui.open||ui.page!=='day'||!ui.media.length)return false;
 const ids=ui.media.map(m=>String(m.id));
 if(ids.length>10000||ids.some(id=>!/^(?:v?[0-9]{1,18})$/.test(id)))return false;
 ++r507Generation;clearTimeout(r507Timer);r507Timer=0;
 r507Opened=false;window.__moaR507NativePending=false;window.__moaR511InlineArm=false;window.__moaR511NativeArmed=false;
 view?.classList.remove('moa-r507-native-mounted','moa-r519-native-entering');
 r531Advanced=true;
 let ok=false;try{ok=!!window.MoaLocalAudio?.openNativeGallery?.(JSON.stringify(ids),ui.idx,ui.date)}catch(e){console.warn('R531 original fullscreen gallery',e)}
 if(!ok){r531Advanced=false;setTimeout(()=>{if(ui.open&&ui.page==='day')r507StartInline()},100);}
 return ok;
};
// R539: selected index/MediaStore ID from the ORIGINAL fullscreen Gallery is
// the single source of truth when it closes, not the index at expansion time.
window.__moaR539AdvancedSelection=function(index,id){
 if(!r531Advanced||!ui.open||ui.page!=='day')return false;
 const wanted=String(id||'');let next=ui.media.findIndex(m=>String(m.id)===wanted);
 if(next<0){const i=Number(index);if(Number.isSafeInteger(i)&&i>=0&&i<ui.media.length)next=i;}
 if(next<0)return false;
 ui.idx=next;
 const track=view?.querySelector('.moa-r472-track');
 if(track&&track.clientWidth)track.scrollLeft=next*track.clientWidth;
 r472UpdatePager();r472LazyPhotos();
 return true;
};
window.__moaR531AdvancedClosed=function(){
 if(!r531Advanced)return false;
 r531Advanced=false;
 if(ui.open&&ui.page==='day'&&!r523DayExiting){r527BeginDay();setTimeout(()=>{if(ui.open&&ui.page==='day')r507StartInline()},100);}
 return true;
};
// R547: Android invokes this ONLY after confirming a genuinely unusable native
// host (not for an ordinary Back or a healthy pause/resume). Keep the day/index.
window.__moaR547RebuildDamagedHost=function(token){
 if(Number(token)!==window.__moaR527DayToken || !ui.open || ui.page!=='day' ||
    r523DayExiting || r531Advanced) return false;
 r507StopInline();r515RecoveryAttempts=0;r527BeginDay();
 if(view&&ui.media.length&&!view.classList.contains('moa-r596-web-ready')){view.classList.add('moa-r547-native-owner','moa-r519-native-entering');}
 clearTimeout(r507Timer);
 r507Timer=setTimeout(()=>{if(ui.open&&ui.page==='day'&&!r523DayExiting&&!r531Advanced)r507StartInline()},360);
 return true;
};
// R535: native Activity resume can leave the prior R463 TextureView blank/gray
// while Gallery.isOpen remains true. Restart ONLY the inline renderer, never
// reset the page/diary or fire a native day-exit/back handler.
window.__moaR535ResumeInline=function(token){return window.__moaR543RebuildInline(token);};
window.__moaR539RecoverAfterReturn=function(token){return window.__moaR543RebuildInline(token);};
window.__moaR543RebuildInline=function(token){
 if(Number(token)!==window.__moaR527DayToken||!ui.open||ui.page!=='day'||r523DayExiting||r531Advanced)return false;
 r507StopInline();r515RecoveryAttempts=0;r527BeginDay();
 if(view&&ui.media.length)view.classList.add('moa-r519-native-entering');
 clearTimeout(r507Timer);
 r507Timer=setTimeout(()=>{if(ui.open&&ui.page==='day'&&!r523DayExiting&&!r531Advanced)r507StartInline()},240);
 return true;
};
window.__moaR543RepairInline=function(){
 r594RetryUsed=false;r594ClearFallback();
 // Manual user action is a safe escape hatch if Android native TextureView
 // silently loses its surface (never auto-triggers during first mount).
 if(!ui.open||ui.page!=='day'||r523DayExiting||r531Advanced)return false;
 r507StopInline();r515RecoveryAttempts=0;r527BeginDay();
 if(view&&ui.media.length)view.classList.add('moa-r519-native-entering');
 setTimeout(()=>{if(ui.open&&ui.page==='day'&&!r523DayExiting)r507StartInline()},250);
 return true;
};
function r507StopInline(){r596ClearWebTimer();r594ClearMountWatchdog();r594NativeIndexMap=[];
 r539EndProxy();
 if(r507Opened||window.__moaR507NativePending)
   window.__moaR567ProgrammaticCloseUntil=Date.now()+850;
 ++r507Generation;clearTimeout(r507Timer);r507Timer=0;
 const opened=r507Opened;
 r507Opened=false;window.__moaR507NativePending=false;window.__moaR511InlineArm=false;window.__moaR511NativeArmed=false;
 view?.classList.remove('moa-r507-native-mounted','moa-r519-native-entering');
 // The R547 native-owner latch stays on whenever we are still in photo-day.
 if(view&&ui.open&&ui.page==='day'&&ui.media.length)view.classList.add('moa-r547-native-owner');
 clearTimeout(r519EntryTimer);r519EntryTimer=0;
 if(opened){try{window.MoaLocalAudio?.closeNativeGallery?.()}catch(e){console.warn('R507 inline close',e)}}
}
// R598: Unlike asynchronous FamilyJourneyDiary.state.byId, the ORIGINAL
// R463 Gallery.open validates a selected MediaStore URI with ContentResolver
// openFileDescriptor() BEFORE creating the native Gallery host. Trust that
// actual validation, not the stale cached-byId membership for ALL saved photos.
function r598TryOriginalGallery(ids,wanted,day){
 const target=Math.max(0,Math.min(ids.length-1,Number.isInteger(wanted)?wanted:0)),candidates=[target];
 for(let dist=1;dist<ids.length&&candidates.length<4;dist++)
  for(const index of [(target+dist)%ids.length,(target-dist+ids.length)%ids.length])
   if(!candidates.includes(index)){candidates.push(index);if(candidates.length>=4)break;}
 let attempts=0;
 for(const index of candidates){attempts++;
  try{if(window.MoaLocalAudio?.openNativeGallery?.(JSON.stringify(ids),index,day))
    return {ok:true,index,attempts};
  }catch(e){console.warn('R598 original native MediaStore read',e);}
 }
 return {ok:false,index:target,attempts};
}
function r507StartInline(){
 if(r523DayExiting||r531Advanced)return;
 // R551: a second asynchronous entry request must not restart or close an
 // original Gallery which the user is already viewing.
 if(r507Opened&&window.__moaR507NativePending)return;
 const generation=++r507Generation;
 r602Mark('START_INLINE',{count:ui.media.length});
 if(view&&ui.media.length)view.classList.add('moa-r519-native-entering');
 clearTimeout(r519EntryTimer);
 // On unsupported Android/native bridge, restore original web photo UI gracefully.
 r519EntryTimer=setTimeout(()=>{if(generation===r507Generation&&view&&!view.classList.contains('moa-r507-native-mounted'))notify('네이티브 갤러리 연결 확인 중');},3500);
 const waitUntil=Date.now()+8000;
 const tryOpen=()=>{
  if(generation!==r507Generation||!ui.open||ui.page!=='day'||view?.hidden)return;
  if(!window.__moaR507BridgeReady || typeof window.MoaLocalAudio?.openNativeGallery!=='function'){
   if(Date.now()<waitUntil)r507Timer=setTimeout(tryOpen,180);
   else {r602Mark('PROVIDER_BRIDGE_TIMEOUT');r594Fallback('BRIDGE_UNAVAILABLE');}
   return;
  }
  const ids=ui.media.map(x=>String(x.id));
  if(!ids.length||ids.length>10000||ids.some(id=>!/^(?:v?[0-9]{1,18})$/.test(id))){r594Fallback('INVALID_NATIVE_MEDIA_LIST');return;}
  if(!view?.querySelector('.moa-r469-stage')?.isConnected){
   r602Mark('NATIVE_STAGE_NOT_ATTACHED');
   r594Fallback('NATIVE_STAGE_NOT_ATTACHED');
   return;
  }
  // R598: media from Quick Record is committed to original IndexedDB before
  // WebView's separate asynchronous byId index updates. Cache absence is not
  // a missing MediaStore file; the original native Gallery checks the real URI.
  const state=getState(),uncached=ids.filter(id=>!state?.byId?.has(id));
  window.__moaR598IndexStatus={day:ui.date,total:ids.length,
    uncached:uncached.length,scanning:!!state?.load,at:Date.now()};
  window.__moaR511InlineArm=true;
  if(!window.__moaR511NativeArmed){
   // R604: restore the physically user-approved R567 open gate. BridgeReady
   // only proves the provider exists, NOT that R463 pre-draw ownership/host
   // is prepared. Never invoke openNativeGallery while the gate is false.
   if(Date.now()<waitUntil){r507Timer=setTimeout(tryOpen,70);return;}
   window.__moaR511InlineArm=false;
   r602Mark('NATIVE_ARM_TIMEOUT');
   r594Fallback('NATIVE_ARM_TIMEOUT');
   r594RequestIndexOnce();
   return;
  }
  window.__moaR507NativePending=true;
  // R594: try the EXACT original Gallery and original ID order first.
  // If any stale/provisional same-day ID makes that open fail, retry once
  // using the phone's *real* MediaStore-indexed IDs. Records stay in IDB.
  let ok=false;let map=ui.media.map((_,i)=>i);
  // Delegate readability to original Android ContentResolver instead of byId.
  // Up to three alternative selected IDs are attempted ONLY on native rejection
  // and remain within the SAME original gallery playlist.
  const nativeResult=r598TryOriginalGallery(ids,ui.idx,ui.date);
  ok=nativeResult.ok;
  window.__moaR598NativeOpen={at:Date.now(),day:ui.date,total:ids.length,
   cached:ids.length-uncached.length,attempts:nativeResult.attempts,accepted:ok};
  r602Mark(ok?'NATIVE_OPEN_ACCEPTED':'NATIVE_OPEN_REJECTED',{count:ids.length,uncached:uncached.length,tries:nativeResult.attempts});
  if(ok&&nativeResult.index!==ui.idx){ui.idx=nativeResult.index;r472UpdatePager();}
  if(!ok){
   const real=getState()?.byId;
   const kept=ui.media.map((m,i)=>({id:String(m.id),idx:i})).filter(m=>real?.has(m.id));
   if(kept.length && kept.length<ids.length){
    const safe=kept.map(m=>m.id),chosen=kept.findIndex(m=>m.idx===ui.idx);
    try{ok=!!window.MoaLocalAudio.openNativeGallery(JSON.stringify(safe),chosen<0?0:chosen,ui.date)}
    catch(e){console.warn('R594 indexed-media Gallery unavailable',e)}
    if(ok)map=kept.map(m=>m.idx);
   }
  }
  if(!ok){
   window.__moaR507NativePending=false;
   window.__moaR511InlineArm=false;
   r594Fallback('NATIVE_OPEN_REJECTED');
   r594RequestIndexOnce();
   return;
  }
  r594NativeIndexMap=map;
  r507Opened=true;
  r594ClearMountWatchdog();
  r594MountWatchdog=setTimeout(()=>{
    if(generation===r507Generation&&r507Opened&&ui.open&&ui.page==='day'&&
       !view?.classList.contains('moa-r507-native-mounted'))r594Fallback('NATIVE_MOUNT_UNCONFIRMED');
  },6500);
  // R551: the old 2700ms timer called r507StopInline() (which invokes
  // Gallery.close()) merely because the asynchronous native mounted signal
  // had not reached JS yet. On a detail↔photo or NAVER return this DESTROYED
  // a valid R463 gallery, then exposed the old Web viewer. Never close a
  // native gallery on a timer. The Java ticker retries attachment in-place.
  setTimeout(()=>{
   if(generation!==r507Generation||!r507Opened||!ui.open||ui.page!=='day')return;
   if(!view?.classList.contains('moa-r507-native-mounted')){
     if(!view?.classList.contains('moa-r596-web-ready'))
       view?.classList.add('moa-r519-native-entering','moa-r547-native-owner');
     // Keep the original Gallery host eligible for async attachment, without
     // re-locking the Web UI after its already-observed mount failure.
     window.__moaR507NativePending=true;
     window.__moaR511InlineArm=true;
   }
  },2700);
 };
 r507Timer=setTimeout(tryOpen,0);
}

// R495: user preference is additive; it does not write to original diary/Gallery databases.
const r495ScrollMode=()=>{try{return localStorage.getItem(R495_SCROLL_KEY)==='page'?'page':'flow'}catch(_){return 'flow'}};
let r495BackBinding=false,r495ScrollGesture=null,r495WheelUntil=0;
function r495SetScrollMode(mode){
 const safe=mode==='page'?'page':'flow';try{localStorage.setItem(R495_SCROLL_KEY,safe)}catch(_){}
 if(view)view.dataset.monthScroll=safe;
 document.querySelectorAll('[data-moa-r495-scroll]').forEach(x=>x.checked=x.value===safe);
 if(ui.open&&ui.page==='calendar')render();
}
function r495InstallScrollSetting(){
 const settings=document.querySelector('section.page[data-page="settings"]');
 const host=settings?.querySelector(':scope > ul.rows');
 if(!host||document.getElementById('moa-r495-scroll-setting'))return;
 const li=elem('li','moa-r495-scroll-setting');li.id='moa-r495-scroll-setting';
 const heading=elem('strong','moa-r495-scroll-label','달력 이동 방식');
 const description=elem('small','moa-r495-scroll-desc','한 달씩 이동하거나 위아래로 연속 탐색');
 const options=elem('div','moa-r495-scroll-options');options.setAttribute('role','radiogroup');options.setAttribute('aria-label','달력 이동 방식');
 for(const [val,name] of [['flow','연속 스크롤'],['page','한 달씩 이동']]){
  const label=elem('label','moa-r495-scroll-choice'),radio=elem('input');radio.type='radio';radio.name='moa-r495-month-scroll';radio.value=val;radio.dataset.moaR495Scroll='1';radio.checked=r495ScrollMode()===val;
  radio.addEventListener('change',()=>{if(radio.checked)r495SetScrollMode(val)});
  label.append(radio,elem('span','',name));options.append(label);
 }
 li.append(heading,description,options);const photo=host.querySelector('#moa-r117-photo-settings');if(photo)host.insertBefore(li,photo.nextSibling);else host.prepend(li);
 // R602: diagnosis is in SETTINGS only, never outside the Gallery/card.
 // No personal media identifiers, GPS, photos, diary text or M4A names.
 if(!document.getElementById('moa-r602-gallery-diagnostic')){
  const row=elem('li','moa-r602-gallery-diagnostic');row.id='moa-r602-gallery-diagnostic';
  const trigger=btn('원본 갤러리 진단 복사',()=>{
   const report=window.__moaR602GalleryDiagnostic?.()||'DIAGNOSTIC_UNAVAILABLE';
   try{navigator.clipboard.writeText(report).then(()=>notify('갤러리 진단 정보 복사 완료')).catch(()=>prompt('갤러리 진단 복사',report));}
   catch(_){prompt('갤러리 진단 복사',report);}
  },'moa-r602-gallery-diagnostic-copy');
  row.append(trigger,elem('small','','연결 실패 단계만 기록 · 사진과 메모 내용은 포함하지 않음'));
  li.insertAdjacentElement('afterend',row);
 }
}
function r495SyncLegacyRoot(){
 const root=diaryRoot(),s=getState();if(!root)return;
 // Prevent the older curated/automatic calendar from flashing while the single unified calendar mounts.
 // Own the calendar presentation even if the original detailed editor retains
 // its previous `page=day` state after native Gallery Back; never flash it.
 // When switching to the ORIGINAL detailed editor, close() clears this marker.
 if(s?.open&&!root.hidden&&ui.open&&ui.page==='calendar'&&!r475ExitUntilHidden)root.dataset.moaUnifiedPage='calendar';
 else delete root.dataset.moaUnifiedPage;
}
function r495TryBack(){
 if(!ui.open||document.getElementById('moa-r149-voice-modal'))return false;
 const shade=view?.querySelector('.moa-r479-picker-backdrop');if(shade){shade.remove();return true}
 return goBack();
}
function r495InstallBackHandlers(){
 // Native host versions invoke either of two callbacks; rewrap if other retained modules reassign them.
 for(const name of ['__fjBackOverlay','__photoMapBack']){
  const prev=window[name];if(typeof prev==='function'&&prev.__moaR495Back)continue;
  const wrapped=function(...args){if(r495TryBack())return true;return typeof prev==='function'?prev.apply(this,args):false};
  wrapped.__moaR495Back=true;window[name]=wrapped;
 }
 if(r495BackBinding)return;r495BackBinding=true;
 document.addEventListener('keydown',e=>{
  if(!ui.open||!['Escape','Backspace'].includes(e.key))return;
  if(e.key==='Backspace'&&e.target.closest?.('input,textarea,[contenteditable]'))return;
  if(r495TryBack()){e.preventDefault();e.stopImmediatePropagation()}
 },true);
}
function r495AttachMonthGestures(feed){
 // PAGE = one and only one month per finger gesture. FLOW stays native inertial scroll.
 feed.addEventListener('touchstart',e=>{if(r495ScrollMode()!=='page'||e.touches.length!==1)return;
  r495ScrollGesture={y:e.touches[0].clientY,at:Date.now(),startMonth:new Date(ui.month)};
 },{passive:true});
 feed.addEventListener('touchend',e=>{const g=r495ScrollGesture;r495ScrollGesture=null;
  if(!g||r495ScrollMode()!=='page'||e.changedTouches.length!==1)return;
  const dy=e.changedTouches[0].clientY-g.y;
  if(Math.abs(dy)<38)return;
  r479SwipeBlockUntil=Date.now()+500;
  ui.month=g.startMonth;
  changeMonth(dy<0?1:-1);
 },{passive:true});
 feed.addEventListener('touchcancel',()=>{r495ScrollGesture=null},{passive:true});
 feed.addEventListener('wheel',e=>{if(r495ScrollMode()!=='page')return;
  e.preventDefault();if(Date.now()<r495WheelUntil||Math.abs(e.deltaY)<8)return;
  r495WheelUntil=Date.now()+420;changeMonth(e.deltaY>0?1:-1);
 },{passive:false});
}


const elem=(tag,cls,txt)=>{const x=document.createElement(tag);if(cls)x.className=cls;if(txt!==undefined)x.textContent=txt;return x};
const btn=(label,action,cls)=>{const x=elem('button',cls,label);x.type='button';if(action)x.addEventListener('click',action);return x};
function notify(msg){const x=$('.moa-r469-status',view);if(x)x.textContent=String(msg||'');}
function nativePost(op,payload){try{if(typeof window.NativeHost?.post==='function'){window.NativeHost.post(op,JSON.stringify(payload));return true}}catch(e){}return false;}
function diaryRoot(){return document.getElementById('fj-diary-root');}
function db(){return new Promise((resolve,reject)=>{const r=indexedDB.open(DB,2);r.onsuccess=()=>resolve(r.result);r.onerror=()=>reject(r.error);r.onblocked=()=>reject(Error('기존 일기 저장소 사용 중'));});}
async function stored(table,key){const d=await db();try{return await new Promise((resolve,reject)=>{const r=d.transaction(table,'readonly').objectStore(table).get(key);r.onsuccess=()=>resolve(r.result||null);r.onerror=()=>reject(r.error);});}finally{d.close();}}
 // R592: The detailed diary owns the storage. Photo view reads that SAME day
 // from IndexedDB BEFORE opening the original native gallery. No writes.
 let r592OpenToken=0,r592RefreshBusy=false;
 async function r592HydrateDay(day){
  const [c,e]=await Promise.all([stored('curated',day),stored('entries',day)]),st=getState();if(!st)return false;
  let changed=false;
  for(const [name,rec] of [['curatedEntries',c],['entries',e]]){
   const map=st[name];if(!rec||rec.day!==day||!map)continue;const old=map.get(day);
   const mismatch=JSON.stringify(old?.photoIds||[])!==JSON.stringify(rec.photoIds||[])||
     JSON.stringify(old?.moments||[])!==JSON.stringify(rec.moments||[])||
     String(old?.body||'')!==String(rec.body||'')||old?.updatedAt!==rec.updatedAt;
   if(mismatch){map.set(day,rec);changed=true;}
  }
  return changed;
 }
 async function r592HydrateMonth(month){
  const st=getState();if(!st?.curatedEntries)return false;
  const lo=dayOf(new Date(month.getFullYear(),month.getMonth()-1,1));
  const hi=dayOf(new Date(month.getFullYear(),month.getMonth()+3,0));
  const connection=await db();let rows=[];
  try{rows=await new Promise((resolve,reject)=>{
    const request=connection.transaction('curated','readonly').objectStore('curated').getAll(IDBKeyRange.bound(lo,hi));
    request.onsuccess=()=>resolve(request.result||[]);request.onerror=()=>reject(request.error);
   });}finally{connection.close();}
  let changed=false;for(const rec of rows){if(!valid(rec?.day))continue;
   const old=st.curatedEntries.get(rec.day);
   if(JSON.stringify(old?.photoIds||[])!==JSON.stringify(rec.photoIds||[])||old?.updatedAt!==rec.updatedAt){st.curatedEntries.set(rec.day,rec);changed=true;}
  }return changed;
 }
 function r592PrepareView(){
  const token=++r592OpenToken,page=ui.page,day=ui.date,month=new Date(ui.month);
  view.replaceChildren(elem('p','moa-r592-loading','저장된 일기를 불러오는 중…'));
  let rendered=false;
  const current=()=>token===r592OpenToken&&ui.open&&ui.page===page&&(page!=='day'||ui.date===day)&&view&&!view.hidden;
  const paint=()=>{if(rendered||!current())return;rendered=true;render();};
  const fallback=setTimeout(paint,2800);
  const read=page==='day'?r592HydrateDay(day):r592HydrateMonth(month);
  Promise.resolve(read).then(()=>{
   clearTimeout(fallback);if(!current())return;
   if(!rendered)paint();else if(page==='day')r592RefreshVisibleDay();
  }).catch(e=>{clearTimeout(fallback);if(current()){console.warn('R592 IndexedDB read fallback',String(e));paint();}});
 }
 async function r592RefreshVisibleDay(){
  if(r592RefreshBusy||!ui.open||ui.page!=='day'||r523DayExiting||r531Advanced||ui.dirty)return false;
  r592RefreshBusy=true;const day=ui.date,token=r592OpenToken,previous=ui.media.map(p=>String(p.id)).join('|');
  try{await r592HydrateDay(day);
   if(token!==r592OpenToken||!ui.open||ui.page!=='day'||ui.date!==day||ui.dirty||r523DayExiting)return false;
   const next=mediaFor(day),ids=next.map(p=>String(p.id)).join('|');
   if(ids!==previous){
    // R602: A new Quick Record changes ONLY the SAME-DAY playlist.
    // render() calls r507StopInline()->MoaNativeGallery.close(), destroying
    // the working native rail, TextureView, and all eight action listeners.
    // Preserve the old native host; its provider hot-updates its ORIGINAL ids.
    const previousId=String(ui.media[ui.idx]?.id||'');
    const index=next.findIndex(p=>String(p.id)===previousId);
    ui.media=next;ui.idx=index>=0?index:Math.min(ui.idx,Math.max(0,next.length-1));
    r602Mark('SAME_DAY_LIST_CHANGED',{oldCount:previous?previous.split('|').length:0,newCount:next.length,nativeOpen:!!r507Opened});
    renderMedia();refreshVoices();r602RefreshMomentNotes();r607RefreshStoryBody();r527SyncGeometry(true);
    window.__moaR602PlaylistUpdate={day,token:window.__moaR527DayToken,ids:next.map(p=>String(p.id)),index:ui.idx,changedAt:Date.now()};
    // Only if Android has no accepted original host may we open a new one.
    if(!r507Opened&&!window.__moaR507NativePending){r594RetryUsed=false;r507StartInline();}
    return true;
   }
   refreshVoices();r602RefreshMomentNotes();r607RefreshStoryBody();return false;
  }catch(e){console.warn('R592 media refresh',String(e));return false;}
  finally{r592RefreshBusy=false;}
 }

// R607: the Quick Record canonical text is now committed in curated.body.
// Refresh ONLY this textarea when native IndexedDB ACK arrives, never repaint
// the native Gallery host, image rail, playback or the 8 action listeners.
function r607RefreshStoryBody(){
 if(!ui.open||ui.page!=='day'||ui.dirty||!view)return;
 const area=view.querySelector('.moa-r469-text');
 if(!area||document.activeElement===area)return; // never clobber live typing
 const entry=getState()?.curatedEntries?.get(ui.date)||getState()?.entries?.get(ui.date);
 const value=String(entry?.body||'');
 if(area.value!==value){area.value=value;r613AutosizeStory(area);}
}
// The original camera/QuickRecord IndexedDB writer sends this once it
// ACTUALLY commits and reads back. No polling over the camera or Gallery.
window.addEventListener('moa:native-diary-committed',event=>{
 const day=event?.detail?.day;
 if(ui.open&&ui.page==='day'&&day===ui.date&&!ui.dirty)
  Promise.resolve().then(()=>r592RefreshVisibleDay());
});
function r602RefreshMomentNotes(){
 if(!view||!ui.open||ui.page!=='day')return;
 const noteHost=view.querySelector('.moa-r469-story');if(!noteHost)return;
 const content=getState()?.curatedEntries?.get(ui.date)||getState()?.entries?.get(ui.date);
 const notes=(content?.moments||[]).filter(m=>String(m?.note||'').trim());
 let box=noteHost.querySelector('.moa-r469-moments');
 if(!notes.length){box?.remove();return;}
 if(!box){box=elem('details','moa-r469-moments');box.open=false;
  const area=noteHost.querySelector('.moa-r469-text');area?.insertAdjacentElement('afterend',box);}
 const wasOpen=box.open;
 box.replaceChildren(elem('summary','',`바로기록 · ${notes.length}개`));
 for(const m of notes)box.append(elem('p','',String(m.note)));
 box.open=wasOpen;
}

async function persist(table,key,record){const d=await db();try{await new Promise((resolve,reject)=>{const tx=d.transaction(table,'readwrite'),st=tx.objectStore(table);table==='curated'||table==='entries'?st.put(record):st.put(record,key);tx.oncomplete=resolve;tx.onerror=()=>reject(tx.error);});}finally{d.close();}}
async function mergeDiaryBody(day,body,table){if(!['curated','entries'].includes(table))throw Error('unsupported diary table');const d=await db();try{return await new Promise((resolve,reject)=>{
 const tx=d.transaction(table,'readwrite'),store=tx.objectStore(table);let result=null;
 const get=store.get(day);get.onsuccess=()=>{const original=get.result||{day,selectionMode:'manual',title:'',tags:[],feeling:'',activities:{},photoIds:[],moments:[]};
  result={...original,day,body,selectionMode:original.selectionMode||'manual',updatedAt:Date.now(),source:original.source||'owner'};
  store.put(result);};get.onerror=()=>{try{tx.abort()}catch(_){}};
 tx.oncomplete=()=>resolve(result);tx.onerror=()=>reject(tx.error);tx.onabort=()=>reject(tx.error||Error('record transaction aborted'));
 });}finally{d.close();}}

function dayEntry(day){return getState()?.curatedEntries?.get(day)||null;}
function mediaFor(day){const st=getState();if(!st)return [];
 const entry=st.curatedEntries?.get(day),hidden=new Set((entry?.removedMediaIds||[]).map(String));
 const saved=Array.isArray(entry?.photoIds)?entry.photoIds.map(String).filter(id=>safeMedia(id)&&!hidden.has(id)):[];
 const momentTimes=new Map();
 for(const moment of Array.isArray(entry?.moments)?entry.moments:[]){
  const t=Number(moment?.at);
  if(!Number.isFinite(t)||dayOf(t)!==day)continue;
  for(const id of moment.photoIds||[])if(safeMedia(id)&&!momentTimes.has(String(id)))momentTimes.set(String(id),t);
 }
 const selectedIds=[...new Set([...saved,...momentTimes.keys()].filter(id=>!hidden.has(id)))];
 const all=[...(st.byDay?.get(day)||[]),...(st.byVideoDay?.get(day)||[])];
 const byId=new Map(all.map(p=>[String(p.id),p]));
 const selected=selectedIds.map(id=>st.byId?.get(id)||byId.get(id)||({id,t:momentTimes.get(id)||Date.parse(day+'T12:00:00'),video:id.startsWith('v'),approx:true,r592Saved:true}));
 const combined=ui.source==='automatic'?[...all,...selected]:selected,seen=new Set();
 return combined.filter(p=>safeMedia(p.id)&&!hidden.has(String(p.id))&&!seen.has(String(p.id))&&seen.add(String(p.id)))
   .sort((a,b)=>(Number(a.t)||0)-(Number(b.t)||0));
}
function mainCover(day,media){const s=getState();const preferred=String(s?.covers?.[ui.source]?.[day]||'');return media.find(x=>String(x.id)===preferred)||media[0]||null;}
let r475ScheduleCache=[];let r479FamilyLocallyWritten=false,r479SwipeBlockUntil=0,r479Animating=false;
function r475Events(day){try{const f=window.MoaFamilySchedule;const e=!r479FamilyLocallyWritten&&f?.ready?f.visibleEvents:r475ScheduleCache;return Array.isArray(e)?e.filter(x=>x?.date===day):[]}catch(_){return []}}
function r475UpdateFamilyDom(){
 if(!ui.open||!view)return;
 for(const tile of view.querySelectorAll('.moa-r469-date')){
  const day=(tile.getAttribute('aria-label')||'').slice(0,10);
  const has=r475Events(day).length>0, dot=tile.querySelector('.moa-r475-event-mark');
  const lane=tile.querySelector('.moa-r483-event-lane')||tile;
  if(has&&!dot){const node=elem('span','moa-r475-event-mark');node.setAttribute('aria-label','가족 일정 있음');lane.append(node)}
  if(has&&dot&&dot.parentElement!==lane)lane.append(dot);
  if(!has&&dot)dot.remove();
 }
 const panel=$('.moa-r475-family',view);if(!panel||ui.page!=='day')return;
 const events=r475Events(ui.date),header=panel.querySelector('.moa-r475-family-top span');
 if(header)header.textContent='가족 일정'+(events.length?' · '+events.length:'');
 panel.querySelector('.moa-r475-family-list')?.remove();
 if(events.length){const list=elem('div','moa-r475-family-list');
  for(const ev of events){const row=btn('',()=>r479ScheduleEditor(ui.date,ev),'moa-r475-family-item');row.append(elem('span','moa-r475-family-time',String(ev?.allDay?'종일':ev?.start||'')),elem('span','',String(ev?.title||'일정')));list.append(row)}
  panel.append(list);
 }
}
function r479ScheduleEditor(day,existing){
 if(!valid(day))return;
 const shade=elem('div','moa-r479-picker-backdrop');shade.setAttribute('role','presentation');
 const pane=elem('section','moa-r479-picker-sheet moa-r479-schedule-sheet');pane.setAttribute('role','dialog');pane.setAttribute('aria-modal','true');pane.setAttribute('aria-label',existing?'가족 일정 확인 및 수정':'가족 일정 추가');
 const header=elem('div','moa-r479-picker-heading');header.append(elem('strong','',existing?'가족 일정':'새 가족 일정'),btn('×',()=>shade.remove(),'moa-r479-picker-close'));pane.append(header);
 const form=elem('form','moa-r479-schedule-form');
 const field=(label,type,value)=>{const row=elem('label','moa-r479-schedule-field');row.append(elem('span','',label));const input=elem('input');input.type=type;input.value=String(value||'');row.append(input);form.append(row);return input};
 const title=field('일정 이름','text',existing?.title||'');title.required=true;title.maxLength=120;
 const date=field('날짜','date',existing?.date||day);date.required=true;
 const allDayRow=elem('label','moa-r479-schedule-check');const allDay=elem('input');allDay.type='checkbox';allDay.checked=existing?.allDay??false;allDayRow.append(allDay,elem('span','','하루 종일'));form.append(allDayRow);
 const times=elem('div','moa-r479-time-fields');const start=elem('input'),end=elem('input');start.type=end.type='time';start.value=existing?.start||'09:00';end.value=existing?.end||'10:00';times.append(start,end);form.append(times);const toggleTimes=()=>{times.hidden=allDay.checked};allDay.addEventListener('change',toggleTimes);toggleTimes();
 const note=field('메모','text',existing?.note||'');
 const err=elem('p','moa-r479-form-error','');form.append(err);
 const actions=elem('div','moa-r479-form-actions');
 if(existing)actions.append(btn('삭제',async()=>{if(!confirm('해당 가족 일정만 삭제할까요?'))return;try{await r479WriteFamily('delete',existing.id);shade.remove();await r475RefreshFamily();r475UpdateFamilyDom()}catch(e){err.textContent='삭제 실패: '+String(e)}},'moa-r479-remove'));
 actions.append(btn('취소',()=>shade.remove(),'moa-r479-cancel'));const save=btn('저장',()=>form.requestSubmit(),'moa-r479-submit');actions.append(save);form.append(actions);
 form.addEventListener('submit',async e=>{e.preventDefault();if(save.disabled)return;const name=title.value.trim();if(!name||!valid(date.value)||(!allDay.checked&&start.value>end.value)){err.textContent='일정 이름·날짜·시간을 확인해 주세요.';return}
  const now=new Date().toISOString(),old=existing||{};
  const item={...old,id:old.id||((typeof crypto!=='undefined'&&crypto.randomUUID)?crypto.randomUUID():String(Date.now())+'-'+Math.random().toString(36).slice(2)),title:name,date:date.value,allDay:allDay.checked,start:allDay.checked?'':start.value,end:allDay.checked?'':end.value,who:old.who||'가족',note:note.value.trim(),tzid:old.tzid||Intl.DateTimeFormat().resolvedOptions().timeZone||'Asia/Seoul',createdAt:old.createdAt||now,updatedAt:now,revision:(Number(old.revision)||0)+1};
  save.disabled=true;try{await r479WriteFamily('put',item);shade.remove();await r475RefreshFamily();r475UpdateFamilyDom();if(ui.page==='calendar')render()}catch(ex){save.disabled=false;err.textContent='저장 실패: '+String(ex)}
 });pane.append(form);shade.append(pane);shade.addEventListener('click',e=>{if(e.target===shade)shade.remove()});view.append(shade);
}
async function r479WriteFamily(op,value){
 const d=await new Promise((resolve,reject)=>{const r=indexedDB.open('moa-family-calendar-v1',1);r.onupgradeneeded=()=>{const db=r.result;if(!db.objectStoreNames.contains('events')){const store=db.createObjectStore('events',{keyPath:'id'});store.createIndex('date','date',{unique:false})}};r.onsuccess=()=>resolve(r.result);r.onerror=()=>reject(r.error)});
 try{await new Promise((resolve,reject)=>{const tx=d.transaction('events','readwrite'),store=tx.objectStore('events');if(op==='delete')store.delete(value);else store.put(value);tx.oncomplete=resolve;tx.onerror=()=>reject(tx.error);tx.onabort=()=>reject(tx.error)});}finally{d.close()}
 r479FamilyLocallyWritten=true;
}
async function r475RefreshFamily(){
 try{
  const f=window.MoaFamilySchedule;
  if(f?.ready&&!r479FamilyLocallyWritten){r475ScheduleCache=f.visibleEvents||[];r475UpdateFamilyDom();return}
  // Avoid opening a nonexistent DB at version 1, which would break original onupgradeneeded schema creation.
  if(typeof indexedDB?.databases!=='function')return;
  const names=await indexedDB.databases();if(!names.some(x=>x.name==='moa-family-calendar-v1'))return;
  const d=await new Promise((resolve,reject)=>{const q=indexedDB.open('moa-family-calendar-v1');q.onsuccess=()=>resolve(q.result);q.onerror=()=>reject(q.error)});
  try{
   if(!d.objectStoreNames.contains('events'))return;
   r475ScheduleCache=await new Promise((resolve,reject)=>{const req=d.transaction('events','readonly').objectStore('events').getAll();req.onsuccess=()=>resolve(req.result||[]);req.onerror=()=>reject(req.error)});
  }finally{d.close()}
  r475UpdateFamilyDom();
 }catch(e){console.debug('R475 family read-only unavailable',String(e))}
}
const r472Cache=new Map();
let r472ThumbRetryTimer=0;
function r472Cached(id,size){return r472Cache.get(size+':'+id)||r472Cache.get('400:'+id)||r472Cache.get('250:'+id)||r472Cache.get('130:'+id)||null;}
function r472Store(id,size,data){if(typeof data!=='string'||!data.startsWith('data:image/'))return;
 const key=size+':'+id;r472Cache.delete(key);r472Cache.set(key,data);
 while(r472Cache.size>22)r472Cache.delete(r472Cache.keys().next().value);
}
function r472Paint(node,src){if(!node?.isConnected||!src?.startsWith('data:image/'))return;
 if(node.src!==src){node.onerror=()=>{node.classList.remove('moa-r472-image-ready');node.removeAttribute('src');r472ScheduleRetry()};node.src=src;node.classList.add('moa-r472-image-ready');const slide=node.closest('.moa-r531-video-slide');if(slide)slide.style.setProperty('--moa-r531-poster',`url("${src}")`);}
}
function r472ScheduleRetry(){if(r472ThumbRetryTimer||!ui.open||document.hidden)return;
 r472ThumbRetryTimer=setTimeout(()=>{r472ThumbRetryTimer=0;
  if(!ui.open||document.hidden)return;
  const missing=[...view.querySelectorAll('img[data-id]')].filter(x=>{
   if(!x.isConnected||Number(x.dataset.tries||0)>=6)return false;
   const month=x.closest('.moa-r483-month');if(month&&r483Feed){const r=month.getBoundingClientRect(),f=r483Feed.getBoundingClientRect();if(r.bottom<f.top-250||r.top>f.bottom+250)return false;}
   const slide=x.closest('.moa-r472-slide');
   if(slide&&Math.abs(Number(slide.dataset.idx)-ui.idx)>1)return false;
   return !x.classList.contains('moa-r472-image-ready')||!!slide&&!x.dataset.fullLoaded;
  });
  if(missing.length){const large=missing.filter(x=>x.closest('.moa-r472-slide'));
   const small=missing.filter(x=>!x.closest('.moa-r472-slide'));
   if(large.length)fillImages(large,true);if(small.length)fillImages(small,false);}

 },1600);
}
async function fillImages(targets,large=false){
 if(!targets?.length||!view)return;
 const size=large?2048:260;
 const get=window.__requestThumbs;
 const grouped=new Map();
 for(const node of targets){
  if(!node.isConnected||!safeMedia(node.dataset.id))continue;
  node.alt='';const id=node.dataset.id;
  const cached=r472Cached(id,size);
  if(cached)r472Paint(node,cached);
  if(cached&&(!large||r472Cache.has('2048:'+id)))continue
  if(Number(node.dataset.tries||0)>=6)continue;
  node.dataset.tries=String(Number(node.dataset.tries||0)+1);
  if(!grouped.has(id))grouped.set(id,[]);
  grouped.get(id).push(node);
 }
 if(!grouped.size)return;
 if(typeof get!=='function'){r472ScheduleRetry();return;}
 const keys=[...grouped.keys()];
 for(let i=0;i<keys.length;i+= (large?3:12)){
  const ids=keys.slice(i,i+(large?3:12));let got;
  const accept=got=>{for(const id of ids){const img=got instanceof Map?got.get(id):got?.[id];
   if(img?.startsWith('data:image/')){
    r472Store(id,size,img);
    for(const node of grouped.get(id)||[])if(node.dataset.id===id){if(!large&&node.closest('.moa-r472-slide')&&node.dataset.fullLoaded)continue;r472Paint(node,img);if(large)node.dataset.fullLoaded='1';}
   }
  }};
  let completed=false;
  const task=Promise.resolve().then(()=>get(ids,size)).then(x=>{completed=true;accept(x)}).catch(()=>{completed=true});
  await Promise.race([task,new Promise(resolve=>setTimeout(resolve,2500))]);
  if(!completed)r472ScheduleRetry();
 }
 const missed=[...grouped.values()].flat().filter(x=>x.isConnected&&(!x.classList.contains('moa-r472-image-ready')||large&&!x.dataset.fullLoaded));
 if(missed.length)r472ScheduleRetry();
}
function r472RefreshVisibleThumbs(){if(!ui.open||!view||view.hidden)return;
 const missing=[...view.querySelectorAll('img[data-id]')].filter(x=>{
  if(!x.isConnected||Number(x.dataset.tries||0)>=6)return false;
  const month=x.closest('.moa-r483-month');if(month&&r483Feed){const r=month.getBoundingClientRect(),f=r483Feed.getBoundingClientRect();if(r.bottom<f.top-250||r.top>f.bottom+250)return false;}
  const slide=x.closest('.moa-r472-slide');
  if(slide&&Math.abs(Number(slide.dataset.idx)-ui.idx)>1)return false;
  return !x.classList.contains('moa-r472-image-ready')||!!slide&&!x.dataset.fullLoaded;
 });
 if(missing.length){const large=missing.filter(x=>x.closest('.moa-r472-slide'));
  const small=missing.filter(x=>!x.closest('.moa-r472-slide'));
  if(large.length)fillImages(large,true);if(small.length)fillImages(small,false);}

}
window.addEventListener('pageshow',()=>{setTimeout(r472RefreshVisibleThumbs,200)},{passive:true});
window.addEventListener('resize',()=>{if(ui.open&&ui.page==='day')r613AutosizeStory($('.moa-r469-text',view));},{passive:true});
document.addEventListener('visibilitychange',()=>{if(!document.hidden){setTimeout(r472RefreshVisibleThumbs,300);setTimeout(async()=>{if(ui.open&&ui.page==='day'){await r592RefreshVisibleDay();r600PreferNativeAfterReturn('CAMERA_RETURN');}},600);}},{passive:true});

function mount(){if(view)return view;const n=elem('section','moa-r469-root');n.id='moa-r469-root';n.setAttribute('aria-label','통합 사진 일기 달력');n.hidden=true;n.addEventListener('scroll',()=>{r527SyncGeometry();window.__moaR613ScrollNavRefresh?.()}, {passive:true});n.addEventListener('click',e=>{if(Date.now()<r479SwipeBlockUntil&&e.target.closest('.moa-r469-date')){e.stopImmediatePropagation();e.preventDefault()}},true);document.body.append(n);view=n;return n;}
function open(page='calendar',day){const s=getState();if(!s?.open)return false;r594RetryUsed=false;r594ClearFallback();r527BeginDay();mount();ui.open=true;ui.page=page==='day'?'day':'calendar';ui.selected=valid(day)?day:ui.selected;ui.date=ui.selected;ui.month=new Date(ui.selected+'T12:00:00');ui.month.setDate(1);ui.idx=0;ui.fast=false;ui.tools=false;ui.rail=false;ui.voiceExpanded=false;ui.dirty=false;view.hidden=false;
 try{localStorage.setItem(KEY,'simple')}catch(e){}r495SyncLegacyRoot();r495InstallBackHandlers();r592PrepareView();r475LastDataKey=[s.curatedEntries?.size||0,s.entries?.size||0,s.byDay?.size||0,s.byVideoDay?.size||0].join(':');installBack();setTimeout(r475RefreshFamily,100);return true;}
function close(){++r592OpenToken;r594RetryUsed=false;r594ClearFallback();r507StopInline();view?.classList.remove('moa-r547-native-owner');r483ImageObserver?.disconnect();r483ImageObserver=null;r483Feed=null;window.MoaVoicePlaybackUI?.stop?.();ui.audioPlaying=false;ui.open=false;ui.requestGeneration++;if(view)view.hidden=true;window.__moaR613ScrollNavRefresh?.();r495SyncLegacyRoot();try{localStorage.removeItem(KEY)}catch(e){}return true;}
function goBack(){if(!ui.open)return false;if(ui.page==='day'){if(ui.dirty&&!confirm('작성 중인 내용이 있습니다. 저장하지 않고 돌아갈까요?'))return true;
  // Mark intentional exit BEFORE closing Gallery: native callbacks cannot
  // mistake the old closed player for a crash and auto-reopen it.
  r523DayExiting=true;
  // Hide the dormant original screen BEFORE closing the native renderer.
  // R515 closed Gallery first, exposing the old web day underneath for one frame.
  const oldRoot=diaryRoot();if(oldRoot&&!oldRoot.hidden)oldRoot.dataset.moaUnifiedPage='calendar';
  ui.page='calendar';ui.dirty=false;
  // R563: explicit Back is a definitive exit. The Java Gallery host can still
  // be open after an asynchronous native-mount status reset.
  const nativeWasPending=window.__moaR507NativePending;
  const nativeWasOpened=r507Opened;
  // R567: paint the CALENDAR under the original R463 native host FIRST.
  // Closing the host before rendering exposed the empty gray WebView stage.
  view?.classList.remove('moa-r547-native-owner');
  window.MoaVoicePlaybackUI?.stop?.();render();
  r507StopInline();
  if(nativeWasPending && !nativeWasOpened){
    try{window.MoaLocalAudio?.closeNativeGallery?.()}catch(e){console.warn('R567 day exit native close',e)}
  }
  return true;}r475ExitUntilHidden=true;close();window.FamilyJourneyDiary?.close?.(false);return true;}
// Android Gallery's original Back or the R523 overlay Back must both EXIT day.
window.__moaR523NativeClosed=function(token){
 if(token!==undefined&&Number(token)!==window.__moaR527DayToken)return false;
 if(r523DayExiting||!ui.open||ui.page!=='day')return false;
 // If the native owner was already closed by the original R463 Back, the
 // only correct action is to leave photo diary, never launch it again.
 return goBack();
};
window.__moaR523NativeBack=function(token){
 if(token!==undefined&&Number(token)!==window.__moaR527DayToken)return 'stale';
 if(!ui.open||ui.page!=='day')return 'not-open';
 // Voice/recording popups keep their original close priority.
 if(document.getElementById('moa-r149-voice-modal')){
  const h=window.__fjBackOverlay;
  if(typeof h==='function')h();
  else document.querySelector('#moa-r149-voice-modal button[aria-label*="닫기"]')?.click();
  return 'modal';
 }
 r495TryBack();
 return ui.page==='calendar'?'exit':'stay';
};
// R559 user-initiated Back is synchronous to the CURRENT photo-day.
// It is not an asynchronous old-host close event and must never be rejected
// because the Android renderer retains an older token after a re-entry.
window.__moaR559ForegroundDayBack=function(){
 if(!ui.open||ui.page!=='day')return 'not-open';
 if(document.getElementById('moa-r149-voice-modal')){
   const modal=document.getElementById('moa-r149-voice-modal');
   const button=modal.querySelector('button[aria-label*="닫기"]');
   if(button)button.click();else window.__fjBackOverlay?.();
   return 'modal';
 }
 const shade=view?.querySelector('.moa-r479-picker-backdrop');
 if(shade){shade.remove();return 'picker';}
 goBack();
 return ui.page==='calendar'?'exit':'stay';
};
// R563: original R463 Gallery's own OnBackInvokedCallback can win over the
// supplementary in-card callback and close the native host first. A foreground
// close is a user-day EXIT (R535 behavior), never a native-loss auto-reopen.
window.__moaR563ForegroundNativeClosed=function(day){
 if(Date.now()<window.__moaR567ProgrammaticCloseUntil)return 'intentional-close';
 if(r523DayExiting||!ui.open||ui.page!=='day'||r531Advanced)return 'not-open';
 // A delayed old-host callback must not exit an unrelated new diary date.
 if(day && day!==ui.date)return 'stale-day';
 return window.__moaR559ForegroundDayBack();
};
// R567: a live native host can survive Home/Recents but its WebView-mounted
// acknowledgment/position MessagePort can be lost. This restores ownership
// WITHOUT reopening/closing the original R463 Gallery or resetting index.
window.__moaR567RestoreLiveCard=function(day){
 if(!ui.open||ui.page!=='day'||r523DayExiting||r531Advanced||ui.date!==day)return false;
 r507Opened=true;window.__moaR507NativePending=true;
 window.__moaR511InlineArm=false;window.__moaR511NativeArmed=false;
 clearTimeout(r507Timer);r507Timer=0;
 if(view&&ui.media.length)view.classList.add('moa-r547-native-owner');
 window.__moaR507NativeMounted(true);
 r527LastRect='';r527SyncGeometry(true);
 return true;
};
// R567: only a Java-confirmed CLOSED/DETACHED original host can request
// a same-day rebuild. No retry loop for a live Gallery, no old Web controls.
window.__moaR567ReopenLostCard=function(day){
 if(!ui.open||ui.page!=='day'||r523DayExiting||r531Advanced||ui.date!==day)return false;
 r507StopInline();r515RecoveryAttempts=0;r527BeginDay();
 if(view&&ui.media.length)view.classList.add('moa-r519-native-entering','moa-r547-native-owner');
 r507Timer=setTimeout(()=>{if(ui.open&&ui.page==='day'&&!r523DayExiting)r507StartInline();},270);
 return true;
};
window.__moaR559RepositionNative=function(){r527SyncGeometry(true);return true;};
window.__moaR519NativeBack=window.__moaR523NativeBack;
function installBack(){if(backInstalled)return;backInstalled=true;r495InstallBackHandlers();}
function r475ModeToggle(active,onPhoto,onDetail){
 const wrap=r483Pill(active,[{key:'photo',label:'사진형'},{key:'detail',label:'상세형'}],mode=>{if(mode==='photo')onPhoto();else onDetail()},'moa-r483-day-mode');
 wrap.classList.add('moa-r475-view-toggle');return wrap;
}
// R539: both modes build precisely one shared day header from the SAME factory.
// The original R463 detailed ⋯ settings trigger remains attached and callable;
// we hide only its old visible chrome, never delete or override the menu owner.
function r539DayChrome(mode,day,onPhoto,onDetail,onSettings){
 const frame=elem('div','moa-r539-day-chrome');
 const title=elem('header','moa-r539-day-head');title.append(elem('strong','',dateLabel(day)));
 const controls=elem('div','moa-r539-day-controls');
 const switcher=r475ModeToggle(mode,onPhoto,onDetail);
 switcher.classList.add(mode==='photo'?'moa-r475-photo-switch':'moa-r475-detail-switch');
 // R607: matching switch-shaped settings button, NOT a second menu or
 // extra Web view. Preserve the exact native/detail original settings owner.
 const settings=btn('',onSettings,'moa-r539-day-settings');
 settings.dataset.moaR607Slider='1';
 settings.classList.add('moa-r615-settings-control');
 // R615 visual only; original photo/detail settings handler is untouched.
 settings.innerHTML='<svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M3 7h9m4 0h5M3 17h4m4 0h10"/><circle cx="14" cy="7" r="2"/><circle cx="9" cy="17" r="2"/></svg>';
 settings.setAttribute('aria-label','일기 보기 설정 및 관리');settings.title='일기 보기 설정';
 controls.append(switcher,settings);frame.append(title,controls);return frame;
}
function r539PhotoSettings(){
 const open=view?.querySelector('.moa-r539-photo-settings');if(open){open.remove();return}
 const controls=view?.querySelector('.moa-r539-day-controls');if(!controls)return;
 const panel=elem('div','moa-r539-photo-settings');panel.setAttribute('role','group');panel.setAttribute('aria-label','사진형 보기 설정');
 const details=btn('상세형 보기 설정',()=>{panel.remove();r475OpenDetail(ui.date);setTimeout(()=>{diaryRoot()?.querySelector('.moa-r191-day-menu-trigger')?.click();},120)},'moa-r539-settings-detail');
 panel.append(details);
 const retry=btn('갤러리 다시 표시',()=>{panel.remove();window.__moaR543RepairInline?.()},'moa-r539-settings-detail');
 panel.append(retry);controls.append(panel);
}
function r475OpenDetail(day){if(ui.dirty){notify('작성 중인 글을 먼저 저장한 뒤 상세형으로 전환해 주세요.');return;}
 // Original Diary still owns its detailed timeline/settings/data.
 // R555 must end the photo Gallery BEFORE selectDay opens the detail Gallery.
 const s=getState();if(!s)return;
 s.mode=ui.source;
 // R555: close the PHOTO-only Gallery FIRST. The original detail selectDay()
 // opens/owns the R463 Gallery; closing after selectDay() killed that new owner.
 // Suppress stale card close callbacks while changing representations.
 r523DayExiting=true;
 close();
 window.FamilyJourneyDiary?.selectDay?.(day);
 r475DecorateDetail();
}
function r475DecorateDetail(){
 const s=getState(),root=diaryRoot();if(!s?.open||s.page!=='day'||!root||root.hidden||ui.open)return;
 if(root.querySelector('.moa-r539-day-chrome'))return;
 const top=root.querySelector('.fd23-top');if(!top)return;
 const day=s.date||ui.date;
 const chrome=r539DayChrome('detail',day,()=>{
  const state=getState();if(state?.dirty&&state?.editing&&!confirm('저장하지 않은 변경사항이 있습니다. 사진형으로 이동할까요?'))return;
  if(state?.mode==='automatic'||state?.mode==='curated')ui.source=state.mode;
  open('day',state?.date||day);
 },()=>{},()=>root.querySelector('.moa-r191-day-menu-trigger')?.click());
 top.insertAdjacentElement('afterend',chrome);
}
function addMode(){
 const s=getState(),root=diaryRoot();r495SyncLegacyRoot();r495InstallBackHandlers();r495InstallScrollSetting();
 if(!s?.open||!root||root.hidden){r475ExitUntilHidden=false;return;}
 if(ui.open&&ui.page==='calendar'&&!s.load){
  const key=[s.curatedEntries?.size||0,s.entries?.size||0,s.byDay?.size||0,s.byVideoDay?.size||0].join(':');
  if(key!==r475LastDataKey&&!r475CalendarRefreshPending){r475LastDataKey=key;r475CalendarRefreshPending=true;
   setTimeout(()=>{r475CalendarRefreshPending=false;if(ui.open&&ui.page==='calendar'&&!ui.dirty)render()},240);
  }
 }
 if(s.page==='day'&&!ui.open){r475DecorateDetail();return;}
 if(s.page!=='calendar'||ui.open||r475ExitUntilHidden||r475AutostartScheduled)return;
 r475AutostartScheduled=true;
 setTimeout(()=>{r475AutostartScheduled=false;
  const current=getState(),host=diaryRoot();
  if(current?.open&&current.page==='calendar'&&host&&!host.hidden&&!ui.open&&!r475ExitUntilHidden)open('calendar',current.date||ui.selected);
 },80);
}
function sync(){if(pending)return;pending=requestAnimationFrame(()=>{pending=0;addMode();r472Nav();});}
function r472Nav(){
 const bar=document.getElementById('tabbar');if(!bar)return;
 const q=tab=>bar.querySelector(`[data-tab="${tab}"]`);
 const diary=q('diary'),map=q('home'),record=q('record'),settings=q('settings');
 if(!diary||!map||!record||!settings)return;
 const family=q('family');if(family)family.hidden=true;
 // Keep the original event handlers by moving, NOT cloning, old buttons.
 let plus=q('moa-plus');if(!plus){plus=btn('+',async()=>{
  const s=getState();const date=ui.open?ui.page==='day'?ui.date:ui.selected:(s?.page==='day'?s.date:ui.selected);
  if(!s?.open)await window.FamilyJourneyDiary?.open?.();
  if(!open('day',valid(date)?date:dayOf(Date.now())))console.warn('MOA new diary unavailable');
 },'moa-r472-bottom-plus');plus.dataset.tab='moa-plus';plus.innerHTML='<span class="moa-r472-plus-disc" aria-hidden="true">+</span>';plus.setAttribute('aria-label','선택한 날짜 사진 일기 작성');}
 const wanted=[diary,map,plus,record,settings];
 const visible=[...bar.children].filter(b=>!['family','reco','battle'].includes(b.dataset.tab));
 if(visible.some((b,i)=>b!==wanted[i])||visible.length!==wanted.length)for(const b of wanted)bar.append(b);
 // No separate family-calendar tab or old three-way diary selector is exposed.
 // Family events are rendered directly in each date cell and the date's inline agenda.
 const root=diaryRoot();root?.querySelector('.moa-r472-family-inside')?.remove();

}
function start(){mount();r495InstallBackHandlers();r495InstallScrollSetting();observer=new MutationObserver(sync);observer.observe(document.body,{childList:true,subtree:true});const root=diaryRoot();if(root)observer.observe(root,{childList:true,subtree:false,attributes:true,attributeFilter:['hidden']});sync();setTimeout(r472Nav,500);
 const bar=document.getElementById('tabbar');if(bar)bar.addEventListener('click',e=>{
  const tab=e.target.closest('button[data-tab]')?.dataset.tab;
  if(tab==='diary'){
   // R499: the original Diary tab button calls FamilyJourneyDiary.open() and paints
   // the retired two-calendar UI. Own this explicit route, even after central +.
   e.preventDefault();e.stopImmediatePropagation();
   const date=ui.page==='day'?ui.date:ui.selected;
   if(ui.open&&ui.page==='day'&&ui.dirty&&!confirm('작성 중인 내용이 있습니다. 저장하지 않고 달력으로 돌아갈까요?'))return;
   r475ExitUntilHidden=false;
   const original=getState();
   if(original?.open){
    // Preserve the original IndexedDB owner; only re-open the unified presentation.
    original.page='calendar';original.editing=false;original.dirty=false;
    open('calendar',valid(date)?date:dayOf(Date.now()));
   }else{
    Promise.resolve(window.FamilyJourneyDiary?.open?.()).then(()=>{
     r475ExitUntilHidden=false;
     const st=getState();if(st?.open)open('calendar',valid(date)?date:st.date||dayOf(Date.now()));
    }).catch(err=>console.warn('R499 diary tab open',String(err)));
   }
   return;
  }
  if(!ui.open)return;
  if(tab&&tab!=='moa-plus'){r475ExitUntilHidden=true;close();}
 },true);}

function render(){if(!ui.open||!view)return;if(r507Opened && !(r523DayExiting && ui.page==='calendar'))r507StopInline();ui.requestGeneration++;view.replaceChildren();view.dataset.page=ui.page;view.dataset.monthScroll=r495ScrollMode();requestAnimationFrame(()=>window.__moaR613ScrollNavRefresh?.());r495SyncLegacyRoot();
 ui.page==='day'?renderDay():renderMonth();view.append(elem('div','moa-r469-status',''));view.scrollTop=0;r472Nav();setTimeout(r472RefreshVisibleThumbs,600);}
function header(title,back){const h=elem('header','moa-r469-head');h.append(btn('‹',back,'moa-r469-back'),elem('strong','',title));return h;}
function r483MonthKey(date){return `${date.getFullYear()}-${String(date.getMonth()+1).padStart(2,'0')}`}
function r483MonthDate(str){const [y,m]=str.split('-').map(Number);return new Date(y,m-1,1)}
function r483JumpToMonth(y,m){
 if(y<1900||y>2100||m<0||m>11)return;
 ui.month=new Date(y,m,1);render();
}
function r479PeriodSheet(){
 if($('.moa-r479-picker-backdrop',view))return;
 let selectedYear=ui.month.getFullYear();const selectedMonth=ui.month.getMonth();
 const shade=elem('div','moa-r479-picker-backdrop');shade.setAttribute('role','presentation');
 const sheet=elem('section','moa-r479-picker-sheet moa-r483-picker-sheet');sheet.setAttribute('role','dialog');sheet.setAttribute('aria-modal','true');sheet.setAttribute('aria-label','연도와 월 이동');
 const heading=elem('div','moa-r479-picker-heading');heading.append(elem('strong','','연도 · 월 선택'),btn('×',()=>shade.remove(),'moa-r479-picker-close'));sheet.append(heading);
 const picker=elem('div','moa-r483-picker-columns'),years=elem('div','moa-r483-year-list'),months=elem('div','moa-r483-picker-months');
 years.setAttribute('role','listbox');years.setAttribute('aria-label','연도 선택');
 const updateYear=year=>{
  selectedYear=year;
  for(const b of years.children){const active=Number(b.dataset.year)===year;b.classList.toggle('active',active);b.setAttribute('aria-selected',String(active))}
  for(const b of months.children)b.classList.toggle('active',Number(b.dataset.month)===selectedMonth&&year===ui.month.getFullYear());
 };
 for(let y=1900;y<=2100;y++){
  const b=btn(String(y),()=>updateYear(y),'moa-r483-year-option'+(y===selectedYear?' active':''));b.dataset.year=String(y);b.setAttribute('role','option');b.setAttribute('aria-selected',String(y===selectedYear));years.append(b)
 }
 for(let m=0;m<12;m++){
  const b=btn(String(m+1)+'월',()=>{shade.remove();r483JumpToMonth(selectedYear,m)},'moa-r483-month-option'+(m===selectedMonth?' active':''));b.dataset.month=String(m);months.append(b)
 }
 const label=elem('div','moa-r483-picker-labels');label.append(elem('span','','연도'),elem('span','','월'));sheet.append(label);
 picker.append(years,months);sheet.append(picker);
 sheet.append(elem('p','moa-r479-picker-hint','연도와 월을 각각 스크롤해 선택할 수 있습니다.'));
 shade.append(sheet);shade.addEventListener('click',e=>{if(e.target===shade)shade.remove()});shade.addEventListener('keydown',e=>{if(e.key==='Escape'){shade.remove();e.preventDefault()}});
 view.append(shade);
 requestAnimationFrame(()=>{
  for(const panel of [years,months]){const active=panel.querySelector('.active');
   if(active)panel.scrollTop=active.offsetTop-panel.offsetTop-panel.clientHeight/2+active.clientHeight/2;
  }
 });
}
function r479SetSource(source){
 if(!['curated','automatic'].includes(source)||ui.source===source)return;
 ui.source=source;ui.idx=0;render();
}
function r483Pill(active,items,onSelect,cls){
 const wrap=elem('div','moa-r483-oval-switch '+cls);wrap.setAttribute('role','group');wrap.setAttribute('aria-label',cls==='moa-r483-photo-source'?'사진 범위 변경':'일기 보기 변경');wrap.dataset.source=active;
 const thumb=elem('span','moa-r483-thumb');thumb.setAttribute('aria-hidden','true');wrap.append(thumb);
 for(const item of items){
  const button=btn('',()=>{if(Date.now()<r479SwipeBlockUntil)return;onSelect(item.key)},'moa-r483-toggle-hit');button.dataset.option=item.key;button.setAttribute('aria-label',item.label);button.setAttribute('aria-pressed',String(item.key===active));button.title=item.label;wrap.append(button)
 }
 let begin=null;
 wrap.addEventListener('pointerdown',e=>{begin={id:e.pointerId,x:e.clientX,y:e.clientY}});
 wrap.addEventListener('pointerup',e=>{
  if(!begin||begin.id!==e.pointerId)return;const dx=e.clientX-begin.x,dy=e.clientY-begin.y;begin=null;
  if(Math.abs(dx)>15&&Math.abs(dx)>Math.abs(dy)*1.1){r479SwipeBlockUntil=Date.now()+300;onSelect(dx>0?items[1].key:items[0].key)}
 });
 wrap.addEventListener('pointercancel',()=>{begin=null});return wrap;
}
function r479SourceControl(){
 return r483Pill(ui.source,[{key:'curated',label:'내가 고른 사진'},{key:'automatic',label:'전체 사진'}],r479SetSource,'moa-r483-photo-source');
}
/* R483: Photos365-style VERTICAL calendar feed. No pointer-based horizontal month jumps. */
let r483Feed=null,r483OnScroll=0,r483ExtendBusy=false,r483ImageObserver=null;
function r483MonthSection(date){
 const y=date.getFullYear(),m=date.getMonth(),days=new Date(y,m+1,0).getDate(),offset=new Date(y,m,1).getDay();
 const section=elem('section','moa-r483-month');section.dataset.month=r483MonthKey(date);
 section.style.setProperty('--moa-r487-week-rows',String(Math.ceil((offset+days)/7)));
 section.setAttribute('aria-label',`${y}년 ${m+1}월 사진 달력`);
 section.append(elem('h2','moa-r483-month-title',`${y}년 ${m+1}월`));
 const grid=elem('div','moa-r469-month-grid');grid.setAttribute('aria-label',`${y}년 ${m+1}월 달력`);
 // R511: weekdays are a single fixed header outside the month scroll feed.
 for(let i=0;i<offset;i++)grid.append(elem('span','moa-r469-blank'));
 const prefix=`${y}-${String(m+1).padStart(2,'0')}-`;
 for(let n=1;n<=days;n++){
  const d=prefix+String(n).padStart(2,'0'),photo=mainCover(d,mediaFor(d));
  const tile=btn('',()=>{if(Date.now()<r479SwipeBlockUntil)return;ui.selected=d;ui.date=d;ui.month=new Date(y,m,1);ui.page='day';ui.idx=0;ui.fast=false;r527BeginDay();r592PrepareView()},'moa-r469-date');
  tile.setAttribute('aria-label',`${d} 일기 및 가족 일정`);tile.dataset.day=d;
  if(d===ui.selected)tile.classList.add('selected');if(d===dayOf(Date.now()))tile.classList.add('today');
  if(photo){const img=elem('img');img.dataset.id=String(photo.id);img.alt='';img.draggable=false;tile.append(img);if(isVideo(photo))tile.append(elem('span','moa-r469-video-mark','▶'))}
  tile.append(elem('span','moa-r469-day-number',n));
  const lane=elem('span','moa-r483-event-lane');lane.setAttribute('aria-hidden','true');
  if(r475Events(d).length){const mark=elem('span','moa-r475-event-mark');lane.append(mark)}
  tile.append(lane);
  if(getState()?.curatedEntries?.has(d)){const mark=elem('span','moa-r469-record-mark','•');tile.append(mark)}
  grid.append(tile);
 }
 let after=(offset+days)%7;if(after)for(;after<7;after++)grid.append(elem('span','moa-r469-blank moa-r479-trailing-blank'));
 section.append(grid);return section;
}
function r483FetchMonth(section){
 if(!section||!section.isConnected)return;
 const images=[...section.querySelectorAll('img[data-id]:not(.moa-r472-image-ready)')];
 if(images.length)fillImages(images.slice(0,32));
}
function r483SyncToolbar(){
 if(!r483Feed||!r483Feed.isConnected)return;
 const sections=[...r483Feed.children];if(!sections.length)return;
 let active=sections[0];const top=r483Feed.getBoundingClientRect().top;
 for(const section of sections){if(section.getBoundingClientRect().top<=top+78)active=section;else break}
 for(const section of sections)section.classList.toggle('moa-r511-active-month',section===active);
 const displayed=r483MonthDate(active.dataset.month),title=$('.moa-r479-period strong',view);
 if(title)title.textContent=`${displayed.getFullYear()}년 ${displayed.getMonth()+1}월`;
 ui.month=displayed;
}
function r483EnqueueMonth(direction){
 if(r483ExtendBusy||!r483Feed||!r483Feed.isConnected)return;
 const feed=r483Feed,children=[...feed.querySelectorAll(':scope > .moa-r483-month')];
 if(!children.length)return;
 r483ExtendBusy=true;
 const current=direction<0?children[0]:children[children.length-1],date=r483MonthDate(current.dataset.month);
 const news=[];
 for(let j=1;j<=2;j++){
  const next=new Date(date.getFullYear(),date.getMonth()+direction*j,1);
  if(next.getFullYear()<1900||next.getFullYear()>2100)break;
  news.push(r483MonthSection(next));
 }
 if(direction<0){
  const originalHeight=feed.scrollHeight;
  for(const section of news)feed.prepend(section);
  /* Browser preserves the visual anchor when earlier months are prepended. */
 }else for(const section of news)feed.append(section);
 // Keep a bounded render window while retaining the anchored scroll position.
 const all=[...feed.querySelectorAll(':scope > .moa-r483-month')];
 if(all.length>18){
  const remove=all.slice(direction<0?18:0,direction<0?undefined:all.length-18);
  const oldHeight=feed.scrollHeight;
  for(const section of remove){r483ImageObserver?.unobserve(section);section.remove()}
  /* Browser scroll anchoring keeps the current visible section after top-trim. */
 }
 for(const section of news)r483ImageObserver?.observe(section);
 r483ExtendBusy=false;
}
function r483HandleScroll(){
 if(!r483Feed)return;
 const feed=r483Feed;
 if(r495ScrollMode()==='page')return;
 r483SyncToolbar();
 if(feed.scrollTop+feed.clientHeight>feed.scrollHeight-360)r483EnqueueMonth(1);
 if(feed.scrollTop<340)r483EnqueueMonth(-1);
}
function renderMonth(){
 if(!getState())return;
 r483ImageObserver?.disconnect();r483ImageObserver=null;r483Feed=null;r483ExtendBusy=false;
 const toolbar=elem('div','moa-r479-calendar-toolbar');
 const period=btn('',r479PeriodSheet,'moa-r479-period');period.append(elem('strong','',`${ui.month.getFullYear()}년 ${ui.month.getMonth()+1}월`));period.setAttribute('aria-label','연도와 월 선택');period.title='연도·월 선택';toolbar.append(period);
 const right=elem('div','moa-r479-right-stack');right.append(r479SourceControl());toolbar.append(right);view.append(toolbar);
 const weekdayBar=elem('div','moa-r511-sticky-weekdays');weekdayBar.setAttribute('role','row');weekdayBar.setAttribute('aria-label','요일 고정 표시');
 for(const day of ['일','월','화','수','목','금','토'])weekdayBar.append(elem('span','moa-r511-weekday',day));view.append(weekdayBar);
 const feed=elem('div','moa-r483-month-feed');feed.setAttribute('role','region');feed.setAttribute('aria-label','요일 고정, 월별 날짜와 사진을 위아래로 스크롤');r483Feed=feed;
 const selected=new Date(ui.month.getFullYear(),ui.month.getMonth(),1);
 for(let offset=-1;offset<=2;offset++){
  const section=r483MonthSection(new Date(selected.getFullYear(),selected.getMonth()+offset,1));feed.append(section)
 }
 view.append(feed);r495AttachMonthGestures(feed);
 const todayDock=elem('div','moa-r487-today-dock');
 const todayAction=btn('',()=>{
  const today=new Date();ui.selected=dayOf(today);ui.month=new Date(today.getFullYear(),today.getMonth(),1);
  // Recreate only the calendar presentation; original diary/gallery stores stay untouched.
  render();
 },'moa-r487-today-action');
 todayAction.setAttribute('aria-label','오늘 날짜의 달력으로 이동');todayDock.append(todayAction);view.append(todayDock);
 r483ImageObserver=new IntersectionObserver(entries=>{for(const entry of entries)if(entry.isIntersecting)r483FetchMonth(entry.target)},{root:feed,rootMargin:'240px 0px'});
 for(const section of feed.children)r483ImageObserver.observe(section);
 feed.addEventListener('scroll',()=>{if(r483OnScroll)return;r483OnScroll=requestAnimationFrame(()=>{r483OnScroll=0;r483HandleScroll()})},{passive:true});
 requestAnimationFrame(()=>{
  if(!feed.isConnected)return;
  const section=feed.querySelectorAll(':scope > .moa-r483-month')[1];
  if(section)feed.scrollTop=section.offsetTop;
  r483SyncToolbar();
 });
}
function changeMonth(k){ui.month=new Date(ui.month.getFullYear(),ui.month.getMonth()+k,1);render();}
function dayMedia(index){const m=ui.media[index];return m&&safeMedia(m.id)?m:null;}
function setDay(day){if(!valid(day))return;r594RetryUsed=false;r594ClearFallback();ui.date=day;ui.selected=day;ui.page='day';ui.fast=false;ui.idx=0;ui.dirty=false;r527BeginDay();r592PrepareView();}
function r613AutosizeStory(area){if(!area||!area.isConnected)return;area.style.height='auto';area.style.height=Math.max(125,area.scrollHeight+2)+'px';}
function renderDay(){r515RecoveryAttempts=0;r495InstallBackHandlers();const d=ui.date,s=getState();if(!valid(d)||!s)return;ui.media=mediaFor(d);const chosen=mainCover(d,ui.media);const ri=ui.media.findIndex(x=>String(x.id)===String(chosen?.id));ui.idx=Math.min(ui.media.length-1,Math.max(0,ui.idx||ri));if(ui.idx===0&&ri>0)ui.idx=ri;
 const current=s.curatedEntries?.get(d)||s.entries?.get(d),wrap=elem('div','moa-r469-day');
 wrap.append(r539DayChrome('photo',d,()=>{},()=>r475OpenDetail(d),r539PhotoSettings));
 const stage=elem('div','moa-r469-stage');stage.dataset.moaStage='yes';stage.tabIndex=0;stage.setAttribute('aria-label','사진 영상 좌우로 이동');stage.append(elem('div','moa-r469-stage-media'));
 const coverStar=btn('☆',()=>{const media=dayMedia(ui.idx);if(media)saveCover(media.id)},'moa-r503-cover-star');
 coverStar.setAttribute('aria-label','현재 사진을 달력 대표 사진으로 지정');coverStar.title='달력 대표 사진으로 지정';stage.append(coverStar);
 const more=btn('···',()=>{ui.tools=!ui.tools;toggleTools()},'moa-r469-more');more.setAttribute('aria-label','사진 기능');stage.append(more);
 wrap.append(stage);
 stage.addEventListener('keydown',e=>{
  if(e.key==='ArrowLeft'){changeMedia(ui.idx-1);e.preventDefault()}
  else if(e.key==='ArrowRight'){changeMedia(ui.idx+1);e.preventDefault()}
 });
 const dots=elem('div','moa-r469-pager');wrap.append(dots);
 const tools=elem('section','moa-r469-tools');tools.hidden=!ui.tools;
 const glyph={share:'<circle cx="18" cy="5" r="2"/><circle cx="6" cy="12" r="2"/><circle cx="18" cy="19" r="2"/><path d="M8 11l8-5M8 13l8 5"/>',
  geo:'<path d="M20 10c0 5-8 12-8 12S4 15 4 10a8 8 0 1116 0z"/><circle cx="12" cy="10" r="2.5"/>',
  info:'<path d="M3 6.5l6-3 6 3 6-3v14l-6 3-6-3-6 3zM9 3.5v14M15 6.5v14"/>',
  fast:'<path d="m4 5 7 7-7 7m8-14 7 7-7 7"/>'};
 const actions=elem('div','moa-r469-actions');
 for(const [op,label] of [['share','공유'],['geo','네이버 지도'],['info','촬영 시간·주소'],['fast','빠른 스와이프 켜기/끄기']]){
  const button=btn('',null,'moa-r499-action');button.dataset.op=op;button.setAttribute('aria-label',label);
  button.innerHTML=`<svg viewBox="0 0 24 24" aria-hidden="true" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">${glyph[op]}</svg>`;actions.append(button);
 }
 // Fallback Web controls obey the same bottom-row layout as the native R535 capsule.
 const advanced=btn('',()=>{if(!view?.classList.contains('moa-r507-native-mounted'))window.MoaLocalAudio?.openNativeGallery?.(JSON.stringify(ui.media.map(m=>String(m.id))),ui.idx,ui.date)},'moa-r531-web-advanced');
 advanced.setAttribute('aria-label','원래 고급 갤러리 전체 화면 열기');
 advanced.innerHTML='<svg viewBox="0 0 24 24" aria-hidden="true" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M4 9V4h5M15 4h5v5M4 15v5h5M20 15v5h-5"/></svg>';
 actions.append(advanced);
 const info=elem('div','moa-r469-info');info.hidden=true;
 const railToggle=btn('',()=>{ui.rail=!ui.rail;toggleRail()},'moa-r469-rail-toggle');railToggle.setAttribute('aria-label','사진 썸네일 목록 펼치기');railToggle.setAttribute('aria-expanded','false');
 const rail=elem('div','moa-r469-rail');rail.hidden=true;rail.setAttribute('aria-label','날짜별 사진과 영상');
 tools.append(actions,info,railToggle,rail);
 tools.querySelector('.moa-r469-actions').addEventListener('click',onAction);wrap.append(tools);
 const story=elem('section','moa-r469-story');story.append(elem('strong','moa-r469-story-title','오늘의 이야기'));
 const area=elem('textarea','moa-r469-text');area.placeholder='오늘의 소중한 순간을 기록해 보세요.';area.value=current?.body||'';area.oninput=()=>{ui.dirty=true;r613AutosizeStory(area);};story.append(area);
 const momentNotes=(current?.moments||[]).filter(x=>String(x.note||'').trim());if(momentNotes.length){const details=elem('details','moa-r469-moments');details.open=false;details.append(elem('summary','',`바로기록 · ${momentNotes.length}개`));for(const m of momentNotes){const p=elem('p','',m.note);details.append(p)}story.append(details);}
 // R613: independent collapsible voice list, identical disclosure convention
 // to QuickRecord; original native M4A recorder remains the only recorder.
 const voicehead=elem('div','moa-r469-voice-head');
 const voiceToggle=btn('음성기록 · 0개',()=>r613ToggleVoice(),'moa-r613-voice-toggle');
 voiceToggle.setAttribute('aria-expanded','false');voiceToggle.setAttribute('aria-controls','moa-r613-voice-list');
 const recButton=btn('',()=>openNativeRecorder(),'moa-r469-record');
 recButton.innerHTML='<span class="moa-r613-rec-dot" aria-hidden="true"></span>';
 recButton.setAttribute('aria-label','새 음성 녹음 시작');recButton.title='새 음성 녹음';
 voicehead.append(voiceToggle,recButton);story.append(voicehead);
 const chooser=elem('div','moa-r613-voice-list');chooser.id='moa-r613-voice-list';chooser.hidden=true;story.append(chooser);
 const foot=elem('div','moa-r469-story-footer');foot.append(elem('span','moa-r475-save-note','이 날짜의 ‘오늘의 이야기’ 글만 저장\n음성은 녹음 완료 시 별도 저장'),btn('글 저장',()=>saveStory(),'moa-r469-save'));story.append(foot);wrap.append(story);
 const family=elem('section','moa-r475-family');const dayEvents=r475Events(d);
 const familyTop=elem('div','moa-r475-family-top');familyTop.append(elem('span','','가족 일정'+(dayEvents.length?' · '+dayEvents.length:'')));
 familyTop.append(btn('＋ 일정',()=>r479ScheduleEditor(d,null),'moa-r475-family-manage'));
 family.append(familyTop);
 if(dayEvents.length){const list=elem('div','moa-r475-family-list');dayEvents.forEach(ev=>{
  const entry=btn('',()=>r479ScheduleEditor(d,ev),'moa-r475-family-item');const time=String(ev?.allDay?'종일':ev?.start||'');
  entry.append(elem('span','moa-r475-family-time',time),elem('span','',String(ev?.title||'일정')));list.append(entry);
 });family.append(list)}
 wrap.append(family);
 const status=elem('div','moa-r469-status','');wrap.append(status);view.append(wrap);
 // Do not show the web-gallery chrome for a second while the existing native
 // Gallery is mounting. The static media poster may remain underneath.
 if(ui.media.length)view.classList.add('moa-r519-native-entering','moa-r547-native-owner');
 renderMedia();refreshVoices();if(ui.media.length){r507StartInline();}else view.classList.remove('moa-r519-native-entering');r527SyncGeometry(true);
 // Same R96 panel as detail; run after DOM append, not during Gallery host open.
 requestAnimationFrame(()=>{r613AutosizeStory(area);window.__moaR613ScrollNavRefresh?.();});}
function r472MediaSelected(index){
 if(!Number.isFinite(index)||!ui.media.length)return;
 const next=Math.max(0,Math.min(ui.media.length-1,index));
 if(next===ui.idx)return;
 const oldSlide=$(`.moa-r472-slide[data-idx="${ui.idx}"]`,view);
 const oldVideo=oldSlide?.querySelector('video');if(oldVideo){oldVideo.pause();oldVideo.removeAttribute('src');oldVideo.load();oldVideo.remove()}
 window.MoaVoicePlaybackUI?.stop?.();ui.audioPlaying=false;
 ui.idx=next;ui.info=false;
 const info=$('.moa-r469-info',view);if(info){info.hidden=true;info.replaceChildren()}
 r472UpdatePager();r472LazyPhotos();
}
function r472UpdatePager(){
 // Black video standby only. The original native player/stream is untouched.
 view?.classList.toggle('moa-r572-video-active',!!ui.media[ui.idx]&&isVideo(ui.media[ui.idx]));
 const dots=$('.moa-r469-pager',view);if(!dots)return;
 dots.replaceChildren();const count=ui.media.length;if(!count)return;
 const range=count<=9?Array.from({length:count},(_,i)=>i):Array.from({length:7},(_,i)=>Math.max(0,Math.min(count-7,ui.idx-3))+i);
 for(const i of range){const dot=btn('',()=>changeMedia(i),'moa-r469-dot'+(i===ui.idx?' active':''));dot.setAttribute('aria-label',`${i+1}번째 사진`);dots.append(dot)}
 const star=$('.moa-r503-cover-star',view),m=dayMedia(ui.idx);
 window.__moaR507CoverId=String(getState()?.covers?.[ui.source]?.[ui.date]||'');
 if(star){const active=!!m&&String(getState()?.covers?.[ui.source]?.[ui.date]||'')===String(m.id);
  star.textContent=active?'★':'☆';star.classList.toggle('active',active);
  star.setAttribute('aria-pressed',String(active));star.disabled=!m;
 }
 const fast=$('[data-op="fast"]',view);if(fast)fast.classList.toggle('active',ui.fast);
 if(ui.rail)renderRail();
}
function r472LazyPhotos(){
 const strip=$('.moa-r472-track',view);if(!strip)return;
 const files=[];
 for(let i=Math.max(0,ui.idx-1);i<=Math.min(ui.media.length-1,ui.idx+1);i++){
  const frame=strip.children[i];const img=frame?.querySelector('img[data-id]');
  if(img&&!img.dataset.fullLoaded)files.push(img);
 }
 if(files.length)fillImages(files,true);
}
function renderMedia(){
 const stage=$('.moa-r469-stage-media',view);if(!stage)return;
 stage.replaceChildren();const medias=ui.media;ui.requestGeneration++;
 if(!medias.length){stage.append(elem('div','moa-r469-empty','사진을 추가하면 여기에 표시돼요.'));r472UpdatePager();return;}
 const track=elem('div','moa-r472-track');
 track.classList.toggle('is-fast',ui.fast);track.setAttribute('aria-label','좌우로 사진·영상을 넘기는 갤러리');
 let pendingScroll=0,settleTimer=0;
 track.addEventListener('scroll',()=>{
  clearTimeout(settleTimer);
  if(ui.fast)settleTimer=setTimeout(()=>{
   if(!track.isConnected)return;const w=track.clientWidth||1;const at=Math.round(track.scrollLeft/w)*w;
   if(Math.abs(track.scrollLeft-at)>1)track.scrollTo({left:at,behavior:'smooth'});
  },170);
  if(pendingScroll)return;
  pendingScroll=requestAnimationFrame(()=>{pendingScroll=0;
   const width=track.clientWidth||1;const next=Math.max(0,Math.min(medias.length-1,Math.round(track.scrollLeft/width)));
   r472MediaSelected(next);
  });
 },{passive:true});
 track.addEventListener('click',e=>{
  if(e.target.closest('button,video,input'))return;
  if(e.target.closest('.moa-r472-slide')){ui.tools=!ui.tools;toggleTools();}
 });
 medias.forEach((m,i)=>{
  const slide=elem('div','moa-r472-slide');slide.dataset.idx=String(i);if(isVideo(m))slide.classList.add('moa-r531-video-slide');
  const image=elem('img');image.alt='';image.dataset.id=String(m.id);image.loading='lazy';
  slide.append(image);
  if(isVideo(m)){
   const play=btn('▶',()=>r499OpenOriginalGallery(m),'moa-r469-video-play');play.setAttribute('aria-label','영상 재생');slide.append(play);
   const bar=elem('div','moa-r499-video-controls');
   const launch=btn('▶',()=>r499OpenOriginalGallery(m),'moa-r499-video-play');launch.setAttribute('aria-label','영상 재생·일시정지');
   const native=btn('⛶',()=>nativePost('diaryPlayVideo',{id:String(m.id)}),'moa-r499-video-native');native.setAttribute('aria-label','기존 갤러리 영상 제어·음량·캡처 열기');
   bar.append(launch,native);slide.append(bar);
  }
  track.append(slide);
 });
 stage.append(track);
 requestAnimationFrame(()=>{if(!track.isConnected)return;track.scrollLeft=ui.idx*(track.clientWidth||1);r472LazyPhotos()});
 r472UpdatePager();
}
function changeMedia(i,origin='stage'){if(!ui.media.length)return;
 const track=$('.moa-r472-track',view);if(!track)return;
 const to=Math.max(0,Math.min(ui.media.length-1,i));
 track.scrollTo({left:to*(track.clientWidth||1),behavior:origin==='rail'?'auto':Math.abs(to-ui.idx)>2?'auto':'smooth'});
 if(origin==='rail')r499RailOrigin=true;try{r472MediaSelected(to)}finally{r499RailOrigin=false}
}

function toggleTools(){const t=$('.moa-r469-tools',view);if(t)t.hidden=!ui.tools;}
function toggleRail(){const r=$('.moa-r469-rail',view),b=$('.moa-r469-rail-toggle',view);if(r)r.hidden=!ui.rail;if(b){b.setAttribute('aria-expanded',String(ui.rail));b.setAttribute('aria-label',ui.rail?'사진 목록 접기':'사진 목록 펼치기')}if(ui.rail)renderRail();}
let r499RailSync=0,r499RailOrigin=false;
function renderRail(){const r=$('.moa-r469-rail',view);if(!r||!ui.rail)return;
 // Never recreate children during a fling; DOM replacement previously cancelled inertia and selection.
 if(r.children.length!==ui.media.length||[...r.children].some((x,i)=>x.dataset.id!==String(ui.media[i]?.id))){
  r.replaceChildren();const imgs=[];
  ui.media.forEach((m,i)=>{const tile=elem('div','moa-r469-rail-item');tile.dataset.id=String(m.id);
   const select=btn('',()=>changeMedia(i),'moa-r503-rail-select');select.setAttribute('aria-label',`${i+1}번째 사진·영상 보기`);
   const img=elem('img');img.dataset.id=String(m.id);select.append(img);
   if(isVideo(m))select.append(elem('small','','▶'));
   const star=btn('☆',()=>saveCover(m.id),'moa-r503-rail-star');star.setAttribute('aria-label',`${i+1}번째 사진을 달력 대표로 지정`);
   star.setAttribute('aria-pressed','false');star.title='달력 대표 지정';
   tile.append(select,star);r.append(tile);imgs.push(img)});
  fillImages(imgs);
  if(!r.dataset.synced){r.dataset.synced='1';let nextFrame=0;
   r.addEventListener('scroll',()=>{if(r499RailSync||nextFrame)return;nextFrame=requestAnimationFrame(()=>{nextFrame=0;if(!ui.rail||!ui.open)return;
    const center=r.scrollLeft+r.clientWidth/2,items=[...r.children];if(!items.length)return;
    let index=0,dist=Infinity;items.forEach((x,i)=>{const d=Math.abs(x.offsetLeft+x.offsetWidth/2-center);if(d<dist){dist=d;index=i}});
    if(index!==ui.idx)changeMedia(index,'rail');
   })},{passive:true});
  }
 }
 for(const [i,x] of [...r.children].entries()){
  x.classList.toggle('active',i===ui.idx);
  const cover=x.querySelector('.moa-r503-rail-star');if(cover){
   const selected=String(getState()?.covers?.[ui.source]?.[ui.date]||'')===String(ui.media[i]?.id);
   cover.classList.toggle('active',selected);cover.textContent=selected?'★':'☆';cover.setAttribute('aria-pressed',String(selected));
  }
 }
 if(!r.dataset.lastIndex||Number(r.dataset.lastIndex)!==ui.idx){r.dataset.lastIndex=String(ui.idx);
  r499RailSync+=Number(!r499RailOrigin);const x=r.children[ui.idx];if(x&&!r499RailOrigin){const center=x.offsetLeft+x.offsetWidth/2-r.clientWidth/2;
    r.scrollTo({left:Math.max(0,center),behavior:'auto'});}
  if(!r499RailOrigin)requestAnimationFrame(()=>{r499RailSync=Math.max(0,r499RailSync-1)});
 }
}
async function onAction(e){const op=e.target.closest('button[data-op]')?.dataset.op,m=dayMedia(ui.idx);if(!op||!m)return;
 if(op==='fast'){ui.fast=!ui.fast;const track=$('.moa-r472-track',view);if(track)track.classList.toggle('is-fast',ui.fast);r472UpdatePager();notify(ui.fast?'빠른 연속 넘기기 ON':'한 장씩 넘기기 OFF');return}
 if(op==='share'){if(!nativePost(isVideo(m)?'diaryShareVideo':'sharePhoto',{id:String(m.id)}))notify('Android 공유 기능을 연결할 수 없습니다.');return}
 if(op==='cover'){await saveCover(m.id);return}
 if(op==='geo'){r503OpenNaverLocation(m);return;}
 if(op==='info'){const pane=$('.moa-r469-info',view);if(!pane)return;ui.info=!ui.info;pane.hidden=!ui.info;if(ui.info){pane.replaceChildren(elem('p','',`촬영: ${new Date(Number(m.t)||Date.now()).toLocaleString('ko-KR')}`));try{window.FamilyJourneyDiaryGeo?.attach?.(pane,String(m.id))}catch(e){}}return;}
}

function r503OpenNaverLocation(media){
 const pane=$('.moa-r469-info',view);if(!pane||!media)return;
 pane.hidden=false;pane.replaceChildren();ui.info=true;
 if(typeof window.FamilyJourneyDiaryGeo?.attach!=='function'){
  pane.textContent='원본 GPS 위치 기능을 사용할 수 없습니다.';return;
 }
 const mediaId=String(media.id);let finished=false;
 const findNativeMap=()=>{
  if(finished||!pane.isConnected||String(dayMedia(ui.idx)?.id)!==mediaId)return false;
  const b=[...pane.querySelectorAll('button')].find(x=>x.textContent?.trim()==='네이버지도');
  if(b){finished=true;observer.disconnect();b.click();return true}
  if(/촬영 위치 정보 없음|bridge_unavailable/.test(pane.textContent||'')){
   finished=true;observer.disconnect();return true;
  }
  return false;
 };
 const observer=new MutationObserver(findNativeMap);observer.observe(pane,{childList:true,subtree:true});
 try{window.FamilyJourneyDiaryGeo.attach(pane,mediaId);}catch(e){observer.disconnect();pane.textContent='GPS 위치 확인 중 오류가 발생했습니다.';return;}
 findNativeMap();setTimeout(()=>{if(!finished){finished=true;observer.disconnect();}},6000);
}
async function saveCover(id){const s=getState();if(!s?.covers)return;const covers=s.covers;const source=ui.source;const old=covers[source]?.[ui.date];if(!covers[source])covers[source]={};covers[source][ui.date]=String(id);
 try{await persist('meta',coverKey,covers);window.__moaR507CoverId=String(id);notify('대표 사진이 달력 표지로 저장됐습니다.');r472UpdatePager();}catch(e){if(old===undefined)delete covers[source][ui.date];else covers[source][ui.date]=old;notify('대표 사진 저장 실패: '+String(e))}}
async function saveStory(){const s=getState();if(!s)return;const textarea=$('.moa-r469-text',view);if(!textarea)return;const text=textarea.value.trim(),day=ui.date;
 try{const table=s.curatedEntries?.has(day)?'curated':s.entries?.has(day)?'entries':'curated';const updated=await mergeDiaryBody(day,text,table);(table==='curated'?s.curatedEntries:s.entries).set(day,updated);ui.dirty=false;notify('기존 일기 저장소에 저장했습니다. 바로기록·시간대별 기록은 보존됩니다.');}
 catch(e){notify('저장 실패: '+String(e))}
}

function r499OpenOriginalGallery(media){
 if(!media)return;
 if(isVideo(media)){if(!nativePost('diaryPlayVideo',{id:String(media.id)}))playInlineVideo(media);return;}
 const list=ui.media.filter(p=>!isVideo(p)&&safeMedia(p.id));
 const index=list.findIndex(p=>String(p.id)===String(media.id));
 const owner=window.FamilyJourneyNaver?.openFullGallery;
 if(typeof owner==='function'&&index>=0){owner(list.map(p=>String(p.id)),index,dateLabel(ui.date));return}
 notify('사진 확대를 열 수 없습니다. 원본 사진 갤러리에서 확인해 주세요.');
}
function parseVoices(){let list=[];try{list=JSON.parse(window.MoaLocalAudio?.list?.(ui.date)||'[]')}catch(e){}
 return (Array.isArray(list)?list:[]).filter(x=>/^[A-Za-z0-9_-]{8,90}\.m4a$/.test(String(x?.id||''))).sort((a,b)=>(Number(a.time)||0)-(Number(b.time)||0));}
function r613VoiceTime(seconds){const n=Math.max(0,Math.floor(Number(seconds)||0));return String(Math.floor(n/60)).padStart(2,'0')+':'+String(n%60).padStart(2,'0')}
function r613ToggleVoice(){ui.voiceExpanded=!ui.voiceExpanded;const panel=$('.moa-r613-voice-list',view),button=$('.moa-r613-voice-toggle',view);if(panel)panel.hidden=!ui.voiceExpanded;if(button)button.setAttribute('aria-expanded',String(ui.voiceExpanded));refreshVoices();}
function refreshVoices(){
 ui.clips=parseVoices();ui.clip=Math.max(0,Math.min(ui.clips.length-1,ui.clip));
 const toggle=$('.moa-r613-voice-toggle',view),list=$('.moa-r613-voice-list',view);
 if(toggle){toggle.textContent=`음성기록 · ${ui.clips.length}개`;toggle.setAttribute('aria-expanded',String(ui.voiceExpanded));}
 if(!list)return;list.hidden=!ui.voiceExpanded;if(!ui.voiceExpanded)return;
 // Preserve playing original control objects on no-data-change refresh.
 const signature=ui.date+':'+ui.clips.map(x=>String(x.id)).join('|');
 if(list.dataset.signature===signature){window.MoaVoicePlaybackUI?.updatePlayback?.();return;}
 list.dataset.signature=signature;list.replaceChildren();
 if(!ui.clips.length){list.append(elem('p','moa-r613-voice-empty','이 날짜에 저장된 음성이 없습니다.'));return;}
 const state=getState(),entry=state?.curatedEntries?.get(ui.date)||state?.entries?.get(ui.date);
 for(const [index,clip] of ui.clips.entries()){
  const id=String(clip.id),note=window.MoaVoicePlaybackUI?.metaFor?.(ui.date,id)||{};
  const title=String(note.title||`녹음 ${index+1}`);
  const transcript=String(note.transcript||note.autoTranscript||note.captureNote||
    (entry?.moments||[]).find(m=>(m.voiceIds||[]).includes(id))?.note||'').trim();
  const row=elem('article','moa-r613-voice-card');
  row.append(elem('strong','moa-r613-voice-title',title),elem('small','moa-r613-voice-date',new Date(Number(clip.time)||Date.now()).toLocaleTimeString('ko-KR',{hour:'numeric',minute:'2-digit'})));
  // Original audio PlaybackUI is the sole authority for playback/pause,
  // native elapsed time and total length. Do not add a second HTML player.
  const play=btn('▶ 00:00 / --:--',()=>window.MoaVoicePlaybackUI?.play?.(ui.date,id,play),'moa-r613-voice-play');
  play.dataset.moaAudioPlay=ui.date+'/'+id;play.dataset.moaAudioTitle=title;play.dataset.moaAudioCompact='true';
  play.setAttribute('aria-label',title+' 재생 및 일시정지');
  row.append(play);
  const remaining=elem('small','moa-r613-voice-remaining','남은 --:--');remaining.dataset.moaVoiceRemaining=id;row.append(remaining);
  row.append(elem('p','moa-r613-voice-transcript',transcript||'이 녹음에 저장된 텍스트가 없습니다.'));
  list.append(row);
 }
 window.MoaVoicePlaybackUI?.updatePlayback?.();
}
// Display only: the actual time comes from ORIGINAL native PlaybackUI's
// per-file elapsed/total rendering, never a guessed file-size duration.
function r613SyncVoiceRemaining(){
 if(!ui.open||ui.page!=='day'||!ui.voiceExpanded||!view||document.hidden)return;
 const list=$('.moa-r613-voice-list',view);if(!list||list.hidden)return;
 for(const card of list.querySelectorAll('.moa-r613-voice-card')){
  const button=card.querySelector('.moa-r613-voice-play'),rem=card.querySelector('.moa-r613-voice-remaining');
  if(!button||!rem)return;
  const result=button.textContent.match(/(\d{2,}:\d{2})\s*\/\s*(\d{2,}:\d{2})/);
  if(!result){rem.textContent='남은 --:--';continue;}
  const sec=v=>v.split(':').map(Number).reduce((a,b)=>a*60+b,0);
  rem.textContent='남은 '+r613VoiceTime(Math.max(0,sec(result[2])-sec(result[1])));
 }
}
window.setInterval(r613SyncVoiceRemaining,500);
window.addEventListener('moa:voice-meta-changed',e=>{if(e.detail?.day===ui.date&&ui.open&&ui.page==='day'){const list=$('.moa-r613-voice-list',view);if(list)delete list.dataset.signature;refreshVoices();}});
function openNativeRecorder(){const s=getState();if(!s)return;window.MoaVoicePlaybackUI?.stop?.();ui.audioPlaying=false;
 // Existing voice host accepts only S.page==='day'; call the *original* day navigation
 // so all original record-save side-effects, UID and data ownership remain intact.
 if(s.page!=='day'||s.date!==ui.date){s.mode='curated';window.FamilyJourneyDiary?.selectDay?.(ui.date)}
 const result=window.MoaVoiceDiaryNative?.open?.();if(!result){notify('기존 녹음 화면 연결이 준비되지 않았습니다.');return}
 const check=()=>{if(!ui.open)return;if(document.getElementById('moa-r149-voice-modal')){setTimeout(check,1200);return;}refreshVoices()};setTimeout(check,1300);
}
function playInlineVideo(media){
 const slide=$(`.moa-r472-slide[data-idx="${ui.idx}"]`,view);if(!slide||!isVideo(media))return;
 const old=slide.querySelector('video');if(old){old.paused?old.play().catch(()=>{}):old.pause();return;}
 window.MoaVoicePlaybackUI?.stop?.();ui.audioPlaying=false;
 const video=elem('video','moa-r469-inline-video');video.controls=true;video.playsInline=true;video.preload='metadata';
 video.poster=slide.querySelector('img')?.src||'';
 // Android WebView must be allowed to read the MediaStore URI. On devices that reject it,
 // original native playback stays a user-visible explicit fallback, not a false success.
 video.src=`content://media/external/video/media/${String(media.id).slice(1)}`;
 video.onerror=()=>{
  video.pause();video.removeAttribute('src');video.load();video.remove();
  notify('이 기기에서 화면 내 영상 열기가 제한되어 있습니다. 원본 재생기를 사용할 수 있습니다.');
  if(!slide.querySelector('.moa-r469-native-fallback'))slide.append(btn('원본 재생기로 보기',()=>nativePost('diaryPlayVideo',{id:media.id}),'moa-r469-native-fallback'));
 };
 slide.querySelector('.moa-r469-video-play')?.remove();slide.append(video);
 video.addEventListener('play',()=>{const b=slide.querySelector('.moa-r499-video-play');if(b)b.textContent='Ⅱ'});video.addEventListener('pause',()=>{const b=slide.querySelector('.moa-r499-video-play');if(b)b.textContent='▶'});video.play().catch(()=>{video.controls=true});
}

const originalAudioEvent=window.__moaNativeAudioEvent;
if(typeof originalAudioEvent==='function'){window.__moaNativeAudioEvent=function(evt){originalAudioEvent.apply(this,arguments);if(!ui.open||ui.page!=='day')return;const event=String(evt?.event||'');if(['record_saved','delete','transcribe_result'].includes(event)){const panel=$('.moa-r613-voice-list',view);if(panel)delete panel.dataset.signature;setTimeout(refreshVoices,250);}else if(event.startsWith('play_'))window.MoaVoicePlaybackUI?.updatePlayback?.();};}
// Native R570 save gate: exact CURRENT photo id, not merely same day/GPS.
window.__moaR570CurrentMediaId=()=>ui.open&&ui.page==='day'?String(dayMedia(ui.idx)?.id||''):'';
window.MoaR469SimpleDiary={openAdvancedGallery:()=>window.__moaR531ShowAdvanced?.(),openCalendar:()=>open('calendar'),openDay:d=>open('day',d),setCoverNative:id=>{if(ui.open&&ui.page==='day'&&ui.media.some(m=>String(m.id)===String(id)))saveCover(id)},home:()=>ui.open?(ui.page==='day'?goBack():true):false,close,readOnlyStatus:()=>({active:ui.open,page:ui.page,date:ui.date,mediaCount:ui.media.length,voiceCount:ui.clips.length})};
if(document.readyState==='loading')document.addEventListener('DOMContentLoaded',start,{once:true});else start();
})();