# R10 2026-10-31 — screenshot-proven startup failure, reproducer and fix gate

## What we actually did / did NOT do
- User's Galaxy screenshot at R9: blank white, static 20%-width line, bottom `시작하기`. This is the original `index.html` pre-boot DOM, **not an initialized map**.
- **REA CLI was NOT executed.** It was not installed in the current execution environment, and npm package acquisition timed out. Do not falsely claim to have run REA. Instead, performed direct byte inspection of user-supplied APK/web bundle, parsed native.js/app.js/tripbuilder.js, and ran original JS in a headless Chromium test harness.
- The Chromium harness is a **web-runtime reproduction using original JS**, not an actual Galaxy WebView/MediaStore test.

## Reproduced exact async bottleneck
Original `native.js` sequence:
`ready → __nativeFingerprint → needPhotos → __nativePhotos → PhotoTripBuilder.build → post('geocode') → __geocodeResult → __bootPhotoMap`.
Original JS's `geocode` promise times out only after **180,000 ms**.
- Test A (original R9 bootstrap, synthetic 650 geotagged photos): send fingerprint and photos, **drop native geocode reply**. Outcome `window.__photoMap=false`, all `.page.home` hidden; no JS exceptions. Exactly same blank initial DOM class as user screenshot.
- Test B (same test, explicitly call `window.__geocodeResult(1,[])`): `window.__photoMap=true`, home visible. This identifies a **source-proven stall condition**, not proof that this specific IPC loss happened on user's Galaxy (logs not provided).
- Test C (new R10 `host-bootstrap.js`, same dropped reply): 1800 ms fallback resolves pending geocode with `[]`. **`window.__photoMap=true`, home visible**, no JS errors. The native geocode handler in separate host already returned `[]`; fallback does not claim full native geocoding fidelity.

## Native host changes in public source
- Commit `0312e2687bc02d818a15f0509f0a6f499d213d0d`: `HostActivity` initiates photo fingerprint on 3s after page load if original JS `ready` message was lost, and absolute 18s diagnosis if map still absent.
- Commit `8f3060cc0383e30376411063f318cb0dc2f01ad6`: versionCode10, versionName `1.0.4-host-autoboot-r10`.
- GitHub Actions host run `41160435432` Java compile/APK verify/sign succeeded (only public independent host; original web assets NEVER pushed to GitHub).
- Private bootstrap shim `host-bootstrap.js` added only in user-held package. Original **20/21 web code files identical**; `index.html` script inserts remain additive, original native.js/app.js/engine.js untouched.
- Private APK R10 `FamilyJourney_Original_UI_CleanHost_v1.0.4_PHOTO_AUTOBOOT_R10_BETA.apk`, versionCode10, `com.juhyeon.familyjourney`, 3,201,235 bytes, SHA256 `92fffc191b93cc2ba5871e4e719d5407f161566bc2010d533548930bc42ac5d8`, v3 signing PASS, signer SHA256 `1d471020bbdeccaac105a13ceac4bef95e795a4db17e7c07eef3c971186a396c` (same as R9).

## Status / restrictions
- **R9 REAL PHONE FAIL**. **R10 Chromium synthetic web startup PASS, Galaxy still NOT TESTED.** Users should not be told all original/paid features work or that launch is guaranteed.
- Original Play subscription/premium purchase of `com.hueeng.phototravelmap` does not transfer to this independent package automatically; no entitlement manipulation undertaken. Additional native source bridges (cloud OAuth/fetch, widget, share, original media export, and actual phone 1440p) remain unverified.
- Do not upload commercial user-supplied original JS/assets or signing keys/public photos to GitHub. Original purchased application remains untouched.
