# MOA R345 USER-OBSERVED NAVER SAVED-LIST GOLDEN — IMMUTABLE CHECKPOINT (2026-11-11 KST)

## Status / scope (do NOT inflate to fully certified release)
User physically installed R345 and supplied two screenshots and two short videos after testing:
1. In-app Naver PC web visible while waiting for save.
2. Screen-nonoccupying / offscreen save while doing other activities.

The same **logged-in first-party NAVER PC saved list** displays `내 장소` **187 items** versus the previously recorded **185**, and two new location entries are visible. This is a materially stronger confirmation than a UI star click or an unverified local 'save' notification. The user reports both workflows appeared successful. **Designate this exact R345 build a user-confirmed scoped Golden checkpoint for observed first-party account-list entry and visible/offscreen workflows**, while clearly keeping strict independent API readback, alias/memo exactness, never-created duplicate lists, offline/retry, and long-running unattended correctness OPEN. No claim of complete Android automatic Naver account save FINAL.

## Frozen exact signed APK / release
- Name: `MOA_R345_EXACT_ADDRESS_HEADER_STAR_CLICK_REPAIR_BETA.apk`
- Package: `com.juhyeon.familyjournea`
- versionCode: **345**
- Size: **8,880,150 bytes**
- Immutable APK SHA256: **`fe2aaaac15d39a610268ee3d10361652a95537e0ce8ec9cde86e98edf3f8ceb1`**
- Original signer certificate SHA256: `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`
- Original QA: independent APK v2 RSA/full content digest PASS, APK ZIP CRC 138/138 PASS; all 16 DEX preserved. Compared with signed R341, only `AndroidManifest.xml` and `assets/web/moa-r231-naver-frame-probe.js` payloads changed; **136/138 original functional archive members unchanged.**
- Original paired APK+recovery release ZIP SHA256: **`cd63e8367c825be8fecd6738d0cb3cd1938f7d1025b9a450f4679fde07cda6ef`** (name `MOA_R345_APK_R347_RECOVERY_TESTS_20261111.zip`). It contains the EXACT R345 APK SHA above (CRC and hash independently checked).

## Durable private artifact path — avoid asking user to upload again
The original release ZIP with byte-identical R345 signed APK is **already stored** in private personal Library:
`/모아_프로젝트_근거_20261103/R345_20261111/MOA_R345_APK_R347_RECOVERY_TESTS_20261111.zip`

Additional private user-Golden folder:
`/모아_프로젝트_근거_20261103/GOLDEN_R345_20261111/`
contains README, **138-member full SHA256/CRC manifest**, exact source JS and user evidence screenshots. A redundant new Golden ZIP upload was refused by **`library_storage_limit_exceeded`**; do not interpret that as loss of the already preserved original release ZIP. Public GitHub stores **source and hashes only**; never family video, exact home location/GPS, login cookies, session, APK private signer/keys.

Public user-Golden source-only branch:
`golden/moa-r345-20261111-user-naver-list-visible`
Three Web assets extracted from exact signed R345 APK (full content git blob SHA checked):
- `goldens/moa-r345-20261111/source/assets/web/fj-naver-favorites.js`: Git blob `f9a6efcae12ac60f2a13517dfb8aa22becc3f140`, content SHA256 `3338e0f182769272f024e5e5240092f4df9b3566fdabbe6e5bb203a288b24d0a`
- `goldens/moa-r345-20261111/source/assets/web/moa-r231-naver-frame-probe.js`: Git blob `86fc336af8ddbae52eb77566a824aa93b1e42b4e`, content SHA256 `351a9c6eafd576222bee15cc2ce85f2d9fb2cb1d03ede3135c14369030ad2413`
- `goldens/moa-r345-20261111/source/assets/web/moa-r231-settings.js`: Git blob `29c38546ac3cbf68cd1a3d70adfe99769fb2949e`, content SHA256 `076e2dedc1e584639595e01936e709a830800fdb7411cf3481bc91bd51b7fd70`
These 3 files are exact extracts and collectively demonstrate source-level reference; original user-Golden APK is preserved via the Library release ZIP, not built from the branch in GitHub.

## Device evidence provenance (private only; DO NOT publish raw)
- `20430.png`: screenshot of first-party NAVER `내 장소` list at **187**. SHA256 `bedd29d4861f443cf9002e367cf0834bf658c5bd0b2e0902a743a1f9f49dc920`.
- `20432.png`: visible first-party saved list entry. SHA256 `a34e2da62134a6ecc768bfa153dd5656bd3a3912d0fc25d400729707f6a24318`.
- `20434.mp4` ~51.59s showing MOA screens and NAVER saved list, SHA256 `23662b4613e411eaa16c0e8a0afa57e317e7b277deb5f0d7e386c66b07ff6181`.
- `20435.mp4` ~19.81s showing another activity/Naver app/one-tap MOA return, SHA256 `aea6ee5fa6d3d7fdf40ad5a0f5277d1adb3592d75fa6007ba57069c404c3f8c8`.
Screenshots were archived in the private Golden folder; videos are user conversation uploads referenced by hashes and not republished.

## ABSOLUTE preservation rules
1. **Never edit, overwrite or resign R345 Golden APK or the frozen source branch**. Future work must fork into separate feature branch and make higher code version.
2. **Never routine-install R347**. `MOA_R347_FORWARD_RESTORE_R341_FUNCTIONS.apk` returns functional members to **R341**, not the newly verified R345. Installing it would remove the successful R345 behavior and block a lower 345 update. Preserve it only as historical emergency, not Golden recovery.
3. New functional candidate versionCode should be **>=349** to remain forward-installable above the existing R347 version, with verified original signer.
4. Preserve gallery/photo/video, diary, Quick Record, audio recording/voice, Naver 1-tap external return, existing Golden R269/R227/R219 etc. **Do not uninstall, clear app data, erase ADB pairing, touch AA AirPods audio/daemon.**
5. Improvements in strict readback/list-creation/alias-memo, concurrency, retry, long-running offscreen mode MUST be additive and tested against R345.
6. If user later reports a regression, preserve working R345 original and build a higher-version functional-equivalent recovery from exact R345 bytes (manifest-only if possible), not from R341.

## Latest test gate
The **first-party NAVER account list displaying new entries and increase 185→187 = user-device positive proof**. Keep remaining strict checks OPEN, not synthetic PASS. Do not ask to rerun previously proven address / star discovery; request new tests only for one currently unresolved issue at a time.
