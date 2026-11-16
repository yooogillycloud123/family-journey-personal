# MOA R655 real Galaxy device trace: Java `processing` gate blocks PHOTO-inline

2026-11-17 KST. Source: user private upload `txt_1794854006780.txt` (4,842 JSON event rows), `23276.mp4` (83.11 sec). Do not publicly upload raw private trace or recording. This evidence overrides earlier R655 `DEVICE UNTESTED` handoff. **R655 was used on actual Galaxy and PHOTO-inline native mount failed; R655 is not Golden and does not fix QuickRecord.**

## New device evidence (UTC logs; KST = UTC+9h)

Full trace retains older builds: none 2,081; R648 1,360; R649 292; R653 261; **R655 848** events. R655 sessions `mwjlo2pg-adtbqn` (18:31:37.396–53.117Z) and `mwjloib4-wm1cbp` (18:31:57.617–18:32:51.884Z) contained **193 R655_JAVA_BRANCH** events. Of these, `TICK_CALL_MAYBE_ARM_CLOSED=62`, `MAYBE_ARM_ENTER=62`, **`MAYBE_ARM_DENY_PROCESSING=61`**, `TICK_DENY_INACTIVE_ACTIVITY=8`. No recorded MAYBE_ARM_CALLBACK_ACCEPT, NATIVE_PREDRAW_ARMED, NATIVE_OPEN_ACCEPTED, NATIVE_MOUNT_ACK in the R655 sessions. Some previously retained historical builds show these success markers: DO NOT mix them with current failure.

10 `R655_JS_START_INLINE`, 10 `R655_JS_TRYOPEN_ENTER`, 10 `R655_JS_ARM_REQUESTED`, 21 `R655_JS_WAIT_JAVA_ARM`; 3 `R655_JS_TRYOPEN_ABORT` (SUPERSEDED 1, PAGE_CHANGED 2); 1 `R655_JS_JAVA_ARM_TIMEOUT` at 18:32:24.595Z; 11 `R655_JS_STOP_INLINE`; no recorded mount ACK. New Java bridge records `attemptId` (WebView context) but `nativeAttemptId='unbound'` for every Java branch, meaning no accepted ARM snapshot token was observed in the current export.

Correlated example attempt `R655:mwjloib4-u90a:g4`: 18:32:16.589Z START_INLINE; 16.597 tryOpen; 16.598 JS_ARM_REQUESTED; 17.172 Java MAYBE_ARM_DENY_PROCESSING; repeated until 20.057; activity inactive from ~20.225; 24.595 JS_JAVA_ARM_TIMEOUT. After 18:32:28.581 QUICK_RECORD_NATIVE_COMMIT, JS g5→g6 replacements/abort `SUPERSEDED` and `PAGE_CHANGED` appear while Java still DENY_PROCESSING.

Video checked as independently uploaded 83.11 sec: visible calendar and detail/media UI, QuickRecord/camera UI, and old photo-add WebView picker, but this does not prove PHOTO-inline original 8-action native host mounted. No positive PHOTO-inline native mounting ACK in current R655 trace. This is a function failure, not successful 'diagnostics = success'.

## Source-level mechanism and key uncertainty

Original R611/R648 `MoaR507InlineGalleryProvider.java` `maybeArm()` has one shared boolean `processing`: if true, the call returns immediately. The flag also guards `tick()`'s gallery-open `SNAPSHOT`. On successful path it sets `processing=true` before `web.evaluateJavascript(ARM_SNAPSHOT, callback)` and resets only in the callback. The gallery-open `SNAPSHOT` branch has similar callback reset and synchronous `catch`; if callback is never delivered during WebView lifecycle/navigations, future `maybeArm()` calls can be denied indefinitely. **This conditional mechanism matches the observed 61 denials but proof of the exact lost callback / how processing first latched is still absent.** No R655 `MAYBE_ARM_EVALUATE_ARM_SNAPSHOT` or `MAYBE_ARM_CALLBACK_*` events appeared in full user export. Source suggests either the `processing` field was set earlier by another async operation, or the bridge event delivery was lost; cannot choose one based on this trace.

**Important instrumentation confound:** R655 new `r655Branch()` calls `web.evaluateJavascript(...)` for branch report for each polling tick and at `maybeArm()` entry/return, in addition to original evaluateJavascript snapshots. On a busy WebView this can change scheduling, queueing and callback delivery. It might worsen an existing race or create a new one. R655 Java trace itself is NOT behavior-neutral. Claiming Java alone caused this in the R648 physical baseline is unwarranted.

Video shows detail/gallery and old photo-add UI but they are different entry paths. R655 intentionally included no new native photo picker. Preserve user's scoped R648 Golden and original data.

## Required next action — no blind release

1. Quarantine R655 as real-device PHOTO-inline failure. Do not label final or Golden. R656 original-R648-functional version-forward APK remains available and signed but device recovery not proven; no uninstall/data clearing.

2. Make `processing` an explicit per-operation state (`operation`, `generation`, `startTime`, `Activity/WebView identity`) with bounded callback timeout releasing **only the same generation's stale lock**. Avoid restarting an already running/visible native Gallery; do not add timers to call open/close repeatedly. This is a proposed fix, not yet implemented or physically validated.

3. Separate original-source event telemetry from hot-path UI JS callbacks: write native ring buffer/logcat on Java branches; export on demand through a single low-frequency/one-shot transport. Instrument `PROCESSING_SET`, callback delivered, exception, `PROCESSING_CLEAR`, stale-timeout, request ID and source `SNAPSHOT` versus `ARM_SNAPSHOT`. Also retain JS `TRYOPEN_ABORT(reason)` and native actual `close/detach` caller.

4. Use real Galaxy A/B in two distinct builds (R648 exact source + passive low-impact telemetry vs revised guarded processing), test first launch, One Hand Naver OFF→ON, QuickRecord locked/unlocked/in-app, detail/photo/map, photo-add after original photo-inline stable. No claim of PASS without user physical test. Next versionCode >=657, rollback > candidate, same signer.

5. Do not change AA Android Auto/AirPods project. User trust is damaged; prioritize demonstrable reproducible evidence, no serial guess-based APKs.