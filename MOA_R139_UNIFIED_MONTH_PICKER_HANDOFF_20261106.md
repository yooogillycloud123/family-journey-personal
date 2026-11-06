# MOA R139 — Unified month picker, theme parity, remove family duplicate picker, MUSIC REMOVED FROM ROADMAP

**2026-11-06 KST — R139 signed STATIC + isolated browser MOCK PASS. GALAXY install/actual Android picker still PENDING.**

## Latest physical user evidence
- User actually installed **R137** on Galaxy; screenshots `19184.png`, `19186.png`, `19190.png`, `19192.png` show:
  1. Diary `NOV 2026` month button has dark/black typography while Family Calendar month button is pink, with differing visual dimensions despite same app theme.
  2. Diary button opens R125 custom year-list/12-month grid, whereas Family opens Android `월 설정` two-wheel native year+month selector. User wants the **Family native wheel for BOTH**.
  3. Family has a second visible numeric `2026년 11월` input **below** the main month button. It is redundant. Move existing `오늘` button to that left-side row. One month picker total.
  4. **User explicitly EXCLUDES music/songs/YouTube Music/iTunes linkage from future MOA feature development.** No music feature in subsequent plans unless user affirmatively changes requirement. Historical R137 research is history, not an active recommendation.
- This user evidence shows R137 installation and these UI bugs, NOT automatic full DB or original diary regression PASS.

## Exact R139 binary (source R137)
- Source exact signed `MOA_R137_DIARY_FAMILY_CALENDAR_PARITY_BETA.apk`, versionCode 137, SHA256 `6c8f908d554537f01a867cd82fcbf53f98413cd2f37a8330ac0b493a515b366b`.
- New `MOA_R139_CALENDAR_PICKER_UNIFIED_BETA.apk`, versionCode **139**, package `com.juhyeon.familyjournea`, **5,452,364 bytes**, SHA256 **`7821ff6afae7f064011a3a4ad531f552dde93e5713d0689d1d9e966608073a6f`**, same original signer cert SHA256 `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`.
- Of R137's 120 APK entries, **118 byte-identical**. Existing changed members only `AndroidManifest.xml` typed version code 137→139 and `assets/web/index.html` to load new UI CSS/JS. Added only `assets/web/moa-r139-calendar-unify.js` / `.css` (total 122 entries). All 5 DEX, resources.arsc, Diary DB, Family `moa-family-calendar-v1` storage, photo/video, Map, old swipe/gesture, voice, icon/launcher files are **BYTE-EXACT**. No new permissions, schema changes, media copying, user data reset.

## Implementation behavior
- Diary R137 decorated `NOV 2026` pill remains visually. R139 adds an **actual native `<input type="month">`** transparent, enabled touch layer exactly over pill, `min=1900-01`, `max=2100-12`. Its trusted tap invokes Android's existing month wheel directly instead of firing hidden R125 custom picker. On change, uses the same R125 proven volatile month state procedure: set the month to previous month, click original +1 arrow once; no diary database writes. Existing R125 date swipe/backup untouched.
- Family R135 existing live month input is **reparented, not cloned**, from `.moa-r135-nav-tools` to the main `.moa-r135-month-nav` as transparent touch layer over its existing R137 styled pill, preserving its exact original input change handler/state/render (and native picker). Numeric `2026년 11월` row becomes the **same existing** `오늘` button aligned left. No duplicate Today or month input remains.
- Both pills and their `NOV`/year/small help text follow existing theme variables `--moa-r117-accent`, `--moa-r117-accent-deep`, `--moa-r117-soft`, `--moa-r117-surface`, using identical specific CSS selectors. This removes Diary generic black styling override and maintains icon/theme setting compatibility. No proprietary DayPic artwork copied.
- R137 Family left/right month swipe event handlers and Diary R125 swipe remain intact. No extra month/year selector added in a submenu.

## QA and limitations
- JS `node --check` PASS. Chromium 393×852 mocked Diary+R135 Family DOM test PASS: native month input exists and is the *actual tap hit target* on both pills; Diary 2026-11 → 2025-04 via `change`, R125 old popup absent; Family input reparented with original handler, redundant numeric row input removed, `오늘` moved left; family 2024-07 month `change`, original swipe → 2024-08, Today→2026-11, both heading computed accents identical, no JS errors. `month.showPicker()` OS appearance is **NOT verified** by browser mock; actual Galaxy native picker still needs user test. Diary user data and Family IndexedDB true persistence were **not tested** by this UI mock.
- Independent v2 RSA signature signed-data signature, full content digest, exact cert, ZIP CRC, 37 STORED 4-byte alignment, DEX header SHA1+Adler and byte-for-byte old member diff PASS. Android PackageManager install itself still **NOT TESTED**.
- **R140 emergency only**, exact R137 prior contents except manifest version code 140, SHA256 `9d70f7c3dd5de38a86aad5aa3d9e7d302c757dd559170d2d4270b8119a4ce6fe`, same signer. Do not present as new feature or recommend casual downgrade.

## Next features — user music opt-out
1. First R139 Galaxy native picker/style + previous Diary/Family/Map preservation verification, do NOT promote to Golden without evidence.
2. Read-only monthly diary report/photo collage using existing timestamp/Diary/source links, no original photo rewriting.
3. User-triggered original voice recording/replay/secure export (not STT conversion), separate Android permission/storage QA.
4. Family schedule recurring/reminders, safe attachments and explicit opt-in family/PC two-device sync (e.g. Supabase Auth/RLS/Realtime & offline outbox), then 3D map globe; each separately scoped.
5. **Music integration excluded by express user request.** Do not include iTunes/YouTube Music song links or music copy/download in backlog or APK.

## Protection and delivery
- Keep exact R115 user Golden, R117/R133/R135/R137 release lineage untouched; no changes to AirPods code. All private signing materials stored only in private Library/local container and excluded from source QA/public GitHub. Chat-only delivery, no Gmail. R139 is BETA until Galaxy confirms it installed and both native selectors work. On `Library file not found` recreate directly in current conversation, do not repeatedly give the failed link. Exact R139 signed artifact, source/QA and R140 to be archived separately with actual API result; do not infer archival success from file creation.