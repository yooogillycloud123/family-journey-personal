// MOA R44 native-to-existing-diary bridge INSERT ONLY inside family-diary.js IIFE.
// Do not ship as a separate page. Reuses: S, dbGet, dbPut, dateOf,
// mmGroupKey, mmAppendActivity, timeOf, render, loadIndex, init.
let mnImportBusy = false, mnLastRefresh = 0;
function mnBridge() {
  return (typeof window.MoaMomentNative !== 'undefined' &&
    typeof window.MoaMomentNative.drafts === 'function') ? window.MoaMomentNative : null;
}
function mnSafeDrafts() {
  const b = mnBridge(); if (!b) return [];
  try {
    const a = JSON.parse(b.drafts() || '[]');
    return Array.isArray(a) ? a.filter(d => d && /^(?:v)?\d{1,19}$/.test(String(d.id)) &&
       Number.isFinite(+d.at) && +d.at > 0).sort((a,b)=> +a.at - +b.at) : [];
  } catch (e) { console.warn('MOA moment native inbox parse:', e); return []; }
}
async function mnImportNative() {
  if (mnImportBusy || !mnBridge()) return;
  mnImportBusy = true;
  try {
    await init();
    const batches = mnSafeDrafts();
    for (const d of batches) {
      const id = String(d.id);
      // Never ACK a native item until the actual MediaStore ID exists in the MOA index.
      if (!S.byId || !S.byId.has(id)) continue;
      const day = dateOf(+d.at), note = String(d.note || '').trim().slice(0, 2000);
      if (!day) continue;
      const uid = 'native_' + id;
      const prev = await dbGet('curated',day) ||
        {day, title:'', body:'', photoIds:[], tags:[], feeling:'', activities:{},
          selectionMode:'manual', moments:[], source:'native-moment'};
      const ids = [...new Set([...(prev.photoIds||[]).map(String), id])];
      const moments = Array.isArray(prev.moments)?prev.moments.map(m=>({...m})):[];
      const old = moments.find(m=>m.uid===uid);
      const m = old || {uid, at:+d.at, photoIds:[id],note:'',createdAt:+d.at};
      if (!old) moments.push(m);
      // A native edit may be newer than an earlier synchronized draft.
      const oldText = String(m.note || '').trim();
      m.note = note; m.updatedAt = +d.updatedAt || Date.now();
      const updated = {...prev, day, photoIds:ids, moments,
                       selectionMode:'manual', updatedAt:Date.now()};
      const activityKey=mmGroupKey(updated,m);
      m.activityKey=activityKey;
      const activities={...(prev.activities||{})};
      const base=String(activities[activityKey]||'');
      const prior=oldText ? timeOf(m.at) + ' · ' + oldText : '';
      activities[activityKey] = prior && base.includes(prior)
        ? base.replace(prior,'').replace(/\n{2,}/g,'\n').trim():base;
      if(note) activities[activityKey]=mmAppendActivity(activities[activityKey],m,note);
      updated.activities=activities;
      await dbPut('curated',day,updated);
      const confirmed=await dbGet('curated',day);
      const saved=(confirmed?.moments||[]).find(x=>x.uid===uid);
      // Retry on interruption / IndexedDB failure. No premature ACK, no false success.
      if (!confirmed?.photoIds?.map(String).includes(id) || !saved ||
          String(saved.note||'').trim() !== note) continue;
      S.curatedEntries.set(day,confirmed);
      // Unwritten moments remain queued natively so the notification can add a note later.
      if (note) {
        try { mnBridge().ack(id); } catch(e) { /* retry next pass */ }
      }
    }
    if (S.open && !S.editing) render();
  } catch(e) { console.warn('MOA native photo diary import postponed:',e); }
  finally { mnImportBusy = false; }
}
function mnScheduleImport() {
  if (!mnBridge()) return;
  const now=Date.now(); if (now-mnLastRefresh<1200)return;
  mnLastRefresh=now;
  // The native foreground service handles event detection while the camera is open.
  // This is only the reliable two-phase commit into the preexisting MOA IndexedDB.
  setTimeout(async()=>{
    if(!S.byId || !S.byId.size) await loadIndex(false);
    await mnImportNative();
  },220);
}
function mnLinkNativeControls() {
  const native=mnBridge(); if(!native)return;
  // Native QuickTile is authoritative; legacy localStorage polling must not compete.
  try { mmEnabled=false; } catch(e) {}
  document.addEventListener('visibilitychange',()=>{
    if(document.visibilityState==='visible') mnScheduleImport();
  });
  window.addEventListener('focus',mnScheduleImport);
  setInterval(()=>{if(document.visibilityState==='visible') mnScheduleImport()},5000);
  mnScheduleImport();
}
// Call mnLinkNativeControls() once after diary init/mount; do not duplicate legacy timer.
