# MOA R383 — user-uploaded R381 exact-signer forward update / R385 recovery (2026-11-12)

## Verified install failure diagnosis
- User screenshot: Android package installer `앱이 설치되지 않음` for delivered R373 update (code 373).
- User supplied actual `MOA_R381_NAVER_AUTH_NATIVE_WEBVIEW_GUARD_SIGNED_BETA.apk` bytes 8,959,120 SHA256 **`72bb23ec17856e3f41cc39b0f2556d16ea0c70dbaa7c5abaabbdb0432ce3d22f`**. Binary AndroidManifest versionCode **381**, same package `com.juhyeon.familyjournea` and original APKv2 signing cert SHA256 `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`.
- R373 code373 therefore **lower** than source R381 code381; Android version downgrade restriction is the strongest cause consistent with failure. Installer screenshot does not include an OS-specific error code, so independently proving the exact PackageManager reason is not possible. Do **not** reinstall after uninstall or clear app data.
- R381 is not equivalent to R369: original R369→R381 changed AndroidManifest, assets/web/index.html, native QuickRecord bridge JS, classes18.dex, added `moa-r379-auth-diag.js`. **DO NOT build further from R369**.
- Exact R381 `classes18.dex` bytes SHA256 `2bec268336863494d779b8196800923880b3d464367e73c17fac792266eb1463` match **exactly** GitHub CI R381 source artifact from [43192848697](https://github.com/yooogillycloud123/family-journey-personal/actions/runs/43192848697).
- R381 original `classes13.dex` SHA256 `a0485dbff1186709d970e703a37d26fe2f2e57e4ef9e2147cd594937cb2286ef` still carries original R283 official NID Android-UA login correction.

## Actual root-scoped code adjustment
- Base exact [R381 source branch](https://github.com/yooogillycloud123/family-journey-personal/tree/feature/moa-r381-native-auth-trace-safe-20261112).
- New [R383 branch](https://github.com/yooogillycloud123/family-journey-personal/tree/feature/moa-r383-r381-auth-transaction-freeze-20261112).
- R381 native provider already guards `hiddenStart()` based on `MoaR381AuthTrace.authBusy()` but `deliver()` still dispatched stored favorite tasks during login.
- R383 `MoaR365CompanionProvider.java`: when official NAVER authentication is in progress, suppresses background queued favorite delivery (no account write request), not just hidden start. Avoids parallel account work during user authentication.
- R383 `MoaR381AuthTrace.java`: original 120-second-only auth protection now remains active **while the actual live native WebView URL is official NID login**; clears if live WebView moves to map. If WebView is missing, bounded original 120-second fallback retained; protects against stale state.
- **Not modified:** R283 login method in original classes13.dex, any login credentials/cookies, NAVER challenges, NAVER writer JS, QuickRecord JS/UI, Gallery/Diary/Audio.
- GitHub Actions [43197942975](https://github.com/yooogillycloud123/family-journey-personal/actions/runs/43197942975) **SUCCESS**, R383 CI DEX 25,012 bytes SHA256 **`5a6eb742c093b26ac0f1176738d0be1191967c522ec255ea74ded729e1607987`**.

## Real signed APK R383
- File: `MOA_R383_R381_NAVER_AUTH_TRANSACTION_GUARD_SIGNED_BETA.apk`.
- **versionCode 383**, **8,932,281 bytes**, **SHA256 `6e7382f929c15c4e998945bfad12d159b85e726e5a4bc2fea825881ad23cd1ac`**.
- Exact R381 archive 143 members: **141/143 unchanged**, only AndroidManifest(versionCode) and classes18.dex differ; all previous 17 DEX including login, recorder and first-party writer untouched. No extra package or helper app.
- Independently verified Android Signature Scheme v2 RSA SHA256/content digest, original signer cert match, ZIP CRC/alignment, 18 DEX SHA1/Adler32, all unmodified member content hashes. The private key and user media remain in private local/authorized Library only; never uploaded to public GitHub or release ZIP.

## R385 emergency (forward update, exact R381 functionality)
- File `MOA_R385_FORWARD_RESTORE_EXACT_R381_FUNCTIONS_EMERGENCY.apk`, **versionCode 385**, **8,932,132 bytes**, **SHA256 `1216f35525f09d2f1107413b4ab8571fcdbbc4017f029e9ee3aaef69e3fa132c`**.
- Exact R381 functional archive members, **only manifest versionCode 381→385**. Same signer v2 verified. Intended **only if R383 has severe functionality regression**. Do not install just to test a newer version.
- Future next version must be **>385** if R385 installed.

## User installation
1. Do not install the earlier R373 (too old) or R375 (older feature fallback).
2. If currently installed MOA versionCode <=382 with same signer, tap **R383 APK** for in-place update. No uninstall, no data/cookie clearing.
3. First verify original diary, native moment recording, NAVER settings. Attempt official NAVER login **once**, personally, no sharing password/OTP/receipt answers. A persistent receipt challenge means no auth PASS; stop rather than brute-force/repeat.
4. Actual device installer verification, Naver second-factor success, logged-in session durability, and first-party list readback remain **NOT TESTED** by CI or model. If installation still blocked, collect Android package installer failure reason before trying speculative APKs.
5. R385 emergency only on severe R383 functional regression, not for login troubleshooting.

**Status: Verified source/compiler/same-signer signed R383 BETA; no physical Galaxy login success proof.**
