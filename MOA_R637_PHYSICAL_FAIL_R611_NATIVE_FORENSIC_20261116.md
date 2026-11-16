# R637 physical FAIL and R611 native gallery failure-stage forensic — 2026-11-16

**Confirmed actual Galaxy result:** user supplied `23050.png`, `23052.png`, `23054.jpg`, `23055.png`. Installed R637 fails the original native Gallery on first photo-day, after One Hand Operation+ NAVER Accessibility OFF→ON, and after QuickRecord. The visible 5-action Web Gallery is the R611 fallback renderer. R637 separate photo-add viewer is unsatisfactory and not native. **R637 is NOT Golden or a fix.** Previous R629–R635 similarly unverified or device-failed.

## Byte evidence (opened original APKs)
- User physically approved R611 `38a507cf2e88a235282ae4d9ad64cf0799033f34ae8fe3e179a58960d1213ccd`.
- R637 `a8f81e1a2b102e01fe33aba160f26834da2062d18aeba438ae9b7a3c51c530a2`, 18/18 original native DEX and photo JS/CSS exact, old 144 entries only Manifest and index.html differ, 2 new standalone JS/CSS assets. Native initial gallery failure therefore is NOT explained by deleted native DEX. R637 top-level picker code creates unattached hidden DOM and installs click capture, but only acts on `button[data-tab="moa-plus"]`, so cannot assert that entering the picker was the trigger when original native fails before plus.
- R638 `6aaad8fb70fe0545810eba6c2dccbc1a454372872b31b7f6c18ad4926d53cbab` remains the same-signer R611 exact functional control: **143/144 entries identical, only AndroidManifest versionCode differs**, Android original 18/18 DEX and index/js/css identical. **R638 has not yet been physically tested by the user**. This test can differentiate R637-specific index/extra script from persistent app/device native entry failures.

## R611 actual source fallback diagnostic
Exact existing `assets/web/moa-r483-vertical-calendar.js` exposes `window.__moaR602GalleryDiagnostic()` returning Java event stages, `bridge`, `arm`, `pending`, `opened`, `mounted`, count. R611 Settings already includes **원본 갤러리 진단 복사**, inserted right after **달력 이동 방식**. In failed photo day, wait ~8 seconds for native arm; go Settings, copy JSON and share; report excludes personal photo IDs, diary text and GPS.

Key possible *observable*, not guessed, failure states: `BRIDGE_UNAVAILABLE`, `NATIVE_STAGE_NOT_ATTACHED`, `NATIVE_ARM_TIMEOUT`, `INVALID_NATIVE_MEDIA_LIST`, `NATIVE_OPEN_REJECTED`, `NATIVE_MOUNT_UNCONFIRMED`. This evidence is REQUIRED before authoring another native-lifecycle patch. No device log means exact root cause not proven.

**Protect all data, cookies, original certificate and R611 Golden.** Do not fabricate a successful APK or call browser mock PASS physical success. Do not disturb AA AirPods audio.
