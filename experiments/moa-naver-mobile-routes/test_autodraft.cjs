'use strict';
const assert=require('node:assert/strict'),a=require('./MoaNaverAutoDraft.js');
const photo={id:'111',lat:35.8,lon:127.1,address:'대한민국 테스트 주소 100'};
assert.equal(a.prepare({},{}).status,'NEEDS_GPS');
assert.equal(a.prepare(photo,{alias:'우리 가족',memo:'방문 기록',list:'가족'}).status,'NEEDS_POI');
assert.equal(a.prepare(photo,{verifiedPlaceName:'방문 장소'}).status,'NEEDS_POI');
assert.equal(a.prepare({...photo,address:''},{}).status,'NEEDS_ADDRESS');
const job=a.prepare(photo,{alias:'우리 가족',memo:'방문 기록',list:'가족'},
 {placeId:'1234',placeName:'가상의 장소',address:photo.address});
assert.equal(job.status,'READY');
assert.equal(job.photoId,'111');
assert.equal(a.readbackMatches(job,{listName:'가족',sid:'1234'}),false);
assert.equal(a.readbackMatches(job,{listName:'가족',sid:'1234',alias:'우리 가족',memo:'방문 기록'}),true);
assert.equal(a.readbackMatches(job,{listName:'가족',sid:'4321',alias:'우리 가족',memo:'방문 기록'}),false);
assert.equal(a.readbackMatches(job,{listName:'다른 리스트',sid:'1234',alias:'우리 가족',memo:'방문 기록'}),false);
const noMemo=a.prepare(photo,{list:'내 장소'},{placeId:'1234',placeName:'가상의 장소'});
assert.equal(noMemo.status,'READY');
assert.equal(noMemo.memo,'');
console.log('MOA strict photo GPS automatic request/readback unit PASS — no NAVER account test');
