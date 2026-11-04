# MOA R77 — GitHub open-source secure-camera overlay flag experiment (2026-11-04)

## Confirmed user facts
- User's screen-locked Samsung Camera capture DOES create the MOA pill in the background: it appears after unlocking and later auto-disappears. Never misdiagnose capture failure.
- Goal: show and tap the ORIGINAL "모아 | 바로 기록 | ×" pill while Samsung secure Camera remains foreground, before unlocking. Notification-only fallback is not equivalent.
- R75 actual Samsung device secure-camera pill FAIL. R76 improves photo thumbnail caching only, not secure-camera overlay.

## Actual external source comparisons
- Public GitHub aunger/gallery-button-for-pixel-camera, OverlayManager.kt:
  https://github.com/aunger/gallery-button-for-pixel-camera/blob/main/app/src/main/java/com/gb4pc/overlay/OverlayManager.kt
  Its TYPE_APPLICATION_OVERLAY sets FLAG_NOT_FOCUSABLE | FLAG_NOT_TOUCH_MODAL | FLAG_LAYOUT_IN_SCREEN | FLAG_SHOW_WHEN_LOCKED. It is intended to stay visible on Pixel Camera even when the camera was launched from lockscreen.
- Actual MOA R75 Java source WindowManager.LayoutParams had only FLAG_NOT_FOCUSABLE | FLAG_NOT_TOUCH_MODAL, not the two lockscreen flags. This is a proven source difference, a TESTABLE lead, not confirmed Samsung solution.
- Official Android docs: FLAG_SHOW_WHEN_LOCKED was deprecated API27 and is only specified for topmost full-screen windows. A small Samsung overlay may ignore it:
  https://developer.android.com/reference/android/view/WindowManager.LayoutParams
- Earlier uploaded Samsung Camera 17.0.00.43 APK confirms its own Camera Activity uses showWhenLocked and SECURE_CAMERA intent, which is a separate OS-launched Activity, not evidence of third-party overlay permission.
- Alternative: Android AccessibilityService can create TYPE_ACCESSIBILITY_OVERLAY. Real GitHub user issue #927 reports that such a window can remain over the actual keyguard PIN:
  https://github.com/Nain57/Smart-AutoClicker/issues/927
  So this requires user opt-in and strict CAMERA-ONLY visibility guard + PIN-screen hide rule. NOT implemented in R77; do not auto-enable, never allow overlay to obstruct PIN.

## Exactly implemented R77
- Source branch: fix/moa-r77-secure-camera-flag-parity-20261104
- Java file: android/app/src/main/java/com/juhyeon/familyjourney/MoaMomentCaptureService.java
- Only if KeyguardManager.isKeyguardLocked() is true during bottom popup creation, append FLAG_SHOW_WHEN_LOCKED and FLAG_LAYOUT_IN_SCREEN to existing TYPE_APPLICATION_OVERLAY LayoutParams. If unlocked, original flags unchanged.
- Private prefs diagnostics (no photo, notes or IDs): r77LastOverlayKeyguard, r77LastOverlayFlags, r77LastOverlayAttemptAt.
- Android GitHub Actions CI 41780297825 SUCCESS, compiled classes4.dex SHA256 d28f588537cd1b47c38687a88a0fad9dabb341e806c2c5d12d86a41368d34c36 (74,380 bytes).
- R77 signed in-place upgrade APK: MOA_R77_Install.apk, versionCode 77, 3,445,814 bytes, SHA256 a37a0f062c545b1d07dd1e635cc5084239a64ad18bb13b74fe810e01eba72003, package com.juhyeon.familyjournea, historic cert SHA256 5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15.
- R76 → R77 only 2/55 APK members changed: AndroidManifest.xml version and classes4.dex; all other 53 byte identical, specifically assets/web/family-diary.js R76 persistence, assets/web/moa-direct-diary-commit.html R63 actual successful IndexedDB writer, original base DEX and NAVER, photo notes/time grouping and OHO+.
- Android D8 Java compile, original APK signing cert/v2 verify, DEX hashes, ZIP CRC, diff PASS. GALAXY SCREENLOCK POPUP PHYSICAL SUCCESS NOT VERIFIED. Do not call GOLDEN.
- Permanent Library: /모아_프로젝트_근거_20261103/MOA_R77_SECURE_CAMERA_OVERLAY_FLAG_EXPERIMENT.apk and MOA_R77_LOCKSCREEN_FLAG_SOURCE_NO_KEYS.zip.
- R63 physical Golden remains frozen.

## Next acceptance test
- Update R76 → R77 without uninstall/data reset.
- Enable monitor; lock phone; side-key double-click → Samsung secure Camera → capture a disposable photo. BEFORE unlock, see if existing bottom "모아 | 바로 기록 | ×" appears and the record action works. Check unlocked capture still behaves as before.
- If pill remains hidden despite R77 flags, report R77 DEVICE FAIL and move to opt-in accessibility-overlay feasibility test with explicit security guarding; do not invent a third success by reissuing an unchanged APK. User must authorize accessibility permission. Do not launch a fullscreen Activity automatically to cover Samsung Camera.
