# 모아(MOA) 다음 채팅 이어가기 — 2026-11-15 R576 사용자 실패 수정 후

**프로젝트 최상위 Canonical 먼저 읽기:** `yooogillycloud123/workexcel-devbridge` main `AA_AirPods_FINAL_READ_FIRST_v1.0_20261005.md` 전체. 하지만 이번 요청은 **모아(MOA)**로, AirPods/Android Auto 소스·데몬 수정 금지.

## 반드시 순서대로 읽기
1. `yooogillycloud123/family-journey-personal` main `MOA_READ_FIRST_NEW_CHAT.md`.
2. **`MOA_R567_USER_APPROVED_GOLDEN_LOCK_READ_FIRST_20261114.md`**: R567은 사용자 실기기 성공·승인 최종 골든, 원본/해시·브랜치 절대 수정 금지.
3. **`MOA_R576_R577_R574_PHYSICAL_FAIL_QUICKRECORD_GALLERY_RECOVERY_20261115.md`**: R574 실제 오류 3개와 R576 수정·QA·서명·실패 시 정확한 R577 복구.
4. `MOA_WIP_CHECKPOINT_CURRENT.md` 상단 최신.
5. `feature/moa-r576-provisional-capture-gallery-first-frame-rail-gap-20261115`, `golden/moa-r567-user-device-pass-20261114` 및 원본 R567 APK와 새 R576/R577 ZIP/개인 Library.
6. 세부 기능/원본 복구 이유는 R567/R570/R572/R574 이전 인계 문서와 전체 소스 차이 확인.

## 사용자 실기기 사실 (절대 정적 PASS로 바꾸지 말 것)
- **R567 = 유일한 사용자 실기기 승인 골든**, 코드567 APK SHA256 `f205afb72744391ce9f2594f898728699870be006f787c712599a1ee8492e93c`.
- R574 사용자 동영상 `22007.mp4`(75.6초) **FAIL**: 바로기록 뒤 상세형은 기록 표시, 사진형은 검정 빈 화면/갤러리가 앱 재시작 뒤에도 불가. 사진/영상 첫 진입에 검정 번쩍임/검은 빈 영역, 필름 스트립과 8개 액션 버튼 사이 여백 여전히 과함.
- R572/R574에서 사용자 이미 성공 확인: **연속넘김 ON/OFF 설정 유지, 비점유 저장 안내 자동 종료, 별도 회색 전체 폭 도크 제거**, 8개 아이콘 크기 이전보다 개선. 절대 퇴행 금지.
- **R576 = 새로운 동일 서명 설치 베타** v576 APK SHA256 `5bab7d434157bb9c755cbfa70db569012016d89fd1e55bcf760de096afaeb054`. 사용자 Galaxy 동작 아직 **NOT_TESTED**.
- **R577 = 정확한 R567 기능 forward recovery** v577 SHA256 `7a2a9d9eb04a25c7f6894efda454e278a36d6b7896fa403f87c7755172b362bb`; R567 원본 143개 ZIP 엔트리 중 Manifest 버전 외 142개 동일. 심각한 R576 실패 시에만 R577 덮어쓰기. R577 설치 후 차기 APK v578 이상.
- 원본 서명 certificate SHA256 `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`. 개인 키/비밀번호는 사용자 PRIVATE_SIGNERS 개인 Library에만 저장하며 공개 금지.

## R576에서 해결한 코드 결함과 테스트
- 상세형 `family-diary.js` R73은 `state.byId`에 없는 **새 촬영 임시 `fast` 색인**을 사용하도록 의도적으로 설계돼 있음. 하지만 R574 사진형 JS는 `state.byId.has(id)` 없으면 `openNativeGallery` 호출을 무한히 보류한 치명적 오류. 그전 Chromium 테스트는 **오히려 미호출을 PASS로 판정**했기 때문에 테스트 기준이 틀렸음.
- R576 JS는 기존 원본 사진 ID로 Gallery를 정식 index 여부와 무관하게 호출. 백그라운드 `diaryIndex` 갱신은 여전히 가능하지만 열기를 막지 않음. 새 Chromium 5/5 PASS(임시 ID, 과거 ID, 재시작, 원본 Gallery 거부 시 저장 데이터 유지, 네이티브 mount ACK).
- R574 Java의 TextureView **위에 검은 커튼을 0.36~2.2초 동안 올리는 동작** 제거. R570의 Video **아래** 정적 배경으로 복원, 원래 player/seek/capture DEX 불변. Web 비디오도 일률적 black/blur 대신 정지 이미지 backdrop.
- 썸네일과 액션 바 사이 간격은 고정 dp 추가 가정이 아닌 실제 lowerControls/8개 도크 위치를 화면 좌표로 측정해 7dp 간격 목표로 최대 38dp native lowerControls 위치 이동. 실제 Galaxy 픽셀/겹침 여부는 반드시 확인 필요.
- **R574 144 APK 엔트리 중 140개 동일**, 변경은 Manifest, classes18.dex, photo Calendar JS·CSS 4개만. R567 원본 17 DEX·네이버 저장·family-diary.js/기존 JS byte 동일.
- SDK35 Java/D8/Node [CI 43612793745](https://github.com/yooogillycloud123/family-journey-personal/actions/runs/43612793745) SUCCESS. 새 classes18.dex 63,416B SHA256 `cab2e7e6591d430157178f906d3f4dfb38b4faac5b66602205c4fd56886ea611`. APK v2 original signer RSA/ZIP/DEX full digest PASS.
- ZIP `MOA_R576_R577_SAME_SIGNER_INSTALL_RECOVERY_SOURCE_QA_20261115.zip` SHA `daa52a935cd47cebb86e7d0cb92dbc4618a4c1d70d4a0f9644ca634fac1d1a9b`: 두 APK, R567 골든 원본, R574 사용자 FAIL 비교본, 수정 Java/JS/CSS, exact diff, tests, QA JSON, README. 원본 서명 비밀 및 사용자 개인 영상/사진 제외.

## 다음 할 일
1. **사용자가 R576을 실기기에서 확인한 결과가 최우선**. 새 촬영 후 같은 날짜 상세/사진형 둘 다 사진·메모, 앱 재시작 뒤 재진입, 사진/영상 첫 진입 반짝임, 필름스트립-액션 간격, 영상 재생/썸네일 관성/8개 버튼/네이버/Back/홈/최근 앱 전부 확인.
2. 실패가 재현되면 **정확히 어느 단계인지** 추가 사진·영상·코드·사용자 경험을 근거로 좁힌다. 모의 PASS를 실기기 PASS라고 말하지 않는다.
3. 새 개선은 R576 feature branch에서 추가 작업하고, R567 approved Golden branch·원본 APK 절대 수정/교체 안 함. 모든 데이터/사진/네이버 쿠키/기록 보존. 앱 uninstall/data reset 금지.
