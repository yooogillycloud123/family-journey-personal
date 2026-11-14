# MOA R582 P0 R580 physical regression correction + R583 exact R567 emergency (2026-11-15)

## Physical user video and root cause
- User provided `22064.mp4` after R580 install: photo calendar opens; Web photo/card exists, but the **native original gallery, filmstrip and eight actions are missing**. This is a user-device FAIL; do not treat R580 as usable or golden.
- Compare exact source `R580` `experiments/moa-r507/MoaR507InlineGalleryProvider.java`: in `attachCard()`, R580 added `r580PhotoPending=!currentId(gallery).startsWith("v") && !actualMediaReady(gallery)` and sets **ENTIRE original native host INVISIBLE** if true. In `r572FinishEntry()`, R580 added the same check and returns without original `__moaR507NativeMounted(true)` ACK. The `actualMediaReady()` helper checks `images[1].getDrawable()` for photos. It is not a safe condition for the whole native Gallery mount; drawable may not be ready, selected media may be provisional, and original Gallery can use different visible image slot. R580's JS also hides Web fallback controls while native entering. This explains missing native controls and rail while Web photo persists; the exact image slot status on the Galaxy has not been separately probed.
- Regression is **in the new R580 Java mount gate, not loss of the user's original detailed diary record**. Prior QA did not test a physical Galaxy nor intentionally empty center native image on mount. Do NOT repeat the failed full-host hide approach.

## R582 P0 scope
- New separate feature branch `feature/moa-r582-r580-native-gallery-mount-regression-repair-20261115`. Do not change approved immutable `golden/moa-r567-user-device-pass-20261114`.
- Restore actual R567/R578 behavior in `attachCard()`: native host visibility is based on card-in-viewport ONLY, not native drawable readiness.
- Restore R567/R578 immediate `r572FinishEntry()` mounted ACK even while original native image is pending. Maintain original Gallery `refreshPages()` bounded retry and all original Back/Host/MediaPlayer controls.
- ONLY changed build members from signed **R580**: `AndroidManifest.xml` versionCode **580→582**, additive `classes18.dex`. **142/144 members identical** (including R580 photo-form IDB JS/CSS), original 17 native DEX byte-for-byte protected.
- This is an urgent repair for **gallery controls not displaying**. It does not prove earlier photo flicker, filmstrip gap, or QuickRecord-to-photo form are all fixed on physical device. Do not overclaim.

## Signed files and checks
- **R582 install** `MOA_R582_NATIVE_GALLERY_MOUNT_P0_RESTORE_SAME_SIGNER_BETA.apk`, versionCode 582, **9,091,888B**, SHA256 **`a0e1acdbef1c7dfc87df0270e19f2e5218ec4b93c02dad49c72dea15b8c79d84`**.
- **R583 emergency exact R567 function** `MOA_R583_EXACT_R567_GOLDEN_FORWARD_RECOVERY_ORIGINAL_SIGNED.apk`, code583, **9,069,599B**, SHA256 **`49e83431398e01320f7e314f9885842c6e3eaa83a4864656aa16ef6548e7f098`**. Original R567 142/143 APK ZIP members identical, only version manifest differs.
- Same original package `com.juhyeon.familyjournea` and original signer cert SHA256 `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`. Independently verified both APKs: v2 RSA + signed-content digest, ZIP CRC, 18 DEX headers SHA1/Adler32, stored 4-byte alignment, Manifest PASS.
- Android SDK35 Java/D8 compilation and updated source regression test asserting **no full-host readiness gating** [GitHub CI 43651919183 PASS](https://github.com/yooogillycloud123/family-journey-personal/actions/runs/43651919183). Previous retained R580 9 JS isolated MOCK tests PASS, not Galaxy proof.
- Verified release ZIP `MOA_R582_R583_NATIVE_GALLERY_P0_RESTORE_SIGNED_QA_20261115.zip` SHA256 `84859ac980df143df8273f894bf0b96fbc996ec657266902d3e4501e17219bcd`, 13,175,052B, includes both APKs, source/patch, CI DEX/QA, no keystore or credentials. Archived privately `/모아_프로젝트_근거_20261103/R582_R583_GALLERY_P0_20261115/`.

## Install safety + immediate testing
- Install R582 over same signer MOA R580 or R581 without uninstall or data/cache clearing; no NAVER logout/cookie clearing, MediaStore deleting, or original DB mutation.
- R583 ONLY if serious regression and user prioritizes known-good Golden R567 exact functionality; if installed, future APK versionCode **>=584**. R581 also restores Golden from R580 but is lower code and cannot update R582.
- First test **one known pre-existing photo in photo-type day**: original native gallery shows, filmstrip and eight action icons visible and responsive. Only after this PASS continue same-day QuickRecord photo, video flicker, gap, and Back/Home/Recents.
- **R582 ON-DEVICE QA PENDING — NOT a GOLDEN**. The user already experienced repeated regression, do not report "fully fixed" or physical PASS from compilation.
- Never touch AA AirPods/Android Auto daemon or apps for MOA.
