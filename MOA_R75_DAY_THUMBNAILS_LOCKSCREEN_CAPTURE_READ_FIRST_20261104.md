# MOA R75 — 날짜별 미리보기 첫 표시 + 잠금화면 카메라 기록 알림 / 2026-11-04

> **최신 사용자 실기기 증거:** R74 사용자는 하단 `모아 | 바로 기록 | ×`가 존재함을 확인했음. 그러나 R74에서 *달력의 대표 사진은 이미 보이는데 날짜를 누른 사진 일기 카드에는 빈 회색 미리보기만 보이고, 시간이 지나서야 사진이 나타나는 회귀*를 영상 `18621.mp4`와 화면 `18624.png`로 보고함. 빈 카드도 탭하면 원본 사진은 열림. 따라서 데이터·원본 미디어 ID/저장 문제 아님; **날짜별 큰 썸네일 로드 우선순위 문제**. 아울러 사용자는 Samsung 잠금화면에서 전원 버튼 2회 눌러 보안 카메라로 촬영하면 원래 하단 팝업이 잠금 상태에서는 보이지 않고 잠금 해제 후 보인다고 보고함. **R74 미리보기 갤럭시 FAIL 및 잠금화면 팝업 FAIL**, R74 × 버튼 실제 표시 PASS.

## 우선 지침 / ABSOLUTE GOLDEN
1. 사용자 실제 성공 R63 `com.juhyeon.familyjournea` 원본 서명 GOLDEN SHA256 `64b1b730478a2a50976961cc2dc4cf511182a75495f2d02159f091167f646024` 및 `assets/web/moa-direct-diary-commit.html` **절대 수정 금지**. 원본 일기 IndexedDB `familyjourney-diary-v1/curated`, 음성/네이티브 메모 1회 입력, 실제 촬영 시간/사진 ID, 5분 표시 그룹, 선택 사진 제외, 원본 갤러리 보호, 일기 삭제 확인창, OHO+ 원핸드 ON/OFF, 네이버 기능 모두 유지.
2. 새 채팅은 이 문서 + `MOA_MASTER_CURRENT_GOLDEN_RELEASE_HANDOFF_20261104.md` + `MOA_WIP_CHECKPOINT_CURRENT.md` 순으로 최신 결과 확인. R75 Galaxy 실기기 성공은 아직 없음.

## 1. 증거로 확인한 R74 원인
- 실제 R74 `assets/web/family-diary.js`의 `renderCalendar()` 달력 대표에는 **130px** 썸네일 `thumbs(...,130)`을 로드함. 날짜 `renderDay()`는 **250px** (넓은 화면 400px) `thumbs(...,R38_BIG_THUMB)`를 *별도 키*로 로드.
- `thumbs()`의 기존 빠른 경로는 **동일 해상도** `r74Preview[size+':'+id]`/`r37Ram[size+':'+id]`; `size===130`일 때만 `r37Cover[id]` 조회. 그래서 **달력에 이미 있는 바로 그 사진의 130px 프리뷰를 날짜별 250px 카드에 재사용하지 못하고 빈 회색 칸을 표시**.
- 기존 HostActivity의 원본 `thumbnails(JSONObject)`는 `bg.execute`로 처리하며 `diaryPhotoIndex`도 동일한 `Executors.newSingleThreadExecutor()`를 써서 **전체 13k+ MediaStore 인덱스가 진행되면 250px 사진 썸네일이 줄을 서는 병목**. 데이터 카드 링크는 미디어 ID로 즉시 열리므로 탭은 정상.
- 촬영 팝업은 Android `TYPE_APPLICATION_OVERLAY`, 삼성 보안 키가드 위에서는 화면 아래에 그렸어도 가려질 수 있음. 기존 알림은 `Settings.canDrawOverlays=true`일 때 **IMPORTANCE_LOW** 조용한 채널로 보내기 때문에 키가드 상태에선 알림도 잘 드러나지 않음. 잠금 해제 뒤 숨겨졌던 원래 오버레이가 보인다는 사용자 보고와 부합. **Samsung 보안 화면의 모든 기기에서 표시를 보장한다는 뜻이 아님**.

## 2. R75 수정 구현 — 썸네일
- `assets/web/family-diary.js`의 `r75Peek(id,size)`: 원본 **동일 mediaId**의 250/400px 미리보기가 없을 때, 이미 표시된 달력 130px `r37Cover`, RAM cache, 마지막 화면 버퍼 사진을 **즉시 작은 사진으로 재사용**. 원본 사진 ID의 저해상도 임시 화질만 표기, 수정된 새 사진으로 오인하지 않음; 뒤이어 고화질 비트맵을 기존 사진칸에 비동기 교체. 저장소는 변하지 않음.
- `MoaMomentApplication`의 **선택적 추가 WebView JS Bridge** `MoaQuickThumb` → 신규 `MoaMomentQuickThumb.java`: 기존 HostActivity `bg` 단일 스레드와 독립된 **2-worker read-only thumbnail fetch**에서 Android `MediaStore.loadThumbnail`로 실제 기존 ID를 읽고, 앱의 원래 신뢰된 `https://familyjourney.local/` WebView에만 data:image으로 전달. 내장 메모/사진 저장·권한·원본 미디어는 변경 없음.
- JS `window.__moaQuickThumbResult`는 현재 살아 있는 `img[data-photo-id]`에 즉시 결과 적용. 기존 130px 사진 임시 이미지가 표시되었다면 250px 이미지를 덮어씌움. DOM이 교체되어도 현재 사진칸에 반영, R74 메모리 버퍼 그대로 사용.
- **안전 폴백 필수:** `MoaQuickThumb` 브리지가 기기에 노출되지 않거나 850ms 동안 응답이 없으면 **기존 NativeHost `__requestThumbs`로 원래 방식 유지**. 원본 사진 삭제 판정(`R73.confirmedMissing`)이면 새로운 썸네일과 캐시 이미지를 사용하지 않음. 사용자 사진 삭제/이동·복원/개별 제외/시간/메모 보존 처리 모두 원래 로직 유지.
- 새 썸네일은 **메모리에만** 존재하고 `curated`, 원본 인덱스, 타임스탬프, 사진 파일, 외부 서버에 저장하지 않음.
- 한계: 130px 달력 캐시는 대표 사진 하나에만 있을 수 있음. 나머지 새 사진은 첫 고화질 비트맵 생성 시간이 필요하며 장치의 WebView JS bridge가 보이지 않으면 기존 경로로 복귀. 원본 전체 사진 색인 자체는 기존 삭제 확인용으로 유지(진짜 `MediaStore.getGeneration` 델타 native 인덱스 단계는 아직 미구현). 따라서 **모든 카드가 0ms에 나타난다고 주장 금지**.

## 3. R75 수정 구현 — 잠금화면 카메라
- 기존 `MoaMomentCaptureService.showCapture`에서 `KeyguardManager.isKeyguardLocked()`를 조회. 잠금 상태 촬영을 서비스가 감지했을 때 **중요도가 높은 `CH_EVENT` 시스템 알림**을 사용(`Notification.VISIBILITY_PUBLIC`, 내용 일반 표시, `바로 기록` 누르는 동작, 기존 `바로 메모` 인라인 입력은 유지). 잠금이 아닌 상태는 기존 thumb-zone 오버레이+조용한 알림 그대로 유지.
- **R74 해제 뒤 팝업 기능 보존:** 잠금 중에도 기존 `Settings.canDrawOverlays` 사용자의 오버레이를 원래처럼 생성; 삼성 키가드에서 가려져 있다가 풀릴 때 나타나는 기존 동작을 없애지 않음. 잠금 중에는 **추가로 고우선순위 시스템 알림을 사용**해 사용자가 바로 탭할 가능성을 높임.
- 알림 탭은 기존 `MoaMomentMemoActivity` `PendingIntent` 그대로; 잠금 중 명시적으로 사용자가 탭해서 열면 `setShowWhenLocked(true)`로 **메모 창을 키가드 위에 표시하도록 시도**, 보안 잠금을 임의로 해제하거나 다른 개인 기록을 자동 공개하지 않음. STT/텍스트/원래 로컬 commit+IDB sync 동일.
- **실제 OS 제약을 반드시 알릴 것:** 삼성 Secure Camera/One UI가 타사 알림을 카메라 위에서 차단하거나 사용자가 잠금화면 알림을 숨긴 경우, `Notification.VISIBILITY_PUBLIC`만으로 하단 `TYPE_APPLICATION_OVERLAY`와 동일한 즉시 표시를 보장할 수 없음. Android 14+ `USE_FULL_SCREEN_INTENT`는 전화/알람에 제한되므로 우회로 남용하지 않음. Google Android docs: `KeyguardManager.isKeyguardLocked`, `Activity.setShowWhenLocked`, Android 14 full-screen intent limits.
- 만약 실제 잠금화면에서 알림이 전혀 노출되지 않으면, 새 APK들을 추측으로 계속 내지 말고 갤럭시 잠금화면 알림 정책/채널 허용 상태와 사진 감지 시점(`lastCaptureKeyguardShowing`, `lastCaptureNotificationAt` 개인 메모 원문 없는 진단)을 먼저 확인. **보안 정책을 우회해 잠금 화면 위에 무조건 떠야 한다는 식으로 거짓 약속 금지**.

## 4. R75 APK·빌드 증거
- 기존 R74 정확한 베이스 SHA-256 `4d8ed5a46d0c933db7d805322c8ee591c5f8e9b6fef31e9b893e886cb35239f2`, 동일 패키지·동일 서명.
- **R75 signed APK `MOA_R75_Install.apk`** versionCode **75**, size **3,441,371 bytes**, SHA-256 **`fe4f3bcd08d5806711c4276a88fab7a7b9f16a19b3b24e6853a3eddc36ba8e6a`**. Signing cert SHA-256 **`5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`**, original package `com.juhyeon.familyjournea`.
- 변경 APK ZIP entry **3/55개만**: `AndroidManifest.xml` 버전, `classes4.dex` 본 문서의 선택적 썸네일·보안 카메라 알림, `assets/web/family-diary.js` 캘린더 → 일기 미리보기 즉시 재사용. 나머지 **52개 바이트 동일**: 원래 R63 IDB writer, `classes.dex/classes2.dex/classes3.dex` 원래 HostActivity, 사진 시각·5분 그룹, 네이버 자동화, R70 OHO+ R71 편집/삭제, R74 X.
- GitHub source branch `fix/moa-r75-fast-day-thumbs-lockscreen-capture-20261104`, Java CI run **41772629259 SUCCESS**, compiled `classes4.dex` 74,112 bytes, SHA-256 `e4cc37eddcd49e69f4a840a52e237780f7f01f38b999b0f996732f8ad247cacf`.
- APK v2 signature, certificate, ZIP CRC, DEX checksums, exact preserved-file diff, `node --check` PASS. Synthetic JS regression: **달력 작은 사진 즉시 표시 → 빠른 네이티브 큰 사진 교체**, 달력에 없는 새 사진도 네이티브 callback 연결, 연결 실패 시 기존 thumb 경로, 삭제 확정 ID의 재표출 금지. R73 삭제·제외·복원·정확한 촬영 시각, R63 original fake IndexedDB 동시 저장 테스트 PASS.
- **R75 실제 삼성 갤럭시 실기기 미검증**: 잠금화면에서의 알림 접근·보안 카메라 화면 노출, WebView 새 JS interface 사용, 체감 썸네일 복구 시간은 설치 후 확인이 필요. 이전 R74에서 화면이 빈 것은 사용자 영상으로 확인되었으므로 R74를 썸네일 PASS로 승격시키지 말 것.

## 5. Library 및 다음 작업
- APK private Library `/모아_프로젝트_근거_20261103/MOA_R75_DAY_THUMBS_LOCKSCREEN_RECORDING_BETA.apk`.
- NO KEYS/NO personal photo source `/모아_프로젝트_근거_20261103/MOA_R75_SOURCE_TESTS_NO_KEYS.zip` (exact JS, patch, synthetic tests, hash report). Java actual source files branch above.
- APK update only; **삭제·초기화 금지**, R74 → R75 in-place. Camera unlocked overlay original, note STT and original diary R63 write route, R71 edit/delete and R73 deleted-media consistency regressions must keep passing.
- 기기 테스트 ① 기존에 달력 표지 있는 날짜를 눌러 곧바로 사진칸이 채워지는지 → 다른 사진칸도 빠르게 채워지는지. ② 화면 잠금 후 전원버튼 2번 → 사진 촬영 → 보안 카메라/잠금화면 알림 `모아 바로 기록` 접근과 메모 입력 확인 → 잠금 해제 후 기존 하단 팝업도 유지되는지. 설정/키가드 정책에 의해 알림 자체가 숨겨지면 그 사실을 정확히 기록.
- 미래 Stage B: 전체 MediaStore 대량 목록 조회를 변경분/삭제감사 기반으로 최적화할 수 있지만 R75에는 아직 포함되지 않음.
