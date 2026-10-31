# FamilyJourney — CURRENT READ FIRST (2026-10-31)

## User's fixed product goal
One family travel app based on independently implemented ideas inspired by the user's installed travel passport, NOT a modified paid app. Offline local photos EXIF/GPS and timestamps → trips/stops → actual basemap animated videos, visited administrative areas, family maps/passport, potential Naver Map links and (only if officially supported) saved places. Premium-grade features created independently without payment limitations. Both Windows EXE and Android APK, future iOS; public GitHub for source/CI, never publish real family photos, private GPS, home address or tokens.

## This session's real completed work
- User created and authorized PUBLIC repo `yooogillycloud123/family-journey-personal`.
- Main Android source commit `b03b7b84abadc69d6777eedfc6321f5803fd25b4` created 10 files using pure Android Java + Gradle 8.11.1 + AGP 8.9.2.
- SDK bootstrap fixes commits `5691def1dce9d58d8069d91e154209afeeca1f9b` and `cf1da04e14394d7e6f1bd8807adc9dd16d47e03f`.
- Public CI Android APK Actions run **41152890142 SUCCESS**: Android build, APK ZIP integrity, v2 signing verification, artifact uploaded.
- Artifact ID **13023513924**, name `FamilyJourney-Android-v0.1.0-Debug-APK`.
- APK package `com.familyjourney.personal`, version 0.1.0, min API 26, target 35, debug signed.
- Actual SHA256 **b03123e7755e60d84ba03ea307d18a3974c76d5205c7f49d93d3d061edee36c5** (24,241 bytes).
- APK ZIP check also confirmed in conversation runtime after extracting the verified Actions artifact. No real Android device test yet.

## Current implemented Android features (source/build, NOT physical feature PASS)
1. Explicit photo/document multi-select via SAF; no device-wide photo access and no INTERNET permission.
2. Read EXIF GPS and original capture time on device; skip missing data, do not upload files.
3. Chronological grouping into stops/trips; manual optional home exclusion radius 1.5 km.
4. Draw schematic coordinate-based route, save 1080x1920 PNG to Photos/FamilyJourney.
5. Encode 720x1280 H.264 MP4 in worker thread to Movies/FamilyJourney, using native MediaCodec and MediaMuxer, 6 sec demo animation path; hardware/device codec compatibility not yet validated on Galaxy.
6. Synthetic clearly labeled demo data.
7. App label in Korean, one independent package, no ads/billing.
8. Source-only CI static build; install and media read/write to be validated with real phone.

## Important limits and immediate next work
- No real basemap/roads, location address reverse-geocoding, city/province country fill, album index, family sync, recommendations, premium rendering controls, native Naver account automatic saved places, 1080p/1440p MP4, iOS.
- Initial user's **Windows MVP v0.1 source ZIP already exists as a conversation file**, with 8/8 pytest and FFmpeg demo PASS. It has **not yet been pushed to this GitHub repository**; do not say Windows EXE CI completed. Preserve the exact ZIP; add its 13 unpacked source files and run Windows Actions, don't rewrite a weaker Windows engine.
- No original Travel Passport APK/DEX/JS or paid entitlement bypass to be pushed.
- Android real hardware tests pending; distinguish CI APK build PASS from photo picking/GPS/video physical PASS.
- Publish code/CI only, never any real family location/photographs. Use .gitignore.
