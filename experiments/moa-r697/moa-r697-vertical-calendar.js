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
let r679DetailHandoff=false, r679PreviewNonce=0;
// R507 in-card high-fidelity native engine. Original R463 classes6/17 unchanged.
// The Android ContentProvider projects the original native Gallery's OWN host
// over the exact HTML photo-card bounds; WebView does not decode content:// video.
// On missing provider / unsupported activity / invalid MediaStore ID, retain the
// full R503 web presentation and never launch an unexpected fullscreen viewer.
let r507Generation=0,r507Timer=0,r507Opened=false;
// R661: one PHOTO-native mount transaction per actual day/stage.  An Android
// Gallery which is already mounted must never be restarted by a diary update.
let r661Attempt=null,r661RetryDay='',r661RetryCount=0,r661RetryTimer=0;
const r661Events=[];
function r661Log(event,extra={}){const e={event,at:Date.now(),...extra};r661Events.push(e);
 if(r661Events.length>120)r661Events.shift();r602Mark('R661_'+event,extra);}
window.__moaR661NativeDiagnostic=()=>JSON.stringify({version:661,events:r661Events.slice(),dayActive:ui.open&&ui.page==='day',
 day:ui.date,stageConnected:!!view?.querySelector('.moa-r469-stage')?.isConnected,
 mounted:!!view?.classList.contains('moa-r507-native-mounted'),opened:r507Opened,
 bridge:!!window.__moaR507BridgeReady,armed:!!window.__moaR511NativeArmed,
 inlineArm:!!window.__moaR511InlineArm,pending:!!window.__moaR507NativePending,
 generation:r507Generation,attempt:r661Attempt?{age:Date.now()-r661Attempt.started,
 status:r661Attempt.status,gen:r661Attempt.gen}:null});
function r661ClearRetry(){clearTimeout(r661RetryTimer);r661RetryTimer=0;}
function r661EnsureNative(reason){
 if(window.__moaR694SelectorOpen)return false;
 if(!ui.open||ui.page!=='day'||r523DayExiting||r531Advanced||!ui.media.length||!view||view.hidden)return false;
 if(view.classList.contains('moa-r507-native-mounted')&&r507Opened){r527SyncGeometry(true);return true;}
 // The original Gallery may have opened and still be attaching; never close it.
 if(r507Opened||window.__moaR507NativePending)return true;
 const stage=view.querySelector('.moa-r469-stage');if(!stage?.isConnected)return false;
 if(r661Attempt&&r661Attempt.day===ui.date&&r661Attempt.stage===stage&&
    r661Attempt.gen===r507Generation&&r661Attempt.status==='waiting'&&
    Date.now()-r661Attempt.started<10500){return true;}
 r661Log('ENSURE_MOUNT',{reason,count:ui.media.length});r507StartInline();return true;
}
function r661RetryOnConfirmedFailure(reason){
 // No periodic auto-reopen. Only a concrete native reject/timeout can trigger
 // one subsequent request, never when the original Gallery was accepted/live.
 if(r507Opened||window.__moaR507NativePending||!ui.open||ui.page!=='day'||r523DayExiting||r531Advanced)return false;
 const day=ui.date;if(r661RetryDay!==day){r661RetryDay=day;r661RetryCount=0;}
 if(r661RetryCount>=1)return false;
 ++r661RetryCount;r661ClearRetry();
 const stage=view?.querySelector('.moa-r469-stage');
 r661Log('RETRY_AFTER_DENIAL',{reason,attempt:r661RetryCount});
 const gen=r507Generation;
 r661RetryTimer=setTimeout(()=>{
  r661RetryTimer=0;
  if(!ui.open||ui.page!=='day'||ui.date!==day||r523DayExiting||r531Advanced||
     r507Opened||window.__moaR507NativePending||!stage?.isConnected||
     view?.classList.contains('moa-r507-native-mounted'))return;
  // Generation only changes for deliberate cancellation; refuse stale retry.
  if(r507Generation!==gen)return;
  if(r661Attempt)r661Attempt.status='retry';
  r507StartInline();
 },420);
 return true;
}

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
 if(r661Attempt)r661Attempt.status='denied';
 // Retry only after explicit failure, with the old native host confirmed absent.
 if(r661RetryOnConfirmedFailure(reason))return true;
 r661Log('TERMINAL_NATIVE_FAILURE',{reason});
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
 r661RetryDay='';r661RetryCount=0;r661ClearRetry();
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
 if(mounted){if(r661Attempt)r661Attempt.status='mounted';r661ClearRetry();r661RetryCount=0;r661Log('MOUNTED_ACK');
  r600RestoreAttempts=0;r594ClearFallback();window.__moaR567ProgrammaticCloseUntil=0;r515RecoveryAttempts=0;r551LostAttempts=0;r515LastNativeMount=Date.now();clearTimeout(r519EntryTimer);r519EntryTimer=0;r527SyncGeometry(true);}
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
function r507StopInline(){r661ClearRetry();if(r661Attempt)r661Attempt.status='stopped';
 r596ClearWebTimer();r594ClearMountWatchdog();r594NativeIndexMap=[];
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
function r507StartInline(){if(window.__moaR694SelectorOpen)return false;
 if(r523DayExiting||r531Advanced)return;
 if(r507Opened||view?.classList.contains('moa-r507-native-mounted'))return;
 const existingStage=view?.querySelector('.moa-r469-stage');
 if(r661Attempt&&r661Attempt.day===ui.date&&r661Attempt.stage===existingStage&&
    r661Attempt.gen===r507Generation&&r661Attempt.status==='waiting'&&
    Date.now()-r661Attempt.started<10500){r661Log('JOIN_INFLIGHT',{count:ui.media.length});return;}
 // R675: advisory PREWARM into the existing original R463 native Gallery
 // image cache before Java ARM/open. Does not open/close/replace original host.
 // If the bridge/URI/cache is unavailable, original PHOTO behavior is unchanged.
 try{const m=ui.media[ui.idx];if(m?.id)window.MoaR667NativePicker?.primePhoto?.(String(m.id));}catch(_){}
 const generation=++r507Generation;
 r661Attempt={gen:generation,day:ui.date,stage:existingStage,started:Date.now(),status:'waiting'};
 r602Mark('START_INLINE',{count:ui.media.length});
 r661Log('TRY_ARM',{count:ui.media.length});
 if(view&&ui.media.length)view.classList.add('moa-r519-native-entering');
 clearTimeout(r519EntryTimer);
 // On unsupported Android/native bridge, restore original web photo UI gracefully.
 r519EntryTimer=setTimeout(()=>{if(generation===r507Generation&&view&&!view.classList.contains('moa-r507-native-mounted'))notify('네이티브 갤러리 연결 확인 중');},3500);
 const waitUntil=Date.now()+8000;
 const tryOpen=()=>{
  if(generation!==r507Generation||!ui.open||ui.page!=='day'||view?.hidden){
   r661Log('TRY_ABORT',{reason:generation!==r507Generation?'STALE_GENERATION':!ui.open?'CLOSED':ui.page!=='day'?'PAGE_CHANGED':'HIDDEN'});return;}
  if(!window.__moaR507BridgeReady || typeof window.MoaLocalAudio?.openNativeGallery!=='function'){
   if(Date.now()<waitUntil)r507Timer=setTimeout(tryOpen,180);
   else {r602Mark('PROVIDER_BRIDGE_TIMEOUT');r594Fallback('BRIDGE_UNAVAILABLE');}
   return;
  }
  const ids=ui.media.map(x=>String(x.id));
  if(!ids.length||ids.length>10000||ids.some(id=>!/^(?:v?[0-9]{1,18})$/.test(id))){r594Fallback('INVALID_NATIVE_MEDIA_LIST');return;}
  if(!view?.querySelector('.moa-r469-stage')?.isConnected){
   r661Log('STAGE_NOT_ATTACHED');
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
/* R681 PERMANENT: actual installed APK PackageManager version, not stale JS version text.
 * Runs again when a native bridge finishes attaching after first WebView paint. */
function r681VersionInSettings(host){
 if(!host)return;
 let row=document.getElementById('moa-r681-apk-version');
 if(!row){
   row=elem('li','moa-r681-apk-version');row.id='moa-r681-apk-version';
   row.append(elem('strong','','모아 앱 버전'),elem('small','moa-r681-version-value','설치 버전 확인 중'));
   host.prepend(row);
 }
 const value=row.querySelector('.moa-r681-version-value');
 if(!value)return;
 try{
   const native=window.MoaR667NativePicker;
   const raw=native&&typeof native.appVersionInfo==='function'?native.appVersionInfo():'';
   if(raw){
     const info=JSON.parse(raw);
     const code=Number(info.versionCode);
     if(Number.isSafeInteger(code)&&code>=1&&typeof info.versionName==='string'&&info.versionName){
       value.textContent=`${info.versionName} · R${code} (versionCode ${code})`;
       value.dataset.moaLiveVersion='true';return;
     }
   }
   // R681: the original native bridge also exposes a build ID; a release
   // must change this ID along with Manifest versionCode. Do not guess.
   const tag=native&&typeof native.version==='function'?native.version():'';
   const hit=/^R([0-9]+)-/.exec(String(tag));
   if(hit){const code=Number(hit[1]);value.textContent=`모아 R${code} · 빌드 ${code}`;value.dataset.moaLiveVersion='true';}
 }catch(_){/* keep explicit checking label, never fake a version */}
}
function r495InstallScrollSetting(){
 const settings=document.querySelector('section.page[data-page="settings"]');
 const host=settings?.querySelector(':scope > ul.rows');
 if(!host)return;
 r681VersionInSettings(host);
 if(document.getElementById('moa-r495-scroll-setting'))return;
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
 // On PHOTO→DETAIL, keep marker through the handoff, then release after the next paint.
 if(s?.open&&!root.hidden&&(ui.open||r679DetailHandoff||s.page==='calendar'))root.dataset.moaUnifiedPage='calendar';
 else delete root.dataset.moaUnifiedPage;
}
function r495TryBack(){
 if(!ui.open||document.getElementById('moa-r149-voice-modal'))return false;
 if(r621PreviewHost){r621ClosePreview();return true;}
 if(['picker','period','settings'].includes(ui.page)){r619ReturnFromAux();return true;}
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
  // R661: QuickRecord/return may call prepareView on an already-live PHOTO day.
  // Preserve the native host, exact stage DOM, current video frame, scroll and
  // eight-action deck; only read changed storage and update playlist/story.
  if(page==='day'&&view?.dataset.page==='day'&&view?.dataset.r661PhotoDay===day&&
     view.querySelector('.moa-r469-stage')?.isConnected&&!view.hidden){
   r661Log('PRESERVE_DAY_STAGE',{reason:'PREPARE_VIEW'});
   Promise.resolve(r592RefreshVisibleDay()).then(()=>r661EnsureNative('PREPARE_VIEW')).catch(e=>console.warn('R661 refresh',String(e)));
   return;
  }
  // R673: keep the already visible calendar/day DOM while IndexedDB
  // hydrates; R592's former full replaceChildren(loading text) caused a white
  // flash on EVERY date entry/back, as captured in Galaxy video 23408.
  // render() still owns the one legitimate screen switch after hydration.
  // No original PHOTO native owner, media store or QuickRecord path is touched.
  let rendered=false;
  const current=()=>token===r592OpenToken&&ui.open&&ui.page===page&&(page!=='day'||ui.date===day)&&view&&!view.hidden;
  const paint=()=>{if(rendered||!current())return;rendered=true;
   if(page==='calendar'&&view.dataset.page==='calendar'&&r483Feed?.isConnected&&
      view.dataset.r699Month===r483MonthKey(month))r699ReconcileVisibleCalendar();
   else render();
  };
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
   refreshVoices();r602RefreshMomentNotes();r607RefreshStoryBody();
   r661EnsureNative('SAME_DAY_NO_LIST_CHANGE');return false;
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
 const entry=st.curatedEntries?.get(day);
 const active=(ui.source==='automatic'?st.entries?.get(day):entry);
 const hidden=new Set([...(entry?.removedMediaIds||[]),...(active?.removedMediaIds||[])].map(String));
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
 // R694: the representative cover always leads the VIEW/Filmstrip playlist.
 // Keep persisted photoIds and real EXIF capture timestamps untouched.
 const chron=combined.filter(p=>safeMedia(p.id)&&!hidden.has(String(p.id))&&!seen.has(String(p.id))&&seen.add(String(p.id)))
   .sort((a,b)=>(Number(a.t)||0)-(Number(b.t)||0));
 const coverId=String(st.covers?.[ui.source]?.[day]||'');
 const p=chron.findIndex(x=>String(x.id)===coverId);
 return p>0?[chron[p],...chron.slice(0,p),...chron.slice(p+1)]:chron;
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
// R699: cache ONLY tiny rendered calendar covers.  No original media duplicated.
const R699_COVER_KEY='moa.r699.calendar.thumbs.v1';
const r699CoverRows=new Map();
let r699CoverReady=false,r699CoverSaving=0,r699CoverLoading=false;
function r699MediaStamp(id){
 const rec=getState()?.byId?.get(String(id));
 return Number.isFinite(Number(rec?.t))?Number(rec.t):0;
}
async function r699WarmCalendarCovers(){
 if(r699CoverReady||r699CoverLoading||!getState()?.byId?.size)return;
 r699CoverLoading=true;
 try{
  const saved=await stored('meta',R699_COVER_KEY);
  if(!saved||saved.version!==1||!Array.isArray(saved.items)){r699CoverReady=true;return;}
  for(const row of saved.items){
   if(!safeMedia(row?.id)||!r699MediaStamp(row.id)||r699MediaStamp(row.id)!==Number(row.t))continue;
   if(typeof row.data!=='string'||!row.data.startsWith('data:image/')||row.data.length>125000)continue;
   const id=String(row.id);r699CoverRows.set(id,{id,t:Number(row.t),data:row.data});
   if(!r472Cache.has('260:'+id))r472Cache.set('260:'+id,row.data);
  }
  r699CoverReady=true;
  for(const img of view?.querySelectorAll('.moa-r483-month img[data-id]')||[]){
   const cached=r472Cached(img.dataset.id,260);
   if(cached&&!img.classList.contains('moa-r472-image-ready'))r472Paint(img,cached);
  }
 }catch(e){console.debug('R699 calendar thumbnail cache unavailable',String(e));r699CoverReady=true;}
 finally{r699CoverLoading=false;}
}
function r699SaveCalendarCovers(){
 if(r699CoverSaving)return;
 r699CoverSaving=setTimeout(async()=>{r699CoverSaving=0;
  try{
   const items=[...r699CoverRows.values()].filter(r=>r699MediaStamp(r.id)===r.t);
   await persist('meta',R699_COVER_KEY,{version:1,items,savedAt:Date.now()});
  }catch(e){console.debug('R699 calendar cache write skipped',String(e));}
 },1600);
}
function r699RememberCalendarCover(id,data){
 if(typeof data!=='string'||data.length>125000||!data.startsWith('data:image/'))return;
 const stamp=r699MediaStamp(id);if(!stamp)return;
 const key=String(id);r699CoverRows.delete(key);r699CoverRows.set(key,{id:key,t:stamp,data});
 let length=0;for(const x of r699CoverRows.values())length+=x.data.length;
 while((length>2300000||r699CoverRows.size>48)&&r699CoverRows.size){
  const first=r699CoverRows.keys().next().value;
  length-=r699CoverRows.get(first).data.length;r699CoverRows.delete(first);
 }
 r699SaveCalendarCovers();
}
let r472ThumbRetryTimer=0;
function r472Cached(id,size){return r472Cache.get(size+':'+id)||r472Cache.get('400:'+id)||r472Cache.get('250:'+id)||r472Cache.get('130:'+id)||null;}
function r472Store(id,size,data){if(typeof data!=='string'||!data.startsWith('data:image/'))return;
 const key=size+':'+id;r472Cache.delete(key);r472Cache.set(key,data);
 while(r472Cache.size>22)r472Cache.delete(r472Cache.keys().next().value);
 if(size===260)r699RememberCalendarCover(id,data);
}
function r472Paint(node,src){if(!node?.isConnected||!src?.startsWith('data:image/'))return;
 if(node.closest('.moa-r621-preview-frame')){
  if(node.dataset.imageTier==='original'||node.dataset.imageTier==='original-pending')return;
  const full=r472Cache.get('2048:'+String(node.dataset.id));
  if(node.dataset.fullLoaded==='1'&&full&&src!==full)return; // no 260px overwrite
 }
 if(node.closest('.moa-r619-picker-tile')){
  const high=r472Cache.get('640:'+String(node.dataset.id));
  if(high&&src!==high)return; // Never repaint a sharp tile with a stale 260px callback.
 }
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
   if(large.length)fillImages(large,true);if(small.length){const picker=small.filter(n=>n.closest('.moa-r619-picker-tile'));const other=small.filter(n=>!n.closest('.moa-r619-picker-tile'));if(picker.length)fillImages(picker,false);if(other.length)fillImages(other,false)}}

 },1600);
}
async function fillImages(targets,large=false){
 if(!targets?.length||!view)return;
 // R677: picker 3-column tiles use up to 640px; 260px is intended only
 // for the small calendar/rail. The original PHOTO native decoder is untouched.
 const pickerHigh=!large&&targets.every(n=>n.closest('.moa-r619-picker-tile'));
 const size=large?2048:(pickerHigh?640:260);
 const get=window.__requestThumbs;
 const grouped=new Map();
 for(const node of targets){
  if(!node.isConnected||!safeMedia(node.dataset.id))continue;
  node.alt='';const id=node.dataset.id;
  const cached=r472Cached(id,size);
  if(cached)r472Paint(node,cached);
  // A 260px cached poster must NOT suppress a 640px request for this
  // photo-add tile, nor may late low-quality callbacks overwrite the high tier.
  if(cached&&(!pickerHigh||r472Cache.has(size+':'+id)))continue
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
  if(large.length)fillImages(large,true);if(small.length){const picker=small.filter(n=>n.closest('.moa-r619-picker-tile'));const other=small.filter(n=>!n.closest('.moa-r619-picker-tile'));if(picker.length)fillImages(picker,false);if(other.length)fillImages(other,false)}}

}
window.addEventListener('pageshow',()=>{setTimeout(r472RefreshVisibleThumbs,200)},{passive:true});
window.addEventListener('resize',()=>{if(ui.open&&ui.page==='day')r613AutosizeStory($('.moa-r469-text',view));},{passive:true});
document.addEventListener('visibilitychange',()=>{if(!document.hidden){setTimeout(r472RefreshVisibleThumbs,300);setTimeout(async()=>{if(ui.open&&ui.page==='day'){await r592RefreshVisibleDay();r661EnsureNative('CAMERA_RETURN');}},600);}},{passive:true});

function mount(){if(view)return view;const n=elem('section','moa-r469-root');n.id='moa-r469-root';n.setAttribute('aria-label','통합 사진 일기 달력');n.hidden=true;n.addEventListener('scroll',()=>{r527SyncGeometry();window.__moaR613ScrollNavRefresh?.()}, {passive:true});n.addEventListener('click',e=>{if(Date.now()<r479SwipeBlockUntil&&e.target.closest('.moa-r469-date')){e.stopImmediatePropagation();e.preventDefault()}},true);document.body.append(n);view=n;return n;}
function open(page='calendar',day){const s=getState();if(!s?.open)return false;r594RetryUsed=false;r594ClearFallback();r527BeginDay();mount();ui.open=true;ui.page=['day','picker','period','settings'].includes(page)?page:'calendar';ui.selected=valid(day)?day:ui.selected;ui.date=ui.selected;ui.month=new Date(ui.selected+'T12:00:00');ui.month.setDate(1);ui.idx=0;ui.fast=false;ui.tools=false;ui.rail=false;ui.voiceExpanded=false;ui.dirty=false;view.hidden=false;
 try{localStorage.setItem(KEY,'simple')}catch(e){}r495SyncLegacyRoot();r495InstallBackHandlers();r592PrepareView();r475LastDataKey=[s.curatedEntries?.size||0,s.entries?.size||0,s.byDay?.size||0,s.byVideoDay?.size||0].join(':');installBack();setTimeout(r475RefreshFamily,100);return true;}
function close(){++r592OpenToken;r594RetryUsed=false;r594ClearFallback();r507StopInline();view?.classList.remove('moa-r547-native-owner');r483ImageObserver?.disconnect();r483ImageObserver=null;r483Feed=null;window.MoaVoicePlaybackUI?.stop?.();ui.audioPlaying=false;ui.open=false;ui.requestGeneration++;if(view)view.hidden=true;window.__moaR613ScrollNavRefresh?.();r495SyncLegacyRoot();try{localStorage.removeItem(KEY)}catch(e){}return true;}
function goBack(){if(!ui.open)return false;if(['picker','period','settings'].includes(ui.page)){r619ReturnFromAux();return true;}if(ui.page==='day'){if(ui.dirty&&!confirm('작성 중인 내용이 있습니다. 저장하지 않고 돌아갈까요?'))return true;
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
 if(r621PreviewHost){r621ClosePreview();return 'preview';}
 if(ui.open&&['picker','period','settings'].includes(ui.page)){r619ReturnFromAux();return 'aux';}
 if(!ui.open||ui.page!=='day')return 'not-open';
 if(document.getElementById('moa-r149-voice-modal')){
   const modal=document.getElementById('moa-r149-voice-modal');
   const button=modal.querySelector('button[aria-label*="닫기"]');
   if(button)button.click();else window.__fjBackOverlay?.();
   return 'modal';
 }
 const shade=view?.querySelector('.moa-r479-picker-backdrop');
 if(shade){shade.remove();return 'picker';}
 if(['picker','period','settings'].includes(ui.page)){r619ReturnFromAux();return 'picker';}
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
// R619: one shared date navigator. The browser's own horizontal compositor
// owns kinetic flings; the native photo/video gallery is NEVER a touch target.
// Commit a date only after the horizontal rail settles, not during scrolling.
let r619AuxReturn='photo',r619AuxDate='',r619PickerScope='day',r619PickSelection=new Set();
let r619PickerGroups=[],r619PickerGroupCount=0,r619PickerObserver=null,r621RowObservers=[];
function r621CleanPickerObservers(){r623PickerDragStop();r619PickerObserver?.disconnect();r619PickerObserver=null;for(const observer of r621RowObservers)observer.disconnect();r621RowObservers=[];r621ClosePreview();}
const r619ShiftDay=(day,delta)=>{const d=new Date(day+'T12:00:00');d.setDate(d.getDate()+delta);return dayOf(d.getTime())};
function r619ChangeDay(day,fromMode){
 if(!valid(day))return false;
 if(fromMode==='detail'&&!ui.open){
  const st=getState();if(!st?.open||st.page!=='day')return false;
  if(st.dirty&&st.editing&&!confirm('저장하지 않은 내용을 닫고 날짜를 변경할까요?'))return false;
  window.MoaVoicePlaybackUI?.stop?.();
  window.FamilyJourneyDiary?.selectDay?.(day);
  requestAnimationFrame(r475DecorateDetail);return true;
 }
 if(!ui.open||ui.page!=='day'||ui.date===day)return false;
 if(ui.dirty&&!confirm('작성 중인 글을 저장하지 않고 날짜를 변경할까요?'))return false;
 // User-owned navigation only. This is NOT a same-day playlist change;
 // the R611 original Gallery must close intentionally before the new day.
 r523DayExiting=true;
 window.__moaR567ProgrammaticCloseUntil=Date.now()+2300;
 window.MoaVoicePlaybackUI?.stop?.();r507StopInline();
 ui.date=day;ui.selected=day;ui.month=new Date(day+'T12:00:00');ui.month.setDate(1);
 ui.idx=0;ui.media=[];ui.voiceExpanded=false;ui.dirty=false;
 r594RetryUsed=false;r594ClearFallback();r527BeginDay();r592PrepareView();
 return true;
}
function r619DateRail(day,mode){
 const host=elem('div','moa-r619-date-host');host.setAttribute('aria-label','고정 날짜 숫자 좌우 스와이프 · 길게 눌러 년월 선택');
 const label=btn(dateLabel(day),()=>{},'moa-r619-date-fixed');
 label.setAttribute('aria-label',dateLabel(day)+' · 좌우 스와이프 날짜 변경, 길게 눌러 연월일 선택');
 label.setAttribute('aria-live','off');host.append(label);
 let gesture=null,holdTimer=0,flingTimer=0,ignoreClickUntil=0,opened=false;
 const stopHold=()=>{clearTimeout(holdTimer);holdTimer=0;};
 const shiftDisplay=(offset)=>{label.textContent=dateLabel(r619ShiftDay(day,offset));};
 function begin(e){
  if(e.pointerType==='mouse'&&e.button!==0)return;
  clearInterval(flingTimer);stopHold();opened=false;
  gesture={id:e.pointerId,x:e.clientX,y:e.clientY,t:performance.now(),lastX:e.clientX,lastT:performance.now(),vx:0,dx:0,drag:false,preview:0};
  try{label.setPointerCapture(e.pointerId)}catch(_){}
  holdTimer=setTimeout(()=>{if(!gesture||gesture.drag)return;opened=true;ignoreClickUntil=Date.now()+700;stopHold();gesture=null;r619EnterPeriod(mode,day);},560);
 }
 function move(e){
  const g=gesture;if(!g||g.id!==e.pointerId)return;
  const now=performance.now(),dx=e.clientX-g.x,dy=e.clientY-g.y;
  if(Math.abs(dx)>9||Math.abs(dy)>9){g.drag=true;stopHold();}
  if(!g.drag||Math.abs(dx)<Math.abs(dy)*1.15)return;
  const dt=Math.max(16,now-g.lastT);g.vx=.62*g.vx+.38*Math.max(-2,Math.min(2,(e.clientX-g.lastX)/dt));
  g.lastX=e.clientX;g.lastT=now;g.dx=dx;
  const offset=Math.max(-20,Math.min(20,Math.round(-dx/46)));
  if(offset!==g.preview){g.preview=offset;shiftDisplay(offset);}
 }
 function finish(e,cancelled=false){
  const g=gesture;if(!g||e&&e.pointerId!==g.id)return;
  gesture=null;stopHold();
  if(opened||cancelled){shiftDisplay(0);return;}
  if(!g.drag||Math.abs(g.dx)<16){shiftDisplay(0);return;}
  ignoreClickUntil=Date.now()+450;
  const raw=-g.dx/72-g.vx*2.1;
  const steps=Math.max(-14,Math.min(14,Math.round(raw)||(-g.dx>0?1:-1)));
  if(!steps){shiftDisplay(0);return;}
  // A short number-only deceleration. The header, native Gallery and adjacent
  // photo/detail controls never translate or re-render until the final day.
  const duration=Math.min(340,130+Math.abs(steps)*15),began=performance.now();
  let displayed=g.preview;
  flingTimer=setInterval(()=>{
   if(!host.isConnected){clearInterval(flingTimer);return;}
   const t=Math.min(1,(performance.now()-began)/duration);
   const eased=1-Math.pow(1-t,3);
   const offset=Math.round(g.preview+(steps-g.preview)*eased);
   if(offset!==displayed){displayed=offset;shiftDisplay(offset);}
   if(t>=1){clearInterval(flingTimer);flingTimer=0;r619ChangeDay(r619ShiftDay(day,steps),mode);}
  },28);
 }
 label.addEventListener('pointerdown',begin,{passive:true});
 label.addEventListener('pointermove',move,{passive:true});
 label.addEventListener('pointerup',e=>finish(e),{passive:true});
 label.addEventListener('pointercancel',e=>finish(e,true),{passive:true});
 label.addEventListener('click',()=>{if(Date.now()<ignoreClickUntil||opened)return;r619EnterPeriod(mode,day)});
 label.addEventListener('contextmenu',e=>e.preventDefault());
 return host;
}
function r619EnterPeriod(mode,day){
 if(!valid(day))return;
 r619AuxReturn=mode;r619AuxDate=day;
 if(mode==='photo'&&ui.open&&ui.page==='day'){
  r523DayExiting=true;window.__moaR567ProgrammaticCloseUntil=Date.now()+2300;
  const hadPending=!!window.__moaR507NativePending,wasOpen=r507Opened;
  r507StopInline();
  if(hadPending&&!wasOpen)try{window.MoaLocalAudio?.closeNativeGallery?.()}catch(_){}
 }
 mount();ui.open=true;ui.page='period';view.hidden=false;ui.date=day;ui.selected=day;
 render();
}
function r619PeriodToDay(day){
 if(!valid(day))return;
 const mode=r619AuxReturn;
 if(mode==='detail'){
  close();window.FamilyJourneyDiary?.selectDay?.(day);
  requestAnimationFrame(r475DecorateDetail);
 }else{
  ui.page='day';ui.date=day;ui.selected=day;ui.idx=0;ui.dirty=false;
  ui.month=new Date(day+'T12:00:00');ui.month.setDate(1);
  r527BeginDay();r592PrepareView();
 }
}
function r619ReturnFromAux(){
 if(!ui.open||!['picker','period','settings'].includes(ui.page))return;
 const mode=r619AuxReturn,day=valid(r619AuxDate)?r619AuxDate:dayOf(Date.now());
 r621CleanPickerObservers();
 if(mode==='detail'){
  close();window.FamilyJourneyDiary?.selectDay?.(day);requestAnimationFrame(r475DecorateDetail);
 }else{ui.page='day';ui.date=day;ui.selected=day;ui.dirty=false;
  r527BeginDay();r592PrepareView();}
}
function r619RenderPeriod(){
 const d=new Date((r619AuxDate||ui.date)+'T12:00:00');let year=d.getFullYear(),month=d.getMonth(),currentDay=d.getDate();
 const shell=elem('div','moa-r621-aux-shell');
 shell.append(elem('div','moa-r621-aux-underlay',''),elem('div','moa-r621-aux-day',dateLabel(r619AuxDate||ui.date)));
 const shade=elem('div','moa-r479-picker-backdrop moa-r621-sheet-backdrop');
 const sheet=elem('section','moa-r479-picker-sheet moa-r483-picker-sheet moa-r621-period-sheet');
 sheet.setAttribute('role','dialog');sheet.setAttribute('aria-modal','true');sheet.setAttribute('aria-label','연도 월 날짜 선택');
 const heading=elem('div','moa-r479-picker-heading');heading.append(elem('strong','','연도 · 월 선택'),btn('×',r619ReturnFromAux,'moa-r479-picker-close'));sheet.append(heading);
 const labels=elem('div','moa-r483-picker-labels');labels.append(elem('span','','연도'),elem('span','','월'));sheet.append(labels);
 const wheel=elem('div','moa-r483-picker-columns');
 const years=elem('div','moa-r483-year-list'),months=elem('div','moa-r483-picker-months');
 years.setAttribute('role','listbox');months.setAttribute('role','listbox');
 years.setAttribute('aria-label','연도 관성 세로 스크롤');months.setAttribute('aria-label','월 관성 세로 스크롤');
 const days=elem('div','moa-r621-day-grid');
 const redraw=()=>{
  for(const c of years.children){const on=Number(c.dataset.year)===year;c.classList.toggle('active',on);c.setAttribute('aria-selected',String(on));}
  for(const c of months.children){const on=Number(c.dataset.month)===month;c.classList.toggle('active',on);c.setAttribute('aria-selected',String(on));}
  const max=new Date(year,month+1,0).getDate();currentDay=Math.min(currentDay,max);
  days.replaceChildren();for(let n=1;n<=max;n++){
   const target=dayOf(new Date(year,month,n,12).getTime());
   const b=btn(String(n),()=>r619PeriodToDay(target),'moa-r621-day-option'+(n===currentDay?' active':''));
   b.setAttribute('aria-label',dateLabel(target)+' 일기 열기');days.append(b);
  }
 };
 for(let y=1900;y<=2100;y++){const b=btn(String(y),()=>{year=y;redraw();},'moa-r483-year-option'+(y===year?' active':''));b.dataset.year=y;years.append(b);}
 for(let m=0;m<12;m++){const b=btn((m+1)+'월',()=>{month=m;redraw();},'moa-r483-month-option'+(m===month?' active':''));b.dataset.month=m;months.append(b);}
 wheel.append(years,months);sheet.append(wheel,elem('p','moa-r479-picker-hint','연도·월은 위아래로 스크롤, 아래 숫자를 눌러 날짜로 이동합니다.'),days);
 shade.append(sheet);shell.append(shade);view.append(shell);redraw();
 requestAnimationFrame(()=>{for(const w of [years,months]){const c=w.querySelector('.active');if(c)w.scrollTop=c.offsetTop-w.offsetTop-w.clientHeight/2+c.clientHeight/2;}});
 shade.addEventListener('click',e=>{if(e.target===shade)r619ReturnFromAux()});
}
function r619EnterMediaPicker(day){
 const st=getState();if(!st?.open||!valid(day))return false;
 if(ui.open&&ui.page==='day'&&ui.dirty&& !confirm('작성 중인 글을 저장하지 않고 사진 선택 화면으로 이동할까요?'))return false;
 if(!ui.open && st.page==='day'&&st.editing&&st.dirty&&
   !confirm('저장하지 않은 상세형 편집 내용을 닫고 사진을 추가할까요?'))return false;
 r619AuxReturn=ui.open&&ui.page==='day'?'photo':st.page==='day'?'detail':'photo';r619AuxDate=day;
 r619PickerScope='day';r619PickSelection.clear();r619PickerGroupCount=0;
 if(ui.open&&ui.page==='day'){
  r523DayExiting=true;window.__moaR567ProgrammaticCloseUntil=Date.now()+2300;
  const hadPending=!!window.__moaR507NativePending,wasOpen=r507Opened;
  r507StopInline();
  if(hadPending&&!wasOpen)try{window.MoaLocalAudio?.closeNativeGallery?.()}catch(_){}
 }
 mount();ui.open=true;ui.page='picker';ui.date=day;ui.selected=day;ui.dirty=false;view.hidden=false;
 r621CleanPickerObservers();render();return true;
}
function r619PickerAssets(){
 const st=getState();if(!st)return [];
 // MediaStore's byDay index and flat list can hydrate in different orders.
 // Combine both read-only sources for the selected day; never mutate diaries.
 const flat=[...(st.photos||[]),...(st.videos||[])];
 const d=r619AuxDate;
 const source=r619PickerScope==='day'?
  [...(st.byDay?.get(d)||[]),...(st.byVideoDay?.get(d)||[]),
   ...flat.filter(p=>Number.isFinite(Number(p.t))&&dayOf(Number(p.t))===d)]:flat;
 const ids=new Set();return source.filter(p=>safeMedia(p.id)&&Number.isFinite(Number(p.t))&&
  !ids.has(String(p.id))&&ids.add(String(p.id))).sort((a,b)=>Number(b.t)-Number(a.t));
}
// R623 — ONE canonical picker selection Set for grid, enlarge and filmstrip.
// The original Android MediaStore/native Gallery renderer is never touched.
let r621PreviewIndex=0,r621PreviewAssets=[],r621PreviewHost=null;
let r623PreviewFast=false,r623PreviewRailVisible=true,r623Drag=null,r623DragTimer=0,r623DragAutoscroll=0,r623SuppressTileClickUntil=0,r623RailThumbObserver=null;
try{r623PreviewFast=localStorage.getItem('moa.r623.picker.fast')==='1';r623PreviewRailVisible=localStorage.getItem('moa.r623.picker.rail')!=='0';}catch(_){/* local setting optional */}
function r623RememberPreference(){try{localStorage.setItem('moa.r623.picker.fast',r623PreviewFast?'1':'0');localStorage.setItem('moa.r623.picker.rail',r623PreviewRailVisible?'1':'0');}catch(_){}}
function r623SelectionNumber(id){let n=0;for(const picked of r619PickSelection){++n;if(picked===String(id))return n;}return 0;}
function r623SetSelection(id,selected,update){id=String(id);if(!safeMedia(id))return;
 if(selected)r619PickSelection.add(id);else r619PickSelection.delete(id);
 if(typeof update==='function')update();
}
function r623PickerDragStop(){clearTimeout(r623DragTimer);r623DragTimer=0;if(r623DragAutoscroll){cancelAnimationFrame(r623DragAutoscroll);r623DragAutoscroll=0;}r623Drag=null;}
function r621ClosePreview(){r623RailThumbObserver?.disconnect();r623RailThumbObserver=null;if(r621PreviewHost){for(const video of r621PreviewHost.querySelectorAll('video'))try{video.pause()}catch(_){}r621PreviewHost.remove();r621PreviewHost=null;}}
// MOA R667: explicitly isolated Android native PHOTO-ADD preview. Never call
// original MoaLocalAudio.openNativeGallery or manipulate original PHOTO owner.
function r667PickerNativePreview(items,index,update){
 const bridge=window.MoaR667NativePicker;
 if(!bridge||typeof bridge.open!=='function')return false;
 const source=items.filter(x=>/^v?\d{1,19}$/.test(String(x.id)));
 if(!source.length)return false;
 const wanted=String(items[index]?.id||''),at=source.findIndex(x=>String(x.id)===wanted);
 const payload={index:Math.max(0,at),items:source.slice(0,1400).map(m=>({id:String(m.id),t:Number(m.t)||0,video:isVideo(m)})),selected:[...r619PickSelection],day:r619AuxDate||dayOf(Date.now())};
 window.__moaR667NativePickerError=message=>{
   notify('사진 추가 원본 갤러리 연결 실패: '+String(message||''));r619PickerStatus('원본 네이티브 갤러리를 열 수 없습니다. 연결을 확인한 뒤 다시 선택해 주세요.');
 };
 window.__moaR667NativePickerResult=async raw=>{
  let result;try{result=typeof raw==='string'?JSON.parse(raw):raw}catch(_){return;}
  if(!result||!Array.isArray(result.selected))return;
  const ids=new Set(source.map(m=>String(m.id)));
  // Preserve selections outside current visible day when mode=all.
  for(const id of ids)r619PickSelection.delete(id);
  for(const id of result.selected){const v=String(id);if(safeMedia(v)&&ids.has(v))r619PickSelection.add(v);}
  update?.();
  // The EXACT original Gallery's existing "모아 기존 상세·GPS 보기" menu
  // closes the isolated picker and forwards the original selected media ID
  // into the *original* diary detail route, never a recreated WebView viewer.
  const legacy=String(result.legacyDetails||'');
  if(/^(day|month)\|v?\d{1,18}$/.test(legacy)){
   const parts=legacy.split('|'), mediaId=parts[1];
   r619ReturnFromAux();
   requestAnimationFrame(()=>{
    try{
     if(parts[0]==='day')window.MoaUnifiedDiary?.openFromDay?.(mediaId);
     else window.MoaR175MonthLegacy?.(mediaId);
    }catch(err){console.warn('native picker original detail route',err)}
   });
   return;
  }
  const cover=String(result.coverId||'');
  if(cover&&ids.has(cover)){
   const media=source.find(m=>String(m.id)===cover);
   if(media&&dayOf(Number(media.t))===r619AuxDate){try{await saveCover(cover);}catch(_){notify('대표 사진을 설정하지 못했습니다');}}
  }
  const mapId=String(result.mapId||''),bookmarkId=String(result.bookmarkId||'');
  const placeId=mapId||bookmarkId;
  if(placeId&&ids.has(placeId)){
   const id=placeId.replace(/^v/,'');
   const existing=view.querySelector('.moa-r667-gps-result');existing?.remove();
   const holder=elem('div','moa-r667-gps-result');
   const close=btn('×',()=>holder.remove(),'moa-r667-gps-close');close.setAttribute('aria-label','위치 선택 닫기');
   const geo=elem('div','moa-r667-gps-content');holder.append(close,geo);view.append(holder);
   if(mapId){
    if(typeof window.FamilyJourneyDiaryGeo?.attach!=='function'){geo.textContent='위치 정보 연결을 사용할 수 없습니다';}
    else {
     try{window.FamilyJourneyDiaryGeo.attach(geo,id);}catch(_){geo.textContent='위치를 조회하지 못했습니다';}
     const observer=new MutationObserver(()=>{
      if(!holder.isConnected){observer.disconnect();return;}
      const button=[...geo.querySelectorAll('button')].find(b=>/네이버지도/.test(b.textContent||''));
      if(button){observer.disconnect();button.click();}
     });observer.observe(geo,{subtree:true,childList:true});setTimeout(()=>observer.disconnect(),3500);
    }
   }else if(bookmarkId){
    if(typeof window.NativeHost?.post!=='function'||typeof window.FamilyJourneyNaver?.saveFromDiaryGps!=='function'){
     geo.textContent='네이버 위치 저장 연결을 사용할 수 없습니다';
    }else{
     const list=prompt('네이버 지도에 저장할 리스트 이름을 입력하세요 (선택 가능)','');
     if(list===null){holder.remove();return;}
     geo.textContent='원본 사진의 GPS 확인 중…';
     const request=1886000000+Math.floor(Math.random()*900000);
     const previous=window.__fjDiaryMediaLocationResult;let done=false;
     const finish=(message)=>{geo.textContent=message;done=true;window.__fjDiaryMediaLocationResult=previous;};
     window.__fjDiaryMediaLocationResult=(rid,value)=>{
      if(Number(rid)!==request){if(typeof previous==='function')previous(rid,value);return;}
      if(done)return;const lat=Number(value?.lat),lon=Number(value?.lon);
      if(!value?.hasGps||!Number.isFinite(lat)||!Number.isFinite(lon)){finish('촬영 위치 GPS가 없습니다');return;}
      try{
       const accepted=window.FamilyJourneyNaver.saveFromDiaryGps(
        {...value,id,lat,lon},'','',String(list).slice(0,70),
        ack=>{geo.textContent=String(ack?.message||ack?.state||'네이버 지도 저장 처리 중');},{mode:'web'});
       if(!accepted)finish('네이버 지도 저장 요청에 실패했습니다');
       else{done=true;window.__fjDiaryMediaLocationResult=previous;}
      }catch(_){finish('네이버 지도 저장에 실패했습니다');}
     };
     setTimeout(()=>{if(!done)finish('촬영 위치 응답 시간이 초과됐습니다');},10000);
     try{window.NativeHost.post('diaryMediaLocation',JSON.stringify({request,id}));}
     catch(_){finish('GPS 정보 연결에 실패했습니다');}
    }
   }
  }
 };
 try{return !!bridge.open(JSON.stringify(payload));}
 catch(error){console.warn('R667 dedicated picker bridge',error);return false;}
}
function r621OpenPreview(items,index,update,save){
 // R679: 23414.mp4 rejects the look-alike WebView. Use the exact original native
 // classes6 Gallery or report a real bridge failure; never silently show 42/113 imitation.
 const nonce=++r679PreviewNonce;
 if(r667PickerNativePreview(items,index,update))return;
 let attempt=0;
 const nativeRetry=()=>{
  if(nonce!==r679PreviewNonce||!ui.open||ui.page!=='picker')return;
  if(r667PickerNativePreview(items,index,update))return;
  if(++attempt<18){setTimeout(nativeRetry,170);return;}
  r619PickerStatus('원본 네이티브 갤러리를 연결하지 못했습니다. 사진 추가 화면에서 다시 선택해 주세요.');
 };
 setTimeout(nativeRetry,170);
 return; // The old R621 imitation is intentionally unreachable, all original PHOTO/DETAIL untouched.
 r621ClosePreview();r621PreviewAssets=items;r621PreviewIndex=Math.max(0,Math.min(items.length-1,index));
 const outer=elem('div','moa-r621-preview moa-r623-preview');outer.setAttribute('role','dialog');outer.setAttribute('aria-modal','true');outer.setAttribute('aria-label','사진 동영상 큰 미리보기와 선택');r621PreviewHost=outer;
 const header=elem('div','moa-r621-preview-top'),count=elem('span','moa-r623-preview-index'),selectedCount=elem('span','moa-r623-preview-count'),exit=btn('×',r621ClosePreview,'moa-r621-preview-exit');
 header.append(count,selectedCount,exit);outer.append(header);
 const frame=elem('div','moa-r621-preview-frame moa-r658-preview-stage');
 const mediaHost=elem('div','moa-r658-preview-media');frame.append(mediaHost);outer.append(frame);
 const infoPane=elem('aside','moa-r658-preview-info');infoPane.hidden=true;frame.append(infoPane);
 const railWrap=elem('section','moa-r623-preview-railwrap'),railTop=elem('div','moa-r623-preview-rail-top');
 const railTitle=elem('strong','','사진·영상 필름스트립');
 const fastButton=btn('',()=>{r623PreviewFast=!r623PreviewFast;r623RememberPreference();updateRailControls();},'moa-r623-fast-toggle');
 const railButton=btn('',()=>{r623PreviewRailVisible=!r623PreviewRailVisible;r623RememberPreference();updateRailControls();},'moa-r623-rail-toggle');
 railTop.append(railTitle,fastButton,railButton);
 const rail=elem('div','moa-r623-preview-rail');rail.setAttribute('aria-label','사진·영상 좌우 관성 필름스트립');
 railWrap.append(railTop,rail);frame.append(railWrap);
 const footer=elem('div','moa-r621-preview-bottom moa-r623-preview-bottom moa-r658-preview-actions');
 const glyphs={
  star:'<path d="m12 2 3.15 6.6 7.25 1-5.25 5.1 1.2 7.3L12 18.6l-6.35 3.4 1.2-7.3L1.6 9.6l7.25-1z"/>',
  fast:'<path d="m2 5 7 7-7 7m1-14 7 7-7 7"/>',
  share:'<circle cx="18" cy="5" r="2"/><circle cx="6" cy="12" r="2"/><circle cx="18" cy="19" r="2"/><path d="M8 11l8-5M8 13l8 5"/>',
  pin:'<path d="M20 10c0 5-8 12-8 12S4 15 4 10a8 8 0 1116 0z"/><circle cx="12" cy="10" r="2.4"/>',
  map:'<path d="M3 6.5l6-3 6 3 6-3v14l-6 3-6-3-6 3zM9 3.5v14M15 6.5v14"/>',
  bookmark:'<path d="M5 3.5h14v17l-7-4-7 4z"/><path d="M9 8.5h6m-3-3v6"/>',
  rail:'<rect x="2" y="5" width="20" height="14" rx="2"/><path d="M8 5v14m8-14v14"/>',
  expand:'<path d="M8 3H3v5m13-5h5v5M3 16v5h5m13-5v5h-5"/>',
  add:'<path d="M12 5v14M5 12h14"/><circle cx="12" cy="12" r="10"/>'
 };
 const tool=(name,label,handler)=>{const b=btn('',handler,'moa-r658-preview-tool moa-r658-tool-'+name);b.setAttribute('aria-label',label);
  b.innerHTML='<svg viewBox="0 0 24 24" width="23" height="23" fill="none" stroke="currentColor" stroke-width="1.7" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">'+glyphs[name]+'</svg>';footer.append(b);return b;};
 const showInfo=(openMap=false)=>{
  if(!openMap&&!infoPane.hidden){infoPane.hidden=true;infoPane.replaceChildren();return;}
  const media=r621PreviewAssets[r621PreviewIndex];if(!media)return;
  infoPane.hidden=false;infoPane.replaceChildren();
  infoPane.append(btn('×',()=>{infoPane.hidden=true;infoPane.replaceChildren();},'moa-r658-info-exit'));
  infoPane.append(elem('div','moa-r658-info-date','촬영 '+new Date(Number(media.t)||Date.now()).toLocaleString('ko-KR')));
  const geo=elem('div','moa-r658-info-geo');infoPane.append(geo);
  if(typeof window.FamilyJourneyDiaryGeo?.attach!=='function'){geo.textContent='위치 정보 연결 불가';return;}
  try{window.FamilyJourneyDiaryGeo.attach(geo,String(media.id));}catch(_){geo.textContent='위치 정보를 불러올 수 없습니다';return;}
  if(openMap){const observer=new MutationObserver(()=>{
   if(!infoPane.isConnected||infoPane.hidden){observer.disconnect();return;}
   const b=[...geo.querySelectorAll('button')].find(v=>v.textContent?.trim()==='네이버지도');
   if(b){observer.disconnect();b.click();}
  });observer.observe(geo,{subtree:true,childList:true});setTimeout(()=>observer.disconnect(),3000);}
 };
 const coverButton=tool('star','현재 일기의 대표 사진 지정',async()=>{
  const media=r621PreviewAssets[r621PreviewIndex];if(!media)return;
  if(dayOf(Number(media.t))!==r619AuxDate){notify('선택한 일기 날짜의 사진만 대표로 지정할 수 있습니다.');return;}
  await saveCover(media.id);
 });
 const fastAction=tool('fast','큰 사진 빠른 넘김',()=>{r623PreviewFast=!r623PreviewFast;r623RememberPreference();updateRailControls();});
 tool('share','현재 사진·영상 공유',()=>{const m=r621PreviewAssets[r621PreviewIndex];if(m&&!nativePost(isVideo(m)?'diaryShareVideo':'sharePhoto',{id:String(m.id)}))notify('공유 기능을 연결할 수 없습니다.');});
 tool('pin','촬영 시간 및 위치',()=>showInfo(false));
 tool('map','현재 사진 네이버 지도 위치',()=>showInfo(true));
 const bookmarkAction=tool('bookmark','현재 사진 위치 네이버 지도에 저장',()=>{
  const media=r621PreviewAssets[r621PreviewIndex];if(!media)return;
  // Use the user's existing first-party Naver/MediaStore bridge, not Gallery owner.
  if(!window.NativeHost?.post||typeof window.FamilyJourneyNaver?.saveFromDiaryGps!=='function'){
   notify('네이버 장소 저장 연결을 사용할 수 없습니다.');return;
  }
  infoPane.hidden=false;infoPane.replaceChildren();
  const closeBtn=btn('×',()=>{infoPane.hidden=true;},'moa-r658-info-exit');
  const label=elem('strong','','현재 사진의 촬영 위치 저장');
  const hint=elem('p','','원본 사진의 GPS 위치를 확인한 후 네이버 지도 저장을 실행합니다.');
  const go=btn('네이버 지도 장소 저장',()=>{
   go.disabled=true;go.textContent='사진 위치 확인 중…';
   const id=String(media.id).replace(/^v/,'');
   if(!/^\d{1,18}$/.test(id)){go.textContent='위치를 확인할 수 없습니다';return;}
   const request=1886000000+(Math.floor(Math.random()*900000));
   const previous=window.__fjDiaryMediaLocationResult;
   let done=false;
   const onResult=(rid,value)=>{
    if(Number(rid)!==request){if(typeof previous==='function')previous(rid,value);return;}
    if(done)return;done=true;window.__fjDiaryMediaLocationResult=previous;
    const latitude=Number(value?.lat),longitude=Number(value?.lon);
    if(!value?.hasGps||!Number.isFinite(latitude)||!Number.isFinite(longitude)){
     go.textContent='GPS 위치 정보가 없습니다';go.disabled=false;return;
    }
    const list=prompt('네이버 지도에 저장할 리스트 이름 (선택)', '');
    if(list===null){go.textContent='사용자가 저장을 취소했습니다';go.disabled=false;return;}
    if(!infoPane.isConnected)return;
    try{
     const accepted=window.FamilyJourneyNaver.saveFromDiaryGps(
      {...value,id,lat:latitude,lon:longitude},'', '',list.slice(0,70),
      result=>{go.textContent=String(result?.message||result?.state||'네이버 지도 저장 확인 중');go.disabled=false;},
      {mode:'web'});
     if(!accepted){go.textContent='저장 요청이 수락되지 않았습니다';go.disabled=false;}
    }catch(_){go.textContent='네이버 장소 저장 실패';go.disabled=false;}
   };
   window.__fjDiaryMediaLocationResult=onResult;
   setTimeout(()=>{if(!done&&window.__fjDiaryMediaLocationResult===onResult){
    done=true;window.__fjDiaryMediaLocationResult=previous;
    if(go.isConnected){go.textContent='GPS 응답 시간 초과';go.disabled=false;}
   }},10000);
   try{window.NativeHost.post('diaryMediaLocation',JSON.stringify({request,id}));}
   catch(_){window.__fjDiaryMediaLocationResult=previous;go.textContent='GPS 연결 실패';go.disabled=false;}
  },'moa-r665-bookmark-save');
  infoPane.append(closeBtn,label,hint,go);
 });
 const railAction=tool('rail','필름스트립 펼치기 또는 접기',()=>{r623PreviewRailVisible=!r623PreviewRailVisible;r623RememberPreference();updateRailControls();});
 const fillAction=tool('expand','사진 전체화면 보기',()=>{
  outer.classList.toggle('moa-r665-immersive');
  fillAction.classList.toggle('is-active',outer.classList.contains('moa-r665-immersive'));
 });
 mediaHost.addEventListener('dblclick',()=>frame.classList.toggle('moa-r658-fill'));

 const toggle=tool('add','현재 사진·영상 선택 또는 해제',()=>{
  const id=String(r621PreviewAssets[r621PreviewIndex]?.id||'');if(!safeMedia(id))return;
  r623SetSelection(id,!r619PickSelection.has(id),update);paint('toggle');
 });
 frame.append(footer);
 let swipe=null,lastRailLow=-1,lastRailHigh=-1,railInteracting=false,railScrollDebounce=0,railScrollFrame=0,railProgrammaticUntil=0;
 const railFocused=()=>{let best=null,dist=Infinity;const center=rail.scrollLeft+rail.clientWidth/2;for(const tile of rail.children){const delta=Math.abs(tile.offsetLeft-rail.offsetLeft+tile.clientWidth/2-center);if(delta<dist){dist=delta;best=tile;}}return best;};
 const highlightRail=()=>{const candidate=railFocused();if(!candidate)return;for(const tile of rail.children)tile.classList.toggle('active',tile===candidate);};
 function updateRailControls(){
  fastButton.textContent=r623PreviewFast?'빠른 이동 ON':'빠른 이동 OFF';fastButton.setAttribute('aria-pressed',String(r623PreviewFast));
  railButton.textContent=r623PreviewRailVisible?'필름스트립 접기':'필름스트립 펼치기';railButton.setAttribute('aria-expanded',String(r623PreviewRailVisible));
  // R625: Fast ON/OFF affects ONLY full-size photo swipes. The rail keeps native-style inertia in BOTH modes.
  railWrap.classList.toggle('is-collapsed',!r623PreviewRailVisible);rail.classList.remove('is-fast');frame.classList.toggle('is-fast',r623PreviewFast);
  fastAction.classList.toggle('is-active',r623PreviewFast);railAction.classList.toggle('is-active',r623PreviewRailVisible);
 }
 function shift(step,source='swipe'){
  const nextIndex=Math.max(0,Math.min(r621PreviewAssets.length-1,r621PreviewIndex+step));
  if(nextIndex===r621PreviewIndex)return;
  r621PreviewIndex=nextIndex;paint(source);
 }
 frame.addEventListener('pointerdown',e=>{if(e.pointerType==='mouse'&&e.button!==0)return;if(e.target.closest('.moa-r623-preview-railwrap,.moa-r658-preview-actions,.moa-r658-preview-info,.moa-r625-video-controls')){swipe=null;return;}swipe={x:e.clientX,y:e.clientY,at:performance.now()};},{passive:true});
 frame.addEventListener('pointerup',e=>{
  if(!swipe)return;const dx=e.clientX-swipe.x,dy=e.clientY-swipe.y,dt=Math.max(40,performance.now()-swipe.at);swipe=null;
  if(Math.abs(dx)<38||Math.abs(dx)<Math.abs(dy)*1.13)return;
  const speed=Math.abs(dx)/dt;
  const steps=r623PreviewFast?Math.min(9,Math.max(1,Math.round(Math.abs(dx)/78+speed*3))):1;
  shift((dx<0?1:-1)*steps,'swipe');
 },{passive:true});
 frame.addEventListener('pointercancel',()=>{swipe=null},{passive:true});
 rail.addEventListener('pointerdown',()=>{railInteracting=true;railProgrammaticUntil=0;},{passive:true});
 rail.addEventListener('wheel',()=>{railProgrammaticUntil=0;},{passive:true});
 rail.addEventListener('pointerup',()=>{railInteracting=false;},{passive:true});
 rail.addEventListener('pointercancel',()=>{railInteracting=false;},{passive:true});
 // A flick of the bottom strip momentarily highlights the centered image; on
 // scroll settle it opens that image without cancelling the rail's inertia.
 rail.addEventListener('scroll',()=>{
  if(Date.now()<railProgrammaticUntil)return;
  if(railScrollFrame)cancelAnimationFrame(railScrollFrame);
  railScrollFrame=requestAnimationFrame(()=>{railScrollFrame=0;highlightRail();});
  clearTimeout(railScrollDebounce);railScrollDebounce=setTimeout(()=>{
   const tile=railFocused(),n=Number(tile?.dataset.index);
   if(!tile||!Number.isSafeInteger(n)||n===r621PreviewIndex)return;
   r621PreviewIndex=n;paint('rail-scroll');
  },170);
 },{passive:true});
 rail.addEventListener('click',e=>{
  const cell=e.target.closest('.moa-r623-preview-rail-tile');if(!cell||!rail.contains(cell))return;
  const value=Number(cell.dataset.index);if(!Number.isSafeInteger(value))return;
  r621PreviewIndex=value;paint('rail');
 });
 outer.addEventListener('keydown',e=>{
  if(e.key==='Escape'){r621ClosePreview();e.preventDefault();e.stopPropagation();}
  if(e.key==='ArrowLeft'){shift(-1,'arrow');e.preventDefault();}
  if(e.key==='ArrowRight'){shift(1,'arrow');e.preventDefault();}
 });
 function renderRail(){
  // Windowed 125-thumbnail filmstrip: enough kinetic travel without forcing
  // thousands of WebView/MediaStore thumbnail requests at once.
  const lo=Math.max(0,r621PreviewIndex-62),hi=Math.min(r621PreviewAssets.length,lo+125);
  if(lastRailLow===lo&&lastRailHigh===hi)return;
  lastRailLow=lo;lastRailHigh=hi;rail.replaceChildren();
  const imgs=[];
  for(let n=lo;n<hi;n++){
   const p=r621PreviewAssets[n],id=String(p.id);
   const cell=btn('','', 'moa-r623-preview-rail-tile');cell.dataset.index=n;cell.dataset.id=id;
   cell.setAttribute('aria-label',dateLabel(dayOf(Number(p.t)))+' '+(isVideo(p)?'동영상':'사진')+' '+(n+1)+'번 보기');
   const img=elem('img');img.dataset.id=id;img.loading='lazy';img.alt='';cell.append(img);
   if(isVideo(p))cell.append(elem('span','moa-r623-rail-video','▶'));
   const mark=elem('span','moa-r623-rail-num');cell.append(mark);rail.append(cell);imgs.push(img);
  }
  r623RailThumbObserver?.disconnect();r623RailThumbObserver=null;
  if(typeof IntersectionObserver==='function'){
   r623RailThumbObserver=new IntersectionObserver(entries=>{
    const near=entries.filter(e=>e.isIntersecting).map(e=>e.target);
    for(const img of near)r623RailThumbObserver?.unobserve(img);
    if(near.length)fillImages(near,false);
   },{root:rail,rootMargin:'190px'});
   for(const img of imgs)r623RailThumbObserver.observe(img);
  }else fillImages(imgs.filter((_,i)=>i>=Math.max(0,r621PreviewIndex-lo-7)&&i<=r621PreviewIndex-lo+7),false);
 }
 function syncRail(source){
  renderRail();
  const order=new Map([...r619PickSelection].map((id,i)=>[id,i+1]));
  for(const cell of rail.children){const idx=Number(cell.dataset.index);const current=idx===r621PreviewIndex;
   cell.classList.toggle('active',current);const n=order.get(String(cell.dataset.id))||0;
   cell.classList.toggle('selected',!!n);cell.setAttribute('aria-current',current?'true':'false');const mark=cell.querySelector('.moa-r623-rail-num');if(mark)mark.textContent=n?String(n):'';
  }
  const chosen=rail.querySelector('.moa-r623-preview-rail-tile.active');
  if(chosen&&!railInteracting&&!['rail','rail-scroll'].includes(source)&&r623PreviewRailVisible){
   try{railProgrammaticUntil=Date.now()+550;clearTimeout(railScrollDebounce);const left=chosen.offsetLeft-rail.offsetLeft-rail.clientWidth/2+chosen.clientWidth/2;rail.scrollTo({left:Math.max(0,left),behavior:r623PreviewFast?'instant':'smooth'});}catch(_){/* optional */}
  }
 }
 function paint(source='open'){
  const p=r621PreviewAssets[r621PreviewIndex];if(!p)return;
  const id=String(p.id),picked=r623SelectionNumber(id);
  count.textContent=`${r621PreviewIndex+1} / ${r621PreviewAssets.length} · ${dateLabel(dayOf(Number(p.t)))}`;
  selectedCount.textContent=`선택 ${r619PickSelection.size}개`;
  for(const oldVideo of mediaHost.querySelectorAll('video'))try{oldVideo.pause();oldVideo.removeAttribute('src');oldVideo.load()}catch(_){}
  mediaHost.replaceChildren();infoPane.hidden=true;infoPane.replaceChildren();
  const photo=elem('img');photo.dataset.id=id;photo.alt='사진 또는 동영상 확대 미리보기';mediaHost.append(photo);
  // Actual original photo ContentResolver image rather than the small map thumbnail.
  // If the Android WebView blocks content://, fall back to the original 2048px native bridge.
  const isMovie=isVideo(p);
  if(!isMovie && /^\d{1,19}$/.test(id)){
   let settled=false;const fallback=()=>{if(settled||!photo.isConnected)return;settled=true;photo.onload=null;photo.onerror=null;photo.dataset.imageTier='native2048';photo.removeAttribute('src');fillImages([photo],true);};
   const timeout=setTimeout(fallback,1800);
   photo.onload=()=>{if(settled)return;settled=true;clearTimeout(timeout);photo.dataset.fullLoaded='1';photo.dataset.imageTier='original';photo.classList.add('moa-r472-image-ready');};
   photo.onerror=()=>{clearTimeout(timeout);fallback();};
   photo.dataset.imageTier='original-pending';photo.src='content://media/external/images/media/'+encodeURIComponent(id);
  }else{photo.dataset.imageTier='native2048';fillImages([photo],true);}
  if(isMovie){
   mediaHost.append(elem('span','moa-r621-preview-video','동영상'));
   const player=elem('video','moa-r621-preview-player');player.preload='metadata';player.playsInline=true;player.controls=false;
   player.setAttribute('playsinline','');player.setAttribute('webkit-playsinline','');
   const controls=elem('div','moa-r625-video-controls'),status=elem('span','moa-r625-video-clock','00:00 / --:--');
   const play=btn('▶',()=>{if(player.paused){player.play().catch(()=>{status.textContent='재생할 수 없는 파일입니다';});}else player.pause();},'moa-r625-video-play');
   play.setAttribute('aria-label','동영상 재생 또는 일시정지');
   const seek=elem('input','moa-r625-video-seek');seek.type='range';seek.min='0';seek.max='1000';seek.value='0';seek.step='1';seek.setAttribute('aria-label','동영상 재생 위치');
   const time=seconds=>{if(!Number.isFinite(seconds)||seconds<0)return '--:--';const n=Math.floor(seconds);return Math.floor(n/60).toString().padStart(2,'0')+':'+(n%60).toString().padStart(2,'0');};
   const tick=()=>{const duration=player.duration;status.textContent=time(player.currentTime)+' / '+time(duration);if(!seek.matches(':active')&&Number.isFinite(duration)&&duration>0)seek.value=String(Math.round(player.currentTime/duration*1000));};
   const jump=()=>{if(Number.isFinite(player.duration)&&player.duration>0)player.currentTime=Number(seek.value)/1000*player.duration;tick();};
   seek.addEventListener('input',jump);seek.addEventListener('change',jump);
   player.addEventListener('loadedmetadata',tick);player.addEventListener('timeupdate',tick);
   player.addEventListener('play',()=>play.textContent='Ⅱ');player.addEventListener('pause',()=>play.textContent='▶');
   player.addEventListener('ended',()=>play.textContent='▶');
   player.addEventListener('error',()=>{player.style.display='none';status.textContent='원본 영상 재생 불가';play.disabled=true;});
   const mute=btn('♬',()=>{player.muted=!player.muted;mute.textContent=player.muted?'♩':'♬';mute.setAttribute('aria-pressed',String(player.muted));},'moa-r665-video-mute');mute.setAttribute('aria-label','동영상 음소거 토글');controls.append(play,mute,seek,status);mediaHost.append(player,controls);
   const movieId=id.replace(/^v/,'');
   if(/^\d{1,19}$/.test(movieId))player.src='content://media/external/video/media/'+encodeURIComponent(movieId);
   else{status.textContent='동영상 원본 주소를 사용할 수 없습니다';play.disabled=true;}
   // Real MediaStore stream when WebView content permission permits. Native Gallery
   // video engine/decoder and the user's video bytes are never altered.
  }
  if(source==='swipe'||source==='arrow')try{photo.animate([{opacity:.68,transform:'translateX(10px)'},{opacity:1,transform:'translateX(0)'}],{duration:r623PreviewFast?115:175,easing:'ease-out'});}catch(_){}
  toggle.classList.toggle('is-selected',!!picked);toggle.setAttribute('aria-pressed',String(!!picked));
  toggle.setAttribute('aria-label',picked?`${picked}번 선택됨 · 눌러 선택 해제`:'현재 사진·영상 선택');
  coverButton.classList.toggle('is-active',String(getState()?.covers?.[ui.source]?.[r619AuxDate]||'')===id);
  bookmarkAction.classList.remove('is-active');
  updateRailControls();syncRail(source);
 }
 view.append(outer);outer.tabIndex=-1;outer.focus();paint();
}
// R665: picker-only equivalent of the PHOTO/detail 42px date rail.
// The existing PHOTO native Gallery and day-navigation functions are immutable.
function r665PickerGoDay(day){
 if(!valid(day)||!ui.open||ui.page!=='picker')return;
 // A date jump must start its groups from ZERO. The old cursor survived
 // re-render and silently skipped every photo in the destination date.
 r619AuxDate=day;ui.date=day;ui.selected=day;
 r619PickerGroupCount=0;
 r621CleanPickerObservers();render();
}
function r665PickerPeriodSheet(day){
 const old=view.querySelector('.moa-r665-picker-sheet-backdrop');if(old)old.remove();
 const d=new Date(day+'T12:00:00');let year=d.getFullYear(),month=d.getMonth(),selected=d.getDate();
 const shade=elem('div','moa-r479-picker-backdrop moa-r621-sheet-backdrop moa-r665-picker-sheet-backdrop');
 const sheet=elem('section','moa-r479-picker-sheet moa-r483-picker-sheet moa-r621-period-sheet');
 sheet.setAttribute('role','dialog');sheet.setAttribute('aria-modal','true');sheet.setAttribute('aria-label','사진 추가 날짜 선택');
 const heading=elem('div','moa-r479-picker-heading');heading.append(elem('strong','','연도 · 월 선택'),btn('×',()=>shade.remove(),'moa-r479-picker-close'));sheet.append(heading);
 const labels=elem('div','moa-r483-picker-labels');labels.append(elem('span','','연도'),elem('span','','월'));sheet.append(labels);
 const wheel=elem('div','moa-r483-picker-columns'),years=elem('div','moa-r483-year-list'),months=elem('div','moa-r483-picker-months');
 const days=elem('div','moa-r621-day-grid');
 years.setAttribute('role','listbox');months.setAttribute('role','listbox');
 const redraw=()=>{
  for(const c of years.children){let active=Number(c.dataset.year)===year;c.classList.toggle('active',active);c.setAttribute('aria-selected',String(active));}
  for(const c of months.children){let active=Number(c.dataset.month)===month;c.classList.toggle('active',active);c.setAttribute('aria-selected',String(active));}
  selected=Math.min(selected,new Date(year,month+1,0).getDate());days.replaceChildren();
  for(let n=1;n<=new Date(year,month+1,0).getDate();n++){
   const target=dayOf(new Date(year,month,n,12).getTime());
   const b=btn(String(n),()=>{shade.remove();r665PickerGoDay(target);},'moa-r621-day-option'+(selected===n?' active':''));
   b.setAttribute('aria-label',dateLabel(target)+' 사진 추가 날짜');days.append(b);
  }
 };
 for(let y=1900;y<=2100;y++){const b=btn(String(y),()=>{year=y;redraw()},'moa-r483-year-option'+(y===year?' active':''));b.dataset.year=y;years.append(b);}
 for(let m=0;m<12;m++){const b=btn(String(m+1)+'월',()=>{month=m;redraw()},'moa-r483-month-option'+(month===m?' active':''));b.dataset.month=m;months.append(b);}
 wheel.append(years,months);sheet.append(wheel,elem('p','moa-r479-picker-hint','연도·월을 스크롤하고 날짜를 선택하세요.'),days);shade.append(sheet);view.append(shade);redraw();
 requestAnimationFrame(()=>{for(const w of [years,months]){const c=w.querySelector('.active');if(c)w.scrollTop=c.offsetTop-w.offsetTop-w.clientHeight/2+c.clientHeight/2;}});
 shade.addEventListener('click',e=>{if(e.target===shade)shade.remove()});
}
function r665PickerDateRail(day){
 const host=elem('div','moa-r619-date-host moa-r665-date-host'),label=btn(dateLabel(day),()=>{},'moa-r619-date-fixed');host.append(label);
 label.setAttribute('aria-label',dateLabel(day)+' · 날짜 좌우 스와이프, 눌러 연월일 선택');
 let gesture=null,hold=0,fling=0,suppress=0;
 const stop=()=>{clearTimeout(hold);hold=0};
 const show=delta=>{label.textContent=dateLabel(r619ShiftDay(day,delta))};
 label.addEventListener('pointerdown',e=>{
  if(e.pointerType==='mouse'&&e.button!==0)return;
  clearInterval(fling);stop();gesture={id:e.pointerId,x:e.clientX,y:e.clientY,dx:0,vx:0,lastX:e.clientX,lastT:performance.now(),preview:0};
  try{label.setPointerCapture(e.pointerId)}catch(_){}
  hold=setTimeout(()=>{if(!gesture)return;gesture=null;suppress=Date.now()+650;r665PickerPeriodSheet(day);},560);
 },{passive:true});
 label.addEventListener('pointermove',e=>{
  const g=gesture;if(!g||g.id!==e.pointerId)return;
  const dx=e.clientX-g.x,dy=e.clientY-g.y;
  if(Math.abs(dx)>9||Math.abs(dy)>9)stop();
  if(Math.abs(dx)<Math.abs(dy)*1.15)return;
  const now=performance.now(),dt=Math.max(16,now-g.lastT);g.vx=.62*g.vx+.38*Math.max(-2,Math.min(2,(e.clientX-g.lastX)/dt));g.lastX=e.clientX;g.lastT=now;g.dx=dx;
  const n=Math.max(-20,Math.min(20,Math.round(-dx/46)));if(n!==g.preview){g.preview=n;show(n)};
 },{passive:true});
 const done=e=>{
  const g=gesture;if(!g||g.id!==e.pointerId)return;gesture=null;stop();
  if(Math.abs(g.dx)<16){show(0);return;}
  suppress=Date.now()+450;const raw=-g.dx/72-g.vx*2.1;
  const steps=Math.max(-14,Math.min(14,Math.round(raw)||(-g.dx>0?1:-1)));
  const duration=Math.min(340,130+Math.abs(steps)*15),began=performance.now();let shown=g.preview;
  fling=setInterval(()=>{
   if(!host.isConnected){clearInterval(fling);return;}
   const t=Math.min(1,(performance.now()-began)/duration),eased=1-Math.pow(1-t,3),n=Math.round(g.preview+(steps-g.preview)*eased);
   if(n!==shown){shown=n;show(n)}
   if(t>=1){clearInterval(fling);fling=0;r665PickerGoDay(r619ShiftDay(day,steps));}
  },28);
 };
 label.addEventListener('pointerup',done,{passive:true});label.addEventListener('pointercancel',()=>{gesture=null;stop();show(0);},{passive:true});
 label.addEventListener('click',()=>{if(Date.now()>=suppress)r665PickerPeriodSheet(day)});
 label.addEventListener('contextmenu',e=>e.preventDefault());return host;
}
function r665PickerScopePill(){
 const outer=elem('div','moa-r483-oval-switch moa-r483-day-mode moa-r665-picker-scope');outer.dataset.source=r619PickerScope;
 outer.setAttribute('role','group');outer.setAttribute('aria-label','사진 날짜 범위');
 const thumb=elem('span','moa-r483-thumb');outer.append(thumb);
 for(const val of ['day','all']){
  const b=btn('',()=>{if(r619PickerScope===val)return;r619PickerScope=val;r619PickerGroupCount=0;r621CleanPickerObservers();render();},'moa-r483-toggle-hit');
  b.dataset.option=val;b.title=val==='day'?'해당 날짜':'전체 날짜';b.setAttribute('aria-label',b.title);b.setAttribute('aria-pressed',String(r619PickerScope===val));outer.append(b);
 }
 // The same 34px interactive geometry as PHOTO/DETAIL switch.
 let x0=null;outer.addEventListener('pointerdown',e=>{x0=e.clientX});
 outer.addEventListener('pointerup',e=>{if(x0==null)return;const dx=e.clientX-x0;x0=null;
  if(Math.abs(dx)>16){const next=dx>0?'all':'day';outer.querySelector('[data-option="'+next+'"]')?.click();}
 });
 return outer;
}
function r619RenderPicker(){
 r621CleanPickerObservers();
 r619PickerGroupCount=0; // Recreated picker DOM never inherits the old list cursor.
 const day=r619AuxDate||ui.date,shell=elem('section','moa-r619-picker-screen moa-r665-picker-screen');
 // Header shares the exact photo/detail 49px row, 14px date rail and 68x34 switch.
 // Fixed as a non-scrolling flex child; photo grids have their own scroll viewport.
 const head=elem('header','moa-r665-picker-header');
 // Deliberately NO back arrow: horizontal date gestures + Android Back remain.

 const dateHost=elem('div','moa-r539-day-head');dateHost.append(r665PickerDateRail(day));
 const controls=elem('div','moa-r539-day-controls moa-r667-picker-controls');
 const scope=r665PickerScopePill();controls.append(scope);
 const today=btn('',()=>{
   const now=dayOf(Date.now());
   // Always rehydrate today's groups, even if user is already on today's day.
   // An old scope and the previous group cursor must not leave an empty grid.
   r619PickerScope='day';
   r665PickerGoDay(now);
 },'moa-r667-today-pill');
 today.setAttribute('aria-label','오늘 날짜로 이동');today.setAttribute('title','오늘로 이동');
 // R681: TODAY is a one-tap fixed calendar symbol, never a slider.
 today.innerHTML='<svg viewBox="0 0 24 24" aria-hidden="true" focusable="false" fill="none" stroke="currentColor" stroke-width="1.9" stroke-linecap="round" stroke-linejoin="round"><rect x="3.5" y="5" width="17" height="15.5" rx="2.5"/><path d="M8 3v4M16 3v4M3.5 10h17"/><circle cx="12" cy="15" r="2.5" fill="currentColor" stroke="none"/></svg>';
 controls.append(today);
 head.append(dateHost,controls);shell.append(head);
 const intro=elem('p','moa-r619-picker-intro moa-r658-picker-status');intro.hidden=true;shell.append(intro);
 const groupsHost=elem('div','moa-r619-picker-groups moa-r665-picker-scroll');groupsHost.setAttribute('role','region');groupsHost.setAttribute('aria-label','날짜별 사진과 영상 목록');shell.append(groupsHost);
 // R658: ONE bottom black save capsule, aligned above the existing app tabbar.
 const footer=elem('div','moa-r658-picker-bottom');
 const save=btn('선택 0개 · 사진 추가',()=>r619CommitPicked(save),'moa-r619-picker-save moa-r658-picker-save');
 save.disabled=true;save.setAttribute('aria-label','선택한 사진과 영상을 날짜의 일기에 추가');footer.append(save);
 shell.append(footer);view.append(shell);
 const all=r619PickerAssets(),grouped=new Map();for(const p of all){const d=dayOf(Number(p.t));if(!grouped.has(d))grouped.set(d,[]);grouped.get(d).push(p);}
 r619PickerGroups=[...grouped.entries()].sort((a,b)=>b[0].localeCompare(a[0]));
 const update=()=>{
  save.disabled=!r619PickSelection.size;
  save.textContent=`선택 ${r619PickSelection.size}개 · 사진 추가`;
  const order=new Map([...r619PickSelection].map((id,i)=>[id,i+1]));
  for(const tile of groupsHost.querySelectorAll('.moa-r619-picker-tile')){
   const id=String(tile.dataset.id),number=order.get(id)||0;
   tile.classList.toggle('selected',!!number);
   tile.setAttribute('aria-pressed',String(!!number));
   tile.setAttribute('aria-label',number?`${number}번 선택된 사진·영상, 다시 누르면 해제`:'사진·영상 선택');
   const circle=tile.querySelector('.moa-r619-picker-check');if(circle)circle.textContent=number?String(number):'';
  }
 };update();
 const media=all,chunk=32;
 const mediaIndex=new Map(media.map((p,i)=>[String(p.id),i]));
 const addTile=(p,d,j,grid)=>{
  const id=String(p.id),tile=elem('div','moa-r619-picker-tile');tile.dataset.id=id;
  tile.tabIndex=0;tile.setAttribute('role','button');
  tile.setAttribute('aria-label',dateLabel(d)+(isVideo(p)?' 동영상':' 사진')+' 선택 또는 해제');
  const img=elem('img');img.dataset.id=id;img.loading='lazy';img.alt='';tile.append(img);
  const check=elem('span','moa-r619-picker-check','');check.setAttribute('aria-hidden','true');tile.append(check);
  const zoom=btn('',()=>{},'moa-r623-grid-zoom');
  zoom.innerHTML='<svg viewBox="0 0 18 18" width="12" height="12" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"><path d="M6.5 2.5h-4v4m9-4h4v4m-13 5v4h4m9-4v4h-4"/></svg>';
  zoom.setAttribute('aria-label',dateLabel(d)+' '+(isVideo(p)?'동영상':'사진')+' 확대 보기');
  zoom.addEventListener('click',e=>{e.preventDefault();e.stopPropagation();r621OpenPreview(media,mediaIndex.get(id),update,save);});
  tile.append(zoom);
  if(isVideo(p))tile.append(elem('span','moa-r619-picker-video','▶ 동영상'));
  tile.addEventListener('click',e=>{
   if(Date.now()<r623SuppressTileClickUntil||e.target.closest('.moa-r623-grid-zoom'))return;
   r623SetSelection(id,!r619PickSelection.has(id),update);
  });
  tile.addEventListener('keydown',e=>{if(e.key==='Enter'||e.key===' '){e.preventDefault();r623SetSelection(id,!r619PickSelection.has(id),update);}});
  grid.append(tile);
 };
 // Long-touch and sweep selection use the SAME Set as preview and commit.
 // Before the long hold, ordinary vertical WebView inertia remains untouched.
 let startPoint=null;
 const dragApply=(id)=>{
  const g=r623Drag;if(!g||!g.active)return;
  const endIndex=mediaIndex.get(String(id));if(endIndex===undefined||endIndex===g.lastIndex)return;
  g.lastIndex=endIndex;r619PickSelection.clear();for(const x of g.original)r619PickSelection.add(x);
  const step=endIndex>=g.startIndex?1:-1;
  for(let i=g.startIndex;step===1?i<=endIndex:i>=endIndex;i+=step){
   const item=String(media[i].id);if(g.deselect)r619PickSelection.delete(item);else r619PickSelection.add(item);
  }
  update();
 };
 const tileAt=(x,y)=>{
  const el=document.elementFromPoint(x,y),tile=el?.closest?.('.moa-r619-picker-tile');
  return tile&&groupsHost.contains(tile)?tile:null;
 };
 const beginAt=(x,y,identifier)=>{
  const tile=tileAt(x,y);if(!tile||document.elementFromPoint(x,y)?.closest?.('.moa-r623-grid-zoom'))return;
  const startIndex=mediaIndex.get(String(tile.dataset.id));if(startIndex===undefined)return;
  r623PickerDragStop();startPoint={x,y,id:identifier};
  const drag={active:false,startIndex,lastIndex:-1,original:new Set(r619PickSelection),deselect:r619PickSelection.has(String(tile.dataset.id)),x,y,id:identifier};r623Drag=drag;
  r623DragTimer=setTimeout(()=>{
   if(r623Drag!==drag||!groupsHost.isConnected)return;
   drag.active=true;r623SuppressTileClickUntil=Date.now()+900;
   dragApply(String(tile.dataset.id));
   try{navigator.vibrate?.(20)}catch(_){}
   const tick=()=>{
    if(r623Drag!==drag||!drag.active)return;
    const rect=groupsHost.getBoundingClientRect();
    const edge=56,offset=drag.y<rect.top+edge?-Math.min(18,(rect.top+edge-drag.y)*.55):drag.y>rect.bottom-edge?Math.min(18,(drag.y-(rect.bottom-edge))*.55):0;
    if(offset){groupsHost.scrollTop+=offset;const target=tileAt(drag.x,drag.y);if(target)dragApply(target.dataset.id);}
    r623DragAutoscroll=requestAnimationFrame(tick);
   };r623DragAutoscroll=requestAnimationFrame(tick);
  },360);
 };
 groupsHost.addEventListener('touchstart',e=>{if(e.touches.length!==1)return;const t=e.touches[0];beginAt(t.clientX,t.clientY,'touch');},{passive:true});
 groupsHost.addEventListener('touchmove',e=>{
  const g=r623Drag;if(!g||g.id!=='touch'||!e.touches.length)return;
  const t=e.touches[0];g.x=t.clientX;g.y=t.clientY;
  if(!g.active){if(Math.hypot(g.x-startPoint.x,g.y-startPoint.y)>10)r623PickerDragStop();return;}
  e.preventDefault();r623SuppressTileClickUntil=Date.now()+850;
  const tile=tileAt(g.x,g.y);if(tile)dragApply(tile.dataset.id);
 },{passive:false});
 groupsHost.addEventListener('touchend',()=>{if(r623Drag?.active)r623SuppressTileClickUntil=Date.now()+850;r623PickerDragStop();},{passive:true});
 groupsHost.addEventListener('touchcancel',r623PickerDragStop,{passive:true});
 groupsHost.addEventListener('mousedown',e=>{if(e.button!==0||e.target.closest('.moa-r623-grid-zoom'))return;beginAt(e.clientX,e.clientY,'mouse');});
 groupsHost.addEventListener('mousemove',e=>{
  const g=r623Drag;if(!g||g.id!=='mouse')return;g.x=e.clientX;g.y=e.clientY;
  if(!g.active){if(Math.hypot(g.x-startPoint.x,g.y-startPoint.y)>10)r623PickerDragStop();return;}
  const tile=tileAt(g.x,g.y);if(tile)dragApply(tile.dataset.id);
 });
 groupsHost.addEventListener('mouseup',()=>{if(r623Drag?.active)r623SuppressTileClickUntil=Date.now()+850;r623PickerDragStop();});
 groupsHost.addEventListener('mouseleave',()=>{if(r623Drag?.id==='mouse')r623PickerDragStop();});
 groupsHost.addEventListener('contextmenu',e=>{if(e.target.closest('.moa-r619-picker-tile'))e.preventDefault();});
 function appendGroups(){
  if(!groupsHost.isConnected)return;
  const end=Math.min(r619PickerGroups.length,r619PickerGroupCount+4);
  for(let i=r619PickerGroupCount;i<end;i++){
   const [d,photos]=r619PickerGroups[i],group=elem('section','moa-r619-picker-group');
   group.append(elem('strong','moa-r619-picker-date',dateLabel(d)+' · '+photos.length+'개'));
   const grid=elem('div','moa-r619-picker-rail'),watch=elem('div','moa-r621-row-sentinel');
   let cursor=0;
   const appendTiles=()=>{
    const end=Math.min(photos.length,cursor+chunk);
    const images=[];
    for(let j=cursor;j<end;j++){addTile(photos[j],d,j,grid);const img=grid.lastElementChild?.querySelector('img[data-id]');if(img)images.push(img);}
    cursor=end;if(cursor>=photos.length)rowObserver.disconnect();
    if(images.length)fillImages(images,false);
   };
   const rowObserver=new IntersectionObserver(entries=>{
    if(entries.some(e=>e.isIntersecting)&&ui.open&&ui.page==='picker')appendTiles();
   },{root:groupsHost,rootMargin:'350px'});
   group.append(grid,watch);groupsHost.insertBefore(group,groupsHost.querySelector('.moa-r619-picker-sentinel'));
   appendTiles();if(cursor<photos.length){rowObserver.observe(watch);r621RowObservers.push(rowObserver);}
  }
  r619PickerGroupCount=end;
 }
 if(!r619PickerGroups.length){groupsHost.append(elem('p','moa-r619-picker-empty',r619PickerScope==='day'?'이 날짜에 사진·영상이 없어요. ‘전체 기간’을 선택해 보세요.':'불러온 사진·영상이 없어요. ‘사진 다시 읽기’를 눌러 보세요.'));}
 else appendGroups();
 const sentinel=elem('div','moa-r619-picker-sentinel');groupsHost.append(sentinel);
 r619PickerObserver?.disconnect();r619PickerObserver=new IntersectionObserver(entries=>{
  if(entries.some(e=>e.isIntersecting)&&ui.open&&ui.page==='picker'&&r619PickerGroupCount<r619PickerGroups.length)appendGroups();
 },{root:groupsHost,rootMargin:'380px'});r619PickerObserver.observe(sentinel);
}
function r619PickerStatus(t){const x=view?.querySelector('.moa-r619-picker-intro');if(x){x.hidden=false;x.textContent=t;}}
async function r619CommitPicked(button){
 const ids=[...r619PickSelection].filter(safeMedia),day=r619AuxDate;
 if(!valid(day)||!ids.length||button.disabled)return;
 button.disabled=true;button.textContent='일기에 추가 중…';
 try{
  const d=await db();let updated=null;
  try{await new Promise((resolve,reject)=>{
   const tx=d.transaction('curated','readwrite'),store=tx.objectStore('curated');
   const req=store.get(day);req.onsuccess=()=>{
    const before=req.result||{day,photoIds:[],moments:[],activities:{},title:'',body:'',tags:[],feeling:'',selectionMode:'manual',source:'owner'};
    const photoIds=[...new Set([...(before.photoIds||[]).map(String),...ids])];
    const removed=new Set((before.removedMediaIds||[]).map(String));ids.forEach(x=>removed.delete(x));
    updated={...before,day,photoIds,removedMediaIds:[...removed],selectionMode:'manual',updatedAt:Date.now()};
    store.put(updated);
   };req.onerror=()=>{try{tx.abort()}catch(_){};};
   tx.oncomplete=resolve;tx.onerror=()=>reject(tx.error||Error('DB_WRITE_FAILED'));tx.onabort=()=>reject(tx.error||Error('DB_ABORTED'));
  });}finally{d.close();}
  const verify=await stored('curated',day);
  if(!verify||ids.some(id=>!(verify.photoIds||[]).map(String).includes(id)))throw Error('MEDIA_ID_READBACK_MISSING');
  const state=getState();state?.curatedEntries?.set(day,verify);
  if(state){state.mode='curated';if(state.date===day)ids.forEach(id=>state.selection?.add?.(id));}
  r619PickSelection.clear();r619ReturnFromAux();
  // Already committed IDs into the SAME IndexedDB store; original native Gallery
  // opens from refreshed index after returning, never reinitialize/replace engine.
 }catch(e){button.disabled=false;button.textContent='다시 추가';r619PickerStatus('사진·영상 추가 실패 · 일기를 삭제하지 않았어요: '+String(e));}
}
function r539DayChrome(mode,day,onPhoto,onDetail,onSettings){
 const frame=elem('div','moa-r539-day-chrome');
 const title=elem('header','moa-r539-day-head');title.append(r619DateRail(day,mode));
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
function r621EnterPhotoSettings(){
 if(!ui.open||ui.page!=='day')return;
 if(ui.dirty){notify('작성 중인 글을 먼저 저장해 주세요.');return;}
 const day=ui.date;r619AuxReturn='photo';r619AuxDate=day;
 r523DayExiting=true;window.__moaR567ProgrammaticCloseUntil=Date.now()+2300;
 const pending=!!window.__moaR507NativePending,opened=r507Opened;
 r507StopInline();if(pending&&!opened)try{window.MoaLocalAudio?.closeNativeGallery?.()}catch(_){}
 ui.page='settings';view.hidden=false;render();
}
function r621RenderPhotoSettings(){
 const back=elem('div','moa-r621-aux-shell');
 const day=r619AuxDate||ui.date;
 back.append(elem('div','moa-r621-aux-underlay',''),elem('div','moa-r621-aux-day',dateLabel(day)));
 const closeToggle=btn('⚙',r619ReturnFromAux,'moa-r621-aux-settings-toggle');
 closeToggle.setAttribute('aria-label','사진형 설정 닫기');back.append(closeToggle);
 const shade=elem('div','moa-r479-picker-backdrop moa-r621-sheet-backdrop');
 const settingsToggle=btn('⚙',r619ReturnFromAux,'moa-r621-sheet-top-toggle');settingsToggle.setAttribute('aria-label','설정 닫기');shade.append(settingsToggle);
 const sheet=elem('section','moa-r479-picker-sheet moa-r621-settings-sheet');
 sheet.setAttribute('role','dialog');sheet.setAttribute('aria-modal','true');sheet.setAttribute('aria-label','사진형 설정');
 const heading=elem('div','moa-r479-picker-heading');
 heading.append(elem('strong','','사진형 설정'),btn('×',r619ReturnFromAux,'moa-r479-picker-close'));sheet.append(heading);
 sheet.append(btn('상세형 보기 설정',()=>{
  const selected=r619AuxDate;r619AuxReturn='detail';r619ReturnFromAux();
  setTimeout(()=>{r475DecorateDetail();diaryRoot()?.querySelector('.moa-r191-day-menu-trigger')?.click();},140);
 },'moa-r621-sheet-action'));
 sheet.append(btn('갤러리 다시 표시',()=>{
  r619ReturnFromAux();setTimeout(()=>window.__moaR543RepairInline?.(),350);
 },'moa-r621-sheet-action'));
 sheet.append(btn('설정 닫기',r619ReturnFromAux,'moa-r621-sheet-cancel'));
 shade.append(sheet);back.append(shade);view.append(back);
 shade.addEventListener('click',e=>{if(e.target===shade)r619ReturnFromAux()});
}
function r539PhotoSettings(){r621EnterPhotoSettings();}
function r475OpenDetail(day){if(ui.dirty){notify('작성 중인 글을 먼저 저장한 뒤 상세형으로 전환해 주세요.');return;}
 // Original Diary still owns its detailed timeline/settings/data.
 // R555 must end the photo Gallery BEFORE selectDay opens the detail Gallery.
 const s=getState();if(!s)return;
 s.mode=ui.source;
 // R555: close the PHOTO-only Gallery FIRST. The original detail selectDay()
 // opens/owns the R463 Gallery; closing after selectDay() killed that new owner.
 // Suppress stale card close callbacks while changing representations.
 r523DayExiting=true;
 // Keep the obsolete legacy calendar hidden through the synchronous DETAIL handoff.
 r679DetailHandoff=true;
 try{
  close();
  window.FamilyJourneyDiary?.selectDay?.(day);
  r475DecorateDetail();
 }finally{requestAnimationFrame(()=>{r679DetailHandoff=false;r495SyncLegacyRoot()})}

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
// R699 incremental MediaStore/diary reconciliation; never reset the month feed.
function r699ReconcileVisibleCalendar(){
 if(!ui.open||ui.page!=='calendar'||!view||view.hidden||!r483Feed?.isConnected)return false;
 const state=getState();if(!state||state.load)return false;
 let changed=false;const feedBox=r483Feed.getBoundingClientRect();
 for(const section of r483Feed.querySelectorAll(':scope > .moa-r483-month')){
  const bounds=section.getBoundingClientRect();
  if(bounds.bottom<feedBox.top-180||bounds.top>feedBox.bottom+180)continue;
  for(const tile of section.querySelectorAll('.moa-r469-date[data-day]')){
   const d=tile.dataset.day,cover=mainCover(d,mediaFor(d));
   const id=cover?String(cover.id):'',old=tile.querySelector(':scope > img[data-id]');
   if(String(old?.dataset.id||'')!==id){
    const next=id?document.createElement('img'):null;
    if(next){
     next.dataset.id=id;next.alt='';next.draggable=false;
     const cached=r472Cached(id,260);
     if(cached){next.src=cached;next.classList.add('moa-r472-image-ready')}
     tile.insertBefore(next,tile.firstChild);
    }
    old?.remove();changed=true;
   }
   const mark=tile.querySelector(':scope > .moa-r469-video-mark');
   if(cover&&isVideo(cover)&&!mark){
    const video=elem('span','moa-r469-video-mark','▶');
    const dayNum=tile.querySelector('.moa-r469-day-number');
    tile.insertBefore(video,dayNum);changed=true;
   }else if((!cover||!isVideo(cover))&&mark){mark.remove();changed=true;}
   const record=tile.querySelector(':scope > .moa-r469-record-mark');
   if(state.curatedEntries?.has(d)&&!record){tile.append(elem('span','moa-r469-record-mark','•'));changed=true;}
   else if(!state.curatedEntries?.has(d)&&record){record.remove();changed=true;}
   tile.classList.toggle('selected',d===ui.selected);
  }
 }
 if(changed)r472RefreshVisibleThumbs();
 return changed;
}
function addMode(){
 const s=getState(),root=diaryRoot();r495SyncLegacyRoot();r495InstallBackHandlers();r495InstallScrollSetting();
 if(!s?.open||!root||root.hidden){r475ExitUntilHidden=false;return;}
 if(ui.open&&ui.page==='calendar'&&!s.load){
  const key=[s.curatedEntries?.size||0,s.entries?.size||0,s.byDay?.size||0,s.byVideoDay?.size||0].join(':');
  if(key!==r475LastDataKey&&!r475CalendarRefreshPending){r475LastDataKey=key;r475CalendarRefreshPending=true;
   setTimeout(()=>{r475CalendarRefreshPending=false;
    if(ui.open&&ui.page==='calendar'&&!ui.dirty)r699ReconcileVisibleCalendar();
   },240);
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
  if(ui.open&&['picker','period','settings'].includes(ui.page)){r619ReturnFromAux();return;}
  const s=getState();const date=ui.open&&ui.page==='day'?ui.date:(s?.page==='day'?s.date:ui.selected);
  if(!s?.open)await window.FamilyJourneyDiary?.open?.();
  r619EnterMediaPicker(valid(date)?date:dayOf(Date.now()));
 },'moa-r472-bottom-plus');plus.dataset.tab='moa-plus';plus.innerHTML='<span class="moa-r472-plus-disc" aria-hidden="true">+</span>';plus.setAttribute('aria-label','선택 날짜의 사진·영상 추가 또는 일기 열기');}
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

function render(){if(!ui.open||!view)return;
 if(ui.page==='day'&&view.dataset.page==='day'&&view.dataset.r661PhotoDay===ui.date&&
    view.querySelector('.moa-r469-stage')?.isConnected&&!r523DayExiting&&!r531Advanced){
  r661Log('PRESERVE_DAY_STAGE',{reason:'RENDER'});
  r592RefreshVisibleDay().then(()=>r661EnsureNative('RENDER'));
  return;
 }
 if(r507Opened && !(r523DayExiting && ui.page==='calendar'))r507StopInline();ui.requestGeneration++;view.replaceChildren();
 view.dataset.r661PhotoDay='';view.dataset.page=ui.page;view.dataset.monthScroll=r495ScrollMode();requestAnimationFrame(()=>window.__moaR613ScrollNavRefresh?.());r495SyncLegacyRoot();
 ui.page==='day'?renderDay():ui.page==='picker'?r619RenderPicker():ui.page==='period'?r619RenderPeriod():ui.page==='settings'?r621RenderPhotoSettings():renderMonth();view.append(elem('div','moa-r469-status',''));view.scrollTop=0;r472Nav();setTimeout(r472RefreshVisibleThumbs,600);}
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
 view.dataset.r699Month=r483MonthKey(ui.month);
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
 r699WarmCalendarCovers();
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
function renderDay(){r515RecoveryAttempts=0;r495InstallBackHandlers();const d=ui.date,s=getState();if(!valid(d)||!s)return;
 view.dataset.r661PhotoDay=d;
 ui.media=mediaFor(d);const chosen=mainCover(d,ui.media);const ri=ui.media.findIndex(x=>String(x.id)===String(chosen?.id));ui.idx=Math.min(ui.media.length-1,Math.max(0,ui.idx||ri));if(ui.idx===0&&ri>0)ui.idx=ri;
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
  fast:'<path d="m4 5 7 7-7 7m8-14 7 7-7 7"/>',
  remove:'<path d="M4 7h16M9 7V4h6v3M7 7l1 13h8l1-13M10 10v7M14 10v7"/>'};
 const actions=elem('div','moa-r469-actions');
 for(const [op,label] of [['share','공유'],['geo','네이버 지도'],['info','촬영 시간·주소'],['fast','빠른 스와이프 켜기/끄기'],['remove','현재 사진·영상을 일기에서 제외']]){
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

// R691: Exact detailed-diary R56 semantics for PHOTO. This is ONLY a diary
// association exclusion (with tombstone and undo via existing DETAIL editor).
// Never call Android MediaStore.delete, never delete a file, original image,
// video, M4A, note, GPS, Naver bookmark, or any other day's data.
// R697: single-item fallback uses the SAME bulk transaction/refresh path as
// the native multi-select control. Never call openDay() after exclusion.
async function r691ExcludeMedia(day,id){
 id=String(id||'');
 if(!ui.open||ui.page!=='day'||ui.date!==day||!safeMedia(id)||
     !ui.media.some(m=>String(m.id)===id))return false;
 return !!(await window.MoaR697MediaUI?.removeFromWeb?.(day,[id]));
}
// One ACK owner for the existing same-day native Gallery provider. The original
// R602 hot-update path preserves TextureView and controls when any items remain.
// An empty day is a legitimate empty day and may intentionally close native.
window.__moaR697PhotoAfterDelete=async(day,ids)=>{
 if(!ui.open||ui.page!=='day'||ui.date!==day||ui.dirty)return false;
 const earlier=ui.media.map(x=>String(x.id));
 try{
  if(r531Advanced){
   // Fullscreen is a different native owner. Close it intentionally only AFTER
   // the one atomic DB transaction; rebuild the PHOTO day from hydrated index.
   r531Advanced=false;
   window.__moaR567ProgrammaticCloseUntil=Date.now()+3500;
   try{window.MoaLocalAudio?.closeNativeGallery?.()}catch(_){}
   await r592HydrateDay(day);
   ui.media=mediaFor(day);
   ui.idx=Math.min(ui.idx,Math.max(0,ui.media.length-1));
   renderMedia();refreshVoices();r602RefreshMomentNotes();r607RefreshStoryBody();
   if(ui.media.length){r527BeginDay();setTimeout(()=>{
     if(ui.open&&ui.page==='day'&&!r523DayExiting&&!r531Advanced&&!r507Opened)r507StartInline();
   },280);}
  }else{
   // PHOTO-inline stays mounted: NO close() / openDay() / render() roundtrip.
   await r592RefreshVisibleDay();
   const after=mediaFor(day);
   const list=after.map(x=>String(x.id));
   if(JSON.stringify(ui.media.map(x=>String(x.id)))!==JSON.stringify(list)){
    ui.media=after;ui.idx=Math.min(ui.idx,Math.max(0,after.length-1));
    renderMedia();refreshVoices();r602RefreshMomentNotes();r607RefreshStoryBody();
    window.__moaR602PlaylistUpdate={day,token:window.__moaR527DayToken,
      ids:list,index:ui.idx,changedAt:Date.now()};
   }
  }
  // No native player can display zero photos; show the native-safe day empty
  // state without treating it as an unexpected Gallery failure or leaving an
  // invisible stale host over the underlying WebView.
  if(!ui.media.length){
   window.__moaR567ProgrammaticCloseUntil=Date.now()+3500;
   r507StopInline();
   view.dataset.r661PhotoDay='';render();
  }else{
   r527SyncGeometry(true);
   if(!r531Advanced)r661EnsureNative('R697_AFTER_MEDIA_DELETE');
  }
  const now=new Set(ui.media.map(x=>String(x.id)));
  if(ids.some(id=>now.has(id)))throw Error('deleted ID still in live PHOTO playlist');
  return true;
 }catch(ex){console.warn('R697 gallery refresh',String(ex));
  // Failure is not permission to clear the diary, delete MediaStore, or
  // replace the original video/gallery engine. User may safely retry the day.
  return false;
 }
};
// Native action deck transmits the actual current native Gallery media ID.
// Date/day/media checks reject stale callbacks, arbitrary ID injection and
// duplicate taps; only trusted same-app UI can request exclusion.
window.__moaR691RemoveDiaryMedia=(day,id)=>r691ExcludeMedia(String(day||''),String(id||''));

async function onAction(e){const op=e.target.closest('button[data-op]')?.dataset.op,m=dayMedia(ui.idx);if(!op||!m)return;
 if(op==='remove'){await r691ExcludeMedia(ui.date,String(m.id));return;}
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
 try{await persist('meta',coverKey,covers);window.__moaR507CoverId=String(id);
  // The next native Gallery session MUST consume a reordered cover-first list;
  // only an explicit cover change may deliberately reopen the current gallery.
  if(ui.open&&ui.page==='day'&&ui.date&&ui.media.some(x=>String(x.id)===String(id))){
   window.__moaR567ProgrammaticCloseUntil=Date.now()+2600;
   r507StopInline();ui.media=mediaFor(ui.date);ui.idx=0;r527BeginDay();render();
  }else r472UpdatePager();
  notify('대표 사진이 첫 번째로 설정됐습니다. · 원본 촬영순은 유지됩니다.');}catch(e){if(old===undefined)delete covers[source][ui.date];else covers[source][ui.date]=old;notify('대표 사진 저장 실패: '+String(e))}}
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
window.MoaR469SimpleDiary={openAdvancedGallery:()=>window.__moaR531ShowAdvanced?.(),openCalendar:()=>open('calendar'),openDay:d=>open('day',d),setCoverNative:id=>{if(ui.open&&ui.page==='day'&&ui.media.some(m=>String(m.id)===String(id)))saveCover(id)},home:()=>ui.open?(ui.page==='day'?goBack():true):false,close,readOnlyStatus:()=>({active:ui.open,page:ui.page,date:ui.date,source:ui.source,mediaCount:ui.media.length,voiceCount:ui.clips.length,dirty:ui.dirty})};
window.setInterval(()=>{
 if(!ui.open||ui.page!=='calendar'||document.hidden)return;
 r699WarmCalendarCovers();r699ReconcileVisibleCalendar();
},1250);
if(document.readyState==='loading')document.addEventListener('DOMContentLoaded',start,{once:true});else start();
})();
