# MOA R523 / R525 — native in-card Gallery Back, video geometry, scroll stability (2026-11-14)

**Status: R523 ORIGINAL-SIGNED LAB CANDIDATE; REAL GALAXY NOT VERIFIED. R463 remains the ONLY user-approved immutable Golden.**

## User's immediate evidence / corrections
- Physical Galaxy videos `21527.mp4` and `21528.mp4` show R519's unwanted up-arrow in supposedly empty Today strip; repeated Back failing to leave the photo diary; video player expanding/shrinking after playback starts; obvious drag/jank while vertically scrolling with the embedded native Gallery compared to fluid legacy web diary.
- Explicit user request: remove the **Today text only**, add NO alternate arrow, icon, character or decoration. Continue native Gallery in the photo diary; do not edit standalone R463 advanced Gallery.
- R519 user-visible symptoms were NOT resolved by the previous 32ms polling + 56ms easing removals; physical performance is the acceptance gate.

## Root cause from source
- Native supplementary `MoaR507InlineGalleryProvider.tick()` called `__moaR515RecoverInline` after `MoaNativeGallery.open` changed to false. The original R463 Gallery already has its own Android `PRIORITY_OVERLAY` callback that closes Gallery; this unexpected-closure recovery could relaunch a native session right after a real Android Back, trapping the user in the day.
- R519 Gallery owned card reapplied `lowerControls` height each position tick when original `updateChromeLayout` restored normal sizes, and also reapplied `TextureView` content transform every 420ms. Both interact with the original `MediaPlayer` layout on video start, resulting in visible zoom/size changes.
- Native host is a separate Android View over a scrolling WebView. Async `evaluateJavascript(getBoundingClientRect())` polling incurs unavoidable Web/native bridge delay; R523 cuts unnecessary render work and bounds position extrapolation, but DOES NOT fundamentally share the WebView's compositor and CANNOT honestly guarantee 60fps lockstep scrolling.

## R523 actual changes (vs R519)
1. Additive Web calendar JS button text is **empty string**, not `⌃`. Accessible label remains `오늘 날짜의 달력으로 이동`. CSS blocks any `::before` or `::after` symbols; 420px synthetic viewport 406×29px blank bar PASS.
2. Native Gallery Back no longer triggers automatic same-day reopen. Both original Gallery close and owned callback route through one photo-day → unified month calendar transition; confirm open=false persists at least 180ms before treating transient media state as a real close. When closing intentionally set page-exit guard before `closeNativeGallery`; old Web diary remains hidden. Native Back handles IME first, modal route preserves original voice handler; cancelled dirty-entry confirmation resets exit latch.
3. Stop forced 137/82dp `lowerControls` height modifications on every polling tick. Compact initial card only; the original Gallery owns follow-up video chrome layouts. Limit center-crop Matrix attempts to first media state + bounded ready retries rather than perpetual every 420ms. Suppress minor frame-size jitter (<=9dp), reduce heavy unnecessary layout/Matrix work while rendering.
4. Host vertical motion is direct hardware translation with a capped <=18dp look-ahead based on recent native WebView rect delta; 48ms polling instead of 32ms and no 56ms delayed animation. **Smoothness still requires Galaxy validation**; if persistent jank, implement a correctly permission-scoped event-driven scroll bridge or dedicated native scroll container rather than assert polynomial/timing tweaks cured it.
5. No database changes, no font/theme ownership migration, no NAVER cookies/access change, and no changes to R463 standalone Gallery DEX.

## Exact binaries and verification
- R523 install original-signer LAB: `MOA_R523_NATIVE_BACK_VIDEO_SCROLL_FIX_ORIGINAL_SIGNER_LAB.apk`, versionCode 523, **9,013,134 bytes**, SHA256 **`d925abae1231ec70c0b9505c024d62b973d5a21e6d54067507ffa22194174876`**.
- R525 emergency exact R463 functional rescue: `MOA_R525_EXACT_R463_GOLDEN_FUNCTION_RECOVERY.apk`, versionCode 525, **8,951,160 bytes**, SHA256 **`a9fd0d5f9e4023123cb1e50acd74bfeb390db21d412097cd3a280572d5e36006`**; changes ONLY Manifest versionCode from previous R521.
- Combined install/recovery/source/DEX/QA ZIP `MOA_R523_R525_NATIVE_VIDEO_BACK_SCROLL_SIGNED_APK_SOURCE_QA_20261114.zip`, **13,019,953 bytes**, SHA256 **`42647709fd4b2cb8460cad4f77de4dab750e9edd9902797b703cd519fc18a122`**; ZIP CRC + embedded APK identity PASS.
- Package `com.juhyeon.familyjournea`; original signing cert SHA256 `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`.
- GitHub native bridge SDK35 D8 build `.github/workflows/moa-r523-native-card.yml` run **43538680227** SUCCESS. New `classes18.dex` 26,452 bytes, SHA256 **`3ab6ea0ae3b2bb27956dea5bb2ff4270df1bac76cc63da1495e66a7d8b0c5bf6`**; exact provider source SHA256 `89799344f3f6b4391bee317e584288b1c558b6ac93c61c7c6030046e5aab8875`.
- R519→R523 changed only `AndroidManifest.xml`, `assets/web/moa-r483-vertical-calendar.js`, `.css`, supplementary `classes18.dex`. **All original R463 classes.dex through classes17.dex untouched and byte-identical**, native R463 Gallery/Video owner preserved. R525 only manifest vs R521.
- Independent native-original certificate v2 RSA signature + full signed-content digest / stored-entry alignment / APK CRC / DEX SHA1 and Adler32 PASS both. Browser pink/peach/black/white at 420×870 PASS: no text or arrow on Today, 406×29 size, native closed->calendar, no auto-reopen on exit, direct native callback->calendar, legacy original root hidden, no JS exceptions.
- **NOT TESTED:** Samsung hardware Back gesture event order / real video start and scaling / sustained vertical fling jank / all ordinary R463 Gallery functions / GPS-Naver / voice + dirty confirmation / 14,000 photos / download resolver. Real device proof required before calling success or Golden.
- Keys/passwords and user media/GPS/diary data NOT in GitHub, ZIP, README, or screenshots.

## Safeguards and resume
- User-approved Golden R463 signed SHA256 `9d2fd10d32a3bc35eb3132333e96edd8f565abd5daf3ce954b052f77083d8379`, original branch `golden/moa-r463-user-approved-20261113`, unchanged.
- Private Library release: `/모아_프로젝트_근거_20261103/R523_R525_GALLERY_FIX_RELEASE_20261114/`; source branch `feature/moa-r523-back-video-scroll-stability-20261114`; WIP `/모아_프로젝트_근거_20261103/R523_NATIVE_IN_CARD_WIP_20261114/`.
- Install ONLY over existing package with installed versionCode <523; never uninstall, wipe IDB/photos, NAVER cookies/login or delete user's diary. If serious regression emergency update install R525; afterwards next candidate must have versionCode >525.
- If the next real Galaxy video still stutters on Web/native vertical scroll, treat as **architecture problem**: Android native overlay and browser scroll are separate compositor owners. Need a direct one-way geometry bridge with origin checks and native frame sync, or native-hosted scroll layout. Do not repeat polling interval guesses or auto-reopening retired web UI.
- User has experienced Android ChatGPT `Library file not found`. File existence, Library save and sandbox link do not establish device download; report recipient status UNCONFIRMED.
- No AirPods/Android Auto source touched.

**Read first next chat**: `MOA_READ_FIRST_NEW_CHAT.md`, `MOA_R463_GOLDEN_LOCK_READ_FIRST_20261113.md`, `MOA_WIP_CHECKPOINT_CURRENT.md`, this handoff, existing R523/R525 APK/ZIP and exact feature source. Continue from R523 not R483.
