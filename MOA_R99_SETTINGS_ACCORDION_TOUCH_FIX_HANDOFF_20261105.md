# MOA R99 Settings accordion and touch responsiveness fix (2026-11-05)

## User request and evidence
User sent screenshot `18899.png` and screen recording `18901.mp4` showing R98's expanded "화면 빠른 이동 패널" occupying too much of the Settings tab, and reported some settings clicks not responding. Requested the same collapsed/expandable UI as other settings entries and repair unresponsive controls.

## R99 exact deliverable
Signed APK `/모아_프로젝트_근거_20261103/MOA_R99_SETTINGS_ACCORDION_TOUCH_FIX_Install.apk`, same package `com.juhyeon.familyjournea`, versionCode **99**, versionName `MOA-R99-Safe-Capture`, **3,511,986 bytes**, SHA256 `a15b066e4364d7d4723a119d4d7145fa80e58b5f298f0847587ff049da48f35f`, original signer cert SHA256 `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`. Original R89 and user-confirmed R96 Golden preserved.

Only two APK members differ from R98: `AndroidManifest.xml` (version) and `assets/web/family-diary.js` (settings accordion/touch fix). 53 of 55 unchanged from R98. Existing R92 native keyboard `classes4.dex` byte-identical, photo/memo/IndexedDB/daily calendar and other features unchanged. NAVER work still on hold.

## UX and touch fix
- Settings > App > "화면 빠른 이동 패널" is now a **single compact disclosure row by default**, with native HTML `<details><summary>` and chevron. Tap row to expand/collapse all six existing controls. No new screen, no extra app.
- Removes the R98 `settings.addEventListener('click',sync,true)` capture-phase synchronization that could overwrite input state during native click processing.
- Checkboxes use native `change`; sliders use `input` and `change`, with preference persistence, live displayed values and disabled-state synchronization. Controls do not trigger parent app click delegation. Does not call `preventDefault` on checkbox/range/summary, preserving touch semantics.
- Existing R98 settings values and original R96 movable/lockable up/down buttons are preserved. Collapsed by default; setting values remain persisted.
- Does not assert that every user-reported non-responsive touch was reproduced from video; several sliders visibly changed values in recording.

## Verification
- Full APK RSA3072 v2 signature/content digest PASS, ZIP CRC PASS, original cert PASS, JS syntax PASS.
- **Real headless Chromium mobile viewport/touch-capable browser DOM test PASS**: disclosure default closed, tap expand/collapse, checkbox on/off, dependent slider enable/disable, range updates and live label, edge snap toggle, persistence callback.
- Galaxy S26 Ultra real device R99 behavior **NOT YET VERIFIED**.
- ChatGPT Android file download success **NOT YET VERIFIED**; user had prior repeated `Library file not found`, see `MOA_RELEASE_DOWNLOAD_LINK_RELIABILITY_CRITICAL_RULE_20261105.md`. Do not declare user delivery success until user reports it.
- Source `MOA_R99_SETTINGS_ACCORDION_PATCH.py`, browser test `MOA_R99_MOBILE_CHROMIUM_TOUCH_TEST.py`, full `MOA_R99_VERIFICATION.json` in private Library folder. Private signing keys not uploaded.
