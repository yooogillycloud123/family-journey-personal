# MOA R361 — R357 QuickRecord→GPS→NAVER 연결, 메모 교차오염, 비점유 웹창 시작 수리 (2026-11-12)

## 사용자의 실제 증거 (기기)
- 사용자 20522/20526.png 및 20519.mp4 (~125초): R357 순간기록의 **장소 저장** UI는 실제 화면에 보인다. 그러나 체크한 순간기록→NAVER 비점유 저장이 실패하며, 일반 일기 저장은 점유/비점유로 성공할 수 있다.
- 비점유라고 눌러도 NAVER PC WebView가 한 번 앞으로 나타나고 사용자가 '지도 웹창 뒤로 보내기'를 수동으로 누르는 문제가 있다.
- 같은 주소의 여러 일기 사진 편집기에 예전 순간기록 텍스트가 네이버 메모로 반복 선입력되는 모습이 있다.
- User confirmed exact R345 user-device Golden and R355 restoration. **Never lose original diary/gallery/voice/native recorder!**

## Evidence-confirmed root-cause locations (R357 actual APK)
1. `assets/web/moa-r357-quick-bridge.js` `precisePoint()` searched ONLY `FamilyJourneyDiary.state.photos/videos`, while original `__moaNativeSync` already ACKed IndexedDB before asynchronous `__fjDiaryChunk` and MediaStore GPS index completed. The temporary status was saved as `NEEDS_GPS_OR_PHOTO_INDEX` but `dispatchOne` only allowed retries on `NEEDS_GPS` / `NEEDS_PHOTO_INDEX`, so it could become permanently blocked even after metadata arrived. R361 directly queries **exact original photoId** from already-available `FamilyJourneyNaver.sourceRows()` and retries bounded until index is ready. Never infer GPS from text or city.
2. `assets/web/fj-naver-favorites.js` shares `state[key(p)]` at **lat/lon toFixed(4)** (approx 11m), so multiple photos at same location reused `old.memo`; `diaryDraftForGPS` selected `saved.memo || diary.memo` and `saveFromDiaryGps` selected `memo || old.memo || diary.memo`. Blank explicit memo silently fell back to an unrelated photo's old text. R361 uses exact photo mediaId, **per-photo diary memo precedence**, explicit empty memo stays empty; `assets/r28-diary-location.js` always passes original mediaId into diary location editor. Does not edit/delete existing diary or already-saved NAVER account data.
3. Golden `tryR289Offscreen()` on missing session explicitly did `naverWebProbeControl('visible')`, causing the foreground flash. R361 sends `naverWebProbeControl('hidden')` and waits for first-party native `running&&hidden` status before using the **same original R345 phone_submit/save/readback** logic. Controller DEX contains `HIDDEN_PROBE_START` native status, but whether the hidden launch actually succeeds on Samsung is a **physical-device test gate**. It NEVER substitutes an early `WEB_SESSION_NOT_READY` that broke R349. If the hidden startup cannot be confirmed, it fails closed as `WEB_HIDDEN_START_UNAVAILABLE` and the user may explicitly open the login web UI.
4. Standalone native provider `classes17.dex` was storing checkbox/list only on `Save.ACTION_DOWN` and racing original save with delayed writes. R361 now persists on checkbox/list edits and uses SharedPreferences listener to reattach the optional fields after the original native note Save; **never replaces the Golden Save touch/click handler**. Original 16 native DEX byte-identical.

## Exact installable signed artifacts (2026-11-12)
- **`MOA_R361_QUICK_GPS_MEMO_HIDDEN_START_BETA.apk`** versionCode 361, bytes **8,931,818**, SHA256 **`15a40c0a15dc17acfff6845c44f66523dcd9f7c1d06b5e5b3f9210611b8ec0cf`**.
- **`MOA_R363_FORWARD_RESTORE_EXACT_R355_GOLDEN.apk`** versionCode 363, bytes **8,907,248**, SHA256 **`46c17977289aea31d54b25e6bb3e746200f6c82cc9c09c356eff67af3320de2c`**.
- Signed ZIP **`MOA_R361_APK_R363_RECOVERY_SOURCE_QA_20261112.zip`** bytes **12,943,988**, SHA256 **`5e46f1446d6327a26b8a533b56385259c8898a39f6541aa1c0b0a5f60892b541`**, includes two exact APKs, QA, native/JS source patches, 8 contract test cases and Korean instructions. Exact signed outputs were built in current container and ZIP CRC+inner APK bytes verified. Source ZIP contains **no signing private key, keystore/password, photo/recording/GPS logs or account secrets**.

### APK byte-level preservation
- R357→R361 only 5 existing members changed: AndroidManifest.xml (361), `classes17.dex` (additive native hook), `assets/web/moa-r357-quick-bridge.js`, `assets/web/fj-naver-favorites.js` (**3 narrowly scoped code sites: hidden startup, photo-specific draft, explicit memo**), `assets/r28-diary-location.js` (pass exact media ID).
- **All original R355/R345 16 DEX, original recorder Activity, Diary `family-diary.js`, Naver frame probe/controller DEX, settings, gallery/voice, return controls byte-identical.**
- Original signer cert SHA256 `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15` retained. Independent APK v2 RSA signature + full chunked SHA256 content digest, ZIP CRC, stored DEX/resources alignment, and 17 DEX SHA1+Adler PASS.
- **R363 exact R355 functional restoration**: every original archive member (same names) byte-identical to R355 except AndroidManifest versionCode363; update-install same original certificate. Not a separate user-accepted Golden until physically installed.
- Native-only GitHub Actions `43049037405` PASS on feature branch `feature/moa-r361-native-gps-memo-hidden-20261112` (provider JS/Xposed omitted, original recorder class not recompiled).

### Automated checks
- Node VM source+mock tests: direct photo-ID→GPS with unloaded diary index PASS; delayed MediaStore row PASS; checkbox OFF = zero writes PASS; GPS absent = no fabricated location PASS; exact token duplicate = one write PASS; explicit empty memo PASS; stale memo from different photo at same GPS NOT copied PASS; hidden start command/known media-ID contracts PASS.
- These tests do **not** establish Android WebView hidden-start acceptance, Galaxy native preference callback timing, Naver account readback or successful save on a physical device.

## Device gate / do not claim FINAL yet
1. Update install R361 over currently installed R357 (or R359 recovery) **WITHOUT uninstall/data clearing**. Confirm original recording/voice/Diary and existing Naver save controls persist.
2. At one known GPS photo, QuickRecord check ON, custom/pinned list, type current text; '일기 저장' once. Verify current photo memo and first-party NAVER list exactly once.
3. On a separate photo at same location with blank memo, check it stays empty rather than inheriting previous photo text.
4. Test offscreen from stopped/hidden WebView: page should not appear. If status `WEB_HIDDEN_START_UNAVAILABLE`, report that exact first blocker; do not repeat account saves.
5. On regression, **R363** forward restore only; restores R355 original features and removes incomplete additions. R363 physical install not yet tested. After R363, future release versionCode >363.
6. Never touch immutable R345 Golden, user data, or AirPods/Android Auto daemon/audio.

## Retention
- Stable original Golden ZIP remains private Library `/모아_프로젝트_근거_20261103/R345_20261111/MOA_R345_APK_R347_RECOVERY_TESTS_20261111.zip`.
- New signed R361 ZIP and individual APKs are verified in the current conversation sandbox, not a falsely claimed separate Library upload (private Library is at storage limit). Exact release ZIP is attached in the current conversation.
- The feature branch has exact isolated native provider source+CI. Full JS source, diff and tests are included in release ZIP; GitHub handoff records file hashes, test outcomes and remaining device gate.
