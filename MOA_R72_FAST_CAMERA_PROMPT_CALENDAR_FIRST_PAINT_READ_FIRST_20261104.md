# MOA R72 — Camera Thumb Prompt Speed + Nonblocking Diary Calendar — 2026-11-04

## 1. New user evidence and EXACT problem
- User reports the existing MOA photo/memo journal is **operational** and shows screenshots (2026-11-04). After taking a photo, the small lower thumb-zone **'모아 바로 기록'** prompt feels slow, subjectively about **3 seconds**. This is an observed estimate, **not a measured instrument trace**.
- The November/October diary calendar grid temporarily **does not appear** when opening MOA while newly written native camera memos are syncing. November's full month cells reappear after background sync/initialization finishes. Screenshots are evidence of temporary UI disappearance, **not proof that original diary records were deleted**. New Nov 4 photos (4-count media marker) are visible after load.
- User explicitly requires both UX improvements **without any regression of actual R63→R71 photo/memo direct diary save, original capture times, 5-minute segments, right/left thumb overlay placement, voice input, on/off, and R71 edit/delete**.

## 2. Proven root causes in user-distributed exact R71 APK source
- In `MoaMomentCaptureService.schedule()` (the R71 `classes4.dex` Java source): `h.removeCallbacks(scan); h.postDelayed(scan,1100)`. Every repeated Samsung MediaStore `ContentObserver.onChange` resets the **1.1-second debounce**, so bursts of media writes can defer first query by more than one second. Includes MediaStore `is_pending!=0`, `_size<=0`, and `dcim/camera` filters. Measured 3s exact latency remains unconfirmed.
- In R71 `assets/web/family-diary.js`: `open()` does `await init();await refreshCuratedFromDatabase();render()`. Therefore **no calendar DOM** is rendered until both initial IDB cache/open and fresh `curated` retrieval resolve. This precisely explains the temporarily missing month cell grid while the successful R63 hidden same-origin WebView is independently persisting notes and the photo index is loading.
- **Not caused by camera capture timestamp or a data deletion**, so no IndexedDB store migration, no re-enabling R42 second popup, no changes to media ID/at mapping.

## 3. Exact targeted R72 edits (from byte-exact signed R71)
- Native event scheduling ONLY: `schedule()` now **coalesces rapid observer signals** via `if(!h.hasCallbacks(scan))h.postDelayed(scan,300L)`. Unlike the old resetting debounce, repeated notifications cannot postpone the already-scheduled scan. **Existing MediaStore row readiness criteria, 6s missed-signal fallback, SharedPreferences commit-before-notification, native memo/stt/editor, overlay design, original timestamp, and R63 direct IDB writer ALL remain unchanged.** Android Java compiled by GitHub Actions run **41759915481 SUCCESS**, branch `fix/moa-r72-fast-calendar-overlay-20261104`, DEX SHA256 `518fc0c9cc143dac4fb9ff452ffd4239686ec81df90fbb0772b566d83180c973`, 68,272 bytes.
- Diary UI ordering ONLY: `open()` now calls **`render()` immediately before `await init()`** to show the month grid without waiting for IndexedDB; following init and `refreshCuratedFromDatabase()` it calls `render()` again, showing fresh records. Guard `if(!S.open)return` prevents late DOM refresh after diary closed. While first load is pending, banner says `일기 자료를 불러오는 중 · 달력은 먼저 표시됩니다`. Existing 5-minute segment and R71 4-button sticky title/time/save/delete controls stay as-is.
- **Do not prematurely claim popup now always displays within 300ms**. The changed number is **scheduling delay**, and overall time also includes camera writing, OS MediaStore notifications, cursor reads, UI dispatch, and device load.

## 4. Installable identical-app R72 static evidence
- EXACT base: R71 `MOA_R71_Install.apk` SHA256 `64725bdfaff9b4507dfab0b7e889d3ddac284066a933e74a1d42f760bb1ecb1a`.
- R72 `MOA_R72_Install.apk`: SHA256 **`974667456d09ebf43053de9039a4431df751defbae08b4b89da1604bc6b9dd76`**, **3,430,803 bytes**, versionCode **72**, same `com.juhyeon.familyjournea` and signing certificate SHA256 `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`.
- Changed **3/55** ZIP members: `AndroidManifest.xml`, `classes4.dex`, `assets/web/family-diary.js`. **52 BYTE IDENTICAL** to R71, especially `assets/web/moa-direct-diary-commit.html` original successful R63 trusted IndexedDB writer, `classes.dex`, `classes2.dex`, `classes3.dex`, all Naver and static OHO shortcut XML and all media resources.
- Signed APK v2 independent cryptographic verification PASS; DEX header SHA1/Adler32 PASS; ZIP CRC PASS; Node `--check` PASS; actual `open()` extracted into Node mocks with **slow deferred IDB promise** PASS: calendar paint first, then DB hydration, then updated render; original R71 Delete callback and R66 5-minute `segments` unchanged.
- Stored in private Library `/모아_프로젝트_근거_20261103/MOA_R72_FAST_CAPTURE_CALENDAR_BETA.apk` and no-private-keys source/verification ZIP `MOA_R72_Source_Verification_NoKeys.zip`. GitHub Java + patch source branch as above.
- **R72 USER GALAXY DEVICE PERFORMANCE / CALENDAR TEST NOT YET DONE**. Treat as a focused signed beta. Frozen **R63 user-device Golden unchanged**.

## 5. Next gate (minimal)
- Same package/signature in-place R71 → R72, never uninstall or reset.
- One normal Samsung Camera capture while capture monitor enabled: measure approximate shutter-to-lower-thumb '바로 기록' overlay appearance; confirm normal speech/text memo, date/time, image and diary stay intact. Do not force repeat shootings/diagnostics.
- On MOA diary: when native sync/photo index are in progress, **month grid must be visible immediately**, with subsequent photo cover/count updates without disappearance. Month navigation and R71 sticky 4-button edit/save/delete must remain intact. Delete should only happen after existing original confirm().
- If still slow, gather **actual timing/observer-to-overlay** diagnostic before another speculative numeric delay adjustment. Do not replace native service/IDB architecture.
