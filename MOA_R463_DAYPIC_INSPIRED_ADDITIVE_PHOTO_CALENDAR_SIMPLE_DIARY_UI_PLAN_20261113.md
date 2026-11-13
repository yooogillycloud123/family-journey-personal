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

### C. 바로기록 — ONE recording/save workflow, TWO UI presentations (LATEST USER CORRECTION)

**This section supersedes and REVOKES the earlier suggestion of a two-option destination chooser or separate `간편 일기` vs `상세 일기` save dialog.** The user does not want to split 바로기록 into two workflows.

- Keep the existing **single 바로기록** capture and save mechanism, as-is for detailed chronological entries. The new simple Diary shows the same date's relevant saved media/text/voice as a **concise, polished presentation** in `오늘의 사진` and `오늘의 일기` without asking the user where to save.
- If an entry is created from within the new simple UI, it naturally appears in that UI and should remain accessible to the existing detailed Diary wherever the shared data model allows; do not silently create two duplicated diary records or replace old chronological records.
- UI transformation is a **read/view model adapter** where possible: detailed time-stamped entries can be grouped/summarized into today's simple photo/text/voice layout while preserving original timestamps, source media IDs and edit provenance.
- The precise R463 current `바로기록` data model, text/audio/media links, original write APIs, and whether an additive simple-entry type is needed must be source-verified before implementation. Never promise a common database structure or update original data without checking.
- There is **no destination picker, no duplicate Quick Capture app, and no extra save step.** The context/date determines the displayed date; one authoritative storage operation supports multiple views.

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
3. Add selected-day highlight distinct from Today and date-aware central plus; connect existing single 바로기록 flow to both detailed and simple presentations without duplicate writes; add voice record/play component that attaches to the same selected day.
4. Integrate feature controls incrementally, physical Galaxy verify stage fling/zoom/video/voice and date context. Preserve R463 user GOLDEN and original R467 exact restore. Future signed candidate code >=469 from separate branch only.

**Status:** New explicit user design clarification recorded. Still a DESIGN PROPOSAL, not an implemented APK. It overrides any earlier line in this proposal implying that the primary use of the hero photo is only to tap into a separate black fullscreen gallery.


## 2026-11-13 FINAL REFINEMENT — Multi-clip audio and bounded in-page media interactions

**Newest user correction (takes priority over all earlier destination-choice language anywhere):** 바로기록 remains one workflow. Existing detailed Diary shows detailed chronological contents; new simple Diary presents the SAME relevant date content concisely. No save-destination modal, no duplicate save, no second Quick Record system.

### Voice clips: 0..N per day, not a single global audio slot
- Each recording session produces an independent clip with stable ID, recorded-at timestamp, duration and source link. A diary date can contain zero, one, or many clips. Existing clips must survive another recording, edits, process relaunch and date navigation.
- Inside `오늘의 일기`, display a compact vertically growing list (or collapsed count when many) with per-clip play/pause, seek/progress and elapsed/total time; one clip plays at a time. `녹음 추가` appends; it NEVER overwrites the prior one.
- While recording show state, elapsed time, pause/resume/stop where supported, safe cancellation and mic permission. On leaving the screen, preserve a pending draft rather than silently discarding, and finalize writing atomically when the existing save mechanism permits. Delete requires clear targeted confirmation; do not delete all on single item action.
- Respect the existing R463 audio recording/playback ownership and Android audio focus. Source-verify `MediaRecorder` and actual DB/URI association before wiring; historical POC is not proof the current shipped APK has a ready in-card multiple-recording API.
- A voice clip is a diary attachment/record: **do not introduce a DayPic-like music section**.

### Restrict photo/video gestures to a bounded in-page hero area
- The new `오늘의 사진` region is a **self-contained media viewport** within the scrollable Diary page. Horizontal drag, fast/slow R463 mode, pinch/double tap on photo, video seek/play/pause/mute/frame capture, Share/GPS/capture-info actions should act **only inside its designated media viewport and controls**.
- Horizontal motions inside the viewport own media navigation; vertical movement outside it (and predominately vertical gestures inside it when not pinch/seek) should be left to the page's vertical scroll after proper gesture arbitration. Do not place a fullscreen transparent touch overlay across the editor or block note/voice input.
- Keep video media indexed with photos in the same selected-date collection. On media switch, pause/clean up the prior video and audio before starting the next item. Preserve frame and rail index synchronization, safe lifecycle on navigate-away/reopen, media aspect/crop, video Surface/TextureView and audio focus.
- Avoid layout jump: stable reserved stage height or responsive aspect constraint; native control bar and thumbnail rail must not overlap note editor or mic list. Optional expanded viewer is secondary, and the default is **NOT** a forced black viewer.
- This requires a safe host adapter/reuse of native R463 Gallery logic; simply reparenting its fullscreen Activity or replicating R203 physics in a second unverified engine is NOT acceptable.

### Acceptance gates
1. Existing Quick Capture save → original detail shows original chronological data; new simple Diary shows concise presentation for same date; NO choice prompt, NO duplicate record, NO write-loss.
2. Record three separate audio clips on one date, play each and seek individually, reopen Diary with all three intact, do not overlap audio, append a fourth without replacing earlier clips.
3. Embedded photo/video collection allows seamless horizontal swipes in its bounded area; outside media region vertical page scroll, text editing and voice controls remain responsive; ON fast mode is scoped to this region and OFF retains single-step.
4. Mixed photo→video→photo navigation handles video lifecycle/no stale audio, supports native mute/seek/capture with no child view clipping or layout jumping. Returning from share/map keeps same media.
5. All existing manual/automatic calendars and detailed time-based Diary preserved unchanged; selected date highlight/Today marker/new calendar remain additive. R463 signed Golden and R467 exact recovery untouched.

**Status:** updated DESIGN ONLY, no APK editing/build/test. Next engineering effort must verify the original R463 quick-capture and audio storage schema and Gallery host embedding constraints first.


---

## 2026-11-13 LATEST DESIGN UPDATE — representative photo, clean context footer, and compact audio picker

**User intent is visual restraint.** The new DayPic-inspired diary screen must reuse existing R463 capabilities, but it must NOT permanently show the entire fullscreen Gallery control surface on top of every photo. Photo/video remains the hero, with only on-demand controls. A separate five-slot, slim icon-only action bar sits BELOW the miniature thumbnail rail.

### Hero photo/video
- The user can designate the CURRENT media item as a **representative photo**. This controls the initial hero image for this day and the corresponding new photo-calendar cell. It must be persisted by day + stable original media ID, subject to verifying the R463 diary schema. Never duplicate, reorder, rename or move physical photos; previous AND next chronological photo/video items remain freely swipable in both directions from the representative.
- Default layout: large in-page photo/video viewport with a discreet 1/N indicator, selected representative star marker, and absolutely minimal overlay. Horizontal gestures operate only inside this bounded media surface, and vertical gestures outside it scroll the diary. No forced black fullscreen viewer; optional expand only.
- Video playback/seek/mute/capture overlay appears only when current item is a VIDEO. On photo, keep the picture itself visually unobstructed. When changing items, stop previous video sound and cleanly prepare next media without stage jumping.
- Below the synchronized miniature swipe rail, add **five compact icons** in one capsule: **대표 지정 (star) / 공유 / GPS 지도 이동 / 촬영정보 접기 / 빠른 넘기기 ON-OFF**. GPS button is gated on actual GPS; metadata disclosure does not launch map. Buttons retain sufficient touch targets despite small glyphs. No giant text labels in the visual bar (accessibility labels stay). Hide rare secondary actions under an overflow menu instead of stacking more rows.

### Multiple voices without a long old-style list
- In the simple diary's text section, provide ONE premium-looking mini player row, independent of the number of voice recordings. It has a small Play/Pause circle, one thin audio-progress line/waveform, time counter, selected clip label, and a compact count selector (e.g. 2/5 with down chevron).
- If the selector is tapped, reveal a small on-demand drawer/sheet with all individual recordings (date/time/duration); picking a clip switches the SINGLE visible player. Never show five bulky permanent Play rows. Existing clips remain separate and persistent; '+ 녹음' safely appends, doesn't overwrite. One clip plays at a time and sound focus must arbitrate against gallery video.
- If no voice clips, show a subtle '녹음' affordance. If one clip, the same compact player still looks natural. No DayPic music section.
- A waveform drawn in prototypes is decorative until actual audio-level data is sourced; do not fake saved recording data in production.

### Demo artifact and boundaries
- New separate development branch: feature/moa-r469-daypic-inline-media-voice-ui-prototype-20261113, based on frozen R463 Golden. The interactive HTML prototype source is design-prototypes/daypic-simple-diary/R469_INLINE_MEDIA_COMPACT_AUDIO_UI_PROTOTYPE.html.
- Prototype supports sample photo gestures, representative star selection, fast-toggle visualization, folded info, selection of multiple sample voice clips in ONE player and a simple diary text layout. **It is NOT yet a signed Android APK or integration with actual R463 MediaStore, video playback, microphone audio, Naver Maps, diary storage or the Android Sharesheet.** This status must remain explicit.
- Original native R463 fullscreen gallery, original 50dp four-icon bar, fast stage swipe, R227 share retention, Naver background saving, all original diary/quick capture/voice functions and current R463 Golden are protected. R467 remains the exact R463 emergency recovery. No new user-approved Golden.
- Before production APK: identify actual current diary/voice/capture data APIs, implement non-destructive representative selection mapping, embed Gallery's media lifecycle safely inside a bounded view with video and gesture arbitration, connect a single mini-player to original multiple audio attachments, test Gallery/Map/Share and media zoom on Galaxy, and finally build/sign a separate R463-derived v469+ APK with an exact functional recovery version above the candidate.

### Acceptance criteria
- Choose the third of several media as representative; reopen and see it first but still swipe both to earlier and later images/videos in original order, without affecting other dates.
- Hero UI stays clean for photos, and shows only necessary video controls for video; stage horizontal gestures cannot block note textarea or voice buttons.
- With six recordings only one player is visible; chooser lets the user select each clip, append seventh safely, and keep independent stored clips without audio overlap.
- No Quick Record destination chooser, no duplicate diary writes, no change to original detailed diary or selected/automatic photo calendars. No mandatory black gallery on ordinary photo swipes.

**This document is a design + separately interactive UI preview. R463 remains the user's immutable Golden; no new APK has been built or installed.**


---


## 2026-11-13 LATEST VISUAL RESET: photo-first, no always-open legacy Gallery controls

User re-supplied DayPic inspiration screenshots and explicitly rejected the previous card-plus-thumbnail-plus-five-always-visible-controls mock as outdated and visually cluttered. **This visual correction supersedes the old default toolbar/rail layout** throughout this design plan.

- Default screen must be **almost entirely a tall, near-full-width PHOTO**, preceded by a very small date header. Keep minimal rounding, no prominent card frame, overlays or debug text. A small discreet ··· control is enough. **Only small pagination dots immediately under photo**; original full thumbnail filmstrip is HIDDEN by default.
- Hero itself instantly swipes photo/video horizontally, in place, both previous and next from user-selected day representative. Preserve original R463 mode when OFF; optional fast motion ON. No forced black fullscreen app. Opening tools is never a prerequisite for ordinary photo swipe.
- **Tap the photograph or ··· to show** one compact icon-only contextual toolbar (set representative star, share, actual GPS NAVER, capture time/address, fast swipe). Tap again/swipe to hide. Only show the full mini-thumbnail rail when user explicitly selects 사진 목록 from the tool layer. Keep tool buttons accessible and safely tappable.
- On video, show only contextual video playback/seek/mute/still capture, and manage actual audio/texture lifecycle. On still photos, there are no video controls, only image.
- Under photo/dots present one quiet light-background 오늘의 이야기 text area. Below its text, **exactly ONE thin voice mini-player** with clip 1/N selection popover regardless of number of clips; do not stack bulky individual players; discreet + 녹음. No separate music section.
- Existing one-flow 바로기록, old detailed diary, manual & automatic calendars and all source data are preserved. Representative selection drives both simple diary hero and new photo calendar tile by shared stable original media reference. Keep default design photo-dominant.
- Historical rejected HTML: feature/moa-r469-daypic-inline-media-voice-ui-prototype-20261113 / design-prototypes/daypic-simple-diary/R469_INLINE_MEDIA_COMPACT_AUDIO_UI_PROTOTYPE.html.
- **New improved interactive HTML UI prototype**: feature/moa-r469-daypic-photo-first-immersive-prototype-20261113 / design-prototypes/daypic-simple-diary/R469_PHOTO_FIRST_CLEAN_INLINE_UI_v2.html. Generic Unsplash photos used only as sample assets. Supports simulated swipe, representative state, action disclosure, optional filmstrip, fast-mode UI and voice clip picker. **No real MOA data/media/audio/GPS/share/video persistence is connected and no APK built.** The user screenshots are not republished to GitHub.
- Current original signed user Golden stays R463. R467 exact R463 rescue unchanged. The prototype must not be confused with a functional Android upgrade. Future Android work needs source-verified data/recording/calendar integration and native Gallery life-cycle testing on Galaxy.

**Priority:** This new photo-dominant default REPLACES prior suggestions of permanent thumbnail/action decks.


---


## 2026-11-13 V3 PHOTO / STORY GEOMETRY AND R463 GALLERY HOST PLAN — CURRENT USER VISUAL CORRECTION

The user uploaded a DayPic recording screen (private user screenshot 21052.png) and specifically pointed out that the TOP photo section and BOTTOM diary section have **identical LEFT and RIGHT outside edges** from top to bottom, consistent rounded corners, and a quieter voice-recording interface. Previous prototype used photo 100% width but story inset, so its box alignment was wrong. The user also asks how all original R463 Gallery capabilities can work WITHIN this photo area without visually cluttering it.

### Locked visual proportions
- One outer content rail: photo viewport and diary story card both use **16px horizontal margins**, **width calc(100% - 32px)**, and **the same ~21px corner radius** on phones; smaller screens reduce both to 13px using one shared layout token. Their left/right edges must align exactly in both portrait/landscape responsive layouts. The cards are separated by a deliberate modest ~10px gap (+ small pager dots). Photo remains tall and dominant (adaptive 57vh within sensible min/max).
- Keep natural picture content full bleed WITHIN the rounded photo box, not stretched. For portrait photos use fill/crop strategy that honors original aspect; consider fit-on-demand to protect important subjects; landscape photos/video can use nonblack blurred/fill backing instead of mandatory black letterbox. Avoid artwork appearing like an extra framed old-style card.
- Default visible photo chrome is almost zero, small discreet `···` only; tiny dots immediately below hero. The original R463 thumbnail rail and compact actions appear only upon tap/open menu; the photo remains touch-operable even while controls are hidden.
- Diary/story uses same width/radius but calm pale theme background, no giant title bars. Voice mini-player is **one thin row** with small outline Play icon + seek line + `1/N⌄`, not a heavy black player or one row per recording.
- A micro **mic glyph** in Story is the only permanent recording affordance. Tapping it opens an **in-place quiet focus/record panel** (same aligned card, large centered `0:00`, thin waveform/line, minimal Cancel / Stop-Save actions), inspired by the screenshot. In the preview, UI control is **not actual microphone recording**. For multiple real clips show one small player with clip chooser, not stacked large controls.

### Engineering strategy: reusable Gallery CONTENT host, not duplicate fullscreen screen
- R463 original signed native `MoaNativeGallery` and R203 smooth GalleryRail + `r203Present/r203ReleaseWithVelocity` physics exist in protected `classes6.dex`, while supplementary R463 Java provider owns the **StageScrub** ON/OFF overlay. Both are currently tied to the existing fullscreen Gallery Activity lifecycle/stage hierarchy. A **new in-diary viewport cannot be built correctly simply by placing an Activity screenshot, reparenting `SurfaceView`, launching a hidden fullscreen viewer, or putting a global touch interceptor over the Diary**.
- Recommended implementation: isolate or adapt original Gallery's shared **media collection (stable ID/date/index), image decode, video player state, frame capture, R203 rail math and gesture controller** into a `GalleryMediaController` behind two UI hosts: unchanged original fullscreen Gallery and new `InlineMediaStage` bounded to photo area. Since the binary/source integration risks are high, inspect the exact original DEX/call sites and prefer a minimal adapter that invokes the already validated R463 behavior without touching original protected assets, unless necessary/verified in a separate source-verified branch. Do not guarantee the same renderer is directly reusable until Android implementation/physical test.
- **Touch ownership:** horizontal one-finger within hero -> stage media switch (OFF one-at-a-time, ON same R203 momentum); tap -> toggle compact contextual action row; 2-finger/pinch -> image zoom; horizontal filmstrip when voluntarily expanded -> original rail; vertical movement outside hero and predominantly vertical drag inside -> Diary page scroll; video progress swipe only on visible video timeline. Never cover the entire page with an invisible stage overlay.
- **Contextual actions:** when opened, the thin icon row BELOW the photo (or optional anchored overlay) offers representative ☆, Android Share, NAVER GPS, capture metadata/date/address, R463 fast mode. Representative is date-local and must affect Calendar cover and initial media index, **not reorder the previous/next collection**. Photos get no video controls; when VIDEO active only, show play/pause, seek/timeline, mute/volume, frame capture in a minimal auto-hiding video overlay without expanding/contracting the card layout.
- **Player lifecycle:** on swipe photo↔video, pause/release prior video+audio, switch texture/media cleanly, keep thumbnail rail & selected media ID in sync, restore content when returning from GPS/Share, prevent simultaneous audio with recorded voice playback. Handle Android lifecycle on screen pause/resume/destroy without black screen or leaked MediaPlayer and keep in-card stage measured stable.
- **Photo info and default display:** preserve original R463 metadata/always-on preference semantics where applicable, but in this minimal diary disclosure should be collapsed by default to avoid persistent top card hiding the image, unless the user has explicitly enabled its existing default-display preference. Do not silently reset preferences.
- **Voice recording implementation:** first inspect actual shipped R463 audio clip schema and recording/playback flow, then make compact UI bind to those APIs: multiple audio clips per day, immutable IDs, one active player, 1/N dropdown, micro-record UI states Idle/Recording/Paused/Review/Save/Cancel, voice/audio focus arbitration and safe draft retention, no separate music section. Any background waveform should be derived from actual audio data, not synthetic fake production samples.
- **No database migration until existing diary / quick capture / representative mapping inspected.** Keep original one-flow 바로기록 and detailed chronological Diary while the new simple Diary reads/writes a source-verified shared record, not duplicates.

### Versioned V3 interactive prototype status (NOT APP)
- GitHub R463-derived branch: `feature/moa-r469-daypic-aligned-voice-studio-prototype-v3-20261113`.
- File: `design-prototypes/daypic-simple-diary/R469_ALIGNED_PHOTO_STORY_MINIMAL_VOICE_v3.html`.
- Concrete changes to V2: both cards 16px aligned widths / 21px rounded; consistent responsive smaller-screen margins; small mic SVG with centered in-card 0:00 voice-sheet preview; lighter outlined voice Play, still just one clip player; same photo inline swipe and tap→context actions. Generic source sample photos only.
- **This is design-only HTML**, not an installed MOA APK, actual camera image/video player, real microphone recording, native Share sheet, NAVER map or diary persistence. It has not passed Galaxy runtime integration. R463 user-approved Golden original APK and original-signed R467 exact-recovery remain immutable; no new signed APK produced.
- Acceptance: screen edges align across photo and story with equal radius at all viewport widths; silent default controls; no black gallery required for everyday swipe; mic tap shows focused recording UI; when actual native integration is implemented, media play/mute/seek/capture/Share/GPS/zoom/fast swipe and multi-clip audio must pass on device without breaking original R463 workflows.

**PRECEDENCE:** This addendum supersedes older plan text that displayed a photo hero flush to device edge while the diary card was inset, or a permanent heavy audio toolbar. User approved the general structure but not the implementation, and the R463 Golden remains unchanged.
