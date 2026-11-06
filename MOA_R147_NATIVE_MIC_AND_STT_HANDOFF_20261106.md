# MOA R147 — original native STT + new date-stored recording in one signed APK

**Date:** 2026-11-06. **Status: SIGNED / native Android Java compiled through GitHub Actions / independent static APK PASS. Actual Galaxy install, existing speech-to-text and real microphone recording are NOT VERIFIED.** Do not call this Golden or successful audio fix until a real device test.

## User's exact goal and regression
- R145 was installed on user's Galaxy. Screenshot `19205.png`: new date-audio recording shows `Permission denied`; screenshot `19207.png`: original in-Diary `음성 입력` stops responding / `음성 준비 중...` while separate native `바로기록` speech memo works. This is R145 **DEVICE MIC FAIL + user-reported LEGACY DIARY STT FAIL**.
- User rejects R146's removing the new recorder as the final answer. Required BOTH: original Diary STT restored AND new original audio recording persisted by Diary date, in one same-package APK without deleting existing data.
- R146 was based on exact R143 and only contained legacy native STT; R146 physical STT recovery was not separately confirmed.

## Confirmed native cause and architecture
- Existing original `MoaMomentVoiceChrome.onPermissionRequest` in `classes4.dex` (code item 0xd744) calls the superclass `WebChromeClient.onPermissionRequest()` without granting `PermissionRequest.RESOURCE_AUDIO_CAPTURE`; thus the R145 WebView `getUserMedia()` request is not handled by an explicit native grant. User's real `Permission denied` is consistent with this mechanism. Root cause of original STT's simultaneous failure is not definitively established.
- Native original STT depends on `MoaMomentVoiceChrome.onJsPrompt` and `onProgressChanged` heartbeat, and original `MoaMomentVoiceBridge`/`MoaMomentVoice` SpeechRecognizer (R83/R89 Golden). **Never replace the custom Chrome with a default empty WebChromeClient.**
- Actual launcher aliases all target `MoaIconHost`, which is a class in original `classes5.dex` extending `MoaMomentVoiceHostActivity`. Simply rewriting a separate registered `MoaMomentVoiceHostActivity` name in the manifest would not affect those launcher aliases. To route ALL nine launcher icon aliases through the new class, preserve manifest activity and icon/alias configuration **exactly**, change only the ASCII MUTF8 type descriptor `MoaMomentVoiceHostActivity` to equal-length `MoaMomentAudioHostActivity` inside `classes5.dex`, recompute SHA1+Adler32. This changes `MoaIconHost`'s superclass to the new class while leaving its actual `android:name` alias targets intact. New `classes6.dex` defines `MoaMomentAudioHostActivity extends MoaMomentVoiceHostActivity`.
- New `SafeChrome` delegates `onJsPrompt`, `onProgressChanged`, `onConsoleMessage`, dialogs, native file chooser and activity custom-view callbacks to the original WebChromeClient, preserving original STT pathways. Its `onPermissionRequest` grants **only** AUDIO_CAPTURE with HTTPS trusted `familyjourney.local` origin matching the active WebView, with Android `RECORD_AUDIO` runtime permission. Video/other resources and foreign origins are denied. Pending mic permission requests are not granted after pause/destroy. Voice input isn't automatically started; recording must be explicitly tapped.
- New Android Java source compiled with real Android 35 `android.jar` and D8 by GitHub Actions workflow, NOT a handwritten fabricated DEX. Exact class source: [`android/app/src/main/java/com/juhyeon/familyjourney/MoaMomentAudioHostActivity.java`](https://github.com/yooogillycloud123/family-journey-personal/blob/main/android/app/src/main/java/com/juhyeon/familyjourney/MoaMomentAudioHostActivity.java). Workflow: [`.github/workflows/moa-r147-audio-dex.yml`](https://github.com/yooogillycloud123/family-journey-personal/blob/main/.github/workflows/moa-r147-audio-dex.yml). Compilation GitHub Actions run id `42223723269`, success. Compiled DEX SHA256 `82d39c06b1d378578fadf3637f72a3ae851337bc8a8733c3f25c5467ef9b15f9`, 7536 bytes.

## Exact R147 APK
- Candidate `MOA_R147_LEGACY_STT_PLUS_NATIVE_RECORDING_BETA.apk`, in-chat copy `MOA_R147_Install.apk`.
- Package `com.juhyeon.familyjournea`; versionCode `147` (updates R145 / R146 in place).
- Bytes: `5,475,094`.
- SHA256: `e6b5d504b2bf00fec51fd7262cd4ed23be8c3f4cf63a07cdd79e2fa74afe554d`.
- Existing signer cert SHA256: `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`.
- Built from **exact R143 source APK**, SHA256 `709c2bc906159d2e93ce4f407def0016a04e45f8d492e31d948d65aa55bca5d1` (R143 was old STT + the fixed ALL-media monthly report). 124 original members, **121 byte identical**.
- Changed original 3: `AndroidManifest.xml` **versionCode ONLY** 143→147 (binary resource IDs, activity names, aliases unchanged), `assets/web/index.html` to load voice UI, `classes5.dex` single same-length native superclass descriptor + regenerated Dex header checksums. Added 3: `classes6.dex` native trusted mic bridge, `assets/web/moa-r145-voice-diary.js`, `.css` copied **exactly** from the R145 addon. 127 members total.
- Original `classes.dex` through `classes4.dex`, `family-diary.js/css` native STT, all `MoaMomentVoice*`, all Diary/Family IndexedDB code, media/Map/native quick capture/video, `moa-r141-monthly-report.js/css`, all launcher icon/alias resources unchanged. No permissions or DB migrations added. The new audio module uses separate `moa-diary-voice-v1` IndexedDB (audio Blob) by Diary date, with playback/delete and conditional share/import, separate from original text STT.

## Independent verification (PASS static)
- APK v2 RSA PKCS#1 SHA256 signedData and FULL APK content digest independently recomputed PASS (not only ZIP CRC).
- Historical signing cert SHA identical, original ZIP 121/124 member equality, 4-byte aligned STORED entries, ZIP CRC PASS.
- Existing DEX1–4 EXACT; DEX5 descriptor-only delta plus valid recomputed SHA1/Adler; DEX6 valid SHA1/Adler and expected class/method refs for `PermissionRequest.grant/deny` and original STT `WebChromeClient.onJsPrompt/onProgressChanged` delegate PASS.
- Binary manifest `AndroidManifest.xml` structurally parsed; nine icon aliases unchanged and target original `MoaIconHost`. `MoaIconHost` inherits new AudioHost, AudioHost inherits original VoiceHost, validated from DEX class definitions. Manifest typed versionCode 147. Original media/IDB JS exact PASS; R145 recording JS byte exact; `node --check` PASS.
- Java compile success and synthetic browser test success do **NOT** demonstrate Android runtime grant, old STT recovery, real audio captured, Blob stored after cold start, audio share/export or old quick voice. All **DEVICE PENDING**.

## Required device test sequence
1. Install the original-signer R147 over installed R145 or R146, **DO NOT UNINSTALL, CLEAR APP DATA OR RESET RECORDS**.
2. Test **original Diary `음성 입력` first**: speak 1–2 sentences and verify recognized Korean text actually inserted into the Diary textarea; check native quick `바로기록` too.
3. Open a Diary date → `🎙 음성 녹음·목록` → tap `● 녹음 시작`, approve system microphone prompt if needed, record a short clip, tap `■ 종료·저장`, reopen the day after fully closing the app, play saved file. If error, capture exact message and relevant UI state. Data is local and NOT INCLUDED in old diary backups.
4. Check month report ALL photo+video browsing and Android Back, family event local storage and Map/gallery. No proof until user confirmation.
5. On failure do **not** claim R147 succeeded; use relevant logs, analyze without uninstallation. Emergency-only R148 (source-equivalent R146 with versionCode148) is separately signed/archived; do not deliver as routine update or pretend it preserves R147 recorded data in external backups.

## Preserved requirements
- R115 frozen user Golden, R133 and R143 signed baselines untouched.
- NO Gmail/email; direct in-chat APK and fallback ZIP only; private signing keys never shared.
- Music features permanently excluded from roadmap on user's instruction.
- Next features after audio physical gate: Family recurrence/notifications, opt-in spouse/Windows realtime sync and globe. No unapproved cloud upload of family data.