# MOA R66 — R63 GOLDEN preserved, R64 physical UX feedback

## Actual new user screenshots (2026-11-03)
- R64 thumb-zone floating camera "바로 기록" is physically visible and placement approved.
- Native memo editor voice/SAVE buttons are too high. R64 OHO+ dynamic shortcut "모아 기록 전환" missing from Samsung chooser.
- The selected-photo diary renders seven photos from 22:23 to 22:55 in **ONE** time segment; source `segments` used rolling **60-minute** photo gap, not a fixed window. Photo capture timestamps and displayed per-note minutes are separate.
- Existing NAVER Maps favorites automation works visibly, but user requests no exposed NAVER UI.

## Frozen user-confirmed baseline
- Read `MOA_R63_USER_DEVICE_GOLDEN_LOCK_20261103.md` first. Exact Golden APK SHA256 `64b1b730478a2a50976961cc2dc4cf511182a75495f2d02159f091167f646024`. Its private same-origin WebView writes IndexedDB `familyjourney-diary-v1/curated` with transaction/readback and original media IDs/time. NEVER replace this flow or reintroduce second memo popup.

## R66 implementation
- New branch `fix/moa-r66-thumb-editor-pinned-5min-20261103` from R64, not Golden branch.
- Java `MoaMomentMemoActivity`: ScrollView body + **fixed bottom voice and save buttons**, `ADJUST_RESIZE` above keyboard. Native STT, commit, direct IDB sync identical.
- Java `MoaMomentApplication`: R64 had only a dynamic shortcut and wrong-icon namespace. R66 resolves launcher icon from actual installed app resources; publishes dynamic shortcut and **prompts once** for Samsung launcher user-approved **pinned** "모아 기록 전환" shortcut on opening MOA. Uses existing QS `switchTo` and explicit short-lived activity intent. Whether One Hand Operation+ discovers the pinned shortcut is **UNVERIFIED on Samsung**. No extra app package.
- Diary JS **display-only**: fixed wall-clock **five-minute** segments using `Math.floor(t/300000)`. For example: 22:23/22:24 => 22:20–22:24; 22:25 => 22:25–22:29; 22:31 => 22:30–22:34; 22:55 => 22:55–22:59. Keeps exact native media capture times, memo associations, IndexedDB schema, stored notes and user-edited day content unchanged.
- NAVER **fully invisible saving not implemented**. Existing NAVER `naverArm` bridges to an AccessibilityService that controls the **active NAVER window**. Android's active-window contract means simply minimizing NAVER cannot guarantee the same behavior. No verified official personalized NAVER favorite-list/memo write API. Do not create imaginary background capability or break existing NAVER process.

## Source, build and static evidence
- Based on real R64 SHA256 `047bd509f99221a821ba5a57b1813cb19b74bda3930908db77d75c4f60b40b28`.
- Android D8 GitHub run `41652066895` successful; final DEX SHA256 `6e71a3c5b0b0855ecd0ad99342cf0307f038c7f2979193b6f683f4b158f2be1d`.
- Final signed APK `MOA_R66_Thumb_5min_PinnedShortcut_Install.apk`; SHA256 `fe733b27a86ac0ba9a48ca78ff30ce765acbdfbb53140682013f1ade06f66376`, bytes `3426429`, package `com.juhyeon.familyjournea`, versionCode 66, signer unchanged.
- APK diff **only three members changed**: `AndroidManifest.xml` version, `classes4.dex` Java UI+shortcut, `assets/web/family-diary.js` grouping. Other **51/54 members byte-identical**, including original R63 direct IDB writer, NAVER UI automation JS/native DEX.
- APK v2 signature, ZIP CRC, DEX headers PASS; original JS Node fake-IDB test PASS; new fixed-time segment tests PASS. **R66 Galaxy real-device result NOT TESTED, do not label Golden.**

## Device acceptance
1. In-place update, open MOA once, accept Samsung launcher home-screen shortcut pin prompt if shown. Then Samsung OHO+ > desired gesture > `홈 화면 바로가기` > `모아 기록 전환`; check actual ON/OFF and QS tile. If no prompt or no listing, physical gate FAIL.
2. Samsung Camera capture -> approved lower floating "바로 기록" -> native voice/save **bottom** -> same R63 curated journal, correct original capture minute, no second input popup.
3. Reopen existing 11/3 diary, verify 5-minute fixed groups; all memos/photos still present.
4. NAVER foreground save unchanged. Do not claim hidden background saving.

