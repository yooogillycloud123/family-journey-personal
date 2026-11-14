# MOA R567 USER-REQUESTED FROZEN GOLDEN BASELINE — 2026-11-14

## User decision and crucial status distinction

On 2026-11-14 the user explicitly asked to freeze the attached R567 result as the new **unchangeable development Golden baseline**, incorporating the previous R463 new-chat prompt. Therefore source/APK/QA bytes must be preserved exactly. **R567 real Galaxy functional/physical PASS is NOT established**; the current evidence is static + CI + synthetic tests only. Do not turn CI PASS or screenshots of previous assistant chat into device PASS.

**R463 stays permanently preserved as the previous user-device-approved Golden**, including original APK, signature, source, and private Library. Never overwrite R463 or R435 archives. The new immutable code reference is [the frozen R567 branch](https://github.com/yooogillycloud123/family-journey-personal/tree/frozen/moa-r567-20261114-user-requested-device-qa-pending), copied directly from `feature/moa-r567-pause-resume-native-owner-back-cards-20261114`. Never commit repairs onto this frozen branch.

## Exact binary lock

- Original user ZIP: `MOA_R567_R569_NATIVE_GALLERY_FOREGROUND_ONE_BACK_ORIGINAL_SIGNED_SOURCE_QA_20261114.zip`; 13,132,663 bytes; SHA256 `0610b55bea13ee8a8b4dc742ffef232ead068d6e4f7f2c58d18d443d50d7f21a`.
- R567 installed test APK: `01_INSTALL/MOA_R567_FOREGROUND_NATIVE_RESTORE_ONE_BACK_SAME_SIGNER_TEST.apk`; versionCode 567; SHA256 `f205afb72744391ce9f2594f898728699870be006f787c712599a1ee8492e93c`; 9,069,544 bytes; 143 entries, 18 DEX.
- R569 forward restore APK: `02_RECOVERY/MOA_R569_EXACT_R463_GOLDEN_FUNCTION_FORWARD_RECOVERY.apk`; versionCode 569; SHA256 `e3545a707402911eb9798d5e01007d066b776018d7e3d7faf96524bf9042fccd`. **R569 restores R463 functionality, not exact R567 behavior**; new photo-day features can be lost.
- Package `com.juhyeon.familyjournea`, original cert SHA256 `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`.
- R567 additive `classes18.dex` SHA256 `a073bd5222aa77f8ca452408d64469c07a556158064f91cfd9b642840982025d`.
- Prior R463 physical user-approved APK SHA256 `9d2fd10d32a3bc35eb3132333e96edd8f565abd5daf3ce954b052f77083d8379`.

Verified from user-uploaded ZIP in new chat: 17 ZIP entries CRC PASS, 16/16 SHA checks PASS, original bundled independent public-only `QA/verify_release.py` re-run PASS for both same-signer APK v2 RSA/content digest/DEX.

## Protected mechanics, functionality and failures

User physical R563 videos `21846.mp4`, `21847.mp4`, `21850.mp4` establish the real problem: gray 0.5-1s after first Back, and after Home/Recents/external app native Gallery becomes gray/invisible/old Web with broken Back/reentry. R567 fixes by rendering calendar BEFORE closing native Gallery; prePause + native host detach watches separate explicit Back from OS pause; 150/480/950/1700/2750/3950ms bounded return verification, same-day JS ACK before success; restore live Gallery with VISIBLE/alpha1/bringToFront and token/MessagePort only, **never close healthy host**; reopen only truly lost trusted same-day native host once. Preserve exact R535 integer geometry/R527 WebMessagePort, no new scroll rewrite. This is source/test intent, not proven device behavior.

Never lose the actual R463 native photo+video mixed Gallery, horizontal bottom rail, player audio/seek/capture, zoom/pinch, selected-media preservation, original four-button 50dp deck **Share / NAVER map / folded map capture time-address-default-show / large-stage swipe ON-OFF** (fourth default OFF). Preserve first-party NAVER private favorite session and hidden offscreen write, diary/quick record/voice M4A/transcript/photos/GPS/DB/cookies/themes/pink home. Do not reintroduce legacy Web play controls, alpha0 proxy or old R555 fractional jitter. Do not change AirPods/Android Auto.

## Next release / rollback

- New candidates **versionCode >=570**, separate development branch; exact R567 untouched.
- Verify protected R463 17 DEX and R563's 140 original members, exact Java/JS/CSS deltas, APK signed full digest, DEX/ZIP and true Galaxy behavior.
- Provide a new higher-than-candidate **exact-R567 functional** recovery APK only once its bytes/signature are actually generated and verified. Do not mislabel R569.
- Never uninstall, clear data/cache/NAVER cookies, replace signing identity, delete private credentials or publish original signing keys.
- Keep current/previous real-device PASS/FAIL/PENDING explicitly separate. Read full [R567 handoff](MOA_R567_R569_FOREGROUND_NATIVE_HOST_BACK_RETURN_SIGNED_HANDOFF_20261114.md), [R463 Golden lock](MOA_R463_GOLDEN_LOCK_READ_FIRST_20261113.md), [current WIP](MOA_WIP_CHECKPOINT_CURRENT.md), and [new chat prompt](MOA_NEW_CHAT_RESUME_PROMPT_R567_FROZEN_20261114.md) before changing code.
