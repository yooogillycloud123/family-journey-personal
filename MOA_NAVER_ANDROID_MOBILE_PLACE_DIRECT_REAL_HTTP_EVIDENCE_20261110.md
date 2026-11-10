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


## 2026-11-10 additional unauthenticated Save click probe (run 42756466931 SUCCESS)
CI used actual Playwright Chromium (Android mobile UA) on `https://pcmap.place.naver.com/place/1628573942/home`, observed HTTP200 and a visible text `저장`. Clicked this text once while **NOT logged in** and did not submit any account write. Observation:
- `save_found=true`, but `post_click_url` remained the same Place detail URL and frames remained Place main + static analytics iframe.
- `input` and `button` text lists returned empty; no NAVER save-list modal, account login or persisted bookmark was demonstrated.
- **Do not infer this is a working click-to-save flow or capable of authenticated list creation.** It may require a different clickable ancestor/JS event, first-party authenticated session or DOM state. Additional inspection and user-consented login on a real Android engine remain mandatory.
- Proof artifact: GitHub Actions run `42756466931`, `MOA_NAVER_PUBLIC_SAVE_MODAL_NO_AUTH.json` under `MOA-NAVER-mobile-public-route-evidence-NO-AUTH`.

## Current checkpoint
`MoaNaverAutoDraft.js` is a source-only location/GPS/verified-POI/alias/memo/list job constructor. GitHub Actions run 42756111782 passed strict unit assertions, but **no Android APK** is produced by this research. No authenticated NAVER write or readback can be claimed. The user explicitly rejects more installable manual-entry test APKs and screen-cover alternatives. Preserve that requirement, do not relabel source/browser UI evidence as final.


## Last inspection: actual public Place save control ancestry — GitHub run 42757710483 SUCCESS
- Real Android-mobile Chromium UA page `pcmap.place.naver.com/place/1628573942/home` has exactly one public `저장` label inside `<span class="place_blind">` nested within a link with `role="button"`, `aria-pressed="false"`, `data-nlog-area="map_btp.save"` (CSS module class `lGLl4`).
- An **unauthenticated** click of that real clickable parent **did not** navigate or open a login popup, change iframe count, or produce a verifiable save modal. The original old selector `a.D_Xqt[aria-pressed]` from an April 2026 OSS reference is already outdated; do not ship with hard-coded selector.
- Evidence: run 42757710483 artifact `MOA-NAVER-Place-Save-DOM-public-no-account`; *no NAVER account data/login or actual saving*.
- Important possibility (not proven): Place web view is built as an iframe child that expects a parent `map.naver.com` context and browser messages. Its standalone public Save label is NOT proof of a working standalone Save flow. NAVER's own DEVIEW presentation documents Place→Map `postMessage({action,data})` architecture. Therefore the mobile direct Place URL is a useful observation, **not a resolved authenticated writer**.

## 2026-11-10 preliminary R245 product UI source-cleanup, NOT APK
- Private Library: `/모아_프로젝트_근거_20261103/R247_EXISTING_PHOTO_GPS_SOURCE_ONLY_20261110/MOA_R247_EXISTING_GPS_SOURCE_ONLY_NOT_APK.zip`, zip sha256 `cbc125a2e0acf10ec1561e8e69e33ad240a107af031c0c19ec2abab24c8e8530`.
- The research patch removes R245's *six-field manual Settings tester* and *duplicate prompt() venue/list questions*, preserves original popup settings and Photo Gallery, and reuses existing photo GPS/draft address/list/alias/memo.
- Exactly 11 static/syntax/guard tests PASS, **but no authenticated NAVER bookmark write/readback exists**. Consequently the source patch is not converted to a user APK; its status fails closed `PENDING_AUTHENTICATED_BROWSER_WRITER`.
- New user installation or further fake beta releases are forbidden until the actual writer and readback are proved; existing R227 GOLDEN and user-confirmed R229 NAVER return not changed.
