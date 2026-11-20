/*
 * MOA R703 — isolated map-refresh orchestration candidate.
 * SOURCE WIP ONLY: NOT linked in the R701 APK, NOT a release.
 *
 * Never refresh the diary, reopen a native Gallery, or call the original
 * "사진 다시 읽기" full-rescan control from this module.
 *
 * The real R701 assets/web app/map bridge must provide:
 *  readRevision(): Promise<string|number>  (cheap MediaStore/index revision)
 *  readDelta(previousRevision, nextRevision): Promise<delta>
 *  applyDelta(delta): Promise<void>         (map data/markers only)
 * Required native bridge: signalPhotoIndexChanged() when MediaStore changes.
 * Optional map hook: onMapVisible() when tab opens/returns.
 *
 * No integration until actual R701 APK map methods have been verified.
 */
(function(root, factory) {
  if (typeof module === 'object' && module.exports) module.exports = factory;
  else root.MoaR703MapDeltaRefresh = factory;
})(typeof globalThis !== 'undefined' ? globalThis : this, function createMapDeltaRefresh(options) {
  'use strict';
  const o = options || {};
  if (typeof o.readRevision !== 'function' ||
      typeof o.readDelta !== 'function' ||
      typeof o.applyDelta !== 'function') {
    throw new TypeError('R703_MAP_REQUIRES_VERIFIED_EXISTING_MAP_BRIDGE');
  }
  const schedule = o.schedule || ((fn, ms) => setTimeout(fn, ms));
  const cancel = o.cancel || (id => clearTimeout(id));
  const delay = Math.max(0, Number.isFinite(o.debounceMs) ? o.debounceMs : 240);

  let visible = false, disposed = false, busy = false, dirty = true;
  let timer = null, revision = null, generation = 0, checked = false;
  let lastError = null, applied = 0, unchanged = 0;

  function clearTimer() {
    if (timer !== null) { cancel(timer); timer = null; }
  }
  function queue() {
    if (disposed || !visible || busy || timer !== null) return;
    timer = schedule(() => {
      timer = null;
      void flush().catch(() => {});
    }, delay);
  }
  function signalPhotoIndexChanged() {
    if (disposed) return;
    generation += 1;
    dirty = true;
    queue();
  }
  function onMapVisible() {
    if (disposed) return;
    visible = true;
    // Always compare the CHEAP revision on entry; no full MediaStore scan.
    generation += 1;
    dirty = true;
    queue();
  }
  function onMapHidden() {
    visible = false;
    clearTimer();
    // In-flight read may finish; never update a hidden map.
  }
  async function flush() {
    if (disposed || !visible || busy || !dirty) return false;
    clearTimer();
    busy = true;
    const request = generation;
    try {
      const next = await o.readRevision();
      if (disposed || !visible) return false;
      if (!(typeof next === 'string' || typeof next === 'number') ||
          (typeof next === 'number' && !Number.isFinite(next))) {
        throw new Error('R703_MAP_REVISION_UNAVAILABLE');
      }
      const same = checked && String(next) === String(revision);
      if (!same) {
        const delta = await o.readDelta(checked ? revision : null, next);
        if (disposed || !visible) return false;
        // This callback applies changed map items, not a global app repaint.
        if (delta != null && delta.hasChanges !== false) {
          await o.applyDelta(delta);
          if (disposed || !visible) return false;
          applied += 1;
        }
        revision = next;
        checked = true;
      } else {
        unchanged += 1;
      }
      if (request === generation) dirty = false;
      lastError = null;
      return true;
    } catch (error) {
      lastError = String(error && error.message || error);
      // Fail closed: old map remains unchanged; retry on next entry/change.
      dirty = true;
      return false;
    } finally {
      busy = false;
      if (visible && !disposed && dirty && request !== generation) queue();
    }
  }
  function status() {
    return Object.freeze({
      visible, dirty, busy, checked, revision, applied, unchanged,
      generation, lastError, sourceOnly: true
    });
  }
  function dispose() {
    disposed = true;
    visible = false;
    clearTimer();
  }
  return Object.freeze({
    signalPhotoIndexChanged, onMapVisible, onMapHidden, flush, status, dispose
  });
});
