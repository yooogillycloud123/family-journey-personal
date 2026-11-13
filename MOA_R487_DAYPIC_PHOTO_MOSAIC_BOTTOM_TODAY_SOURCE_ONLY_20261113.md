# MOA R487 DayPic photo-first calendar — SOURCE + BROWSER QA, NOT SIGNED APK
Date: 2026-11-13 Asia/Seoul

User rejected R483's ordinary-looking month calendar, large exposure of the following month, and top-right Today button. User explicitly supplied DayPic photo mosaic inspiration and a video showing a brown bottom Today navigation bar. R463 remains the only user-approved Golden.

## Exact implementation
Based on signed R483 (versionCode483, SHA256 dcd4ff0f5b623b4503c133d83d38d4c9dd39499b01c89c7691581a8980ecc408) and its exact source. The new isolated branch changes only `experiments/moa-r483/moa-r483-vertical-calendar.js` and `.css`.
- Calendar month becomes a full-height 7-column photographic mosaic; rows expand according to the actual 4–6 weeks of each month. Following month is below the fold initially, yet vertical month-by-month touch scroll remains.
- Duplicate per-month displayed heading removed (accessible heading retained), year/month picker and tiny two-state curated/all photo switch preserved.
- Upper Today button removed. One full-width warm-brown "오늘 달력으로 이동" bar sits directly above the original bottom five-tab navigation.
- Existing full-tile Today border and photo-free 9px family event marker remain. Async family markers are now inserted into the reserved event lane, not photo region.
- Bounded 18-month virtual-feed trim used to jump backward due double scroll adjustment; remove the redundant manual corrections so Chromium's own anchored layout preserves the visible month. Original R483 month creation/owner and all diary data functions unchanged.
- Original R463 native 17 DEX, diary/voice/storage/quick record/Naver assets and actual signed APKs are UNMODIFIED.

## Verification
- Node JS parsing PASS.
- Synthetic Chromium 420x870 and 360x780 PASS: initial next month visible 0px, bottom Today dock touches bottom tab boundary, photo tiles render, year list 201 and month choices 12, family event line in 9px lane, day opens and Today returns to November.
- Stress QA 20 months down and 20 back up, including 18-section trim/prepend, PASS in headless Chromium after corrective patch; no JavaScript errors.
- Screenshot images use SYNTHETIC placeholders. Real Galaxy/14k media/DB/Naver/advanced Gallery physical verification NOT RUN.

## APK blocker — do not misrepresent
The original R483 signed APK and R485 exact R463 functional recovery are preserved in private Library folder `/모아_프로젝트_근거_20261103/R483_VERTICAL_CALENDAR_R485_RECOVERY_20261113/`.
R485 SHA256 d5639c07a34e963c679a0a772a16c25845d0ce530e237f88ab6261cf535901c3 (versionCode485).
This session DOES NOT have the original APK's private signing key or an authorized original-signer signing service. A modified APK cannot be update-installed with a different certificate. Thus R487 changes are COMMITTED SOURCE ONLY, not an installable same-signer APK; never claim built/verified device APK. When authorized original signing is available, create code>485 original-signed candidate from frozen R483 with ONLY the two updated assets and Manifest version increment, verify all original 17 DEX bytes, APK v2 RSA full digest, original cert, and install-in-place. Do not uninstall/reset app or Naver cookies. Do not relabel R487 as Golden before physical testing.

Source path on this feature branch: `experiments/moa-r483/moa-r483-vertical-calendar.js/.css`.
