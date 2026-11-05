# MOA R111 launcher icon density resource repair — 2026-11-06

## User hardware evidence and actual root-cause candidate
On Galaxy S26 Ultra, R103–R109 app icon is heavily blurred in One UI home dock, app drawer, Samsung Installer and My Files thumbnail; user screenshot IDs 19014 and 19016. Not just stale launcher cache, since the downloaded APK preview is blurred. User-provided ChatGPT split APK showed a conventional density-aware adaptive icon implementation. R109 source 768x768 bitmap layers are independently sharp but Android appears to return a downscaled/magnified icon.

**Exact structural bug found in R109**: all 18 new `res/mipmap-nodpi/moa_adaptive_*.png` layers were inserted into **one type4 resource variant whose ResTable_config.density was 0xFFFE (anydpi)**. Android does NOT derive density from the path string; it uses binary `resources.arsc` configuration. The original 9 XML aliases shared that anydpi variant. A bitmap given ~65534 dpi effective source density can become an extremely tiny intermediate when rendered around 420–480dpi, then magnified into a blurry icon. This is an evidence-backed explanation and reproduces a similar visual effect in a local rescale simulation; true hardware causal confirmation remains pending. Android official docs distinguish nodpi (never scale) and anydpi (matches all densities). The old 512PNG-only approach had the same wrong anydpi resource configuration, so mere higher PNG resolution or adaptive XML did not address the problem.

## R111 fix
- Exact artifact `MOA_R111_DENSITY_RESOURCE_FIX_BETA_Install.apk`: **5,486,971 bytes**
- SHA256 `8056d4aff349f8745c2fd9da30c4c5106e0e2574202068870b07f9ca264384b0`
- package: `com.juhyeon.familyjournea`; versionCode **111**; original signer certificate SHA256 `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`
- Base: exact R109 signed versionCode109 APK SHA256 `e32c0036a5f177c14f84f50404233247c29a0f798259f59201f50406583e8d5c`.
- **Only two uncompressed members differ from R109**: `AndroidManifest.xml` (versionCode 111) and `resources.arsc` (mipmap type4 resources split into two density-configured chunks). Other **101 APK members unchanged**, including `classes.dex`–`classes5.dex`, user diary/photos/calendar/voice/IndexedDB, existing 9 theme assets, and both foreground/background PNG layer pixels. No new side app or data migrations.
- Mipmap config 0xFFFE (anydpi): IDs0–9 (existing ic_launcher and 9 adaptive launcher XMLs) ONLY.
- Mipmap config 0xFFFF (nodpi): IDs10–27 (18 foreground/background PNG resources) ONLY.
- Same resource IDs/strings/files retained, only their density metadata corrected.

## Independent validation
- Android APK v2 RSA PKCS#1 SHA256 signature and full content digest recomputed: PASS.
- Original certificate SHA256: PASS.
- ZIP CRC: PASS.
- Binary resource table two variant configs, 9 adaptive XMLs resolving to correct 18 nodpi PNG resources and 768px RGBA: PASS.
- Manifest versionCode 111 and unchanged package: PASS.
- 101 unchanged original R109 members: PASS.
- Android runtime installation, Galaxy icon clarity, reselecting 9 themes: **NOT PHYSICALLY TESTED**. Release is beta, not Golden until confirmed on phone.

## Emergency rollback-forward
VersionCode112 `MOA_R112_EMERGENCY_RESTORE_R99_NOT_ROUTINE_INSTALL.apk`, SHA256 `3c43a075c8dfc0af395839acf81ca089b58459eacba8ea6a7ba1528f23ba0707`, original signer, 3,511,994 bytes. Exactly R99 original app and resources, only versionCode 112. Hold private and use only if R111 fails. Never uninstall/clear data, never silently downgrade and never reissue R107/R109 as the fix.

## Deliveries
Deliver **only inside the current ChatGPT conversation** with a freshly generated exact signed APK attachment and recipient download confirmation. Do not use Gmail, email drafts, mail attachments, external providers, or copies of failing links. User has repeatedly seen `Library file not found` in Android client. Both local and Library file existence are not proof of user-accessible attachment; avoid declaring downloaded or installed before the user confirms.

Do not modify the AirPods code or Golden; R89 MOA user-device Golden untouched.
