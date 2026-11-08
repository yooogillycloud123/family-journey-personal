# MOA R191 — Compact photo diary / per-media memo / day menu / time-slot voice (2026-11-08)

## Actual status
- User video `19598.mp4` (private) shows cluttered curated-day screen, duplicated edit buttons, date stats, whole-gallery/voice management buttons, long per-media management rows, loosely grouped captured notes and long time-slot record button. User asked direct date → day narrative, consolidate into date ⋯ popup, per-media linked memo and actions folded independently, and a compact native record button beside time/count; **preserve existing saved voice fold/play and all data**.
- **R191 SIGNED + STATIC + ISOLATED MOCK-BROWSER PASS; USER GALAXY NOT YET TESTED, NOT GOLDEN**. The new markup/flows were tested against simulated day+media+moment records in headless Chromium; actual Android native voice, diary IndexedDB and data migration are NOT physically validated.
- Latest approved **R187 scoped device Golden** (signed SHA `4380ca0a421c3a12cfad0334e860e659112b116f6cc7099f8989475c646a97e9`) frozen untouched. R189 empty-note-capture signed fix also preserved in new APK (`classes7.dex` byte-identical). No AirPods/Android Auto code touched.

## Exact release
- Signed package `com.juhyeon.familyjournea`, **versionCode 191**, **5,661,635 bytes**, SHA-256 `d848b3a981172ab3e57c1dd124bf5b5a96264f7051985a9717c7744cfd6cec56`.
- Exact signed base **R189** SHA256 `d0e171782f2d72ff48ebadd81d2c2e467548f62e9a279dce8bda2fe2ccec0f9a`.
- **124/128 ZIP member payloads unchanged**; only `AndroidManifest.xml` (189→191), `assets/web/family-diary.js`, `assets/web/moa-r141-monthly-report.js`, `assets/web/moa-r149-voice.css` changed. All native DEX, gallery, existing video seek, photo EXIF, note capture, native recorder, backups, IndexedDB, calendars, maps and unrelated data assets byte-identical.
- Original signer certificate SHA256 `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`. Independent original signer/Android APK v2 RSA signature and full content digest, ZIP CRC, stored-asset alignment and JS syntax PASS. Exactly verified source-to-APK payload and unchanged DEX checks.
- Source branch `feature/moa-r191-compact-day-popup-media-memo-voice-20261108`. Exact shipped source Git blob hashes:
  - `experiments/moa-r175/assets/web/family-diary.js` `a0b42d7faaf6441a6ff268a2ae31253be158f5eb`
  - `experiments/moa-r175/assets/web/moa-r141-monthly-report.js` `22b1406f629aedb973083debd2e7b75d29272bf8`
  - `experiments/moa-r175/assets/web/moa-r149-voice.css` `451bc6e027dfe9fba2d2ababfb5c05b36631ae34`
- GitHub Actions source JS syntax + source contract run **42459989017 SUCCESS**. It is NOT a full clean Gradle APK build.

## Changed UI
1. On `S.page === 'day'`, hide status/meta banner except errors, day photo/video stats, redundant top shortcuts, externally-inserted whole-gallery and voice-open buttons, and redundant bottom diary-edit. The day date row appears directly above the `우리 가족의 하루` title/body.
2. The date row `⋯` now opens a mobile action sheet with existing real actions: whole day photo/video sheet (`MoaUnifiedDiary.openSheet`), full recording/list (`MoaVoiceDiaryNative.open`), add/change selected photos, select all, diary title/body/times editing, and confirm-before-delete. The edit form is the ORIGINAL form and save/delete handlers moved into the sheet; do not create a new schema or overwrite diary silently. Android Back/Escape and a dismiss control close it, dirty input prompts before discard.
3. Each photo/video tile has **two independent collapsed `details`**: `메모` (native `entry.moments[].photoIds` linked to exact media ID; edit existing memo available) and `기능` (share, open Galaxy gallery, calendar cover, GPS location, **삭제**), all preserving their original callbacks. Delete's accessible label and confirmation retain the truth: only exclude from this diary, NEVER delete original phone media.
4. Photo-linked moments are no longer repeated as separate group-top notes. The presentation-only `r191GroupOnlyActivity` filters duplicate saved moment text from activity display; standalone manually entered activity text remains foldable. **IndexedDB source remains unchanged**; all moments and activity records are preserved. A moment linked to several media can show on each associated media tile.
5. The real native `MoaVoiceTimelineRefresh` R151/R169 voice script now creates a small round `●` recorder in the same `.fd23-logtime` time/count row, with the exact `showRecorder(day,slot)` callback as before. Saved voice rows/folds/playback/editor remain untouched underneath. Empty audio placeholder and empty tools rows are hidden; genuine unlinked recordings remain visible.

## Safety and recovery
- **R192 emergency-only forward restore of exact R189 features**: signed package code192, 5,655,113 B, SHA256 `cd917f4dcb577ba807d77ae33dd21fb68c870bb56995291c27c172e2fd07b42e`; 127/128 member payloads identical to R189 except Manifest 189→192; same signer and independent v2/ZIP PASS. Actual emergency restore NOT TESTED. Do not install routinely; use only after confirmed R191 regression. If a future update code exceeds 192, create higher version emergency from appropriate Golden/tested baseline.
- R190 emergency only returns R187 and therefore loses the R189 empty-note fix. R187 user device scoped Golden remains immutable; R177 and R163 historical Goldens likewise.
- NO uninstall, app data clear, signer change, permission reset, family media upload, private signer upload or AA audio changes. In-place upgrade only.

## Physical acceptance before promotion
1. R189→R191 normal update **without uninstall**, existing diary/month/map/voice/photo records remain.
2. Curated day top: no counts/status/buttons, directly date → family day title; date ⋯ menu opens each item, sheet editor save/cancel/delete confirmation correctly.
3. Whole day gallery and native voice list still open from the menu.
4. Photo/video tile collapsed default, independent `메모`/`기능` toggles; capture memo visibly linked under **correct** photo only; no duplicate note at top; shared/manual activity preserved.
5. Photo/video item `삭제` excludes only from diary with confirmation; original phone media survives.
6. Time/count row has one small round native record button; record M4A and verify correct day/time link, saved recording expansion and playback. Cross-day/unlinked recordings remain.
7. R187 gallery smoothness/fixed bottom strip/real time seeking, R189 no-text media save, STT voice, backup/GPS/long-press navigation all pass.
8. **Do not call R191 Golden until user confirms on Galaxy.** If broken, collect screenshot/log, do not claim passed based on mock browser.

## New-chat order
Read `workexcel-devbridge/main/AA_AirPods_FINAL_READ_FIRST_v1.0_20261005.md` complete, then `MOA_R187_USER_DEVICE_GOLDEN_LOCK_READ_FIRST_20261108.md`, this handoff, MOA release ledger/WIP, and private Library latest R191 APK/source/QA. Resume from latest, not fresh analysis. AirPods Android Auto project stays untouched.
