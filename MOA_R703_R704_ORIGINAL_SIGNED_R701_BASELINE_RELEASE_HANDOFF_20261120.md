# MOA R703/R704 — R701-preserving original-signed APK release handoff (2026-11-20)

## CURRENT TRUTH / NEW CHATS READ FIRST

**ACTUALLY BUILT R703 & R704 APKs (original R39 signer) and FULL SOURCE+QA ZIP.** These were produced after previous "ClientError/source-only" records; those earlier blocker notes are HISTORICAL and superseded.

**NOT user-device Golden.** The owner's Galaxy S26 Ultra has NOT yet been used to confirm R703 installation, actual zero-volume speaker icon, map GPS auto refresh, or full regression. Do NOT present static/CI PASS as physical PASS.

### Installation artifacts (PRIVATE PERSONAL LIBRARY)
`/모아_프로젝트_근거_20261103/R703_R704_R701_BASELINE_20261120/`

- `MOA_R703_R701_SAFE_ZERO_VOLUME_ICON_GPS_AUTO_REFRESH_ORIGINAL_SIGNED_BETA.apk`
  - package `com.juhyeon.familyjournea`, versionCode **703**
  - SHA-256 `9117395663ede860d33551544ccef37cfec736a48b52eae4aaf49c552afd796e`, 9,814,737 bytes
- `MOA_R704_EXACT_R701_FUNCTIONAL_ORIGINAL_SIGNED_RECOVERY.apk`
  - same package, versionCode **704 >703**
  - SHA-256 `97cf4b0269494e1fa20c0ee32782f05bbddbab97ecce68033a51c1465e44ba5b`, 9,804,137 bytes
- `MOA_R703_R704_R701_BASELINE_SOURCE_QA_FULL_20261120.zip`
  - SHA-256 `773e4c71a958ab1dfc6fa38b7f520e801fa694341846a3e7ce50543c0e18c1ff`, 22,003,436 bytes; 22 files
  - includes both APKs, immutable R701 source APK backup, changed actual Java/JS source, exact unified diffs, CI source/DEX, QA JSON/tests, Korean install/recovery instructions, individual checksums
- Original **R701** baseline APK SHA-256 `1a655d25cc81cf97aa6d16c124fb8214c44da55a479fc5d4f5e439bf36e12b6c`, code 701. User reported physical success specifically for Galaxy volume integration.

### Signature and static verification

- Original signer X.509 certificate SHA-256 `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`, same across R701, R703 and R704.
- APK v2 RSA PKCS#1 v1.5 SHA-256 signature, full content digest, ZIP CRC, stored-entry alignment: independently VERIFIED on all 3 binaries.
- All 19 DEX files SHA1 and Adler32 verified.
- R703 vs R701: **163/167 unchanged uncompressed file payloads AND original compressed member bytes**; only AndroidManifest.xml, classes17.dex, assets/web/app.js, assets/web/native.js changed.
- R704 vs R701: **166/167 unchanged**, sole changed AndroidManifest.xml versionCode; FUNCTIONALLY EXACT R701 RECOVERY, NOT R697!
- Original `classes6.dex` Gallery, `classes18.dex` PHOTO host, diary JS, calendar, media, Naver, EXIF sources and all existing resources left byte-identical.
- Java SDK35 javac + D8 CI [run 44749594615](https://github.com/yooogillycloud123/family-journey-personal/actions/runs/44749594615) SUCCESS, source branch [feature/moa-r703-r701-zero-volume-icon-map-autorefresh-20261120](https://github.com/yooogillycloud123/family-journey-personal/tree/feature/moa-r703-r701-zero-volume-icon-map-autorefresh-20261120), branch final source commit `9936ac0c4476f1b1ff5ad3dc25d8434ad3fa6d53`, DEX17 SHA-256 `318a332fd2641549352f0d79e955b75ebb2ce6c92db1980567019757f0f12741`.
- Java production implementation preserves R701 native OneUI sound behavior but updates only Gallery icon glyph with `effectiveSilent = playerMuted || getStreamVolume(STREAM_MUSIC)==0`; no icon-only setVolume/toggleMute side effect.
- Original R701 shipped `assets/web/app.js`, `native.js`, `family-diary.js` were **actually extracted and inspected** (earlier GitHub-only guesses superseded). Native GPS map was one-time boot and lacked photo delta adaptation. R703 now checks MediaStore ID + modification revisions on foreground and periodically while active (cheap metadata query), EXIF-re-reads only changed candidates, reuses its original private GPS cache, and recomputes active world/country/region markers without WebView/app reload. It does not add fake location to noGPS photos. Original manual photo reread kept. Existing diary, IndexedDB, MediaStore media, Naver cookies & settings not cleared.
- JavaScript `node --check` PASS for app/native/family-diary; mock map bridge test PASS (initial map single boot, overseas photo map delta, noGPS fallback), map-renderer-adapter isolated test PASS. Chromium `ERR_BLOCKED_BY_ADMINISTRATOR` so real browser integration test unavailable. Official local `apksigner` CLI unavailable; independent v2 cryptography was verified. Actual physical behavior still NOT TESTED.
- PRIVATE original signer & password were used only inside local trusted execution environment; never uploaded to public GitHub/CI, never included in QA ZIP. No Android Auto/AirPods source, daemon, audio routing changed.

### Install / recovery IMPORTANT
1. R703 APK is a BETA **update-install** on R701, same package and original signer. **Do not uninstall, clear data, delete photos, or reset permissions**.
2. Test Galaxy volume down to 0 => speaker muted glyph, volume up => appropriate glyph and actual audio; no duplicate volume panel. Test GPS photo capture/import => automatic Map country/region/photo count without clicking manual reread, including overseas. Test gallery/video, calendar/diary, multi-select deletion, Naver login and settings, existing data.
3. If ANY regression, **update-install R704** (code 704 >703) for exact R701 functionality while preserving app data. **R702 is NOT R701 recovery** (it is exact R697-function). R701 code701 cannot normally downgrade-install over R703.
4. After R704 is installed, future update candidates must be code **>=705**, with higher-code exact R701 recovery; check actual installed version before choosing.
5. Do not call R703 Golden before owner verifies on Galaxy; static PASS != physical pass.

### Remaining caution
Real Samsung S26 Ultra Android 17 behavior, native MediaStore permission/timing, stale pending fingerprint delivery, foreign EXIF location, full gallery regression and update-install with persisted real data require owner testing. There is now a real signed APK pair; if device tests find failures, use the preserved R701-based source+full QA ZIP to issue code705+ without modifying protected R701 behavior.
