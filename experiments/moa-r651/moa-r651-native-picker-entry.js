/* MOA R651: independent native photo picker channel. Never opens, closes, repairs,
 * reparents or instruments the physically-approved R648 Gallery/Activity-root host.
 * R648 own gallery, QuickRecord, Naver and diary scripts remain byte-identical.
 */
(()=>{'use strict';
 const ORIGIN='https://familyjourney.local';
 const isDay=d=>/^\d{4}-(?:0[1-9]|1[0-2])-(?:0[1-9]|[12]\d|3[01])$/.test(String(d));
 const isId=id=>/^(?:\d{1,19}|v\d{1,18})$/.test(String(id));
 const stamp=(type)=>{try{
   const key='moa_r651_native_picker_trace';const arr=JSON.parse(localStorage.getItem(key)||'[]');
   arr.push({type,at:Date.now()});while(arr.length>200)arr.shift();localStorage.setItem(key,JSON.stringify(arr));
 }catch(_){}};
 let port=null,busy=false;let awaitingNative=false;
 const post=obj=>{try{port?.postMessage(JSON.stringify(obj));return !!port;}catch(e){stamp('BRIDGE_SEND_FAILED');port=null;return false}};
 const dayNow=()=>{
   const active=window.MoaR469SimpleDiary?.readOnlyStatus?.();
   if(isDay(active?.date))return active.date;
   const selected=document.querySelector('#moa-r469-root .moa-r469-date.selected[data-day]')?.dataset.day;
   if(isDay(selected))return selected;
   const now=new Date();return [now.getFullYear(),String(now.getMonth()+1).padStart(2,'0'),String(now.getDate()).padStart(2,'0')].join('-');
 };
 const dbOpen=()=>new Promise((resolve,reject)=>{
   const r=indexedDB.open('familyjourney-diary-v1',2);
   r.onsuccess=()=>resolve(r.result);r.onerror=()=>reject(r.error||Error('DB_OPEN_FAILED'));
   r.onblocked=()=>reject(Error('DB_BLOCKED'));
 });
 async function commitSaved(x){
   if(busy)return;busy=true;let db=null;
   try{
     if(!isDay(x.day)||!Array.isArray(x.ids)||!x.ids.length||x.ids.length>10000||x.ids.some(v=>!isId(v)))throw Error('INVALID_MEDIA_SELECTION');
     const ids=[...new Set(x.ids.map(String))];
     db=await dbOpen();
     const old=await new Promise((resolve,reject)=>{
       const tx=db.transaction('curated','readonly'),r=tx.objectStore('curated').get(x.day);
       r.onsuccess=()=>resolve(r.result);r.onerror=()=>reject(r.error||Error('READ_FAILED'));
     });
     // Merge ONLY the existing curated photoIds. Every other diary field is retained.
     const merged={...(old||{day:x.day,photoIds:[],moments:[],activities:{},title:'',body:'',tags:[],feeling:'',selectionMode:'manual',source:'owner'}),day:x.day};
     merged.photoIds=[...new Set([...(merged.photoIds||[]).map(String),...ids])];
     const removed=new Set((merged.removedMediaIds||[]).map(String));ids.forEach(id=>removed.delete(id));
     merged.removedMediaIds=[...removed];merged.selectionMode='manual';merged.updatedAt=Date.now();
     await new Promise((resolve,reject)=>{
       const tx=db.transaction('curated','readwrite');tx.objectStore('curated').put(merged);
       tx.oncomplete=resolve;tx.onerror=()=>reject(tx.error||Error('WRITE_FAILED'));tx.onabort=()=>reject(tx.error||Error('WRITE_ABORTED'));
     });
     const readback=await new Promise((resolve,reject)=>{const tx=db.transaction('curated','readonly');
       const r=tx.objectStore('curated').get(x.day);r.onsuccess=()=>resolve(r.result);r.onerror=()=>reject(r.error||Error('READBACK_FAILED'));
     });
     if(!readback||ids.some(id=>!readback.photoIds?.map(String).includes(id)))throw Error('SAVE_READBACK_MISMATCH');
     const state=window.FamilyJourneyDiary?.state;
     if(state?.curatedEntries?.set)state.curatedEntries.set(x.day,readback);
     if(state){state.mode='curated';if(state.date===x.day)ids.forEach(id=>state.selection?.add?.(id));}
     stamp('SELECTION_SAVED_READBACK_PASS');
     post({type:'saved_ack',token:String(x.token||'')});
     // Existing R648 day entry path only, once, after a confirmed successful commit.
     try{window.MoaR469SimpleDiary?.openDay?.(x.day);}catch(_){stamp('DAY_OPEN_FAILED_AFTER_SAVE');}
   }catch(err){
     stamp('SELECTION_SAVE_FAILED');console.warn('R651 native photo selection save failure',String(err?.name||'Error'));
     window.alert?.('사진 추가 저장이 완료되지 않았습니다. 저장 결과를 유지하고 재시도할 수 있습니다.');
   }finally{try{db?.close()}catch(_){}busy=false;awaitingNative=false;}
 }
 function onNativeMessage(evt){
   let x;try{x=JSON.parse(evt.data)}catch(_){return;}
   if(x?.type==='picker_saved'){stamp('PICKER_RESULT_RECEIVED');void commitSaved(x);}
   if(x?.type==='picker_cancelled'){awaitingNative=false;stamp('PICKER_CANCELLED');post({type:'saved_ack',token:String(x.token||'')});}
   if(x?.type==='picker_open_failed'){awaitingNative=false;stamp('PICKER_OPEN_FAILED');window.alert?.('네이티브 사진 추가 화면을 열지 못했습니다. 기존 사진과 일기는 변경되지 않았습니다.');}
 }
 window.addEventListener('message',event=>{
   // Follow R527's proven native WebMessagePort origin check: the trusted page
   // is this app's own WebView, while Android-originated events may carry no event.origin.
   if(window.location?.origin!==ORIGIN||event.data!=='MOA_R651_PORT'||!event.ports?.[0])return;
   port=event.ports[0];port.onmessage=onNativeMessage;port.start?.();stamp('NATIVE_BRIDGE_CONNECTED');post({type:'hello'});
 },false);
 // Register BEFORE the R641 lazy Web picker capture handler. Prevent it only
 // after the user's explicit Plus action; do not touch the Gallery on app boot.
 document.addEventListener('click',event=>{
   if(!(event.target instanceof Element)||!event.target.closest('button[data-tab="moa-plus"]'))return;
   if(!port){stamp('NATIVE_BRIDGE_NOT_READY');event.preventDefault();event.stopImmediatePropagation();
     window.alert?.('사진 추가 화면이 준비되지 않았습니다. 잠시 후 다시 눌러 주세요.');return;}
   if(awaitingNative)return;
   const info=window.MoaR469SimpleDiary?.readOnlyStatus?.();
   const editor=info?.page==='day'?document.querySelector('#moa-r469-root .moa-r469-text'):null;
   const current=window.FamilyJourneyDiary?.state;
   const prior=current?.curatedEntries?.get(info?.date)||current?.entries?.get(info?.date);
   if(editor&&editor.value!==String(prior?.body||'')&&
       !confirm('작성 중인 글이 저장되지 않았습니다. 먼저 저장하거나 이동을 취소할 수 있습니다. 저장하지 않고 사진을 선택할까요?')){
     event.preventDefault();event.stopImmediatePropagation();return;
   }
   event.preventDefault();event.stopImmediatePropagation();
   awaitingNative=true;stamp('NATIVE_PICKER_OPEN_REQUEST');
   if(!post({type:'open',day:dayNow()})){awaitingNative=false;stamp('NATIVE_PICKER_OPEN_POST_FAILED');}
 },true);
 document.addEventListener('visibilitychange',()=>{if(!document.hidden&&awaitingNative)stamp('PICKER_PARENT_RESUMED');},false);
 window.MoaR651PickerDebug={readOnly:()=>({nativeBridgeReady:!!port,busy,pickerRequested:awaitingNative}),
   copyTrace:()=>localStorage.getItem('moa_r651_native_picker_trace')||'[]'};
 stamp('R651_JS_BOOTSTRAP_LOADED');
})();