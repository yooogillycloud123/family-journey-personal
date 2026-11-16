# MOA R640 — R611 physical-Golden-native conservation + isolated, lazy photo-add picker (2026-11-16)

## Exact task / user evidence
R611 approved on a Galaxy S26 Ultra: native original 8-action/filmstrip photo mode appeared immediately on entry, detail↔photo mode worked, Samsung One Hand Operation+ NAVER **AccessibilityService** OFF→ON repeatedly restored original Gallery, QuickRecord same-day photo gallery remained working. Source golden SHA256 `38a507cf2e88a235282ae4d9ad64cf0799033f34ae8fe3e179a58960d1213ccd`.

After new-chat R627–R637 installations, progressively failed: first QuickRecord, then Accessibility toggle, then first day entry. R629 did show native picker photo/video/fullscreen at one point, but R631 QuickRecord regressed and R633+ initial gallery failed. User actual R637 screenshots `23050.png`, `23052.png`, `23055.png` show fallback Web viewer rather than original eight-action native. R638 exact original-version-forward APK was reported by user as **not opening**; this does not specify whether link, package installer or launched app failed, do not speculate.

User supplied exact device R637 diagnostic:
```json
{"version":602,"last":"START_INLINE","events":[{"event":"START_INLINE","at":1794818778820,"count":7}],"visibleDay":false,"count":7,"bridge":true,"arm":false,"pending":false,"opened":false,"mounted":false}
```
Do not infer `visibleDay:false` proves page never active: report copied from Settings. R611 original JS emits START_INLINE before asynchronous `setTimeout(tryOpen,0)` and silently returns when generation changes, UI/page changes, or view becomes hidden. Further failure causes unproven without live day-stage logcat.

## Source-derived regression code locations and confidence
- R629 actual APK's `assets/web/moa-r483-vertical-calendar.js` new `r619EnterMediaPicker()` **calls `r507StopInline()`** on photo-day entry; if it thinks native pending without JS opened, it can also call `MoaLocalAudio.closeNativeGallery()`. Its zoom action calls **the SAME `MoaLocalAudio.openNativeGallery` instance** and changes `r531Advanced`. Thus R629 **factually reused original native Gallery ownership and lifecycle**, rather than simply cloning visual UI. This is a concrete regression-risk path but not independently proven as the only physical root cause.
- R631 added a Java per-tick picker observer/overlay in `classes18.dex`; R633 moved button into native capsule and added independent QuickRecord repair; R635 modified native ARM snapshot. R637 reverted all original R611 DEX and photo JS/CSS yet device still failed, so claims that just the changed DEX explains its **first-launch** failure are falsified.
- R637 `index.html` eagerly loads new independent picker JS before first photo day. It does not call native Gallery until the plus action, so don't assert a native picker action caused first-entry failure.

## R640 exact implementation and preservation
- Built **directly from original SHA-verified R611 APK**, never from R629/R631/R633/R635/R637 binaries.
- `com.juhyeon.familyjournea` same original signing certificate SHA256 `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`.
- Signed APK filename `MOA_R640_R611_GOLDEN_NATIVE_SAFEGUARD_LAZY_PICKER_SIGNED_BETA.apk`, short alias `MOA_R640.apk`, code **640**, **9,118,704 bytes**, SHA256 **`d27249135d3400c74c81dd46079effce794237457cd611267b45c7ffdaf9dd30`**.
- **142/144 original preexisting APK payload members exact**, only `AndroidManifest.xml` version 611→640 and `assets/web/index.html` 1 script link changed; 3 additional WEB assets `moa-r640-safeguard-bootstrap.js`, `moa-r640-lazy-picker.js`, `moa-r640-lazy-picker.css`.
- **18/18 original native DEX exact**, original `moa-r483-vertical-calendar.js/.css`, `family-diary.js`, `moa-r149-voice.js` exact. Preserve original Java R611 Accessibility OFF/ON, QuickRecord playlist and Gallery source, not a merely approximate rewrite.
- NEW lazy picker JS/CSS is **loaded only when the central + button is actually tapped**, not at boot or photo-day entry. Only new light bootstrap loads during index. The picker is a separate WebView DOM panel, no calls to original `MoaLocalAudio.openNativeGallery`, `closeNativeGallery`, `r507StopInline`, or original native ownership/repair. It is **not an independent native engine**. Real video content URI and original photo precision remain physical QA requirements.
- R640 bootstrap extends existing `원본 갤러리 진단 복사` JSON to include last photo-day snapshot, actual Android gallery-open state, stage attached/width, bridge method presence and state timeline. Does not dump photos, diary text, GPS.
- **Bounded safe abort repair**: only if photo-day is STILL active and its stage attached/visible, last R611 event is START_INLINE older than **9.5 sec**, no R611 pending/open/mounted/arm, bridge and bridge method available, Android `isNativeGalleryOpen()===false`; then invoke existing original R611 `__moaR543RepairInline` at most twice with 15-second gap. NEVER call while native gallery is open, state is unknown, stage missing, another failure event was logged, or navigation changed. This is a **risk-limited code-level mitigation for a silent abort**, not proof of the Galaxy root cause or immediate performance.
- R637 standalone picker improved to load only on demand, reserve selection header height to avoid jump, and use scrollend/debounce rail settle. Original-content URI-first Web photo with 2048 fallback; selected photo IDs merge into the same original `curated.photoIds` with mock readback; no media copy/delete.
- **R611 UI baseline** may lack post-R611 cosmetic improvements from R613–R635; preserve original native function at priority over UI cosmetics.

## Verification gates performed locally
- APK-v2 RSA signature/full digest original cert PASS, ZIP CRC PASS, original 18 DEX member byte-exact, original JS/CSS/diary/voice byte-exact.
- Node `--check` JS PASS.
- Chromium **mock** 360/390/412: no picker initialization before central +, grid select/deselect, enlarged select, rail present, controlled fake IndexedDB commit and readback, **zero original native calls**. **Mock, not actual Galaxy**.
- Six isolated guard conditions on Chromium: healthy native (0 repairs); confirmed closed stale START_INLINE (1 repair); stage missing (0); not photo-day (0); another native failure stage (0); bridge unavailable (0). Physical results not established.
- Private bundled APK+source/QA ZIP `MOA_R640_R611_ORIGINAL_GOLDEN_NATIVE_RECOVERY_SOURCE_QA_20261116.zip` SHA256 `2e53bcdf65557be4acd3b8787e65af7cf629cc1fd716b5de233fbe2b5c06afc2`.
- Private Library `/모아_프로젝트_근거_20261103/R640_R611_IMMUTABLE_SAFEGUARD_LAZY_PICKER_20261116/` contains short signed APK and full QA bundle.

## Crucial limitations — DO NOT MISREPRESENT
**Galaxy R640 original Gallery first-entry / QuickRecord / One Hand Naver toggle still UNTESTED; R640 is NOT GOLDEN/FINAL.** We did not diagnose exact cause of R638 "cannot open" without installer or launch error. APK byte identity and browser simulations cannot certify physical lifecycle. No device-level native rail or original media URI playback confirmed for independent WEB picker. Do not assert any of these as PASS.

**Safety:** Do not uninstall app, clear settings, reset Naver session/media, rotate signing key, modify protected R611 golden, or change independent AA AirPods Android Auto runtime. Next signed code must exceed 640.
