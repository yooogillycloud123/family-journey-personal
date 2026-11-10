# 2026-11-10 Android mobile Naver Place direct-browser proof — no login (NOT a full MOA APK)
Read after MOA R227 immutable gold and real Galaxy R241/R245 failures.

## Real unauthenticated network proof: GitHub Actions run 42755713059
Actual Playwright Chromium sessions, 2026-11-10 (this is emulated Android-mobile browser UA, NOT actual S26 WebView or logged-in user):
| Route / mobile browser mode | HTTP | Evidence |
| -- | -- | -- |
| `https://map.naver.com/p/` normal Android-mobile | 200 | Redirects to `m.map.naver.com/appLink.naver`, NOT map functionality; R241 repeats problem |
| `https://pcmap.place.naver.com/place/1628573942/home` Android-mobile | **200** | Actual public Place page renders with a visible **저장** control |
| `https://m.search.naver.com/search.naver?query=...` Android-mobile | **200** | Naver search with real address and Place section results |
| `https://m.place.naver.com/place/1628573942/home` Android-mobile | **429** | Request rate limited from GitHub hosted IP; do not repeat aggressively |
| `https://pages.map.naver.com/save-pages/` Android-mobile | 200 | **Error page '요청하신 페이지를 찾을 수 없습니다'** (DO NOT misread HTTP200 as working saved UI) |
| `https://pages.map.naver.com/save-pages/api/maps-bookmark/v3/folders?... ` Android-mobile | **405** | Body explicitly **로그인정보가 없습니다**; readback requires real auth, not yet verified |
| `https://map.naver.com/p/` Android UA claiming Windows | 200 | Public PC map DOM + Save navigation exists, but earlier Galaxy Android WebView R233 does NOT reproduce this |
No NAVER login or writes occurred. Source: `experiments/moa-naver-mobile-routes/ci_probe.py`, public JSON artifact on run 42755713059; do not publicly release private family GPS.

## Valid app design consequence
- **Do not load `map.naver.com/p/` on Galaxy-mobile first.** User already proved app redirect / ERR_TOO_MANY_REDIRECTS on embedded WebView.
- Realistic alternative to test is embedded first-party `pcmap.place.naver.com/place/{exactVerifiedSid}/home` for the Save UI. First-party browser authentication would need user consent once. Authenticated modal (list creation+alias+memo+save) and list GET readback have not been observed in a real user's account. Mobile Chrome emulation is not equivalent to Android WebView real device.
- Resolve **exact Naver place SID** before any write: reuse MOA photo GPS and diary metadata, reverse geocode once; Naver mobile search can provide candidate links but user must not repeatedly enter fields. If multiple businesses share same address, require contextual confirmation on the photo card (not a six-field settings test).
- Full strict user requirement: when photo's '즐겨찾기 저장' tapped, no other app screen, no PC, root/Shizuku/helper, existing gallery/QuickRecord/return immutable, list autocreate + exact alias/memo + independent NAVER account readback. Only mark CONFIRMED on exact account readback, never simple button click.
- Do not ship beta APK with new manual inputs/overlay; R245 remains unchanged as signed failed demonstration, not claimed completed.

## Actual staged code
`experiments/moa-naver-mobile-routes/MoaNaverAutoDraft.js` generates a sanitized request from original photo GPS + previously known exact venue metadata with **zero prompts**, and `readbackMatches()` only passes exact list+POI+requested alias/memo. No guess of place from coordinates, no manual re-entry. `test_autodraft.cjs` passed in GitHub Actions run 42756111782. **It is source only and NOT wired to the full MOA APK or a real NAVER writer**.

## Remaining proof gates (must PASS before a single new user APK)
1. Android S26 WebView on `pcmap.place.naver.com`: true page, not error landing, legitimate first-party login, no forbidden cookie import.
2. Exact SID from one real photo: confidence/ambiguity rules from verified Naver result.
3. Same-engine attached offscreen browser: working Javascript while MOA remains foreground, no Naver screen occupied, no overlay workaround.
4. Actual list creation, save place+alias+memo in user's own account, independently readback all fields. Existing saved list/item must not be toggled off. Try repeated cycles and crash/requeue.
5. Original-signer same-package version increment, no regressions, fully verified APK+matching ZIP+clear user guide. No root/data clear, never publish signer private material.

Reference: AOSP secondary virtual display activity security blocks arbitrary cross-app invisible launches (https://source.android.com/docs/core/display/multi_display/activity-launch); Samsung Internet Custom Tabs do not grant MOA arbitrary DOM control (https://developer.samsung.com/browser/android/web-developer-guide.html). GeckoView is not officially supported on NAVER PC Maps (https://help.naver.com/service/5637/contents/20007?lang=ko&osType=PC).
