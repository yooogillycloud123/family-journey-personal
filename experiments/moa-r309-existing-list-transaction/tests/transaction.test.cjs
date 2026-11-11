'use strict';
const test=require('node:test');
const assert=require('node:assert/strict');
const {Transaction,ST}=require('../moa-naver-existing-list-transaction.js');
function fixture(overrides={}){
 const map=new Map();let writes=0, stored=null, time=1000, loggedIn=true;
 const storage={getItem:k=>map.has(k)?map.get(k):null,setItem:(k,v)=>map.set(k,v)};
 const candidate={targetId:'PLACE001',targetKind:'PLACE',
   firstPartyVerified:true,exactAddressMatch:true,distanceMeters:15};
 const folders=[
  {id:'share-185-AAA',name:'내 장소',count:185,verifiedFirstParty:true,ownedByUser:true},
  {id:'share-000-BBB',name:'내 장소',count:0,verifiedFirstParty:true,ownedByUser:true}
 ];
 const adapter={
  assertFirstPartyAuthenticated:async()=>loggedIn,
  searchExactAddress:async()=>[candidate],
  readExistingFolders:async()=>folders,
  readExactSavedRecord:async()=>stored,
  prepareExactSaveUI:async()=>({
   firstPartyTargetMatch:true,firstPartyFolderMatch:true,
   aliasMatch:true,memoMatch:true,alreadySaved:false
  }),
  commitOnce:async()=>{writes++;stored={
   targetId:'PLACE001',targetKind:'PLACE',folderId:'share-185-AAA',
   alias:'우리 가족',memo:'사진과 함께 저장'
  }},
  ...overrides
 };
 const make=()=>new Transaction({adapter,storage,now:()=>time});
 const input={jobId:'job-1',photoId:'photo-1',exactAddress:'가상의 테스트 주소 123',
   latitude:35.8,longitude:127.15,alias:'우리 가족',memo:'사진과 함께 저장',
   suggestedListName:'내 장소'};
 return {make,adapter,input,candidate,folders,get writes(){return writes},
  setTime:n=>time=n,setLogin:v=>loggedIn=v,setStored:v=>stored=v};
}
async function ready(f){const t=f.make();t.prepare(f.input);await t.search('job-1');
 await t.confirmExistingFolder('job-1',{id:'share-185-AAA',explicitUserClick:true});return t;}
test('address search first, unique verified target locked',async()=>{
 const f=fixture(),t=f.make();t.prepare(f.input);
 const j=await t.search('job-1');assert.equal(j.targetId,'PLACE001');
 assert.equal(j.status,ST.NEEDS_FOLDER)});
test('session persisted through new coordinator instance',async()=>{
 const f=fixture();f.make().prepare(f.input);
 assert.equal((await f.make().search('job-1')).targetId,'PLACE001')});
test('ambiguous exact match must not save',async()=>{
 const f=fixture({searchExactAddress:async()=>[
  {targetId:'A',targetKind:'PLACE',firstPartyVerified:true,exactAddressMatch:true,distanceMeters:10},
  {targetId:'B',targetKind:'PLACE',firstPartyVerified:true,exactAddressMatch:true,distanceMeters:9}
 ]}),t=f.make();t.prepare(f.input);
 assert.equal((await t.search('job-1')).status,ST.NEEDS_TARGET);assert.equal(f.writes,0)});
test('wrong-address never auto selected',async()=>{
 const f=fixture({searchExactAddress:async()=>[
  {targetId:'A',targetKind:'PLACE',firstPartyVerified:true,exactAddressMatch:false,distanceMeters:1}
 ]}),t=f.make();t.prepare(f.input);
 assert.equal((await t.search('job-1')).status,ST.NEEDS_TARGET)});
test('same name and 185 items cannot identify folder',async()=>{
 const f=fixture(),t=f.make();t.prepare(f.input);await t.search('job-1');
 assert.equal((await t.listExistingFolders('job-1')).length,2);
 assert.equal(t.read('job-1').folderId,null)});
test('explicit folder click and first-party live ID required',async()=>{
 const f=fixture(),t=f.make();t.prepare(f.input);await t.search('job-1');
 await assert.rejects(t.confirmExistingFolder('job-1',{id:'share-185-AAA'}),/EXPLICIT_FOLDER/);
 await assert.rejects(t.confirmExistingFolder('job-1',{
  id:'unknown-ABC',explicitUserClick:true}),/FOLDER_ID_NOT_FOUND/);
 assert.equal((await t.confirmExistingFolder('job-1',{
  id:'share-185-AAA',explicitUserClick:true})).folderId,'share-185-AAA')});
test('first-party target and folder must match save modal',async()=>{
 const f=fixture({prepareExactSaveUI:async()=>({
  firstPartyTargetMatch:true,firstPartyFolderMatch:false,aliasMatch:true,memoMatch:true
 })}),t=await ready(f);
 assert.equal((await t.save('job-1')).status,ST.BLOCKED);assert.equal(f.writes,0)});
test('strict readback and one-only click',async()=>{
 const f=fixture(),t=await ready(f);
 assert.equal((await t.save('job-1')).status,ST.VERIFIED);
 assert.equal((await t.save('job-1')).status,ST.VERIFIED);assert.equal(f.writes,1)});
test('uncertain commit never repeated',async()=>{
 let n=0;const f=fixture({commitOnce:async()=>{n++;throw Error('lost ACK')}}),t=await ready(f);
 assert.equal((await t.save('job-1')).status,ST.UNVERIFIED);
 assert.equal((await t.save('job-1')).status,ST.UNVERIFIED);assert.equal(n,1)});
test('missing readback never claims success',async()=>{
 const f=fixture({commitOnce:async()=>{}}),t=await ready(f);
 assert.equal((await t.save('job-1')).status,ST.UNVERIFIED)});
test('exact already saved record does not mutate account',async()=>{
 const f=fixture();f.setStored({targetId:'PLACE001',targetKind:'PLACE',
  folderId:'share-185-AAA',alias:'우리 가족',memo:'사진과 함께 저장'});
 const t=await ready(f);assert.equal((await t.save('job-1')).status,ST.VERIFIED);
 assert.equal(f.writes,0)});
test('existing alias mismatch requires human review',async()=>{
 const f=fixture();f.setStored({targetId:'PLACE001',targetKind:'PLACE',
  folderId:'share-185-AAA',alias:'다른 별명',memo:'사진과 함께 저장'});
 const t=await ready(f);assert.equal((await t.save('job-1')).status,ST.NEEDS_REVIEW);
 assert.equal(f.writes,0)});
test('expired job cannot write',()=>{
 const f=fixture(),t=f.make();t.prepare(f.input);f.setTime(100000);
 assert.throws(()=>f.make().read('job-1'),/JOB_EXPIRED_NO_WRITE/)});
test('unauthenticated first party cannot search',async()=>{
 const f=fixture(),t=f.make();t.prepare(f.input);f.setLogin(false);
 await assert.rejects(t.search('job-1'),/FIRST_PARTY_NAVER_SESSION_UNVERIFIED/)});
test('idempotency collision cannot swap photo',()=>{
 const f=fixture(),t=f.make();t.prepare(f.input);
 assert.throws(()=>t.prepare({...f.input,photoId:'another'}),/IDEMPOTENCY_COLLISION/)});
test('no list create/delete API exists',()=>{
 const t=fixture().make();assert.equal(t.createFolder,undefined);
 assert.equal(t.deleteFolder,undefined)});
