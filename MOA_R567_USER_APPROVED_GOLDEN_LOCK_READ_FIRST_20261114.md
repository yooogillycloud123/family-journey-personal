# MOA R567 — 최신 사용자 실기기 성공 승인 골든 LOCK (2026-11-14 KST)

## 0. 최우선 확정 정정 (기존 오기보다 우선)
2026-11-14 현재 사용자가 명시적으로 **“실기디 성공했으니 골든 지정하라고 햤지”**라고 확인했다. 이는 **R567 실기기 성공 + R567을 현재 최신 골든으로 승인한 직접 사용자 보고**다. 이전 ChatGPT가 R567을 단순 'frozen development baseline / DEVICE PASS PENDING'이라고 적은 것은 **잘못된 최신 상태 기록**이다. 본 문서가 그 이후에 접수된 사용자 확인을 반영하여 우선한다.

**CURRENT GOLDEN = `MOA_R567_USER_DEVICE_PASS_GOLDEN_20261114`**
- 출처: 사용자 2026-11-14 실기기 성공 명시 보고. 정적/브라우저/CI PASS가 아니라 **사용자 실기기 성공 보고**.
- 사용자가 이번 메시지에서 개별 동작별 회차/동영상/계측치를 따로 제공한 것은 아니므로 확인되지 않은 세부 항목을 일률적으로 '전수 PASS'로 확대하거나 시간을 지어내지 않는다.
- 기존 R563의 영상 기반 FAIL, R567 제작 당일 작성된 'DEVICE NOT YET TESTED' QA는 **테스트 실행 시점에 적힌 역사적 사실**이다. 삭제하지 말되 이후의 사용자 성공 보고가 최신 승인 사실이다.
- 과거 R463도 독립 **이전 승인 골든**으로 영구 보존. R435 등 과거 자료도 삭제 금지. 새 기능 개발은 **R567에서만** 시작.

## 1. 변경 금지 바이너리와 SHA256
- 사용자 제공 원본 ZIP: `MOA_R567_R569_NATIVE_GALLERY_FOREGROUND_ONE_BACK_ORIGINAL_SIGNED_SOURCE_QA_20261114.zip`; 13,132,663 bytes; SHA256 `0610b55bea13ee8a8b4dc742ffef232ead068d6e4f7f2c58d18d443d50d7f21a`
- 현재 최신 승인 골든 APK: `MOA_R567_FOREGROUND_NATIVE_RESTORE_ONE_BACK_SAME_SIGNER_TEST.apk` (원본 파일명은 TEST이나 사용자 승인으로 골든 승격, APK bytes 불변); versionCode **567**, 9,069,544 bytes; SHA256 `f205afb72744391ce9f2594f898728699870be006f787c712599a1ee8492e93c`
- package `com.juhyeon.familyjournea`; signer certificate SHA256 `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`
- R567 143 APK members, DEX 18. 원본 R463 native core 17 DEX byte-for-byte 유지; R563→R567 보호 엔트리 140 동일. `classes18.dex` SHA256 `a073bd5222aa77f8ca452408d64469c07a556158064f91cfd9b642840982025d`.
- 이전 R463 승인 골든 SHA256 `9d2fd10d32a3bc35eb3132333e96edd8f565abd5daf3ce954b052f77083d8379`.
- 현재 배포된 R569 비상복구 APK SHA256 `e3545a707402911eb9798d5e01007d066b776018d7e3d7faf96524bf9042fccd`는 **R463 기능만** 복원. R567 정확 기능 복구본이 아님. 평상시에 설치하지 말 것.

## 2. 골든 소스 및 자료 읽기
- 불변 **승인 골든** 브랜치: [`golden/moa-r567-user-device-pass-20261114`](https://github.com/yooogillycloud123/family-journey-personal/tree/golden/moa-r567-user-device-pass-20261114). 원본 `feature/moa-r567-pause-resume-native-owner-back-cards-20261114`에서 만들어진 `frozen/moa-r567-20261114-user-requested-device-qa-pending` 포인터를 그대로 분기한 것. 골든 브랜치 직접 변경 금지.
- 릴리스 및 소스: `MOA_R567_R569_FOREGROUND_NATIVE_HOST_BACK_RETURN_SIGNED_HANDOFF_20261114.md`, ZIP 내부 `03_MODIFIED_SOURCE/`, `QA/R563_R567_EXACT_SOURCE_DIFF.patch`, `QA/R567_RELEASE_QA.json`.
- 이전 R463 중요 자료: `MOA_R463_GOLDEN_LOCK_READ_FIRST_20261113.md`, `MOA_NEW_CHAT_RESUME_PROMPT_R463_GOLDEN_20261113.md`.
- GitHub 첫 열람: `MOA_READ_FIRST_NEW_CHAT.md` → **본 문서** → `MOA_NEW_CHAT_RESUME_PROMPT_R567_USER_DEVICE_PASS_20261114.md` → `MOA_WIP_CHECKPOINT_CURRENT.md` → R567 상세 인계 → 필요 시 구 R463 문서.
- 별도 프로젝트 최상위 Canonical 읽기 지침은 준수하되 **AirPods/Android Auto 코드/데몬은 모아 작업 범위 밖**.

## 3. R567에서 반드시 보존할 기능
- 원본 `MoaNativeGallery` 사진·동영상 혼합, 사진 확대/핀치, 하단 썸네일 관성 레일, 영상 재생/음소거/볼륨/탐색/캡처, 현재 선택 미디어 유지, 공유 후 갤러리 복귀.
- 하단 50dp 4개 아이콘의 기존 순서: **공유 / 네이버지도 이동 / 접이식 촬영 시간·주소·기본표시 / 상단 큰 미디어 연속 스와이프 ON/OFF**. 지도 아이콘은 작은 심볼; 불필요한 상단 ‘정보’ 텍스트 추가 금지. 체크 ON 기본표시, OFF 후 본문 누르면 접힘. 연속 스와이프 기본 OFF, ON만 다중 연속·관성.
- 사진 일기 Back 한 번에 달력, 재진입 시 원본 갤러리; Home/Recents/타 앱 복귀 뒤 원본 native 갤러리 유지/재연결. 정상 native를 닫거나 구형 Web 갤러리·옛 동영상 play/expand로 강등 금지.
- R535 정수 기반 scroll geometry + R527 WebMessagePort 채널 + R567 CSS, 갤러리 원래 gesture/영상 handler. 새 fractional scroll/alpha0 proxy 무근거 재도입 금지.
- 네이버지도 실제 이동과 복귀, PC WebView/비점유 저장/리스트/로그인 세션, 일기·바로기록·가족 기록, 음성/M4A/STT·텍스트, 사용자 사진·영상·DB, 테마, 분홍 홈 버튼, 각종 설정/상태값 보존.

## 4. R567의 핵심 복구 설계 (변경 이유 없이 rewrite 금지)
- 사용자 명시 Back 시 native Gallery 닫기보다 **달력 HTML을 먼저 표시**.
- foreground native host attach/detach, `onActivityPrePaused` 구분으로 Home/Recents/외부 앱 이탈을 사용자 Back으로 오분류하지 않음.
- 복귀 시 150/480/950/1700/2750/3950ms bounded recheck; 확인된 동일 날짜 JS ACK 이후 성공 처리; `returnFromBackground` 유령 flag 금지.
- 살아 있는 host는 VISIBLE, alpha1, bringToFront 및 token/geometry rebind만 처리, Gallery.close/reopen 금지. 분실한 host만 same-day/owner 확인 후 제한적 1회 재구성.
- 예전 R563 실기기 Back gray + Home/Recents 복귀 실패 이력은 회귀 금지 참고. R567 사용자 성공으로 승인됐다고 해서 모든 미래 단말/기능 테스트가 자동 PASS인 것은 아님.

## 5. 이후 개발, 배포, 복구
1. **R567 immutable 골든**을 별도로 복제한 새 feature branch에서만 수정. R463/R567 원본 브랜치·APK·ZIP·해시 보존.
2. 차기 설치 APK versionCode **570 이상**, 기존 `com.juhyeon.familyjournea`/동일 original signer **in-place update**. 앱 uninstall, app data/cache, 네이버 쿠키, 로그인/DB, 개인 기록 초기화 금지.
3. 변경 최소 diff, 보호 ZIP members/기존 17 DEX 등 byte comparison, APK v2 RSA/signed content, manifest, CRC, DEX, signer, hash, CI와 실기기 확인 구분.
4. 신규 후보보다 높은 버전의 **정확 R567 기능 전용 forward recovery** 생성 및 검증. R569는 구 R463 복구이므로 이를 R567 GOLDEN 복구라고 부르지 않는다.
5. 새 채팅에서 이미 존재하는 `_analysis_repair*`, APK, DEX, temp, verification과 GitHub·Library 최신자료를 먼저 검사하여 최신 작업에서 이어간다.
6. 개인 서명키/사용자 사진/계정 인증/쿠키 등 비밀은 공개 업로드하지 않는다.

## 6. 상태 표시 규칙
- **R567 = USER_REPORTED_GALAXY_PASS + USER_APPROVED_CURRENT_GOLDEN** (2026-11-14).
- **R463 = PREVIOUS_APPROVED_GOLDEN / IMMUTABLE BACKUP**.
- **R569 = R463 FUNCTIONAL RESCUE**, NOT R567 exact recovery.
- **실기기 PASS 과거 오기**가 담긴 `MOA_R567_USER_REQUESTED_FROZEN_GOLDEN_LOCK_20261114.md`와 기존 프롬프트는 이 문서가 최신 상태에 관해 우선한다.
