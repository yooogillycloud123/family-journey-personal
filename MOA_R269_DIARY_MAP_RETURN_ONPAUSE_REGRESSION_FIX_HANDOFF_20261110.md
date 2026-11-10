# MOA R269 — 20135.mp4 verified missing ↶ MOA from Diary / fixed actual onPause source deletion (2026-11-10)

## User verified behavior and private video
Galaxy video `20135.mp4` 41s (PRIVATE; do not publish raw family media/GPS):
- Original Gallery photo → NAVER Maps shows the existing floating ↶ MOA pill (t≈5–7s), 1-tap works to MOA.
- Diary photo location card's **네이버지도** (distinct from native gallery map button) → real NAVER map appears **without the ↶ MOA pill** (t≈13–16s); repeated Back needed.
- Diary favorite+memo via first-party NAVER accessibility currently works as user-reported **foreground workflow**. User insists retain it intact, while separate fully nonoccupying background saving remains unsolved.
- Existing popup setting and underlying native first-party NaverSaveService must be preserved. No fake screen cover.

## Real signed R265 source-level root cause (not general conjecture)
- R265 `HostActivity.startActivity(Intent)` checks first-party NAVER `nmap://`/package/map.naver.com and invokes `MoaNaverReturnOverlay.showIfAbsent(this)`.
- But `MoaMomentAudioHostActivity.onPause()` unconditionally attempts `unifiedGallery.close()` unless the old Gallery's `r227RetainForExternalMap()` is true. This flag is set **only for the original Gallery map button**.
- When Diary photo location button uses `assets/r28-diary-location.js → NativeHost.post('diaryOpenNaverPlace') → HostActivity.diaryOpenNaverPlace → startActivity(NAVER)`, a non-null cached `unifiedGallery` can be closed during onPause. **`MoaNativeGallery.close()` starts with `MoaNaverReturnOverlay.hide()` unconditionally**, deleting the shared pill that HostActivity showed just before launching NAVER. This exactly explains gallery PASS vs diary map FAIL with the user's actual video.
- The original Gallery's same-photo `r227ExternalMapPending` was correct and must not be changed.

## Exact R269 minimal signed APK and verifications
- `MOA_R269_NAVER_ALL_ENTRY_RETURN_REPAIR.apk` versionCode269 `com.juhyeon.familyjournea`, original signer SHA256 `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`, APK SHA256 **`c0663e65aac2b72feb86cb0f1ba5eac448b6599c3850858de4d942f2aa446920`**, bytes 8,932,642.
- Backup `MOA_R269_APK_WITH_KOREAN_GUIDE.zip` SHA256 `8a56d7403db129c40eb28f30460a2c6196718f70def65b4bfed9b652233278c5` with bit-identical APK, Korean usage, QA JSON.
- Diff vs signed R265: only **3 original non-signature payloads changed**: `AndroidManifest.xml` 265→269, `classes2.dex` HostActivity, `classes6.dex` derived AudioHostActivity. **135 other non-signature APK entries byte-for-byte identical**, including `classes10.dex` original popup, `classes16.dex` notifier, `NaverSaveService` and all diary/gallery/QuickRecord/voice JS and native storage.
- `HostActivity.startActivity`: when NAVER Intent recognized, sets static transient `naverExternalPending=true` *before* original `MoaNaverReturnOverlay.showIfAbsent` and `super.startActivity`.
- `MoaMomentAudioHostActivity.onPause`: skips **only `unifiedGallery.close()`** if NAVER launch is pending. All existing voice recorder, speech, video overlay, media playback onPause cleanup remains untouched. This preserves same Gallery and existing pill while native NAVER foreground is active.
- `HostActivity.onResume`: when MOA actually returns to foreground, resets pending marker and hides previous overlay. Default app and normal non-NAVER app navigation unchanged.
- Full apktool smali build 0 errors; APK v2 original cert + aapt/version + zipalign + ZIP CRC + all 16 DEX SHA1/Adler PASS; final signed APK **re-decoded** and new methods/call order verified. Backup ZIP inner APK SHA identical. No real Galaxy R269 QA yet; static compilation is not account-save PASS.
- `MOA_R269_SOURCE_DIFF_NO_PRIVATE_SIGNER.zip` contains minimal source/QA/build reproducibility with no private keystore material. Private archive path `/모아_프로젝트_근거_20261103/R269_UNIVERSAL_NAVER_RETURN_LIFECYCLE_20261110/`.

## Emergency rollback (do not pre-install)
`MOA_R271_EMERGENCY_RESTORE_R261.apk` SHA256 **`1348b2536dbe223c8c9771d7e8a9902903d61d96a0cb69e691af5f57cf931573`**, package/cert unchanged, versionCode271; **all functional payloads byte-identical user-running R261**, only Manifest code261→271. Use only if R269 crashes, never uninstall/clear data.

## Strict original end goal — NOT falsely finished
User demands one MOA APK where photo EXIF GPS/Diary/QuickRecord can send exact NAVER account favorite list-create/place/alias/memo **without ever switching screen** and read back exact user account data. R269 does **not** implement offscreen NAVER account writer; first-party NAVER app + Accessibility is still foreground and screen-occupying. Android's private/untrusted virtual display third-party launching is restricted (AOSP https://source.android.com/docs/core/display/multi_display/activity-launch); Samsung Internet Custom Tabs do not grant arbitrary DOM/cookies, and prior R241 WebView NAVER root redirected in Galaxy. Requires real verified Android-internal authenticated browser/server write mechanism; don't claim functionality from UI save toast or desktop mock.

## Absolute next gates
1. Install R269 update over R265; verify normal launch, Diary top-map → ↶ MOA one tap, Gallery same-photo route, Diary favorite frontground existing place/alias/memo.
2. Verify result toast ON/OFF and preservation of photo/voice/calendar/quick record.
3. Separate real **offscreen-account** technical implementation, login consent, create list, exact save/readback, idempotency; only then mark FINAL.
4. Never edit immutable R227 Golden or user-proven R261/R255 originals, private photos/GPS/keystore.

