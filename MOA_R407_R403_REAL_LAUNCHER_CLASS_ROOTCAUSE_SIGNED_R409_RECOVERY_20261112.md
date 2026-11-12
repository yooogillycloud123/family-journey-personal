# MOA R407 — R403 startup bootstrap NEVER ARMED because actual launcher class is MoaIconHost (2026-11-12)

## User's actual failure / evidence
- User installed/tested original-signer R403 and reports no automatic first NAVER PC WebView setup at MOA startup. After first offscreen photo save: WEB_LOGIN_REQUIRED and QUEUED_VISIBLE; NAVER PC WebView appears, no account save yet. Private video 20789.mp4 (~10.1 sec) and image 20790.png. Keep raw private.
- Prior first visible web open -> hide -> subsequent offscreen first-party favorites PASS under R397, also account login session preserved from R391. Do not undo.
- The exact R403 `assets/web/fj-naver-favorites.js` function `tryR289Offscreen()` has immutable Golden logic `if(!probe?.running){naverWebProbeControl('visible'); ...; return false;}`. This is **conditional**, not "always open": when initial bootstrap never ran, it necessarily triggers foreground. The source of QUEUED_VISIBLE is `MoaNaverWebProbeController.control()`, not an account write acknowledgment.

## **BINARY-PROVEN REAL ROOT CAUSE (not a hypothesis)**
- Real R403 binary AndroidManifest.xml: enabled LAUNCHER activity-alias `com.juhyeon.familyjourney.MoaIcon_A_modern_bold_pink` targets **`com.juhyeon.familyjourney.MoaIconHost`**.
- Actual R403 DEX class_def chains: `classes5.dex` `MoaIconHost extends MoaMomentAudioHostActivity`; `classes6.dex` `MoaMomentAudioHostActivity extends MoaMomentVoiceHostActivity`; `classes4.dex` `MoaMomentVoiceHostActivity extends HostActivity`; `classes2.dex` `HostActivity extends android.app.Activity`.
- Original R403 provider `MoaR391SessionPersistProvider.valid(a)` tested only **`HOST.equals(a.getClass().getName())`**, with HOST exactly `com.juhyeon.familyjourney.HostActivity`. **Actual `MoaIconHost` never passes**, despite being a subclass. `onActivityCreated` thus never inserts Run and `onActivityResumed` finds none; the automatic STOP → full-size visible START → 460ms → HIDE sequence **never began** on ordinary launcher path. No need to guess whether URL/DOM gates or timing caused this specific ordinary launch failure.
- Secondary code risk: cover attached during `onActivityCreated` may have been removed by later `HostActivity.setContentView()`. R407 rechecks the cover's actual parent at `begin()` and reattaches to real `android.R.id.content` if needed, before starting full-size NAVER WebView. This guard is preventive; detached-cover behavior was not separately observed on Galaxy.

## Precisely changed R407
- From **exact R397** (user-returned working features) signed SHA `268332af789e0d748b73b3e64ce2c75f627f3b2a7a9d7d56ae5af0c142348206`, retaining R391 cookie persistence.
- Source branch `feature/moa-r407-real-launcher-class-fix-20261112`: `experiments/moa-r391/MoaR391SessionPersistProvider.java`.
- `valid(a)` accepts `MoaIconHost` and original `HostActivity`, no other activity names. Original R403 sequence and 460ms hold unchanged. Cover-parent reattach added after real content layout.
- Android CI **[43234183436](https://github.com/yooogillycloud123/family-journey-personal/actions/runs/43234183436)** SUCCESS; compiled `classes17.dex` size 16,064 bytes SHA256 `7f00405fa15fca344516348b5cc1b0d0b4e80a1d0f3de0bd8ab60d7d1e15b7c4`. Exact DEX contains `MoaIconHost` and `COVER_CHECKED_AFTER_HOST_CONTENT`.
- R407 **`MOA_R407_REAL_LAUNCHER_COVER_REATTACH_SIGNED_BETA.apk`** versionCode **407**, 8,928,684 bytes SHA256 **`ecfde9ac17d6bbf8c368dac0fc0d5c16b7729aca246f26a10b56d3e5190d2c97`**. Same original package `com.juhyeon.familyjournea`, original cert SHA256 `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`.
- R397 140 archive members: **only AndroidManifest.xml versionCode and classes17.dex changed** (138/140 byte-equal); original 16 DEX, entire web assets including first-party NAVER writer/frame, Diary/Gallery/native recorder/Voice, home dot exact payload byte-equal.
- APK Signature Scheme v2 actual RSA signature **and full SHA256 content digest** independently verified; ZIP CRC, STORED alignment, all DEX SHA1/Adler32 PASS. This verifies binary correctness **NOT Galaxy behavior**.

## Recovery R409 / storage
- **`MOA_R409_FORWARD_RESTORE_EXACT_R397_FEATURES.apk`** versionCode 409 SHA256 **`245eacd9816b5bdc6073b3b68997731c7ae91160b8e3f3027d9a343009911c5b`**, 8,916,808 bytes. 139/140 R397 member data identical; only Manifest version changed. **Emergency only on R407 serious regression.** Not a fix and not routine install; if installed next new app versionCode >409.
- Signed APKs/source/QA backup `MOA_R407_LAUNCHER_BOOTSTRAP_R409_RECOVERY_QA.zip` SHA256 **`c197e832dbc7323e5c844d8a4bb2ce8c4e4661e8a7de3e1962433acbc11285fd`** 12,910,952 bytes. Saved PRIVATE Library `/모아_프로젝트_근거_20261103/R407_LAUNCHER_FIX_20261112/`. No keystore, private password, cookie or user media in archive or GitHub.

## Truth / next device test
- R403 ordinary launch automatic bootstrap **confirmed source-level impossible** because exact class equality mismatch. R407 removes this blocker; R407 physical Galaxy test **PENDING**, do not mark no-pop-up success early.
- User currently code403 or 405 can update-in-place to R407 with same signer; never uninstall/clear app data/cache/cookies. First cold launch -> immediate offscreen save before the four-minute expiry -> read actual NAVER account list; confirm no visible PC map.
- **KNOWN OTHER LIMITATION:** original `MoaNaverWebProbeController.scheduleExpiry()` invokes `dispose()` after ~4 minutes. Since original controller and Golden JS were deliberately frozen, after expiry the unmodified `tryR289Offscreen` still calls `visible` on next save. R407 is NOT an "any time forever" solution. For truly persistent no-popup, a separately evidenced safe rearm on expiry/on next explicit save is needed, preserving original first-party account readback. Do not claim otherwise.
- `MOA_R407_BOOT` native event logs should show cover attach/reattach, CLOSE_REQUESTED/FINISHED, VISIBLE_STARTED_MASKED, HIDE_CONFIRMED and STOP_VISIBLE_HIDE_COMPLETE. On failure record phase, no guessed root.
- AirPods/Android Auto code unaffected.
