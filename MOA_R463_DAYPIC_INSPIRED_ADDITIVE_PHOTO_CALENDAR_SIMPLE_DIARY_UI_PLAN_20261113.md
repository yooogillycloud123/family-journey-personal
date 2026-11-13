# MOA R463 Golden-preserving additive Photo Calendar & Simple Diary UI proposal
Date: 2026-11-13 (Asia/Seoul)
Status: **DESIGN PROPOSAL / USER BRIEFING — NO APK PATCH, NO NEW GOLDEN**
Parent: **MOA_R463_USER_APPROVED_GOLDEN_20261113**, exact signed code463 SHA256 `9d2fd10d32a3bc35eb3132333e96edd8f565abd5daf3ce954b052f77083d8379`
Frozen source: `golden/moa-r463-user-approved-20261113`
Existing Golden rescue: **R467 exact R463 functional recovery** (R465 restores only R459). Do not use R465 as R463 recovery.

## 1. User request (faithful to supplied screenshots)
The user shared 10 DayPic reference screenshot images in the current conversation: `20735.png`, `20737.png`, `21021.png`, `21027.png`, `21025.png`, `21023.png`, `21033.png`, `21031.png`, `21029.png`, `21035.png`.
Their visual and functional wishes are:
- **Do not delete or replace existing MOA manually chosen-photo diary/calendar or automatic-photo calendar**, nor the old time-segmented detailed diary editor. Add a **third simple, full-bleed photo-calendar and diary UI**, taking design inspiration from DayPic screenshots but integrated with MOA functionality and assets (not copying licensed UI assets/code).
- The calendar should be densely filled with photos inside **entire date cells**, with a small day number overlaid, not the existing separate date/photo areas. Clean typography and room for the month, light controls and a month progress measure similar to the supplied example. Tapping any date opens that date's content. Explicit `오늘` jump and `홈` action required; month paging by swipe and month/year selector are proposed.
- Prominent central `+` should open **the selected/current context date** in diary editing, not unconditionally today; when no date context, default to user's local today (Asia/Seoul). Desired eventual accessibility from any Diary/calendar mode; must not unexpectedly replace existing app's global navigation until scoped regression checks.
- Simple editor has exactly TWO major groups: `오늘의 사진` and `오늘의 일기`; **no DayPic “오늘의 한 곡/오늘의 음악” field**. Original full detailed/time-based MOA editor remains accessible as advanced mode.
- Existing R463 high-fidelity gallery rail / video playback / mute / timeline / capture / zoom / Share / actual NAVER GPS map / folded photo info / optional upper-stage fast swipe ON/OFF should be accessible via the image hero and compact action row where appropriate. Avoid building a second, regressed gallery engine.
- The screenshots also illustrate monthly progress and export/share-calendar-as-image; consider these optional enhancements rather than prematurely claiming they are requirements already approved.

## 2. Source-vs-proposal distinction
- Confirmed directly from user screenshot/context: DayPic example has full date-cell photo calendar, progress percentage, central compose `+`, Today One Cut / Today Song / Today Story triptych; MOA user wants only photo + text, and existing two photo calendar and advanced diary maintained.
- The exact MOA persisted data schema / relationships between journal dates, selected photos, automatic photos, daily text, moment records and MediaStore have **NOT yet been exhaustively inspected** from the R463 application. The mapping described below is a **design requirement to verify during implementation**, not an assertion that APIs already exist.
- The current R463 sources verified as frozen include supplementary `MoaR391SessionPersistProvider.java` and protected original `classes6.dex`; do not mutate the protected golden branch or suggest source-integrated behavior proven without device validation.

## 3. Three-view information architecture
1. **기존 선택 사진 달력**: unchanged behavior, manually chosen/representative photos.
2. **기존 자동 사진 달력**: unchanged behavior, automatically selected photos.
3. **NEW `사진 일기 달력` (DayPic-inspired)**: month-wide seven-column edge-to-edge photo cells, day overlaid; date selection => simple diary/detail.

A shared view selector/tabs should allow instant switching without duplicating or migrating saved data. **Default app home/tab remains unchanged until user approves default change.**
Proposed date-cell image policy: chosen representative photo for the date when present; otherwise linked diary photo; optionally automatic same-day photo when that mode is enabled. Distinguish `image exists` from `journal saved`, e.g., understated dot/status; never invent diary entries for photo-only dates. For multiple photos show representative still image + optional `+N` mark; videos show thumbnail + tiny play glyph. Empty days are calm blank panels with date number.
Monthly completion % = `number of dates with saved diary text or explicitly saved entry` / `days in that month`, not percentage of images, subject to user confirmation. No extra writes for counting.

## 4. New quick diary UI
Header: back, explicit YYYY.MM.DD (tap for date picker), save state, existing MOA theme.
Section A: **오늘의 사진** — one large chosen image/video (or hero collage), small smoothly swipeable miniature rail for multiple linked items; tapping hero opens **the same R463 native MoaNativeGallery**, not a parallel gallery; optionally present compact action icons (Share, GPS Map, folded capture info, optional fast stage) using existing methods so original video/GPS controls are preserved. Do not force native player on the edit form when a safe gallery launch can be used.
Section B: **오늘의 일기** — one spacious multi-line text input, not a compulsory time grid. Preserve drafts safely, explicit save feedback, Back w/ unsaved-changes policy; optional `상세 기록으로` for the original original time-structured MOA diary editor. The existing voice/moment records must not be removed, overwritten, or silently transformed; advanced editor handles them.
No music section in the basic view. Never accidentally conflate absent music with deleting existing audio records.

## 5. Route/date context and continuity
- Selected date on photo calendar => opens that exact `localDate`. A tap on global/section `+` first resolves explicit selected date, else existing diary being viewed, else local current date. Never use today's date when the user is browsing a selected historical day.
- `오늘` => selects/scrolls to local today and opens/retains chosen mode appropriately. `홈` => back to MOA current home tab, preserving its original position/navigation state.
- Diary photo thumbnail, diary row, calendar tile, family record/photo path all pass the same `dateKey` and media item ID to existing viewer where possible; maintain Back navigation state (month/year, scroll, selected day). For photo date different from a saved diary date, saved diary association takes precedence; EXIF capture time is displayed separately, not silently rewritten as diary date.
- Single source of truth: save a quick entry through an adapter that **reuses the existing MOA diary persistence model or a separate additive field** only after schema inspection. Do not duplicate existing diary records, reset original time blocks, break NAVER location lists, or migrate data destructively. UI route toggles read the same data.
- New modes should add only safe UI overlays/navigation components and avoid editing protected R463 Gallery DEX, NAVER writer and existing 50dp gallery footer; no new app ID or sign key.

## 6. UI controls / visual system
- 7-column full-photo calendar, discreet overlaid date badge high contrast, selected-day outline, Today marker, no oversized headers or excessive cards. Scale 5–6 week rows to device height; no forced crop of faces in thumbnails when avoidable (choose crop anchor/fit).
- No duplicated persistent bottom navigation: either integrate a center `+` into new diary-mode local bar, or a global floating action above MOA's **existing** bottom navigation with coexistence/inset testing. Avoid two simultaneous bars/obstructing Gallery bottom rail. `홈` and `오늘` remain always accessible.
- Bottom quick-editor media action bar should be extension-capable (re-use R463 glyph style and existing handlers), but NOT automatically duplicate the Gallery overlay into a context that has different scrolling/touch ownership.
- Default fast-swipe mode stays OFF per original R463, and state changes never persist unexpectedly.

## 7. Engineering/test gates (future, not done)
- Phase A: UI-only prototype/new route, original calendar and detailed diary untouched; switch 3 modes, photo-cell rendering, date navigation/Today/Home, date-aware `+`.
- Phase B: Data binding to existing selected/auto-photo and diary/photo linkage with non-destructive adapter, draft/save/reopen, real month progress, zero duplicate writes, video thumbnail.
- Phase C: R463 Gallery integration and compact action bar, share/media/GPS/fast swipe tests, different entrypoints and Back state.
- Phase D (optional user approval): calendar-month export/share, day completion analytics, default mode option, search/filter, multi-photo day picker, themes/animation.
- Acceptance: 31-day/28-day/29-day month + 5/6-week layout; photos/videos mixed; blank day; date selection and `+` correct for historical day; no diary overwrite; Timezone/local date boundaries; existing two modes exact unchanged; old time-based editor unchanged; NAVER nonoccupying/Chrome login/cookies and Gallery media/sound/capture untouched; process relaunch restore mode; accessibility/readable number; selected day scroll; safe Android status/nav insets.
- Performance: MediaStore/thumbnail lazy-loading, background decode/cache, no full-resolution month grid bitmaps, stable recycler keys, target smooth swipe and memory safe.
- Future signed builds only **from new branch based on frozen R463**, same cert/package, next versionCode >=469, plus candidate-higher-version exact R463 functional recovery. Golden stays R463 until new explicit approval.

## 8. Decisions for next design review
- **Recommended** initial default remains existing MOA entry (new `사진 일기 달력` is an extra tab); user may later elect to make new view default.
- **Recommended** editable new section uses existing detailed entry as optional deep link instead of forcing a complete data migration.
- **Recommended** no global app bottom navigation redesign in first commit; initially integrate `+` in calendar/diary pages, then elevate to global after safe cross-tab routing approval.
- Confirm whether dates with images but no saved diary should display full photos (recommend yes) but not count in diary completion.
- Confirm whether the simple diary text should be same as existing diary's summary or separately stored additive note after schema inspection.

**This proposal is recorded against the immutable R463 Golden; it is NOT an implemented R469 APK and must not be described as user-approved final UI.**


---

## 2026-11-13 ADDENDUM — USER CORRECTIONS TO PRIOR BRIEF (AUTHORITATIVE FOR THIS UI PROPOSAL)

The user has clarified the earlier proposed `tap hero photo -> separate native Gallery` **is insufficient as the default experience**. The new DayPic-inspired screen should itself offer as much as possible of the existing MOA R463 full Gallery/Diary interaction IN PLACE, not make users enter a black-screen standalone Gallery each time. Keep the full-sized/open Gallery option only as an optional escalation.

### A. Embedded photo/video stage — gestures without tapping, no mandatory black viewer
- In **오늘의 사진** section the hero photo/video is an **interactive in-place Gallery stage**. Touch and horizontally drag **directly inside the embedded hero** to switch among multiple day-media items; when the fast-swipe switch is ON, reuse R463 original R203 fractional/momentum engine and synchronize an optional miniature rail; when OFF retain one-at-a-time behavior. The user should not first tap to open a different full-screen Gallery in order to swipe.
- Keep the editor's DayPic-inspired clean/light theme and text area visible while swiping the hero; **do not auto-navigate to an all-black full-screen viewer**. Optional maximize/expand allows distraction-free viewing while **retaining a nonblack/light configurable surround** and a smooth return with the same media item/index. If a separate R463 black full-screen Activity is still used internally, it must not be the only path for inline interactions.
- Reuse **the existing R463 Gallery engine's state/gesture/MediaPlayer/MediaStore access** through a safely embedded adapter or reused Stage+Rail logic. Critical engineering qualification: original `MoaNativeGallery` is tightly coupled to a native fullscreen host, so embedding is a **real layout/touch ownership and lifecycle integration effort**; it is not yet proven possible by simply dropping the Activity into a card. Do NOT claim a complete in-card engine already exists or implement an independent low-quality duplicate. Prototype an adapter that leaves original `classes6.dex` intact and preserves an optional exact R463 full viewer.
- Embedded stage must account for vertical page scrolling versus horizontal media swipe, pinch/double-tap zoom, video timeline scrubbing, video play/pause/mute/volume/frame capture, original Share chooser and return, NAVER GPS action, folded capture time/address info and upper fast-swipe ON/OFF. Small context actions should be accessible in/under the hero without the entire editor turning into a full-screen overlay. Handle video-swipe transitions without audio overlap.

### B. Date selection should be obvious visually
- The currently **selected calendar date** receives a clear but polished highlight: e.g. theme-colored rounded 2dp stroke + subtle tinted overlay/inner elevation. Highlight remains legible atop bright/dark full-bleed photos.
- **Today's date** has a distinct small marker (dot/Today accent) so it is not confused with the **selected date** when browsing a different month/day. On tapping a date, update highlight immediately, keep selected date when returning from the diary, synchronize central `+` context to that selected date. Use accessible semantics and not color-only indicators.
- Do not alter/delete original manually-selected and automatic calendars. The highlight is part of the **third** added calendar screen.

### C. 바로기록 integrated destination chooser
- The user already has **바로기록** (quick capture) and wants this entry path represented in the **new simple UI**, not rebuilt as a competing disconnected recording system.
- On quick capture/compose, offer clear **save destination choices** such as `새 간편 일기` and `기존 상세 일기` (the actual wording can match MOA's established terminology after source inspection). Respect selected/current date context. Preserve an option to switch destination **before final save** without losing entered text, media or recording.
- Storage must be **non-destructive and nonduplicating**: destination choice selects an appropriate VIEW/EDITOR/association (or an explicit entry type), **not separate blind writes** into two unrelated tables. Reuse existing MOA persistence and diary/date/media association after inspecting R463 app storage schema; guarantee existing original time-segmented diary/바로기록 content does not vanish, reassign dates, or double save. If the new simple view cannot safely represent an existing detailed element, show a link to original entry rather than silently dropping it.
- Quick capture card supports photo/video selection, short text, voice recording if possible, save or continue-in-editor; still use existing MOA permissions and URI grants.

### D. Voice inside 오늘의 일기, not a DayPic music section
- The user **explicitly requires voice recording AND playback** from inside `오늘의 일기`, preserving any existing MOA audio/voice features.
- A compact microphone control records/pauses/stops; saved recordings show small playable rows with waveform/progress, elapsed time and Play/Pause plus optional re-record/delete. Notes and audio attach to the current date entry and are restored on reopen. **Audio is content attached to today's diary**, NOT a separate `오늘의 음악` panel.
- Original MOA `MoaMomentAudioHostActivity` history contains `MediaRecorder` and source-recording POC code, but exact R463 shipped workflow and attachment schema must be inspected before claiming this voice wiring already works inside this editor. Avoid duplicating storage and permission flows; request microphone permission only as already supported.

### E. Visual priority and feature completeness
- New `사진 달력` → `오늘의 사진` interactive embedded media stage → `오늘의 일기` text + voice: all within a coherent minimal UI. Existing advanced operations are **contextual action buttons/disclosures**, not many permanently open panels.
- The user wants to migrate or link **almost all usable MOA diary/gallery functions to this surface**, not merely provide a shortcut to the legacy interface. Before implementation, produce a source-verified feature-to-UI map for: existing photo picker/gallery, continuous lower rail & optional upper fast motion, video media controls, GPS/metadata, Share, selected/automatic calendar, quick capture, legacy time-block diary, voice record/play, save/restore, and navigation.
- Preserve the existing R463 50dp Gallery toolbar and fullscreen behavior as a protected mode; the in-card action row can visually adapt but should invoke the same underlying media services. Optional fullscreen is secondary and should **not auto-blacken the background** in the new simple diary.

### Implementation gates updated
1. Map actual R463 diary persistence and quick-capture and `MediaRecorder` flow; identify exact extant APIs to reuse, prove source-backed functionality before coding bridge.
2. Build an **inline interaction proof** with photo/video horizontal gestures, media-index & miniature-rail synchronization, vertical-scroll arbitration and light-theme nonblack stage; maintain existing R463 fullscreen viewer as fallback, not forced navigation.
3. Add selected-day highlight distinct from Today and date-aware central plus; connect quick-capture destination chooser without duplicate diary writes; add voice record/play component that attaches to the same selected day.
4. Integrate feature controls incrementally, physical Galaxy verify stage fling/zoom/video/voice and date context. Preserve R463 user GOLDEN and original R467 exact restore. Future signed candidate code >=469 from separate branch only.

**Status:** New explicit user design clarification recorded. Still a DESIGN PROPOSAL, not an implemented APK. It overrides any earlier line in this proposal implying that the primary use of the hero photo is only to tap into a separate black fullscreen gallery.
