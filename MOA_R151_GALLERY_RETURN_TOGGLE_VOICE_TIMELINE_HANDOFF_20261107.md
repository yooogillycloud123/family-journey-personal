# MOA R151 — user R149 device-verified voice baseline / optional photo-sheet return + time-linked audio

Date: 2026-11-07 (Asia/Seoul)

## Most important new user evidence
- User explicitly confirmed **R149 real Galaxy legacy Diary speech-to-text and original Android M4A recording BOTH WORKING**, screenshots `19226.png` through `19234.png`. R149 is now a *voice-only, user-confirmed* working checkpoint, not automatically full-Golden for every app feature. Quick Record remains working. Preserve exact signed R149 `com.juhyeon.familyjournea` code149 SHA256 `6fddee1d808162eff1c333abe891bb1cb4b9d005600fa63e7aaa5179f5ad0852`.
- User asks (1) settings ON/OFF for intermediate photo-list sheet when exiting photo viewer from Diary or Record/Map, currently always returns to sheet; (2) use the successful date-local voice recordings at **5-minute photo timeline position**, play audio at that section, and record new original audio anchored to a photo time slot. Still preserve original speech-to-text and quick record.

## Exact R151 candidate (not hardware tested)
- `MOA_R151_GALLERY_TOGGLE_VOICE_TIMELINE_BETA.apk` / `MOA_R151_Install_Chat.apk`, code151, package `com.juhyeon.familyjournea`, bytes **5,489,463**, SHA256 **`b0626d91b710dcda4496f554cc0191a6abf2d1f0d1d5b0a1602b82d88a774f2c`**.
- Signer certificate SHA256 `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`, same as R149/R115. Independent APK v2 RSA signed data + content digest verified, ZIP CRC PASS, STORED members 4-byte aligned, manifest typed code updated 149→151.
- Exact R149 127 ZIP original members: **124 uncompressed-byte-identical**; changed ONLY: `AndroidManifest.xml` (versionCode), `assets/web/index.html` (load R151 assets) and `assets/web/moa-r133-diary-unified.js` (optional direct return in `closeViewer`). Added ONLY `assets/web/moa-r151-settings-timeline.js` and `.css`, total 129 entries. **All native DEX including classes5/6, R149 original microphone, STT code, image/video data handlers, diary DB, MediaStore and Family calendar logic remain untouched.** No app uninstall, data clear, migrations or new permissions.

## UX 1: Photo sheet return settings
- Settings > 사진 및 데이터 > `사진 전체보기 후 목록으로 돌아가기` toggle; **default ON** preserving current R149 UX.
- ON: full photo viewer → original photo list sheet → original Diary/Map.
- OFF: full photo viewer → directly original Diary/Map; no unnecessary intermediate photo list. Does NOT remove manual `이 날짜 사진·영상 전체 보기` button or Map place listing when manually opened. Setting stored only in app-origin `localStorage['moa.gallery.return.sheet.v1']`, no DB edits.
- R133 Diary viewer's close checks `window.MoaGalleryPreference.enabled()`; Map's original `#viewer-root`/`#fj-naver-photo-full` existing viewer closure detected to dismiss parent place photo sheet only if OFF. ON preserves original callbacks.

## UX 2: Native audio linked to actual photo-time group
- Diary day > existing `사진·영상으로 보는 하루` 5-min group (`.fd23-log`). Add `● 이 시간대 음성 녹음` and `▶ HH:MM · KB` items under that group's header.
- The button opens the existing **R149 native M4A** recorder. User explicitly starts/stops; JS never requests WebView getUserMedia. On `record_saved`, find the new item returned by **existing native** `MoaLocalAudio.list(day)`, then record **only reference** `day/audio-id -> HH:MM 5-min group` in `localStorage['moa.voice.timeline.links.v1']`. No copy, move, modification, deletion or re-encoding of voice files. Original files still at R149's app-private `filesDir/moa-original-audio/YYYY-MM-DD`.
- Existing date-only M4A recordings automatically appear in a matching photo group if their actual file timestamp has that 5-min bucket; otherwise remain in `사진 시간대 밖에 녹음한 음성` and the original `전체 녹음 목록·삭제` continues to work. Photo or video metadata never altered; linking a voice recorded today to an older photo time slot means **the audio's real recording timestamp is retained** but the association is explicit.
- This introduces a local-only small mapping. The original diary JSON backup **does not yet export either M4A or the new time-link mapping**; future backup/recovery must add both. Deleting application or app data destroys app-private audio. Prevent any untested promise of cross-device persistence.
- If selected slot recorder aborts, do not create a new link; `record_error` cancels association.

## Actual QA vs unverified
- Chromium 393×852 isolated mock: default ON, toggle OFF, matching legacy R149 record shown in `08:40 ~ 08:44`, explicit slot recording matched to new Android mock file, play callback, Map viewer close OFF hides original place sheet, no JS errors PASS.
- Separate Diary R133 viewer Chromium mock: OFF closes full viewer AND sheet; ON leaves sheet and manual Close works, PASS. Synthetic data only, no real device.
- Independent v2 RSA PKCS#1 SHA256, content digest + signer cert, original 124-member compare, ZIP CRC PASS.
- **NOT TESTED:** actual Galaxy R151 installer, saved toggle across restart, Map/Record photo viewer all entry paths, native `record_saved` timing in live app, 5-min audio group mapping persistence, Android Back handling after R151. R151 BETA, **not** R149 hardware verified status transferred.

## Recovery-only version
- R152 exact R149 signed app content with only manifest code 149→152, all 126 other members identical, same signer SHA256 cert; emergency SHA256 `a67cf1e6be1b3726a69030ba740002ee4a8a9ab90b8967a35ef27f9cacfe0834`, 5,484,517B. NOT ordinary release. New localStorage slot mapping might remain after R152 but no original M4A is deleted.

## Next user phone checks
1. Install R151 *over* verified R149 (never uninstall/clear). Existing Diary speech-to-text and existing R149 recording playback must remain PASS.
2. Settings > 사진 및 데이터; ON Diary/Map photo close retains list; OFF directly returns to Diary/Map; turn back ON and retest. Restart application and check toggle persists.
3. Open Diary 2026-11-07 08:40–08:44 group. Confirm previously recorded 08:44 M4A appears and plays there. Tap `이 시간대 음성 녹음`, record 3 seconds, stop/save. Confirm the new audio appears there and plays. Reopen app and confirm timestamp/attachment retained. Unlinked audio should stay in date-level list. Do not delete old user recordings.
4. If errors, use exact native UI screenshots/logs to distinguish implementation from QA; do not silently reintroduce WebChromeClient modifications from R145/R147.

## Protected policy
- R115 visual Golden, R149 voice user-tested, R133 mixed gallery, R141/143 full-month and family calendar components preserved.
- Music integration explicitly out of scope. No AirPods source changes. No Gmail/email, chat-only APK. Signer backup stays PRIVATE and never included in GitHub or QA ZIP.