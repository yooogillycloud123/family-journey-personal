# MOA R83 — R82 real-device `V0 C0 N1 M0` and original HostActivity direct-WebView voice repair (2026-11-04)

## Physical device evidence and interpretation
- User screenshot `18725.png`: after pressing diary title mic on **R82**, message `모아 음성 인식 네이티브 연결이 시작되지 않았습니다. 진단: R82 V0 C0 N1 M0`. Companion `18727.png` shows button `음성 연결 실패 · 다시 누르기`, no recognized words. **R82 physical FAIL**.
- V0: `MoaVoiceNative.start` not exposed to the current script. C0: R81/R82 Chrome heartbeat absent. N1: original `NativeHost.post` exists and works in the same page. M0: optional `MoaMomentNative.enabled` not exposed.
- Those flags prove **voice bridge not ready**, not a failure of SpeechRecognizer itself. Previous native memo speech recognition and interim text were actually successful on the same phone.
- Hypothesis supported by code: Application lifecycle-based discovery/injection of an already loaded WebView was not sufficient. Exact root cause (callback loss, injection error, timing, other) not device-logged. Do not claim definitive root cause.

## R83 fix approach — independent of ActivityLifecycleCallbacks
- Source branch: `speech-r83-original-webview-direct-host`, commit `a89903d8dfb2dcc31e4052092fcff3746dc23e29` (source), additional R83 direct-host trust + R63 inbox parity patches already in branch.
- Original signed R82 APK SHA256 `128305dca42b593942e67e35a1507129915ce90c89b997ef763d0e10cedfebf8`.
- Installed launcher is now `MoaMomentVoiceHostActivity` (subclass of the original `HostActivity`). Its `super.onCreate()` executes the **original untouched HostActivity UI/bridge/diary code**. Then its own onCreate/foreground onResume loop obtains the **original private `HostActivity.web` field** and installs `MoaMomentVoiceBridge` and original `MoaMomentVoiceChrome` directly. The Chrome prompt interception is immediately active; `addJavascriptInterface` remains for subsequent loads.
- Foreground-only loop 320ms, stopped onPause/destroy, without forcing a WebView reload or saving an incomplete diary.
- Existing quick thumbnail `MoaQuickThumb`, capture `MoaMomentNative` and original `NativeHost` preserved in same WebView.
- **R63 memo-to-diary sync parity:** `MoaMomentInboxSync.host()` accepts original or R83 exact subclass and reads original `HostActivity.web`, protecting user-confirmed native memo → IndexedDB token/ACK path.
- Original `HostActivity` kept as separate non-exported manifest activity for existing explicit shortcuts and navigation. New launcher alone inherits MAIN/LAUNCHER filter. This is NOT an extra app.
- Original `classes2.dex` method code entirely byte-for-byte unchanged; the one non-header byte modified is the **public FINAL access flag of HostActivity: 0x11→0x01** to permit subclassing. DEX SHA1 and Adler headers recomputed. This is more invasive than R79–R82 and requires real-device gate.

## Actual build, signing and tests
- GitHub Actions `41809388814` completed **SUCCESS**; Android Java compile+D8 succeeded after patching R80→R81→R82→R83 and correcting public lifecycle override visibility.
- R83 APK `MOA_R83_DIRECT_HOST_NATIVE_VOICE_Install.apk`: **3,486,468 bytes**, SHA256 `2d044ce41d4904b39e386e627c72a5e0b40e877a81c3d3da3ecd4787e10badbc`.
- Package `com.juhyeon.familyjournea`; versionCode **83**; same R82 signer SHA256 `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`.
- Verified APK v2 RSA SHA256 signed digest and signature; ZIP CRC; all four DEX SHA1/Adler; AXML original nonexported HostActivity + new exported MAIN/LAUNCHER; new DEX class parent is original HostActivity, lifecycle flags public 0x1 for onCreate/onDestroy; JS syntax and previous R82 mock partial/final/guard tests all PASS.
- R82→R83 changed exactly four of 55 decompressed ZIP entries: `AndroidManifest.xml`, `classes2.dex` (class-final bit only), `classes4.dex`, `assets/web/family-diary.js`; other **51/55 byte-identical**.
- **Physical Galaxy S26 Ultra result: UNTESTED**. Do NOT declare STT fixed until user confirms actual live transcript + final text + Save and native memo/R63 sync.

## Safe in-place recovery
- Since changing the launcher is structurally more invasive, a separate same-signer **R84 rollback-forward APK** `MOA_R84_RECOVER_R82_BASELINE_Install.apk` was created for emergencies.
- It restores the exact R82 code and launcher from the signed R82 baseline and changes **ONLY** `AndroidManifest.xml` versionCode to 84 (versionName R84); all **54 other ZIP members identical** to R82.
- SHA256 `5cdf6628c1d9540223cc68b5c08a3581ad6298b0cebf8ac070e5c972be3e76e0`; APK v2 verified.
- Install R84 **only if R83 fails to launch or has major regression**, as a normal same-package in-place update. R84 restores R82 behavior including its known diary voice failure, and future fix needs versionCode >=85.
- **NEVER uninstall, clear app data, change signer, or copy signing secrets to GitHub.** Save unsaved drafts before updating app process.

## Protected source / next result
- All private source, APK and verification artifacts in MOA Library `/모아_프로젝트_근거_20261103/`.
- Next test: title/body/5-minute memo mic, interim/final words, diary Save, locked-camera native memo + diary synchronization. If failure, send actual R83 H/V/C/N/M flags; do not produce blind retry.
