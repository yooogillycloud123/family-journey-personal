# MOA R82 — R81 silent diary voice failure, original HostActivity WebView field bind (2026-11-04)

## Actual new physical evidence
- User uploaded **18722.mp4**, captured on Galaxy S26 Ultra using R81. Diary edit mic button changes from `🎙 음성 입력` to `음성 준비 중…` and eventually `음성 연결 재시도`; no recognized words, no native success or error dialogue. R81 **physical FAIL**.
- This specifically indicates the JS native bridge and the Chrome heartbeat were not available to the editor during the 4.5-second wait; it does **not** establish a failure inside Android's SpeechRecognizer. R80 raw `MOA_R79_NATIVE_VOICE` prompt and R81 silent fallback are two manifestations of the same still-unproven WebView-to-Android bridge attachment issue.
- Previously verified native locked-camera memo SpeechRecognizer still supplies positive evidence. Do not rewrite it.

## Exact original APK forensic result
- Independently parsed bundled `classes2.dex` of signed R81 APK: `com.juhyeon.familyjourney.HostActivity` declares private field **`web: android.webkit.WebView`**. Original onCreate constructs WebView, installs `NativeHost` JS interface, sets its WebChromeClient/WebViewClient, calls `setContentView` and loads `https://familyjourney.local/web/index.html`.
- R81 Application registered its Activity callbacks and tried to find the WebView by recursive decorView traversal. The exact reason this did not lead to a live bridge is **not provable** from video alone; the private WebView field gives a direct independent binding route.

## R82 reversible change
- Branch: `speech-r82-host-webview-field-bind`
- Native patch: `tools/moa_r82_patch_host_webview_bind.py`; pipeline applies R80 native patch → R81 Chrome re-arm patch → R82 direct `HostActivity.web` reflective bind (read-only) → Java compile/D8.
- Binding prefers exact private `HostActivity.web` and falls back to existing decorView recursion. The foreground-only 350-ms Chrome watcher stays. Same-origin validation was unified across `MoaMomentVoiceChrome`, `MoaMomentVoiceBridge`, and App re-arm to exact `https://familyjourney.local`.
- JavaScript patch: `tools/moa_r82_patch_diary_diagnostic.py` adds a one-time visible failure with R82 **V/C/N/M** flags if native binding is still absent. No false "recording", no raw WebView prompt or write to diary, existing unsaved text protected.
- **No changes** to native `HostActivity` classes2.dex, R63 writer, camera service, image/5-min grouping, location/maps, widget or original WebView assets beyond family-diary.js.

## Build results
- CI: `41806280531` SUCCESS; R82 DEX SHA256 `a387f083f83b29867d8fc6b40c290f0dc36b6b5459b756d50cc722d7f778300f`.
- Signed APK `MOA_R82_VOICE_BIND_REPAIR_Install.apk`, SHA256 `128305dca42b593942e67e35a1507129915ce90c89b997ef763d0e10cedfebf8`, 3,485,361 bytes.
- Package `com.juhyeon.familyjournea`, versionCode 82, same pre-existing signer SHA256 `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`. Private key never uploaded.
- R81→R82 only 3/55 content entries changed: `AndroidManifest.xml`, `assets/web/family-diary.js`, `classes4.dex`; other 52 content entries unchanged. ZIP CRC, v2 cryptographic digest+signature, 4 DEX SHA1/Adler integrity, JS syntax and three Node regression tests PASS.
- **R82 Samsung on-device functional result: UNTESTED.** No release may be called physically fixed without confirmation.

## Next action
- Update-install R82 over R81 (no uninstall/data reset) and tap the existing diary title/body/time-group mic. If it works, verify interim text and final once; if not, R82 reports a single `R82 V0 C0 N1 M0`-style diagnostic. Use the actual flags to identify native interface vs Chrome vs original NativeHost and avoid another blind code-only change.
- Signed R82 APK, backup, source/verification ZIP, JSON saved privately in MOA Library. Immutable working R63/R77/R78 and unrelated AA AirPods project untouched.
