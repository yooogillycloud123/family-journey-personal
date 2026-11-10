# MOA R269 — Background saving Android browser acceptance report (2026-11-10)

## Protected baseline
User-designated R269 Golden: exact installed original-certificate APK SHA256 `c0663e65aac2b72feb86cb0f1ba5eac448b6599c3850858de4d942f2aa446920`, code269, package `com.juhyeon.familyjournea`. **The Golden APK and its proven first-party foreground accessibility save path were not edited in this research.**

## Why previous WebView R241 never qualifies
On real Galaxy, R241 navigated `https://map.naver.com/?app=Y&appmarket=N`, hit `net::ERR_TOO_MANY_REDIRECTS`, and did NOT reach saved-place UI. Android WebView does not inherit native NAVER app cookies. User-agent change, WebView onPageFinished, raw save-menu click or a successful APK checksum are not evidence that a personal account bookmark was written.

### Current public network evidence (no authentication or private user data)
- GitHub Actions run **42802940026**, actual Playwright Chromium in Android-shaped viewport, with desktop User-Agent, loaded `https://map.naver.com/p/entry/place/1628573942` HTTP200. Earlier script clicked **navbar 저장**, and reached `/p/favorite/myPlace` login. **That is only opening saved tab, NOT saving the place**.
- GitHub Actions run **42803375767** identified two separate main-page controls: navbar `btn_navbar`, and hidden/inaccessible widget `button.widget_favorite[aria-pressed=false]`. No saving.
- GitHub Actions run **42804626932** waited for Place iframe to load, confirmed `https://pcmap.place.naver.com/place/1628573942/home` embeds inside parent map. Inside it is the **actual place Save link**, `a[data-nlog-area="map_btp.save"][aria-pressed="false"]`. The root widget is non-clickable in headless Playwright due its visibility/layout. Any implementation that treats top-navbar and Place Save as equal is a logic error.
- The exact Place iframe control is now being tested **anonymously** on research CI (no NAVER account login or write). Even if click opens login, it cannot establish personal account list creation/alias/memo/readback success.

### Why WebView iframe integration is different from R241 code
Standard `WebView.evaluateJavascript` runs in the **top frame**, cannot directly control cross-origin `pcmap.place.naver.com` frame. **Official AndroidX WebKit** `WebViewCompat.addDocumentStartJavaScript` and `addWebMessageListener` support origin-restricted script injection and verified frame-origin messages. Ref https://developer.android.com/reference/androidx/webkit/WebViewCompat .
Use only exact origins `https://map.naver.com`, `https://pcmap.place.naver.com`, `https://pages.map.naver.com`; never a globally exposed `addJavascriptInterface` with credentials, never capture/export cookies, passwords, captcha. DOM scripting only in user's own explicitly signed-in first-party browser session.
A source-only Android SDK36 test project and CI workflow exist at:
- `experiments/moa-r269-android-webview-frame-test/**`
- `.github/workflows/moa-r269-android-webview-frame-test.yml`
This compiles an isolated Android WebView 2x2 attached view, injects first-party scripts into frames with WebViewCompat, records redirect/frame state, and NEVER writes to NAVER. It is NOT a MOA APK or a real account writer.
- The previously verified R243 GeckoView CI compiled but Android emulator failed before website result; no proof Mozilla/Gecko works for NAVER map. Browser mock vs actual WebView must be differentiated.

## Account data/auth boundary verified from provided NAVER 6.7.2.1 split APK
- Native first-party `BookmarkRepositoryImpl` invokes `BookmarkApi.addBookmark` and `BookmarkFolderApi.addFolder` via private ApiGateway request builders. Folders add path `folders/new`, bookmark `bookmarks/{type}` (research string evidence only). NAVER native request stack includes `HmacManager` for request URL signatures. **No exported Android bookmark writer** is advertised to third-party MOA. Simply copying private class/URL doesn't give MOA NAVER native session, HMAC, authorization or captcha consent.
- Respect NAVER's protections and the user's personal account. Do not impersonate NAVER app signing certificate or bypass captcha; do not copy proprietary class implementations.

## The product that MUST work before release
1. Preserve original R269 app, existing background capture/Diary/QuickRecord, and user-confirmed foreground native favorites, all bytewise unless strictly needed.
2. Use existing photo GPS/address/list/alias/memo without six-field test form.
3. One-time legitimate first-party **user-visible** sign-in to the **MOA-owned independent web session**; no native NAVER cookies.
4. Actual Android WebView **PC map main + Place iframe** loads under intended Android version, without redirect/app-install errors.
5. Same-page **Place Save** operates after auth: exact Place SID, folder create/select, alias and memo.
6. **Read back exact SID + folder + alias + memo from the user's NAVER account**. Only then emit CONFIRMED; otherwise PENDING/NEEDS_USER/UNVERIFIED with no forced NAVER foreground fallback.
7. Only after #3–#6 physical PASS: source merge to original-signer same-package R269+ APK, full standard APK v2/ZIP/DEX QA, photo/Diary/QuickRecord/naver↶MOA regressions and one exact-byte rollback.
8. Do not label public DOM and Java syntactic PASS a finished APK.

## Current actual status
User requested working final APK, but it is **not yet produced**. The sole unresolved gate is **legitimate authenticated in-app NAVER UI write + exact server readback on Android**, not package/signing/build. Shipping an APK with only public-page frame observation or a fake save-complete popup would repeat R241–R265 failures and violate the current explicit instruction.

## Current research automation
- `.github/workflows/moa-r269-naver-frame-ui.yml` anonymous public Place Save click (no credentials).
- `.github/workflows/moa-r269-android-webview-frame-test.yml` actual Android WebView run. Prior initial run failed due `sdkmanager` PATH; corrected and rerun, result must be inspected before any claims.
- All user private APKs/signing keys, family photos and coordinates remain outside public GitHub repository.
