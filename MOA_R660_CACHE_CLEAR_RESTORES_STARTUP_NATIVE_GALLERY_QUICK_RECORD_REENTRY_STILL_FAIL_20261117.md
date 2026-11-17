# MOA 2026-11-17 UPDATED PHYSICAL EVIDENCE: R660 STARTUP RECOVERED AFTER CLEAR-CACHE; QUICK RECORD REENTRY STILL FAILS

## New user's exact physical reproduction; supersedes previous blanket "R660 failed"
User kept installed R660 exact uploaded R657 functional payload; did **not** reinstall another APK. After Samsung app **CLEAR CACHE** + re-launch, PHOTO in-card original native Gallery reappeared immediately. One Hand Operation+ OFF→ON also left original Gallery functional. User provided screenshot `23302.png`: 2026-11-15 day has native bottom eight-action toolbar, media filmstrip, diary contents/voice. User reports **after QuickRecord** original PHOTO native Gallery failed again, and provided new current-version R602 Gallery Diagnostic:

```json
{"version":602,"last":"START_INLINE","events":[
{"event":"NATIVE_8_ACTION_DECK_READY","at":1794875905174},
{"event":"NATIVE_GALLERY_OPEN_OBSERVED","at":1794875905329},
{"event":"NATIVE_8_ACTION_DECK_READY","at":1794875905330},
{"event":"NATIVE_GALLERY_OPEN_OBSERVED","at":1794875905484},
{"event":"NATIVE_8_ACTION_DECK_READY","at":1794875905484},
{"event":"NATIVE_GALLERY_OPEN_OBSERVED","at":1794875905639},
{"event":"NATIVE_8_ACTION_DECK_READY","at":1794875905639},
{"event":"NATIVE_GALLERY_OPEN_OBSERVED","at":1794875905794},
{"event":"NATIVE_8_ACTION_DECK_READY","at":1794875905795},
{"event":"NATIVE_GALLERY_OPEN_OBSERVED","at":1794875905949},
{"event":"NATIVE_8_ACTION_DECK_READY","at":1794875905949},
{"event":"NATIVE_GALLERY_OPEN_OBSERVED","at":1794875906104},
{"event":"NATIVE_8_ACTION_DECK_READY","at":1794875906104},
{"event":"NATIVE_GALLERY_OPEN_OBSERVED","at":1794875906259},
{"event":"NATIVE_8_ACTION_DECK_READY","at":1794875906260},
{"event":"START_INLINE","at":1794875913393,"count":8},
{"event":"START_INLINE","at":1794875915153,"count":8},
{"event":"START_INLINE","at":1794875916802,"count":18}],
"visibleDay":false,"count":18,"bridge":true,"arm":false,"pending":false,"opened":false,"mounted":false}
```
KST: successful READY ~09:38:25–26, new START_INLINE at 09:38:33.393, 35.153 (+1760ms), 36.802 (+1649ms). Three new attempts and media count 8→8→18, so effective media list is populated and dynamically updated. **No subsequent PREDRAW_ARMED / OPEN_ACCEPTED / MOUNT_ACK in the last 18 events**. End state visibleDay=false may reflect the Settings diagnostic-copy page, NOT earlier page absence. R602 **version 602 is only diagnostic format**, not code.

**CRITICAL correction:** R660 is **startup recovered after clear-cache** but **QuickRecord→PHOTO native Gallery reentry device FAIL**. R658 initial installation failures and R659 restore issues may have been confounded by reused WebView cached runtime and lifecycles; they cannot be retrospectively classified as pure code defects nor declared good. Do not rewrite history as “all old versions were fine” or “all old failures were cache”. The successful clear-cache is strong evidence for cached-resource/startup-state component, but because app was relaunched and cache cleared jointly, cannot isolate the precise cache entries from restart side effects without A/B. No user fault.

## Actual R657/R660 original APK JS inspected (same SHA, not just old docs)
User-uploaded R657 APK SHA `f8c0e460ecacc7ab6d5a9a7c41dcee5e6fa8f25c94554c446c814ec983d6861a`; R660 functional JS is byte-identical. Source `assets/web/moa-r483-vertical-calendar.js`:
- `r507StartInline` logs `START_INLINE` **synchronously before** `r507Timer=setTimeout(tryOpen,0)`; so START_INLINE does NOT prove `tryOpen` executed nor `__moaR511InlineArm=true` nor Java maybeArm returned. Its async `tryOpen` first returns silently if generation superseded, current day/page hidden/changed; bridge condition, MediaStore IDs and stage connected then set JS arm true, wait Android `__moaR511NativeArmed` up to 8sec and fallback. New starts can cancel previous generation/timer.
- `r507StopInline` bumps generation, clears native ARM/NativePending and if opened calls `MoaLocalAudio.closeNativeGallery()`. This occurs in `render()` before `view.replaceChildren()`. **If returning from QuickRecord re-renders the PHOTO day rather than only hot-updates media list, an existing host may be destroyed/replaced**. No evidence current UI did exactly that, but source establishes a risk.
- The in-place QuickRecord-specific path `r592RefreshVisibleDay()` in R657 compares photo ids, calls `renderMedia()`, `refreshVoices()`, moment/story refresh, and updates `__moaR602PlaylistUpdate` without `render()`. This keeps the already-mounted native owner alive **only when active PHOTO day gets the `moa:native-diary-committed` event**, not necessarily locked/background/camera return. There are other day-entry and async hydrate/render code paths, including `r592PrepareView()` async IndexedDB hydration with 2800ms paint fallback; the same host lock contract must cover those.
- Shared native Gallery is used in BOTH detail/photo flows with different lifecycle contracts. Detail `FamilyJourneyDiary.selectDay` owns original R463 media/gallery; PHOTO uses `MoaR507InlineGalleryProvider` Android host overlay on `.moa-r469-stage` with geometry and Java preDraw ARM, plus WebView outer UI. Therefore “detail = WebView only; photo = native only” is inaccurate. Restoring old WebView in-card player may reintroduce photo/video flicker and layout jump; no downgrade/goal reduction.
- R660 R602 diagnostic retains last 18 events, does not record `tryOpen` entry/abort/source or actual Java guard exit; **cannot distinguish Java processing/predraw guard vs async generation abort/cancel from current trace**. Earlier R655 61 MAYBE_ARM_DENY_PROCESSING evidence applies only to that other compiled candidate, not automatically R660.

## Release design locks (non-destructive)
A. User cache discovery must be first-class test: on each app version upgrade, perform targeted **WebView.clearCache(true) once before loading new local JS/CSS** with main/UI-thread lifecycle and guard version marker. This clears WebView RAM+disk resource cache, NOT cookies, localStorage, IndexedDB (Android docs WebView#clearCache, OWASP MASTG). Consider fingerprint/version URLs for local JS/CSS or short cache-control headers in asset path; the app's `https://familyjourney.local` resource paths are currently versionless; verify exact native interception before changing. Do not clear cache at each startup, never clear data/cookies/IndexedDB or uninstall.
B. Keep PHOTO **one native in-card owner**, no old WebView full photo rendering, no scroll-induced stage replacement. Implement single serialized **QuickRecord commit→day hydration→stable DOM stage→JS_ARM_REQUESTED→Java maybeArm/processing reason→preDraw→original OPEN→MOUNT ACK→8-actions** lifecycle with epoch/generation/Activity tokens. Update playlist in-place when same host is already live; never close/reopen healthy native gallery in response to a routine diary commit. If preDraw denies, report explicit return reason via low-impact native ring buffer; JS records `TRYOPEN_ENTER`, `TRYOPEN_ABORT_REASON`, `ARM_SET`, TIMEOUT and delivery without frequent `evaluateJavascript` hot-path probes.
C. Keep fallback visually stable poster/rail until native mount confirmed; do not paint duplicate viewers or switch owner on scroll. Coordinate geometry on layout changes rather than modifying WebView gallery DOM. Graceful bounded recovery may retry **only a genuinely unmounted host after explicit failure with same generation**. Never infinite rearm timers or blindly terminate old host.
D. R660 QuickRecord current physical failure is unresolved; hold R657 functional Golden baseline and do not promote R660/unknown subsequent APK based on clear-cache success alone.
E. Physical QA: fresh upgrade after targeted cache invalidation, app cold start, One Hand OFF→ON, PHOTO/detail/calendar, repeated QuickRecord while app foreground/unlocked/locked and 8-action rail, media index increase, scroll, video/recording, Naver and diary persistence, reboot. Capture entire new-session Settings Full Execution Trace + R602 with PHOTO active after >=8 seconds for accurate ARM diagnosis.
F. R658 photo picker update not yet demonstrated physically successful after cache clearing; do not retest on primary user device without separate safe rescue/backup. No more version-only “restores” and no damage to unrelated AA AirPods audio.

## Sources
Exact uploaded APK JS, user screenshot and device R602 JSON on 2026-11-17, earlier R655 Galaxy physical processing guards documented separately. API: https://developer.android.com/reference/android/webkit/WebView#clearCache(boolean); https://mas.owasp.org/MASTG/knowledge/android/MASVS-PLATFORM/MASTG-KNOW-0018/; local content https://developer.android.com/reference/androidx/webkit/WebViewAssetLoader. Raw user screenshot/log is private, do not upload to public repo.
