# MOA R637 / R638 — physically approved R611 original native Gallery untouched, standalone picker — 2026-11-16

## Actual user feedback supersedes all R629–R635 static claims
The user reports R635 installed on Galaxy S26 Ultra still has **no original native gallery from first app open, after repeated Samsung One Hand Operation+ NAVER Accessibility OFF→ON, or after QuickRecord**. Actual user video `23039.mp4` (18.974589s) visibly shows app restart, November 16 photo day, old non-native Web gallery with no original filmstrip/8-action bottom chrome. **R629–R635 are NOT physical Golden.**

## Exact APK-source regression timeline — FACT vs HYPOTHESIS
- R611: user-device-accepted original native Gallery + repeated NAVER Access OFF/ON and same-day QuickRecord success; original same-signer APK SHA256 `38a507cf2e88a235282ae4d9ad64cf0799033f34ae8fe3e179a58960d1213ccd`.
- R625 photo add was a separate Web picker and 18/18 original R611 native DEX unchanged.
- R629 changed picker zoom to call original `MoaLocalAudio.openNativeGallery` and track `isNativeGalleryOpen()`, combining picker with an original native host previously owned by the photo-day flow.
- R631/R633/R635 modified `classes18.dex` in order to insert native selection control. R631/R633 added independent Java picker poll in original gallery tick; R635 switched to modified ARM snapshot. Their Android compile passes did NOT prove Galaxy original photo-day still mounted.
- R635 `r619EnterMediaPicker` includes `r507StopInline()` and conditional `closeNativeGallery()`. This is a verified shared-gallery shutdown path; without phone logcat it cannot be declared the unique cause of first-launch failure.
- **Do not copy, reuse, or modify original R611 Android native Gallery host for photo-add again without explicit physical validation.**

## R637 design: STRICT original Galaxy Golden boundary
Actual produced **R637 code637 same original signer**:
`MOA_R637_R611_GOLDEN_INTACT_SEPARATE_WEB_PICKER_ORIGINAL_SIGNED_BETA.apk`
Size **9,116,158B**, SHA256 **`a8f81e1a2b102e01fe33aba160f26834da2062d18aeba438ae9b7a3c51c530a2`**.
- Built FROM exact immutable R611 signed APK, NOT the R635 derivative.
- **142/144 pre-existing APK entries byte-for-byte identical**; only original `AndroidManifest.xml` versionCode 611→637 and `assets/web/index.html` two new asset links changed.
- **18/18 original R611 native DEX identical, original `assets/web/moa-r483-vertical-calendar.js` and `.css` byte-exact**, and every other original asset/member unchanged.
- NEW `assets/web/moa-r637-standalone-picker.js` + `.css`, no native DEX changes.
- The new picker intercepts ONLY central `button[data-tab=moa-plus]` and does not call `openNativeGallery`, `closeNativeGallery`, `r507StopInline` or native repair. When leaving photo-day for picker it invokes ONLY user-facing **existing** `MoaR469SimpleDiary.openCalendar()`; on cancel/save it invokes original `MoaR469SimpleDiary.openDay(day)` to rebuild the day.
- Standalone separate WebView DOM picker (not a second physical WebView/activity): device day/all photos/videos, selection numbered grid, long-hold sweep selection, full-screen photo preview with bottom select/clear, native-looking kinetic horizontal rail (scroll-snap disabled), optional Fast main swipe, original MediaStore image URI first then existing 2048px `__requestThumbs` fallback, HTML5 video attempting original content URI. **Original photo resolution and Android WebView video content:// access still device-unverified**.
- Single existing IDB v2 `curated` store `photoIds` merge and transaction+readback, preserving diary text, moments, audio, removedMediaIds. No media copy/delete, no app reset.

## Verification vs physical QA
- Same signer certificate SHA256 `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`, APK v2 full digest+RSA signature PASS, ZIP CRC and stored alignment PASS.
- Node syntax PASS; Chromium `page.set_content` 360/390/412 CSS+JS simulated grid select, preview select, rail, **controlled mock IndexedDB writer/readback** PASS, original native calls **0**. Real browser IndexedDB and actual MediaStore sources were not exercised by mock due runtime restrictions.
- **Physical Galaxy One Hand OFF/ON, QuickRecord repeated, original native Gallery initial mount and standalone picker image/video still UNVERIFIED**. R637 IS BETA, NOT Golden/FINAL. Distinguish byte-isolation proof from device result.

## R638 exact-R611 emergency
Original-signed code638 APK `MOA_R638_EXACT_R611_GOLDEN_FORWARD_RECOVERY_ORIGINAL_SIGNED.apk`, SHA256 **`6aaad8fb70fe0545810eba6c2dccbc1a454372872b31b7f6c18ad4926d53cbab`**, size 9,106,884 B; **143/144 original members exact** (only manifest version), 18/18 DEX exact. Emergency ONLY: photo-add new UI absent, future version>=639 if installed.

## User delivery
Bundle `MOA_R637_R638_R611_GOLDEN_SEPARATE_PICKER_FULL_RELEASE_20261116.zip` SHA256 `86b03a98e1d6fea77500b3f144d951b8536ce0839c3f00bb6c0e70b9ef81182f`.
Private Library folder:
`/모아_프로젝트_근거_20261103/R637_R638_R611_GOLDEN_SEPARATE_PICKER_20261116/`
contains both APKs and ZIP with editable isolated JS/CSS source, QA JSON, hashes and README. No signing private key, password, user photo/audio/session.

## Device protocol (only after in-place installing R637)
Do NOT uninstall, clear data/cookies, change signer, reset NAVER Accessibility, or alter unrelated AA AirPods runtime. Check in order:
1. First open photo day **native original 8 actions/filmstrip**.
2. QuickRecord two consecutive commits, same photo day native still alive.
3. Samsung One Hand Operation+ NAVER Access OFF→ON twice, original native still alive.
4. Central + opens **standalone** picker. Grid select, enlarged select, filmstrip inertia, add to existing diary and photo-day reopen.
5. Original image quality, video play/scrub are independent real-device checks; do not pretend static PASS.

If first three fail despite exact R611 core, collect `window.__moaR602GalleryDiagnostic?.()` and Android manifest/provider lifecycle logcat rather than changing more code blindly. R638 can be installed as a higher-version functionality rescue but loses photo add.
