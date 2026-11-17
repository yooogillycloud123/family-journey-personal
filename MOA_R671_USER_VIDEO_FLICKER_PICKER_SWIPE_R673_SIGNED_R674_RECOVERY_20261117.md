# MOA R671 actual Galaxy video: full-screen diary-loading blink + native PHOTO-ADD rail/slip → R673 signed mitigation / R674 R665 functional recovery

## Observed current user evidence (2026-11-17, user private files NOT published)
- User provided **23408.mp4** (1080×2340, 11.6505s) and **23407.mp4** (1080×2340, 19.3681s). Inspected representative contact frames directly.
- In 23408 at ~1.4s and ~11.3s the page temporarily becomes **almost entirely white, with small top text "저장된 일기를 불러오는 중…"**, then the calendar/day returns with some thumbnails rendering as gray placeholders. This is a visible source of flicker/flash, not an assumption.
- In 23407 the separate PHOTO-ADD native Activity has a black letterboxed media viewer + thumbnail strip and smaller original PHOTO/detail native gallery examples. User reports single finger swipe can jump several photos, thumbnail rail has noticeable delayed following. The isolated Activity visual/gesture behavior is unlike original PHOTO/detail viewer; user's demand remains actual native smoothness and parity.
- Do **not** claim the original PHOTO Gallery is broken: user earlier physically confirmed the R665 original PHOTO native eight-action Gallery; it must be kept unchanged. Do **not** claim all black TextureView glitches are fully resolved by hiding loading text.

## Concrete cause verified in exact R671 APK JS source
In `assets/web/moa-r671-vertical-calendar.js`, `r592PrepareView()` calls `view.replaceChildren(elem('p','moa-r592-loading','저장된 일기를 불러오는 중…'))` BEFORE IndexedDB daily/month hydration. Every calendar-to-PHOTO/date transition discards the entire prior visible DOM, flashes a white/empty loading display, then paints once after the read or a 2800ms fallback. Actual user video explicitly shows this exact text. This source-specific cause is distinct from unknown Android native host/video black framebuffer transitions. New R673 changes this **single expression** (to an explanatory comment) so the old calendar/photo DOM persists until data hydrates, then the existing render function paints the next page once. Existing QuickRecord same-day R661 stage-preserving branch and original PHOTO gallery owner code stay byte-exact. A 240ms delayed synthetic IndexedDB browser test confirms prior calendar DOM remains until stage is drawn; back does not introduce blank text. It might hold old view very briefly instead of blank; real transition performance remains hardware-QA pending.

## Concrete native PHOTO-ADD source cause and repair
Current R671 `classes19.dex` corresponds to `MoaR667NativePickerProvider.java`: `NativePickerActivity.renderRail()` calls `railRow.removeAllViews()` on **EVERY** `setCurrent()`, reconstructing up to 31 thumbnail tiles, asynchronously invoking ContentResolver.loadThumbnail for each, and `rail.smoothScrollTo(...)` (animated lag) to center. Main photo decode jobs share this same ExecutorService and may queue behind 31 thumbnail jobs. Native `GestureDetector.onFling()` directly changes photo index without an explicit once-per-touch transaction; this can allow extra gesture navigation callbacks.

R673 separate Activity repairs **without touching the original PHOTO R507 host**:
1. Photo swipes handled only once per `MotionEvent.ACTION_UP`; `onFling()` has no page-changing action. 54dp left/right threshold, dominant horizontal direction, 190ms repeat-event guard, index change at most ±1.
2. Reuse a stable up-to-41-tile native horizontal rail window; update only selected white border/y-lift, rebuild only when leaving the buffered window. `LruCache` caches thumbnails up to 90 and recent 4 main images.
3. Main image jobs and thumbnail decode tasks use separate thread executors, no thumbnail backlog holding main image.
4. `rail.scrollTo` immediate center align replaces `smoothScrollTo` on each photo; native HorizontalScrollView is still user-draggable.
5. Separate native Activity appearance changed to black status/nav/fullscreen Gallery presentation with white top glyphs, no white root or 16dp rounded card padding, original-style dark bottom tools and rail. This remains **a newly implemented isolated Android native Activity, not literally the original compiled R463 Gallery engine**. Complete functional parity (Naver / GPS / original video controls) is NOT yet physically verified, and user may still request direct reuse only if proven safe.

## Signed deliverables
- **R673**: `MOA_R673_NATIVE_PICKER_ONE_SWIPE_CACHED_RAIL_NO_LOADING_FLASH_SIGNED_BETA.apk` (short handoff name `MOA_R673_INSTALL.apk`), code673, **9,473,717 bytes**, SHA256 `fbed6f62cc5ce23895c57474f42d63abf93b5970275591bebe7b980706abd5fe`.
- **R674 forward rescue**: `MOA_R674_EXACT_R665_FUNCTIONAL_FORWARD_RECOVERY_SIGNED.apk` (short `MOA_R674_RECOVERY.apk`), code674, **9,271,330 bytes**, SHA256 `adf09483ea3ef6d0c494331631bb908f411354be9016bc8a67286148263e9efd`. All 149 original R665 ZIP entries byte-exact except AndroidManifest.xml versionCode; **does not clear device runtime cache/IndexedDB**.
- Archive `MOA_R673_R674_NATIVE_SWIPE_FLICKER_UPDATE_SOURCE_QA.zip` = **18,832,912 bytes**, SHA256 `f9e8ac3e6ec8c1177e3f923d762291ed246402d794d06ff2bcf84bb0ef354bef`, both APKs + safe Java/JS sources/diffs + install README + official SDK, browser and source QA. Private original signing PKCS12/key/password, user screenshots/photos/diary/GPS/credentials NOT included.
- Same package `com.juhyeon.familyjournea`, signer original cert SHA256 `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`. No uninstall/clear data/user data wipe.

## EXACT diff / original native protection
R673 vs signed original R671 ZIP member content: modified existing EXACT three entries
1. `AndroidManifest.xml` code671→673 only (no new AXML components or binary headers; all parse rules unchanged).
2. `assets/web/index.html` points to new `moa-r673-vertical-calendar.js` instead of prior R671 URL (picker CSS unchanged).
3. `classes19.dex` standalone photo-add Activity/bridge only.
Added one `assets/web/moa-r673-vertical-calendar.js`, original full `moa-r671-vertical-calendar.js` kept byte-exact in ZIP; new active JS differs from old R671 by the ONE loading-replace line only (comment substitution). ALL R671 original **18/18 DEX byte-exact**, native original PHOTO/QuickRecord and unrelated app files unchanged. This reduces regression exposure but **does not prove real device stability**.

## Official release and QA gates completed
- Java source Android SDK35 `javac` + D8 min-api29 generated standalone classes19.dex; Node syntax new full JS PASS.
- OFFICIAL SDK35: `java -jar apksigner.jar verify --min-sdk-version 29 --max-sdk-version 37`, `aapt dump badging`, `aapt2 dump xmltree --file AndroidManifest.xml`, `zipalign -c 4` **ALL PASS both APKs**. Exact original signer/v2 signature/ZIP CRC and all 18 old DEX immutability independently verified.
- Chromium mobile 360/390/412 picker selection, date header/scope, native open callback, original save, TODAY, period wheel no JS errors PASS.
- Browser mocked original in-card PHOTO native lifecycle: same-day reentry preserves stage DOM; QuickRecord mock grows media 2→3; original Gallery openCount1 closeCount0 PASS.
- Browser artificially delayed IndexedDB read 240ms: calendar DOM remains present immediately after PHOTO entry, no "loading" stage; after read PHOTO stage appears; calendar return no white loader; no page errors PASS.
- Source guards verify native swipe is only ACTION_UP and rail uses cached window/immediate scroll.
- **R673/R674 Galaxy actual install/native PHOTO-ADD behavior and total black flicker elimination NOT TESTED**. Static and synthetic QA cannot claim physical success.

## Real-device acceptance tests
1. Update R673 OVER currently installed R671, preserve app data; verify existing PHOTO original 8 actions, One Hand OFF→ON and QuickRecord after unlocked/locked/foreground.
2. Calendar→PHOTO→calendar repeatedly: former white full-page loading text should NOT appear; observe any remaining black TextureView flash separately.
3. Photo add grid, native enlarge: fast consecutive single swipes must move 1 item per gesture, filmstrip selection synchronized without 31-thumbnail reload/slow animation, original photo/video and + selected IDs saved correctly.
4. Video pause/seek, GPS/Naver bookmarks, photo sharing and photo-original quality require on-device checks and may have limitations in separate engine.
5. If R673 fails, R674 installs above it as exact R665 functional payload (higher code674); NO uninstall/clear data/IndexedDB/Naver cookies. Stale WebView assets may require Samsung clear CACHE ONLY, never clear DATA. If R674 installed any future code >=675.
6. AA Android Auto/AirPods vehicle audio/daemon is unrelated, entirely untouched.

## Source provenance
All findings from exact R671 APK JS and standalone Java source, and direct user video review. New feature-branch note: `feature/moa-r673-picker-one-photo-and-native-loader-flicker-20261117`. No inferred Galaxy PASS claims.
