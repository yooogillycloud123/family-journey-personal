# MOA R83 — USER-CONFIRMED NATIVE DIARY SPEECH GOLDEN LOCK (2026-11-04)

## TOP PRIORITY: DO NOT BREAK OR OVERWRITE
User has explicitly confirmed **"성공했다 드디어 이것도 골든버전으로 지침 박아놓고"** after updating to R83 on Galaxy S26 Ultra. This confirmation supersedes the historical `R83 onDevice=UNTESTED` status of the earlier candidate handoff **for the native diary-editor speech bridge**.

User screenshot `1793786504511.png` and video `18743.mp4`: MOA diary editor voice input is now active and inserts recognized Korean words into the diary title and body. The displayed saved diary title/body in the screenshot also indicates that a diary record exists. Do not broaden this to proof of all edge cases or recognition accuracy. The user reports inaccurate/omitted Korean words and that the **one-line title input clips longer text**; both are enhancement tasks, not reasons to rewrite the proven bridge.

### Frozen physical Golden
- App: **MOA R83**, `com.juhyeon.familyjournea` versionCode **83**.
- Exact APK: `MOA_R83_DIRECT_HOST_NATIVE_VOICE_Install.apk`, **3,486,468 bytes**.
- Exact full APK SHA256: `221488ba5e1c6fb225c99837070cdad6028f1798aba396c05e73a763bb4e2d78`.
- Signer certificate SHA256: `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`.
- Frozen APK member `assets/web/family-diary.js` SHA256 `8a8e609220cddbf309c585202bc94a7e113b6450c57fe8942c9cd0c8c37a91d5`.
- Frozen APK member `classes4.dex` SHA256 `6833fc04e40fa0e7c10cc814db4fffc5a3adc32fba198bdc5f930efce4964efe`.
- Frozen APK member `classes2.dex` SHA256 `0a15e834442135199852b79047b2be0f73a60119b0741bf256a6e20367f16a23`.
- R83 first successful native speech architecture: new launcher `MoaMomentVoiceHostActivity extends original HostActivity`, reads ORIGINAL `HostActivity.web` and installs `MoaMomentVoiceBridge` and `MoaMomentVoiceChrome` **after calling super.onCreate**, foreground re-arm every 320 ms; original `HostActivity` methods unchanged. Only original class FINAL flag cleared in `classes2.dex` to allow subclass. This specific architecture, exact runtime class identity and manifest launcher structure MUST REMAIN.
- Original R63 real-device Golden photo→memo→IndexedDB writer frozen. R77 locked-camera memo native voice, R68/71 editor toolbar, R73 media grouping, R75 thumbnails, R82 diagnostics, map, navigation, all existing data/permissions retained.
- GitHub source branch **`golden/moa-r83-20261104-user-voice-pass-do-not-modify`**; original implementation branch `speech-r83-original-webview-direct-host`.
- GitHub Actions R83 native DEX build `41809388814` SUCCESS; static checks PASS, Samsung physical speech connection **USER PASS**.

### Current enhancement requests (DO NOT contaminate GOLDEN)
1) Title uses `<input type=text id=fd23-title>` with maxlength=120 and a fixed single-line viewport; long entered/recognized title appears clipped while editing, whereas body/time-group textareas can expand. Target **auto-growing multiline title** and retain original `id=fd23-title`, `.value` save, voice target and cursor, accessibility and keyboard behavior. Maintain title max 120, no schema or DB changes.
2) Korean recognition transcript sometimes mishears words. The current R83 recognizer uses `SpeechRecognizer.createOnDeviceSpeechRecognizer` where available, `ko-KR`, `EXTRA_PREFER_OFFLINE`, partial results. Android recognizes partials as provider-dependent. Possible accuracy improvements: optional user-selectable SYSTEM/online-eligible recognizer (only after device validation), speech formatting quality, contextual biasing names; provider support varies. **Never replace or alter the default R83 engine merely to improve accuracy.** Keep recognition provider selection separately gated and reversible, no silent cloud transmission.
3) User video `18743.mp4` also includes a question spoken into title about saving; **do not claim universal title save confirmed** from this alone. Preserve existing Save logic and test end-to-end before claiming.
4) New releases must use versionCode >=85 because an R84 rollback-forward package was already created, even though R83 is physical Golden. R84 restores known broken R82 voice and is not the Golden. Do not suggest R84 as routine rollback.
5) Before ANY modification, copy exact R83 signed APK to private Library with a `GOLDEN` filename, record SHA, and create a separate branch from frozen source. Sign same private key locally only; no private signing material/GitHub commits, no uninstall/clear data. Minimum manifest and DEX unchanged for UI-only release. Diff all archive entries; JS UI patch only. Run web tests for multiline typing, STT partial/final, existing save and reopen, note grouping and R63 writer.
6) A successful GitHub compile/static validation is NOT physical-device validation; mark each separately.

## Next new chat read-first
1. Project `yooogillycloud123/workexcel-devbridge/main/AA_AirPods_FINAL_READ_FIRST_v1.0_20261005.md` first per project instruction; AirPods Golden unaffected.
2. This file **MOA_R83_USER_DEVICE_GOLDEN_LOCK_20261104.md**.
3. `MOA_R83_R82_V0C0N1M0_DIRECT_ORIGINAL_WEBVIEW_READ_FIRST_20261104.md` for source/builder.
4. Latest separate R85+ enhancement checkpoint, library signed APK and tests.
