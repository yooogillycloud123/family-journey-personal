# R75 exact signed release reference — 2026-11-04

Latest user's physical R74 video `18621.mp4` proves selected diary day cards are initially blank while calendar preview exists, and later native thumb loads; photo opens on tap. User reports secure lockscreen Samsung camera hides the normal TYPE_APPLICATION_OVERLAY until unlock.

This branch carries the **actual source** Java deltas:
- `MoaMomentQuickThumb.java` (optional independent thumbnail fetch priority worker),
- `MoaMomentApplication.java` (attach separate optional JS bridge while preserving R63 native and R70 toggle),
- `MoaMomentCaptureService.java` (isKeyguardLocked→high-priority PUBLIC actionable notification; R74 overlay still created for unlock),
- `MoaMomentMemoActivity.java` (setShowWhenLocked only on explicit user notification tap).

The APK's **exact applied** `assets/web/family-diary.js`, minimal JS patch, regression test, final binary/verification report and source (NO signing keys) are permanently in private Library:
`/모아_프로젝트_근거_20261103/MOA_R75_SOURCE_TESTS_NO_KEYS.zip`.
The final signed same-package APK is in Library:
`/모아_프로젝트_근거_20261103/MOA_R75_DAY_THUMBS_LOCKSCREEN_RECORDING_BETA.apk`.
SHA256 `fe4f3bcd08d5806711c4276a88fab7a7b9f16a19b3b24e6853a3eddc36ba8e6a`, versionCode 75, same signer, 3,441,371B.
Android CI run `41772629259` SUCCESS, compiled DEX SHA256 `e4cc37eddcd49e69f4a840a52e237780f7f01f38b999b0f996732f8ad247cacf`.
Exact APK changes vs R74 only `AndroidManifest.xml`, `classes4.dex`, `assets/web/family-diary.js`; 52/55 zip files byte-identical (R63 core direct IDB writer and original HostActivity preserved).
All static tests PASS, **Galaxy R75 physical day thumbnail/secure camera UI tests NOT DONE**. Do not claim Samsung can be forced to display third-party popup on secure lockscreen; OS policy and notification preferences may hide notification. No full-screen-intent abuse. R63 Golden untouched.

Main canonical:
`MOA_R75_DAY_THUMBNAILS_LOCKSCREEN_CAPTURE_READ_FIRST_20261104.md`.
