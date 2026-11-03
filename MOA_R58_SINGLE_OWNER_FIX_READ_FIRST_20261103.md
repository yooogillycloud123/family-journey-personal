# 모아 R58 — 네이티브 단일 기록원 / 구형 웹 복귀 팝업 OFF (2026-11-03)

## 사용자 실기기 증거
- 새 영상 `18216.mp4` (37.48초): 빠른 설정 모아 기록 활성화, 삼성 카메라 촬영, 네이티브 메모창에서 Google 음성 및 글 입력, 저장, 모아 앱으로 돌아왔을 때 **두 번째 웹 메모창**이 나타나는 문제. 기존 R57 테스트의 재현 증거. 스크린샷 `1793694105758.png`는 '순간 기록 ON · 끄기' 표기.
- 추가 웹 메모창을 닫거나 저장해야 하는 사용 흐름은 불필요. 목표는 **삼성 기본 카메라 → 네이티브 '바로 기록' → 문자/음성 메모 1회 저장 → 모아 복귀 시 별도 팝업 없이 촬영 시간대에 자동 반영**.

## 정확한 원인 — R57 실제 APK 소스 확인
- `assets/web/family-diary.js` R57 94~125행: `MM_KEY='moa.moment.v1'`, `mmEnabled`, `mmToggle`은 **WebView R42 카메라 귀환 보조 모드**만 제어하며, Android `MoaMomentCaptureService`의 Quick Settings ON/OFF와 독립된 별도 상태 변수다.
- R57 `mmHandleIndex` → `mmFlush` → `mmPrompt`는 웹 복귀시 **새 사진에 별도의 빈 note moment + 두 번째 메모창을 만들어냄** (R57 161~211행). 따라서 기존 상단 ON 상태가 추가 팝업을 만드는 명확한 코드상 원인이다.
- R57은 `mmNativeCoveredIds()`로 현재 네이티브 초안이 있는 ID만 건너뛰므로, 이미 `native.ack(id)`로 초안을 정리했거나 네이티브 브리지 활성화·사진 색인 순서가 바뀌면 중복 제거가 흔들릴 수 있다. **Native ACK 뒤에도 다시 팝업이 뜨는 구조적 레이스를 제거해야 함.**
- 네이티브 메모 `MoaMomentMemoActivity`는 `SharedPreferences.commit()`으로 메모를 **즉시 영속 저장**하고, WebView IndexedDB 사진 일기는 모아가 열릴 때 `__moaNativeSync` → ACK 경로로 자동 반영된다. 두 단계 저장을 하나의 화면에서 또 입력해야 하는 것으로 오해하지 말 것.

## R58 적용과 검증 상태
- 새로운 APK: `MOA_R58_골든_단일기록_중복팝업차단_업데이트.apk`.
- SHA-256: `a877b18b8713cc77a64e81418a447326d9a74e807a4f47ef687d7cee5a41109f`.
- R57 동일 package `com.juhyeon.familyjournea`, 기존 R57 인증서 SHA-256 `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`, versionCode **57→58**. **R57에 덮어쓰기**하며 새 앱 아이콘 생성 없음. 원본 R37 `com.juhyeon.familyjourne8`은 별도 앱이며 절대 삭제/초기화/통합됐다고 주장 금지.
- 앱 시작 때 남은 웹 `mmEnabled=true`를 OFF로 이관. 상단 버튼은 이제 별개 WebView ON이 아닌 실제 `MoaMomentNative.enabled()/setEnabled()`를 호출해 빠른 설정의 네이티브 촬영 감시를 제어함.
- `mmHandleIndex`는 구형 웹 자동 팝업을 강제로 비활성화. `mmPrompt`는 네이티브 브리지 존재시 열리지 않음. 네이티브 초안이 ACK 후 삭제된 뒤에도 중복 팝업이 생기지 않게 **ID에 대한 임시 초안 존재 여부에 의존하지 않음**.
- 카메라 오버레이, 네이티브 음성 입력, 실제 서비스, 알림, 사진·영상 개별 제외/복원, 일기 데이터 스키마 모두 R57 코드 바이트 그대로. 변경된 APK 항목 **오직 `assets/web/family-diary.js`, `AndroidManifest.xml`(version fields)**.
- 실질적인 네이티브 `SharedPreferences.commit()`은 카메라 메모창에서 즉시, IndexedDB는 모아 앱 오픈 시 **자동·무팝업 동기화**. Android WebView가 종료된 동안 IndexedDB까지 즉시 commit됐다고 잘못 안내하지 않는다.
- APK v2 RSA 서명·APK content digest·ZIP·DEX·Manifest·R57 변경 파일 diff·Node JS 상태/중복팝업 모델 테스트 **79/79 PASS**. **실제 삼성 갤럭시 R58 설치/촬영/재진입 테스트는 아직 미실시.** 정적 PASS는 기기 PASS 아님.

## 다음 검증 및 절대 회귀 금지
- R57을 제거하지 말고 R58 위에 업데이트; 기존 R37 원본 그대로.
- Quick Settings [모아 기록] ON ↔ 웹 상단 [촬영 즉시 기록 ON]이 같은 상태인지 확인.
- 삼성 카메라 촬영 → [바로 기록] → 네이티브 음성 또는 문자 메모 저장 → 모아 앱 열기 → **두 번째 웹 팝업 없음** + 해당 사진 촬영시간의 일기 메모 자동 반영.
- 브리지가 안 보인다면 웹 '연결 확인 중' 안내가 나타나고, 의도하지 않은 구형 자동 메모창이 생성되면 안 됨. 빠른 설정 네이티브 감시를 사용.
- 실기기에서 실패하면 **무작정 코어 재작성하거나 신규 앱/서명키 제작 금지**. 해당 촬영 시각, 메모 텍스트, 모아 일기·기록 상태 화면과 네이티브 기록 진단만 확인. 기존 R54 성공 카메라 오버레이/네이티브 음성은 보호.

## 보관
R58 APK, 설치 안내, 독립 검증 JSON, R57→R58 diff, 단위 테스트는 사용자 개인 Library `/모아_프로젝트_근거_20261103`에 함께 보관. APK의 사용자 실제 설치 성공 여부는 추가 실기기 검증 전 **미확인**.
