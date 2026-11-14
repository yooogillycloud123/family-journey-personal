# MOA R519 / R521 — native in-card photo diary direct entry, Back/rail/scroll, original-signed LAB

**Date:** 2026-11-14 (Asia/Seoul). **User-approved Golden remains immutable R463** (package `com.juhyeon.familyjournea`, Golden APK SHA256 `9d2fd10d32a3bc35eb3132333e96edd8f565abd5daf3ce954b052f77083d8379`). R519 is a new **LAB candidate, not a new Golden**, until Galaxy verification.

## Physical R515 user evidence and 6 requirements
User screenshots/video `21519.png`, `21515.mp4` (30.8 s), `21518.mp4` (46.4 s) show R515 in-card native photo/video Gallery broadly working with full-bleed video, but:
1. Full-width bottom Today bar is taller than desired; remove visible `오늘` text, preserve a recognizable minimal symbol.
2. Opening photo diary first shows old Web media UI for roughly a second before native Gallery attaches.
3. Move the GalleryRail show/hide control into the same dark native action strip as ★ / share / GPS-Naver / capture info / fast swipe.
4. Inline native Gallery appears to trail vertical scroll rather than remain aligned with its card. Existing video mute/play/capture/time UI feels oversized.
5. Never alter standalone R463 high-end Gallery's code, video or navigation behavior.
6. Android Back in an in-card Gallery must return to the main **unified calendar**, not merely close native Gallery and reveal the obsolete Web diary photo interface. Keep diary text, voice modal, recorder behavior safe.

## Original source diagnosis / exact change
- R515 Java native overlay `MoaR507InlineGalleryProvider` used a 56ms compositor animation after each 55ms WebView geometry poll, causing a following/trailing effect. R519 uses direct `setTranslationX/Y` to latest card geometry every 32ms when owned; no repeated TextureView layout unless dimensions change. MediaPlayer/Texture transforms are throttled to relevant media transitions / <=420ms, rather than querying every poll. **Real performance remains physically untested.**
- R515 built native Gallery after the Web day had already drawn, displaying R499 Web controls initially. R519 sets `moa-r519-native-entering` before initial paint, hides only the obsolete Web photo controls/pager while native is mounting, starts the arm handshake without extra 140ms delay; a bounded 3.5s fallback restores Web UI if native mount is unavailable. The still image/poster can remain underneath the native host to avoid a black blank.
- Native Android `OnBackInvokedCallback` is registered only on this owned photo card at overlay priority + 50 and calls `window.__moaR519NativeBack()`, then unified diary `r495TryBack()/goBack()`. Original Gallery full-screen callback remains untouched. In Web `goBack()`, set legacy root hidden before native close, change page to calendar before rendering; `r495SyncLegacyRoot` hides retired calendar even if original detailed-owner state still says `page=day`. On dirty text, retain unsaved-work confirmation.
- For the keyboard, native back first hides visible IME; when a voice modal is present, delegate to the original `__fjBackOverlay` before changing diary page. Synthesized browser cannot guarantee Samsung's physical Android Back dispatch ordering.
- Native compact gallery deck: append the thumbnail `⌄/⌃` as the sixth 34dp slot after representative-photo star and existing 4 R463 actions, **no free-floating thumb overlay**. Rail collapse preference `moa.r515.card_ui/rail_expanded` unchanged; original R463 rail physics untouched.
- The original Gallery `updateChromeLayout()` intentionally restores lowerControls height to 208dp; in-card R519 reapplies 137dp (rail shown) / 82dp (hidden) only while the owned native photo-card session is active. Icon visuals: original R201 mute/play/capture views scaled ~.82, video row 34dp, seek row 27dp and 10sp time text; hit behavior and listeners remain original.
- Full-width Today dock retains ~406px width on 420px viewport, visible height from 33px to **29px**, label replaced by small upward chevron `⌃`, accessible Korean label `오늘 날짜의 달력으로 이동`.
- The R515 cover/crop behavior stays in-card only. Source changes affect only supplementary `classes18.dex` and additive Web calendar JS/CSS. **All original 17 DEX are byte-for-byte preserved; no R463 code edit, original gallery, MediaStore, Naver, original diary database or voice migrations.**

## Files and hashes
- Install: **`MOA_R519_INLINE_NATIVE_BACK_RAIL_UI_ORIGINAL_SIGNER_LAB.apk`**, `versionCode=519`, **9,011,860 bytes**, SHA256 **`44c09f551f0289eba7fdf3744916a33c8334dae55eed7ba8a4f238a430251cfc`**.
- Emergency same-original-signer exact R463 functional restoration: **`MOA_R521_EXACT_R463_GOLDEN_FUNCTION_RECOVERY.apk`**, `versionCode=521`, **8,951,153 bytes**, SHA256 **`ce244fa9a01c26a9630915dec8741425ff1e9adbd019e82cc49ebb1d204ace92`**. R517->R521 changes only AndroidManifest version; if installed, future candidates **versionCode >521**.
- Combined install/restore/source/DEX/QA/README/SHA ZIP: **`MOA_R519_R521_NATIVE_DAY_BACK_RAIL_SIGNED_APK_SOURCE_QA_20261114.zip`**, **13,017,441 bytes**, SHA256 **`b1fca9fbb526db0b796c09226b9f2059c43604a600e64251bae927a73fde2db6`**, ZIP CRC and embedded exact APK bytes PASS.
- APK package `com.juhyeon.familyjournea`, original certificate SHA256 `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`.
- Private Library folder **`/모아_프로젝트_근거_20261103/R519_R521_NATIVE_DAY_BACK_RAIL_20261114/`** stores ZIP, both signed APKs, three exact source files and QA. Separate WIP in `/모아_프로젝트_근거_20261103/R519_NATIVE_DAY_WIP_20261114/`.
- Exact source branch **`feature/moa-r519-direct-native-day-back-rail-20261114`** at `experiments/moa-r507/MoaR507InlineGalleryProvider.java`, `experiments/moa-r483/moa-r483-vertical-calendar.js`, `.css`. Source is NOT merged into golden.
- GitHub SDK35 javac/D8 workflow `.github/workflows/moa-r519-native-card.yml` final successful run **43533794548**. New supplementary `classes18.dex` **25,508B**, SHA256 **`b8f33fedeb629ee7eddce6f58543a7eeb71b1ab56f181875185e3d066225780d`**, source SHA256 `d1a8abc7d76bfefc9504ca478c1f98fab5b4be52d1de49e52c8a3f86e4758545`.
- Exclude signing private key/password, user's images/videos, GPS, database, cookies and any account secrets from all release artifacts.

## Verification gates (do not conflate)
- **PASS STATIC:** GitHub Java/D8 compile; source/CI manifest exact SHA; independent APK v2 RSA PKCS#1 SHA256 cert/signature/full signed-data content digest, 4-byte stored-entry alignment, ZIP CRC; all original 17 DEX bytes identical and all 18 DEX SHA1/Adler32 header integrity; R515->R519 exactly Manifest + 2 Web files + classes18; R517->R521 only Manifest.
- **PASS SYNTHETIC BROWSER:** 420x870 Chromium with pink/peach/white/black: 406x29 Today button no word, original accessibility label, no obsolete Web controls during pending native mount, native-mount toggling, simulated native Android Back -> unified calendar and legacy root hidden even with old owner's `page=day`; no JS exceptions.
- **NOT TESTED DEVICE:** actual Samsung Galaxy Android predictive Back precedence, real keyboard/voice modal, actual first-frame native attach timing, video/capture/volume/nav map, high-speed vertical scroll performance, 14k-photo rail, thumbnail button click in live Gallery, ordinary separate full-screen R463 Gallery regression. Do **not** claim these physically PASS or call R519 a Golden.
- Historical ChatGPT Android delivery links have yielded `Library file not found` for the user. Sandbox file existence, GitHub commits and Library uploads alone **do not prove mobile recipient opened/downloaded the APK**.

## Install and rollback
- If installed versionCode <519, **update-install R519 over existing app**; do not uninstall, clear app data/cache, DB, media, NAVER cookies or login.
- R521 is emergency only for major regression. It restores the R463 functional behavior and loses R519 new DayPic calendar/photo card features; after installing R521, next version must be >521.
- Leave AA AirPods project untouched.
- Next session must first read `MOA_READ_FIRST_NEW_CHAT.md`, `MOA_R463_GOLDEN_LOCK_READ_FIRST_20261113.md`, `MOA_WIP_CHECKPOINT_CURRENT.md`, this handoff, exact R519 source and release ZIP; continue from existing verified outputs rather than reconstructing from R483.

## Explicit physical acceptance
1. After installing R519, test ordinary standalone R463 Gallery first (video/volume/capture/GPS/quick swipe/Back) for no regression.
2. Central `+` -> photo diary: there should be no flash of old web controls, native card is visible and stable.
3. Native lower strip includes star/share/map/info/fast-swipe/rail-toggle. Rail hides/expands without clipping or changing video playback; controls are smaller.
4. While playing a video, scroll vertically to story and back, confirm native Gallery remains aligned instead of lagging or falling back to Web.
5. Android Back returns photo diary directly to calendar; active keyboard hides first, voice modal and unsaved diary confirmation are honored.
