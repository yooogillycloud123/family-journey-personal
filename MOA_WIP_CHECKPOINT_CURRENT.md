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
