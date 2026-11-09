# MOA R229+ 분리형 구현 — NAVER 빠른 복귀 + 비점유 웹 실험

**상태: feature branch source-only / 실제 R227 또는 새로운 R229 APK에 미탑재.**

## A. 갤러리 → NAVER 앱 → '↶ MOA' 한 번 눌러 복귀

- 사용자 현장 R227: 동일 사진 복귀 성공, 네이버 앱에서 시스템 Back 3회 필요.
- R227 원본 `MoaNativeGallery.java` 복사본 기준 **호출 3곳만 수정**: NAVER 앱 시작 직전 전용 오버레이 show, MOA 돌아오면 hide, 갤러리 close 시 hide. 녹음/사진/필름스트립/자동 메모 구조 그대로.
- `MoaNaverReturnOverlay`: Galaxy 사용자가 이미 부여했을 수 있는 `SYSTEM_ALERT_WINDOW`/`Settings.canDrawOverlays` 사용. 네이버 지도 화면 위에 다크 그레이 알약 배경+피치/핑크 액센트 `↶ MOA`와 작은 X. Quick Record의 스타일(`#252830`, `#ef3157`, 엣지/코너 8개 편집)를 참고하며 **프리퍼런스 파일을 독립**시키므로 바로기록 UI 영향 없음.
- 누르면 `ActivityManager.AppTask.moveToFront()`로 정확한 MOA 기존 task를 최우선 복귀; 실패하면 원래 host 액티비티에 `REORDER_TO_FRONT` PendingIntent 시도. 앱을 초기화하거나 새 갤러리를 열지 않음. NAVER 내부 Back stack을 바꾸는 것은 아니다.
- 짧게 X → 임시 버튼 숨기기, 길게 → 편집 모드, 이동·8방향 크기조절·화면 방향별 위치/크기 저장. 편집 중 X → 완료. 복귀/갤러리 닫기 시 오버레이 즉시 제거. 기본 154×48dp, 주 버튼이 X보다 넓고 X 터치 대상 44dp.
- 권한 없으면 **아무 팝업이나 요청 화면을 강제로 띄우지 않고** 기존 R227 네이버 지도 열기/뒤로가기 그대로 작동. 향후 앱 설정에서 opt-in 권한 허용으로 연결할 것.
- 실제 Galaxy Android 17 / One UI와 NAVER: 오버레이 `moveToFront`/PendingIntent / orientation / 키가드 / 드래그 / 원 사진 위치 / 하위시트 / 네이버 뒤로가기 동작 **모두 실기 검증 필요**.

## B. MOA 자체 WebView NAVER 저장 가능성 실험

- `MoaNaverWebProbeHost.java`는 **읽기 전용** WebView/AndroidX WebKit 프레임 프로브. 기존 `naver-origin-frame-probe.js`와 연동, `map.naver.com`, `pcmap.place.naver.com`, `pages.map.naver.com` 3오리진의 저장버튼·새 리스트 버튼 **요소 개수만** 보고.
- **이 실험은 즐겨찾기 저장기 아님**, 자동 입력/클릭/로그인/비밀번호 및 쿠키 읽기/내보내기 없음. 코드는 user opt-in start로만 시작되고, 평소에는 WebView를 만들지 않음. stop/destroy 가능.
- WebView의 웹 로그인은 NAVER 앱 계정과 별도 세션일 수 있음. 로그인할 때는 사용자가 네이버 인증 화면을 직접 보면서 입력, MOA는 계정 정보 관여하지 않음.
- `start(false, JS)`: 화면 표시 상태에서 NAVER 웹 프레임 접근 확인. **이게 성공하기 전에는 `start(true, JS)` 사용하지 않는다**. `start(true, JS)`는 1×1 컨테이너에 큰 WebView를 잘라 붙이는 비점유 가능성 실험: JS/레이아웃/렌더링이 정상 유지되는지는 미확인.
- 최초 실제 성공 게이트: 로그인→대상 목록 존재/생성 UI 접근→선택한 실제 POI→저장 버튼→실제 목록 재확인→10건 연속 저장 중 MOA 화면 전환 0회. 현재 이 단계 구현·테스트 **아직 안 됨**.
- WebView 메모리/CPU 증가 테스트는 전체 MOA 기준 before/after 측정 + 종료 후 회수 확인; 정확한 수치나 항상 빠르다는 주장은 아직 할 수 없음.

## 보존 및 배포

- Frozen exact R227 signed APK SHA256 `53c4c04ce32ad13de3c0613f4e5ec7abbc75ccbdfe9db5da05d8fa9b806ec6cd`, code227 unchanged.
- 분리된 feature `feature/moa-r229-nav-return-qa-gated-20261109`, 신규 앱 버전은 반드시 >227, 동일 signer/package, 기존 앱 삭제·데이터 초기화 금지.
- 소스 Javac/DEX CI 통과와 **기기 화면·계정 저장 PASS는 다르다**. 소스가 준비되어도 실제 APK+ZIP 생성/원본 서명·정적/실기기를 통과하기 전에는 완성이라고 말하지 말 것.
- 코드/빌드 검증 과정에서 가족 사진, 음성, 위치, NAVER 계정/쿠키, 서명키 등을 GitHub에 올리지 않는다.