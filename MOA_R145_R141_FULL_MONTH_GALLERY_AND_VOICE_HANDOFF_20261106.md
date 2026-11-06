# MOA — R141 device report regression → R143 complete monthly media → R145 dated original voice

**2026-11-06 KST.** Current release candidate **R145 SIGNED / INDEPENDENT STATIC PASS / ISOLATED BROWSER MOCK PASS. GALAXY INSTALL / HARDWARE RECORDING / REAL DATA PENDING.**

## 1. Exact user repro / current precedence
- Actual Samsung screenshot `19200.png`: R141 month October 2026 report physically displays **2,978 photos, 224 videos, 31 photographed days** but only **9 fixed photo thumbnails**. User explicitly says this is a half-implemented report, wants **all that month's original photos and videos** to browse continuously and Android Back to close (not only UI `닫기`). User also demands implementing the next feature in the same development turn.
- No music functionality: user's prior explicit veto remains governing, **never re-add music** or YouTube Music to the roadmap without new instruction.
- R115 frozen user visual Golden (code115 SHA `1118bdc249e2d941a899518e58be0185b120a887ff2c371c8f5a01037a5002a8`) and R133, R135, R137, R139, R141 signed lineage preserved unmodified.
- Exact R141 user-installed source `MOA_R141_MONTHLY_REPORT_COLLAGE_BETA.apk`, code141, **5,458,030 bytes**, SHA256 **`ccea7a3baa2197bef63793df820a81fa5a9913de86beb7f0db84cfc2a6e9c1c2`**, same package `com.juhyeon.familyjournea` and historical signer SHA256 **`5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`**.

## 2. Confirmed R141 source cause
- `assets/web/moa-r141-monthly-report.js::collectMonth()` selected at most `max=9` photo IDs under `collage`, **explicit hard limit**.
- Month popup only requested 9 thumbnails via existing `__requestThumbs`, did not render all indexed videos or expose per-month mixed-media viewer.
- R141 `init()` handled keyboard `Escape` only; unlike original Diary's `__fjBackOverlay` / Map's `__photoMapBack`, Android native Back did not close month popup.
- Fixed overlay has original calendar under it; new flow must preserve chart, 4 numerical stats, original month and diary state.

## 3. R143 — full month gallery independent checkpoint
- Built exact R141→**R143** with versionCode143, size **5,460,532 bytes**, SHA256 **`709c2bc906159d2e93ce4f407def0016a04e45f8d492e31d948d65aa55bca5d1`**, original same certificate.
- Original R141 **124 ZIP members**, **121 byte-identical**; modified only `AndroidManifest.xml` code141→143 and existing `assets/web/moa-r141-monthly-report.js/.css` report presentation; no new files, no old deletions. All DEX5, `resources.arsc`, original Diary DB and photo indexing, original mixed Diary/Map media gallery and Family Schedule remain unchanged.
- Collect *all* existing in-memory `FamilyJourneyDiary.state.byDay` and `byVideoDay` rows in the requested month, deduplicated by MediaStore-style ID (e.g. numeric photos, `v...` videos). Keep original date, timestamp and approximation marker, do not invent records. This is **all indexed** media; it cannot claim missing/unindexed MediaStore originals.
- 3-column, fully scrollable **photos + videos** list. Virtualizes layout with 3 columns and roughly 18–40 mounted tiles; monthly list still contains all IDs, including months with >3,000 indexed media; avoids huge HTML/base64 thumbnail retention. Requests existing native `__requestThumbs` only for visible IDs, bounded 105 thumb cache; no copying/deleting images/videos.
- Click an image/video to open the new **mixed monthly viewer** with next/previous arrows and horizontal swipe. Image uses original `https://familyjourney.local/fj-photo/<id>.jpg`. Video uses original native bridge `NativeHost.post('diaryPlayVideo', {id})` on explicit `▶`, not new transcoding/embedded player; actual video return after native player remains hardware PENDING.
- Back: from viewer → same-month full media list at same scroll; then from report → original Diary calendar. Wrap native `__fjBackOverlay` and `__photoMapBack` plus ESC/Backspace, without overwriting original handlers when no overlay. Original `닫기` remains.
- Monthly collage in R143 is a browseable on-screen media mosaic, **not a PNG export**. No external backup, music or migration.

## 4. R145 — adds real audio recording attempt and separate persistent store
- **R145 combined install candidate** `MOA_R145_MONTHLY_ALL_AND_DATE_VOICE_BETA.apk`, versionCode **145**, **5,467,444 bytes**, SHA256 **`b6dda080d11a76f4400d6e4dc01611829d0ad3efdcecf01adb590708abd60d3d`**. Same old package and signer.
- Exact R143→R145 binary diff: of R143 **124 original ZIP members, 122 byte-identical**. Only `AndroidManifest.xml` code143→145 and `assets/web/index.html` voice JS/CSS loader references changed; added `assets/web/moa-r145-voice-diary.js` and `.css`. New 126 entries. **Original R143 monthly report JS/CSS byte-identical**. Original five DEX, original STT/Diary photos, existing Diary and Family IndexedDB writer, Map, Gallery and launcher unchanged.
- On **Diary day** UI (not Calendar's month page) adds `🎙 음성 녹음·목록`. It is explicitly distinct from native STT. On user tap start, probes Android WebView `navigator.mediaDevices.getUserMedia({audio})` and `MediaRecorder` with native mic permission (existing manifest contains `android.permission.RECORD_AUDIO`, checked in binary XML string pool). If allowed: explicit record → stop → save original audio Blob, day key, original MIME/type and duration in a **new isolated IndexedDB `moa-diary-voice-v1/recordings`**; list same-day files, play with `<audio controls>`, delete with confirmation, optional Web Share file export when supported. Keep recording tracks stopped after completion. No background/automatic recording or uploading.
- Fallback `기존 음성파일 가져오기` in case direct WebView mic is unavailable; depends on original app's native Android file chooser. If capture/chooser/storage is unsupported, show a real error instead of false success. Preserve recording Blob in memory on failed save, offer save retry or explicit discard, and block silent modal dismissal while unsaved. Max 90MB per recording.
- **CRITICAL limitations:** actual Galaxy `getUserMedia` grant, native WebChromeClient permission, WebView `MediaRecorder`, native file chooser, real IndexedDB Blob persistence/reopen, Android external share/export and audio playback all **NOT TESTED**. Do not assert actual microphone feature PASS until phone evidence. New audio files are **not included in the old Diary JSON backup**. Data cleared/uninstall = loss; user must never uninstall/clear data. Future opt-in external backup is required.

## 5. Tests and hard gates
- R143 Chromium 393×852 synthetic month 2,978 photo IDs + 224 videos, **3,202 indexed items**, virtual DOM max 25 tiles while traversing top to last, scroll reaches last item (photo id100), mixed video native command, Back viewer→month→Diary: PASS. No real family images in mock.
- R145 isolated Chromium synthetic mic & fake IndexedDB: explicit user start/stop, 300-byte mock audio Blob, separate store put/read/list/delete, reopen day, native Back voice dismissal, no Diary mutation: PASS MOCK. **Real browser IndexedDB inaccessible in our Playwright about:blank/file context; was deliberately mocked**, not real persistence. The mic stream & MediaRecorder were also deliberately mocked.
- Independently verified both APKs' APK v2 RSA signed-data signature + full APK content digest, original signer cert, ZIP CRC, 37 STORED alignment, 5 DEX SHA1/Adler and original protected file byte-for-byte checks: PASS. Manifest versionCode patched single known typed value byte at 7268, no resource-map/string mutation.
- R144 **emergency** exact R141-forward code144 SHA256 **`19dbcc2f52369a520d84648fd08261d014a053f0e30b4991aa4aac71e1f3082d`**, lower than R145 and not useful as an update after R145.
- R146 **emergency** exact R143-forward code146 SHA256 **`17550bc78ecdd54b400ce07bd0de4c17e25a6755365ef10af582208d0b8a9e77`**, intended only if R145 voice regression. R146 code keeps monthly full viewer and removes voice UI, without deleting its separate data store. Neither is routine installation.

## 6. Current target and required device verification
**R145 is the user-facing combined candidate**; R143 remains a separately archived milestone, NOT current Golden. Install as an in-place update on existing R141 (`com.juhyeon.familyjournea`, same signature) without uninstall or data reset.

Required real Android QA:
1. Open October 2026 R141 report history from Diary calendar → R145 new report with 2,978/224 counts; scroll full month down/up and click mixed media; video `▶` native playback; return viewer to month list; Back to original Diary calendar.
2. Check older/newer month with zero or one photo; preserve 4–6-week Diary calendar, existing selected diary, 5-min memos, Map gallery, STT, Family Calendar CRUD.
3. Open a Diary date → `🎙 음성 녹음·목록`, start after Android permission, stop/save, close app and reopen same date, play record, optional external Share, delete with confirmation; do NOT test destructive app data clear.
4. If mic unsupported, capture exact error text/toast and test existing audio import separately. Do not promote beta before evidence.

## 7. Release policy / next expansion
- Preserve all user-approved Golden and historical lineage. This release includes actual UI code for full monthly media and attempted WebView audio recorder, not placeholder feature badges. A **true native audio bridge** may be required if WebView mic access fails; do not silently substitute STT or claim recorded audio success.
- Next independent milestones: external encrypted user-controlled voice backup/restore, Family Calendar recurrence/notifications/photo linking, opt-in spouse + Windows sync with RLS/outbox, optional 3D globe. **Music features REMOVED** from roadmap by user instruction.
- Private signed artifact, no-key source ZIP, QA JSON and this handoff should be archived to Library and GitHub. **Chat-only APK delivery, no Gmail/emails**. Tool-side file creation/Library archival does not prove ChatGPT Android client download or installed behavior.