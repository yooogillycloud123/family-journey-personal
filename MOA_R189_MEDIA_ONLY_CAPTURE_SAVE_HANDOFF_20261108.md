# MOA R189 — PHOTO/VIDEO-ONLY CAPTURE SAVE BETA (2026-11-08)

**STATUS: SIGNED + STATIC AND SYNC-LOGIC PASS; GALAXY INSTALL/SAVE NOT TESTED. DO NOT PROMOTE TO GOLDEN.** Preserve immutable R187 user-confirmed scoped Golden.

## User report / screenshot
- User screenshot `19505.png` is private. Native `방금 찍은 사진·영상 · 모아 시간대별 메모` screen, textarea empty, clicking `모아 일기에 메모 저장` yields toast **`입력한 메모가 없어요.`** and refuses to save.
- Correct requirement: recent photo/video themselves count as a record; text and speech are OPTIONAL. Without an existing captured media record, refuse orphan saves. A blank temporary draft is NOT automatically confirmed until user taps Save.

## Exact root cause and minimal fix
- In **actual signed R187 `classes7.dex`**, exact native class `Lcom/juhyeon/familyjourney/MoaMomentMemoRecorderActivity;`, method `saveNote()V`, code item at offset 15664 (insns start 15680), word index 73: `if-eqz v7,+14` (two words: `0738 000e`). `v7` is result of `String.isEmpty()`; false used to jump over toast/return. The true/blank case fell through to toast then return.
- Replace exact same-size two-word instruction with `goto/16 +14` (`0029 000e`) to enter existing persistence path *for either empty or populated notes*. Existing captured media draft ID/precondition and `SharedPreferences` commit are untouched. That path persists note (possibly `""`) and `memoSaved:true`, making native→WebView diary sync properly acknowledge the intentional action.
- Equal-size DEX string change: button `모아 일기에 메모 저장` → `모아 일기에 기록 저장`. No alteration to other UI, voice, video, storage or diary logic.
- Recompute original-length `classes7.dex` SHA1 header and Adler32. DEX input 53,800B SHA `a48bc1728c8af8bf89e4682bab7195fd907b516f99dc572fcc87d739faaa4781`; DEX output SHA `65706f01ab0848ba36e806819ce546f6f50258173806fc4829c3f3057da3869c`. Only branch opcode, same-length button literal and DEX integrity fields changed. Exact no-key patch script: `experiments/moa-r189/patch_empty_note_guard.py` in `feature/moa-r189-empty-memo-media-only-save-20261108`. Source is deterministic bytecode patch, NOT a whole-app clean Android source recompile. DO NOT publish original signing key, private APK or family screenshot.

## Pipeline proof
- R187 `assets/web/family-diary.js` has `mmNativeCleanDraft()` and `mmNativeSaveDraft()`: a valid `memoSaved:true` media record with `note:""` adds `photoIds` and `moments`, then IndexedDB read-back and native acknowledgment. Existing draft not explicitly saved remains ACK-pending. RemovedMediaIds is still honored; text note normal.
- Exact unchanged JS run with Node isolated mock IndexedDB (from signed base APK), **5 PASS**: photo-only saved, video-only saved, empty draft not explicitly saved, text note saved, removed media not resurrected. Supplemental direct commit page `assets/web/moa-direct-diary-commit.html` also explicitly allows `!note` if `memoSaved===true`. No JS changes needed.

## Signed APK and immutability
- **R189** `com.juhyeon.familyjournea` versionCode **189**, **5,655,113 bytes**, SHA256 `d0e171782f2d72ff48ebadd81d2c2e467548f62e9a279dce8bda2fe2ccec0f9a`.
- Exactly **126/128 ZIP members identical** to exact R187 Golden SHA `4380ca0a421c3a12cfad0334e860e659112b116f6cc7099f8989475c646a97e9`. Changed ONLY `AndroidManifest.xml` versionCode 187→189 and `classes7.dex`; all native gallery `classes6.dex`, `family-diary.js`, other DEX, data assets unchanged.
- Original signer cert SHA256 `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`; independently checked RSA v2 signer, signed content digest, ZIP CRC/4-byte alignment, DEX integrity **PASS**. No changes to AA Android Auto/AirPods.
- Private Library: `/모아_프로젝트_근거_20261103/MOA_R189_MEDIA_ONLY_CAPTURE_SAVE_BETA.apk`; QA and independent signature report alongside. Signed APK and ZIP fallback delivered via current conversation.
- **No R189 real Galaxy save/installation confirmation yet.** Do not call R189 Golden or full build CI success.

## Recovery
- R187 user-verified scoped Golden stays immutable and frozen in Library and `golden/moa-r187-20261108-user-device-fixed-rail-native-seek-pass-do-not-modify`.
- Existing signed **R190 emergency-only** restores R187 exact contents with only manifest versionCode187→190; SHA256 `fd68bd84d6674aa595fbebd379b9b02310279a40d231d7ecf4f7dd48a03cec85`, same original signer and verified APK-v2, NOT tested as a physical rollback. **Use only on confirmed R189 regression**, in place; never uninstall or clear data. Do not routinely install.

## Device acceptance
1. Update existing app R187→R189 normally, no uninstall/no data clear.
2. Capture a PHOTO, open native quick record, leave text blank, tap `모아 일기에 기록 저장`: no missing-memo toast, close/success and return to MOA.
3. Confirm that same photo appears in that exact date/time day diary with an empty moment note after native sync acknowledgment (may require returning to app). Avoid duplicate.
4. Repeat with VIDEO blank note and with a nonblank note. Check voice file/no text and existing capture records remain.
5. Verify no media loss, no duplicate moments, video/photo gallery R187 Golden, timeline seek, audio volume, floating long-press panel, calendar/map/backup.
6. If device failure, preserve evidence and use R190 only after confirmed regression. Never edit R187 Golden.

## Next chat
Read canonical `workexcel-devbridge/main/AA_AirPods_FINAL_READ_FIRST_v1.0_20261005.md` start to finish, then R187 Golden lock, R189 handoff, MOA release ledger and WIP, private Library binary and QA. Continue from exact latest checkpoint and preserve AA project separately.
