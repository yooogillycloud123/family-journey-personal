# MOA R187 USER DEVICE GOLDEN — READ FIRST (2026-11-08)

**CURRENT: R187 USER-REPORTED SCOPED DEVICE PASS, GOLDEN FROZEN.** On 2026-11-08 after receiving R187, user said "오케이 작동확인 이제 골든에 추가". Do not relabel the previous static beta as untested. This is *not* proof of Samsung 120Hz parity, every video codec, or full cross-module regression.

## Authority / precedence
1. Per project instruction read the complete main file `yooogillycloud123/workexcel-devbridge/AA_AirPods_FINAL_READ_FIRST_v1.0_20261005.md` before any MOA work. AA AirPods audio project code is unrelated, do not change it.
2. Read this file, `MOA_READ_FIRST_NEW_CHAT_R187_20261108.md`, `MOA_RELEASE_LEDGER_CURRENT.md`, `MOA_WIP_CHECKPOINT_CURRENT.md`, and `MOA_R187_FIXED_RAIL_SHARP_NATIVE_LIVE_SEEK_HANDOFF_20261108.md`. Check newest relevant library artifacts and runtime before any source modification.
3. **Release authority is the EXACT signed R187 APK preserved in private Library, not partial source.**

## Immutable signed binary
- Package `com.juhyeon.familyjournea`; code **187**; **5,655,113 bytes**; SHA256 `4380ca0a421c3a12cfad0334e860e659112b116f6cc7099f8989475c646a97e9`.
- Original signer cert SHA256 `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`.
- Private Library `/모아_프로젝트_근거_20261103/MOA_R187_USER_DEVICE_GALLERY_FIXED_RAIL_NATIVE_SEEK_GOLDEN_DO_NOT_MODIFY.apk`.
- Immutable 128-entry per-member hash manifest `/모아_프로젝트_근거_20261103/MOA_R187_USER_DEVICE_GOLDEN_128_MEMBER_FREEZE_20261108.json`, plus .sha256.
- Frozen **source-only** branch `golden/moa-r187-20261108-user-device-fixed-rail-native-seek-pass-do-not-modify`, with Java in `experiments/moa-r175/MoaNativeGallery.java`. Source lineage `feature/moa-r187-fixed-rail-live-video-seek-20261108`. Do not edit either Golden APK or frozen branch.
- Exact R185 baseline SHA256 `14ccee98b35e858b80821cfa1093f568a7ac99cd92fe8d3c9cf8b2b28599098f`. In R187, **126/128** ZIP members remain identical; only `AndroidManifest.xml` and `classes6.dex` differ.
- Isolated Java+d8 CI `42442253775` SUCCESS, native DEX size **109,004B**, SHA256 `2679eb3fa200cd8d4b9603c1302f513d903fbb9f4f51d1814730fe0489c53d7d`. Original signer, APK-v2 digest/RSA, ZIP/DEX static checks PASS. Isolated build ≠ full clean Gradle build.

## Device-accepted functional baseline
- Earlier R177 real-device native same-screen photo/video and long-press XY panel move success. Earlier R179 photo EXIF, media volume controls, capture changes reported working. R185 user confirms actual video filmstrip to playback-time seeking succeeds. R187 user now reports latest app works.
- Native photo/video swipe remains in ONE gallery, photo/video image/surface canvas stable while toolbar/thumbnails show/hide on tap, controls overlay.
- Tap video thumbnail in mixed filmstrip to enter video-frame time rail; swipe/scrub to actual video playback time; play/pause, mute/unmute, Android MUSIC volume slider, still capture.
- R187 keeps 72dp thumbnail rail vertically pinned by constant 208dp overlay + flexible spacer; controls/volume row never shift rail baseline. Never upscale 72dp timeline frames over full-resolution video, use native TextureView/MediaPlayer and at-most-one in-flight coalesced seek. Preserve native zoom, EXIF orientation, 3-page glide, R177 long press scroll rail.
- Preserve all non-gallery diary/voice/M4A/STT, photos, metadata, GPS/map, monthly/date, calendar, IndexedDB, backups and existing app data. *Not all non-gallery items were independently re-tested in this turn.*

## Exact forward emergency and version policy
- **R190 = emergency-only R187 feature restore**, signed package code190, **5,655,113B**, SHA256 `fd68bd84d6674aa595fbebd379b9b02310279a40d231d7ecf4f7dd48a03cec85`. It differs from R187 only by Manifest versionCode **187→190**, so **127/128 ZIP entries identical**. Same signer and independent APK-v2/ZIP PASS. Private Library `/모아_프로젝트_근거_20261103/MOA_R190_EMERGENCY_R187_GOLDEN_FORWARD_ONLY.apk`. **DO NOT install as normal update**; device rollback unverified, use only if new R189 candidate regresses. If a future candidate has code >190, create a newer signed forward emergency.
- Historic R188 returns *R185*, not R187, and must not be used as R187 recovery. R177 scoped Golden and R163 basic Golden remain frozen; R179/R185 user success artifacts preserved.
- Next normal candidate code **189** or higher, in a **new feature branch**, minimal diff against immutable signed R187. Preserve original signer. Never uninstall, clear data, modify golden in-place, lose private keys, or publish family media/keys.

## Full new-chat protocol
Read `MOA_READ_FIRST_NEW_CHAT_R187_20261108.md` and private Library `MOA_NEW_CHAT_COPY_PASTE_PROMPT_R187_20261108.txt`. Inventory existing R187 signed APK/ZIP, R190 emergency, DEX, temp, _analysis_repair*, QA, GitHub CI before re-analysis. Verify exact diff, app signer, APK-v2 full content digest, ZIP 128-member SHA, DEX, update-in-place and rollback path. Release BETA until Galaxy tested; never claim real Samsung parity or REA method decompilation unless actually tested/used. Keep AA Android Auto/AirPods audio project unchanged.
