# MOA R463 — USER-APPROVED CURRENT INTEGRATED GOLDEN LOCK

**승인일:** 2026-11-13 (Asia/Seoul)
**사용자 확정:** “오케이 이것도 골든으로 확정 여기에 이어서 업구레이드 진행한다. … 새채팅용 프롬포트랑 내용들 깃허브등 다 제대로 보관 기재해”
**이 문서는 모아 프로젝트의 현재 사용자 승인 골든을 정의한다. 이전 R435 골든 기록은 과거 보존 자료이며, 신규 개발 기준으로 사용하면 안 된다.**

## 1. 고정된 실행 바이너리 (변경·삭제 금지)

- Golden label: `MOA_R463_USER_APPROVED_GOLDEN_20261113`
- APK 원본 이름: `MOA_R463_GALLERY_OPT_IN_FAST_STAGE_SWIPE_SIGNED_BETA.apk` (기존 릴리스명 유지; 사용자가 이제 골든으로 확정한 바이너리)
- 개인 Library 내 봉인 복사본: `MOA_R463_USER_APPROVED_GOLDEN_DO_NOT_MODIFY.apk`
- Package: `com.juhyeon.familyjournea`
- versionCode: `463`
- 정확한 원본 APK SHA-256: `9d2fd10d32a3bc35eb3132333e96edd8f565abd5daf3ce954b052f77083d8379`
- 원래 APK 서명 인증서 SHA-256: `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`
- 총 140개 APK ZIP 엔트리, 17개 DEX. Android APK Signature Scheme v2 RSA + signed-content digest, ZIP CRC/DEX header SHA1/Adler32 검증 PASS.
- `classes17.dex` SHA-256: `2e41f108d2e20f604c6cebe3692157cd9d52ca4c87576df0cbf5b80b301b4492` (65,236B). GitHub javac/D8 Actions `43372987065`: SUCCESS.
- 사용자 직접 골든으로 **지정한 것**은 확정 사실. 물리기기에서 가능한 모든 갤러리·동영상 조작 시나리오를 독립적으로 전수 검증했다는 뜻은 아님. 신규 수정 시 각각 재검증.

## 2. GitHub와 개인 Library — 필수 위치

- GitHub 저장소: `yooogillycloud123/family-journey-personal`
- **고정 소스 브랜치:** `golden/moa-r463-user-approved-20261113` (새 수정 커밋 금지)
- 해당 소스: `experiments/moa-r391/MoaR391SessionPersistProvider.java`
- 골든 지정 전 원본 개발 브랜치: `feature/moa-r463-gallery-upper-fling-toggle-20261113`
- 최초 기능별 기록: `MOA_R463_R459_GALLERY_UPPER_FAST_SWIPE_MODE_R465_RECOVERY_20261113.md`
- **현재 골든 문서:** `MOA_R463_GOLDEN_LOCK_READ_FIRST_20261113.md`
- **새 채팅 지침:** `MOA_READ_FIRST_NEW_CHAT.md`, `MOA_NEW_CHAT_RESUME_PROMPT_R463_GOLDEN_20261113.md`
- **누적 최신 기록:** `MOA_WIP_CHECKPOINT_CURRENT.md`
- 개인 Library 봉인 디렉터리: `/모아_프로젝트_근거_20261103/GOLDEN_R463_USER_APPROVED_20261113/`
- 최초 R463 릴리스 자료: `/모아_프로젝트_근거_20261103/R463_STAGE_FAST_SWIPE_20261113/`
- 과거 골든 R435 불변 보관: `/모아_프로젝트_근거_20261103/GOLDEN_R435_USER_APPROVED_20261113/`; `golden/moa-r435-user-approved-20261113`.

## 3. 신규 개발 시 절대 손실 금지할 기능

1. 원래 고급 네이티브 갤러리 (`classes6.dex`)와 같은 화면에서 사진/동영상 혼합 보기, 전체 화면 이미지, 하단 썸네일 좌우 연속·관성 탐색, 영상 재생/음소거/볼륨/타임라인/프레임 캡처, 사진 확대·축소·핀치·복귀/뒤로가기. 과거 구형 웹 갤러리로 회귀 금지.
2. 갤러리 하단 **50dp 컴팩트한 아이콘 전용 네 버튼** 순서: (a) 공유, (b) 네이버 GPS 지도 바로가기, (c) 접이식 3패널 지도 모양 = 촬영 일시/주소/기본 표시 토글, (d) 큰 화면 빠른 연속 스와이프 모드 ON/OFF. 기존 3개를 제거·재배치하지 않음.
3. (c) 접이식 지도 **그림 자체는 약 14.4dp로 다른 버튼과 시각적으로 비슷**, 터치 영역 유지. **상단에 다시 지도 심볼을 추가하면 안 됨**. 하단 세 번째 버튼을 누르면 **원래 상단의 동일 위치**에 촬영 시간·주소·`기본 표시` 네모 체크박스가 표시/접힘. 체크 ON은 이후 재진입 시 기본 펼침으로, 해제 시 재접힘.
4. (d) 신규 빠른 모드 **기본 OFF**: 큰 화면 상단 사진/영상은 기존 한 장씩 넘기기. ON일 때만 큰 화면을 빠르게 연속 드래그/관성 플릭으로 여러 장 이동하고 **원본 하단 썸네일 레일과 일치**. 기존 원본 `MoaNativeGallery` R203 fractional index, `OverScroller`, `r203Present`, `r203ReleaseWithVelocity` 활용. 원본 Stage SwipeHandler는 OFF일 때 한 장 이동 그대로; 영상·핀치/탭/줌 방해 금지. 닫고 재진입하면 OFF.
5. 공유 액션 `shareOriginal()`은 Android 공유창을 열 때도 갤러리와 현재 미디어를 유지해야 함 (R227 활동 일시정지/복귀 보존 구조). 실제 공유 후 동일 사진/동영상 복귀 확인.
6. GPS 있는 사진의 지도는 기존 네이버 이동·갤러리 복귀 경로. GPS 없으면 지도 이동 비활성. 촬영 시간/주소 데이터의 원본 조회 경로 유지.
7. 모아 시작 로고/테마·가림막 뒤 네이버 PC 지도 일시 표시→숨김·최초 비점유 준비·웹창 강제종료 후 자동 재준비·실제 네이버 리스트 확인 후 저장 성공 판정·쿠키 유지 등 기존 정상 네이버 비점유 저장 기능. 계정 정보/쿠키 삭제 금지.
8. 네이버 별도 웹창의 접이식 UI, 상태표시줄 아래 안전한 터치 영역, 드래그/위치 기억 가능한 분홍 MOA Home 버튼. 앱 내 일기·바로기록·사진/GPS·영상·가족기록/모든 UI와 R435 기능을 보존.
9. 모든 갤러리 진입점의 **공통 `MoaNativeGallery` 경로**를 점검. 별도의 레거시/네이버 앱 뷰어까지 동일한지 확인되지 않았으므로, 무조건 전체에 적용된다고 주장하지 말 것.

## 4. 비상 복구본 구분 (핵심)

- 이전 `R465` (`MOA_R465_EXACT_R459_FUNCTIONAL_FORWARD_RECOVERY.apk`)는 **R459만 정확히 복구**하므로, **R463 전용 골든 복구본이 아니다.** R463의 네 번째 버튼과 빠른 모드를 잃는다.
- **새로 제작·검증한 R467**: `MOA_R467_EXACT_R463_GOLDEN_FUNCTIONAL_RECOVERY.apk`, versionCode `467`, SHA-256 `0a477fc158daecfd0700f8accef33a9a04876645d4a61c0aace625d407753b0e`, 같은 원본 서명. R463 140개 파일 중 `AndroidManifest.xml`의 versionCode를 제외한 **139개 원본 payload가 완전히 동일**. R463 기능 전체를 복구함.
- R467은 심각한 새 버전 회귀용 **비상 복구본**이며 일반 업데이트처럼 설치하지 않음. 설치하면 다음 버전은 `>467`이 필요함.
- 앞으로 새로운 후보는 가급적 `versionCode 469 이상`의 단조 증가 코드 사용. 새 후보보다 더 높은 버전코드의 **R463 정확한 기능 복구본**을 별도로 제작·검증(매번 이전 R467만 재활용하지 말 것).
- 앱 삭제·재설치/데이터·캐시·쿠키 초기화 절대 금지. 늘 `com.juhyeon.familyjournea` 기존 인증서 유지.

## 5. 매 새 채팅 기본 작업 절차

1. 프로젝트 별도 최상위 Canonical 읽기 지침을 준수하고, MOA 관련에서는 `MOA_READ_FIRST_NEW_CHAT.md` → 이 문서 → `MOA_WIP_CHECKPOINT_CURRENT.md` → R463 원본 기록 → 개인 Library 파일·최신 변경 소스를 반드시 확인.
2. R463 SHA-256과 원본 인증서·source branch를 먼저 검증. 파일/DEX/temp/검증 자료가 있으면 재활용.
3. 신규 변경은 **새 개발 브랜치를 골든 R463 브랜치에서 분기**하여 작업. 과거 R435, R459, R451을 기준으로 자동 롤백하지 않음.
4. 기존 기능의 손실 없는 작은 수정만 구현. 빌드 후 정확한 signed APK + v2 RSA/full content digest 검증 + ZIP/DEX checksum + 140개 엔트리 diff + 복구 APK + 한국어 README + QA ZIP 제공.
5. 실기기 검증과 정적 빌드 PASS를 반드시 구별. 사용자가 최종 성공·골든 승인을 직접 말하면 그때만 새 골든으로 갱신.
6. 결과물을 private Library, GitHub 인수인계·WIP·새 채팅 안내에 반영하고 현재 채팅에서 다운로드 링크 제공.
7. AirPods/Android Auto 프로젝트 앱/데몬/지침 소스는 모아 갤러리 요청으로 수정하지 않는다.

**현재 기본: `MOA_R463_USER_APPROVED_GOLDEN_20261113`.** 이후 사용자가 새 골든을 지정한 기록이 나오기 전에는 변경하지 말 것.