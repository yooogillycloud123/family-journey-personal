> **2026-11-06 newer MOA corrections:** User R121 device install PASS but 6-week calendar clipped & R121 nmap native launch blocked. R123 same-cert beta code123 SHA `f9f2553dda70fb0eb8f48787173b0c8593aa590233c4004fe20c3947fadbf58f` has independent crypto/static & browser-mock PASS, Galaxy install pending. Relevant: `MOA_R123_R121_DEVICE_FINDINGS_HANDOFF_20261106.md`. User requires independent 5th **가족 일정** bottom tab, not `기록` subview, and future opt-in sync based on Loglog package evidence. `MOA_LOGLOG_REALTIME_SYNC_TECHNICAL_REVIEW_20261106.md`. No existing Galaxy data or native code changed.

> **2026-11-06 MOA R115 USER DEVICE GOLDEN CONFIRMATION:** User has now reported completing R115 real-device verification and explicitly accepts it as the ongoing development Golden. **STATUS: R115 USER-CONFIRMED DEVICE GOLDEN (overall user-reported PASS)**, superseding earlier provisional **visual-only / functional verification pending** labels *as a general acceptance status*. Exact APK remains unchanged: versionCode115, SHA256 `1118bdc249e2d941a899518e58be0185b120a887ff2c371c8f5a01037a5002a8`, same installed package and signer, frozen private Library APK. The user's statement is evidence of their overall real-device validation; no individual test-case log was provided, so do **not** claim independently measured photo/diary/STT/OHO/9-theme results or fabricated screenshots. Preserve R63/R83/R89/R96 historical Goldens. Future regular code >=117. Always read `MOA_R115_NEXT_CHAT_START_HERE_20261106.md` and the append-only release ledger first. 

# MOA — Architecture, Regression Map, UI Contract & Extension Roadmap
**Edition 2026-11-06. Active baseline: R115 user-approved visual Golden.** Based on actual R115 APK member inventory and recorded physical tests. Do not infer runtime capabilities beyond evidence.

## 1. Product identity / durable boundaries
- Installed live app: **MOA / 모아**, package `com.juhyeon.familyjournea`, original certificate SHA256 `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`. Golden file `MOA_R115_USER_APPROVED_VISUAL_GOLDEN_20261106_DO_NOT_MODIFY.apk`, SHA256 `1118bdc249e2d941a899518e58be0185b120a887ff2c371c8f5a01037a5002a8`.
- Keep one existing app/package and persistent user data. Native Android layer is an installed signed APK with **five DEX files** (`classes.dex` through `classes5.dex`), `AndroidManifest.xml`, `resources.arsc`, `res/` and locally bundled `assets/web/`.
- IMPORTANT: public GitHub `android/` prototype uses `com.familyjourney.personal`; it is not the installed `com.juhyeon.familyjournea`. Its current Gradle build cannot be substituted for live R115; start a *controlled, hash-reproducible* build migration only as a separate future engineering task, never overwrite Gold.
- Public GitHub is for **source patches, handoffs, test harness, non-secret metadata**. Real signed APK and signer backups reside privately in project Library. No private signing key, family pictures, recordings, private locations/account details, or original uploaded proprietary app binaries on a public repo.

## 2. R115 actual APK component map — verify by extracting immutable artifact
| Component | Actual member(s) | Responsibility / caution |
|---|---|---|
| Android launcher, aliases, native features | `AndroidManifest.xml`, `resources.arsc`, `classes.dex` … `classes5.dex` | Android app/package/permissions, launcher themes, native voice/memo/camera integration. Binary AXML and DEX structure must be parsed and signed correctly, not string-replaced blindly. |
| App WebView / root UI | `assets/web/index.html`, `app.js`, `style.css`, `native.js`, `host-bootstrap.js`, `host-monitor.js` | App pages, launch/first paint, navigation and native WebView integration. Scope CSS/JS edits and guard startup behavior. |
| MOA branding | `assets/web/moa-r32-brand.css`, `moa-r32-ui.js` | Existing family/peach style and splash layout. Do not flatten whole app theme during icon fixes. |
| Photo diary & calendar | `assets/web/family-diary.js`, `family-diary.css` | UI and backed storage for record/calendar, day cards, 5-minute notes and editor controls; historic R63/R71/R96/R99 behavior to preserve. |
| IndexedDB direct memo capture | `assets/web/moa-direct-diary-commit.html` | Protected original per-media ID/timestamp/memo commit path. Do not change IDs or timestamps, wipe/auto-migrate database, or remove records. |
| Theme selector | `assets/web/moa-icon-theme-settings.js`, `.css` | Settings > App > icon chooser. JS calls **`window.MoaIconTheme.apply(id)`**, persists key **`moa.icon.theme.applied`** to localStorage only after native returns `OK`. 9 valid IDs; read back selection on next startup. |
| Selected splash artwork | `assets/web/moa-icon-themes/*.png` (9) | Clean ~768×768 composite, independent from launcher adaptive foreground. `index.html` selects image by saved theme on startup. R115 loads CSS in head and constrains splash IMG **180×180 from first paint**. |
| Nine launcher themes | `res/mipmap-anydpi-v26/moa_*.xml` and `res/mipmap-nodpi/moa_adaptive_fg_*.png`/`moa_adaptive_bg_*.png` | XML adaptive icons separate FG/BG; bitmap layers must be **`nodpi=0xFFFF` in `resources.arsc` binary configuration**, XML `anydpi=0xFFFE`. Center wordmark in mask safe zone. |
| Historic features / auxiliary | `assets/web/owner-*.js/css`, `fj-*.js`, `res/xml/moa_shortcuts.xml`, widget resources, `classes4.dex` | Native and web integrations, OHO/shortcuts/widget etc. Preserve unless current user request directly targets them. Some historic experimental NAVER features are **not** proven fully invisible / background successful. |

## 3. Visual design contract — nine themes (do not "improvise" without request)
Styles: **A modern bold / B slim premium `MOΛ` (Λ no crossbar) / slim minimal glass**. Each has **pink, black, white** variant. R115 is the approved appearance; copying icons out of tiny promotional screenshots is forbidden. 
- Home launcher **sharp**, FG wordmark centered, far enough inside dynamic One UI mask. R113 solved clipping with 768px glyph alpha bounds approx bold x170..598 width428, slim x174..594 width420.
- Colors and gradients should be compared on *actual small-scale preview* as well as source pixels. White/black backgrounds neutral except intentional glass glow. No black ghost, cropped captions, duplicate rounded square, halo outside mask, or distorted MOA glyph.
- Theme must be consistent on (1) settings preview, (2) Samsung launcher home and app drawer, (3) startup splash. These are different resources. **A static icon preview PASS is not native launcher PASS.**
- Startup first paint R115: stylesheet `moa-icon-theme-settings.css` linked in `<head>` and critical `#moa-launch .moa-lockup img` width/height constrained before late scripts; do not put essential first-frame CSS after splash markup.
- Preserve original app skin `moa-r32-brand.css` and all diary controls while working on icon themes.

## 4. Data safety & continuity
- **No uninstall, clear storage, package rename, signing-key rotation, or replacement app.** These could make existing private app data inaccessible.
- The user previously confirmed essential earlier versions: photo + same media ID / correct shooting date + memo IndexedDB saved (R63), native diary speech (R83), native keyboard-aligned memo Mic/Clear/Save and confirmation (R89). These are different physical test scopes; no claim that every R115 path is confirmed.
- Keep exact media IDs and image timestamps; never silently combine/replace 5-minute note groups; preserve existing diary titles/body/cards and non-destructive editing.
- To add new storage, prefer **additive, opt-in and namespaced** IndexedDB object stores/keys, idempotent migration with dry-run/backout/test fixtures. Old DB and originals remain source of truth; never infer deletion from missing thumbnail.
- For logs, don't export private family images, record text, GPS, device IDs, phone numbers or signing materials publicly.

## 5. Actual regression checklist for next device test (R115 status currently PENDING)
Record each as `PASS / FAIL / NOT TESTED` with screenshots/log version context, **never default PASS**.

### Installation / Launcher / Splash
- Verify versionCode and signer, in-place install and old records retained.
- Home dock/app drawer wordmark centered, sharp, no clipped edges for A/B/Glass × all 3 colors.
- Settings select changes launcher icon; dark/white/pink each persist after app restart (launcher cache latency allowed, not infinite).
- Startup from cold launch shows clean selected color and 180px icon; no 768px popup/blank flash, transitions to correct page.

### Diary / Photos / Camera / Data
- Open pre-existing diary entry and correct date, title, text, 5-minute memo, photo order/media ID.
- Capture a new photo **only if user chooses**, use native `바로 기록`, write a memo, confirm it attaches to the correct image and actual timestamp; reopen app, read back from IndexedDB; no duplicates.
- Calendar month grid renders without blanking; day cards/thumbs load, survive reload, and tapping correct card opens original photo.
- Edited title/body/5-minute note persist; clearing only current field requires confirmation; cancel does nothing; deleting one diary requires the original destructive confirmation, never immediate deletion.
- Native memo screen Mic/Clear/Save remains above Samsung IME, Korean STT populates expected field; no unintended Web Speech fallback.
- Draggable top/bottom diary navigator jumps, lock/drag/position persist; settings `<details>` accordion is initially collapsed and controls respond.
- OHO / lockscreen camera / widget behavior tested only if the user uses these flows; never mark entire area proven by older unrelated screenshot.
- Offline/no-network basic UI and access to saved records preserved; no change to original AirPods project.

## 6. Maintainable next updates and expansion
**Backlog, not implemented by this document**:
1. **First complete R115 regression test evidence**, classify actual failures precisely, promote from visual Golden to full functional Golden only when truly demonstrated.
2. **Reproducible build pipeline**: capture source reconstruction from exact signed R115, patch chain (R89→R99→R100–R115) with SHA-pinned inputs and no signing secrets, compiled AXML/aapt2/D8 + zipalign + v2 verification. CI should test static resources/DEX, not generate a different package prototype and call it MOA.
3. **Automated gates**: asset alpha bounds, One UI masks at mdpi–xxxhdpi, palette/contrast, all 9 adaptive resource IDs, XML`targetActivity`, bitmap density, first-paint CSS, index/integrity, signature and package, golden members diff, realistic user download.
4. **Observability**: privacy-preserving in-app optional diagnostics and safe export for package version, route status, theme, native bridge version, IndexedDB key readback health; no private content by default.
5. **Data protection**: opt-in offline backup/restore of user records and privacy-safe migration test, no unconsented change to original stores.
6. **Optional feature ideas only when asked**: photo-diary based English learning with text/voice/pronunciation linked to user-created photos, user-defined navigation UX improvements, reusable widgets; keep experimental NAVER background-save effort on hold per user priorities.
7. **Release policy**: each update one narrowly scoped feature, exact binary diff, user visible results, separate tests; reserve rollback-forward **next code** and never regress previous Golden.

## 7. Sources and required reading
- `MOA_R115_USER_APPROVED_VISUAL_GOLDEN_LOCK_20261106.md` — active Golden identity and exact frozen bytes.
- `MOA_R115_SPLASH_POPUP_FIRST_PAINT_REPAIR_HANDOFF_20261106.md` — current patch and reproduced first-frame test.
- `MOA_RELEASE_FAILURE_LEDGER_AND_BUILD_GATES_20261106.md` — why earlier APKs failed and test gates.
- `MOA_RELEASE_LEDGER_CURRENT.md` — append-only per-version evidence; update **every** time.
- `MOA_R63_USER_DEVICE_GOLDEN_LOCK_20261103.md`; `MOA_R83_USER_DEVICE_GOLDEN_LOCK_20261104.md`; `MOA_R89_USER_DEVICE_GOLDEN_LOCK_20261104.md`; `MOA_R96_TOP_BOTTOM_DRAG_LOCK_RELEASE_HANDOFF_20261105.md`; `MOA_R99_SETTINGS_ACCORDION_TOUCH_FIX_HANDOFF_20261105.md`.
- Signed APK, all-member SHA and prior independent R115 verification in private Library `/모아_프로젝트_근거_20261103/`.
