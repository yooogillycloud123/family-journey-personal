# MOA R76 — Actual previously uploaded Samsung Camera 17.0.00.43 APK inspection (2026-11-04)

## Origin
User said "카메라 앱이랑 다 보내줬잖아" and rightly expected source-level verification. Recovered original private Library files (never copy/commit their private APK bytes publicly):
- `/카메라-17.0.00.43.apk`, 68,426,996 bytes (4 DEX, 6,409 ZIP members, compiled AndroidManifest.xml 108,064 bytes).
- `/Camera Assistant-4.5.00.20(1).apk`, 12,270,099 bytes (1 DEX, compiled manifest 22,040 bytes).
- User's live R75 failure screen video `18638.mp4` (43.12s). Real Galaxy does NOT show original floating `바로 기록` above Samsung Camera launched via side key while locked, but displays after unlock.

## What the ACTUAL Samsung Camera APK manifest proves
Binary-AXML tree parsed (not guessing from package name): `<activity android:name="com.sec.android.app.camera.Camera" android:exported="true" android:showWhenLocked="true" android:taskAffinity="android.task.camera" ...>`.
The SAME Camera activity includes exported intent actions:
- `android.media.action.STILL_IMAGE_CAMERA_SECURE`
- `android.media.action.IMAGE_CAPTURE_SECURE`
- `android.provider.action.MOTION_PHOTO_CAPTURE_SECURE`.

Android OS SystemUI launches secure Camera differently from normal unlocked launch using the special secure-camera intent; this is corroborated by AOSP source `packages/SystemUI/docs/camera.md`: https://android.googlesource.com/platform/frameworks/base/+/refs/heads/android14-mainline-permission-release/packages/SystemUI/docs/camera.md .

Therefore **Samsung Camera's own camera UI can appear while locked because its ACTIVITY explicitly opts into showWhenLocked and the OS launches it through a secure camera entrypoint**. This is NOT evidence that any third-party `TYPE_APPLICATION_OVERLAY` can draw on top of that camera/lockscreen. The MOA floating pill is not itself the Samsung Camera Activity, and its original overlay is system-layer-lower than critical OS windows. Official Android API reference: https://developer.android.com/reference/android/view/WindowManager.LayoutParams .

Additional APK-specific observations:
- Samsung Camera declares requests for `android.permission.SYSTEM_CAMERA` and `android.permission.WRITE_SECURE_SETTINGS`. Manifest DECLARATION ALONE is NOT proof the permissions were granted and is NOT by itself a sufficient causal explanation; privilege status requires device package-manager evidence.
- The literal `android.permission.HIDE_OVERLAY_WINDOWS` is **NOT present in this uploaded Camera APK's manifest string pool**. So DO NOT claim this exact Samsung Camera APK definitely uses HIDE_OVERLAY_WINDOWS to block MOA; that would be a fabricated root cause. Keyguard/WindowManager layer restriction, window visibility policy and OEM secure-camera suppression are still possible.
- Samsung Camera Assistant APK has no `STILL_IMAGE_CAMERA_SECURE` activity declaration nor documented external overlay injection intent; it requests Samsung camera-setting read/write permission and exposes setting/DeepLink actions, but nothing in manifest proves ordinary MOA app can add a visual child to Samsung Camera's secure Activity. The earlier Camera Assistant analysis was about camera settings/capture, not secure keyguard overlay privileges.
- The current user footage and manifest establish **functionally different window types and actual device failures**, but cannot prove which Samsung firmware WindowManager path/hide reason is active without on-device `dumpsys window` / notification-channel states while secure camera is on top.

## R75 vs R76 truth
R75 Java already uses `KeyguardManager.isKeyguardLocked()`, HIGH `moa_moment_capture_alerts_v2` notification plus `MoaMomentMemoActivity.setShowWhenLocked(true)` on **USER tap**. Yet user's device still does not show the **automatic floating pill** in the secure camera. `setShowWhenLocked` on the *memo Activity* is not equivalent to displaying the *background service TYPE_APPLICATION_OVERLAY* inside Samsung Camera.

R76 exact signed APK code76 sha256 `fe0a3913caf2e74a2ccf5b6c1e4aeba492dd89f610dae8602aa69c481ec33a8c` changes only manifest version + diary JS persistent thumbnails; all prior Java DEX unchanged. So **R76 resolves neither app's security-layer UI controls nor Samsung secure camera display**, and it must NEVER be represented as a successful lockscreen fix. A source-only separate branch includes a proposed lock capture channel+nonprivate diagnostics not in this release.

## Proper next experimental gate for an AUTO pill on secure Samsung Camera
- Do NOT blindly switch to TYPE_SYSTEM_ERROR/TYPE_SECURE_SYSTEM_OVERLAY, root/shizuku/hidden Samsung APIs or full-screen-intent for non-call/non-alarm apps. Those are restricted by the platform and can break camera or user security.
- Read exact device WindowManager keyguard/window visibility and NotificationManager channel importance while a secure camera capture is made. Determine if the MOA overlay was added but hidden by layering; if notification exists and can be opened; and if Samsung chooses to hide other app overlays over the secure camera window. Device logs are essential to distinguish these concrete failure modes.
- A **user-invoked MOA-owned camera Activity** could display an in-app shortcut on its own lockscreen camera preview, but that requires a separate full camera implementation and may not retain Samsung Camera features. A **translucent MOA showWhenLocked Activity AUTO-launched from background** is not guaranteed due Android background-activity-start restrictions and may pause/interrupt Samsung Camera; do not silently ship it as a safe guaranteed fix.
- Even if notification fallback is offered, avoid telling user it is the requested same-position floating pill. Distinguish actual UX from fallback.
