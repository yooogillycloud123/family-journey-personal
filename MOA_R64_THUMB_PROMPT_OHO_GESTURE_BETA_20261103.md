# MOA R64 — thumb capture pill and One Hand Operation+ toggle UX BETA
> **DO NOT supersede the R63 USER DEVICE GOLDEN.** Read [MOA_R63_USER_DEVICE_GOLDEN_LOCK_20261103.md](MOA_R63_USER_DEVICE_GOLDEN_LOCK_20261103.md) before working. This file describes an R64 code-verified **optional usability candidate**, NOT a Samsung device-success release.

## Frozen baseline
- User physically confirmed R63's 3 media cards and minute-accurate note lines at 22:23/22:24 in selected photo diary, no repeated second memo popup. That is the Golden.
- R63 immutable APK SHA-256 `64b1b730478a2a50976961cc2dc4cf511182a75495f2d02159f091167f646024` 3,422,752 bytes, package `com.juhyeon.familyjournea`, versionCode 63, signer certificate SHA256 `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`.
- Frozen code branch `golden/moa-r63-20261103-user-device-pass-do-not-modify` from pinned SHA `bdc6003577ba062c7100e43e334ef9a4d834f431`.
- Golden APK also saved user-private Library `/모아_프로젝트_근거_20261103/MOA_R63_GOLDEN_USER_DEVICE_PASS_20261103.apk`.

## Source-confirmed dual top prompts and lower thumb solution
- Under R63, `MoaMomentCaptureService.showCapture()` posts Android HIGH-priority `CH_EVENT` notification, giving *system* heads-up at TOP, and separately calls `showOptionalCameraOverlay()` with app `TYPE_APPLICATION_OVERLAY` `Gravity.TOP;p.y=130` banner also at TOP. Both invoke the same native `MoaMomentMemoActivity` via matching PendingIntent; not two diary engines.
- Android controls the display location of notification heads-up; an ordinary app cannot reposition Android SystemUI notification to the bottom. R64 retains high-priority notification if no overlay permission; while overlay is allowed, uses a **new** LOW-importance channel `moa_moment_capture_quiet_thumb_v1` so only the small app-controlled pill is visible, with the event still in notification center for recovery. New channel ID is required because Android notification channel importance cannot be changed in place.
- R64 overlay changed to compact WRAP_CONTENT rounded `모아 [바로 기록]` pill at RIGHT|BOTTOM with default bottom offset 310dp, x 12dp. It avoids center shutter/zoom; **tap the `모아` grip to swap RIGHT/LEFT thumb**, drag grip vertically to adjust 180–530dp from bottom; preference persisted. Remains nonfocusable, does not interfere with Samsung camera capture, expires at original 8500ms, opens **exact same** native memo PendingIntent.
- If creating overlay actually throws while overlay permission is present, promote same photo event notification to legacy heads-up channel (same notification ID). When no overlay permission, legacy heads-up remains. No changes to camera detection/MediaStore timestamps, DB schema, photo capture/voice STT.

## OHO+ one-gesture on/off shortcut
- Samsung OHO+ supports gesture action `홈 화면 바로가기` (Home screen shortcuts) and `앱 실행`; **it does not automatically operate arbitrary third-party custom QuickTile**.
- R64 `MoaMomentApplication` publishes one **dynamic app launcher shortcut** `모아 기록 전환`, ID `moa-recording-toggle`, routed to existing exported launcher HostActivity with explicit action `com.juhyeon.familyjournea.TOGGLE_MOMENT_MONITOR`. No new launcher icon, helper app, manifest-declared exported receiver or new Service UID.
- Short-lived `onActivityCreated/onActivityResumed` action guard toggles using the **exact existing** `MoaMomentCaptureService.enabled/switchTo/updateTile` underlying Quick Settings tile, shows ON/OFF toast and finishes immediately, one action once per Activity. If required READ_MEDIA_IMAGES, READ_MEDIA_VIDEO, POST_NOTIFICATIONS permissions missing, opens existing setup. There may be a brief activity flash due to shortcut routing; **Samsung actual OHO+ picker and swipe behavior NOT YET VERIFIED**.
- Suggested OHO+ user setup: open MOA once after update to publish shortcut, open One Hand Operation+ > desired left/right handle > swipe action > `홈 화면 바로가기` > MOA `모아 기록 전환`. If shortcut is not listed, this remains a DEVICE FAIL of the OHO+ usability gate, not proof that QS auto-toggle works.

## Actual scoped source, CI and APK static proof
- Isolated code branch `fix/moa-r64-thumb-prompt-oho-toggle-20261103` (never write into frozen R63).
- Java files changed against R63 Golden: `MoaMomentCaptureService.java` **camera overlay + notification only**, `MoaMomentApplication.java` **shortcut action only**; no changes to `MoaMomentDirectDiaryStore.java`, `MoaMomentMemoActivity.java`, `MoaMomentInboxSync.java`, or diary JS/HTML. CI workflow scoped on R64 only.
- Android GitHub Actions `41646577961` **SUCCESS**; compiled native `classes4.dex` SHA-256 `f649be0f78559261f60efdb00aec35a4679da454b52a943e0d821a14fd6f6044`, 63,192 bytes. First compile failed on wrong `Button.setTextAllCaps`, corrected to Android `setAllCaps` and reran success; never claim first attempt passed.
- Built **same signed package** `MOA_R64_Thumb_OHO_BETA_Install.apk` (versionCode 64, versionName `MOA-R64-Safe-Capture`), 3,425,300 bytes, SHA-256 `50facd37f4c6e1e6156f220cb1dd1298ccbd5960d6874308b5c1618de2cf2321`. Signature v2, cert, ZIP CRC, DEX header verification PASS.
- APK diff R63→R64: **only `AndroidManifest.xml` version fields and `classes4.dex` differ; other 52 APK members exactly byte-identical**, particularly both protected `assets/web/family-diary.js` (IndexedDB refresh) and `assets/web/moa-direct-diary-commit.html` (actual direct IDB transaction/ACK), original HostActivity DEX and other assets. No new package, no duplicated R42 popup.
- **R64 physical usability PASS NOT VERIFIED**: potential pill overlap/camera interruption, OHO+ shortcut discoverability, instant toggle feedback, same-photo diary write and reenter all require Samsung device tests. Do not declare R64 Golden until user observes all.

## Safe code-return artifact (not automatic rollback)
- Because Android prohibits ordinary installing lower versionCode 63 over versionCode 64, a **same-signer higher-version CODE RETURN** `MOA_R65_GOLDEN_CORE_RESTORE_ONLY.apk` is prepared. SHA-256 `e7e7f3e438dbb909ac1e09aa157b1fefa3f031e2e04e3b99bdf781ed29fb3b7d`, 3,422,751 bytes, versionCode 65.
- R65 is **exact R63 Golden 54 APK members byte-identical except AndroidManifest.xml versionCode/name**. R63 Golden native DEX and original 52 other files unchanged, same signer certificate; APK v2/ZIP PASS. Provides no-data-clear code return **if** R64 UX regresses; this is not full device state/shortcut metadata migration/physical rollback proof. Never uninstall/clear user data. Do not install R65 except to return from R64; existing installed R63 Golden user should stay on R63 unless explicitly testing R64.
- Do not label R64 or R65 as "new Golden"; R63 remains the immutable physical successful reference.

## Required physical acceptance before upgrade to future Golden
1. R63 photo+native Korean speech/text memo-> correct 11/03 curated media-card+minute notes still PASS, no second dialog; reopen still visible.
2. Camera capture yields ONE obvious accessible lower thumb-zone pill (not two top banners), tap `바로 기록` opens original memo. Test both left and right side; vertical drag saves selected position; system heads-up fallback when overlays disabled.
3. OHO+ left/right selected gesture via MOA shortcut truly toggles running monitor ON→OFF→ON, normal QS tile matches, without having to pull quick panel twice. If shortcut not listed, do not claim supported.
4. Photo/video, consecutive shots, original records, diary selection/edit, camera controls/shutter, notification fallback, data/signature continuity.
