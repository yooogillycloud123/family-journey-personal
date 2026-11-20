'use strict';
/*
 * R703 source-level unit gates. Run with:
 *   node experiments/moa-r703/test-map-delta-refresh-controller.js
 * This does not verify the actual R701 APK integration or Android MediaStore.
 */
const assert = require('node:assert/strict');
const make = require('./moa-r703-map-delta-refresh-controller.js');

function harness() {
  const tasks = [];
  const state = {revision:1, seen:[], applied:[]};
  const ctl = make({
    readRevision:async()=>state.revision,
    readDelta:async(from,to)=>{
      state.seen.push([from,to]);
      return {hasChanges:true, from,to};
    },
    applyDelta:async delta=>{state.applied.push(delta);},
    schedule: fn => {tasks.push(fn);return tasks.length;},
    cancel:()=>{},debounceMs:0
  });
  const drain = async () => {
    while(tasks.length) {
      tasks.shift()();
      for (let i=0;i<8;i++) await Promise.resolve();
    }
  };
  return {tasks, state, ctl, drain};
}
async function main() {
  {
    const h=harness();
    h.ctl.signalPhotoIndexChanged(); // map hidden = do not update
    await h.drain();
    assert.equal(h.state.applied.length,0);
    h.ctl.onMapVisible(); await h.drain();
    assert.equal(h.state.applied.length,1);
    assert.equal(h.state.seen[0][0],null);
    assert.equal(h.state.seen[0][1],1);
    // A nonchanged source must not redraw a map.
    h.ctl.signalPhotoIndexChanged();await h.drain();
    assert.equal(h.state.applied.length,1);
    assert.equal(h.ctl.status().unchanged,1);
    // Only new revision refreshes.
    h.state.revision=2;h.ctl.signalPhotoIndexChanged();await h.drain();
    assert.equal(h.state.applied.length,2);
    assert.deepEqual(h.state.seen[1],[1,2]);
    h.ctl.dispose();
  }
  {
    // Failure must keep existing map, leaving dirty for recovery.
    let fail=true,draws=0;
    const h=make({
      readRevision:async()=>3,
      readDelta:async()=>({hasChanges:true}),
      applyDelta:async()=>{if(fail)throw new Error('simulated failure');draws++;},
      schedule:()=>1,cancel:()=>{}
    });
    h.onMapVisible();
    assert.equal(await h.flush(),false);
    assert.equal(h.status().dirty,true);
    assert.equal(h.status().checked,false);
    assert.equal(h.status().lastError,'simulated failure');
    fail=false;
    assert.equal(await h.flush(),true);
    assert.equal(draws,1);
    assert.equal(h.status().dirty,false);
    h.dispose();
  }
  {
    // Hide during in-flight read: do not mutate a hidden map.
    let complete;
    let draws=0;
    const h=make({
      readRevision:()=>new Promise(resolve=>{complete=resolve}),
      readDelta:async()=>({hasChanges:true}),
      applyDelta:async()=>{draws++;},
      schedule:()=>1,cancel:()=>{}
    });
    h.onMapVisible();
    const inFlight=h.flush();
    h.onMapHidden();
    complete('g1');
    await inFlight;
    assert.equal(draws,0);
    assert.equal(h.status().dirty,true);
    h.dispose();
  }
  console.log('R703_SOURCE_ORCHESTRATOR_TESTS=PASS (not APK or Galaxy QA)');
}
main().catch(error=>{console.error(error);process.exitCode=1});
