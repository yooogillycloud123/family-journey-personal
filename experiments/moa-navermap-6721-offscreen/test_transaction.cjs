const assert=require('node:assert/strict');
const t=require('./MoaNaverBookmarkTransaction.js');
(async()=>{
 const job=t.prepare({id:'photo42'},{placeId:'1234',folder:'가족',alias:'별명',memo:'메모',requestId:'one'});
 assert.equal(job.phase,'QUEUED');
 assert.equal(t.prepare({id:'photo42'},{placeId:''}).phase,'NEEDS_PLACE_CONFIRMATION');
 assert.equal((await t.run(job,null)).phase,'BLOCKED_NO_FIRST_PARTY_WRITER');
 let count=0;const stored={};
 const writer={authenticated:async()=>true,folderExists:async()=>false,
   createFolderThroughFirstPartyUI:async()=>{},
   readback:async(_,sid)=>stored[sid],
   upsertThroughFirstPartyUI:async x=>{count++;stored[x.placeId]={placeId:x.placeId,folder:x.folder,alias:x.alias,memo:x.memo};}};
 assert.equal((await t.run(job,writer)).phase,'CONFIRMED');
 assert.equal((await t.run(job,writer)).phase,'CONFIRMED');
 assert.equal(count,1);
 assert.equal((await t.run(job,{...writer,readback:async()=>({placeId:'1234',folder:'가족'})})).phase,'SUBMITTED_UNVERIFIED');
 console.log('Synthetic first-party writer transaction contract: PASS. REAL NAVER SAVE IS NOT IMPLEMENTED.');
})().catch(e=>{console.error(e);process.exit(1)});
