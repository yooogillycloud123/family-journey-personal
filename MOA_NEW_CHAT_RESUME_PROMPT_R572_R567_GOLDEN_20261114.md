# 모아(MOA) 새 채팅 인계 — R567 사용자 실기기 골든 유지 / R572 실기기 테스트 예정 (2026-11-14)

프로젝트 `yooogillycloud123/family-journey-personal` 최신 작업에서 이어간다. 상위 프로젝트 `yooogillycloud123/workexcel-devbridge/main/AA_AirPods_FINAL_READ_FIRST_v1.0_20261005.md`를 처음부터 끝까지 읽되, **모아 작업이므로 에어팟/Android Auto 소스·데몬은 절대 변경하지 않는다.**

## 필수 읽기 순서
1. GitHub main `MOA_READ_FIRST_NEW_CHAT.md`
2. **`MOA_R567_USER_APPROVED_GOLDEN_LOCK_READ_FIRST_20261114.md`** — 사용자 실기기 성공·승인 불변 골든.
3. **`MOA_R572_R573_R570_SIX_USER_ISSUES_ORIGINAL_SIGNED_HANDOFF_20261114.md`** — 가장 최신 R572 서명 APK/검증/문제 6가지.
4. `MOA_WIP_CHECKPOINT_CURRENT.md` 최신 상단.
5. 원본 R567 `MOA_R567_R569_FOREGROUND_NATIVE_HOST_BACK_RETURN_SIGNED_HANDOFF_20261114.md`; 이전 R570 signed handoff 및 R463 골든 기록은 필요할 때만.
6. 원본 브랜치 `golden/moa-r567-user-device-pass-20261114`와 최신 `feature/moa-r572-r570-compact-dock-rail-flash-fast-toast-20261114`, 개인 Library `/모아_프로젝트_근거_20261103/R572_R573_SIGNED_20261114/`의 실제 APK·QA·소스 ZIP 확인.

## 불변 기준과 최신 실험
- **R567만 최신 사용자 실기기 승인 Golden**: `MOA_R567_FOREGROUND_NATIVE_RESTORE_ONE_BACK_SAME_SIGNER_TEST.apk` v567 SHA256 `f205afb72744391ce9f2594f898728699870be006f787c712599a1ee8492e93c`.
- **R570 실기기 FAIL 피드백** (영상 `21909.mp4`, 사진 `21905/21907/21912.png`): 아이콘별 그림 크기 차이, 썸네일-바 빈 공간, 비점유 진행 토스트 잔존, 연속넘김 재진입 OFF, 사진 검은 번쩍임·영상 회색 요동, 사진 하단 독립 도크 요구.
- **R572 TEST BETA** v572 기존 원본 서명 APK SHA `a5eeff113022894afa2f72fb4d149e8ee4c1269dabf8c78d16fca28e5ece10ab` (9,084,761B), 기존 패키지 `com.juhyeon.familyjournea`; original cert SHA `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`. SDK35 Java/D8/JS [CI 43605438138](https://github.com/yooogillycloud123/family-journey-personal/actions/runs/43605438138) SUCCESS. 새 additive `classes18.dex` 61,840B SHA `f59efcfc30e1f4e88fe1f9fab453ae4d3986391496c83a6317c64b27e07b2e82`. **R572 물리 PASS 아직 미확인**.
- **R573 비상 복구** v573 APK SHA `33217fc379284d028407d8cda85c3666a3782eb834c5d169c92c08162c6af951` (9,069,599B) = R567 내용 그대로, Manifest versionCode만 변경. 심각한 R572 회귀 때만 덮어쓰기. R573 설치 후 모든 차기 버전 **>=574**.
- 사용자 ZIP `MOA_R572_R573_SAME_SIGNER_INSTALL_RECOVERY_SOURCE_QA_20261114.zip` SHA `4e6f5a8e6b53199ad11e6d409d9cab1ac9496c432ff4d308159054f212878858`: R572/R573 + R567/R570 원본 비교 APK + source/QA/검증 스크립트/README. 개인 Library 별도 보관 확인.
- R570→R572 **139/144 APK 멤버 바이트 동일**, 원본 **17 DEX**와 네이버 저장/일기 JS 불변. R567→R573 **142/143 멤버 동일**.

## 다음 실기기 테스트/후속 작업
사용자에게 R572 실기기 실행 피드백(사진/영상 5회 첫 진입, 회색·검은 번쩍임, 썸네일 바로 붙기, 하단 8 아이콘, 터치/순서 저장, 연속넘김 ON/OFF 재진입, 토스트 3.8초 자동 종료, 비점유·기존 저장 실제 계정 확인, Back1회/Home/Recents/네이버 복귀, 음성/STT/일기/영상 재생)을 받으면 **그 실제 실패 지점만 R572 소스와 물리 증거로 좁혀 수정**. 검증 없이 R572를 GOLDEN으로 승격하지 않는다.

원본 골든 R567 브랜치·APK·해시 영구 고정. 새 기능은 별도 feature 브랜치에서만. 앱 uninstall, DB/data/cache 삭제, 네이버 로그인·쿠키 초기화, signer 변경 금지. 다른 이름의 복잡한 보조 앱 추가 금지. 서명키/암호/개인 위치·가족 사진을 공개 GitHub에 넣지 않는다.
