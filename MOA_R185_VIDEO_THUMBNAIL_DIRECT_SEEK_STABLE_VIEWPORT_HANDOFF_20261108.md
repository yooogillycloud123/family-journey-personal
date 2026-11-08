# MOA R185 — Corrected direct filmstrip seek, fixed media viewport (2026-11-08)

## Read first: real device status
- **R185 SIGNED STATIC BETA — USER DEVICE INSTALL / PERFORMANCE / SEEK NOT YET TESTED.**
- Latest user tests R181 via private `19479.mp4` and `19480.mp4` show: photo/video viewport size jumping on chrome/mode changes, bottom filmstrip perceived as uneven, '영상 탐색' unwanted, frame preview moving without reliable playback seeking, plus media playback error in R181 demonstration.
- In the same session R183 initial signed APK was briefly shared, but additional code review found a **real player-preparation omission** after a strip drag that lands on video. **R183 SUPERSEDED; use R185 instead.** R185 also fixes this edge condition and has separate higher versionCode.

## Exact signed APK R185
- Package `com.juhyeon.familyjournea`, versionCode **185**.
- Size **5,654,093 bytes**; SHA-256 `14ccee98b35e858b80821cfa1093f568a7ac99cd92fe8d3c9cf8b2b28599098f`.
- Same original signer cert `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`.
- Exact signed R181 base SHA `50d745ebdd8848a4f8f9b5d8fb91915a7516f31e3a7695ad5d6a1988f631a7c3`: **126/128 zip member payloads unchanged**; only `AndroidManifest.xml` (181→185) and `classes6.dex` gallery code change. All JS/other DEX/IndexedDB/photo backups/voice/GPS/map and unrelated AA unchanged.
- Independent ZIP CRC+alignment, APK v2 signed data RSA + full signed content digest, signer certificate continuity, DEX SHA1+Adler checks **PASS**.
- GitHub `feature/moa-r185-final-video-prepare-safeguard-20261108`, isolated javac+d8 CI run `42439652030` SUCCESS; DEX **107,984 bytes** SHA-256 `e800cdf571db5b405c12c4edcf97b0d452edac37cd4728a8e81bdf23d5ceb718`, workflow artifact `13600553317`. Isolated compile is not a full clean Gradle APK build.

## What actually changed
1. **Stable composition.** Native full-page photo ImageViews and video TextureView occupy the same full-stage rectangle at all times. Hide/show of header, playback controls, bottom rail and system-volume controls only toggles overlays; no change in top/bottom stage margins and no Android system-bar flag/window-inset relayout triggered by a tap. This avoids the proven R181 zoom/size jump cause.
2. **Filmstrip alignment and movement.** Original photo/video thumbnails use one constant 46x52dp tile geometry; deduplicated pending poster requests, photo page-ID reuse and fewer repeated player resets reduce flickering/rebound.
3. **Video mode by *thumbnail*, not separate button.** Tap a video item in the mixed-media bottom strip (including selected video). It becomes its own duration-time filmstrip; no default '영상 탐색' button. A small `‹ 목록` control returns to the mixed gallery.
4. **Actual seek.** During time-strip dragging, selected time/readout/decoded frame preview tracks finger. Exactly once on release, call Android MediaPlayer `seekTo(targetMs, SEEK_CLOSEST)`; on asynchronous `OnSeekComplete`, reveal actual video and resume only if previously playing. No more 150ms seek queue flood that can stall decoder. Seeked position may be bounded by codec keyframes/performance on device; real Galaxy gate pending.
5. **R185 edge-case correction.** If bottom image rail drag lands on an already-current video while the preview player is absent, now prepare the MediaPlayer before opening time mode. Also preserve R179 EXIF, system media-volume slider, on-screen capture, R177 movable rail.

## User Samsung APK inspection vs unavailable REA
- Private Samsung Gallery APK `갤러리-15.9.01.7.apk` 61,617,593 bytes SHA `fc552aa41255d1e9fefffb7a9b72824ffaa83c2f655a7bcf4cc6310542deea34`. Local DEX class reference scan (not a method-level REA tool): `com.samsung.android.gallery.widget.filmstrip3.FilmStripLayoutManager`, `VideoSearchView`, `app.ui.viewer2.container.delegate.film.FilmStripSeekerDelegate`, `widget.videoview.mediaplayer.MediaPlayerViewImp`.
- REA MCP provider/headless JADX engine not connected to this session; do not claim to have executed REA method decompilation or copied proprietary code. Architecture independently built from observed screen recordings and Android public APIs.

## Golden, emergency
- User limited Golden R177 signed `c6b4b8d21742370b3e59758ffbe1a715e598a5d3911ab6c8af5050a6b2789b30` remains frozen. User-tested **R179** signed `70a1218650a210b5f0256a3910b705850919ce64c619b22a87588dccbfcd65c8` remains preserved. R185 NOT Golden.
- **R186 EMERGENCY ONLY**: same original R179 payload exact (127/128 ZIP members identical; Manifest code 179→186 only), same original cert; size 5,643,677B, SHA `a999e258e9de9c5dd3115fb5a3fb94d044ccb1e165367bde6b53f671b2af406f`, independent APK v2/ZIP PASS. R186 device install NOT TESTED, **never routine-install**; use only for confirmed R185 regression, in place, never uninstall/clear data.

## Physical Galaxy acceptance before Golden
- R185 update over current app without uninstall, photo/video switch show/hide chrome no size jump, bottom rail stays same aligned baseline with no bounce.
- Tap selected video thumbnail to enter time strip. Drag to three distinct timestamps (start/middle/end) and RELEASE, verify actual video frame & time, re-play, one Back, `‹ 목록` returns to photo/video rail.
- Repeated 10+ rapid photo/video swipes, short and HEVC/HDR video, mute/volume, frame capture, EXIF orientation, R177 long-press movable rail, full/day/month 700+ items and diary voice/map persistence.
- **No claim** that static compile/zip verify proves 120Hz smoothness, no glitch, exact Samsung proprietary behavior or future device test pass. Private user files/keys never published.
