# MOA R63 — native photo memo direct IndexedDB diary commit (2026-11-03)

## User's actual R62 physical FAIL — strongest current evidence
- User reports R62 APK installed but **2026-11-03 '내가 고른 사진 일기' has NO photo and NO memo** despite native Save.
- Three read-only v4 reports from 21:53:23 / 21:53:59 / 21:56:03. One first try ADB unauthorized; subsequent two were authorized and read app private prefs.
- Exact installed R62 APK SHA256 `e1abe553ee1a9d5565b0c90eb8a207524f794430c249363f8f9e39f6adc4df8e`.
- On 21:56, `MOA_HOST_SCREEN_ACTIVE=True` before and after, 34 `m:` captured drafts / 8 `memoSaved=true` / 13 non-empty notes, 13 native records eligible for sync, **13/13 valid capture timestamp and media IDs**, but `BRIDGE_DIAGNOSTIC=<empty>`, `INBOX_SYNC_DIAGNOSTIC=<empty>` and timestamp also empty both before and after. Monitor heartbeat within 1s. This definitively rules out bad-date/bad-ID among eligible notes; it does NOT prove the exact lifecycle API exception; no Java->IDB end-to-end commit occurred.
- **R62 = GALAXY FAIL, not Golden, regardless of static PASS.** Avoid same lifecycle/WebView injection version bump again.

## R63 implemented change (not a second editor or supplemental app)
- GitHub source branch `fix/moa-r63-direct-idb-on-native-save-20261103`; compiled Java DEX from source commit `c287e39afa950a6fb9d7e7958d834e33e34bb7c9`, scoped GitHub Actions `41642111207` **SUCCESS**, compiler DEX SHA256 `82fa235efcef7f06e0357cd6d3d77d95bda92f91ab195a14937a0ec78301e057` (58,012 bytes).
- New `MoaMomentDirectDiaryStore.java` runs from THREE independent paths: (1) native Save in `MoaMomentMemoActivity`; (2) active native camera foreground service scanner, every ~6 s if pending; (3) `MoaMomentApplication.onCreate`. Does **NOT** require previously failed `MoaMomentNative` UI bridge or `MoaMomentInboxSync.onResume` callbacks. Existing direct-inbox source still present for compatibility.
- Instantiates a controlled private Android WebView using `loadDataWithBaseURL('https://familyjourney.local/', bundled HTML,...)` so that JavaScript uses **same origin** as original diary WebView. The trusted HTML script accesses existing `indexedDB.open('familyjourney-diary-v1',2)` / `curated`, **same key `day` and `photoIds`/`moments` schema** as original R42.
- Transactional read-modify-write of matching local capture day; do NOT replace existing notes/title/body/tags, do NOT resurrect explicitly removed media. Per-ID deterministic moments, exact capture timestamp, no guessed current time.
- After transaction completes, read back the actual stored photo ID and matching note. Only then return token-bound ACK and tag matching native draft as synced. Failed writes remain retryable. No extra second memo popup. No photos or notes uploaded to internet.
- Key additional source-confirmed **display defect**: original diary JS `init()` returns early when `S.ready=true` and thus keeps cached `S.curatedEntries` from initial open. R63 minimally changes `assets/web/family-diary.js` to re-read `dbAll('curated')` upon diary opening and focus, then redraws. This closes the gap where an independently committed IDB entry would otherwise remain invisible in the displayed calendar.
- Original R62 camera capture source/notification/STT code preserved (golden source diff checked against R61 branch); no new app package, no original R37 data migration, no second editing dialog.

## Signed APK and independent tests
- APK `MOA_R63_Install_20261103.apk` / `MOA_R63_Download.apk`, 3,422,752 bytes, SHA256 **`64b1b730478a2a50976961cc2dc4cf511182a75495f2d02159f091167f646024`**.
- Based on **exact installed user R62 APK**; package `com.juhyeon.familyjournea`, versionCode **63**, original private R39/R42-lineage certificate SHA256 `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`. Private key is NOT published.
- ZIP members: 54 total, three existing files changed (`AndroidManifest.xml`, `classes4.dex`, `assets/web/family-diary.js`), one trusted local helper HTML added (`assets/web/moa-direct-diary-commit.html`), other **50 unchanged**. APK v2 cryptographic signature, ZIP CRC, DEX SHA1/Adler32 all **PASS**.
- Node isolated same-origin IDB writer test **PASS** for two media on same day, exact capture time, duplication suppression, preservation of existing day title/body, edited note, transaction+readback. Diary JS syntax PASS.
- **CRITICAL honesty gate: R63 on Galaxy S26 Ultra remains UNTESTED.** Android CI and Node tests do NOT prove the actual hidden WebView can access the user's existing WebView IndexedDB. Never say device PASS until user observes actual photo+note in selected-photo diary after update and reopening.

## Install/test safety and exact acceptance
- Standard update-install over installed R62; NEVER uninstall/reset app or photos. Original R37 (`com.juhyeon.familyjourne8`) is separate and untouched. No other helpers.
- With existing camera monitor ON and no new camera shots required, open MOA selected-photo diary for Nov 3. R63 should first process **already pending 13 eligible native notes** without retyping; they may include entries from other original capture dates. Check 11/03 plus original dates, exact time, no second popup. Close and reopen diary to check durable persistence.
- If R63 still fails, stop guessing: native internal preference `directDiaryDiagnostic` records `DIRECT_IDB_START`, `DIRECT_IDB_COMMITTED_READBACK`, `DIRECT_IDB_TIMEOUT_KEEP_PENDING`, `DIRECT_IDB_REJECT`, etc. Unlike R61/62 this is an **independent same-origin persistence path**. No further version bumps until actual stop gate is proven.
