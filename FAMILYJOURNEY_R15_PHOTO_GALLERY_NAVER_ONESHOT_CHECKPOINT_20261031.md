# FamilyJourney R15 — photographed-location gallery + NAVER one-shot save assistant, 2026-10-31

## Latest user input (authoritative)
- Existing R14 presents ~380 GPS visit candidates, and user approves the 25 m precise grouping rather than city-level saves.
- User wants to **see which original photos contributed to each 25 m location**.
- PC version has already saved exact places into NAVER account automatically according to user, so manual "open Naver and confirm" is not an adequate final Android feature.
- No recommendation/battle tabs; preserve map, Korean names, records, video/advanced options, on-device media scanning, original installed paid app separated, zero original publisher communication.
- Recent successful PC script was NOT found in available connected repo/Library/personal context. Never confuse it with 2026-10-24 national office location project or 8/2026 code; do not invent its control selectors.

## R15 actually implemented now
- `fj-naver-favorites.js` in a PRIVATE, user-owned source bundle now shows **"이곳 사진 N장 보기"** on every 25 m candidate; it retrieves actual MediaStore photo IDs from the cached original `DATA.photos` and original `window.__requestThumbs` native bridge. On tap shows 3-column scrollable on-device thumbnails; another tap uses new `openPhoto` Android intent to view the original full photo. No upload.
- Photo tile counts are limited to up to 180 IDs on screen; old candidate place grouping unchanged. A cluster's thumbnail map is not hardcoded and reflects user's real photo location.
- Added opt-in `NaverSaveService` Android AccessibilityService **packageNames=com.nhn.android.nmap only**, non-exportable externally without BIND_ACCESSIBILITY_SERVICE, service disabled unless explicitly enabled by user in Android Settings. A single job expires after three minutes. Job begins via `naverArm` bridge, opens official `nmap://search` with exact user-confirmed POI name; user picks correct POI in NAVER Maps; service then attempts visible Save and chosen saved list, and recognizes only UI-confirmed `저장됨/저장 완료` state. A different screen cannot cause fabricated status.
- Current app does **NOT** choose an ambiguous NAVER result automatically, does NOT write via a supported NAVER favorites API, and the service's UI labels have **NOT BEEN VALIDATED on user's Naver Map version**. So **PC-grade fully automatic account favorites registration is NOT COMPLETE**; R15 is a testable, owner-initiated single-place Accessibility assist, not a verified saved-place feature.
- Native HostActivity `openPhoto` validates MediaStore numeric ID; `naverArm`, `naverStatus`, `naverCancel`; Android Manifest XML includes restricted service and queries package.
- Existing user WebView core files `app.js`, `native.js`, `tripbuilder.js`, `engine.js`, `render-worker.js` byte-identical to R14. No proprietary web assets in public GitHub, only native code/manifest.

## Exact evidence
- GitHub Actions `41171064433` Gradle compile, APK signature, artifact PASS for the new native host.
- Local private signed integrated APK: `/mnt/data/FamilyJourney_R15_PhotoGallery_NaverSaveHelper.apk` 3,238,699 bytes SHA256 `e88f694f7dea0831840c245a5afca2c11c111fe63c71dc12af20a54386d55dd8`. versionCode 15, package com.juhyeon.familyjourney, signer SHA256 `1d471020bbdeccaac105a13ceac4bef95e795a4db17e7c07eef3c971186a396c` (matches R14, update-in-place).
- Android v3 signature PASS, APK CRC PASS, precise photo JS syntax PASS.
- Chromium test: 3 actual-style synthetic photo IDs in one cluster, opened gallery with 3 photos, full original photo handoff sent `openPhoto id=100`, Naver one-shot arm sent with exact name `들꽃숲`, 0 JS errors. Original R14 cached-map Chromium navigation test passed, ~2.59s in headless browser with fake cached data (NOT a real phone timing).
- **No real device NAVER UI run or account save confirmation** and no phone original photos/gallery validation yet. Do not say original user account auto save was achieved.
- User's original TravelPassport Play package must not be uninstalled and is unaffected.

## Immediate next step
Real Galaxy NAVER save screen inspection/test with R15's opt-in service and proof of saved list insertion; then automate safe serial queue. Never label a click as confirmed save without app UI readback. Prefer getting recent user's known-good PC save driver if available, but user does not need to repeat the description of the goal.
