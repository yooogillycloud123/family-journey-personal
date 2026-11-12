# MOA R395 — Hidden-first NAVER WebView restart attempt, from R391 physical login persistence (2026-11-12)

## User-proven fact / exact issue
- User installed/tested R391 and reported **NAVER login remains signed in** after reauth using one-time number.
- On force-closing and reopening MOA, the FIRST offscreen favorite save causes NAVER PC map WebView to pop visibly, and MOA reports: `QUEUED_VISIBLE` and that account save has not started.
- Private user video `20740.mp4` / screenshot `20741.png` reviewed in conversation; keep private.
- **Binary-proven root** in exact R391 `assets/web/fj-naver-favorites.js`: when `naverWebProbeStatus().running` is false, `tryR289Offscreen()` explicitly invokes `naverWebProbeControl('visible')`, reports `WEB_LOGIN_REQUIRED`, and returns without saving. This is not the R391 cookie problem.
- Older R349 made a previous ill-tested no-start replacement and broke original R345 first-party favorite operation. Do not repeat as a mere no-op. User-confirmed R345 saves to existing and NEW NAVER lists are protected.

## R395 candidate (source in branch)
- Branch: `feature/moa-r395-hidden-bootstrap-session-20261112`.
- Exact installation base: previously signed R391 SHA256 `ef49bc1573536ad9be70bdee53816ffa8a28da2160ee0892cb7372ec46518b2e`, not R389 or legacy.
- `MoaR391SessionPersistProvider.java` extends R391 cookie flush with bounded, opt-in WebView first-load prewarm when MOA original HostActivity resumes and internal MOA WebView and offscreen setting are present. Reflects into existing same-package R345 `MoaNaverWebProbeController` and invokes original `start(Activity)` then `setHidden(Activity,true)` on **same UI callback**. No credentials or cookie reads, clearing, new account login, separate UID, extra visible launcher or NAVER API writes.
- Changed `assets/web/fj-naver-favorites.js` EXACT initial stopped case: no `'visible'` call; one pending request at a time, bounded 16x300ms wait for genuine `running && hidden` status. On success delegate **exact old first-party save path**. On failure `WEB_HIDDEN_START_UNAVAILABLE` and no false success/forced WebView foreground, manual Settings PC-web opening still available.
- GitHub Actions [43219721151](https://github.com/yooogillycloud123/family-journey-personal/actions/runs/43219721151) **SUCCESS**, compiled classes17.dex SHA256 `6699c875c6b5160fac3edb319496991d1c0e58071255c8b19c431cdecad0bb32` 8,504 bytes.
- Node mock contract 3 branches PASS: existing hidden session one submission; stopped then hidden session one submission with duplicate-tap suppression; missing hidden session no foreground and no submission. STATIC MOCK ONLY.

## Signed distribution / immutable core
- **R395** `MOA_R395_R391_HIDDEN_FIRST_NAVER_RESTART_SIGNED_BETA.apk`, versionCode 395, SHA256 `9a6624e5ea67e87486a1d07c2bd34b8062891b4e7af5d32a2199fddd1a7f6fe3`, 8,921,438 bytes.
- **R397** emergency `MOA_R397_FORWARD_RESTORE_EXACT_R391_FEATURES.apk`, versionCode 397, SHA256 `268332af789e0d748b73b3e64ce2c75f627f3b2a7a9d7d56ae5af0c142348206`, 8,916,808 bytes.
- Same exact original signer cert SHA256 `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`. Independent APK v2 RSA/full SHA256 content digest, ZIP CRC/alignment, DEX SHA1/Adler PASS.
- R395 R391 original 140 archive members: only **Manifest, classes17.dex, fj-naver-favorites.js** changed, **137/140 exact byte-identical**, including all original 16 DEX (R283 NID UA login, gallery, photo/voice/record), other Naver frame and exact R389 pink home JS.
- R397 **139/140 R391 archive members byte-identical**; only Manifest versionCode changed (restores exact R391 with cookie flush).
- Recovery R397 **NOT routine install**, only after severe R395 regression. If installed, later code must exceed 397.
- Backup ZIP `MOA_R395_HIDDEN_START_R397_RECOVERY_QA_BUNDLE.zip` SHA256 `058e1853602e0e034ff569184ba986fca117dbbeb25363f58543ab53117e302d`. Includes APKs, source, patch, QA and test JS; **NO signing keys, cookies, password, private video or personal data**.
- PRIVATE Library path: `/모아_프로젝트_근거_20261103/R395_HIDDEN_BOOTSTRAP_20261112/`.

## DEVICE TEST STILL OPEN (DO NOT CLAIM FIXED)
- User's physical R391 login status persistence: **PASS as reported**, not proof of indefinite server cookie.
- R395 initial app launch without WebView flash, true hidden-first start, actual first favorite save to NAVER account, and repeated process-death restart: **UNVERIFIED**.
- If hidden WebView isn't actually possible on this Samsung runtime, R395 will fail closed; it may not satisfy automatic first-save, and native start then hide may still flash depending on Android rendering. Do NOT call final.
- In-place update R391→R395, no uninstall, NO app-data/cache/cookie clearing.
- Test: (1) login unchanged (2) launch without unexpected PC-web (3) one actual offscreen favorite save with no visible browser (4) account list readback (5) force close/reopen and repeat (6) Diary/gallery/Quick Record/home retained. Stop if first regression, use R397 only after serious breakage.
- Root/Shizuku/ADB, external helper apps, persistent process, server-side authentication bypass are NOT part of this change. No AA AirPods changes.
