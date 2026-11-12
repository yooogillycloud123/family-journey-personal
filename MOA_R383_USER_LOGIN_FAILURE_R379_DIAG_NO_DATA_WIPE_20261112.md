# MOA 2026-11-12 — R383 로그인 재발 실기기 진단: DATA WIPE 금지 / 수정 가설 재평가

## 최신 사용자 관측
- 사용자 보고: R283에서 과거 영수증 인증 실패를 해결하여 정식 네이버 2차 인증 및 로그인 성공, R365까지 다수 업데이트 동안 로그인 유지. R365 이후 갑자기 로그아웃됐고, R373/R383의 추가 hidden-WebView guard 패치 이후에도 네이버 수동 인증 문제가 재발함.
- **R383 가드만으로 문제 해결 실패.** Native companion hidden-prewarm 충돌 가설을 로그인 실패의 주원인으로 단정하는 것은 이제 부적절함. 다른 무검증 가드 APK 반복 배포 금지.
- 사용자가 제공한 `moa.r379.login.diagnostic.v1` JSON 사건 순서 (UTC):
  1. 10:23:48 수집 시작, 앱 visible/focused.
  2. 10:23:54 `VISIBLE_DESKTOP_PAGE_FINISHED_UNVERIFIED`; 10:23:56 `FRAME_ELEMENTS_OBSERVED_READ_ONLY`.
  3. 10:24:00 `HOST_BLUR`.
  4. 10:24:02 `NAVER_OFFICIAL_LOGIN_ENTRY_UNVERIFIED` → 10:24:04 `NAVER_AUTH_SCREEN_MANUAL_ONLY`.
  5. 10:24:26 `VISIBLE_DESKTOP_PAGE_FINISHED_UNVERIFIED`.
  6. 10:24:29 `HOST_FOCUS`, `STOPPED`, `PROBE_DISPOSED`.
- **R379 JSON scope itself explicitly says NAVER WebView navigation callbacks NOT instrumented.** Cannot infer auth success, exact NID redirect, login HTTP response, cookie loss, anti-bot cause, precise UA class switching, or 'which component logged out' from these events. `STOPPED`/`PROBE_DISPOSED` means native probe lifecycle ended, not that cookie/profile data was deleted.
- Actual R383 APK SHA256 `6e7382f929c15c4e998945bfad12d159b85e726e5a4bc2fea825881ad23cd1ac` source inspection: `assets/web/moa-r379-auth-diag.js` is still host-side-only; original `classes13.dex` SHA256 `a0485dbff1186709d970e703a37d26fe2f2e57e4ef9e2147cd594937cb2286ef` includes `MoaNaverWebProbeHost`, `setNativeAuthUaOnce`, `setUserAgentString`, `NAVER_AUTH_NATIVE_ANDROID_UA_MANUAL_ONLY`, `CookieManager.flush`. **No `removeAllCookies`, `clearCache` symbols in classes13.dex**. These static strings do not prove runtime transitions. R383 additive `classes18.dex` contains native `MoaR381AuthTrace`, which logs only domain and UA class (no raw URL, credentials, cookie, login answer).
- Of particular interest: R379 sampled states never included `NAVER_AUTH_NATIVE_ANDROID_UA_MANUAL_ONLY`; may have been missed between 500ms samples, and cannot be treated as proof of missing UA switch. Check existing R381 native diagnostic logs before further login attempts or code edits.
- **No Android settings app data clear / uninstall / CookieManager.removeAllCookies / forced WebView profile deletion.** Data clear can delete MOA diary/in-app user state plus session/cookies, and has not been shown to fix challenge. Cache-only clear removes transient resources, but is not login fix and would obscure forensic evidence. Device should not be repeatedly challenged; avoid repeated CAPTCHA attempts.

## Exact next diagnostic gates, not new blind APK
1. Read and compare persisted already-recorded R381 native trace (`moa_r381_auth_events_private` SharedPreferences) if accessible through authorized private app-local diagnostics without exposing secrets. R379 host JSON is insufficient.
2. Establish `nid.naver.com` navigation `onPageStarted`/`shouldOverrideUrlLoading` and whether R283 `setUserAgentString(null)` occurred before challenge, vs desktop UA remaining, vs switch/redirect interrupt.
3. Check real login result classification and website first-party cookie persistence **without logging/exposing cookie values**. Do not copy native NAVER-app credentials/cookies.
4. Compare R283 genuinely fresh-login route with R381/R383 under equivalent clean-but-data-preserved session. Note that R283→R365 mostly retained a logged-in session; post-R365 *fresh* login outcome had not been proven.
5. Only after a demonstrated failing event should narrowly change source, preserve R381 protected 141 payload files and original signer; dynamic Galaxy verified login/2FA required before claiming fix.

## User-facing accurate support
**Do not clear MOA app DATA.** Do not clear cache until existing diagnostic evidence is preserved. Android docs distinguish clear cache (temporary files) from clear storage (all app data). Additional HTTP auth challenge is a site/server/user-flow signal and could be affected by WebView; current source does not isolate root cause. No additional fake 'login fixed' APK is approved on this evidence alone.

Status: **R383 physical login FAIL per user; exact reason OPEN; cache/data purge NOT justified.**
