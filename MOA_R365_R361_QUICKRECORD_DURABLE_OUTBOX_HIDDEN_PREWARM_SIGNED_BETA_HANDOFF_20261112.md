# MOA R365 — R361 QuickRecord automatic favorites / native outbox / hidden prewarm

## Trigger and physical evidence (2026-11-12)
User reported that with R361 newly captured pictures may save offscreen, but old pictures fail with hidden WebView startup status. Real native QuickRecord had [장소 저장] checked and list '새로운' entered; original Diary save succeeded but automatic NAVER favorite did not start until the user manually tapped the Diary nonoccupying save button. Diary displayed default '내 장소'.

## Exact base and outputs (all verified in the current conversation container)
- Base: MOA_R361_QUICK_GPS_MEMO_HIDDEN_START_BETA.apk, code 361, SHA256 15a40c0a15dc17acfff6845c44f66523dcd9f7c1d06b5e5b3f9210611b8ec0cf. Do NOT confuse with a separately built R361 of another hash.
- New original-signer BETA: MOA_R365_DURABLE_QUICK_RECORD_HIDDEN_BOOTSTRAP_BETA.apk, code 365, bytes 8,946,098, SHA256 f9c65e8555d44409a9b0409b53ec12f7b9bed2ded9c135064a0fc55a251f562b.
- Emergency forward Golden restore: MOA_R367_FORWARD_RESTORE_EXACT_R355_GOLDEN.apk, code 367, bytes 8,907,248, SHA256 f961fef2ea98944664973cddc1bd6301b890287fb08867b8800ee30ecb23f030. It has all R355 original functional member bytes except AndroidManifest versionCode. Only use on regression, not a routine update.
- Paired ZIP: MOA_R365_APK_R367_GOLDEN_RECOVERY_QA_20261112.zip, bytes 12,931,020, SHA256 d3cced430d8c0727a1bb2b4286b9cae73b8aa41b4c0b3c68acf038b5b597b4af. It contains both signed APKs, exact JS, Node tests, DEX compiler artifact, manifest patch/build QA and install README. No signing private key or personal media.
- Original signer cert SHA256 5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15. APKv2 RSA/full chunked digest, ZIP CRC, all DEX integrity and alignment PASS.

## Byte-level scope
R361→R365 changes only AndroidManifest.xml (version+one non-exported ContentProvider) and assets/web/moa-r357-quick-bridge.js, and ADDS classes18.dex. Every original 17 DEX, native polished recorder classes, family-diary.js, fj-naver-favorites.js, moa-r231-naver-frame-probe.js, r28-diary-location.js and other functional original files byte-identical to R361. Do not recompile older R217 recorder or rebuild R345 Naver writer. R345/R355 originals remain immutable.

## Actual implementation
1. New separate provider MoaR365CompanionProvider (additive classes18.dex) watches original moa_camera_native_v1 SharedPreferences m:id writes, remembers checked state and exact list name, including when the original Golden note Save overwrites optional fields. It persistently stores a separate r365task:id outbox ONLY after original memoSaved=true and new updatedAt exceeds the checkbox-open baseline. The original Golden InboxSync can delete m:id after IndexedDB ACK without losing the outbox. No original Save click handler replaced.
2. The provider attempts exact single-media EXIF GPS from the source photo or ISO6709 metadata from the source video; Android scoped-media redaction is respected. JS falls back to existing photo-ID-matched FamilyJourneyNaver.sourceRows / Diary index, never guesses a nearby address.
3. New JS reads native outbox on MOA Host resume, requires original IndexedDB token ACK or hydrated persisted curated entry with the same media id/moment, then invokes ONLY the original FamilyJourneyNaver.saveFromDiaryGps method once. Explicit list '새로운' wins over fallback '내 장소'. Native memo transfers directly, blank memo remains blank. Idempotency ledger prevents repeated uncertain account writes. No manual Diary favorite click should be needed if actual runtime flow succeeds.
4. To avoid the stopped-session 'hidden' bootstrap failure on old photos, native provider reflects ONLY into the app's existing MoaNaverWebProbeController class: verified compiled methods start(Activity) and setHidden(Activity,boolean) execute sequentially on the SAME Android UI thread before the next draw. It reuses the existing first-party WebView and login session, never creates a second browser. This is a hypothesis for zero-flash behavior and MUST be physically tested.

## Test evidence and limits
- GitHub Actions run 43057299312 compiled ONLY additive provider; DEX SHA256 5f23ebf6e8d8d801e59f6fa6b3a14cac4030afaff3b29cb750911f956967cdbf, original 17 DEX never recompiled.
- Node synthetic tests PASS: exact list, typed memo, original IndexedDB commit gate, auto-dispatch once, duplicate guard, checked OFF, native photo-ID GPS, missing GPS and blank memo.
- Binary AXML parsed and validated: old native provider preserved, new unique non-exported provider inserted, old original DEX and WebView writer byte-equal.
- NOT tested: actual Galaxy installation, zero on-screen flicker, Android Native provider lifecycle callback on this user's device, server-verified new-list creation and automatic saving. R365 is BETA, NOT FINAL or GOLDEN.

## Real-device test order / recovery
Install R365 as same-package original-signer update over current R361 WITHOUT uninstall/data clearing. Check old Diary/voice/gallery and original NAVER behavior. For one old GPS photo test offscreen; then make ONE QuickRecord with checked '장소 저장', type '새로운', add text, press original '일기 저장' once. Do NOT press Diary nonoccupying favorite button. Confirm first-party NAVER saved-list readback and actual folder; do not repeat uncertain save. If regression, R367 forwards to exact R355 functional original. Future versionCode must be >367 after recovery.

## Durable source references
Feature branch: feature/moa-r365-durable-quick-hidden-bootstrap-20261112, exact additive Java source experiments/moa-r365/MoaR365CompanionProvider.java and workflow .github/workflows/moa-r365-native-additive.yml. Exact browser-side JS/tests/build/QA in conversation ZIP; personal Library quota prevents a redundant large ZIP upload. Existing original R345 Golden remains privately archived. No AirPods/Android Auto files touched.