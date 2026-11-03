# MOA 현재 체크포인트 / 새 채팅 이어받기
**기록 시각 기준: 2026-11-03** — 변경 시 날짜와 실제 검증 근거를 갱신.

## 우선순위
1. 최상위 기준: [MOA_ABSOLUTE_READ_FIRST_20261103.md](MOA_ABSOLUTE_READ_FIRST_20261103.md) 전문.
2. 실물 APK 증거: 사용자 업로드 R37, R41, R42, R44, R45, R47, R48 ZIP, R49, R50 APK 및 작업공간 R51 APK. 각 APK 존재·SHA 확인 후 활용.
3. 이전 정적 코드 비교: `/mnt/data/MOA_R37_R51_실물APK_기능퇴행_정밀검증_20261103.md`, `/mnt/data/MOA_실제APK_R37_R51_퇴행검증_증거.zip`, `/mnt/data/MOA_VERSIONS_CODE_AUDIT.json`, `/mnt/data/MOA_version_regression_tests.py`. 이는 이전 대화에서 생성된 **로컬 자료 경로**이며 새 채팅에서 자동 존재하는지 반드시 확인해야 한다.
4. GitHub 실제 최신 main/CI의 Android Java·Manifest·JS/asset와 GitHub 빌드 이력. 이 저장소의 일반 Android MVP와 사용자가 설치한 APK가 자동으로 동등하지 않다.

## 실물 APK로 현재까지 확인된 사실 (정적)
- R37 사진·영상 선택/달력/일기 데이터베이스 존재. 삼성 기본 카메라 촬영 이후 자동 감지는 없음.
- R41 카메라→모아 **귀환** 후 새 사진 감지·선택 일기 등록 경로.
- **R42 정상 기능 보존 기준선**: 사진·영상 새 파일 감지, 촬영 시간대별 메모, Web Speech 입력 시도. 사용자가 지연·음성 `not-allowed` 문제를 보고. **전체 실기기 PASS가 검증된 것은 아님.**
- **R44 명시적 퇴행**: `mmEnabled=false;mmArmedAt=0`; `mmToggle()`에서 바로 `return`; R42 귀환 후 기록 경로 상실.
- R45~R49 네이티브 연결 실패/앱 분리/권한·토글 문제. 특정 JavaScript↔native 브리지의 정확한 런타임 예외 **미확정**.
- R50 설치 오류·수정 후 앱 실행 종료, R51 일기 화면 누락 사용자 증거. **원본 일기 데이터의 실제 삭제 확인은 아님.**
- R42/R44 동일 패키지/인증서이나 최신 설치 '모아' 앱의 실제 package·key는 별도 확인 전까지 추정 금지. R45/R49/R50 키·패키지 바뀜.

## 현재 사용자 목표 (한 세트)
**기존 모아 기능 유지 + 하나의 앱**에서 빠른 ON/OFF → 삼성 기본 카메라 사진/영상 촬영 → 저장 직후 기록 버튼/알림 → 한국어 음성·문자 입력 → 해당 날짜·촬영 시각의 '내가 고른 사진 일기'로 기록 저장. 원본 촬영 메타데이터/사진 보존. 이미 저장한 사진·일기 데이터 보존. R42 귀환 후 자동 기록은 항상 안전 폴백.

## 현재 Gate
| Gate | 상태 | 비고 |
|---|---|---|
| 업로드 APK 코드 비교·SHA 대조 | PASS(정적) | 위 증거 보고서·스크립트 |
| R42 복귀 후 기능 코드 확인 | PASS(정적) | 사용자 일부 기능 동작 경험 있음 |
| 실기기의 실제 정상 원본 앱 package·signer 확인 | NOT CONFIRMED | 원본 모아 삭제 금지 |
| R42 기능 포함 통합 APK 회귀검사 | NOT DONE | R44 비활성화 재도입 금지 |
| 촬영 후 즉시 Android 네이티브 감지·저장 | NOT DONE | 실제 Android 테스트 없음 |
| 음성 입력 `not-allowed` 복구 | NOT DONE | 웹 음성/네이티브 권한 분리 |
| 기존 사진 일기·지도·여권·설정 모두 유지 | NOT DONE | 최신 원본 앱 실물 대조 필요 |
| 동일 앱 업데이트 서명/데이터 연속성 | NOT CONFIRMED | 개인키 없으면 무리한 동일 패키지 업데이트 불가 |
| Android 설치/실행·실기기 반복 촬영 PASS | NOT DONE | **아직 FINAL APK 없음** |

## 실제 다음 작업(우선순위 고정)
A. 사용자 기기 정상 '모아' 앱의 **실제 패키지/인증서와 보존해야 할 DB**를 확보한 원본 실물 APK·장치 결과로 확인. R42 기능 기준과 사용자 데이터 기준을 별도로 정리.
B. 사용자 파일의 R42 `family-diary.js`에서 `mmToggle/mmHandleIndex/mmFlush/mmPersist/mmGroupNotes/mmVoiceToTextarea`를 보존한 복원 브랜치. 일기/지도/여권/달력 기능 diff 및 자동 회귀검사 설정.
C. 독립 네이티브 MediaStore Observer + 타일 상태 진단 + 지속/중복 저장 큐를 추가하되 R42 폴백을 끄지 않음. JS 브리지는 보조일 뿐이고, 서비스 실기기 상태를 별도 확인.
D. 에뮬레이터 설치/실행·기본 일기 백업복원·촬영 시뮬레이션; 실제 갤럭시 카메라 사진 및 영상 각 2회 이상 순환 확인; 기존 데이터 안전성 확인.
E. 동일 앱 서명/패키지·업그레이드 가능한 경로를 검증한 **완성본 APK**만 사용자 배포. 별도 앱 증식·추정 성공선언 금지.

## 작업 중단/보고 규칙
- **요청한 동작을 만들기 전이라면** 원인 분석만 반복하지 말고 실제 가능한 작업을 수행하되, 정적 검사만으로 기능 완성을 약속하지 말 것.
- 정보 부족 시 사진·영상보다 더 필요한 **정확한 adb logcat 범위, APK, 패키지 정보**를 한 번에 최소 요청; 왜 필요한지도 기재.
- 매 채팅 확인한 SHA/커밋, 수정한 코드, 통과·실패 검사, 남은 실제 문제와 사용자 데이터 영향은 이 파일에 반영.
- R49/R50/R51을 현재 기준선으로 삼지 말 것. **R42 기능 기준, 실제 정상 사용 앱은 데이터 기준**이다.

## 2026-11-03 추가 진행 (재현 가능한 개발 기반)
- GitHub main에 `MOA_ABSOLUTE_READ_FIRST_20261103.md`, `MOA_EVIDENCE_R37_R51_20261103.md`, `tools/moa_apk_regression_gate.py` 추가. 루트 README와 대화 프로젝트 상위 Canonical(다른 저장소)에 우선 읽기 포인터 연결.
- 검사 목적: R42 사진·영상 귀환 폴백/타임라인 메모/ON-OFF 하드 비활성화 방지, 앱/서명 연속성.
- 동일 로직의 로컬 스크립트로 사용자 첨부 R42를 기준·후보로 비교한 경우 PASS(종료 0), R44를 후보로 비교하면 R44 하드 비활성화 확인 FAIL(종료 1) 재현. **GitHub 업로드본의 직접 실행은 새 채팅에서 다시 확인**.
- 아직 소스 통합·Android 실기기 테스트·완성 APK를 수행한 것은 아니다. 다음 실행 단위는 원본 실제 package·데이터 비교 및 R42 복귀 경로 복원 소스+빌드 회귀 검증.

## 2026-11-03 개인 Library 영속 증거 보관 완료
- 개인 Library 폴더: `/모아_프로젝트_근거_20261103/`.
- 업로드 확인: 사용자 원본 실물 APK **R37, R41, R42, R44, R45, R47, R49, R50**, R48 APK 예비 ZIP, 이전 생성된 R51 APK, 정적 증거·테스트·새채팅 읽기 ZIP. 공개 저장소에는 사용자 설치 APK·사적인 파일·개인 서명키 업로드하지 않음.
- 새 채팅에서 이 Library 폴더를 **먼저 Files 검색**하고 실제 접근·해시를 재확인하라. 이전 채팅의 `/mnt/data` 경로는 새 세션에서 보존된다고 가정하지 말 것.
- GitHub main 코드가 실제 기기에 설치된 모아 APK와 동일하다고 가정하지 말 것. R42 기준/실제 설치 본 데이터는 분리해야 한다.

## 2026-11-03 new inspection
R42 source and local verification artifacts re-read. Build remains gated on original package signer and real device verification.

## 2026-11-03 현재 진행: R42 보존 통합 코드 및 독립 감시 엔진 수정
- 실제 GitHub main 변경: `MoaMomentInboxSync.java`(호스트 WebView 직접 JS 평가/IndexedDB ACK 후 동일 바이트의 native draft 삭제), `MoaMomentSyncApplication.java`(별도 Activity 또는 브리지 리로드 없이 콜백 전달), `MoaMomentSetupActivity.java`(화면 위 표시 권한은 선택사항; 알림 감시 자체를 차단하지 않음), `MoaMomentCaptureService.java`(빠른 설정 ON 시 오버레이 미허용이라도 사진/영상/알림 권한이 있으면 시작 가능).
- 로컬 R42 additive inbox JS v2: 기존 R42 `mmFlush`와 네이티브 Inbox 작업을 하나의 Promise 큐로 직렬화하여 동시 `dbGet/dbPut` 덮어쓰기 가능성 감소. 이미 있는 '내가 고른 사진 일기'의 기존 `selectionMode`도 유지하도록 수정. 자동 회귀 테스트 **9건 PASS**, Node 구문 PASS, R51의 bare `async` 오류 재현 PASS.
- 정확히 제한할 Gate: Android SDK/D8 없음(local), GitHub Actions 컴파일 산출물 미확보, 실제 사용자 정상 모아 서명/패키지 확인 미완, Galaxy S26 Ultra 실기기 테스트 불가. **최종 업데이트 APK 미완성**, 미검증 앱 설치를 사용자에게 요구하지 않음.
- 로컬 실측 코드: `/mnt/data/moa_r52_dev/` (새 채팅에서 해당 경로가 자동 존재한다고 가정하지 말고 Library 보관본을 열 것).

## R52 검증 업데이트 (2026-11-03)
- R42 native inbox v2: 원본 R42 JS 해시 고정, mmFlush↔native 동시 쓰기 큐 직렬화, 기존 selected/automatic selectionMode 보존, ACK 메모리 한도. Node.js 9건 PASS, R51 `ReferenceError: async is not defined` 재현·한 줄 수정 시 일기 객체 등록 PASS.
- Android 네이티브 inbox/app 라이프사이클 Java 소스는 자바 17 + 테스트 더블(최소 Android API stub) 타입 검증 **PASS (class 19개)**. **이 검사는 실제 Android SDK 35 + D8 컴파일 결과가 아님.**
- `moa-r50-native-dex.yml`을 R52 inbox 5개 Java 소스만 컴파일하도록 좁히고 DEX 아티팩트 경로를 R52로 변경. GitHub workflow run 확인 결과 없음, 실제 Android DEX artifact 여전히 미확보.
- 원래 사용자 정상 앱 private signer와 실제 active package 검증 미완. 결과: **완성 APK 미배포**; 사용자에게 또 다른 미검증 APK 설치하지 않음.

## 2026-11-03 R54 동일 패키지 APK 실제 패키징·서명 검증
- 사용자 업로드 R42 APK SHA256 `40835356c6c7f4bdbfaf3f07763f99e49fc817dfd9dbd2ba28e2a4094b19cba1`를 기준으로 전체 52개 ZIP 항목 중 `AndroidManifest.xml`과 `assets/web/family-diary.js`만 교체하고, 기존 R49에 실재했던 Android SDK/D8 컴파일 native `classes5.dex` 1개를 `classes4.dex`로 추가. 기타 50개 항목 내용은 byte-for-byte 동일.
- R42 귀환 후 감지·ON/OFF·메모·일기/지도·위젯 기능 원본 보호. R53 native inbox JS의 기존 일기 보존·중복 방지·메모 미저장 보류 로직과 R49 `MoaMomentNative.drafts()` 연결을 추가. 기존 R49 native DEX가 인정된 ACK 이후 동일 사진을 재알림할 수 있어, **R54에서는 native ACK를 호출하지 않고 초안을 보존** (차기 native DEX에 'seen' 영속 마커 구현 후 변경). 음성은 기존 R49 MemoActivity의 Android native STT 경로 활용(갤럭시 실제 검증 미완).
- 생성 `MOA_R54_기존모아_촬영즉시기록_통합검증용.apk`: **package `com.juhyeon.familyjournea`, versionCode 54, 원본 R39/R42 인증서 SHA256 `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`, APK SHA256 `36d536fbed05e5787bf051318bfcc3be14d272c8ec4da045129b1e9fc9943f9a`**. RSA v2 checksum/signature 내용 검증 PASS, ZIP CRC PASS, XML components PASS, DEX checksum/class duplicate PASS, original source-preservation PASS, total static checks 121 PASS.
- Node JS R54 native bridge consumer simulated event tests PASS, R53 diary storage behavior 12 PASS, model checks 7 PASS. **Android 실기기 설치, 삼성 기본 카메라 즉시 UI, 실제 모아 일기 저장 end-to-end PASS는 미확인**. R54은 검증용 후보이며 FINAL 아님. 현재 사용자 기기에서 `com.juhyeon.familyjournea`가 정말 운영 앱인지 확인 전 업데이트를 보장할 수 없음. 앱 삭제/데이터 초기화 금지.
- 서명키를 새로 만들거나 사용자에게 재업로드 요청하지 않았음. R39 개인 키는 개인 Library에만 보관하며 GitHub에는 공개하지 않음.

## 2026-11-03 사용자 삼성 카메라/Camera Assistant/R37 실제 APK 첨부 — 새 사실 (P0)
- 실물 사용자 첨부 `모아-MOA-R37-Widget (2).apk`의 SHA-256은 기존 R37과 **완전 동일** `49a06e88a95195db8a14cd3cd703e3540f0b5925c626c9c267b5f2f248b66eba`이다. 현재 사용 중인 **원본 모아 패키지 `com.juhyeon.familyjourne8`, 서명 `b20f69c55ddfa24d786f4bc0dd6514cf5082059af6ad44897e1f055bc4891f88`**.
- 전달한 R54 APK는 `com.juhyeon.familyjournea`, 서명 `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`이므로 **R37 업데이트가 아니라 별도 앱 설치**. 사용자 화면에서 두 아이콘이 나타나는 현상이 설명됨. 과거 R39 개인키 복구는 **R42 계열 전용**이며 R37 원본 키를 확보했다는 뜻이 아니다. 이 문제를 사용자에게 또 같은 키 요청으로 넘기지 말 것.
- R54 실제 `assets/web/family-diary.js`: `mmToggle()`가 단순 `mmEnabled=!mmEnabled` 로컬 R42 **앱 복귀 후 감시만 켜고**, 전체 파일에서 `MoaMomentNative.setEnabled(` 호출 **0건**, `openSetup(` 호출 **0건**. 따라서 스크린샷의 '순간 기록 ON'은 **Android MediaStore 네이티브 서비스 ON 증거가 아님**. 카메라 화면에서 즉시 알림/오버레이가 뜨지 않는 핵심 구현 결함. 먼저 빠른 설정 '모아 기록' 타일과 FGS/권한 진단을 확인하라.
- R54 웹 음성 버튼은 `window.SpeechRecognition || webkitSpeechRecognition`에 의존하므로 사용자 실제 화면 `not-allowed`가 반복됨. R54 Manifest에는 `android.permission.RECORD_AUDIO` 없음. 네이티브 `MoaMomentMemoActivity`의 Android `RecognizerIntent` 경로는 별도이며 웹 버튼과 연결되어 있지 않음. **웹/네이티브 STT 분리 결함**.
- 삼성 카메라 APK v17.0.00.43: `com.sec.android.app.camera` (SHA-256 `391cb6c22ae8aa57dde7c3a0...`). Camera Assistant v4.5.00.20: `com.samsung.android.app.cameraassistant` (SHA-256 `24cbaa10ad87beb3d4ec19f2...`). 제공된 Camera Assistant Manifest에는 공용 '촬영 저장 완료' broadcast/action이 없고, 고급 카메라 설정만 제공함. 삼성 카메라 APK를 **패치·재서명하지 않는다**; 공식 MediaStore `ContentObserver` + (사용자 허용) 오버레이·알림을 사용.
- 4개 실제 APK의 manifest/source 정적 교차검증 결과와 **비파괴 ADB 1회 진단** 수집 도구는 개인 Library `/모아_프로젝트_근거_20261103/`의 `MOA_카메라_R37_R54_확인결과_원클릭진단.zip`에 보관. 기기에서 `모아 기록` Quick Settings 타일 ON 후 카메라 촬영 중 네이티브 감시/서비스/권한 상태 확보 필요.
- 기존 R37 `android:debuggable=true` 는 `adb shell run-as`로 원본 데이터를 **읽기 전용 백업**할 가능성을 제공. 원본 서명키 부재 시 데이터 보존 이전 방법을 검증하되 절대 원본 삭제/초기화하지 않는다. 실제 device 데이터 이전 PASS는 미확인.
- **다른 APK 배포 금지**: 동일 원본 R37 업데이트가 증명되지 않았고 카메라 즉시 감지·네이티브 STT가 갤럭시 실기기에서 PASS하지 않았다. 기존 앱 삭제 없이 UI/설정/알림/NativeService 로그를 확인하고, Android 코드를 정확히 수정한 뒤 검증.

## 2026-11-03 16:02 사용자 실기기 영상·스크린샷 (58.08초) — 중요 검증 상태 변경
- 실기기 영상 `18175.mp4` 직접 프레임 분석: 삼성 카메라 촬영(약 5~6초) 중 상단 `모아 · 사진 촬영됨 / 바로 기록` **실시간 네이티브 오버레이 성공**. 이후 네이티브 기록창에서 Google Speech 음성 인식(약 9~12초) → 한국어 텍스트 `오 이거 되는 거 맞아` 채워짐 → `모아 일기에 메모 저장` 누름(약 13초) → 카메라로 돌아와 `기록 저장됨 · 모아에서 해당 시간대 확인` 토스트(약 14초). **카메라 즉시 호출과 네이티브 음성 인식은 실기기 PASS!** 이전 '네이티브 미동작' 가설 폐기.
- 사용자 별도 스크린샷의 사진 일기 타임라인에는 일부 과거 메모가 등록되어 있으나, **15:59, 16:00, 16:01 촬영은 '아직 기록하지 않음'으로 잔존**. 이 메모들이 실제로 저장 실패인지, 해당 각 촬영에 아직 메모를 남기지 않은 정상 '대기'인지 영상만으로는 구분 불가. '일부 저장 성공 후 불규칙한 동기화/재진입 필요'는 사용자 반복 관찰.
- 웹 일기 팝업 `음성 입력 실패: not-allowed`는 별도 WebView SpeechRecognition 경로(영상 약 44초). **네이티브 Google Speech 성공과 혼동 금지**. 웹 일기 마이크를 네이티브 STT에 연결하거나, 미지원 오류 대신 네이티브 입력으로 안내 필요.
- R54 APK 실제 `assets/web/family-diary.js` 636행 부근 핵심 신뢰성 결함 직접 확인: native `drafts()` → `__moaNativeSync()`가 `ACCEPTED`(비동기 작업 **접수**만 의미)를 즉시 반환했을 뿐인데 `lastPayload=key`로 설정하여 해당 내용이 실제 IndexedDB에 저장 실패/편집충돌해도 **같은 payload 자동 재시도를 차단**. 실제 저장 완료는 `__moaNativeAckByToken[token].acked/failed`에 비동기로 기록됨. `lastPayload`를 오직 ACK 검증 후 갱신하고, 실패 시 재시도 및 디버그 상태 제공하는 게 정확한 우선 수정.
- R54에 `native.ack(id)` 호출이 없으므로 Android SharedPreferences 초안이 계속 남는 점은 R49 감시가 다시 알림을 일으키는 결함에 대한 임시 방지책이었음. 이에 따른 '알림 메모는 저장했는데 여전히 남음'은 **네이티브 보류 큐 vs IndexedDB 완료의 상태 불일치** 가능성이 큼; 실제 기기 로그로 확인할 것.
- 판정: **카메라 촬영 직후 기록 버튼과 네이티브 음성은 성공**. 문제 초점은 확실히 **네이티브 임시기록 → WebView IndexedDB 원자적 저장 → 완료 확인/중복 방지 → 화면 즉시 갱신**이다. 앞으로 이미 성공한 촬영 감지부터 갈아엎지 말 것. 기존 R37 보존·R54 별도 패키지 문제는 여전히 해결 필요.

## 2026-11-03 R55 저장 완결성 검증 코드 작성 (사용자 동영상 근거)
- R54 실제 `family-diary.js`에서 **`ACCEPTED`를 저장 완료로 오인**하고 `lastPayload=key`를 즉시 기록하던 문제 확인. 비동기 IndexedDB 저장에 실패해 `__moaNativeAckByToken[token].failed`로 돌아와도 동일 payload는 재시도되지 않았음. 사용자가 '여러 번 나갔다 들어와야 반영'한다고 경험한 증상에 부합하는 **확정 코드 결함**. 이것만이 모든 잔여 증상의 원인이라는 뜻은 아님.
- R55 패치 `r54_native_bridge_commit_ack_fix.js`: `window.__moaNativeAckByToken[token]`로 **진짜 commit ACK** 완료 후에만 payload 중복 제거 상태 갱신. 실패/미응답은 데이터 삭제 없이 2초 후 재시도; 사용자가 메모를 저장하지 않은 초안은 보존; 네이티브 브리지 없으면 대기. `window.__moaNativeSyncStatus`로 상태 `PENDING_COMMIT / COMMITTED / RETRY_PENDING / NO_SAVED_MEMO / WAIT_NATIVE_BRIDGE` 진단 제공.
- 실제 R54 APK에서 추출한 JS에만 치환한 `R55_family-diary_candidate.js`: `node --check` PASS, 원래 R42 폴백/Diary 경로 유지. Node VM 독립 테스트 4개 PASS: ACK 전 완료 표시 금지; 승인 후 중복전송 금지; 실패 후 동일 payload 재시도; 미기록 초안/브리지 부재시 보존.
- **패치 자체는 개발/단위테스트 PASS이지 기기 배포/실기기 저장 성공이 아니다.** 원본 R37과 R54 별도 패키지 문제 그대로. 기존 사용자 설치 앱 삭제/데이터 초기화 금지. R54 네이티브 DEX에 seen tombstone이 반영될 때까지 native.ack 제거 사용 금지.
- 동영상에서 Android 네이티브 음성 입력이 **실제로 성공**했고 `not-allowed` 오류는 별도 웹 일기 입력에서만 발생한다. 성공한 촬영 알림/네이티브 음성 경로를 다시 교체하지 말 것.

## 2026-11-03 GOLDEN R54 → R55 실제 업데이트 APK 완성 (정적)
- **새 채팅 필독:** [MOA_R54_R55_GOLDEN_READ_FIRST.md](MOA_R54_R55_GOLDEN_READ_FIRST.md).
- R54 삼성 카메라 촬영 직후 오버레이·Android 네이티브 한국어 음성은 사용자 영상 **실기기 PASS**로 고정. R54 일기 동기화는 불규칙하여 아직 PASS 아님.
- R55 APK `MOA_R55_골든보정_기존R54업데이트_저장동기화.apk`, package `com.juhyeon.familyjournea`, versionCode **55**(R54=54), **동일 인증서** `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`, APK SHA256 `6a9ecd2d0b26b97dfbecbabbcfc26f16eb04aef30a2787b093dc271711b5bdc3`. R54 위에 덮어쓰기: **R54 아이콘 1개 그대로, 새로운 앱 추가 없음**.
- R54 대비 APK 내부 변경은 `assets/web/family-diary.js`(ACCEPTED와 진짜 IndexedDB commit ACK 구분, 실패 자동 재시도, 미작성 메모 보존)와 `AndroidManifest.xml`의 versionCode/name **2개뿐**. 네이티브 카메라 감시/오버레이/Google 음성 DEX **완전 동일**, 나머지 원본 자산 100% 동일.
- 독립 APK 서명·ZIP·DEX·Manifest·web 원본·JS async test **92/92 PASS**, 새 APK Android 실기기 테스트 **NOT RUN**. R37 원본 별도 앱 `com.juhyeon.familyjourne8`은 R55로 업데이트되지 않고 데이터 별도, 절대 삭제 금지.
- 결과물·검증 JSON·재현 빌드 스크립트는 사용자 private Library `/모아_프로젝트_근거_20261103/` 보관. 다음 단계: 사용자의 R55 실제 테스트(촬영 2회→각각 음성/문자 입력→일기 즉시 반영→종료/재실행 후 지속 확인). 웹 일기 마이크 not-allowed는 별도 미완 항목.

## R57 (2026-11-03) built and verified — device test pending
Read [MOA_R57_GOLDEN_ISSUES_READ_FIRST_20261103.md](MOA_R57_GOLDEN_ISSUES_READ_FIRST_20261103.md) first. User video identified duplicate R42 popup, persistent native memo alert and missing per-photo/video diary removal. R57 signed APK preserves package and certificate of R55 (version 57). CI Android D8 native DEX build PASS (PR #2), independent static gate 102/102 PASS. Original camera capture and native Korean speech must remain GOLDEN. No R57 Samsung device PASS yet; original R37 data stays untouched. Current artifact in user's private MOA Library.

## 2026-11-03 R58 USER VIDEO SINGLE NATIVE RECORDING FIX
**MOST RECENT mandatory read-first:** [MOA_R58_ONE_SAVE_SINGLE_NATIVE_READ_FIRST_20261103.md](MOA_R58_ONE_SAVE_SINGLE_NATIVE_READ_FIRST_20261103.md). User-provided 18216.mp4 confirms R57 still exposes a SECOND R42 WebView memo popup after native camera memo saved; R57 legacy green `순간 기록 ON` was separate from the real Android QS tile. Source has competing native pipeline and old R42 `mmCandidates→mmFlush→mmPrompt` with insufficient duplicate gate (native drafts cleared by native.ack). R58 only uses native capture for automatic entry, shuts off the old R42 on-return modal/queue (code retained for reference), makes web ON/OFF call `MoaMomentNative.setEnabled` and shows real native state, and silently re-syncs native memo when MOA opens. R57 native DEX/camera overlay/STT/notifications unchanged, diary deletion and old data untouched. APK `MOA_R58_단일촬영기록_중복팝업차단_동일앱업데이트.apk`, SHA256 `ee65319ae370c4aa5de4f2867aee6578814bdceba3227b12a9305230fa76df6e`, package `com.juhyeon.familyjournea`, versionCode 58, certificate `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15` (R57 same). Changed entries exactly 2 (manifest version + diary JS), other 51 byte-identical. Independent static 89/89 PASS. **User Samsung device R58 test NOT DONE.** Native memo is persisted to SharedPrefs on save, but the diary's IndexedDB is synchronized when MOA WebView opens; do not claim background IndexedDB commit when MOA is closed. R37 original package/data separate; never uninstall or clear. Resume from R58 test and only alter proven-faulty area, not Golden camera/voice.
