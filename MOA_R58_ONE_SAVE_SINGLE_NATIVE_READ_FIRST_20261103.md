# MOA R58 — 2026-11-03 Samsung Camera one-save, one-popup fix (R57 regression)

**Mandatory newest MOA checkpoint.** Read this before any further MOA build along with `MOA_ABSOLUTE_READ_FIRST_20261103.md`, `MOA_WIP_CHECKPOINT_CURRENT.md`, `MOA_R57_GOLDEN_ISSUES_READ_FIRST_20261103.md`. R54 native camera+Korean voice is user-proven GOLDEN. R58 Android device proof is **NOT YET AVAILABLE**.

## Evidence and confirmed code-level root cause
- User screenshot `1793694105758.png`, real 37.48s Samsung screen recording `18216.mp4`: native memo saves, then entering MOA displays extra R42 `촬영한 사진·영상 ... 시간대별 메모` popup despite a note already typed. User can also see a legacy green `순간 기록 ON` button separate from native quick tile.
- R57 `assets/web/family-diary.js` has **two different record pipelines running simultaneously**:
  1. Native Android `MoaMomentCaptureService` → `MoaMomentMemoActivity` → `SharedPreferences.commit()` locally → independent `__moaNativeSync` indexedDB write on MOA opening → successful `native.ack(id)` deletes draft.
  2. Legacy R42 `mmEnabled`/R42 localStorage flag → `mmHandleIndex()` → `mmCandidates()` → `mmFlush()` → `mmPrompt()/mmShowEditor()`, i.e. the second WebView pop-up on returning to MOA.
- R57 checked `MoaMomentNative.drafts()` to suppress duplicate R42 prompts. But successful native `ack()` deletes a draft; when the legacy pipeline scans afterward it no longer sees that native ID. Whether this *exact* timing occurred is not proven without device logs, but the duplicate paths and too-narrow gate are explicit in source. R57's green UI switch controlled only old web localStorage and was independent of the real native watcher.

## R58 APK outcome
- APK `MOA_R58_단일촬영기록_중복팝업차단_동일앱업데이트.apk`
- SHA256 `ee65319ae370c4aa5de4f2867aee6578814bdceba3227b12a9305230fa76df6e`
- Package `com.juhyeon.familyjournea`, versionCode **58**, versionName `MOA-R58-Safe-Capture`. Updates installed R57; same existing R39/R54/R55/R57 certificate fingerprint `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`. **No new package/key/icon.** The original R37 `com.juhyeon.familyjourne8` is a *separate* app and remains untouched; never uninstall or wipe data.
- Only **two ZIP entries change** relative to R57: `AndroidManifest.xml` version 57→58, and `assets/web/family-diary.js`. All other **51 entries** (all classes*.dex including native camera/overlay/speech/notification, original UI and map/day diary modules) byte-identical. Golden preserved.
- R58 makes native-only the one active automatic capture path; old R42 on-return automatic modal/queue explicitly deactivated, but existing manual notes, day diary, photo/video delete+restore remain. Web `촬영 즉시 기록 ON/OFF` controls **actual native `MoaMomentNative.enabled()/setEnabled()`**, not legacy localStorage, same watcher as quick settings `모아 기록`. On returning to MOA, it syncs native draft silently without a new pop-up.
- The native memo save is immediately durable to local Android `SharedPreferences.commit()`. **Diary IndexedDB sync still happens when MOA app WebView is opened**, not automatically while MOA never runs. This is not a complete background syncing system and should not be sold as such. On failed sync, draft is retained and retried.
- Independent static checks **89/89 PASS**: verify R57 and R58 APK v2 RSA SHA256 PKCS1 signature and content digest; cert identity, AXML manifest version and unchanged permissions, ZIP, 4 DEX signatures/adler, alignment, 51 byte-identical entries, Node syntax, dynamic R42 no-popup/native-toggle model, native commit ACK/retry model.
- **Real Samsung Galaxy Android install/photo test is pending**. Do not call this a user-confirmed final build until actual phone confirms.

## User-specific test and nonnegotiable regression gate
Keep R57 app installed (do not delete or clear data), install R58 **as an update**. Check actual QS `모아 기록` ON and green R58 button both reflect ON. Take 2 Samsung photos (and optional video), tap camera overlay `바로 기록`, say/write a unique memo, save once, open MOA, require diary timeline note at capture timestamp and **NO second R42 WebView modal**, exit/re-enter and verify persistence. Turn one native switch OFF → no recording popup; reenable by QS or MOA switch → capture and one-save succeed. Test existing per-media removal/restore; original gallery files untouched.

## Rollback and future chat
R57 rollback APK SHA256 `cb1031197250c3e8f708c3be0599df20b89a5fc6bda0044d6e439075ddecb5f9` is kept private. Never downgrade-install over R58 without a safe, data-preserving plan. Keep original R37 data. Future work: user-proven Android test; improve truly background IDB sync **only after** current one-prompt workflow is stable, without rewriting native camera/Google voice; preserve single-package signer and add regression tests.
