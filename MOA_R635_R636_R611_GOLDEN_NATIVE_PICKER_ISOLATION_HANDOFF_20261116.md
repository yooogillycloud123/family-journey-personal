# MOA R635 / R636: R633 Physical FAIL, original R611 QuickRecord / NAVER Gallery isolation — 2026-11-16

## Mandatory first priority: user's actual Galaxy evidence
After R633 installation, user reports **both** Samsung One Hand Operation+ NAVER Accessibility OFF→ON and QuickRecord photo-day return fail to mount the ORIGINAL native Gallery. Screenshot `23017.png` shows the old Web gallery interface (large overlay play, ellipsis, six Web actions) rather than the physically-approved R611 native eight-action/filmstrip host. **R633 is DEVICE FAIL, never Golden.** R631 also failed QuickRecord. No usable device logcat identifies the single root-cause callback; do NOT assert the cause is fully proven.

## Exact source evidence
- R611 user physical Golden original signed APK SHA256 `38a507cf2e88a235282ae4d9ad64cf0799033f34ae8fe3e179a58960d1213ccd`, 18 DEX, certified signer SHA256 `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`.
- R631 added a **new always-tick native picker observer** `r631ObservePicker()`, evaluating WebView state around original gallery handoff and inserting button in activity root. R633 retained observer (with ownsGallery gate), moved glyph into original action capsule.
- R633 also added a **new second `moa:native-diary-committed` listener** that checked `isNativeGalleryOpen()` 850/2100/3900ms after QuickRecord and may call `__moaR547RebuildDamagedHost`. That routine calls `r507StopInline` and may close/rebuild a healthy or recovering gallery when a transient read is false. This is a code-confirmed dangerous path, NOT proven singular physical root cause.
- R611 QuickRecord photo JS `r507StartInline`, `r507StopInline`, `r592RefreshVisibleDay`, `r594Fallback` are exact source-function matches to R635. The photo story `r602RefreshMomentNotes` is intentionally visually updated (collapsed QuickRecord).

## R635 candidate engineering
- Rebuild native `classes18.dex` from the **exact frozen R611 original Java provider**, not R631/R633 derivative. R611 `r611RecheckAfterNaverAccess`, `r602PollPlaylist`, `actualMediaReady` Java function bodies compare exactly in CI.
- NO R631/R633 separate picker polling in healthy photo-day. Only the **already-running R611 ARM_SNAPSHOT** returns an optional `picker:true` field when the JS explicit `window.__moaR635PickerNativeActive` is true in PHOTO-ADD fullscreen native preview, and only then adds a 5th select/clear glyph to the existing original fullscreen capsule. Original native media engine/filmstrip/gestures/actions untouched.
- Remove R633's secondary `moa:native-diary-committed` autorearm observer entirely. Retain R611's original single same-day `r602PollPlaylist` and R611 Accessibility observer/rebind owner. Do not infer an Android gallery failure from a transient false state.
- R633 UI visuals/JS `family-diary.js`, `moa-r149-voice.js`, photo CSS are retained byte-for-byte; photo picker Set, selection, native video/photo and existing IndexedDB curated photoIds writer unchanged.

## Output and gates
- Original-signed same-package `MOA_R635_R611_GOLDEN_ISOLATED_PICKER_NO_QUICKRECORD_REARM_ORIGINAL_SIGNED_BETA.apk`, versionCode 635, **SHA256 `449b974acc9cc9cdf2c7874c6bf18935d19b430ac8ab7ff9df65e83854027520`**, 9,128,415 bytes.
- APK V2 cryptographic RSA signature and content digest original certificate PASS, ZIP CRC/stored alignment PASS. R633→R635 changed exactly **3 of 144 APK payload members**: Manifest, photo JS, classes18.dex. R611 native original core **17/17 DEX exact**. Actual JDK 17 Java/API35/D8 compiled CI [run 43823794059](https://github.com/yooogillycloud123/family-journey-personal/actions/runs/43823794059) SUCCESS with original R611 Java functions exact comparison.
- Chromium 360/390/412 UI mock PASS for photo pick, native-open dispatch, picker-session active flag true/false, selection/unselection and day return. **NO Galaxy physical PASS yet, not Golden.** Code-isolation pass cannot certify a real phone hardware behavior.
- Emergency exact R611-functionality, versionCode636 `MOA_R636_EXACT_R611_GOLDEN_FORWARD_RECOVERY_ORIGINAL_SIGNED.apk`, SHA `e65149103ae15925f27f30e3f778c8ee000ec473e111d9baea9550a61d4a26dc`, 143/144 members byte-identical to R611, 18/18 DEX identical. Removes post-R611 features; emergency-only. Future next version >636 if this is installed.
- Full non-secret APK/source/test archive `MOA_R635_R636_R611_GOLDEN_NATIVE_PICKER_ISOLATED_FULL_RELEASE_20261116.zip` SHA `1eb4cdba402d6c3f057c8f24d79bd7b53afe62a8b9588a2c9c64918d5a91f999`.
- Private Library `/모아_프로젝트_근거_20261103/R635_R636_R611_GOLDEN_NATIVE_PICKER_ISOLATION_20261116/`.
- Source Java in branch `feature/moa-r635-r611-immutable-native-picker-isolation-20261116/experiments/moa-r635/MoaR507InlineGalleryProvider.java`.

## Install and minimal physical gate
- Update-install R635 only over currently signed MOA R633; NEVER uninstall, clear MOA/NAVER data/cookies, rotate cert or restore older versionCode by downgrade.
- Test **original photo day first**, then QuickRecord 2x + same photo day original Gallery/filmstrip/8 actions; then One Hand NAVER accessibility OFF→ON twice + original native Gallery; then central photo-add and new bottom native select/clear, return grid and add chosen photos. Capture diagnostics if fallback.
- R636 only if critical regression, loses newer photo-add UI. Do not report browser QA as device success.
- Do not touch independent AA AirPods Android Auto daemon / audio project.

## Evidence preservation
Original immutable R611 Golden, all R631/R633 failed betas, compiled R635 ZIP, exact hashes and QA retained; no signer private key/password or personal media published.
