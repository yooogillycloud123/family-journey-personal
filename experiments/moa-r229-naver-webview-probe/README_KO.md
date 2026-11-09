# MOA R229+ NAVER iframe WebView 안전 실험 (소스만, 신규 APK 없음)

실험 목적: Shizuku/루트/별도 네이버 앱 화면 전환 없이 MOA 내부 WebView로 NAVER의 **브라우저 UI의 프레임 접근이 가능한지** 먼저 검증한다. 이 파일은 자동저장기/계정 로그인기 아님. **실제 NAVER 계정에 어떠한 변경도 가하지 않음**.

## 실제 구현 범위

- `naver-origin-frame-probe.js`: 3개의 NAVER HTTPS 오리진으로 제한된 프레임 주입 스크립트. 네이버 UI 저장/리스트/메모 관련 **현재 나타나는 요소 개수만** 집계해 `MoaNaverProbeBridge.postMessage()`로 전달. 텍스트, 주소, 비밀번호, 쿠키, 로그인 토큰 등을 수집하지 않음. 사용자 click/입력/네트워크 요청 없음. 30초, 최대 8개 변경 보고, 최대 100회 DOM 변경 후 종료.
- `test-probe.cjs`: 자체 비밀/클릭/쓰기 API 미사용 및 오리진 차단 테스트. Node22에서 `node test-probe.cjs` PASS. **이것은 Galaxy/실네이버 사이트 검증 아님.**

## Android 통합 스파이크 가이드 (아직 미구현)

1. 기존 `com.juhyeon.familyjournea` R227 골든을 그대로 보존하고 R229+ source-only branch에서 별도의 `MoaNaverWebSaveWorker` 구현.
2. 앱 개발자가 사용자에게 명확하게 표시하는 `네이버 웹 로그인` 전용 화면을 먼저 제공. 사용자가 직접 로그인하고, MOA는 비밀번호/OTP/세션 쿠키를 읽거나 내보내지 않음. 로그인 실패/웹 차단 시 명시적 FAIL.
3. 앱 자체 소유 WebView에 AndroidX WebKit의 `WebViewCompat.addWebMessageListener(webview,"MoaNaverProbeBridge",allowlist,listener)`를 먼저 등록. **메시지는 반드시 listener 인수의 `sourceOrigin`과 isMainFrame을 검사하고 데이터 길이·type·origin을 제한**.
4. `WebViewCompat.addDocumentStartJavaScript(webview,PROBE_JS,allowlist)`를 **loadUrl 이전** 등록; 실제 iframe의 origin마다 probe script를 실행. WebViewFeature 지원 여부를 먼저 검사. Android WebView에 어떤 cross-origin iframe이 있는지 실제 렌더링 결과는 미확인. 지원 불가 시 STOP.
5. `https://map.naver.com/p/`를 별도 WebView에 탐색. **처음에는 보이는 테스트 패널로 인증/렌더링 검증**, 이후 유효하다면 화면 밖/비점유 실행 상태에서 같은 검사가 유지되는지 별도 검사. 숨김 WebView에서 스크립트/렌더 타이밍이 멈출 수 있으므로 처음부터 hidden success 가정 금지.
6. 비밀번호/쿠키/각종 개인정보 포함한 로그는 저장/전송/스크린샷 금지. 필요한 디버그 메시지는 `{schema,origin,counts,...}`만. Play 정책, NAVER 서비스 이용 약관 및 인증 흐름 제약 준수.
7. 로그인/실제 DOM 프레임 접근/복구/전면 화면 비점유까지 성공한 후에야, 독립 설계된 사용자 1회 승인 `place+list` 작업의 실제 저장/리스트 재조회 성공 여부를 실기기에서 검증. **정확한 장소 미확인 시 자동 저장 금지**.

## 게이트

- 지금: `JS source static mock PASS`, `Android SDK compile UNKNOWN`, `actual NAVER WebView login UNKNOWN`, `cross-origin iframe injection UNKNOWN`, `offscreen rendering UNKNOWN`, `NAVER account write UNKNOWN`.
- 사용자 디바이스에서 실험 모듈 없이 원래 R227을 사용 가능. R227에서는 갤러리 동일 사진 복귀 해당 영상 PASS, 엄격한 네이버 내부 1 Back FAIL, 화면 비점유 즐겨찾기 FAIL.
- 실험 실패해도 새로운 helper APK/권한 우회/Shizuku 요구 없이 동작하는 기존 사용자 화면 기반 저장 기능은 원형 보존한다.

AndroidX official API: https://developer.android.com/reference/androidx/webkit/WebViewCompat