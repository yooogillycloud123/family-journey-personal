# MOA R269 사용자 지정 GOLDEN — 비점유 네이버 즐겨찾기 연구·사용자 참여 분리 부록
**기록일: 2026-11-10 / 문서만 추가. R269 Golden 바이너리 및 기존 잠금 문서 내용은 변경하지 않음.**

## 0. R269 골든 불변·기능 상태
- 원본 MOA APK: `com.juhyeon.familyjournea`, versionCode269, 8,932,642 bytes, SHA256 `c0663e65aac2b72feb86cb0f1ba5eac448b6599c3850858de4d942f2aa446920`, 원본 서명 SHA256 `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`.
- 이전 R227 사용자 골든 역시 별도 보존. 새 브랜치는 원본 코드와 바이너리를 덮어쓰지 않는 별도 구현·연구에 사용.
- R255 Galaxy 앱 기동 사용자 PASS / R261 네이버지도 전경 접근성 즐겨찾기 저장 사용자 보고 성공 / R269는 사용자 지정 골든. **R269 모든 경로의 완전한 실기기 PASS로 확대 해석 금지**.
- 보호 기능: 사진 원본 EXIF GPS 및 주소 자동 확인, 일기/기록/음성/바로기록, 기존 전경 접근성 즐겨찾기 저장, 네이버 지도 진입 시 ↶MOA 일회 복귀, 이미 저장한 사진/화면 상태, 본래 앱 데이터.
- 최종 요구: 단 한 개의 MOA APK, 루트/Shizuku/PC/보조 앱 없이 **MOA가 계속 전경에서 조작 가능하고 네이버 앱을 점유 실행하지 않은 채** 올바른 리스트·장소·별명·메모 저장, 없는 리스트 생성, 실제 네이버 계정 목록 재조회 후에만 '저장 완료'. 바로기록 같은 기존 저장 파이프라인에서 재사용 가능.

## 1. 이번 사용자 제공 NAVER 지도 6.7.2.1 APK 실제 분석 결과
관련 연구 근거 파일:
- `MOA_R269_NAVERMAP_6721_APK_REVERSE_OFFSCREEN_FEASIBILITY_20261110.md` 및
- `MOA_R269_REAL_ANDROID_WEBVIEW_FRAME_SAVE_GATE_AND_REUSE_HANDOFF_20261110.md`
(브랜치 `research/moa-r269-navermap6721-offscreen-evidence-20261110`).

NAVER 지도 앱 base APK `com.nhn.android.nmap`, 42 DEX; `BookmarkRepositoryImpl`, `BookmarkApi.addBookmark`, `BookmarkFolderApi.addFolder`, `BookmarkPlaceDialogFragment`, 인증된 내부 API 게이트웨이 및 URL 서명 계층 존재. 그러나 매니페스트 분석에서 **제3자 앱에 개방된 개인 즐겨찾기 저장·폴더 생성 구성요소가 없음**. 외부 `nmap://` 인텐트는 장소·지도 열기 등으로, 사유 북마크 쓰기 계약이 아니다. NAVER 앱 내부 클래스·세션·쿠키·서명 비밀을 MOA에 복사한다고 동작하는 구조가 아님. 비공개 인증 우회, 앱 사칭, 캡차 우회 구현 금지.

## 2. 이전 WebView 실패와 달라진 구체적 증거
- R241 실제 Galaxy WebView `ERR_TOO_MANY_REDIRECTS` on `map.naver.com/?app=Y&appmarket=N`. 이 주소 재사용, UA만 변경, `onPageFinished`를 성공 처리하는 오류 재현 금지.
- 2026-11-10 공개 무로그인 PC지도 브라우저 테스트: `https://map.naver.com/p/entry/place/{sid}` 접근 가능 (데스크톱 UA Chromium, Android 모사 viewport 환경). **이것은 실제 Galaxy WebView 성공을 증명하지 않음**.
- 상단 `저장` 내비게이션 메뉴는 **저장목록 화면 이동**이지 '장소 저장' 버튼이 아님.
- 실제 장소 상세 페이지는 자식 iframe `https://pcmap.place.naver.com/place/{sid}/home`이고, 실제 저장 후보 컨트롤은 `[data-nlog-area="map_btp.save"]` 등 첫 번째 당사자 DOM 내부. 해당 DOM selector는 언제든 변경될 수 있으며 로그인 없는 테스트의 클릭은 서버 저장 성공 아님.
- 표준 `WebView.evaluateJavascript()`는 최상위 문서에 작용하므로 cross-origin iframe의 저장 UI 제어 불가. 공식 AndroidX `WebViewCompat.addDocumentStartJavaScript` + `addWebMessageListener`를 허용된 네이버 출처별로 사용하는 구현 경로를 실험. 세션 인증/쓰기 가능 여부는 아직 **미검증**.
- Android emulator WebView 실제 프레임 시험: `experiments/moa-r269-android-webview-frame-test/**`; 검증 워크플로 run `42804245257`는 이 기록 시점 **in_progress**. 최초 run 실패는 SDK manager PATH 오류였고 수정한 다음 재실행됨. 결론 확정 전 성공 처리 금지.
- 공개 페이지 무인증 실험 CI 성공은 **네이버 개인 계정 저장에 대한 PASS가 아님**.

## 3. 해결할 정확한 기술 관문
1. **내가 할 일 — 휴대폰 브라우저 실행 환경:** 실제 Android WebView에서 PC지도 부모·장소 상세 iframe 렌더링, 앱 강제 유도/리다이렉트, 프레임 통신, 비가시/극소 WebView에서 JS 실행 지속 여부 검증. WebView가 실패하면 별도 내장 브라우저도 근거 기반 대조.
2. **내가 할 일 — 기존 MOA 입력 재사용:** 사진 EXIF/GPS→주소→정확한 네이버 장소 SID 식별, 기존 저장리스트/별명/메모·바로기록의 값 재사용. 업체가 모호하면 자동 임의 선택 금지.
3. **내가 할 일 — 작업 안정성:** 하나의 앱 내부 영속 큐, 중복 저장 해제 방지, 실패 단계/사유, 팝업 ON/OFF, 확인 전 PENDING/UNVERIFIED, 사용자 화면 비점유 및 기존 `↶ MOA` 회귀 검증.
4. **공동 실계정 검증 — 사용자 승인이 필수:** MOA 소유 브라우저의 공식 네이버 로그인 UI가 실제 동작하면 사용자가 **본인 폰에서 최초 1회 로그인·추가 인증/동의**. 로그인 성공 후 내가 만든 엔진이 한 개의 무해한 테스트 장소·리스트·별명·메모 저장을 시도하고, 사용자가 네이버 계정에서 실제 반영을 검증. 자동 readback 일치가 저장완료의 필수 조건.
5. **인증 차단 시 중단 조건:** 네이버 인증·보안·캡차 정책상 통합 브라우저의 저장이 허용되지 않는다면 단순 HMAC/내부 API 카피나 외부 NAVER 앱을 화면만 덮는 트릭으로 '비점유 완료'를 주장하지 않음. 추가 사용자 입력이 필요한 경우 한 번에 최소한으로 요청.

## 4. 사용자 도움의 시점·내용
**지금 당장 필요한 사용자의 행동은 없음.**
내가 검증 가능한 공개 UI·Android 런타임·실제 통합 후보를 먼저 준비해야 한다. 그러고 나서 사용자에게 필요한 것은:
- **네이버 계정 본인 로그인:** 사용자 스마트폰에서 MOA 내부의 정식 네이버 로그인 화면을 직접 사용(비밀번호, OTP, 세션 쿠키, 인증 토큰을 채팅으로 전달하지 않음).
- **실계정 저장 결과 1건 확인:** 별도 테스트 리스트에 장소·별명·메모가 같은 값으로 저장됐는지 확인. 오류 발생 시 개인 정보가 제거된 상태코드/짧은 화면 기록만 필요.
- 이와 별개로 MOA 일기/갤러리/바로기록 정상 및 ↶MOA 복귀가 지속되는지만 간단히 확인.
사용자가 원하지 않는 6칸 수동 테스트 폼, 무작위 다수 APK 설치, PC·보조 앱 요청 금지.

## 5. 개발 릴리스 기준
- R269 골든 원본/서명 보존, 신규 브랜치에서만 개발.
- 최소: **실제 Android WebView 네이버 페이지 PASS → 본인 정식 인증 PASS → 폴더 만들기/정확한 장소·별명·메모 저장 PASS → 계정 readback PASS → 기존 MOA 회귀 PASS**.
- 소스 컴파일/모의 CI PASS는 계정 저장 PASS를 대체할 수 없다.
- 기존 점유형 저장이 되는 상태를 절대로 미검증 비점유 구현으로 바꾸지 않는다.
