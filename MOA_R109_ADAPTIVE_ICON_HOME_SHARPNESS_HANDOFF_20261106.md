# MOA R109 Adaptive Launcher Icon Repair — 2026-11-06

## User-observed failure
On Galaxy S26 Ultra, MOA R107 icon in Samsung One UI home and app drawer was extremely pixelated/blurred, although the same package's 512×512 source PNGs look sharp when examined as files. User supplied a ChatGPT Android split-APKs archive as a reference and screenshots. Do not use or redistribute ChatGPT copyrighted source artwork; compare Android packaging structure only.

## Evidence
The supplied ChatGPT base APK has `res/mipmap-anydpi-v26/ic_launcher.xml` adaptive icon and density-specific legacy launcher WebP assets in mdpi/hdpi/xhdpi/xxhdpi/xxxhdpi. R107's nine MOA activity-alias icons were direct 512×512 bitmap PNGs stored under `res/mipmap-anydpi-v26/`, without the required adaptive XML layers for those aliases. Android developer's adaptive-icon specification recommends a foreground/background layer with the device-controlled shape mask. Direct PNG-based aliases are a plausible source of the One UI low-resolution launcher rendering, but **device root-cause is not conclusively proven until R109 is installed and observed.**

## R109 signed artifact
- Artifact: `MOA_R109_ADAPTIVE_ICON_HOME_SHARPNESS_BETA_Install.apk`
- Package `com.juhyeon.familyjournea`, versionCode 109, versionName R109
- Bytes: 5,486,325
- SHA256: `e32c0036a5f177c14f84f50404233247c29a0f798259f59201f50406583e8d5c`
- Existing signing cert SHA256: `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`
- Base: R107, signed user-installable bytes SHA256 `672d411796a94964ef58bf4b3f8b0a464c6d41bc61ab33447a7f134b3ab08f89`
- 9 existing alias resource IDs preserved, corresponding PNG resource-table paths now `.xml` with Android `<adaptive-icon>` and correct framework drawable attribute IDs. New resource IDs `0x7f04000a..0x7f04001b` are 9 foreground and 9 background raster layers, each 768×768 RGBA and properly mapped in `resources.arsc`.
- The renderer was rebuilt as background gradients + high-resolution extracted MOA glyph layers. No cropped poster shadows or manually baked launcher rounded-corner mask. System mask is responsible for actual icon outline.
- R107 DEX classes 1–5 and all old APK members except `resources.arsc` and `AndroidManifest.xml` are byte-identical to R107, including full diary/photo/voice/calendar/JS/IndexedDB functionality. Original 9 PNG archive members retained as unreferenced legacy artifacts; no application data wiped.
- VersionCode advanced to 109; emergency rollback-forward 110 separately available privately (not routine install).

## Verification
- **INDEPENDENT PASS**: RSA/PKCS1 SHA256 APK v2 signature, certificate matching original, APK v2 content digest recomputation, ZIP CRC, stored-entry 4-byte alignment, unmodified legacy members, all 9 alias icon IDs resolve to compiled adaptive XML and 18 correct layer references.
- **NOT TESTED**: Android PackageManager actual installation, Samsung One UI launcher refresh, actual device icon sharpness, runtime icon switching. Do not call this Golden or physical PASS.
- This is a beta. Never uninstall existing MOA or clear app data. If install fails, collect phone on-device ADB exact `pm install -r` error; do not guess.
- **DELIVERY**: User forbids Gmail/email; deliver APK only as direct fresh attachment in the current ChatGPT conversation. Record in-chat download success only after user confirms.
