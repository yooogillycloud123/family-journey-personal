# MOA R415 — R411-scoped Golden + Gallery native-bridge owner repair + stabilized masks (2026-11-12)

## User evidence, top issue
Read [R411 user-scoped Golden](MOA_R411_USER_SCOPED_NAVER_GOLDEN_GALLERY_REGRESSION_20261112.md). User video 20812.mp4 shows diary viewer old R133 web fallback while user expected native R227 gallery features. Video 20813.mp4 shows MOA launch/UI shake and transient MOA branded cover during explicit WebView stop → offscreen save rearm.

## Exact binary source facts
- R411 `classes6.dex` SHA256 `cf93d66d08f1700b95949760093bd50689fa8b45e7cbe4a42b962b2afbb6f61b` still contains `MoaNativeGallery` and native `GalleryRail`, `VerticalMediaVolume`, mute, video, frame capture and the R227 native-return paths. It is not missing all gallery features.
- `assets/web/moa-r133-diary-unified.js` calls `window.MoaLocalAudio.openNativeGallery(JSON.stringify(ids),index,day)` then only renders the old `← 목록` fallback on bridge unavailability or false return. `MoaMomentAudioHostActivity` stores `web`, `trustedPage`, and its `attach()` chooses the first WebView in the activity hierarchy. New same-activity NAVER controller adds its own separate WebView. It is therefore plausible (not proved) that the audio owner may target a NAVER sibling rather than the original MOA document and reject native gallery entry. Other possible causes: unreadable MediaStore ID/permission or bridge absent.
- Do not replace whole classes6 from the earlier R227, because the current classes6 also holds later NAVER controller. No user media is in the source ZIP.

## R415 surgical implementation
- Fork exact signed R411 SHA `ec2c0fb88b4fc795b59156acdd59b88c4702bc4135634b6096be7efcf8d76377`.
- Source branch `feature/moa-r415-gallery-owner-freeze-view-20261112`; `experiments/moa-r391/MoaR391SessionPersistProvider.java`.
- Keep original 140 APK members; change **only** `AndroidManifest.xml` versionCode 411→415 and provider `classes17.dex`. All original 16 DEX and original 54K NAVER favorites JS and R133 viewer JS are BYTE IDENTICAL.
- **Native gallery ownership repair:** every bounded monitor (~400ms), when the app itself has an exact `https://familyjourney.local/` WebView, reflect into `MoaMomentAudioHostActivity.web/trustedPage` to restore that owner and authentic own-origin status if a separate NAVER WebView was selected. No privilege bypass/cookie extraction; does not override missing MediaStore authorization or force reload. Distinct diagnostic non-sensitive `GALLERY_WEBVIEW_OWNER_REPAIRED` / `GALLERY_OWN_ORIGIN_TRUST_REFRESHED` logged. If this isn't the actual cause, fallback remains and physical native gallery feature success must be marked FAIL.
- **Launch wobble mitigation:** avoid stacking root View and external WindowManager panel cover; use one app-owned `TYPE_APPLICATION_PANEL` cover that starts before original full-size PC map renderer; remove `FLAG_LAYOUT_IN_SCREEN` so its geometry follows standard app content. Preserve proven STOP → VISIBLE START → 460ms → HIDE user flow and original account writer.
- **Rearm visual freeze:** when an explicit offscreen save follows intentional web stop, before showing any navigator, capture the existing MOA Activity window into private in-memory Bitmap via `PixelCopy.request`, fallback to `decor.draw(Canvas)`, present the frozen bitmap as the same panel mask during exact original stop/start/hide transaction, then recycle it. No image stored, uploaded or logged. If capture timeout, no foreground web popup; original R411 one-shot retry mechanism still in place.
- **Keepalive:** original R411 65sec renew + manual stop respecting + R391 cookie flush preserved, without client HTTP/network calls, credentials, data migration or external APK.

## Build evidence
- [GitHub Actions 43245984787](https://github.com/yooogillycloud123/family-journey-personal/actions/runs/43245984787) Android35 javac + D8 **SUCCESS**, new `classes17.dex` 27,272 bytes SHA256 `baeee0a6944614bf94b6c76d8e0f2203220f4e9daca096ac30839823d4bcb343`.
- **R415 signed candidate** `MOA_R415_R411_GALLERY_BRIDGE_FREEZE_REARM_BETA.apk`, versionCode415, 8,940,179 bytes, SHA256 **`448d6f98548023f7d7a82ae1bcb0124d456873c739f72795f245579b805cb487`**. Existing original signer cert SHA256 `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`. Independent APKv2 RSA + SHA256 content digest, ZIP CRC, stored-alignment, DEX SHA1/Adler32 PASS. Exactly **138/140** R411 members byte-identical; protected classes6/other 16DEX all original web JS intact.
- **R417 exact R411 forward recovery** `MOA_R417_FORWARD_RESTORE_EXACT_R411_GOLDEN.apk`, versionCode417, 8,937,063 bytes, SHA256 **`a9e66e1beb109d4868574f501b93b6635cd053b83f26e765d3aaccb304173b4e`**. Only Manifest changed; 139/140 original R411 members identical. Use ONLY for serious regression. Next build after R417 must be >417.
- Combined full signed ZIP `MOA_R415_GALLERY_REPAIR_R417_R411_RECOVERY_QA.zip` SHA256 **`50bf2868f021bfb9049c3e38c949ef998b012dc8fbf719ca3187eff6bd4a2c7f`**, 12,929,608 bytes, includes both APK, source, QA, Korean README, SHA256SUMS. Private Library `/모아_프로젝트_근거_20261103/R415_GALLERY_START_FREEZE_20261112/`.
- *NO* signing key/password, cookie token, private photos/video in GitHub or release ZIP.

## Physical acceptance needed
- R411 NAVER initial masked save, session rearm 1/2/4: **USER PASS**; R411 4-minute keepalive **NOT CONFIRMED**.
- R415 upper/lower launch wobble eliminated: **NOT VERIFIED**.
- R415 rearm screenshot remains visually stationary without MOA logo flash: **NOT VERIFIED**.
- R415 native gallery full filmstrip, native video autoplay, mute, still capture, sound volume slider, swipe, navigation return: **NOT VERIFIED**. Root cause may be other than WebView ownership.
- R415 NAVER actual first-party account list write and no regressions: **NOT VERIFIED**.
- Never claim gallery fully restored from static DEX hash alone. Do not silently fall back to old viewer while calling it a success. If R415 still falls back, require exact non-sensitive native bridge status before another patch; no blind gallery engine/Dex replacement.
- Never uninstall/delete/clear app data or NAVER cookies. Update-in-place signed package `com.juhyeon.familyjournea`.
- AA AirPods/Android Auto unchanged.
