# MOA R551 actual signed Gallery stability candidate / R553 Golden function forward recovery
**2026-11-14 (KST). Status: original-signer APK/DEX/JS/3-theme regression STATIC PASS, physical Galaxy R551 NOT TESTED. The only USER-approved GOLDEN remains immutable R463.**

## Latest physical evidence (supersedes previously stated guesses)
User's **21730.mp4** (19.236 seconds, S26 Ultra 1080x2340): original R463 Gallery/rail/action symbols initially renders in the photo-day, switches to detailed day timeline, returns to photo-day via top oval switch, and original native Gallery is absent — only old Web photo/video poster with play/fullscreen buttons remains. Then opening the legacy viewer confirms the regression. This is not just external NAVER Activity return; **photo↔detail within the SAME Activity is affected**.

**R547 source-confirmed destructive behavior:** `r507StartInline()` scheduled a 2700ms timeout: if no `.moa-r507-native-mounted` acknowledgment then it invoked **`r507StopInline()`**, which called original **`MoaLocalAudio.closeNativeGallery()`**, then tried reopening at most twice and stopped. This can kill a valid native Gallery merely because WebView/native attachment acknowledgment is late or missing. The original provider's `installPreDrawGuard()` also called `host.setAlpha(0f)` **before** verifying a successful card mount and could disarm on failure, leaving a transparent/gray native host. Provider `ticker` called `clearCardMark()` on any uncaught reflection exception, and `maybeArm` ran only when Gallery `isOpen()==false` — preventing re-attachment of already-open but not-owned native hosts. R547's automatic `isOpen=false` after 180ms triggered `__moaR523NativeClosed` (day exit) even if this originated from a non-Back transition. These are exact source paths; no pretense to have a device stacktrace.

## R551 changes (R547 exact baseline)
1. **No timeout-driven native close**. R551's delayed 2700ms diagnostic does NOT call `r507StopInline`, Gallery.close, or a duplicate `openNativeGallery`. It preserves `NativePending` and `InlineArm` so Java can attach existing gallery during slow WebView/native frame.
2. **Native entry is idempotent**. If original native Gallery is already opened/pending, a subsequent async start does nothing; no duplicate player reset.
3. **Late native attach**. Native ticker can call `maybeArm` even when Gallery `isOpen` but card ownership has not been established. `SNAPSHOT` accepts pending/arm; valid day+root+host required to attach. The original `classes6.dex` gallery/player and R463 other DEX unchanged.
4. **No permanent alpha=0**. Pre-draw attaches before drawing; on failure it restores alpha=1 and keeps arm for late snapshot, instead of leaving an invisible video/photo host.
5. **Native-close state**. A confirmed `isOpen=false` does not automatically mean user pressed Back. Java verifies same trusted WebView/day/session before invoking `__moaR551NativeLost(token)` to attempt native re-entry, bounded to 4 across genuine losses. Explicit owned Android Back handler still exits day.
6. **No old R503 controls**. Legacy photo-day Web pager/play/advanced/actions CSS is noninteractive/hidden unconditionally, even when native mounted callback is missing. The underlying inert image/video poster is only a placeholder until native mounts — not a second renderer.
7. **No micro-scroll experiment**. Preserve R527 geometry push, R535 video FIT/ambient/photo protection, R539 shared photo/detail header and fullscreen selected image handoff, R547 foreign Activity isolation; golden Gallery, NAVER, voice, diary unchanged.

## Falsifiable regression evidence
New browser test `QA/browser_regression_r551.py` deliberately **withholds `__moaR507NativeMounted(true)` >3 seconds** while the actual mock native Gallery is already open. It tracks `MoaLocalAudio.closeNativeGallery` calls. Exact unchanged R547 JS under the same test: **FAIL** (`AssertionError: OLD BUG: timeout killed native Gallery`). Exact new R551: **PASS** (no spurious close), plus detailed→photo roundtrip without forced second close, late mount accepted, old Web controls hidden, **Peach/Black/White 3/3 PASS, zero JS page errors**. This proves the specific source regression is fixed; it is **NOT** real Samsung Native Gallery/SurfaceTexture pass.

CI Android SDK35 javac + D8/JS checks [workflow run 43576877423](https://github.com/yooogillycloud123/family-journey-personal/actions/runs/43576877423) **SUCCESS**, compiled `classes18.dex` **40,232 bytes**, SHA256 **`048b97ad29d60da57165cfc6a7e05904fcae17d3c43f07dbf0afa8202ec697b8`**. Source exact branch `feature/moa-r551-native-late-mount-no-autoclose-20261114`, head `56e63fb6a2e949a35ab2221e5dea8e5d6756d451`. Original R463 Golden branch untouched.

## Signed APKs — actual distributables
Combined user-download ZIP: `MOA_R551_R553_NATIVE_GALLERY_STABILITY_SIGNED_APK_RECOVERY_SOURCE_QA_20261114.zip`, **13,114,697B**, SHA256 **`f141b99da2ad531f25014c9b13ca804ed53825e481115bdef20bb57674199486`**. Exact ZIP includes installation, forward emergency recovery, source, DEX, public-only cryptographic APK verifier, 3-theme browser regression and QA/results, Korean README. Re-extracted ZIP and independently ran included `python QA/verify_release.py` successfully.

- **Install R551:** `01_INSTALL/MOA_R551_NATIVE_GALLERY_STAY_NO_TIMEOUT_CLOSE_ORIGINAL_SIGNED_TEST.apk`, package `com.juhyeon.familyjournea`, versionCode **551**, **9,059,011B**, SHA256 **`24774e9ad564684354b15394d6e1497d88413b1786379df4752e3d0d916bd82e`**. Same original certificate `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`.
- **Emergency R553:** `02_RECOVERY/MOA_R553_EXACT_R463_GOLDEN_FUNCTION_FORWARD_RECOVERY.apk`, versionCode **553**, **8,978,096B**, SHA256 **`35f4825492a3238836440318a4a02ebeddc82dcb31e2e06766255f9e6a6f00e1`**. Same original signer, exact original R463 functionality in higher version; newer photo diary experiments would be lost if recovery used. Any future build after R553 must code **>=554**.
- R547→R551 APK changed only **4 entries** (`AndroidManifest.xml`, additive calendar JS/CSS, `classes18.dex`): **139 protected ZIP member payloads EXACT**, all **17 original R463 native DEX EXACT**.
- R549→R553 rescue changed only Manifest versionCode; other **139 members EXACT**.
- Independent original-certificate APK v2 RSA SHA256/full signed content digest, ZIP CRC and stored alignment, manifest versionCode/package, all DEX SHA1/Adler32, protected byte compare, sources-to-CI exact **PASS**.
- Original private signer/keystore/password from protected Library used only locally, never packaged or published. All real user family photos/videos excluded from release ZIP.

## Physical acceptance gates — NOT YET PASSED
1. Open photo-day and see actual native rail and R463 icons.
2. Switch photo→detail→photo at least 3 times; original native Gallery must be present immediately and without reopening old Web controls.
3. Expand original fullscreen Gallery, swipe to another photo, return: selected photo must match.
4. Launch NAVER map and return with hardware Back; native Gallery still appears.
5. Leave for another app, return; video/image still visible and original control functions intact.
6. Video original FIT/blur, share/GPS/voice/diary/NAVER continue operating.

No uninstall, no data clear, no Naver logout. R551 should be tested in-place over current same-cert code<=550. **Do not declare physical success or GOLDEN from static tests**. Immutable R463 user GOLDEN SHA256 `9d2fd10d32a3bc35eb3132333e96edd8f565abd5daf3ce954b052f77083d8379`. AA AirPods/Android Auto runtime unchanged. Latest GitHub WIP and new-chat docs should link here.
