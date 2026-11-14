# MOA R563: R535 foreground Back exit semantics and original Gallery photo/video foreground restoration

Date 2026-11-14 KST. Signed LAB: GitHub Java/D8 and JS CI PASS, APK v2 public cryptographic verification PASS, real Galaxy R563 NOT tested. The only user-approved immutable Golden remains R463.

## Latest user evidence
- Historical 2026-11-14 R535 chat screenshots: user rated R535 scrolling almost perfectly smooth, earlier Back/re-entry worked.
- New videos 21814.mp4 (~41.94 sec), 21815.mp4 (~10.34 sec), 21817.mp4 (~16.91 sec), screenshots 21806.png, 21808.png, 21810.png, 21812.png: R559 first Back closes original Gallery leaving blank, second Back exits; app/Recents return sometimes grey/old Web view; residual scroll jitter.
- User wants ACTUAL code comparison and APK+forward recovery ZIP, no helpers or unproven optimizations.

## Actual source root cause and precise fix
1. R535 MoaR507InlineGalleryProvider.tick() detected same-owner foreground original Gallery.isOpen false >180ms, called clearCardMark and __moaR523NativeClosed to exit to calendar. R559 replaced this same path with 380ms NativeLost -> JS __moaR551NativeLost -> Gallery reopen. This is the deterministic source regression behind a first Back leaving a gray or dormant photo-day. R563 restores R535 foreground-close-to-day-exit semantics; validates same Activity, window focus, no paused-background return window, and same date; current foreground user Back bypasses stale token while asynchronous old-day callbacks are guarded.
2. R559 rebindAfterReturn() called healthy when Gallery.open true and host parent attached even if selected media drawable/SurfaceTexture was absent. R563 keeps healthy original native host (never destroys it for normal return) and checks actual selected media readiness. If selected PHOTO has no images[1] drawable it invokes the original R227 MoaNativeGallery private refreshPages(), preserving index. If selected VIDEO has a missing SurfaceTexture/MediaPlayer after foreground return, waits 820ms and rechecks exact original host, native Activity, media ID and day token; if still broken invokes original Gallery teardownPlayer(), refreshPages(), prepareCurrentVideo() to recreate the ORIGINAL player. Healthy video is not restarted. A broken video can restart at beginning; exact previous seek may not be recoverable.
3. R535 versus R559 onPositionMessage/attachCard have identical integer rounded geometry target expressions. R559 had already restored those, so R563 does not introduce another scroll algorithm. R527 WebMessagePort remains; minor jitter can persist because WebView and native view are separate compositors.
4. Explicit photo-day exit closes its original native Gallery even if the WebView native-mounted acknowledgment was reset; guard prevents double close. Detailed diary owner, shared header, fullscreen current index remain intact.

## Exact signed deliverable
- Combined user ZIP: MOA_R563_R565_NATIVE_BACK_RESUME_R535_SCROLL_ORIGINAL_SIGNED_SOURCE_QA_20261114.zip
- ZIP size: 13,120,750 bytes; SHA256: c3d0e704d093b408f39a223ed1c5f4165ec5b9932b314ae60b1b84558db22502. Archive CRC and extracted file checks PASS.
- 01_INSTALL/MOA_R563_NATIVE_BACK_ONE_TAP_R535_SCROLL_RESUME_REHYDRATION_SAME_SIGNER_TEST.apk: package com.juhyeon.familyjournea, versionCode 563, 9,063,503 bytes, SHA256 e9e08f1f9b41c6c9b71ffede007ac741caea9f3ab094da4be9c5497a52208242.
- 02_RECOVERY/MOA_R565_EXACT_R463_GOLDEN_FUNCTION_FORWARD_RECOVERY.apk: same package, versionCode 565, 8,978,096 bytes, SHA256 6a4c0abab239c41e4a919443466420d839fe87e94b95c243c0aa7e9edaf83312. Original R463 functional exact forward recovery, loses newer experimental photo UI if used, preserves data.
- Exact original certificate SHA256: 5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15. Private key/password NEVER shared or published.
- R559->R563 changed only Manifest, photo calendar JS, classes18.dex. All 140 other APK member contents IDENTICAL, original 17 R463 native DEX byte-identical and CSS unchanged. R561->R565 recovery changed Manifest only: 139 recovery payloads identical.

## Source and validation
- Source branch feature/moa-r563-r535-native-back-exit-and-blank-resume-20261114, final head 61433dd6bae2e5fd1bf04128dc203b0baa805cff.
- Exact GitHub Actions CI SUCCESS: https://github.com/yooogillycloud123/family-journey-personal/actions/runs/43584859491 ; shipped Java/JS/CSS and compiled classes18.dex match CI artifact.
- Independent APKv2 RSA-SHA256 original signature + full signed content digest, ZIP CRC, aligned STORED records, DEX header checks and manifest version passed using included no-private-key QA/verify_release.py.
- Synthetic Chromium Peach/Black/White native mock: photo/detail three roundtrips, original settings, delayed native-mounted no timeout close, current first Back to calendar and old-date callback ignored PASS. Not proof of real S26 physical Back/Surface rendering or 120 Hz scrolling.
- QA/R535_R559_R563_DIFFERENCES.txt in ZIP gives actual relevant source differences, not speculative descriptions.

## Install/recovery / acceptance
- In-place R563 update over installed original-signer code <=562. DO NOT uninstall, delete app storage, MediaStore or Naver cookies.
- First test one native photo-day Back -> calendar and reopen same date; then Home/Recents/another app return with photo and video, photo-detail roundtrip, Naver, scroll.
- R565 only for serious failure; after installing R565 subsequent versions must be code >=566.
- R463 user-approved immutable Golden APK SHA256 9d2fd10d32a3bc35eb3132333e96edd8f565abd5daf3ce954b052f77083d8379 unchanged. AA AirPods Android Auto runtime untouched.
- Do not call device tests PASS until user physically verifies R563. If it still fails, capture correlated native Back, prePause, TextureView logs before more guessed changes.

Storage note: Prior signed ZIP uploads to private Library repeatedly failed due user Library quota. Small sources staged; do not claim the full signed R563 ZIP persisted to Library without positive confirmation.