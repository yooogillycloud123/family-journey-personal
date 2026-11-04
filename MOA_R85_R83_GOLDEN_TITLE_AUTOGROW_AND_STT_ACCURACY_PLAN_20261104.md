# MOA R85 — R83 voice GOLDEN protected; title auto-grow beta (2026-11-04)

## User-confirmed R83 physical GOLDEN
First read MOA_R83_USER_DEVICE_GOLDEN_LOCK_20261104.md. The user confirmed diary voice works on Galaxy S26 Ultra, screenshot 1793786504511.png and video 18743.mp4. Older "R83 onDevice UNTESTED" text is obsolete for this specific speech feature. Exact immutable signed APK SHA256 221488ba5e1c6fb225c99837070cdad6028f1798aba396c05e73a763bb4e2d78, 3,486,468 bytes, com.juhyeon.familyjournea code83, existing signing cert 5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15. Frozen branch golden/moa-r83-20261104-user-voice-pass-do-not-modify. Private Library exact copy MOA_R83_USER_DEVICE_GOLDEN_VOICE_PASS_20261104_DO_NOT_MODIFY.apk.

## User's two additional issues
1. Existing diary title uses a one-line text input; long typed or transcribed text is clipped, while body/time memos are multiline.
2. Korean speech recognition is physically working but mishears words; accuracy enhancement is requested without breaking the successful bridge.

## Signed R85 UI-only beta
- Branch enhance/moa-r85-title-autogrow-r83-golden-frozen. Script tools/moa_r85_title_autogrow_patch.py. Exact original packaged R83 JS SHA256 guard 8a8e609220cddbf309c585202bc94a7e113b6450c57fe8942c9cd0c8c37a91d5.
- Replaces only the title field from one-line input to two-row textarea, same id fd23-title, maxlength120, value, native microphone listener, original Save and underlying IndexedDB. Adds wrap, automatic expansion/shrink capped at 240px, scroll and vertical manual resize. Partial/final voice input events also auto-expand.
- APK MOA_R85_GOLDEN_TITLE_AUTOGROW_Install.apk, code85, 3,487,910 bytes SHA256 665e934ec61030b98004dc89098505e6001aec57d0c2727b719cc02b5d331a8a; same package and certificate. R84 was already a rollback to voice-broken R82, not the R83 Golden.
- Exactly two of 55 decompressed entries changed from R83: AndroidManifest.xml (code and versionName ONLY, two different AXML bytes) and assets/web/family-diary.js (title-only UI). Other 53 identical, including ALL classes.dex/2/3/4 and R63 writer. SpeechRecognizer, HostActivity, MoaMomentVoiceHostActivity, MoaVoiceNative and original save() are byte-identical to R83.
- R85 packaged JS SHA256 d8a2256a0ec6f48a44d2cf07461b0fcf6395a6f8a3abd3581279bea8e4e6f389. APK v2 digest/signature verified, ZIP CRC and stored-file alignment verified.
- Node --check complete real JS PASS, mock DOM tests verify title value/id/maxlength, mic targets textarea, multiline expand/shrink, STT input event auto-growth; original native voice JS and original save() byte-identical PASS.
- **R85 Samsung device test UNTESTED; do not call it a physical Golden until user confirms title editing, voice and Save/reopen.** Exact R83 user Gold remains untouched. No uninstall/clear data, sign only with original private key and do not publish keys.

## STT accuracy improvements: PLAN ONLY, NOT IN R85
- R83 native engine chooses Android createOnDeviceSpeechRecognizer when available, ko-KR and offline preference.
- Future version as OPTIONAL controlled experiment, default current R83 provider: compare Android system default recognition vs on-device with explicit warning if the system provider may use internet/cloud; never silently switch privacy behavior.
- Android provider may support EXTRA_BIASING_STRINGS (local user-editable proper names), EXTRA_ENABLE_FORMATTING + FORMATTING_OPTIMIZE_QUALITY (punctuation), EXTRA_MAX_RESULTS >=3 (user can choose alternate transcript). The provider may ignore any hint; accuracy gain not guaranteed.
- Keep in-app manual correction and original text; A/B test at least 10 matching Korean phrases for word errors and latency, no raw audio logging, no family photo/note upload. If bad or unsupported fallback automatically to Golden default.
- STT quality work must not be mixed into this R85 title-only release.

## Follow-up gate
Install R85 in place over R83, test long title wraps and grows while typing and native speech dictation, tap original Diary Save and reopen; check body/time-note/save and photo memo still work. If new regression, create newer versionCode >=86 rollback-forward from frozen R83, NOT R84 (R82 behavior).
