# MOA — CURRENT RELEASE REGISTRY / APPEND-ONLY CHANGELOG
**Latest checkpoint 2026-11-06: R115 USER-APPROVED VISUAL GOLDEN.**
*This document is an append-only chronology. On every future change, create a new dated entry (including failed experiments) and also update the ACTIVE READ-FIRST pointers. Do not delete failed versions to make the history look successful.*

## 0. Exact live baseline
| Item | Value |
|---|---|
| User-selected current Golden | **MOA R115 — VISUAL/LAUNCHER/SPLASH USER-APPROVED**; full legacy feature regression **PENDING** |
| Package | `com.juhyeon.familyjournea` |
| VersionCode | `115` (reserve 116 for R113-based recovery, future feature code **>=117**) |
| Golden APK SHA256 | `1118bdc249e2d941a899518e58be0185b120a887ff2c371c8f5a01037a5002a8` |
| Size | `5,406,744` bytes |
| Signer cert SHA256 | `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15` |
| Frozen private file | `/모아_프로젝트_근거_20261103/MOA_R115_USER_APPROVED_VISUAL_GOLDEN_20261106_DO_NOT_MODIFY.apk` |
| Member manifest | `MOA_R115_GOLDEN_LOCK_MANIFEST_20261106.json` (SHA for all 103 zip members) |
| Signed APK proof | `MOA_R115_INDEPENDENT_VERIFICATION.json`; user confirmation in conversation 2026-11-06 |
| Prior Golden assets | R63 photo/IDB, R83 native diary speech, R89 memo IME, R96 navigation (see own handoffs). Never overwrite. |

## 1. Release/version history — 2026-11-05/06 icon project

| Release | Status and evidence | Root cause / changes / fix or next step |
|---|---|---|
| R99 | Stable base for R100, package code99, SHA `a15b066e4364d7d4723a119d4d7145fa80e58b5f298f0847587ff049da48f35f`. Actual R99 native device touch full-regression not independently proven. | Settings > App collapsible quick navigator/controls; R96 behavior retained. Exact signed APK private Library; see `MOA_R99_SETTINGS_ACCORDION_TOUCH_FIX_HANDOFF_20261105.md`. |
| **R100** | **INSTALL FAILED** (actual Samsung `pm install` result). Artifact SHA previously `a9ca9b0628006bfd7aedb28bca1a0bbc6524756e23131c5d601a2917bc55b822`; not installable. | `INSTALL_PARSE_FAILED_MANIFEST_MALFORMED`, `activity-alias targetActivity` missing because binary resource-map index mismatch; extra classes5.dex method classification flaw. Fixed in R102. **Static ZIP/v2 PASS did not mean install PASS.** |
| R101 | Recovery-only forward, NOT new icon feature. | Return-to-old code baseline, higher code to permit rollback; do not treat as verified functional successor to R100. |
| **R102** | Actual installed; **VISUAL FAIL** in user screenshots. SHA `6da5e3b77abcc1404bb7949caa12960d5487e2ac14fa3bfb64f1bd9a9602fadd`. | Fixed typed AXML IDs and DEX static method list; icon mock art diverged from user approval, home icon fuzzy, startup remained old image. R103 follow-on. |
| **R103** | Actual installed; **VISUAL FAIL**: black edges, shadows, color/texture mismatch. | Tiny approved poster cells cropped then scaled into launcher/splash; poster graphics/caption/shadows baked into bitmaps. CSS/settings/splash flow wired. Fix needed clean layered assets. |
| R104 | Emergency rescue version, not regular release. | R99 baseline-forward only. |
| R105 | Intermediate visual rebuild, static PASS; user did not promote. | Removed baked halos but lost gloss and accurate approved colors. More work needed; preserve evidence. |
| R106 | Emergency rescue, not routine release. | R99-style restore-forward. |
| **R107** | Updated APK, artifact SHA `672d411796a94964ef58bf4b3f8b0a464c6d41bc61ab33447a7f134b3ab08f89`, **DEVICE VISUAL FAIL** (severe icon blur). | 9 icons prettier as PNGs, but launcher aliases still used direct PNG in `mipmap-anydpi`; actual Android launcher rendering bad. Some download links failed `Library file not found`. |
| R108 | Emergency rescue, not routine release. | R99 forward recovery only. |
| **R109** | Signed beta SHA `e32c0036a5f177c14f84f50404233247c29a0f798259f59201f50406583e8d5c`. **Device blur still FAIL** after adaptive XML. | Added 9 adaptive XML + 18 768px bitmap layers, but binary resource config incorrectly registered nodpi PNGs under `anydpi=0xFFFE`. Fixed in R111. |
| R110 | Emergency rescue, not routine release. | R107 restore-forward. |
| **R111** | Signed beta SHA `8056d4aff349f8745c2fd9da30c4c5106e0e2574202068870b07f9ca264384b0`. **Actual Galaxy icon sharpness IMPROVED** (user screenshots); **wordmark clipping and splash blots FAIL**. | Split adaptive XML `anydpi` vs bitmap `nodpi=0xFFFF` in binary resources. User's visible improvement supports fix. Remaining too-wide glyph and dirty splash → R113. |
| R112 | Emergency rescue, not routine release. | R99 restore-forward. |
| **R113** | Signed APK SHA `024f788ca890f1eccbc3a1cdd08aee5dbe78baf6b43dfaa5cf72d24ce32b7f25`. User: **"이제 거의 완성"**, home icon center and splash cleaner, but startup "popup" flash visible on video `19030.mp4`. | Constrain foreground alpha wordmark to safe center (~428px/768 bold), replace nine splash poster-crop PNGs with clean 768px composite. Late stylesheet produced 768px transient image → R115. |
| R114 | Emergency rescue, not routine release. | Restores R111 bits at higher code; would restore its known clipping/blotches, not a full R113 successor. |
| **R115** | **USER-DESIGNATED VISUAL GOLDEN on 2026-11-06**, exact SHA `1118bdc249e2d941a899518e58be0185b120a887ff2c371c8f5a01037a5002a8`, 5,406,744 bytes; signed/v2 PASS; 101/103 members byte-identical to R113. **Full original feature regression NOT TESTED.** | First-paint fix: move `moa-icon-theme-settings.css` into HTML head and add 180px critical splash CSS. Chromium with late CSS withheld: R113 IMG 768px vs R115 IMG 180px. User explicitly asks to save as Golden. Frozen. |
| R116 | **RESERVED EMERGENCY ONLY**, not installed as routine release. SHA `4273752b54a8aa2973a6d8a30e45af86e063bffdd034bb45c3c8c83247a1cf59`. | R113 bits + versionCode116; restores R113 visual behavior, including known flash. Never represent as equivalent to R115 Golden. |

## 2. Protected earlier Golden history
- R63 USER-DEVICE GOLDEN: exact per-photo ID/capture timestamp/memo saved to IndexedDB and read back; SHA `64b1b730478a2a50976961cc2dc4cf511182a75495f2d02159f091167f646024`.
- R83 USER-DEVICE GOLDEN: diary editor native STT and live bridge; SHA `221488ba5e1c6fb225c99837070cdad6028f1798aba396c05e73a763bb4e2d78`.
- R89 USER-DEVICE GOLDEN: Samsung keyboard-aware Mic/Clear/Save in native photo memo, confirmation; SHA `2b52826fc0dd8653a70d3c503d3654ae33071bfc4ec075753ec4464a1e2dc493`. R89-specific camera temporary-save toast not independently full-IDB proof; R63 covers separate IDB Golden.
- R96 user-accepted floating up/down drag/pin, original SHA `d90a6ccd70a24ad261a54788a8a795c881fd429a37dcf71b6d9d25970a5f1eaf`. Exact physical acceptance scope referenced in R96/99 records.

## 3. Release check status vocabulary (never swap)
- `EXPERIMENT/PROPOSAL`: idea only, no code.
- `SOURCE_WRITTEN`: code/text made, no compiled installable.
- `APK_SIGNED_STATIC_PASS`: exact file exists, framework ZIP+resource+DEX+APK v2/cert gates passed.
- `DELIVERY_REFERENCE_FAIL`: ChatGPT shows `Library file not found`.
- `USER_DOWNLOAD_CONFIRMED`: recipient reports usable download, NOT install.
- `DEVICE_INSTALL_PASS/FAIL`: actual Android PackageManager result.
- `VISUAL_DEVICE_PASS/FAIL`: user screenshot/video of visible feature.
- `FUNCTION_DEVICE_PASS/FAIL`: specific observed user workflow, not inferred from other feature.
- `VISUAL_GOLDEN_USER_APPROVED`: user-designated stable visual baseline; existing feature tests may still be pending.
- `FULL_FUNCTION_GOLDEN_USER_APPROVED`: ONLY after user actually runs comprehensive regression checklist and explicitly accepts the scope.

## 4. Mandatory future entry format — append and link tests
```
### YYYY-MM-DD — R### — TITLE — STATUS
- Request/scope, base Golden SHA:
- Exact new APK (bytes/SHA/code/package/cert), Library reference:
- Changed/added/removed zip member names and per-file SHAs:
- Build process, source/branch/commit and successful/failed checks:
- Device/download evidence (screenshots/log): 
- Root cause: CONFIRMED / HYPOTHESIS / UNKNOWN, precise evidence:
- What fixed it; what still fails and why:
- Legacy data/function preservation evidence and PENDING gaps:
- Dedicated rollback-forward and its known limitations:
- Next action and whether current Golden is unchanged:
```
If a bug is discovered after release, append a correction with new timestamp and link to original entry; do not rewrite history as if it never failed. Always update `MOA_WIP_CHECKPOINT_CURRENT.md`, the main read-first header and current Golden status links.

## 5. Source references
`MOA_RELEASE_FAILURE_LEDGER_AND_BUILD_GATES_20261106.md`; `MOA_R115_USER_APPROVED_VISUAL_GOLDEN_LOCK_20261106.md`; `MOA_ARCHITECTURE_EXTENSION_AND_QA_MAP_20261106.md`; R99, R102, R107, R109, R111, R113, R115 individual handoffs; private verified binary files and manifests.


### 2026-11-06 — R115 GOLDEN FREEZE & ENGINEERING ARCHIVE (documentation action, NOT a new APK)
- User explicitly designated R115 as Golden and requested all failures, causes, fixes, reproducibility, new-chat read-first steps and future release history. Visual/UX Golden accepted; pre-existing full feature regression remains PENDING.
- Frozen signed APK copied byte-identically (5,406,744 B; SHA256 `1118bdc249e2d941a899518e58be0185b120a887ff2c371c8f5a01037a5002a8`) into `MOA_R115_USER_APPROVED_VISUAL_GOLDEN_20261106_DO_NOT_MODIFY.apk` in private Library. All 103 member SHA digests stored in `MOA_R115_GOLDEN_LOCK_MANIFEST_20261106.json`.
- No-keys source/testing/archive ZIP (1,935,084 B, SHA256 `65dacf44688f4eeb45e91b20e3e83693ec1913d22c8015b5abbc2ecd36b93e13`) saved to private Library. Exact UI/launcher/splash source plus diff and QA; full native build source not claimed.
- Public GitHub `tools/moa_golden_release_guard.py` added: original baseline intact PASS, R113 negative diff test correctly FAILED on 2 expected members. Pure member SHA/ZIP guard; APK v2/device verification is separate.
- New mandatory read-first, Golden Lock, failures/regressions, architecture/test map, append-only ledger committed; README, Absolute Read First, WIP, Master Golden header updated to point to **R115 CURRENT**.
- No app function modified, no new build installed, no signer secrets published. Next regular release versionCode >=117; R116 reserved for emergency recovery.

- Frozen GitHub **documentation/test snapshot branch**: `golden/moa-r115-20261106-visual-user-approved-do-not-modify` (created from latest main; metadata/source anchor only). **This branch does NOT embed or reproduce the exact signed R115 APK**; actual unmodified 5,406,744-byte release remains in private Library.


### 2026-11-06 — R115 — USER REAL-DEVICE VERIFICATION CONFIRMED (status-only update)
- User reports R115 installed and practical device validation **completed successfully**, and directs that this exact version be kept as the Golden for future development. Overall evidence type: **USER-REPORTED DEVICE TEST PASS**, not independent tester logs.
- Current Golden now **R115 USER-CONFIRMED DEVICE GOLDEN**, superseding the earlier *visual-only Golden / overall device test pending* headline; historical entries above remain as dated evidence.
- Exact APK unchanged: package `com.juhyeon.familyjournea`, versionCode115, size 5,406,744 bytes, SHA256 `1118bdc249e2d941a899518e58be0185b120a887ff2c371c8f5a01037a5002a8`. No APK rebuild, no data migration, no new installation in this documentation step.
- **Evidence boundary:** The user provided a general real-device completion report; they did not enumerate results for every diary, photo, calendar, voice, shortcut, OHO, individual icon variant or data-recovery path. Treat overall acceptance as PASS, specific detailed test evidence **not itemized**. Don't fabricate per-feature outcomes.
- Original signed Golden APK and all 103 member SHA hashes frozen in private Library; earlier R63/R83/R89/R96 reference Goldens unchanged.
- Any new feature code >=117, keep exact signer and package, never uninstall/clear app. Before and after modifications, run binary/resource/signature/static and device regression gates; append FAIL/root cause/fix to this ledger for every future experiment.
