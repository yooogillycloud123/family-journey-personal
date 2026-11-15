'use strict';
const fs=require('fs'),assert=require('assert');
const js=fs.readFileSync('experiments/moa-r483/moa-r483-vertical-calendar.js','utf8');
const java=fs.readFileSync('experiments/moa-r507/MoaR507InlineGalleryProvider.java','utf8');
const begin=js.indexOf('async function r592RefreshVisibleDay(){');
const end=js.indexOf('\nfunction r602RefreshMomentNotes()',begin);
assert(begin>0&&end>begin,'exact production same-date function must exist');
const realFunction=js.slice(begin,end);
const day='2026-11-15';
let hydrated=false,rendered=0,closed=0,renderedMedia=0,notes=0,voices=0,start=0,geometry=0,marks=[];
const ui={open:true,page:'day',date:day,dirty:false,media:[{id:'100',t:1},{id:'101',t:2}],idx:1};
let newMedia=[{id:'100',t:1},{id:'101',t:2},{id:'102',t:3}];
const window={__moaR527DayToken:41,__moaR507NativePending:true};
let r507Opened=true;
const r592OpenToken=8;
const ctx={ui,window,getState:()=>({}),r592OpenToken,
 r592HydrateDay:async d=>{assert.equal(d,day);hydrated=true;return true},
 mediaFor:d=>{assert(hydrated);return newMedia;},
 r602Mark:(s,x)=>marks.push({s,x}),r602RefreshMomentNotes:()=>notes++,refreshVoices:()=>voices++,
 renderMedia:()=>renderedMedia++,r527SyncGeometry:()=>geometry++,r507StartInline:()=>start++,
 r594RetryUsed:false,r507Opened,r507StopInline:()=>closed++,
 render:()=>rendered++,r523DayExiting:false,r531Advanced:false,r592RefreshBusy:false};
const names=Object.keys(ctx),vals=Object.values(ctx);
const maker=new Function(...names,realFunction+'\nreturn {run:r592RefreshVisibleDay};');
(async()=>{
 let h=maker(...vals);assert.equal(await h.run(),true);
 assert.equal(rendered,0,'full document render destroys native Gallery');
 assert.equal(closed,0,'original native Gallery must never be closed for same-date new capture');
 assert.equal(start,0,'never restart healthy native player');
 assert.equal(ui.media.length,3);assert.equal(ui.idx,1,'keep current selected old media');
 assert.deepEqual(window.__moaR602PlaylistUpdate.ids,['100','101','102']);
 assert.equal(window.__moaR602PlaylistUpdate.token,41);
 assert.equal(renderedMedia,1);assert.equal(notes,1);assert.equal(voices,1);assert.equal(geometry,1);
 // Stable saved IDs: only refresh notes, never close/rebuild player.
 hydrated=false;newMedia=[...ui.media];assert.equal(await h.run(),false);
 assert.equal(rendered,0);assert.equal(start,0);assert.equal(notes,2);
 // If the old renderer is actually absent, permit a single native-first restart.
 ctx.r507Opened=false;ctx.window.__moaR507NativePending=false;
 h=maker(...Object.values(ctx));
 newMedia=[...newMedia,{id:'103',t:4}];
 assert.equal(await h.run(),true);assert.equal(start,1);
 assert.equal(closed,0);
 const nativeHot=java.slice(java.indexOf('private void r602PollPlaylist('),java.indexOf('private void syncIndex(',java.indexOf('private void r602PollPlaylist(')));
 assert(nativeHot.includes('ids.clear();ids.addAll(updated)'));
 assert(nativeHot.includes('getDeclaredMethod("refreshPages")'));
 assert(nativeHot.includes('ownedDayToken=token'));
 assert(!nativeHot.includes('invokeClose(')&&!nativeHot.includes('clearCardMark('));
 assert(java.includes('NATIVE_HOST_READY_ACTION_DECK_MISSING'));
 assert(java.includes('NATIVE_PREDRAW_ARMED'));
 assert(java.includes('NATIVE_HOST_MOUNTED_WITH_ACTIONS'));
 assert(js.includes('ARM_UNCONFIRMED_DIRECT_NATIVE_ATTEMPT'));
 assert(js.includes('moa-r602-gallery-diagnostic-copy'));
 assert(js.includes('window.__moaR602JavaReport'));
 assert(!js.includes('r580PhotoPending'));
 console.log('R602 real source-extracted same-day gallery hot-list lifecycle, native controls, and failure-stage diagnostic contract: PASS');
})().catch(x=>{console.error(x);process.exit(1)});
