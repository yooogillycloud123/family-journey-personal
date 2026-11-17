# MOA R685 — Persistent Native Gallery >> ON/OFF (R683 user-physical Golden protected)

Date: 2026-11-17 (KST). **R685 signed BETA is NOT yet physically verified. R683 remains user-physical GOLDEN.**

## Non-negotiable Golden freeze
- User expressly confirmed that the installed signed **R683** passes all previously requested functions. [Exact R683 USER PHYSICAL GOLDEN LOCK](MOA_R683_USER_DEVICE_PHYSICAL_GOLDEN_LOCK_20261117.md) overrides earlier R680/R684 baselines.
- Immutable R683 package `com.juhyeon.familyjournea`, versionCode **683**, original-signer certificate SHA256 `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`, exact APK SHA256 `e20e446d5e02358e833fe223471735abc3fd042234b4efc53acc208118ee9e8b` (9,685,046 bytes).
- Independent immutable private Library backup folder: `/모아_프로젝트_근거_20261103/GOLDEN_R683_USER_PHYSICAL_20261117/` contains exact R683 APK, original source/QA ZIP and SHA256 seal. It is NOT R684, which is a different old-R680 functional recovery. Never overwrite or demote R683 Golden.

## New user-requested behavior
Existing native gallery fourth-bottom action `>>` is the original R463 fast, upper large-stage multi-item inertial swipe mode. The user wants ON to remain ON and OFF to remain OFF on PHOTO/DETAIL exit/re-entry and after app restart. Previous R463 source explicitly saved **no preference** and deliberately reset `fastSwipeEnabled=false` during overlay cleanup.

**R685 scoped repair** uses the SAME `SharedPreferences` (`moa_r685_gallery_fast_stage_v1`, key `enabled`) in both the original PHOTO/DETAIL `MoaR391SessionPersistProvider` deck (`classes17.dex`) and the PHOTO-ADD isolated original-gallery `MoaR675PickerGalleryDeck` (`classes19.dex`). On a successful explicit ON click, `commit(true)`; on OFF click, `commit(false)`; on a fresh attached Gallery bar, read and attach original `StageScrub` mode and toggle icon if preferred ON. A failed native stage attach never falsely marks the UI as ON. **Automatic Gallery close/host removal still destroys temporary overlay but does not write OFF.** Existing default if no preference remains OFF. Uses original `r203Present`/`r203ReleaseWithVelocity` physics in unchanged `classes6.dex`; no independent engine.

## Exact signed release
- **Install**: `MOA_R685_R683_GOLDEN_FAST_STAGE_PERSIST_ORIGINAL_SIGNED_BETA.apk`; package unchanged, `versionCode=685`, **9,686,154 bytes**, SHA256 **`2e5bfeb0fc407c290d74bcc5d8a737e533154bc9d16e7afb3e6966ac3012665a`**.
- **Higher exact-Golden-functional forward rescue**: `MOA_R686_EXACT_R683_GOLDEN_FUNCTIONAL_FORWARD_RECOVERY_ORIGINAL_SIGNED.apk`, `versionCode=686`, SHA256 **`4ca36ffd502e7320017328d7be87c54f4a579ce407335d65990e83e278c5d3dc`** (9,685,236 bytes). Its **160/161 R683 APK ZIP entry contents match EXACT**, except AndroidManifest.xml code 683→686; original private data cannot be restored if separately deleted.
- Full self-contained release archive `MOA_R685_R686_GOLDEN_SAFE_FAST_STAGE_PERSIST_SOURCE_QA_20261117.zip` SHA256 **`4750a0d4efd3f68c52ebf5321de221f896b629345d6125e0c7378aefcd918ea7`**, contains R683 original GOLDEN snapshot, candidate and recovery APKs, Java source, two exact diffs, QA, install README and SHA sums. No private signer/password, screenshot, GPS or user data.
- Source and Android CI: [isolated feature branch](https://github.com/yooogillycloud123/family-journey-personal/tree/feature/moa-r685-persist-fast-gallery-20261117/experiments/moa-r685); [CI Java8 source/dex comparison RUN 44048199863](https://github.com/yooogillycloud123/family-journey-personal/actions/runs/44048199863) SUCCESS; [CI Java17 picker baseline RUN 44047879303](https://github.com/yooogillycloud123/family-journey-personal/actions/runs/44047879303) SUCCESS.

## Golden-preservation proof
- Compared to the exact user-device-approved R683 APK, changed only `AndroidManifest.xml`, `classes17.dex` and `classes19.dex`. **158/161 original ZIP entry payloads are byte-identical**, including original PHOTO/DETAIL/Gallery/QuickRecord/Android host DEX 1–16 and 18, `classes6.dex` original native engine (SHA256 `cf93d66d08f1700b95949760093bd50689fa8b45e7cbe4a42b962b2afbb6f61b`), all JS/CSS/index, existing settings/version UI, Naver and media index logic.
- Original R463 native deck `classes17.dex` recompiled using exact original `javac --release 8` + D8 minAPI29 Android SDK35 produced **byte-for-byte identical to original R683**: SHA256 `2e41f108d2e20f604c6cebe3692157cd9d52ca4c87576df0cbf5b80b301b4492`. After ONLY preference patch, classes17 SHA256 `26bfacf3478c54a34fb37ebe19a9159a15e86e1d848cf33084636939985e3d25`.
- Original isolated photo-add `classes19.dex` compiled with original Java17+SDK35/D8 as R683 source equivalent: **306/306 original methods have identical instruction bytecode and register metadata**. The recompiled original DEX19 differs in debug-only metadata/offsets; this is not claimed full byte equality. After only preference code and bridge version tag R685, classes19 SHA256 `a6f4a95fbecf48f8595be79b1bdf9b937fe658229425539e8287a878724b6237`.
- Existing Java original source fully preserved except the two explicit pref handling inserts; photo-add picker provider only exposes `version()=R685-...` so existing Settings version label matches the Manifest. Original 4 native actions unchanged.
- Actual R685/R686 **APK v2 RSA signature and full signed contents digest independently reconstructed and VERIFIED**, original signing certificate exact, DEX SHA1/Adler32, ZIP CRC/4byte stored alignment, Manifest code/higher-version, recovery exact ZIP contents PASS. Official *final signed APK* Android SDK aapt/aapt2/apksigner parser not run in local environment; no new Android Manifest nodes or component names introduced. **Galaxy install/render and actual ON/OFF after app restart remain UNTESTED**. Do not call R685 FINAL/GOLDEN before user confirms.

## Install, test, and safe recovery (never uninstall)
1. Update-install R685 over R683 (same package/certificate; code 685 >683).
2. Settings version should show R685. PHOTO native Gallery set `>>` ON; exit/re-enter PHOTO, switch DETAIL and return, open PHOTO-ADD original gallery; ON state should survive. App force-stop/relaunch while ON should also stay ON.
3. Turn OFF, close/reopen, process restart; OFF must persist. Verify original 8-action native photo/video, lower rail gestures, video seek, QuickRecord, header geometry, Naver map/cookies, TODAY and system status bar remain as in Golden.
4. Any regression: install R686 **OVER the current app without uninstall, data clear, IndexedDB/cookies reset, credential changes**. R686 returns R683 functional APK payload, but is **not** the original R683 signed binary version. User smartphone physical PASS for R686 not yet established.
5. After optional R686 installation, all subsequent APKs must have **versionCode >=687**; same original signer and precise package. Future fixes must derive from R683 Golden and preserve R685 as one isolated experiment, not stack unknown large refactors.
6. Completely unrelated AA AirPods/Android Auto/daemon/audio untouched.

## New-chat rule
After `MOA_READ_FIRST_NEW_CHAT.md`, read **R683 user-physical Golden lock** and **this R685/R686 handoff**. Keep R683 immutable. Never claim R685 fixed on user phone before explicit user test. Preserve permanent Settings app version display requirement and current exact Android package/cert.
