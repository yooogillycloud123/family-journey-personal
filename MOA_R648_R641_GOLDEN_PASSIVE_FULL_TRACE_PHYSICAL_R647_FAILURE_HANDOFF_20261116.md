> **2026-11-16 USER PHYSICAL UPDATE (OVERRIDES ORIGINAL PRE-DEVICE-BETA STATUS BELOW):** Galaxy S26 Ultra 사용자가 **Samsung One Hand Operation+ OFF→ON 이후** R648 잠금화면·화면 켜짐·모아 전면 바로기록과 원본 Gallery 정상 작동을 확인. 함께 제공한 `테스트.txt` R648 태그 581행에서 native START_INLINE/PREDRAW_ARMED/OPEN_ACCEPTED/HOST_MOUNTED/8_ACTION_DECK_READY 각14, MOUNT_ACK20, QuickRecord native commit4가 관측됨. 리소스 로드 오류는 이미지6, 동영상2이며 사진 추가 오류와 인과 미확정. **이제 R648은 사용자가 확인한 조건 내에서 SCOPED GOLDEN 보호 기준**, 사진 추가/원핸드 조작 없이 최초 실행/기타 전체 UX까지 FINAL 아님. 아래 'REAL GALAXY STATUS = UNVERIFIED BETA'는 이 사용자 보고 전의 역사적 출시 상태임. 최신 필수 진실과 사진 추가 명세: [MOA_R648_USER_PHYSICAL_SCOPED_GOLDEN_PHOTO_ADD_LOCK_20261116.md](MOA_R648_USER_PHYSICAL_SCOPED_GOLDEN_PHOTO_ADD_LOCK_20261116.md). R648 기능 byte hash 보존, 새 사진추가 독립 owner, 무설치삭제/데이터보존, 상위 코드 복구 APK 필수.

# MOA R648 — R647 physical fail, R641 user-approved Golden clone + separate passive diagnostics (2026-11-16)

**REAL GALAXY STATUS = UNVERIFIED BETA.** The source Golden R641 was physically approved on Galaxy; R648 has only static + isolated browser tests. DO NOT promote R648 to GOLDEN without new user-device confirmation.

## Forensic evidence from user-provided R647 full trace (1981 historical+latest rows)
- The export preserves sessions from R645, R646, and R647 in the same IndexedDB journal. The report header build=R647 does NOT mean all historical 1981 events came from R647.
- In newest R647 boot `mwjbh89s-alqtgk`, 2026-11-16T13:46:24.009Z: `START_INLINE` count13. StageAttached true by 13:46:24.373Z; arm/pending/opened/mounted false. At 13:46:33.721Z another `START_INLINE` count13, stageAttached true by 13:46:33.808Z; ARM/PREDRAW/OPEN_ACCEPTED/MOUNT_ACK absent again. User reports Gallery failure.
- Earlier successfully opened sessions show `NATIVE_PREDRAW_ARMED`, `NATIVE_OPEN_ACCEPTED`, `NATIVE_MOUNT_ACK`, `NATIVE_8_ACTION_DECK_READY` (e.g. 12:56:30.580–.666Z).
- **Observation gap is established. Root cause at Android Java/OS/owner lifecycle is NOT established.** Do not speculate that missing ARM proves a specific Java failure.
- R625 derived R647 failed too, R646 re-arm timer experiment failed. Revert to unmodified physically approved R641 functionality, not new retry/rearm guesses.

## Exact signed build
- Golden source original R641 signed APK SHA256 `bf1633ad830057b61ef1d256d57a9215b393800c739c75a113dbb10f06167e89`. GOLDEN file and branch kept immutable.
- R648 APK `MOA_R648_R641_USER_GOLDEN_EXACT_NATIVE_PASSIVE_FULL_TRACE_ORIGINAL_SIGNED_BETA.apk` SHA256 `6b5984e1b3892c0ed10606008d2627c0393ba02661e22a13565571f1a47be3c1`, size 9,097,017 bytes, package `com.juhyeon.familyjournea`, versionCode648, original signing certificate SHA256 `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`.
- Release ZIP `MOA_R648_R641_GOLDEN_PASSIVE_TRACE_SIGNED_APK_SOURCE_QA_20261116.zip` SHA256 `39067339f58bcc3098e3ebba94e39083ff1e71f098a99fad38e3f068dbdf8bc6`, contains byte-identical R648 APK, non-secret logger JS, index diff patch, tests, README and hashes, NO signer/keystore/password/user data.
- EXACT original 147 APK entries: 145 unchanged byte-for-byte; changed ONLY `AndroidManifest.xml` version641→648, `assets/web/index.html` one script AFTER `moa-r641-safeguard-bootstrap.js`; ADDED `assets/web/moa-r648-passive-full-runtrace.js`. **18/18 DEX byte exact**, all original Web JS/CSS including `moa-r483-vertical-calendar.js`, `moa-r641-safeguard-bootstrap.js`, `family-diary.js`, `moa-r149-voice.js`, `host-bootstrap.js`, picker and Naver untouched.
- New logger is intentionally loaded AFTER the existing Golden photo, navigation and bootstrap scripts; no direct hook of `r602Mark`, `__moaR602JavaReport`, no mutation of any Gallery/QuickRecord/native Java owner/open/close/repair path. It only reads `__moaR602GalleryDiagnostic` snapshots, non-sensitive DOM events and Java callbacks ALREADY forwarded by original Golden.
- Settings `전체 실행 경로 진단 · R648 (R641 골든 복제)` offers `전체 기록 보기` + `전체 진단 복사`. Existing `moa_full_runtrace_r645` IndexedDB and local tail backup names maintained, old sessions preserved and new R648 rows tagged `build`. New missing-stage marker `NATIVE_ARM_NOT_OBSERVED_AFTER_START` means no ARM was observed after 1.2s, NOT a proved cause.
- APK v2 RSA/content digest PASS, CRC PASS, stored asset alignment PASS, JS syntax PASS. Isolated Chromium mocked Gallery stage/QuickRecord/missing ARM/settings view/copy/private-note exclusion, 0 native-open calls and no page error PASS. **Real Android physical Galaxy, origin IndexedDB cross-restart persistence, actual original-gallery hardware = NOT VERIFIED; native pre-WebView first calls still uninstrumented.**

## Deployment, protected invariants, next step
- **Do NOT uninstall app, clear diary/media/Chrome/Naver state, rotate signer, or touch AA AirPods daemon/audio.** R648 versionCode > installed R647 and uses SAME signer for in-place update.
- User should verify R641-known-Golden paths: initial original 8-action Gallery; photo↔detail; One Hand Operation+ NAVER Accessibility OFF→ON; QuickRecord save then same day Gallery return repeatedly; then Settings full log copy.
- R625 photo-picker selection/hires/video UX improvements are NOT included; preserves R641's exact built-in lazy standalone picker. Do NOT silently conflate R625 enhancements with Golden.
- If R648 fails again, analyze ONLY newest rows tagged R648 alongside prior history; isolate Android-native pre-WebView or owner lifecycle via narrowly scoped instrumented build, not another blind Web UI/rearm patch.
- Private personal Library: `/모아_프로젝트_근거_20261103/R648_R641_GOLDEN_PASSIVE_DIAGNOSTICS_20261116/`.
- Mandatory all-version full-trace policy remains `MOA_PERMANENT_FULL_RUNTRACE_RELEASE_POLICY_20261116.md` and R611/R641 Golden documents frozen.
