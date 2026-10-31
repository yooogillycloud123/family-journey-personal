# 2026-10-31 — User-provided AirPods reference APK compared, independent TravelPassport native host built

## Verified reference
- User uploaded `내 에어팟 5-1.0.11-juhyeon-ko-daily-debug (2).apk`.
- Direct package inspection: appId `com.myairpods5.personal`, launcher `me.kavishdevar.librepods.MainActivity`, 13 DEX, locally signed debug SHA256 cert `56e94efa84f386e29b4fe62c57c66147f5cd5106d8aae184d2da27ffaab9b91f`. No original TravelPassport Pairip component. Its own native app, unlike the wrong 10/31 repackaged TravelPassport APK.
- This is why independent install is **possible in principle**. It is not evidence that another app's Google Play in-app purchase is legally or technically inherited by changing package names.

## What was actually built now
- Code commit `c1e281d7e208983124370dce23238b3aee744599` public Android `androidHost` independent host, no protected commercial files in public repo.
- `80a4913433fbe86bb3de851726cd4746988a7556` fixes original `native.js` fingerprint/cache protocol: first `__nativeFingerprint`, then `needPhotos` true triggers EXIF scan; no infinite reload from redundant photo delivery.
- `9f51c4316d39f920a76de2e9d474d6d1c5759cd4` adds explicit unsupported purchase/restore responses; avoids hanging spinner, rewarded ad absent callback.
- GitHub Actions `41158620821` entire Android compile/sign gate SUCCESS, public artifact is native host only (proprietary user APK not uploaded to repo).
- Locally PRIVATE rebuilt host APK from clean Android source + user-provided original `assets/web` (full native UI engine/assets in private container only), using `host-bootstrap.js` to implement original `window.webkit.messageHandlers` protocol, auto MediaStore photo EXIF + thumbnail, offline CITIES name fallback, video chunk saves, existing family-addon.js.
- Private APK `FamilyJourney_Original_UI_CleanHost_v1.0.4_BETA.apk`, appId `com.juhyeon.familyjourney` versionCode 8, **3,192,971 bytes, SHA256 `fda4a2a1374164201342c5926d34e0243f9f31f53f36720880d5788d2c5a87e4`**, signature v3 PASS, CRC PASS, launchable activity PASS; DEX Pairip absent; original app.js, native.js, engine.js, render-worker.js, tripbuilder.js, style.css byte-identical. New local independent key stable in `/mnt/data/_fj_sign_private/familyjourney_independent_stable_20261031.p12` (do NOT publish keystore or pass to PUBLIC GitHub).
- Private packaging script `/mnt/data/_fj_rebuild_cleanhost_private.py`, public source excludes originals.

## VERY IMPORTANT user truth/gates
- User goal is original TravelPassport **all functions + purchased premium-grade features** with zero loss, photos automatically scanned, original maps/UI, plus family/Naver additions, independent installed package. No dummy simplified UI.
- **Only static build/CRC/sign/byte-identity PASS. Android device launch, photo scan, real video export, full premium / other native network/cloud/battle features NOT tested or completed.**
- Bought original Play premium package `com.hueeng.phototravelmap` remains untouched; its purchase is **not automatically transferred** to `com.juhyeon.familyjourney`. Separate premium features currently may be LOCKED; do not call this final or claim all premium functions work.
- Previous re-signed Play-protected package (versionCode7) was real FAIL screenshot: `Something went wrong ... Google Play`. New clean runtime has no Pairip, unlike prior, but smartphone crash/physical function still UNKNOWN.
- On-device installation of beta with same appId as prior failed TEST version might require removing **only** the broken test first due differing signing cert. Never delete real purchased original or personal photos.
- Current source/zip locations in conversation container; new chat must use original files and no copyrighted asset upload to PUBLIC repo.
