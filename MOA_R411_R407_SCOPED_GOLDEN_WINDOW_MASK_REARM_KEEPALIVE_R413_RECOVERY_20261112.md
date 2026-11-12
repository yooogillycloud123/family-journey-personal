# MOA R411 — R407 user-scoped Golden protected; window-masked WebView warmup, idle keepalive, first-save auto rearm (2026-11-12)

## User-confirmed R407 Golden and remaining failures
- User-confirmed R407 practical startup stop → original full-size NAVER PC map start → short (~460ms) → hide, enabling subsequent offscreen favorites. Read immutable [R407 user-scoped Golden](MOA_R407_USER_CONFIRMED_SCOPED_GOLDEN_20261112.md).
- Exact Golden APK `MOA_R407_REAL_LAUNCHER_COVER_REATTACH_SIGNED_BETA.apk`, code407 SHA256 `ecfde9ac17d6bbf8c368dac0fc0d5c16b7729aca246f26a10b56d3e5190d2c97`, original signer cert SHA256 `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`.
- User video PRIVATE `20801.mp4` SHA256 `caff965ce4a0ed88661bf17a78cd29182f1098d5785cfc18a3db9c70c40c7642`, 111.9 sec. ~0.58–1.17sec full-size "네이버 웹 연결 실험 · 읽기 전용" UI/white NAVER map flashes BEFORE MOA splash; not zero-popup.
- Original controller file `MoaNaverWebProbeController.java` has `start(Activity)` that appends full-size `shell` under HostActivity content root; R407 ordinary View cover may get drawn underneath that newly attached shell during launch. Device surface root-cause not strictly proven; higher same-app window is a design hypothesis.
- Original controller `scheduleExpiry()` unconditionally invokes `dispose()` after 4min; original `tryR289Offscreen` `if(!probe.running){ b.naverWebProbeControl('visible'); return false; }` exposes map and does not save. User requests app-running keepalive plus first-save hidden rearm.

## R411 surgical changes
- Fork only from exact signed R407, not R397 or failed R395/R399.
- Branch [feature/moa-r411-window-masked-rearm-keepalive-20261112](https://github.com/yooogillycloud123/family-journey-personal/tree/feature/moa-r411-window-masked-rearm-keepalive-20261112).
- Native `experiments/moa-r391/MoaR391SessionPersistProvider.java`: retains R407 original STOP→full-size original visible start→460ms→original hide; before starting renderer, attaches a **same-app WindowManager TYPE_APPLICATION_PANEL opaque MOA-looking cover**, waits for that window's first pre-draw callback, then 40ms before launching NAVER under it. Fail closed if overlay cannot be added/drawn, rather than showing full-size NAVER. Root cover also has elevated Z.
- App-owned HostActivity monitor checks only its own MOA-origin WebView and reads transient JS `window.__moaR411Rearm.pending` BOOLEAN (no payload or location). On one pending explicit user save when native probe no longer running, reuses same masked STOP→OPEN→HIDE; the JS retries original writer exactly once after `running && hidden` is observed. Does not change the first-party `phone_submit`, folder/readback contract or UI frame agent. Duplicate tap suppresses second job; timeout refuses write/foreground display and returns status `WEB_REARM_UNAVAILABLE`.
- Hidden, existing app controller expiry renewed via reflective invocation of original `scheduleExpiry()` approximately every 65 sec **while HostActivity exists, including process-alive background**, without HTTP calls, cookies contents or credential access. Manual web Stop stays stopped; background OS process kill/server expiry cannot be prevented; no perpetual guarantee.
- No separate APK/service, root or Shizuku. Original WebView cookies and R391 `CookieManager.flush()` retained without cookie clearing. This is not CAPTCHA automation.

## Android/JS build evidence
- GitHub Android35 javac + D8 [run 43240366760](https://github.com/yooogillycloud123/family-journey-personal/actions/runs/43240366760) SUCCESS; new `classes17.dex` SHA256 `dd386ca85f816c49eb9d54cd6acaaf12e1199005b13b976dc56f1c26d58a2204`.
- Mocked JavaScript tests 4 PASS: already hidden one submit; missing session then hidden one submit; duplicate tap one submit; failed rearm no submit and never invoke visible.
- **R411 APK** `MOA_R411_R407_MASKED_REARM_KEEPALIVE_SIGNED_BETA.apk` versionCode411, 8,937,063 bytes, SHA256 **`ec2c0fb88b4fc795b59156acdd59b88c4702bc4135634b6096be7efcf8d76377`**, original signer.
- Exact R407 140 original APK members, ONLY 3 changed: AndroidManifest.xml versionCode, classes17.dex, assets/web/fj-naver-favorites.js. **137/140 original entries content-byte identical**; original 16 DEX, all other assets including NAVER frame writer and native Gallery/Diary/recorder/voice/home unchanged.
- **R413 Golden forward rescue** `MOA_R413_FORWARD_RESTORE_EXACT_R407_GOLDEN.apk` versionCode413 SHA256 **`c82da61d93a0d41a85837b79b9e740617f40ab97482a7c72e9cf66a2f599915b`**, 8,928,684 bytes; 139/140 original R407 members byte-identical, ONLY manifest versionCode changed. This is exact R407 functionality including user-scoped bootstrap, NOT the R397 older emergency. Use only on R411 serious regression. After R413, next code must exceed413.
- Both APKs independent APK Signature Scheme v2 RSA signature and full SHA256 digest verification PASS; cert match, ZIP CRC/alignment, DEX SHA1+Adler32 PASS. No private signing key/cookie/user video in release ZIP.
- Combined `MOA_R411_WINDOW_MASK_REARM_R413_EXACT_R407_RECOVERY_QA.zip` size12,946,972B, SHA256 **`2a5ed7faf19811fd249998bf8037f8fdb0490a3aa6935f3c50fe91983f603c9b`** (full APKs/safe source/QA/README/mocked test) stored PRIVATE Library `/모아_프로젝트_근거_20261103/R411_WINDOW_MASK_REARM_DEV_20261112/`.
- R407 user-confirmed Golden separately preserved PRIVATE Library `/모아_프로젝트_근거_20261103/GOLDEN_R407_USER_CONFIRMED_20261112/`.

## Truthful physical QA status & safe installation
- **R411 is STATIC VERIFIED BETA; NOT Galaxy physical PASS.** A same-app WindowManager panel may still be subject to OEM launch composition/timing. Do not claim flash-free until video.
- Actual user-account favorite save after cold launch and after >4min/return from background NOT YET TESTED. Mock NAVER_READBACK_VERIFIED is not real account readback.
- In-place install over original-signer current code<=410, *never uninstall, clear MOA data, cache or NAVER cookies*. First test cold launch for flash, one real account list readback. Then remain in MOA >5min and save; explicitly stop web window and retry offscreen favorite (single automatic rearm) — ensure no duplicates.
- If serious regression only, R413 restores original R407 user Golden in-place; do not routine-install recovery to troubleshoot a single NAVER failure.
- If R411 fails, inspect device-native `MOA_R411_BOOT` stage messages (mask/token/predraw, stop/start, hide, idle renewal) without logging secrets. No blind R415 shipping. AA/AirPods Android Auto untouched.
