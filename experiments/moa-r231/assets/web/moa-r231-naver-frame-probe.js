/* MOA R229 - NO-SHIZUKU NAVER web-origin capability PROBE ONLY.
 * Inject using AndroidX WebViewCompat.addDocumentStartJavaScript into these exact
 * origins: https://map.naver.com, https://pcmap.place.naver.com,
 * https://pages.map.naver.com.  Use addWebMessageListener with the same allowlist.
 * Requires user-initiated login in a separate visible WebView, NEVER reads secrets.
 * This is a READ-ONLY pilot; it does NOT click/save/create any NAVER place/list.
 */
(() => {
  'use strict';
  if (window.__MOA_NAVER_WEB_PROBE_V1__) return;
  Object.defineProperty(window, '__MOA_NAVER_WEB_PROBE_V1__', {value:true});
  const ALLOWED = new Set([
    'https://map.naver.com',
    'https://pcmap.place.naver.com',
    'https://pages.map.naver.com'
  ]);
  if (!ALLOWED.has(location.origin)) return;
  const bridge = window.MoaNaverProbeBridge;
  if (!bridge || typeof bridge.postMessage !== 'function') return;
  const MAX_REPORTS = 8;
  const SELECTORS = Object.freeze({
    saveButton: 'a.D_Xqt[aria-pressed], button.btn_favorite',
    saveDialogList: 'button.swt-save-group-info',
    saveCommit: 'button.swt-save-btn',
    addMemo: 'button.swt-save-add-info-btn',
    createList: 'button.swt-create-list, button[aria-label="새 리스트 만들기"]',
    listTitle: 'input.swt-input-text',
    saveListConfirm: 'button.swt-complete-btn',
    resultRow: 'li.UEzoS, li.VLTHu'
  });
  // A claim that a selector is present is not proof it can be clicked or a
  // NAVER account was mutated.  All counters intentionally omit text/values.
  let reports = 0, ended = false, mutations = 0, scheduled = false;
  let prevSignature = '';
  const expiresAt = performance.now() + 30000;
  function report() {
    if (ended || reports >= MAX_REPORTS || performance.now() > expiresAt || !document.querySelectorAll) {stop();return;}
    const counts = {};
    for (const [key, selector] of Object.entries(SELECTORS)) {
      try { counts[key] = Math.min(99, document.querySelectorAll(selector).length); }
      catch (_) { counts[key] = -1; }
    }
    const signature = JSON.stringify(counts);
    if (signature === prevSignature && reports > 0) return;
    prevSignature = signature; reports++;
    const payload = {
      schema: 'moa.naver.web.probe.v1', kind: 'ELEMENT_COUNTS',
      origin: location.origin, isTopFrame: window === window.top,
      counts, tsElapsedMs: Math.max(0, Math.floor(performance.now()))
    };
    try { bridge.postMessage(JSON.stringify(payload)); } catch (_) {}
    if (reports >= MAX_REPORTS) stop();
  }
  let observer;
  function stop() {ended=true; if(observer)observer.disconnect();}
  if (document.readyState === 'loading') document.addEventListener('DOMContentLoaded', report, {once:true});
  else report();
  try {
    observer = new MutationObserver(() => {
      // This probe is intentionally bounded: at most 100 DOM-change notices,
      // 30 seconds total and eight reports, with a small scheduling delay.
      if (ended || ++mutations >= 100) {stop();return;}
      if (scheduled) return;
      scheduled=true;
      setTimeout(() => {scheduled=false;report();}, 250);
    });
    observer.observe(document.documentElement || document, {childList:true,subtree:true});
  } catch (_) {}
  window.addEventListener('pagehide',stop,{once:true});
})();