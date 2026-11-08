# MOA R209 — exact reference muted speaker, reversed buttons, saved toast removed (2026-11-09)

## Status
**SIGNED ORIGINAL-CERT UPDATE APK + BYTE-IDENTICAL ZIP FALLBACK CREATED; INDEPENDENT STATIC PASS. USER'S GALAXY R209 INSTALL/UX NOT YET TESTED. R209 IS BETA, NOT GOLDEN.**

## Direct source of change
User screenshot `1794180271806.png` shows the exact Samsung Gallery muted speaker silhouette. Private video `19777.mp4` shows R207 buttons and duplicate success toast. User explicitly requested (a) left speaker/mute, right capture, with existing actions unchanged; (b) the exact visual muted speaker glyph, not an approximated separate stroke; and (c) no successful capture toast, because the saved-photo thumbnail confirms success.

Native file `experiments/moa-r175/MoaNativeGallery.java` on source branch `feature/moa-r209-exact-muted-icon-swap-capture-no-toast-20261109`:
- Swaps only visual placement: left container gets existing `mute` view, right gets existing `still` capture view. Listener objects, mute/capture methods and center play/time capsule remain intact.
- Extracts ONLY the 72×73 px white/transparent mute icon silhouette from user-supplied reference screenshot, strips photo/background pixels and embeds its 1376-byte PNG as a Base64 code constant. The existing native view draws this exact alpha-only icon for the muted state (`♪` legacy state marker); unmuted speaker state retains its working icon. No personal photo or personal media was committed to GitHub.
- After successful capture, shows only existing clickable tiny photo preview; removes redundant `장면을 사진으로 저장했어요` Toast, retains actual failure Toast. Saved thumb moves to right ABOVE newly positioned capture button. Tap opens saved-photo overlay, Back returns to exact video/position/previous play state as in R207.
- R203 OverScroller kinetic inertia, R207 selected thumbnail lift and slim audio slider, M4A/diary/video/backup assets remain unchanged.

## Exact signed release
- Same package `com.juhyeon.familyjournea`, versionCode **209**, original signer cert SHA256 **`5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`**.
- APK: `MOA_R209_EXACT_SAMSUNG_MUTE_SWAP_NO_TOAST_BETA.apk`, **5,720,522 bytes**, SHA256 **`2491d7cb23f0980c41ec9d09a46a77dcc70d12a567a8b5de135b9e5061451321`**.
- ZIP with identical APK, QA JSON, install README and SHA256SUMS: `MOA_R209_APK_BACKUP_WITH_QA_20261109.zip`, **5,389,054 bytes**, SHA256 **`657f960bdfea1ee932cc0209a21fbfa8e9fbe3e371a1f127da9718fb2190be9b`**.
- Private Library files: `/모아_프로젝트_근거_20261103/MOA_R209_EXACT_SAMSUNG_MUTE_SWAP_NO_TOAST_BETA.apk`; `/모아_프로젝트_근거_20261103/MOA_R209_APK_BACKUP_WITH_QA_20261109.zip`; `/모아_프로젝트_근거_20261103/MOA_R209_RELEASE_QA_20261109.json`.
- Build baseline signed exact R207 SHA256 `60f5227268617bab2b1d13136a5edce3d895de5be96812d7c1147070b8c999ea`; **126/128 identical original APK member payloads**. Only binary `AndroidManifest.xml` (versionCode207→209) and compiled `classes6.dex` change.
- Android SDK35 native javac/d8 CI **42535692068 SUCCESS**, artifact **13638837648**, compiled classes6 DEX SHA256 **`c43a31d6ac5b5e243f5454fb6d7df57483ffb16fa307c9a204da2ed71ef16125`**; Java source SHA256 `96e6a527a65dc2e951c2d190fe9e506cd3446c009b0d7d23a96afc69dbadddfc`.
- Independent no-key public verification: APK Signature Scheme v2 RSA PKCS1 SHA256 signature verification + full APK signed-content digest, ZIP CRC 128, alignment for STORED entries, all DEX header SHA1/Adler32 and signer cert continuity PASS. ZIP contains the exact APK SHA256 matching direct download.

## Emergency recovery
Prepared **emergency-only** signed R210 code-forward restoring exact R207 feature payload; private `MOA_R210_EMERGENCY_R207_FEATURES_CODE_FORWARD_ONLY.apk`, SHA256 `c6e99f25878fa9b2985493d34cd571ea9729c79d20e5823052d9828e11228a6a`, 127/128 R207 payload entries unchanged (Manifest only), same original signer, independent v2 static PASS. Matching ZIP `MOA_R210_EMERGENCY_R207_FEATURES_BACKUP.zip` SHA256 `d8defc74b7b8a84908d96e1f3d9aac0dcd423d2c30ea5d68cd42f1f6e9ceda8c`. **R210 has not been device-tested; not for routine install.**

## Preserve old Goldens and QA scope
R203 scoped user-approved gallery Golden SHA `6d85add0d0d97b08e90cec1fc13923cfa49faea1af66907350eb1f54a2b2c6a7` and R187 older scoped Golden SHA `4380ca0a421c3a12cfad0334e860e659112b116f6cc7099f8989475c646a97e9` remain protected. No AA AirPods Android Auto source/daemon/routing touched. Never uninstall/clear app data or replace signer; update-install only.

## Actual Galaxy R209 QA open
1. Left sound/mute, center play/time, right photo capture with EXACT Samsung screenshot white muted glyph.
2. Tap capture -> saved preview above RIGHT button; **no extra success Toast**; tap thumbnail -> photo full screen; Back -> same video, media time and autoplay state.
3. Mute/unmute actually toggles audio and sound slider remains correct.
4. R203 multi-item inertia, R207 selected-only thumb lift, image/video swipes, scrub, M4A/diary/backup data no regression.
Real-device successful installation and visual equivalence are **not proven by CI**.
