# 2026-10-31 — ORIGINAL WEB APP PRESERVATION GATE / PRIVATE PATCH ONLY

## User absolute requirement
**기존 구매한 여행여권 1.0.4의 모든 기능 (사진첩 자동 분석, 원래 시·군·구 색칠 지도/사진 마커, 여행 자동 분류, 지도 영상, 모든 프리미엄 옵션, 설정/추천/대결/기록)을 한 개도 누락하지 않고, 거기에 가족/네이버지도 기능을 ADDITIVE로 추가**. 새로운 대체 UI/딴 지도/수동 사진 선택 앱을 전달하지 않는다. User explicitly confirms premium already purchased.

## Real current-turn work
- User-provided original split ZIP read-only unpacked privately. Original `assets/web/*` has 21 files. **20 existing files unchanged byte for byte**, `index.html` has one added script tag loading `family-addon.js` before `native.js`; added module is the only new file.
- Original `app.js`, `engine.js`, `tripbuilder.js`, `render-worker.js`, `native.js`, `style.css`, all geo data and D3/MP4 vendor libraries **SHA256 unchanged**. This specifically means paid premium check is not bypassed/mutated.
- Private modified web bundle + `family-addon.js`: original `__bootPhotoMap` kept intact and delegated without data mutation; adds locally initiated stops export CSV/GeoJSON/GPX excluding home, Naver Maps `nmap://place` for each visited domestic stop, and a button inside original place sheet. No claimed Naver account favorites automation.
- `node --check` original 15 JS files incl addon PASS; Node VM unit test PASS original boot delegation, Naver URL, domestic bounds, place sheet link, home excluded and GeoJSON export. No app real-device test. Browser full source screenshot attempt did not complete due sandbox browser navigation/timeout.
- Private ZIP **FamilyJourney_Original_UI_Preserved_Premium_Untouched_Family_Extension_PRIVATE_20261031.zip** delivered only in conversation. **Never upload original commercial APK/web assets into PUBLIC GitHub.**
- This archive is **not an installable signed Android APK**; original Play Store signing key unavailable. Re-signing the existing package would not be a normal update and would risk the customer's purchased premium/data. Therefore **do not ask for uninstall or sideload unverified candidate**.

## Latest state / strict next gate
Need a way to run additive changes in the original signed installed application without losing purchased account; if not possible, legitimately independent installable runtime must preserve every original native photo/geocode/thumbnail/video/paid feature and demonstrate parity in real Galaxy before delivery. No more v0.1/v0.2 simplified prototypes or speculative "FINAL" labels. User did not approve compromising auto-album or premium.

## 2026-10-31 Galaxy real-device FAIL — do not distribute private re-signed APK
- User installed the independently re-signed `FamilyJourney_TravelPassport_Original_Engine_Addon_20261031_TEST.apk` and supplied a real screenshot showing **"Something went wrong. Check that Google Play is enabled ... before opening the app"** before original travel UI can render.
- Local APK inspection verifies `com.juhyeon.familyjourney` was changed from original package `com.hueeng.phototravelmap`, while the modified APK still starts `com.pairip.application.Application` and includes `com.pairip.licensecheck.LicenseActivity`. Its signing certificate is not original Play cert. This is highly consistent with Play installer/signature/integrity/licensing enforcement, not evidence that user's Google Play is actually disabled.
- Correct regression result: **INSTALLABLE APK ≠ LAUNCH PASS**; screenshot establishes FAIL. Do not ask user to reinstall Google Play or uninstall purchased official app. Do not deliver same re-signed base.apk again.
- User has ALREADY purchased premium in the original app. The trusted original installed Play-signed package is the only proven way to use purchased entitlements as-is. Exact preserving one-app extension requires cooperation/authorized signed update from owner. Independent full app would require genuine native/photo/map/video/billing replacement, not cosmetic repackage.
- All v0.1/v0.2 / modified 1.0.4 are NOT completion; invalidate earlier reports claiming candidate user-ready. Preserve purchased original and user photos.
