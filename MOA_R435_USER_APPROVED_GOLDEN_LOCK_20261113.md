# MOA R435 — USER-DESIGNATED CURRENT INTEGRATED GOLDEN LOCK

**Effective:** 2026-11-13 (Asia/Seoul)
**User decision:** “오케이 이 버전을 골든으로 지정해줘, 여기서 더 발전해 나가자 … 새로운 채팅에서 이어서 … 이 버전 기준”.
**Status:** **CURRENT PRIMARY GOLDEN / USER-APPROVED BASELINE**. This supersedes "R435 BETA / physical pending" as a *designation of the baseline*, not a claim that every app function has independently passed a complete automated or on-device test.
**Next development rule:** All subsequent work must begin from this exact R435 binary/source, not R431/R427/R423/R419/R415. Preserve the earlier Goldens for historical forensics/rollback, not as automatic feature base.

## 1. Exact immutable deliverables (do not overwrite)

- APK: `MOA_R435_DRAGGABLE_NAVER_PINK_HOME_SIGNED_BETA.apk` (original filename retained in historical release).
- Immutable Golden copy: `MOA_R435_USER_APPROVED_GOLDEN_DO_NOT_MODIFY.apk` in PRIVATE Library.
- package: `com.juhyeon.familyjournea`
- versionCode: **435**
- size: **8,943,793 bytes**
- full APK SHA-256: **`e36e55b823d9d8aa1650c05fb8314b5773df7b00287dab2e102440eea51f910c`**
- original signing certificate SHA-256: `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`
- Android GitHub Actions compilation/D8: [run 43331481423](https://github.com/yooogillycloud123/family-journey-personal/actions/runs/43331481423), SUCCESS. DEX `classes17.dex` SHA-256: `7ae4f8de8109d3bde08a33057f4ae3792a26e7383dfe76718e5921816374d2cd`.
- Previous static release QA showed signature scheme v2 RSA verification **plus full signed-content digest PASS**, ZIP CRC/alignment and DEX Adler32/SHA1 PASS. Preserve those records and distinguish static verification from real device assertions.
- User has explicitly selected R435 as the Golden during this conversation; no new APK is needed for designation.

## 2. Archive references

**PRIVATE Library immutable Golden folder:**

`/모아_프로젝트_근거_20261103/GOLDEN_R435_USER_APPROVED_20261113/`

Contents copied from the verified R435 release:
- `MOA_R435_USER_APPROVED_GOLDEN_DO_NOT_MODIFY.apk`: exact user-approved release.
- `MOA_R435_ORIGINAL_SIGNED_RELEASE_AND_QA.zip`: original R435 + R437 recovery + source/README/QA bundle; do **not** mislabel the included R437 as an exact R435 recovery.
- `R435_ORIGINAL_VERIFICATION_QA.json`: preserved hash, signature & member comparison.
- `MoaR391SessionPersistProvider_R435_GOLDEN.java`: source archive.
- `R435_ORIGINAL_CHANGE.diff`: R431→R435 source change evidence.

The older release assets remain untouched in `/모아_프로젝트_근거_20261103/R435_DRAGGABLE_NAVER_HOME_20261113/`.

Source-of-truth GitHub branch (do not update):
`golden/moa-r435-user-approved-20261113`

Development source path:
`experiments/moa-r391/MoaR391SessionPersistProvider.java`

The earlier development branch `feature/moa-r435-draggable-naver-home-20261113` and GitHub handoff `MOA_R435_R431_DRAGGABLE_NAVER_HOME_R437_EXACT_RECOVERY_20261113.md` remain historical sources. The new Golden branch is intended to be frozen and should not receive commits.

## 3. Mandatory preservation contract

Every following version must preserve R435's existing implementation and regression-check the following modules:

1. **High fidelity native Gallery** from R415 and earlier golden: photos/videos in a single gallery, horizontal thumbnail rail, swiping, playback, mute, media volume, frame capture, navigation/return. Do NOT regress to R133 legacy web fallback. Original `classes6.dex` includes advanced Gallery and NAVER Controller; do not swap older whole DEX.
2. **NAVER WebView session and official login:** user manually signed in previously, and native CookieManager persistence exists. Do not clear data/cookies, force official login, move login secrets or bypass receipt CAPTCHA.
3. **NAVER PC map first-party location save:** original account list selection/readback and `assets/web/fj-naver-favorites.js` engine must be preserved; do not conflate a queued UI status with a successful saved place.
4. **Automatic non-occupying NAVER map preparation at MOA launch:** user-proven STOP → actual visible PC map START → short (~460ms) → HIDE, protected by an opaque MOA mask.
5. **Automatic rearm after manual NAVER WebView close** when user presses offscreen save; one submission only, no duplicate writes; frozen current Diary UI; avoid popping visible browser. 
6. **Existing app-process WebView renewal logic** introduced to address controller 4-minute expiry. Its actual >4-minute user-device behavior has not separately been explicitly closed; keep code, regression-test, do not overclaim.
7. **R419 launch/rearm visual stabilization** and **R423 full-opacity icon-theme splash**.
8. **R427 tiny foldable NAVER chrome**, R431 safe tappable chevron below Android status shade + original MOA/Close controls when expanded.
9. **R431 native pink MOA Home in separate NAVER map WebView**: short tap hides map (does not dispose NAVER session) and returns to MOA. 
10. **R435 enhancement**: pink Home supports native drag, safe bounds, tap-versus-drag gesture handling and persisted normalized position across NAVER WebView restarts via app-private SharedPreferences. Avoid resetting position during global layout.
11. Diary/photo/GPS, Moment recording, gallery, voice, R389 main-screen Home dot, all theme assets and app navigation must remain intact.

Original R435 QA: 140 APK members, 138 unchanged relative to R431, only Manifest versionCode and `classes17.dex` changed. Protected payload hashes recorded in `R435_ORIGINAL_VERIFICATION_QA.json`:
- `classes6.dex` `cf93d66d08f1700b95949760093bd50689fa8b45e7cbe4a42b962b2afbb6f61b`
- `assets/web/fj-naver-favorites.js` `ee9d62ace062c38876105eec2f2a974cae243e15851dc6897197577a924d924b`
- `assets/web/moa-r389-home-dot.js`: use authoritative original QA for the exact hash.
- `assets/web/index.html` `31194656f9a4e97c043855075264a253ce350fb8aebbee972fe7aea41dee6969`

**Important:** For all file-level hashes use `R435_ORIGINAL_VERIFICATION_QA.json` as authoritative. The original QA and original APK bytes prevail over any manual prose.

## 4. New version/recovery rules

- Do **not** modify/overwrite/delete R435 Goldens or replace binary in-place.
- Make future experiments on a **new branch from `golden/moa-r435-user-approved-20261113`**. Use new versionCode greater than 437 (e.g. 439 or later; check actual installed versionCode).
- Keep package `com.juhyeon.familyjournea` and EXACT original signing certificate so update install preserves data and NAVER cookies; never uninstall/wipe data/cache/cookies.
- Save full signed APK + full QA ZIP + source change + checksum + PRIVATE Library archive + GitHub checkpoint **per candidate**.
- Before shipping a new candidate create a separate **forward-installable exact R435 functional recovery APK** (only AndroidManifest versionCode changed) with a versionCode higher than the candidate; independently verify original signer, data-preserving update, and exact payload comparison.
- **Do not use R437 as R435 recovery.** R437 is a forward restoration of **R431**, not R435; it loses R435's native drag feature. Older R429/R425/R421/R417 similarly are not current Golden recoveries.
- Real Galaxy acceptance must explicitly verify Gallery + offscreen account save + NAVER visible/hidden startup + rearm + chevron and Home drag/tap/position persistence. CI/zip/DEX PASS != physical PASS.
- Never modify AA AirPods / Android Auto app or runtime while working on MOA.

## 5. How to resume in a future chat

1. Read `MOA_READ_FIRST_NEW_CHAT.md` and this file in full.
2. Read `MOA_WIP_CHECKPOINT_CURRENT.md` and verify there is no newer **explicitly user-approved Golden**; otherwise this R435 remains baseline.
3. Read `MOA_R435_R431_DRAGGABLE_NAVER_HOME_R437_EXACT_RECOVERY_20261113.md` and original QA; inspect exact source branch and PRIVATE Library.
4. Inspect existing source/DEX/APK/verification artifacts first; reuse them rather than reconstructing previous work.
5. Accept the user's next requested improvement as a **delta from R435**, preserving all contracts above.
6. If creating an APK, static verification and real device verification must be reported separately; do not claim success prematurely.

See `MOA_NEW_CHAT_RESUME_PROMPT_R435_20261113.md` for a ready-to-paste start message.

**Baseline label:** `MOA_R435_USER_APPROVED_GOLDEN_20261113`.
