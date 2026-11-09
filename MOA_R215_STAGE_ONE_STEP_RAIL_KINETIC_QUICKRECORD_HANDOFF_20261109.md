# MOA R215 — photo stage one-step, lower rail kinetic inertia, native editable quick-record overlay (2026-11-09)

## Exact status
**SIGNED original-cert beta APK + matching ZIP created and verified. Real Galaxy R215 physical QA PENDING; R215 is NOT GOLDEN.** User private `19805.mp4`, `바로기록 버튼 조정.pdf`, and illustration `세련된 녹화 버튼 UI 스타일 모음.png` supplied expected behavior and design. Private family/video pixels, signatures and keys must not be publicly exposed.

## Freeze / lineage
- Parent R211 signed beta package `com.juhyeon.familyjournea` code211 SHA256 `ae9d7fb92730e0ff83d3b587d64453bcc5e3b5f4f0002d9ec01b8a66ce40f063`.
- User-approved immutable **R209 gallery scoped Golden** SHA256 `2491d7cb23f0980c41ec9d09a46a77dcc70d12a567a8b5de135b9e5061451321`, separately frozen; earlier R203 / R187 goldens remain.
- Exact R215 APK `MOA_R215_STAGE_SINGLE_RAIL_INERTIA_FLOATING_QUICKRECORD_BETA.apk` **5,745,891 bytes**, SHA256 **`153499d80499de9e1c66fe07312959910875d487800e80e6e18dbdaac776a271`**.
- VersionCode **215**, package **`com.juhyeon.familyjournea`**, signer cert SHA256 **`5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`** (same original signer).
- Private Library `/모아_프로젝트_근거_20261103/`: direct APK, paired `MOA_R215_APK_WITH_ZIP_BACKUP_20261109.zip` and `MOA_R215_RELEASE_QA_20261109.json`. ZIP contains exact same APK (SHA256 match, CRC passes), readme, QA, SHA manifest.
- ZIP member count **129**, parent existing 128: **124 unchanged**, modified Manifest, classes4.dex native camera service bridge, classes6.dex gallery stage, `assets/web/moa-r121-ui.js`, and new classes8.dex native overlay helper. **No change** to native voice/diary/map media storage DEX/content other than listed boundaries.
- DEX hashes: classes4 `67c13e67fdb5f060be77ef1bf52ca5cc0446e47dc03db45ffbffb934d3b05e9c`; classes6 `ff32c95429e98f581352151cd3b5077c50d617f3c48d3bfcc1b0857aea4d9bfe`; new classes8 `3d957dc1547ab58d9ba8aafa06296a0ee4082f95c26e26057bd3f6c62110775c`; settings `assets/web/moa-r121-ui.js` `6f6859045e1297e716d57123a7638f54973907ae84d912d4ebaa76fff097af8a`.
- Compiled gallery Java Android SDK35 CI **42541902967 SUCCESS**. Native quickrecord helper Android SDK35 CI **42543587064 SUCCESS**. Signed APK/static check record in private QA JSON. The local ZIP and APK were checked in an active container and the internal/direct APK hashes are identical. Not equivalent to actual Galaxy install pass.

## Gallery critical regression fixed
R203 accidentally installed a stage `SwipeHandler.ACTION_UP` velocity path that called multi-photo `r203ReleaseWithVelocity(starting, releaseVelocity, 0.88f)` on the **upper large photo/video**. R215 removes that stage-only path, retaining `settle(toward,...)` so every stage swipe changes at most one image and preserving pinch/zoom. The **bottom GalleryRail.ACTION_UP** continues `r203ReleaseWithVelocity(next,vx,1f)`, the existing OverScroller `r203Present`, and `updatePosition` so flinging the *bottom* filmstrip moves the upper image/video in sync through multiple entries. Never conflate one-stage step with restricting lower rail; precisely this source separation was demanded.

## Quick-record native overlay
- Kept original MediaStore camera capture observer, notification and `MoaMomentMemoActivity` record launch; only targeted native overlay delegation to new `MoaR215QuickOverlay` while retaining existing capture ID.
- New 2-button floating capsule: larger prominent red Record action; smaller semi-transparent X but adequate invisible hit space; original tap actions retained.
- Long press enters edit mode; drag moves entire capsule, lower-right handle resizes with synchronized scaled icons/padding/gaps, edit completion / close without accidental action; auto-hide paused while editing, restarted afterward.
- Persistent native settings, normalized orientation-aware position and size, existing previous side/bottom offset migration, minimum/maximum size and screen bounds, optional edge snapping, opacity, icon styles and text.
- UI settings `사진 및 데이터 > 바로기록 팝업`: style A–F and X styling, label toggle, scale/opacity, long-press move and resize switches, auto hide, position / size reset and preview.
- Base asset `moa-r121-ui.js` and helper Java native sources saved on `feature/moa-r213-stage-one-step-rail-inertia-quickrecord-20261109` in `experiments/moa-r215/`; R211 map native photo paths preserved.

## Device acceptance required before promotion
1. Upper big photo/video: fast and slow swipe EXACTLY one step each, even high-velocity flick, with stage still swiping normally. Bottom rail fast swipe can move across many thumbnails and corresponding upper image tracks / decelerates and stops at nearest photo. Test rapid alternating upper/lower.
2. Camera capture with native popup: Record launches original exact captured image memo; X closes and does not create a record; auto-dismiss is correct and no duplicate overlays.
3. Long-press edit: drag moves, grip resize proportional, no accidental record/close, orientation and app relaunch persistence, screen safe areas and min/max safe; auto-hide pauses editing and resumes.
4. Settings page actual changes affect next capture popup; all six style choices, text and X options, opacity/size, preview/reset; verify layout with system gesture navigation.
5. Map/Diary/Naver R211 behavior, original M4A voice, photos/videos, calendar, export/backup and data integrity.

**DO NOT uninstall, clear data, alter signing identity, send private media/key to public Github, edit AirPods/Android Auto routing or modify immutable R187/R203/R209 Golden.** Future releases ALWAYS have separately downloadable original APK plus ZIP containing byte-identical APK. If a test fails, collect actual screenshot and log and fix in next higher version; never silently call beta Golden.
