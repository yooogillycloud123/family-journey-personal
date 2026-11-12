# MOA R411 — USER CONFIRMED SCOPED GOLDEN (2026-11-12)

## Physical user report
User explicitly reports **1, 2, and 4 SUCCESS** on actual Galaxy S26 Ultra after installing R411. These correspond to:
1. Cold MOA launch: initial NAVER PC map masked warmup no visible foreground NAVER browser flash reported success, although user observes short vertical UI motion.
2. After cold launch: first offscreen NAVER place-save successful, with UI staying nonoccupying.
4. When user intentionally closes NAVER browser and taps offscreen save: automatic masked rearm and save successful, but a brief MOA branded cover appears instead of the original diary screen.
The separate **>4 minute keepalive test #3 was NOT confirmed**. Do not claim physical PASS for it.

## Crucial new regression (NOT GOLDEN)
Private actual user videos `20812.mp4` (89.17s) and `20813.mp4` (19.92s) supplied. User observes advanced native Gallery (full-width continuous photo/video rail, video autoplay, mute, capture, media volume, swipe) appearing replaced by **old `← 목록 / 공유·카톡 등 / 갤러리에서 열기` full-screen legacy viewer** at ~80s of 20812. In exact R411 APK, `classes6.dex` *still contains* `MoaNativeGallery`, `GalleryRail`, `VerticalMediaVolume`, `r227ExternalMapPending`, `r187SeekInFlight` and video methods. The legacy screen exactly matches `assets/web/moa-r133-diary-unified.js` fallback called when `window.MoaLocalAudio.openNativeGallery` is missing or returns false. **Missing route/bridge or failed MediaStore file check** is the open family of possible causes; no on-device bridge call return traces, so do NOT claim a specific cause proven.
Original R227 separate gallery user Golden is frozen. Its classes6.dex differs from R411 because later classes6 also includes NAVER web controller; **DO NOT blindly copy R227 whole classes6** into R411, which would break NAVER sessions.

## Golden identity
- Current user-tested `MOA_R411_R407_MASKED_REARM_KEEPALIVE_SIGNED_BETA.apk`
- code411, size 8,937,063 bytes
- SHA256 `ec2c0fb88b4fc795b59156acdd59b88c4702bc4135634b6096be7efcf8d76377`
- package `com.juhyeon.familyjournea`, original cert SHA256 `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`.
- Store this exact APK and full QA ZIP PRIVATE only; Library `/모아_프로젝트_근거_20261103/GOLDEN_R411_USER_SCOPED_20261112/`. Never overwrite or privately leak signer, user photos/videos, GPS, cookies, or logs.
- R411 is **only a scoped Golden for the three confirmed NAVER functions**, NOT a whole-app Golden because the gallery native fallback regression is serious.

## Forward branch
For improvements, base future APK from exact R411 bytes, change only a small additive native module and test actual high-fidelity gallery entry. R415 code415 is the first distinct beta attempting single app panel mask (no duplicate cover), frozen in-place screen for explicit rearm, and native gallery WebView owner/trust restoration. R417 code417 original R411 functional forward recovery if R415 serious regression. New candidate if R417 installed must >417. Do not uninstall/clear app data/cookies. AA AirPods untouched.

User-provided source videos private and never published on GitHub.
