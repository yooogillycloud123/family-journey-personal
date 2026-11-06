# MOA R137 — Diary / Family Schedule calendar parity + DayPic expansion design

**2026-11-06 · APK_SIGNED_STATIC_PASS + CHROMIUM_ISOLATED_MOCK_PASS. Galaxy R137 device install/function PENDING.**

## 0. Incoming device evidence (exact scope)
- User reported R135 family schedule **installed and usable enough to compare its month/year picker with the Diary**. In their new video `19178.mp4` and screenshots `19165.png`, `19167.png`, `19169.png`, `19171.png`, user requests: Diary currently splits year and month into separate tap targets, whereas Family Schedule has one clickable year-month control; Family schedule is missing the horizontal calendar swipe already available in Diary. They also want DayPic-inspired polished JAN/JUN monthly header.
- This confirms **R135 presence/UI** on user's phone. It does **not** establish persistence after app cold restart, successful export/restore, notification, or multi-device synchronization. No future app Golden is promoted automatically.
- User supplied **screenshots and an Instagram demo**, not actual DayPic proprietary source or split APK. DayPic code internals were **not reverse engineered**; research is official Play/App Store functionality + demo imagery, independently built MOA features only.

## 1. Precise R135 source root
- `assets/web/moa-r125-calendar.js::enhanceMonth` renders two independent visible buttons, `.moa-r125-year` and `.moa-r125-mon`, each launching the **same combined year+month modal** but with different initial focus. Original Month `goTo(y,m)` changes **only volatile** diary month and uses original right-arrow handler, not IndexedDB.
- `assets/web/moa-r135-family-calendar.js::navigation` already renders one center month/year button calling existing native `<input type=month>.showPicker()`; family `calendarGrid()` has no touch handlers, while `assets/web/moa-r125-calendar.js::enhanceSwipe` implements horizontal recognizer for original Diary.
- DayPic video provides visual inspiration for large `JAN/JUN` English abbreviation and adjacent year. No copyrighted app assets or implementation copied.

## 2. Exact signed R137 incremental binary
- Base: immutable exact R135 installed candidate `MOA_R135_FAMILY_CALENDAR_LOCAL_BETA.apk`, code135, SHA256 `a6851e64d162f4ae5019f8c5cb8569632dee04665623189b82bbeef694006327`.
- New APK `MOA_R137_DIARY_FAMILY_CALENDAR_PARITY_BETA.apk`: **code137**, **5,449,703 bytes**, SHA256 **`6c8f908d554537f01a867cd82fcbf53f98413cd2f37a8330ac0b493a515b366b`**; package `com.juhyeon.familyjournea`, signer SHA256 `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15` (unchanged).
- Original 118 APK members: **116 byte-identical**. Changed ONLY typed binary Manifest versionCode135→137 (one byte), `assets/web/index.html` adds one CSS and one JS loader; ADD `assets/web/moa-r137-calendar-parity.js`, `assets/web/moa-r137-calendar-parity.css`. New total 120. **All existing DEX5, original photo/Diary/Map/photo-video gallery/voice, R135 event CRUD/IDB, photo IDs and golden visuals untouched. No DB migration, permissions or network access.**
- Diary R125's original year/month buttons stay in DOM (visually hidden). One new visible button uses their **existing month picker**; no reimplementation of state changes. Both calendar headers display large uppercase English abbreviated month + smaller year in a single pill. Family `type=month` control and original navigation handlers remain. Family month/week strip enables left/right swipe with horizontal-direction threshold, prevents accidental day tap, preserves vertical scroll and event chips; dispatches original arrows exactly once.
- Date/year selector UI may differ by platform because Family Schedule still uses the Android native month input while Diary keeps its existing custom year-wheel picker; this release **unifies the one-button interaction and visual header**, not the popup internals. This distinction is intentional to minimize regression.

## 3. Verification gates (do not overclaim)
- Independent APK v2 RSA SHA256 signed data signature, full signed APK digest recalculated, exact cert, ZIP CRC, 37 STORED 4-byte alignment, original DEX SHA1 + Adler, original resources, byte-exact diff allowlist: **PASS**.
- Chromium 393x852 fixture with actual original R125 picker JS + R135 family screen JS + R137 module; diary combined control opens full year/month modal, 2026/11→2025/04, both old buttons hidden, no overflow; family swipe 2026/11→2026/12, native input date 2024/07, vertical scroll does not switch month; JS errors none. **PASS_MOCK**, not Galaxy/Android.
- `moa-family-calendar-v1` and all original Diary IndexedDB source untouched. Test fixture has no real family persistence nor device native month-dialog screenshot; **R137 hardware install/gestures/style/persistence PENDING**.
- Recovery-only R138 from exact R135 bytes except Manifest versionCode138, SHA256 `45bb6164d0a2a53c53fa40b6f8e5c1f07971020194d688b428ba8bdb7813952e`; same cert, signature/ZIP PASS. It restores R135 behavior, not a future feature, and does NOT delete local family events.

## 4. DayPic evidence vs MOA engineering design
- Target **NovaLink DayPic (photo diary; bundle known publicly iOS id6770772768, Android com.novalink.daypic)**, not unrelated apps also named DayPic. User-provided demo indicates 1-photo calendar, song, recorded voice, monthly report; official App Store/Play description confirms daily photo+song+text+voice, question prompts, monthly diary habit report and collage.
- Official pages: https://apps.apple.com/kr/app/id6770772768 ; https://play.google.com/store/apps/details?id=com.novalink.daypic . 2026-10-28 2.0.0 app update notes mention more photos/videos per diary and invited collaboration; app-specific rating/description do **not** independently verify quality of sync, media encoding or internal database architecture.
- MOA already exceeds a single-photo diary: existing ~13k photos/1k videos, date grouping, selected photo diary, full-screen mixed gallery, native STT. Keep **original photo/media IDs** authoritative, never clone or reencode media to build DayPic-like UX.

### A. Month headers — **R137 IMPLEMENTED**
- Both Diary & Family Schedule use one visible clickable month-year button, with `NOV 2026` typography inspired by demo, while preserving app theme and original picker mechanics. Avoid narrow 38px controls / accidental overlaps from R125 legacy. One screen remains local-first.

### B. Monthly report/collage — **NOT YET IMPLEMENTED**, good low-risk next new feature
- New read-only `moa-monthly-insights-v1` on demand under Diary with a `월간 리포트` entry. Aggregate ONLY exact capture timestamps/Diary index: unique photographed days, day counts, genuine photo/video totals, personally authored Diary entries, last month delta and optional per-day photo collage. Distinguish dates with no media vs imported legacy media with approximate timestamps; never claim visit based only on non-GPS photos. Avoid inflated counts from duplicate photo indices. Read-only cache with source version digest, lazily render thumbnails, no rewrite of old Diary stores; no automatic upload. Export optional PNG/PDF only after actual native share/export viability checked. Avoid storing copied original photo binaries in a report DB.

### C. Original voice memo — **NOT IMPLEMENTED**; separate native feature requiring real device QA
- Existing R83 native STT converts speech to text but doesn't preserve an original audio file. New user-triggered recording must be explicit start/pause/stop/play/delete; permission & mic-indicator, private app storage or user-selected SAF document, deterministic `day+recordingId` link, retention/backup/export, and migration-safe data table. Android `MediaRecorder` or `AudioRecord/MediaCodec` (AAC/M4A) with real RECORD_AUDIO permission handling and foreground/lock lifecycle. Never silently record, don't synthesize `PASS` from native STT permission, and preserve original STT binding. Gallery originals remain separate. Family sharing later requires explicit opt-in for each recording.

### D. A song for a day via YouTube Music — **LINK INTEGRATION ONLY, NOT IMPLEMENTED**
- User has YouTube Music Premium. Official YouTube Music Help supports sharing a song/playlist link that opens in YouTube Music: https://support.google.com/youtubemusic/answer/9198182?hl=ko . First design: user pastes shared HTTPS `music.youtube.com/watch?v=...` URL + self-entered title/artist into new per-day link store, one-tap external app/HTTPS launch after verified native allowlist. No iTunes backend, Music Premium credential scraping or unsupported YouTube Music private API. Google's public API list covers YouTube Data API, not an equivalent public full on-demand Music catalog playback SDK: https://developers.google.com/youtube/apis . Respect developer policy forbidding unapproved media download/caching: https://developers.google.com/youtube/terms/developer-policies . Opening links needs actual Android device test due earlier NAVER URI allowlist failure.

### E. Opt-in family & PC real-time sync — **NOT PART OF R137**
- Preserve isolated R135 events DB. Later: trusted Supabase Auth+RLS Postgres changes/realtime, device outbox with idempotent op IDs and revision conflicts, opt-in family invite, private photo/audio uploading only by explicit consent; Windows web PWA reads same authenticated event table. Google Drive remains separate explicit backups. Loglog packaged evidence supports subscriptions/queue concept, **does not prove 0.1s guaranteed end-to-end latency**. Never treat GitHub as private user database.

## 5. Next staged work (each distinct APK, static + user phone gate)
1. **Verify R137** one-tap Diary picker / Family swipe and month heading on Galaxy; check existing Diary day photos/voice, local Family event persistence, old Map.
2. **Monthly reports & collage (read-only)** from local indexed media and diary dates; QA month 4/5/6 rows, 13k photo performance and accurate timestamps.
3. **Actual recorded voice attachment** and user-controlled native file store/backup, with mic permissions and re-listen QA. Keep STT separate.
4. **YouTube Music daily HTTPS-link attachment** (not embedded copyrighted song audio), verify external open and offline fallback.
5. Family invite + two-device/Windows sync, security & conflict testing, then optional 3D globe under Map.

All R115 user Golden, R117, R133, R135 signed reference binaries remain immutable in private Library. No emailing APK, no uninstall/data-clear, no AirPods code edit. Full dynamic device tests remain pending for R137.