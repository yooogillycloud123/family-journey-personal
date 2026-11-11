/* MOA R309 continuation: EXISTING-LIST transaction safety core.
 * SOURCE-ONLY. NOT installed, NOT authenticated NAVER E2E tested.
 * A verified first-party WebView adapter is still required.
 * Never expose cookies, password, account data or any private signer.
 */
(function(root,factory){const api=factory();if(typeof module==='object'&&module.exports)module.exports=api;else root.MOANaverExistingListTransaction=api;})(typeof globalThis!=='undefined'?globalThis:this,function(){
'use strict';
const ST=Object.freeze({
 PREPARED:'PREPARED',SEARCHING:'SEARCHING',NEEDS_TARGET:'NEEDS_TARGET_CONFIRMATION',
 TARGET_LOCKED:'TARGET_LOCKED',NEEDS_FOLDER:'NEEDS_EXISTING_FOLDER_ID',
 FOLDER_LOCKED:'FOLDER_LOCKED',PREFLIGHT:'PREFLIGHT',COMMIT_IN_FLIGHT:'COMMIT_IN_FLIGHT',
 READBACK:'READBACK',VERIFIED:'NAVER_READBACK_VERIFIED',UNVERIFIED:'NAVER_READBACK_UNVERIFIED',
 NEEDS_REVIEW:'NEEDS_MANUAL_REVIEW',BLOCKED:'BLOCKED'});
const finite=x=>typeof x==='number'&&Number.isFinite(x);
const norm=v=>String(v==null?'':v).normalize('NFKC').replace(/\s+/g,' ').trim();
const fault=s=>Object.assign(new Error(s),{code:s});
const id=v=>typeof v==='string'&&v.length>=2&&v.length<=256&&!/[\s<>]/.test(v);
const recordMatches=(x,j)=>!!x&&String(x.folderId)===j.folderId&&
 String(x.targetId)===j.targetId&&x.targetKind===j.targetKind&&
 norm(x.alias)===norm(j.alias)&&norm(x.memo)===norm(j.memo);
const candidateMatches=(x,j)=>!!x&&id(String(x.targetId||''))&&
 ['PLACE','ADDRESS'].includes(x.targetKind)&&x.firstPartyVerified===true&&
 x.exactAddressMatch===true&&(!finite(j.latitude)||!finite(j.longitude)||
 (finite(x.distanceMeters)&&x.distanceMeters>=0&&x.distanceMeters<=120));
class Transaction{
 constructor({adapter,storage,now=()=>Date.now(),onState=()=>{}}){
  if(!adapter||!storage||typeof storage.getItem!=='function'||
   typeof storage.setItem!=='function')throw fault('ADAPTER_OR_STORAGE_REQUIRED');
  this.adapter=adapter;this.storage=storage;this.now=now;this.onState=onState;
 }
 key(jobId){return 'moa.r309.existing-list.'+jobId}
 read(jobId){if(!id(jobId))throw fault('INVALID_JOB_ID');
  let raw=this.storage.getItem(this.key(jobId));
  if(!raw)throw fault('JOB_NOT_FOUND');
  let j;try{j=JSON.parse(raw)}catch(_){throw fault('JOB_CORRUPTED')}
  if(this.now()>j.expiresAt)throw fault('JOB_EXPIRED_NO_WRITE');return j;
 }
 state(j,status,fields={}){
  const next={...j,...fields,status,updatedAt:this.now()};
  this.storage.setItem(this.key(j.jobId),JSON.stringify(next));
  // No addresses, folder IDs, tokens, notes or aliases in UI diagnostic callbacks.
  this.onState({jobId:next.jobId,status,code:fields.code||null});return next;
 }
 prepare({jobId,photoId,exactAddress,latitude=null,longitude=null,
    alias='',memo='',suggestedListName=''}){
  if(!id(jobId)||!norm(photoId)||!norm(exactAddress))throw fault('INPUT_REQUIRED');
  if(latitude!==null&&(!finite(latitude)||latitude< -90||latitude>90)||
     longitude!==null&&(!finite(longitude)||longitude< -180||longitude>180))
    throw fault('INVALID_GPS');
  if(this.storage.getItem(this.key(jobId))){
   const previous=this.read(jobId);
   if(previous.photoId!==String(photoId)||previous.exactAddress!==norm(exactAddress))
     throw fault('IDEMPOTENCY_COLLISION');
   return previous;
  }
  const j={version:1,jobId,photoId:String(photoId),exactAddress:norm(exactAddress),
   latitude,longitude,alias:norm(alias),memo:norm(memo),suggestedListName:norm(suggestedListName),
   targetId:null,targetKind:null,folderId:null,commitAttempts:0,
   createdAt:this.now(),expiresAt:this.now()+90000};
  return this.state(j,ST.PREPARED);
 }
 async trusted(){
  if(typeof this.adapter.assertFirstPartyAuthenticated!=='function'||
     await this.adapter.assertFirstPartyAuthenticated()!==true)
    throw fault('FIRST_PARTY_NAVER_SESSION_UNVERIFIED');
 }
 async search(jobId){
  let j=this.read(jobId);
  if(![ST.PREPARED,ST.NEEDS_TARGET].includes(j.status))
   throw fault('SEARCH_NOT_ALLOWED_IN_STATE');
  await this.trusted();j=this.state(j,ST.SEARCHING);
  const candidates=await this.adapter.searchExactAddress(j.exactAddress);
  const exact=Array.isArray(candidates)?candidates.filter(x=>candidateMatches(x,j)):[];
  if(exact.length!==1)return this.state(j,ST.NEEDS_TARGET,{
   code:exact.length>1?'AMBIGUOUS_EXACT_TARGET':'NO_UNIQUE_VERIFIED_TARGET'});
  j=this.state(j,ST.TARGET_LOCKED,{
   targetId:String(exact[0].targetId),targetKind:exact[0].targetKind});
  return this.state(j,ST.NEEDS_FOLDER);
 }
 async confirmTarget(jobId,selected){
  let j=this.read(jobId);if(j.status!==ST.NEEDS_TARGET)
   throw fault('TARGET_CONFIRMATION_NOT_REQUESTED');
  await this.trusted();
  if(!candidateMatches(selected,j)||selected.explicitUserChoice!==true)
   throw fault('TARGET_NOT_EXPLICITLY_VERIFIED');
  j=this.state(j,ST.TARGET_LOCKED,{
   targetId:String(selected.targetId),targetKind:selected.targetKind});
  return this.state(j,ST.NEEDS_FOLDER);
 }
 async listExistingFolders(jobId){
  let j=this.read(jobId);if(j.status!==ST.NEEDS_FOLDER)
   throw fault('FOLDER_STAGE_NOT_READY');
  await this.trusted();
  const rows=await this.adapter.readExistingFolders();
  if(!Array.isArray(rows)||!rows.every(x=>x&&id(String(x.id||''))&&
    x.verifiedFirstParty===true&&x.ownedByUser===true))
   throw fault('FOLDER_LIST_NOT_VERIFIED');
  // Only present choices; never infer target by name, order, or 185-count.
  return rows.map(x=>({id:String(x.id),name:norm(x.name),count:x.count}));
 }
 async confirmExistingFolder(jobId,selected){
  let j=this.read(jobId);if(j.status!==ST.NEEDS_FOLDER)
   throw fault('FOLDER_STAGE_NOT_READY');
  await this.trusted();
  if(!selected||selected.explicitUserClick!==true||!id(String(selected.id||'')))
   throw fault('EXPLICIT_FOLDER_ID_REQUIRED');
  const rows=await this.adapter.readExistingFolders();
  if(!Array.isArray(rows)||!rows.some(x=>String(x.id)===String(selected.id)&&
   x.verifiedFirstParty===true&&x.ownedByUser===true))
   throw fault('FOLDER_ID_NOT_FOUND_IN_LIVE_ACCOUNT');
  return this.state(j,ST.FOLDER_LOCKED,{folderId:String(selected.id)});
 }
 async save(jobId){
  let j=this.read(jobId);
  if(j.status===ST.VERIFIED)return j;
  if([ST.COMMIT_IN_FLIGHT,ST.READBACK,ST.UNVERIFIED].includes(j.status))
   return this.verifyOnly(jobId); // Never repeat an uncertain star/commit.
  if(j.status!==ST.FOLDER_LOCKED)throw fault('SAVE_NOT_READY');
  await this.trusted();j=this.state(j,ST.PREFLIGHT);
  const existing=await this.adapter.readExactSavedRecord(j.folderId,j.targetId,j.targetKind);
  if(recordMatches(existing,j))return this.state(j,ST.VERIFIED);
  if(existing)return this.state(j,ST.NEEDS_REVIEW,{
   code:'EXISTING_RECORD_DIFFERS_NO_OVERWRITE'});
  const proof=await this.adapter.prepareExactSaveUI({
   targetId:j.targetId,targetKind:j.targetKind,folderId:j.folderId,alias:j.alias,memo:j.memo});
  if(!proof||proof.firstPartyTargetMatch!==true||proof.firstPartyFolderMatch!==true||
     proof.aliasMatch!==true||proof.memoMatch!==true||proof.alreadySaved===true)
   return this.state(j,ST.BLOCKED,{code:'FIRST_PARTY_SAVE_UI_NOT_VERIFIED'});
  // Journal before commit: restart may ONLY read back, never send another write.
  j=this.state(j,ST.COMMIT_IN_FLIGHT,{commitAttempts:1});
  try{await this.adapter.commitOnce()}catch(_){
   return this.state(j,ST.UNVERIFIED,{code:'COMMIT_ACK_UNCERTAIN_NO_RETRY'})}
  return this.verifyOnly(jobId);
 }
 async verifyOnly(jobId){
  let j=this.read(jobId);
  if(![ST.COMMIT_IN_FLIGHT,ST.READBACK,ST.UNVERIFIED].includes(j.status))
   throw fault('NOT_IN_READBACK_STATE');
  await this.trusted();j=this.state(j,ST.READBACK);
  let record;
  try{record=await this.adapter.readExactSavedRecord(j.folderId,j.targetId,j.targetKind)}
  catch(_){return this.state(j,ST.UNVERIFIED,{code:'READBACK_UNAVAILABLE_NO_RETRY'})}
  if(recordMatches(record,j))return this.state(j,ST.VERIFIED);
  return this.state(j,ST.UNVERIFIED,{code:'READBACK_FIELDS_NOT_EQUAL_NO_RETRY'});
 }
}
return {Transaction,ST};
});