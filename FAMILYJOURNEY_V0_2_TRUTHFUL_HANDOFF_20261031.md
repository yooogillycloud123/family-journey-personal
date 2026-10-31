# 2026-10-31 — ORIGINAL SCREENSHOTS PRIORITY, v0.2 BUILD HONEST HANDOFF

## User's confirmed priority
- Original **여행여권** app's actual polished UI, not the primitive v0.1 prototype.
- Screenshot layout reference: 방문지도/사진 썸네일/전국 시군구 색칠, 여행선택, 제목·문구, 실제지도 스타일·비율·테마, 미리보기/영상저장.
- Premium-grade functionality usable in the independent family app, original family photo privacy, future Naver Map integration. User does NOT want empty claims or multiple helper apps.

## Source analysis
- User supplied `여행여권-1.0.4-split-apks.zip`; original base.apk web UI assets: `assets/web/index.html`, `style.css`, `app.js`, `engine.js`, `tripbuilder.js`, `render-worker.js`; original is web UI inside Android wrapper. Read-only inspection observed source says **1080p default free**, premium toggles options `theme/mapMode/tiles/camera/shortEdge` and `photoDots/emoji/watermark`, not all video functionality is paid. This is an observation, not permission to publish original proprietary code.
- Do not publish original APK assets in PUBLIC GitHub, and do not misstate purchase-entitlement modifications as independent capability development.

## Actual independent v0.2 candidate work
- Commit `76f57480b09d95b1d0c349915897f739c30197eb`: Author-created WebView UI screens: 5-tab home, map with online OSM tiles + GPS stops + polyline, trip selection, wording, aspect/theme, preview/save. Native photo picker + optional gallery scan, local EXIF parsing and route grouping, PNG screenshot and prior 6-second schematic MP4 exporter.
- Commit `ae884fb87f37082f05ad8aba7cca1d1c9a705992`: versionCode 2 versionName 0.2.0.
- GitHub Actions run `41155129309`, all build/APK integrity/signature steps PASS, artifact `13024718060` (current zip named artifact `FamilyJourney-Android-v0.1.0-Debug-APK`, though APK internally version 0.2.0). Signed debug APK SHA256 `5ae671d4de9ccf228044d4cde2968087a61c219c273e90a7fc306218adb25b10` (42296 bytes).
- JS syntax check with V8 `new Function` PASS; browser setContent and synthetic travel data wizard click navigation PASS. Real Galaxy install, EXIF access, large gallery read, maps tile display, codec saving NOT physically tested.

## Known gaps — do not call original-level parity complete
- Web UI is a **new independently authored interface**, not original `여행여권` UI. Photo bubble thumbnails, actual municipal polygons and shaded visited areas, multiple styles, polished original map renderer, passport/recommendations/rankings/contacts/family sync, all premium-grade effects are **not implemented**.
- Screen selected 15/30/60 seconds, aspects and theme affect only UI; currently MP4 export STILL invokes prior fixed 6-second schematic native VideoExporter. It does NOT encode online basemap or selected style/resolution. UI says this honestly.
- User explicitly complained previously about unfinished substitutions; do not ask them to reinstall a stream of helper/test apps and do not call v0.2 final.
- Reconcile design and functionality honestly rather than claiming paid entitlement bypass or AirPods OSS project is identical to commercial travel app.
