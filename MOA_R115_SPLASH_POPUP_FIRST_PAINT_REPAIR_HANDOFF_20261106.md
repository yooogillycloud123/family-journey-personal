# MOA R115 — start-screen pop-up / oversized image flash repair — 2026-11-06

## Real device evidence
The user provided Galaxy S26 Ultra video `19030.mp4`, ~4.22 s. At ~0.7–1.0 s, during app opening, the in-app launch image is visibly **gigantic**, with a zoomed M and pink quadrant inside a rounded expanding Android window. By ~1.3 s, the splash has the correct dimensions and by ~2.5 s the normal map opens. This is distinct from an ordinary One UI window-opening animation.

## Exact root cause, reproducible
In R113's `assets/web/index.html`, the CSS `<link rel="stylesheet" href="moa-icon-theme-settings.css">` was appended **right before `</body>`** after all the large app scripts. The splash `<img id="moa-launch-theme-icon">` is declared at the top of the body and is 768×768 native pixels. Before that late CSS loads, `moa-r32-brand.css` styles the parent as 154×154 but **does not style the child IMG**, which thus renders at native 768×768 and overflows. As the CSS arrives, it jumps to 180×180. This causes the transient oversized/popup-like splash visible in user's video.

Headless Chromium mobile controlled first-paint reproduction:
- R113 with late CSS withheld: child IMG width **768px**, parent 154px.
- R113 with late CSS loaded: child IMG width **180px**.
- R115 with that CSS withheld: child IMG width **180px**.
- R115 with CSS loaded: child IMG width **180px**.
Thus exact cause/fix reproduced in a real browser without touching the native window animation.

## Exact R115 APK
- `MOA_R115_SPLASH_POPUP_FLASH_FIX_Install.apk`
- package `com.juhyeon.familyjournea`; versionCode **115**
- APK bytes: **5,406,744**
- SHA256 `1118bdc249e2d941a899518e58be0185b120a887ff2c371c8f5a01037a5002a8`
- User's currently installed/successful R113 baseline SHA256 `024f788ca890f1eccbc3a1cdd08aee5dbe78baf6b43dfaa5cf72d24ce32b7f25`.
- Original signing certificate SHA256 `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`.
- **Only two of 103 decompressed APK members changed**: `assets/web/index.html` and `AndroidManifest.xml` (versionCode). Exactly 101 unchanged, including `classes.dex` through `classes5.dex`, original `resources.arsc`, 9 launcher adaptive icons and 9 splash PNGs, diary JavaScript and CSS, IndexedDB writer, settings icon selection JavaScript/CSS, all original data and native functions.
- In `index.html`, move the existing icon-theme stylesheet link from bottom body to head, keep existing icon-theme JavaScript at bottom body. Add a tiny critical CSS style in the head constraining splash parent and IMG to 180px from first paint. No design, animation duration, or app logic changes.

## Verification
- Independently verified APK v2 RSA signature and full SHA256 content digest PASS; original signer matches.
- ZIP CRC, manifest versionCode115, HTML parser head CSS order, exact changed member diff PASS.
- Chromium mobile (393×852, 3x density) first-paint test reproduced R113 oversized 768px child and R115 corrected 180px child whether late CSS loads or not; screenshot `R115_FIRST_PAINT_MOBILE.png`.
- **NOT YET TESTED**: real Samsung install, final animation, and full diary/voice/photo/navigation regressions. User plans these tests; do not assert Golden.
- Standard Android/Samsung window expansion animation remains OS-controlled. This patch specifically prevents an abnormally zoomed WebView splash inside it.

## Reversible rescue
If R115 regresses, rollback-forward versionCode 116 `MOA_R116_EMERGENCY_RESTORE_R113_NOT_ROUTINE_INSTALL.apk` built from unchanged R113, Manifest version only, size 5,406,653 B, SHA256 `4273752b54a8aa2973a6d8a30e45af86e063bffdd034bb45c3c8c83247a1cf59`, same signer. Private Library only, not a routine install.

## Delivery rules
User forbids Gmail; deliver signed APK only directly in this ChatGPT conversation. In-app recipient accessibility is unconfirmed until user opens. Do not claim local path/link implies mobile download. Never uninstall existing MOA or clear app data. Keep R89 Golden, R111 density fix and R113 perfected icons unchanged. Do not touch AirPods project.
