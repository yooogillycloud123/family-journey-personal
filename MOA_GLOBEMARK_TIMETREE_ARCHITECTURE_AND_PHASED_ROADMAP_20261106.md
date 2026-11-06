> **2026-11-06 LATEST MOA R145 COMBINED BETA — R141 USER GALAXY REGRESSION / NO MUSIC:** User screenshot `19200.png` confirms R141 real phone monthly report shows 2,978 photos + 224 videos (October) but only 9 hardcoded collage preview images and Android Back fails. Exact source root: R141 `collectMonth()` has `max=9` and report handles ESC only, not native `__fjBackOverlay/__photoMapBack`. R143 signed checkpoint adds virtualized, scrollable **ALL indexed monthly photos+videos** with 3-column thumbs, mixed left/right gallery, explicit video native play, viewer→month→Diary hardware Back, no photo/Diary DB writes. Code143 SHA `709c2bc906159d2e93ce4f407def0016a04e45f8d492e31d948d65aa55bca5d1`, size 5,460,532B, historical cert. **R145 user-facing combined candidate** `MOA_R145_MONTHLY_ALL_AND_DATE_VOICE_BETA.apk`, code145 SHA `b6dda080d11a76f4400d6e4dc01611829d0ad3efdcecf01adb590708abd60d3d`, size 5,467,444B, same package/cert; from R143 original 124 members **122 byte-identical**, only Manifest code and HTML voice-loader changed; added `moa-r145-voice-diary.js/css`. On Diary day new **🎙 음성 녹음·목록** with user-initiated WebView `getUserMedia/MediaRecorder`, isolated `moa-diary-voice-v1` IndexedDB Blob saving, play/list/delete, optional Share/import and explicit permission/storage error, no STT change. R143 synthetic 3,202 media month full virtual scroll, monthly mixed navigation and back PASS; R145 mocked mic/IDB record/save/reopen/delete/back PASS; independent APK v2 RSA+full digest+old cert, ZIP, DEX PASS. **REAL GALAXY R145 install, mic permission, original audio persistence and actual video playback NOT TESTED.** Historical R115 Golden/R133/R141 and all existing Diary, Family Event data untouched. R143, R145, no-key QA and emergency R144/R146 in private Library CONFIRMED, no email. Audio files NOT in prior Diary backup; never uninstall or clear data. Music features explicitly OUT of scope. Read [R145 handoff](MOA_R145_R141_FULL_MONTH_GALLERY_AND_VOICE_HANDOFF_20261106.md) + release ledger before further code.

> **2026-11-06 MOA NEWEST R141 MONTHLY REPORT / USER MUSIC OPT-OUT:** User replied R139 calendar unification complete and required proceeding beyond UI-only fixes. User **explicitly excludes all music features from future MOA** (no YouTube Music/iTunes/song links/player); this overrides historical DayPic music suggestions. New exact R139-derived R141 signed BETA `MOA_R141_MONTHLY_REPORT_COLLAGE_BETA.apk` (`com.juhyeon.familyjournea`, code141, 5,458,030 B, SHA256 `ccea7a3baa2197bef63793df820a81fa5a9913de86beb7f0db84cfc2a6e9c1c2`, same R115 signer). **120/122 original APK files byte-identical**, only `AndroidManifest.xml` code and `assets/web/index.html` loader changed; added `moa-r141-monthly-report.js/css`. Read-only Diary calendar `월간 리포트 · 콜라주`: monthly photo/video counts, photographed days, diary-entry dates, daily histogram, up to nine photo thumbnail collage previews via existing `__requestThumbs`. **No original media/Diary/Family DB writes**, no music, no share/export PNG yet. Independent APK v2 digest/cert, ZIP/DEX and isolated Chromium synthetic state tests PASS; **REAL GALAXY R141 INSTALL/MEDIA WORKFLOW PENDING**. Private Library signed APK, no-key source QA, report, handoff and R142 emergency original-R139-forward (SHA `551cedd41b00a36d0ab4edaf2d859cf08e616f3d51520e807f368cb828742b3c`) confirmed archived. Read [R141 handoff](MOA_R141_MONTHLY_REPORT_COLLAGE_HANDOFF_20261106.md) and release ledger. Next feature: opt-in original audio voice recording (not STT), then Family repeat/reminders, PC/spouse realtime sync, 3D globe. No email/data wipe/AirPods edits.

> **2026-11-06 MOA LATEST R135 FAMILY SCHEDULE LOCAL MVP (DEVICE PENDING):** User requested to preserve the R133 working state and proceed to new features. R133 original exact SHA256 `f4fa987e987782818f84b758682bb6c967155cf8572a20fea1a82b6d3e5034f1` remains unchanged in private Library; no unsupported R133 full device-Golden promotion. New independent fifth primary tab **가족 일정** (not under Record) is implemented in **signed R135** package `com.juhyeon.familyjournea`, code135, SHA256 `a6851e64d162f4ae5019f8c5cb8569632dee04665623189b82bbeef694006327`, 5,446,442 B, same original signer. From exact R133: **114/116 old APK members byte-identical**, only Manifest versionCode and index HTML link modified, added `moa-r135-family-calendar.js/css`. Existing all five DEX, photos, native camera/voice, diary, original DB, Maps and launcher untouched. New isolated `moa-family-calendar-v1` IndexedDB for offline CRUD (title/date/time/all-day/category/note), 4-6 week month, week/day, local-only labels. Chromium 393px mocked IDB CRUD/week/day/back PASS, 5 tabs ~79px each, **real browser IndexedDB denied by test environment**, **GALAXY INSTALL/IDB PERSISTENCE NOT TESTED**. No real spouse/PC sync, notifications or recurring yet. Emergency-only R136 exact-R133-forward saved SHA `1155e45c95007b8250aef1f24dc53e888d8c4cbf0fd9a755158ab1e228a5b4ba`, not routine install. Private Library original R135 APK/no-key QA/independent test/handoff and R136 archived; no Gmail. Read [R135 handoff](MOA_R135_FAMILY_CALENDAR_LOCAL_MVP_HANDOFF_20261106.md) + release ledger before next patch. Next features are recurrence/notifications/Diary links and opt-in PC/spouse synchronization (Supabase+RLS+outbox), 3D globe later. R115 Goldens and AirPods untouched.

> **2026-11-06 USER CORRECTION, SUPERSEDES THIS DOCUMENT'S OLDER "FAMILY CALENDAR UNDER RECORD" NAVIGATION:** User explicitly rejects burying `가족 일정` under `기록`; future implementation MUST put `가족 일정` as a separate fifth bottom tab. Proposed `일기 | 가족 일정 | 나의 지도 | 기록 | 설정` with responsive 5-item width; existing record content stays for general logs and other functions. This is only a revised design, NOT implemented in R123. Preserve Globe as an optional 2D/3D mode under Map. Google Drive is suitable for backup, not reliable sub-100ms concurrent event sync. Actual submitted Loglog v1.0.10 (Capacitor+Supabase Realtime+app-level offline queue) and alternatives described in `MOA_LOGLOG_REALTIME_SYNC_TECHNICAL_REVIEW_20261106.md`. First test R123 installed calendar/GPS/Naver regression, then implement new tab and family DB in distinct release. Historical original text below remains for traceability but its Record placement is REJECTED.

# MOA — Globemark + TimeTree integration architecture, 2026-11-06

**Status: source/package research + design proposal. NOT IMPLEMENTED IN MOA R121. No actual Galaxy performance testing of either third-party app was performed here.** Primary immediate gate remains R119 user install failure and R121 beta installation.

## 0. Preservation and scope

- MOA installed package `com.juhyeon.familyjournea`. Freeze exact R115 user Golden SHA256 `1118bdc249e2d941a899518e58be0185b120a887ff2c371c8f5a01037a5002a8`, R117 user tested baseline SHA256 `667e6caa97ffc76b10df15594d5be0672ea892ae0be2692b293161eba94dfdb0`.
- R119 was Galaxy INSTALL FAIL (user screenshot `19084.png`), exact PM failure code unknown. R121 is newly signed, static PASS, **DEVICE INSTALL PENDING**: SHA256 `3e85d68ad652c5a55eafe01ec31ecbc2129bbea0e56a76eca70c4594b89a094a`.
- Keep existing bottom 4 tabs **일기 → 나의 지도 → 기록 → 설정**, 9 theme icons, native camera/memo/STT, WebView/local IndexedDB, MediaStore original IDs, day cards, NAVER functions intact. No extra helper APK. Explicitly selected extension UX within Record and Map; do not silently replace primary navigation.
- Never modify `familyjourney-diary-v1` / `curated` or any existing photo record because an extension wants a different schema. New data is additive and references existing objects by stable logical IDs.
- Do not republish proprietary third-party APK contents, assets, encrypted/obfuscated code, or family data to public GitHub; any reference library/boundary datasets need independently verified license and attribution.

## 1. Actual provided third-party package evidence (read-only)

**Globemark-1.2.0-split-apks.zip**, ZIP total 27,807,856 B:
- split export manifest: `com.novalabs.globemark`, versionName `1.2.0`, code11. Four splits; `base.apk` 22,086,167 B SHA256 `df99a03db88f1dd2676217fa319687211ca5d14b25c0882cf00b943a72bb841e`.
- Flutter resources are present: `assets/flutter_assets/assets/geo/{geo_110m.bin,geo_50m.bin,geo_10m.bin,regions.bin,cities.bin,city_names.bin,country_names.json,countries_meta.json,region_edges.bin,admin1_lines.bin}`. These prove bundled geospatial assets; they do NOT authorize copying/reusing those assets or prove their internal precision. Play listing confirms visited countries/cities on 3D globe and map, % visited, photo location import and journal (official URL: https://play.google.com/store/apps/details?id=com.novalabs.globemark).

**TimeTree-15.34.1-split-apks.zip**, ZIP total 52,517,408 B:
- split export manifest: `works.jubilee.timetree`, versionName `15.34.1`, code780. Three splits; `base.apk` 83,399,019 B SHA256 `42def53ebcdaddcd565bdd7cfc958edea4eeadfb7699ad00b6821e1d44df86e9`, 10 DEX entries and `assets/TZDB.dat` 110,194 B.
- Official functionality: calendar groups and invited members, participant differentiation, event color, time zone, repeat/custom repeat, reminders, notes, attachments, per-event comments, offline event CRUD queued for later sync. **Offline comments not equivalent to reliable automatically synced events**; refer official help: https://support.timetreeapp.com/hc/en-us/articles/360000626842-Can-I-use-TimeTree-offline, https://support.timetreeapp.com/hc/en-us/articles/204010389-How-to-add-recurring-events, https://support.timetreeapp.com/hc/en-us/articles/204934675-How-to-create-events-notification-repeat-attachment-checklist-day-count.
- Do not assert any TimeTree private internal backend/database semantics from ZIP existence; implement a separate independently designed MOA calendar.

## 2. MOA actual compatibility anchors (from signed R117 APK inspection)

- Original Diary stores per-media metadata in its existing `FamilyJourneyDiary.state.byId` and `curated` IndexedDB. Photo index includes `id`, native media timestamp `t` and approximation flag `approx` when known.
- `FamilyJourneyExtension.getData().photos` exposes photos with `photoId`, `lat`, `lon` for actual photo source index; `fj-naver-favorites.js` supplies the original photo viewer and route interactions. Some media lacks GPS or can be unavailable; this must remain explicit.
- Native `MoaMomentNative.enabled/setEnabled` are already exposed by Diary's `momentToggle`; original camera recorder/IndexedDB commit are protected.
- WebView is bundled under `assets/web/` and JS adds DOM controls; native Android `HostActivity`/bridges are signed in 5 DEX entries. Source code for exact native binary is not completely reproducible from the public `android/` prototype, which has a different app package; avoid replacing installed MOA with that prototype.

## 3. UX information architecture

Keep four existing bottom tabs untouched. **기록** adds a clear card named **가족 일정**; initial sub-views `월간 | 주간 | 일간 | 일정 상세`. Diary remains past events/photo-based journaling; future planned calendar does NOT edit dates/content in the original diary DB. On a day with both scheduled events and diary, show two separate rows and optional one-tap links; never auto-delete or create diary records.

**나의 지도** keeps old 2D default and adds `2D 지도 | 3D 지구본` view mode toggle. Drill path: 세계 → 국가 → 도시 → 장소 → 원본 사진/일기. A day event with a location may deep link to map; a visited photo/diary day may be explicitly linked to a planned event. No automatic assumption that GPS indicates intentional visit, or that a scheduled destination was actually visited.

**설정** gains optional 가족 공유·알림·지도 품질 items inside existing collapsed groups, preserving theme settings and native settings handlers. First run requires no account/network and preserves local-first behavior.

## 4. Family Calendar isolated schema / storage

Initial offline-only MVP uses a **new** IndexedDB database on the existing trusted same-origin WebView, e.g. `moa-family-calendar-v1`. Never repurpose the protected `familyjourney-diary-v1` nor rename `curated`.

Logical entities:
```text
families(id, name, createdAt, schemaVersion)
members(id, familyId, displayName, role=owner|editor|viewer, deviceAlias)
calendars(id, familyId, title, color, visibilityPolicy)
events(id, calendarId, title, notes, startUtc, endUtc, tzid,
       allDayLocalDate, location{label,lat,lon}, ownerMemberId,
       revision, deletedAt|null, createdAt, updatedAt)
event_participants(eventId, memberId, response)
recurrence(eventId, rrule, exdates, overridesByOccurrenceKey)
comments(id, eventId, actorId, body, createdAt, tombstone)
event_photo_links(eventId, photoLogicalId, localMediaStoreId|null)
event_diary_links(eventId, diaryLocalDay, entryId|null)
notification_jobs(eventId, occurrenceKey, triggerUtc, status)
oplog(opId, deviceId, entityType, entityId, operation, baseRevision,
      localSequence, payload, createdAt, syncStatus)
sync_cursors(familyId, serverCursor, lastAckOpId)
```

Design rules:
- Use UUID-like stable logical IDs for events, not date text / MediaStore IDs as sole sync identity.
- `startUtc`, `endUtc`, IANA `tzid`, all-day local date stored separately; handle DST, midnight, multiple time zones.
- RRULE RFC5545 recurrence and immutable occurrence IDs; support edit this occurrence / this-and-following / entire series via exceptions. Never materialize infinite repeats; show only viewport window.
- Separate attachments: local photo references via original `MediaStoreId` and a deduplicated `photoLogicalId`; **MediaStoreId alone will not resolve on spouse's device**. Sharing a photo requires separate explicit upload and permission, or display `사진은 이 기기에만 있음`; never silently copy family photo binaries.
- Original diary data/notes/voice remain the source of truth. Links are soft references; deleting a link never deletes the original diary/photo.
- Schema migrations idempotent with version gates, double-write disabled until tested, backup/snapshot and rollback strategy.

## 5. True family synchronization (not part of offline MVP)

Real spouse device updates require **a shared backend** and accounts/identity; local IndexedDB alone cannot sync another handset. Do not represent offline-only beta as shared family calendar.

Proposed protocol:
1. Opt-in login/invite/join with per-family ACL, authorization on every read/write, private calendar visibility and device/session revocation.
2. Client writes local transaction + persistent oplog ID before responding to a user; sends idempotent operations with `opId`, `deviceId`, `baseRevision`; server provides monotonic authoritative `revision` / sync cursor; do not trust device clocks as conflict arbitration.
3. On reconnect: push pending ops, pull server delta since cursor; no automatic lost edits, handle duplicate/replay operations, tombstones, owner deletions, intermittent mobile network, and concurrency. Keep a visible `동기화 대기/충돌` state.
4. For nonconflicting fields, field-level merges; conflicting start/end/recurrence should present user conflict resolution or concurrent-version preservation, not blindly pick latest local timestamp.
5. End-to-end encryption optional but privacy/security claims require an actual key-management, multi-device and backup implementation. At minimum authenticated TLS, at-rest encryption of cloud storage and access controls. Storage/export/deletion consent for family schedule, location, photo and children's records. Logs omit PII.

For notifications use native bridge with permission-aware Android notification scheduler/WorkManager. Exact-time alarms and Android reboot/Doze/battery restrictions must be tested; never promise 100% timing from a JS timer. Reconcile notifications after sync, timezone change and device restart.

## 6. 3D globe technical approach and accuracy

From existing indexed photo points, derive an **independent read-only cache**:
```text
PhotoGeoIndex(photoLogicalId, mediaStoreId, capturedAt,
              gpsLat, gpsLon, gpsSource, accuracyMeters|null,
              countryIso|null, admin1|null, cityId|null,
              sourceDigest, indexVersion)
TripAggregate(countryIso, cityId, year, photoCount, visitedConfidence)
```

- Ingest only original EXIF/MediaStore/GPS or existing trusted user-tagged places, not guessed addresses; if GPS absent leave `unknown`.
- Map to countries/regions/cities with independent license-verified public geographic polygons/points. Use offline geospatial point-in-polygon with coarse tile/grid index (or an explicitly consented network lookup as fallback). Country boundaries may be disputed; keep map rendering nonpolitical and allow correction. `방문` classifications have `GPS 확인`, `사용자 직접 표시`, `예정만 있음` statuses; planned ≠ visited.
- WebView GPU/WebGL/Three.js or a comparable independently licensed runtime can render a low-detail 3D globe; load the globe **only when mode selected**, keep current 2D as fallback. LOD 110m→50m→10m, geometry simplification, pooled markers, GPU context-loss handling, texture/memory budget, pause when screen hidden. No reliance on copying Globemark's compiled asset bins.
- Tapping visited country opens city counts; city opens place/photo/day diary index. Statistics use distinct verified country/city keys and clear denominator methodology; no claims from the TimeTree/Globemark code. Years use actual EXIF capture time not app import time; distinguish approximate/edited timestamps.
- Performance QA on Galaxy S26 Ultra: cold/warm load, fps/memory, 100/1,000/10,000 photo data points, no UI jank in original diary, lower powered tablet and GPU loss, offline map availability.

## 7. Phase gates — each new feature separate release

| Phase | Scope | Release gate |
|---|---|---|
| **P0** | **R121 install/baseline**: R119 failure documented; test R121 in-place install and check old diary/photo/stt and map | Exact PackageManager install result + original records intact. R121 **not Golden** until user confirms |
| **P1** | Family schedule **offline/local** month/week/day CRUD, independent store, family member colors | Create/update/delete + safe cancel, time zone, cold-restart persistence, zero changes to original Diary/Map DEX |
| **P2** | Repeat exceptions, native scheduled reminders, event→diary/photo links | Repeat edit only-occurrence/all/future, reboot notifications, broken photo fallback, link delete never delete original |
| **P3** | Opt-in multi-user backend, invites/ACL/offline sync/concurrency | Two-device simultaneous edit and offline/online reconciliation, family member revoke, privacy & conflict QA |
| **P4** | 3D read-only globe integrated into existing map, GPS visited stats, drill downs | Verified GPS/Unknown differentiation, WebGL memory & 2D fallback, old map/gallery/diary regression |
| **P5** | Event location→trip links, optional saved itinerary, selective family media share | No implicit location/photo uploading, per-user permission checks and end-to-end regression |

P1/P4 can be swapped after R121 install gate based on user priority, but do not batch both in a single risky APK. Preserve same package + signer, no uninstall or data clear. Every release gets exact binary member diff, GitHub append-only release entry, private signed artifact, rollback-forward candidate with higher versionCode and explicit device status.

## 8. Important nonclaims / next test

This document is a **research/design deliverable only**. The uploaded split APK metadata and official docs do not imply full source access or permission to copy their implementation. True cross-device sync, 3D globe, native live address opening and complete R121 installed operation are **not yet proven/implemented**. R119 failed actual install; Android PackageManager error text/code is still unavailable. Do not chase speculative installation reasons by uninstalling or clearing user data.

**Next required physical test**: install current signed R121 beta over R117 (same package/cert, higher code) with **no uninstall** and report whether it installs. If it fails, capture `INSTALL_FAILED_*` in read-only ADB if available or precise Samsung installer message. Only then promote/fix candidate. See `MOA_R121_R119_INSTALL_FAIL_REPAIR_HANDOFF_20261106.md` and `MOA_RELEASE_LEDGER_CURRENT.md`.
