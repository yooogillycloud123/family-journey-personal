# MOA R605 / R606 — native Gallery original-host mount ACK + same-day QuickRecord hot update, original-signer APKs (2026-11-15)

## Exact user evidence and scope
- User uploaded `22340.mp4` (17.04s), `MOA_R602_NATIVE_HOT_UPDATE_QUICKRECORD_ORIGINAL_SIGNED_BETA.apk` and `MOA_R603_EXACT_R600_FUNCTION_EMERGENCY_ORIGINAL_SIGNED.apk`. On user phone R602 original fast R463/R567 native Gallery + 8 native actions/rail do NOT persist/appear, instead blank/black and old Web fallback after restart. Physical R602 **FAIL**.
- User asks to treat original Web photo stage as native Gallery frame, preserving original 8 actions and adding QuickRecord photo/voice without native Gallery destruction. Actual architecture already uses original Web DOM stage geometry to position ORIGINAL `MoaNativeGallery` Android host directly in Activity root; WebView itself also owns calendar/Diary. Do not remove entire WebView.
- R602 native provider `r572FinishEntry()` blocked native mount ACK until `actionDeck` existed, whereas user-approved R567 ACKed when original native host attached. The asynchronous deck can lag. It is a code-confirmed unnecessary prerequisite, **not yet proven sole physical reason**. R602 JS also previously allowed native opener without `__moaR511NativeArmed`, unlike R567.
- R602 earlier `r592RefreshVisibleDay() -> render() -> r507StopInline() -> closeNativeGallery()` same-day QuickRecord bug was source-confirmed and already repaired; preserve R602 in-place native playlist update.

## Source and controlled changes
- Branch: [R605 original native attach ACK](https://github.com/yooogillycloud123/family-journey-personal/tree/feature/moa-r605-r567-native-attach-ack-r602-live-playlist-20261115)
- R604 JS on R605: R567 required pre-draw arm before original native Gallery.open; explicit `NATIVE_ARM_TIMEOUT` and missing-stage diagnostics. No unarmed force-open. R602 hot playlist/selection/memos/voice updated without Gallery.close.
- R605 additive Java `experiments/moa-r507/MoaR507InlineGalleryProvider.java`: original host+stage must be in Activity root; then emit native mount ACK independently of 8-action deck readiness, while still reporting `NATIVE_ACTION_DECK_PENDING` until actual original deck is attached. Original eight native OnClickListeners preserved, original Gallery source unchanged.
- [Android SDK35 Java/D8 + JS source contract CI SUCCESS run 43693065799](https://github.com/yooogillycloud123/family-journey-personal/actions/runs/43693065799). Public tools/DEX CI [43693583966](https://github.com/yooogillycloud123/family-journey-personal/actions/runs/43693583966) SUCCESS.
- Source-only workflow is NOT physical Galaxy QA. No new Gallery/Web engine built.

## Signed user APKs generated in current session (private key NEVER published)
- Exact original R602 parent: SHA256 `ed21bddc7710921b433e3d0b5f80d661d71d0e16ba3553c92691191faa1bf64f`; original package `com.juhyeon.familyjournea`.
- Private Library historical original signer was locally materialized to an excluded private directory; PKCS#12 key and certificate fingerprint **cryptographically MATCH** R602. Do NOT upload any key, password, private registry, or signing zip to GitHub or release QA.
- **R605 installable original-signer BETA**: `MOA_R605_NATIVE_GALLERY_RESTORE_QUICKRECORD_HOTUPDATE_ORIGINAL_SIGNED_BETA.apk`, versionCode 605, 9,100,992 bytes, SHA256 `b357112dd2c90194b218ad197ee988b85fb4edd2a8275b0fe68cb283ed431030`. EXACT 141/144 original R602 zip entry payloads identical; only `AndroidManifest.xml` (versionCode 602→605), `assets/web/moa-r483-vertical-calendar.js`, `classes18.dex` changed. All original 17 core DEX untouched.
- **R606 HIGHER-CODE EMERGENCY functional return to user-approved original R567 Golden**: `MOA_R606_EXACT_R567_USER_GOLDEN_FORWARD_RECOVERY_ORIGINAL_SIGNED.apk`, versionCode 606, 9,072,236 bytes, SHA256 `022c0c55adc51162970211237bf42bc8823cec7cb3ae233ea992caaa89a62bd6`. Exact user-approved R567 APK SHA256 `f205afb72744391ce9f2594f898728699870be006f787c712599a1ee8492e93c`; R606 payload vs R567 only AndroidManifest versionCode changed. R568–R605 functionality LOST if R606 installed; emergency only.
- Both APK original signer certificate SHA256 `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`, RSA 3072, APK Signature Scheme **v2 signed-content verification PASS** across SDK29–37, ZIP CRC PASS, all 18 DEX header/Adler32/SHA1/size PASS, all 48 stored entries 4-byte aligned. Same package/signer update-install preflight PASS; **real Galaxy installation / physical native success STILL PENDING**.
- Complete distributable APK+public source/QA `MOA_R605_R606_ORIGINAL_SIGNED_APK_SOURCE_QA_FULL_SET_20261115.zip` 13,158,592 bytes SHA256 `51db828fa3fdd156406cab388386700388e33d591bba28f90c4abbc24430cb3f`. Contains R605, R606, README, QA and source; no signer material.
- User links delivered in same ChatGPT session (only exact verified local paths).

## Install/test/rollback gate
1. Update-install **R605 only** over existing same-signer R602/R603 (both lower codes). No uninstall, clearing storage/cache, Naver logout, diary/photo deletion, AirPods modification.
2. Historic photo date FIRST: original fast native rail and 8 native controls visible; then capture → QuickRecord save → same-day photo playlist updates with no Gallery.close; restart; verify photos/videos/memos/M4A.
3. If severe *new* regression, update-install R606 only, exact R567 approved functional return, with loss of later-added features. After R606 next build **versionCode≥607**.
4. On R605 native failure, **Settings → 원본 갤러리 진단 복사** collects bridge/open/host/geometry/deck/mount stages. Do not invent an Android root cause or call APK FINAL until physical PASS.
5. Preserve immutable R567 and R463 Goldens. Keep AA AirPods unrelated audio project unchanged.

**Status:** SIGNED INSTALLABLE BETA / static+crypto QA PASS / physical Galaxy native rail + repeat QuickRecord PENDING.