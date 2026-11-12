# MOA R373 — exact uploaded R369 signed update and R375 emergency recovery (2026-11-12)

## Scope and priority
- User provided actual `MOA_R369_CAPTURE_LIST_HIDDEN_RETRY_BETA.apk` (8,949,141 bytes, SHA256 `243bc7c2e6de1c87ceb4a22050589b13f414b8085174c244e1e4c1396be5eb14`) + exact matching `MOA_R369_EXTRA_DEX_FINAL.zip` (SHA256 `ce7ac6db7a3425a1887ba14818878be641579989a1f7e028b4f97df569d2544d`), R371 emergency (SHA256 `5ed6a361ca9903c1ab9c01c924c36e582416f7cdec0e92ac650f8f03c6f51641`), JS, QA, sha manifests.
- R369 real bytes exactly match recorded known latest. User-reported history: R275/R279 NAVER receipt challenge blocked login; R283 UA restoration allowed 2FA + verified login; login persisted over upgrades until R365; post-R365 logout brought receipt challenge back.
- R369 **still contains EXACT R283 login-related `classes13.dex`** SHA256 `a0485dbff1186709d970e703a37d26fe2f2e57e4ef9e2147cd594937cb2286ef` with `setUserAgentString` / NID strings. It is incorrect to claim old successful login class disappeared.
- R369 native additive `classes18.dex` re-prewarms hidden Naver session every 3 seconds and can deliver pending tasks. This is a **potential** authentication-interference risk; sudden logout cause and Naver server receipt challenge cause **NOT PROVEN**.

## New signed R373
- **File**: `MOA_R373_NAVER_AUTH_SESSION_PRESERVATION_BETA.apk`, **8,922,848 bytes**, **SHA256 `e26604c45d337cc88170df69f037675dfde5c23cd007924442ec1473aa7fd149`**.
- **package** `com.juhyeon.familyjournea`, **versionCode 373**, **original signing certificate SHA256 `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`**.
- **Exact APK payload delta R369→R373**: only **`AndroidManifest.xml`** (versionCode369→373) and **`classes18.dex`** (R373 official login guard) changed. **Other 140/142 APK archive members byte-content-identical**, including all **17 existing DEX**, current native recorder, home/diary/gallery and exact original JS NAVER writer/frame and per-media QuickRecord R369 JS.
- New `classes18.dex` 16,952 bytes SHA256 **`c6b414bf72fabca8e037979f27e5e8704b30ddea5b770d05729e14fc2e90e150`**. Source branch `feature/moa-r373-naver-auth-preservation-20261112`, CI [43189444467](https://github.com/yooogillycloud123/family-journey-personal/actions/runs/43189444467) **SUCCESS**. Login page guard tests PASS.
- Implementation: companion native provider checks `WebView.getUrl()` exact official HTTPS NAVER authentication domains inside active Host View hierarchy. When present, **pause** hidden WebView bootstrap, JS task delivery and monitor activation until official first-party auth page leaves. No CAPTCHA bypass, cookie management, login DOM handling, credential capture, new WebView, or edit to R283 original login DEX.
- **Independent final package tests**: parse/cryptographically verify Android APK Signature Scheme v2 RSA-PKCS1-SHA256 (including APK contents digest and certificate SPKI); ZIP CRC; package original certificate; all **18 DEX header SHA1+Adler32**, all stored ZIP payload data 4-byte alignment; original 140 members content hash preserved. No personal signing keys included in deliverables. These tests are STATIC: not Android package manager / Galaxy authenticated login checks.

## Higher-version emergency forward recovery
- **R375** `MOA_R375_FORWARD_RESTORE_EXACT_R355_FUNCTIONS_EMERGENCY.apk`, 8,880,094 bytes, **SHA256 `5eeea6712d169d3500bcd7f36e44b82e57c265bcf4879c3e1d075d89a715e634`**; original signer as R369.
- Exact R371 R355 functional contents with **only Manifest versionCode 371→375 changed**, v2 signature, all 16 DEX+ZIP valid. Emergency **only if R373 causes serious UI/Diary regression**; loses R357–R369 enhancements, NOT a routine version upgrade. Never uninstall or clear data.
- Full release package `MOA_R373_APK_R375_EMERGENCY_QA_20261112.zip`, **12,857,643 bytes**, SHA256 **`2a6649bb8412fb7f6faf7d9cc4509fd277443482d0c2dd301b35f5b9eda943ca`**. Contains both signed APKs, standalone QA JSON, Korean instructions, SHA manifest. Exact release ZIP verified current container.
- Both original signed APK and original private signing material loaded from user authorized local/Library storage only. **Signer/password/keystore must NEVER be committed or uploaded to GitHub**.

## User installation and device gate
1. **Install R373 only as in-place update** if currently installed versionCode is <=372 and package+signing certificate match. Existing app data, NAVER login cookies and all personal records must NOT be wiped. Do not uninstall/clear cookies.
2. Check native moment recorder, gallery, diary first. On official NAVER login try **once** with user's own phone, no sharing password/OTP/challenge response. If receipt challenge persists, STOP repeated attempts. The actual reason could be outside the new companion provider.
3. After login + second authentication success, verify same NAVER list/account readback and then only one offscreen save task. No PASS claim until physical confirmation.
4. If R373 has serious regression, optionally install separately prepared **R375 emergency** (loss of added features) in place, no data wipe. Future code >375.

**STATUS: REAL SIGNED INSTALLABLE R373 BETA, STATIC CRYPTO/ZIP/DEX PASS, DEVICE LOGIN AND LOGOUT-CAUSE UNVERIFIED.**
