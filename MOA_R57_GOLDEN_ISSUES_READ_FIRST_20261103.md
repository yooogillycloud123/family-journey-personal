# MOA R57 — Golden capture retained; native memo notification + diary sync + per-photo removal
**New MOA chats must read this before modifying the user-proven camera/voice workflow.**

## User evidence (2026-11-03)
A 44.57-second user video `18205.mp4` and screenshot `18207.png` show:
1. Samsung-camera instant capture alert and native Google speech/text memo work, but after tapping save the old R42 camera-return companion displays an unexpected second memo popup.
2. The earlier notification's '바로 메모' remains after recording a note and reopening causes confusion. Native memo save in old DEX wrote a SharedPreferences draft but did not cancel the notification.
3. Photo diary editor offered day-level deletion only, not selective photo/video unlink.

## R57 candidate built now — do not claim untested Android device success
- APK: `MOA_R57_골든보정_실시간메모_알림정리_개별사진삭제_테스트.apk`
- SHA256: `cb1031197250c3e8f708c3be0599df20b89a5fc6bda0044d6e439075ddecb5f9`
- Same app/package `com.juhyeon.familyjournea`, versionCode 57, original R54/R55 signing certificate SHA256 `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`. **R55 in-place update, no new third icon**.
- The original user owner app R37 `com.juhyeon.familyjourne8` is a different package and is never deleted/updated or migrated by this APK.

## Actual correction
- Web: detect existing native draft MediaStore IDs before R42-on-return popup, suppress only duplicate R42 popup for those captured photos. Retain fallback when native is unavailable.
- Web: await actual IndexedDB transaction commit AND read-back before ACK. Retry without losing unsaved drafts; update current diary page after commit.
- Native: GitHub Actions PR #2 `feature/moa-r57-native-notification-cleanup`, head SHA `302276768b02f5431b04a40a500323f33d8cdc1a` compiled with Android SDK35/D8, workflow run `41598850228`, artifact `13213516916`, DEX SHA256 `779061b19527cadd57d5809d3fdd5b38f31effa0dea189139d46577399613f89`. New memo save cancels **its exact notification** only after SharedPreferences commit; native capture persists `seen:<id>` so later IDB-confirmed `native.ack(id)` does not re-notify old shots. Preserve Samsung Camera overlay and native Korean STT.
- UI: individual `일기에서 제외` per photo/video + in-editor `사진·영상 개별 관리`, reversible `다시 표시`. Keep original photos/videos in system gallery (not physical delete). Day-level titles, body, moments/notes, other photos unchanged. Exclusion tombstones prevent native re-import.
- R55->R57 APK modified exactly `AndroidManifest.xml`, `assets/web/family-diary.js`, `classes4.dex` only; other 50 ZIP members remain byte-identical.
- Independent static tests: **102/102 PASS**, Java/Android SDK/D8 build PASS, APK v2 signature, all DEX checksums & no duplicated classes, JS 7+4 unit checks. **No Android R57 install/real Samsung camera test yet**.

## Field test and subsequent work
Test 2 photos + 1 video: native overlay -> memo/voice -> click save -> alert disappears -> opening MOA does NOT show duplicate R42 popup -> diary timeline note exactly once -> app restart persists. Remove only one photo/video -> original gallery stays -> restore, prior note returns. Old R55 notifications may need single manual dismissal. If it fails, preserve user data and inspect exact capture time + screenshot/log. **Never delete original R37 or clear app data.**

Web diary's own `SpeechRecognition not-allowed` is separate, remains unresolved; don't replace the proven native speech workflow to fix it.

Private Library artifacts: `/모아_프로젝트_근거_20261103/MOA_R57_골든보정_실시간메모_알림정리_개별사진삭제_테스트.apk` and R57 verification ZIP. Continue from R57, not an older R44-R53 branch.
