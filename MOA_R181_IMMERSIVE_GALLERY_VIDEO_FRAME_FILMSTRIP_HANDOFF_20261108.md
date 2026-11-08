# MOA R181 — IMMERSIVE GALLERY + IN-VIDEO FRAME FILMSTRIP (2026-11-08)

## Status / exact source of truth
**SIGNED STATIC BETA, device install and real Galaxy touch response NOT YET VERIFIED.** Original R177 user-device *scoped* Golden remains immutable; user confirms R179 supplied APK working on Galaxy but has not expressly promoted it to separate Golden. Do not label R181 Samsung Gallery perfect/120Hz.

- Package: `com.juhyeon.familyjournea`.
- Exact signed R181 APK **versionCode181**, **5,651,625 bytes**, SHA256 **`50d745ebdd8848a4f8f9b5d8fb91915a7516f31e3a7695ad5d6a1988f631a7c3`**.
- Exact signed, user-tested R179 starting APK **5,643,677 bytes**, SHA **`70a1218650a210b5f0256a3910b705850919ce64c619b22a87588dccbfcd65c8`**.
- Same original signer certificate SHA256 `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`.
- 128 existing ZIP members preserved; 126 **payload bytes exactly identical** to exact R179 signed APK. The only changed files: `AndroidManifest.xml` versionCode179→181 and `classes6.dex` native gallery. The JavaScript/HTML/Diary IndexedDB, voice/M4A/STT, family calendar, GPS/map, and all other DEX/resources remain byte-identical.
- Independent APK signature v2 RSA + full content digest, cert, ZIP CRC/alignment, manifest version, DEX SHA1/Adler, exact archive diff verified PASS. **No actual PackageManager install test or Galaxy smoothness claim**.
- Native CI: `42437764337` job `gallery_dex` **SUCCESS**, artifact `13599917688`. Compiled exact new dex SHA256 `a3185cee4ef4a5e3848b30f6da445e95da15ebd386915e6134149fbc2e9b124b`, 105,516 bytes. The compiler test is an *isolated Java17+Android35+d8 build* of the native owner + gallery, **not** a clean whole-project Gradle APK rebuild.

## User evidence / gesture interpretation
User private video `19474.mp4` (~37 s, 1080x2340) contains MOA R179 at ~0-8 s and Samsung Gallery reference at ~11-35 s. Samsung Gallery tap toggles controls while photo/video stays visible and media navigation still responds to horizontal full-stage swipe. Video frame timeline is **a filmstrip of frames of the currently selected video**, not another list of separate media clips; dragging seeks that video's playhead. Video is private; no media screenshots, user recordings, image pixels or user coordinates pushed into public GitHub.

## R181 source changes
Source branch: `feature/moa-r181-immersive-video-frame-filmstrip-20261108`, only `experiments/moa-r175/MoaNativeGallery.java` changed versus R179. Existing `MoaMomentAudioHostActivity_native_unified_gallery.java.txt` unchanged.

1. **One tap stage = chrome toggle:** app top gallery header/buttons and lower controls/filmstrip hide together; stage margins expand to immersive edge-to-edge and system status/navigation bars hide; next tap restores original controls/bars. Fullscreen stage retains original 3-page gallery media swipe, native video TextureView playback, original photo pinch and double-tap zoom. No additional Activity. Existing single Back closes viewer; system UI flags restored.
2. **Two separately labelled filmstrip modes:** default `사진·영상 목록` navigates media items. On a selected video, button `영상 탐색` switches rail to video frames from **that clip**; button changes to `사진·영상 목록` for return.
3. **Video time-filmstrip:** native `MediaMetadataRetriever.getScaledFrameAtTime` prepares bounded (12–36) small image samples **off UI thread**, near current playhead first, with per-clip generation/cancellation checks. Only visible samples are drawn in an existing native Canvas rail. While dragging, the rail tracks fractional elapsed time; MediaPlayer seeks throttled every >=150ms, final exact seek on release, and previous playing state resumes. Existing traditional seekbar remains available in default media-list mode, but is hidden in video-frame mode.
4. **Existing R179 freezes:** EXIF-aware ImageDecoder full photos, stream music volume slider, muted video autoplay, same-Activity render, photo/video stage drag, native frame capture, same signer/package, app data and helper interactions unchanged.

## Emergency restore
**R182 emergency ONLY** signed from exact R179 original, with versionCode182 (higher than R181) and **127/128 ZIP members byte-for-byte identical to R179**, changed only binary Manifest version. Size 5,643,677 B SHA256 **`cfbd9367d0f551354c22ff682e1069f3e54ec8888f749f020fa76ccf069a627e`**. Same certificate and independent v2/ZIP PASS. Restore is still DEVICE UNTESTED. Not for normal install; no uninstall/clear data. R177 GOLDEN unchanged, R179 tested base unchanged; R180 emergency was R177 only, lower code cannot roll R181 forward.

## User acceptance tests / feature status
1. In-place install R181 over R179, **never uninstall/reset**. Screenshot/video 19474 target: photo tap -> toolbar/rail disappear, full media stage expands; tap again -> show. On fullscreen photo and video, swipe next/prev.
2. Video displayed -> button `영상 탐색` -> **frames from same clip** populate filmstrip. Drag horizontally to different timestamps with visible time label; final time playable; tap `사진·영상 목록` returns to separate media items. Handle very short videos and long video, loop between videos without stale frame previews.
3. Verify pause/resume/mute/unmute/volume slider/seek/scene save; photo correct orientation, pinch zoom, one Back.
4. Verify long-press XY movable diary rail, Calendar, Diary private data/IDB, original M4A/STT, GPS/maps, camera capture; giant 700-photo date/month performance and no thumbnail flooding.
5. If regression, apply R182 **only after user-approved emergency**. Do not call R181 Golden on compiler evidence.

## Download and privacy
Exact signed R181 APK is in current chat and private Library; ZIP fallback contains identical signed APK. Do not claim download verified on user's phone unless user confirms. Never upload signer keys, private videos, photo frames or personal files to public GitHub. AA AirPods/Android Auto project and its Golden untouched.

## Next chat
After full AA Canonical read, read this R181 handoff, R177 Golden lock, R179 handoff, release ledger and WIP checkpoint; use frozen signed R179/R177 byte hashes, not an incomplete public Android full build. Continue from R181 test findings without restarting from scratch.
