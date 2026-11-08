# MOA R177 USER-DEVICE LIMITED GOLDEN LOCK — 2026-11-08

## Verified by user on real Galaxy
User expressly confirms R177 **working in-app native photo/video gallery** and **long-press XY movement of top/bottom scroll-control rail**. Status is limited **USER_DEVICE_INSTALL_AND_BASIC_GALLERY_RAIL_PASS**, not complete Samsung Gallery equivalent and not global full-function Golden. Private R177 screen recording confirms in-screen native video controls and movement; media not uploaded.

### Exact immutable release
- `com.juhyeon.familyjournea` versionCode `177`; **5,640,225 bytes**; SHA-256 `c6b4b8d21742370b3e59758ffbe1a715e598a5d3911ab6c8af5050a6b2789b30`.
- Original signing certificate SHA-256 `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`. Previous static APK v2 content digest/ZIP/DEX guard PASS.
- Private Library locked binary: `/모아_프로젝트_근거_20261103/MOA_R177_USER_DEVICE_NATIVE_GALLERY_RAIL_GOLDEN_20261108_DO_NOT_MODIFY.apk` and exact 128-member freeze `MOA_R177_USER_GOLDEN_FREEZE_128_MEMBER_SHA_20261108.json`.
- Source-only protected branch `golden/moa-r177-20261108-user-device-native-gallery-rail-pass-do-not-modify`. Exact signed APK, not GitHub partial source, is release authority.
- Older independent **R163** user Golden SHA `f789a3a579102bfb34a77da11be9b99b18b54906527c428603885bbd130e68e1` still frozen; R63/R83/R89/R96/R115 historical anchors untouched. AirPods AA project untouched.

### Explicit remaining defects from user's 19464.mp4 (PRIVATE; not shared to GitHub)
1. Some still photos shown sideways: R175 `MoaNativeGallery.getBitmap(fullSize=true)` calls raw `BitmapFactory.decodeStream` and ignores EXIF orientation metadata. Orientation mismatch visible around ~33s. Need EXIF-aware image decode without rewriting original photo.
2. Unmute slider absent: `MediaPlayer.setVolume(1,1)` cannot audibly override Android system media volume at 0; introduce visible, user-controlled `AudioManager.STREAM_MUSIC` slider on unmute, **never auto-raise system volume**.
3. Native `장면 저장 실패: frame missing` captured in user's screen recording near ~13s: `MediaMetadataRetriever.getFrameAtTime` sometimes returns null; implement appropriate live `TextureView.getBitmap` fallback and careful source-preserving save.
4. More device-measured swipe smoothness/700 items testing required; no claim of 120Hz parity.

### Development safeguards
- DO NOT modify R177 Golden APK or frozen source branch.
- Next normal feature versionCode >=179 from exact R177 signed APK with original cert, small diff, independent native source compile, APK v2/DEX/ZIP guard and user acceptance gates.
- Reserve 178 as **R173-restore-only**, not R177; do not misleadingly call it a R177 equivalent rollback.
- In-place upgrade only. No app uninstall, data clear, signing change, private family media or signing-key publication, or unrelated AA modifications.
- Record all CI/build outcomes and failures append-only in `MOA_RELEASE_LEDGER_CURRENT.md` and `MOA_WIP_CHECKPOINT_CURRENT.md`.
