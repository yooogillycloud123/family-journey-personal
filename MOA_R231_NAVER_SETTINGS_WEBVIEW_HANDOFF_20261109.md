# MOA R231 — 네이버 복귀 플로팅 버튼 설정 + 화면 비점유 WebView 현장 실험 인계

**2026-11-09. 신규 설치형 서명 베타 완성, 정적 PASS, 실기기 R231 검증 OPEN.** 사용자 R229 갤럭시 직접 확인: 네이버지도 위 임시 복귀 버튼 → 원래 MOA 사진 복귀 **정상 작동**. R229에 설정 메뉴가 없다는 사실과 원본 바로기록 설정 UI 사진 `19977.png`, `19979.png`, 버튼 동작 영상 `19976.mp4`가 후속 기능의 출발점. 비공개 사진·영상은 공개 GitHub에 업로드하지 않았다.

## 절대 기준 / 기존 골든 보호

- 사용자 지정 R227 불변 골든 `com.juhyeon.familyjournea`, code227 SHA256 `53c4c04ce32ad13de3c0613f4e5ec7abbc75ccbdfe9db5da05d8fa9b806ec6cd`, 원본 인증서 SHA256 `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15` 보존.
- R229 사용자 실기기 복귀 PASS 원본 code229 SHA256 `823bed41210be28b971860c88879bbc43e934793cf9847d1f0cb7e3e4f1cef74` 변경 없음. R219/R209/R203/R187 이전 골든 보존.
- 기존 일기·가족 일정·갤러리·영상 필름스트립·네이버 장소 보기·GPS·음성·M4A·카메라 바로기록 및 기존 `moa_quick_overlay_v1` 설정 저장소 **수정 금지**. 앱 삭제/데이터 초기화 금지, AA AirPods 프로젝트 수정 금지.

## R231 실제 빌드

- APK: `MOA_R231_NAVER_RETURN_SETTINGS_WEBVIEW_PROBE_BETA.apk`; package `com.juhyeon.familyjournea`, versionCode **231**, **8,895,626 bytes**, SHA256 **`73dfbfe53cb02533f63ab25f33899b60ce14e435fbca8fcea1040d6beecc1bb4`**.
- 기존 인증서 SHA256 **`5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`**, APK signing v2, ZIP CRC, 13 DEX SHA1/Adler32, aapt package/version, apktool 디코딩, new JS Node --check, isolated Android35 Java17/AndroidX CI compile: **STATIC PASS**.
- 백업 ZIP `MOA_R231_NAVER_RETURN_SETTINGS_WEBVIEW_PROBE_BACKUP.zip` SHA256 **`b862a97b73860f250329ecf80f455f1e7349cc40db8ebe13690476f6ed979753`**, 바이트 동일 APK 포함, ZIP CRC PASS.
- R229의 기존 131 파일 중 **126개 내용 동일**. 변경 파일: `AndroidManifest.xml` versionCode229→231, `classes4.dex`에 `MoaMomentApplication$CaptureBridge` 4개 메서드, `classes6.dex`에서 `MoaMomentAudioHostActivity.onResume`에 연결 한 곳, `classes10.dex` 기존 `MoaNaverReturnOverlay` 기능/환경설정 확장, `assets/web/index.html` 추가 로더. 신규 `assets/web/moa-r231-settings.js`, `assets/web/moa-r231-naver-frame-probe.js`, `classes11.dex`~`classes13.dex` AndroidX/Controller 계층. 오리지널 다른 DEX·모든 사진·기존 일기 데이터 정의/설정 자산 변경 없음.

## 기능 1 — 기존 복귀 팝업 별도 설정

- `설정 > 네이버지도 복귀 버튼`, 기존 `바로기록 팝업` 카드와 같은 계층에 별도 펼치기/접기 UI.
- on/off, 네이버 버튼 스타일(미니멀 글래스/블랙/라이트/아웃라인), 텍스트 표시, X 스타일, 자동 숨김(기본 없음), 방향별 크기, 불투명도, 길게 눌러 자유 이동·8방향 크기조절, 가장자리 정렬, 위치/크기/모두 초기화, 현재 설정 미리보기.
- 별도 SharedPreferences `moa_naver_return_overlay_v1`, 카메라 `moa_quick_overlay_v1`와 완전히 분리. 사용자 기기에서 1-탭 복귀가 이미 성공한 R229 구현과 task-to-front 의도 유지.

## 기능 2 — WebView 실제 Android 실험 첫 설치 단계

- `설정 > 네이버지도 복귀 버튼 > 네이버 웹 연결 실험`: 네이버 웹 연결(명시적 사용자 누름) → 네이버에서 사용자가 직접 로그인/장소 확인 → `모아로` 눌러 클립된 attached WebView로 전환 → MOA 화면을 사용하는 동안 `숨김 진단` 상태 확인 → `실험 종료`로 메모리 해제. 자동 4분 안전 종료.
- `MoaNaverWebProbeController`, `MoaNaverWebProbeHost`, AndroidX WebKit 1.12.1; origin scoped `map.naver.com`, `pcmap.place.naver.com`, `pages.map.naver.com`에만 JavaScript 주입, 외부 네이버 사이트 탐색 제한.
- 자격증명/패스워드/쿠키/페이지 텍스트/사진/주소를 읽거나 전송하지 않음. 읽는 정보는 북마크 관련 선택자 DOM 요소 개수와 `frameOrigin` 등 진단 데이터뿐. 자동 리스트 생성, 실제 즐겨찾기 클릭/저장/재조회 코드는 **아직 추가하지 않음**.
- 네이버 앱과 WebView 쿠키가 자동 공유된다는 보장 없음. 네이버 웹 로그인 시 화면이 반드시 한 번은 표시될 수 있음. 숨겨진 WebView의 타이머·프레임 읽기·성능은 **R231 갤럭시에서 검증 전**이며 CPU/메모리 사용 0 보장 없음. 앱 유휴 상태에서는 별도 WebView를 실행하지 않음. APK 약 +3.1MB 증가(AndroidX WebKit dependency).
- 웹뷰 실기기 진단 PASS 후에만 사용자가 승인한 위치 한 곳의 새 리스트 생성→실제 즐겨찾기 저장→목록 재조회 순서로 확장. 잘못된 자동 저장 완료 표시 절대 금지.

## GitHub / CI

- source-only feature branch `feature/moa-r231-settings-naver-webview-poc-20261109` (기존 R229 브랜치에서 분기). `experiments/moa-r231/source`, `assets/web`, `ci/android`, `tests/test_contract.py` 및 `.github/workflows/moa-r231-settings-webview-compile.yml`.
- GitHub Action Android35/Java17/AndroidX/WebKit runtime 컴파일 최종 **run 42639556701 SUCCESS**; 첫 구현 중 중복된 overlay class 제거 후 최종 runtime DEX artifact 별도 검증. 기존 원본 설치형 APK/원본 signer는 공개 GitHub 미업로드.
- 개인 Library `/모아_프로젝트_근거_20261103/GOLDEN_R227_20261109/R231_SETTINGS_WEBVIEW_POC_20261109/`에 APK, 동일 백업 ZIP, QA, 설명서, 이 handoff 및 공개 소스 보관.

## 실기기 수락 조건 / 다음 순서

1. 설치한 R229를 삭제하지 않고 R231 APK 업데이트 설치; 이전 사진·일기·M4A·카메라 앱 데이터 그대로인지 확인.
2. **설정** 탭에서 기존 `바로기록 팝업` 카드 바로 아래 `네이버지도 복귀 버튼` 카드가 나타나는지, 크기·스타일·불투명도·텍스트·표시값 변경 및 재실행 후 유지 여부 확인.
3. 원본 갤러리 사진→네이버지도→한 번 누르기 MOA 복귀(원래 사진 그대로), 8방향 크기 조절·이동·X 닫기, 바로기록 팝업과 독립성 확인.
4. 네이버 웹 연결 실험에서 실제 WebView가 열리고 네이버 웹에서 로그인 가능 여부 확인. `모아로` 버튼으로 복귀해 MOA 화면 사용에 지장이 없는지, `숨김 진단`에서 상태/버튼 수가 나오는지 확인. `WEBKIT_FRAME_FEATURE_UNSUPPORTED`, `WEBVIEW_INIT_FAILED`, `NO_ACTIVE_MOA_HOST`, 로그인 거부 등 정확한 단계별 결과 보고. 계정 로그인 정보·실제 가족 GPS는 제출 금지.
5. 갤럭시 CPU/배터리/메모리, 장시간 동작, 앱 Back/Home, 영상 재생/음성 녹음/기존 일정/카메라 이벤트에 영향이 없는지 확인. WebView 실제 NAVER 계정 favorite persistence는 **NOT IMPLEMENTED**인 R231에서 PASS 선언하지 말 것.

**상태: R229 NAVER 반환 사용자 실기기 PASS; R231 설정+WebView 런타임 정적 PASS, R231 전체 실기기 PENDING.**