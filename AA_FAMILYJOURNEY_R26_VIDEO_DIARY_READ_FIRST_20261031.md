# FamilyJourney R26 — 사진 + 동영상 동일 일기 / Zero-Copy (2026-10-31)

## 사용자 최상위 요구
- **Windows PC와 iOS 작업 킵(동결)**. 이 작업은 기존 Android R25 앱 *하나*에 동영상만 추가하는 증분 업데이트이다.
- 기존 갤럭시 원본 사진 및 동영상을 복사, 변환, 업로드, 새 MP4 저장하지 않음. **MediaStore ID·촬영시간·길이 등 메타데이터만 앱 IndexedDB에 저장**. 영상 썸네일은 Android MediaStore에서 불러온 해상도 제한 작은 이미지 메모리 데이터이며, 재생은 Android VideoView가 실제 MediaStore content URI를 참조한다. 원본 갤러리에서 지우면 일기 참조도 끊어진다.
- '앱 저장 용량 0 증가'를 보장하지 않음: 텍스트/색인/일시적 썸네일 캐시/앱 업데이트 및 DB 때문에 소량 늘어날 수 있지만 원본 동영상 크기만큼 중복 저장하지 않는 구조.
- 현재 갤럭시 R25 선택사진 일기가 메인, 자동사진 달력이 보조. 두 일기 저장소(entries,curated) 독립. R23의 자동 사진112장/수동9장 상호 덮어쓰기 회귀 절대 금지.
- 여행 지도, 영상 제작, 네이버지도 즐겨찾기, 사진 전체화면 핀치/공유, PC ZIP 사진 가져오기 기능 모두 보존.

## 구현한 변경
- 네이티브 `HostActivity.java`:
  - 기존 `diaryPhotoIndex`에 `MediaStore.Video.Media` 메타데이터 조회 추가: `v<숫자>` 영상 ID, `video:true`, `duration` ms, 촬영시간 `t`, 근사 표기. 사진 인덱스는 숫자 ID 그대로 보존.
  - Android 13+ `READ_MEDIA_VIDEO` 권한은 사용자가 일기 진입/색인할 때 **한 번만 명시적으로 요청**. 거절해도 사진 전용으로 계속 동작.
  - 기존 영상이동/재생과 독립된 `diaryPlayVideo`는 Android 네이티브 fullscreen Dialog+VideoView/MediaController로 원본 영상 직접 재생, 앱 내부 뒤로가기 후 기존 일기 복귀. 미지원 코덱은 외부 기본 재생기로 fallback.
  - `diaryShareVideo`는 명시적 클릭된 영상 URI 하나만 Android Sharesheet로 공유, 무단 전송 금지.
  - 기존 thumbnail 브리지 `thumbs`가 영상 ID `v123` 인식해 MediaStore.loadThumbnail 호출; 실제 영상 파일 복사/동영상 프레임 전량 디코딩 금지.
  - AndroidManifest: `READ_MEDIA_VIDEO` 추가. 앱 패키지, NaverAccessibility Service, 기존 나머지 권한/컴포넌트 유지.
- JS/CSS: `assets/web/family-diary.js`, `assets/web/family-diary.css`만 갱신. IndexedDB **DB version 2 / entries / curated / meta** 그대로; 기존 저장 일기 변경 없음. 기존 `photo-index`가 영상 미포함 캐시임을 구분하기 위해 `mediaIndexVersion:26` 사용; 첫 열기 새 영상 색인을 수행. 사진 배열과 영상 배열 분리하고 날짜별 영상 Map 별도 관리하여 사진 112장과 영상 n개 표시, 선택 일기는 선택한 사진9장/영상 n개 표시. 선택 ID `photoIds` 배열에 video ID도 'v123'로 저장해 기존 DB 이식 없이 기록.
- 날짜별 자동 달력, 수동 일기, 월별 다중 사진·영상 선택, 촬영일별 구분, 타임라인 영상 썸네일/재생/공유, 동영상 길이 표시. 1시간 그룹에서 영상이 처음12장에 묻힐 때에도 최대10개 영상을 우선 표시하고 '모두 펼치기'로 나머지까지 표시. 사진 확대 갤러리에 video IDs 전달 금지.

## R26 빌드 및 증거
- Signed APK `/mnt/data/FamilyJourney_R26_PhotoVideoDiary_ZeroCopy.apk`
- ZIP `/mnt/data/FamilyJourney_R26_PhotoVideoDiary_ZeroCopy.zip`
- APK SHA256 `396147c63c669827a00fd6981f5cc7f8b2ea49ec4d1e5db73dbedc363968d9cb`
- package `com.juhyeon.familyjourne2`, `versionCode=26`, `versionName=1.0.4-video-diary-r26`.
- APK cert SHA256 `0d25313c1a6f769d1a9b43ea9d3b7a4626a12924a887062ad25dc69907fbad09` **IDENTICAL to R25**. 덮어쓰기 설치, 기존 앱/데이터 제거 절대 금지.
- native source GitHub commits: `3d4dfc6221cd6bd4381f0f6e2f49d15cf3b1a0d7` (HostActivity), `c23f553bbea302809878e27e916df39d1ca1ea7f` (manifest), `7544178378e12ab636011d0c4c5f7afeecc75430` (gradle version).
- Native GitHub CI run `41191186056` compiled PASS and artifact `FamilyJourney-R26-NativeHost.zip`. Main compiled manifest from this host, same package/classes. Private signer remains runtime-only, not published.
- APK vs R25 changed exactly FOUR entries: `AndroidManifest.xml`, `classes2.dex`, `assets/web/family-diary.js`, `assets/web/family-diary.css`; other original map/video/Naver/photo code byte-identical.
- Android signature v2/v3 verified PASS, ZIP CRC PASS, aapt package/version/READ_MEDIA_VIDEO/Naver service PASS, Node JS syntax PASS.
- Headless Chromium synthetic UI PASS using 2026-10-31 photo112 + video1 and existing R23 curated2 + video1; separate automatic count photo112 maintained, selected photo2+video1 stored without affecting automatic; video thumb tile play/share native command, group expanded support, no page errors. Tests `/mnt/data/_fj_r26/test_r26.py`. **This is a mock browser, not a Galaxy test.**
- Actual Galaxy S26 Ultra device permission prompt, real video playback/codec, video thumb resolution, video counts and storage persistence **NOT YET PHYSICALLY VERIFIED**. No guarantee of seamless video playback until user tests.
- UI uses in-app VideoView, fallback to system app if codec unsupported. Video is not exported as new video; unlike original travel-route video builder which intentionally creates an MP4 if user invokes it.

## Further
- Device test: update without uninstall; open 일기→내가 고른 사진 일기 and allow video access; 자동 달력 same photo count (e.g. Oct31 112 photos) + video counts; manual add video from another day, save, close and reopen; tap ▶ to play and share one video; test existing photo viewer pinch and Naver.
- Source-only independent JS/CSS and test in private runtime `/mnt/data/_fj_r26`. **Never publish commercial base APK, private signing key or family photos/GPS to PUBLIC GitHub**.
- Windows PC v0.1 and incomplete iOS skeleton remain paused and unmodified; no auto cross-device sync in R26.
