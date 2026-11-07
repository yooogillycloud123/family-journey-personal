# MOA R165 — Non-destructive MediaStore voice copy BETA (2026-11-07)

## Goldens and intended behavior
- **R163 remains CURRENT USER DEVICE GOLDEN**, exact SHA256 `f789a3a579102bfb34a77da11be9b99b18b54906527c428603885bbd130e68e1`, code163; private Library frozen signed APK/manifest. **Do not overwrite R163 or promote R165 without physical QA.**
- R165 is a safety-first candidate for preserving voice recordings across app uninstall. It is NOT full migration to public primary storage, NOT complete diary-text backup, and NOT storage reduction.
- Existing R163 playback, M4A creation, post-recording transcript, photo→Diary connection, keyboard and video behavior must be preserved; all original classes.dex–classes6.dex and HTML/JS/CSS remain exact. New copy logic only in isolated classes7.dex. No app-data deletion.

## Exact signed artifact and static proof
- **R165 signed BETA** `com.juhyeon.familyjournea`, code165, **5,551,221 bytes**, SHA256 `989c50d3b06fb91a853c84a64f23e427d58afb8255a6b3449a843682456547e5`.
- Original R163 signing certificate SHA256 `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`; independently reverified the R165 APK v2 signer-list, RSA signature, signed APK digest, ZIP CRC and stored-item alignment on 2026-11-07.
- 128 entries in both APKs, exactly **126 byte-identical ZIP payloads**; changed only `AndroidManifest.xml` (code) and `classes7.dex` (new copy/UI).
- New `classes7.dex` SHA256 `481d4f52425784019884f1b775a68befcdb7e93adc9a63e1324dfca534718be1`; source branch `feature/moa-r165-media-audio-safe-export-20261107`. Isolated Android Java/DEX compile PASS. Unrelated full legacy Gradle compilation is not a complete build reference.
- Signed APK frozen in private Library `/모아_프로젝트_근거_20261103/MOA_R165_EXTERNAL_AUDIO_SAFE_COPY_BETA_INSTALL_20261107.apk`; QA report, handoff, no-key QA ZIP, backup ZIP also stored. Current-turn exact-byte redistributed chat APK and ZIP separately.

## What R165 does
1. Original new Quick Record M4A remains saved privately under `getFilesDir()/moa-original-audio/YYYY-MM-DD`. This preserves all R163 file-based STT, list and playback paths.
2. AFTER recording's speech-recognition task is finished/error/timed out, an isolated background copy writes a duplicate to Android `MediaStore.Audio` under **`Recordings/MOA/YYYY-MM-DD/MOA_YYYY-MM-DD_<originalfilename>.m4a`**, readback SHA256 verified before `IS_PENDING=0` makes it visible.
3. In the native `바로 기록` screen, a manual **기존 녹음 원본 모두 외부 폴더에 보관하기** action, with confirmation, scans all date folders. This covers both previous Quick Record and Diary M4A. Matching copies are identified by date/name/size/SHA256 to avoid avoidable repeats. The private file is NEVER deleted.
4. The audio backup can be visible to other media/file apps because it lives in shared storage; inform user of privacy implications. On Android 12+ Recordings is a valid MediaStore audio path.

## Unfinished; DO NOT overclaim
- **R165 Galaxy install, MediaStore write/visibility, background timing, STT and legacy playback are DEVICE PENDING.** This is statically verified candidate only, not a new Golden.
- **Storage capacity DOES NOT SHRINK.** Keeping the app-private source and adding public copy initially INCREASES total phone storage. No automatic cleanup is authorized until an independently verified external-primary switch and a verified restore/re-link flow.
- Uninstall clears private M4As, voice labels and Diary metadata. Shared audio backup can remain, **but R165 does not automatically re-link on reinstall**; future SAF/READ_MEDIA_AUDIO import and full metadata backup are needed. User must **NOT uninstall/clear app data** on the assumption that R165 is a complete restore solution.
- New Diary tab audio (different native host) is NOT automatically copied on each save; manually exporting all from Quick Record screen includes them.
- Do not mistake MediaStore SHA verification of the physical copy for verified complete photos/Diary/notes backup. Do not publish private signing key, family audio or real personal media to GitHub; no Gmail/email.

## Required R165 Galaxy QA before release promotion
- In-place install on R163 (no uninstall) and verify version still same package.
- Quick Record voice and its auto-transcript, button above Samsung keyboard, recording time and playback controls behave as R163.
- My Files > Recordings > MOA > YYYY-MM-DD shows the new copied M4A; original M4A and memo preserved; audio plays inside app.
- Press manual old-recordings export; confirm count/error and files, redo export without unexpected duplication.
- Verify failed external write does not erase original, old Diary voice/voice text, video/map/photos/calendar function.
- Only after physical device acceptance should exact R165 SHA be recorded as user-approved Golden. Until then **R163 remains frozen Golden**.

See [R163 Golden Lock](MOA_R163_USER_DEVICE_GOLDEN_LOCK_READ_FIRST_20261107.md), [current release registry](MOA_RELEASE_LEDGER_CURRENT.md), and private archived build handoff. Separate alternative unshipped SAF backup source is **not** an R165 APK and must not be confused with this signed beta.
