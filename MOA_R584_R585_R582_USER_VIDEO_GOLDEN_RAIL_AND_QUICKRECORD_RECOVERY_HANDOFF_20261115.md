# MOA R584 / R585 — 22066.mp4 사용자 실기기 오류 대응 / R567 필름스트립 원상복구 (2026-11-15 KST)

## 최우선 실제 사용자 확인
- 사용자 R582 실기기 영상 `22066.mp4` **FAIL**. 이전 사진/영상은 네이티브 갤러리·필름스트립·조작버튼이 표시되지만, 문제 날짜의 사진형 카드에서 분홍색/빨간색 화면과 썸네일만 보이고 정상 사진형 갤러리 표시가 실패. 이 영상만으로 해당 사진의 원본 MediaStore 상태나 IDB 실제 내용을 확정해서는 안 됨.
- 사용자는 R580→R582의 필름스트립 아래쪽 강제 재배치를 **완전 철회**할 것을 명시했고, 순간기록은 상세형에 저장되나 사진형이 다시 열어도 갱신 안 되는 회귀를 반복 보고.
- **CURRENT USER-APPROVED GOLDEN = R567**, 코드/원본 APK SHA `f205afb72744391ce9f2594f898728699870be006f787c712599a1ee8492e93c`; 불변 분기 `golden/moa-r567-user-device-pass-20261114`. **R584 실기기 PASS 미검증**.

## 소스 대조로 확인한 원인
1. R580/582 `MoaR507InlineGalleryProvider.java`는 `r576TightenMeasuredRail()`로 전체 `nativeLower`를 실제 filmstrip과 actionDeck 거리 계산에 따라 **아래로 강제 translationY**했음. R567 원본은 자동 translation 자체가 없고 펼침 높이 137dp/접힘 82dp. 이것이 사용자 의도와 반대였음.
2. 사진형 JS `r578HydrateSelectedDay()`는 IndexedDB `curated`에서 새 photoIds를 읽어도 이미 원본 Gallery가 열린 상태(`r507Opened / __moaR507NativePending`)면 `ui.media`와 해당 Gallery의 플레이리스트를 변경하지 않음. 상세형 기록 저장과 별도 Gallery 미디어 목록에 **갱신 누락** 경로가 존재.
3. 사진형 진입 때도 비동기 DB 재조회보다 `r507StartInline()`가 먼저 실행되어 **과거 캐시 ID**로 Gallery가 초기화될 수 있음. 앱 재시작 후 어떤 날짜의 기록이 불러와지는지는 실제 휴대폰 DB/MediaStore 증거로 최종 확인 필요.
4. 원본 JS에는 기존 `__moaR543RepairInline()` (렌더러만 다시 연결) 코드가 있었지만 상단 `··· → 갤러리 다시 표시`는 **IDB 재조회/MediaStore 재색인 없이 재실행**했음. 이 방식만으로 새로 저장된 photo ID 누락은 해결되지 않음.

## R584 범위 고정 — 큰 UI 변경 금지
- 별도 개발분기 [R584 source](https://github.com/yooogillycloud123/family-journey-personal/tree/feature/moa-r584-r582-r567-rail-quickrecord-rebind-20261115) (최신 커밋 `0a3fa4cd8c7c02f46eaa6f26af7af32a8e3d0c2d`).
- Java의 필름스트립 `setRailExpanded`는 **R567 원래 137dp/82dp 높이, 원래 레이아웃**으로 복구. `r576TightenMeasuredRail` 메서드와 호출 완전 삭제. 덱/rail 임의 평행이동 금지. R572 이후 사용자가 원했던 8개 액션 기능은 그대로.
- 사진형 날짜 렌더는 기존 IndexedDB `curated` 동일 날짜 photoIds/moments를 read-only 재조회한 **뒤에 원본 native Gallery를 처음 열도록 순서 변경**. 추가된 저장 ID를 탐지하면 해당 날짜 한정으로 한 번 Gallery native ID 리스트를 재연결; 단순 메모·글 수정/ID가 동일한 경우 기존 재생기 절대 재시작 안 함.
- 사진형 상단 **↻ 복구 버튼**과 기존 `··· → 갤러리 다시 표시`는 모두 `r584RecoverGallery` 실행: 기존 `curated` IDB 읽기 전용 재조회 → 원본 MediaStore 인덱스에 없는 ID일 때만 기존 `FamilyJourneyDiary.loadIndex(true)` 호출 → 원본 Gallery의 현재 날짜 ID리스트 재연결. 저장소 쓰기/사진삭제/쿠키 삭제/일기 초기화 절대 없음.
- 조회 결과 사진 ID가 0개이면 **없는 미디어를 가짜로 열지 않음**. 재색인 요청+사용자 안내만 진행, 실패를 성공이라고 분류하지 않음.
- R567 갤러리 lifecycle/Back/Home/Recents, 원본 17 DEX, Naver writer, STT/녹음, original MediaStore, IndexedDB schema/data/쿠키는 전혀 수정하지 않음.

## 서명·정적 검증 (실기기 PASS와 구분)
- **R584 install** `MOA_R584_GOLDEN_RAIL_QUICKRECORD_GALLERY_REPAIR_ORIGINAL_SIGNED_BETA.apk`, code584, **9,091,636B**, SHA256 **`8f47eca0308bfceb3770c55b4a8834b68aad94d159d254711ef040178128aa7c`**.
- **R585 emergency R567-functional exact** `MOA_R585_EXACT_R567_GOLDEN_FUNCTION_FORWARD_RECOVERY.apk`, code585, **9,069,600B**, SHA256 **`b3e6a6ee95bf519bc7e239d21a83c930f69fb22d8203c72bfdd545cd5ccdd4ca`**. R567 총 143개 ZIP 구성요소 중 **142개 바이트 동일**, 유일 변경 AndroidManifest versionCode 585.
- Both package `com.juhyeon.familyjournea` + original cert SHA `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`; APK v2 RSA signed digest, ZIP CRC/alignment, DEX SHA1/Adler32 independent PASS.
- R582→R584 변경 **4/144 구성요소만**: Manifest, `classes18.dex`, `assets/web/moa-r483-vertical-calendar.js`, `.css`. Original 17 native DEX byte-identical.
- [SDK35 Java/D8 CI 43654266051 SUCCESS](https://github.com/yooogillycloud123/family-journey-personal/actions/runs/43654266051), exact Git-source blob hashes = local R584 source and exact CI-source artifacts verified; Node actual function 9/9 MOCK contracts PASS. **Physical Galaxy R584 NOT_TESTED, NOT GOLDEN**.
- Unified ZIP `MOA_R584_R585_GOLDEN_RAIL_QUICKRECORD_GALLERY_REPAIR_20261115.zip`, 19,829,656B SHA256 **`c87e553909758c127455d26b0ffc5353942412accc8e8b5bebcf9810f34af8d4`**, 12 members CRC/hash PASS: R584/R585, exact R567 read-only reference, source, diff, CI/QA, README. No signer/private key/password/family media.
- Archived in personal Library **`/모아_프로젝트_근거_20261103/R584_R585_SIGNED_20261115/`**.

## 설치 및 실제 판정
- 현재 R582 등 code ≤583 동일 서명 모아에 R584만 **덮어 설치**. uninstall, app data/cache clear, DB reset, Naver cookie/auth reset 금지.
- 우선 이전 정상 날짜 1개로 R567 필름스트립의 기존 위치 확인 → 이후 새 순간기록 사진을 저장하고 **정확히 같은 날짜** 상세형 및 사진형 비교 → 사진형 누락 시 상단 ↻ 버튼 **한 번** 실행 후 실제 원본 이미지/썸네일 및 8버튼 표시 확인.
- 실기기 문제 시 `R585`로 정확 R567 **기능 복귀만** 가능. R585 설치 뒤 모든 다음 versionCode **≥586**; 기존 낮은 R583은 되돌아갈 설치 방법이 아님. 앱 자체에서 별도 권한 없이 설치 APK를 자동 무인 실행할 수 있다고 주장하지 말 것.
- User video and runtime trace가 없으면 이 새 R584의 실제 사진형 정상 PASS·재생 중 무깜빡임·나머지 모든 앱 기능을 완료했다고 말하지 말 것.
- **AirPods Android Auto project source/daemon untouched**.
