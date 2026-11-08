# MOA R177 — native gallery and movable scroll rail (2026-11-08)

## Exact release status
- **SIGNED STATIC PASS, DEVICE INSTALL/UX NOT TESTED**. This is a BETA, not Samsung Gallery parity, not a new Golden.
- App: `com.juhyeon.familyjournea`, versionCode `177`; 5,640,225 B.
- Exact APK SHA256: `c6b4b8d21742370b3e59758ffbe1a715e598a5d3911ab6c8af5050a6b2789b30`.
- Original signer cert SHA256: `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`.
- Baseline **exact signed R173** SHA256 `bbbb051a7dda2368d39eb3aee35c96194129d0a6d78771192dd6c2b2e4ab6990`.
- Diff R177/R173: 123/128 exact ZIP entry payloads unchanged; changed only `AndroidManifest.xml`, `classes6.dex`, `assets/web/family-diary.js`, `assets/web/moa-r133-diary-unified.js`, `assets/web/moa-r141-monthly-report.js`.
- R163 immutable user-device basic Golden SHA `f789a3a579102bfb34a77da11be9b99b18b54906527c428603885bbd130e68e1` **untouched**.
- No change to AirPods/Android Auto audio project.

## User evidence and objective
Private videos `19400.mp4` Samsung Gallery and `19427.mp4`/`19443.mp4` MOA show the target gap: Samsung-like physically continuous swipe, in-view muted autoplay video plus play/pause/mute/seek (without separate video Activity), and genuinely draggable upper/lower arrow panel by long press in any XY direction. Private videos and Samsung APKs are not copied into GitHub; Samsung proprietary implementation is not imported.

## Native gallery
- Latest R175 isolated native Gallery build, GitHub Actions run `42429743708`, job `compile_gallery` **SUCCESS**, artifact `13597007343`. 94,116 B compiled DEX SHA `523d4bd8a585e933ffb1ae69d2ef67eb6f00f0996ec4d53c2b9e45d6111a2af7`.
- R175 `MoaNativeGallery.java` uses a single native Activity-overlay three-pane ImageView stage with prefetch, fractional filmstrip and native gesture animation, a `TextureView/MediaPlayer` for same-stage video, default muted playback, pause/resume, mute, seek, frame capture, double-tap/pinch photo, and Back close. MediaStore access is preflighted before hiding R173 WebView fallback.
- R175 day and monthly viewer JS call `openNativeGallery` first; legacy R173 viewer remains if preflight returns false. Real Galaxy 120Hz smoothness, codecs and permission compatibility unverified.
- Source branch `feature/moa-r175-native-unified-gallery-recycler-rail-fix-20261108` and isolated native compiled DEX are source/compile evidence, **not** full reproducible signed APK build.

## Rail pointer fix (R177)
- `family-diary.js` originally used HTML `.disabled` on boundary arrow buttons. Disabled buttons may stop pointer/long-press from reaching the enclosing rail, exactly when at top/bottom.
- Replace `.disabled` with `aria-disabled` visual state only. Both arrows remain pointer-receptive.
- Change child buttons' `touch-action:manipulation` to `touch-action:none`, including inline styles. Keeps long hold (330ms) and subsequent XY drag from being cancelled by browser scroll gesture.
- Preserve fast click top/bottom, rail position persistence, optional edge snap, auto-collapse preferences.
- App install/actual hold-to-move remains **PENDING**.

## Verification and protect/rollback
- Exact independently signed APK v2 RSA signature, signed-content digest, original signer, 128 ZIP-entry CRC/alignment, DEX SHA1/Adler, JS syntax: **PASS**.
- APK download in conversation available; user device install and user video comparison **PENDING**. Do not use the term FINAL.
- Emergency **R178** package same original R173 code with manifest versionCode178 only, 127/128 ZIP entry payloads unchanged, signed SHA256 `f9600f62efd70f1ea7aa7d5d0942f22964949aba843084d918bc51292d23f02c`, same cert, v2/ZIP PASS. **NOT routine install; only after a user-confirmed R177 regression.** In-place install only; never uninstall or clear data.
- Never publish signer/key/keystore or user media. Do not change AA audio project.

## Device acceptance
1. Install R177 as normal upgrade over existing app **without uninstall or clear data**.
2. Day/Monthly viewer, photo swipe and gallery strip: stage moves with finger, adjacent slides, no black gap/jerks; measure whether improvement actually visible.
3. Video encountered between photos: same activity, autoplay muted; pause, resume, mute, seek, capture, reverse-swipe and one Back.
4. Long press ANY upper/lower arrow for ~330ms, drag left/right/up/down, release to persist; short taps still jump top/bottom.
5. Previous photo/date/diary IndexedDB data, GPS, voice M4A/STT, monthly grid, calendar, map, capture workflow smoke gate.
6. On device regression use R178 only as explicit emergency forward-rollback; do not automatically deploy.
