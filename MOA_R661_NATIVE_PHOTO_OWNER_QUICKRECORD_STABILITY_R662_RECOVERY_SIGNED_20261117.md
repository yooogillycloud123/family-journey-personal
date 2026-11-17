# MOA R661 native PHOTO owner stabilization signed beta + R662 exact R660-function recovery (2026-11-17)

## Source of truth and exact artifacts
- Immutable user-physical approved baseline: **R657 R625-functional** same-original-signer APK SHA256 `f8c0e460ecacc7ab6d5a9a7c41dcee5e6fa8f25c94554c446c814ec983d6861a`; original package `com.juhyeon.familyjournea`. User-installed **R660** same R657-functional binary-layout version forward SHA256 `d8ce843fe812838443e3265f866f17a6ac2641fa314161fde7967700492feea1`. R660 physically regained initial native PHOTO Gallery after Samsung app **Clear cache**, One Hand OFF→ON PASS, BUT QuickRecord reentry FAIL and legacy 5-action WebView fallback video `23310.mp4`.
- **New install beta R661**: `MOA_R661_NATIVE_PHOTO_OWNER_QUICKRECORD_STABILITY_ORIGINAL_SIGNED_BETA.apk`, size **9,170,406** bytes, SHA256 `8a45e0bca6526fd7fb693ede2995d8cad069c0d7e74f88eca905c077653e2752`. package unchanged, versionCode 661, original signer cert SHA256 `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`; Android APK v2 RSA signature and full-content SHA256 digest independently parsed and verified PASS, ZIP CRC PASS, stored-entry alignment PASS.
- **Higher-version R662 functional restore**: `MOA_R662_EXACT_R660_FUNCTIONAL_FORWARD_RESTORE_ORIGINAL_SIGNED.apk`, size **9,124,042** bytes, SHA256 `86a23d98af4ebe3b9a2fc545d6a8421f06bc3539a78f3c37ad987ec6e0fd978b`. Manifest versionCode=662; **all 143 other R660 payload members byte-exact**, including all 18 DEX, Web JS, CSS, QR, Naver, diary. Same signer and full APK v2/digest/ZIP PASS. It is NOT an all-state rollback: cached runtime/IndexedDB survives install; Clear cache ONLY may be needed after any upgrade. Neither candidate physically tested.
- Local source/install zip `MOA_R661_R662_SOURCE_QA_AND_INSTALL.zip`, SHA256 `321677e0c9c9e09e412ed6c4b2897f7ec7c1a78b91610928c0f9a83ba4575a10`. Includes BOTH APKs, SHA256SUMS, changed JS full/diff, unit/browser QA, install notes. Private signer never included.

## Exact feature changes vs original R660 APK
Existing R660 144 entries retained. R661 changed ONLY:
1. `AndroidManifest.xml` versionCode 660→661
2. `assets/web/index.html` original PHOTO script reference changed to unique `moa-r661-vertical-calendar.js` to avoid cached old JS; original photo CSS stays original.
3. `classes18.dex` original Android `MoaR507InlineGalleryProvider` compiled Java class replaced with **already-compiled, exact original R611-derived** generation-bound `processing` callback lock, CI GitHub run `43977479500` artifact `14282625084`, DEX SHA256 `f54d15c61b00343b3d11b8950a462ddbb4839cd7ec57e7082901d1392d7c2b6a`, 72,260 bytes. Shared `processing` evaluates a 3,500 ms generation-owned stale limit; late callbacks ignored; no normal Gallery close/reopen side effect. This DEX is NOT the prior user-physical R657 binary, physical validation REQUIRED. The other **17 DEX byte-exact**.
PLUS one **added** new file `assets/web/moa-r661-vertical-calendar.js` (145,019 bytes). The original `assets/web/moa-r483-vertical-calendar.js` remains byte-exact in APK and is *not* loaded by updated index; user app data/cache unchanged. New active JS:
- A one-attempt-per-PHOTO-day and DOM-stage registry: repeated native mount requests during an in-flight transaction join rather than bumping generation and canceling prior async `tryOpen()`.
- Same-day `r592PrepareView()`/full `render()` short-circuit when actual PHOTO stage is connected on current day; preserve exact native host, eight-action deck, video frame and scroll; hydrate and refresh playlist/story *in-place*.
- QuickRecord same-day *unchanged* media also triggers idempotent ensureMounted after IndexedDB hydration; changed-media path retains R592 exact native playlist update.
- Native `NATIVE_MOUNT_ACK` clears retry state; no original Gallery close for a native live owner.
- Following **confirmed** ARM timeout/native reject and genuinely absent host, ONE bounded retry (420 ms), no periodical blind rearm loop, before showing preexisting legacy fallback after terminal failure. Added nonpersonal `__moaR661NativeDiagnostic()` (120 recent events) to identify tryOpen status/reasons independently of old R602 18 events. Does NOT record private media paths, diary body, GPS or auth.
- Unique JS filename is a resource cache-busting measure when the refreshed HTML is loaded; it does NOT prove all caches auto-purged, nor does it clear user cookies/IndexedDB. No new photo picker UI and no gallery feature reduction.

## QA evidence and limitations
- Exact Android v2 cert signature/digest, 4-byte alignment, ZIP CRC/Manifest code and 144-member diff all PASS for R661/R662.
- `node --check` for the entire new 145 KB active JS PASS.
- JS lifecycle logic unit test PASS: in-flight join, preserve already-open native Gallery, at most one denial retry.
- Headless Chromium Android-like synthetic browser test PASS: on the same PHOTO day, `openDay` reentry **kept the exact original DOM stage node**, native open **one time**, close **zero**, QuickRecord commit from 2→3 media IDs, story updated, no JS page errors. This uses fake Android native mount and fake IndexedDB store; it **does not** simulate Galaxy native ContentProvider/TextureView lifecycle, Gallery ARM callback loss, real One Hand/camera/lock behavior.
- **NO REAL GALAXY PHYSICAL PASS** for R661 OR R662. Do not mark as Golden/final or claim “always” until user device check. Older R658, R659, R660 failure and clear-cache QA remain separate.
- Stable UI stage fallback still exists after terminal errors; a screenshot of legacy 5-action rail means native mounted invariant still failing. Do not hide this from user.

## User installation / precise gates
Update install R661 over R660. **Never uninstall, clear data, reset original photo IDs, delete IndexedDB, clear Naver cookies or modify AA AirPods runtime.** If app boots with stale JS/UI, first use Samsung App settings > **Force stop** > Storage > **Clear cache ONLY**, not Clear data. Physical test: cold start PHOTO 8-action, One Hand OFF→ON, QuickRecord from locked/unlocked/foreground, photo calendar and detail navigations, picker roundtrip, 8-action+rail repeat, app restart, video, Naver and diary persistence. For failure: save current R602 Gallery Diagnostic + Full Execution Trace; R661 diagnostic optional through JS; only then localize failed transaction; install R662 higher code over R661 if wanting exact R660-function payload.

## Next source work if R661 fails
This build includes a bounded original Java evaluation-lock improvement; if QuickRecord still drops native owner, investigate real activity/host/Java gate and JS generation concurrently using the new current-session logs, not identical-function APK re-signing. Two separate failure classes possible: WebView cached resources (confirmed operationally by clear-cache restoring startup) vs after-QR native gallery ownership failure (current R660 physically reproduced). 8-action original native Gallery is the goal; do not downgrade to 5-action WebView fallback or repair with blind infinite open/close. Current R657 user physical Golden is immutable and unrelated AA AirPods audio is unchanged.

## Privacy
DO NOT publish user videos/screenshots, diary text, location or signer backup. Only nonpersonal technical descriptions, hashes, public APK names and source patches are in this document.
