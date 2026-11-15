'use strict';
const fs=require('fs'),assert=require('assert');
const src=fs.readFileSync('experiments/moa-r483/moa-r483-vertical-calendar.js','utf8');
function slice(a,b){const i=src.indexOf(a),j=src.indexOf(b,i+a.length);assert(i>=0&&j>i);return src.slice(i,j);}
const helper=slice('function r598TryOriginalGallery(ids,wanted,day){','function r507StartInline(){');
const openFn=slice('function r507StartInline(){','// R495: user preference');
let attempts=[];
const bridge={openNativeGallery:(packed,index,day)=>{
 const ids=JSON.parse(packed);attempts.push({ids,index,day});
 return ids[index]==='234'; // Simulate original ContentResolver.openFileDescriptor
}};
const original=new Function('window',helper+'\nreturn r598TryOriginalGallery;')({MoaLocalAudio:bridge});
let r=original(['234','999'],0,'2026-11-15');
assert.deepStrictEqual(r,{ok:true,index:0,attempts:1},'native directly accepts a real new media ID absent from Web byId cache');
assert.strictEqual(attempts.length,1);
attempts=[];r=original(['999','234','888'],0,'2026-11-15');
assert.deepStrictEqual(r,{ok:true,index:1,attempts:2},'when selected photo truly missing try nearest real original photo');
assert.deepStrictEqual(attempts[1].ids,['999','234','888'],'preserve full original gallery playlist');
attempts=[];r=original(['901','902','903','904','905','906'],0,'2026-11-15');
assert.strictEqual(r.ok,false);assert(r.attempts<=4,'no infinite reopen storm');
assert(openFn.includes('const nativeResult=r598TryOriginalGallery(ids,ui.idx,ui.date)'));
assert(openFn.includes('const state=getState(),uncached=ids.filter'),'cache used for diagnostic only');
assert(!openFn.includes('if(missing.length){'),'R596 blocking cached-ID gate prohibited');
assert(!openFn.includes('r596ShowWeb(state?.load?'),'R596 Web fallback before native proof prohibited');
assert(openFn.includes("r594Fallback('NATIVE_OPEN_REJECTED')"),'Web fallback remains for genuinely unreadable files');
assert(openFn.includes('r594RequestIndexOnce()'),'bounded index refresh remains after native failure');
assert(src.includes('r592HydrateDay(day)')&&src.includes('r596ShowWeb(reason)'),'diary and Web emergency path preserved');
assert(!src.includes('r580PhotoPending')&&!src.includes('r584RecoverGallery'),'no earlier broken native host blocker');
console.log('R598 direct original MediaStore gallery open and bounded alternate index; 13 source/unit gates PASS');
