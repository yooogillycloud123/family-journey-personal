# MOA R683 4화면 헤더 정확 좌표 보정 / R684 복구 (2026-11-17)

**현재 최신 MOA 베타는 R683 / 복구는 R684.** R681은 초기 베타이므로 사용자에게 R683을 우선 제공한다. 기존 User Golden/PHOTO·DETAIL·18 DEX를 변경하지 않는다.

## 사용자 2026-11-17 6건
(1) PHOTO+DETAIL 상단 날짜 및 우측 스위치를 정답 고정값으로, CALENDAR/PHOTO-ADD의 X/Y·글꼴·자간 일치; (2) 내 지도/기록/설정에서 일기로 돌아와도 구형 ‘내가 고른 사진일기’ 화면 완전히 미표시; (3) 상태바 시계·배터리 노출과 깜빡임 네이티브 Activity/Window 경로까지 조사 및 실기기 QA; (4) PHOTO-ADD 오른쪽 오늘은 정적 심볼, 슬라이더 그래픽 금지; (5) 사진 추가 확대는 원본 classes6.dex MoaNativeGallery/8 actions, 가짜 WebView 금지; (6) 모든 향후 앱 설정에 실제 버전 정보 상시 표시, manifest/bridge/Settings 불일치 릴리스 금지.

## R683 실제 배포 자산
- MOA_R683_PRECISE_HEADER_GALLERY_VERSION_ORIGINAL_SIGNED_BETA.apk, original package com.juhyeon.familyjournea, versionCode 683, SHA256 e20e446d5e02358e833fe223471735abc3fd042234b4efc53acc208118ee9e8b.
- Original signer cert SHA256 5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15. APK v2 RSA signature+전체 3구역 chunk SHA256 digest 독립 PASS, ZIP CRC PASS, original 18 DEX/18 byte-exact PASS.
- R679의 classes19.dex에서 JNI host exact Activity classname 문자열 인덱스 한 곳을 HostActivity→실제 런처 MoaIconHost, JS bridge version tag R673→R683으로 수정. Original native Gallery classes1..18, 원본 비디오/QuickRecord/지도 소스 불변.
- 메인 달력/사진 추가의 날짜·스위치 CSS PHOTO 기준 보정: Chromium 360/390/412 synthetic geometry에서 달력/사진형/사진 추가 **날짜 X=17** / toggle X=225,255,277 (각 폭별) / top row Y=8 / letter spacing normal 일치. **DETAIL은 원본 수정 없이 보존, 실제 Galaxy 픽셀 동등성은 아직 검증 못함**. PHOTO ADD 확대 bridge mock, TODAY 실제 날짜 이동, 피커 wheel, 3장 선택, no fake viewer 브라우저 회귀 PASS.
- 설정에 ‘모아 앱 버전’ 행 추가, 기존 compiled bridge.version() R683 빌드 번호 표시. Android PackageManager.versionName 동적 API, superclass-loop host guard, onResume native statusbar 재제어는 이번 DEX에 **컴파일되지 않았음**. 상태바 플래시 실기기 문제 해결 선언 금지.

## R684 복구
- MOA_R684_EXACT_R680_FUNCTIONAL_FORWARD_RECOVERY_ORIGINAL_SIGNED.apk, code684, SHA256 145b2b4f26d2d8f899db7df0bdcbab55ffec170d0cc01e806c4e4f7b6f10903c.
- R680 원본 모든 156개 non-Manifest entries byte-exact, 버전만 684. R683에 문제가 생기면 원래 package/signer 그대로 앱 제거하지 말고 R684 업데이트 설치. 차기 versionCode >=685.

## 실기기 미확인 및 영구 Gate
- 공식 apksigner/aapt2 실행, Galaxy 실제 설치·원본 갤러리 열림, 네이버/기록/설정 10회 왕복, 상태바 OS icon flash, 실제 4화면 픽셀 실측은 미확인. **따라서 R683도 DEVICE-UNVERIFIED BETA, GOLDEN/FINAL 아님.**
- 모든 차기 버전 설정의 버전코드/버전명은 실제 Manifest·PackageManager와 동기 검증하고 사용자에게 보임. 기존 Golden/원본 18 DEX/QuickRecord/Naver/IndexedDB 및 AA AirPods 오디오 보존. 앱 삭제·데이터 삭제·쿠키 초기화 금지.
- 이전 문서 MOA_R681_HEADER_GALLERY_VERSION_PERMANENT_HANDOFF_20261117.md 및 영구 설정 규칙 MOA_APP_VERSION_SETTINGS_PERMANENT_GOLDEN_ADDENDUM_20261117.md를 함께 보존.
