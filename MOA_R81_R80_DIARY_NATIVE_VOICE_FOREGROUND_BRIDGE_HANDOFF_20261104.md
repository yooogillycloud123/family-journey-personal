# MOA R81 — R80 diary native voice bridge foreground repair (2026-11-04)

## Actual device evidence and problem
- User tested R80 on Galaxy S26 Ultra. Native memo inline voice recognizes and renders interim text (physical PASS).
- Diary editor microphone still displays a raw WebView prompt with `MOA_R79_NATIVE_VOICE` and a token, then reports native voice connection failure (physical FAIL).
- This shows that the live editor WebView did not have the expected native prompt interceptor at the moment the button ran. Exact underlying reason for the replacement is not independently logged.

## R81 isolated repair
- Based on **exact uploaded R80 APK** SHA-256 `4b15c43724a9023adeb237bd09e35f9c490dec858664497955519906d804a2f7`.
- Branch: `speech-r81-editor-native-live-bridge`, source `tools/moa_r81_patch_voice_bridge.py` applies **after** the existing R80 native patch script.
- `MoaMomentApplication`: foreground-only 350 ms generation-guarded `WebChromeClient` health check/re-arm, stopped on pause or destroy. Existing STT objects and capture/storage services unchanged. This avoids the previous R80 assumption that two one-shot resume retries are sufficient.
- `MoaMomentVoiceChrome`: exact HTTPS origin parser for `familyjourney.local`, including root URL without `/`, not a fragile string prefix.
- Existing initial WebView reload now checks if diary editor is already active first.
- Packaged `assets/web/family-diary.js`: safe 4.5-second native bridge readiness wait; prompt fallback issued only when the native Chrome heartbeat is fresh, preventing the previously observed raw `MOA_R79_NATIVE_VOICE` prompt in ordinary missing-bridge state. Preserve existing drafts; do not save until user taps diary save.
- R80 SpeechRecognizer interim/final behavior and the physically successful native memo pathway preserved.

## Build / signing
- GitHub Actions run `41802659947` **SUCCESS**, Java and DEX compiled.
- Isolated R81 DEX SHA256 `34d82e2d065646b570781a8aa979805c160d476353548cb26cda33b1b6bddc52`.
- R81 signed APK `MOA_R81_VOICE_BRIDGE_FIX_Install.apk`, SHA256 `26e65446fbd634266a1c4bcbac94e67586fef5080ae71b8966d58886d31ac3d9`, bytes 3,484,214.
- Android package `com.juhyeon.familyjournea`, versionCode 81, versionName R81, previous signing certificate SHA256 `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`. Private keystore **NEVER uploaded to GitHub**.
- APK v2 cryptographic signature/digest verify PASS, ZIP CRC PASS, all four DEX checksum PASS, stored entry alignment PASS.
- Exactly 3/55 contents changed: AndroidManifest.xml, classes4.dex, assets/web/family-diary.js. Other 52 decompressed members identical, including original HostActivity classes2.dex and R63 diary writer.
- Node speech-simulation tests PASS: intermediate results replace instead of duplicate, final once, native bridge direct path, heartbeat-guarded fallback, absent bridge prevents raw prompt and preserves text.

## Honest release state / next physical gate
R81 is a **signed static-verified beta**, not a confirmed Samsung functional fix. Requires physical Galaxy S26 Ultra test: editor mic for title/body/5-minute memo, initial + subsequent attempts, interim words, end/final, original Save, existing memo/lockscreen still pass. If it fails, collect live `WebChromeClient` state and `MoaVoiceNative` JS bridge logs rather than reporting static pass as physical success.

## Preserve
Do not uninstall, clear data, rotate signer, or modify existing R63, R77/78 camera/memo, gallery, map and photo grouping. Golden writer and all unrelated original DEX frozen.

Private backup APK/source/verification retained under MOA Library. No signing credentials in public artifacts.
