# MOA R233 — NAVER WebView 모바일 앱 설치 유도/차단 진단 수정 인수인계

작성일: 2026-11-10 KST. *R227 immutable Golden / R229 user-device pass / R231 WebView landing-page device failure.*

## 사용자의 R231 실제 테스트
- 비공개 `19991.mp4`(15.6초), `20004.mp4`(19.05초): 설정의 NAVER 웹 연결 실험에서 실제 네이버 웹 지도 대신 `네이버지도 앱 설치`, `네이버지도 앱 열기` 모바일 안내 화면 반복.
- MOA 화면의 진단 `NON_NAVER_NAVIGATION_BLOCKED` 관찰. **이 상태는 네이버 계정 차단/비밀번호 오류 판정이 아님.** R231 `MoaNaverWebProbeHost.shouldOverrideUrlLoading`에서 `https` + `*.naver.com` 외 탐색을 끊으며 표시한 내부 상태 코드임. 실제 차단 요청의 스킴/호스트가 영상에 노출되지 않았으므로 정밀 서버 원인 확정 금지.
- 기존 NAVER Maps **네이티브 앱에 로그인**돼도 그 앱 쿠키/로그인 토큰은 MOA `WebView`에 자동 공유되지 않음. MOA 웹 로그인에 성공하면 앱 데이터/쿠키가 보존되는 동안 재사용될 수 있으나 최초 로그인 및 세션 만료 시 재인증이 필요할 수 있음. 인증 쿠키 탈취/전용 브리지 복사 금지.
- 기존 R229/R231 사용자 확인 NAVER→MOA 1탭 동일 사진 복귀 기능은 보존 대상. 새로운 WebView 우회와 별도.

## R233 실험 패치 (완제품 NAVER 자동 저장 아님)
- 기준 signed R231 APK 60m original package `com.juhyeon.familyjournea` versionCode231 APK SHA256 `73dfbfe53cb02533f63ab25f33899b60ce14e435fbca8fcea1040d6beecc1bb4`.
- AndroidX WebView **실험 전용** `MoaNaverWebProbeHost`에서 PC 지도 UI를 요청하도록 Windows desktop UA, wide viewport 적용. MOA 일기/갤러리/기존 WebView UA는 변경 없음.
- `shouldOverrideUrlLoading`에서 서브프레임은 개입하지 않고, 앱 실행용 `intent://`, `nmap://`, `market://` 링크는 명확히 `NAVER_APP_OPEN_REQUEST_SUPPRESSED_WEB_ONLY`라고 표시. 네이버 도메인 이외 HTTPS 차단은 `EXTERNAL_WEB_NAVIGATION_BLOCKED`라고 분리. 앱 열기를 단순 허용하면 네이버가 전면에 떠서 사용자 목적에 반하므로 허용하지 않음.
- 최종 페이지에 앱 설치 링크가 있으면 `NAVER_APP_INSTALL_LANDING_DESKTOP_REQUEST_UNSUCCESSFUL` 표시(참고용 boolean 판정, SPA 동적 레이아웃에서 놓칠 수 있음). 모든 `*_PAGE_FINISHED_UNVERIFIED`는 웹 지도 성공/즐겨찾기 성공 증거 아님.
- `CookieManager.flush()`로 MOA 내부 웹 쿠키 유지 가능성 추가; 네이버 앱 로그인 공유 보장 없음.
- 로드 시에만 WebView 생성, 종료 시 WebView 해제; 실제 기기 속도/배터리 수치 아직 미측정.

## 빌드/무결성
- `feature/moa-r233-webview-mobile-landing-fix-20261110` 기준 공개 Java 소스/CI, GitHub Actions `42643411824` SUCCESS.
- 실제 same-signer update-install 베타 APK `MOA_R233_NAVER_WEB_DESKTOP_GATE_BETA.apk` / package unchanged / versionCode 233 / bytes **8,895,626** / SHA256 **`cdf3bf3a56a797e00883189bae66f859edf193432c9acea893b8af04caf20517`**.
- APK v2 signature original cert SHA256 **`5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`** PASS; ZIP CRC PASS; 13 DEX header/SHA1/Adler32 PASS; 134 of 136 APK entries unchanged vs R231. Only manifest code231→233 and classes13.dex different. Android assets, settings design, return overlay, diary, gallery, media, privacy DB unchanged.
- `MOA_R233_NAVER_WEB_DESKTOP_GATE_BACKUP.zip` same APK byte-for-byte verified, ZIP SHA256 **`7ec7f73385c8defe084e4f167d7116e9031f20512ea2f3d479f6cb870bacaf8a`**, 6,430,399 bytes. No device QA, no real favorites write/list create.

## 사용자용 실기기 게이트
1. 기존 MOA를 **삭제하지 말고 업데이트 설치**. 이전 정상 복귀 버튼 그대로 있는지 점검.
2. `설정 > 네이버 즐겨찾기 웹 연결 실험 > 네이버 웹 연결`을 눌러 PC형 웹 지도/장소 검색 UI인지 확인.
3. 여전히 `네이버지도 앱 설치/열기` 화면이면 `DESKTOP_REQUEST_UNSUCCESSFUL`로 실패 기록. 로그인 시도 반복 금지, 계정 차단이라고 주장 금지.
4. 지도 자체가 열렸다면 **네이버 화면에서만 직접 로그인**하고 `모아로/숨김 진단`을 시험. 비밀번호·쿠키·인증 코드를 공개 영상/로그에 포함하지 않음. 숨김 상태에서도 지도 목록 요소가 읽히는지 숫자 상태만 확인.
5. 실기기 PASS 이후에만 네이버 계정 저장용 user-consented 단건 PoC 허용. 계정 목록 재조회가 확인되어야 `NAVER_SAVED_VERIFIED` 가능. 실패하면 웹 자동화 배제 후 `MOA 내부 로컬 큐 + 선택적 PC headless 동기화` 또는 기존 네이버 앱 전면 방식의 예약/빠른 복귀를 대안으로 제시. PC worker는 PC가 실제 켜져 있고 연결됐을 때만 작동하는 한계를 명확히 안내.

## 외부 근거
- https://developer.android.com/reference/android/webkit/WebViewClient (true -> cancel navigation, URL callback may include non-http or subframe)
- https://developer.android.com/develop/ui/views/layout/webapps/in-app-browsing-embedded-web (WebView and browser sessions separate, resource/performance considerations)
- https://developer.android.com/reference/android/webkit/CookieManager (app WebView cookie jar)
- https://developer.android.com/develop/ui/views/layout/webapps/overview-of-android-custom-tabs (shared *browser*, not NAVER Maps native app, cookies)

**문서 작성/정적 PASS는 실제 NAVER 웹 지원이나 비점유 즐겨찾기 저장 성공을 의미하지 않는다. 원본 R227 및 R229 보존.**