# 모아(MOA) 새 채팅 시작 — R567 실기기 성공 최신 골든 (2026-11-14)

모아 프로젝트 이어서 작업한다. **사용자가 2026-11-14 직접 "실기디 성공했으니 골든 지정하라고" 확인했다. 따라서 현재 최신 승인 골든은 R567이며, '기기 검증 대기'가 아니다.** 기존 ChatGPT가 R567 DEVICE PASS PENDING이라고 기록한 문서는 그 이후 사용자의 직접 실기기 성공 확인에 의해 **정정·대체**되었다. R463은 그 이전 사용자 승인 골든이며 더 이상 신규 개발의 출발점이 아니지만 절대 삭제/변경하지 않는다.

## 먼저 전체를 읽을 필수 자료
1. 상위 프로젝트 Canonical: `yooogillycloud123/workexcel-devbridge` main `AA_AirPods_FINAL_READ_FIRST_v1.0_20261005.md`. **하지만 이 작업은 모아만 해당하며 AA AirPods/Android Auto 소스·데몬 수정 금지**.
2. `yooogillycloud123/family-journey-personal` main `MOA_READ_FIRST_NEW_CHAT.md`.
3. **`MOA_R567_USER_APPROVED_GOLDEN_LOCK_READ_FIRST_20261114.md` — 현재 최우선 MOA 골든 기준**.
4. `MOA_WIP_CHECKPOINT_CURRENT.md`.
5. `MOA_R567_R569_FOREGROUND_NATIVE_HOST_BACK_RETURN_SIGNED_HANDOFF_20261114.md`.
6. 이전 골든 이력/기능: `MOA_R463_GOLDEN_LOCK_READ_FIRST_20261113.md`, `MOA_NEW_CHAT_RESUME_PROMPT_R463_GOLDEN_20261113.md`. **R463 기준으로 다시 빌드 금지**.
7. 원본 기능 고정 브랜치 `golden/moa-r567-user-device-pass-20261114`, 기존 `feature/moa-r567-pause-resume-native-owner-back-cards-20261114`; 개인 Library와 현재 첨부·컨테이너 내 source/APK/DEX/QA.
문서 내용이 충돌하면 **이후에 접수된 사용자의 직접 실기기 성공/골든 승인 > 당시 작성된 'R567 미검증' QA/오래된 handoff** 순으로 해석해라. 다만 사용자 성공 보고를 시나리오별 전체 검증으로 임의 확대하지 않는다.

## 현재 정확한 기준
- **R567 = MOA_R567_USER_DEVICE_PASS_GOLDEN_20261114** (user-reported Galaxy PASS; user-approved immutable current Golden)
- APK `MOA_R567_FOREGROUND_NATIVE_RESTORE_ONE_BACK_SAME_SIGNER_TEST.apk` (파일명 TEST는 그대로 유지, 바이너리 변경 금지).
- package `com.juhyeon.familyjournea`, versionCode **567**.
- APK SHA256 `f205afb72744391ce9f2594f898728699870be006f787c712599a1ee8492e93c`.
- cert SHA256 `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`.
- 사용자 첨부 원본 ZIP `MOA_R567_R569_NATIVE_GALLERY_FOREGROUND_ONE_BACK_ORIGINAL_SIGNED_SOURCE_QA_20261114.zip`, SHA256 `0610b55bea13ee8a8b4dc742ffef232ead068d6e4f7f2c58d18d443d50d7f21a`; 압축 안 `03_MODIFIED_SOURCE/`와 `QA/R563_R567_EXACT_SOURCE_DIFF.patch`, `QA/R567_RELEASE_QA.json` 원본 보존.
- `classes18.dex` SHA256 `a073bd5222aa77f8ca452408d64469c07a556158064f91cfd9b642840982025d`. 원본 R463 네이티브 17 DEX 변경 금지.
- **R463** 이전 승인 골든 APK SHA256 `9d2fd10d32a3bc35eb3132333e96edd8f565abd5daf3ce954b052f77083d8379` 별도 보관.
- **R569** 높은 versionCode 비상 APK SHA256 `e3545a707402911eb9798d5e01007d066b776018d7e3d7faf96524bf9042fccd`는 **R463 기능으로 돌아가는 것**이지 R567 정확 복구본이 아니다. 불필요하게 설치하지 않는다.

## R567 원본 골든에서 반드시 보존할 기능
- 원본 `MoaNativeGallery`: 사진/동영상 혼합, 전체 사진/영상, 영상 재생·탐색·음소거·볼륨·프레임 캡처, 사진 확대/축소/핀치, 하단 가로 썸네일 관성·동기화, 현재 미디어 유지, 공유/네이버지도 이동 후 동일 사진 복귀.
- 사진 일기 Back **한 번에 달력**, 재진입 시 native Gallery. Home/Recents/다른 앱 후 돌아와도 native Gallery/Back 안정; 구형 WebView 갤러리/과거 play·expand 버튼 재등장 금지.
- 하단 50dp 아이콘 **4개 순서** 공유 / 네이버지도 / 컴팩트 촬영 시간·주소·기본표시 지도 심볼 / 큰 미디어 연속 스와이프 ON/OFF. 정보는 원래 상단 같은 위치의 접이식 패널만; 기본표시 ON 체크 유지, OFF 시 본문 터치로 접힘. 연속 스와이프 기본 OFF, ON만 다중 플릭/관성.
- R535 정수 스크롤 geometry·R527 WebMessagePort·R567 CSS/네이티브 host lifecycle, alive host NO close/reopen, foreground Back에서 JS 달력 먼저, Home/Recents/타 앱 prePause 구분, bounded resume probes.
- 네이버 PC WebView/비점유 즐겨찾기 저장 및 실제 판정·로그인 쿠키/리스트, 일기·바로기록·가족기록, M4A/음성·STT, 사진 GPS/영상, 테마/설정/분홍 홈 버튼/DB 전부 보존. 구형 R435/R459/R463 코드로 기능 퇴행 금지.

## 다음 릴리스 개발/배포 강제 규칙
- **R567 골든 브랜치는 불변. 새 feature branch를 파생**하고 변경사항을 최소화. 최신 `_analysis_repair*`, APK/DEX/temp/verification/GitHub CI artifacts/Library를 먼저 확인해 이미 나온 것을 재사용.
- 신규 설치 APK **versionCode >=570**, 같은 package·같은 signer로 기존 앱에 **덮어쓰기 설치**. **uninstall, 데이터/캐시 초기화, 네이버 쿠키·계정 삭제, DB wipe 금지**.
- **신규 후보보다 높은 versionCode의 R567 정확 기능 복구 APK**를 만들어 source/hash/서명/원본 DEX/ZIP member diff로 검증. 구형 R569를 R567 복구라고 부르지 않는다.
- SDK/JS/DEX/CI/서명 검증과 실기기 사용자 성공을 혼동하지 말고, **현재 R567은 실기기 성공 보고에 따라 확정 골든**으로 취급. 추후 신규 후보의 물리 성공은 별도로 확인.
- 수정 때마다 signed APK + 긴급 복구 APK + source/QA ZIP + SHA/정적 검증 + GitHub WIP 기록 + 가능한 개인 Library 보존까지 한 세트로 제공.
- 원본 APK·이전 골든·사진·DB·토큰·비밀 서명키 공개 금지 및 AirPods 소스 수정 금지.

**다음 작업은 최신 승인 R567에서만 시작한다. 기존 성공 원리를 다시 만들거나 소스를 정리한다는 이유로 갈아엎지 않는다.**
