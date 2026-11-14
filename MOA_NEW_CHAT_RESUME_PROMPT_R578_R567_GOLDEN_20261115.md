# 모아 새 채팅 최우선 인계 — R567 승인 골든 / R578 검증용 서명 APK / R579 골든 복구 (2026-11-15)

프로젝트 `yooogillycloud123/family-journey-personal`을 가장 최신 작업에서 이어간다. 새 분석/수정 전 별도 상위 프로젝트 Canonical `yooogillycloud123/workexcel-devbridge/main/AA_AirPods_FINAL_READ_FIRST_v1.0_20261005.md`를 처음부터 끝까지 읽되, **모아 관련 작업이므로 AA AirPods 앱·데몬은 건드리지 않는다.**

읽는 순서: `MOA_READ_FIRST_NEW_CHAT.md` → **`MOA_R567_USER_APPROVED_GOLDEN_LOCK_READ_FIRST_20261114.md`** → **`MOA_R578_R579_R576_REGRESSIONS_ORIGINAL_SIGNED_HANDOFF_20261115.md`** → `MOA_WIP_CHECKPOINT_CURRENT.md` → 현 사용자 실기기 결과 → 필요시 R576/R572 관련 역사적 기록.

**승인 골든 = R567 USER_PHYSICAL_PASS**, source branch `golden/moa-r567-user-device-pass-20261114` (불변), original APK SHA256 `f205afb72744391ce9f2594f898728699870be006f787c712599a1ee8492e93c`. R576은 user-device FAIL이며, R578은 소스/CI/서명+Mock PASS지만 실기기 **NOT TESTED**. 승인 골든 승격 금지.

실기기 FAIL 3가지: (1) R576 사진/영상 첫 열기 시 검은 여백·번쩍임, (2) 썸네일 필름스트립과 8개 하단 버튼 사이 사용자 붉은 빗금 여백이 변하지 않음, (3) 바로기록 후 상세형에는 정상 저장되나 사진형이 아예 갤러리 없음/검은 화면이고 앱 재시작에도 지속. 사용자 제공 `21969.png` 및 `22012.mp4`.

최신 동일서명 설치 베타 **R578**, file `MOA_R578_RESTORE_CROP_QUICKRECORD_FILMSTRIP_ORIGINAL_SIGNED_BETA.apk`, code 578, SHA256 `9736c7460b42584ee9a9f94c82eda6c0cc370d41aef33a58ad2d61d270837bd5`. 기능 변경: R567 native photo CENTER_CROP/video ambient restored, actual filmstrip bottom–8-icons top measured and railView Y repositioned, photo-form day IDB curated readonly rehydration + content-based data cache key and original native Gallery refreshPages bounded retry. R576 대비 140/144 original members unchanged, 17/17 core dex intact. CI `43616323558` SUCCESS; DEX SHA256 `1094ff97a047a310fe410832177f0542843a284bba167dec30596a0a63ef6510`. Original Naver writer, detailed diary DB, STT, video player, Back owner preserved. Mock tests 4/4 PASS; real Galaxy outcome unknown.

**비상 R579 exact R567 기능 복구**, file `MOA_R579_EXACT_R567_GOLDEN_FORWARD_RECOVERY_ORIGINAL_SIGNED.apk` code579 SHA256 `e80c3f339e71d3016920f4b3c768df43109471aee04fe800fa0a93ac1c4dd52a`, R567 142/143 original members identical except version Manifest. R579 설치 후 다음 업데이트 versionCode>=580. R579 오직 심각한 회귀시 덮어쓰기. 앱 삭제·데이터/캐시/쿠키 초기화 절대 금지.

**전체 signed APK+QA+소스 ZIP** `MOA_R578_R579_SAME_SIGNER_INSTALL_RECOVERY_SOURCE_QA_20261115.zip` SHA256 `2e196e8f09db2a83e61e90df6751f8b9d2b1d8711d591cf685335ef97d19f692`. 정확한 원본 SHA/cert, QA/data/source/CI preserved under private Library `/모아_프로젝트_근거_20261103/R578_R579_SIGNED_20261115/`. Build signing key stored separate private Library, **DO NOT commit keystore/password to GitHub/public ZIP**. Next changes from `feature/moa-r578-r576-restore-native-photo-crop-quickrecord-refresh-rail-20261115` in a new branch, not Golden.

실기기 새 결과가 오면 문제 재현을 구체적으로 기록하고 **사용자가 이미 확인한 기능을 절대 회귀시키지 않는 최소 수정**. CI PASS를 실기기 PASS라 쓰지 말고, 웹 모의 테스트와 Android 실물 테스트를 엄격히 구분. R567 골든 소스/바이너리 절대 수정 금지.
