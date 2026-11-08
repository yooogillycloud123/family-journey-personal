# MOA R187 — FIXED FILMSTRIP BASELINE + SHARP COALESCED NATIVE VIDEO SEEK (2026-11-08)

## Physical observation & scope
- User confirms **R185 installed, operates, and video filmstrip actually seeks** on Galaxy. R185 is **user-verified scoped success**, but remaining moving bottom thumbnail height and soft-to-sharp video scrubbing were observed in user-provided private `19487.mp4` (43.27 s, 1080×2340, 120 fps source). Do **not** elevate R185 to feature-complete Golden. R177 prior limited Golden SHA `c6b4b8d21742370b3e59758ffbe1a715e598a5d3911ab6c8af5050a6b2789b30` and older R163 Golden remain immutable; R179 user-tested preserved.
- This is a **NEW SIGNED R187 BETA, DEVICE NOT TESTED**. No Samsung-equivalence/120fps claim. Private video and Samsung proprietary APK/code never uploaded. REA/Ghidra/JADX provider unavailable; prior Samsung APK static class-ref scan and user's screen recordings are references, not direct code copying.

## Code root cause
- Previous `MoaNativeGallery.updateChromeLayout()` changes `lowerControls` height by mode: 72dp for photo, 165dp for muted video, 201dp for unmuted video. The `GalleryRail` was the last child in a variable-height vertical panel; every show/hide or mute operation moved the thumbnail rail even though the image/video stage had been fixed.
- Previous `showScrubPreview()` took a tiny `getScaledFrameAtTime(...dp(72),dp(72))` filmstrip frame and assigned it to a **full-page** ImageView during scrub. The full-page upscaling caused obvious blur, and on release it disappeared to reveal the crisp native video.

## R187 changes (only native Gallery file, not other app functions)
1. `lowerControls` is an overlay with constant **208dp layout height**, transparent parent and individually translucent tinted controls. A weighted non-clickable `android.widget.Space` is inserted before playback/seek/volume rows; the GalleryRail itself is **always 72dp at the bottom**, with no vertical displacement between photo/video/unmute/scrub modes. Hiding chrome hides the whole overlay; the full-stage image/video surface remains unchanged. Media controls overlay the video, not push the filmstrip.
2. Never mount the low-res `scrubPreview` ImageView over the full video. Keep low-res thumbnails only in small strip tiles. Use actual native `TextureView/MediaPlayer` decoding for full-size sharp video preview.
3. The filmstrip drag changes desired milliseconds, and real `MediaPlayer.seekTo(SEEK_CLOSEST)` is queued/coalesced at a bounded pace with **at most one in-flight seek**. On completion request the latest desired time, avoiding seek floods; on release apply final time then restart playback only if previously playing. Cached strip thumbnails still update independently on a single worker. Video rail ticker 80ms vs previous 300ms when time-strip mode active.
4. R185 direct video-thumbnail access, R179 photo EXIF/volume slider/frame save, R177 long-press floating nav, Diary IndexedDB, map, calendar, sound and Android Auto/AirPods project all untouched.

## Release and safeguard
- **Signed code187** package `com.juhyeon.familyjournea`, **5,655,113 bytes**, SHA256 `4380ca0a421c3a12cfad0334e860e659112b116f6cc7099f8989475c646a97e9`.
- Baseline exact signed R185 SHA256 `14ccee98b35e858b80821cfa1093f568a7ac99cd92fe8d3c9cf8b2b28599098f`. ZIP members unchanged **126/128**; only `AndroidManifest.xml` code185→187 and `classes6.dex` changed.
- Original signer certificate SHA256 `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`; independent APK v2 signature + complete signed digest, ZIP CRC + 4-byte alignment, native DEX checks PASS.
- GitHub source branch `feature/moa-r187-fixed-rail-live-video-seek-20261108`. Isolated Java17/Android35/d8 CI run `42442253775` SUCCESS, compiled DEX **109,004 bytes**, SHA256 `2679eb3fa200cd8d4b9603c1302f513d903fbb9f4f51d1814730fe0489c53d7d`, artifact `13602475274`. Isolated native compile is not full clean Gradle build and not physical device QA.
- Private signed APK and QA report in Library `/모아_프로젝트_근거_20261103/`.
- **R188 emergency-only forward restore of R185**: code188, 5,654,093 B, SHA256 `80a192fef8a29cbe80857508f4ecf0415af27d1f3f9802470bc472d90dc247ee`, 127/128 members exactly same as signed R185 and only manifest version changed. Same signer and independently verified v2/ZIP. **Never routine install; never uninstall or clear app data**. Real-device emergency restore unverified.

## Real-device acceptance (pending)
1. In-place install R187 over R185, no uninstall/no data clear. Open photo→video→photo, switch mute on/off, enter/exit time-strip, show/hide controls: the bottom filmstrip tile baseline must not shift vertically.
2. Drag an original 31s video scrub strip through beginning/middle/end; compare full-resolution frame clarity DURING dragging and final seek accuracy. On a slow HEVC device, decoder may pause briefly; expect no 72dp-upscaled blurred full-stage preview. Audio resumes only if previously playing.
3. Tap image to hide/display chrome; video/photo display scale must remain fixed. Check seeking while paused and playing, mute/volume slider, frame capture, photo EXIF.
4. Repeated 10+ rapid gallery transitions, day/month, floating rail long press, GPS, diary, voice files. Original data unaffected.
5. Only after physical device acceptance consider Golden promotion. Further measured jank/performance optimization might require MediaCodec pipeline tracing and decoder frame pacing; never claim exact Samsung proprietary engine equivalence.
