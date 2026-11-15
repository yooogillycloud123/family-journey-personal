# MOA R605 user-approved Golden + R607 narrow repairs / R608 EXACT R605 functional recovery (2026-11-15)

## 1. Physical truth / immutable Golden
- User's actual 107.707778-second Galaxy video `22375.mp4` shows R605 original native Gallery on initial photo-day with full eight-button strip and original fast rail, photo ↔ detailed diary navigation. User separately reports successful app background/foreground and other-app→MOA return (not every case filmed).
- User explicitly: **ADD R605 AS NEW GOLDEN; DO NOT REGRESS ANY WORKING FUNCTION**. Locked **GOLDEN code605** `MOA_R605_NATIVE_GALLERY_RESTORE_QUICKRECORD_HOTUPDATE_ORIGINAL_SIGNED_BETA.apk`, **9,100,992 bytes**, SHA256 **`b357112dd2c90194b218ad197ee988b85fb4edd2a8275b0fe68cb283ed431030`**.
- Immutable branch: `golden/moa-r605-user-device-approved-native-gallery-20261115`. Private immutable archive `MOA_R605_USER_APPROVED_NATIVE_GALLERY_GOLDEN_FREEZE_20261115.zip` SHA256 `fa16dae094c81ae08d705b910b0007e5efbe24dfd0bfa8b73a6e7da7f54b1806` saved to private Library `/모아_프로젝트_근거_20261103/GOLDEN_R605_USER_DEVICE_APPROVED_20261115/`. Do not touch Golden archive/branch or revert to R567 as the new baseline.

## 2. Video-supported UI/data regression, exact code reasoning
- Photo-day header next to existing photo/detail slide switch shows outdated `···` (R539 CSS pseudo-glyph) rather than a matching slider. Original photo and detailed settings menu listeners still work. **Appearance only** needed; do not recreate/replace menus.
- User records QuickRecord voice and recognized transcript in native text field, saves, then photo-form `오늘의 이야기` textarea remains blank, although original audio is shown and `바로기록 20개` item list contains the text. Actual source: native `family-diary.js:mmNativeSaveDraft` stores `curated[day].moments[].note` but leaves `curated[day].body` untouched. Photo-form `moa-r483-vertical-calendar.js:renderDay` binds textarea to `current.body`, not `moments.note`. Independent `r602RefreshMomentNotes` only refreshes the expanded QuickRecord list, not editable story text. Therefore canonical write+same-day textarea refresh needed, without Gallery closing/refreshing.

## 3. Actual R607 changes from exact R605 Golden
- Feature branch **`feature/moa-r607-r605-golden-settings-slider-quickrecord-body-20261115`**, never merge into frozen branch.
- User install **R607 code607** `MOA_R607_R605_GOLDEN_SLIDER_AND_QUICKRECORD_TEXT_ORIGINAL_SIGNED_BETA.apk` **9,105,098 bytes**, SHA256 **`e2a5f442806660b6f4e5d370c1291121ae2c30eb5a5f79cbfd75e71e5c965885`**.
- Exact 4/144 APK payloads changed: `AndroidManifest.xml` version605→607; `assets/web/family-diary.js` canonical writer; `assets/web/moa-r483-vertical-calendar.js` settings button + after-native-ACK body refresh; `assets/web/moa-r483-vertical-calendar.css` settings pill/slider matched 68×34 to original adjacent toggle. **140/144 uncompressed APK member payloads unchanged, ALL original DEX1–18 byte-identical**, all Gallery/QuickRecord native classes, native eight actions, filmstrip, video, M4A, Naver, CSS except targeted photo file frozen.
- `family-diary.js:mmNativeSaveDraft` now appends nonempty saved QuickRecord `note` to same canonical `curated.body` at most once per exact native media ID, stores `r607BodySyncedMediaIds`, keeps original user-edited body as a prefix and all existing photos/moments/tags/M4A. After IndexedDB commit and read-back confirm body contains text, sends only day `moa:native-diary-committed`, no personal text. `moa-r483` refreshes photo story textarea if not dirty/focused and ONLY updates existing image list/moment notes, preserving R602 native in-place playlist and never calling Gallery.close on same-day refresh.
- Header Settings button reuses original `onSettings` handler (photo popover and detailed `moa-r191-day-menu-trigger`), converts visual shape from old `···` to same slider track/pill. No new overlay.
- Original package `com.juhyeon.familyjournea`, original signing certificate SHA256 **`5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`**; original private PKCS12 only used locally in authorized excluded private dir, NEVER published to GitHub or release ZIP.

## 4. Emergency SAME GOLDEN, NOT R567
- **R608 code608** `MOA_R608_EXACT_R605_USER_GOLDEN_FORWARD_RECOVERY_ORIGINAL_SIGNED.apk` **9,100,997 bytes**, SHA256 **`faf77385d3bdbfdf2b2bbc34a6a8ac108322a13e0035b47a9dae11c3f0d367ce`**. **143/144 original R605 ZIP member payloads byte-identical**, only AndroidManifest versionCode 605→608; original 18 DEX, gallery, all JS/CSS EXACT user-approved R605 functionality.
- R608 is emergency installation **ONLY if R607 new severe regression**. Install R607 or R608 in-place with same signer; no uninstall, data/cache/cookie clear, Naver logout, photo/audio delete. After R608 install, next build **versionCode >=609**.
- Previous R606 was R567 function rollback, so do not use for restoring newly approved R605 Golden.

## 5. Evidence and release QA
- Actual source Node VM executed original modified `mmNativeSaveDraft` with IDB-like storage: create body+M4A, same-id re-delivery no duplicates, new photo text append, existing manual prose/tags remain, voice-only keeps original body, after-readback event, no native restart and settings owner preserved → **8/8 PASS**.
- Actual Chromium CSS render of photo and detailed settings with full real R607 CSS: adjacent slider track calculated **68×34** in both modes, with 44×19 track and 18×15 thumb → **2/2 PASS**.
- Node parser checks for both JS files PASS.
- Independent APK v2 signature verification using original private signing identity (Android SDK 29–37), ZIP CRC, all 18 DEX SHA1/Adler, 4-byte alignment of stored members, exact original-vs-candidate APK diff → PASS. Signer certificate fingerprint match. No native DEX recompilation (all 18 preserved exactly).
- Full distributable `MOA_R607_R608_GOLDEN_PRESERVED_SIGNED_APK_SOURCE_QA_20261115.zip` **13,233,765 bytes** SHA256 **`b49f114160e65741a740e1c7f166847d2a419df1d473f540ebbd6444497e0289`**, includes both signed APK, source JS/CSS, exact patch diffs, QA code/results, README, hashes; no key, password, or private personal video.
- Private Library `/모아_프로젝트_근거_20261103/R607_R608_R605_GOLDEN_PRESERVED_SIGNED_20261115/`.
- Important: **R605 physical GOLDEN = USER_APPROVED. R607 static+browser PASS, new Galaxy QUICKRECORD AUTO-STORY + all-Gallery regression STILL UNTESTED; R607 is BETA NOT GOLDEN.**

## 6. Test and future
1. Install R607 above currently installed R605 (code607>605; original signature matches). Do NOT uninstall/reset data.
2. FIRST verify native original fast rail + 8 buttons at photo day, photo/detail round-trip, Home/background app return, and different-app return; **no old Web fallback**.
3. Photo/detail top-right Settings now matching adjacent slider; original settings menu must open.
4. Capture new photo → QuickRecord voice/transcript (text visible native) → Save → photo `오늘의 이야기` textarea shows exact text automatically; original "바로기록 N개" list and original M4A preserved; no duplicate when revisiting; existing manual story preserved.
5. If fails, share device screen recording and `설정 → 원본 갤러리 진단 복사` for native issues, without destructive resets. If serious, use R608 EXACT R605 forward recovery.
6. Never touch AA AirPods project / R605 immutable source / previous Golden archives.
