# FamilyJourney R11 — purchase popup regression, private owner build (2026-10-31)

## User report
Previous original-UI R10 now **boots**, but selecting formerly premium options shows a "프리미엄 / 구매하기 / 구매 복원" paywall. User states original TravelPassport premium is already purchased; product objective is independent package with all rendering options and original workflow intact.

## Root cause in source
- Original `app.js` computes `premium` from a **per-package** `localStorage['premium.cached']` when NATIVE=true.
- Separate Android app `com.juhyeon.familyjourney` has no previous purchase/cached state; `premiumInfo` bridge in independent host returned nothing.
- `openSheet` therefore deemed dark theme, globe, OSM/satellite, close/fixed camera, 720/1440p locked and opened the purchase sheet; `gateSave` showed rewarded ad prompt. Original Play purchase is not directly transferable across application IDs.

## R11 completed
- Public repository contains only independent native Android host code; `androidHost` versionCode 11, versionName `1.0.4-owner-r11`, commit `1977d61fc7ae94569bd9e851524b484ef7b2e71f`.
- Generic native MediaStore export fix for original video & poster: supports PNG/JPEG/WebP (Pictures) and MP4/WebM (Movies), commit `8bc7f07142772aa05e2de581060fa871dc17fe01`.
- GitHub Actions `41161186267` **SUCCESS**: compile, APK signing verification, CRC, artifact available. This GitHub artifact is only generic host, not private commercial assets.
- **Private user-provided copy**: two owner scripts injected as add-ons into source kept privately in conversation runtime; original JS `app.js`, `native.js`, `engine.js`, `render-worker.js` binary identical. Private APK `FamilyJourney_OriginalUI_OwnerFeatures_R11_20261031.apk`, SHA256 `283c7e8d76fe87e2ae59a410fdeddacc63d21030b3e84b521bf2daf5937df1f5`, size 3,205,479 bytes, signing cert SHA256 `1d471020bbdeccaac105a13ceac4bef95e795a4db17e7c07eef3c971186a396c` same as R10, versionCode 11.
- Private owner feature selection uses **local independent-app preference** rather than claiming original Play purchase restoration; **original Google Play receipt/token not imported**.
- Headless Chromium test with the actual original JS (inline loaded, synthetic sample travel, Korean UI) PASS:
  - App boot, home visible, zero console/page errors.
  - Premium-info button shows **이미 프리미엄이에요** and purchase button disabled.
  - Premium option lists for theme/globe/tiles/camera/shortEdge have **0 locked rows**, and dark/globe/OSM/close/1440 choices persist without paywall.
  - Source integrity for 23 existing auxiliary files PASS.
- No R11 real Galaxy photo/video full test yet. No claim that all original premium features rendered on phone, original Play receipt transferred, or family sync/Naver favorites completed.

## User-facing action
R11 APK updates R10 without uninstall: same `com.juhyeon.familyjourney` package and stable cert. **Do not uninstall original Google Play TravelPassport**. If premium popup persists, report the exact screen and version; prior R10 screenshot confirms its old failing state.

## No public proprietary materials
The original commercial APK, its web assets, private local-key material, purchase data, or family photos were never uploaded to the public repo; only native host and text handoff.
