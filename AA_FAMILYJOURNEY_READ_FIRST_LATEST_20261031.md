# FamilyJourney 최신 Canonical READ FIRST — 2026-10-31 R29 GOLDEN (Android) + iOS R1 (separate)

**새 대화에서 모든 분석·소스 변경·APK 빌드 전에 이 파일을 처음부터 끝까지 읽고 가장 최신 체크포인트부터 재개한다.** 본 파일은 이 저장소의 오래된 v0.1/v0.2 시제품 설명이나 R12 이하 인계 문서보다 최신이다. AirPods 별도 프로젝트 지침과 섞지 말 것.

## 1. 사용자 확정 요구
- **사용자 가족용 단일 Android 앱** `FamilyJourney`, 삼성 Galaxy S26 Ultra.
- 기존 여행여권과 별도로 설치, 기존 정품 앱·프리미엄 구매 데이터 보존. 기존 R15~R21 개인 앱의 정상 지도/사진 GPS/사진 마커/영상/여권/고급 해상도·테마/빠른 실행 기능은 삭제하지 않는다.
- 추천/축제/지도대결/불필요한 소셜 서버 기능은 사용자 요청으로 제거 완료. 새 릴리즈에서 복구하지 않는다.
- 원작자 서버·개인정보 전송 차단 유지. 온라인 지도를 켜면 지도 제공사 요청 가능, 네이버 검색/저장은 사용자가 명시적으로 실행한 경우에 한함.
- 사진 위치 **원본 EXIF GPS**로 25m 단위 군집, 실제 주소/좌표 사용. 남원/전주 같은 시군 지역명을 네이버 즐겨찾기 장소로 저장하지 않는다. 상세주소 조회(예: 전남 진도군 의신면 초사리 1205) 성공을 보존.
- 장소에 연결된 사진 N장 3열 미리보기와 **앱 자체 전체화면 사진 뷰어** 1~6x 두 손가락 연속 확대, 축소, 확대 후 이동, 자연스러운 가로 스와이프/다음 사진, 뒤로가기 닫기 보존.
- 최신 요청: **현재 선택된 원본 사진을 Android 공유 시트(카카오톡 등)로 보내고 삼성 갤러리에서 해당 사진 직접 열기.** 사용자 요청 시에만 명시된 사진 1장 URI 공유, 앨범 자동 전송 절대 금지.
- 현재 네이버 저장: 사진 GPS 상세 주소를 네이버지도에서 찾아, 사용자가 입력한 **메모 최대 50자, 별명 최대 25자**, 저장 리스트(예: `내 장소`)를 골라 네이버 계정 즐겨찾기 저장. 기존 PC 성공 절차는 아직 원본 소스 미확인. 임의 지명/별명으로 네이버 검색하는 오류 재발 금지.
- 최근 실기 영상 `17519.mp4`에서 사용자가 메모·별명 입력, `내 장소` 선택, 저장을 하기 위해 매번 추가로 화면을 터치해야 했음. **원인은 AccessibilityService가 이벤트만 기다려 stage 전환을 놓치고 IME 키보드가 NAVER UI를 가린 경우**로 분석; 가설이며 실제 기기 로그 검증 필요. 사용자는 각 단계 사이 터치 없이 자동으로 진행되기를 원함.
- 사용자 계정 실제 저장 완료 여부를 **버튼 클릭 자체와 혼동하지 말 것**. 앱에서 `VERIFIED`는 네이버지도 저장 확인 UI 판독 후에만. 기기에서 검증하기 전 "완전 자동 저장 성공" 주장 금지.

## 2. 위치/아티팩트
- GitHub: `yooogillycloud123/family-journey-personal` `main`, 공용 소스는 `androidHost/app/src/main/java/com/juhyeon/familyjourney` 등. **상용 앱에서 추출된 웹 자산, 가족사진/GPS, 서명키는 공개 GitHub에 업로드 금지.**
- R20 유저 설치 검증: `/mnt/data/FamilyJourney_R20_PinchZoom_NaverFavorites_Fix.apk` 패키지 `com.juhyeon.familyjourne2` versionCode20, 개인 서명키 `/mnt/data/_fj_r17/signer/familyjourney_v16_owner_stable.p12`와 pw 파일 (절대 외부 공유 금지).
- R20 자체 웹 갤러리 소스 `/mnt/data/_fj_r19/fj-naver-favorites-r20.js`. R20 패키징 레시피 `/mnt/data/_fj_r19/package_r20.py`. R20 host `FamilyJourney-R20-NativeHost.zip`.
- 최신 R21 수정 웹 갤러리 `/mnt/data/_fj_r21/fj-naver-favorites-r21.js`, synthetic JS 검증 `/mnt/data/_fj_r21/test_share_gallery_r21.py` PASS.
- R21 native source commits: `701333723f658cdcd5a36d01277b29357373044d` photo sharing; `e5e5bab0a0f3560a2d266f664aa11a63ab14fb4f` periodic NAVER advance + keyboard-aware stage3; `4d1f021421a0f0ac13ccff9106384bdccf0a166a` NAVER window obtained even if IME foreground; version21 at `3d63b58def723a5e7a85af1957fa4f1665c6fc07`.
- Commit/build native path may change on latest branch; always check main SHA and CI. Initial R21 CI 41183868443.
- R21 APK package/signature MUST stay `com.juhyeon.familyjourne2` and same signing cert as R20 so in-place upgrade and user data preservation. Do not change identity or create extra apps.

## 3. New R21 code design
- Photo gallery R20 core untouched; added a row `공유 · 카톡 등` and `갤러리에서 열기`; JS `NativeHost.post('sharePhoto', {id})` or `('openInGallery',{id})` for *currently viewed* original MediaStore ID.
- Native HostActivity: ACTION_SEND with `content://media/external/images/media/<id>`, `ClipData`, `FLAG_GRANT_READ_URI_PERMISSION` and Android chooser; ACTION_VIEW with Samsung Gallery `com.sec.android.gallery3d` and generic view fallback. No external media selected without user intent.
- NaverSaveService: no new event after programmatic clicks can stall; add Handler poll every 500ms while armed (2.4 sec while idle) and only inspect Naver Maps package, 180sec job expiry. Once text filled in NAVER, if keyboard TYPE_INPUT_METHOD present, try back action to hide keyboard only, and proceed to list/submit. Uses `getWindows()` Naver root even with IME focus. Avoid repeated toggling and taps after confirmed list selection, prevent fake verified.
- **Still not verified on Galaxy**: share sheets, Gallery URI association, permission selection, NAVER real account list/alias/memo saved state. If UI automation fails, need status logs per stage and adjust exact NAVER UI, not invent finished claim.

## 4. Verification gates
- Android CI success Gradle compile → zipalign → release signed with SAME cert as prior → apksigner verify (v2/v3) → aapt package/version → APK CRC → main old JS bytes unchanged except the additive `fj-naver-favorites.js`.
- Chromium synthetic photo gallery navigation/pinch/share button action and Android Back. User screenshots R20 prove pinch and preview actually working.
- Real Galaxy user test: first installed R21 → open one photo → Share (Kakao chooser), open Galaxy Gallery; then NAVER `주소로 저장 + 메모` → exact address remains → user only chooses correct result if ambiguous → auto star, text fields, list, blue Save without extra taps → verify in saved list and memo. If unverified, report stage and do not say complete.

## 5. Do not repeat regressions
- Do NOT add separate "로컬 즐겨찾기" substituting NAVER account saved list (R16 was rejected); do NOT re-add 추천/대결; do NOT show demo/premium billing.
- Do NOT remove all features because an external endpoint blocked. Preserve map, picture, film, premium-grade options, independent network.
- Do NOT use a different package/signing key and break upgrade; no additional helper apps; no R15 rollback.
- Do NOT claim PC favorites script identified; it was not in available data.

## 6. Latest completed R21 release (signed APK produced)
- Generated full private APK `/mnt/data/FamilyJourney_R21_PhotoShare_NaverAutoFlow.apk` (3,283,755 bytes, SHA256 `7288fd2651c2c494c4e03664a5cf28d0009d20f04398069705dcfde2719f4e2f`).
- Same private signer certificate SHA256 `0d25313c1a6f769d1a9b43ea9d3b7a4626a12924a887062ad25dc69907fbad09`, package `com.juhyeon.familyjourne2`, versionCode 21. Signed Android v3 and integrity PASS; builds on R20 without deleting R20 data.
- Public native CI `41183868443`: completed SUCCESS and artifact downloaded as `/mnt/data/FamilyJourney-R21-NativeHost.zip`.
- ZIP alternate `/mnt/data/FamilyJourney_R21_PhotoShare_NaverAutoFlow.zip`.
- Script `/mnt/data/_fj_r21/package_r21.py`; private patched gallery script `/mnt/data/_fj_r21/fj-naver-favorites-r21.js`; `/mnt/data/_fj_r21/test_share_gallery_r21.py` headless Chromium PASS: share selected id 101, gallery open id 101, move and share id 102, back closes dialog, no JS errors. Original map/video cores byte-identical to R20.
- Phone NAVER favorite auto-tap/list/save and user screenshot/physical keyboard tests still unverified; do not claim end-to-end success.


## 7. NEWEST R22 — Calendar photo diary integrated 2026-10-31 (supersedes R21 as latest APK)
Read `FAMILYJOURNEY_R22_CALENDAR_FAMILY_DIARY_CANONICAL_20261031.md` **in full** before touching R22. User uploaded D·LOG v1.14.3 split APK solely as a feature reference; never publish proprietary source/assets or user photos/GPS.

- R22 private signed APK: `/mnt/data/FamilyJourney_R22_FamilyCalendar_PhotoDiary.apk`, **SHA256 `93c57875b5d0676b4ae47e0c933115a59701090e425664e404f47977b4ad2fbf`**, `versionCode=22`, package `com.juhyeon.familyjourne2`, same private certificate SHA256 `0d25313c1a6f769d1a9b43ea9d3b7a4626a12924a887062ad25dc69907fbad09`. Safe in-place update on R21.
- ZIP fallback: `/mnt/data/FamilyJourney_R22_FamilyCalendar_PhotoDiary.zip`.
- Additive independent JS/CSS: `/mnt/data/_fj_r22/family-diary.js` and `family-diary.css`. Packaging script `/mnt/data/_fj_r22/package_r22.py`.
- New nav tab: **일기** between 기록 and 설정; existing 추천/대결 remain hidden, originals intact.
- Native `HostActivity.diaryPhotoIndex` user-triggered MediaStore ID + DATE_TAKEN; fallback DATE_ADDED tagged approximate; all photos including GPS-less. Batch 160 to WebView callback.
- Monthly calendar cover thumbnails/counts/record dots, day photos by time, >60min photo-group timeline, activity title per group, manual multi-select OR full-day selection, title/freeform diary/tags/mood, IndexedDB local save/edit/delete, JSON memo export. Day photo tap uses existing R21 pinch/swipe/share viewer exposed through additive `FamilyJourneyNaver.openFullGallery`. No photos copied or uploaded. Original GPS map/video native.js, app.js, engine.js byte-identical. Existing `fj-naver-favorites.js` gets only a one-line export of its already working in-app zoomable gallery (`openFullGallery`) for the diary; no other logic changes.
- Public Android CI code commit `f7f5d48c3e07b639d301033cc0ae00f7e2d66739`, version bump `80b2b0f14ad5fdc293dc9f0db9ce397fe9b3532e`. CI run `41184907394` compile/host signing PASS. Standalone APK signed v3 and ZIP CRC PASS. Node JS syntax and grouping unit tests PASS.
- **Real Galaxy diary UX / all-photo scan / photo count / IndexedDB persistence on phone NOT YET TESTED**. Headless browser is inaccessible in current container (ERR_BLOCKED_BY_ADMINISTRATOR), don't claim headless visual PASS. Phone test required before any final parity assertions.
- Future: real Android Photo Picker across arbitrary days, richer geo/time activities, multi-day import, full backup restore, family notes export PDF, optional private sync. D·LOG backend, accounts and copyrighted UI are NOT incorporated.
- User's NAVER favorite autosave R21 behavior still conditional; don't claim end-to-end account save fully proven.


## 9. LATEST — R25 (2026-10-31)
**Read `AA_FAMILYJOURNEY_R25_READ_FIRST_20261031.md` from start to end before ANY new FamilyJourney edit.** Latest APK `FamilyJourney_R25_CuratedDefault_PCPhotoImport.apk`; package `com.juhyeon.familyjourne2`, versionCode25, same owner signing certificate. R24 user verified working. New diary initial tab is curated/selected photos, automatic full photo calendar remains second tab. Android native SAF picker explicitly imports PC-origin images or transferred ZIP files into user local Pictures/FamilyJourney PC Imports, preserves EXIF date and original bytes, sha256 dedup, reindexes. No PC direct SMB sync or iOS build yet. R25 on-device importer NOT VERIFIED. No deleting original R24 data, no new app, no regression of map/video/Naversave/zoom/share. SHA256 and code instructions in R25 READ FIRST.

## 11. NEWEST R26 — Android 사진 + 동영상 일기 (2026-10-31)
**반드시 `AA_FAMILYJOURNEY_R26_VIDEO_DIARY_READ_FIRST_20261031.md`를 처음부터 끝까지 읽어라.** R25 사용자가 설치/업데이트 후 만족한 기준. R26은 기존 사진/PC/지도/여행영상/네이버/일기 엔진을 보호하며 MediaStore **동영상 메타데이터 조회, 선택·날짜별 보기·인앱 원본 재생·공유**만 추가.
- Latest APK `FamilyJourney_R26_PhotoVideoDiary_ZeroCopy.apk`, package `com.juhyeon.familyjourne2`, versionCode26, SHA256 `396147c63c669827a00fd6981f5cc7f8b2ea49ec4d1e5db73dbedc363968d9cb`, **same signing cert as R25**. Never uninstall existing app, in-place update only.
- New Android permission `READ_MEDIA_VIDEO`, requested on diary first scan. Deny → legacy photo-only diary. No MP4 copied/transcoded/uploaded. DB photos kept separate from videos, selected-video IDs 'v'+MediaStore ID, no DB schema upgrade. Original photos still photo112 even when video count grows. Small metadata/cache storage increases possible.
- Native GitHub CI 41191186056 PASS. R25→R26 APK changed four entries: AndroidManifest.xml, classes2.dex, assets/web/family-diary.js and family-diary.css. JS browser synthetic photo+video selection, save and independent count PASS. **Galaxy actual playback/permission STILL UNTESTED**.
- User specifically instructed **PC Windows and iOS work paused**; no new sync or iOS build in R26. 

## 12. LATEST R27 — R26 사용자 일기 화면 깨짐 CSS 회귀 수정 (2026-10-31)
**R27을 새 Canonical 최신 Android 결과물로 지정. 반드시 `AA_FAMILYJOURNEY_R27_CSS_REGRESSION_FIX_READ_FIRST_20261031.md`를 전체 읽어라.**
- User real screenshots prove diary flowed as unstyled text below '나의 지도' after installing R26. Exact root cause extracted from actual R25 and R26 APK: original diary CSS 9,851 bytes accidentally overwritten with only 994-byte video additive rules. `#fj-diary-root{position:fixed}` deleted.
- R27 CSS = original R25 full 9851 bytes + 994-byte R26 video rules. Difference from R26 APK **only** `AndroidManifest.xml` (versionCode27) and `assets/web/family-diary.css`; all other classes.dex, JS, map/video/Naver features byte-identical.
- Corrected signed `FamilyJourney_R27_VideoDiary_LayoutRestored.apk` SHA256 `4290cb2a4501e7a867dbf17af4ef09688beeebeeaf4e15303a4abf89ba2b74e9`, same app package/signing cert; install **OVER** existing R26, NEVER uninstall.
- CI compile `41191969052` success. Browser viewport test confirms fixed overlay and photo112/video1 plus curated independent diary; real Galaxy device R27 visual and video not yet tested.
- PC Windows and iOS remain frozen. DO NOT repeat a regression by replacing a whole CSS file with only new addon rules. Every subsequent APK must verify baseline CSS and UI computed `position:fixed` in screenshot test.

## 13. R28 WIP source only — video share buttons, elegant owner app icon, diary GPS (2026-10-31)
**The latest user-installable signed APK remains R27.** Read `AA_FAMILYJOURNEY_R28_VIDEO_SHARE_ICON_DIARY_GPS_WIP_20261031.md` in full before working on next APK; R28 is NOT a finished installable APK.
- User confirmed R27 installed and functional, requested (1) share/ Gallery on native video viewer, (2) unique clean icon, app label remains `우리 가족 여행`, (3) photo/video EXIF GPS and exact Naver coordinate pin/address under diary time. User screenshot also revealed `[object Object] · 사진` gallery title bug.
- Public native changes in GitHub `androidHost`: share/gallery buttons in `playDiaryVideo`, new `diaryMediaLocation`, `diaryOpenNaverPlace`, `diaryReverseAddress` handlers, native on-page injection for own location addon, adaptive icon XML and AndroidManifest. Latest native CI run 41194114008 PASS, JS addon syntax PASS.
- **Incomplete:** private R27 `assets/web/family-diary.js` timeline render must call new `FamilyJourneyDiaryGeo.attach`; private gallery title `[object Object]` must be corrected. No signed R28 produced; don't claim finished. Current runtime lacks private R27 APK and matching signer, and Library raw-byte materialization denied. Do NOT replace installed R27 with publicly compiled host (it has no proprietary web assets and different signer).
- Do not upload private APK/signing key to public GitHub; keep R27 working and preserve all diary IndexedDB. Resume from available authorized R27 APK, private owner signer, exact source diff, signed build and Galaxy tests. Windows/iOS remain deferred.

## 14. ABSOLUTE NEW GOLDEN: USER-VERIFIED R29 (2026-10-31)
**Always read `AA_FAMILYJOURNEY_R29_GOLDEN_LOCK_20261031.md` in FULL and use its hard SHA256, package, version, signer.**
- User explicitly approved **R29 Android** as Golden on 2026-10-31. It is `FamilyJourney_R29_HeartDiary_Updated.apk` SHA256 `95d82324beb1f0293a9bac49be1ff4f35be1931a3b0caf784009411f0446e041`. Backup exists as `/mnt/data/FamilyJourney_R29_GOLDEN_DO_NOT_MODIFY.apk`.
- R29 package `com.juhyeon.familyjourne3`, versionCode29, signing cert SHA256 `24868e5cdf5c8b6699435981f341752dd3fdae6ea89156eaca552605502e4d0c`. Legacy R27 package `com.juhyeon.familyjourne2` is a different parallel app. Do not mix up signing certs or reset app data.
- Exact frozen functions: user-accepted maps/diary photo/video/import, separate automatic and chosen-photo calendars, in-app photo viewer + share, video play/share, date cover, NAVER favorites assistance, gradient heart launcher icon. No changes to installed GOLDEN without testing.
- New direct request: iPhone version for spouse, same feature direction; native original SwiftUI iOS R1 written at `ios/` (XcodeGen) without copying private Android binary/code into public repo. Simulator CI `41198595626` passed. iOS code includes PhotosKit on-device gallery, selected/auto diary, GPS Apple map, Naver marker links, videos and share, heart icon, local JSON. BUT full Android feature parity and device-level sign/deploy NOT yet established. No Android-to-iOS photo sync or automated NAVER favorites account modification.
- Public macOS workflow `.github/workflows/ios-build.yml` builds unsigned device IPA for local Apple ID signing (Sideloadly/AltStore) plus simulator compile; Apple signing required. Do not tell user unsigned IPA installed by just tapping iPhone.
- Preserve private user GPS/Photos, R29 APK signing key; never upload to public GitHub.

## 15. iOS R1 native build PASS, unsigned IPA ready for Apple account signing (2026-10-31)
- MUST read `AA_FAMILYJOURNEY_IOS_R1_BUILD_AND_INSTALL_CHECKPOINT_20261031.md` entirely before changing iOS. `ios/` SwiftUI source, independent `com.juhyeon.familyjourney.ios`, iOS 17+.
- Latest full macOS GitHub Actions workflow run **41199085729**, iOS simulator compile PASS and physical iPhone architecture compile PASS, valid unsigned `Payload/FamilyJourneyIOS.app`. `/mnt/data/FamilyJourney_iOS_R1_UNSIGNED_AppleID_Sign_Required.ipa`, 717,104 bytes, SHA256 `4ad4873e3eecfe57fbfcfa0cec14d862837dde064dd0e14b0499034b4ff66850`. No Apple code signature — no directly installable iPhone APK-like one-tap file. Windows free Apple ID Sideloadly may sign/side-load (7-day validity), or Apple Developer Program/TestFlight for continued distribution. Never collect Apple credentials.
- Source kit `/mnt/data/FamilyJourney_iOS_R1_Source.zip` includes GPS animated map video MP4 builder with PhotosKit/AVKit/MapKit. Installation kit `/mnt/data/FamilyJourney_iOS_R1_INSTALL_KIT_UNSIGNED.zip`. Real spouse iPhone usage unverified. iOS NAVER favorites auto-save/account memo, Android R29 diary auto sync, original premium video themes and PC import not yet parity.
- Android R29 GOLDEN unchanged. Do not overwrite Android app with iOS artifact or upload Android private APK/images.
