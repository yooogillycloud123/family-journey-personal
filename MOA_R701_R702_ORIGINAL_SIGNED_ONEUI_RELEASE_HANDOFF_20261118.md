# MOA R701 OneUI Native Volume Integration — ORIGINAL-SIGNED APK and R702 R697 Recovery (2026-11-18)

## STATUS
- **R701 signed installable APK BUILT, Android SDK35 DEX compile PASS, independent v2 RSA signature/content digest + ZIP + DEX integrity PASS.**
- **R702 signed higher-version EXACT R697-functional recovery BUILT, same static gates PASS.**
- **Galaxy real-device install/runtime NOT TESTED**, user-approved physical Golden still **R697**. Do NOT call R701 a device-tested Golden.
- Earlier R701 `SOURCE_ONLY` handoff was historical and is **SUPERSEDED** by this actual signed release.

## Exact downloadable artifacts
- R701 `MOA_R701_ONEUI_SINGLE_SYSTEM_VOLUME_ORIGINAL_SIGNED_BETA.apk`
  - Android versionCode **701**, package `com.juhyeon.familyjournea`
  - SHA256 **`1a655d25cc81cf97aa6d16c124fb8214c44da55a479fc5d4f5e439bf36e12b6c`**, **9,804,145 bytes**.
- R702 exact R697 functionality restored, `MOA_R702_EXACT_R697_FUNCTIONAL_FORWARD_RECOVERY_ORIGINAL_SIGNED.apk`
  - Android versionCode **702** (installable on top of R701; never uninstall)
  - SHA256 **`f57bffc84aa2eee4e5ab07e100afab796e6fadc5058399c543b797518dfeb170`**, **9,801,420 bytes**.
- Full package 2 APK + complete source+QA+readme:
  - `MOA_R701_R702_ORIGINAL_SIGNED_APK_QA_COMPLETE_20261118.zip`
  - SHA256 **`539a4962b1e651c4a5d81f5bd277dd9c3fa2c8d81d299116e85189727072a86b`**, **14,552,467 bytes**.
- Personal Library **actually uploaded** at `/모아_프로젝트_근거_20261103/R701_ONEUI_SIGNED_R702_R697_RECOVERY_20261118/`, all above files plus signing verification JSON. Do NOT falsely say they are absent in another new chat. Use Files/Library search, materialize as needed.
- Original **private R39 signer** still in `/모아_프로젝트_근거_20261103/PRIVATE_SIGNERS/MOA_R39_SIGNING_BACKUP_PRIVATE_KEEP.zip`, passwords private registry same folder; neither key nor password ever publish. Cert SHA256 **`5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`** identical to R697 and R701/R702.

## User requirements from 23562.mp4 & implementation
- R699 synchronized *numeric system media volume*, but left a conflicting **MOA in-app vertical volume slider** and **Samsung native system media slider**. In user's screen recording system media reached 100 while video was still **local-muted**. R701 resolves by:
  1. Force original native `volumeBubble` `GONE` in gallery monitor, no custom volume rail.
  2. Speaker icon click original `toggleMute()` then `AudioManager.adjustStreamVolume(STREAM_MUSIC,ADJUST_SAME,FLAG_SHOW_UI)`, requesting the **real Samsung OneUI media panel** without changing the global volume.
  3. Activity hardware volume keys targeted to `STREAM_MUSIC`; prior Window volume-control stream restored on gallery exit.
  4. Real `STREAM_MUSIC` level rises during prepared local-muted video -> original Gallery `toggleMute()` one time to unmute player, restore hardware set system volume if Gallery unexpectedly modified it, synchronize icon and remember preference across next video.
  5. Keeps R699 **calendar visible-day incremental update + limited thumbnail cache**. Does NOT disable all Android MediaStore indexing.
- Preserve original Gallery engine `classes6.dex`, original PHOTO host `classes18.dex`, diary JS engine, MediaStore data and Naver state. Do not modify AirPods/Android Auto or alter global audio routing.
- R701 v R697 **163/167 ZIP entries uncompressed payload byte exact**, changes: `AndroidManifest.xml`, `classes17.dex`, `classes19.dex` (version display only), `assets/web/moa-r697-vertical-calendar.js`.
- R702 v R697 **166/167 original entries byte exact**, **only AndroidManifest.xml versionCode and versionName changed**. Do NOT mistake R702 for R695 recovery.

## Verified
- GitHub Android SDK 35 Java17 `javac --release 8` and D8 compile workflow **SUCCESS** https://github.com/yooogillycloud123/family-journey-personal/actions/runs/44264603426
- Compiled `classes17.dex` SHA256 **`3c31d31fc9bf7e4290640024052eb18851eac9cb3c107b41e03c5d7a216401d4`**, actual 90,768 bytes, original Gallery untouched; `r701ApplyGalaxyVolumeUnified` and `r701OpenGalaxySystemVolume` present.
- Original-signer private key ↔ cert SPKI match; both APK signature and Android v2 full contents SHA digest independently verified, ZIP CRC and alignment, all DEX SHA1/Adler, original package remains same, version 701/702 manifest verified. R699 JS syntax + incremental date DOM mock PASS.
- **NOT VERIFIED:** Galaxy side-button physical behavior, exact OneUI SystemUI panel dismissal, installation and regression for Gallery, native audio behavior at the already-max volume when + does not increase numeric value. Also no local Android official `aapt`/`apksigner` output; independent cryptographic verifier used.

## Install/QA/next work
- Update-install R701 on current R697/R699/R700 (all have lower versionCode), **never uninstall/clear data**.
- Verify muted video side VOL+, resulting actual sound and speaker icon, OneUI panel after icon tap, no MOA duplicate slider, cross-video behavior, gallery/photo/diary/date/new-photo/calendar and Naver and original bulk remove features. Try phone speaker/Bluetooth audio as output.
- If any regression, update-install **R702 exact R697-functional** higher version recovery, without deleting data. Any following APK candidate versionCode must be **>=703**, and higher recovery code if releasing again.
- R697 exact user success baseline SHA256 `67a8892c661e38ea9ec4227baa6ecb053bfe612ef874594e6fdf1b250820328e`. R683 separately protected Golden.
- Release source: branch `feature/moa-r701-oneui-system-volume-single-panel-20261118`, provider source `experiments/moa-r697/MoaR391SessionPersistProvider.java`, calendar remains the R699 variant `experiments/moa-r697/moa-r697-vertical-calendar.js`.
