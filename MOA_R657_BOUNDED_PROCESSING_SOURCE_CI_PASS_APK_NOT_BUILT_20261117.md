# MOA R657 bounded processing owner source (SDK35 Java/D8 CI PASS) — **SIGNED APK NOT BUILT**

2026-11-17 user explicitly requires a TESTABLE APK, not discussion. Be transparent: **No R657 APK exists from this turn. DO NOT claim built, signed, installed or linked.** Existing R656 original-signer forward-R648 recovery remains available via personal Library and recent upload; hardware recovery unverified.

## Trigger and root evidence

User R655 Galaxy full trace 4842 JSON rows, 848 current R655, 193 Java executed branches, 61 MAYBE_ARM_DENY_PROCESSING; WebView attempted ARM (10), no native PREDRAW/OPEN/MOUNT in R655 sessions. Shared Java `processing` boolean remains true if evaluateJavascript callback never invokes; exact missing callback/initial origin not captured, and R655 itself added high-frequency evaluateJavascript instrumentation that may perturb schedule. R648 scoped-Golden OneHand OFF→ON only; R649/R651/R653/R655 failed user phone.

## Source patch implemented

`feature/moa-r657-bounded-processing-owner-safe-20261117/experiments/moa-r657/MoaR507InlineGalleryProvider.java` is derived from *exact* R611 baseline owner Java. Replaces bare shared `processing` boolean callbacks with bounded per-evaluation generation-token owner for both SNAPSHOT and ARM_SNAPSHOT, `R657_STALE_EVAL_MS=3500`, only releases stale lock, never closes/opens a live gallery, guards late callbacks via matching generation, logs native `MOA_R657 EVAL_SET / EVAL_CLEAR / EVAL_STALE_UNLOCK / EVAL_LATE_IGNORED` (no R655 hotpath JS report calls). R648 photo JavaScript, R641 safeguard, all original DEX1..17 should remain original if packaged.

## Verified CI

GitHub workflow `.github/workflows/moa-r657-bounded-processing.yml` built with Android SDK35 `javac`/D8. First CI run 43977365369 failed due *test harness* incorrect DEX magic assertion (Java compile and D8 passed). Fixed assertion; second CI run 43977479500 **SUCCESS**. DEX classes18 72,260 bytes SHA256 `f54d15c61b00343b3d11b8950a462ddbb4839cd7ec57e7082901d1392d7c2b6a`, Java source SHA256 `5a9680f64ec44215f613365f1312fbbfab10dc239537c60fcc9af0d2dd26d01d`. GitHub Actions artifact `MOA-R657-BOUNDED-PROCESSING-DEX-QA` artifact ID 14282625084 contains zlib base64 DEX, verify.json, compile.log.

## Critical blocker on APK packaging

The session's Python/python_user_visible/container tools repeatedly raise `ClientError` even for `echo`/`1+1`, despite GitHub CI and Files tools working. Private original signer backup ZIP `MOA_R39_SIGNING_BACKUP_PRIVATE_KEEP.zip` and R656 signed APK were found in conversation file metadata and materialized to `/mnt/data/moa_r657_inputs/`. Since no actual container code execution is available, **R657 DEX cannot yet be patched into R656 and re-signed using the original private signer**. GitHub CI does not have the original signer secrets and cannot fabricate a same-package/same-signer APK. DO NOT replace with another signer, publish private signing material to GitHub, or invent a download.

## Next actual step when container works

Read original Python packaging source from R655 release context or R651 source QA, use verified R656 functional archive (version code 656) as baseline, replace *only* `classes18.dex`, update manifest versionCode 657, sign original cert `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`; verify v2, file hashes and ZIP entries. Need separately original-function recovery code658 (higher than test candidate). Avoid uninstall/clearing app data/Naver account. Do not label TESTABLE until an exact signed APK path exists and integrity verified.

## Device QA gates

R657 would still be UNTESTED on Galaxy: initial photo inline, OneHand OFF→ON, QuickRecord lock/unlock/app foreground, detail/map, repeated cycles, old original photo-add only. If R657 physical failure, do not continue blind attempts; analyze limited native lock lifetime via ADB logcat + existing complete runtrace and preserve R648 scoped Golden. AA AirPods audio project not related.