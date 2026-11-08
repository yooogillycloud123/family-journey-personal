# MOA R179 — EXIF photo rotation + visible media volume + safe video capture (2026-11-08)

> **NEW SIGNED BETA, NOT NEW GOLDEN.** Original R177 user-device limited Golden remains protected at exact SHA `c6b4b8d21742370b3e59758ffbe1a715e598a5d3911ab6c8af5050a6b2789b30`. Do not uninstall, wipe, publish private photo/video or signer, change AA code, or promote without user device QA.

## Trigger / evidence
- User on Galaxy installed R177 and confirmed native single-screen gallery/video + long-press draggable scroll rail. This is a scoped **user Golden**.
- Private user video `19464.mp4` shows still-photo sideways rotation at ~33s, gallery frame save `frame missing` at ~13s. User notes unmuted audio stays silent when Android media level zero, because no in-view volume control.
- R175/R177 source evidence: `MoaNativeGallery.getBitmap()` uses `BitmapFactory.decodeStream` without EXIF orientation; `toggleMute()` changes only MediaPlayer local gain; `capture()` has one MediaMetadataRetriever extraction and fails when it returns null.

## Exact signed R179
- `com.juhyeon.familyjournea` **versionCode 179**, **5,643,677 bytes**, SHA256 `70a1218650a210b5f0256a3910b705850919ce64c619b22a87588dccbfcd65c8`.
- Same original signer certificate SHA256 `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`.
- Exact R177 → R179 diff: **126/128 ZIP members byte-identical**. Changed ONLY `AndroidManifest.xml` (code177→179) and `classes6.dex` (compiled native Gallery). All JS/CSS, IndexedDB, capture, maps, GPS, calendar, voice, activity manifest components, assets, other DEX byte-identical.
- Independent APK-v2 RSA signature + full content digest, original certificate, 128 ZIP entries CRC/alignment, DEX SHA1/Adler, exact diff **PASS**. **User device install and feature QA PENDING.**

## Source changes
- Code branch `feature/moa-r179-exif-volume-frame-capture-safe-20261108`, file `experiments/moa-r175/MoaNativeGallery.java`, native host file unchanged.
- For full-size still images, Android 28+ `ImageDecoder.decodeBitmap` with bounded sample size and software allocator handles encoded EXIF/HEIF orientation. Existing provider thumbnails and raw BitmapFactory fallback remain. This is a fix **candidate**; individual user file EXIF metadata and real Galaxy rotation not independently inspected.
- On native gallery unmute, reveal small in-gallery **Android STREAM_MUSIC** volume slider and level label (including zero). Only an explicit user slider gesture changes system media volume; mute/unmute itself never raises device volume, avoiding surprise audio. Gallery hardware volume keys target music stream while open.
- For `장면 저장`, synchronously request displayed `TextureView.getBitmap()` while frame is on screen; if unavailable use MediaMetadataRetriever closest/closest_sync/default fallbacks. Original clip never edited. MediaStore JPEG save retains previous behavior.
- Video-on-photo rail, original 3-page navigation, smooth thumb gestures, pause/seek, optional EXIF and previous long-press arrows untouched.

## Compile and verification
- GitHub Actions isolated compile `42436200107` job `gallery_dex` SUCCESS; DEX **97,568 bytes** SHA256 `72b0bd47978fed8e370a62931ee8d2561ed940874c1be2d481143eedd4beb89b`; artifact `13599344067`.
- This is isolated `javac + d8` of exact R175 host + changed R179 Gallery, NOT full clean Android project build. Signed APK assembled from exact R177 user Golden and original private signer; v2 signature independently reverified with no-key guard.
- No Android PackageManager install check, no real Galaxy 120Hz video/audio/EXIF/codec QA, no full legacy regression, no media or secrets published.

## Emergency recovery
- Signed **R180 emergency-only** from **exact R177 Golden** payload with binary Manifest versionCode180 only, all **127/128** other entries byte-identical: size 5,640,226 B, SHA256 `52bda70c4d22f06cf9fef39aa989737da19d2bf1596152d98d80a1657958bfe0`, same cert, independent v2/ZIP PASS.
- R180 is **not** a new feature or normal upgrade, and on-device restore still NOT TESTED. Use only on **user-confirmed R179 regression**; in-place update, no uninstall/clear. Previous R178 returns R173 only and is **not** equivalent to R177 Golden.

## Next user acceptance gates
1. In-place install R179 only if user wants to test new beta. Preserve R177 user Golden and diary data.
2. Open exact prior sideways image (and varied JPEG/HEIC), verify portrait/landscape original orientation, no upside-down flip.
3. Video first silent: tap 소리 켜기; slider appears, zero-level correctly indicated, drag to audible level, mute again and return to images. Verify hardware volume buttons adjust music.
4. Repeat original `장면 저장` on video that previously produced `frame missing`, check saved frame and original video untouched.
5. Confirm long-press rail XY, 700-photo drag, one Back, both day/month gallery, voice M4A/STT, original diary IndexedDB, camera, GPS, map, calendar, existing files.
6. If unexpected regression, R180 emergency-only candidate exists. Do not call R179 Golden without user confirmation.
7. Further Samsung smoothness needs on-device frame pacing/decoder prefetch profiling, reducing repeated rail rebind, and adjacent media cache; do not state 120fps parity based on static tests.

## Read-first
New MOA conversations read shared AA Canonical in `workexcel-devbridge`, then R177 user Golden lock, this R179 handoff, current MOA release ledger and exact private Library evidence. Never edit Golden branch or expose private user media/signing credentials.
