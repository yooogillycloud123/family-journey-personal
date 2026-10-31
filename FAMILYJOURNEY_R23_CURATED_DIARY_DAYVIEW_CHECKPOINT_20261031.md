# FamilyJourney R23 — 직접 고르는 사진 일기 + 날짜별 독립 하루 화면 (2026-10-31)

## 사용자 확인 / 고정 기준
- 사용자가 R22 Android 실기에서 정상 동작을 확인함. 날짜별 사진 수(약 12,783장 사진 색인)·달력 대표 썸네일·시간순 사진 분류 PASS.
- 사용자가 요구한 R23 방향: 기존 **자동 사진 달력은 유지**, 새로 **내가 고른 사진 일기** 모드를 별도로 제공. 달력에서 날짜를 누르면 긴 페이지 하단으로 스크롤하는 R22 방식을 폐기하고, D·LOG의 *컨셉*처럼 별도 그날의 하루 기록 화면에서 사진·활동·메모를 시간순 표시. 원작 앱 코드/아이콘/상용 자산을 복사하지 않는다.
- 기존 지도/영상/네이버지도·사진 전체화면 공유·제스처·개인정보 기능 손상 금지. 다른 패키지, 서명, 앱 증식 금지.

## 실제 구현
- R23 installable APK `/mnt/data/FamilyJourney_R23_CuratedPhotoDiary_DayTimeline.apk`
- SHA256 `4dbf15b3679f7a3e24dc928f451f5605f6c86d309140ae863b4335c5f4d9edfe`
- ZIP `/mnt/data/FamilyJourney_R23_CuratedPhotoDiary_DayTimeline.zip`
- package `com.juhyeon.familyjourne2`, versionCode **23**, R22 identical signing SHA256 `0d25313c1a6f769d1a9b43ea9d3b7a4626a12924a887062ad25dc69907fbad09`. In-place install preserving R22 IndexedDB.
- Original R22 photo date cache and diary DB `familyjourney-diary-v1` (entries keyPath day) are reused *without schema version bump*. Old R22 entries loaded; existing manual selections inferred from nonempty photoIds and new records write `selectionMode='manual'|'automatic'`.
- R23 UI: within **일기**, `자동 사진 달력` and `내가 고른 사진 일기` sub-tabs, day click changes to **separate date view** with date title, diary entry, timeline, thumbnail strips, activity notes and previous/next day.
- Manual entry mode: choose diary target date with native HTML date input, then month-browsable **multi-select photo picker across arbitrary dates** from the R22 user-local MediaStore index, paginate 120 photos per screen, choose up to many photos, create/update diary title/body/tags/feeling/activity per time group; selected photo timestamps retained and original shot date displayed if different from diary date.
- Day view offers '사진 직접 고르기', '이날 사진 전체', writing/edit/delete, existing R21 viewer via `FamilyJourneyNaver.openFullGallery` (pinch zoom, swipe, share, gallery).
- Photos are **MediaStore ID references only**, no upload/copy. Export legacy compatible per-day notes and selected IDs JSON; original binary media are not in JSON. On removed/relocated photo some references may go missing.
- Leave nav bar [나의 지도, 기록, 일기, 설정]; no 추천/대결 or R16 substitute local Naver list.
- Only **3 files changed in signed R23 APK compared to R22**: binary AndroidManifest.xml (code/name/label), assets/web/family-diary.js, assets/web/family-diary.css. All existing native dex/bridge, map/video and Naver/favorite/zoom/share scripts remain byte-identical. No new Android permissions or custom server.
- Build script `/mnt/data/_fj_r23/package_r23.py` (requires private signing key, never upload key).
- New authored module `/mnt/data/_fj_r23/family-diary.js` and `family-diary.css`. Generated `FamilyJourney_R23_OriginalDiarySource_and_Notes.zip` contains these independent modules and build guide, not any third party proprietary JS assets or signing secrets.

## Verification
- User R22 on-device success: **confirmed by user**.
- R23 Node JS parse PASS, Chromium DOM/UI synthetic test with in-memory mocked IndexedDB PASS: selecting 2 photos, date detail, saving, manual record listing, navigation, zero JS errors.
- Actual Android Galaxy R23 UX and persistent local IndexedDB after full app restart **NOT YET TESTED**. Chromium screenshot synthetic and DB mock are not device evidence.
- APK zip CRC PASS, apksigner v2/v3 signature verify PASS, AAPT package `com.juhyeon.familyjourne2` versionCode23 PASS, changed archive entries strictly 3 expected PASS.
- R22 stable APK is fallback: `/mnt/data/FamilyJourney_R22_FamilyCalendar_PhotoDiary.apk`; do not uninstall and lose user data. Android normally refuses versionCode downgrade; use a newer signed rollback APK if R23 needs rollback while keeping data.

## Next tasks
- Test real Galaxy custom photo selection from another month; entry save, app full restart, date calendar tap → standalone day page, date navigation and Back overlay, existing pinching/share/Google gallery/Naver no regression.
- Consider direct **Android Photo Picker** future for albums/cloud sources not in MediaStore; R23 *currently* uses the existing local photos index filtered by month, not external Gallery selection UI. Keep this distinction clear.
- Refine timeline auto grouping and cover selection. Maintain original EXIF/GPS privacy policy.
