> **USER ACTUAL GALAXY RESULT SUPERSEDES SIGNED/STATIC PASS STATUS:** Read [MOA_R655_GALAXY_ACTUAL_JAVA_PROCESSING_LATCH_DEVICE_FAIL_20261117.md](MOA_R655_GALAXY_ACTUAL_JAVA_PROCESSING_LATCH_DEVICE_FAIL_20261117.md). R655 PHOTO-inline mount FAILED on user's Galaxy (848 current-build events, 61 direct Java MAYBE_ARM_DENY_PROCESSING, no native mount ACK). R655 is NOT FUNCTIONALLY SUCCESSFUL. Original shared `processing` boolean appears stuck (callback missing possible but unproven), R655 telemetry itself uses frequent WebView evaluateJavascript and can perturb scheduling. R656 exact-R648-functional forward recovery remains untested on device. Do not present R655 as golden, fix method requires native-only processing lifetime trace before bounded same-generation stale lock mitigation.

# R655 actual WebView / Java / Native-owner direct-branch diagnostic, R656 Golden function recovery

Status: 2026-11-17 SIGNED/SDK35 COMPILE/STATIC-QA PASS; **NO REAL GALAXY HARDWARE TEST**. R655 is diagnostic BETA, not a bug fix or GOLDEN. R648 remains physically approved under One Hand Operation+ OFF→ON precondition. R649/R651/R653 are Galaxy physical failures.

## Real APK releases

R655 versionCode=655 same-original-signer APK SHA256 0ee22fa07f195b740643bb77e571aa90f5f66b9b0147a86fe194836cd9f6a74b, 9,100,466 bytes. Package com.juhyeon.familyjournea. Cert SHA256 5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15.

R656 versionCode=656 same-original-signer forward recovery, R648 functional-exact except Manifest version change. SHA256 0fd3ab1395823a2934953a789200519ce19a65a1546f2aede2d3e31318f0e436, 9,097,037 bytes. Recovery on real hardware NOT tested.

QA ZIP SHA256 61f1306475146cba74c35ae6fe000d4f4fdcb7649f6d4277df29dcd546dba417, includes both APKs, JS/calendar source, native DEX binary hash and CI compile/QA, original signer secrets excluded. Original-derived Java source in feature branch: https://github.com/yooogillycloud123/family-journey-personal/blob/feature/moa-r655-direct-branch-correlation-20261117/experiments/moa-r655/MoaR507InlineGalleryProvider.java

R648 original SHA256 6b5984e1b3892c0ed10606008d2627c0393ba02661e22a13565571f1a47be3c1. R655 changed exactly 4 existing entries: Manifest version, assets/web/moa-r483-vertical-calendar.js, assets/web/moa-r648-passive-full-runtrace.js, classes18.dex. Other 144/148 original APK members byte-exact. R656 changed only Manifest.

R611 original owner Java recompiled into R648 classes18.dex byte-exact, 70,992 bytes (GitHub run 43925629456). R655 source instrumented owner Java compiled with SDK35/D8 to 73,508-byte DEX SHA256 5ebb8a12cc56b44221481037c0bb3d8b425b432ba59bca72484283ae8d99b162 (CI 43927278141). APKv2 RSA digest and original signer cert, ZIP CRC, JS node syntax passed. No original media gallery open/close algorithm changes intended; trace statements modify execution timing and their physical safety is unverified.

## Three-stage actual branch trace with correlated request

Original photo-day JS emits R655_JS_START_INLINE, R655_JS_TRYOPEN_ENTER, R655_JS_TRYOPEN_ABORT with reason SUPERSEDED/CLOSED/PAGE_CHANGED/VIEW_HIDDEN, R655_JS_ARM_REQUESTED, R655_JS_WAIT_JAVA_ARM, R655_JS_JAVA_ARM_TIMEOUT, R655_JS_NATIVE_OPEN_CALL, R655_JS_NATIVE_OPEN_ACCEPTED/REJECTED, R655_JS_STOP_INLINE, R655_JS_CLOSE_NATIVE_CALLED.

Attempt IDs are R655:<boot>:g<generation>. Original-derived Java owner tick()/maybeArm() includes R655_JAVA_BRANCH directly at executed return paths: MAYBE_ARM_DENY_OWNS_GALLERY, ALREADY_ARMED, PROCESSING, SUPPRESSED; CALLBACK_DENY_NOT_RESUMED/OWNER_CHANGED/INACTIVE/GEOMETRY/NO_ROOT; TICK_DENY_OWNER_MISMATCH / FULLSCREEN, GALLERY_EXIT_CALL_CLOSED_WHILE_OWNED, JAVA_DISARM_CALLER, NATIVE_PREDRAW_ARMED and NATIVE_HOST_MOUNTED. ARM_SNAPSHOT carries attempt ID into Java branch reason. The native event is also written to Android logcat MOA_R655_BRANCH, and is bridged into the existing WebView trace. Native Gallery internal close calls outside the owner class (in untouched classes1–17) are not directly instrumented; do not assert 100% close caller coverage.

R648 original full-runtrace allowlist has been extended to persist attemptId, nativeAttemptId, branch, generation, stack/callsite. Settings > 전체 실행 경로 진단 > 전체 진단 복사 exports R655 events with old history retained. Do not use R653 Java snapshot copy. If R655 Java events are absent, report channel instrumentation failure instead of guessing the native Java guard.

## Test and rollback

Update-install R655 without uninstalling MOA, wiping data, resetting permissions or losing Naver data. FIRST check photo-inline original Gallery at app start; if absent stop and export full trace. If passes, One Hand NAVER accessibility OFF→ON and QuickRecord under locked/unlocked/in-app contexts; stop on first regression. The photo-add picker remains from original R648; no R649/R651 feature included in R655.

Optional R656 forward-version update-install restores functional R648 payload but device recovery success is unverified; never call it guaranteed. Next code >=657. Independent AA AirPods Android Auto daemon untouched.

Private user videos, raw logs, signing keys and passwords must never be uploaded to public GitHub.