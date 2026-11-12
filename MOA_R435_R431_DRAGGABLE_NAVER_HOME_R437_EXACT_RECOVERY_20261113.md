# MOA R435 — Draggable persistent NAVER WebView pink Home button / exact R431 recovery R437 (2026-11-13)

## Physical input and proven problem
- User photo `1794526850489.png` shows the native R431 pink MOA Home dot rendered over the separate NAVER PC WebView. User reports it cannot be moved.
- Exact R431 source `MoaR391SessionPersistProvider.java` sets native Home dot y to `shellHeight*0.71` on every `positionChromeControls()` (called by global layout), with a hard-coded default `x=12dp`. No drag gesture listener or persistence existed. A move was therefore not possible; this is source confirmed.
- Do not touch the existing rich native Gallery, NAVER first-party account saving, startup hidden 460ms prewarm, keepalive, chevron fold, or R431 short-tap `setHidden(true)`.

## R435 surgical changes
- Branch `feature/moa-r435-draggable-naver-home-20261113`, source `experiments/moa-r391/MoaR391SessionPersistProvider.java`.
- Add native Home dot `OnTouchListener` with actual scaled touch slop to distinguish **short tap** from **drag**. Short tap calls the original `performClick()` → `MoaNaverWebProbeController.setHidden(Activity,true)`; drag changes only FrameLayout margins in the already existing app-shell.
- Add in-memory Chrome position state so global layout updates no longer reset user's dragged location to 71% height.
- Save normalized x/y as floats in private app SharedPreferences `moa_r435_naver_home_position_v1` after drag completes, restore on new NAVER shell and after app relaunch. Position clamped within safe bounds: at least 6dp side, below safe OS top/menu zone, clear of bottom navigation/gesture area. No external network, cookie/password/GPS read.
- Leave the native circle 54dp and its original pink shape/alpha untouched, as well as chevron and its menu buttons. No permissions, no new APK packages.
- Modified supplemental DEX only; no edits to original `classes6.dex` controller/Gallery or first-party NAVER writer.

## Artifacts and static verification
- Base exact original-signer R431 APK `MOA_R431_NAVER_SAFE_TOUCH_PINK_HOME_SIGNED_BETA.apk` code431 SHA256 `88f999871908a32fbf9c55a628dcfb1287707e92d9ebb89f11ac1e2d4d687907`.
- Android SDK35 javac+D8 [GitHub CI run 43331481423](https://github.com/yooogillycloud123/family-journey-personal/actions/runs/43331481423) **SUCCESS**. R435 compiled `classes17.dex` size 42020 bytes SHA256 `7ae4f8de8109d3bde08a33057f4ae3792a26e7383dfe76718e5921816374d2cd`.
- R435 original-signer `MOA_R435_DRAGGABLE_NAVER_PINK_HOME_SIGNED_BETA.apk` code435 size 8,943,793B SHA256 **`e36e55b823d9d8aa1650c05fb8314b5773df7b00287dab2e102440eea51f910c`**.
- Out of R431 140 archive entry contents, **138/140 unchanged** (only Manifest versionCode 431→435 and classes17.dex changed). Original 16 DEX, original Gallery classes6.dex, `fj-naver-favorites.js`, `moa-r389-home-dot.js`, theme assets, user data and login handling preserved.
- Both APK Signature Scheme v2 RSA signature **plus full signed content SHA256 digest** independently verified PASS. ZIP CRC, stored 4-byte alignment and all 17 DEX SHA1/Adler32 PASS. Original cert SHA256 `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15` matches.
- R437 `MOA_R437_EXACT_R431_FUNCTIONS_FORWARD_RECOVERY.apk` code437 size 8,940,570B SHA256 **`d83c6d7aa63d09d103fe401ef48ea80bbb031bb3778ec65dd885f57d950a04c0`**. Exact original R431 functional archive content except Manifest versionCode: **139/140 identical entries**. Severe regression emergency only. Next code after R437 >437.
- Full ZIP `MOA_R435_HOME_DRAG_R437_R431_RECOVERY_QA.zip` SHA256 **`0b23353279d7bf87bc66ff5794458a3c6e1f6957b993d6f3f3a74ceb35e9a578`**, 12,924,111B. Contains two signed APKs, Java source and diff, JSON QA, README. No private signer/keystore/password, photos/videos, cookies or personal data.
- PRIVATE Library `/모아_프로젝트_근거_20261103/R435_DRAGGABLE_NAVER_HOME_20261113/` holds both APKs, full ZIP, source and QA. R431 original and prior Goldens untouched. AirPods Android Auto untouched.

## Test truth and next steps
- Static compile, package unchanged contracts, v2 crypto/ZIP/DEX: PASS.
- User Galaxy: draggable button, persisted position across NAVER window restart, tap-to-hide, account offscreen save and advanced gallery **NOT YET PHYSICALLY VERIFIED**. Do not label R435 Golden without evidence.
- Update in place over original-signer code<=434, never uninstall/clear data/cache/cookies. Try drag release, close/open map and check position, short tap hides without losing session, verify offscreen favorite write and high-fidelity Gallery.
- If serious regression only, install R437 in place to return to exact R431 functions; R437 does NOT include drag feature.
