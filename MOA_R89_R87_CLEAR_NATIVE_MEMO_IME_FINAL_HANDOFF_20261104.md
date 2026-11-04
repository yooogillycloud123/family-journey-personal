> **CURRENT STATUS UPDATE 2026-11-04 — R89 USER PHYSICAL GOLDEN:** New screenshots 18777.png, 18779.png, 18781.png, 18783.png and explicit user success confirmation promote R89 (code89 SHA256 `2b52826fc0dd8653a70d3c503d3654ae33071bfc4ec075753ec4464a1e2dc493`) to user-confirmed physical GOLDEN for native capture memo keyboard-aware Mic/Clear/Save, STT + typing, clear confirmation and native temporary-save toast. The older 'physical untested' wording below is a historical status, superseded for these specific observations. Camera temp-save toast is not standalone proof of final R89-specific IndexedDB synchronization. Read `MOA_R89_USER_DEVICE_GOLDEN_LOCK_20261104.md` first. Signed original frozen in private Library and `golden/moa-r89-20261104-user-device-pass-do-not-modify`; enhancements code>=91, new branch, same signer, no data wipe; R90 is older R87 recovery, not Gold.

# MOA R89 — COMPLETE R87 DIARY CLEAR + NATIVE PHOTO MEMO CLEAR / IME-AWARE FOOTER (2026-11-04)

## Current status and proof
- The user explicitly confirmed previous R87 completed part works ("완료는 확인됨"). R87 diary-editor separate title/body/5-minute field whole-clear confirmation behavior is USER PASS. Preserve R87's exact bundled family-diary.js.
- User requested finishing ONLY the remaining native photo memo `MoaMomentMemoActivity`: (a) separate "내용 전체 지우기" on its input with safe confirmation, (b) mic / clear / memo-save buttons visible directly ABOVE Samsung keyboard while open. R83 native diary voice is USER GOLDEN (branch golden/moa-r83-20261104-user-voice-pass-do-not-modify), not modified. R85 title expansion preserved, speech accuracy intentionally deferred.
- R89 is fully COMPILED and SIGNED; **Galaxy R89 physical keyboard/clear test still UNTESTED**. No physical success claimed.

## Exact installable R89 integrated artifact
- `MOA_R89_NATIVE_MEMO_CLEAR_IME_FINAL_Install.apk`, **3,491,886 bytes**, SHA256 `2b52826fc0dd8653a70d3c503d3654ae33071bfc4ec075753ec4464a1e2dc493`.
- Package `com.juhyeon.familyjournea`; versionCode **89**, versionName `MOA-R89-Safe-Capture`; original signer SHA256 `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`. Signed privately, no private signing data in GitHub.
- Based on exact user R87 signed APK SHA256 `cfcd60b9eda832e306e2943de6de40a82a5b31d690c47c5b925d423c8685cf16`.
- Exactly **two of 55 decompressed archive members changed**: `AndroidManifest.xml` version 87→89 and `classes4.dex` (Java native memo Activity UI). All **53 remaining members unchanged**, notably original `classes.dex` / `classes2.dex` / `classes3.dex`, R87 working `assets/web/family-diary.js`, R63 actual IndexedDB commit engine `assets/web/moa-direct-diary-commit.html`, launcher and AndroidManifest activities/permissions unchanged.
- Android/DEX source patch `tools/moa_r87_patch_memo_clear_ime.py`, on feature branch `release/moa-r89-native-memo-keyboard-clear` (based off enhance/moa-r87-safe-clear-fields); original `MoaMomentMemoActivity.java` source built using existing R80→R83 Java patch sequence; extra patch affects **only native memo Activity**.
- Java/D8 actual compile GitHub Actions run `41819061843` **SUCCESS**; `classes4.dex` SHA256 `f1513f5be8741a401943d2654665460b78dbfa6a8acdc463039e54c59b0ae608`, bytes **100,180**. This DEX is the one inside the signed APK.
- Build was staged temporarily through existing R83 CI workflow on original non-Golden implementation branch, because GitHub Actions workflow file creation in R87 feature branch was blocked; original R83 patch was **RESTORED** immediately after DEX compilation, commit `1f4582c38339d9e0e1c4ba1b96ee0843873aa181`. Frozen R83 Golden branch was never touched.

## What R89 implements
1. Native photo memo adds **"내용 전체 지우기"** adjacent to its already functioning native microphone. When empty it does nothing; otherwise displays Android AlertDialog with **취소** and **모두 지우기**. Only the current visible EditText is cleared after confirmation. Cancels in-flight recognizer before clearing so delayed interim results cannot repopulate. No database/photo/delete action happens; existing Save commits by exact R63 store only when tapped; empty Save is rejected by existing guard.
2. Footer now contains microphone + clear side-by-side, and original "모아 일기에 메모 저장" directly below. It remains outside ScrollView and above app window's bottom.
3. Existing `SOFT_INPUT_ADJUST_RESIZE` retained. On Android API>=30, a `WindowInsets.Type.ime` listener calculates actual overlap (window bottom - IME height vs root location/height) and applies only the required bottom root padding; when keyboard closes, padding returns to 0. Avoids double padding when resize already moves footer; keeps draft text and cursor unchanged.
4. R87 in-app diary title/body/timeline field-clear buttons untouched; original STT listener, R83 launcher, save, photo/media IDs, R63 writer, OHO, nav remain untouched.

## Validation
- Github Java compile / D8 PASS.
- Native golden source freeze SHA check PASS for `MoaMomentVoice`, Bridge, Chrome, VoiceHostActivity, Application, capture service, DirectDiaryStore, InboxSync.
- DEX class signatures non-MemoActivity identical to R87, only memo related 5 extra generated synthetic lambda classes. Original voice classes still present.
- APK v2 RSA cryptographic digest/signature PASS (independently tested with public `apksigner.jar verify --verbose`), same expected signing certificate; AAPT manifest package/version/target PASS.
- ZIP CRC, 4-byte stored alignment, all DEX SHA1+Adler32 PASS.
- Original R87 JS per-field clear mock tests PASS, unchanged.
- **Real Galaxy S26 Ultra keyboard and deletion workflow not yet tested.** Follow this EXACT test: open capture "모아 바로 기록" memo; type multi-line text and open Samsung IME; verify all 3 actions visible ABOVE keyboard; cancel full-clear confirm preserves text; confirm clears only text; original media remains; type or speak and Save, reopen diary and check same media's 5-minute memo.

## Emergency rollback-forward R90, NOT routine install
- Same signer `MOA_R90_ROLLBACK_FORWARD_R87_DIARY_CLEAR_Install.apk`, bytes **3,490,038**, SHA256 `bfca47e11724d02370c6b53559bfbabe2b4ede0b351b8f691f56fe4695c21607`.
- Exact R87 code and resources **all 54/55 APK members byte identical**, only versionCode 87→90/Name R87→R90 in manifest. Use ONLY if R89 has major regression; it will return to known R87 diary clear and **unfixed** native keyboard behavior. It is installable over code89 with same package/cert and no uninstall/data reset. Future build versionCode must be >=91.
- Original R83 physical voice Gold and its protected Library APK remain canonical; do not use older R84 (broken R82 voice) or clear app data.

## Repository / Library
- Public source patch and release branch: `release/moa-r89-native-memo-keyboard-clear`.
- GitHub Actions `41819061843` contains genuine compiled DEX artifact (no signing secrets).
- Private Library path: `/모아_프로젝트_근거_20261103/` includes signed R89 APK, no-key source/verification ZIP, emergency R90 and verification JSON.
- Do not change AirPods project code or AA canonical rules.
