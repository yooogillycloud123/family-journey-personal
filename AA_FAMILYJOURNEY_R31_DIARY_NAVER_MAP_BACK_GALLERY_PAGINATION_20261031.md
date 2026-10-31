# FamilyJourney R31 — diary NAVER assist, map Back, in-app gallery, diary incremental photo load
Date: 2026-10-31
Status: **SIGNED APK candidate; browser-simulated tests PASS; real Galaxy physical verification PENDING**.
## Baseline and immutable Golden
- R29 immutable Golden backup `/mnt/data/FamilyJourney_R29_GOLDEN_DO_NOT_MODIFY.apk`, SHA256 `95d82324beb1f0293a9bac49be1ff4f35be1931a3b0caf784009411f0446e041`, unchanged.
- R30 installed-like source `/mnt/data/FamilyJourney_R30_PC_Cloud_FileImport_GOLDEN_Safe.apk`, SHA256 `cf95cab35851d6606d0eee597b019e4d1ba238ff69f25063ce7d5051118a61f6`, unchanged.
- New signed candidate `/mnt/data/FamilyJourney_R31_DiaryNaver_MapGallery_Back_PhotoMore.apk`, SHA256 **`f749fe3b64b86fa4489af3fd1116fe2a5bec6803294a7d53903a00d24e505e80`**, 3,370,255 bytes; package **`com.juhyeon.familyjourne3`**, versionCode **31**, versionName `1.0.7-family-heart-diary-r31`. R29/R30 same signer cert SHA256 **`24868e5cdf5c8b6699435981f341752dd3fdae6ea89156eaca552605502e4d0c`**. APK v3 signed, zipalign/ZIP CRC PASS.
## Exact APK diff (base R30)
**Only**:
- `AndroidManifest.xml` versionCode/name, no permission/package change.
- `assets/web/app.js`: open map/region/home/spot photo tile in existing R29 in-app zoom/pan/swipe/share/gallery `FamilyJourneyNaver.openFullGallery` (all same-place IDs), fallback old viewer for video/cloud/non-MediaStore. Preserve existing 30-at-a-time map grid.
- `assets/web/family-diary.js`: Native Android Back overlay handling: original viewer then place sheet, then full map, then diary day/calendar. Original in-app Naver sheets handled first by previous handler; no app exit dialog for these overlays. In daily timeline, first 12 media (include relevant video) then **30 per tap**, append existing R29 media cards (cover, location, share/gallery), preserve curated-vs-automatic split and IndexedDB.
- `assets/web/family-diary.css`: additive .fd31-more style only; original CSS retained.
- `assets/web/fj-naver-favorites.js`: exported diaryDraftForGPS/saveFromDiaryGps; use same existing reverseAddress and **native naverArm**. Requires valid Korean original GPS and exact road/lot address; user's alias/memo/list never substituted as place search. Status marked REVIEW until native verified, never falsely claim account save. Uses same Accessibility helper already in R29.
- `assets/r28-diary-location.js`: native-injected existing location panel gains collapsible ★ NAVER alias, memo, desired saved list, and button; its press resolves exact address and sends to original naverArm; statuses handled. No new permission; no account token/server connection; buttons off if GPS absent/outside Korea.
All native classes*.dex, original index.html, maps, trip maker, video engine, badges, provider import, diary storage, icons, service APK and private assets are **byte-identical** from R30.
## Tests
- Node syntax 4 modified JS PASS.
- Playwright simulated diary: 95 mixed photos/videos, starts 12, then +30, +30, +23 -> **12/42/72/95** and no duplicates; original controls 95/95 intact.
- Playwright actual JS callback chain: native diaryMediaLocation to GPS to exact reverseAddress to **naverArm with alias+memo+list+address** PASS.
- Playwright Back stack overlay: place dismiss, next Back full map dismiss, no exit prompt for these 2 PASS.
- Playwright extracted map gallery: 75 place photos, map grid 30 then 60, index 0 and 42 both open all 75 in existing in-app gallery PASS.
- Android device real Accessibility/Naver account status, touch gestures, actual back and persistence **not tested by assistant**, requires user Galaxy testing.
## Installation
- If R29 or R30 currently installed, **install R31 over it**, do not uninstall/wipe data.
- APK versionCode 31 > 30; old R29 cannot simply downgrade in-place. If regression discovered, make same-signer forward fix code32 using untouched Golden R29 behavior, not uninstall/data loss.
- Test (1) diary location panel enter alias+memo/list and click; see correct address page on Naver and account saved list; (2) map region -> image pinch/swipe/share -> Android Back -> place -> Android Back map -> Android Back home; (3) diary day with >42 photos, see repeated 30 photo more.
- Real NAVER save remains best-effort Accessibility: if NAVER UI changes or user account permission differs, UI may need user intervention. Never report guaranteed automatic NAVER account save without actual confirmation.
- No private APK/media/GPS uploaded to public GitHub; document only.
