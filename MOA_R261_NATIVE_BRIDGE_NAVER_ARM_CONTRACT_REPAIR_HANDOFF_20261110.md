# MOA R261 — R255/R257 NAVER saving no-reaction exact bridge mismatch repair (2026-11-10)

## User Galaxy evidence (private, do NOT publish media)
User sent `20083.mp4` (110s), `20090.mp4` (23.5s), `20091.png`, `20093.png`, `20095.png`. Existing Diary PHOTO/GPS/alias/memo/list visible. User taps '주소로 저장 + 메모', MOA shows '저장 중' but NAVER Accessibility save UI does not start; no completed favorite. R257's so-called 'final' sandbox link also showed 'Library file not found'. User confirmed R255 boot PASS; R257 standard version boots but saving no response. R251 crash regression already known.

## Definitive root cause from actual R255/R257 ZIP and DEX (not conjecture)
Decoded signed R255/R257:
- `assets/web/fj-naver-favorites.js` calls **`NativeHost.post('naverSave', ...)`** to start favorite saving.
- `HostActivity.smali` Java native bridge registers **`naverArm`**, `naverStatus`, `naverCancel`; it **does NOT dispatch `naverSave`**. Unknown command goes to debug 'Unsupported original bridge operation'.
- Thus the visible Diary frontend could report `NAVER_UI_SAVE_RUNNING` optimistically while the *actual* Android Accessibility saving job was never armed. All R255/R257 route changes after dispatch were ineffective.
- An additional R249 `MoaNaverAccessibilityCover.begin()` remained in baseline signed code. This attempts a fragile WebView overlay/reparent and was independently implicated in prior UI corruption/blank screen; R261 disables that call in the active `naverArm` branch, WITHOUT removing original first-party NAVER app launch or Accessibility service.
- Host startup includes a status callback with `id` equal to payload `key`, and `naverStatus` reads the same expectedPoi; JS remaps to original diary photo ID for display and progress. **No user secret/cookie scraping**.

## Actual locally built R261 APK — exact
`MOA_R261_NATIVE_NAVER_ARM_RESTORE.apk` SHA-256 **`db6d34067a7d2f3b97291ca1746a58c97d71d30f4b3f120cefe7751933a5c9a2`**, bytes **8,928,487**, package `com.juhyeon.familyjournea`, versionCode **261**, original signer cert **`5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`**, Android APK v2 VERIFIED, zipalign PASS, ZIP CRC PASS, DEX SHA1 + Adler32 PASS (15 DEX). Same-signer update over R257 or R255 without deleting data.
- Base R255 **user-confirmed BOOT PASS** APK SHA `3b34cfef5f1344d683a181f556d3e9f76fa7474b4cbdb2b1f5a2b00fd3cf7342`.
- Only four non-signature payloads change vs R255: `AndroidManifest.xml` 255→261, `classes2.dex` (one live `begin()` call → `nop`), `assets/web/fj-naver-favorites.js` (exact command + progress/ack + photo-state remap), and `assets/web/moa-r231-settings.js` (opt-out result popup), all other user-gallery/diary/audio/QuickRecord native assets byte-identical.
- Artifact ZIP `MOA_R261_APK_BACKUP_AND_KOREAN_GUIDE.zip` SHA `a076863e8a92f9b61a808059bf480f428cdbea1c501a195f7e6847834a04ffae`: exact signed APK + Korean guide + JSON QA + SHA list. PASS inner APK byte identity. Source ZIP has NO signing keys.
- Node live-bridge mock (script `moa_r261_fix/test_actual_android_bridge.cjs`) PASS exact `naverArm` command, GPS/address/alias/list/memo 7 fields, reverseAddress response, startup/status ack and terminal state; R261 source JS syntax PASS.
- Prepared data-preserving recovery R263 `MOA_R263_EMERGENCY_RESTORE_R255_APP.apk` (versionCode 263) from exact R255 payload; only manifest version differs, if R261 should fail boot. **Not a second feature app**.

## Scope and truthful acceptance
- **Real Galaxy R261 boot/NAVER account favorites result NOT YET TESTED**; this repair fixes *first demonstrated bridge initiation regression*, not proof that list creation+save+alias+memo/readback works on current NAVER UI.
- The intended visible legacy first-party NAVER app + Accessibility service can occupy phone screen temporarily; complete zero-screen-occupation and NAVER server readback NOT IMPLEMENTED.
- On-user-device acceptance: update install existing MOA no uninstall/cache/data clear; open original Diary/photo, tap one existing favorites button, see native app open and monitor status. If it reaches `WAITING_ADDRESS_RESULT`, precisely select exact place card; if fails save sheet, inspect scoped state not blindly rebuild.
- **Do not make 'saving...' on JS dispatch into 'success'**; only native confirmed UI may show *UI success*, and actual account readback is separate.
- User requires preserve entire normal MOA while solving favorite saving; no six-field test panels, multiple helper APKs, root/Shizuku, PC workers, or fullscreen cover workaround.
- Original R227 immutable golden SHA `53c4c04ce32ad13de3c0613f4e5ec7abbc75ccbdfe9db5da05d8fa9b806ec6cd` preserved.
