# MOA — NEXT CHAT READ FIRST / RESUME LATEST R187 GOLDEN (2026-11-08)

## Mandatory reading order (before answering, analysis, builds)
1. GitHub `yooogillycloud123/workexcel-devbridge` **main** `AA_AirPods_FINAL_READ_FIRST_v1.0_20261005.md` **start to finish**; obey top project rules but **never modify AirPods/Android Auto audio code when working on MOA**.
2. GitHub `yooogillycloud123/family-journey-personal` **main** `MOA_R187_USER_DEVICE_GOLDEN_LOCK_READ_FIRST_20261108.md` **entire file**.
3. MOA main `MOA_RELEASE_LEDGER_CURRENT.md`, `MOA_WIP_CHECKPOINT_CURRENT.md`, `MOA_R187_FIXED_RAIL_SHARP_NATIVE_LIVE_SEEK_HANDOFF_20261108.md` and older R177/R163 Golden instructions as needed.
4. User private Library `/모아_프로젝트_근거_20261103/` exact R187 Golden APK, 128-member manifest, R190 emergency, R185/R179/R177/R163 artifacts. Check remaining _analysis_repair*, APK, DEX, temp, QA, GitHub CI artifacts first. Don't start over.

## Actual latest status
- User **confirmed R187 on-device working** on Nov 8, 2026 and directed Golden freeze. **User-device scoped Golden** is exact signed R187 package `com.juhyeon.familyjournea`, code **187**, **5,655,113 bytes**, SHA256 `4380ca0a421c3a12cfad0334e860e659112b116f6cc7099f8989475c646a97e9`, signer `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`.
- Golden source branch: `golden/moa-r187-20261108-user-device-fixed-rail-native-seek-pass-do-not-modify` — **DO NOT EDIT**; source is trace only, signed APK in private Library is release authority.
- 128-member freeze `MOA_R187_USER_DEVICE_GOLDEN_128_MEMBER_FREEZE_20261108.json`; isolated native CI `42442253775` SUCCESS; DEX SHA `2679eb3fa200cd8d4b9603c1302f513d903fbb9f4f51d1814730fe0489c53d7d`.
- R187 from R185 signed APK 126/128 ZIP member payloads identical, changed only Manifest + `classes6.dex`.

## MUST KEEP WORKING
- Swipe photos/videos in same-screen native gallery, consistent photo/video full-stage size, tap toggles header/thumbnail chrome, seamless left/right media.
- Bottom media thumbnails **pinned to identical bottom y position** even during photo/video transitions, play/pause, mute/unmute, volume row, filmstrip mode. Video controls/volume overlay content instead of pushing rail.
- Tap a selected video thumbnail in mixed photo/video strip to open **that video's own scene-time filmstrip**; moving strip **seeks to actual video time**, one-flight coalescing, no tiny-frame blur over full video. One-tap return to mixed media.
- EXIF photo rotation, zoom/pinch, on-screen video playback/pause/mute, real Android music volume slider (unmute does not automatically increase volume), still-frame capture.
- User R177-proven long-press mobile top/bottom quick-scroll panel in free XY directions.
- Diary dates/month, family photos/videos and notes, voice/M4A/STT, GPS/map, IndexedDB, storage/backups and all other prior app features preserved without clearing data.

## Version and disaster recovery
- **R187 immutable Golden**. New normal code **189+** on new feature branch only. **R190 emergency** signed restore of R187 exact features, code190 and manifest-only change, SHA `fd68bd84d6674aa595fbebd379b9b02310279a40d231d7ecf4f7dd48a03cec85`, signer/ZIP/v2 PASS, **device recovery unverified; do not install routinely**. Code >190 needs newer forward recovery APK. R188 is old R185 restore only.
- **No uninstall, app data clear, signing replacement, old Golden overwrite, unauthorized publishing of family media or private keys**.

## Per-change workflow
Inventory latest APK/CI/temp first; use actual R187 signed APK as binary baseline. Small native change, Android javac+d8 CI, ZIP entry exact diff, signer+APK v2 content digest/DEX/CRC checks, installable APK plus ZIP fallback created at verified path, emergency forward-backup. Label new candidate **BETA** until user confirms device. Make no claims of Samsung 120Hz parity, universal HEVC/HDR smoothness, or REA/JADX inspection unless observed/actually executed. Do not make user repeat requirements already decided. Never modify AA Android Auto/AirPods audio project for MOA.
