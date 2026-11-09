# MOA R233: 네이버 웹뷰 '앱 설치/열기' 화면 실증 후 데스크톱 진입 경로 진단 수정 (2026-11-10)

## 사용자 실기기 증거와 실제 원인

- 사용자가 2026-11-10 제공한 개인 영상 `19991.mp4` (15.60초) / `20004.mp4` (19.05초) 확인. 영상과 캡처 원본·정밀 위치·사용자 계정정보를 **공개 GitHub에 업로드하지 않는다**.
- R231: 설정의 `네이버 웹 연결 실험`을 열면 `map.naver.com`의 **'네이버지도 앱 설치 / 네이버지도 앱 열기' 모바일 유도 페이지**가 표시됨. 네이버 로그인 차단이나 계정 정지를 입증한 증거는 없음.
- `20004.mp4` 상단 진단은 `VISIBLE_PAGE_FINISHED_UNVERIFIED`, `NON_NAVER_NAVIGATION_BLOCKED` 등을 표시. R231 `MoaNaverWebProbeHost.java`는 모바일 WebView 기본 UA에서 `https://map.naver.com/p/`를 열고, `shouldOverrideUrlLoading()`에서 https가 아니거나 `.naver.com` 외의 탐색을 차단하여 모바일 유도 페이지의 `intent://`, `nmap://` 등 앱 열기 시도를 `NON_NAVER_NAVIGATION_BLOCKED`로 통합 표기했음. 이는 **로그인 에러 코드가 아니다**.
- 사용자 검증: R229/R231 네이버지도 **플로팅 '↶ MOA' 한 터치 복귀는 정상**, 고장낸 것으로 간주하지 말 것. R231 설정 카드도 현장 표시됨(별도 미세 UI 동작 전체 QA는 별개).

## 선택한 수정 (R233 테스트 게이트)

1. 기존 네이버지도 앱·R231 설정·갤러리·음성·일기 데이터에는 손대지 않는다.
2. 별도, 사용자가 직접 실행한 WebView 실험에만 **데스크톱 User-Agent**를 사용하고 `useWideViewPort`/`loadWithOverviewMode`로 PC 웹 지도를 요청한다. 네이버 사이트가 실제 PC 지도 페이지를 제공할지는 기기에서 확인해야 한다.
3. `shouldOverrideUrlLoading`: 기본 앱 딥링크 차단은 유지하되, `NAVER_APP_OPEN_REQUEST_SUPPRESSED_WEB_ONLY`, `NON_HTTPS_NAVIGATION_BLOCKED`, `EXTERNAL_WEB_NAVIGATION_BLOCKED` 등 **정확한 종류**를 표시한다. 서브프레임 기본 탐색은 WebView에 맡긴다.
4. 페이지 로드 후 단순 앱 설치 링크 존재 여부만 검사하여 웹이 여전히 앱 설치 유도 페이지인 경우 `NAVER_APP_INSTALL_LANDING_DESKTOP_REQUEST_UNSUCCESSFUL`을 표시할 수 있도록 한다. **본문·계정·비밀번호·로그인 쿠키·개인 좌표를 읽거나 공유하지 않는다**.
5. WebView 종료 시 `CookieManager.flush()` 처리하여 사용자가 웹에서 직접 로그인한 세션 쿠키를 디스크에 반영하도록 한다. **네이버지도 네이티브 앱의 로그인과 WebView는 서로 독립**이며, 웹에서 최초 로그인이 필요할 수 있다. 웹 쿠키가 유효한 동안 다음 실행에서 로그인이 유지될 수 있지만 네이버의 만료/인증 정책으로 무조건 유지되지는 않는다.
6. WebView는 기존과 같이 설정에서 **사용자가 눌러야 실행**, 네이버 실제 즐겨찾기/리스트 쓰기 **미구현**. R233은 진단 수리 테스트 빌드, 자동화 성공 판정 금지.

## 빌드·바이너리 검증

- Source isolated branch: `feature/moa-r233-webview-mobile-landing-fix-20261110`; original R231 source branch is unchanged.
- GitHub Actions Android35+WebKit source/DEX compilation run `42643411824` **SUCCESS**. Produced WebkitRuntimeDex1-3; R231 `classes11.dex`, `classes12.dex` byte-identical, newly compiled `classes13.dex` only differs.
- Updated APK `MOA_R233_NAVER_WEB_DESKTOP_GATE_BETA.apk`; package **`com.juhyeon.familyjournea`**, versionCode **233**, original signer SHA256 **`5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`**.
- APK SHA256 **`cdf3bf3a56a797e00883189bae66f859edf193432c9acea893b8af04caf20517`**, bytes **8,895,626**.
- Backup `MOA_R233_NAVER_WEB_DESKTOP_GATE_BACKUP.zip` SHA256 **`ded0800e3e1213d3291f2c38582f05bbedc8aabf0b49d67025b598e20cc24227`**, bytes **6,430,399**, contains byte-identical same APK, CRC PASS.
- Verified **APK Signature Scheme v2 and same original certificate**, `aapt versionCode 233`, 13 DEX SHA1/Adler32 PASS, APK ZIP 136 entries CRC PASS, **134 of 136 entries exactly preserved** from R231; changed only `AndroidManifest.xml` code231→233 and `classes13.dex` (WebView probe).
- R227 immutable Golden SHA256 `53c4c04ce32ad13de3c0613f4e5ec7abbc75ccbdfe9db5da05d8fa9b806ec6cd` unchanged. Keep R229 Galaxy-tested one-tap return; R231 and R233 versioned beta remain separate.

## 갤럭시 실기기 PASS/FAIL 게이트 (R233 = pending)

1. 기존 MOA 위에 **업데이트 설치**만. 앱 삭제·데이터 지우기 금지.
2. 설정 → 네이버지도 복귀 버튼 → 네이버 웹 연결 실험 → 네이버 웹 연결: 네이버 **PC 웹 지도**가 실제 열리는지, 아니면 여전히 '앱 설치 / 앱 열기' 페이지인지 확인. 실패한 경우 위 상태명을 사진으로 보여주되 개인정보는 가린다.
3. PC 웹 지도가 열리면 네이버 웹에서 **직접** 로그인(필요한 경우 1회) → 모아로 → 숨김 진단 → 프레임 요소 수 표출 여부. 네이버 앱에 로그인되어 있어도 웹뷰 자동 로그인은 보장되지 않는다.
4. 실험 종료 후 같은 웹뷰 실험 재실행: 웹 로그인 유지 여부. 로그인이 필요하면 비밀번호는 네이버 웹 화면에만 직접 입력; 대화/로그에 보내지 않음.
5. 네이버지도 앱 사진 위치 → `↶ MOA` 한 번 → **같은 사진**으로 돌아오는지 회귀 검사, 바로기록·음성·일기·갤러리 정상 여부 확인.
6. 저장/리스트 생성 **아직 시도하지 않는다**. 실제 네이버 계정 리스트 read-back 없는 저장 PASS를 주장 금지.

## 실패 시 현실적인 방향

- R233에서 네이버가 여전히 앱 설치 페이지를 강제하거나 WebView 로그인에 제한을 둔다면, 무조건 같은 웹뷰를 또 강제하지 않는다. 사용자가 원한 **MOA 비점유 저장**은 별도 브라우저 실행권한·네이버 계정 세션·실제 저장 확인이 필요한 작업이다.
- 대안 A: 선택적 **PC/개인기기 내 headless Playwright 작업자** + 사용자가 웹에서 1회 로그인(가능한 범위), Android MOA는 저장할 장소를 큐에 넣고 PC가 처리·네이버 저장 결과 재확인. PC 전원이 꺼져 있으면 동기화 대기. 이것은 PC 의존성이 있으므로 사용자가 승인해야 한다.
- 대안 B: 기존 네이버지도 앱의 사용자 동의 **1건 전면 자동화 + 플로팅 복귀**, 계정 저장 확인. 화면 비점유가 아니므로 목표 완료로 포장하면 안 된다.
- 공식 네이버지도 URL Scheme `nmap://place`는 **장소 열기**이지 계정 즐겨찾기 쓰기 API가 아니다. 네이버 로그인 OAuth 앱 연동은 지도 앱의 세션을 복사하는 기능이 아니다.

## 공식 문서

- Android WebViewClient: https://developer.android.com/reference/android/webkit/WebViewClient
- Android WebView cookies: https://chromium.googlesource.com/chromium/src/+/HEAD/android_webview/docs/cookies.md
- Android WebView app data: https://developer.android.com/develop/ui/views/layout/webapps/webview
- Naver 로그인 SDK 및 네이버앱 스킴 로그인(네이버지도 앱 로그인과 구분): https://developers.naver.com/docs/login/devguide

**현재 상태: R233 original-signer static build PASS, desktop NAVER web login/hidden frame/account favorites actual Galaxy PASS 미확인. 사용자의 이전 R229 1-tap return PASS는 보존.**