# MOA R389 — R355 Golden + original R357 plain pink Home dot (2026-11-12)

## User request and original source
User physically installed/observed R387 exact R355 Golden functional restore, and reported missing small plain pink circular floating home button at left-lower web viewport. The original was identified from immutable private R357 preserved source `moa-r357-home-dot.js` and [R357 original handoff](MOA_R357_R355_GOLDEN_SAFE_NATIVE_HOOK_DOT_HOME_BETA_HANDOFF_20261111.md). Original desired behavior: pink circle with NO icon, tap to Diary calendar home; long-hold move/resize with 8 handles; optional independent auto-shrink setting (OFF by default), tiny-dot first tap expand/second tap home.

## Signed exact physical artifact
- **APK** `MOA_R389_R355_GOLDEN_PINK_HOME_SIGNED.apk`
- **versionCode** 389, package `com.juhyeon.familyjournea`
- **SHA256 APK** `3c90b908a4251a287daaa69a5976bc505c29862a7c7f92c288075593aac5f7ab`, size **8,912,415 bytes**
- **Original certificate** SHA256 `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`.
- Base **R387 signed Golden** SHA256 `96bd015ff404ecd923cbc710e4f4bbb583b8d4b6b187890160bbd15bdd96ffca`
- Independently checked both R345 original `fe2aaaac15d39a610268ee3d10361652a95537e0ce8ec9cde86e98edf3f8ceb1` and literal R371 R355 functional restore `5ed6a361ca9903c1ab9c01c924c36e582416f7cdec0e92ac650f8f03c6f51641`.

## Exact delta against R387; NO NAVER engine changes
- **136/138** original R387 APK members are content-byte-identical to R387, R345 and the user's preserved R371.
- **Only** `AndroidManifest.xml` typed versionCode **387→389**, `assets/web/index.html` single end-of-body script inclusion, and **one new** `assets/web/moa-r389-home-dot.js` home UI only.
- All original **16 DEX**, including polished native Moment Recorder, Gallery, Voice, and original R345 NAVER favorites/account writer/probe, Diary IndexedDB, original Settings assets, frame and app source bytes unchanged.
- Home JS is adapted from exact privately archived R357 JS. **Removed unrelated R357 NAVER settings panel and any NAVER session writer/control**. Preserved prior home LocalStorage preferences and position keys, preserved unrelated NAVER settings fields when writing new home prefs. Default portrait position left-lower (y=.71); saved prior position overrides.
- Pink home circle appears within MOA owned web view only, not atop separate native system apps/Activities. A dirty diary edit presents discard confirmation before navigating.
- No cookie/cache/credential clearing, no restore/uninstall action or database schema modifications.

## QA
- Locally verified **APK Signature Scheme v2 RSA certificate/signature & content digest PASS**, ZIP CRC/alignment PASS, all **16 DEX SHA1+Adler32 PASS**; 139 total packaged archive entries.
- Chromium simulated original R357 home gesture test PASS: icon-free dot, longhold, move, resize, auto-shrink toggle OFF, ON idle collapse, tap expand and next tap home.
- Extra Chromium test PASS: restore saved bottom-left position and prior home size, preserve unrelated previous NAVER folder/mode preference values, old Settings remains, no new NAVER settings panel, calendar home opens, cancel when unsaved Diary edit, resize persistence, zero JS uncaught exceptions.
- **Physical Galaxy install, device WebView and new NAVER login/account save NOT TESTED**. Static/browser acceptance is not a new device Golden declaration.

## Delivered backup and conservation
- Backup ZIP `MOA_R389_R355_GOLDEN_PINK_HOME_APK_BACKUP_QA.zip` SHA256 `ff2ac3c56e274f0c2ad281082df5fc8ac1f8e3028b561ddbc79adc0eec46bde0`, 6,451,235 bytes; includes exact APK, QA JSON, README, SHA sums, ZIP CRC verified.
- All exact binary APK/ZIP/QA and JS source stored successfully in private Library `/모아_프로젝트_근거_20261103/R389_R355_HOME_20261112/`; signer private key/password never included.
- Update install **over R387 (or current lower code with matching signer) without uninstall or app-data clearing**. Preserve R345/R355/R387 originals as immutable archived records. Next candidate **versionCode >389**.
- AirPods/Android Auto repo/daemon/audio unaffected.
