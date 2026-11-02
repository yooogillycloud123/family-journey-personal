# MOA R45 delivered binary audit (2026-11-02, user physical FAIL)
**Do not call the delivered R45 a working camera integration.**

Actual APK byte-by-byte comparison:
- Delivered `MOA_R45_재첨부_실제APK_20261102.apk` vs R44: 53 ZIP entries; **only AndroidManifest.xml and classes4.dex differ**; 51 files including all HTML/JS/CSS/assets are byte-identical.
- `assets/web/family-diary.js` has the same `mmToggle()` unconditional `return;` immediately after status message as R44. The app button cannot arm anything.
- `classes4.dex` does **not** contain the `Landroid/database/ContentObserver;` type; still uses `MoaShotService` Handler-driven scanning, not the GitHub `MoaMomentCaptureService` watcher that was described.
- The actual R45 change fixes only one notification small-icon literal and changes the manifest/package to `com.juhyeon.familyjourneb`; this installer is a separately installed app, so user's existing R44 IndexedDB diary is **not automatically present**.
- The republished `MOA_R45_재첨부_실제APK_20261102.apk` is payload-identical to the earlier `MOA_R45_NEW_SIGNER_CAMERA_SERVICE_FIX_TEST.apk`. Reposting did not change app behavior.
- User reported no improvement on device, which is the acceptance authority. The native `MoaShotTile` state currently mirrors a SharedPreferences boolean, **not proof of live service**. No verified capture→overlay→speech→diary pass exists.

RELEASE BLOCKERS: produce reproducible exact source for delivered APK with build toolchain, implement real QS setup+permission flow and service health state, background MediaStore ContentObserver (not a WebView return scan), Android-overlay user opt-in, native Android speech, durable photo IDs and time-local diary save with ACK only after commit, preserve actual user data or provide verified safe migration; sign and verify package; validate on device. **Do not issue an R46 APK produced by editing only version label or static icon.**
