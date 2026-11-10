/* MOA: original photo GPS -> strict auto save job, no repeated manual inputs.
 * Source-only prerequisite. This does NOT provide NAVER account write by itself.
 */
(function(root,factory){
  const api=factory();
  if(typeof module==='object'&&module.exports)module.exports=api;
  else root.MoaNaverAutoDraft=api;
})(typeof globalThis!=='undefined'?globalThis:this,function(){
 'use strict';
 const text=(v,n)=>(typeof v==='string'?v:'').trim().slice(0,n);
 const numeric=v=>{const x=Number(v);return Number.isFinite(x)?x:NaN};
 const valid=(lat,lon)=>lat>=33&&lat<=39&&lon>=124&&lon<=132;
 const sid=v=>/^\d{1,40}$/.test(String(v||''))?String(v):'';
 const generic=/^(?:촬영 위치|가족 사진|방문 장소|사진 위치|주소|위치 정보|미지정|내 장소|전주|서울|남원|부산|제주)$/;
 function prepare(photo={},draft={},verified={}){
  const lat=numeric(photo.lat),lon=numeric(photo.lon);
  if(!valid(lat,lon))return {status:'NEEDS_GPS',reason:'ORIGINAL_GPS_REQUIRED'};
  const photoId=text(String(photo.id||photo.photoId||''),40);
  const address=text(verified.address||draft.address||photo.address,220);
  const placeId=sid(verified.placeId||draft.naverPlaceId||photo.naverPlaceId);
  const placeName=text(verified.placeName||draft.verifiedPlaceName||photo.verifiedPlaceName,120);
  const alias=text(draft.alias||photo.alias,25),memo=text(draft.memo||photo.memo,400);
  const listName=text(draft.list||verified.listName||photo.list||'내 장소',70)||'내 장소';
  const data={lat,lon,photoId,address,placeId,placeName,alias,memo,listName};
  if(!address&&!placeId)return {...data,status:'NEEDS_ADDRESS',reason:'REVERSE_GEOCODE_REQUIRED'};
  if(!placeId&&(!placeName||generic.test(placeName)))
   return {...data,status:'NEEDS_POI',reason:'EXACT_VENUE_NOT_IDENTIFIED'};
  return {...data,status:'READY',reason:'VERIFIED_PHOTO_AND_PLACE'};
 }
 function readbackMatches(job,row){
  if(job?.status!=='READY'||!row||typeof row!=='object')return false;
  if(text(row.listName||row.folderName,70)!==job.listName)return false;
  const exactId=sid(row.placeId||row.sid);
  const match=job.placeId?exactId===job.placeId:
   text(row.placeName||row.name,120)===job.placeName&&text(row.address,220)===job.address;
  if(!match)return false;
  if(job.alias&&text(row.alias,25)!==job.alias)return false;
  if(job.memo&&text(row.memo,400)!==job.memo)return false;
  return true;
 }
 return Object.freeze({prepare,readbackMatches});
});
