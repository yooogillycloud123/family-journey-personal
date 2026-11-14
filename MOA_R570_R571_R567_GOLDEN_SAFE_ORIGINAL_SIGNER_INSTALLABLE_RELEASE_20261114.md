# MOA R570 original-signer signed APK + R571 exact R567 Golden forward recovery — 2026-11-14

## CURRENT STATUS
- **R567 remains user Galaxy-verified and approved immutable GOLDEN.**
- **R570 is a signed, installable BETA candidate; Galaxy R570 PHYSICAL FUNCTION NOT TESTED**. Do not promote to golden based on source/CI only.
- Previous R570 source-only handoff's assertion of "signer unavailable" was inaccurate. We located prior **private user Library R39 signing continuity** and locally cryptographically verified private key/public key/certificate against R567 APK signer. **No private key, password, or PKCS12 uploaded to GitHub or included in shared ZIP.**
- **R571** is an independently signed higher-version **EXACT R567 functional recovery**, unlike older R569, which recovers R463.
- No MOA uninstall, app-data/DB/cookie reset. Same package & original cert; update install only.

## Signed artifacts, reproducible public verification
1. R570 `MOA_R570_R567_GOLDEN_SAFE_PHOTO_FAVORITES_REORDER_ORIGINAL_SIGNED_BETA.apk` 9,082,624 bytes; **SHA-256 `93ba81abe4d3d44e782bff361598bd070b73de2fe73754c58312a85f0ce01cf5`**, `versionCode=570`, `com.juhyeon.familyjournea`.
2. R571 `MOA_R571_EXACT_R567_GOLDEN_FORWARD_RECOVERY_ORIGINAL_SIGNED.apk` 9,069,599 bytes; **SHA-256 `a3a7bac43d93f277b03f3af95f29f5a752e4730cee87d87530c6f1c952c9a672`**, `versionCode=571`. Identical to R567 functional payload except AndroidManifest.xml versionCode; **142 of 143 original APK members byte-for-byte unchanged**; exact 17 native R463 DEX plus user approved classes18.dex from R567.
3. Original R567 protected Golden exact SHA **`f205afb72744391ce9f2594f898728699870be006f787c712599a1ee8492e93c`** unchanged.
4. Combined private chat+Library ZIP `MOA_R570_R571_SAME_SIGNER_INSTALL_RECOVERY_SOURCE_QA_20261114.zip` 26,318,233 bytes, SHA256 **`7095e6101c92460bb0b4cb297aaad7adef6cff522aacb62aacaec6694210bb66`**, contains R570 signed APK, R571 signed recovery APK, exact Golden R567 APK, source+CI+QA ZIP, independent APK sign/asset checks, SHA256SUMS, Korean README. ZIP CRC and all six member SHA-256 PASS. Secret signer excluded.
5. Signing cert both SHA-256 **`5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`**, **exact identical** to the installed R567 lineage; verified RSA signature (algorithm 0x0103), APK Signature Scheme v2 signer-list nested LP, **full APK section content digest**, ZIP CRC, original stored 4-byte alignment, DEX SHA1+Adler32. Android real PackageManager installation test still pending.

## Exact R567 source diff gate
- R570 modifies only five original APK members: `AndroidManifest.xml` (code570), `classes18.dex` (additive native in-card only), `assets/web/index.html` (script loader), `assets/web/moa-r483-vertical-calendar.js`, `assets/web/moa-r483-vertical-calendar.css`; adds **one** new `assets/web/moa-r570-photo-favorites.js`. **Original R567 138/143 APK members byte-identical.**
- All original native `classes.dex` through `classes17.dex` = byte-identical. `assets/web/fj-naver-favorites.js`, original NAVER WebView/writer, diary, voice/STT/M4A, original gallery/rail/player unchanged.
- R570 compiled CI [43600045810](https://github.com/yooogillycloud123/family-journey-personal/actions/runs/43600045810) SUCCESS, `classes18.dex` size 60,196 bytes, SHA-256 **`1701f287d6efe30d6aba3da11927a34e7d7b6d779cbbddf849867b757b312dec`**.
- R570 JS syntax plus six mock contracts including GPS missing/invalid, selected photo changes, duplicate and cross-mode requests, actual Naver first-party call, callback bridge PASS.
- Source: [R570 feature branch](https://github.com/yooogillycloud123/family-journey-personal/tree/feature/moa-r570-r567-entry-photo-favorites-reorder-safe-20261114). Golden [R567](https://github.com/yooogillycloud123/family-journey-personal/tree/golden/moa-r567-user-device-pass-20261114) UNTOUCHED.

## New user features (BETA, device QA required)
- Photo/video opening: remove only R567 supplemental asynchronous VIDEO blurred ambient thumbnail; keep native original player/TextureView; suppress a duplicate web blur during entry. **No physical claim that all black flash/blur vibration is gone.**
- Photo-card new bookmark symbol: native dialog alias / memo / Naver target list and separate **비점유 저장 / 기존 저장**, calls existing first-party `NativeHost.post('diaryMediaLocation')` then `FamilyJourneyNaver.saveFromDiaryGps(...,{mode:'web'|'native'})`. No new Naver API, authentication, cookie or separate saving engine. Native verifies current photo ID and fails closed when stale or GPS missing. Request accepted ≠ remotely confirmed account save.
- Photo-card buttons scale normalization and long-press selectable left/right reordering, role IDs `cover/share/naver/info/fast/favorite/rail/expand`; keeps original View and OnClick listeners, stores full valid role permutation in photo-only preference. **Advanced full-screen gallery unmodified.**
- Do not expand to further media modes or overwrite existing UI without physical test.

## Install guidance
- Install **R570 only** over existing R567 or earlier same-certificate app, without uninstall or clearing data.
- Test photo-entry flashes, video/seek/capture/mute, Native Back after Home/Recents, photo-card favorites vs original diary detailed favorites in both modes, GPS missing, reordering left/right each action and persistence; test existing offscreen Naver login/session/list and three themes.
- If any serious regression, **R571 ONLY as emergency in-place recovery**. It restores EXACT R567 functional payload. Once R571 installed, subsequent update versionCode **>=572**.
- Do not install older R569 (R463-function rollback) as R567 recovery.
- Never publish private PKCS12 or signing archive; personal Library `PRIVATE_SIGNERS` remains private.

## Latest precedence
Older handoff `MOA_R570_R567_GOLDEN_PROTECTED_ENTRY_FAVORITES_REORDER_SOURCE_CI_SIGNER_BLOCK_20261114.md` is **historical**: it correctly described source-only status at that time but the signer blocker was subsequently solved by private Library materialization and verified signature. This new signed-release handoff supersedes that blocker. **R570 Galaxy PASS is NOT asserted.**
