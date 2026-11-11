# CRITICAL: R349/R353 regression confirmed, R355 exact R345 functional rollback (2026-11-11 KST)

## User physical failure, top priority
User's uploaded screenshots `20490.png`, `20470.png` and videos `20488.mp4` (~115s), `20487.mp4` (~5.6s) show:
- R353's **Android-native 모아 · 순간 기록** layout reverted to old plain UI; prior polished version, working voice/recording controls and form layout changed without authorization. User had explicitly insisted **no old features regress**.
- **Both ordinary Diary and Quick Record NAVER offscreen saves fail** on R353. The earlier user-confirmed R345 Golden saved to existing list, NEW private list and offscreen while using other UI.
- Do NOT attribute failure solely to missing EXIF GPS, session expiration or the user's actions: direct source diff shows two self-inflicted regressions.

## Exact binary forensics (real APK read, NOT inference)
Original R345 code345 `MOA_R345_EXACT_ADDRESS_HEADER_STAR_CLICK_REPAIR_BETA.apk` SHA256 `fe2aaaac15d39a610268ee3d10361652a95537e0ce8ec9cde86e98edf3f8ceb1`, ZIP 138 members/16 DEX, original signer cert SHA256 `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`.
- R349 code349 `MOA_R349_R345_GOLDEN_HOME_QUICKFAVORITES_BETA.apk` SHA256 `ba9ecf86b41841ddd31b3a2ff6c21aa16da4635763e4d17f109b85dadf2ecbb8`: R345 `assets/web/fj-naver-favorites.js` changed (as well as `family-diary.js`, `index.html`, 2 new JS files). Exact root: in `tryR289Offscreen()`, R345 did `if(!probe?.running) {naverWebProbeControl('visible'); return WEB_LOGIN_REQUIRED;}`. R349 replaces this with **`WEB_SESSION_NOT_READY` and no native control call** for OFFSCREEN; it disables previously working lazy startup when the WebView isn't already running. R353 inherits this altered writer BYTE-IDENTICALLY from R349. `displayMode` and route logic also changed.
- R353 code353 `MOA_R353_NATIVE_QUICK_RECORD_FAVORITES_MINIMIZE_BETA.apk` SHA256 `2cfc40742c19e6ae7c2ae7bfe7dd52dc8a2a3c70fac2d90cc4c4a1afd747ac6e`: **`classes7.dex` changed** from original R345 SHA256 `a751a6c2d80e77e6a60de8aaf948524519443bbf2f80142f98d30d978eb2f2e7` to R353 SHA256 `f55721e55eced9fa8f6cd80a569c66ed7194b1dfc186eafd4a50874e3a82f373`, replacing user's modern native recorder with compilation of older `MoaMomentMemoRecorderActivity.java` based on R217 sources. Although 34 class *names* were preserved, **UI behavior was not**. Original voice UI now differs. R353 also altered `family-diary.js`, native bridge companion and home float icon. Previous claim that class-name preservation equals functional preservation was false.
- R353's offscreen source: `assets/web/fj-naver-favorites.js` exactly same altered checksum as R349, NOT R345. As a result, ordinary Diary favorites fail too, not only Quick Record. This isolates the top-level regression from a Quick Record-only bug.

## SAFE IMMEDIATE USER ACTION
Update-install **R355 forward restore of original R345**. `MOA_R355_FORWARD_RECOVER_EXACT_R345_GOLDEN.apk` SHA256 **`e499ed03b59b1efc9ff85aa8bbaf442d214ddea3f6812d871c93bf584802be6a`**, versionCode355 >353, package same, original signer. Direct ZIP comparison: **138 identical paths and 137 identical uncompressed bytes; ONLY `AndroidManifest.xml` versionCode differs.** All 16 original DEXs, `family-diary.js`, NAVER favorites JS, frame agent, original settings and native recorder binary are BYTE-IDENTICAL to user-confirmed R345. Original APK v2 signature and digest verified at original build; APK physical Galaxy install of R355 still not independently verified. Do **NOT** uninstall MOA or clear data; update-in-place to preserve current diary/photos/voice and settings. R355 intentionally removes R349/R353 unfinished features (including the new checkbox/minimize float) to restore the working Golden behavior. Android standard downgrade R353→R345 would be blocked; this is why R355 uses a higher code.

## Regression gate installed
Offline script `R345_REGRESSION_GATE.py` computes exact golden SHA and compares all 16 DEX, `assets/web/fj-naver-favorites.js`, `moa-r231-naver-frame-probe.js`, `family-diary.js`, `moa-r231-settings.js`. `--mode safe-additive` rejects any modification to these protected files without a documented explicit upgrade plan; `--mode golden-restore` rejects any file differing from R345 except manifest.
Actual test:
- R349: **FAIL expected**, changed `family-diary.js`, `fj-naver-favorites.js`.
- R353: **FAIL expected**, changed `family-diary.js`, `fj-naver-favorites.js`, `classes7.dex`.
- R355: **PASS**, none of the protected original functional members changed; in golden-restore mode only manifest differs.
This is **static regression protection**, not Samsung installation or server-write evidence.

## What must happen BEFORE attempting the checkbox again
1. User confirms R355 original native Quick Record and actual NAVER Diary/offscreen behavior restored. Don't ask to reproduce earlier R345 success indefinitely.
2. **No more compiling R217/R225 old native Activity into R345**. First recover exact R345 modern native recorder implementation by Dex decompilation / exact source recovery. Do not substitute older source or assert class-count preservation implies UI preservation.
3. Build a **fork of byte-identical R345**, versionCode >355; maintain `fj-naver-favorites.js` and original WebView lifecycle unless deliberately patched with a tested native *hidden-start* solution and positive Samsung device proof. Never introduce `if(!running) return WEB_SESSION_NOT_READY` as default.
4. Add only a compact `장소 저장` checkbox + one optional list-name field next to the ORIGINAL native screen heading, and keep voice/STT/recording/list buttons unchanged. Need a native draft → diary IDB commit → R345 engine bridge with explicit single-write idempotency, and no injected Diary-card editor.
5. Require Golden regression gate for every candidate. Any intentionally changed protected member must have exact user-approved scope, byte diff, robust test proof and a forward exact R345 restore alongside it.
6. Do not change R345 Golden original APK or frozen source branch. Keep Gallery, M4A, metadata, Diary, return overlay, app settings and AA daemon intact. No unverified final claims.

## Artifact provenance
- All four APKs are accessible in the exact current conversation sandbox. R355 also inside `MOA_R353_APK_R355_EXACT_GOLDEN_RECOVERY_SOURCE_QA_20261111.zip` from earlier session.
- Private original Golden distribution was already saved in Library `/모아_프로젝트_근거_20261103/R345_20261111/MOA_R345_APK_R347_RECOVERY_TESTS_20261111.zip`.
- User-facing R355 link can be supplied once the exact file is verified on disk in the session. No need to request user's APK again.
- **NO R357 or future "complete" candidate was built in this incident**. The actual immediate deliverable is the already signed, byte-matched R355 original functional restoration.
