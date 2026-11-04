# R74 exact signed APK and source provenance

This branch retains the compiled Android Java source change (`MoaMomentCaptureService.java`) and R74 D8 CI workflow results.

- Android CI run `41769797290` SUCCESS, classes4.dex SHA256 `c48a29f0d5a3947d37aeff68dabbb7cf85cf2e92ee398e5644b011288c9121de`.
- R74 signed APK SHA256 `4d8ed5a46d0c933db7d805322c8ee591c5f8e9b6fef31e9b893e886cb35239f2`, versionCode 74, same package/signer.
- R74 exact applied JS, reproducible Python patch, verification/test scripts are retained in private Library `/모아_프로젝트_근거_20261103/MOA_R74_NO_KEYS_SOURCE_AND_VERIFICATION.zip`. The branch's original AndroidHost code is NOT recompiled; original signed `classes.dex/classes2.dex/classes3.dex` stay identical to R73.
- Main reference: `MOA_R74_STABLE_PREVIEWS_CAMERA_POPUP_CLOSE_READ_FIRST_20261104.md`.
- Static PASS, Galaxy R74 runtime test NOT yet done. User R73 device confirms quick diary memo writes but thumbnail flicker, and wants manual × popup close.
- R63 physical Golden direct IndexedDB writer protected.
