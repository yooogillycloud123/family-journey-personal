# MOA R133 — 일기 날짜별 사진목록 시트 + 사진·영상 혼합 뷰어

**2026-11-06 · 신규 업데이트 후보 · APK_SIGNED_STATIC_PASS / ISOLATED_CHROMIUM_MOCK_PASS / GALAXY_R133_PENDING.**

## User physical evidence / regression
- User installed R131 on Galaxy and supplied `19148.mp4` (34.76s) and `19149.mp4` (11.68s).
- Map flow: Map place → full-screen gallery → Back → original rounded Map place-photo sheet with scroll.
- Diary flow: Diary day → photo tile → full-screen photo-only gallery → Back → original diary day timeline, **no analogous day-photo sheet**. User asked for the analogous overlay.
- Mixed video/photo day: Original `family-diary.js` `videoFriendlyTile()` routes a video directly to native `diaryPlayVideo`, but photo uses `openGallery(...)`. That `openGallery()` filters `photos.filter(p=>!isVideo(p))` then calls `FamilyJourneyNaver.openFullGallery(photoIds)`. Video and photo are thus never in one swipe order. This is **confirmed implementation split**, not a technical impossibility.

## Exact R133 implementation, change safety
- Based on exact R131 signed APK SHA-256 `eb9693092c75a88acab51fc19c0c716e11262aeaca1e9416952a6781b80e680c` (5,429,713 B, versionCode131). User reported installed, but workflow regression remains.
- Signed R133 APK `MOA_R133_DIARY_MIXED_GALLERY_RETURN_BETA.apk`, **versionCode133**, size **5,438,184 B**, SHA256 **`f4fa987e987782818f84b758682bb6c967155cf8572a20fea1a82b6d3e5034f1`**, package `com.juhyeon.familyjournea`, original signer cert SHA-256 `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`.
- Original R131 **114 ZIP entries; exactly 112 unchanged bytes**. Changed old members only `AndroidManifest.xml` (one-byte code131→133) and `assets/web/index.html` (loads two modules after R131). Added `assets/web/moa-r133-diary-unified.js` and `assets/web/moa-r133-diary-unified.css`. No removals. All 5 DEX, original `family-diary.js`, all original IndexedDB code, native photo/video code, MediaStore, Map, original R129 place sheet, R131 continuous scroll, R121 GPS overlay and R115/R117 frozen base remain unchanged.
- New diary-specific date media view: clicking any original diary photo/video tile intercepts only the diary day tile's default action. The new original-style rounded date bottom sheet remains mounted underneath the mixed full-screen viewer. Android hardware Back (when intercepted by original browser hook) / `← 목록` closes **only viewer** and reveals original-style sheet (3-column thumbnails, scroll pagination). Closing sheet returns original Diary day and original diary timeline, with title/memo/5-minute groups untouched. A new `▦ 이 날짜 사진·영상 전체 보기` action opens the sheet directly without opening a viewer.
- New mixed viewer order built **solely from existing Diary `state.byDay`/`state.byVideoDay` / curated selected IDs**, in timestamp order, filtering `removedMediaIds`. Stable missing metadata handling; no guessed GPS or dates. Photos load via existing `https://familyjourney.local/fj-photo/<id>.jpg`; video items show native thumbnails via existing `__requestThumbs`, with an explicit `▶ 동영상 재생` action dispatched to the **existing native** `diaryPlayVideo` player. No video recode, no copying/saving media to cloud. A native video player is still a separate Android surface: **true inline `<video>` playback was not implemented or proven**. On return from the native player, the mounted mixed viewer is designed to remain for continued left/right swipe; must be confirmed on Galaxy.
- Original photo share/open-in-gallery and video share/open-in-gallery call unchanged native commands for current mixed item; per-image metadata section keeps fixed 96px size. Existing MAP-only original sheet and photo-only gallery are untouched.
- The new date sheet starts with 30 tiles and automatically appends the next 30 near the bottom as the user scrolls, no `더 보기` button. Thumbnails are requested in chunks (15) with a small in-memory cache; no original photos or database writes.

## Static / browser testing
- Independent APK v2 RSA signed-data verification and **entire APK v2 SHA-256 content digest**, identical cert, ZIP CRC, 37 STORED alignments, 5 DEX SHA1/Adler headers PASS, package/manifest typed versionCode PASS.
- Isolated Chromium mobile 393×852: photo → video → photo in one 76-item chronological gallery, real command name/ID `diaryPlayVideo` invoked on video tile, Android Back handler brings viewer → sheet (sheet persists), scroll reaches 76/76 in 3 columns, opening item 41 then returning works, sheet close returns original diary day, curated filtering excludes removed image without losing selected video, JS pageerrors zero: PASS. No actual family media were supplied to browser fixture. **R133 Galaxy install, native video playback/return and original data regression NOT TESTED**.

## User device acceptance
1. Update over existing R131, DO NOT uninstall/clear app data. Open Diary → either `내가 고른 사진 일기` or `자동 사진 달력` → date containing photos+videos.
2. Tap photo, swipe to a video position, press ▶ and play in native Android video player, close that native player: check whether unified gallery remains on same video and swipe proceeds to next photo. If the activity reopens Diary instead, record FAIL and fix the native lifecycle using exact device evidence.
3. Full-screen `← 목록` and physical Back both reveal **scrollable date sheet**; scroll down many photos; sheet Close returns original diary day. Native MediaStore ID, original text/memo/5-minute groups and photo selection remain intact.
4. Check GPS/date/quality, photo pinch/swipe, share, Map old photo sheet, calendar navigation, old diary writing, native quick capture and stored data. Treat untested as PENDING.

## Next feature / recovery
- R134 emergency-only exact R131 content with code134, signed with the same cert, SHA256 `b71a180fe241f68debfa08c962ed818e389f04f82d3a849fe19a4aa86f8c3db9`. This is a **revert-forward only**, not a routine APK and restores the old R131 photo/video split and no-diary-sheet behavior. Do not uninstall.
- Separate fifth main `가족 일정` tab and offline-first calendar, optional PC/spouse Supabase sync and 3D globe **not implemented in R133**. R135+ for new feature after R133 device verification.
- Private Library stores APK, source/QA, independent report, R134 emergency copy. GitHub holds only non-secret handoff and append-only ledger. Never email or upload private photos/signing keys.