# MOA R155 — Recorded voice playback status, names and text notes (2026-11-07)

## User-confirmed base: R153 fixed signer INSTALL + recorder PASS

- Actual Galaxy screenshot `19270.png` and uploaded video `19272.mp4` (26.87s) show the corrected R153 APK installed with original voice-note modal; 3-second M4A file saved at 09:52:42 and older 08:44:17 recording still listed, sound plays when tapping Listen. The photo/Diary data and both recording entries remain on device.
- Fixed signed R153 source APK SHA256 `9356895559d50535f2c0302028d992a4ab5257414a360010dfd97679abc066ff` versionCode 153 package `com.juhyeon.familyjournea`. **This is current installed working baseline for the voice feature; preserve unchanged.**
- User requests playback visual feedback; customizable per-recording name; transcript text visible with playback. Explicitly asks to prevent any future custom APK v2 encoding mistake or repeated ADB recovery.

## R155 signed BETA, INSTALL NOT YET TESTED

- `MOA_R155_VOICE_PLAYBACK_TITLES_TEXT_BETA.apk` / current-chat `MOA_R155_Install_Chat.apk`, versionCode **155**, **5,490,848 bytes**, SHA256 **`fc3055f71fd5daf66ffc7eb1555da9ec69182c27c1e7919786475caf61f5980c`**.
- Same original certificate SHA256 `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`, package unchanged, supports R153 in-place update.
- R153 127 members → R155 127, **124 byte-identical**. Exactly 3 changes: `AndroidManifest.xml` typed code153→155, `assets/web/moa-r149-voice.js` (UI only), `assets/web/moa-r141-monthly-report.js` (existing R151 voice timeline button forwards to same playback state and reads title). **All six DEX, original native voice recorder and SpeechRecognizer, Diary DB, Quick Record, Gallery, Map, calendar, media are byte-identical.** No new permissions or data migration.
- Playback button now shows `◉ 재생 중 · 00:05` (elapsed wall time, not exact seek/progress); responds to existing native `play_started`, `play_finished`, `play_error` events. State resets after completion. On photo timeline same shared status shows when playback is invoked.
- Native recording filenames unchanged. Each date + filename gets optional `title` (<=120 chars) and `transcript` (<=50,000 chars), stored independently in localStorage `moa.voice.notes.v1`; old recordings display default date/time until renamed. `글 내용 보기/추가` and `이름·글 편집` allow manual save/view. When playback is started on a record with saved text, its text opens automatically. TextContent is used instead of innerHTML (no transcript HTML injection).
- **Automatic M4A transcription NOT implemented.** Existing SpeechRecognizer is microphone-input STT, not verified recorded-file transcriber. Android API33 EXTRA_AUDIO_SOURCE can optionally accept file descriptors but recognizer support varies, raw PCM conversion and device verification required. Do not label manually edited text as automatic transcript or fabricate content. Future separate gate, protect R153 recorder.
- Current R153 diary JSON backup does NOT include raw M4A, localStorage timeline mapping, titles, or transcripts; preserve original app data, do not uninstall/clear. Back up metadata and recording binaries in an opt-in future release before ever promising migration/export. R155 metadata alone persists across in-place app updates on same WebView origin.

## Verification gates (static/mock only)

- Repaired R153 and R155 use correct TWO length prefixes in APK Sig Scheme v2 signer-list; original malformed R153 fails the new public keyless guard. Independent `moa_apk_v2_signer_guard.py` runs full RSA signature, certificate/key equivalence, 1MiB-chunk APK signed-content SHA256 digest, correct alg `0x0103`, exact ZIP CRC and STORED 4-byte alignment, PASS. See `MOA_R155_INDEPENDENT_APKSIG_VERIFY.json`. This is additional to old flawed guard and cannot prove actual device installation.
- 393×852 isolated Chromium DOM mock: legacy two M4A files, play-state start/elapsed/end, save/rename title, manual text persists across modal close/open, saved text auto opens when playback starts, no JS exceptions, PASS. Mock localStorage/native audio bridge; **actual Galaxy recording/playing under R155 PENDING**.
- Original `R153` fixed APK is preserved, plus `R156` emergency rollback-forward from exact R153 with only typed code153→156, SHA256 **`221307481ebd73d8c99ea380035ed0c1b7d506f68483ee44d326b28a71813bc0`**, **not routine install**.
- User may update using R155 APK in-chat. No removal of installed app, no emails, no external upload, no AirPods modifications.

## Required live-device checks

1. Upgrade **in place** to R155, confirm old original Diary STT and Android M4A recording both still work.
2. Open original voice list and play old file: label changes to 재생 중 and elapsed counter, resets when audio ends; photo time-slot play also updates status.
3. Assign a clear name to one old file, add optional text note, close/reopen modal, verify name/text remain and saved text appears with playback; ensure other recordings remain unchanged.
4. Do **NOT** claim automatic transcript or seek/stop button. Actual Galaxy installation and UI status remains DEVICE PENDING.

## Future priority (not included)

A true automatic recorded-M4A-to-text pipeline requiring on-device recognized-file injection with PCM decode and verified speech service support, or an opt-in network transcription backend with explicit consent, privacy controls and backup. Do not upload family audio without user permission. Music integration remains OUT OF SCOPE.