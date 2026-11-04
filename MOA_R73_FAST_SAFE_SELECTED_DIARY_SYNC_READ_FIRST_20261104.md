# MOA R73 — Selected-photo fast calendar / deletion-safe reconciliation — 2026-11-04

> **Latest source-backed and signed installation candidate. R72 user reflected/works, R73 Galaxy runtime NOT YET TESTED.** Preserve R63 user-tested direct IndexedDB Golden forever. User expressly required both maximum feasible new-photo sync speed and CORRECT gallery deletion/movement handling. Do not solve speed by disabling the existing full MediaStore indexer or deleting author-written data.

## 1. User's actual request and constraints
- R72 fixes were reflected on the real Galaxy, but first new photo + native memo appears in calendar only after an additional perceptible sync wait.
- Original private gallery photo(s) can be physically deleted/moved; their outdated IDs must not be rendered forever.
- Keep full family diary features, 5-minute visual groups, original native capture minute/photoId, user title/body/time-note edits, 4-button sticky edit/delete+confirmation, STT, thumb-zone capture prompt, R70 shortcut toggle and NAVER automation exactly as in R72.

## 2. What exact R72 source revealed
- Original R72 `assets/web/family-diary.js` `init()` awaited full `curated` and `entries` followed by reading cover-meta, the cached **complete** 13k+ gallery `photo-index`, and thumbnail cache before re-rendering with recent notes.
- `refreshCuratedFromDatabase()` re-read committed `curated` only after this chain.
- `loadIndex(false)` still requests original HostActivity native `diaryPhotoIndex`, which scans all photo/video MediaStore IDs in batches and replaces the JS media map only at full completion.
- Successful R63 direct writer ALREADY saved `curated` entries with `photoIds` and `moments[{at, photoIds, note}]` including exact local original capture time. Native writer's **same-origin transactional IDB commit/readback untouched**.

## 3. Implemented R73 fast first display
- Exact R72 APK JS now builds **ephemeral in-memory** media-ID/time objects from already committed `curated` day records, validated per-day, integer-id format, capture millisecond, user excluded `removedMediaIds`; VIDEO IDs retain `v` prefix.
- `init()` invokes `r73HydrateSelected()` and first `render()` **immediately when selected diary text records arrive**, BEFORE waiting on photo-index/cover/thumbnail cache.
- Selected-photo calendar/day/timeline resolves `S.byId` (actual/cache native media) first, otherwise provisional mediaId from selected curated note. No automatic photo gallery or picker modification, no new duplicate second memo popup. The full original native MediaStore scan runs **in background**, still.
- A second `dbAll('curated')` fresh read after `init()` is preserved to cover native commit races. No IndexedDB schema change, provisional media never written into `meta/photo-index` or `curated`.
- Screens/stats no longer crash when a curated day references a photo ID absent from actual index; the calendar shows a no-original marker instead of dereferencing an empty `chosenCover.id`.
- Safe privacy-neutral timing method `window.__moaR73SyncDiagnostics()` returns only milliseconds and aggregate missing/provisional COUNTS, no photo IDs or private note text.

## 4. Deleted, moved or excluded originals (explicit regression gates)
- **User excludes a photo from selected diary**: `removedMediaIds` prevents the fallback from reintroducing it, while the gallery original remains. Old `removeOneDiaryMedia` / `restoreOneDiaryMedia` behavior and original diary database remain untouched.
- **User deletes a photo physically in Samsung Gallery**: background full MediaStore scan yields an authoritative index lacking its ID. `r73ReconcileFullIndex` marks that older, absent ID missing; selected photo preview/card goes away; **original diary entry/title/body/moment/note is NOT deleted**. When a moment loses its visible original, its original Korean note is shown in a separate “원본 사진을 찾지 못함 · 메모 보존됨” area so the user's journal text isn't silently lost.
- **Photo is restored/permission restored**: the next complete native index contains its original ID, and index matching removes the missing flag. No remapping by filename/time to a different photo, no copying/deleting original gallery items.
- **Recent captures created during a full scan**: 15-second scan-start safety margin prevents false “deleted” classification while Samsung Camera is finalizing a row. The next scan reconciles.
- **Temporarily empty native scan**: existing R72 safety guard protects a previously populated index instead of treating a single blank response as a mass deletion. True full-library deletion is conservative and may need a second user-triggered rescan; no diary text is erased. Partial media permission can also make an ID unresolvable, so “original unavailable” does not prove physical deletion.
- **Whole diary deletion**: existing protected `remove()` must still require user confirmation, delete ONLY current diary date record from `curated`/entries, never delete gallery originals.

## 5. Signed APK, source, test and residual work
- Exact input: `MOA_R72_Install.apk`, SHA-256 `974667456d09ebf43053de9039a4431df751defbae08b4b89da1604bc6b9dd76`.
- Final deliverable: `MOA_R73_Install.apk`, versionCode 73, same package `com.juhyeon.familyjournea`, same original signer certificate SHA256 `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`; **3,434,405 bytes**, APK SHA-256 **`34efac2a395c6c21a615b5367ac1101523c36c5732133701217870a06cbe07a1`**.
- EXACT APK diff: only **2/55 members** changed: `AndroidManifest.xml` version 72→73 and `assets/web/family-diary.js` presentation fast-path. **53/55 are BYTE IDENTICAL** to R72, including `classes*.dex`, original R63 `assets/web/moa-direct-diary-commit.html` writer, screenshot thumb native driver, camera 300ms scheduling, R70 OHO, R71 delete, NAVER and shortcut XML.
- APK v2 signature + public cert match, ZIP CRC, JS Node syntax PASS; Node test covers 2 old photos+video, recent ID, excluded photo, externally absent photo, restoration, whole-day diary delete, orphan note preservation markers, existing five-minute/save/delete protections PASS; independent original R63 Node fake IndexedDB writer regression PASS.
- **This is Stage A (fast selected-photo FIRST DISPLAY), not Stage B native MediaStore generation-delta indexing.** The background full 13k+ media enumeration remains. No claim of exact 0.1s or guaranteed Samsung runtime improvement without physical timing.
- Scripts, resulting R73 diary JS and tests kept in private Library `/모아_프로젝트_근거_20261103/MOA_R73_FAST_SAFE_Source_Verification_NoKeys.zip`; signed APK stored there as `MOA_R73_FAST_SAFE_DIARY_SYNC_BETA.apk`. No private keys, passwords, family photos or original private notes published.
- Source/reference branch: `fix/moa-r73-fast-selected-media-deletion-safe-20261104`; patch source in Library ZIP and standalone `MOA_R73_FAST_SAFE_PATCH_SOURCE.py`, test `MOA_R73_FAST_SAFE_DEL_TEST.cjs`.

## 6. Next device gate and next major optimization
- Install as an **in-place R72 → R73 update**, NEVER uninstall/reset; open the existing selected-photo diary. Newly committed photos/notes should appear before the media full enumeration completes, while background reconciliation later removes deleted-gallery originals but leaves notes.
- Test with a **disposable gallery test picture only** if desired; never instruct deletion of valuable user photos or user diary. Source-grade deletion tests already performed.
- Determine real latencies using R73's aggregate timing diagnostics, not marketing promises.
- For further maximum work reduction, build **Stage B** separately: Android MediaStore `getVersion/getGeneration`, `GENERATION_ADDED/MODIFIED` delta rows + deletion audit/full-scan invalidation. This needs exact compiled HostActivity/JS bridge parity and independent safety/regression tests before any APK. Do not blindly recompile original large `classes2.dex` or disable deletion audits.

## 7. GOLDEN distinction
- R63 user-verified direct writer remains immutable Golden; R72 modifications confirmed reflected by user; R73 new APK **STATIC VERIFIED BETA only**, no user Galaxy R73 PASS yet.
