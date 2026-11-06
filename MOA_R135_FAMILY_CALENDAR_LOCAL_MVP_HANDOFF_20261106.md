# MOA R135 — Independent Family Calendar / Local MVP

**2026-11-06 · signed release BETA. Do not call hardware Golden.**

## Active lineage and safeguard

- Preserve frozen user R115 Golden: SHA256 `1118bdc249e2d941a899518e58be0185b120a887ff2c371c8f5a01037a5002a8`.
- Preserve user-confirmed R117 original and subsequent checked R129/R131 components.
- User requested **save R133 state and begin the planned additional features**. R133 is an existing `APK_SIGNED_STATIC_PASS` baseline with photo-video mixed Diary gallery and date overlay, SHA256 `f4fa987e987782818f84b758682bb6c967155cf8572a20fea1a82b6d3e5034f1`, 5,438,184 B, code133. User has not provided a separate itemized R133 physical workflow PASS; **do not promote R133 to Golden**.
- The next feature was explicitly agreed as a **fifth main bottom tab `가족 일정`**, not a subview under Record. Original Diary, Map, Record and Settings unchanged.

## R135 exact signed package

- Name: `MOA_R135_FAMILY_CALENDAR_LOCAL_BETA.apk`
- Package: `com.juhyeon.familyjournea`, versionCode **135**.
- Size: **5,446,442 bytes**.
- SHA256: **`a6851e64d162f4ae5019f8c5cb8569632dee04665623189b82bbeef694006327`**.
- Certificate SHA256 (exact original): `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`.
- Derived from exact R133 signed APK. Original 116 APK members: **114 byte-identical**. Existing changed members **only** `AndroidManifest.xml` (typed code133→135 one byte) and `assets/web/index.html` (one CSS link and one JS link).
- Added only `assets/web/moa-r135-family-calendar.js` and `assets/web/moa-r135-family-calendar.css`; new total **118** members, no removals.
- All five `classes.dex`...`classes5.dex`, `resources.arsc`, `app.js`, `family-diary.js/css`, native camera/photo/video bridge, original `IndexedDB` save/read, user photo IDs, Map place sheet, current Diary gallery JS, splash, launcher icons and all other existing APK entries are **BYTE IDENTICAL to R133**. No permission added and no existing database schema migration.

## Actual feature implementation

- The runtime adds **fifth bottom tab** in order `일기 | 가족 일정 | 나의 지도 | 기록 | 설정`. The original `app.js::showTab('family')` generic tab mechanism is reused, original click handlers remain. No replacement of Map or Diary.
- Independent local database **`moa-family-calendar-v1`**, object store `events` with `keyPath:'id'`, secondary date index. This database is **not** `familyjourney-diary-v1`, never accesses `curated`, photo-index stores or MediaStore IDs. No gallery/photo/voice import or wipe.
- Isolated local event CRUD (title, date, optional memo, start/end, all-day, nominal family category `가족/나/배우자/아이`, `tzid`, `revision`, timestamps). No real identity/accounts implied by labels. Soft isolation from Diary.
- Month 4–6 week dynamic grid, week strip and one-day event list; date navigation and today; original app theme tokens reused; five buttons sized for 393px phones. Editor and delete confirmation, independent storage errors shown to user, event re-read after each write.
- Existing Back handlers are delegated unless the new editor/family tab is active. Back from editor closes only editor; from Family returns to Diary, not Map.
- Explicit UI notice **'이 기기에 저장됨 · 다른 기기와는 아직 동기화되지 않습니다.'** No false cloud success or invitation.
- Local-only data will be lost if app is uninstalled/cleared and is not yet included in prior Diary JSON backups. **Do not uninstall/clear data**, offer opt-in backup/export in a follow-up.

## Verification / limitations

- Static `APK_SIG_V2_RSA_PKCS1_SHA256` and **independent full APK v2 content digest** verified; original signer cert PASS; ZIP CRC PASS; 37 STORED entries 4-byte aligned; original DEX internal SHA1+Adler32 PASS; `resources.arsc` unchanged; original member diff allowlist PASS; `node --check` PASS.
- Isolated Chromium (393×852) fifth-tab test: all buttons fit (79 px each), local mocked IndexedDB storage, add/edit/delete & confirm-cancel, 4–6 rows, week/day views, back to Diary, no JS runtime errors. **PASS_MOCK.** Does **not** verify the real IndexedDB in Android/WebView.
- Browser navigation to secure origin/local file was blocked by test environment administrator; browser about:blank origin denies IndexedDB. Thus a normal real IndexedDB browser **reload/readback test was NOT POSSIBLE**, use separate mocked IDB only. Report precisely, no invented pass.
- **NOT TESTED:** Galaxy PackageManager installation, device IndexedDB persistence after app restart, Android keyboard, actual Back stack, 5-tab nav coexistence with real MediaStore/gallery, user account, spouse/PC sync, notifications, reminders, recurrence, family share, 3D Globe.
- Do not call 'production ready' or 'Golden' until user confirms actual device behavior.

## Recovery and next extensions

- Separate private-only `MOA_R136_EMERGENCY_RESTORE_R133_NOT_ROUTINE.apk`: exactly R133 source members except manifest versionCode **136**, signer same, SHA256 **`1155e45c95007b8250aef1f24dc53e888d8c4cbf0fd9a755158ab1e228a5b4ba`**; version higher than R135. Recovery from a R135 UI regression only; **not normal installation**. New family-calendar database is not deleted by this recovery; it simply becomes invisible while R133 UI is active.
- Phase 2 (separate version >=137): repeat-rule exceptions, proper native notifications (respect Android permission, reboot/Doze), namespaced event links to existing diary photos, opt-in export/backup. Do not confuse planned event and past diary.
- Phase 3: opt-in Supabase Auth/Postgres/RLS/Realtime plus durable outbox, offline reconciliation, per-family invite, no silent private photos upload. Browser/PWA Windows companion; Google Drive snapshot/export only. `Loglog 0.1s always` is unproven; actual RTT needs measurement.
- Phase 4: optional 3D globe in the existing Map via actual photo GPS and license-clean dataset; never copy compiled proprietary assets.
- All files delivered **current chat only**; no Gmail, no private signer in public repo or keyless QA ZIP; AirPods source unchanged.