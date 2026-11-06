# MOA R117 — Diary-first landing, compact grouped Settings and icon-linked screen theme
**Date:** 2026-11-06
**Status:** SIGNED / STATIC AND BROWSER MOCK PASS; USER GALAXY INSTALL & FUNCTION REGRESSION NOT YET TESTED.
**Reference/current user-approved Golden:** exact frozen **R115**, do not overwrite or promote R117 to Golden before user confirms.

## User requirements
1. App's first visible tab on cold start: **일기**. Fixed bottom navigation order **일기 → 나의 지도 → 기록 → 설정**. Preserve original map/record/diary navigation, camera quick-capture and all entries.
2. In Settings remove only the redundant **지도 · 영상 고급 기능** promotional row, not the existing enabled capabilities. Regroup and default-collapse **사진 및 데이터**, **디자인 · 테마** (app icon and new screen theme), **사용 및 도움말**, **지도 · 확장 도구** (family extension and NAVER GPS tools). Existing **화면 빠른 이동 패널** remains native details but closed indicator is **›** like the rest, expanded rotates down. Do not erase, rename handlers or destroy any settings.
3. Optional UI theme modes: **아이콘과 동일** (automatic/default), **기존 피치**, **핑크**, **블랙**, **화이트**. Auto uses the color suffix of currently applied `moa.icon.theme.applied`; manual preference `moa.ui.theme.v1`. Applies visual CSS tokens to main UI/settings/tabbar + appended diary root, without changing photo/map geometry or IndexedDB data. The original 9 launcher icons and WebView splash artwork/first-frame CSS remain byte-exact unchanged.

## Exact signed release
- Package `com.juhyeon.familyjournea`, versionCode **117**, original signer SHA256 `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`.
- User delivery filename `MOA_R117_Install.apk` (same signed bytes as `MOA_R117_UI_REORGANIZED_BETA_Install.apk`).
- SHA256 **`667e6caa97ffc76b10df15594d5be0672ea892ae0be2692b293161eba94dfdb0`**, **5,412,356 bytes**, **105 ZIP members**.
- Exact source Golden R115 sha256 `1118bdc249e2d941a899518e58be0185b120a887ff2c371c8f5a01037a5002a8`, 5,406,744 bytes, 103 members.
- R115 original members **100/103 unchanged**. Three changed: `AndroidManifest.xml` versionCode to117, `assets/web/app.js` cold-start default `let tab='diary'` and ignore stale hash tab restores (explicit `?tab` and `?step` still supported), `assets/web/index.html` adds CSS/JS load links.
- Two additional modules: `assets/web/moa-r117-ui.css` and `assets/web/moa-r117-ui.js`. JS uses **existing FamilyJourneyDiary.open** on startup and moves existing DOM setting nodes (does not clone/recreate or lose listener handlers). New CSS colors only; icon theme apply mutation updates auto UI color.
- Original `classes.dex` through `classes5.dex`, `resources.arsc`, all installed launcher resources, old 9 splash PNGs, `family-diary.js`, `family-diary.css`, photo IndexedDB write HTML, `fj-naver-favorites.js`, `family-addon.js`, `moa-icon-theme-settings.js/css` **BYTE-IDENTICAL**.
- No database schema change, no app uninstallation/clear data, no additional helper application, no extra permissions.

## Verification and limits
- Exact R115 signed APK baseline SHA asserted; versionCode-only AXML patch position from byte diff R113→R115 checked.
- SHA256 and byte-by-byte comparison of 103 original entries, ZIP CRC and 4-byte alignment of stored entries: **PASS**.
- Independent APK v2 RSA/SHA256 signed-data signature, full content-digest recomputation, original certificate identity: **PASS**.
- Node JS syntax `app.js`, new module, original diary: **PASS**.
- Headless Chromium DOM **mock**: calls existing diary.open on default startup, nav visible order diary/map/record/settings, settings details default closed, original source/rescan/NAVER/Family panels moved (handler nodes preserved), advanced promotional row hidden, independent black UI theme selection changes root theme: **PASS**. This is a limited test fixture, NOT full original app/browser lifecycle.
- User's Galaxy installation, icon-linked palettes on actual device, original diary/photo/calendar/STT/IndexedDB regressions: **NOT TESTED**. Do not call it user Golden yet.
- Screenshots are simulated settings fixture only. Do not describe as hardware.

## Private durable artifacts
- Signed APK: `/모아_프로젝트_근거_20261103/MOA_R117_DIARY_FIRST_SETTINGS_THEME_BETA_Install.apk`.
- Patch source + QA (no keys) ZIP: `/모아_프로젝트_근거_20261103/MOA_R117_UI_PATCH_AND_QA_NO_KEYS.zip`, bytes 78,464, SHA256 `f4d957282e2312d006ee01671ab8974b944be503922c970bbf9c6e4555d31dc6`.
- Exact QA JSON: `/모아_프로젝트_근거_20261103/MOA_R117_QA_REPORT.json`.
- Emergency **R118**, built from the original R115 Golden with ONLY manifest versionCode changed; **NOT** a regular update: `/모아_프로젝트_근거_20261103/MOA_R118_EMERGENCY_RESTORE_R115_NOT_ROUTINE_INSTALL.apk` (sha256 `462a30d3a18406f56bd3ad884210b8919af277e3e887ea08fdb6091213361361`, 5,406,743 bytes). Independent RSA v2 signature/digest and original member comparison PASS. Using R118 means next normal code >=119.

## Hardware acceptance checklist
- Existing R115 **do not uninstall or clear storage**. R117 installs over it with same signing certificate.
- After opening: Diary visible, not map; tap Map, Record, Settings, then Diary; verify diary edits and back navigation.
- Settings: promotional "지도 · 영상 고급 기능" hidden; all new groups closed initially; › toggles down on open; old photo source/rescan/settings panel buttons respond; no blank long uncollapsed advanced panel.
- Design group: icon selector still changes real launcher icon; choose auto mode and change icon pink/black/white to see UI accents update; manually choose Peach/White/Black and ensure prefs persist after restart.
- Verify old photos/day cards/calendar, native capture memo and original dates, voice keyboard, saves and deletes on device without loss.
- Report any unexpected menu visibility, data issue or visual contrast with screenshot/ADB; preserve R115 Golden and patch only proven root cause.

## Engineering restrictions / next checkpoint
- Read `MOA_R115_NEXT_CHAT_START_HERE_20261106.md`, R115 freeze/manifest, `MOA_RELEASE_FAILURE_LEDGER_AND_BUILD_GATES_20261106.md`, and this handoff first.
- Append actual user-device PASS/FAIL to `MOA_RELEASE_LEDGER_CURRENT.md`. A static PASS is not Galaxy PASS.
- Never paste/install email attachments; release delivery current ChatGPT conversation only, APK link recipient-accessibility unverified until the user opens. No Gmail, signing keys or user photos in public GitHub.
- Do not change unrelated AirPods or archived MOA Goldens.
