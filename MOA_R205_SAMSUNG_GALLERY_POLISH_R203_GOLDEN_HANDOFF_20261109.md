> **2026-11-09 PERMANENT APK+ZIP PAIRED DELIVERY MANDATE:** For ALL future MOA APK releases, betas, and emergency builds, publish/download **two verifiable files together**: (a) a direct signed same-package APK and (b) a self-contained ZIP fallback holding the **byte-identical APK**, plus installation README and release QA/checksums where available. Validate ZIP CRC and that extracted APK SHA-256 matches the direct APK before reporting. Give the user both actual downloadable links in the **same final response**; never rely solely on a Library attachment, because user observed `Library file not found` from a former APK-only link. Do not fabricate paths or mark unavailable builds delivered. Preserve signer, update-install, app data, immutable Golden; never place private keys, user diary/family media or secrets inside the ZIP. The user must not need to repeat this request. R205 ZIP created `MOA_R205_APK_WITH_BACKUP_20261109.zip`, 5,385,409 bytes SHA256 `f42d472a2967b13d25facc13254230a9994a7fade050b51aef2eb02356213739`; verified contained APK SHA256 `8f9f82208b58b504caae7bea44e1d32d5f5a6179b20dd87b5118b66d1cc3e3fb` equals separate R205 APK. Private Library copy `/모아_프로젝트_근거_20261103/MOA_R205_APK_WITH_BACKUP_20261109.zip`.

# MOA R205 Samsung Gallery native controls and inertial thumbnail wave — signed beta handoff (2026-11-09)

## Exact status
**A real original-signer update APK has been built and independently statically verified. Galaxy real-device R205 QA NOT DONE; R205 NOT GOLDEN.** User confirmed R203 satisfaction, so R203 is newly archived as separate scoped user Golden; R187 Golden remains intact.

## Exact artifact / lineage
- Signed APK private Library `/모아_프로젝트_근거_20261103/MOA_R205_SAMSUNG_GALLERY_POLISH_BETA.apk`.
- Release QA private Library `/모아_프로젝트_근거_20261103/MOA_R205_RELEASE_QA_20261109.json`.
- Package `com.juhyeon.familyjournea`, versionCode **205**, size **5,714,031** bytes, SHA256 **`8f9f82208b58b504caae7bea44e1d32d5f5a6179b20dd87b5118b66d1cc3e3fb`**.
- Same original signer cert SHA256 `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`. Independently checked APK Signature Scheme v2 RSA verification and whole-file signed content digest.
- Exact signed R203 baseline SHA256 `6d85add0d0d97b08e90cec1fc13923cfa49faea1af66907350eb1f54a2b2c6a7`. **126 of 128 APK ZIP member payloads byte-identical**; only `AndroidManifest.xml` versionCode203→205 and native `classes6.dex` changed. All 7 DEX SHA1/Adler, ZIP CRC, 39 stored entry 4-byte alignment, `resources.arsc` integrity PASS. No web diary/voice/backup assets modified.
- Exact native Java/d8 CI GitHub run **42531454920 SUCCESS**, artifact **13637527874**, compiled `classes6.dex` SHA256 `37e862339bcbbb59759f6306b2d4641a2c4d0355548ffe446d2146ea3e24e07d`, original native source SHA256 `8e492ec15cd30cf076a38a7f2b3ada5dfc5f07145323283bc3a32dc97789f92c`.
- Source development branch `feature/moa-r205-native-gallery-polish-wave-feedback-20261109`, only native `experiments/moa-r175/MoaNativeGallery.java` plus its CI trigger workflow. Branch head `81e6e3ea99ed174d2e4141f13ad2098c5b9580a5`.

## Implemented
1. Native video controls: frame-capture/mute circle **32dp** instead of 37; center play-time pill **136×34dp** instead of 154×40; consistent 11sp time. Stronger outline on dark button surfaces. Center parent owns click across icon, elapsed, total (avoid children swallowing touch).
2. Native Canvas capture icon changed from four corner brackets to framed-image/landscape icon. Mute is conventional speaker-plus-slash or sound waves, no musical-note symbol.
3. Bordered native `RippleDrawable` and 75ms press shrink / 145ms spring-back, non-consuming touch listener to retain click semantics.
4. After a **real successful saved MediaStore frame** (not on button press alone), show small actual image confirmation over left capture button with zoom/fade and automatic cleanup; failed capture shows prior error toast.
5. Bottom thumb rail retains exact R203 OverScroller fractional-index inertia and adds local Y displacement of nearby thumb cards: Gaussian lift plus damped traveling wave, roughly 260ms decay. Parent bottom rail and main stage Y positions remain fixed, preserving R187 non-bouncing rail.

## Required Galaxy QA / limitations
- On Galaxy S26 Ultra compare native icon/button size and appearance with actual Samsung Gallery capture/mute/playtime controls.
- Tap *everywhere* inside play-time pill and confirm exactly one toggle; observe color ripple and press scale on all three buttons.
- Press capture during playing video: saved image appears briefly immediately above capture control and the image exists in `Pictures/MOA-Video-Captures/`. No popup on failure.
- Fast/slow stage and bottom rail swipe through varied photo/video: R203 momentum and deceleration must still work; wave local thumbnails up/down while bottom rail remains fixed; no blank page/jerk; pinch zoom and video playback/scrub not regressed.
- Verify diary, recorded M4A, linked memos, backups, data intact. Only after user device verification may the scoped R205 feature status change.
- Note that “same as Samsung” is visual/interaction target, **not proprietary Samsung source copied or physical equivalence already proven**.

## Hard rules / recovery
No uninstall/data clear, no signer change, no moving keys, no private family images on public GitHub; no AA AirPods/Android Auto code change. R203 scoped user Golden remains archived, R187 separately frozen; emergency code-forward rollback, if needed, must be separately signed and checked, not a downgrade over installed version 205. Never represent isolated DEX artifact as an APK.
