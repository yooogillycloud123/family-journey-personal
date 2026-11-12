# MOA R403 — Exact user-proven STOP → VISIBLE OPEN → 460ms → HIDE masked bootstrap (2026-11-12)

## Physical evidence and non-negotiable sequence
- User has a **working R397 behavior** after logging into NAVER manually once: if the NAVER PC WebView cannot be reopened, use Settings **웹창 종료** then **네이버 PC 지도 열기**, keep it briefly visible (user reports even roughly 0.1s sufficed), then **모아로 / 지도 웹창 뒤로 보내기**. The first offscreen save subsequently works in their physical Galaxy. User demands this SAME primitive sequence happen automatically on MOA launch, behind the MOA startup splash, without a PC map popup.
- **R395 physically FAIL** (hidden-first instead of visible bootstrap).
- **R399 physically FAIL** (private 20781.mp4: after splash/Diary, first save forces visible map). Root code defect: conditional `findAndStart` only starts when MOA WebView URL and localStorage preference match; `poll` rejects early visible map unless URL and DOM readiness match, then disposes the candidate; R397 JS visible fallback remains and pops browser. Exact failing gate unknown because R399 swallowed exceptions. Never re-label R399 as success.
- R403 is the FIRST candidate that **unconditionally calls exact STOP, then exact original visible START, holds for 460ms, invokes original HIDE** under a native MOA-look opaque cover. It does not gate on URL, localStorage mode or DOM readiness.

## Exact source/CI
- Branch: `feature/moa-r403-exact-stop-visible-hide-20261112`.
- Source: `experiments/moa-r391/MoaR391SessionPersistProvider.java` (ContentProvider class name preserved).
- Android compiler/D8 isolated CI: [43230889895](https://github.com/yooogillycloud123/family-journey-personal/actions/runs/43230889895) **SUCCESS**; `classes17.dex` SHA256 `a12850407287e0b6b591e2ae57cb9e69838ce99ac08062b0c1c367c899b3afc2` (15,832B).
- Lifecycle: `HostActivity.onActivityCreated` installs native MOA-cover above `android.R.id.content` before first frame; after `onActivityResumed` 55ms, direct original `MoaNaverWebProbeController.dispose()` (same exact primitive as Settings '웹창 종료') → `onHostResumed(Activity)` → private original `start(Activity)` (same as Settings '네이버 PC 지도 열기' on stopped controller). On same main-loop frame bring cover to front, retain full-size visible-map layout for 460ms, then private `setHidden(Activity,true)` (same as button '모아로') → require `running && hidden`, remove cover ~60ms later.
- No reliance on NAVER URL/DOM readback because user's tested sequence did not require fully loaded page. If startup/browsing/hide fails, dispose only this owned WebView before removing cover; don't falsely claim any NAVER save success. One-shot per newly-created HostActivity, not each onResume.
- Retains previously R391 existing cookie flush on Activity pause/stop, no cookie reads/copy/delete; no NID captcha/login automation, no extra app, no root/Shizuku.
- Native `Log.i("MOA_R403_BOOT",stage)` and private `moa_r403_bootstrap_stage` SharedPreferences record non-sensitive status strings, no account/GPS/cookies. This is a diagnostic record, not a live proof on Galaxy.
- Original NAVER WebView controller still has approximately four-minute expiry; unchanged for regression protection. Do not claim this automatically works forever beyond expiry.

## Signed native deliverables / exact preservation
- Base exact same-signer user-tested R397, `MOA_R397_FORWARD_RESTORE_EXACT_R391_FEATURES.apk` SHA256 `268332af789e0d748b73b3e64ce2c75f627f3b2a7a9d7d56ae5af0c142348206`.
- **R403 APK** versionCode 403 `MOA_R403_R397_MASKED_STOP_OPEN_HIDE_SIGNED_BETA.apk` SHA256 **`5db1412dcfdd8487691a7a3f5066709a3703c657b14e643ccf2cbe27c2bec384`**, 8,928,452 bytes. Exact R397 140 entries: ONLY `AndroidManifest.xml` versionCode and `classes17.dex` changed, **138/140 original members byte-identical**, all 16 original DEX, native gallery/recorder/diary, all NAVER login & account writer JS, and pink Home unchanged.
- **R405 emergency** versionCode 405 `MOA_R405_FORWARD_RESTORE_EXACT_R397_FEATURES.apk` SHA256 **`f483dc9fb86b262e6a5527d94550f33339ffeb50bef5cb61bbee156e38030c5d`**, 8,916,808 bytes; **139/140 R397 payload entries identical** except Manifest versionCode. This is EXACT R397 functional restore, **NOT** new hidden bootstrap. Only after severe R403 regression. Next functional APK must exceed code405 if R405 installed.
- Same original certificate SHA256 `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`. Independently verified APK Scheme v2 RSA/full SHA256 digest, ZIP CRC, STORED 4-byte alignment, all 17 DEX SHA1/Adler32 and binary manifest versionCode. Source order contract PASS. **All static, no actual Galaxy runtime proof.**
- Combined `MOA_R403_STOP_OPEN_HIDE_R405_RECOVERY_BACKUP_QA.zip` SHA256 **`8b937209a45a4c9cdeee3c17964c2c7f313b15e75e8e0cc7df424e97af8b8bd7`**, 12,910,746 bytes; private Library folder `/모아_프로젝트_근거_20261103/R403_EXACT_STOP_VISIBLE_HIDE_20261112/` holds signed APK+recovery ZIP, source and QA. ZIP contains no keystore/private key/password/cookie/photos/videos.

## User test gates
1. Preserve currently installed same-signature R397/R399/R401 app and login state: in-place update to **R403**; **no uninstall, cache/data/cookie clear**.
2. MOA cold launch must show only MOA mask (no NAVER PC window flash) then Diary/normal view.
3. First offscreen favorite after cold launch must remain nonoccupying AND appear in actual NAVER account list. `HIDDEN_ATTACHED...` is not a successful save.
4. Repeat after cold launch and, separately, after original ~4-minute session expiry. This is not yet claimed fixed.
5. Check native Moment recorder/Diary/Gallery/voice, pink Home and existing NAVER manual buttons.
6. On failure, future work must collect non-sensitive `MOA_R403_BOOT` stage and actual user video; change only proven gate. **Do not create R407 blind fixes**. If severe R403 regression, use R405 in place for exact R397 feature restoration.

### Status
- Android CI compile: PASS
- Same signer, APKv2 crypto/full digest, original member preservation, DEX/ZIP: PASS
- Galaxy first-lauch no popup / actual NAVER account offscreen save: **NOT VERIFIED**
- R397 physical one visible PC web then hidden/offscreen: USER-REPORTED PASS
- AA AirPods/Android Auto/audio daemon: untouched
