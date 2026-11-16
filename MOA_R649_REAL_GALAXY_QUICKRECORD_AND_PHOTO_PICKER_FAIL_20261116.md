# MOA R649 real Galaxy regression, R648 user-scoped Golden remains protected — 2026-11-16

## Highest-priority user physical result — FAIL
User provided original device R602 diagnostic JSON + 72.3s recording `23197.mp4` after installing R649 beta. **R649 QUICK RECORD→NATIVE GALLERY FAIL**. This supersedes all static/Chromium PASS claimed in R649 signed handoff. **DO NOT promote or re-ship R649**. Protect currently user-approved conditional R648 scoped Golden and older immutable R611/R641. R649 must be marked DEVICE FAIL; neither the photo-add nor native-gallery regression is fully resolved.

### Device timestamps (Asia/Seoul, same Nov 16)
- 23:56:29.654 R641 bootstrap loaded under R649 signed build.
- 23:57:09.845 `QUICK_RECORD_COMMITTED`.
- 23:57:10.395 `LIFECYCLE page=day, stageAttached=true, nativeOpen=true, arm=true, pending=true, opened=true, mounted=true`.
- 23:57:11.495 `QUICK_RECORD_STATE delay=1650`: nativeOpen/opened/mounted = true, last `NATIVE_8_ACTION_DECK_READY`.
- 23:57:12.756 a **new `START_INLINE` count=18** after the original native Gallery had already opened. No new PREDRAW_ARMED/OPEN_ACCEPTED/MOUNT_ACK in R602 last events.
- 23:57:13.045 `QUICK_RECORD_STATE delay=3200`: still same active day `2026-11-16`, stageAttached true, width352, bridge true, rootHidden false, nativeMethod true BUT nativeOpen/opened/mounted/arm/pending ALL false, last START_INLINE.

**Exact code defect opportunity:** In byte-identical R648/R649 `assets/web/moa-r641-safeguard-bootstrap.js`, only `[550,1650,3200]` checkpoints are scheduled on one QR native-commit. 3200ms checkpoint requires 1800ms<=age of last START_INLINE<=9000ms to issue one existing `__moaR543RepairInline` if closed. This trace has 23:57:13.045 minus 23:57:12.756 = **289ms**, so its repair condition necessarily skips. There is **no later checkpoint**. This is a source/log-proven missed recovery opportunity, **NOT sufficient proof of the trigger that closed the live native Gallery**. Do not claim the new picker directly caused that close.

### Video additional photo picker failure
In `23197.mp4`, user-installed R649 initially shows native Gallery in earlier screens; QR then leads to calendar/absence of expected same-day native gallery. Later opening center + photo add displays new dark preview with broken `원본 사진` placeholder and multiple blank images in the filmstrip, while at least one photo/video frame appears. Thus **R649 photo add real-content preview FAIL**, not equivalent to the synthetic 360/390/412 checks.

Source `moa-r640-lazy-picker.js` in R649 was changed to try `content://media/external/images/media/ID` with `img.dataset.r649Quality=100000` first in preview, and only on image error request native `__requestThumbs([id],2048)` fallback. Actual device screenshot demonstrates the preview does not reliably load all original media. The exact cause (WebView content URI visibility vs thumbnail service responsiveness vs other) is still unproven without actual error callback/timing/URI class, do not call fixed. R648 old picker first used `__requestThumbs` and only content-URI on failed thumbnail, so changed order is a tangible regression-risk path.

**Important causation distinction:** `moa-r641-safeguard-bootstrap.js` loads the picker JS/CSS **only when the central + is tapped**. Video sequence shows QR regression occurred before the new picker UI was opened. Therefore changing the picker JS is not evidenced as the *direct initial* QR closure cause. The 18 native DEX and native gallery JS remain byte-identical across R648/R649. This only proves source equivalence, not that R648 runtime always succeeds under all conditions (R648 verified user-pass had One Hand Operation+ OFF→ON precondition). Original Java/OS/owner close event reason remains unknown.

### Prohibited next moves
- Do not tell user uninstall, app data clear, Naver logout or reset, replace AA AirPods runtime.
- **Do not ship another timer/auto-reopen guess without observing original closing cause.** Previous R646-style re-arm experiments also failed to establish reliable hardware solution.
- Do not re-use R649 photo-add as if high-res/video worked on hardware.
- Do not assume `visibleDay:false` in Settings proves day was invisible earlier; saved `r641LastActiveDay` is the relevant active-day snapshot.

### Emergency rollback already built and verified statically
Same-original-signer **R650 functional-exact R648** APK path in Library `/모아_프로젝트_근거_20261103/R649_R648_GOLDEN_ISOLATED_PHOTO_ADD_20261116/MOA_R650_EXACT_R648_FUNCTIONAL_FORWARD_RECOVERY_ORIGINAL_SIGNED.apk`; code650 (higher than 649), SHA256 `dac8e53eabe4cef3132a94deee8c85b4025440a1d40f5f58126f681863f6ce6c`; 147/148 original R648 members byte-identical, only Manifest versionCode changed, all original 18 DEX exact. Signed cert SHA256 `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`. User may update-install without uninstall/data clear; **R650 actual phone physical behavior still untested**, no guarantee reset of preexisting device state. Future candidate versionCode>=651.

### Next engineering gate
1. Stop release/promotion of R649. Keep complete user video/log in conversation PRIVATE, do not put private media in public GitHub.
2. If user chooses to install R650, compare QR under same One Hand Operation+ setup as user-confirmed R648 and use full `Settings > 전체 진단 복사` to collect version-tagged events.
3. Locate where a **live** original Gallery host transitions from nativeOpen=true to false: Java native owner CLOSE/DETACH callbacks, Java→JS last event timing, specific `r507StopInline()` caller (including render/navigation), creation/closing of Activity/View. Instrument missing close causes minimally, rather than blind rearm loops. A future change must preserve QR original mount as well as initial app photo/day.
4. Photo-add should provide immediate working thumbnail before attempting fullres original; validate 6 image/2 video prior `RESOURCE_LOAD_ERROR` classes plus new black screenshot on real Galaxy; only then consider new isolated component.
5. Physical regression repeated QR, initial Gallery, photo↔detail, One Hand NAVER OFF→ON, 3 QR contexts, new content URI photos/video must PASS before new Golden.
