/* MOA R570 — additive bridge for the user's approved R567 native photo card.
   No new GPS reader, Naver writer, IndexedDB schema, login page, or privilege.
   Native photo-card dialog invokes this bridge; it uses the EXISTING first-party
   NativeHost diaryMediaLocation and FamilyJourneyNaver.saveFromDiaryGps functions. */
(()=>{
 'use strict';
 const idOK=id=>/^(?:v)?[0-9]{1,18}$/.test(String(id));
 const pendingGeo=new Map(), inProgress=new Set();
 let seq=0, oldLocationHandler=null, wrappedLocationHandler=null;
 function installGeoResultProxy(){
   if(window.__fjDiaryMediaLocationResult===wrappedLocationHandler)return;
   oldLocationHandler=window.__fjDiaryMediaLocationResult;
   wrappedLocationHandler=function(request,value){
     const id=Number(request),callback=pendingGeo.get(id);
     if(callback){pendingGeo.delete(id);callback(value);return;}
     if(typeof oldLocationHandler==='function')return oldLocationHandler.apply(this,arguments);
   };
   window.__fjDiaryMediaLocationResult=wrappedLocationHandler;
 }
 function status(message){
   // Only an information line outside the native image. Never animate/resize
   // the verified R567 Gallery host, card geometry, playback or current item.
   const chrome=document.querySelector('#moa-r469-root[data-page="day"] .moa-r539-day-chrome');
   if(!chrome)return;
   let label=chrome.querySelector('.moa-r570-save-status');
   if(!label){label=document.createElement('div');label.className='moa-r570-save-status';
     label.setAttribute('role','status');label.setAttribute('aria-live','polite');chrome.append(label);}
   label.textContent=String(message||'');
 }
 function requestLocation(id,callback){
   if(!idOK(id)||!window.NativeHost||typeof window.NativeHost.post!=='function')return false;
   installGeoResultProxy();
   const request=1800000000+(++seq%1000000);
   pendingGeo.set(request,callback);
   try{window.NativeHost.post('diaryMediaLocation',JSON.stringify({request,id:String(id)}));}
   catch(_){pendingGeo.delete(request);return false;}
   window.setTimeout(()=>{
     const cb=pendingGeo.get(request);if(!cb)return;
     pendingGeo.delete(request);cb({hasGps:false,error:'location_timeout'});
   },12000);
   return true;
 }
 function save(id,alias,memo,list,mode){
   id=String(id);mode=String(mode||'');
   if(!idOK(id)||!['web','native'].includes(mode))return false;
   const s=window.MoaR469SimpleDiary?.readOnlyStatus?.();
   if(!s?.active||s.page!=='day'||window.__moaR570CurrentMediaId?.()!==id)return false;
   if(typeof window.FamilyJourneyNaver?.saveFromDiaryGps!=='function')return false;
   const key=id; // one in-flight operation per photo across web/native paths
   if(inProgress.has(key)){status('이미 이 사진의 저장 요청을 확인 중입니다.');return false;}
   inProgress.add(key);
   status('원본 사진 촬영 GPS를 확인하는 중…');
   const accepted=requestLocation(id,info=>{
     // A changed media can never be silently saved under the previous id.
     if(window.__moaR570CurrentMediaId?.()!==id){inProgress.delete(key);status('사진이 변경되어 저장을 취소했습니다.');return;}
     const lat=Number(info?.lat),lon=Number(info?.lon);
     if(!info?.hasGps||!Number.isFinite(lat)||!Number.isFinite(lon)||
        lat<33||lat>39||lon<124||lon>132){
       inProgress.delete(key);status('저장할 한국 GPS 위치정보가 없습니다.');return;
     }
     try{
       // Existing R345+ writer owns address reverse-geocoding, saved-list choice,
       // account verification, cookie/trust state and the WEB/NATIVE switch.
       const ok=window.FamilyJourneyNaver.saveFromDiaryGps(
         {...info,id,lat,lon},String(alias||'').slice(0,100),String(memo||'').slice(0,400),
         String(list||'').slice(0,70),result=>{
           const resultState=String(result?.state||'');
           status((mode==='web'?'비점유: ':'기존 저장: ')+String(result?.message||resultState||'저장 확인 중'));
           if(resultState!=='LOOKUP')inProgress.delete(key);
         },{mode});
       if(!ok){inProgress.delete(key);status('네이버 저장 엔진이 요청을 수락하지 않았습니다.');}
     }catch(_){inProgress.delete(key);status('기존 네이버 저장 경로 호출에 실패했습니다.');}
   });
   if(!accepted){inProgress.delete(key);status('위치정보 연결을 사용할 수 없습니다.');return false;}
   return true; // This means REQUEST ACCEPTED, never "saved".
 }
 window.MoaR570PhotoFavorites=Object.freeze({save});
})();