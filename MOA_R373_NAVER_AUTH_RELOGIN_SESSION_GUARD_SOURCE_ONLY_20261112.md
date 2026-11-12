# MOA R373 — NAVER 로그인 인증 충돌 방지 SOURCE/DEX ONLY (2026-11-12)

## 사용자 사실(우선순위 1)
- R275/R279에서는 네이버 아이디·비밀번호 이후 영수증 형태의 추가 인증이 반복되거나 확인을 눌러도 진행되지 않았음.
- R283 설치 후 Galaxy에서 정상 2차 인증을 거쳐 로그인 성공한 사실이 기존 프로젝트 WIP에 기록됨. 사용자는 이 로그인 세션이 R365까지 업데이트 중 유지됐다고 직접 보고함.
- R365 이후 로그아웃이 발생했고, 다시 인증하려 하니 영수증 인증 실패가 재발했으며 여러 후속 수정으로도 복구되지 않음.
- **다시 로그인하지 않은 상태에서 수십 개 버전이 세션을 유지했다고 해서 재로그인 절차까지 검증된 것은 아님.**

## 실물·소스 조사
1. R279→R283 핵심 해결: 네이버 PC 지도 WebView는 데스크톱 UA 유지, 정식 `https://nid.naver.com/` 로그인 main-frame에서는 **Android WebView 원래 UA**로 전환 `setUserAgentString(null)`, 1회 URL restart 및 onPageStarted/shouldOverride fallback. 최초 R283 성공은 실기기 확인.
2. 개인 Library의 **실제 R345 서명 APK** `MOA_R345_EXACT_ADDRESS_HEADER_STAR_CLICK_REPAIR_BETA.apk` (SHA256 `fe2aaaac15d39a610268ee3d10361652a95537e0ce8ec9cde86e98edf3f8ceb1`)를 열어 확인: `classes13.dex` 20,120 bytes SHA256 `a0485dbff1186709d970e703a37d26fe2f2e57e4ef9e2147cd594937cb2286ef`, DEX 문자열 `setUserAgentString`, `nid.naver.com`, 데스크톱 Chrome/131 UA 확인. **R283의 정확한 메서드 실행 경로까지 동적 검증했다는 뜻은 아님.**
3. R365→R369 배포 기록에는 원래 16 DEX/R345 NAVER writer/frame 보존이 명시돼 있어, **R283 UA 코드가 삭제됐다고 단정할 근거 없음.** 그러나 R369 최신 signed APK 자체는 이번 컨테이너/Library에 없음; 직접 byte hash 대조는 미완료.
4. GitHub 실제 R369 `MoaR365CompanionProvider.java`: 3초 host monitor가 자체 앱 origin WebView를 찾아 기존 NAVER controller `start()` → `setHidden(true)`를 반복적으로 보강. `deliver()`가 native favorite 작업을 보낼 수 있음. **인증 UI 진행 중 이 작업이 개입할 가능성**을 줄이는 것이 이번 좁은 패치 목적. 갑작스러운 로그아웃이 이 코드 때문에 발생했는지는 입증 안 됨.
5. 네이버 서버/보안 정책, WebView 버전/프로필/쿠키 수명/2차 인증 방식 변동은 아직 원인 분리되지 않음. 인증 우회·캡차 자동해결·자격증명/쿠키 수집 금지.

## 실제 변경 — GitHub feature branch SOURCE
- [R373 source branch](https://github.com/yooogillycloud123/family-journey-personal/tree/feature/moa-r373-naver-auth-preservation-20261112)
- `experiments/moa-r365/MoaR365CompanionProvider.java`: 공식 NAVER 로그인 HTTPS 호스트를 보여주는 동일 앱 소유 WebView가 탐지되면 hidden-start, queued task delivery, 3초 background monitor의 실행부를 모두 일시 중단. 인증 종료 뒤 기존 모니터로 복귀. 원래 R283 `classes13.dex`, R345 NAVER writer/frame 및 Diary, recorder 소스 수정하지 않음. 현재 WebView.getUrl 탐지에 의존하며 리디렉션 중 창이 view tree 밖에 있으면 누락될 수 있음.
- `experiments/moa-r365/MoaNaverAuthUrl.java`: 정확한 first-party HTTPS auth host matcher. 제3자 유사 호스트, HTTP, 지도 페이지에서는 pause 하지 않음.
- `experiments/moa-r365/MoaNaverAuthUrlTest.java`: 순수 Java 허용/거부 호스트 테스트 13개. 일반 사용자 인증정보·WebView 쿠키 사용하지 않음.
- `.github/workflows/moa-r369-native-retry.yml`: R373 별도 branch 빌드, helper+provider 함께 D8 컴파일, 안전한 테스트.

## QA
- GitHub Actions [43189444467](https://github.com/yooogillycloud123/family-journey-personal/actions/runs/43189444467): SUCCESS; JDK17 Java matcher test / Android35 provider DEX compile / artifact upload.
- Artifact `MOA-R373-AUTH-GUARD-EXTRA-DEX-NO-SIGNING-KEYS` (CI id `13928999745`): DEX 16,952B SHA256 `c6b414bf72fabca8e037979f27e5e8704b30ddea5b770d05729e14fc2e90e150`; provider and matcher class, R373 status strings 확인. 이 파일은 **APK 아님**.
- **미검증:** 실제 Galaxy 화면에서 auth guard 진입, 로그인 성공, 영수증 인증 제거, 로그아웃 원인, 네이버 첫 번째 저장/리스트 readback, R369 전 기능 회귀.
- 현재 Library에는 R345 구버전 signed ZIP만 확인. R369 signed binary 및 변경된 최신 JS/DEX 전체를 재구성할 검증된 릴리스 ZIP이 없음. R345로 APK를 새로 서명하면 R357~R369 기능을 잃을 수 있어 **사용자에게 설치용 R373 APK라며 배포하지 않음**.

## 다음 릴리스 게이트
- 현재 설치된 최신 **서명 APK 실물** 확보 → 버전·원래 서명 인증서·모든 DEX/JS hash 검증 → R369 binary의 실제 R283 UA 메서드 경로 확인.
- 인증 중 백그라운드 시작이 실제 발생하는지 개인 비밀 없는 상태코드로 확인. 인증 화면의 host-only 상태 감지/UA 복귀 동작 추가 검증.
- 원래 최신 APK에서 **수정된 provider DEX만** 교체, 다른 오디오/모아 UI·일기·기록·저장 엔진은 그대로 보존, manifest versionCode > 현재 설치본 및 rollback 코드. 개인 Library에 보존된 **원래 같은 서명키**로 오프라인 서명, APKv2/DEX/ZIP/출력원본 hash gate 통과.
- 실기기에서 본인이 네이버 공식 화면으로 정상 로그인 및 2차 인증 성공/세션 유지 확인한 뒤에만 최종 승격. 보안 인증 실패하면 우회하지 않고 정확한 상태로 보류.
- 앱 제거, 앱 데이터·쿠키 초기화, 자동 로그아웃/강제 재로그인, 개인 키/인증정보 GitHub 업로드 금지.

**상태: R373 SOURCE + COMPILED ADDITIVE DEX VERIFIED, NO SIGNED INSTALLABLE APK, NO DEVICE AUTH PASS.**
