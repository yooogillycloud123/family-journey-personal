# MOA R203 — compact, fully clickable play/time capsule + true kinetic gallery swipe

## Current status — 2026-11-09
**SIGNED UPDATE APK CREATED AND INDEPENDENT STATICALLY VERIFIED. NOT GALAXY PHYSICALLY TESTED. NOT GOLDEN.**

The user provided private evidence on 2026-11-08: `19737.png`, `19739.png`, `19735.mp4` (Samsung Gallery fling reference) and `19736.mp4` (MOA R201 limited snap). They report two concrete deficiencies:
1. MOA oversized capture/play-time/mute buttons compared with Samsung; clicking the central time part did not toggle playback.
2. MOA stage and rail stop abruptly on one/few items even after a fast flick, while Samsung shows multiple images drifting with inertia and smooth deceleration.

## Shipped exact R203
- Private Library APK: `/모아_프로젝트_근거_20261103/MOA_R203_COMPACT_TOUCH_ALL_NATIVE_INERTIA_FLING_BETA.apk`.
- Android package `com.juhyeon.familyjournea`, versionCode **203**, 5,709,983 bytes, SHA-256 `6d85add0d0d97b08e90cec1fc13923cfa49faea1af66907350eb1f54a2b2c6a7`.
- Exact original signing cert SHA-256 `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`, same as R201/R187. APK Signature Scheme v2 RSA+SHA-256 and independently recomputed whole-file signed digest PASS, 128 ZIP member CRC/integrity, alignment, DEX Adler/SHA1 PASS.
- Source baseline signed R201 SHA-256 `ffe9f1c1bbfb6e0cf81017eea903c9bbc45dd35145b35e170a14775ac5bcffaa`. Only **AndroidManifest.xml (201→203) and classes6.dex** differ; other **126 of 128 ZIP member payloads byte-for-byte preserved**, including every WebView diary/voice asset and classes7. Native existing R187 Golden untouched (SHA-256 `4380ca0a421c3a12cfad0334e860e659112b116f6cc7099f8989475c646a97e9`).
- Native Android 35 Java+d8 isolated GitHub Actions CI **42494987936 SUCCESS**, artifact **13623341631**. Exact CI `classes6.dex` SHA-256 `5e64ed65d6b3775490a820659d9c05f3811088a162b3fbda5e9b2a18557de47e` (123,628 bytes); exact compiled native source SHA256 `10e5183be21881feb7e6228b974b00db6806a7cb41eba3d3fc51ae7fe7aaefb7`.
- GitHub source branch `feature/moa-r203-compact-center-pill-native-inertia-fling-20261109`, original Java file `experiments/moa-r175/MoaNativeGallery.java`; source blob SHA `8be3bc864c21fd01d8cf19006448e9e0a32ef9af`; CI-triggering commit `592745659ebbd6e249c7c78cd7426529f90e978e`.
- Private Library extras: `MOA_R203_INSTALL_ZIP_FALLBACK.zip`, `MOA_R203_SAFE_SOURCE_EVIDENCE_NO_KEYS.zip`, `MOA_R203_RELEASE_QA_20261109.json`. No signer material, personal diary database, family media or keys in source/evidence ZIP.
- Emergency-only **R204**: `MOA_R204_EMERGENCY_R201_FEATURES_CODE_FORWARD_ONLY.apk`, SHA-256 `e32506c2a529023dc3871bdfb996ed0ac34a5ca3a4b5aa07ff845c2bbf472823`, exact R201 feature payload 127/128 identical (Manifest code204 only), signed original cert. **Emergency Galaxy recovery untested; not for routine install.**

## Native code changes (surgical)
1. Video control row: capture and mute buttons each **37dp**; center rounded play/time capsule **154×40dp**, 12sp stable elapsed/total. Full `centerPill` receives click-to-toggle, `videoTime` receives click-to-toggle, and nested pause icon retains click; touch no longer confined to icon. Existing media callbacks remain unchanged.
2. Fullscreen `SwipeHandler` now uses native `VelocityTracker` release x-velocity. Fast directional horizontal fling (>680px/s and minimum displacement) starts shared `r203ReleaseWithVelocity`; slow drags keep original step settle, pinch/zoom preserved.
3. `GalleryRail.touch` now uses `VelocityTracker` for gestures and native `android.widget.OverScroller` to move the shared **fractional image index** across multiple images. Physical native spline friction decelerates. During motion the stage and strip share a fractional position; only the three visible stage pages are retained, full-size decoding deferred until final item; end snaps to nearest item in 150ms and restores autoplay video only once. Fling travel clamped to valid media bounds and ±45 items from release. Gesture cancellation/close/navigation stop prior animations.
4. Previously implemented R201 Samsung-like video clip strip, frame poster fallback, header ⋯ corrections, day record controls, M4A/backup flows and immutable Golden unchanged.

## Device QA gate still open
On Galaxy S26 Ultra:
- Pause and resume by tapping **any part** of center rounded capsule including elapsed/total; show 00:00/00:43 without truncation.
- Verify capture left/sound right icon sizes vs Samsung Gallery reference.
- Fling rapidly through 15+ items using **main stage** and **bottom media rail**; watch continued inertial glide and deceleration, no abrupt three-image stop, no blank/black page, no heavy stutter. Verify slow swipes and photo pinch still work, photos/video alternate and selected video autoplays at final item.
- Test gallery exit/back, photo record/M4A playback/linking/backup data unchanged. Real-device smoothness/120Hz Samsung parity is not established from SDK compilation and APK static checks alone.
- Update install only: **never uninstall, clear app data or replace signer**. Do not edit AA AirPods/Android Auto audio source.
