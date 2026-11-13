# MOA R511 / R513 — Sticky weekdays and compact, stable in-card native Gallery (2026-11-14)

## Project state / irreversible constraints
- **ONLY user-approved MOA Golden is R463**, exact signed SHA256 `9d2fd10d32a3bc35eb3132333e96edd8f565abd5daf3ce954b052f77083d8379`. Golden source/17 DEX never touched, no recreation from scratch.
- User's Galaxy screenshots/videos `1794610560071.png`, `21430.png`, `1794610668542.png`, `21435.png`, `21426.mp4`, `21427.mp4` show that R507 native Gallery **already works in the photo card**, but report repeated weekday headers on month scroll, weak month boundaries, photo entry initial fullscreen black flash, top photo cover star, intermittent legacy web fallback, square native card and oversized thumbnail/footer controls, WebView vertical scroll stutter. User explicitly requires no regression to the original standalone R463 high-end Gallery.
- Exact prior base: R507 signed APK code507 SHA256 `cc46bd000eb2b24e834d14c6b56b731632facf59e3d0a8d4aad3ec5992b4cb54`; recovery baseline R509 code509 SHA256 `863af0d9dcf71b8d047c480a6b4b90496e59e375f4ecac89c56d9095b28f5369`.

## New signed binaries
- **Install LAB R511:** `MOA_R511_STICKY_MONTH_COMPACT_NATIVE_GALLERY_ORIGINAL_SIGNER_LAB.apk`, code **511**, **9,005,849B**, SHA256 **`95f139df890a25c72d172f520fe3872abc0df7afabe6732cc1cbc0dcbfdc5138`**.
- **Emergency exact R463-function rescue R513:** `MOA_R513_EXACT_R463_GOLDEN_FUNCTION_RECOVERY.apk`, code **513**, **8,951,160B**, SHA256 **`a371e45cbe0e3e8504bda1e20cf91367815948d84843614bf548aaf84b5d8447`**. R509→R513 only Manifest versionCode changes. Emergency only; future candidates **>513** after installing it.
- **Combined install/restore/source/compiled-DEX/QA ZIP:** `MOA_R511_R513_NATIVE_GALLERY_STABILITY_SIGNED_APK_SOURCE_QA_20261114.zip`, **13,573,458B**, SHA256 **`d3a6afe38d9da0a1809ce89a211d673efd023ef03de23c418ea891ea093e1bf3`**, ZIP CRC & exact payload SHA256 PASS.
- Original cert SHA256 `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`. Original signer private key/password is NOT in repo, ZIP, QA, or handoff.
- Private Library folder `/모아_프로젝트_근거_20261103/R511_R513_NATIVE_GALLERY_STABILITY_20261114/` holds ZIP, two APKs, independent QA, Korean README, provider source. Source branch `feature/moa-r511-sticky-month-native-card-stability-20261114` from R507.
- **Exact changes R507→R511: ONLY 4 APK members**: AndroidManifest.xml versionCode, `assets/web/moa-r483-vertical-calendar.js`, `.css`, and supplementary `classes18.dex`. Original `classes.dex` through `classes17.dex` and all legacy Gallery/diary/Naver/voice assets remain byte-identical. 143 total members / 18 DEX. R513 has 140 members / 17 DEX.

## Engineering changes
1. One fixed row of Sunday–Saturday chips OUTSIDE monthly scroll feed. Remove seven repeated weekday elements from each monthly grid; each month's 4–6 date rows now fill the same available viewport. Top period follows real visible month.
2. Thin theme-derived month transition line with compact small month-label badge only on inactive sections. No duplicate big weekday row.
3. Photo editor daily header height reduced to 41px, view switch compact; implicit Back/gesture used (unnecessary visual `‹` hidden); photo stage increased to 64vh (bounded) and web/native round corners 23dp.
4. R511 two-phase **arm → native Gallery open**: provider receives card rect before opening, registers `ViewTreeObserver.OnPreDrawListener`, hides fullscreen native host alpha before its first draw, places host to exact in-card bounds, then softly reveals original renderer. Fails closed to Web fallback if native unavailable; no original Gallery DEX changes.
5. On photo stage vertical movement, avoid recurring `FrameLayout.setLayoutParams` on `TextureView`: only resize on dimension change and use hardware-composited `translationX/Y` 56ms interpolated updates at 55ms owned-only poll. Ignore sub-second Web DOM active false so original video/gallery isn't closed during brief layout recalculation.
6. No top picture star. During owned inline session only, inject ★ as the FIRST action in the existing R463 `moa.gallery.action.deck.r443` footer; original four functions share/GPS/metadata/fast stage remain the SAME original handlers. Star reuses `calendar-covers-r29` storage. Compact 5-action capsule, original rail/video controls, and photo stage round clipping only on this owned Gallery instance. All normal fullscreen Gallery sessions retain R463 untouched behavior.
7. Scoped Android Back callback only while in-card Gallery owns host; original standalone Gallery callback left unchanged.

## Verification — separate static/build vs physical
- GitHub Actions SDK35 Java17/D8 compile **PASS**: run `43525651711`, artifact `14085155898`. New `classes18.dex` size **20,900B**, SHA256 **`6c1f0518f5f4af6c3f51d03908e1175fce7a7c3de8242d9f2f7bec548fc08ed3`**, compiled exact source SHA `d31ab4f28dd1c64010a325ebbfd1516347d7441fb78260b29b49f0e80376c33a`.
- Independently verified both APK **v2 RSA PKCS1 SHA256 certificate and signature + full signed-content digest, ZIP CRC, 4-byte stored data alignment, every DEX SHA1/Adler header, 17/17 original DEX exact bytes** PASS.
- Synthetic browser Chromium 420×870 4 named themes pink/peach/white/black: EXACTLY one weekday header, 7 chips, zero repeated month weekdays, 5-row dates filling viewport, 2026/11→12 month label updates while weekday Y stationary, enlarged rounded daily picture, hidden web cover star and top Back, no JS exceptions — PASS. Real personal photos NOT used in tests.
- **R511 real Galaxy physical**: install, full-size native Gallery stage/video/mute/seek/frame-capture, GPS/NAVER, cover star, day↔calendar Back, cross-screen scrolling/flicker/heat/power, all original standalone Gallery regression scenarios **NOT TESTED**. Do NOT mark device PASS, FINAL or new GOLDEN. An APK's valid signature does not prove runtime feature correctness.
- User has historically seen `Library file not found` with some ChatGPT Android file links. Sandbox exists and Library uploaded; **recipient-download NOT CONFIRMED**. Do not claim user received/downloaded.
- Never uninstall/clear data, IndexedDB, Naver cookies/logins, media files; no changes to AA AirPods project.

## Mandatory device acceptance
1. First launch the *ordinary standalone R463 high-end Gallery* and verify swipe/video controls/GPS/metadata/volume/capture and Naver return untouched.
2. In R511 main photo calendar check sticky weekday once and clear month transitions for continuous/month-by-month settings.
3. Enter photo day: confirm NO fullscreen black flash; 5 icon footer with leading representative-photo star, no top star; rounded stage and compact video/filmstrip; kinetic horizontal swipe; every icon actual action.
4. Swipe vertically while Gallery is visible, scroll into story and back multiple times: no stutter/NativeHost reloading/legacy web fallback, no video restart.
5. Test normal hardware Back, pink Home, day diary, scheduled events, Naver login, voice, Save.
6. Any severe R511 regression -> update-install R513 (same cert, code513) with original app data untouched; report exact FAIL and preserve R463 Golden.

## Next chat
Read `MOA_READ_FIRST_NEW_CHAT.md`, `MOA_R463_GOLDEN_LOCK_READ_FIRST_20261113.md`, `MOA_WIP_CHECKPOINT_CURRENT.md`, this handoff and existing signed R511 ZIP. Do NOT restart analysis from R483 or claim unseen physical PASS; retain the exact source and compilers on feature branch.
