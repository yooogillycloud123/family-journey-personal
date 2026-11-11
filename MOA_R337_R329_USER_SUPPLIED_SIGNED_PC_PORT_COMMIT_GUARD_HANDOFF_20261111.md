# MOA R337 / R339 — User-supplied R329 signed build with verified R333 source port and commit guard (2026-11-11 KST)

## User correction and actual base
The user **never received R333 APK** and explicitly corrected the assistant for falsely implying otherwise. They uploaded exactly:
- `MOA_R325_ADDRESS_STAR_FIRST_R327_RECOVERY_QA_20261111.zip`: SHA256 `ab6bb33a310824f747a44c2908d3411c39cf8a9cd71c7ad963d5985c7c53dcba`; 13 entries, CRC PASS, contains signed R325+R327 APK.
- **Actual latest delivered** `MOA_R329_ALIAS_MEMO_FIRST_R331_RECOVERY_QA_20261111.zip`: SHA256 `c702023a7308204439b72ea6b919b993fe03aeceae6f53b111fcf00a3e38d54e`; 10 entries, CRC PASS, contains signed `MOA_R329_ALIAS_MEMO_BEFORE_LIST_SAME_SIGNER_BETA.apk` SHA256 `e904c41cb2f290b54de37d9fe3b4aea551dbd22e17a561e001abeac2055d4dd5` and R331 recover APK. **Never demand the never-delivered R333 binary again.**

## Recovered actual source
R333 private Library under `/모아_프로젝트_근거_20261103/R333_20261111/` holds exact R333 `fj-naver-favorites-r333.js` and `moa-r333-web-probe.js`. Separate prior generated source-only `MOA_R333_COMMIT_READBACK_GUARD_SOURCE_ONLY_20261111.zip` contains patch correcting implicit six-second COMMIT_WAIT → VERIFY_LIST without any click acknowledgment.

The original R39 PKCS12 signing backup was recovered from **private** Library `/모아_프로젝트_근거_20261103/PRIVATE_SIGNERS/` and certificate SHA256 cryptographically matched to the R329 APK's existing signer. **No private key/password made public.**

## Real current-turn signed artifacts
- `MOA_R337_R329_BASE_R333_PC_FLOW_COMMIT_GUARD_BETA.apk` **versionCode 337**, 8,879,231 bytes, SHA256 **`c4f3ed66e48e50d355adf4e16971671d6510f7674eb94413770af77b6adc9bc9`**. Package unchanged `com.juhyeon.familyjournea`; original cert **`5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`**.
- `MOA_R339_FORWARD_RECOVER_R329_FUNCTIONS.apk` **versionCode 339**, 8,879,863 bytes, SHA256 **`14e13b9849c74c9eb177df17ddd03efcb6cbff4b06f82b42bac4b02fb5e69cfa`**: R329 uncompressed member payloads identical except Manifest versionCode, higher version fallback if R337 regresses. Actual Galaxy recovery update-install NOT tested.
- Backup ZIP `MOA_R337_INSTALL_APK_R339_RECOVERY_QA_20261111.zip` 12,862,042 bytes SHA256 **`b29ed5cd7fbda49768b0c256207fa7a8734f8f8c499f66a0d9ef1f70a278d052`** contains *byte-for-byte identical* R337 APK, R339 APK, QA, Korean install/readme, two JS assets, Node test and SHA manifest; ZIP CRC PASS.
- **Durably saved privately**: `/모아_프로젝트_근거_20261103/R333_20261111/MOA_R337_INSTALL_APK_R339_RECOVERY_QA_20261111.zip` and standalone QA/readme in that folder. User also received directly in the current chat via verified /mnt/data download.

## Exactly what changed
R329 original 138 APK entries; **only 3 uncompressed payload members changed** in R337: `AndroidManifest.xml` code329→337, `assets/web/fj-naver-favorites.js` (R333 actual private source), `assets/web/moa-r231-naver-frame-probe.js` (R333 actual source + commit ACK guard). **135/138 original entries and ALL 16 DEX exactly unchanged**, preserving diary, photo/gallery, M4A/voice, Quick Record, return overlay, other data and settings payloads. `moa-r231-settings.js` is still original R329 because R333 settings source was not available; therefore do not falsely claim byte-perfect full R333 parity. R337 web probe JavaScript = 21,798 Java chars, under 24,000-character native guard.

Fix: COMMIT_WAIT cannot auto-promote after six seconds. No COMMIT_CLICKED ACK for ten seconds => READBACK_UNAVAILABLE, no true saved status. Confirmation only after commit click stage + intended list-opening + folder ID + readback path. PC-based correct address result/heading/star, alias→memo→list last, full original list scan before creating new private list. Ambiguous list name/failed page remains fail-closed.

## Actual verification / limits
- Original signing certificate matched private PKCS12 and original signed R329 APK.
- APK Signature Scheme v2 RSA signature **and full chunked SHA256 content digest PASS** for both files.
- ZIP 138/138 CRC PASS; resources.arsc STORED and aligned; STORED DEX aligned; 16 DEX byte equal and SHA1/Adler PASS.
- Node syntax `--check` PASS for both updated JS; R337 commit contract **12/12** PASS.
- Backup ZIP inner APK bytes exact match to standalone outputs.
- **NO Galaxy installation test. NO real NAVER account favorite/list creation/readback PASS. Android WebView synthetic `.click()` remains an unproven trust/action gate**; R337 is a signed BETA test candidate, not FINAL or Golden. Original R269 Golden, Gallery, Diary, Quick Record, AirPods audio daemon untouched. No app uninstall or data wipe.

## User instructions
Install **R337 only** as same-package update over current R329 (provided installed version is <=337); NEVER uninstall/clear data. Check current diary/gallery/recording/return overlay, then try exactly one NAVER place favorite and verify in actual Naver account. R339 is emergency *forward* recovery to R329 functionality only when R337 breaks old functions, not routine install. Once R339 installed, standard downgrade to R337 is blocked. Future candidates need >339 versionCode to follow R339. Report actual device PASS/FAIL separately.
