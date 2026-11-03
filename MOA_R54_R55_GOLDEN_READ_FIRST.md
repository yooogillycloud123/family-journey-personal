# MOA GOLDEN: R54 camera overlay + native speech; R55 sync patch (2026-11-03)

**Mandatory for every new MOA chat:** Read this, `MOA_ABSOLUTE_READ_FIRST_20261103.md`, and `MOA_WIP_CHECKPOINT_CURRENT.md` before any new build. Never regress the user's Samsung Camera immediately-on-capture overlay, native Korean speech input, quick-settings camera watcher, or the original R42 camera-return fallback.

## Confirmed by user's 58-second video
R54 showed the camera overlay immediately after a Samsung Camera shot. Native memo opened and Korean speech-to-text populated the memo. User saved the native draft. The remaining problem is inconsistent native-draft to IndexedDB diary sync; this **was not proven reliable** in the video.

## Confirmed R54 defect and R55 correction
R54 marked a native payload handled immediately when `__moaNativeSync()` returned `ACCEPTED`, even though the diary's IndexedDB write completed asynchronously. R55 checks the real `__moaNativeAckByToken[token]` completed-result before marking the payload committed. Failed writes retry after two seconds, pending unsaved drafts are left intact, missing bridge is non-destructive. No `native.ack()` is called while the old native DEX lacks a persistent deduplication tombstone.

## R55 signed update build
- Filename: `MOA_R55_골든보정_기존R54업데이트_저장동기화.apk`
- Package `com.juhyeon.familyjournea`, versionCode **55** (R54 was 54), original R54 signing certificate SHA-256 `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`.
- APK SHA-256 `6a9ecd2d0b26b97dfbecbabbcfc26f16eb04aef30a2787b093dc271711b5bdc3`.
- Changes relative to R54 **only**: `assets/web/family-diary.js` and version fields in `AndroidManifest.xml`. Camera, overlays, native speech, compiled DEX, all 50+ other assets untouched.
- Independent static gate **92/92 PASS**, including RSA v2 signature, manifest, unchanged DEX/assets, Node JS syntax and async-ACK unit tests.
- **R55 device test NOT YET DONE.** APK is a test candidate, not 'final confirmed' diary sync.

## Update behavior and data
R55 overwrites the already installed **R54** and does not create another icon. Original user '모아' R37 is **a different package** `com.juhyeon.familyjourne8`; R55 **does NOT overwrite R37 or transfer its data**. Keep original R37 and its data untouched.

## Next actual tests and follow-up
Samsung Camera photo -> immediate overlay -> native voice/text memo -> save -> R55 photo diary at the same shot time -> repeat twice -> exit/reenter -> verify both notes and no duplicates. If delayed, use shot time+saved text+diary screenshot/log to isolate ACK failure. Do not replace the working camera/voice code. Web diary's `SpeechRecognition not-allowed` is a separate unresolved mic path; native memo speech worked and must be preserved.

The signed candidate and local verification JSON, rebuild script and full evidence are stored privately in the user's MOA Library collection. Future versions must keep this golden milestone and update the checkpoint with actual results, without making new packages.
