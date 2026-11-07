> **POST-RELEASE 2026-11-07 GOLDEN STATUS CORRECTION:** Following the BETA handoff below, the user completed R163 physical-device testing and reported “일단 작동함”; **promote exact signed R163 SHA f789a3a5…68e1 to USER DEVICE BASIC-OPERATION GOLDEN**. Individual IME/STT/video features were not each separately tested in supplied evidence; prior statements below saying DEVICE PENDING reflect historical pre-user status only. See [new Golden lock](MOA_R163_USER_DEVICE_GOLDEN_LOCK_READ_FIRST_20261107.md) and private Library all-member SHA manifest. Do not edit frozen APK. 

# MOA R163 — capture IME, recording/playback state and video entry UI (2026-11-07)

## Current exact artifact
- **R163 SIGNED BETA**, package `com.juhyeon.familyjournea`, versionCode **163**, signed APK **5,540,517 bytes**, SHA256 `f789a3a579102bfb34a77da11be9b99b18b54906527c428603885bbd130e68e1`.
- Original signing certificate SHA256 `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15` verified by nested APK-v2 RSA and full content digest.
- **R161 exact baseline preserved**: SHA256 `daf119c7d9e98a5729c4b64e6d70c8b8071073018e9dc5c416db551fa24cf485`. 122/128 old APK files byte-identical. Only binary manifest versionCode, isolated `classes7.dex`, R133 photo/video viewer JS+CSS and R141 monthly video viewer JS+CSS changed. All original classes.dex–classes6.dex, R159 voice bridge, R161 capture/Diary sync HTML, diary DB, native camera, family calendar and user data paths unchanged.

## User evidence
- User videos `19341.mp4` (native-looking video player with translucent central play/pause & seek bar) and `19348.mp4` (R161 capture screen keyboard covering control footer and recording/playing feedback) examined. Preserve private footage; **do not upload user media to public GitHub**.
- User reports newly added R161 capture voice works but text arrives late. No independent duration accuracy benchmark provided.

## R163 changes
1. Capture memo root uses Android API30+ edge-to-edge `WindowInsets.Type.statusBars/navigationBars/ime` to pad the entire weighted native layout above keyboard, including ALL rows, rather than relying only on `SOFT_INPUT_ADJUST_RESIZE`.
2. Native MediaRecorder shows red STOP action + elapsed MM:SS timer; MediaPlayer shows PLAY/PAUSE and current/total position; pause/resume and completed state; preserve native M4A files and manual mic text entry.
3. Recorded-file SpeechRecognizer starts **after recording stops**, explicitly requests partial results and reports provisional text in the editable memo field while recognition proceeds; final result replaces provisional suffix without duplication; failure/timeout discard only unchanged provisional text, leave original M4A untouched. Source PCM was formerly paced at ~1x real-time; file stream now paced ~3x (pipe/provider backpressure), to reduce avoidable delay. Faster and accurate Galaxy behavior **PENDING hardware QA**; some recognizers ignore source-file descriptor.
4. R133 Diary mixed viewer and R141 monthly media viewer native PLAY ENTRY overlays restyled to Samsung-like centered translucent 74px circular play button, blur/press motion; **native `diaryPlayVideo` invocation and actual external/native video player controls unchanged** (do not claim scrubber or during-play UI changed).
5. No permissions added, no migrations, no extra helper app, no AirPods edits.

## Compilation, signing and release gates
- Original complete Android source tree in main lacks some legacy classes. Existing unrelated `dex` job FAILED, **isolated `r163_photo_memo` job SUCCEEDED** using R161 ABI stubs + Android SDK35 d8, then compiled native activity DEX SHA256 `edd6f1ed0c4aa7949c51b4d23bce316e0472474e25b2e027b8ed72b3d94f94a4`. Source SHA256 `ec70c368818b82f41d00b082fd1d8519496d862c49d2dfae4e46a8aa2d8e95dd`.
- Feature code: `feature/moa-r163-ime-controls-fast-stt-video-20261107`. Main runner build ID **42360961498**, artifact **13569801407**. Code-check and DEX method calls independently matched against original R161 native ABI; APK CRC/alignment, v2 cert RSA/signature/content digest PASS.
- Current Galaxy **R163 install / IME location / playback controls / transcription accuracy and latency / video transition** NOT YET DEVICE TESTED — R163 is **BETA, not Golden**.
- Library private APK `/에어팟안드로이드/MOA_R163_Install_Chat_20261107.apk`, backup ZIP, plus QA/source zip/handoff in `/모아_프로젝트_근거_20261103/`.
- ChatGPT Android download accessibility NOT PROVEN merely by Library upload. Do NOT claim user received before confirmation; do not email, do not uninstall or clear user data. Prior R161 original remains intact for comparison.

Next action: user device checks: capture keyboard open shows action footer, recording timer & playback pause/time; final transcription no duplicate and audio file preserved; video entry controls look natural. If only native/system video DURING playback is still desired, acknowledge that current code only changed MOA's in-app poster play controls and separately consider safe native player replacement requiring new user-approved scope.
