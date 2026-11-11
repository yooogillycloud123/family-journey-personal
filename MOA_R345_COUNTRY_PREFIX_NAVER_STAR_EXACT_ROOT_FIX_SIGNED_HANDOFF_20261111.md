# MOA R345 — Galaxy screenshot address heading STAR root-cause and signed fix (2026-11-11)

## User evidence and exact failure class
Latest private Galaxy screenshot `20416.png` shows an authenticated-looking PC NAVER map **address detail** open, unsaved outline ☆, but the existing R341 MOA WebView automation does not press it. User had supplied the actual PC Python Playwright implementation earlier. No screen/record/video uploaded to PUBLIC GitHub.

R341 actual embedded `assets/web/moa-r231-naver-frame-probe.js` checks `detail()`: exactly one `.address_info_area .address_title`, with `addrEqual(title, incoming photo GPS address)`. Direct reproduction from actual signed R341 code:

```
addrEqual('대한민국 전북특별자치도 전주시 덕진구 가상동2가 1332-2',
          '전북 전주시 덕진구 가상동2가 1332-2') === false
```

The user screenshot has exactly this structural mismatch: photo geocoder adds initial `대한민국`, while NAVER renders an abbreviated province and no country prefix. R341 province canonicalizer only expanded `PROV[firstToken]`; with `firstToken=대한민국`, it failed to canonicalize `전북특별자치도`. Thus R341 never reached STAR in this class of real screen despite visible ☆. Separate selector issue: R341 searched `button.btn_favorite`, but the *actual original working Python* uses `.btn_favorite:visible`, covering links and other elements too. **Do not assume untrusted click is the only cause: there was an earlier proven address gate failure.**

## Public research context
- Playwright official `Locator.dispatchEvent` is equivalent to `element.click()` / untrusted event; `Locator.click` invokes browser input path and actionability checks: https://playwright.dev/docs/touch-events
- Android WebView supports WebView input and AndroidX origin-scoped injected WebMessage bridge; a native MotionEvent driver could be investigated if real Galaxy accepts address but `HTMLElement.click()` still fails. https://developer.android.com/reference/android/webkit/WebView and https://developer.android.com/reference/androidx/webkit/WebViewCompat
- In this R345 only the **proven gate defects** were corrected. **No native MotionEvent trusted click driver is inside R345**; actual WebView input acceptance and NAVER account readback remain open.

## Exactly changed from signed R341
- Country prefix `대한민국/한국/South Korea/Republic of Korea` removed only when a complete initial country token, before original province abbreviation expansion. City/district/dong and exact building/lot/road number preserved.
- `star()` chooses a single **visible `.btn_favorite` regardless of HTML tag**, or a uniquely identified unsaved button inside the verified address scroll panel; rejects multiple targets and already-saved state. This matches user-supplied PC Python selector semantics better.
- STAR→DIALOG is not set until actual `.click()` dispatch returns, no repeated auto-click from the timer. Still requires modal and authenticated same-list item readback; no false `NAVER_READBACK_VERIFIED`.
- New sessionStorage key `moa.r345.task` isolates stale prior R341 tasks; prevents replay of previous in-flight jobs.
- Everything else stays byte-for-byte frozen, including original Gallery/Diary/Quick Record, foreground NAVER save, R341 default web/save buttons, native code, 16 DEX.

## Real signed release and validation
- Package `com.juhyeon.familyjournea`, R345 versionCode **345**, original signing cert SHA256 **`5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`**.
- Signed main APK `MOA_R345_EXACT_ADDRESS_HEADER_STAR_CLICK_REPAIR_BETA.apk` 8,880,150 B SHA256 **`fe2aaaac15d39a610268ee3d10361652a95537e0ce8ec9cde86e98edf3f8ceb1`**.
- Emergency forward rollback code347 `MOA_R347_FORWARD_RESTORE_R341_FUNCTIONS.apk` 8,879,959 B SHA256 **`67e454d2fc10e9a366c40a6f5d5ba28ba81b46d184b5e30a9d8795820140efe5`** (original R341 functionality except Manifest); user must not install routinely.
- Paired ZIP `MOA_R345_APK_R347_RECOVERY_TESTS_20261111.zip` 12,840,503 B SHA256 **`cd63e8367c825be8fecd6738d0cb3cd1938f7d1025b9a450f4679fde07cda6ef`** contains byte-identical both APKs, source-only NAVER JS, 13-case node VM test, QA/hash, Korean README. ZIP CRC PASS.
- R341→R345 **only 2 uncompressed member changes**: Manifest 341→345, first-party NAVER frame probe JS. Other 136 members including all 16 DEX byte-identical. APKv2 original signer/full content digest PASS; DEX SHA/Adler and STORED ZIP alignment PASS. Embedded probe 23,079 Java characters < native 24,000 gate.
- **13/13 Node synthetic tests PASS**, including screenshot-like country-prefix mismatch now true, wrong house number/province/city false, link-shaped ☆ receives *one* DOM click in simulated rootAction. This is not physical NAVER commit/readback proof. Actual Galaxy R345 and NAVER account save **NOT TESTED**.
- Artifacts stored private Library `/모아_프로젝트_근거_20261103/R345_20261111/` exact ZIP, QA, install guidance. Signing key/password, user GPS/photos, original Windows private ZIP and Naver proprietary split APKs **not published**.

## Required next action / no repeated dead-end
User may install **R345 only** over installed R341 (no uninstall/data clear) and make one verified address favorite attempt. If star still not pressed, do NOT repeat URL/UA/JS `click()` rewrites as though proven; next design is native, authenticated WebView input-bridge experiment with UI-thread `WebView.dispatchTouchEvent(MotionEvent)`, coordinate-bound exact DOM rect, no fabricated `isTrusted`, strict per-task origin/folder scope and on-screen status before/after; its feasibility requires physical testing and native code changes. **Do not claim this native driver is implemented in R345.** After real account save/check, verify alias/memo/folder and no duplicate creation. R347 code347 only forward restore if core regression, and blocks downgrade to R345. Immutable R269 Goldens and AA audio daemon remain untouched.
