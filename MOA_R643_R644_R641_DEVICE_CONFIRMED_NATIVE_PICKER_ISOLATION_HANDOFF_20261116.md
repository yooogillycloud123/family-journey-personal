# MOA R643 / R644 — R641 physically confirmed native Gallery baseline + independent kinetic photo-add viewer (2026-11-16)

## New actual Galaxy evidence — precedence over previous estimated root causes
User tested **R641** on Galaxy S26 Ultra:
1. Installed R641 and original Android native photo-day Gallery displayed immediately.
2. Samsung One Hand Operation+ (NAVER AccessibilityService) OFF→ON and original native Gallery continued to work.
3. QuickRecord then diary return and original native Gallery continued to work.
4. Photo/detail toggles also worked.
User-provided diagnostic when copied from Settings:
```json
{"version":602,"last":"INIT","events":[],"visibleDay":false,"count":0,"bridge":true,"arm":false,"pending":false,"opened":false,"mounted":false,"r641LastActiveDay":null,"r641LegacyRecoveryAttemptsDisabled":0,"r641Timeline":[{"type":"BOOTSTRAP_LOADED","at":1794824304780,"nativeGallerySource":"R611","alwaysOnRecovery":false}]}
```
This diagnostic was collected in Settings and **does NOT invalidate the user's repeated physical functional PASS**. The trace does not mean the photo-day was never active; unlike previous R640 trace it does not capture live mounted conditions. User uploaded 23089.mp4 (141.63s), and reported the three checks worked. **R641 is now USER DEVICE-APPROVED Golden for the scoped core-native Gallery / Naver OneHand recovery / QuickRecord cycle.** Do NOT call untested photo-add flow approved. Freeze exact signed R641 APK SHA256 **`bf1633ad830057b61ef1d256d57a9215b393800c739c75a113dbb10f06167e89`**, 9,119,310 bytes, cert SHA256 `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`.

## User intent / recent error
User wants to proceed with photo-add gallery visually and kinetically matching approved native photo-day while not destroying working R641 core. Previous UI/process screenshot shows an unrelated earlier attempt stopped at "GitHub MOA 문서 확인..." / "오류"; this isn't evidence of an APK crash, no client error details. Do not infer a runtime failure from that screenshot.

## R643 implementation — exact source scope
Produced **signed R643 code643** `MOA_R643_R641_VERIFIED_GOLDEN_NATIVE_INDEPENDENT_KINETIC_PICKER_ORIGINAL_SIGNED_BETA.apk`, 9,120,933 bytes, SHA256 **`49346c49656bd0c4a8bd43f694eb1e1e9bed039672038348b02814f91414663a`**.
- Built FROM **exact signed R641** (not from failed R625/R629/R631/R633/R635/R637).
- R641's existing 147 APK content members: **144/147 byte-identical**. EXACT changes:
  1. `AndroidManifest.xml` versionCode 641→643 only.
  2. `assets/web/moa-r640-lazy-picker.js` dedicated photo-add JS.
  3. `assets/web/moa-r640-lazy-picker.css` dedicated photo-add CSS.
- All **18 original native DEX**, photo-day `moa-r483-vertical-calendar.js/.css` (including R641 ARM coalescing and QuickRecord return), `family-diary.js`, `moa-r149-voice.js`, `moa-r641-safeguard-bootstrap.js`, and other 144 original members remain exact R641 bytes.
- New picker is an independent WebView DOM viewer, **not the original Android Gallery renderer**. It is loaded lazily only after central +, and source has **zero calls** to `openNativeGallery`, `closeNativeGallery`, `r507StopInline`, `__moaR543RepairInline`, or `MoaLocalAudio`. There is no new Java native host/DEX or special permission.
- Biggest performance correction: R641 picker called `render()` on every enlarged image shift, tearing down the entire frame and up to 121 native-looking filmstrip DOM nodes and reloading all thumbnails. R643 holds the frame, rail, controls and 101-item bounded rail DOM persistently, updates only current media/active classes, and regenerates only near window edges. User's kinetic rail scroll uses native compositor overflow inertia, scroll-snap disabled, scroll settle picks nearest item, avoids programmatic scroll relabeling. **Not a native Android render engine, real Galaxy smoothness not yet proven.**
- Enlarged photo main FAST OFF 1 media per swipe, FAST ON up to 6 by swipe strength; bottom rail always independent inertia. Selected rail tile raised with white outline.
- 16px centered zoom glyph inside 32px touch area; top selected count/add floats in fixed layer and does not alter grid layout on selection. Grid numbered tap and 360ms press-drag; fullscreen selectable □/☑ glyph in bottom action capsule; same original curated.photoIds IndexedDB merge/save/readback code unchanged.
- Real image: original content:// display attempt, 2048px bridge fallback. Real video: original content:// HTML5 player attempt with visible error fallback. **True device URI access/actual original-resolution/video playback unverified**. Do NOT call those fixed until tested.

## Exact tests
- v2 RSA full content digest original signer PASS; ZIP CRC PASS and 4k STORED alignment PASS.
- Original member byte-protection 144/147, DEX18 exact, UI photo-day and QR bootstrap JS exact.
- Node --check picker JS PASS.
- Chromium synthetic mobile 360/390/412 PASS for lazy only +, picker UI, 16px glyph, zero selection layout jump, stable rail object and same rail tile after media swipe, scroll-snap none, fast and rail toggle, preview selection/deselection, mock curated IndexedDB write/readback, 0 original native API calls, 0 JS pageerrors.
- Extra 277-item and real IndexedDB browser navigation QA **NOT CLAIMED PASS**; sandbox administrator blocked HTTPS/file page navigation. Do not include unsuccessful test as PASS.
- **R643 Galaxy physical initial Gallery/QuickRecord/One Hand/photo-add photo/video still NOT VERIFIED.** Never promote R643 to Golden solely on mock.

## Emergency R644
`MOA_R644_EXACT_R641_USER_CONFIRMED_FUNCTIONAL_RECOVERY_ORIGINAL_SIGNED.apk`, code644, 9,119,322 bytes, SHA256 **`091456295a4a4e47624e5ebcc12990993c63f5858f110a5faec010d01c5ace9e`**, original signer full v2 PASS; **146 of 147 R641 members exact; only Manifest versionCode differs**. Emergency only; original R641 picker old viewer/UI preserved, new R643 viewer improvements removed. **If R644 is installed, later version must be ≥645.**

## Bundle / Archive
`MOA_R643_R644_R641_DEVICE_APPROVED_GOLDEN_PICKER_QA_20261116.zip`, 13,196,057B, SHA256 `f3a8e592208259a3ad349118b155f0c9eaae15ffe5ba3f23d7a8dea1098fa6c1`; includes both APKs, picker JS/CSS, exact R641→R643 patch, QA JSON, source build scripts (no private key/password), README, checksums.
Private Library: `/모아_프로젝트_근거_20261103/R643_R644_R641_DEVICE_PASS_GOLDEN_ISOLATED_PICKER_20261116/`, APKs + ZIP.

## Device install/check
Update-install R643 only over installed same-original-signer R641. **Do not uninstall, clear diary/Naver data, reset permissions or rotate signing key.** First recheck three physically successful R641 flows, then central + photo-add grid → zoom → preview rail inertia → bottom selection → add to day, separately original photo and video quality. R644 only in case serious regression. Always keep independent AA AirPods/Android Auto app unchanged.
