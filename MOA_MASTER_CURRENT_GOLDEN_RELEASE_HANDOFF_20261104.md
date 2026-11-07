> **2026-11-07 LATEST MOA USER-CONFIRMED R163 DEVICE GOLDEN — READ THIS FIRST (supersedes older R115-as-current headings, not their frozen artifacts):** User explicitly completed physical device testing and said R163 "일단 작동함", requested Golden registration and preservation of all preceding work. Exact signed **MOA R163** `com.juhyeon.familyjournea` code163, **5,540,517B SHA256 `f789a3a579102bfb34a77da11be9b99b18b54906527c428603885bbd130e68e1`**, original cert `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`; independent APK-v2 RSA/digest/ZIP + 128-member lock PASS. **USER DEVICE INSTALL/BASIC OPERATION PASS**, NOT evidence all individual STT/IME/video regressions passed. Exact immutable Library `/모아_프로젝트_근거_20261103/MOA_R163_USER_DEVICE_GOLDEN_20261107_DO_NOT_MODIFY.apk`, per-member hash manifest, full lock and no-key source QA frozen; GitHub source-only branch `golden/moa-r163-20261107-user-device-basic-pass-do-not-modify`. **MANDATORY FIRST READ:** [R163 Golden Lock](MOA_R163_USER_DEVICE_GOLDEN_LOCK_READ_FIRST_20261107.md) then R163 handoff, release ledger, R115/historic lock. R163 base R161 122/128 unchanged; R163 IME footer fix, record/play controls, partial file STT, video poster button styling; external native video player unchanged. **Next normal version >=165; reserve 164 rollback.** No old Golden overwrite, app uninstall/clear, helper apps, signing key exposure, email or AirPods changes. 

> **2026-11-06 MOA LATEST ACTIVE GOLDEN OVERRIDE — R115 (USER-APPROVED VISUAL GOLDEN).** THIS TOP BLOCK OVERRIDES ALL OLDER "LATEST R63/R89/R96/R99" HEADINGS BELOW; THOSE ARE HISTORICAL, NOT A REQUEST TO DOWNGRADE. User explicitly requested Golden registration after R115 fix. Exact signed private Library APK `/모아_프로젝트_근거_20261103/MOA_R115_USER_APPROVED_VISUAL_GOLDEN_20261106_DO_NOT_MODIFY.apk`, package `com.juhyeon.familyjournea`, versionCode **115**, **5,406,744 B**, SHA256 **`1118bdc249e2d941a899518e58be0185b120a887ff2c371c8f5a01037a5002a8`**, original signer cert SHA256 `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`. ZIP/v2 verification PASS, R113→R115 changed ONLY binary Manifest/version and `assets/web/index.html` early CSS/180px splash first paint (101 of 103 other members identical). User visually approved R115; **full existing diary/photo/calendar/voice/native feature regression is PENDING, NOT PASS**. R63/R83/R89 and R96 historical Goldens remain frozen. Emergency R116 reserved for R113 recovery; next feature code **>=117**. Read **[MOA_R115_NEXT_CHAT_START_HERE_20261106.md](MOA_R115_NEXT_CHAT_START_HERE_20261106.md)** FIRST, then **[R115 GOLDEN LOCK](MOA_R115_USER_APPROVED_VISUAL_GOLDEN_LOCK_20261106.md)**, **[FAILURE/REPAIR LEDGER](MOA_RELEASE_FAILURE_LEDGER_AND_BUILD_GATES_20261106.md)**, **[ARCHITECTURE + QA MAP](MOA_ARCHITECTURE_EXTENSION_AND_QA_MAP_20261106.md)**, **[APPEND-ONLY RELEASE REGISTRY](MOA_RELEASE_LEDGER_CURRENT.md)**. In every new chat: read project AA canonical first if required, inspect actual Library artifact/hash, do not rely on stale source. **NO Gmail/email/drafts** and no misleading ChatGPT sandbox delivery claims. Never uninstall/clear existing app or publish private signer/photo/data.

---

## 2026-11-04 CURRENT GOLDEN: USER-PROVEN MOA R89 — STRICT READ FIRST
User said `오케이 일단 성공 골든버전으로 저장하고 이걸 기반으로 확장하는 방향으로 가자` after screenshot proofs 18777/18779/18781/18783. R89 code89 same-signer user-Golden, exact SHA256 `2b52826fc0dd8653a70d3c503d3654ae33071bfc4ec075753ec4464a1e2dc493`, 3,491,886 bytes. Keyboard-open Mic/Clear/Save, typing/STT and safe delete confirmation physically confirmed, camera temporary memo-save toast confirmed; R89-specific IndexedDB completion was not independently proved by the camera screenshot alone, while R63 direct-save prior Golden remains frozen. Private Library canonical APK `MOA_R89_USER_DEVICE_GOLDEN_20261104_DO_NOT_MODIFY.apk`, private evidence screenshots ZIP, exact SHA JSON. GitHub protected baseline `golden/moa-r89-20261104-user-device-pass-do-not-modify`, read `MOA_R89_USER_DEVICE_GOLDEN_LOCK_20261104.md` FIRST; older R79/R83/R89 UNTESTED lines are historical as to user-confirmed features. Future improvements ONLY separate versionCode >=91 + new branch and identical signer, protect R89 R87/R85 UX, R83 native voice bridge and R63 IndexedDB. R90 recovery-forward-to-R87 is NOT Gold. Do not uninstall or clear app data. Voice accuracy improvement on hold. AA AirPods project untouched.

## 2026-11-04 R79 latest — actual R78 editor speech FAILED not-allowed; R78 native lockscreen memo voice PASSED
The R78 screenshot 18675.png shows `familyjourney.local` browser alert `음성 입력 실패: not-allowed` when using diary-editor microphone. Root source: missing/exposed-late `MoaVoiceNative` causes R78 to fall back to blocked Web Speech in WebView. R79 eliminates Web Speech fallback and routes editor dictation to SAME already-working native SpeechRecognizer via direct bridge or same-origin `WebChromeClient.onJsPrompt` fallback without reloading dirty diary. Signed R79 APK SHA256 211d3b1501c4f451261f9358ef2f2f3ebc7b7154f13bdc4eedaf13b74a50943a, code79, 3454131 bytes, same package/signer; 3/55 member changes only. R77 keyguard popup & R78 native photo memo speech/ R63 IDB writer byte-preserved. CI 41786151324 + APK/JS/IDB/deletion/thumb tests PASS; **R79 Samsung editor voice PHYSICAL UNTESTED**. Read MOA_R79_R78_DIARY_VOICE_NOT_ALLOWED_NATIVE_PROMPT_BRIDGE_READ_FIRST_20261104.md first.

> R78 newest: R77 secure camera popup user PASS; native SpeechRecognizer + diary fields microphone R78 static build PASS, Galaxy speech untested. See MOA_R78_R77_LOCKSCREEN_GOLDEN_NATIVE_STT_EDITOR_VOICE_READ_FIRST_20261104.md.

# 2026-11-04 LATEST R77 — Secure Samsung Camera pill overlay code parity with GitHub GB4PC (DEVICE UNTESTED)
User confirmed the bottom "모아 | 바로 기록" popup IS constructed on photo capture while locked and only becomes visible after unlock, then times out: do not misdiagnose missing photo detection. Public GitHub project aunger/gallery-button-for-pixel-camera actual OverlayManager.kt uses FLAG_SHOW_WHEN_LOCKED | FLAG_LAYOUT_IN_SCREEN on TYPE_APPLICATION_OVERLAY; exact MOA R75/R76 native source missed these. R77 applies those flags ONLY when KeyguardManager.isKeyguardLocked (normal unlocked popup unchanged), preserves R76 individual persistent thumbs, R63 direct diary Golden, R73 fast sync, R74 × dismiss, R70 OHO, NAVER, all original JS. Same package and signer R77 APK code77 SHA256 a37a0f062c545b1d07dd1e635cc5084239a64ad18bb13b74fe810e01eba72003 (3,445,814B), changed manifest+classes4 DEX only (53/55 bytes identical). Android CI run 41780297825 SUCCESS; APK static v2/DEX/ZIP PASS. Samsung secure-camera physical pop-up untested; official Android says FLAG_SHOW_WHEN_LOCKED deprecated and only topmost full-screen, so no guarantee. More promising but permission-sensitive alternative TYPE_ACCESSIBILITY_OVERLAY (Smart-AutoClicker GitHub issue #927 lockscreen display) is NOT implemented and must never cover PIN. Complete report: MOA_R77_GITHUB_SECURE_CAMERA_OVERLAY_FLAG_EXPERIMENT_20261104.md. R63 Golden unchanged.

## 2026-11-04 최신 R75: R74 실제 갤럭시 날짜별 사진 미리보기 빈칸 + 삼성 잠금화면 보안 카메라 팝업 누락
실제 사용자 영상 `18621.mp4`에서 달력 대표 미리보기는 보이지만 해당 날짜에 들어가면 동일 사진 카드 미리보기가 빈칸이고 시간이 지나서 보임(카드 탭 원본 정상). **R74 썸네일 UX 실기기 FAIL**, R74 `×` 닫기 버튼 화면 표시 PASS. 사용자 추가 보고: 전원버튼 더블클릭으로 잠금 상태 Samsung Secure Camera에서 사진 촬영하면 모아 하단 `바로 기록` 팝업 안 보이고 잠금 해제 뒤 나타남. R75는 달력 130px 이미지를 날짜별 250px 카드에 즉시 재사용하며 기존 동일 사진 원본 ID 검증 후 고화질로 전환, 독립 2스레드 **`MoaQuickThumb`** 읽기 전용 썸네일 경로 추가(브리지 불가시 기존 NativeHost 850ms fallback). 잠금시 `KeyguardManager.isKeyguardLocked()` 검출로 조용한 알림 대신 PUBLIC 고우선순위 바로 기록 시스템 알림, 사용자가 탭한 기존 메모 Activity만 `setShowWhenLocked(true)`; **기존 잠금해제 뒤 하단 오버레이 및 평상시 ×/좌우이동/바로기록/8500ms 유지**. 보안 키가드에서 OS/사용자 알림 설정으로 타사 알림이 가려질 수 있어 잠금상태 표시를 보장할 수 없음; FSI 우회 사용 금지.
**R75 최종 APK** `MOA_R75_Install.apk`, code75, bytes **3,441,371**, SHA256 **`fe4f3bcd08d5806711c4276a88fab7a7b9f16a19b3b24e6853a3eddc36ba8e6a`**, original package/signature preserved; R74 대비 manifest/classes4.dex/diary JS 3개만 변경, 52/55 바이트 동일(기존 R63 실제 저장 GOLDEN HTML, HostActivity original DEX, R70 OHO, R71 편집·삭제, R73 삭제/제외 로직 그대로). Java CI run `41772629259` PASS, DEX/ZIP/APK v2/JS/갤러리 삭제·복구/R63 실제 IndexedDB writer fake tests PASS. **삼성 R75 실기기 결과는 미확인**. Library `/모아_프로젝트_근거_20261103/MOA_R75_DAY_THUMBS_LOCKSCREEN_RECORDING_BETA.apk`, sources `MOA_R75_SOURCE_TESTS_NO_KEYS.zip`. [MOA_R75_DAY_THUMBNAILS_LOCKSCREEN_CAPTURE_READ_FIRST_20261104.md](MOA_R75_DAY_THUMBNAILS_LOCKSCREEN_CAPTURE_READ_FIRST_20261104.md) 전문 FIRST READ. **R63 사용자 실기기 GOLDEN 불변**.

## 2026-11-04 LATEST — R73 REAL DEVICE quick selected-photo sync PASS / temporary blank thumbnails FAIL → R74 FIX BETA
User's actual Galaxy screenshots show newly captured 12:15 / 12:43 / 12:44 photos and notes appear near-immediately in photo diary, but thumbnails temporarily disappear on each new photo and only later reappear; tapping blank card still opens the original image. User also requests manual × close on lower thumb-zone camera recording popup without disabling recording or breaking existing behavior. **R73 data first-display/device PASS, preview stability UX FAIL.**
R74 same package/signer APK sha256 **4d8ed5a46d0c933db7d805322c8ee591c5f8e9b6fef31e9b893e886cb35239f2**, bytes **3437120**, versionCode74; changed 3/55 APK members ONLY (manifest version, classes4.dex popup ×, family-diary.js preview preservation), 52 unchanged including R63 Golden same-origin IDB writer, photo timestamp, R70 OHO, R71 sticky edit/delete, NAVER, base DEX. Java CI run 41769797290 success, APK v2/certificate/DEX/ZIP/JS PASS, gallery deletion/recovery and R63 IDB regression PASS, new tests cover previous thumbnail display preserved across DOM rebuild and delayed native image hotpainting into current DOM. **R74 Galaxy actual PASS NOT YET VERIFIED.**
Preview implementation: memory-only bounded snapshot of previously loaded data:image thumbnails before each render, immediate reuse on new DOM, skip day full rerender when native index unchanged, paint current DOM if old async node was detached, discard missing originals from RAM after complete MediaStore index. Original diary memo text is never deleted, MediaStore full scan is still retained for deletion safety. Popup × cancels just this current floating pill/quiet alert; monitor ON/OFF, next photo notification, action button, drag and 8500ms timeout unchanged.
Private Library `/모아_프로젝트_근거_20261103/MOA_R74_STABLE_THUMBNAIL_DISMISS_PILL_BETA.apk` and `MOA_R74_NO_KEYS_SOURCE_AND_VERIFICATION.zip`. FIRST READ [MOA_R74_STABLE_PREVIEWS_CAMERA_POPUP_CLOSE_READ_FIRST_20261104.md](MOA_R74_STABLE_PREVIEWS_CAMERA_POPUP_CLOSE_READ_FIRST_20261104.md). R63 remains physical GOLDEN.

## 2026-11-04 R72 사용자 실기기 반영 확인 + 새 사진 일기 동기화 지연 개선 설계 (최신)
사용자 “R72 반영확인”; 달력 첫 화면 개선 후에도 **새 촬영 사진·메모가 달력에 실제 반영되는 시간은 여전히 체감상 느림**(정량 로그 없음). 실제 AndroidHost `diaryPhotoIndex`는 사진/영상을 **MediaStore 전체 매번 스캔**하고 160개씩 WebView에 전달하며 최종 chunk 후 화면 목록을 반영; R72 JS는 `init()`에서 `curated` 읽고 `refreshCuratedFromDatabase()`에서 한 번 더 읽고 `mmR60RefreshMedia`로 전체 미디어 색인을 재요청한다. 과거 사진 13,126장/영상 983개 기준 전체 스캔은 불필요한 큰 작업. R63 writer는 새 미디어 ID·원래 시각·메모를 이미 `curated`에 보존함. **획기적 속도개선 가능**: (A) 기존 curated 순간 메모의 ID·시각으로 즉시 달력 카드 표시→느린 전체 스캔 기다리지 않기(전용 JS 패치·보호 테스트), (B) Android `MediaStore.getGeneration/getVersion`, `GENERATION_ADDED/MODIFIED` 기반 **변경분만 색인**하며 불일치/초기/삭제 감사 때 전체 재조회. 정확한 기기 지연 ms나 APK 완성 주장 금지. **현재 새 APK 없음, 설계 및 정확한 코드 조사 완료**, R72 사용자 반영 기준과 R63 Golden 동결. 상세 `MOA_R72_SYNC_PERFORMANCE_DELTA_INDEX_DESIGN_20261104.md`.

## 2026-11-04 UPDATE: R72 fast capture prompt + nonblocking diary calendar (STATIC BETA)
User reports working R71 journal and photo diary calendar (Nov 4, 4 photos), but the thumb capture prompt feels ~3s late and calendar month grid disappears temporarily during sync. Source-proven causes: R71 Camera ContentObserver resets 1100ms debounce on each change; diary open awaited init and curated IDB read before first render. R72 replaces repeated reset with a coalesced 300ms scheduled scan (preserving pending/size/6s fallback) and displays month grid before awaiting IndexedDB, then refreshes. APK SHA256 974667456d09ebf43053de9039a4431df751defbae08b4b89da1604bc6b9dd76, 3430803 bytes, code72, same signer/package. Three of 55 entries changed; other 52 byte-identical including proven R63 direct writer and R71 sticky delete. Android CI D8, APK v2, ZIP CRC, Node first-render-order test PASS; Galaxy R72 latency and calendar test NOT YET verified. Library saves R72 signed APK and no-key source. Full details: MOA_R72_FAST_CAMERA_PROMPT_CALENDAR_FIRST_PAINT_READ_FIRST_20261104.md. Keep R63 user Golden fixed; do not clear data.

# MOA — MASTER CURRENT / GOLDEN / UPDATE HANDOFF (2026-11-04)

> **이 파일은 새로운 모아 작업 대화의 최신 1차 인수인계 기준이다.** 기존 연대기 체크포인트 안의 과거 실패/미검증 문구보다 이 파일의 **최신 실기기 증거와 버전 구분**이 우선한다. 단, 과거 기록을 삭제하지 말고 이력을 보존한다. **R63 USER PHYSICAL GOLDEN과 현재 배포된 R71 BETA를 절대 혼동하지 않는다.**

## 0. 새 채팅 시작 절차 (MUST)
1. GitHub `yooogillycloud123/workexcel-devbridge/main/AA_AirPods_FINAL_READ_FIRST_v1.0_20261005.md` 전문을 첫 번째로 읽는다(에어팟 골든 변경 금지).
2. `yooogillycloud123/family-journey-personal/main/MOA_ABSOLUTE_READ_FIRST_20261103.md`, **본 파일 전문**, `MOA_WIP_CHECKPOINT_CURRENT.md`, `MOA_R63_USER_DEVICE_GOLDEN_LOCK_20261103.md`를 읽고 최신 Library APK/소스 해시를 확인한다.
3. 기준 원본 **R63 사용자 실기기 GOLDEN**은 수정하지 않는다. 새 개선은 별도 브랜치/상위 버전, 동일 패키지/서명으로 한다. 제자리 업데이트, 절대 앱 삭제/데이터 초기화 금지.
4. 정적 ZIP/DEX/JS/서명 PASS와 Samsung 실기기 PASS를 별도로 표시한다. 다운로드 링크는 파일이 실제 존재하고 해시 검증된 뒤에만 제공한다.

## 1. 제품 목표와 변하지 않는 핵심
- 단일 모아 APK `com.juhyeon.familyjournea`; Galaxy S26 Ultra, 삼성 기본 카메라 사진/동영상 촬영 감지.
- 사용자가 원할 때만 카메라 아래쪽 엄지 근처 `바로 기록` → **딱 한 번의 네이티브 음성/문자 입력** → 원본 미디어 ID 및 실제 촬영 시각·날짜와 함께 기존 **‘내가 고른 사진 일기’**로 자동 저장. 모아 실행 시 중복 메모 팝업을 요구하지 않는다.
- R63 성공의 정확한 구현: `MoaMomentMemoActivity`의 native commit → `MoaMomentDirectDiaryStore`의 별도 동일 출처 WebView (`https://familyjourney.local/`) → **기존 IndexedDB `familyjourney-diary-v1`/`curated`**에서 저장 트랜잭션·재읽기·ACK → `assets/web/family-diary.js`가 `curated`를 재조회하여 표시. **저장 알고리즘, 사진 ID, 개별 촬영 시각, 메모 원문은 절대 훼손 금지.**
- 기존 지도/기록/일기/편집/선택 미디어 제외, 원본 갤러리 유지, 네이버지도 즐겨찾기, STT, 카메라 감지, 기존 서명 보존.

## 2. 실제 증거 기준 버전 이력 (성과 / 한계 구분)
| Version | 변경·검증된 사실 | 상태 |
|---|---|---|
| R42 | 이전 WebView 추가 팝업에서 직접 `dbPut('curated',day,...)` 하여 기록 가능, 하지만 사용자에게 중복 입력을 요구함 | 과거 비교용 |
| R58–R62 | 팝업 제거 후 native→WebView 전달 실패; R61/R62 사용자 기기에서 사진·메모가 일기에 반영되지 않았음 | **실기 FAIL**, 골든 아님 |
| **R63** | 독립 동일 출처 WebView→기존 curated IDB 직접 기록/재읽기 + 화면 재조회. 사용자가 **22:23~22:24 사진 3장 항목+시간별 메모 3개**가 실제 일기에 나타난 스크린샷으로 성공 확인 | **유일한 데이터 경로 실기기 GOLDEN** |
| R64 | 카메라 촬영 후 `모아 · 바로 기록` 작은 오버레이를 하단 엄지 위치로 옮김; 사용자 화면에서 위치 만족 확인. 상단 이중 알림 간소화 작업. 원핸드 바로가기는 아직 목록 문제 | 촬영 버튼 배치 **실기 PASS**, 단축키 문제 남음 |
| R66 | 고정 5분 시각 구간(기존 연속 1시간 묶음 오류 개선) 및 native 메모 음성·저장 버튼 하단 배치 소스 구현. 사용자 스크린샷에서 **22:20~22:24** 고정 그룹 표시 확인. 동적/핀 shortcut은 OHO 목록에 없음 | 5분 그룹 **실기 화면 확인**, OHO 목록 FAIL |
| R68 | 하단 고정 일기 편집 도구막대 `제목·본문 | 시간대 메모 | 일기 저장`, 기존 항목 유지. 사용자가 **실기 화면에서 ‘작동확인됨’** 명시. `CREATE_SHORTCUT`만으로는 OHO 목록 누락 계속 | 편집 바 **실기 PASS**, OHO FAIL |
| R69 | 사용자 AA AirPods처럼 `android.app.shortcuts`+정적 XML을 추가하여 OHO+에서 **‘모아 기록 전환’ 목록 표시 자체는 실기 PASS**. 하지만 제스처가 `HostActivity`를 열고 QS 기록은 OFF, 실제 ON/OFF FAIL | 목록 PASS, **토글 FAIL** |
| R70 | 전용 `MoaMomentToggleActivity`로 정적/동적 바로가기 실행 대상 변경; 기존 `switchTo`+`updateTile`을 호출한 후 종료. R70 APK 컴파일/서명/AXML 확인 | **실제 제스처 ON→OFF→ON 아직 명시적 실기 PASS 근거 없음**. 코드만 확인 |
| **R71** | R70 기준 하단 고정 편집 바에 **네 번째 `일기 삭제` 직접 실행** 추가. 기존 `remove()` 확인창 그대로 사용, 취소면 삭제 없음, 확인하면 해당 날짜 일기만 삭제. 기존 3버튼 유지. | **최신 전달 APK / 정적·모의시험 PASS**, 사용자 실기기 R71 확인 전 |

> 특히 과거 assistant가 잘못 이해했던 `삭제로 이동`은 **최종 요구가 아니다.** 사용자는 **`일기 저장`처럼 하단의 `일기 삭제`를 직접 눌러 기존 삭제 확인창을 띄우는 기능**을 명확히 요청했다. 승인 없이 삭제하거나 원본 갤러리 파일을 삭제하지 않는다.
>
> 2026-11-04 사용자가 보낸 “작동확인됨”은 **하단 편집 도구막대 3개 기능에 대한 확인**이며, R70 OHO ON/OFF 또는 R71 삭제 버튼 모두 실기기 통과했다는 증거로 확대하면 안 된다.

## 3. 아티팩트·해시·소스와 영구 보관 위치
- **R63 Golden**: Library `/모아_프로젝트_근거_20261103/MOA_R63_GOLDEN_USER_DEVICE_PASS_20261103.apk`; SHA-256 `64b1b730478a2a50976961cc2dc4cf511182a75495f2d02159f091167f646024`; 3,422,752 bytes; versionCode 63. Frozen source branch `golden/moa-r63-20261103-user-device-pass-do-not-modify`.
- **R70**: Library `/모아_프로젝트_근거_20261103/MOA_R70_DIRECT_OHO_TOGGLE_STATIC_BETA.apk`; SHA-256 `483994e3decd8e01828bcad5beed5290cc5699594b074298748ce58c758aa8a5`; 3,430,065 bytes; versionCode 70; `fix/moa-r70-direct-toggle-activity-20261104`.
- **R71 최신 배포 APK**: Library `/모아_프로젝트_근거_20261103/MOA_R71_DIRECT_DIARY_DELETE_WITH_CONFIRM.apk`, 대화 파일 `MOA_R71_Install.apk`; SHA-256 **`64725bdfaff9b4507dfab0b7e889d3ddac284066a933e74a1d42f760bb1ecb1a`**; **3,430,689 bytes**; versionCode **71**, versionName R71, same package/signer. No-keys source archive `/모아_프로젝트_근거_20261103/MOA_R71_DIRECT_DELETE_Source_Verification_NoKeys.zip`; source branch **`fix/moa-r71-sticky-direct-delete-confirm-20261104`**, exact delta script `tools/moa_r71_sticky_direct_delete_confirm.py`. User downloads `MOA_R71_Install.apk`, `MOA_R71_Direct_Delete_Install_Backup.zip`, `MOA_R71_Direct_Delete_Source_NoKeys.zip`.
- Signing certificate SHA-256 (PUBLIC fingerprint only): `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`. Private signing keys, passphrases, family photos, private note content MUST NEVER be published.
- R71 vs R70 **only 2 of 55 existing APK members changed**: `AndroidManifest.xml` (version) and `assets/web/family-diary.js` (4th sticky control); **53 byte-identical**, including `classes4.dex` direct toggler, R63 core `assets/web/moa-direct-diary-commit.html`, original `classes2.dex`, NAVER assets/shortcuts.
- R71 local validation PASS: `node --check`, focused original `remove()` confirm cancel vs accept test, original R63 IDB regression suite, APK v2 signature + cert match, DEX untouched, ZIP CRC and exact entry diff. **Do not turn these static PASS marks into Samsung device PASS.**

## 4. 현재 사용자 최종 UI 요구
하단 편집 바 버튼 순서:
**`제목·본문` | `시간대 메모` | `일기 저장` | `일기 삭제`**.
- 제목·본문: 기존 필드로 스크롤 점프.
- 시간대 메모: 사진별 시간 메모 입력 섹션으로 점프.
- 일기 저장: 기존 `save()` 호출.
- **일기 삭제: 기존 `remove()`를 즉시 호출 → 확인창 → 승인한 경우에만 현재 날짜의 일기 삭제**. 다른 날짜·원본 갤러리 미디어는 보호.
- 하단 스크롤 고정이며 기존 편집 콘텐츠(제목/본문/태그/기분/시간대 메모/사진별 제어/취소/기존 하단 삭제)를 제거하지 않는다.
- 삼성 S26 Ultra에서 4버튼 배치/확인 취소 동작은 R71 기기 테스트로 별도 확인한다. 실수 삭제 방지를 위해 테스트는 “취소”부터 시행하고, 사용자의 소중한 일기에서 실제 삭제 테스트를 요구하지 않는다.

## 5. 보류·예정 기능 (현 상태를 성공이라고 주장 금지)
1. **원핸드 오퍼레이션+ 실제 기록 ON/OFF**: R69은 바로가기 목록 표시 PASS / 토글 FAIL. R70 전용 토글 Activity + 퀵패널 상태 동기화 코드는 정적 PASS; 갤럭시 실제 ON→OFF→ON이 확인되기 전까지 완성으로 고정하지 않는다. R71에 동일 R70 DEX가 바이트 보존됨.
2. **사진 영어 공부**: 사진·원본 촬영 시각·연관 한국어 일기 및 시간대별 메모 전체를 기반으로 일화/표현/문장별 한영 학습, 음성 듣기·말하기, 어휘·퀴즈·복습. 기존 `curated`는 수정하지 않고 별도 `photoEnglishV1` 파생 학습 스토어/캐시로 확장. 사용자 동의 없이 가족 사진을 외부 서버로 보내지 않음. **기획·지침만 기록, APK 미구현**. 세부 `MOA_R68_SHORTCUT_EDITOR_AND_ENGLISH_20261103.md`.
3. **네이버지도 즐겨찾기 조작 완전 백그라운드화**: 현재 검증된 방식은 네이버 앱 전면 UI를 AccessibilityService로 조작하는 것. 완전 화면 비표시로 동일하게 저장하는 공식 계정 연동 경로는 확인되지 않아 **미구현**. 기존 정상 흐름 훼손 금지.
4. 촬영 후 단일 엄지 버튼/네이티브 하단 STT+SAVE/5분 고정 그룹/카드 썸네일과 편집 기능 회귀 점검. **임의 이미지·메모 재촬영, 원본 데이터 삭제를 다음 작업의 선행 조건으로 강요하지 않는다.**

## 6. 다음 작업 순서 / 근거 없는 버전 증식 금지
- 먼저 현재 사용자 폰에 **어느 APK가 실제 설치됐는지 구분**(최신 전달본=R71이지만 설치 완료를 단정하지 않음).
- R71 편집 바 실제 4버튼과 삭제 **확인창·취소** UX를 확인하는 경우에도 원본 사진·일기 데이터 변경 없음. 문제 발생 시 Java·JS의 정확한 중단 부분만 수정한다.
- 원핸드 실제 ON/OFF는 별도 실기기 검증 후 PASS/FAIL 업데이트한다. 정적 테스트만으로 골든 승격 불가.
- 새 개선은 R63 원본 골든과 최신 업데이트 앱의 기능을 모두 보존하는 최소 diff 방식; 앱 추가 설치, 삭제/초기화, 중복 입력, 원본 시간대 변경 금지.
- 모든 배포 시 APK SHA, bytes, package/version, 서명 fingerprint, 기존 파일 byte-diff, 실제 on-device PASS/FAIL, Library 영구 파일과 최신 GitHub 문서를 갱신한다.

## 7. 필수 연관 최신 자료
- `MOA_R63_USER_DEVICE_GOLDEN_LOCK_20261103.md` (실기기 데이터 저장 GOLDEN)
- `MOA_R70_OHO_DIRECT_TOGGLE_AFTER_R69_DEVICE_FAILURE_20261104.md` (원핸드 목록→실제 기능 변경 경위)
- `MOA_R71_STICKY_DIRECT_DIARY_DELETE_WITH_CONFIRM_20261104.md` (직접 삭제 4번째 버튼)
- `MOA_R68_SHORTCUT_EDITOR_AND_ENGLISH_20261103.md` (사진 기반 영어공부 확장)
- `MOA_WIP_CHECKPOINT_CURRENT.md` (전 개발 이력)
