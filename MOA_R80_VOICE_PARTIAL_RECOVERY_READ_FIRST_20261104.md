# MOA R80 recovery checkpoint — 2026-11-04

R79 Samsung actual FAIL: diary edit mic reported "모아 음성 인식 연결을 준비하지 못했습니다" (18698.png). R77 secure-camera locked popup and R78 native memo STT are user-confirmed real PASS and must never regress. R63 original same-origin IndexedDB writer Golden protected.

Recovered existing R79 GitHub branch `speech-r79-editor-bridge` and signed exact R79 APK SHA256 `211d3b1501c4f451261f9358ef2f2f3ebc7b7154f13bdc4eedaf13b74a50943a`. Original last Python/container command failed with ClientError, then environment recovered. **R80 source patches and build now finished.**

Source-proven failure: R79 editor JS depended on stale `__moaR79VoicePromptReady` boolean and refused to call onJsPrompt. Also R79 `MoaMomentVoice.onPartialResults` was empty and did not request `EXTRA_PARTIAL_RESULTS`. Only final words appeared. WebView Chrome bridge was registered once and could be displaced.

R80 fixes:
- `tools/moa_r80_patch_native.py` (five native voice-related Java sources, applied and compiled via GitHub CI): Android partial results → native memo live EditText and editor JS callback; final once; End button; bound permission after grant; token/session cleanup; rearm WebChrome on foreground without page reload.
- `tools/moa_r80_patch_diary_voice.py` patches exact private R79 JS for native voice prompt even with stale ready flag, partial replacement in title/body/5-minute note, final no duplication, no Web Speech fallback, original manual Save retained.
- Original R77 overlay source and R63 native direct writer source hash verified unchanged by CI. No new app or data deletion.

GitHub source branch `speech-r80-partial-bridge`, current compiled CI source HEAD **a6c66b0e2826b88c01b64f661a23e92a3b0e6dc1**, Actions **41796811658 SUCCESS**, compiled classes4.dex SHA256 **aef7c90606eb439ed0e331c9ef371c3e286c10dfa92c9d257b9e9ea97d307b6d** (91,564B). Source changes are stored as strict `tools/` patch scripts; Java paths remain R79 in raw checkout until the workflow applies them.

Signed same-package installer **MOA_R80_Install.apk**, versionCode80, package `com.juhyeon.familyjournea`, bytes **3483143**, SHA256 **4b15c43724a9023adeb237bd09e35f9c490dec858664497955519906d804a2f7**; original cert SHA256 **5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15**. Private archived signer used locally only and never published.

APK R79→R80 3/55 member bytes changed ONLY Manifest/version, classes4.dex, family-diary.js; 52 identical incl R63 direct writer and all original classes.dex/classes2.dex/classes3.dex. APK v2 RSA signature+digest/ZIP CRC/4-byte alignment PASS; Node live partial-final no-dup, stale callback, R63 IndexedDB, R73 deletion and R76 thumbnails PASS.

Private Library:
- `/모아_프로젝트_근거_20261103/MOA_R80_NATIVE_PARTIAL_FINAL_EDITOR_BRIDGE_BETA.apk`
- `/모아_프로젝트_근거_20261103/MOA_R80_NATIVE_PARTIAL_SOURCE_VERIFICATION_NO_KEYS.zip`
- `/모아_프로젝트_근거_20261103/MOA_R80_VERIFICATION.json`

**R80 Galaxy actual install, microphone, interim recognition NOT YET VERIFIED.** Speech provider may omit partial events despite API request. Update existing R79 in place, never uninstall/clear app. First device gate: secure camera native memo unchanged; diary editor title/body/time mic displays interim→final correctly, no R79 error, original save persisted.
