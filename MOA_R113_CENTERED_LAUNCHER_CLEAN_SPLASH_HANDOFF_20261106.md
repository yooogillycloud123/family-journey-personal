# MOA R113 — centered launcher wordmark + clean splash — 2026-11-06

## User hardware result and scope
The user confirmed R111 finally fixes the Samsung Galaxy S26 Ultra launcher pixelation: screenshot 19019/19025 shows a crisp MOA wordmark. Remaining visible defects: wordmark on the home icon is oversized and clipped at the left/right sides, and the MOA splash tile (screenshot 19023) contains visible blotches/stray black arc near top right. User asks ONLY for these two visual fixes, preserving all diary/photo/calendar/voice/navigation functions; user explicitly has NOT yet verified those functions and plans to test after these visuals are fixed.

## Root cause confirmed from APK
- R111's adaptive foreground layer in 768×768 RGBA has alpha bbox x=102..665 (563px wide), occupying 73% of the layer; near the System Icon visible safe zone it becomes clipped. Other styles similar width.
- R111 splash reads `assets/web/moa-icon-themes/*.png` from index.html via existing localStorage, which held legacy poster-cropped PNGs with shadow/edge residues; Adaptive Icon resources do not fix the WebView splash.
- Preserve correct R111 `anydpi XML + nodpi PNG` density resource-table configuration; do not regress this.
 
## R113 exact APK
- `MOA_R113_CENTERED_ICON_CLEAN_SPLASH_BETA_Install.apk`
- versionCode 113, package `com.juhyeon.familyjournea`, size **5,406,652 bytes**, SHA256 `024f788ca890f1eccbc3a1cdd08aee5dbe78baf6b43dfaa5cf72d24ce32b7f25`.
- Original signing certificate SHA256 `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`.
- R111 source SHA256 `8056d4aff349f8745c2fd9da30c4c5106e0e2574202068870b07f9ca264384b0`.
- **Exactly 19/103 APK entries changed**: versionCode in `AndroidManifest.xml`, 9 `res/mipmap-nodpi/moa_adaptive_fg_*.png` foreground glyphs, and 9 `assets/web/moa-icon-themes/*.png` splash/preview PNGs. Other **84** entries byte-identical, especially `classes.dex` through `classes5.dex`, `resources.arsc`, `assets/web/index.html`, diary JavaScript and CSS, icon theme settings JavaScript and CSS, original IndexedDB commit html, and all 9 adaptive background PNGs.
- Adaptive launcher glyph pixel alpha bbox: bold x=170..598 width=428, B and Glass x=174..594 width=420, centered on x=384, inside Android foreground's recommended central safe region. Existing glyph shape and colors retained.
- Splash tile PNGs are recomposited at 768×768 from the *existing clean background gradients* plus the original glyph layer, with a smooth alpha-rounded tile mask. This removes the legacy poster-crop residues and black edge artifacts without changing the page markup, splash flow or CSS. All 9 selected themes supported.

## Verification
- Independently recomputed APK v2 RSA signature + SHA256 content digest, same original certificate: **PASS**.
- ZIP CRC and unchanged member comparison: **PASS**.
- All nine foreground central-zone bounding boxes: **PASS**.
- All nine splash PNGs have transparent outer corner pixels, opaque centers, 768px dimensions: **PASS**.
- `resources.arsc` unchanged means correct R111 density configs preserved: **PASS**.
- User Galaxy installation, visual center, splash quality, and existing feature regression: **NOT TESTED**.
- QA previews generated `R113_ONE_UI_ICON_SIM_9_QA.png` and `R113_SPLASH_9_QA.png`; screenshot simulation is **not** hardware proof.

## Emergency rollback
R114 rollback-forward built from exact R111 bits, only AndroidManifest versionCode 111->114 changed, size **5,486,972 bytes**, SHA256 `c7f6061fda0d634c034c52d8872123b93a4898d1b6561573388ff1503f047cab`. Same original cert. Keep private, NOT routine installation. Never uninstall existing MOA or clear data.

## Delivery
The user prohibits Gmail/email and wants APK only inside this ChatGPT conversation. Previous Android app returned `Library file not found` on some sandbox links. Create a current-turn file and present only as unverified until recipient opens; do not claim device download verified. Save R113 and rollback source/verification under private MOA Library as backup; that does not establish user-accessible download.

Do not change AirPods project code/Golden or user-confirmed MOA R89.
