# MOA R231 — 네이버 복귀 팝업 전용 설정 + 실제 네이버 웹뷰 연결/숨김 실행 진단 BETA

2026-11-09. **기준 R229 (사용자 실기기 성공: 네이버지도 위 ↶ MOA 표시·편집·한 번 눌러 같은 갤러리 사진 복귀), 불변 R227 골든 변경 없음.**

## 사용자 증거와 올바른 상태
- 사용자 제공 `19976.mp4` 31.7초는 R229 갤러리→NAVER 실제 화면→작은 `↶ MOA` 플로팅 버튼 편집·표시→눌러 원래 갤러리 사진/동영상으로 돌아오는 흐름이다. 사용자가 **"정상작동함"**이라고 직접 확인했다. **R229 복귀 핵심 동작 = GALAXY SCOPED PASS**. 모든 시스템/화면 방향/백그라운드 모드 검증이라는 뜻은 아니다. 해당 가족 사진/정확한 주소/비디오는 공개 저장소에 업로드 금지.
- 설정 캡처 `19977.png`, `19979.png`: 기존 `바로기록 팝업` 카드가 있고 토글, 6개 기록 아이콘 스타일, X 심볼, 표시 텍스트, 자동 숨김, 크기 슬라이더, 불투명도, 이동/8방향 리사이즈, 가장자리 정렬, 초기화/미리보기가 구현되어 있다. **R229의 `↶ MOA` 복귀 버튼은 아직 별도 MOA 설정 카드가 없어서 사용자 요구가 미완성**이었다.
- 새 요구: 기존 바로기록과 다르게 **`네이버지도 복귀 팝업` 전용 카드**를 settings에 동일한 UX 체계로 추가; 그리고 지도 즐겨찾기 화면을 뺏지 않는 WebView 방식의 **Android 실제 실행 단계로 즉시 진입**.

## R231 signed artifact (원본 계열 업그레이드)
- package `com.juhyeon.familyjournea` versionCode **231**; original certificate SHA256 `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`.
- APK `MOA_R231_NAVER_RETURN_SETTINGS_WEBVIEW_PROBE_BETA.apk` **5,815,249 B** SHA256 **`57ba08ff7491270f6e71c8b41d00c32911dc6cf8eb27f9d7c1faa5536970f343`**.
- ZIP `MOA_R231_NAVER_RETURN_SETTINGS_WEBVIEW_APK_BACKUP.zip` SHA256 **`a8b9083f00a8e40cafd89abddea5f5a8d887943c434cedd0ed9fabaa6d5c302d`**; includes byte-identical APK plus QA JSON/README/checksums.
- From exact R229 (SHA256 `823bed41210be28b971860c88879bbc43e934793cf9847d1f0cb7e3e4f1cef74`) **127/131 existing entries byte-identical**, existing only manifest 229→231, `assets/web/index.html` loader, `classes6.dex` host minimal new native JS bridge, and `classes10.dex` overlay + new WebView native. Added only `assets/web/moa-r231-naver-ui.js` and `.css`; 133 entries/10 DEX; APK v2 original signer, APK CRC, DEX sha1/adler32, ZIP byte-identical PASS. User Galaxy install/device QA **NOT TESTED**.

## Implementation
1. **복귀 버튼 전용 settings** `MOA → 설정 → 네이버지도 복귀 팝업`: 표시 스위치, 미니멀 글래스(기본)/피치/화이트, 불투명도, 화면 방향별 크기, 길게 눌러 이동/8개 방향 리사이즈, 가장자리 붙이기, 위치/크기 초기화, 미리보기. Existing Quick Record native class/shared prefs `moa_quick_overlay_v1` never touched. New preferences exclusively `moa_naver_return_overlay_v1`. Old R229 actual return path and original Gallery unchanged.
2. **WebView real native probe** `MOA → 설정 → 네이버 즐겨찾기 웹 연결 · 실험 → 네이버 웹뷰 진단 시작`: actual Android `android.webkit.WebView` created **only after explicit user action** in a native dialog, opens exact NAVER web URL `https://map.naver.com/p/` with HTML/DOM JS. Login only via NAVER's displayed page; redirects limited to `https` and `naver.com` subdomains. Numeric-only `iframe count` and save/list selector presence; no saved places, passwords, cookie strings, personal HTML or photos read/uploaded. `숨김 검증` reattaches the same live WebView with 390×820 layout inside a 1×1 clipped FrameLayout while MOA is visible and interactive, samples numeric top-page selector counts, and disposes the worker after 30sec. Observe probe state via Settings; no full favorites automation shipped.
3. New Bridge `MoaNaverFeatures` is attached to local trusted `https://familyjourney.local` only, on existing `MoaMomentAudioHostActivity.attach` schedule. Native code caches trusted top page on UI thread (does not read WebView API from JS bridge thread), invokes original `MoaNaverReturnOverlay` read/write preferences, prompts before opening the experimental WebView, disposes on main host onDestroy.
4. All WebView worker code is isolated in classes10, only initialized when user asks, no background loop at launch; native Android system WebView engine reused. APK net increase **24,731 bytes** vs R229; actual peak RAM, browser login interoperability, throttle/hidden DOM, frames, Naver web account session and keyboard are **NOT YET DEVICE MEASURED**. No AndroidX libraries added to runtime APK (initial AndroidX feature-gate PoC compiled separately as R229 source-only).

## Explicit limits
- **NAVER real account favorites AUTO-SAVE = NOT IMPLEMENTED**; **NAVER auto-create saved lists = NOT IMPLEMENTED**; hidden running can be blocked/throttled by Android/WebView/Naver. This R231 is a controlled **capability probe** to decide feasibility, not a false completed favorite saver. The official nmap app URL launches visible maps only, not account bookmark API.
- Main frame DOM cannot bypass cross-origin `iframe` browser same-origin restrictions; AndroidX WebKit per-frame origin-scoped scripts are next only after R231 visible/hidden login/frame feasibility. Never scrape passwords/cookies or bypass login/anti-bot, never claim VERIFIED from tap alone.
- Never uninstall or clear app data. Original R227 freeze, R229 proven return behavior and earlier R219/R209/R203/R187 preserved.

## Minimal Galaxy test
1. R231 APK update-install over R229; no uninstall/clear data. Open Settings — both **바로기록 팝업** and **네이버지도 복귀 팝업** must exist as separate cards.
2. Change Naver popup style/opacity/size; open photo GPS → Naver app; observe `↶ MOA` new styling and one-tap return to exactly same photo; basic Quick Record pop-up remains independent.
3. In `네이버 즐겨찾기 웹 연결 · 실험`, press `네이버 웹뷰 진단 시작` and consent. Report page load vs Naver web login vs blank/unsupported. On actual NAVER web top-level page press `요소 진단`.
4. Press `숨김 검증` from Naver map web page. MOA should become usable. Within 30s go to Settings → `진단 결과 확인`; report `state`, `hidden`, `iframe` counts. If not supported, do not attempt hidden saving.
5. Check diary/voice/photo/gallery/Quick Record and Naver one-tap return for regressions. No favorites write is supposed to happen in R231.

## Next exact technical gate
If R231 login/top document/hidden callback passes: implement AndroidX per-iframe observer & first **user-confirmed one-place, one-list create+save+actual NAVER saved-list readback** under separately controlled R233+, first visible verify, then hidden; no blind batch-saving. If login/frame inaccessible, compare explicit opt-in PC headless worker vs user-approved local queue; don't pretend local-only equals NAVER account saved.