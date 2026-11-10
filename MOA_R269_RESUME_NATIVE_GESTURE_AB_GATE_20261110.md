# MOA R269 — 멈춘 작업 인수 및 WebView 사용자 제스처 A/B 실험 (2026-11-10)

## 최상위 보존
- 사용자가 지정한 R269 원본 Golden **절대 불변**: `com.juhyeon.familyjournea` code269, SHA256 `c0663e65aac2b72feb86cb0f1ba5eac448b6599c3850858de4d942f2aa446920`, 기존 원본 서명. R227 등 다른 Golden도 변경하지 않았다.
- 변경은 독립 **연구 브랜치** `research/moa-r269-webview-kvm-frame-gate-20261110`의 익명 테스트 Java 및 GitHub Actions 두 파일에 한정한다. 유저 설치용 모아 APK를 제작한 것이 아니다.
- 최종 요구 불변: 모아 화면 조작 유지, 네이버 앱 전경 점유 없이, 사진 GPS에서 실제 NAVER 계정 폴더 생성·SID 장소 저장·별명·메모 쓰기, 서버에서 동일 값 재조회, PC/루트/Shizuku/별도 도우미 앱 없음.

## 이미 실제로 확인된 CI
- Android35 emulator run [42812425818](https://github.com/yooogillycloud123/family-journey-personal/actions/runs/42812425818) success: Android WebView에서 `pcmap.place.naver.com/place/1628573942/home`의 실제 Place `a[data-nlog-area="map_btp.save"]`를 읽음; 2×2 크기에서도 DOM 유지.
- 같은 run에서 JS `.click()` 자체는 실행됐으나, 12초 뒤 `dialogCount=0;loginTextVisible=false`. 사용자 제스처 인정, 로그인, 개인 서버 저장, 자동 리스트 생성, readback **모두 미확인**.
- PC parent `map.naver.com` 에뮬레이터 DNS -2와 직접 Place 로딩 성공은 분리해 판단한다. 사전 R241 / R233 무한 리다이렉트 경로로 되돌아가지 않는다.

## 이번 세션 실제 소스 변경
- `554a2dd123b19b2a2e084c33242b8c5925d62859`: 완전 불투명한 MOA 모의 전경 터치 리스너, WebView 내부 save 버튼에 ACTION_DOWN/UP 전달 뒤 7초 익명 UI 결과 관측. 개인 데이터/로그인/쿠키/계정 쓰기 없음.
- `356618f12e80779f23d53ac508e9f47d5c60e223`: CI에 실제 Android 전경 커버 탭과 UI 변화 로그 필수 Gate 추가.
- `464a99f053f528c0391c82a35e5344c05c98f682`: JS 클릭 직후 상태가 native touch A/B 결과를 오염시키지 않게 **새로 직접 Place 문서 로딩**.
- `e0d709262824c2bc027001391912a6ba53e35fa2`: cover on 153s / native touch 약158.5s / 실제 전경 tap 174s / log capture 190s로 CI 정렬.
- GitHub Actions workflow `.github/workflows/moa-r269-android-webview-frame-test.yml`은 branch/paths push trigger이며, 신규 CI 실제 PASS/FAIL 로그는 **이 문서 작성 시 미확인**. 변경한 소스가 컴파일/실행에 성공했다는 주장 금지.

## 다음 판정
1. 해당 워크플로의 최신 run/job log에서 `NATIVE_TOUCH_FRESH_DOCUMENT`, `NATIVE_TOUCH_SENT`, `NATIVE_TOUCH_POST_UI`, `MOA_COVER_CLICK`, `AUTH_POPUP_REQUESTED`를 검사. FAIL이면 정확한 첫 실패 Gate를 분리.
2. 버튼 자체 클릭 및 공식 로그인 UI가 정상적으로 열리기 전에는 기존 Golden APK에 실험 코드를 넣지 않는다.
3. 사용자 참여는 **오직 본인 폰의 정식 네이버 로그인**과 실제 저장 결과 1건 확인 시점에만 필요하다. 자격증명·OTP·쿠키를 개발자/채팅/로그에 수집하지 않는다.
4. 실제 NAVER 계정에 지정 폴더/SID/별명/메모를 저장하고 별도 세션 재조회가 정확히 일치할 때만 `NAVER_READBACK_VERIFIED`. 익명 DOM/터치/인증팝업은 그 자체로 저장 성공이 아님.
5. 완료 및 실제 Galaxy 검증 이전에는 'R269 FINAL APK', '네이버 저장 완료'로 표시하지 말 것. Golden 삭제/수정/언인스톨/data clear 금지.

## 링크
- [실제 연구 workflow](https://github.com/yooogillycloud123/family-journey-personal/actions/workflows/moa-r269-android-webview-frame-test.yml)
- [원래 연구 측정](MOA_R269_OFFSCREEN_WEBVIEW_KVM_DNS_FRAME_QA_20261110.md)
