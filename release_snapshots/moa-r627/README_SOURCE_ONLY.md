# MOA R627 source-only picker corrections — 2026-11-16

Parent: exact user-supplied R625 original-signed APK SHA256 7aca05a220df6891e29ccfc5c4057d4b52e7f2aa79fcb0a86f44eb9552da3663.

This branch is **source-only, NOT a signed/installable APK**, not R611 Golden, and not a device-verified release.

Changes to only R625 photo Web JS/CSS:
- zoom glyph visually 16 CSS px, retain 32 CSS px tap target.
- top selection/diary/add control hidden until at least 1 photo selected.
- picker scroll isolated to one shell; sticky top uses that shell; observer and long-touch autoscroll follow same scroll root.
- rail scroll-snap removed for both FAST states; auto-follow no longer forces smooth scrolling during rail movement.
- 125-thumbnail rolling window rebuilt near edges only, not on every index change.
- picker status remains inside scrolling shell.

Source-level checks: Node syntax PASS; Chromium 360/390/412 widths PASS for 16px visual, 32px touch area, selected-only overlay, actual sticky top (0 offset), and no above-bar photo hit-through; rail computed CSS scrollSnapType=none PASS. Galaxy physical motion/selection/diary persistence/One Hand Naver ON-OFF remain pending.

**Not implemented**: exact native R611 main-photo swipe engine and full-resolution native bitmap/video playback in the picker. R625 Web photo/video content-URI paths cannot be certified as original-quality. The current FAST ON/OFF web main preview still jumps indices, so do not call this a complete fix.

Correct next step: extend the R611 native Gallery host with an independent PHOTO_PICKER mode, reuse its existing OverScroller/MediaPlayer/TextureView/filmstrip and its Android MediaStore ContentResolver; bridge the existing picker selection Set to native selected-ID callbacks; leave the R611 PHOTO_DAY host untouched; build a versionCode >=627 APK using the app's exact original signing identity. Do not substitute a debug signer, uninstall, or clear user data. Preserve R626 code626 recovery and the immutable R611 Golden.

No audio/AirPods project files touched.
