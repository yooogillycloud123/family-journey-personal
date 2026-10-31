# FamilyJourney R28 WIP — video share + original app icon + photo/video EXIF GPS diary (2026-10-31)

## Canonical priority
- Installed user-proven working baseline: **R27** `FamilyJourney_R27_VideoDiary_LayoutRestored.apk`. Do not uninstall, clear data, change appId, or regress diary CSS.
- This R28 file describes **incremental source work in progress, NOT a released/signed R28 user APK**. Do not tell user it's installable or that all 3 features work on Galaxy.
- Windows/iOS remain on hold.

## User screenshots and requested changes
1. R27 photo fullscreen has `공유 · 카톡 등` and `갤러리에서 열기`, but native video fullscreen only has `일기로 돌아가기` and MediaController. Add those actions to **video playback itself** without copying MP4; keep existing gallery/pinch photo functionality. Screenshot also shows photo gallery title literally `[object Object] · 사진` — JS title type coercion must be repaired in exact private `fj-naver-favorites.js` when available.
2. Launcher icon remains generic Android grid with `우리 가족 여행` app name. User wants own clean Instagram-class visual identity; **name remains 우리 가족 여행**, no trademark imitation, gradient blue/violet camera-heart icon.
3. Diary timeline displays only capture times. Add per-media original EXIF GPS (if present) + coordinate label under time row, exact NAVER Maps marker link, and optional address lookup. No location-less guessed city/place. Video GPS may genuinely be missing. Do not geocode entire 13k gallery automatically. No private GPS/background upload.

## Source changes already completed in public native repo
- `HostActivity.java`: Within `playDiaryVideo`, added native bottom buttons **공유 · 카톡 등**, **갤러리에서 열기** for selected original video; native Android ACTION_SEND share URI and ACTION_VIEW with Samsung Gallery fallback.
- `HostActivity.java` bridge:
  - `diaryMediaLocation {request,id}` reads one image EXIF original GPS via `MediaStore.setRequireOriginal` where permitted, or one video `MediaMetadataRetriever.METADATA_KEY_LOCATION`. Async callback `window.__fjDiaryMediaLocationResult(request,{id,hasGps,lat,lon})`. No bulk raw video conversion.
  - `diaryOpenNaverPlace {lat,lon,name}`: documented Naver `nmap://place?lat=...&lng=...&name=...&appname=...` link for valid Korea coordinates, preserving exact marker.
  - `diaryReverseAddress {request,lat,lon}`: explicitly triggered Android Geocoder; callback `window.__fjDiaryAddressResult`. Do not request at startup.
  - `injectOwnerDiaryLocationAddon()` loads separate owned JS asset safely after local WebView document finished.
- Original resources `res/drawable/ic_family_journey_background.xml`, `ic_family_journey_foreground.xml`, `res/mipmap-anydpi-v26/ic_launcher.xml`, app manifest launcher icon reference updated. Label/package unchanged.
- `androidHost/app/src/main/assets/r28-diary-location.js`: own privacy-friendly nonproprietary API `FamilyJourneyDiaryGeo.attach(container,mediaId)`, async GPS chip, NAVER exact marker tap, address tap, `safeTitle(place)` string/object normalization. **Private `family-diary.js` must call attach() from actual selected timeline/group render function**. As of this checkpoint, the addon exists but private diary render integration is NOT completed.

## Quality gates
- Android native CI `41193568377` success after video share & GPS getter.
- CI `41193632119` success with vector adaptive icon.
- CI `41194010232` success with NAVER link/address bridge.
- New asset JS parsed successfully in V8 `new Function`.
- Check newest CI after injector commit `fabb635b3f4f608858aaccbd02b5c4ebc486d07d`.
- No signed R28 APK currently. This sandbox does not mount historical `/mnt/data/_fj_r17/signer` or prior R27 private APK. The R27 binary appears as a Library entry but `files.materialize` returns `This Project file does not have an authorized raw-byte materialization path`. **Do not package a blank host or claim upgrade compatibility from public CI**. Need actual private R27 APK bytes and matching owner signing key in a secure build runtime to deliver user-installable R28.

## Required before R28 release
- Obtain original R27 private APK and owner signer **through authorized secure workflow**, never upload signer to public GitHub.
- Extract current full private `assets/web/family-diary.js`, `fj-naver-favorites.js`. Patch only safe minimal integration: call `FamilyJourneyDiaryGeo.attach` under each displayed time/media group with exact MediaStore id; prefer captions and GPS only if original GPS actually present; avoid lookup for videos without geo. Fix `[object Object]` gallery title by formatting object fields instead of coercing object to string.
- Require R27 diary CSS baseline 10,847 bytes intact, original map/video/navigation/diary JS byte-diff limited to intended changes, ZIP CRC, package, versionCode28, same signer SHA256 `0d25313c1a6f769d1a9b43ea9d3b7a4626a12924a887062ad25dc69907fbad09`, Android v3 signing, in-place update.
- Test real Galaxy video share chooser + Gallery open, icon installed and visible, exact photo GPS/blank videos, correct NAVER pin, user-click address, saved diary persistence, selected/auto calendars independent, photo fullscreen smooth/pinch.
- NEVER mark R28 final until actual owner signed APK plus physical phone verification.
