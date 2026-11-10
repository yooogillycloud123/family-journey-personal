(function(root, factory){
  const api=factory();
  if(typeof module==='object' && module.exports)module.exports=api;
  else root.MoaNaverBookmarkTransaction=api;
})(typeof globalThis!=='undefined'?globalThis:this,function(){
  'use strict';
  const trim=(v,max)=>String(v??'').trim().slice(0,max);
  function prepare(photo, diary){
    const sid=trim(diary.placeId,40);
    if(!/^[0-9]+$/.test(sid))return {phase:'NEEDS_PLACE_CONFIRMATION'};
    return {phase:'QUEUED',photoId:trim(photo.id,64),placeId:sid,
      folder:trim(diary.folder||'내 장소',80),alias:trim(diary.alias,80),
      memo:trim(diary.memo,500),requestId:trim(diary.requestId,80)};
  }
  function readbackIsExact(job, record){
    return !!record && record.placeId===job.placeId &&
      record.folder===job.folder &&
      (!job.alias||record.alias===job.alias) &&
      (!job.memo||record.memo===job.memo);
  }
  async function run(job,writer,stage=()=>{}){
    if(job?.phase!=='QUEUED')return {phase:'NEEDS_PLACE_CONFIRMATION'};
    if(!writer||typeof writer.authenticated!=='function')return {phase:'BLOCKED_NO_FIRST_PARTY_WRITER'};
    try{
      if(!await writer.authenticated())return {phase:'NEEDS_FIRST_PARTY_LOGIN'};
      if(!await writer.folderExists(job.folder)){
        stage('CREATING_FOLDER');
        await writer.createFolderThroughFirstPartyUI(job.folder);
      }
      let existing=await writer.readback(job.folder,job.placeId);
      if(readbackIsExact(job,existing))return {phase:'CONFIRMED',proof:'FIRST_PARTY_READBACK'};
      stage('SAVING_IN_FIRST_PARTY_UI');
      await writer.upsertThroughFirstPartyUI({...job,alreadySaved:!!existing});
      stage('READING_BACK');
      existing=await writer.readback(job.folder,job.placeId);
      return readbackIsExact(job,existing)?{phase:'CONFIRMED',proof:'FIRST_PARTY_READBACK'}:
        {phase:'SUBMITTED_UNVERIFIED'};
    }catch(e){return {phase:'ERROR',reason:trim(e?.code||e?.message||'UNKNOWN',100)};}
  }
  return Object.freeze({prepare,readbackIsExact,run});
});
