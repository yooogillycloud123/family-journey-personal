# MOA R131 — 일기 날짜별 사진·영상 연속 스크롤 (2026-11-06)

**Status:** APK_SIGNED_STATIC_PASS + INDEPENDENT_APK_V2_PASS + CHROMIUM_MOCK_PASS; **Galaxy R131 installation/photo scroll PENDING**. No fake device verification.

## User's precise request and current physical baseline
- User physically confirmed R129's **original rounded Map place-photo bottom sheet** remains displayed, with all photos auto-appearing while scrolling inside it, without pressing **사진 더 보기**. They now want **the same continuous scrolling behavior inside Diary**, not a new full-screen viewer or changed calendar layout.
- Map photo sheet, original close and navigation, curated diary, automatic photo calendar, original date-to-photo linkage and all user data must stay intact. Do NOT move Diary to Map, delete the original sheet or replace it with a different UI.

## Exact implementation
- In protected original `assets/web/family-diary.js::renderDay()`, the day's 5-minute groups each display up to 12 initial media, with video first pass, followed by an existing `.fd31-more` button that calls the old closure to append the next 30 media in the **same existing `.fd23-strip`**. Changing that JS and its IndexedDB semantics is unnecessary.
- R131 adds **two new small assets** `assets/web/moa-r131-diary-scroll.js` and `.css` and references them after all earlier UI patches in `assets/web/index.html`.
- In Diary Day (`FamilyJourneyDiary.state.page==='day'`), the original `.fd31-more` buttons remain in DOM with the exact original `.onclick` closures. UI hides their visual presentation while leaving a **1px positional sentinel** for scrolling. An added passive Diary root scroll listener checks near-visible sections and calls exactly **one original button click per ~230ms**, loading the next 30 original tiles/MediaStore thumbnails in that existing 5-minute group. No new backend call, no reordered photos, no additional re-render or photo copy.
- In Diary media picker (`page==='picker'`), the original renderer already implements 60-at-a-time scrolling in `renderPicker()`: R131 hides just the redundant `.fd32-more` manual button; the original bound picker scroll handler remains responsible for batching/selection/foot actions. No new duplicate paging.
- The helper observes only Diary root's direct child renders/hidden attribute, not every thumbnail mutation or entire document subtree. Initial lazy Diary mount is discovered via body direct-child observer. Other pages, map, photo full viewer, and calendar remain unmodified.

## Signed APK identity and file-level diff
- Base exact installed/user-accepted R129: `MOA_R129_ORIGINAL_PLACE_SHEET_SCROLL_FIX_BETA.apk` **SHA256 `54d0323e6ea7ab8be8bc1323a8a24ff364cb04ea643a7535ce7e78e173d16579`**, code129, 112 ZIP members.
- New signed `MOA_R131_DIARY_CONTINUOUS_SCROLL_BETA.apk`: **5,429,713 bytes, SHA256 `eb9693092c75a88acab51fc19c0c716e11262aeaca1e9416952a6781b80e680c`**, package **`com.juhyeon.familyjournea`**, versionCode **131**, original signer cert SHA256 **`5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`**.
- Existing original members 112: **110 byte-identical**; ONLY changed `AndroidManifest.xml` (binary typed code129→131 at the previously verified one-byte position) and `assets/web/index.html` (two ordered asset references). ADDED only `assets/web/moa-r131-diary-scroll.js` and `assets/web/moa-r131-diary-scroll.css` (114 total). No removals.
- `classes.dex`–`classes5.dex`, `resources.arsc`, `app.js`, `family-diary.js/css`, `fj-naver-favorites.js`, `moa-r127-fixes.js/css` (R129 Map place scroll), calendar CSS/JS and all photo/data storage handlers unchanged. Same package/cert; no account setup, permission changes or user data clearing.

## Evidence and QA
- Prior R129 SHA and v2 content digest asserted before build. Independent verification script re-parsed APK v2 block and validated RSA SHA256 signature, entire APK content digest and exact original certificate; ZIP CRC, 37 stored member alignments, 5 DEX SHA1+Adler headers and byte-by-byte member diff PASS.
- Node `--check` PASS. Chromium mobile 393×852 **mock** of original Diary DOM with two 5-minute groups of 137+68 photos loaded **12→42→72→102→132→137 and 12→42→68** on scrolling; time labels retained; original more buttons hidden; re-render and picker presentation PASS. Picker original real native data/picker handler not exercised in this isolated mock and is protected/unchanged.
- **R131 real Galaxy installation, actual all photo thumbnails, app data, advanced diary editor and scrolling behavior PENDING.** Do not call user Golden yet. Exact historical R115 Golden and R117 tested baseline untouched.

## Fail-safe and next version
- Emergency-only **R132** APK created from exact R129 payload + manifest code132 and original signer, SHA256 `27266d1fbddac0e7a7dba39c4f4863bcae1049e8270ed975b4a7c6857c3e515c`, 5,427,709 B. NOT a normal update; restores R129 if R131 regressions are confirmed, but no user data rollback and no uninstallation.
- Next new feature version **>=133**. The separate independent **fifth 가족 일정** bottom tab, offline family-calendar DB, later Loglog-style opt-in PC/spouse realtime sync and Map 3D Globe are future distinct releases, NOT included in R131. Do not pretend family scheduling is built.
- Private Library artifacts: `MOA_R131_DIARY_CONTINUOUS_SCROLL_BETA.apk`, `MOA_R131_SOURCE_QA_NO_KEYS.zip`, `MOA_R131_QA_REPORT.json`, `MOA_R131_INDEPENDENT_VERIFICATION.json`, this handoff, `MOA_R132_EMERGENCY_RESTORE_R129_NOT_ROUTINE.apk`. Keep keys, passwords, personal family photos/GPS out of GitHub/public zip. Download delivery in current chat only; never email. Avoid `Library file not found` by attaching freshly verified current-chat APK and alternative ZIP.