# MOA R703 map incremental refresh — source WIP, not installable (2026-11-20)

## Verified problem
- User-confirmed: overseas EXIF displays in Samsung Gallery; MOA R701 world map displays it after tapping the manual photo reread button, not automatically.
- R701 private signed APK: MOA_R701_ONEUI_SINGLE_SYSTEM_VOLUME_ORIGINAL_SIGNED_BETA.apk, versionCode 701, SHA256 1a655d25cc81cf97aa6d16c124fb8214c44da55a479fc5d4f5e439bf36e12b6c.
- Package com.juhyeon.familyjournea, original signer cert SHA256 5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15.
- Existing R702 APK is exact R697-function recovery, not an R701-function recovery. Keep private data and both originals untouched.

## Scope of proposed R703
Only auto-invalidate and incrementally update the My Map data layer on Android photo/EXIF changes or on Map tab entry. Preserve R701 OneUI volume, native Gallery classes6.dex, PHOTO native host classes18.dex, diary/calendar, native picker, QuickRecord, Naver, existing media/IDB, version controls and all user data. No full app reload, no repeated full photo reread, no wipe, no uninstall.

## Source work actually done
- New detached branch from R701 source: feature/moa-r703-map-incremental-refresh-wip-20261120.
- Staged experiments/moa-r703/moa-r703-map-delta-refresh-controller.js: debounced map-only event/revision coordinator, stale-event coalescing, hidden-map safety, non-destructive failure retry, no diary/gallery/full-reload calls.
- Staged experiments/moa-r703/test-map-delta-refresh-controller.js: source-level Node assertions.
- Isolated JS execution on the actual newly committed controller: first map entry updates, identical revision skips duplicate update, later revision triggers update — all PASS.
- IMPORTANT: This module is NOT loaded by any app HTML and is NOT in a signed APK. These are controller tests, not end-to-end Android tests.

## Actual R701 integration still required
1. Recover exact signed R701 APK from private Library path /모아_프로젝트_근거_20261103/R701_ONEUI_SIGNED_R702_R697_RECOVERY_20261118/, verify SHA.
2. Extract R701 actual assets/web/app.js, native.js, family-diary.js and map renderer, including exact map refresh handler and the existing FamilyJourneyExtension indexed-photo source. Those proprietary shipped runtime assets are not fully present in the public GitHub experiment source; do not guess method names.
3. Add a cheap changed-media generation check (Android MediaStore or native existing cached index), incremental changed/new/deleted GPS media ID delta, and map-only refresh adapter for the verified original map renderer. Use photo-change signal + tab-entry check, not repeated blind all-gallery scan.
4. Keep map viewport/selection and GPS-less exclusion. Debounce and avoid duplicate event/refresh. If permission/index error occurs, preserve old markers and retry on next entry.
5. Only then load the controller from R701 index.html, with no other changes except necessary narrow native bridge, if the original bridge lacks the revision signal.
6. Build candidate versionCode 703 and companion versionCode 704 exact R701-functional higher-code recovery under original certificate (private Library signer). Verify signer, v2, source diff, ZIP, DEX, package, CRC, original member hashes, Android install compatibility.
7. Physical QA: camera/import overseas and local GPS, map auto-update without reread, return while map open, duplicate and invalid GPS, delete/edit metadata, diary calendar performance, original native galleries/OneUI audio/QuickRecord/Naver, no data loss.

## Actual blocker and release status
The container and Python execution tools consistently returned ClientError for even simple commands. R701 APK was previously materialized but could not be parsed, modified or signed. NO R703 APK is built or downloadable; NO original signer is being exposed or committed. Keep R701 installed unchanged. No claim of complete fix.
