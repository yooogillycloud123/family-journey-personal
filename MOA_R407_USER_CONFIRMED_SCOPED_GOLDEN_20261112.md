# MOA R407 — user-confirmed startup bootstrap scoped Golden (2026-11-12)

## Exact immutable baseline
- APK: MOA_R407_REAL_LAUNCHER_COVER_REATTACH_SIGNED_BETA.apk
- Package: com.juhyeon.familyjournea; versionCode 407
- SHA256: ecfde9ac17d6bbf8c368dac0fc0d5c16b7729aca246f26a10b56d3e5190d2c97
- Original signing cert SHA256: 5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15
- Original immutable private ZIP: /모아_프로젝트_근거_20261103/R407_LAUNCHER_FIX_20261112/MOA_R407_LAUNCHER_BOOTSTRAP_R409_RECOVERY_QA.zip
- Entire ZIP SHA256: c197e832dbc7323e5c844d8a4bb2ce8c4e4661e8a7de3e1962433acbc11285fd
- User private evidence: 20801.mp4 (111.9 sec), SHA256 caff965ce4a0ed88661bf17a78cd29182f1098d5785cfc18a3db9c70c40c7642; DO NOT PUBLISH VIDEO.

## Scope user personally confirms
- R407 launcher startup STOP → actual full-sized NAVER PC WebView OPEN → short hold ~460ms → original HIDE successfully enabled subsequent nonoccupying photo favorite saves, unlike R395/R399/R403 failures.
- This is a **SCOPED USER GOLDEN** for the observed initial warm-up path and subsequently working nonoccupying functionality; not a blanket certified zero-flash/forever-sessions release. If further account server readback needed, test separately without degrading baseline.
- NAVER one-time login in MOA previously worked and R391 cookie persistence user-confirmed; preserve existing login state.

## Known cosmetic regression and concrete evidence
- In 20801.mp4 at ~0.58–1.17s, a real white/full-sized `네이버 웹 연결 실험 · 읽기 전용` window is briefly visible, sometimes with NAVER PC sidebar, BEFORE the MOA splash/diary. Around 1.2–1.5s the MOA splash appears.
- Source controller start(Activity) adds full-sized shell to HostActivity android.R.id.content at end of child list; R407's ordinary View cover is also attached under the same root. Browser may temporarily be the top drawing child and be sampled during Android launch animation. R407 `cover.bringToFront()` occurs AFTER synchronous original start, and may not cover first composed frames. Exact surface composition cause not independently proven; do not claim OS limitation.
- Next design: mask **at the window layer before starting controller**, no 0.1s blind sleep; keep existing stop/open/hide, guard startup with stage logs. Do not alter original 16 DEX or original NAVER writer in-place on this Golden.

## User-requested next improvements
1. Zero-visible-flash startup (use correctly layered opaque MOA splash/window cover before visible WebView starts, remove only after hide confirmed).
2. Offscreen-save stopped-session **auto rearm**: do NOT invoke unconditional `naverWebProbeControl('visible')` and leave it foreground/QUEUED_VISIBLE. Instead short stop→visible-open-under-cover→hide, then **exactly one** original saved-item job, preserving user list/memo/account-readback rules; fail closed without false success or duplicates.
3. While MOA is running, remove/renew `MoaNaverWebProbeController.scheduleExpiry()` fixed 4-minute disposal without changing NAVER server cookie expiration; manual user Stop must still work. Resume from lifecycle restart/session-missing as needed; battery/OS process death means no absolute permanence guarantee.
4. App relaunch safely performs one bootstrap; do NOT clear cookies/cache/data, uninstall app, or disturb AirPods audio.

## Absolute preservation policy
- DO NOT overwrite this APK, its Golden manifest or original R345/R397/R391 baselines.
- Fork new versionCode > 409 with same original signer and separately test, preserve original R407 protected 16 DEX and original NAVER account writer as regression gate. If implementing JS hook, isolate and protect duplicate/submission logic.
- R409 was signed as exact R397 feature-only emergency, **not** R407 Golden restoration; next emergency restore should contain exact R407 functional payload, not R397.
- Record any new signed APK separately with original SHA and user device result; static QA != physical pass.