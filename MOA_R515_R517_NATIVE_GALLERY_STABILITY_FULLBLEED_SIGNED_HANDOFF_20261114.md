# MOA R515 / R517 — original-signer LAB: prevent unexpected web-gallery fallback, compact rail toggle, full-width Today, photo/video fill

**Date:** 2026-11-14 Asia/Seoul. **R515 is an installable LAB, NOT a user-approved Golden.** Only signed R463 remains immutable approved Golden.

## Actual user video diagnosis
User attached physical Galaxy video `21488.mp4` (64.0s, 1080x2340). In the in-card native diary Gallery, photo/video sometimes has large black letterbox bars, the native gallery controls/thumbnails are clipped or too visually heavy, and at the end of navigation the *legacy WebView media UI* reappears unexpectedly. Main calendar's Today button remains narrow/centered. Do NOT upload user videos/photos or private GPS into public repo/release ZIP.

**Trace-backed causes:**
- R511 `MoaR507InlineGalleryProvider.tick()` closes a running native Gallery after ~1150ms of `SNAPSHOT active=false`, even if the form is merely transitioning WebView layout, app resumes from NAVER, or pending state is briefly unavailable. If Gallery unexpectedly closes, provider calls `MoaR469SimpleDiary.home()` instead of recovering native in-card media. R511 web `__moaR507NativeMounted(false)` falls back to Web gallery.
- R511 shrank original native `GalleryRail` to **54dp**, while R463 GalleryRail draws each normal thumbnail 46dp tall and the selected thumbnail **8dp above** its baseline, so selected top can be cropped (for 54dp: 27-23-8=-4dp). Root cause is container geometry, not picture corruption.
- R463 original `MoaNativeGallery` uses ImageView `FIT_CENTER` and TextureView `updateVideoGeometry()` with **min(width/videoWidth,height/videoHeight)**, leaving letterbox margins for different aspect ratios. The original R463 fullscreen Gallery must keep that default.
- R499/R511 Today button has a higher-specificity CSS 94px max-width override.

## Exact signed outputs — private Library and download
- Install **`MOA_R515_GALLERY_STABILITY_FULLBLEED_RAIL_TOGGLE_ORIGINAL_SIGNER_LAB.apk`**, versionCode **515**, 9,010,459 bytes, SHA256 **`23959d383f1dcb9455226341fa99ed2153e3f27c5e85dac9d800f3f2843214ce`**.
- Emergency exact R463 functional restoration **`MOA_R517_EXACT_R463_GOLDEN_FUNCTION_RECOVERY.apk`**, versionCode **517**, 8,951,160 bytes, SHA256 **`33564ff0aac5f9dbfac529bcc11a3f0aecc8cece1c5829fc5bb83cdff206289e`**. R513→R517 changes only binary AndroidManifest versionCode. If installed, future versionCode must be >517.
- Full source + APK 2 + QA + DEX **`MOA_R515_R517_GALLERY_STABILITY_FULLBLEED_SIGNED_APK_SOURCE_QA_20261114.zip`**, 13,013,871 bytes, SHA256 **`890f819aa1b7047972073c294ba757d66d7b8f13a843ce094c471289b5f854f2`**, ZIP CRC and full embedded APK byte identity PASS.
- App `com.juhyeon.familyjournea`; original signing cert SHA256 `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`; private key/password NOT included in any public source or release.
- Private Library release folder `/모아_프로젝트_근거_20261103/R515_R517_NATIVE_GALLERY_RELEASE_20261114/` contains combined ZIP, individual APKs, two QA JSON files and browser QA. WIP source also privately stored under `/모아_프로젝트_근거_20261103/R515_NATIVE_INLINE_WIP_20261114/`.
- GitHub **feature branch** `feature/moa-r515-native-gallery-sticky-fill-rail-20261114`; source at `experiments/moa-r507/MoaR507InlineGalleryProvider.java`, `experiments/moa-r483/moa-r483-vertical-calendar.js/.css`. Never edit frozen R463 Golden source.

## R511→R515 exact source changes
1. **Native gallery continuity**: native provider no longer closes the original in-card Gallery after a transient invalid DOM snapshot; only intentionally closed day/form or confirmed lost ownership triggers cleanup. Unexpected native close with a pending active diary day invokes a guarded JS reconnect, max 2 retries per day (instead of immediate Web gallery/home). Never auto-revive after deliberate JS close. This reduces unintended web legacy fallback, but does **not** prove impossible on physical Android.
2. **Rail crop & collapse**: original 64dp native GalleryRail container retains full 46dp selected thumbnail + 8dp raised state; artwork is visually compressed to 79% vertical size. A small native right-edge `⌄/⌃` button toggles rail visibility; `moa.r515.card_ui/rail_expanded` SharedPreferences saves user choice. Video mute/play/seek, star, share, GPS, original info and fast stage actions remain. No R463 physics/event handler changes.
3. **Today**: calendar lower dock 40px, theme-linked button height 33px; 420px mock viewport button width 406px. Previous max-width 94px override superseded.
4. **Full-bleed in photo diary ONLY**: original native photo ImageView switches to `CENTER_CROP` inside the owned card; native video TextureView transformation uses `max` scale for center-crop (original fullscreen Gallery remains untouched FIT_CENTER). The source **does not reencode/compress** photos/videos. If source and card aspect ratios differ, filling without distortion crops some image edges. Extreme widescreen media may crop significantly. No false guarantee of all visual content.
5. **Original Gallery freeze**: R515 changes only four archive members vs original-signer R511: `AndroidManifest.xml` code511→515; additive `assets/web/moa-r483-vertical-calendar.js`; additive `.css`; supplementary `classes18.dex`. All **17/17 original R463 DEX** and original NAVER/diary/media/voice owner bits exact bytes. R517 only Manifest changed vs R513.
6. HTML/JS native fallback no new database schema, no migration, no data clearing.

## Build, QA and limits
- GitHub Actions Android SDK35 javac/D8 R515 compile **PASS**, latest run **43530156379**, source DEX `classes18.dex` size **25,136 bytes**, SHA256 **`09e61a1931386f892bd1b4b82292395fad77e7fa712c18f5c3cbd39f9b2b3ba3`**, source SHA **`9113ae6e1b1d0ba1ab6b0ea57746eaef2ca5a5355cd3ddef2994608365abad29`**; exact local source hash matched CI manifest.
- Independent APK v2 original RSA/cert signature + full content SHA256 digest and ZIP CRC + stored-entry alignment **PASS** both R515 and R517. All 18 DEX headers SHA1/Adler PASS and original 17 DEX bytes unchanged.
- Synthetic Playwright Chromium **pink/peach/white/black** at 420x870: fixed one weekday row, Today 406x33, native bridge unexpectedly closed synthetic callback schedules same-day re-arm, no JS errors PASS.
- **NOT TESTED on real Galaxy after R515 build:** native host retaining state through NAVER external trip and hours of browsing, real video image transform, native rail show/hide mid-video, existing standalone R463 Gallery, original GPS route, sound/capture, heavy 14k-photo runtime, hardware Back, heat/perf and phone recipient link opening. Do not call physical PASS, finished product, new Golden. This is a LAB candidate and rollback-safe static build, not risk-free.
- Never uninstall or wipe data/IndexedDB/NAVER cookies/logins/media. User should install only over same package/cert with installed versionCode<515; R517 is emergency recovery only. No AirPods changes.

## Mandatory physical acceptance next
1. Open original standalone advanced Gallery before and after photo-diary test, verify smooth swipe, pause/mute, volume bubble, capture, GPS/NAVER map, information, cover and Android Back unchanged.
2. Photo diary: repeated day entry/exit, rapid scroll, leave for NAVER GPS/map and return, inspect no unexpected old Web gallery, no fullscreen flash or stale native ghost.
3. Native photo/video full-bleed: no stretched pixels, check important edges are not cropped more than acceptable. Cropping is inherent to different aspect ratio; if unacceptable, add future fit/fill per-media switch, default fit for high ratio mismatch.
4. Native rail: selected thumbnail top not clipped; tap right-edge arrow to collapse/expand; video playback/seek and upper stage remain functional in either.
5. Main calendar Today full-width thumb button, one sticky weekday row, both modes; diary story, voice record and family schedule remain.

**If R515 issues occur**, do not delete app. Use original signer R517 exact R463-function emergency if serious regression. Record real device FAIL evidence, never mark Golden. Next candidate >517 after rescue installed.
