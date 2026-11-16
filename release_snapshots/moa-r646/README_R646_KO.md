# 모아 R646 — 바로기록 후 원본 갤러리 복귀 / 누적 실행 진단

## 사용자 실기기 R645 로그에서 확인된 문제
- 2026-11-16 21:58:58.352 KST, `QUICK_RECORD_NATIVE_COMMIT` 수신.
- 21:59:00.359와 21:59:02.793 KST, `START_INLINE` 두 차례 기록.
- 그 뒤 `NATIVE_PREDRAW_ARMED`·`NATIVE_OPEN_ACCEPTED`·`NATIVE_MOUNT_ACK`는 관측되지 않음.
- R641의 기존 3.2초 한 번 복구 검사(21:59:01.877)는 당시 마지막 `START_INLINE`로부터 약 1.518초 시점이어서, `lastAge < 1800ms` 조건을 통과할 수 없었음. **이는 실제 코드/로그에서 확인된 복구 타이밍 결함이며, 원본 Android Java 콜백이 최초로 진행되지 않은 원인을 단정하지는 않는다.**
- R645 진단기는 `NATIVE_GALLERY_OPEN_OBSERVED`·`NATIVE_8_ACTION_DECK_READY` 같은 상태를 150ms 간격으로 중복 기록하여 1222행 로그를 팽창시켰음.

## R646 바뀐 부분
1. R641 실기기 승인 기능을 출발점으로, R645 누적 진단을 유지.
2. 즉시 연속 재시작 없음. 바로기록 후 0.55,1.65,3.2,5.3,7.3,10.3,13.5,16.5초의 관측 검사만 수행. 5.3초 이후 동일 날짜, 사진형 일기, stage 실제 연결, 네이티브 host **명시적 CLOSED**, `arm/pending/opened/mounted=false`, BRIDGE 있음, 최근 `START_INLINE` 정체가 >=1.8초로 **증명된 경우에만 원본 `__moaR543RepairInline`을 최대 한 번 호출**. 이미 열려 있거나 실제 네이티브 상태를 알 수 없는 경우 절대 강제 종료·재연결하지 않음.
3. 로그에 `QUICK_RECORD_REARM_GATE` (검사 결과·제외 이유), `QUICK_RECORD_CLOSED_HOST_REARM`, `QUICK_RECORD_REARM_FINAL` 기록.
4. 기존 원본 `r507StartInline` 호출 시 실제 타이머 실행, BRIDGE 대기, ARM 대기/확인, 6.1초 이상 지연, 중간 정지 상태를 추가 기록. 원본 네이티브 오픈의 검사 로직 자체는 유지.
5. R645의 `MOA COMPLETE RUN TRACE` 및 IndexedDB 저장소 이름 그대로 유지, R645 이전 진단 기록 보존. 반복된 정상 Gallery keepalive는 일정 창당 1건+누락 개수 요약으로 압축. 사용자 메모·사진·영상·GPS·URL·인증정보 수집하지 않음.
6. 그 외 R641의 18 DEX, `family-diary.js`, `moa-r149-voice.js`, 원본 갤러리 CSS, R640 사진 추가 UI, 네이버 관련 앱코드/서명/앱 데이터 수정 없음.

## 설치와 확인
- 기존 R645가 있다면 앱 삭제·데이터 초기화 없이 동일 서명 R646 APK로 업데이트.
- 원본 갤러리 초기 진입 → 상세형↔사진형 → One Hand Operation+ 네이버 접근성 OFF→ON → 앱이 열린 채로 바로기록 저장 → 같은 날짜 사진형 재진입.
- 실패하면 **설정 → 전체 실행 경로 진단 · R646 → 전체 진단 복사**를 사용. 이전 R645의 기록도 계속 포함.
- **Galaxy S26 Ultra 실기기에서 R646 자체의 복귀 성공 여부는 아직 미확인.** 브라우저 시뮬레이션과 APK 정적/서명 통과를 실기기 PASS 또는 Golden으로 표기하지 않는다.

## 검증 범위
- R646 APK v2 원본 서명 RSA/content digest PASS, ZIP CRC PASS, STORED 정렬 PASS.
- R641과 원본 DEX 18/18 바이트 일치, 일기·음성·네이버/사진추가 기능 파일 보호.
- Node JavaScript syntax PASS, 8개 QuickRecord 복구 가드 모의시나리오 PASS.
- Chromium `about:blank` synthetic settings/clipboard/중복 로그 압축/개인 메모 비노출 PASS, page errors 0.
- 브라우저에서 실제 파일/로컬 HTTP 이동은 관리자 정책으로 차단되어 **실제 WebView/IndexedDB 재시작 지속성 재검증은 수행하지 못함**. 다만 R645 실기기 누적 로그는 이전 기록의 지속성을 입증.
- 안드로이드 Activity/WebView 생성 이전의 모든 Java/OS 이벤트 추적은 별도 미구현 범위.

## 보관 규칙
- R611/R641 사용자 Golden APK와 이전 백업 절대 수정/삭제 금지.
- 새 APK 원본 서명 유지, versionCode 646, 설치된 R645 위의 순방향 업데이트만 허용.
- 모든 후속 모아 릴리스에 진단 누적/전체 복사 기능 필수 유지. 다른 에어팟/안드로이드오토 앱 변경 금지.