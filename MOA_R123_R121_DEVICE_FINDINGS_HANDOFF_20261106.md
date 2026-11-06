# MOA R123 — user R121 device evidence and calendar/GPS/NAVER safe corrective beta
**Date**: 2026-11-06 KST. **Status**: SIGNED STATIC+ISOLATED BROWSER PASS; R123 REAL GALAXY INSTALL / NAVER EXTERNAL OPEN PENDING.

## 0. Current physical truth (do not overwrite)
- Prior R119 screenshot `19084.png`: Android `앱이 설치되지 않음` -> **R119 DEVICE_INSTALL_FAIL**, exact PackageManager error not supplied.
- **R121 PHYSICAL INSTALL+DISPLAY PASS** by user's actual Samsung screenshots `19091.png`, `19098.png`, `19100.png`, `19102.png`, but the **calendar is clipped below bottom tab** and **R121 NAVER native `nmap://map` external launch FAIL**, toast `등록되지 않은 외부 서비스 연결은 차단됩니다.` Photo date and some precise reverse-geocoded addresses shown in screenshots; another photo reports `사진 원본 GPS 없음` from only the map-index check. Do not infer all native/diary functions PASS.
- R115 immutable user Golden SHA256 `1118bdc249e2d941a899518e58be0185b120a887ff2c371c8f5a01037a5002a8`; R117 user-reported installed/functional reference SHA256 `667e6caa97ffc76b10df15594d5be0672ea892ae0be2692b293161eba94dfdb0`; R121 installed functional candidate SHA256 `3e85d68ad652c5a55eafe01ec31ecbc2129bbea0e56a76eca70c4594b89a094a`. These exact original files are protected.

## 1. Precise reproduction / source cause
- Diary's original `family-diary.js` builds header `fd23-header`, photo-status banner `#fd23-status`, 2-mode chooser, `fd23-hint` (curated description), month, actions, calendar. Original `family-diary.css` includes 78px min day cell, large headings/margins. 5 or 6 rows exceed usable viewport above fixed bottom navigation. R121 only hid lower editor/PC-import/capture controls and did not fix calendar first-screen vertical geometry.
- R121 `moa-r121-ui.js` function `coords(id)` calls **`FamilyJourneyExtension.getData().photos`**, a travel-map georeferenced index. When a specific photo ID is absent (or map index not yet ready) R121 falsely prints `사진 원본 GPS 없음`, **even though EXIF/MediaStore GPS was not read** by this overlay. R121 retry loop updated timestamp only, not photo-location result. Actual original GPS presence is UNKNOWN for that ID; same phone does not prove all photos have location permission/EXIF.
- R121 `openNaver` posts official `nmap://map?...` to **`NativeHost.openUrl`**. The real phone displayed the native rejected-external-service toast, so this **specific route is physically FAIL**. Existing older `fj-naver-favorites.js` already uses `https://map.naver.com/p/search/<query>` via same `NativeHost.openUrl`. Naver official URL scheme `nmap://` is valid in principle but this APK's native bridge allowlist is stricter; app direct launch needs an authorized native bridge change/real device test, not arbitrary WebView scheme guessing.

## 2. R123 signed beta exact artifact
- Filename `MOA_R123_CALENDAR_GPS_NAVER_FIX_BETA.apk`
- Actual base R121 exact SHA `3e85d68ad652c5a55eafe01ec31ecbc2129bbea0e56a76eca70c4594b89a094a`
- New SHA256 **`f9f2553dda70fb0eb8f48787173b0c8593aa590233c4004fe20c3947fadbf58f`**, **5,417,671 bytes**, versionCode **123**, package `com.juhyeon.familyjournea`, same signing certificate SHA256 **`5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`**.
- Old 107 R121 ZIP members: **104 byte-identical**. Changed ONLY `AndroidManifest.xml` versionCode `121→123` one byte, `assets/web/index.html` adds CSS link in head, `assets/web/moa-r121-ui.js` updates overlay implementation while retaining filename/load path. Added ONLY `assets/web/moa-r123-ui.css`. No removed members.
- `classes.dex` ... `classes5.dex`, `resources.arsc`, native camera, raw photo/MediaStore record, `family-diary.js/css`, `fj-naver-favorites.js`, map, user database code, app theme launcher assets all byte-exact R121. No new permissions, no runtime database migration.

## 3. Corrective implementation
- Compact calendar CSS scoped only when `#fj-diary-root` contains direct `.fd23-modes` chooser: hide redundant huge `fd23-header` and explanatory hints; month/mode and day-cell margins reduced; day cells dynamically clamp to 52~73 CSS px. Both **curated/automatic** calendars share this DOM. Preserve 7 columns and full 5-6 week rows; original day detail and editor styles left intact.
- MutationObserver moves **the existing `오늘/일기 백업/사진 다시 읽기` actions** and the photo-statistics banner *below* original calendar grid, preserving handlers and data; nothing deleted. `내가 고른 사진 일기`/`자동 사진 달력` switch remains sticky visible at top of calendar.
- Viewer GPS: re-check current selected photo ID and map GPS lookup for up to 30 seconds if map index is late, update time/date/coordinates/address on photo changes. Explicitly print `지도 색인에서 이 사진의 GPS 미확인 · 원본 GPS 여부는 미검증` rather than making false original-EXIF-negative claims. No guessed coordinates, no foreign-country NAVER direct app button. A definitive original-EXIF read for a map-index-missing photo **still requires a separate verified native MediaStore EXIF bridge**. Do not claim it is implemented by R123.
- Naver button now sends safe **`https://map.naver.com/p/search/<realReverseGeocodeAddressOrAccurateCoordinates>`** through pre-existing exact `NativeHost.post('openUrl', ...)` HTTPS handler, mirroring the formerly working `fj-naver-favorites.js`. It may open NAVER Maps app via Android link association, or web page/browser depending device; **actual external app launch is NOT hardware-verified**. No successful map launch toast forged.

## 4. Verification boundaries
- Exact same-package original signer from private R39 PKCS12 (never exported/uploaded), independent APK v2 RSA PKCS#1 SHA-256 signed-data signature with embedded cert and FULL APK v2 content digest **PASS**.
- ZIP CRC PASS, 37 STORED members 4-byte aligned, resources.arsc identical, DEX SHA1 and Adler32 headers PASS, 104/107 old members byte equal. AXML package/structural IDs preserved, only versionCode one-byte mutation.
- Chromium mobile 393x852 isolated mock PASS: calendar 6-week last row bottom `589px`, scroll root bottom `785px` (all week rows in viewport); mode chooser still visible; original action buttons and banner moved below grid; late-arriving GPS index fixed; Naver command URL HTTPS; switching to photo with no map-index coords shows true ambiguous status and button hides; no real family photos in mock.
- Important: mock not full WebView/native. R123 **DEVICE INSTALL NOT TESTED**, **Galaxy NAVER ACTUAL OPEN NOT TESTED**, **actual GPS of absent-index photos NOT YET READ**, screenshots not representative of real user's photo.
- Emergency original-R121 rollback-forward candidate **R124** generated privately; versionCode124, original R121 107 entries **106 unchanged except Manifest versionCode 121→124**, same certificate, SHA256 `8d7e241fabf34e4dfd97afb72e2665c4644235e856509300b87f71519969a072`. Use only if R123 causes regression; R124 returns R121's known Naver/calendar limitations. Do not present R124 as a bug-fix update.

## 5. Other user requirements / future corrections
- User rejected placing Family Calendar inside `기록`. **PROMOTE to INDEPENDENT FIFTH TAB** in a future separately scoped build: proposed bottom order `일기 | 가족 일정 | 나의 지도 | 기록 | 설정`; old `기록` content remains unchanged. This change NOT part of R123.
- 3D globe still adds optional `2D/3D` toggle to the existing Map without discarding 2D.
- Loglog (actual submitted `loglog-1.0.10-split-apks.zip` package `com.klarwerk.loglog`) research is at `MOA_LOGLOG_REALTIME_SYNC_TECHNICAL_REVIEW_20261106.md`. Its Supabase realtime + offline queue informs optional cross-device architecture; NOT in R123.
- Do NOT mix realtime backend, family calendar tab, native EXIF feature, or native `nmap://` allowlist changes with R123's narrow repair.

## 6. Delivery and next chat
- Current-chat direct APK artifact and keyless QA ZIP only. No email, no public proprietary APK/key.
- Private Library archive names: `/모아_프로젝트_근거_20261103/MOA_R123_CALENDAR_GPS_NAVER_FIX_BETA.apk` and R123 source/QA ZIP/JSON. Preserve exact hash, compare after any materialization. Archived state must be confirmed by Library API, not inferred from filename.
- Before next feature: real Galaxy in-place update/install, calendar both modes + November 6 weeks, photo GPS present/absent, NAVER URL opening, original diary/camera/voice/data regression. R115 and R117 remain immutable.