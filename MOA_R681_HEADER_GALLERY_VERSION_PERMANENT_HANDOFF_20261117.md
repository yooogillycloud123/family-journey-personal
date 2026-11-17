# MOA R681 사용자 영상 전체 요구·릴리스 검증·R682 복구 핸드오프 (2026-11-17)

## 사용자 요구가 확정된 6개 기능
- 사용자 승인 사진형/상세형의 날짜 연월일 X/Y, 폰트/자간, 우측 스위치를 정답 Golden 위치로 고정하여 메인 달력 및 사진 추가를 그 자리에 동일 배치; 화면 전환 시 흔들림 금지.
- 내 지도/기록/설정에서 다시 일기로 돌아오는 것을 포함해 구형 ‘내가 고른 사진일기’ 레이어가 잠깐이라도 보이지 않게 차단.
- 화면 이동 때 간헐 노출되는 Android 시계·배터리·통신 상태바와 검정/흰 화면 깜빡임 원인을 Activity/Window 레벨로 조사, 실기기 확인 없이는 해결 주장 금지.
- 사진 추가의 오늘 돌아가기 슬라이더 모양을 제거하고 단일 정적 오늘 심볼을 사진형·상세형의 우측 설정 위치에 고정(34px 누름 영역).
- 사진 추가 확대는 원본 PHOTO/DETAIL의 **진짜 MoaNativeGallery classes6.dex**를 사용. WebView 가짜 미리보기/흉내 낸 갤러리 불허; 8버튼·동영상·빠른기록·네이버 기능 유지.
- 영구 규칙: 모든 APK의 설정에 실제 앱 버전 표시, Manifest 버전과 릴리스 정보 자동/동기 확인, 새 채팅·Golden 정책에 반드시 기록.

## 실제 R681 베타 APK
- APK: MOA_R681_HEADER_GALLERY_VERSION_ORIGINAL_SIGNED_BETA.apk
- package com.juhyeon.familyjournea, versionCode 681, sha256 cfa46e321816fc9ed8862e2459a4e3e28370aa4039faa1c2c1c0ff7487c025cd
- 원래 서명 인증서 SHA256 5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15 정확 일치.
- R679에서 수정한 것: Manifest versionCode, index.html의 versioned JS/CSS 링크, 새 JS+CSS 2개, classes19.dex의 provider.host Activity classname const-string 인덱스 한 곳(HostActivity exact→MoaIconHost exact), bridge.version 텍스트 R673→R681. **상속 계층을 자동 허용하는 소스 초안이나 PackageManager versionName API는 R681 dex에 컴파일하지 않음**; 향후 실제 컴파일/실기기 확인 필요.
- 원본 classes1.dex~classes18.dex 18개 **압축 해제 바이트 정확 동일**, 포함된 기존 native Gallery 엔진 보존.
- 새 JS/CSS: CALENDAR와 PHOTO-ADD 상단 위치/폰트/자간을 사진형·상세형 기준으로 맞춤, 고정 Today 심볼, old calendar 숨김 규칙, 설정 ‘모아 앱 버전’ 행이 실제 bridge.version에서 R681 읽어 표출.
- 검증: ZIP CRC PASS, stored entry align4 PASS, DEX19 SHA1/Adler PASS, 인증서 및 APK v2 signing block RSA 서명 독립 검증 PASS, 실제 APK 전체 chunk SHA256 재계산 PASS, Chromium 360/390/412 picker QA PASS, Node 문법 PASS.
- **미검증**: 공식 SDK apksigner/aapt2 게이트(현 작업 환경에 바이너리 도구 미설치), 실제 Galaxy 설치, MyMap/Settings/Records 10회 전환, Gallery 8버튼/비디오/OS 상태바 플래시. 브라우저 MOCK PASS는 네이티브 실기기 PASS가 아님. **R681은 아직 사용자 승인 Golden/FINAL이 아니다**.

## R682 복구
- MOA_R682_EXACT_R680_FUNCTIONAL_FORWARD_RECOVERY_ORIGINAL_SIGNED.apk, versionCode682, SHA256 88c94f6567898e91c73c15aed7c0d5b3dd8cdd5404a069a7e8c5ae9fa5df2c77.
- 기존 R680 기능 ZIP 항목 156개 전부 압축 해제 내용 동일; AndroidManifest versionCode만 변경; original signer/v2/ZIP 검증.
- R681 동작 문제가 있으면 **앱 제거·데이터 삭제 없이 R682 덮어쓰기**, 복구 이후 차기 versionCode >=683. 과거 R657/R665 원본 PHOTO 실기기 Golden 불변, R611/R641 기록 유지, Naver/One Hand/QuickRecord/AA AirPods audio 변경 금지.

## 모든 다음 모아 업데이트의 영구 릴리스 Gate
- 가장 먼저 MOA_READ_FIRST_NEW_CHAT.md, MOA_APP_VERSION_SETTINGS_PERMANENT_GOLDEN_ADDENDUM_20261117.md, 이 문서와 최신 Library/브랜치/APK/실기기 결과 확인.
- 메인 CALENDAR/PHOTO ADD 상단을 PHOTO/DETAIL 원본 기하로 맞춘 실기기 픽셀 비교·네 화면 스위치/날짜 이동 테스트.
- 내 지도/기록/설정→일기 각각 10회, 구형 UI 미표시, 상태바 미노출, native gallery 확대/영상 seek/8 original actions/QR 재진입.
- **설정 버전 정보는 실제 패키지 versionCode·versionName과 일치**. 차후 PackageManager 동적 연동을 구현하는 것이 목표. 불일치·구버전 캐시 잔존시 release block.
- 절대 uninstall/data clear/cookie reset·임의 Golden 덮어쓰기·다른 앱 오디오 변화 금지.
