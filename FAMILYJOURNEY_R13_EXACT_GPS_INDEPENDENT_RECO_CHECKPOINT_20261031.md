# FamilyJourney R13 — exact GPS, no sample, independent recommendation sources (2026-10-31)

## User-reported R12.1 regressions
Screenshots prove: sample travel link still visible; settings still refers to commercial premium, App Store purchase/restore/privacy; recommendation festival cards spin forever; place photo and blog content stopped loading after the publisher API was blocked; existing Naver candidate queue shows only coarse cities (남원/전주), not the exact POI (e.g. 들꽃숲). User wants independent personal app; one APK; no battle; existing map/film/photo functionality preserved.

## Actual R13 work and evidence
- Public Android Host code commits `c5a143d20e3d98d1390505409a0744df3538ce43` (permit user-requested Naver blog search), `5f594670cda86beeb7a595f2a59030b16594472d` (opt-in Android Geocoder per exact coordinate), `0238892c9da7c863f1d32881556e5978c0173549` (versionCode13).
- Android host CI `41168161465`: Gradle build, zip, APK signature PASS.
- Independently signed private v13 package `com.juhyeon.familyjourney`, user-held original web assets re-bundled locally only, **NO proprietary assets in public repository**.
- Deliverable `/mnt/data/FamilyJourney_R13_ExactGPS_IndependentRecommendations.apk`, bytes **3,218,071**, SHA256 **f8044d71823b4aec948779e222bd078b115c2c6d57d5fa56fcb80fd6d6e3d239**, stable signing cert SHA256 **1d471020bbdeccaac105a13ceac4bef95e795a4db17e7c07eef3c971186a396c** identical to user's R12.1, Android versionCode13.
- ZIP fallback same APK. No removal/clearing old data required, no change to purchased official package.
- Private patches: `demo.js` removed from bundled scripts and package; all sample CTA hidden; premium account/purchase/restore/App Store text replaced with personal advanced features UI (existing premium-grade renderer configuration retained); original vendor watermark text replaced with `우리 가족 여행`; old developer support/privacy outbound links hidden.
- Original publisher API base empty + Android outbound allowlist blocks original publisher domain. **Galaxy packet-level 0 egress NOT YET OBSERVED**.
- Independent place-photo lookup calls Wikimedia API using destination **name only** and displays Wikimedia thumbnails with source credit where available. Representative photo is NOT guaranteed for every destination; no original tourism agency feed/image IDs.
- In-app Blog feed is **not yet restored** because original `/blogs` publisher API removed. Original blog detail section now gives honest unavailable notice and user-tapped **NAVER blog search** via newly permitted `m.search.naver.com` instead of never-ending spinner. An independent review API is still needed for thumbnails/titles in-app.
- Festival recommendation had indefinite skeleton loading due disabled publisher `/festivals`; now displays honest no-independent-feed state. **Live independent festival auto-refresh is not finished**.
- **Exact location** Naver candidate queue now reads `DATA.photos` actual individual photo GPS index at 5 decimals (~1m nominal coordinate precision, subject to real GPS accuracy) rather than `DATA.stops[].name` city label. Clusters within 25 meters, strips city-only place names; displays precise coords, builds NAVER map query from coordinate or separately confirmed place name/actual reverse-geocoded address. City name alone must not be stored as POI. User-initiated Android Geocoder uses Android's location provider only for selected points and may send coordinates to provider; no automatic full-photo upload.
- **Actual NAVER account favorites write and read-back NOT IMPLEMENTED**. The PC procedure recently proved by user is still not located among accessible code; never call Naver map open/search an account save. Current queue is locate/review/manual confirmation, not autopost.
- Existing UI/engine/video code otherwise retained apart from exact private string fixes, replacement Wikipedia lookup, and blog/festival no-provider condition. All local test data synthetic; no actual family GPS collected.
- Headless Chromium integration test `/mnt/data/_fj_r13_work/test_r13.py` PASS: sample hidden, premium purchase sheet not opened, two distinct photo GPS POI 50+m apart in the **same** 남원 stop, Wikipedia mocked response loads image, blog detail opens without indefinite spinner, 0 JS page exceptions. JS syntax, ZIP CRC, stable signature, same-package in-place upgrade PASS.
- Galaxy R13 real photo analysis, online Wikipedia service behavior, video export, detailed reverse-address geocoder response and account-saving **NOT YET PHYSICALLY TESTED**.

## Next priority
1. Obtain correct recent **PC favorites save success source** (not 2026-10-24 work-places project with zero real saves) and port its actual NAVER saved-list write/readback to Android with explicit owner action and visible verified success. Never fake.
2. Independent government/tourism festival feed (current no source credentials); in-app blog preview integration using nonpublisher endpoint, with accuracy/attribution; avoid dead cards.
3. Self-hosted photo sources Immich/PhotoPrism/Synology/Google Drive/OneDrive: original UI is preserved but independent Android allowlist and OAuth integration not done; DO NOT claim all online connectors work.
4. Test Android real screenshots and full native automated EXIF + H.264 video regression; privacy network traffic capture; keep exact original UX.
