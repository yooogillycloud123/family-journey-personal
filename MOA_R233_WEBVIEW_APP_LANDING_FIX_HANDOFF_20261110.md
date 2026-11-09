# MOA R233 — 사용자 제공 영상 기반 네이버지도 웹뷰 '차단' 원인 판정 및 PC 웹 진단 패치

기준: 2026-11-10 / 사용자 Galaxy S26 Ultra R231 실기기 `19991.mp4`(15.60초), `20004.mp4`(19.05초), R231 GitHub source `experiments/moa-r231/source/com/juhyeon/familyjourney/MoaNaverWebProbeHost.java`, preserved signed R231 APK.

## 1. 실제 확인한 사실

- R231에서 `설정 > 네이버 웹 연결 실험`을 열었을 때 실제 지도 웹 UI가 아니라 모바일 `m.map.naver.com`의 **네이버지도 앱 설치/열기 유도 랜딩 페이지**가 나타남. 사각형 지도 일러스트, `네이버지도 앱 설치`, `네이버지도 앱 열기`를 보여줌.
- `네이버지도 앱 열기` 터치 등으로 타 앱 실행용 URI로 이동하려고 할 때 R231's internal `WebViewClient.shouldOverrideUrlLoading()` 조건 `safe = https && isNaverDomain(host)`가 실패해 자체 진단 `NON_NAVER_NAVIGATION_BLOCKED` 출력. **네이버 계정 차단, 로그인 실패, 서버 보안 정지 메시지가 아님.**
- 영상 마지막에도 실제 네이버 웹의 저장·리스트 UI 접근은 입증되지 않았고, R231은 **실제 즐겨찾기 저장 기능 자체가 없는 읽기 전용 PoC**.
- 기존 R229의 네이버지도 위 `↶ MOA` 원래 사진 복귀는 사용자 기기에서 PASS. R231 관련 사용자는 본 대화에서 복귀 정상 동작 재확인함. 원본 R227 골든/이전 릴리스 변경 금지.

## 2. 로그인: 다른 앱과 WebView는 세션 별도

- 네이버지도 **네이티브 앱에 로그인**한 세션·쿠키가 MOA 소유 **WebView**에 자동 공유되지 않는다. 앱 서명을 같게 유지해도 타사의 인증 쿠키를 취할 권한은 생기지 않는다.
- WebView에서 **별도 웹 로그인 한 번** 허용되면 Android WebView CookieManager가 앱 내 브라우저 쿠키를 저장/재사용할 수 있지만, 만료·보안 재인증·서버의 WebView 접근 제한 등에 따라 다시 인증할 수 있다. 이번 R233은 `CookieManager.flush()` 사용하되 **로그인 비밀번호/쿠키를 읽거나 추출하지 않음**.
- 공식 Naver OAuth Android SDK `WEB_VIEW_IS_DEPRECATED`는 NAVER Android 로그인 API WebView 인증 방식의 제거를 뜻한다. 그것은 NAVER Maps 즐겨찾기/리스트 쓰기 API를 제공하는 것과 전혀 다르다. 네이버 계정 OAuth 로그인만 성공해도 지도 즐겨찾기를 쓸 수 있다는 보장은 없다.

## 3. R233 변경 범위 — 오로지 WebView 진단

소스 브랜치 `feature/moa-r233-webview-mobile-landing-diagnostic-20261110`. GitHub Actions CI `42645150726`: Android35/Java17/AndroidX runtime DEX and JS static tests SUCCESS. 실기기 PASS는 아직 없음.

- `MoaNaverWebProbeHost.java`: **선택적으로 활성화되는 전용 WebView에만** desktop User-Agent + wide viewport + overview/zoom 설정 적용하여 앱 설치 유도 모바일 랜딩에서 PC 지도 웹 UI 접근을 시도. MOA 일반 WebView, 갤러리, 음성, 일기, Quick Record에는 UA 변경 없음.
- 내비게이션 실패를 원인별 구분: 네이버 앱 열기 시도는 `NAVER_APP_OPEN_REQUEST_SUPPRESSED_WEB_ONLY`, HTTPS 네이버 외부로 이동은 `EXTERNAL_WEB_NAVIGATION_BLOCKED`, 기타 URI는 `NON_HTTPS_NAVIGATION_BLOCKED` 등. 타 앱 강제 실행 없음. iframe 내 비HTTPS 이동은 자체 WebView 규칙을 과잉적용하지 않고 그대로 둠.
- 브라우저 로드 완료 상태와 앱 설치 링크 존재 여부를 읽기만 하는 진단. 앱 설치 링크만으로 웹 접근 불가가 확정되는 것은 아니므로 **오진 가능성**을 포함한 베타. 네이버 계정, 화면 내용, 위치 좌표, 비밀번호 또는 쿠키는 수집하지 않음.
- `assets/web/moa-r231-settings.js`: 실험 버튼명을 `PC 웹 연결 진단`으로 바꾸고 기계적인 상태코드 대신 한국어 사유를 설명. 네이버지도 앱과 WebView 로그인 세션이 자동 공유되지 않는다는 안내.
- 원본 `com.juhyeon.familyjournea`, original signer 유지. R231 기준 정확히 **3개 APK 멤버만 변경**: `AndroidManifest.xml` code231→233, `assets/web/moa-r231-settings.js`, `classes13.dex`. 나머지 **133/136 기존 멤버 내용 동일**, 기존 13 DEX 유지. 실제 가족 데이터·갤러리·앱 설정 DB 변경 안 함.

## 4. 서명 및 검증된 독립 산출물

- APK: `/mnt/data/MOA_R233_NAVER_PC_WEB_DIAGNOSTIC_FIX_BETA.apk`, size **8,899,722 bytes**, SHA-256 **4869fca60a4c9e6042d567389d3a9b492cb7ee67c3c1f9a9e6ac77f799567672**, code233.
- 인증서 SHA256 **5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15** (same as R227/R229/R231). `apksigner verify` v2 PASS. ZIP CRC PASS, DEX SHA1/Adler32 PASS, aapt package/code PASS.
- ZIP: `/mnt/data/MOA_R233_NAVER_PC_WEB_DIAGNOSTIC_FIX_BACKUP.zip`, size **6,430,652 bytes**, SHA256 **41dd738a9cc0337a26fc12517a2e13442c43e02e94fca0b6c87b7c897f909378**. Contains exactly same APK bytes. Backup ZIP CRC PASS.
- QA JSON at `/mnt/data/MOA_R233_NAVER_PC_WEB_DIAGNOSTIC_FIX_QA.json`.

## 5. Galaxy 시험 및 결정 규칙

- **업데이트만** R231→R233. 앱 삭제·데이터 지우기 금지. Gallery→NAVER app→ `↶ MOA` 1탭 복귀 같은 사진 보호 확인.
- 설정→네이버지도 복귀 버튼→ `PC 웹 연결 진단`. 실제 PC 네이버지도 지도/검색 창인지, 같은 앱 설치 안내인지 구분. **모바일 앱 설치 화면이 그대로라면 웹뷰 실제 지도 사용은 실패**로 처리. 앱 로그인과 지도 읽기·쓰기 검증 금지.
- PC 웹 지도 화면이 나타나도 바로 즐겨찾기 자동 저장 PASS로 승격하지 말 것. 별도 웹 로그인 유지, 읽기 전용 `숨김 진단` 후 사용자가 승인한 더미 장소 한 건 실제 쓰기 + 네이버 목록 readback 등 단계별 별도 개발 필요.
- 만약 네이버에서 모바일 WebView 접근을 강제 앱으로 돌린다면 반복적인 UA 변경이나 보안 인증 우회는 하지 않고 다음 대안 평가: 선택적으로 PC Chromium/Playwright 로컬 엔진(사용자가 브라우저에 직접 로그인한 세션), 네이버 앱 화면을 잠깐 사용하는 접근성 자동화 + 즉시 복귀, 또는 MOA 자체 로컬 즐겨찾기 대기열. 사용자는 Shizuku/root/ADB/보조 APK를 원치 않음.

## 6. 출처

- 사용자 동영상은 **비공개**; 공개 GitHub에 업로드하지 않는다.
- NAVER Developers: https://developers.naver.com/docs/login/devguide / https://developers.naver.com/docs/login/android/android.md
- Android CookieManager: https://developer.android.com/reference/android/webkit/CookieManager
- Android WebSettings: https://developer.android.com/reference/android/webkit/WebSettings
- 변경 사항은 **서명된 R233 베타까지 제작**, **Galaxy 실기기 네이버 PC 웹 로그인·지도 UI는 아직 미검증**.