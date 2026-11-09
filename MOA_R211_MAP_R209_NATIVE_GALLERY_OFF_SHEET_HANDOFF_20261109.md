# MOA R211 — Map / Naver photos use frozen R209 Native Gallery and OFF suppresses bottom sheets (2026-11-09)

## Exact status
**Original-signer signed update APK created; APK Signature Scheme v2 RSA + full signed digest, ZIP CRC/alignment/DEX static checks PASS; local synthetic browser behavior tests PASS; GitHub source hash/syntax contract CI `42539402974` SUCCESS. Real Galaxy R211 install and Map end-to-end QA NOT TESTED. R211 is BETA, NOT GOLDEN.**

The user expressly accepted native Gallery R209 on Galaxy on 2026-11-09 and requested it be preserved as a new **scoped Golden**, while private `19794.mp4` proves Map's place/spot/region photo paths still open old slide-up photo list sheets even with Settings `사진 전체보기 후 목록으로 돌아가기` OFF, and old HTML galleries instead of R209 native.

## Immutable Golden
- R209 exact `com.juhyeon.familyjournea` code209 APK SHA-256 `2491d7cb23f0980c41ec9d09a46a77dcc70d12a567a8b5de135b9e5061451321`, 5,720,522B, signer SHA256 `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`.
- PRIVATE frozen binary and member hashes: `/모아_프로젝트_근거_20261103/GOLDEN_R209_20261109/`, `MOA_R209_USER_DEVICE_SCOPED_GOLDEN_DO_NOT_MODIFY.apk` plus `MOA_R209_USER_SCOPED_GOLDEN_128_MEMBER_FREEZE_20261109.json`.
- Source-only frozen `golden/moa-r209-20261109-user-device-gallery-controls-do-not-modify` and [R209 Golden Lock](MOA_R209_USER_DEVICE_SCOPED_GOLDEN_LOCK_20261109.md).
- R203 inertia user-Golden and R187 older Gallery Golden remain independently immutable.

## Confirmed original root cause
- `assets/web/app.js`: `mapTap` → `openSpot` / `openRegion` / `openPlace` always opened legacy `#place-root` bottom photo sheet unconditionally; sheet tile used `FamilyJourneyNaver.openFullGallery` or `openViewer`, NOT native.
- `assets/web/fj-naver-favorites.js`: `showPhotos` always created separate `#fj-naver-photo-sheet` bottom sheet and `openInternalFullGallery` created distinct old HTML full-screen photo viewer.
- `assets/web/moa-r141-monthly-report.js` R151 setting `localStorage['moa.gallery.return.sheet.v1']` was applied **after** closing viewer, not to initial Map photo sheet creation; previous default was enabled if setting absent. R157 back cleanup only hid the sheet after close, sometimes briefly flashing.

## R211 exact modifications (ONLY 4 APK members)
- **Map OFF or unset:** no initial `#place-root` sheet. Marker, photo-pin, region, home and spot call exact same `window.MoaLocalAudio.openNativeGallery(JSON.stringify(mediaIDs), index, '')` as R209 Diary, with correct raw `123|v` → native `v123` conversion, original mixed photo/video order, and native 10k-item max window. Back closes native overlay directly to same Map screen, no intermediate photo sheet.
- **Map ON explicitly:** retain deliberate legacy `#place-root` photo list, but tapping any actual place photo/video now invokes exact R209 native Gallery; Back restores list when opted in.
- **Naver/GPS photo groups:** OFF directly native without `#fj-naver-photo-sheet`; ON allows sheet, but its photos open R209 native. If native MediaStore rejects media, use only legacy **full-screen** safe fallback, never bottom sheet while OFF. Demo/remote IDs cannot be rendered by native MediaStore and therefore use old full-screen safe fallback; this is limited and explicitly not pixel parity.
- User preference is now strict opt-in `localStorage['moa.gallery.return.sheet.v1']==='on'`, OFF by default; original stored ON/OFF preserved. No diary/voice/backup data migration.
- **Native R209 `classes6.dex` unchanged byte-for-byte**, all user records, video capture controls, zoom, voice recording and map coordinates untouched.

## Signed R211 release exact files
- Package `com.juhyeon.familyjournea`, versionCode211, same original signer SHA `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`.
- Direct `MOA_R211_MAP_NATIVE_GALLERY_OFF_SHEET_BETA.apk`: **5,721,755 bytes**, SHA256 **`ae9d7fb92730e0ff83d3b587d64453bcc5e3b5f4f0002d9ec01b8a66ce40f063`**.
- Paired `MOA_R211_APK_WITH_ZIP_BACKUP_20261109.zip` SHA256 **`dd4e16d511a7c02caf428d9eed90d8584d1ee16a1739330873a9fa31fb8c5f60`**, 5,391,009 bytes; contains the **exact byte-identical APK**, QA JSON, install README and nonsecret SHA manifest. ZIP CRC and internal APK digest PASS.
- Original R209 128 ZIP members: **124 identical uncompressed payloads**, exactly 4 changes: `AndroidManifest.xml` code209→211, `assets/web/app.js` SHA256 `a12b3701b7823d1110a67e0febd8785668f02e32b17b37baff07cc909e3222b3`, `assets/web/fj-naver-favorites.js` SHA256 `a89ba35c00524c7db404048e0ebfa6e55404fc2d546ed8ec321426a5f51d95cd`, `assets/web/moa-r141-monthly-report.js` SHA256 `823f0c6fdfc2f5ee6e3a8ac12729e4284c0d19d11451e0f041b29d17892b9f19`. Native seven DEX and all audio/diary assets frozen.
- PRIVATE Library `/모아_프로젝트_근거_20261103/`: R211 direct APK, exact ZIP, `MOA_R211_RELEASE_QA_20261109.json`, and `MOA_R211_MAP_SOURCE_PATCH_SAFE_NO_KEYS_20261109.zip` (97,082B SHA `d5b62352efa894ccf535275082b32eb10c998e94c555a573ecc9ef7b098cb236`); full web source and patch diffs also archived.
- Complete **signed-release exact source** (GitHub blob SHA checked against local R211 bytes, not a reconstructed approximation): `feature/moa-r211-map-native-gallery-off-sheet-fix-20261109/experiments/moa-r211/assets/web/` contains 3 JS assets; patch diffs and SHA manifest under `experiments/moa-r211/`. Source contract GitHub workflow `moa-r211-map-native-contract.yml`, run `42539402974` SUCCESS. Node --check all 3, SHA256 comparisons to source manifest, synthetic browser routes PASS.

## Local synthetic browser acceptance (NOT actual Android hardware)
- Map OFF => opens native `['101','v102','103']` (mixed photos/videos) and `#place-root.hidden=true`.
- Explicit ON => list sheet opens and tapping tile starts native exact same IDs.
- Missing/empty pref => treated OFF.
- Native unavailable => no OFF sheet, safe old full-screen fallback.
- Naver OFF => direct native `['201','v202']`, no Naver sheet.
- Naver ON => sheet opens, clicking tile opens native not old HTML.
- All tests use dummy IDs and mocked bridges; no family photos, GPS coordinates or real device data published.

## Recovery-only
Signed `MOA_R212_EMERGENCY_R209_GOLDEN_FEATURES_FORWARD_ONLY.apk`, code212 SHA256 **`f1732d91d5c6065883f6e936254ab1c8ba73239d9329f50d271a84b14904aa15`**, exact **127/128 R209 APK member payloads** (only manifest version); signer/v2/ZIP PASS. Matching ZIP `MOA_R212_EMERGENCY_R209_GOLDEN_FEATURES_BACKUP.zip`, sha `54e21372d6691c9bdf9f9fc9e9998649a886e5dc06501982451b7c7ae152e2df`. Private Library only, **NOT routine install and real device recovery NOT TESTED**.

## Required Galaxy R211 QA
With Settings OFF: Map > photo marker, filled region, photo pin/spot, home marker, Naver-photo group → should open **native R209 gallery immediately** without bottom sheet. Swipe photos/videos + play/seek/mute/capture as R209, Back returns Map without bottom photo sheet. With ON: list sheet appears deliberately; tapping media opens R209 native, Back returns list, next Back returns Map. Restart app to verify persisted OFF, and make sure Diary and existing M4A/audio/backup remain intact. If native denies read, note safe legacy full-screen fallback rather than creating sheet.

**R211 remains BETA until Galaxy physical pass.** No uninstall/data wipe, original signer change, user data deletion, signer/material publication, or modifications to AA AirPods/Android Auto daemon/audio routing. Always provide paired direct APK + exact ZIP.
