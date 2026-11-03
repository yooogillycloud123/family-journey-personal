# MOA R63 — USER PHYSICAL GOLDEN LOCK — 2026-11-03 (latest, highest MOA priority)

> **NEW FACT OVERRIDES earlier R63 "DEVICE NOT YET VERIFIED" language.** On 2026-11-03 the user explicitly confirmed: **"드디어 성공이다 ... 골든으로 일단 지침에 때려박아"**, with three actual Samsung Galaxy screenshots from the installed R63 showing curated/photo diary media slots, native memo text and original capture time. The user requests to freeze the proven core and continue ONLY incremental usability fixes.

## 1. Exactly what the user physically demonstrated (do not exaggerate)
- Screenshot `18302.png` (conversation evidence, DO NOT add user photos to public GitHub): MOA Diary > "사진·영상으로 보는 하루" > group **22:23~22:24**, badge **3장**, with **THREE individual photo/video cards** and memo lines visibly present:
  - `22:23 · 저장`
  - `22:23 · 율리`
  - `22:24 · 오케이 그러면 이제 문제가`
  On-screen old editor/navigation remains visible (일기 편집, 전날/다음날, bottom tabs 나의 지도 / 기록 / 일기 / 설정). User explicitly confirms R63 is the long-awaited working Golden.
- Screenshot `18297.png`: Samsung Camera shows TWO visible capture entry surfaces simultaneously: (1) Android heads-up notification `방금 촬영한 사진·영상...` at the top and (2) app TYPE_APPLICATION_OVERLAY banner `모아 · 사진 촬영됨 [바로 기록]` just below it. Both refer to the *same* native memo activity and are not two independent diary-save workflows.
- Screenshot `1793712632087.png`: Current Quick Settings `모아 기록` tile, reached via repeated downward swipes. This is the user’s UX problem, not an issue with successful diary storage.
- **Precisely bounded PASS:** native Samsung Camera capture alert + one memo entry -> actual photo/video MEDIA CARD IDs plus memo lines visible in the existing curated diary at capture clock times, with no second R42 memo dialog reported by the user. **Do not claim tested image thumbnail pixels or relaunch/reboot durability:** the three photo card image areas appear pale/blank in the screenshot; thumbnail rendering is a separate open issue, not evidence to revert the successful data pipeline. A screenshot alone does not verify across-device behavior or shutdown/relaunch persistence.
- Treat this user physical result as **MOA R63 USER DEVICE GOLDEN** for its observed photo/media-card, memo, and time association behavior. All earlier R59, R60, R61, R62 device FAIL remain historical evidence, NOT recommended rollback bases.

## 2. Exact installed release / binary identity (IMMUTABLE, DO NOT REPACKAGE AS "GOLDEN" WITH MODIFICATIONS)
- File distributed and user installed: `MOA_R63_Download.apk` (also `MOA_R63_Install_20261103.apk`).
- APK SHA-256 **`64b1b730478a2a50976961cc2dc4cf511182a75495f2d02159f091167f646024`**, exact **3,422,752 bytes**.
- Package `com.juhyeon.familyjournea`, versionCode **63**, versionName `MOA-R63-Safe-Capture`.
- Signer public certificate SHA-256 **`5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`** (same R62; private key NEVER publish).
- Exact protected APK entries:
  - `classes4.dex`: SHA-256 `82fa235efcef7f06e0357cd6d3d77d95bda92f91ab195a14937a0ec78301e057`, 58,012 bytes.
  - `assets/web/family-diary.js`: SHA-256 `70254142e1d60b80e6ea01f4f199fb241145c21d3f451a1b20cd1253e7c08fdd`, 72,370 bytes.
  - `assets/web/moa-direct-diary-commit.html`: SHA-256 `0690962b5261a9d372b7f8dee9d6ef4719ec380793f147a9bab36cdf5585eb3d`, 4,468 bytes.
- R62→R63 APK change set: existing `AndroidManifest.xml`, `classes4.dex`, `assets/web/family-diary.js`; added exactly `assets/web/moa-direct-diary-commit.html`; remaining 50 entries byte-identical. APK v2/DEX integrity/ZIP CRC static PASS before user's subsequent physical PASS.
- Source branch frozen **`golden/moa-r63-20261103-user-device-pass-do-not-modify`** from commit **`bdc6003577ba062c7100e43e334ef9a4d834f431`**; compiled DEX source at commit **`c287e39afa950a6fb9d7e7958d834e33e34bb7c9`**, GitHub Actions #**41642111207** SUCCESS. Builder/test sources linked in `MOA_R63_DIRECT_IDB_WRITE_RELEASE_READ_FIRST_20261103.md`.
- Keep original R37 `com.juhyeon.familyjourne8` and all existing user diary data untouched. No new package, duplicated helper app or signer identity.

## 3. The actual logic and causal reasoning that solved R58-R62 regression
1. Original R42's *second WebView popup* could save with `dbPut('curated',localCaptureDay,record)`. This path worked but required opening MOA and typing a second time. R58 removed duplicate popup BEFORE a reliable native->WebView transport existed, causing apparent "saved" native memo never to appear in diary.
2. R59-R62 kept trying to make `MoaMomentApplication / MoaMomentInboxSync`, native JS bridge and HostActivity WebView resume/injection reliable. Actual user R61/R62 run-as snapshots showed native `m:` records with note and valid media IDs/timestamps, active HostActivity, but `bridgeDiagnostic` and `inboxSyncDiagnostic` empty, **no curated DB commit**. Repeated code/DEX static PASS did not resolve actual installed-runtime path.
3. R63 adds `MoaMomentDirectDiaryStore`: after native Save via `MoaMomentMemoActivity`, also via foreground `MoaMomentCaptureService` and `MoaMomentApplication.onCreate` reconciliation, it uses a **private same-origin WebView** with bundled trusted HTML and `loadDataWithBaseURL('https://familyjourney.local/',...)` to open the user's **existing** IndexedDB `familyjourney-diary-v1` object store `curated`. This path **does not require** HostActivity injection, `MoaMomentNative` bridge visibility, or the old WebView popup. No second app.
4. It writes each intentional `m:<photo/video id>` note to the **original capture local calendar day**, keeps original media ID, `at` timestamp, and existing day fields, merges multiple same-day captures and suppresses duplicates, does IDB transaction completion **and readback**, and only then tags matching native draft fingerprint with a committed-ACK. Never assume a successful native SharedPreferences write equals curated DB persistence.
5. An additional essential fix in `assets/web/family-diary.js`: old `S.curatedEntries` cached selected diary indefinitely; R63 re-reads `dbAll('curated')` on diary open and foreground focus before render. Without this, successful background DB changes could be invisible despite commit.
6. User screenshot now shows 3 media records and original-minute note placements in the selected photo diary: physical confirmation of the **combined direct-IDB + display refresh** effect. Do not wrongly ascribe all previous failures to one unproven Java lifecycle exception.

## 4. ABSOLUTE NO-REGRESSION LOCK
- Do NOT rewrite/remove or replace `MoaMomentDirectDiaryStore.java`, same-origin writer HTML, note+photo ID mapping, capture timestamp/day normalization, curated store schema, transaction/readback/ACK, `family-diary.js` curated refresh and one-native-input/suppressed second popup.
- Do NOT swap in R59/R60/R61/R62 DEX or re-enable R42 second popup to "fix" UX.
- No format/schema migration, unrelated native speech/camera capture method changes, or app-data deletion; no package/signer changes.
- ALL future improvements must branch from locked R63 Golden, not overwrite it; new v64+ variants can change **only targeted UX** after byte-diff and repeat test. Preserve immutable Golden APK as rollback evidence, though Android downgrade may be blocked without higher code version/signing and data migration.
- Golden is not a blanket claim every surface works: screenshot card thumbnails are pale/blank, multiple camera alerts inconvenient, One Hand Operation+ direct recording toggle not yet built. These are separate follow-up workstreams.

## 5. Explicit next tasks from SAME user message (NOT yet physically tested)
### P1 — one reachable camera prompt, no top duplicates
- Source proven: `MoaMomentCaptureService.showCapture` posts HIGH-importance `CH_EVENT` heads-up notification AND `showOptionalCameraOverlay`; overlay uses `TYPE_APPLICATION_OVERLAY`, `Gravity.TOP`, `p.y=130`, 8,500ms timeout. Android system heads-up's location is OS-owned and **cannot be moved by MOA**.
- Preferred UX: floating "바로 기록" **one thumb-accessible lower-left/right** small button/pill, not over camera shutter/zoom; user-adjustable position (left/right, draggable if safe), short auto-dismiss. Keep same PendingIntent native memo entry. App notification remains as silent/normal notification-center fallback, but no *second heads-up* when overlay is shown; if overlay permission unavailable, retain actionable heads-up as fallback. Android notification channel importance is immutable after creation: use a new low/default channel ID only after verifying config and OS prompts.
- Do NOT change MediaStore monitoring, photo timestamps or diary commits.

### P2 — Samsung One Hand Operation+ one-swipe capture monitor toggle
- Current `MoaMomentCaptureService.QuickTile.onClick()` toggles same `switchTo(context,on)` but is buried in expanded QS panel.
- Official Samsung OHO+ supports **"Home screen shortcuts"**, and "Start application"; it does not automatically invoke arbitrary MOA TileService buttons. Implement an Android **app shortcut** named `모아 기록 전환` routed to a tiny purpose-built non-launcher ToggleActivity (or equivalent manifest-declared Activity) that calls the **same** `MoaMomentCaptureService.switchTo` + `updateTile`, shows ON/OFF feedback, and finishes immediately. This provides selectable OHO+ **홈 화면 바로가기** gesture action without any extra app icon/helper APK; actual Samsung OHO+ shortcut discoverability and in-place gesture behavior require real-device validation. No assumption of silently launching a background Service with non-exempt restrictions.
- Keep existing QS tile, include graceful permissions/Android background restrictions paths and avoid repeated immediate toggles due to accidental gesture. User wants **one swipe → genuine ON/OFF**, not just opening MOA or QS.
- Before implementation verify OHO+ actual chooser exposes the manifest/static/pinned shortcut on user's One UI build. Samsung official materials describe shortcuts, but third-party shortcut launching behavior may vary.

### P3 — thumbnail media card rendering
- Screenshot includes 3 cards whose image preview areas are pale/empty. Treat **as unverified visual** until original files/permissions/thumbnail rendering are examined; do not change the successful curated ID/media time mappings while diagnosing.

## 6. Next acceptance/regression test for UX versions
- R63 Golden itself MUST remain installable and unchanged; create new version on a separate branch.
- With photo monitor ON, Samsung Camera takes photo -> **one** thumb-zone overlay, opens existing one native memo -> record attaches to selected photo diary correct original timestamp -> no second modal -> close/reopen still present. In overlay-permission-off case, notification fallback works.
- OHO+ left/right swipe toggles actual native monitor; tile and service are in sync, ON→OFF→ON, without opening full settings or duplicating apps.
- Verify video, multiple same-day photos, edit/delete selected photo, original family diary/map/record/settings, earlier user data, signature/package continuity. Don't label UX variant Golden before physical user pass.
