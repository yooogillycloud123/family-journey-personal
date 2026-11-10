
> **2026-11-10 R257 CORRECTED POST-SIGN DEX REASSEMBLY:** The first local R257 packaging returned success despite a smali syntax error (`move-result/from16`) and carried a stale accessibility guard. The user was not asked to install it. We corrected the opcode, removed R249's actual `MoaNaverAccessibilityCover.begin()` from the live `handle('naverSave')` path (to prevent unstable MOA WebView reparent), recompiled APKtool with **zero error lines**, signed again, and independently **decompiled the exact signed APK** verifying the new `WAITING_NAVER_WINDOW` and `ALREADY_SAVED_NEEDS_REVIEW` guards actually exist in NaverSaveService DEX, the NaverSaveRouter invocation exists, and the live begin() call is absent. Final valid signed APK SHA256 is `ee78d7cd00c2cb27266204c18aadee0dd60253371e2cfd21c652091b8733ec2c`; old SHA in any previously generated local artifact must be considered superseded. Only Library `/모아_프로젝트_근거_20261103/R257_CORRECTED_POSTSIGN_DEX_VERIFY_20261110/` is authoritative for R257. No Galaxy test so actual saved-place functionality remains UNVERIFIED.
# MOA R257 (2026-11-10) — R255 user-confirmed Galaxy launch + targeted Naver favorites route fix

## Highest-priority real-device evidence
**User confirmed R255 launches normally on their Galaxy** after R251 fatal crash. This is a real user-reported PASS for *launch*, not for favorites. Freeze the exact R255 functional code as boot-stable reference:
- R255 `MOA_R255_EMERGENCY_APP_LAUNCH_RECOVERY.apk`, `com.juhyeon.familyjournea`, original signer `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`.
- SHA256 `3b34cfef5f1344d683a181f556d3e9f76fa7474b4cbdb2b1f5a2b00fd3cf7342`, versionCode 255. Existing R227 immutable golden SHA `53c4c04ce32ad13de3c0613f4e5ec7abbc75ccbdfe9db5da05d8fa9b806ec6cd` also frozen.
- R255 favorites **FAIL** remains; user explicitly asks fix while preserving all normally working MOA.

## Actual R255 binary source root-cause findings, NOT user-verified final root cause
Disassembled R255 APK. `HostActivity.lambda$handle$35(String, SharedPreferences)` starts `nmap://search?query=<address>` with extra R249-only `getBoolean("armed", false)` launch guard. Upstream in `handle("naverSave")` service job is armed and posted to UI thread, but the guard can suppress launch if preference changes. Main `NaverSaveService.processStep()` stage0 waits for a *detailed address* in NAVER app accessibility tree and refuses to advance unless expected road/location components appear; merely opening a search results page need not satisfy this gate, producing `WAITING_ADDRESS_RESULT` and TIMEOUT. Native UI status was previously polled only when Settings GPS panel was visible, not when saving from Diary's normal photo card, leaving user with no progress or result popups.

These findings are confirmed **code facts**, but precise runtime stopping stage cannot be proven absent a private Galaxy accessibility state log. The user already supplied R249 private video showing Naver briefly and 3-minute timeout; that is not an R257 end-to-end PASS.

## Signed deliverable R257
`MOA_R257_STABLE_BOOT_NAVER_FAVORITES_RECOVERY.apk`
- versionCode 257 / original same package and certificate, 8,932,642B
- SHA256 `ee78d7cd00c2cb27266204c18aadee0dd60253371e2cfd21c652091b8733ec2c`
- APK signature v2, all 16 DEX SHA1/Adler32, ZIP CRC, resources STORED, zipalign, same original signer certificate PASS
- Diff from exact R255: only `AndroidManifest.xml` versionCode, `classes2.dex`, `assets/web/fj-naver-favorites.js`, `assets/web/moa-r231-settings.js`; new `classes16.dex` contains isolated `MoaNaverSaveRouter`. **133 other shared non-signature payloads byte-for-byte unchanged**, including gallery/diary/QuickRecord/audio/voice.
- Extra R251 crash guard: no `v8`-String referenced as `JSONObject`, old R251 code completely absent; the minor new `HostActivity` hook uses explicit String+JSONObject type-correct registers. Source standalone Java compiled with SDK35 and D8 API29; JS `node --check`, original-photo-GPS routing/status event Node tests, Java route fallback test and guard assertions PASS.
- Updated ZIP `MOA_R257_APK_BACKUP_AND_INSTALL_GUIDE.zip` SHA256 `483fa5c9a068b72338d7fa105024fa7150bdcb0a3a6d8ef332f03a4f775c7f14`, contains exact signed APK+Korean guide+QA+SHA256; CRC PASS.
- Source-only SHA `40d8b24b551394df79fd5ba48c807ee418138244292c1ace8b63b1b9ef7dde65` from local patch ZIP (no private key).
- All artifacts in private Library `/모아_프로젝트_근거_20261103/R257_CORRECTED_POSTSIGN_DEX_VERIFY_20261110/`. Do not publish raw family photos, locations, or keystore.

## Specific changes
1. Remove only obsolete R249 `armed` launch guard, not the service's job state machine/permission checks.
2. `sendPreparedLocation()` forwards the **existing original photo lat/lon** along with automatically resolved address, list, alias, memo (no six-field manual tester). Type-safe `MoaNaverSaveRouter.chooseLink()` navigates `nmap://place?lat=...&lng=...&name=<encoded address>&appname=com.juhyeon.familyjournea` only for valid KR lat/lon + nonempty precise address; otherwise keeps original Naver search. This is the first-party native Naver place pin already used in R227 manual success evidence, but not guaranteed to expose identical UI in current app.
3. `NaverSaveService` explicitly emits `WAITING_NAVER_WINDOW` when the native window tree is not yet readable; never clicks a control suggesting `저장됨` / `저장 해제` to avoid UNSAVING existing location. Such cases are marked `ALREADY_SAVED_NEEDS_REVIEW`.
4. Existing Diary save card now receives native status polling; maps host `id` to original photo key, reflecting stages, failures, UI confirmation and timeout. One small result popup defaults ON and may be disabled under Settings → NAVER return popup → `네이버 즐겨찾기 결과 팝업`. It does NOT represent user-account server readback. No fullscreen overlay or WebView reparent. No root/Shizuku/PC/helper APK.
5. All other original app features frozen; user sees native NAVER foreground briefly because Accessibility currently automates that first-party app, so **the strict zero-screen-occupation goal is not yet attained**.

## Critical limitations, acceptance gates
- R257 has NOT been installed or opened on actual S26 Ultra; no verified Android runtime boot or NAVER save/list/create/memo end-to-end success. Do not call FINAL/GOLDEN and never conflate static APK checksum PASS with functional success.
- Auto-create missing lists and independent account readback remain **not implemented**. The user can use an already-existing `내 장소` list, but if list missing the service may say `NEEDS_LIST_SELECTION`. A manual photo-place name cannot be inferred from GPS alone.
- The user wants working app + one-touch favorites + automatic photo metadata + status result popup; this current release is a more controlled candidate, not proof of all goals.
- One short physical acceptance from user: update install over R255 (do NOT uninstall or data-clear), open Diary+photo to check launch, tap existing '주소로 저장 + 메모' once, record UI status. If it fails, inspect the single state code and fix specific transition, no blind new APKs. R257 cannot be called confirmed until this real test passes.

## Prepared data-preserving emergency fallback
`MOA_R259_IF_R257_FAIL_RESTORE_R255_BOOT.apk` SHA256 `17d3e2e0ebff5fda92e231214be9f201b207098471c7f7e67fd2d7c0613b439a`, versionCode 259. **Exactly R255 functional APK payloads and signer, only AndroidManifest versionCode 255→259** so Android update-install from R257 works without clearing user data. Do not install unless R257 crashes. This is a rollback mechanism, NOT an additional app or functional feature.

## Reminder on user intent
Do not ask user to type six testing fields, install multiple assistants, change project focus, clear app data, use a PC/cloud worker, use a black cover to masquerade as background execution, or assume Naver account has been saved without actual list+alias+memo readback.
