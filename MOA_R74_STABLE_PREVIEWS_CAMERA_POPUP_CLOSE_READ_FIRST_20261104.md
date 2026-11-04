# MOA R74 — previously loaded photo previews remain visible + dismiss current camera pill (2026-11-04)

## Actual Samsung user evidence and acceptance
- User's uploaded R73 screenshots clearly confirm **near-immediate new curated diary photo ID + native memo/timestamp** display. 12:15~12:19 photo and 12:40~12:44 photo/memo display immediately. The first screenshots show pale/blank preview boxes, and later screenshots show the SAME thumbnails without tapping or re-saving. Tapping the blank thumbnail opens the original Gallery photo, proving the underlying photo ID/record exists and is accessible. **R73 data sync PASS, thumbnail stability/latency UX FAIL**.
- Another Samsung screenshot shows the lower camera overlay pill `모아 | 바로 기록` even after user decided not to record. Automatic timeout is 8500ms; user requests a **manual × dismiss** for the current popup without disabling photo monitoring, moving the button, breaking `바로 기록`, or suppressing subsequent camera events.
- No new R74 Samsung test yet: new code/compiler/signature is verified but not on-device behavior.

## 1. Source-verified root cause of preview flicker/blank
- Exact signed R73 `assets/web/family-diary.js` `render()` executes `S.root.replaceChildren()` for all stage updates, tearing down already loaded image DOM even when no underlying visible diary photo changes.
- Old R37 RAM thumbnail LRU `r37Ram` has 18MiB total and skips items above 256KiB. A newly constructed card can have no `src` even when the previous one had a loaded thumbnail. It then calls `thumbs()` to ask native `__requestThumbs` again, sometimes behind a 13k+ MediaStore scan on HostActivity's SINGLE background executor. Thumbnail requests can complete after the old image node is detached, and the old code only paints nodes from its obsolete `pending` list.
- This fits the user-observed blank-first, image-later cycle without contradicting successful IndexedDB memo persistence. Still, individual actual thumbnail latency/driver scheduling needs Galaxy trace for quantitative proof.

## 2. Minimal R74 fix (no new database writes or schema)
1. A **bounded transient 14MiB on-screen-image buffer** `r74Preview` remembers only loaded `data:image/` thumbnails from displayed elements (max 350k characters per thumb). Before `render()` replaces nodes, `r74KeepVisible()` snapshots their valid previews, complementing the untouched R37 LRU. On subsequent `thumbs()`, the buffer has first priority; images therefore can be repainted immediately without a repeat native fetch.
2. When an asynchronously returned native thumbnail arrives after a UI re-render, the new `thumbs()` writes it into that temporary buffer AND paints the **current connected image elements with matching media ID + thumbnail size**, instead of only its now-detached original nodes.
3. When the complete native MediaStore index is **identical** and no confirmed missing media changed, avoid a redundant `render()` and show status only; the old image nodes remain intact. When a previously present original is really absent from the full index, re-render is still executed to remove its card.
4. After authoritative missing/deleted gallery reconcilation `r74DropMissing()` discards stale RAM preview entries for those missing original IDs. **Diary title/body/timed memo remains untouched**, gallery originals are NEVER deleted, `removedMediaIds` explicit exclusions continue to apply. A new photo's first thumbnail can still take time if it has not been generated before; no promise of instantaneous first decoding or complete removal of the unchanged native full scan.
5. No thumbnail buffer is persisted to `curated`, `photo-index`, any new IDB store, cloud service, or backup. Short-lived screen memory only.

## 3. Current-shot popup dismissal
- Exact `MoaMomentCaptureService.showOptionalCameraOverlay(PendingIntent target,int notificationId)` in Java now adds a small accessible `×` (`TextView`, 42×46dp hit area, label `이번 촬영 바로 기록 알림 닫기`) next to the **existing** `바로 기록` button.
- On ×: only `removeOptionalCameraOverlay()` for the current visible card and `NotificationManager.cancel(notificationId)` for its single quiet capture notification. **Does NOT invoke `switchTo`, clear monitor `enabled`, delete gallery photo, remove already saved memo, or call the native Save path.** Future photos still trigger normal new overlays.
- Existing `모아` pill handle's left/right position toggle, vertical drag, the `바로 기록` PendingIntent, 8500ms auto-dismiss, duplicate-alert fallback, MediaStore scanning 300ms schedule, QS+One Hand Operation+ recording toggle are untouched.

## 4. Binary and verification
- Exact BASE R73 signed APK SHA-256 `34efac2a395c6c21a615b5367ac1101523c36c5732133701217870a06cbe07a1`, 3,434,405 bytes, original signer's certificate SHA-256 `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`.
- **R74 installer** `MOA_R74_Install.apk`: versionCode **74**, package `com.juhyeon.familyjournea`, signer unchanged, **3,437,120 bytes**, SHA-256 **`4d8ed5a46d0c933db7d805322c8ee591c5f8e9b6fef31e9b893e886cb35239f2`**.
- Only **3 of 55 APK entries change**: `AndroidManifest.xml` (version 73→74), `classes4.dex` (overlay dismiss only), `assets/web/family-diary.js` (display cache/hotpaint/skip redundant redraw). Other **52 entries EXACT byte identical**, including R63 Golden `assets/web/moa-direct-diary-commit.html`, original base `classes.dex/classes2.dex/classes3.dex` NAVER and all UI resources.
- Java branch `fix/moa-r74-stable-thumbnails-dismissible-camera-pill-20261104` GitHub Actions D8 compile run **41769797290 SUCCESS**, classes4.dex **69,204 bytes**, SHA-256 `c48a29f0d5a3947d37aeff68dabbb7cf85cf2e92ee398e5644b011288c9121de`.
- APK v2 signature/certificate verification PASS, ZIP CRC PASS, DEX SHA-1/Adler-32 integrity PASS, `node --check` JS PASS.
- R73's gallery deletion/exclusion/recovery test PASS; R63 actual direct IndexedDB mock (multiple same-day photos, original timestamp, dedupe, preserving authored diary body) PASS.
- R74 additional tests PASS: *previously visible thumbnails after full DOM rebuild, incomplete replacement cannot erase valid thumb, confirmed deletion removes in-memory preview, bounded cache, delayed native thumb updates current DOM immediately, deleted source never repainted*. Tests use synthetic image IDs and data, not user's private photos.
- Verified exact ZIP member diff and protected Golden byte-for-byte hash checks. NO on-device R74 pass claimed.

## 5. Artifacts, source, data safety
- Private Library APK `/모아_프로젝트_근거_20261103/MOA_R74_STABLE_THUMBNAIL_DISMISS_PILL_BETA.apk`.
- Private Library source+tests, **no private signing keys/photos** `/모아_프로젝트_근거_20261103/MOA_R74_NO_KEYS_SOURCE_AND_VERIFICATION.zip`.
- Actual release files for user: `MOA_R74_Install.apk`, `MOA_R74_Install_Backup.zip`, `MOA_R74_Source_Verification_NoKeys.zip`.
- Existing R63 physical Golden branch `golden/moa-r63-20261103-user-device-pass-do-not-modify` and APK SHA-256 `64b1b730478a2a50976961cc2dc4cf511182a75495f2d02159f091167f646024` remain protected. No uninstall, no clearing app data, no reinstall as new package/helper.

## 6. Next real Galaxy checks
- Update R73→R74 in place, do not remove app/data. Open existing 11/04 photo diary and add/sync one short **optional** new test note if desired; previously loaded cards should stay filled, and fresh photo's thumbnail should paint when native bitmap arrives, no full-screen reset/flicker. Exact render time not promised; device test is pending.
- Samsung Camera take a disposable test picture → lower pill `모아 | 바로 기록 | ×`. Tap **×** to dismiss immediately; verify the quick settings monitor remains ON. Next photo should again generate `바로 기록` and open the original native memo when tapped.
- Gallery delete/move is not necessary for basic acceptance; source mocked tests already cover it. Never require deletion of important family photos. If a disposable source is removed externally, photo card should disappear only after successful index reconciliation while authored memo stays.
- Further optional performance work: native MediaStore generation delta/priority thumb jobs can reduce first thumbnail delay further, but is **not shipped in R74** because it changes the large original `classes2.dex` integration and needs safety verification.
