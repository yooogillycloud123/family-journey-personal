# MOA R531 original-signer signed gallery UX / R533 forward R463 recovery (2026-11-14)

**Status: signed APK + same-signer recovery static verification PASS; user Galaxy install/real playback NOT YET VERIFIED. R463 alone remains user-approved Golden.**

## Shipped
- Exact user-download combined ZIP: `MOA_R531_R533_MODIFIED_SIGNED_APK_RECOVERY_SOURCE_QA_20261114.zip` = **13,094,809 bytes**, SHA256 **`ce8bdd13f09059f2b65b8252e65bfc6e31ea4eb826f9c9db5fb4e02b1a5ecb91`**. Contains both installable signed APKs, full source, independently compiled `classes18.dex`, JSON QA, public-only verifier, Korean README. Conversation sandbox artifact created and exact bytes verified.
- R531 signed update APK: `MOA_R531_NATIVE_GALLERY_UX_ORIGINAL_SIGNED_TEST.apk`; package `com.juhyeon.familyjournea`, versionCode **531**, **9,050,739 B**, SHA256 **`82f81fe777146ac702a61d23f31114f1bd5d47eeb0872577194ff8b236f01daa`**.
- R533 signed forward recovery: `MOA_R533_EXACT_R463_GOLDEN_FUNCTION_FORWARD_RECOVERY.apk`, package same, versionCode **533**, **8,978,095 B**, SHA256 **`83fd4825f09e488f8c7fceda10a4590e09846070e90f53f7d6639a0ac4dba113`**.
- Both signed with exactly the user's original MOA certificate **`5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`**, private continuity checked against R39 archived key material in **private Library**. **Never publish/export private archive, key, password or derived secret**. No secret material is in the release ZIP or GitHub.
- Modified source GitHub branch `feature/moa-r531-card-gallery-ux-experiment-20261114` = baseline R527, **not** old R483. CI [43547183262](https://github.com/yooogillycloud123/family-journey-personal/actions/runs/43547183262) SUCCESS; exact Java/JS/CSS + 35,436B R531 DEX artifact.

## Exact signed APK diff / protection
R527→R531: **only 4 entries changed**: `AndroidManifest.xml` code527→531, `assets/web/moa-r483-vertical-calendar.js`, `assets/web/moa-r483-vertical-calendar.css`, `classes18.dex`. All **139 other R527 ZIP member payloads identical**, including **all 17 original native R463 DEX**; no original NAVER/Diary/media/voice editing.

R529→R533: **only** `AndroidManifest.xml` code529→533 changed; all **139 other entries identical to R529**, which was the exact R463-function rescue. This is the actual *forward* rescue for code531, not unusably lower code529.

## Implemented in R531
1. Native in-card Gallery controls default hidden. Its original media tap still owns show/hide.
2. For video in card, preserve all source frame edges (R463 FIT); use small MediaStore video thumbnail with blur as ambient background on API 31+; photos retain cover.
3. Replace Unicode up-arrow rail icon with a Canvas three-outline thumbnail glyph aligned with existing action row and preserve rail behavior.
4. Add top-right fullscreen action to open the original R463 advanced Gallery at current index, with return to day after close.
5. R527 WebMessagePort geometry push no longer filters alternating frames with 13ms gate, removes bounded 18dp overshoot in snapshot fallback, preserves independent WebView/native compositor architecture. **No guarantee of perfect 60/120fps**.

## Exact QA
- **APK v2 RSA PKCS#1 SHA256 signatures PASS** with original public certificate; signed content chunk digest independently recomputed PASS.
- ZIP CRC PASS, each uncompressed entry 4-byte aligned, DEX header SHA1/Adler32 PASS (R531 18 DEX; R533 17 DEX).
- AXML versionCode 531/533 confirmed, package original, certificate original.
- Protected R527 139-entry check PASS and R529 139-entry recovery check PASS.
- R531 JS/CSS/DEX bytes exactly match GitHub compile artifact PASS.
- **Physical Samsung install/update, media, video, Back, scroll, browser-to-native frame sync, original fullscreen function: NOT TESTED.** Do not call this Golden or device PASS.

## Install, rollback, next version
- For currently installed code <=530/same original cert: update-install R531; do NOT uninstall/reset app data or Naver login.
- If R531 serious regression: install **R533** (higher version) in place, which loses R531/R527 experimental UI and restores exact R463 Golden functions.
- If R533 installed, any next experimental candidate must use **versionCode >533**. Never substitute R529 for rollback after installing R531.
- Preserve immutable R463 Golden APK SHA256 `9d2fd10d32a3bc35eb3132333e96edd8f565abd5daf3ce954b052f77083d8379`.
- Keep AirPods Android Auto project runtime untouched.

## Exact public QA source
ZIP carries `QA/verify_moa_r531_release.py` (only certificate/public-key verification, no signer private material) and `QA/MOA_R531_R533_INDEPENDENT_RELEASE_QA.json`. For new conversation first read `MOA_READ_FIRST_NEW_CHAT.md`, R463 Golden lock, WIP current and this file before any rebuild. Do not re-analyze original assets when verified R531 source/DEX and signed APK are already present.
