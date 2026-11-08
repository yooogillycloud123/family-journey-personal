# MOA R207 — Samsung-reference selected thumb lift, captured-photo viewer, mute and volume (2026-11-09)

## Status and provenance
**ORIGINAL-SIGNER SIGNED APK + MATCHING ZIP CREATED, INDEPENDENT STATIC PASS. R207 DEVICE QA OPEN; NOT GOLDEN.** User uploaded private Samsung reference `19766.mp4`, MOA `19762.mp4`, and photo `19764.jpg`. Video contact sheets were inspected privately in a local runtime; user/family media and signing keys were NEVER published to GitHub. User observed that native Samsung's other thumbnails stay flat while only the chosen thumbnail pops up, whereas R205 moves neighbors in a wave. Samsung saved-capture popup can be tapped to open photo, and Back restores the video; Samsung speaker mute slash crosses the speaker body. User also requested a slimmer volume UI.

## Exact built R207 release
- App: `com.juhyeon.familyjournea`, versionCode **207**.
- Private Library APK `/모아_프로젝트_근거_20261103/MOA_R207_SELECTED_ONLY_CAPTURE_VIEWER_GALLERY_BETA.apk`
- Private Library ZIP `/모아_프로젝트_근거_20261103/MOA_R207_APK_BACKUP_WITH_QA_20261109.zip`, containing byte-identical APK, QA JSON and installation instructions.
- Private Library QA `/모아_프로젝트_근거_20261103/MOA_R207_RELEASE_QA_20261109.json`
- APK exact **5,718,287 bytes**, SHA-256 **`60f5227268617bab2b1d13136a5edce3d895de5be96812d7c1147070b8c999ea`**. ZIP SHA-256 **`7f088cdbdb738247f09a2d60fc0f1c11779be02ab08f0ebbc7e779e79990e4be`**, ZIP CRC and contained APK hash match PASS.
- Original signer cert SHA-256 `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`. Independent native public verifier validated APK v2 RSA signed data and full content digest; ZIP CRC/all STORED alignment and all DEX SHA1/Adler checks PASS.
- Based on R205 signed exact original SHA `8f9f82208b58b504caae7bea44e1d32d5f5a6179b20dd87b5118b66d1cc3e3fb`. 128 ZIP APK payload entries: **126 byte-identical**, only AndroidManifest code205→207 and classes6.dex compiled native changed. R203 Golden exact SHA `6d85add0d0d97b08e90cec1fc13923cfa49faea1af66907350eb1f54a2b2c6a7` and R187 Golden exact SHA `4380ca0a421c3a12cfad0334e860e659112b116f6cc7099f8989475c646a97e9` unchanged.
- Native source branch `feature/moa-r207-selected-lift-capture-preview-volume-20261109`, `experiments/moa-r175/MoaNativeGallery.java`, isolated Android35 Java+d8 CI **42534150846 SUCCESS**, artifact **13638147834**, DEX SHA-256 `d5480c9d9cad452fb65ea75e76340d028abac53ab3d19a6f9d8fa0e0c47895f1`, source SHA `be75959fecf3561cb7683d300b357805cf164b9cdfb7dfd183c423c8f973d486`.

## Functional differences from R205
1. Removed R205 neighbor Gaussian/sine thumbnail-wave Y offsets, excessive oscillation and decaying re-invalidation. `GalleryRail.r205Track` still follows exact same R203 floating index/OverScroller, but only `i==index` gets an approximately 8dp elevated tile which smoothly drops at fractional boundary; all other thumbnails remain level, video thumbnail markers follow selected thumbnail. Main media stage, 72dp fixed rail and existing video frame scrub unaffected.
2. Muted speaker glyph vector draws diagonal slash **through speaker body** instead of separate slash drawn to the right. Retained pressed ripple/scale and three compact buttons from R205.
3. Successful MediaStore captured photo popup receives real saved `content://` Uri, becomes clickable, opens a full-screen internal overlay with original saved JPEG decoded off UI thread, and intercepts system Back + visible back control. The original selected video index, player, mode, sound and seek position stay behind the overlay; playback pauses upon opening and resumes on Back only if previously playing. No external activity or photo-list jump, no data mutation beyond existing original save.
4. Replaced large rectangular black media volume row with slim rounded semi-transparent bordered capsule; compact percent text and tinted SeekBar thumb/progress, maintaining original Android MUSIC stream volume semantics (no automatic volume increase).

## Critical QA and limitations
Actual Samsung Galaxy install/taps **NOT TESTED**. Confirm R207 update-install without uninstall/data wipe, exact photo rise, 15+ item inertial swipe, photo/video switching, video seek at scene timeline, capture popup image appears and is tappable to open saved full photo, Back returns original frame/player, muted speaker look, volume pill feel, voice/M4A/diary/photo/backup unaffected. Full proprietary Samsung visual parity not asserted.

Emergency-only `MOA_R208_EMERGENCY_R205_FEATURES_CODE_FORWARD_ONLY.apk` private Library, code208, SHA-256 `30ec14e0b8d1d81f9f7d9ed28089db462b8f80f9bb560b2a482bedb2f547936f`. R205 features byte-identical for 127/128 APK members (manifest only higher version), original signer and independent APK-v2 verified. **R208 recovery itself not device-tested; never routine install**. No app uninstall, data clear, signing identity change, private data/key publication, or AA AirPods/Android Auto source edits.

Permanent delivery rule: ALWAYS provide verified paired direct signed APK + matching ZIP in the same response for every future installation candidate.
