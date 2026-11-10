# MOA R293 — Galaxy R289 offscreen QUEUED forensic and fail-closed path diagnostic (2026-11-11)

## Source of truth / privacy
- User supplied **private** Galaxy recordings `20209.mp4` (113.4s), `20210.mp4` (117.5s). DO NOT upload any frames/videos/account labels, GPS coordinates, memos, login info or receipts to GitHub or public QA ZIP.
- Full-resolution view confirms **offscreen experiment checkbox ON** before diary action in 20210; previous compressed-contact-sheet impression that it was OFF was **wrong and retracted**.
- 20209 diary place card visibly shows **요청 대기 (QUEUED)** for a web task. The 20210 later **3-minute NAVER timeout** is wording of the pre-existing *foreground accessibility/native* reporter (`fj-naver-favorites.js` `TIMEOUT`), which may be a delayed independent prior task. Its presence alone cannot prove the hidden-web writer failed at that exact moment. DO NOT conflate task identities.
- User confirms existing visible NAVER save and NAVER signed-in session works, while hidden automatic write has no verified account result. No new user secrets are needed for these code changes.

## Code-proven R289 defect
- Actual R289 `MoaNaverPhoneWorker.submit()` checks **only that `MoaNaverWebProbeController.browserForPhone()!=null`** before setting `state=QUEUED` and answering `QUEUED_IN_MOA_PHONE`.
- The asynchronous UI-handler `lambda$deliver$0` unconditionally did `WebView.evaluateJavascript("window.postMessage({type:'MOA_R237_PHONE_TASK',task:…},window.location.origin)")`, with **no current top-page origin check and no reception acknowledgment**.
- The actual document-start listener for the web task exists only for top `https://map.naver.com`; if the live WebView is at NAVER home, login, or other page, QUEUED can be returned even though the intended map command listener does not exist. **This is confirmed source design flaw, not confirmation that the phone actually was on such a page at the failure instant.** The exact underlying location/frame stage for the user run still requires a non-sensitive runtime state in the next beta.
- An opt-in checkbox in Settings selected the hidden engine through storage; Diary kept a single ambiguous button, while native foreground status could update the same card. These are also confirmed UX/diagnostic ambiguities.

## Exact R293 code changes (original R289 same signer baseline)
1. `classes14.dex` **ONLY** native method `MoaNaverPhoneWorker.lambda$deliver$0` changed: on Android UI thread call `WebView.getUrl()`, require current URL prefix `https://map.naver.com/` before injecting any account task, otherwise set `NAVER_PAGE_NOT_READY` and do not inject. App preserves original first-party URL/consented credentials and never reads tokens or cookies.
2. `assets/r28-diary-location.js`: same fields, **two explicit user actions**, `비점유 저장 실험` (mode=web) and `기존 네이버 저장` (mode=native). Button mode is passed as a method argument, not read from an unrelated Settings WebView storage realm, so a tap cannot silently fall back to foreground.
3. `assets/web/fj-naver-favorites.js`: extends `saveFromDiaryGps` and `sendPreparedLocation` with optional explicit route, retains all existing default calls and original foreground logic; displays [비점유]/[기존 전경] feedback; `NAVER_PAGE_NOT_READY` status rendered and terminal; **QUEUED for 8 polls ≈16 seconds without a first-party frame status** fails with `WEB_NO_FRAME_ACK`, never falsely saved.
4. Binary `AndroidManifest.xml`: versionCode289→293 only. All other APK entries including R283 official-login UA fix and 15 untouched DEX remain byte-identical.

## Signed QA / test limits
- Private-only original cert SHA256 `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`, package `com.juhyeon.familyjournea`.
- **R293**: `MOA_R293_OFFSCREEN_ROUTE_GUARD_DIAG_BETA.apk` 8,907,764 bytes SHA256 `da2ce84c0bbc882b6ebeb0a401bdac1ee2eb9c65830b3a2999b16efedd2b3fd3`.
- **R295 forward recovery**: `MOA_R295_RESTORE_R289_FEATURES.apk`, code295, same cert, 8,907,764 bytes SHA256 `ef950657b016d6fa998cffe9d8b6ba1882ee1611edb4a40081fcc3d51462d6d3`, differs from R289 only by manifest code; **not byte-exact R269 Golden, not Galaxy-tested rollback**.
- User ZIP `MOA_R293_EXACT_ROUTE_DIAGNOSTIC_WITH_R295_RECOVERY_20261111.zip`, SHA256 `cf798031a932deb5a1f55c889390065e2306954835b9010255b0fe2958e59ab3`, 12,882,508 bytes. ZIP includes bit-identical R293+R295, QA JSON, Korean guide and **sanitized code diff only**, NOT keys, user media, NAVER login data or passwords.
- Local Apktool2.12.1 build PASS, ApkSigner v2 cert match/zipalign/ZIPCRC/16 DEX integrity/manifest code/JS parse PASS. Existing 5 synthetic NAVER UI safety cases + new explicit 2-button route and native page-preflight source test PASS. **No actual Galaxy R293 execution, hidden full session save, account persistence, alias/memo/folder independent readback PASS yet.**
- Difference R289→R293 non-signature payloads EXACTLY `AndroidManifest.xml`, `classes14.dex`, `assets/web/fj-naver-favorites.js`, `assets/r28-diary-location.js`.

## Required user-side test if accepted
- Update-install R293 only; no uninstall, data wipe or signer change. Open existing same-app NAVER map via visible connection, navigate to actual `map.naver.com/p/` location, press `모아 화면 유지(연구)`. Then diary photo GPS → explicit **비점유 저장 실험** only once.
- Observe the [비점유] feedback code: `NAVER_PAGE_NOT_READY` (not a map root), `WEB_NO_FRAME_ACK` (frame listener did not ACK), `PLACE_AMBIGUOUS` (multiple exact candidates), `NAVER_UI_CHANGED` (selector mismatch), or `SAVE_SUBMITTED_UNVERIFIED` (UI click attempted, server write unverified). This disambiguates new work from old native 3-minute timeout.
- If page is wrong, do not repeat automatically. If UI save appears, **independently read back** exact NAVER account list/place/alias/memo before confirmation.
- Current user-designated immutable R269 Golden code269 SHA256 `c0663e65aac2b72feb86cb0f1ba5eac448b6599c3850858de4d942f2aa446920` is untouched, as are all AA AirPods/Android Auto routing sources.
