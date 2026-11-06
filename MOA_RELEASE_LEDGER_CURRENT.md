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


### 2026-11-06 — R117 — Diary-first / compact settings / icon-linked UI theme (SIGNED BETA, DEVICE UNTESTED)
- Request: 첫 실행 일기·하단 일기→지도→기록→설정; redundant premium row hide; source/help/theme/advanced fold groups; old quick-nav arrow › unify; auto icon color and optional Peach/Pink/Black/White palettes.
- Base = exact R115 user-device Golden `1118bdc249e2d941a899518e58be0185b120a887ff2c371c8f5a01037a5002a8`. **R115 NOT MODIFIED.**
- R117 SHA256 **`667e6caa97ffc76b10df15594d5be0672ea892ae0be2692b293161eba94dfdb0`**, 5,412,356 bytes, code117, package `com.juhyeon.familyjournea`, original signer cert same as R115. Private Library `MOA_R117_DIARY_FIRST_SETTINGS_THEME_BETA_Install.apk`.
- Exactly 3 changed old members: binary Manifest(version), `assets/web/app.js`(startup tab), `assets/web/index.html`(2 CSS/JS references); 2 new UI CSS/JS modules. Other 100/103 old entries byte-identical, all native DEX, old diary, photo index, map and UI icon assets unchanged.
- Signed APK v2 RSA, content digest, signer fingerprint, ZIP integrity, stored alignment, JS syntax, limited Chromium DOM-mock navigation/grouping/theme interaction PASS. User Galaxy install/UI/legacy regression **NOT YET TESTED**. See [R117 handoff](MOA_R117_DIARY_FIRST_COMPACT_SETTINGS_ICON_LINKED_UI_HANDOFF_20261106.md).
- R118 private emergency-only restore-forward based on exact R115 (manifest only, code118, signed same cert), SHA `462a30d3a18406f56bd3ad884210b8919af277e3e887ea08fdb6091213361361`; no routine install. Following normal update code >=119.
- Delivery strictly in current ChatGPT conversation, Gmail forbidden; actual mobile open and physical test only when user confirms. R115 remains Golden pending R117 acceptance.



### 2026-11-06 — R119 Galaxy INSTALL FAIL / R121 R117-derived repair beta — DEVICE INSTALL PENDING
- **R119** (reported original): `MOA_R119_Install.apk`, code119, 5,416,801 B, SHA256 `332e4508e4e7cce99592013be2b5e42be069e53aba44a670a6ad35d046d730fa`. Original static ZIP/v2 reported PASS; user screenshot `19084.png` conclusively shows Android **"앱이 설치되지 않음"**. Mark **DEVICE_INSTALL_FAIL**, NOT Golden. APK and source zip could not be found in accessible current-chat runtime / current MOA Library; precise PackageManager reason **UNKNOWN**, do not fabricate binary root cause.
- Preserved exact R115 user Golden (SHA `1118bdc249e2d941a899518e58be0185b120a887ff2c371c8f5a01037a5002a8`) and exact R117 user tested base (SHA `667e6caa97ffc76b10df15594d5be0672ea892ae0be2692b293161eba94dfdb0`), both re-read from private Library, untouched.
- **R121** (fresh independent patch, **NOT exact R119 repair**): `MOA_R121_INSTALL_REPAIR_BETA.apk`, package `com.juhyeon.familyjournea`, code121, **5,415,933 B**, SHA256 `3e85d68ad652c5a55eafe01ec31ecbc2129bbea0e56a76eca70c4594b89a094a`. Existing certificate SHA256 `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`. Original R117 105 entries: **103 byte-identical**, only binary `AndroidManifest.xml` versionCode (one byte 117→121) and `assets/web/index.html` loader links changed; added `assets/web/moa-r121-ui.js` and `assets/web/moa-r121-ui.css`. All original DEX, MediaStore, native capture, diary storage/IndexedDB and icon resources unchanged.
- Scope: photo gallery overlay with native diary index time (if available), GPS from existing precise photo index, address via existing native `reverseAddress` with explicit missing/unknown states; NAVER official `nmap://map` URL via existing `NativeHost.openUrl` path (Android intent not hardware tested). Diary UI hides capture toolbar, PC ZIP import and manual date/new-diary form **only in diary**. Adds existing `FamilyJourneyDiary.momentToggle` action to Settings > Photos/Data. Original feature handlers untouched.
- **Verified**: ZIP CRC, APK v2 RSA signature + content digest, original signing cert, resources alignment, DEX internal SHA1/Adler and unchanged bytes, exact diff; Node syntax and isolated Chromium mock date/GPS/address switching + capture toggle + URL call, PASS. **Not verified**: PackageManager install, actual Galaxy native URL, media capture/photo operations, data preservation under update. Claim only `APK_SIGNED_STATIC_PASS`; user R119 `DEVICE_INSTALL_FAIL`.
- Chat-only APK delivery paths generated and verified locally. Actual recipient download/install confirmation pending. No email. No uninstall, data clear, or AirPods source edits. Emergency rollback-forward should only be generated from exact R117/R115 after a proved regression, not guessed.
- Separate handoff `MOA_R121_R119_INSTALL_FAIL_REPAIR_HANDOFF_20261106.md`; private keys deliberately omitted from GitHub and source QA ZIP.

### 2026-11-06 — R121 private archive completed + Globemark/TimeTree research (DOCUMENTATION, NOT INSTALL SUCCESS)
- Files Library API returned `succeeded` for exact signed R121 beta `/모아_프로젝트_근거_20261103/MOA_R121_INSTALL_REPAIR_BETA.apk`, no-key source ZIP, and QA JSON. Original signed APK SHA256 remains `3e85d68ad652c5a55eafe01ec31ecbc2129bbea0e56a76eca70c4594b89a094a`; Galaxy `DEVICE_INSTALL` remains NOT TESTED.
- Inspected user-provided Globemark v1.2.0 split package (`com.novalabs.globemark`) and TimeTree v15.34.1 (`works.jubilee.timetree`), researched official product behavior. Independent technical design at `MOA_GLOBEMARK_TIMETREE_ARCHITECTURE_AND_PHASED_ROADMAP_20261106.md`: add family calendar with separate IndexedDB, opt-in backend sync, original photo ID links and lazy-loaded globe derived from validated GPS; no third-party code copied, no changes included in R121.
- R119 real device INSTALL FAIL and unresolved PackageManager reason remain open; current Golden R115 unchanged, R117 source baseline preserved. Release gate requires user R121 in-place device result before more feature APKs.



### 2026-11-06 — R121 USER GALAXY RESULTS → R123 calendar/GPS/NAVER correction (R123 DEVICE PENDING)
- **Actual R121 Galaxy screenshots** `19091.png`, `19098.png`, `19100.png`, `19102.png`: R121 **installed and displayed original diary/gallery/date/addresses** (DEVICE_INSTALL_PASS and limited PHOTO_VIEW_PASS). R121 calendar first screen is cut below bottom nav in curated and automatic modes **FAIL**; R121 native `nmap://map` external link **FAIL**, toast `등록되지 않은 외부 서비스 연결은 차단됩니다.`; one photo showed `사진 원본 GPS 없음`. Do not infer photo really lacks GPS; this is index lookup, not EXIF inspection.
- **Confirmed source root**: Original `family-diary.js/css` large `fd23-header/banner/hint` and min 78px date cells push 5-6 week rows below viewport. R121 `coords()` reads only `FamilyJourneyExtension.getData().photos` mapped GPS subset, marks absent index as original GPS absent, and its 1s retry refreshes *only time*. R121 `NativeHost.openUrl(nmap://...)` is blocked on real device; existing `fj-naver-favorites.js` uses HTTPS Naver search handler.
- **R123** same package `com.juhyeon.familyjournea`, code123, 5,417,671 bytes, SHA256 **`f9f2553dda70fb0eb8f48787173b0c8593aa590233c4004fe20c3947fadbf58f`**, original cert SHA256 `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`. From exact R121 SHA `3e85d68ad652c5a55eafe01ec31ecbc2129bbea0e56a76eca70c4594b89a094a`; original R121 **104/107 ZIP members byte-identical**, modified only Manifest versionCode (121→123 one byte), HTML CSS link and existing `moa-r121-ui.js` overlay. Added only `moa-r123-ui.css`; no DEX, diary DB, photo index, media engine, launcher or native changes.
- New calendar CSS compresses vertical spacing, sticky chooser retained, original Today/Backup buttons and original statistic banner are **moved intact below** grid; both modes inherit layout. Gallery GPS absence now says `지도 색인에서 이 사진의 GPS 미확인 · 원본 GPS 여부는 미검증`, re-polls current photo index, no made-up location; native EXIF per absent-index image still NOT IMPLEMENTED. NAVER HTTPS URL route uses existing `NativeHost.openUrl`; direct NAVER app open not yet physically proven.
- Independent APK v2 RSA signed-data signature, full content digest, cert, ZIP CRC, 37 STORED alignment, DEX SHA1/Adler and unchanged DEX resources PASS. Chromium mobile 393×852 6-week mock shows last cell bottom 589px vs scroll root bottom 785px, actions and stats below grid, late index GPS refresh, HTTPS Naver call and no-GPS correct status PASS. **R123 Android install / real photo / NAVER link / original full features PENDING**, NOT Golden.
- R123 APK + no-key source/QA zip + JSON + detailed handoff **confirmed uploaded to private Library** `/모아_프로젝트_근거_20261103/`; source QA ZIP SHA256 `b7bbaf87d3cfa115776f76688080351c9e83152a2b63215792099fb83cc30efe`. Private R124 emergency rollback-forward based on exact R121 with only versionCode 124, SHA `8d7e241fabf34e4dfd97afb72e2665c4644235e856509300b87f71519969a072`, NOT normal installation, also archived. No email, no private keys GitHub.
- User explicitly corrected new family calendar to be an **independent fifth bottom tab**, not under `기록`; record untouched. Loglog uploaded APK `com.klarwerk.loglog` 1.0.10 inspected, actual Capacitor/Supabase Postgres Changes + outbox evidence, 100ms guaranteed sync NOT demonstrated. See `MOA_R123_R121_DEVICE_FINDINGS_HANDOFF_20261106.md` and `MOA_LOGLOG_REALTIME_SYNC_TECHNICAL_REVIEW_20261106.md`. All R115/R117 Goldens untouched.


### 2026-11-06 — R123 GALAXY CALENDAR PASS / R125 stable swipe + calendar quick jump + backup UX, SIGNED BETA
- User real screenshot `1793950295768.png`: installed **R123** curated calendar August 2026 shows **entire 6-week grid** and backup/statistics below; confirm **R123 CALENDAR DISPLAY PASS**. It does not verify Naver external link or full original features.
- User real `19118.mp4` (~7.06s, 23/53→31/53 images) shows visible sideways photo translation, adjacent photos and black gaps on each full-screen gallery swipe; original R123 gallery **SWIPE STABILITY FAIL**. Original `fj-naver-favorites.js` updates current `img.style.transform=translate3d(dx...)` and neighbor `src` on each `touchmove`; its `move` animates both huge photo panes then resets/re-renders after 210ms. Original diary `exportNotes()` calls Blob download anchor; user reports pressing `일기 백업` has **NO VISIBLE RESPONSE**, native save operation not confirmed.
- **R125** candidate from exact R123 signed APK SHA `f9f2553dda70fb0eb8f48787173b0c8593aa590233c4004fe20c3947fadbf58f`. New APK `MOA_R125_VIEWER_CALENDAR_BACKUP_BETA.apk`, **5,424,044 bytes**, versionCode **125**, SHA256 `eb2e2660f361bd125c669b0bc4f2d512ce176cc0ea938fe9d8aea36447d30540`, original certificate `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`. Changed **only three** original R123 members `AndroidManifest.xml` (typed versionCode), `assets/web/index.html`, `assets/web/fj-naver-favorites.js`; added `moa-r125-calendar.js/css`. Original **105/108 ZIP members byte-identical**, including 5 DEX, resources, `family-diary.js/css`, all user data writers, existing GPS/NAVER overlay.
- Viewer no longer drags full-stage photo/neighbor on touch move; changes src exactly once after horizontal swipe, fixes jitter candidate, pinch zoom/pan retained. Calendar grid horizontal gestures, scrollable 1900–2100 year selector, month picker, Today/button preserved. Backup now offers visible modal, exact diary-v3 JSON (notes, curated notes, photo/video IDs, covers, no original media), app-local separate `moa-diary-local-snapshots-v1` IDB write/readback, conditional `navigator.share(File)` or JSON copy. Clear notice: local backup is erased by uninstall/data clear, and no full external media backup exists.
- Independent APK v2 RSA SHA256 signature/content digest/cert, ZIP CRC, resources alignment, DEX internal hashes, member diff PASS. Chromium **isolated DOM mock**: direct 2024 March jump, swipe to April, stable image and next image, backup JSON and **mocked** IDB storage PASS. **Actual IndexedDB origin blocked in browser fixture, so real IDB was not tested.** R125 installation and actual Galaxy/Share/GPS/video-regressions PENDING, NOT Golden.
- **R126 emergency only** from exact R123 content with manifest versionCode126, same signer, SHA256 `84150f3be42b1fb82262c0e9c396a1ba014b83fdc6c6e21532fc44089b8d6df0`; not routine install. Original R115 and user R117 frozen. R125 APK, no-keys source QA, JSON and R126 verified uploaded to private Library; no email/no public keys.
- Handoff `MOA_R125_VIEWER_CALENDAR_BACKUP_HANDOFF_20261106.md`. User wants separate fifth family calendar tab, offline-first MVP, then optional PC/phone/spouse sync using Opt-In Supabase Auth/Postgres RLS/Realtime and outbox, Google Drive for explicit backups, later 2D/3D globe in Map. Those parts **not implemented in R125**.



### 2026-11-06 — User R125 GALAXY REGRESSIONS / R127 UI repair signed beta, DEVICE PENDING
- User screenshot `19128.png`, videos `19126.mp4` 17.01s, `19127.mp4` 8.95s, `19130.mp4` 11.93s: **R125 installed on Galaxy**. Visual **FAIL** year/month text overlaps after picker, map photo list shows previous page at top/bottom and user does not want inserted `네이버지도에서 장소 보기`, requires manual `사진 더 보기`; photo swipe metadata arrival seems to shift content; Android back from multiple pages falls to Map instead of Diary. Previous claims of R125 physical PASS for these specific functions are not supported.
- **Confirmed code roots:** R123 `.fd23-month button` 38px rule affects nested R125 year/month buttons, not only arrow buttons. R121 photo-info `min-height:57px` varies when async address or NAVER action appears and resizes flex stage. `#place-root .sheet.place` has 80vh max, background map shows outside. Map `app.js` loads 30 tiles only on `#place-more`, `family-addon.js` injects `#fj-place-map` action. `family-diary.js` root Back `close(true)` directly uses `__photoMap.showTab('home')`.
- **R127 candidate:** Exact R125 APK base SHA256 `eb2e2660f361bd125c669b0bc4f2d512ce176cc0ea938fe9d8aea36447d30540` → `MOA_R127_UI_STABILITY_BACK_DIARY_BETA.apk`, code127, size **5,427,950 B**, SHA256 **`29604d2ae37a1c66477e05d14f6a906842c9b9210ba3c5a6677ea8ca17e62171`**, package `com.juhyeon.familyjournea`, original signer cert SHA256 `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`. R125 original 110 entries: **108 byte-identical**. Only existing changes `AndroidManifest.xml` code125→127 and `assets/web/index.html` loader links; added `assets/web/moa-r127-fixes.js/css`, all old JS/native DEX/photos/diary DB unchanged.
- **Changed UX:** 3-column calendar month row with nonoverlap year/month hit areas; painted Diary canvas behind bottom tab to suppress old Map thumbnails; fixed 96px date/GPS info (long address two-line clamp), photo stage unchanged height during async address; Map photo sheet opaque fullscreen and scroll-to-auto-load original 30-card batches, hides ONLY redundant sheet `#fj-place-map` (keeps per-photo NAVER), old close handler reused; wrap existing native Back paths to return Diary root while preserving nested overlays and Diary day navigation.
- **Static/mocked PASS:** independent crypto v2 signature RSA/content digest/cert, ZIP CRC, 37 STORED alignments, DEX SHA1/Adler; Chromium fixture 393×852 year/month layout noncollision, stage 613px unchanged before/after geocode/photo transition, sheet count 30→90 by scroll, back at diary root retained and other-root diary open. **Actual Android R127 install, gallery scrolling, map sheet and back PENDING**.
- **Recovery only:** R128 exact R125 content except higher code128 manifest, SHA256 `fe74ee8804856e12b1a24336b8b366e3d6888b94f01d360f5642d0250a7eedae`, 109/110 bytes unchanged, not routine update. R115 Golden and R117 user tested frozen. Signed R127, keyless source/QA, independent verification, handoff and R128 uploaded successfully via Files Library; artifact availability still subject to actual user download test; no Gmail/email.
- Next independent feature scope **fifth 가족 일정 tab** offline-first month/week/day CRUD + separate IndexedDB planned for code >=129 only after current beta regression; opt-in Supabase Auth/RLS/realtime PC/spouse and Google Drive backups later, not bundled now. Loglog 0.1s claim remains UNVERIFIED. Technical handoff: `MOA_R127_DEVICE_FEEDBACK_UI_REPAIR_HANDOFF_20261106.md`.



### 2026-11-06 — R127 USER INSTALLED, MAP SHEET REGRESSION / R129 exact narrow repair, DEVICE PENDING
- User screenshot `19128.png` (original expected rounded Map place photo sheet) and `19138.png` (full-photo viewer) plus explicit report: **R127 installed, other modifications generally work**, but our R127 fullscreen place sheet replacement contradicts request. User wanted the **original Map place photo popup retained** and **within that same popup scroll down to see all photos**, not repeated `사진 더 보기` click. Hide only the popup's bottom `네이버지도에서 장소 보기`, not per-photo NAVER.
- Source root CONFIRMED: R127 `moa-r127-fixes.css` replaced `.sheet.place` with `inset:0;height/max-height:100%;border-radius:0`, hid `.dim/.handle`; `moa-r127-fixes.js` injected second Close and paging label. Original `app.js::morePhotos()` is an intact 30-thumbnail batch loader and underlying original sheet/handlers remain in DOM. Root bug was **UI scope**, not photo engine.
- R129 `MOA_R129_ORIGINAL_PLACE_SHEET_SCROLL_FIX_BETA.apk` package `com.juhyeon.familyjournea`, code129, **5,427,709 B**, SHA256 **`54d0323e6ea7ab8be8bc1323a8a24ff364cb04ea643a7535ce7e78e173d16579`**, same cert `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`; base exact R127 SHA `29604d2ae37a1c66477e05d14f6a906842c9b9210ba3c5a6677ea8ca17e62171`. 112/112 APK members present; **109 BYTE IDENTICAL**. Changed 3 only: binary `AndroidManifest.xml` versionCode 127→129, `assets/web/moa-r127-fixes.js`, `assets/web/moa-r127-fixes.css`; no new modules/index loading, no DEX changes or data migration.
- New CSS restores original rounded **80dvh** bottom sheet and Map dim, original header/visit info/3-column photo grid and single original Close. Hides only `#place-more` and `#fj-place-map` within sheet. Original built-in batch loader is called programmatically by near-bottom scroll, **no manual click**; no extra full-screen page or extra close/status.
- Chromium 393×852 isolated DOM mock: original sheet top170px / height681.6px (80vh), radius22px, Map dim visible, More/NAVER hidden while original Close works, continuous scroll yields **30→60→90→120→141 total**, PASS. Real photo thumbs/media data and actual Galaxy R129 not tested. Independently recomputed APK v2 RSA signature/content digest and old certificate, ZIP CRC, 37 STORED member alignments, original 5 DEX SHA1/Adler and exact old content diff PASS.
- APK/QA source ZIP/independent verification/handoff + **emergency-only R130** based on exact R127 (code130, SHA256 `3a93bfd0b10ee3f7cb7d72d10ca79d3a04dc138edb344406fe2793e9b113acc8`) uploaded successfully to private Library, **delivery/install on user phone still PENDING**. R130 recovers the previous R127 source behavior (including old wrong fullscreen sheet), not an alternative fix.
- Golden R115, confirmed R117 and AirPods source unchanged. Follow-up development **family calendar independent fifth tab** code>=131, later PC/Supabase/Drive sync and Globe; no new feature added to R129. Handoff `MOA_R129_PLACE_SHEET_RESTORE_HANDOFF_20261106.md`.


### 2026-11-06 — R129 user accepted Map photo scrolling / R131 Diary auto scroll SIGNED BETA, DEVICE PENDING
- User reports R129's original Map rounded place-photo sheet continuous scroll verified and asks to replicate within Diary; prior Map viewer/Diaries are protected.
- Source root: family-diary.js renderDay() groups media in five-minute sections with initial 12 photos and original 30-at-a-time manual fd31-more button; renderPicker() already binds 60-at-a-time automatic scrolling but shows an unnecessary fd32-more button.
- R131 uses a new scoped passive diary root scroll watcher to click each existing day group fd31-more button as it nears visible viewport, then waits before next batch. The original handlers, time groups, selection, picture source IDs, notes, cover actions, data and video behavior remain unchanged. Picker retains original auto loading, redundant control only visually hidden.
- Base exact R129 SHA256 54d0323e6ea7ab8be8bc1323a8a24ff364cb04ea643a7535ce7e78e173d16579; signed new R131 APK 5,429,713 bytes, code131, SHA256 eb9693092c75a88acab51fc19c0c716e11262aeaca1e9416952a6781b80e680c; same package com.juhyeon.familyjournea / cert 5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15. Of 112 R129 APK entries, 110 byte-identical. Modified only AndroidManifest.xml version and assets/web/index.html loader. Added moa-r131-diary-scroll.js and .css. No DEX, resources, family-diary.js/css, app.js, native/diary storage or R129 Map sheet files modified.
- Node syntax PASS; Chromium mobile 393x852 isolated DOM mock PASS 137+68 sample photo tiles across two time groups with original batch closures and scroll-only auto paging. Independent APK v2 RSA signature/full content digest, exact original certificate, ZIP CRC, 37 STORED alignment and DEX SHA1/Adler PASS. Actual Galaxy installation/diary functionality NOT TESTED (beta).
- APK, keyless source+QA ZIP, reports, handoff and emergency-only R132 (R129 unchanged except manifest code132; SHA256 27266d1fbddac0e7a7dba39c4f4863bcae1049e8270ed975b4a7c6857c3e515c) uploaded to private Library with succeeded status. Current-chat direct APK and fallback ZIP created+verified, actual user download PENDING, no email or private key publication.
- Full handoff: MOA_R131_DIARY_CONTINUOUS_SCROLL_HANDOFF_20261106.md. Next independent family calendar fifth tab release starts >=133; no TimeTree/Loglog/Globe feature was silently bundled in R131.
