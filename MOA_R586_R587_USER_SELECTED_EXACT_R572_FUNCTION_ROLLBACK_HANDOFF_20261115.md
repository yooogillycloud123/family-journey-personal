# MOA R586 / R587 — user-selected R572 exact-function rollback (2026-11-15 KST)

## Latest user decision
Following the physical R584 FAIL (user `22101.mp4`: native photo-form Gallery not displayed; unwanted recovery ↻ visible outside Settings), the user explicitly selected **R572** instead of suggested R570: **"572로 가자 통일성확보한버전"**. The request is RESTORE, not another gallery patch. Exact R572 UI features to keep: normalized eight action icons/34dp hit zones, reorder, independent dark capsule, fast persistence, fade-out Naver status, photo 112dp lower strip vs video 137dp, other R572 assets unchanged.

**Current restoration baseline to install: R572 function, versionCode 586.** R567 stays user-approved immutable Golden, not used for normal rollback. R572 was a physical-test-pending beta, **not user-confirmed flawless Golden**; this forward rollback preserves its actual function as-is without promising all prior QuickRecord photo-form issues disappear.

## Signed artifacts (COMPLETE, no build in progress)
- **Primary INSTALL** `MOA_R586_EXACT_R572_UNIFIED_ICONS_FUNCTION_ROLLBACK_SAME_SIGNER.apk`; package `com.juhyeon.familyjournea`; versionCode **586**, 9,084,760 bytes, SHA256 **`b9817e9da563c259740b82a9b22a490f8ec7124fbff74ebe564b32e6a382f287`**.
- Source is literal original R572 same-certificate signed APK `MOA_R572_COMPACT_DOCK_RAIL_FLASH_FAST_TOAST_ORIGINAL_SIGNED_BETA.apk` (SHA256 `a5eeff113022894afa2f72fb4d149e8ee4c1269dabf8c78d16fca28e5ece10ab`). **Only AndroidManifest.xml content changed** to forward version 572→586: **143/144 archive member contents exactly identical, including original JS/CSS, native classes18.dex, all first 17 DEX, Naver writer, all eight buttons and their actual listeners.** No new recovery button, rail translation, IDB scan, native visibility blocker or Gallery rebind experiment from R574–R584.
- **Emergency ONLY** `MOA_R587_EXACT_R567_GOLDEN_EMERGENCY_SAME_SIGNER.apk`, versionCode 587, 9,069,599 bytes SHA256 **`7e56648714ddda11c73c06175fcbadef339eaabce70fb863c04501cc9a9d4daa`**, same functionality as exact user-approved R567, 142/143 Golden archive contents byte-identical (only versionCode Manifest differs). This DOES NOT preserve R572's later unified 8-action UI. Never install in normal course.
- Original signing cert SHA256 `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15` unchanged. Both release APKs independently verified **APK v2 RSA, full signed-content digest, signer certificate, package name, correct Manifest version code, ZIP CRC, stored member alignment, all 18 DEX SHA1/Adler32 integrity PASS**.
- Bundle `MOA_R586_R587_R572_FUNCTION_RESTORE_QA_20261115.zip` SHA256 **`311378178e26f3ae934bead4ef4bb4ffe30eb750aad4f5dfca6d93cc6e87bd39`**, 19,664,392 B with R586 install, R587 emergency, exact immutable R572 original binary for comparison, JSON SHA and verification report, README, SHA256SUMS. Bundle CRC + all SHA256SUMS verified. **NO signer keystore/password, credentials, user media.**
- Library exact persistent folder `/모아_프로젝트_근거_20261103/R586_R587_R572_EXACT_FUNCTION_RESTORE_20261115/` with three delivered artifacts archived.

## Update-install procedure and stop conditions
1. User device with current code <=585 and identical original signer: **install R586 directly over current existing MOA**. No uninstall, data/cache clearing, IndexedDB erase, personal photo deletion, Naver logout or cookie change. **Do not install old R572 directly**: Android rejects downgrade.
2. Test previously functional PHOTO day, VIDEO day, 8-icon scale/reorder and rail spacing; then same-day Quick Record -> detailed diary vs photo format. If Quick Record photo-form is still blank, acknowledge it remains a R572 baseline bug and capture actual same-date media IDs; do **not** immediately stack another blind change.
3. Use R587 only for severe failure requiring **exact R567 Gold functionality**, with explicit caveat it loses later icon changes; if installed, next update versionCode >=588.
4. R586 Samsung on-device result currently **NOT TESTED**. User-approved Golden remains R567; R572/R586 are user's chosen rollback point rather than automatically approved Golden.
5. MOA-specific work only. AirPods/Android Auto sources and shell daemon untouched.

## Source/history
- Historical [R572 source+signed handoff](MOA_R572_R573_R570_SIX_USER_ISSUES_ORIGINAL_SIGNED_HANDOFF_20261114.md).
- Previous [R584 R585 experimental regressions](MOA_R584_R585_R582_USER_VIDEO_GOLDEN_RAIL_AND_QUICKRECORD_RECOVERY_HANDOFF_20261115.md) not used as code base.
- [R567 immutable Golden lock](MOA_R567_USER_APPROVED_GOLDEN_LOCK_READ_FIRST_20261114.md).
- This is an exact R572 binary-payload restore with new version code. No GitHub source branch rewrite or CI rebuild needed: restoration was cryptographically signed and structurally verified against the original R572 signed APK.
