/* R641: R611 QuickRecord ARM deduplication and lazy photo-add picker.
 * Does not touch the original MoaNativeGallery object, Java provider,
 * Naver accessibility observer, photo-day renderer or its source/DEX.
 * Distinguishes a silent, never-opened START_INLINE from a healthy renderer.
 */
(()=>{'use strict';
 const history=[];
 const stamp=(type,detail)=>{const row={type,at:Date.now(),...(detail||{})};history.push(row);if(history.length>20)history.shift();return row;};
 const status=()=>{try{return window.MoaR469SimpleDiary?.readOnlyStatus?.()||null}catch(_){return null}};
 const stage=()=>document.querySelector('#moa-r469-root .moa-r469-stage');
 const nativeOpen=()=>{
   try{const f=window.MoaLocalAudio?.isNativeGalleryOpen;if(typeof f!=='function')return null;
       const v=f.call(window.MoaLocalAudio);return v===true||v===1||v==='true'?true:v===false||v===0||v==='false'?false:null;
   }catch(_){return null;}
 };
 let lastDaySnapshot=null,previousSignature='',recoveryAttempts=0,lastRecoveryTime=0;
 const diag=window.__moaR602GalleryDiagnostic;
 const readR611=()=>{try{return JSON.parse(typeof diag==='function'?diag():'{}')}catch(_){return {error:'BASE_DIAGNOSTIC_UNAVAILABLE'}}};
 function capture(){const d=readR611(),s=status(),root=document.querySelector('#moa-r469-root');
   const snap={at:Date.now(),active:!!s?.active,page:s?.page||null,day:s?.date||null,
     stageAttached:!!stage()?.isConnected,stageWidth:Math.round(stage()?.getBoundingClientRect()?.width||0),
     rootHidden:root?!!root.hidden:null,bridge:!!d.bridge,
     nativeOpen:nativeOpen(),nativeMethod:typeof window.MoaLocalAudio?.openNativeGallery==='function',
     arm:!!d.arm,pending:!!d.pending,opened:!!d.opened,mounted:!!d.mounted,
     event:d.last||'NONE',latestEventAt:d.events?.at?.(-1)?.at||0};
   if(s?.active&&s.page==='day')lastDaySnapshot=snap;
   const signature=[snap.active,snap.page,snap.stageAttached,snap.nativeOpen,snap.nativeMethod,
                    snap.arm,snap.pending,snap.opened,snap.mounted,snap.event].join('|');
   if(signature!==previousSignature){previousSignature=signature;stamp('LIFECYCLE',snap)}
   return {d,snap};
 }
 window.__moaR641GalleryForensic=()=>JSON.stringify({build:641,source:'R611 native core + scoped QuickRecord ARM guard',
   current:capture().snap,lastActiveDay:lastDaySnapshot,history:history.slice(-16),
   repairs:recoveryAttempts});
 if(typeof diag==='function')window.__moaR602GalleryDiagnostic=()=>{
   const base=readR611();return JSON.stringify({...base,
     r641LastActiveDay:lastDaySnapshot,r641LegacyRecoveryAttemptsDisabled:recoveryAttempts,
     r641Timeline:history.slice(-9)});
 };
 // R641: no boot-time recurrent repair/polling. The original R611 provider
 // continues to own ALL initial/photo/detail/Naver Accessibility transitions.
 let qrSerial=0;
 window.addEventListener('moa:native-diary-committed',event=>{
   const day=String(event?.detail?.day||'');
   const serial=++qrSerial;let rearmed=false;
   stamp('QUICK_RECORD_COMMITTED',{dayKnown:/^\d{4}-\d{2}-\d{2}$/.test(day)});
   // R646: R641 ran one recovery inspection at +3.2s. In the user's real
   // trace, START_INLINE was only 1.518s old then (<1.8s gate), so the
   // only recovery inspection could not fire. Reinspect later, bounded,
   // with exact diagnostics for every gate. Never interrupt an open host.
   const checkpoints=[550,1650,3200,5300,7300,10300,13500,16500];
   for(const delay of checkpoints)setTimeout(()=>{
     if(serial!==qrSerial)return;
     const {d,snap}=capture();
     const latest=Number(d.events?.at?.(-1)?.at||0);
     const since=latest?Date.now()-latest:null;
     const sameDay=snap.day===day;
     stamp('QUICK_RECORD_STATE',{delay,active:snap.active,page:snap.page,
       opened:snap.opened,mounted:snap.mounted,arm:snap.arm,pending:snap.pending,
       nativeOpen:snap.nativeOpen,stage:snap.stageAttached,last:d.last});
     if(delay<5300||rearmed)return;
     let verdict='READY';
     if(!snap.active||snap.page!=='day')verdict='NOT_ACTIVE_DAY';
     else if(!sameDay)verdict='OTHER_DAY';
     else if(!snap.stageAttached||snap.stageWidth<150||snap.rootHidden)verdict='STAGE_NOT_READY';
     else if(snap.nativeOpen!==false)verdict='NATIVE_HOST_NOT_CONFIRMED_CLOSED';
     else if(!snap.nativeMethod||!snap.bridge)verdict='BRIDGE_UNAVAILABLE';
     else if(snap.arm||snap.pending||snap.opened||snap.mounted)verdict='NATIVE_IN_PROGRESS_OR_MOUNTED';
     else if(d.last!=='START_INLINE' && d.last!=='R646_OPEN_STALLED' &&
       d.last!=='R646_WAIT_NATIVE_ARM' && d.last!=='R646_TIMER_FIRED' &&
       d.last!=='R646_WAIT_BRIDGE')verdict='NOT_STALLED_OPEN_PATH';
     else if(since===null||since<1800)verdict='START_TOO_RECENT';
     else if(since>13000)verdict='STALE_TRACE';
     else if(typeof window.__moaR543RepairInline!=='function')verdict='REPAIR_METHOD_MISSING';
     stamp('QUICK_RECORD_REARM_GATE',{delay,result:verdict,stageAttached:snap.stageAttached,
       nativeOpen:snap.nativeOpen,arm:snap.arm,pending:snap.pending,mounted:snap.mounted,
       last:d.last,elapsedMs:since,active:snap.active,page:snap.page,sameDay});
     if(verdict!=='READY')return;
     rearmed=true;recoveryAttempts++;
     stamp('QUICK_RECORD_CLOSED_HOST_REARM',{delay,result:'attempt'});
     try{
       const ok=window.__moaR543RepairInline();
       stamp('QUICK_RECORD_REARM_CALL_RESULT',{result:ok?'ACCEPTED':'REJECTED'});
     }catch(e){stamp('QUICK_RECORD_REARM_EXCEPTION',{errorName:String(e?.name||'Error')});}
     setTimeout(()=>{
       if(serial!==qrSerial)return;
       const check=capture();stamp('QUICK_RECORD_REARM_FINAL',{result:
         check.snap.mounted?'MOUNTED':check.snap.nativeOpen===true?'NATIVE_OPEN':'NOT_MOUNTED',
         arm:check.snap.arm,pending:check.snap.pending,mounted:check.snap.mounted,
         nativeOpen:check.snap.nativeOpen});
     },3200);
   },delay);
 },false);

 let loading=null;
 const loadPicker=()=>{
   if(window.MoaStandalonePickerR640)return Promise.resolve(window.MoaStandalonePickerR640);
   if(loading)return loading;
   loading=new Promise((resolve,reject)=>{
     const style=document.createElement('link');style.rel='stylesheet';style.href='moa-r640-lazy-picker.css';
     document.head.append(style);
     const script=document.createElement('script');script.src='moa-r640-lazy-picker.js';
     script.onload=()=>{const p=window.MoaStandalonePickerR640;
       if(p&&typeof p.open==='function')resolve(p);else reject(Error('PICKER_EXPORT_MISSING'));};
     script.onerror=()=>reject(Error('PICKER_ASSET_UNAVAILABLE'));
     document.body.append(script);
   }).catch(e=>{loading=null;stamp('PICKER_LAZY_LOAD_FAILED',{error:String(e)});throw e});
   return loading;
 };
 document.addEventListener('click',event=>{
   const target=event.target;
   if(!(target instanceof Element)||!target.closest('button[data-tab="moa-plus"]'))return;
   event.preventDefault();event.stopImmediatePropagation();
   loadPicker().then(p=>p.open()).catch(err=>{
     console.warn('R640 independent photo picker cannot open',String(err));
     window.alert?.('사진 선택 화면을 불러오지 못했습니다. 기존 일기와 사진은 그대로 보존됩니다.');
   });
 },true);
 stamp('BOOTSTRAP_LOADED',{nativeGallerySource:'R611',alwaysOnRecovery:false});
})();
