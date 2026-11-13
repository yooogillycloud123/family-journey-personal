> **2026-11-13 MOA R487+R489 ORIGINAL-SIGNED APK AND COMPLETE ZIP — USER-RERPORTED LINK FAILURE ON PRIOR DIRECT APK:** R487 signature issue definitively resolved via verified PRIVATE Library signer backup; real original-signer R487 APK SHA256 `d9c09d4824419b0d96e15a8da54533ce7f4b0cdf7f3380994a188463c91eec3c` code487 and R489 exact user-approved R463-function recovery SHA256 `badee091d8afd20c39afcc5c9862ef09068a21768e6a2856f0ae7efaaa2c2b5e` code489; original signer cert `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`, v2 RSA/full digest, 17 original DEX verified. Full ZIP `MOA_R487_R489_SIGNED_APK_SOURCE_QA_20261113.zip` 13,211,615 B SHA256 `e11d959d5563757d4fb7d292ef01f1e38bd66ad6c5a090d8a6d20ffcafb27ded`, includes 2 APK+source+QA+screenshots+README+SHA sums, local ZIP CRC/content parity PASS, private Library upload `/모아_프로젝트_근거_20261103/R487_R489_DAYPIC_SIGNED_RELEASE_20261113/` SUCCEEDED. **Android recipient link `Library file not found` was reported for earlier direct APK links; NEW ZIP recipient opening is NOT VERIFIED**, do not conflate local artifact/Library upload with recipient success; no public GitHub APK or email without permission. R487 static/synthetic PASS, on-device UI/NAVER/Gallery UNTESTED. R463 IMMUTABLE Golden. If R489 recovery installed then new code >489. **Read [full actual signed ZIP handoff](MOA_R487_R489_SIGNED_DAYPIC_ZIP_RELEASE_HANDOFF_20261113.md)** before continuing. Older R487 source-only blocker is superseded; do not claim signer unavailable. No user data reset; unrelated AA AirPods untouched.

# 모아 새 채팅 이어가기 — R463 사용자 승인 통합 골든

모아(MOA) 프로젝트를 계속 진행해. **최신 사용자 승인 통합 골든은 R463**이야. 사용자가 2026-11-13에 R463을 명시적으로 골든으로 확정했고, 이제 모든 업그레이드는 그 버전에서 이어가야 해. 기존 R435는 이전 골든으로 역사적 보관하며 현재 개발 기준이 아냐. R459/R451 등의 과거 버전으로 회귀하면 안 돼.

작업 전에 GitHub `yooogillycloud123/family-journey-personal`의 다음 문서를 순서대로 전부 읽어:

1. `MOA_READ_FIRST_NEW_CHAT.md`
2. `MOA_R463_GOLDEN_LOCK_READ_FIRST_20261113.md`
3. `MOA_WIP_CHECKPOINT_CURRENT.md`
4. `MOA_R463_R459_GALLERY_UPPER_FAST_SWIPE_MODE_R465_RECOVERY_20261113.md`

원본 소스 고정 브랜치 `golden/moa-r463-user-approved-20261113`, 소스 파일 `experiments/moa-r391/MoaR391SessionPersistProvider.java`.

개인 Library `/모아_프로젝트_근거_20261103/GOLDEN_R463_USER_APPROVED_20261113/`의 원본 APK, 정확한 소스/패치, 전체 QA, 비상복구본을 직접 확인해. 이전 R463 작업 아카이브는 `/모아_프로젝트_근거_20261103/R463_STAGE_FAST_SWIPE_20261113/`.

고정된 R463 원본: `MOA_R463_GALLERY_OPT_IN_FAST_STAGE_SWIPE_SIGNED_BETA.apk`, `com.juhyeon.familyjournea`, versionCode **463**, SHA-256 **`9d2fd10d32a3bc35eb3132333e96edd8f565abd5daf3ce954b052f77083d8379`**, 기존 서명 인증서 SHA-256 `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`.

절대 손실하면 안 되는 기능: 고급 원본 네이티브 갤러리의 사진·영상 혼합보기, 하단 좌우 부드러운 썸네일 관성 스와이프, 동영상 재생/음소거/볼륨/캡처/탐색, 사진 확대, 네이버 원본 장소/GPS, 공유 시 갤러리 유지, 원래 모아 일기·바로기록·테마, 네이버 PC 지도 가림막 자동 준비·비점유 저장·재준비·실제 저장 판정·로그인 쿠키, 별도 웹창·분홍 홈 드래그.

**R463 갤러리 하단 기능 바는 4개 아이콘 순서 고정:** `공유 / 네이버지도 실제 이동 / 접이식 지도 = 촬영 시간·주소·기본표시 패널 토글 / 큰 사진·영상 연속 스와이프 ON/OFF`. 지도 그림은 약 14.4dp 시각 크기(터치 영역은 넉넉히 유지), 상단에는 별도 그림 버튼 없음. 세 번째를 누르면 기존 상단 같은 위치에 촬영정보 카드가 나타나고 다시 누르면 접힘. 체크 ON이면 기본 표시·유지. 네 번째 빠른 스와이프는 **기본 OFF**로 한 장씩 이동, ON일 때만 큰 화면에서 하단 레일과 동기화해 여러 장 연속·관성 스와이프. OFF 및 갤러리 재진입 시 기존 동작 유지. 확대·핀치·영상·영상 캡처 충돌 금지.

복구 구분이 매우 중요해: **R465는 R459 기능으로 되돌리는 구형 복구본이라 R463 골든 복구용이 아냐.** 별도로 검증한 **R467** `MOA_R467_EXACT_R463_GOLDEN_FUNCTIONAL_RECOVERY.apk`가 R463 기능 원본과 똑같은 전용 복구본이야 (Manifest versionCode만 467). 이후 새 후보는 가급적 **versionCode 469 이상**, 동일 원본 서명, 정확한 R463 기능을 복원하는 더 높은 코드 복구 APK를 함께 제공해.

R463 골든 APK/브랜치/Library 보관본을 수정하거나 삭제하지 마. 앱 삭제·데이터/캐시/네이버 로그인 쿠키 초기화 금지. 새로운 요청은 **R463에서 출발한 delta**로만 구현하고 정적 APK 검증과 갤럭시 실제 기능 확인을 구분해. 최신 중간 빌드/소스/DEX가 있으면 먼저 재활용. 결과물은 서명된 덮어쓰기 APK + 골든 기능 복구 APK + 소스/QA ZIP + GitHub 최신 기록/개인 Library 보존까지 한 세트로 처리해.

이 대화 프로젝트의 별도 에어팟 Canonical 우선 읽기 지침은 준수하되 **모아 작업과 무관한 에어팟/Android Auto 소스는 수정하지 마**.

새 채팅에서 사용자가 요구한 다음 개선을 위 R463 골든에 이어서 진행해.