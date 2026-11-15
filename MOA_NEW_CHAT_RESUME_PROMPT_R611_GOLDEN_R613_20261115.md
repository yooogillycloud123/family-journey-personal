# 새 채팅에 그대로 붙여 넣을 모아 프로젝트 시작 프롬프트

모아 가족 사진·일기 Android 앱 개발을 **가장 최신 검증 상태에서** 이어서 진행해. 오래된 골든/구형 갤러리로 롤백하거나 구조를 새로 설계하지 마.

**최우선 사용자 승인 골든: R611**. 사용자 직접 Galaxy S26 Ultra에서 설치 직후 원래 네이티브 갤러리의 하단 필름스트립·8개 기능, 사진형↔상세형, 외부 앱 복귀, Samsung One Hand Operation+로 **'모아 · 네이버지도 장소 저장 보조' 접근성 서비스 OFF→ON 반복 뒤에도 갤러리가 살아 있는 것**을 성공 확인함. 원본은 `MOA_R611_NAVER_ACCESSIBILITY_TOGGLE_NATIVE_GALLERY_RECOVERY_ORIGINAL_SIGNED_BETA.apk` / versionCode611 / sha256 `38a507cf2e88a235282ae4d9ad64cf0799033f34ae8fe3e179a58960d1213ccd`. **절대 변경/삭제 금지.** R605 이전 골든도 보존.

1. 최상위 Canonical `yooogillycloud123/workexcel-devbridge/main/AA_AirPods_FINAL_READ_FIRST_v1.0_20261005.md` 전체를 먼저 읽되 별개 에어팟 오디오 프로젝트 소스에는 손대지 마.
2. `yooogillycloud123/family-journey-personal/main`의 `MOA_READ_FIRST_NEW_CHAT.md` → `MOA_WIP_CHECKPOINT_CURRENT.md` → `MOA_R611_USER_DEVICE_APPROVED_GOLDEN_LOCK_20261115.md` → `MOA_R611_GOLDEN_ROOT_CAUSE_ENGINEERING_AND_R613_UI_HANDOFF_20261115.md` → `MOA_R613_R614_ORIGINAL_SIGNED_UI_RELEASE_20261115.md` 전문과 최신 Library/실제 APK를 읽어.
3. PRIVATE Library `/모아_프로젝트_근거_20261103/GOLDEN_R611_USER_DEVICE_APPROVED_20261115/`의 해시 검증된 원본 R611 골든 ZIP을 먼저 확인. R611 원본 144개 APK 멤버의 해시, DEX18개, 원래 Gallery host, Naver accessibility service, M4A, IndexedDB, 네이버 로그인 유지 필수. 개인 서명키/비번을 GitHub·공개 산출물로 전송 금지.
4. R609 실패는 보조자가 One Hand Operation+에서 켜고 끄는 **네이버 접근성 서비스 `NaverSaveService`**를 **카메라 감시 `MoaMomentNative.setEnabled`**로 잘못 추정한 명백한 오진 때문. R611은 진짜 접근성 서비스 상태 관찰과 기존 R567 무파괴 원본 Gallery 재부착 경로를 써서 사용자 실기기 성공. 사용자의 트리거·클래스·실기기 관찰을 가설보다 우선하고 원인 모르면 로그로 검증. 이전에 실패한 가설·임의 타이머는 반복하지 마.
5. 최신 후보는 **R613 원본 서명 베타** `MOA_R613_R611_GOLDEN_PHOTO_PANEL_VOICE_STORY_UI_ORIGINAL_SIGNED_BETA.apk`, code613 SHA256 `32eab20c71c1a25ef5c652856e53e249427ebe4459515da0c27e5396d4c8cbb9`. R611 대비 Manifest, 사진 JS/CSS, 일기 JS, 음성 JS만 변경, **139/144 멤버와 18/18 DEX 바이트 완전 보존**. 변경 기능: 작고 구분되는 설정 `···`(68x34 터치/50x26 표시/13px 글리프), 상세형 원래 R96 위·아래 이동패널을 사진형에서도 하나로 사용, 사진형 음성 기록 기본 접힘/녹음별 카드/빨간 Record/실제 native M4A 재생·일시정지·경과·전체·남은 시간·텍스트, ‘오늘의 이야기’ 입력란 길이 자동 성장·축소.
6. **R613 실기기 PASS 아직 없음.** 절대 R613을 골든으로 단정하지 말고 원래 네이버 접근성 ON/OFF를 반복해도 R611 갤러리가 보존되는지 + 신규 기능을 확인. 실패한 항목만 격리 수정. R611 골든 브랜치·APK는 그대로.
7. R613에 새 심각한 회귀 발생 시 **R614** `MOA_R614_EXACT_R611_USER_GOLDEN_FORWARD_RECOVERY_ORIGINAL_SIGNED.apk`, versionCode614 SHA256 `2822f0490e5fc1049a98c2439cec9ded4e3c807f77d4108cd335f21d909df74a`, Manifest 버전 외 **143/144 APK 멤버 내용이 정확히 R611과 동일**, 사용 승인 골든 기능으로 상위 버전 복구. 데이터 삭제/초기화 금지. R614 설치 후 다음 앱 코드 ≥615.
8. 모든 수정 전 `문제에 대한 사용자의 실제 관찰 → 대상 컴포넌트 식별 → 경쟁 가설/반증 → 정확한 코드 호출경로 → 작은 패치 → 원본 해시·서명·DEX 보호 → 브라우저/CI 테스트 → 실기기 승인` 순서 적용. 사용자의 힌트를 기다리기보다 스스로 도구·APK·로그로 먼저 관찰하고, 근거 없는 단정·엉뚱한 기능 수정·회귀 APK 전달은 금지.

새로 받은 영상·스크린샷이 있으면 이 파일들을 직접 확인하고, 실제 사용자 테스트 증거를 우선하여 진행하라.