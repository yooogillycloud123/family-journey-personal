# MOA R697 — R694 failure forensics / R695 current user state / native multi-delete safe repair

Date: 2026-11-17 (KST). **R697 is signed STATIC-QA-PASS BETA, NOT Samsung physical PASS.**

## Current truth (user correction)
- User installed **R694**, confirmed **representative cover-first placement works** and the permanent bottom-icon registry guideline was created. PHOTO expanded Gallery and multi-delete/independent icon-order were **NOT physically verified**.
- User tapped the PHOTO inline trash to try multi-delete but only one item was deleted, and afterwards the PHOTO main native Gallery **stopped rendering**. The intended multi-select UI did not appear. Therefore R694 is **user-physical FAIL** and MUST NOT be treated as Golden or reused unchanged.
- User clarified rollback was **R695** (an exact R691-functional forward recovery), **NOT R692**. This supersedes earlier assistant confusion.
- Immutable **R683 user-physical Golden** exact SHA256 `e20e446d5e02358e833fe223471735abc3fd042234b4efc53acc208118ee9e8b` remains protected.
- Latest signed user-installed baseline: `MOA_R695_EXACT_R691_FUNCTIONAL_RECOVERY_ORIGINAL_SIGNED.apk` SHA256 `8581e32e8d293c2341f506529967e32cd1b9b5389b55524951fdc9f85e51d1fd`. Protect app data, indexed diary records, Naver login and original MediaStore images/videos.

## Exact failure path in R694 source
1. `r694OpenDeletePicker()` invoked `r439Call(e.gallery,"close")` BEFORE scheduling `window.MoaR694MediaUI.openFromNative(...)` by 130 ms. The original R523/R567 native close owner could interpret this as user leaving day/host, so the delayed JavaScript modal callback had an invalid/stale day and never became visible. **This is source-based failure risk directly consistent with reported symptoms; no phone log to prove exact last callback.**
2. `batchExclude()` called `MoaR469SimpleDiary.openDay(day)` after IndexedDB commit, reopening a page already active instead of using its existing live media/Native Gallery update. That additional whole-day ownership transition could leave PHOTO stage/gallery blank.
3. The 8-item original R570 inline long-press implementation may install its handler after an R694 9-item handler, so a saved-role signature that prevented rearming the 9-item handler allowed the old 8-icon menu to reappear.
4. R694's mock tested database tombstones but did **not** run actual Android original Gallery, real-screen multi-select visibility or gallery survival. A prior GitHub source-hash CI gate had failures after source changes; updated source hashes subsequently passed. R694 user-physical failure remains authoritative despite static PASS.

## New safe behavior in R697
- **Native Android AlertDialog containing actual local MediaStore thumbnails and multi-select checkboxes** displayed above the STILL-OPEN original native Gallery. No `close()` is executed before the picker. Current item initially selected; users may select multiple, Select All, Clear, Cancel, then explicit confirm to exclude from diary only. Cancel does not mutate Gallery nor IndexedDB.
- Selected `ids` and date are validated against the existing original Gallery/current calendar. A single committed IndexedDB write updates only selected diary `photoIds`/excluded `removedMediaIds`/day-cover metadata. **Never delete physical files**. Keep existing `moments`, diary body, voice, QR/QuickRecord, GPS and Naver.
- PHOTO inline after successful commit calls existing **R592/R602 same-day live playlist refresh**, not `openDay()`. [Exact original native card source](https://github.com/yooogillycloud123/family-journey-personal/blob/golden/moa-r611-user-device-approved-onehand-naver-native-gallery-20261115/experiments/moa-r507/MoaR507InlineGalleryProvider.java) `r602PollPlaylist` mutates the existing native Gallery's `ids` list, preserving TextureView, media playback, filmstrip and original footer actions when nonempty. When the day becomes empty the gallery may intentionally close and the date shows empty state. PHOTO fullscreen uses a separate intentional native close and same-date reentry. DETAIL returns through its original `selectDay` render route.
- 9-item PHOTO inline order is **re-armed** after old R570 handler registration; independent 6-item PHOTO-full and 6-item DETAIL-full with star/trash retained, PHOTO ADD original separate 4-item order retained. The existing original PHOTO card classes18 and original media engine classes6 were NOT replaced.
- Cover-first uses **view-only** reorder of chosen cover to first, maintaining original chronological order of all other media and original stored `photoIds` order.

## Exact APKs
- **R697 candidate:** `MOA_R697_R695_GOLDEN_SAFE_MULTI_REMOVE_FIX_ORIGINAL_SIGNED_BETA.apk`; **versionCode 697**, versionName `MOA-R697-MEDIA-BETA1`, SHA256 **`67a8892c661e38ea9ec4227baa6ecb053bfe612ef874594e6fdf1b250820328e`**. Existing package `com.juhyeon.familyjournea`, same original signer SHA256 **`5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`**.
- **R698 exact R695-functional rescue:** `MOA_R698_EXACT_R695_R691_FUNCTIONAL_FORWARD_RECOVERY_SIGNED.apk`; **versionCode 698**, versionName `MOA-R698-DIARY-SAFE1`, SHA256 **`8e56f44d89db13ccb2b82196ade160935b164ae4916eae0122f1040c144276bf`**. ALL original R695 ZIP contents are byte-for-byte identical EXCEPT AndroidManifest.xml forward version code/name. R698 returns R695 functions; **it does not automatically reverse any already committed diary tombstones**. Restore excluded media from existing DETAIL '다시 표시' if desired.
- Full no-secret source/QA + R683/R695 protected snapshots: `MOA_R697_R698_R695_SAFE_MULTI_DELETE_REPAIR_SOURCE_QA_20261117.zip`, SHA256 **`6f1424bd2a5f9698904383f041f2499466b38e2b6eb13d79dc138ddcf86a3bb9`**, 28,705,059 bytes. **NO keystore/password, cookies, media photos, GPS or user accounts**.
- Source feature branch: [R697 exact native Java and R697 web source](https://github.com/yooogillycloud123/family-journey-personal/tree/feature/moa-r697-r695-safe-native-multi-remove-20261117/experiments/moa-r697).
- Android SDK35 JDK17/D8 compile of native DEX17/19 PASS: [GitHub Actions run 44096850281](https://github.com/yooogillycloud123/family-journey-personal/actions/runs/44096850281), six exact source SHA gates PASS. New DEX17 SHA256 `63bc2e0ffb3b04504fb0fac7ed6d3fa291b50175530fdabd883d1cf3a4c97ac1`. Original R694 classes19 PHOTO ADD behavior is byte-identical except same-length `R694`→`R697` version tag and required DEX integrity signatures; no picker-owner rewrite.

## Unmodified protected original payload
Against the exact R695 installed-function APK: 164 original ZIP entries, **160 byte-exact**. Changes ONLY:
1. AndroidManifest.xml actual 697 and matching Settings version;
2. assets/web/index.html references to new scripts/CSS;
3. classes17.dex native PHOTO/DETAIL ActionDeck multi-select and reorder listener;
4. classes19.dex picker metadata/independent order (R694 source code with R697 version string, no new picker engine);
and 3 additive web assets: `moa-r697-vertical-calendar.js`, `moa-r697-media-tools.js`, `moa-r697-media-tools.css`.
Existing **classes6.dex (original Gallery decoder/MediaPlayer/seek/rail), classes18.dex (original PHOTO native mount/card), all other original DEX, original Naver/QuickRecord/settings, original account data unchanged**.

## QA gates and limitation
- Official Android SDK35 `aapt dump badging`, `aapt2 dump xmltree`, `zipalign -c 4`, `apksigner verify --min-sdk-version 29 --max-sdk-version 37` PASS for R697 and R698. Independent APKv2 signed content digest/certificate, ZIP/DEX integrity PASS.
- Node VM tests PASS: both `curated` and `automatic` modes, PHOTO and DETAIL × 2 selected (one photo + one video) and one retained, body/activities/moments preserved, existing cover tombstone correctly removed, no old `openDay` after batch; view-only cover first, persisted chronological list unchanged. Node `--check` both web files PASS.
- Native Galaxy multi thumbnail display, full screen six action deck, icon order persistence and **PHOTO after actual deletion** **NOT TESTED on phone**. Chromium controlled-page run returned `ERR_BLOCKED_BY_ADMINISTRATOR`; do not treat unit tests as E2E UI PASS. **R697 is BETA; R695 is user's latest functional rollback; R683 remains user-approved Golden.**

## Install / functional acceptance / return
Install R697 over user's R695, preserving package/cert/data. Test PHOTO-inline trash: actual thumbnail grid above still-visible Gallery, select two, confirm; remaining photos still display within SAME PHOTO date. Test PHOTO full and DETAIL full trash, per-surface action order 9/6/6, PHOTO ADD 4 order, cover-first. Confirm originals still present in Samsung Gallery and DETAIL undo. **If ANY regression, install R698 over R697 without uninstall/data clear**. If R698 installed, all later APKs need `versionCode >=699`.

### Permanent new-chat gate
Read `MOA_READ_FIRST_NEW_CHAT.md`, this report, [R683 physical Golden lock](MOA_R683_USER_DEVICE_PHYSICAL_GOLDEN_LOCK_20261117.md), [R691 handoff](MOA_R691_DIARY_SINGLE_MEDIA_EXCLUSION_R692_R693_RECOVERY_20261117.md), and [Gallery action registry rule](MOA_GALLERY_ACTION_REGISTRY_PERMANENT_RULES_20261117.md). Never use R694 as working functional baseline, never repeat premature Gallery close or post-delete day reopen, never claim Galaxy PASS without explicit user evidence. This project does not change AA AirPods daemon/runtime.
