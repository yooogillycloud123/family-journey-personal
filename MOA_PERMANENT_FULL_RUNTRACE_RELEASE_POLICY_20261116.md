> **2026-11-16 NEWEST MOA R648 USER R647 ACTUAL GALAXY FAIL → EXACT R641 GOLDEN FUNCTIONAL PAYLOAD + POST-BOOTSTRAP PASSIVE TRACE (AA AIRPODS INDEPENDENT):** User's R647 full-run export (1981 records, includes retained historical R645/R646 sessions) shows actual R647 boot 13:46:24.009Z and 13:46:33.721Z START_INLINE count13, stageAttached true yet no NATIVE_PREDRAW_ARMED / NATIVE_OPEN_ACCEPTED / NATIVE_MOUNT_ACK. Root cause below WebView unproven. User requests return to known good Golden rather than R625 variant. New original-signed R648 code648 APK SHA256 `6b5984e1b3892c0ed10606008d2627c0393ba02661e22a13565571f1a47be3c1` size 9,097,017B, EXACT R641 user-physically-PASS baseline SHA `bf1633ad830057b61ef1d256d57a9215b393800c739c75a113dbb10f06167e89`: 145/147 original payloads byte identical, only Manifest version and index script AFTER original R641 bootstrap; adds ONE passive trace JS. **All 18 DEX, original Gallery/photo/calendar JS/CSS, R641 QuickRecord safeguards, original photo-add, Naver services byte-exact.** New tracer ONLY reads diagnostic snapshots, never wraps/runs native open/close/rearm or modifies Calendar JS; existing full-run IndexedDB logs preserved. APKv2 cert/digest/ZIP CRC/browser Settings view/copy/missing-ARM mock PASS, **ACTUAL R648 GALAXY PHYSICAL QA PENDING: NOT GOLDEN**. R625 new photo selection UI NOT included, R641 photo-add preserved; never claim otherwise. Keep R611/R641 Golden immutable, update-install same signer without uninstall/reset, AA audio untouched. Complete handoff family-journey-personal/main `MOA_R648_R641_GOLDEN_PASSIVE_FULL_TRACE_PHYSICAL_R647_FAILURE_HANDOFF_20261116.md`; private Library `/모아_프로젝트_근거_20261103/R648_R641_GOLDEN_PASSIVE_DIAGNOSTICS_20261116/`. Permanent all-future MOA Settings full-run trace remains mandatory.

> **2026-11-16 R646 USER R645 REAL FULL-TRACE FAILURE / BOUNDED QUICKRECORD RETURN REPAIR, DEVICE UNVERIFIED:** User R645 Galaxy 1222-record log proves prior 12:58:50Z original Gallery mount/deck ready, 12:58:58Z QuickRecord commit, 12:59:00Z and 12:59:02Z START_INLINE without PREDRAW_ARMED/OPEN_ACCEPTED/MOUNT_ACK. R641 only +3200ms repair check ran 1518ms after START_INLINE, below its own 1800ms threshold, then never rechecked — a concrete **timing gate defect**, not proof of single Java root cause. R646 code646 original-signer signed APK SHA256 `0d2778071915bf871eb808dd37795b2e2bd8d03cb0e4dc881217b11528941a5f`, 9,097,706B; ALL 18 R641 native DEX unchanged, 143/147 original R641 APK members unchanged, IndexedDB R645 trace retained. Guarded same-day native-CLOSED-only at most ONE repair with bounded checkpoint inspections; logs skipped-gate reasons, ARM/timer cancellations; compresses duplicate native keepalive into summaries. Node/synthetic mock QA PASS, **Galaxy real R646 pending, NOT Golden**. Main handoff `MOA_R646_R645_DEVICE_TRACE_QUICKRECORD_REARM_HANDOFF_20261116.md`; release Library `/모아_프로젝트_근거_20261103/R646_R641_QUICKRECORD_REARM_FULLTRACE_20261116/`; permanent all-version full-run diagnosis requirement intact. Never uninstall/data clear or touch R611/R641 Golden/AA AirPods audio.

# MOA — 모든 후속 버전의 전체 실행 경로 진단 의무 지침 (2026-11-16)

> 이 문서는 사용자 요구에 따라 **모아 프로젝트의 영구·필수 릴리스 Gate**다. 실제 기기 사용자 승인 원본인 R611과 R641의 APK/서명/Golden Git 브랜치는 절대 변경하지 않는다. 진단은 그 복제본과 이후의 모든 새 버전에 기본 내장한다. 독립 AA AirPods 오디오 프로젝트는 수정하지 않는다.

## 1. 절대 필수 기능

- **모든 새 버전은 `설정 > 전체 실행 경로 진단 > 전체 기록 보기 / 전체 진단 복사`를 기본 탑재**한다. 개발/디버그 옵션이 아니며 항상 켜져 있어야 한다.
- 앱의 가능한 **가장 이른 진입점**부터 실행 세션 ID, 빌드/버전, UTC 시각 및 경과 시간을 부여해 시간순 이벤트를 기록한다. 다음 사용자 동작을 누락하지 않도록 로깅 대상에 포함한다: 실행/재개/백그라운드/종료, 화면 및 사진/상세 전환, 터치·클릭·스크롤, QuickRecord의 진입·저장·복귀, 일기 저장 ACK, original native Gallery의 ARM/호스트/열기·닫기/ACK/실패·fallback, One Hand Operation+ NAVER 접근성 OFF→ON에서 앱이 관측한 변화, 네이버 연결·저장 경로(민감내용 제외), JavaScript/Java 네이티브 오류, 비동기 Promise 실패, 관련 native callback 등.
- **실시간 현재 화면만 복사하는 `INIT/events:[]` 진단은 금지한다.** 화면을 닫거나 설정으로 이동해도 그 이전 사건이 모두 누적되어야 한다.
- **앱 재실행 후 기록 유지**: 앱 자체의 독립 저장소에 저장하고, 강제 종료/커널 종료로 마지막 종료 콜백을 못 받았다면 다음 시작에서 이전 세션의 `END_NOT_OBSERVED`와 마지막 관측 지점을 표시한다. 원인이 확인되지 않았을 때에도 실패한 마지막 단계·직전 정상 단계·누락된 callback을 판별할 수 있도록 한다.
- **전체 복사**: 날짜·실행 세션·순번·이벤트명·상태·단계명·결과·오류명·관측 경계가 포함된 원문을 설정에서 한 번에 복사 가능해야 한다. Android WebView 클립보드가 거부하면 긴 텍스트 박스의 전체 선택·수동 복사 fallback을 제공한다.
- 기록은 사용자 명령 없이 지우지 않는다. 용량 또는 OS 제한 때문에 전체 기록 저장이 불가능하면 **부분 보존/누락이 발생했다는 상태 자체를 로그와 UI에 남긴다.** 일기·사진 DB와 로그 저장 DB는 분리하고 기존 사용자 데이터/로그인 상태를 절대 초기화하지 않는다.
- 인증 비밀번호·쿠키·토큰·네이버 계정·메모 본문·사진/영상 파일 이름/ID/원본 URI·GPS 좌표·웹주소 원문·입력창 값은 기록 금지한다. 사건 코드·단계·성공/실패와 익명 식별자만 기록한다. 로그를 GitHub에 자동 업로드하지 않는다.

## 2. 릴리스 필수 테스트

모든 다음 MOA APK가 배포되기 전 아래를 충족하지 못하면 `FINAL`/`GOLDEN` 선언 금지:

1. 최초 시작 직후 `APP_START`가 복사 가능하다. 필요시 Android Application/Activity native pre-WebView 이벤트를 별도 계층에 기록하고 JS보다 이른 native 단계가 실제 수집되는지 확인한다.
2. 사진·상세·QuickRecord·갤러리·설정 이동과 원복이 **한 연속 보고서**에서 보인다.
3. original native Gallery의 Java/JS ACK, stage, ARM, 실패 원인이 로그에 존재하며 현재 상태를 떠나도 보존된다.
4. app background/resume 및 프로세스 종료→재시작 이후에도 기존 세션 기록이 보인다. 정상 종료 콜백이 실행되지 않았으면 원인 불명의 `END_NOT_OBSERVED`로 표현하고 OS 크래시로 단정하지 않는다.
5. `전체 진단 복사`가 실제 WebView/Galaxy에서 동작하며 채팅에 붙여넣을 수 있다. 클립보드 권한 미지원 시 UI 원문선택 fallback 테스트.
6. 앱 텍스트/개인사진/인증정보가 로그에 섞이지 않음을 테스트한다.
7. 원래 R641 네이티브 갤러리/One Hand NAVER 접근성 토글/QuickRecord 실차 PASS를 재검증한다. Golden SHA 보호, 기존 DEX/서명 및 앱 데이터 확인.

**소스 diff/DEX SHA/APK v2 서명·ZIP CRC/기기 실물 테스트를 각각 구분해 보고**하고, 물리 검증 이전의 BETA를 Golden이라고 부르지 않는다.

## 3. 2026-11-16 R645 최초 구현 범위 / 한계 (숨김 없이 명시)

- 실제 갤럭시에서 검증된 R641 SHA256 `bf1633ad830057b61ef1d256d57a9215b393800c739c75a113dbb10f06167e89`를 불변 Golden으로 별도 보관하고, **R641 복제 APK를 R645 versionCode645로 상위 버전 서명**했다. R643/R644 설치자도 update-install 가능하게 했다.
- R645 APK SHA256 `9f155402c1b4bf4840e5f2566a1fbc19e62156aee51b4a50e9980bc97ce8bb7a`, package `com.juhyeon.familyjournea`, 기존 Original signing cert SHA256 `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`. R641 기존 147개 파일 중 **144개가 byte-identical**, 오직 Manifest(versionCode), index.html(earliest trace load), 원본 Gallery JS(실패 단계 기록 1줄)를 변경했으며 진단 JS 파일 하나를 추가했다. **모든 18 native DEX 원본 byte-exact**, R641 QuickRecord 핵심 및 네이버 서비스/일기/음성 변경 없음.
- 독립 IndexedDB 전체 로그 + LocalStorage 최근 기록 fallback, boot/session, 사용자 동작, 페이지 전환, native Gallery 원본 R602 단계/상태, R641 QuickRecord 이력, JS 예외, 페이지 종료/재진입, 설정 전체 복사를 구현했다. 원본 Java callback은 기존 JS 진단 채널로 도달한 범위에서 포착한다.
- **R645에는 Android Application/Activity의 WebView 생성 이전 native 실행 전체 및 OS 강제 종료 순간의 로그 자체를 확보하는 신규 native 계측은 없다.** 등록된 native callback이 오지 않는 실행 경로는 마지막 관측 사건으로 판별하고 다음 부팅 시 종료 미관측을 기록한다. 이 한계를 해결하지 않은 상태에서 "OS 전체 native call 100% 기록"으로 과장하지 않는다.
- 정적 보호 파일 비교, v2 RSA/digest/CRC, Chromium에서 설정/전체복사/이벤트/비개인화 테스트 통과. **실제 Galaxy R645 설치·실행·IndexedDB 장기 보존·native Gallery 회귀 테스트는 아직 수행되지 않았다. R645는 BETA이며 새로운 Golden이 아니다.**

## 4. 다음 새 채팅의 절대 작업 순서

1. `workexcel-devbridge/main/AA_AirPods_FINAL_READ_FIRST_v1.0_20261005.md` 원문과 `family-journey-personal/main/MOA_READ_FIRST_NEW_CHAT.md`, R611 Golden Lock, R641 사용자 실제 PASS, R643 물리 실패 보고서 및 이 문서를 읽는다.
2. 확인된 R641 정상 복구 코어를 immutable 기준으로 사용하고, 현 설치 버전·Original signer·user data를 보호한다.
3. 사용자가 설정의 **전체 실행 경로 진단**을 복사해 보내면 먼저 각 이벤트를 시간/세션/단계별로 재구성한다. 로그상 확인되지 않는 실패 원인을 추측으로 확정하지 않는다. 필요하면 그 단계의 native 별도 계측만 최소 추가한다.
4. 어떤 새 버전도 전체 진단 저장·표시·복사 기능을 제거하거나 단순 현재 상태만 출력하도록 퇴행시키지 않는다.
5. APK와 그 **동일 바이너리를 포함한 ZIP**을 함께 제공하고 SHA, original signer, static QA, Galaxy physical pending/pass를 구분한다. GitHub/Library에는 실행 지침·안전한 코드·해시만 저장하고 비공개 서명키를 절대 올리지 않는다.