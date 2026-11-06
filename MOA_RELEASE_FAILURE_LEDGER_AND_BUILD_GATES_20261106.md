# MOA — Failure Ledger, Release Gates & "NEVER AGAIN" Engineering Rules
**Active from 2026-11-06. READ BEFORE EDITING, SIGNING, OR SENDING ANY APK.**
**Canonical installed/visual baseline: R115 USER-APPROVED VISUAL GOLDEN; functional regression verification pending.**
Sources: user's actual Galaxy screenshots and ADB error; archived R99/R100–R115 APKs, binary diffs, per-release handoffs, Chromium first-paint tests. Do not upgrade a hypothesis to a proved physical cause without new device evidence.

## A. Concrete mistake → evidence → repair → permanent regression gate

| Version / phase | What failed or was wrong | Evidence / exact cause | Effective change and what it does *not* prove | PREVENTION / mandatory gate |
|---|---|---|---|---|
| **R100 (first 9 themes)** | Android installation rejected: `INSTALL_PARSE_FAILED_MANIFEST_MALFORMED`, `<activity-alias> does not specify android:targetActivity`. | **Actual Galaxy shell** `pm install -r` result. Binary-AXML resource map IDs were appended without filling the string-pool indices, so `targetActivity`/ `enabled` literal names were present but framework IDs were absent/misaligned. String presence, ZIP CRC and v2 signature mistakenly marked "PASS". | **R102:** pad/fix resource-ID map for proper `android:targetActivity`, `enabled` binding; fix static method placement in classes5.dex. Device installation later advanced. | Parse with **Android PackageManager or official aapt2/aapt** whenever possible; verify each alias target is declared and resolved, resource IDs and manifest typed attrs; do not treat plain string decoding as valid Android parse. Capture exact `pm install -r` error before guessing. |
| **R102** | 9 settings icons visually diverged from the approved poster; launcher icon unreadable, launch screen still old family drawing. | User screenshots; developer-drawn replacement SVG diverged; initial original splash image was separately hardcoded in `index.html`. | **R103** connected theme selection and startup screen; later fixes were required for quality. | Approval design is a contract for typography/palette/effect; QA 3×3 matrix against the exact source, and verify **three surfaces separately** (settings, launcher, splash). |
| **R103** | Black shadows/letter remnants, blotted edges, inconsistent white/black/pink shades. | Crop code took ~150px icons *plus surrounding poster artwork and labels* and enlarged to 512/768px, so artifacts were baked into files. Device screenshots 18983/18991. | **R105–R107** rebuilt glyph, background and glints from layered high-res assets; intermediate attempts lacked adequate glass gloss; R107 still blurred in One UI. | NEVER scale tiny screen-shot crops or reuse promotional poster as production bitmap. Inspect at transparent borders and 1x app-icon size; assert no unwanted nontransparent pixels outside rounded zone, no stray text, and match approved 9-color/palette/Λ geometry. |
| **R107** | Icon raster 512px looked sharp as image file but was mosaicked in Samsung dock, app drawer and package previews. | User screenshot 19002/19004. Nine launcher aliases were direct PNG under `mipmap-anydpi-v26` rather than adaptive-icon XML layers. | **R109** introduced 9 `<adaptive-icon>` XMLs and foreground/background PNG layers. Still blurred in actual Samsung launcher. | Always design launcher as Android resource **and** pixel art. Compare a known-good app's resource *layout*, not reuse copyrighted icons. Verify all alias icons XML and density-specific resource table mapping; check installer thumbnail as well as home/app drawer. |
| **R109** | Even with 768px foreground/background assets, icon extremely pixelated. | Actual binary `resources.arsc`: 18 `res/mipmap-nodpi/*.png` were encoded under **ResTable_config.density=0xFFFE (anydpi)**, sharing XML config, despite path reading `nodpi`. Device 19014/19016 + malformed resource evidence. | **R111** split resource config: 10 XML IDs `anydpi=0xFFFE`, 18 PNG IDs `nodpi=0xFFFF`. User 19019/19025 showed dramatically sharper icon. That supports the density fix. | **Never trust folder names alone**: inspect binary resource table density configs. Bitmap mipmap resources must not inherit XML `anydpi`. Test rendered 48–192px icons from built APK, then device installed launcher/installer. |
| **R111** | Home `MOA` wordmark oversized/clipped by Samsung launcher mask; splash still has faint black blotches/top-right arc. | User 19019/19023/19025; 768px foreground alpha x=102..665 (563px wide =73.3%) beyond safe centered visual area; legacy splash still used dirty bitmap. | **R113:** center glyph into x≈170..598 (bold width428) / x≈174..594 (slim width420); recompose all nine clean transparent 768px splash icons; preserve R111 density fix. | Apply launcher mask safe-zone test for **ALL NINE** variants. Inspect splash PNG independently from launcher foreground; don't assume changing adaptive icon changes WebView screen assets. |
| **R113** | Opening MOA briefly shows a "popup"/huge pink MOA image (~0.7–1s) before normal launch/map. | User `19030.mp4`; `assets/web/index.html` loaded `moa-icon-theme-settings.css` at bottom of body; 768px raw IMG rendered before its 180px CSS, parent earlier ~154px. Chromium: R113 image 768px without late CSS and 180px after CSS. | **R115:** move stylesheet into `<head>` + critical CSS from first paint; browser with late CSS withheld renders 180px; user explicitly requests R115 GOLDEN. | Test **first paint with late CSS blocked**, not just final screenshots. Splash IMG size must be constrained before first network/asset/JS delay; run Chrome mobile 393×852 and multiple themes. Keep OS app-window animation separate from oversized WebView IMG bug. |
| **R100–R115 recurring delivery** | ChatGPT Android `Library file not found` even when APK exists and signed; had to send second current-chat attachment repeatedly. | User screenshots 18843/18845/18860/18993/19007/19033; local `/mnt/data`, Library upload, SHA/v2 PASS are not recipient access proof. | Direct current-chat generated file with verified exact bytes sometimes worked; no universal resolver fix established. | Don't reuse dead links, rename without validating, or claim recipient success from server-only tests. **NO GMAIL / EMAIL / DRAFTS** per explicit instruction. Deliver current chat only; user confirmation is separate release gate. If fails stop repetitive same method. |
| **Repeated misleading "done" / process regression** | Stopped at missing SDK, zip/source, or static PASS without usable APK; features broken by unscoped changes. | Conversation R100–R115. Installed R115 was achieved only after repeated full pipeline repair and user physical evidence. | Maintain true gates and actionable checkpoint even on failures. | For every task: identify actual current Golden, inspect existing outputs first, plan minimal patch, build/sign/verify, deliver exact file, collect real device feedback, checkpoint state. Never ask user to repeat a fact already provided. |

## B. Safe build workflow — required for EVERY next release
1. **READ-FIRST:** read `MOA_R115_NEXT_CHAT_START_HERE_20261106.md`, R115 Golden lock + inventory, this failure ledger, architecture map, current release ledger. Also observe project AirPods canonical read-first requirement without touching AA.
2. **FIND ACTUAL STATE:** current installed version (if reported), exact Library frozen R115 APK hash and 103-file inventory, prior failed/working artifacts, user evidence. Do not start from stale `android/` debug app (`com.familyjourney.personal` is a different package) or re-create solved resources.
3. **DEFINE SCOPE:** one clear requested behavior, target native/JS/XML/resources, allowed changed APK members, protected hashes, expected device proof, fallback. Ask only genuinely missing details; do not repeat known facts.
4. **PATCH COPY:** immutable frozen baseline unchanged; patch a working copy, no extra Android app, no data/DB reset. Keep `com.juhyeon.familyjournea` and exact signer certificate. Any classes.dex change must include full DEX checks and regression tests.
5. **STATIC RESOURCE GATES:** parse compiled binary Manifest with framework IDs, activity-alias `targetActivity`/enabled/roundIcon, XML typed attrs, `resources.arsc` density configs and resource ID indexes, DEX header SHA1/Adler32 and class methods, ZIP CRC, 4-byte alignment, SHA of protected member inventory.
6. **VISUAL GATES:** approved 3×3 icon artwork/palette; 9 foreground safe zones; no poster shadow residue; full splash clean alpha; One UI visual simulation; first-paint CSS withheld/slow tests; different styles selected; prevent first-frame 768px natural-size blink.
7. **SIGN GATE:** zipalign (when changing stored data), sign with **original protected key**, independently verify APK v2 signature AND content digest and certificate SHA; versionCode **>=117** and monotonically increasing (R116 reserved).
8. **DELIVERY GATE:** create exact file attachment in current conversation (not email), verify local path + size+SHA; explicitly label user open/download **UNCONFIRMED** until verified. If failed `Library file not found`, classify as delivery error and fix delivery separately from code.
9. **DEVICE GATES:** actual Android `pm install -r` (optional ADB evidence), in-place user-data preservation, actual launcher, splash, icon choice persistence, core regression cases. Never infer this from signing. Record screenshot/video/log and PASS/FAIL exactly.
10. **CLOSE:** append dated row to `MOA_RELEASE_LEDGER_CURRENT.md` (including failed builds, raw error, root cause, fixed-by link), update current handoff and read-first headers, Library immutable asset + manifest + no-keys tests, and retain recovery-forward before next feature.

## C. Issue diagnosis without guessing
- **Installer says app file problem**: use on-device ADB pairing+connect, then `adb shell pm install -r /data/local/tmp/test.apk` with exact APK copied via `adb push`/shell. Parse returned `INSTALL_PARSE_FAILED...` rather than 60 lines of generic SurfaceFlinger/PackageInstaller logs. Do not uninstall app.
- **APK icon blurred before install**: inspect compiled PNG and `resources.arsc` density; cannot be only launcher cache if installer thumbnail is already blurred.
- **Launcher crisp yet cropped**: check alpha glyph bounds within adaptive safe zone; not DPI.
- **Splash blotches / black edges**: inspect WebView splash bitmap `assets/web/moa-icon-themes/*.png`, not just Android adaptive icon.
- **Splash huge for a frame**: check CSS arrival order and native image width before CSS, distinct from normal OS transition.
- **Update denied due to mismatched signer**: compare actual signing cert, don't rotate private key or uninstall.
- **Unexpected missing data**: stop installing; confirm package/UID, old records and IDB lifecycle. No storage clear, "remove app" or photos re-import without express instruction.
- **`Library file not found`**: ChatGPT attachment reference failure; APK compilation does not fix this. Strict in-chat only and never email.

## D. Release note template — fill ALL fields, no guesses
```text
DATE / REQUEST / DEVICE:
CURRENT EXACT GOLDEN (APK SHA, bytes, code, cert):
NEW VERSION (code > previous and reserved):
FROZEN INPUT / OUTPUT SHA+BYTES:
SCOPE AND ALLOWLIST APK MEMBERS:
ACTUAL CHANGES + PRE/POST MEMBER SHA (changed/unchanged/add/delete):
ACTUAL USER EVIDENCE + WHY FAILED (not just assumption):
ROOT CAUSE LEVEL: CONFIRMED / SUPPORTED HYPOTHESIS / UNKNOWN
REPAIR & RETEST:
MANIFEST/RESOURCES/DEX/ZIP/SIGNATURE: PASS / FAIL / NOT_TESTED, methods:
JS/RENDER/FIRST-PAINT/ICON-SAFETY REGRESSION: PASS / FAIL / NOT_TESTED:
DELIVERY: FILE_EXISTS / LINK_OPENED / USER_DOWNLOADED, separate:
INSTALL ON USER DEVICE: PASS / FAIL / NOT_TESTED:
NEW FEATURE ON USER DEVICE: PASS / FAIL / NOT_TESTED:
LEGACY FEATURE REGRESSION: PASS / FAIL / NOT_TESTED:
RECOVERY CODE/SHA + its LIMITATIONS:
LIBRARY FILE PATH (signed) + NO-KEYS SOURCE/TEST:
GITHUB COMMIT + WIP/READFIRST UPDATED:
OPEN RISKS + NEXT EXACT STEP:
```

## E. Protected decisions
- No automatic R91 NAVER integration, no second helper app, no silent STT engine replacement, no downgrade of already working R63/R83/R89 paths.
- Avoid destructive actions even if older package tests are failing; the user's past actual diary/photo data are more important than cosmetic changes.
- Release correctness includes **recipient accessibility and functional continuity**, not just file integrity.
- Every failure is recorded in the same append-only ledger; never erase a failed version to make chronology look clean.
