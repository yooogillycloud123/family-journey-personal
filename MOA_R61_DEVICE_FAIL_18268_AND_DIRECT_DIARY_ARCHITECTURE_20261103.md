# MOA R61 physical failure — 2026-11-03 19:57 KST video 18268.mp4 (mandatory, overrides release claims)

## User-confirmed failure and hard evidence
- User Galaxy S26 Ultra: original Samsung camera 1 photo -> immediate capture prompt -> native Android voice STT or typed memo -> user pressed "모아 일기에 메모 저장", native note saved locally (or pending) -> **November 3 curated diary remained 0 entries/auto total unchanged**. User's native-save experience is not a successful diary commit.
- User video `18268.mp4` (57.265533 seconds) shows the exact R61 diagnostic popup at approx 18–20s:
  `Native bridge: NOT EXPOSED`
  `Java inbox last packet: null`
  `Web native polling: {"state":"WAIT_NATIVE_BRIDGE","detail":"native.drafts or IDB consumer not ready","at":1793703217647}`
  `사진 색인: 13126장, 영상 983개`, `사진 색인 읽는 중: false`, `선택 일기: 1일`.
- **The UI 'Java inbox last packet: null' is the JS `window.__moaR60LastDelivery` variable, NOT the Android `MoaMomentInboxSync.inboxSyncDiagnostic` from SharedPreferences.** It does not prove whether Java Activity callbacks fired, which WebView was targeted, or why data was rejected. Do not conflate.
- Screens show new MediaStore index works, so do not rebuild camera scanner. User-proven GOLDEN native photo capture overlay, Android Korean STT, typed native memo remain protected.

## Source-confirmed architecture regression
- Older R42 on-return popup used `assets/web/family-diary.js` direct `dbPut('curated', day, updated)` inside the WebView. This **really committed to the displayed IndexedDB**, according to user's previous real use.
- New native `MoaMomentMemoActivity` saves `m:<photo/video id>` JSON with `note`, `memoSaved=true` to Android `SharedPreferences.commit()` and toast explicitly says `메모 임시 저장 완료 · 모아 일기 동기화 대기`. This is **a durable native pending record, not a verified diary IndexedDB commit**.
- R58 deliberately disabled all old R42 modal auto-run (`MOA_R58_SINGLE_NATIVE_CAPTURE=true`), *before* a reliable native->WebView transfer existed. This removed the one user-proven diary-commit path. Subsequent R59–R61 repairs claimed code fixes but this video proves **end-to-end STILL FAILS**.
- In R61 JS `window.__moaNativeSync` is present and writes via old R42 `dbPut('curated')` with commit/readback, but user sees `MoaMomentNative` not exposed. The Java `MoaMomentInboxSync` supposedly calls `WebView.evaluateJavascript(__moaNativeSync)` independently, but no private `inboxSyncDiagnostic` was captured to establish whether it ran. **Do not assert a single definite Java failure cause on the basis of UI variable `null`.**

## Correct next architecture and gate (user requirement)
Keep exactly ONE user prompt (native Android memo UI in Samsung Camera). Keep **single diary save engine/format** and no 2nd popup. A reliable way to fulfill save without opening MOA is:
1. Treat the Android-side persist of photo/video id, actual `MediaStore` capture timestamp, note, and `memoSaved` as a **canonical durable moment journal** with unique key + transaction and visible save success/failure. Commit once while memo activity is visible (no MOA launch needed). Existing SharedPreferences drafts currently satisfy durable pending, but need actual API/UI contract that distinguishes diary-state from pending sync.
2. On opening MOA, read that *same canonical journal* through verified Android bridge/host IPC (not imaginary `MoaMomentNative`), call **the exact existing** `dbPut('curated', day, doc)` consumer without showing a popup, verify `IndexedDB` commit and read-back; ACK deletes only sync queue not canonical journal. Re-render diary immediately.
3. If transport fails, keep canonical record and retry; show accurate `저장됨(기기)/일기 동기화 대기/일기 반영 완료` statuses, never false success and never erase.
4. Optional future migration to Room/SQLite native canonical diary avoids browser IndexedDB being required for *immediate on-device persistence*. Claim that existing WebView IndexedDB updated while MOA was never opened only after an actual headless WebView/background strategy is implemented, and distinguish it from immediate native durability. No private photo data transfer to third-party service.

## Current action
**Do NOT release speculative R62 APK**. Instead obtain direct, read-only R61 `inboxSyncDiagnostic`, `bridgeDiagnostic`, saved `m:` counts and note lengths using the prepared ZIP `MOA_R61_저장실패_기존앱_읽기전용_진단.zip` (same code as R59 tool updated to R61; never reads or exports original note content). Current installed APK is debuggable and can be inspected via ADB `run-as` without app removal/reset/signing key.
- Branch `fix/moa-r61-native-to-existing-diary-idb-20261103` source classes `MoaMomentApplication.java`, `MoaMomentInboxSync.java` are the true existing chain to instrument. Original HostActivity APK must not be replaced blindly.
- User prior screenshots include original different-package MOA R37; **never uninstall or clear either app**. Preserve signer SHA256 `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`; no repeated new icon or package.
- Acceptance: unique native note→one Save→native record durable without MOA open→MOA open shows media+note at actual capture timestamp WITHOUT another editor→app relaunch persisted→2+ additional captures/voice and edited note repeat; failed bridge leaves retryable pending note. No more `89/89` static PASS as proxy for real user success.
