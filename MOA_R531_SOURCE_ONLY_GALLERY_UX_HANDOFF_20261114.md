# MOA R531 source-only lab — 2026-11-14

## Provenance and exact status
- User supplied physical Galaxy videos: `21575.mp4`, `21576.mp4`; R483/R485 older APKs + R483 JS/CSS in conversation.
- Development source baseline: feature/moa-r527-push-geometry-session-fix-20261114; **not** R483/R485 APK downgrade.
- New feature branch: `feature/moa-r531-card-gallery-ux-experiment-20261114` (commit `cde024f406ed4ae6975930cfe6f1b04a435c66c3`).
- Golden unchanged: `golden/moa-r463-user-approved-20261113`; Android original Gallery code and R463 APK remain immutable.
- CI [43544364093](https://github.com/yooogillycloud123/family-journey-personal/actions/runs/43544364093): Java Android 35 javac/D8, JS node --check, static assertions **SUCCESS**.
- Only three source files modified plus new CI workflow: experiments/moa-r483/moa-r483-vertical-calendar.js/.css, experiments/moa-r507/MoaR507InlineGalleryProvider.java.
- **NOT SIGNED APK, NOT INSTALLED, NOT ON-DEVICE PASS, NOT NEW GOLDEN**. The exact R527 original signed baseline APK and original signing key are not present in the current accessible runtime, so producing a valid same-signer update APK is not established. Do not fabricate installability or re-sign with a different key. The supplied R485 emergency only restores R463 functional baseline and is not an R527 feature base.

## Code changes
1. Native R463 in-card gallery starts with its chrome folded, without installing any new on-touch interceptor; native original tap-to-toggle remains owner. No edits to protected Gallery DEX.
2. In-card photo remains fill/crop. In-card video restores original R463 FIT frame geometry, with low-resolution MediaStore video poster under a translucent texture and RenderEffect blur (API31+), avoiding full-frame crop. A muted dark canvas is fallback until poster loads. Web-only fallback uses a blurred copy of its own poster behind contained video.
3. Native rail toggle replaces unbalanced Unicode arrow with Canvas 3-thumbnail stroked symbol at density-aware scale; existing rail expanded state and handlers remain.
4. Native top-right icon displayed with chrome hands off to ORIGINAL R463 standalone fullscreen Gallery, preserving selected media index; closes the in-card renderer first and deliberately returns to same photo day when standalone Gallery exits.
5. R527 geometry push no longer suppresses alternate 120Hz frames with a 13ms throttle. Fallback native position no longer applies up-to-18dp predictive overshoot; uses exact pixel translation. CSS disables scroll anchoring on the card.

## No unverified success claims
- Java+DEX compile and JS syntax: PASS.
- APK original-signer v2 and install/update: NOT RUN.
- S26 native initial hidden chrome/tap, video ambient poster, full gallery Back, thumb symbol, vertical scroll and renderer performance, Android 17 video playback: NOT RUN.
- At the original R463 Gallery, full native swipe/pinch/zoom/share/GPS/voice/diary/NAVER must be regressions-tested after an actual signed package exists.
- Video black bars are treated with contain+ambient; if poster is inaccessible, neutral background may remain. No 60/120fps perfection claim due to separate WebView/native compositors.

## Follow-on required for installable build
- Recover exact original-signer signed R527 APK and secure original signing facility (never export key to chat), incorporate only additive calendar JS/CSS and compiled classes18.dex, increment versionCode beyond any installed rescue (>529), preserve original 17 DEX and protected asset hashes, v2 full-signature test, ZIP/DEX/manifest check, signed forward recovery exact R463 function.
- No uninstall/data/cookie wipe; do not install R483/R485 over newer code. Do not touch AirPods runtime.
