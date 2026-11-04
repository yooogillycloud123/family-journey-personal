# MOA R86 — exact R83 USER VOICE GOLDEN rollback-forward, emergency ONLY (2026-11-04)

R83 user physical voice PASS, original package com.juhyeon.familyjournea code83 SHA256 221488ba5e1c6fb225c99837070cdad6028f1798aba396c05e73a763bb4e2d78. R85 is a title textarea auto-grow BETA; it does not change the voice engine. After an Android update to code85, the original code83 R83 APK is normally blocked as a downgrade.

Prepared an in-place **R86** restoring EXACT R83 application code while raising versionCode to 86: APK MOA_R86_ROLLBACK_FORWARD_R83_GOLDEN_Install.apk, size 3,486,540, SHA256 e8e96de72a206c23bbc860a1fb8dfe9d314076de075fa7e6f4557452286e6dd6, same original signing certificate. Comparing its decompressed 55 members to the user-proven R83 APK, the **only difference** is AndroidManifest.xml: code83->86, name R83->R86, two AXML bytes. Other 54/55 files completely identical; this includes native speech DEX, direct original HostActivity launcher, diary title original single-line UI, photo/memo IndexedDB engine. APK v2 signature and ZIP check PASS. Actual on-device R86 launch UNTESTED.

Use R86 **only if** the R85 title UI introduces a regression and the user must return to R83 behavior. Do NOT suggest old R84: it restores previously failed R82 voice. Do NOT uninstall or wipe app data. Save unsaved diaries before any update. New feature versionCodes must be >=87.

Private Library location /모아_프로젝트_근거_20261103/MOA_R86_ROLLBACK_FORWARD_R83_GOLDEN_Install.apk and matching verification JSON. Private signing keystore was used locally, never published.
