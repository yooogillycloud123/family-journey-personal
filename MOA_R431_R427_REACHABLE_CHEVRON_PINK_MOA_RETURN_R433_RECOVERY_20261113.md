# MOA R431 — NAVER WebView tiny menu touch fix + floating pink MOA return (2026-11-13)

## User physical evidence / issue
- User's private Galaxy screen recording `20861.mp4` (9.9168s, 1080×2340 at 120fps) shows manually opened NAVER PC WebView and repeated taps around the R427 collapsed menu upper-right/search-bar region without a reliable expand/return.
- Earlier user-provided screenshot `20859.png` and follow-up: Can the same pink MOA home floating action be available in the NAVER browser?
- The existing R427 native `MoaR391SessionPersistProvider.compactNaverChrome` inserts a **28×30dp transparent chevron directly in upper-right** of the original controller `shell`. It overlaps the NAVER search/voice-control region and, when expanded, sits over the original native `종료` button area; touch conflicts are supported by source geometry. Actual Android intercepted view is not independently traced.
- This is an accessibility/interaction refinement only; preserve R423/R427 WebView/account-save and high-fidelity native gallery.

## R431 fix
- Base **exact original-signed R427** SHA256 `cae807166acb206bc3c1757cac919ba5987747864448af671cb4ffba70a54527`, package `com.juhyeon.familyjournea`.
- GitHub source branch `feature/moa-r431-reachable-chevron-pink-return-20261113`, `experiments/moa-r391/MoaR391SessionPersistProvider.java`.
- Move the original native-UI chevron from `Gravity.TOP|END` to **`Gravity.CENTER_VERTICAL|END`** with right margin 2dp and 48×54dp transparent hit area, 15sp visual glyph `›`/ `‹`. Keep it detached from the original 64dp native header so original '모아로'/'종료' controls can receive tap input when expanded. Original old header + state are still `GONE` until expanded.
- Add 44×44dp translucent pink native circular `⌂` near lower-right (12dp horizontal inset / 92dp lower inset) styled from existing `moa-r389-home-dot.js` colors (`#cf739f`, `#e8b3ca`) and with full Android accessibility description **`모아로 돌아가기`**. The button calls the **exact original** `MoaNaverWebProbeController.setHidden(Activity,true)` through existing `hide()` method; it **does not call dispose**, never logs out or clears cookies, never invokes NAVER account write. The underlying MOA screen reappears and the same hidden WebView remains for subsequent offscreen saving. This is not a second JS injection into NAVER and is not a second APK.
- These two views remain children of the controller `shell`, so when original controller is hidden to 1px via `setHidden()`, the controls clip away without touching the underlying MOA diary/gallery.
- No changes to original R427 16 DEX, account-write JS, login UA, Diary, Gallery/native video, 460ms warmup, session keepalive, transparent title-collapse UI, or R423 dynamic startup theme.

## Source/CI
- GitHub Android35 javac/D8 CI **[43325509794](https://github.com/yooogillycloud123/family-journey-personal/actions/runs/43325509794)** SUCCESS after correcting the Java integer-dp layout parameter conversion.
- New `classes17.dex`: 37,472 bytes, SHA256 **`3d619239666373a58d57dbb4625a9dcc4946cf59252cb0166db64f09b2f40b7d`**.
- **R431 APK** `MOA_R431_REACHABLE_NAVER_MENU_PINK_HOME_SIGNED_BETA.apk`, versionCode **431**, SHA256 **`bd1a8df98dcb7ad933da85813c1cabf8ba3de6594c2c88c3eb88bf338e02f852`**. Original cert fingerprint SHA256 `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`. 140 original ZIP paths; **138/140 original R427 member payloads byte-identical**. Only `AndroidManifest.xml` versionCode and `classes17.dex` modified. All 16 original DEX including full Gallery and native Naver controller untouched, as are `assets/web/fj-naver-favorites.js`, original pink JS home, and HTML/other assets.
- **R433 recovery APK** `MOA_R433_EXACT_R423_FUNCTIONAL_RECOVERY.apk`, versionCode **433**, SHA256 **`2f419234be387c8473250710a9b12d6dfdaa4f38702874d0701ab81f79a035d5`**. This is a **forward version restore of original functional R423 (NOT R427)**, i.e. original R423 **139/140 uncompressed payloads byte-identical**, only Manifest code changed. It restores the older visible native NAVER titlebar and normal buttons, but also preserves R415 gallery repair, R419 stable UI, R423 theme icon and original account writer. **Use ONLY if R431 causes serious regression**. If R433 installed, next patch versionCode >433.
- Both APKs independent APK Signature Scheme v2 RSA verification **and full signed-content SHA256 digest PASS**, ZIP CRC, all 17 DEX SHA1+Adler32, original ZIP alignment PASS. No package data deletion or reinstall, no new permissions. All checks are **STATIC**, not Galaxy physical acceptance.
- Complete ZIP `MOA_R431_REACHABLE_CONTROLS_R433_R423_RECOVERY_QA.zip`: SHA256 `144474e1dc9d635452f4e38d65638e14935f8a29bbaff8d13c23a5ac334f5096`, signed APK pair/source-only/diff/README/QA, no keys, passwords or private video.
- All APKs, QA and original private user video in PRIVATE Library `/모아_프로젝트_근거_20261103/R431_REACHABLE_NAVER_CONTROLS_20261113/`. GitHub source and report only; do not upload raw video, photos, cookies, signing secrets.

## Device test, status, and regressions
- R427 real user issue: upper-right tiny chevron could not be tapped reliably; not Golden.
- R431 on physical Galaxy: **NOT YET VERIFIED**. Check manual NAVER PC map open: (1) tap right-center 48×54dp transparent chevron to expand; (2) test original '모아로'/'종료' buttons; (3) fold via `‹`; (4) tap pink bottom-right `⌂`, return to MOA without killing WebView; (5) actual offscreen saved-list write; (6) advanced gallery; (7) cold app restart and original icon theme. Only mark success after these on-device.
- Avoid downgrade/uninstall/data clearing. R423 and R415 separately preserved. No AirPods/Android Auto modifications.
