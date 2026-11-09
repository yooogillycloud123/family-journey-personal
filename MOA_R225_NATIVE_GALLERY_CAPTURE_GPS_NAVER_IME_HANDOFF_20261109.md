# MOA R225 — Restore capture time/GPS/address/Naver navigation in native gallery; hide memo backup hints while keyboard open (2026-11-09)

## Status / immutable baseline
**Original-signer, same-package, higher-code R225 APK built and independently statically verified. ZIP contains exact identical APK; Android SDK35 native Java/D8 compilation and source contracts passed. Galaxy R225 on-device visual, map GPS/navigation, keyboard resize QA has NOT been performed. R225 is BETA, not a Golden.**

User evidence: private `19902.png`, `19905.png`, `19907.png`, and user explanation. R223 quick memo while Samsung keyboard is visible still exposes `음성 녹음은 원본 파일과 글을 함께 남겨요.` and the top sliver of `녹음 보관·백업 설정`, leaving a gap between editor and action footer and inconsistent surfaces. User also observed former top gallery capture date/time + real GPS/address + direct Naver Map navigation missing after transition from legacy Web full-photo viewer to R175–R223 native Gallery; header back/menu sometimes not responsive.

### Confirmed root of metadata regression
- Already-existing `assets/web/moa-r121-ui.js` R121/R123 `attachGallery()` adds `#moa-r121-photo-info` **only inside legacy DOM `#fj-naver-photo-full`**.
- R211 Map/Diary entry routes were switched to `MoaLocalAudio.openNativeGallery`. Its separate all-native `MoaNativeGallery.open()` renders only date passed by caller (may be album/day), index/count, back and menu; the legacy JS DOM info header cannot appear on a native `FrameLayout` above the WebView.
- R225 preserves original Web overlay files and restores equivalent information in the native viewer, asking the already cached diary index for capture time and `FamilyJourneyExtension.getData().photos` for GPS, with MediaStore `DATE_TAKEN`, EXIF `DATETIME_ORIGINAL`/GPS, and video metadata location as read-only on-device fallbacks. Does NOT claim coordinates when none are readable. Reverse address lookup uses Android `Geocoder` off UI thread. If GPS is inside Korea bounds, `지도 보기` opens HTTPS Naver Map search with the actual address/coordinates, letting Naver's existing save/favorites/nickname workflow remain unchanged. No photo/GPS is sent to GitHub.
- Fixed native metadata info card **overlays** the top at y=50dp; stage remains the exact prior fullscreen `stagePos.topMargin=0, bottomMargin=0`, 72dp lower inertial rail fixed. Photo bitmap zoom/pan, one-step top swipe, selected-thumb lift and video playback preserved. Meta requests coalesced by media ID + incrementing token; stale geocoder callbacks cannot update a newer image.
- Explicit `backButton.bringToFront();menuButton.bringToFront()` with fixed elevations; native buttons retain original close, menu, share/detail actions.
- Note: metadata absent due to original EXIF permissions or missing indexed GPS will correctly show unavailable; no fabricated address. Physical test needed to verify real device GPS access.

### Keyboard cosmetic repair
- Native helper `MoaR217MemoPolish.java` uses Android30+ IME visibility plus layout fallback; hides only help caption and **the collapsed backup toggle** while IME visible; restores them when keyboard is dismissed. All backup checkboxes/buttons persist in hidden fold and remain operable when keyboard closes.
- Raises EditText minimum height to use remaining visible `ScrollView` viewport and aligns footer card with editor via unified off-white `PALE`, pink border `EDGE`, same 16dp margins and fixed original action heights; footer brought in front to prevent clipped top stroke.
- Retains original `classes7.dex` R223 speech start→stop→final text callbacks, M4A recording/playback and Diary Save; no change to button callbacks or text contents.

## Exact signed files
- `com.juhyeon.familyjournea` versionCode **225**, original signer cert SHA256 `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`.
- Direct `MOA_R225_GALLERY_METADATA_IME_LAYOUT_BETA.apk`: **5,766,164B**, SHA256 **`628e40a2fc052eecf1ddf4692f8190c8bbfdc5e987865567d247df08714594e5`**.
- Matching `MOA_R225_GALLERY_METADATA_IME_LAYOUT_BACKUP.zip`: **5,418,437B**, SHA256 **`66a5efb4501246694d621b0cf88057c9cf76419eb28bf6a49f0e8b93bb2dbacc`**, ZIP CRC PASS, contains exactly bit-identical direct APK + QA JSON, README and SHA256SUMS.
- Input exact signed R223 SHA256 `3eb15ad3d13cee1c95f5701aae8a8887eda3f6ac7128c1ec79a3c375cc1a73b6` (code223). **127 of 130 original APK member payloads exactly unchanged**; only `AndroidManifest.xml` version223→225, `classes6.dex` (native gallery and preserved audio host), `classes9.dex` (native memo presentation) changed.
- Other 7 DEX, especially original `classes7.dex` speech start/stop, and `classes8.dex` 8-axis popup completely byte-identical. All JS/Diary/Map/Naver/MediaStore-related web, photo, audio and backup assets unchanged.
- APK v2 independently verified original signer RSA PKCS#1 SHA256 and **whole signed APK content digest**, ZIP130 CRC, all 9 DEX SHA1+Adler, 4-byte alignment of STORED ZIP members PASS. Replaced only the `MoaNativeGallery*.smali` classes in original classes6 smali and rebuilt with Apktool2.10.0; other classes6 smali sources protected.
- Android SDK35 native `javac`/D8 CI **42569739156 SUCCESS**, compiled Gallery DEX SHA `b625d3d394e38e85e4bc95632e17f310c311c74d3789a2877f38df450e3b8b3a`, memo DEX SHA `92814865e9f7089d3cff6aa09132ff4d99faebac30326d68ddd54acb9e2c90d7`. Source branch `feature/moa-r225-restore-native-gallery-metadata-compact-ime-20261109`, native source `experiments/moa-r175/MoaNativeGallery.java`, memo `experiments/moa-r225/MoaR217MemoPolish.java`.
- PRIVATE Library backups `/모아_프로젝트_근거_20261103/`: signed APK, identical ZIP, QA, exact sources. Never upload signing key, user images, diary or actual GPS to GitHub.

## Physical QA required — DO NOT call final/GOLDEN yet
1. R223 installed first → update install R225, no uninstall/data deletion. Check 19902/19905 quick memo keyboard displayed: help and backup toggle not visible; input fills the visible editor area; footer top/side borders align and remain tappable. Hide keyboard: collapsed backup toggle returns, original settings work.
2. Open same GPS-tagged photo from diary and Map with Settings OFF. Header shows actual capture date/time, address resolved or GPS fallback, `지도 보기` opens Naver at that location. GPS-absent images must not show fake coordinates; check EXIF permission differences.
3. Swipe fast/slow: upper stage one step, lower filmstrip inertia with full photo following, selected-thumb lift, date/address updates per selected photo without moving canvas; photo/video mixed. Back/Menu tap even during metadata lookup. Naver external app → Back to same selected media.
4. Confirm original R223 dictation stop/toggle, saved M4A, backup, quick record floating resize and album/Diary/map no regressions.

Preserve user-scoped R219, R209, R203, R187 Goldens. Do not modify AA AirPods/Android Auto daemon/audio routing. Always deliver original APK and verified same-byte ZIP together; never uninstall, clear app data, change signer or downgrade.
