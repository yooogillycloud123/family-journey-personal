> **2026-11-15 R576 RELEASE ARCHIVE FINAL HASH CORRECTION (DO NOT REPLACE OR RE-SIGN APKs).** The authoritative final, CRC+19 SHA checked, source/QA bundle is `MOA_R576_R577_FINAL_VERIFIED_20261115.zip`, **26,334,208 bytes**, SHA256 `623180412e9f0e0fd24061fd532fde5ef6610bd470c27a36ca7a7e4385ac8510`; safely saved in private Library `/모아_프로젝트_근거_20261103/R576_R577_SIGNED_20261115/`. Earlier archive filename `MOA_R576_R577_SAME_SIGNER_INSTALL_RECOVERY_SOURCE_QA_20261115.zip` has multiple previous exported snapshots while README test-count text was corrected, so prefer the unique **FINAL_VERIFIED** file and its hash above; any earlier archived SHA listed below applies only to its named historical snapshot. **Signed APK SHA unchanged:** R576 `5435d9e185cbf6acdce451d165bfe81aef386a1f69987b4b355758b64df77fc4`, R577 exact R567 functional recovery `7a2a9d9eb04a25c7f6894efda454e278a36d6b7896fa403f87c7755172b362bb`. Chromium actual available tests **3 PASS**; old text saying 5 was corrected in final README. **R576 Samsung user test pending, R567 user-approved Golden immutable**.

# MOA R576/R577 — R574 실기기 갤러리 먹통·첫 진입 번쩍임·썸네일 간격 수정 (2026-11-15 KST)

## 현재 상태 및 우선순위
- **USER-APPROVED PHYSICAL GOLDEN = R567**. R567 원본, SHA256 `f205afb72744391ce9f2594f898728699870be006f787c712599a1ee8492e93c`와 불변 골든 브랜치 `golden/moa-r567-user-device-pass-20261114`를 건드리지 않는다.
- **R574 사용자 실기기 결과 = FAIL.** 바로기록 후 상세형에는 사진과 기록이 있지만 **사진형은 갤러리 전체가 먹통이고 앱을 닫았다 다시 열어도 안 열린다**. 첫 진입 사진/영상 검은 번쩍임·빈 공간도 심해짐. 썸네일 필름스트립과 하단 8개 심볼 사이의 여백은 여전히 멀다. 회색 전체 폭 가로 바 제거, 빠른 연속넘김 상태 저장, 저장 안내 자동 종료는 성공/유지.
- **R576 = SDK35 Java/D8·JS 정적검증/Chromium 모의검증 통과한 동일 원본 서명 설치 베타. Galaxy 실기기 미검증. GOLDEN 아님.** 임의로 성공이라고 표시하지 않는다.
- **R577 = R567 원본 기능 그대로의 비상 복원 APK** (Manifest versionCode만 높임). R576 심각한 회귀 발생 시에만 덮어쓰기 설치.

## 증거
사용자 제공 사진/영상 (비공개, 저장소에 업로드하지 않음): R574 실기기 증상과 사진형 검은 화면, 썸네일-하단 심볼 공백. 사용자 진술과 영상은 **실기기 재현 사실**이며 컴파일/모의테스트와 구별한다.

## 원인: 실제 소스에서 확인
1. R574 사진형 `experiments/moa-r483/moa-r483-vertical-calendar.js` `r507StartInline()`은 `FamilyJourneyDiary.state.byId.has(id)`가 참일 때까지 원래 `MoaLocalAudio.openNativeGallery()` 호출을 미뤘다. 반면 Quick Record은 먼저 `curated` 일기 및 임시 사진 ID를 기록하고, `byId` 색인 동기화는 비동기 경로. 인덱스 누락이 사진 부재의 증거는 아니므로 새 사진을 무기한 대기시키는 회귀가 발생할 수 있다.
2. `r507StartInline()`은 UI re-render/addMode 반복 때 재호출되므로 네이티브 열기 실패 시 대기 카운터가 계속 새로 시작할 수 있었다. 영구 검정 native-owner 상태의 추가 원인 가능성을 줄이기 위해 호출을 single-flight + 제한 횟수로 묶음.
3. R572~R574가 추가한 사진 준비 전 `nativeHost.INVISIBLE`, 영상 `TextureView` 위 블랙 커튼은 기존 R567 즉시 native 표시 경로와 달라 첫 프레임 검은 빈 화면/플래시에 기여할 수 있다. 이 신규 artificial gate/overlay는 롤백한다.
4. 하단 네이티브 카드: R567 `MoaR391SessionPersistProvider.r439UpdateGalleryBar`가 `lower.bottomMargin = originalBottomMargin + 50dp`를 갱신하므로 사진형 `lowerControls` **높이만** 줄여도 목표한 실제 두 영역의 간격이 줄지 않는다. `nativeLower` 안의 마지막 표시 child 하단과 action deck 상단의 **실제 화면 좌표**를 측정해야 한다.

## R576의 제한적 변경
- 기본 원본 R567 갤러리 함수를 그대로 사용하되 `byId` 누락을 열기 차단 조건으로 사용하지 않는다. 현재 사진의 원본 ID를 그대로 Native opener에 전달하며 기존 `loadIndex(false)`는 백그라운드 보충 요청으로만 사용. `byId`가 비어도 Quick Record의 저장 데이터를 삭제·재기록하거나 원본 저장 함수 수정하지 않음.
- Single-flight native open + 최대 네 번 경계 재시도, 실패 시 native owner/entering 가림 클래스 해제 및 **다시 열기** 버튼 표시. 백그라운드/뒤로가기/현재 날짜 전환 시 이전 in-flight 상태 리셋. 갤러리 재생/인덱스/다른 사진 스와이프 엔진을 새로 만들지 않음.
- R567 즉시 native mount ACK로 복원. R574의 사진 decoder 준비 전 강제 INVISIBLE, 검정/회색 커튼 제거. 원본 `TextureView`/video player 기능 그대로 보존. 물리 flicker 완전 소멸은 아직 Galaxy에서 확인되지 않았음.
- 원본 lowerControls 이동을 실제 `getLocationInWindow` 좌표로 측정해 filmstrip 마지막 표시 child와 하단 action deck의 목표 간격 약 7dp, 이동량 0~38dp로 제한. 원본 gallery 전체화면이나 사용자 터치 리스너 교체 없이 nativeLower 묶음만 이동. **이 실제 간격의 시각 결과는 사용자 Galaxy 검증 필요.**
- 사용자가 성공 확인한 연속 넘김 ON 상태 기억, 저장 진행 토스트 자동 종료, 8개 액션 순서 변경/네이버 저장과 상세형, 원래 사진·동영상 데이터베이스 및 네이티브 R463/567 핵심 17 DEX 그대로 유지.

## 실제 서명 결과
- **R576 설치 APK**: `MOA_R576_QUICKRECORD_PHOTO_GALLERY_COMPACT_RAIL_ORIGINAL_SIGNED_BETA.apk`; versionCode 576; size **9,087,382 bytes**, SHA-256 `5435d9e185cbf6acdce451d165bfe81aef386a1f69987b4b355758b64df77fc4`.
- **R577 비상 복구 APK**: `MOA_R577_EXACT_R567_GOLDEN_FORWARD_RECOVERY_ORIGINAL_SIGNED.apk`; versionCode 577; size **9,069,600 bytes**, SHA-256 `7a2a9d9eb04a25c7f6894efda454e278a36d6b7896fa403f87c7755172b362bb`.
- package `com.juhyeon.familyjournea`; 인증서 SHA-256 `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15` 원본 R567과 **일치**. 독립 APKv2 RSA 서명 검증, signed-content digest, ZIP CRC/정렬, DEX 헤더/Adler32/SHA1 PASS.
- R574→R576 앱 ZIP 144개 중 **140개 파일 바이트 동일**. 변경된 4개는 `AndroidManifest.xml`, `classes18.dex`, `assets/web/moa-r483-vertical-calendar.js`, `assets/web/moa-r483-vertical-calendar.css`. 원본 핵심 **classes.dex~classes17.dex 17개 전부 동일**. original Naver favorites writer/일기 DB/음성·영상 재생 engine byte unchanged.
- R567→R577 ZIP 143개 중 **142개 파일 동일**. AndroidManifest.xml의 versionCode만 변경. R577을 R576에 덮어쓰면 exact R567 functionality 복원.
- R576 DEX `classes18.dex` **63,416 bytes**, SHA256 `cab2e7e6591d430157178f906d3f4dfb38b4faac5b66602205c4fd56886ea611`; [R576 SDK35 Java/D8/JS CI PASS](https://github.com/yooogillycloud123/family-journey-personal/actions/runs/43612793745).
- 브라우저 fixture 기반 3개 테스트 PASS: 새 Quick Record ID가 byId에 없어도 원본 opener 호출, 기존 ID 즉시 오픈, 네이티브 거절 시 유한 반복/수동 복구·검은 오너 클래스 해제. **실제 삼성 갤러리 디코더 결과는 이 테스트로 증명되지 않음.**

## 배포·복구 및 개인정보
- 완성 ZIP `MOA_R576_R577_SAME_SIGNER_INSTALL_RECOVERY_SOURCE_QA_20261115.zip`, **26,334,208 bytes**, SHA256 `8e1f786f0c08e46914580d482c352310b45fdf2c552af81610e9a1a76ab2ca5a`. R576/R577, 원본 R567, 비교 R574, 수정 소스·diff, 모의 테스트, 서명 검증, README, SHA256SUMS 포함; ZIP CRC와 개별 SHA 검증 PASS. **개인 서명키와 암호 미포함.**
- 설치: R576 APK만 기존 모아 **덮어쓰기 설치**, uninstall, data/cache/IndexedDB/Naver cookies reset 금지. 비상시 R577만 설치하며 복구 뒤 다음 릴리스 versionCode **578 이상**.
- 다음 단계: 실제 갤럭시에서 새 사진 촬영→바로기록→상세형/사진형 같은 날짜와 미디어 확인; 앱 완전 종료/재실행; 사진·영상 첫 진입 5회 검정 플래시 비교; 썸네일-버튼 사이 **실제 스크린샷**; 하단 버튼/순서/연속넘김 기억/비점유 네이버 저장/Back/Recents/음성·일기 보존 확인. R576을 사용자 승인 Golden으로 승격하지 않음.
- 현재 R576 실기기 결과 미확인. R574 실기기 실패는 해결 확인 전까지 이력 유지.

## 참조
- 이전 골든 불변: `MOA_R567_USER_APPROVED_GOLDEN_LOCK_READ_FIRST_20261114.md`
- 최신 source branch: `feature/moa-r576-unblock-quickrecord-native-restore-rail-20261115`
- 지난 R574 handoff는 원인·시도 기록. 이번 문서는 이후 사용자 **실패 보고를 반영**했으므로 오래된 'R574 fix 완료' 주장을 우선하지 않는다.
