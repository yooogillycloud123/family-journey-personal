# MOA R535 native in-card Gallery R531 user-video fixes — original signed release and R537 forward recovery

**Date 2026-11-14 Asia/Seoul. Latest MOA experiment, NOT new user-approved GOLDEN.** R463 user-approved Golden remains immutable.

## Primary new device evidence
- User uploads: photo `21602.png`; videos `21604.mp4` (~28s), `21605.mp4` (~12s), actually reviewed frame-by-frame/contact sheets.
- R531 visibly: video keeps its full frame against blurred ambient and scrolling is markedly smoother; **photo sometimes has dark blurry video poster on top**, standalone/fullscreen action incorrectly floats at media top-right instead of bottom icon bar; icon visual sizes inconsistent; **after another Android app and return, native card can stay a blank grey panel**. Actual failures supersede previous R531 source-only static assertions. No claim the device already passed R535.

## Source of truth / exact dev branch
- Base: **exact same-signer R531 user-tested APK**, not R483/R485/R527 old-version backport, and GitHub `feature/moa-r531-card-gallery-ux-experiment-20261114`.
- New branch: `feature/moa-r535-resume-photo-ambient-toolbar-20261114`, final SHA `760f0605a4f5d9c81dc5a12724f58e0ae7193778`.
- Changed ONLY: `experiments/moa-r507/MoaR507InlineGalleryProvider.java`, `experiments/moa-r483/moa-r483-vertical-calendar.js`, `experiments/moa-r483/moa-r483-vertical-calendar.css`, plus branch-scoped build workflow `.github/workflows/moa-r531-native-card.yml`.
- GitHub Actions **[43549818654](https://github.com/yooogillycloud123/family-journey-personal/actions/runs/43549818654) SUCCESS**, exact Java D8 SDK35/JS CI DEX SHA256 `1df5defd89207bfb41eb0c819132a2b27cc8d9a791dadce16761ec1fccb60fa5`, 38,388 bytes. Compiled DEX exactly installed in R535.

## Exact R535 changes
1. **No floating fullscreen control**: original R463 in-card Gallery's lower six-icon action capsule becomes seven icons (star, four original R463 actions, filmstrip toggle, original/fullscreen). New last icon inherits native chrome visibility and invokes same `__moaR531ShowAdvanced` original full R463 Gallery. The web fallback equivalent also moves into its own bottom action row instead of photo top-right.
2. **Consistent controls**: replace font-dependent 20sp star and top-right expand with single Canvas `UnifiedGlyph` implementation drawing 19dp antialiased uniform 1.65dp outlines for STAR / RAIL / EXPAND. Existing four R463 action listeners untouched; remove R531 `.74` visual shrink in favor of `.96` glyph scale, preserve 34dp minimum target, widen capsule up to 306dp to fit seven symbols. Original fullscreen R463 icon layout untouched.
3. **Photo should never show ambient video blur**: R531 inserted blurred poster immediately before TextureView, potentially above Photo ImageViews and was only updated during `attachCard`, but the R527 fast WebMessagePort geometry branch skips `attachCard` during frequent frames. R535 moves poster to native stage child index `0` (always BEHIND photos), checks `currentId` and `updateAmbientForSelection` on native tick before the push fast-path, hides poster and makes TextureView opaque on any nonvideo ID, with original photo CENTER_CROP retained. Video still has original FIT/full frame with blurred MediaStore poster and no extra encode/playback pipeline.
4. **Grey on return**: Activity paused/resumed now tracks an epoch and only in-card ownership; after foreground return (>350ms actual background and 380ms rebind delay), confirms trusted WebView and SAME day session token via read-only JS, then closes/clears ONLY the stale native renderer and calls `__moaR535ResumeInline(token)` to re-open original gallery with current date/media/index and new position token. Excludes separate original fullscreen, no normal native Back/day-exit callback and avoids repeated rebind while active. An app-return native gallery `open=false` gap is not treated as Back while rebind is pending. Physical Samsung check still needed.
5. R527 fast WebMessagePort geometry push / R531 no-overshoot position remains unchanged; the 17 original R463 native DEX and existing Naver, voice, diary source untouched.

## Signed distributables / integrity
**Combined ZIP** `MOA_R535_R537_SIGNED_APK_RECOVERY_SOURCE_QA_20261114.zip`: **13,098,614 bytes**, SHA256 **`6e0e5f18f6ba5d4579a621da88cf683cf5fabfdae4fa3fc83d077b9cb60514e9`**.
Private Library location: `/모아_프로젝트_근거_20261103/R535_R537_SIGNED_GALLERY_FIX_20261114/` (file id `libfile_11af29eb2c348191827343f4c6052c3d`).
- Main actual installable signed **R535** `MOA_R535_PHOTO_AMBIENT_RESUME_BOTTOM_TOOLBAR_ORIGINAL_SIGNED_LAB.apk`, package `com.juhyeon.familyjournea`, code **535**, bytes **9,054,015**, SHA256 **`f5605981371d0c73e500f27468fe8d326a1e6fe90b37662c7f957ddbfdcbc62b`**.
- Actual **R537** forward rescue `MOA_R537_EXACT_R463_GOLDEN_FUNCTION_FORWARD_RECOVERY.apk`, package same code **537**, bytes **8,978,137**, SHA256 **`f4d5ba1c8709fae46e9ce3a9379717af3a135722ec19845c1f2668743b17dcdb`**. Original R463 function payload through exact R533 recovery: **139/139 unchanged ZIP member contents** except Manifest 533→537. This loses newer photo-diary experiment UI but retains app data.
- Both APKs signed with user's **same original cert** SHA256 `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`. Original private signer archive held ONLY in local private build process, omitted from ZIP and GitHub; never publish signer key/password.
- Independent verifier: APK Signature Scheme v2 RSA-SHA256 signature, full signed content digest, ZIP CRC/alignment, DEX SHA1/Adler32 PASS; code/manifest/package exact. **143 entries/18 DEX** R535, **140 entries/17 DEX** R537. **R531→R535 changed four entries only** (Manifest, JS, CSS, classes18.dex); **139/139 other payloads byte-identical**, including all original 17 native DEX. R535 shipped CSS/JS/DEX exact match successful CI.
- QA/source files and Korean install/recovery README included in combined ZIP. Static source contracts **13/13 PASS**.

## Install and follow-up
- In-place install R535 over original-signer current R531 (or earlier code<=534); DO NOT uninstall, delete MOA data/cookie/Naver state. User already physically used R531 and requested fix.
- User on-device test: photo clear/no blur, video full FIT w blurred ambient, icon placement/size lower row, tap-to-hide and show, original full Gallery and Back, calendar Back→re-entry, go to another app then back with photo/video selected, video render and native WebView scroll, share/GPS/voice/Naver.
- If serious regression, in-place **R537** restores EXACT R463 functionality. R537 code greater than R535; **after rescue any future experimental release must code >=538**.
- **NEVER report real Samsung foreground resume/video/photo/layout PASS until user tests.** Source/regression physical reason is evidence-backed candidate not proof of full resolution.
- R463 Golden branch `golden/moa-r463-user-approved-20261113` must not change. AA AirPods daemon/Android Auto project not touched.
