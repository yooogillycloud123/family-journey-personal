# 모아 새 채팅 즉시 이어서 진행 — 2026-11-16 R621 beta / R611 physical Golden

**작업 시작 순서 (분석·수정·새 APK 빌드 전에 읽을 것):**

1. `yooogillycloud123/workexcel-devbridge/main/AA_AirPods_FINAL_READ_FIRST_v1.0_20261005.md` 처음부터 끝까지.
2. `yooogillycloud123/family-journey-personal/main/MOA_READ_FIRST_NEW_CHAT.md` 및 `MOA_WIP_CHECKPOINT_CURRENT.md`.
3. `MOA_R611_USER_DEVICE_APPROVED_GOLDEN_LOCK_20261115.md`와 `MOA_R611_GOLDEN_ROOT_CAUSE_ENGINEERING_AND_R613_UI_HANDOFF_20261115.md`를 먼저 읽어 불변 골든/실기기 성공 근거를 이해한다.
4. `MOA_R619_R620_DATE_FLING_MEDIA_MULTIADD_SIGNED_HANDOFF_20261116.md`와 **최신 `MOA_R621_R622_STATIONARY_DATE_WHEEL_VERTICAL_PICKER_ORIGINAL_SIGNED_HANDOFF_20261116.md`**를 상세히 읽는다.
5. Private Library `/모아_프로젝트_근거_20261103/R621_R622_R611_GOLDEN_DATE_WHEEL_VERTICAL_MEDIA_20261116/`에 저장된 정확한 APK/Source/QA ZIP을 확인한 후 중단 지점에서 이어간다.

## 불변 기준
- 실기기에서 승인된 최고 골든은 **R611**, APK versionCode611 SHA256 **`38a507cf2e88a235282ae4d9ad64cf0799033f34ae8fe3e179a58960d1213ccd`**. R605 이전 골든도 보관. One Hand Operation+ `NaverSaveService` 접근성 OFF/ON 반복 후 네이티브 R463/605 갤러리 8개 버튼·필름스트립 생존 및 사진/상세/백그라운드 복귀를 반드시 유지. R611 Golden 소스/APK/서명/원본 DEX 18개를 변형하지 않는다.
- 이전 보조자의 잘못된 카메라 watcher 가설과 네이티브 갤러리 호스트 자동 닫기/강제 재연결 회귀를 다시 만들지 않는다. 본 사용자의 실제 영상·문구→대상 네이티브 함수/DOM→정확한 파일 차이→실기기 성공까지 검증한다.

## 최신 R621 설치용 베타
- 부모 R619 original-signed code619 SHA256 **`8251ede19b932147445fed3d991cc9ee5fcaf5c74c78ca7b1084ee5ed277416c`**.
- **R621 installable** `MOA_R621_R611_GOLDEN_STATIONARY_DATE_WHEEL_VERTICAL_MEDIA_PREVIEW_ORIGINAL_SIGNED_BETA.apk`, versionCode621 SHA256 **`3000e98d180d89372f6335edf1f5299894b9beb92c9ccccd3acd3bd9f454b8df`**, size **9,092,808B**, original same certificate. **Only Manifest + PHOTO JS + PHOTO CSS changed** vs R619, **141/144 members and all original 18 DEX identical**.
- Source GitHub feature branch `feature/moa-r621-r619-golden-stationary-date-wheel-vertical-picker-20261116` under `release_snapshots/moa-r621/assets/web/`, verified exact Git Blob SHA1 JS `dcb782268eca944cda022fd2ccbd2668bf19276c`, CSS `714cfed6e79a9516cafbf280fdce5e3054ac3a7e`.
- User reported R619: photo/detail date horizontal input MOVED adjacent date cells like photos; R621 date string POSITION FIXED, swipe end animates ONLY NUMERALS and opens actual day once. 560ms hold opens ORIGINAL calendar-style bottom year/month scroll wheel (not fullscreen button-grid). Photo settings formerly invisible behind native host now explicit user-opened lower bottom sheet, re-tap gear/X returns original date. Central + from picker again returns to current day. Picker default day/all-period mixed photos/videos vertically scrolling 3-column grid, 48-at-a-time automatic infinite load with NO 'more' buttons, per capture-date sections. Fullscreen 2048px thumb/video poster preview next/previous/touch swipe with add/remove selection; video plays via existing `diaryPlayVideo` action. Original IndexedDB merge writer unmodified.
- Browser source-level actual Chromium QA: stationary coordinate and one commit, original bottom year/month wheel, 120-thumb auto loader, large viewer 2 selections, photo settings bottom-sheet toggle PASS; Node syntax PASS; APKv2 and original certificate, DEX integrity, ZIP stored alignment PASS. **R621 Galaxy physical test PENDING, NOT GOLDEN**.
- **R622 emergency recovery** `MOA_R622_EXACT_R619_FUNCTIONAL_FORWARD_RECOVERY_ORIGINAL_SIGNED.apk` versionCode622 SHA256 `747728548ba17301daa51ed9c725899980a6c9b6bd2ef469b6fe8c9a9845ef5b` is EXACT R619 functionality except Manifest version; NOT exact R611 restore. If installed subsequent APK versionCode >=623.
- All-in-one distributable ZIP **`MOA_R621_R622_R611_GOLDEN_FIXED_DATE_VERTICAL_MULTISELECT_SIGNED_QA_20261116.zip`** SHA `2a9315d504efce20c5207807570705a315bb4ec11ae64c7173f713af0a3f5c0d` in the Library path above. No signing keys/passwords/user media.
- User videos `22613.mp4` (51s), `22614.mp4` (65s) and `22611.png` are private evidence and may be accessed only from current conversation uploads; never commit to public GitHub.
- Do not delete/reinstall the app or clear Naver cookies/IndexedDB or downgrade versionCode. Stop claiming final success when only browser mock PASS; real Samsung Galaxy regression PASS is separate.

**Immediate next work**: Ask only for missing actual physical behavior *if genuinely necessary*; prioritize user's next screenshot/recording and repair only the exact failed path, preserve prior output and make original-signed APK. Keep AirPods Android Auto project audio code untouched.
