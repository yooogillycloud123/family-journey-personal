# MOA R357 additive signed beta + R359 exact-Golden recovery (2026-11-11 KST)

**Status: STATIC PASS / Samsung physical tests NOT YET DONE / NOT GOLDEN.**
Current device user-verified installed baseline remains **R355**. Never ask to reinstall R345 or old R349/R353.

## Deliverables created locally
- R357 install APK: `MOA_R357_R355_GOLDEN_ADDITIVE_BETA.apk`, package `com.juhyeon.familyjournea`, versionCode **357**, SHA256 `0e8d2b7b7eeaf304706d3c90a5a333f7c32d3832cffda8ab830e54f5a61ba550`.
- R359 emergency forward recovery APK: `MOA_R359_FORWARD_RESTORE_R355_GOLDEN.apk`, code **359**, SHA256 `d223b0d659000743869230b461b600ca02b4da7319fac7243cad2d13dca9dc41`. Golden functional members exactly R345/R355; only Manifest changes; **do not routine-install**, because it will block lower-code R357.
- Original signer cert SHA256 `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`; both APK v2 full signed content digest verified, ZIP CRC and all DEX checksums verified.
- Immutable R345 APK SHA256 `fe2aaaac15d39a610268ee3d10361652a95537e0ce8ec9cde86e98edf3f8ceb1`. Do not alter Golden.
- R357 source/QA/both APKs are in user-delivered `MOA_R357_R359_APK_SOURCE_QA_20261111.zip` (never include private signer). Native Java source in GitHub feature branch `feature/moa-r357-restored-safe-injection-20261111`, `experiments/moa-r357/src/MoaR357CaptureHookProvider.java`, compiled CI SUCCESS run `43038776330`, DEX17 SHA256 `510f6756ed2316bba3a21e5bb6d76c74ad4d51ee94c2c9be40af5549cabaf336`.
- User private Library new upload refused with `library_storage_limit_exceeded`; original Golden ZIP still preserved; do NOT delete any files without user consent.

## Exact diff
From R345 138 members to R357 141 members, exactly 5 member modifications/additions: `AndroidManifest.xml`, `assets/web/index.html`, `assets/web/moa-r357-home-quicknav.js`, `assets/web/moa-r357-native-favorites.js`, `classes17.dex`. Original 16 DEX and all protected R345 NAVER/Diary JS bytes identical. GitHub `tools/moa_r345_golden_regression_gate.py --mode safe-additive` PASS; R359 `--mode golden-restore` PASS. JS syntax and local mocked diary ACK→NAVER timing/dedup/GPS/list tests PASS.

## Functional scope & limits
R357 web: blank solid pink dot; quick calendar home; independent enabled/autoshrink ON/OFF; seconds, two tap collapse/restore logic, normal/collapsed sizes, opacity, drag/resize/lock/snap/reset, persistence. Adds compact Settings controls without modifying Golden Settings JS. Native: new ContentProvider observer decorates only original polished recorder Activity with title-right `장소 저장` and single optional list field; **does not recompile original DEX**; uses native saved draft extras; defaults taken from existing WebView local settings. New independent JS wraps original `__moaNativeSync` and starts proven R345 NAVER `saveFromDiaryGps` only after original IDB ACK and real photo/video GPS; no duplicate uncertain-submit retries; existing writer byte-identical. Note/M4A/diary not overwritten.

Physical tests OPEN: Galaxy install compatibility, exact native layout/Save, voice transcription/M4A, GPS and NAVER account readback old/new lists, floating dot interaction, original diary/galley, old NAVER visible/offscreen. **Never assert device PASS without user results.** If regression, install R359 over R357 without uninstall/data reset; R359 functions equal R355.

## Next session
Read MOA_WIP_CHECKPOINT_CURRENT and this file; retrieve the user's delivered signed APK + source QA ZIP and exact GitHub provider/CI, inspect previous `_analysis_repair*`/build products, continue from this state. No AirPods/Android Auto change, no R217 code and no R349/R353 writer.
