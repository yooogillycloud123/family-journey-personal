# MOA — MASTER CURRENT / GOLDEN / UPDATE HANDOFF (2026-11-04)

> **이 파일은 새로운 모아 작업 대화의 최신 1차 인수인계 기준이다.** 기존 연대기 체크포인트 안의 과거 실패/미검증 문구보다 이 파일의 **최신 실기기 증거와 버전 구분**이 우선한다. 단, 과거 기록을 삭제하지 말고 이력을 보존한다. **R63 USER PHYSICAL GOLDEN과 현재 배포된 R71 BETA를 절대 혼동하지 않는다.**

## 0. 새 채팅 시작 절차 (MUST)
1. GitHub `yooogillycloud123/workexcel-devbridge/main/AA_AirPods_FINAL_READ_FIRST_v1.0_20261005.md` 전문을 첫 번째로 읽는다(에어팟 골든 변경 금지).
2. `yooogillycloud123/family-journey-personal/main/MOA_ABSOLUTE_READ_FIRST_20261103.md`, **본 파일 전문**, `MOA_WIP_CHECKPOINT_CURRENT.md`, `MOA_R63_USER_DEVICE_GOLDEN_LOCK_20261103.md`를 읽고 최신 Library APK/소스 해시를 확인한다.
3. 기준 원본 **R63 사용자 실기기 GOLDEN**은 수정하지 않는다. 새 개선은 별도 브랜치/상위 버전, 동일 패키지/서명으로 한다. 제자리 업데이트, 절대 앱 삭제/데이터 초기화 금지.
4. 정적 ZIP/DEX/JS/서명 PASS와 Samsung 실기기 PASS를 별도로 표시한다. 다운로드 링크는 파일이 실제 존재하고 해시 검증된 뒤에만 제공한다.

## 1. 제품 목표와 변하지 않는 핵심
- 단일 모아 APK `com.juhyeon.familyjournea`; Galaxy S26 Ultra, 삼성 기본 카메라 사진/동영상 촬영 감지.
- 사용자가 원할 때만 카메라 아래쪽 엄지 근처 `바로 기록` → **딱 한 번의 네이티브 음성/문자 입력** → 원본 미디어 ID 및 실제 촬영 시각·날짜와 함께 기존 **‘내가 고른 사진 일기’**로 자동 저장. 모아 실행 시 중복 메모 팝업을 요구하지 않는다.
- R63 성공의 정확한 구현: `MoaMomentMemoActivity`의 native commit → `MoaMomentDirectDiaryStore`의 별도 동일 출처 WebView (`https://familyjourney.local/`) → **기존 IndexedDB `familyjourney-diary-v1`/`curated`**에서 저장 트랜잭션·재읽기·ACK → `assets/web/family-diary.js`가 `curated`를 재조회하여 표시. **저장 알고리즘, 사진 ID, 개별 촬영 시각, 메모 원문은 절대 훼손 금지.**
- 기존 지도/기록/일기/편집/선택 미디어 제외, 원본 갤러리 유지, 네이버지도 즐겨찾기, STT, 카메라 감지, 기존 서명 보존.

## 2. 실제 증거 기준 버전 이력 (성과 / 한계 구분)
| Version | 변경·검증된 사실 | 상태 |
|---|---|---|
| R42 | 이전 WebView 추가 팝업에서 직접 `dbPut('curated',day,...)` 하여 기록 가능, 하지만 사용자에게 중복 입력을 요구함 | 과거 비교용 |
| R58–R62 | 팝업 제거 후 native→WebView 전달 실패; R61/R62 사용자 기기에서 사진·메모가 일기에 반영되지 않았음 | **실기 FAIL**, 골든 아님 |
| **R63** | 독립 동일 출처 WebView→기존 curated IDB 직접 기록/재읽기 + 화면 재조회. 사용자가 **22:23~22:24 사진 3장 항목+시간별 메모 3개**가 실제 일기에 나타난 스크린샷으로 성공 확인 | **유일한 데이터 경로 실기기 GOLDEN** |
| R64 | 카메라 촬영 후 `모아 · 바로 기록` 작은 오버레이를 하단 엄지 위치로 옮김; 사용자 화면에서 위치 만족 확인. 상단 이중 알림 간소화 작업. 원핸드 바로가기는 아직 목록 문제 | 촬영 버튼 배치 **실기 PASS**, 단축키 문제 남음 |
| R66 | 고정 5분 시각 구간(기존 연속 1시간 묶음 오류 개선) 및 native 메모 음성·저장 버튼 하단 배치 소스 구현. 사용자 스크린샷에서 **22:20~22:24** 고정 그룹 표시 확인. 동적/핀 shortcut은 OHO 목록에 없음 | 5분 그룹 **실기 화면 확인**, OHO 목록 FAIL |
| R68 | 하단 고정 일기 편집 도구막대 `제목·본문 | 시간대 메모 | 일기 저장`, 기존 항목 유지. 사용자가 **실기 화면에서 ‘작동확인됨’** 명시. `CREATE_SHORTCUT`만으로는 OHO 목록 누락 계속 | 편집 바 **실기 PASS**, OHO FAIL |
| R69 | 사용자 AA AirPods처럼 `android.app.shortcuts`+정적 XML을 추가하여 OHO+에서 **‘모아 기록 전환’ 목록 표시 자체는 실기 PASS**. 하지만 제스처가 `HostActivity`를 열고 QS 기록은 OFF, 실제 ON/OFF FAIL | 목록 PASS, **토글 FAIL** |
| R70 | 전용 `MoaMomentToggleActivity`로 정적/동적 바로가기 실행 대상 변경; 기존 `switchTo`+`updateTile`을 호출한 후 종료. R70 APK 컴파일/서명/AXML 확인 | **실제 제스처 ON→OFF→ON 아직 명시적 실기 PASS 근거 없음**. 코드만 확인 |
| **R71** | R70 기준 하단 고정 편집 바에 **네 번째 `일기 삭제` 직접 실행** 추가. 기존 `remove()` 확인창 그대로 사용, 취소면 삭제 없음, 확인하면 해당 날짜 일기만 삭제. 기존 3버튼 유지. | **최신 전달 APK / 정적·모의시험 PASS**, 사용자 실기기 R71 확인 전 |

> 특히 과거 assistant가 잘못 이해했던 `삭제로 이동`은 **최종 요구가 아니다.** 사용자는 **`일기 저장`처럼 하단의 `일기 삭제`를 직접 눌러 기존 삭제 확인창을 띄우는 기능**을 명확히 요청했다. 승인 없이 삭제하거나 원본 갤러리 파일을 삭제하지 않는다.
>
> 2026-11-04 사용자가 보낸 “작동확인됨”은 **하단 편집 도구막대 3개 기능에 대한 확인**이며, R70 OHO ON/OFF 또는 R71 삭제 버튼 모두 실기기 통과했다는 증거로 확대하면 안 된다.

## 3. 아티팩트·해시·소스와 영구 보관 위치
- **R63 Golden**: Library `/모아_프로젝트_근거_20261103/MOA_R63_GOLDEN_USER_DEVICE_PASS_20261103.apk`; SHA-256 `64b1b730478a2a50976961cc2dc4cf511182a75495f2d02159f091167f646024`; 3,422,752 bytes; versionCode 63. Frozen source branch `golden/moa-r63-20261103-user-device-pass-do-not-modify`.
- **R70**: Library `/모아_프로젝트_근거_20261103/MOA_R70_DIRECT_OHO_TOGGLE_STATIC_BETA.apk`; SHA-256 `483994e3decd8e01828bcad5beed5290cc5699594b074298748ce58c758aa8a5`; 3,430,065 bytes; versionCode 70; `fix/moa-r70-direct-toggle-activity-20261104`.
- **R71 최신 배포 APK**: Library `/모아_프로젝트_근거_20261103/MOA_R71_DIRECT_DIARY_DELETE_WITH_CONFIRM.apk`, 대화 파일 `MOA_R71_Install.apk`; SHA-256 **`64725bdfaff9b4507dfab0b7e889d3ddac284066a933e74a1d42f760bb1ecb1a`**; **3,430,689 bytes**; versionCode **71**, versionName R71, same package/signer. No-keys source archive `/모아_프로젝트_근거_20261103/MOA_R71_DIRECT_DELETE_Source_Verification_NoKeys.zip`; source branch **`fix/moa-r71-sticky-direct-delete-confirm-20261104`**, exact delta script `tools/moa_r71_sticky_direct_delete_confirm.py`. User downloads `MOA_R71_Install.apk`, `MOA_R71_Direct_Delete_Install_Backup.zip`, `MOA_R71_Direct_Delete_Source_NoKeys.zip`.
- Signing certificate SHA-256 (PUBLIC fingerprint only): `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`. Private signing keys, passphrases, family photos, private note content MUST NEVER be published.
- R71 vs R70 **only 2 of 55 existing APK members changed**: `AndroidManifest.xml` (version) and `assets/web/family-diary.js` (4th sticky control); **53 byte-identical**, including `classes4.dex` direct toggler, R63 core `assets/web/moa-direct-diary-commit.html`, original `classes2.dex`, NAVER assets/shortcuts.
- R71 local validation PASS: `node --check`, focused original `remove()` confirm cancel vs accept test, original R63 IDB regression suite, APK v2 signature + cert match, DEX untouched, ZIP CRC and exact entry diff. **Do not turn these static PASS marks into Samsung device PASS.**

## 4. 현재 사용자 최종 UI 요구
하단 편집 바 버튼 순서:
**`제목·본문` | `시간대 메모` | `일기 저장` | `일기 삭제`**.
- 제목·본문: 기존 필드로 스크롤 점프.
- 시간대 메모: 사진별 시간 메모 입력 섹션으로 점프.
- 일기 저장: 기존 `save()` 호출.
- **일기 삭제: 기존 `remove()`를 즉시 호출 → 확인창 → 승인한 경우에만 현재 날짜의 일기 삭제**. 다른 날짜·원본 갤러리 미디어는 보호.
- 하단 스크롤 고정이며 기존 편집 콘텐츠(제목/본문/태그/기분/시간대 메모/사진별 제어/취소/기존 하단 삭제)를 제거하지 않는다.
- 삼성 S26 Ultra에서 4버튼 배치/확인 취소 동작은 R71 기기 테스트로 별도 확인한다. 실수 삭제 방지를 위해 테스트는 “취소”부터 시행하고, 사용자의 소중한 일기에서 실제 삭제 테스트를 요구하지 않는다.

## 5. 보류·예정 기능 (현 상태를 성공이라고 주장 금지)
1. **원핸드 오퍼레이션+ 실제 기록 ON/OFF**: R69은 바로가기 목록 표시 PASS / 토글 FAIL. R70 전용 토글 Activity + 퀵패널 상태 동기화 코드는 정적 PASS; 갤럭시 실제 ON→OFF→ON이 확인되기 전까지 완성으로 고정하지 않는다. R71에 동일 R70 DEX가 바이트 보존됨.
2. **사진 영어 공부**: 사진·원본 촬영 시각·연관 한국어 일기 및 시간대별 메모 전체를 기반으로 일화/표현/문장별 한영 학습, 음성 듣기·말하기, 어휘·퀴즈·복습. 기존 `curated`는 수정하지 않고 별도 `photoEnglishV1` 파생 학습 스토어/캐시로 확장. 사용자 동의 없이 가족 사진을 외부 서버로 보내지 않음. **기획·지침만 기록, APK 미구현**. 세부 `MOA_R68_SHORTCUT_EDITOR_AND_ENGLISH_20261103.md`.
3. **네이버지도 즐겨찾기 조작 완전 백그라운드화**: 현재 검증된 방식은 네이버 앱 전면 UI를 AccessibilityService로 조작하는 것. 완전 화면 비표시로 동일하게 저장하는 공식 계정 연동 경로는 확인되지 않아 **미구현**. 기존 정상 흐름 훼손 금지.
4. 촬영 후 단일 엄지 버튼/네이티브 하단 STT+SAVE/5분 고정 그룹/카드 썸네일과 편집 기능 회귀 점검. **임의 이미지·메모 재촬영, 원본 데이터 삭제를 다음 작업의 선행 조건으로 강요하지 않는다.**

## 6. 다음 작업 순서 / 근거 없는 버전 증식 금지
- 먼저 현재 사용자 폰에 **어느 APK가 실제 설치됐는지 구분**(최신 전달본=R71이지만 설치 완료를 단정하지 않음).
- R71 편집 바 실제 4버튼과 삭제 **확인창·취소** UX를 확인하는 경우에도 원본 사진·일기 데이터 변경 없음. 문제 발생 시 Java·JS의 정확한 중단 부분만 수정한다.
- 원핸드 실제 ON/OFF는 별도 실기기 검증 후 PASS/FAIL 업데이트한다. 정적 테스트만으로 골든 승격 불가.
- 새 개선은 R63 원본 골든과 최신 업데이트 앱의 기능을 모두 보존하는 최소 diff 방식; 앱 추가 설치, 삭제/초기화, 중복 입력, 원본 시간대 변경 금지.
- 모든 배포 시 APK SHA, bytes, package/version, 서명 fingerprint, 기존 파일 byte-diff, 실제 on-device PASS/FAIL, Library 영구 파일과 최신 GitHub 문서를 갱신한다.

## 7. 필수 연관 최신 자료
- `MOA_R63_USER_DEVICE_GOLDEN_LOCK_20261103.md` (실기기 데이터 저장 GOLDEN)
- `MOA_R70_OHO_DIRECT_TOGGLE_AFTER_R69_DEVICE_FAILURE_20261104.md` (원핸드 목록→실제 기능 변경 경위)
- `MOA_R71_STICKY_DIRECT_DIARY_DELETE_WITH_CONFIRM_20261104.md` (직접 삭제 4번째 버튼)
- `MOA_R68_SHORTCUT_EDITOR_AND_ENGLISH_20261103.md` (사진 기반 영어공부 확장)
- `MOA_WIP_CHECKPOINT_CURRENT.md` (전 개발 이력)
