# MOA R499 + R501 signed beta — Diary tab reversion and photo gallery reuse, 2026-11-14

## User on-device evidence and exact priority
Screenshots `1794584406916.png`, `21349.png` and videos `21342.mp4` (17.7 sec), `21352.mp4` (49.6 sec) show central + -> original Diary tab intermittently returns to prior two-calendar chooser, oversized bordered month selector and verbose Today CTA, hidden/nonfindable month-scroll preference, web photo diary 5 inconsistent actions, big expandable media list labels, no kinetic thumbnail-to-photo synchronization, low quality previews and video web player trouble vs original R463 native gallery. Source inspection of R495 `start()` shows original Diary tab listener still calls original owner `open()` while our tabbar capture closed overlay and set `r475ExitUntilHidden`; it caused the old screen. Original `r472UpdatePager` called `renderRail` which always `replaceChildren()` on each index update, cancelling inertia. Photo stage used 1024px thumbnail and video attempted WebView `content://`, unlike working R463 native Gallery.

## Exact deliverables
- **R499** `MOA_R499_UNIFIED_PHOTO_DIARY_NATIVE_GALLERY_BRIDGE_BETA.apk`, versionCode 499, 9,008,655 bytes, SHA256 `4799b12d2933758e15ea4c5ed3b29e64d56dab6d3121deb0b16de602843c34ca`.
- **R501** emergency-only exact R463 functional restore `MOA_R501_EXACT_R463_GOLDEN_FORWARD_RECOVERY.apk`, versionCode 501, 8,978,144 bytes, SHA256 `06519b7af4cfbea7eecb190aadc22cf47f29e94db200a0564fb89d80441b0dc7`.
- Combined delivery `MOA_R499_R501_SIGNED_APK_SOURCE_QA_20261114.zip`, 13,097,847 bytes, SHA256 `6f62986c7a0ffd7452b6df8e9b27bb8ca0c31de728388f590cfffbbec9728f57`.
- Original `com.juhyeon.familyjournea` certificate SHA256 `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`; original key/password NEVER stored in repository, release, output QA, or supplied ZIP.
- Private Library folder `/모아_프로젝트_근거_20261103/R499_R501_PHOTO_DIARY_20261114/`: signed APKs, combined ZIP, exact JS/CSS and Korean README.
- Source branch `feature/moa-r499-diary-tab-native-gallery-reuse-20261114`, files `experiments/moa-r483/moa-r483-vertical-calendar.js/.css`. R495 original branch/artifacts frozen.

## Changes vs R495
1. Intercepts bottom original Diary tab at parent capture stage, blocks legacy button's original `open()`, opens singleton `MoaR469SimpleDiary` calendar instead. Routes both if original Diary was already open and if freshly opening. Preserves old detailed editor and existing databases.
2. `달력 이동 방식` entry moved from nested often-hidden `사진 및 데이터` accordion into actual top-level Settings list directly after photo section. Existing stored flow/page preference unchanged.
3. Borderless month picker with subtle underline; bottom Today label shortened to `오늘`, compact button. Original month navigation remains.
4. Photo view old 5 text-symbol controls -> visually consistent four SVG controls: share, GPS, original capture info, fast mode. Cover action retained via long press/contextmenu on thumbnail; no DB migration.
5. Rail toggle no visible Korean caption; rail DOM stable, native horizontal momentum not destroyed by per-frame list recreation. Center-thumb detection selects matching main photo and vice versa; test with 14 mocked photos selected index8 at scrollLeft320.
6. Large photo bridge size request `2048` vs `1024`, only selected +/-1 loaded first, preserve loaded full-size image vs later 260 thumbnail race. **Actual resulting resolution is native implementation-dependent**; cannot claim original-file quality without device proof.
7. Video play actions in photo viewer call original native `NativeHost.post('diaryPlayVideo', {id})`; original native gallery controls seek/mute/volume/capture/kinetic browse when opened. Inline WebView content URI remains fallback; **do NOT claim that entire native Gallery has been embedded inside photo diary**. Full feature parity within same card remains outstanding, requiring native integration and device testing. Static video call mocked PASS.

## Verifications / hard boundaries
- Original same-signer APK v2 RSA signed content verified independently, original cert, full APK digest and ZIP/alignment PASS for both files.
- R499 changes exactly 3 R495 members: `AndroidManifest.xml` version 495→499 and additive calendar JS/CSS; all original 17 DEX bytes identical. R501 differs from R497 only Manifest version 497→501; exact R463 functionality restored.
- Synthetic Chromium 420x870, four palettes: month/day/picker, page wheel, native Back callback PASS. Additional direct `+ -> 일기` regression PASS, Settings visible at root, 4 SVGs, 14-thumbnail rail inertia selection and 2048 request PASS, native video command PASS, no JS errors.
- **Real Galaxy R499 device installation, 14,000 real photos, actual video route, thumb quality, Nav/NAVER/diary records and physical bottom-tab routing NOT TESTED**. R499 is a Beta. No user GOLDEN promotion.
- **User's original GOLDEN remains R463** SHA256 `9d2fd10d32a3bc35eb3132333e96edd8f565abd5daf3ce954b052f77083d8379`, frozen branch `golden/moa-r463-user-approved-20261113`. No uninstall, clearing data/cookies, photos migration or changes to AA AirPods.
- R501 recovery only if serious regression; if installed next candidate **versionCode>501**. Android ChatGPT link accessibility remains USER_UNCONFIRMED given prior `Library file not found` errors.

## Next mandatory engineering
1. Test physical `+ -> 일기` path and Settings > 달력 이동 방식 on R499.
2. Test native Gallery video command is accessible from photo view and returns without stale WebView root.
3. If user insists on fully functional native viewer embedded directly *inside* photo diary, this build does NOT implement it; inspect `MoaNativeGallery` native APIs and design supported dedicated native FrameLayout bridge. Do not substitute an unsupported WebView `content://` trick or assert success.
4. Preserve proven R463 native Gallery, R345 NAVER offscreen writer/login, original 17 DEX and exact R463 functional recovery.

Read `MOA_READ_FIRST_NEW_CHAT.md`, `MOA_R463_GOLDEN_LOCK_READ_FIRST_20261113.md`, `MOA_WIP_CHECKPOINT_CURRENT.md`, this handoff and exact source/release ZIP before next modification.
