# MOA R313 — original-signer Android APK, address-first existing-list offscreen beta (2026-11-11)

## Real completed work
- User provided R307 same-original-signer APK `MOA_R307_RESTORE_R301_NO_CREATE_SAME_SIGNER.apk` SHA256 `7306765f6d780d48ea35eee1648ec817cffb4ff9ec7792e40bce6e6d687c844d`, code307. Its 16 DEX and genuine asset payloads were extracted and inspected. Actual R309 signed APK was **not present** in current Library/sandbox.
- Original signer was **recovered from private user Library** `/모아_프로젝트_근거_20261103/PRIVATE_SIGNERS` and RSA private key matches the original **certificate** SHA256 `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`. Never republish signing archive/secret.
- **Signed R313 Beta** `MOA_R313_ADDRESS_FIRST_EXISTING_LIST_OFFSCREEN_VERIFY_BETA.apk`: versionCode313, 8,906,089 bytes, SHA256 `eb0768cdb2c8f22ae315081710a83ce53996b002b9a2d214cfe3946d76e033e1`. Original package `com.juhyeon.familyjournea` and original cert RSA-PKCS1v15 SHA256 APKv2 full-content digest VERIFIED. Independent v2 inspection was first validated against uploaded R307's actual v2 signing block and signed digest. All 16 DEX **uncompressed content byte-identical**, all other resources frozen.
- R307→R313 changed only **exactly 3** uncompressed ZIP entries: binary AndroidManifest.xml versionCode307→313 and `assets/web/moa-r231-naver-frame-probe.js`, `assets/web/fj-naver-favorites.js`. ZIP CRC, stored-member alignment and 18 Node source contract/simulated DOM tests PASS.
- **Same-signer R315 recovery** `MOA_R315_R307_FEATURES_FORWARD_RECOVERY_SAME_SIGNER.apk`: versionCode315, 8,904,511 bytes, SHA256 `65a265d3f05b705a9a8232f447f083401fa29c3091a922b38141c8f4e7c532b9`. R307→R315 only binary Manifest version change, all 16 DEX and all JavaScript/resources identical. **Phone recovery NOT tested**.
- Paired exact-binary ZIP `MOA_R313_SIGNED_APK_AND_R315_RECOVERY_QA_20261111.zip` SHA256 `0bc8a8a42054a1a3bbde4557d5e303c6263f10db9396e0bc22f7d287463b5910`, 12,918,874 bytes, includes both APKs, both changed JavaScript sources, test source/TAP, JSON QA, hashes, Korean README; ZIP CRC and member hashes checked.

## Function & boundaries
- Original photo GPS/reverse-geocoded exact street address **FIRST**, separate exact place ID selection, sessionStorage job across same-origin navigation (90-second TTL).
- Existing named lists cannot be guessed: explicit `MOA 기존 리스트 연결` in first-party visible NAVER PC browser once, based on actual `shareId` (and count suffix for user distinction only), revalidate ID on every save. No list creation/deletion or auto-picking by title/count, particularly user's duplicate-name original 185-place `내 장소`.
- Place-specific save star only if unsaved; unique folder ID in Save sheet must match pinned ID; alias and original memo input verified, one commit attempt with no automatic uncertainty retry; independently first-party READ verify exact targetId+folderId+alias+memo.
- New single-tap transition after WebView hide confirmation; no need for extra second tap; prior 50-character web memo block removed to match original 400-character MOA cap without silent cut.
- Foreground native Accessibility NAVER saver and R269 immutable Golden / gallery / diary / voice / GPS all preserved by identical DEX and all original other resource data.
- Exact R313 JavaScript source and 18 tests are only in the **local signed QA ZIP** shared in the conversation. Earlier GitHub `feature/moa-r309-existing-list-transaction-safety-20261111` is a separate **source-only standalone module**, NOT the signed R313 embedded JS. Never pretend it is byte-identical or merged.

## Honest unresolved gates
- Actual Galaxy R313 install/boot/physical screen-free WebView interaction untested.
- First-party NAVER `pages.map.naver.com` iframe loading and read-only folder API, actual map PC DOM selectors and Save modal folderId attributes, synthetic WebView click trustedness, NAVER user-account save and independent server readback **UNTESTED**.
- No test in this environment can impersonate the user's logged-in NAVER account. FAIL CLOSED, no fake success; R313 remains **SIGNED BETA / NOT FINAL / NOT GOLDEN**.
- Do not claim device success from Node tests, or reintroduce first-party unverifiable writes, auto list creation, browser CAPTCHA bypass.
- Existing Library `R309_20261111` folder remains empty; subsequent exact R313 release ZIP upload was attempted but failed `library_storage_limit_exceeded`; **DO NOT claim persistent Library archived APK**. Files available as current conversation outputs. Do not delete user backups to make quota.
- No uninstall or app data clear, no user-visible extra helper app. R315 is a higher-version recovery for the same package, only if needed; user installation consent required.

## Next verifiable engineering step
Retrieve the R313 exact user-attached APK/ZIP or preserve it outside limited Library. Run phone safe update install only if current code<313. In the existing MOA Settings open first-party NAVER PC WebView *visible* for one-time account login and **explicit original folder shareId click**. Then hide; one photo GPS tap should attempt search/entry/star/list/alias/memo/readback. Only real in-account readback can close completion. If it fails, collect exact **stage**, not private cookies, photos or folder IDs, and patch that one source/DEX boundary. Do not generate more arbitrary APKs before that.
