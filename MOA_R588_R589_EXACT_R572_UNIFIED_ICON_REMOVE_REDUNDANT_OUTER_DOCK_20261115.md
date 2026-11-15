# MOA R588 / R589 — user screenshot 22116.png: retain unified R572 eight icons, remove ONLY extra full-width outer dark dock

**2026-11-15 KST. User R586 on-phone screenshot shows unwanted DARK rectangular full-width frame around existing eight-icon OVAL capsule. R586 = exact R572 functionality, not visually corrected.**

## Grounded source diagnosis
1. R572 **added** a separate 40dp dark footer behind the eight-action oval in `experiments/moa-r507/MoaR507InlineGalleryProvider.java` `compactNativeCard()`:
   `GradientDrawable footer=new GradientDrawable();footer.setColor(0xf61c1d23);` and `footer.setStroke(dp(a,.45f),0x775c5d66);deck.setBackground(footer);`.
   This produces precisely the duplicate outer full-width background/stroke in screenshot `22116.png`. Existing oval remains `GradientDrawable bg ... bg.setCornerRadius(dp(a,19)); ... capsule.setBackground(bg);`.
2. R574 source removed the extra rectangular footer with `deck.setBackgroundColor(Color.TRANSPARENT)` while preserving the eight existing child views; handoff for R574 explicitly documents the **wide gray bar removal as user-confirmed working**. However, R574 also changed QuickRecord/Gallery source and **physically FAILED**; importing its whole source or APK would regress the user's gallery.
3. Latest user correction: **"이거 아이콘 크기나 아이콘 감싼 타원형테두리 말고 또 테두리 있어 ... 이거 아니자나"**. Therefore precisely apply the R574 footer one-liner to immutable source R572, NOT R574 gallery.

## R588 ONLY minimal fix, signed in place
- New source branch: [feature/moa-r588-r572-only-remove-outer-dock-background-20261115](https://github.com/yooogillycloud123/family-journey-personal/tree/feature/moa-r588-r572-only-remove-outer-dock-background-20261115), based directly on `feature/moa-r572-r570-compact-dock-rail-flash-fast-toast-20261114`.
- Only **one Java code area** changed, inside `compactNativeCard()`. Replace the separate full-width `footer` drawable/stroke with `deck.setBackgroundColor(Color.TRANSPARENT);`. Retain the original oval `capsule.setBackground(bg)`, eight icons/ordering, R572 photo/video rail positions (photo 112dp vs video 137dp), fast preference and Naver-toast expiry, original photo-form JS/CSS/Naver/diary/Gallery, Back/Recents/MediaStore.
- **Install APK** `MOA_R588_R572_UNIFIED_ICONS_ONLY_REMOVE_EXTRA_DOCK_ORIGINAL_SIGNED_BETA.apk`, versionCode **588**, 9,084,721 B, SHA256 **`c0946c8b5f4af0213c484dd47627f56f682fec7433ddfbfbe11a60c826722258`**. R572 APK base SHA256 `a5eeff113022894afa2f72fb4d149e8ee4c1269dabf8c78d16fca28e5ece10ab`; only APK member changes `AndroidManifest.xml` (code572->588) and compiled independent `classes18.dex` (the single footer fix), **142/144 R572 ZIP member contents byte-identical**, including all first 17 DEX and all JS/CSS.
- **Emergency original R572 functional restore** `MOA_R589_EXACT_R572_FUNCTION_EMERGENCY_ORIGINAL_SIGNED.apk`, code **589**, 9,084,761 B, SHA256 **`ea013f95009f42175e2e26c0eb392658dc4336379c2206746b1a68feed59bd64`**, 143/144 members identical to R572 except Manifest. **Reintroduces unwanted outer dark footer**; emergency only if new build regresses.
- Package `com.juhyeon.familyjournea`, same original signer SHA256 `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`, both APKv2 RSA full signed-content digest, Manifest/version, ZIP CRC, 18 DEX checksum/alignment verified.
- [GitHub Android SDK35 Java/D8/JS CI run 43655917760 SUCCESS](https://github.com/yooogillycloud123/family-journey-personal/actions/runs/43655917760). New independent DEX `classes18.dex` **61,800 B**, SHA256 **`1c0519dcabba3901f8eca88761f600d1822f81fcb114f6476e3816e717de68d0`**. Source contract expressly verifies exterior footer/stroke removed and original oval kept.
- Source/QA/release ZIP `MOA_R588_R589_R572_8ICON_OUTER_DOCK_REMOVE_SIGNED_QA_20261115.zip`, 19,736,751 B SHA256 **`8ff13285e0fe071eeba66f862d17ed83794fd270ed7b83b51861b227b7a9aa11`**, 8 members CRC + listed SHA checks PASS, contains both newly signed APKs, original R572 read-only, precise text source diff, DEX CI artifact and QA. Excludes private keys, passwords, account tokens and personal photos. Archived in private Library `/모아_프로젝트_근거_20261103/R588_R589_R572_OUTER_DOCK_ONLY_20261115/`.

## Installation and success limitations
- Update-install **R588 directly over existing R586 or R587**, same signer and package, preserving existing app data, photos, diary, NAVER cookies, external services and saved settings. Do NOT uninstall or clear cache/data.
- **R588 on actual Galaxy NOT YET TESTED**. Static code change proves full-width footer removed in the implementation, but user phone visual result awaits confirmation. Do not call this visually verified.
- R572/R588 historical QuickRecord→photo-form gallery failure has not been claimed fixed. This rollback is explicitly the user's requested **VISUAL ONLY** fix, not another destructive attempt to rewrite gallery.
- R589 is emergency if R588 experiences serious regression; it restores exact R572 functional content INCLUDING undesired dark footer. After R589 future update versionCode >=590.
- R567 stays untouched immutable user-approved Golden. AA AirPods app, shell daemon and Android Auto untouched.
