# MOA R625 exact modified components — engineering handoff

## Evidence and requirements
User supplied actual R623 Galaxy screenshots `22642.png`, `22644.png` and 4.36s video `22646.mp4`. These show sticky bottom actions covering multiple media tiles, large lower-left zoom glyph, a dark Web preview whose thumbnail rail remains level and photo preview softness. User clarifies FAST ON/OFF is for **main preview photo motion**, NOT the bottom rail (always inertial). Wants same-photo rail lift/white frame and play/pause/seek on videos.

## Source confirmed root causes
- `r619RenderPicker()` appended the 2-button `footer` as last child and CSS `position:sticky;bottom:0`: it visually obscured photographs while scrolling. Now first child sticky top of `.moa-r619-picker-screen` containing selection count/instruction/actions.
- `.moa-r623-grid-zoom` 29x29 CSS pixels, now 23x23 visually. Selection Set and drag untouched.
- `updateRailControls()` coupled FAST to `.moa-r623-preview-rail.is-fast` scroll-snap, even though requested FAST for main image. Rail `scroll-snap-type:x proximity` now invariant; main frame still uses existing `shift(...steps)` FAST calculation.
- Rail `.active` had border but no Y-lift; now white edge and `translateY(-6px) scale(1.065)`. Rail scroll settles at nearest thumb; explicit suppression of programmatic smooth scroll events prevents re-entering old index (found and fixed during QA).
- `fillImages([photo],true)` requested size2048 but global visible-image retry could call small 260px thumb on same preview DOM node; `r472Paint()` lacked a quality floor and could repaint highres with lowres. Introduced original-image `content://media/external/images/media/:id` attempt then bounded fallback native 2048; ignore later low-res paints while original/highres already shown. This corrects a confirmed source **downgrade path**, but actual device full resolution is not independently verified.
- Existing preview video had only an optional button to inject `<video controls>`; now provides explicit play/pause, actual `currentTime/duration` scrub slider for `content://media/external/video/media/:id`, with video error handling and poster fallback. It does NOT add any new Android native video permission or data bridge; user-device success not yet proven.

## Protection
Parent exact signed R623 APK source; changed only AndroidManifest.xml and photo JS/CSS. 141/144 ZIP entries uncompressed contents byte-identical, 18/18 classes.dex unchanged. `r619CommitPicked` indexedDB writer unchanged and MediaStore IDs persist. No user photo/video in the test materials or public GitHub. R611 physical Golden immutable; Naver accessibility OFF/ON native host owner preserved.

## QA
Node --check pass; Chromium actual JS+CSS 360/390/412 viewport PASS sticky top position and 23x23 zoom; FAST ON main 9step vs OFF 1step; rail always kinetic; white active styling; video seek control DOM; first QA run uncovered rail auto-scroll index bounce, fixed by `railProgrammaticUntil`. Cryptographic APK v2 same original certificate, 18 DEX hash equality, 144 member ZIP CRC, stored data alignment PASS. Device tests remain PENDING for fullres photo access and content:// video playback. Signed original recovery R626 exact R623 payload + version only.
