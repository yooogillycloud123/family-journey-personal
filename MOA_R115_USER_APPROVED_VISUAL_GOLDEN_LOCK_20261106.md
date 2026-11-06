> **2026-11-06 MOA R115 USER DEVICE GOLDEN CONFIRMATION:** User has now reported completing R115 real-device verification and explicitly accepts it as the ongoing development Golden. **STATUS: R115 USER-CONFIRMED DEVICE GOLDEN (overall user-reported PASS)**, superseding earlier provisional **visual-only / functional verification pending** labels *as a general acceptance status*. Exact APK remains unchanged: versionCode115, SHA256 `1118bdc249e2d941a899518e58be0185b120a887ff2c371c8f5a01037a5002a8`, same installed package and signer, frozen private Library APK. The user's statement is evidence of their overall real-device validation; no individual test-case log was provided, so do **not** claim independently measured photo/diary/STT/OHO/9-theme results or fabricated screenshots. Preserve R63/R83/R89/R96 historical Goldens. Future regular code >=117. Always read `MOA_R115_NEXT_CHAT_START_HERE_20261106.md` and the append-only release ledger first. 

# MOA R115 — USER-APPROVED VISUAL GOLDEN LOCK (2026-11-06)
**CURRENT ACTIVE MOA BASELINE. READ FIRST FOR EVERY NEW CHAT / EVERY NEW FEATURE.**

## 0. What the user approved and what remains untested
On 2026-11-06, immediately after downloading the R115 release for the launch-screen popup/flash fix, the user explicitly stated: **"오케이 이 버전을 골든버전에 추가해놓고"** and requested a thorough, durable history of every mistake, failed experiment, corrective action, future-proof architecture, and mandatory next-chat read-first process. Promote **the exact R115 bytes** to **USER-APPROVED VISUAL/UX GOLDEN**. This is a user-designated freeze point. It is **NOT** a claim that the user has finished independent tests of all legacy photo, diary, calendar, speech, OHO, shortcuts, or IndexedDB workflows. In the preceding message the user said those functional tests would occur after visual refinement. Keep these gates explicitly separate.

Golden categories:
- **R115** = CURRENT USER-APPROVED **VISUAL/LAUNCHER/SPLASH GOLDEN** and latest installed/update baseline by user report. Preserve it unchanged.
- **R89** = separately protected physical **NATIVE MEMO KEYBOARD/MIC/CLEAR/SAVE GOLDEN** (user screenshot verified). Preserve original R89 bytes/branch.
- **R83** = separately protected physical **DIARY EDITOR NATIVE VOICE GOLDEN**.
- **R63** = separately protected physical **PHOTO/EXACT TIMESTAMP/MEMO DIRECT INDEXEDDB GOLDEN**.
- **R96** = prior accepted quick-navigation behavior; see its own handoff. No other version's tests implicitly cover R115's full feature regression.

## 1. Frozen exact signed artifact — no overwrite or re-sign
- Library path: `/모아_프로젝트_근거_20261103/MOA_R115_USER_APPROVED_VISUAL_GOLDEN_20261106_DO_NOT_MODIFY.apk`.
- SHA-256: **`1118bdc249e2d941a899518e58be0185b120a887ff2c371c8f5a01037a5002a8`**
- Size: **5,406,744 bytes**; versionCode **115**; package `com.juhyeon.familyjournea`.
- Signing certificate SHA256: **`5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`**. Private signing keys must stay only in protected Library `PRIVATE_SIGNERS`, never GitHub/public/chat artifacts.
- ZIP member count: **103**; ZIP CRC PASS; earlier full APK v2 crypto/content-digest and certificate verification PASS per `MOA_R115_INDEPENDENT_VERIFICATION.json`.
- Frozen content manifest (all 103 member SHA256s): `/모아_프로젝트_근거_20261103/MOA_R115_GOLDEN_LOCK_MANIFEST_20261106.json`. Checksum text `MOA_R115_GOLDEN.sha256`.
- Original working R115 signed APK also exists as `MOA_R115_SPLASH_POPUP_FLASH_FIX_Install.apk`; the DO_NOT_MODIFY copy has byte-identical SHA and is the new canonical immutable release.
- Source base: exact R113 `024f788ca890f1eccbc3a1cdd08aee5dbe78baf6b43dfaa5cf72d24ce32b7f25`. Comparing decompressed APK members, **ONLY** `AndroidManifest.xml` and `assets/web/index.html` differ; **101/103 unchanged**.
- The GitHub `android/` debug prototype `applicationId com.familyjourney.personal` is **NOT** the installed MOA package. Do not mistake GitHub workflow/debug build or the historical frozen R89 source branch for an exact reproducible R115 build. Signed APK in private Library is byte-true baseline.

## 2. User-visible golden appearance to preserve
- Home/app drawer: crisp, truly center-aligned `MOA`, no clipping outside circular/rounded launcher mask, no pixelation or black cropped poster shadows.
- Nine themed launcher icon variants: 3 text styles (A modern bold, B `MOΛ` slim premium with crossbarless Λ, slim minimal glass) × pink/black/white. White/black do not acquire unwanted pink tint. Galaxy app icon choice changes the launcher icon.
- Splash screen: selected icon and matching background, clean 768px composited artwork, no stray black arc, dirty transparency, blotches or enlarged raw bitmap. No briefly gigantic `MOA` popup while CSS finishes.
- R115 root-cause fix: pre-existing `moa-icon-theme-settings.css` was loaded at bottom of body; raw splash IMG natural size 768px could render before late CSS while parent was 154px. R115 moves the CSS link into `<head>` and sets critical first-paint parent/IMG dimensions **180px**; launch JS remains at bottom. Chromium regression demonstrated late CSS withheld: R113 IMG 768px vs R115 IMG 180px; after CSS both 180px. See `MOA_R115_SPLASH_POPUP_FIRST_PAINT_REPAIR_HANDOFF_20261106.md`.
- All other legacy features are **unchanged in the signed artifact from R113**, NOT newly tested on R115.

## 3. Frozen protected architecture / files
Never casually change:
- `classes.dex` through `classes5.dex` (Host/native voice/memo/capture/interface/icon integration);
- `resources.arsc`, binary `AndroidManifest.xml` structural attributes, icon activity-alias targets, existing signer/package/permissions;
- `assets/web/family-diary.js`, `family-diary.css`, `moa-direct-diary-commit.html`, original photo timestamp/ID storage;
- `assets/web/moa-icon-theme-settings.js`, CSS, 9 theme PNGs, 9 adaptive-icon XMLs and 18 `mipmap-nodpi` foreground/background PNGs;
- `assets/web/index.html` first-paint ordering without an equivalent browser regression test;
- original photo/media, per-photo memo, IndexedDB/localStorage, account records, diary entries, offline maps, notification states and app data.
Some files may need a targeted future feature change; that needs a declared allowlist, diff report, targeted regression tests and explicit user-facing risk, not a blanket ban on future improvements.

## 4. Release gates — do not overclaim
Separate and record:
1. SOURCE/BUILD, 2. EXACT SHA/BYTES, 3. ZIP/DEX/XML/resource validation, 4. APK v2 SIGNATURE & old certificate, 5. current-chat ATTACHMENT actually openable, 6. IN-PLACE INSTALL, 7. VISUAL DEVICE PASS, 8. FUNCTIONAL DEVICE PASS. Never collapse any of them into "complete".
User's R115 Golden designation applies to visual/update baseline, while comprehensive feature/device gate is **PENDING**. If tests reveal a regression, record exact failure honestly and keep Golden bytes untouched.

## 5. Strict future upgrade rule
- **Next feature/update versionCode >= 117**, because `R116` is already reserved as an emergency rollback-forward to the R113 bits (not routine install). Never issue a lower/same code by accident.
- Always derive from exact R115 freeze, not a stale branch, failed R100–R109, R111 or generic `android/` prototype. Make a separate staging copy/branch; NEVER alter frozen APK.
- Keep package & old signer, in-place install, same app, no uninstall/reset, no user-data migration without separate opt-in and verified safe backup.
- Minimal member changes + SHA diff and regression test; a passing ZIP alone is insufficient.
- Deliver within the **current chat only**; **NO Gmail/email/drafts**. See `MOA_DELIVERY_CHAT_ONLY_NO_EMAIL_RULE_20261106.md` and `MOA_RELEASE_DOWNLOAD_LINK_RELIABILITY_CRITICAL_RULE_20261105.md`. `Library file not found` is a ChatGPT delivery failure, not proof of a corrupt APK.
- A rollback-forward is a recovery-only option. Current R116 reverts to *R113* behavior, including its known initial giant-image flash; do not present it as a complete feature-equivalent R115 rollback. For future releases build a new higher-code recovery from the **exact R115 golden** instead, if practical.

## 6. Immediate next work (do not silently invent requirements)
User intends to test original functions **after** visual baseline is locked. Test one-by-one: open past diary/notes; calendar and photo thumbnail/date grouping; capture camera → memo save and reopen exact photo/timestamp in IndexedDB; native microphone and Samsung keyboard; safe clear/delete confirm/cancel; floating top/bottom drag/lock and settings accordion; 9 icon variants/launcher persistence/splash appearance; offline/data continuity. The user has not reported these completed yet. NAVER background save work and unrelated extensions remain ON HOLD unless explicitly requested.

## 7. Required next-chat navigation
1. Project top-level AirPods canonical read-first when this shared project demands it (do not alter AirPods).
2. `MOA_R115_NEXT_CHAT_START_HERE_20261106.md` (ACTIVE).
3. This **R115 Golden Lock** and actual private Library SHA-verified frozen APK.
4. `MOA_RELEASE_FAILURE_LEDGER_AND_BUILD_GATES_20261106.md` (R100–R115 failed/succeeded experiments, actual causes, preventive test).
5. `MOA_ARCHITECTURE_EXTENSION_AND_QA_MAP_20261106.md` (product/data/regression map).
6. Relevant historical R63/R83/R89/R96/R99 and R111/R113/R115 per-feature handoff, only when needed; older top-level "latest" headings in long files are HISTORY, not current.
7. Append every future change/failure/recovery to `MOA_RELEASE_LEDGER_CURRENT.md`, and update `MOA_WIP_CHECKPOINT_CURRENT.md`, `MOA_ABSOLUTE_READ_FIRST_20261103.md` headers, and this active Golden pointer if a new Golden is specifically user-approved.

**Golden never means "all features passed": avoid that exact repeat failure.**


## 8. Immutable freeze supporting materials — completed 2026-11-06
- **Actual frozen APK** uploaded and SHA checked under private Library path given in section 1; original signed R115 retained separately.
- **Complete member hash inventory**: `MOA_R115_GOLDEN_LOCK_MANIFEST_20261106.json` (all 103 members, R113 diff, protected member hashes) and `MOA_R115_GOLDEN.sha256`.
- **No-keys engineering snapshot**: `/모아_프로젝트_근거_20261103/MOA_R115_GOLDEN_NO_KEYS_ENGINEERING_SNAPSHOT_20261106.zip`; SHA256 **`65dacf44688f4eeb45e91b20e3e83693ec1913d22c8015b5abbc2ecd36b93e13`**, bytes **1,935,084**. Includes exact signed-R115 WebView UI/diary/9-splash/icon XML+PNG resources, R113→R115 HTML patch, visual/browser QA, two verification JSONs, Golden manifest and helper test; **NOT** complete runnable source or a substitute for the signed APK.
- **Regression member-diff tool**: GitHub `tools/moa_golden_release_guard.py` (public, no keys); private copy `MOA_R115_GOLDEN_RELEASE_GUARD_NO_KEYS.py`. Golden-vs-Golden PASS; R113-vs-Golden correctly FAIL for `AndroidManifest.xml` and `assets/web/index.html`. This checks only ZIP/member diff; separate official Android signer/package/runtime tests remain mandatory.
- **No-keys tool selftests**: `MOA_R115_GUARD_SELFTEST_PASS.json` and `MOA_R115_GUARD_NEGATIVE_TEST_R113.json` in private Library. Never publish signer backups.

**Named GitHub freeze branch:** `golden/moa-r115-20261106-visual-user-approved-do-not-modify` (documentation/test/source-reference snapshot based on main at freeze time, not an installable APK or complete native build). Exact signed R115 bytes remain in private Library; never mistake branch for reproducible binary source.
