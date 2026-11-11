# MOA R329 — 사용자 지정 저장 순서: 별명·메모 먼저, 기존 리스트 마지막 (2026-11-11)

## 최신 사용자 지시 (확정)
**사진 GPS 주소 검색 → 정확한 주소 결과 ☆ 클릭 → 별명 입력 → 메모 입력 → 기존 리스트 선택 → 저장 확정 → 계정 재조회.**
R325 및 앞선 출시본의 `주소 검색 → ☆ → 리스트 선택 → 별명·메모 → 저장` 순서는 사용자가 직접 바로잡았으며 다시 사용 금지. 새 리스트 생성/삭제는 보류.

## R325 실제 코드 원인과 수정 범위
- R325 `finishAddressDialog()`는 `nodes[0].click()`으로 기존 리스트 선택을 먼저 실행한 후 `saveInput(alias/memo)`를 실행. `saveExactEntry()`도 동일.
- R329 두 함수에서 **alias/memo 먼저 입력하고 검증한 뒤에만 기존 리스트 고유 ID 행을 클릭하고 최종 저장**하도록 재배치.
- 별명/메모가 빈 문자열이면 그 필드만 생략. 오류·인식불가 시 **리스트를 먼저 클릭하는 우회 금지**, 오저장 방지 fail-closed.
- 기존 R325 사진주소 검색·별표 버튼 선택기·1회 클릭·중복 제어·원본 일기/오디오/갤러리/점유 네이버 저장 UI 및 16개 DEX 전부 불변.
- 기존 리스트만 선택, 동명 리스트 자동 추정 금지, id가 없으면 서버 저장 확정 금지. 이름 변경 시 ID 우선 조건 유지.

## 산출물 / 검증된 범위
- 메인 R329: `MOA_R329_ALIAS_MEMO_BEFORE_LIST_SAME_SIGNER_BETA.apk`, `com.juhyeon.familyjournea`, versionCode329, 8,906,799B, SHA256 `e904c41cb2f290b54de37d9fe3b4aea551dbd22e17a561e001abeac2055d4dd5`.
- 안전 복구 R331: `MOA_R331_RESTORE_R325_FUNCTIONS_SAME_SIGNER.apk`, versionCode331, 8,906,741B, SHA256 `fbc76e2b5479485f8f1b980498e101e2b43d4b1e0974788396ceb2c3ae48acb0`. R325 기능 바이트 동일, 매니페스트 버전만 상향. 기기 실제 복구는 미시험.
- 원본 서명 인증서 SHA256 `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`, APKv2 RSA/전체 digest, ZIP CRC/정렬 PASS.
- R325→R329 정확히 `AndroidManifest.xml`과 `assets/web/moa-r231-naver-frame-probe.js` 변경, **16/16 DEX 바이트 일치**.
- Android WebView native 24,000자 제한에 새 JS **23,981자**로 통과, JavaScript syntax PASS.
- 기존 14개 안전 테스트 + 별명→메모→폴더→커밋 순서 포함 4개 추가 mock = **18/18 PASS**. 모의 브라우저 계약검증으로 **실제 NAVER 계정 저장 PASS가 아님**.
- ZIP `MOA_R329_ALIAS_MEMO_FIRST_R331_RECOVERY_QA_20261111.zip`, 12,911,631B SHA256 `c702023a7308204439b72ea6b919b993fe03aeceae6f53b111fcf00a3e38d54e`. APK 두 개+수정 웹소스+diff+테스트+QA+SHA manifest. current-conversation runtime artifact, no signing key, account secrets, user photo/location data.

## 실제 네이버 UI에서 남은 검증 한계
네이버 PC 저장 다이얼로그가 실제 **리스트 선택 이전에 별명/메모 입력란을 제공하는지** 아직 증명되지 않음. 없다면 R329는 사용자가 금지한 역순을 실행하지 않고 `NAVER_UI_CHANGED`로 중단함. 원본 네이버 앱 자체의 UI 순서를 모아가 강제로 바꿀 권한은 없음. 실계정 PC 웹 저장 성공/독립 readback 및 Galaxy R329 물리 설치 PASS 주장 금지. 이후 작업은 별표가 열린 **실제 네이버 모달 화면**에서 alias/memo 처리 순서와 UI 존재 여부에 집중하고 성공한 주소 검색이나 기존 골든을 다시 분석/수정하지 말 것.

## 설치 및 되돌리기
R325 설치기기에서 앱 삭제·데이터 초기화 없이 **R329만 덮어쓰기**. 문제가 발생하면 R331(상위 버전, 원본 R325 기능 복구 후보) 사용. R269 사용자 GOLDEN·모든 사진·일기·오디오·Android Auto 프로젝트 불변.
