# MOA R92 — selected diary calendar-first + native capture memo auto-IME (2026-11-05)

## Highest priority status
The user supplied screenshots 18836.png / 18838.png / 18840.png, and asked for ONLY TWO UX fixes.
1. When tapping camera **바로 기록**, immediately focus the existing native EditText, show Samsung IME by default, and keep the R89 microphone, safe whole-clear and save buttons above the keyboard.
2. On **내가 고른 사진 일기**, place the monthly calendar BEFORE the large **촬영 즉시 기록** controls. Retain all capture/watch/save status operations intact below the calendar.

**NAVER maps R91 is explicitly ON HOLD** and is not part of this release. Do not merge the R91 navigation/virtual-display branch into R92.

## R89 immutable Golden base
- Exact private Library signed APK: `/모아_프로젝트_근거_20261103/MOA_R89_USER_DEVICE_GOLDEN_20261104_DO_NOT_MODIFY.apk`
- SHA256 `2b52826fc0dd8653a70d3c503d3654ae33071bfc4ec075753ec4464a1e2dc493` (3,491,886 bytes).
- ApplicationId `com.juhyeon.familyjournea`, versionCode 89.
- **Existing signer certificate SHA256** `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`.
- Golden GitHub branch `golden/moa-r89-20261104-user-device-pass-do-not-modify` never modified. R83 voice, R87 clear, R85 editor title, R63 IndexedDB direct diary write, R89 IME-safe footer must remain.
- DO NOT uninstall or clear app storage. Existing R89 remains frozen.

## R92 BETA (compiled + signed and statically validated; not yet device-tested)
- Implementation branch **`feature/moa-r92-auto-ime-calendar-first-20261105`** based DIRECTLY on the immutable R89 source anchor, NOT R91 branch.
- Native patch: `tools/moa_r92_auto_ime_patch.py`, applied ONLY after the original R80→R83→R87 compile chain. Changes the native memo `SOFT_INPUT_STATE_ALWAYS_HIDDEN` to `SOFT_INPUT_STATE_ALWAYS_VISIBLE`, requests initial edit focus, asks Samsung IME to display after first window focus, guarded to request only once. R89 native footer and every saving/voice/clear callback remain unchanged.
- Native GitHub Actions workflow `.github/workflows/moa-r92-calendar-first-ime.yml` successful run **41993970386**. First rebuilds EXACT R89 DEX SHA256 `f1513f5be8741a401943d2654665460b78dbfa6a8acdc463039e54c59b0ae608`, then changes only native memo source and recompiles new `classes4.dex` SHA256 **`a975be1c091441a9f1111bc6d5d8ed09a0fc1143cb7187ee35466ab8984ce5f5`**, 101116 bytes.
- Diary JS patch: `tools/moa_r92_calendar_first_patch.py`, exact pinned R89 JS SHA256 `1ee82f8e55ceb08c1a9daee8a6c6f10117405b7e29db8e61dab078854df81ec3`; new SHA256 **`427fd8c42b4d7d890d5e05051352e4e879bce1f06f9e7c19f70531c280cba837`**. Two minimal DOM-order changes: removes `S.root.append(mmToolbar())` before mode tabs; appends the EXACT original toolbar after `S.root.append(grid)` + calendar hint, before PC photo import/new diary actions in `renderCalendar()`, conditional on curated mode. No new data writes, no schema changes, no differences to non-curated mode. Node.js syntax PASS.
- Signed APK **`MOA_R92_CALENDAR_FIRST_AUTO_KEYBOARD_BETA_Install.apk`** in same private Library folder, **3,491,842 bytes**, SHA256 **`6ce4f8de6f924c66e771ca16c8f3be5af1e5795afce092e6c7a39e2d51c68982`**.
- Package unchanged `com.juhyeon.familyjournea`; versionCode **92**, versionName `MOA-R92-Safe-Capture`; original signer same public cert SHA256 `5a86862b...`.
- Compared decompressed ZIP members to the exact R89 artifact: **55 total, exactly 3 changed** (`AndroidManifest.xml` version only, `classes4.dex` native UI only, `assets/web/family-diary.js` UI order only); **52 uncompressed members identical** (including index, CSS, all other DEX, native host/voice launcher, original IndexedDB writer, maps/NAVER and photo code).
- Local APK v2 RSA-3072 signed-data verification and correct section content digest PASS; ZIP CRC PASS; all stored members 4-byte aligned; new DEX compiled with Android SDK 35/d8, R89 baseline DEX byte-identical; independent Android device install/operation **NOT TESTED**. Do not label new R92 Golden until device confirmation.
- No signing key, signing password, or user media is stored on GitHub.

## Emergency single-app rollback-forward (only if R92 fails)
- Optional **`MOA_R93_RESTORE_R89_GOLDEN_EMERGENCY_Install.apk`** in private Library (not an extra helper app).
- Same `com.juhyeon.familyjournea` package and original signing certificate, versionCode **93**, SHA256 **`26cdf23f3339534c9a4771625b8a4db45940692168c87541c16b1552d13668ba`**.
- Exact R89 Golden **54 of 55 decompressed APK entries identical**, only manifest versionCode/versionName changed, so may install *over* R92 and restore R89 functionality without downgrading/uninstalling/data clearing. APK v2/digest/CRC verified; phone install still user-untested.
- If user installs R93, future versions must be >=94.

## Galaxy acceptance checklist (pending, no claims)
1. Tap camera **바로 기록** on unlocked Samsung S26 Ultra. The memo EditText receives focus, the Samsung keyboard appears automatically, all 3 footer actions remain visible and operative.
2. Microphone speech, typing, clear confirmation and Save retain proven R89 behavior; note sync into original photo day/time retains proven R63 pathway.
3. Open **내가 고른 사진 일기**: top shows title, status, mode tabs then month controls+monthly grid; **촬영 즉시 기록** large panel now BELOW grid. Switching to **자동 사진 달력** remains unchanged.
4. Keep original app data and media intact. No NAVER feature changes, Shizuku, root, background helpers, or reinstall needed.

## Next chat
Read this alongside `MOA_R89_USER_DEVICE_GOLDEN_LOCK_20261104.md` and the canonical AA read-first as project instructions require. R92 is current beta for two UI changes, R89 remains user-confirmed Golden; NAVER R91 is parked for later.
