# MOA R341 — R337 'no visible change' root cause repair, original-signer installable beta (2026-11-11)

## Origin and user-reported failure
User reports R337 had no observable change, despite provision of actual working Windows Naver Playwright Python source and native Naver Maps 6.7.2.1 split APKs. This is a real failure of the delivery gate: signed APK was not enough; actual user-facing save entrypoint was unchanged. **Do not claim NAVER real-account write PASS.**

## New evidence directly inspected, all private
- User-provided exact R337 APK: SHA256 `c4f3ed66e48e50d355adf4e16971671d6510f7674eb94413770af77b6adc9bc9`, original same-package signed versionCode337.
- User-provided exact R339 backup APK; original PC zip `네이버지도_자동등록_20261025_수정판.zip` 1,218 entries, `소스코드/naver_browser.py`, `matching.py`, `runner.py`, tests, real original Windows EXE (NOT EXECUTED).
- Naver native split zip manifest: `com.nhn.android.nmap` version `6.7.2.1`, versionCode60702000, base + arm64 + xxhdpi. Does NOT by itself give the MOA WebView a Naver login session or SDK for writes.
- Existing user-delivered R329 and R325 ZIPs preserved; original MOA R39 private signer was recovered via private Library (CERT SHA256 `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`), not published.

## Code-level confirmed failures in R337
1. **Missing actual default entrypoint integration**. Existing `assets/web/fj-naver-favorites.js` GPS card button `네이버 즐겨찾기 저장` called `startNativeSave(p,input,memoBox)`, which in `sendPreparedLocation` defaulted to `NativeHost.post('naverArm')` and only selected the new PC writer for `route==='web'` OR localStorage `moa.naver.offscreen.try.v1==='on'`. Therefore R337 web writer could be entirely bypassed when tapping the pre-existing normal UI.
2. Existing `assets/web/moa-r231-settings.js` literally executed `localStorage.removeItem('moa.naver.offscreen.try.v1')` during Settings mounting. This erased the opt-in in that storage realm.
3. R333 writer in `assets/web/moa-r231-naver-frame-probe.js` sent child status to `window.parent`, accepted only direct iframe `e.source` in the root, and broadcast commands to root's direct iframe list. Real PC source uses nested `#entryIframe`, `pages.map.naver.com/save-pages/`, and `#myPlaceBookmarkFolderListIframe`; nested grandchild status/commands could fail with no further action.
4. The writer exited immediately at document start when `window.MoaNaverProbeBridge` had not yet been initialized, rather than retrying. A race was possible.
5. Prior ACK/readback guard (R337) existed, but was not relevant if feature entrypoint never invoked.

## Exact R341 changes
- On GPS place card, visibly separate **`PC 웹 자동저장`** (explicit `web` mode) from **`기존 네이버앱 저장`** (explicit `native` mode).
- Default unspecified route in diary/photo now prefers WebView, unless user sets preference `off`; explicit native button preserves original visible save functionality. If browser has no active login/session, a single visible official Naver PC WebView is opened for a user's manual login; no false saved claim.
- Expose a Settings checkbox for `사진·일기 저장은 PC 웹 우선`, default ON when unset, persist user OFF/ON rather than clearing.
- Writer initializes after WebMessage bridge readiness with bounded retries; only origin-scoped NAVER frames; nested command forwarding and root-directed results use per-job nonce. No private API/credential extraction/CAPTCHA bypass.
- Keep PC original address result → address detail → exact ☆ → alias → memo → unique existing folder OR validated new private folder → commit once → readback. Keep no duplicate auto-creation, no fake readback PASS and no repeated commit. **Javascript `.click()` trusted user gesture compatibility on Galaxy still OPEN.**
- NOTE: this is not native Naver 6.7.2.1 in-process patch or automatic sharing of Naver-app cookies; Android UID isolation remains intact.

## Actual release
- APK: `MOA_R341_PC_WEB_BUTTON_NESTED_FRAME_LATE_BRIDGE_BETA.apk`, package `com.juhyeon.familyjournea`, code341, size **8,879,950B**, SHA256 **`b1dd972694bb0249add1a70dee5a2a2bddb90632bed74b87978b476ec3818be0`**.
- Emergency forward recovery: `MOA_R343_FORWARD_RECOVER_R329_FUNCTIONS.apk`, code343 size **8,879,863B**, SHA256 **`fdae93727d3c7b9a46155d1e6c8bda789a1fb0137602ecbc9096e704ca5f6ea4`**, all original R329 functional member content frozen except Manifest code; **not routinely install**, Galaxy recovery itself not tested.
- Exact backup ZIP `MOA_R341_APK_R343_RECOVERY_SOURCE_QA_20261111.zip`, size **12,866,518B**, SHA256 **`af31e7bc98a4d8e919d5272566b38aff276ebedd5b51790b62e5d41fc9c093f1`**, contains byte-identical R341+R343 signed APK, QA, source JS, 13-case Node VM mock harness, hashes, Korean install guide. ZIP CRC PASS.
- Compared to signed R337, exact 4 changed uncompressed members: Manifest, `assets/web/fj-naver-favorites.js`, `assets/web/moa-r231-naver-frame-probe.js`, `assets/web/moa-r231-settings.js`; **134/138 entries unchanged, 16/16 DEX byte-identical**.
- Original certificate SHA256 `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`; independent v2 RSA/full content digest, ZIP CRC, stored alignment and 16DEX SHA/Adler all PASS; frame writer `22454` JS characters (below native 24,000 cap).
- Node VM 13/13 PASS; exact original PC non-browser Pytest 35/35 PASS. Eight Chromium browser fixture tests **NOT COMPLETED** due sandbox `net::ERR_BLOCKED_BY_ADMINISTRATOR` to 127.0.0.1 (not site failure).
- PRIVATE Library: `/모아_프로젝트_근거_20261103/R341_20261111/` stores exact ZIP and QA/README. No family photos, exact GPS, cookies, Naver APK split, signer/key/password or Windows original source uploaded to public repo.

## Physical QA still required
Installation on user's Galaxy, actual Naver authenticated session, WebView native bridge initialization, search result click, address heading/star, popup, alias/memo, selected folder, private list creation and persistence/readback all **not verified**. No FINAL/Golden claim. Existing R269 frozen Golden and AA AirPods routing untouched. Do not uninstall, clear app data, reset pairing or install R343 as routine. Test exactly one photo GPS save and inspect actual list, avoid duplicate attempts until status known. If R341 breaks existing app function only then forward-install R343 (code343 blocks later lower version R341).
