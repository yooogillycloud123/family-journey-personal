# MOA R633 / R634 R611 original Golden-preserving hotfix handoff — 2026-11-16

## Physical user report, highest priority
On installed R631 Galaxy S26 Ultra, after QuickRecord ("바로기록") the original Android native Gallery photo-day sometimes shows a still photo without the original native lower action strip or filmstrip. User recorded `22966.mp4`, screenshots `22968.png` and `22967.jpg`. User specifically requests move photo-add PICK/UNPICK from the floating top-right control INTO the ORIGINAL Android Gallery bottom glyph capsule. R631 UI improvements should not regress. **R631 is NOT physical Golden.**

## Original source comparison
- R611 physically approved Gallery Golden SHA256 `38a507cf2e88a235282ae4d9ad64cf0799033f34ae8fe3e179a58960d1213ccd`; never edit it.
- The JS functions `r507StartInline()` and `r592RefreshVisibleDay()` in R633 are exact text matches to R611, preserving same-day QuickRecord in-place playlist update and R611 native mount gate.
- R631 introduced Java `r631ObservePicker(...)` called from **every native Gallery tick**, including regular photo-day / camera return, and injected the selection button into Activity root top-right; separate from original capsule. **Interference with QuickRecord is a hypothesis, not conclusively established absent Galaxy logcat.**
- R633 gates new picker polling OUT of already-owned original in-card Gallery / R611 fullscreen flow, and houses a fifth glyph (`✓`/ `□`) inside the existing native `moa.gallery.action.deck.r443` capsule. The original four full-screen action views and native media/rail code are not replaced.
- R633 JS adds post-QuickRecord ACK health check: if `isNativeGalleryOpen()` confirms closed and the original JS still thinks the host is opened, calls existing bounded R611 `__moaR547RebuildDamagedHost` only then, never when native is reported active or during picker/intentional exit.

## Deliverables
- **R633** `MOA_R633_R631_QUICKRECORD_NATIVE_GALLERY_BOTTOM_SELECT_ORIGINAL_SIGNED_BETA.apk`, original signer, versionCode **633**, SHA256 **`a7010ab64c74ad2cc3f64a245e8b5df59cb1cceaa140a3d71a5c88315ee0f93d`**, 9,129,049 B.
- **Emergency R634** `MOA_R634_EXACT_R611_GOLDEN_FORWARD_RECOVERY_ORIGINAL_SIGNED.apk`, versionCode 634, SHA256 `69c78b7eedea7989a58e02cebc398e6e9d73ceafff86e467ab042defd1ac941e`, exact R611 *functional* content except versionCode: 143/144 ZIP members equal, DEX 18/18. It loses later photo-add UI; emergency only.
- Full ZIP `MOA_R633_R634_NATIVE_GALLERY_QUICKRECORD_BOTTOM_SELECTION_FULL_RELEASE_20261116.zip`, SHA256 `b3007e799514ae7c80702109f6af84590a94b57a70360e3fbc0f5efff5ed8280`.
- Private Library: `/모아_프로젝트_근거_20261103/R633_R634_NATIVE_GALLERY_QUICKRECORD_BOTTOM_SELECT_20261116/`.
- Native Java source: branch `feature/moa-r633-r631-quickrecord-guard-native-bottom-select-20261116`, `experiments/moa-r631/MoaR507InlineGalleryProvider.java`. CI Android API35/D8 success: https://github.com/yooogillycloud123/family-journey-personal/actions/runs/43817145044 .
- Original signing cert SHA256 `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`; private signer never published.

## Verification
- APK v2 RSA signature and complete digest original cert PASS, ZIP CRC/alignment PASS.
- R631→R633 only AndroidManifest, photo JS and classes18.dex modified (141/144 ZIP entries equal).
- R611 original native core 17/17 DEX equal. R631 family-diary.js, voice.js, photo CSS equal to R633.
- Chromium 360/390/412px photo select/zoom/return UI mock PASS. Isolated R633 actual JS guard test PASS: native alive means zero repair; confirmed closed means exactly one bounded repair.
- **NO new Galaxy physical pass** for QuickRecord repeated use, native bottom pick icon or One Hand Naver Accessibility OFF→ON. Don't call R633 Golden/FINAL. Do not delete app/clear data/Naver login. No AirPods audio changes.

## Suggested physical minimal regression
1. Update R633 over the existing original-signer MOA package (no uninstall). QuickRecord save twice, open same photo day, confirm all native action glyphs, filmstrip, video alive.
2. Central + → photo picker → lower-left zoom → verify new select/clear icon inside BOTTOM native action capsule, reflects same numbered grid selection; exit → add to diary.
3. One Hand Operation+ NAVER Accessibility OFF→ON, return to same photo/day, verify R611 in-card Gallery and filmstrip.
4. If serious regression, emergency R634 restores R611 functionality but loses new picker UI.

Never attribute browser/mock PASS to Galaxy hardware.