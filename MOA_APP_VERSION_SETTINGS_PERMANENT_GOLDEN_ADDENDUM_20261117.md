# MOA 설정의 설치 버전 표시 — 영구 Golden 추가 규칙 (2026-11-17)

이 규칙은 기존 Golden APK/원본 Gallery/QuickRecord 작동을 변경하지 않는 추가 릴리스 의무 사항이다. 모든 새 모아 프로젝트 채팅과 소스 수정/업데이트에 적용한다.

1. 설정 페이지에는 기본으로 보이는 모아 앱 버전 행을 항상 둔다. 디버그 메뉴 전용이 아니다.
2. 표시된 R번호, AndroidManifest versionCode, 패키지명, 서명 인증서는 실제 배포 APK와 반드시 일치해야 한다. 향후에는 설치 APK PackageManager에서 versionName/versionCode를 실시간 읽어 표시하는 것이 최종 목표다. 현재 R681은 실제 서명 APK의 네이티브 bridge.version() 문자열에서 R681 빌드를 읽는다. versionName 런타임 조회는 R681에 포함되지 않았다.
3. 릴리스 때마다 버전코드 및 버전명, WebView/네이티브 캐시, 설정 표시가 서로 일치하는지 QA로 검증하고 이전 버전 문자열이 남아 있으면 배포를 금지한다.
4. 언제나 설치된 버전보다 높은 versionCode+원본 패키지명+원래 서명 인증서로 덮어쓰기한다. 앱 삭제, 데이터/IndexedDB/쿠키/네이버 로그인 삭제는 절대 하지 않는다.
5. 사진형·상세형 기존 원본 상단 날짜·우측 스위치 위치는 메인 CALENDAR와 PHOTO-ADD 통일의 고정 기준이다. 실제 Galaxy 화면 전환시 1px 흔들림·구형 달력·상태바 플래시가 없는지 검증한다.
6. PHOTO-ADD 확대는 기존 classes6.dex MoaNativeGallery 원본 갤러리와 기능이 동일해야 한다. 기존 원본 18 DEX/네이버/QuickRecord/GOLDEN을 회귀시키지 않는다.
7. 실제 기기 설치/왕복 테스트가 없는 결과는 BETA 및 DEVICE TEST PENDING으로 명시한다. R681/R682는 로컬 정적/Chromium PASS지만 실기기 GOLDEN이 아니다.

최신 사례: MOA_R681_HEADER_GALLERY_VERSION_PERMANENT_HANDOFF_20261117.md. 사용자 영상 23428.mp4, 23429.mp4, 23430.mp4, 23431.mp4 (2026-11-17). R682 설치 후 다음 versionCode >=683.
