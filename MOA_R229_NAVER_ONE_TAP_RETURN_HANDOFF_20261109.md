# MOA R229 — 네이버지도 원래 사진 1회 터치 복귀 버튼: 실제 서명 베타 및 웹뷰 독립 검증 인계

작성일 2026-11-09. **R229 signed STATIC PASS, GALAXY DEVICE QA OPEN.** 사용자에게 R229 실사용 성공을 주장하지 않는다.

## 0. 절대 우선 보존
- 장기 Canonical: `MOA_R227_PLUS_LIFELONG_FAMILY_KNOWLEDGE_PLATFORM_CANONICAL_20261109.md` 및 승인된 실행 순서, R227 모듈·의존성 영향 레지스트리, 현재 README/WIP/Release Ledger를 먼저 전부 읽어야 한다.
- 사용자 지정 불변 골든: R227 `com.juhyeon.familyjournea`, versionCode 227, 원본 APK SHA256 `53c4c04ce32ad13de3c0613f4e5ec7abbc75ccbdfe9db5da05d8fa9b806ec6cd`, 기존 서명 인증서 SHA256 `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`. R219/R209/R203/R187 보존. 삭제/데이터 초기화 금지. 다른 AA AirPods 프로젝트 소스 수정 금지.
- R227 실제 Galaxy: 갤러리 사진→네이버지도→뒤로가기 3회→같은 사진 복귀: **동일사진 PASS, 시스템 Back 한 번 FAIL**. 기존 위치정보 즐겨찾기 `내 장소에 저장됨` 표시 PASS, 네이버 전면 화면 점유 FAIL. 영상 19966/19967.mp4 개인자료를 공개 GitHub에 올리지 말 것.

## 1. 사용자 승인 범위 및 UX
사용자는 바로기록과 같은 방식으로 외부 네이버지도 위에 작고 세련된 `↶ MOA` 복귀 팝업을 띄워 단일 터치로 같은 원본 갤러리 사진으로 돌아오기를 요청했다. 기존 바로기록의 dark charcoal 둥근 pill, 분홍색 편집 핸들, X 및 44dp 터치 영역, 장기 누름 이동 및 8방향 크기조절, 불투명도, 화면 방향별 위치·크기 고정·테마를 참고하되 기존 바로기록 설정/알림을 손상하거나 덮지 말 것. 현재 R229 베타는 바로기록과 **독립 SharedPreferences**에 위치·크기를 보관하고 별도의 고정 프리셋 디자인을 적용한다. 사용자에게 완전 테마 동적 연동이 검증되었다고 주장하지 말 것.

## 2. 정확한 signed R229 베타
- 파일: `MOA_R229_NAVER_ONE_TAP_RETURN_BETA.apk`, **5,790,518 bytes**, SHA256 **`823bed41210be28b971860c88879bbc43e934793cf9847d1f0cb7e3e4f1cef74`**.
- 패키지 **`com.juhyeon.familyjournea`**, versionCode **229**, 원본 R227과 **동일 cert SHA256 `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`**, APK v2 PASS.
- 백업 `MOA_R229_NAVER_ONE_TAP_RETURN_APK_BACKUP.zip` **5,426,387 bytes**, SHA256 **`02b598fb46f5f498760dd4f07b13125d7c7a6fbe0d38529458e507d951c6f594`**. 포함 APK는 byte-identical SHA. ZIP CRC PASS.
- 전체 131 ZIP 엔트리 / DEX 10개(각 SHA1/Adler32) PASS. 원래 R227의 130 엔트리 가운데 **128 동일**, `AndroidManifest.xml` code227→229, `classes6.dex` R227 native gallery 클래스 3개 메서드에 narrow hook, 신규 `classes10.dex` return overlay helper. 다른 모든 기존 DEX(1~5,7~9), HTML/JS, 사진·음성·일기/설정/지도 자산 변경 없음.
- 원래 R227 서명키는 개인 Library의 비공개 signer로만 로컬에서 사용; 공개 저장소·제공 ZIP에 사적 키/비밀번호/개인 GPS/사진 없음.
- 사용자 테스트 전 상태: **SIGNED_STATIC_PASS_DEVICE_NOT_TESTED**. 아직 실기기 설치/터치/테마/상호간섭 PASS를 얻지 못했다. 설치된 R227을 덮어씌우는 정상 업데이트로 테스트, 앱 삭제/데이터 삭제 절대 금지.

## 3. 네이버 1터치 복귀 동작
- 원본 R227 Gallery에서 촬영위치 `nmap://place` 버튼을 실행할 때 `MoaNaverReturnOverlay.show(activity)` 호출 후 네이버 실행. 기존 R227 onPause 게이트가 gallery를 보존.
- 화면 위 `↶ MOA` 오버레이 사용자 직접 탭 → `AppTask.moveToFront()` 중심으로 기존 MOA task 앞으로 복귀, 같은 `MoaNativeGallery` selected media/rail 상태 이용. fallback intent 가능. 이 동작은 **네이버 내부 스택의 시스템 Back을 한번으로 바꾸는 기능이 아니다**.
- MOA Activity onResume `r227ResumeFromExternalMap()`에서 overlay hide, 갤러리 close() 시 hide. 취소 X 버튼은 임시 오버레이만 닫는다.
- 최초 Android `SYSTEM_ALERT_WINDOW` 허가가 이미 있는지 확인; 없는 경우 앱 설정의 `다른 앱 위에 표시` 권한 필요. R227 manifest에 해당 권한 선언, 새 권한 요구는 없음. 앱에서 강제 권한 상승/시즈쿠/루트/ADB/별도 보조 APK 없음.

## 4. 실제 소스 · 검증 근거
- GitHub source-only 개발 브랜치: `feature/moa-r229-nav-return-qa-gated-20261109`, `experiments/moa-r229-native/MoaNativeGallery.java`, `R227_MoaNativeGallery.java`, `src/com/juhyeon/familyjourney/MoaNaverReturnOverlay.java`, `src/com/juhyeon/familyjourney/MoaNaverWebProbeHost.java`, 각 README와 tests, `.github/workflows/moa-r229-nav-overlay-probe.yml`.
- GitHub Android35/Java17+DEX/AndroidX WebKit Gradle 성공 run **42632533912**. 새 helper DEX만 정확히 추출하여 **비공개 원본 APK에 오프라인 주입**. 공개 GitHub workflow에는 키·개인 사진·원본 서명 APK 없음.
- 오프라인 apktool2.10, Android SDK build-tools35 zipalign, original private signing certificate verification, aapt badging, apksigner verify, 10 dex checksums, 131 ZIP entries, R227 128/130 same, APK-containing ZIP exact byte verification 통과.

## 5. 웹뷰 즐겨찾기 별도 기술 실험 상태 (R229 APK에는 NOT INCLUDED)
- 읽기 전용 네이버 사이트 origin-scoped DOM frame probe Java source `MoaNaverWebProbeHost.java` + `naver-origin-frame-probe.js` 컴파일 정적 PASS; APK 미설치. 네이버 앱의 로그인과 WebView 로그인은 별도 세션일 수 있음.
- 실제 네이버 웹 로그인, 숨김 WebView iframe 접근, 실제 새 리스트 만들기, 실제 계정 즐겨찾기 등록, 서버 readback, 배터리/CPU 메모리, 사용자 MOA 화면 비점유 **모두 NOT TESTED**. 화면을 숨긴 WebView에도 CPU/메모리가 필요하고 모바일 환경/JS/로그인 제약으로 실패할 수 있다. 사용자 화면에서 명시적 1회 로그인과 승인 필요할 수 있다.
- 사용자 승인 없이 네이버 인증 토큰/쿠키/비밀번호 외부 전송 또는 저장 조작 금지. 공식 `nmap://place`가 favorites-write API라고 주장 금지.

## 6. 실기기 합격 체크 (사용자 한 번에 테스트)
1. 기존 앱 삭제 없이 R229 상향 업데이트; Diary/기록/갤러리 진입/사진·원본 일기 보존 확인.
2. 실제 GPS가 있는 사진 갤러리 → 네이버핀 → 네이버 화면 위 `↶ MOA ×` 나타나는지. 보이지 않으면 Android 설정 특별 접근의 MOA `다른 앱 위에 표시` 확인. 없는 경우 네이버 자체 동작이 막히면 FAIL.
3. `↶ MOA` 정확히 한 번 눌러 같은 사진·같은 하단 썸네일 위치로 복귀하는지, 3회 반복. 네이버 앱 앞에서 X 닫기와 다시 열기 시 overlay 생명주기; 지도 이외 다른 앱에서 부적절하게 남는지.
4. 긴 누름 이동→상하좌우·네 모서리 크기 조절·확정·저장, 세로/가로 독립 저장. 바로기록 팝업과 충돌/차폐 없고 색상·버튼 크기 자연스러운지.
5. 기존 상단 1사진씩 스와이프, 하단 관성+동기, 영상 전체 필름/seek/mute/capture/EXIF GPS/시간, 지도 팝업 OFF, 음성 녹음/종료/Back 시 audio stop, 일기 원본 M4A/메모/바로기록 기존 조작 확인.
6. 네이버 로그인/저장/리스트 새로 생성은 **이번 R229에 구현하지 않았으므로** 테스트 대상 아님. 이를 자동화 완료로 승격하지 말 것.

## 7. 후속 순서
(a) R229 갤럭시 실기기 복귀와 UI 수정 게이트 → (b) AndroidX WebView 실제 NAVER 로그인/iframe READ-ONLY opt-in PoC, 측정 CPU/메모리/기능 → (c) 가능할 경우 새 리스트 생성+즐겨찾기 저장+readback 1건부터 → (d) 다건·오프라인 대기/중복 방지/배터리 제한 검증 → (e) PC/Android sync/학습 플랫폼 확장. R229 실패 시 앱 삭제·데이터 지우기/구버전 다운그레이드 강요 금지, 원본 R227 콘텐츠에만 수정/추가 버전으로 수정해 롤백-포워드.