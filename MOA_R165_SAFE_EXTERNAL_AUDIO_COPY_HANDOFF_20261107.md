# MOA R165 safe external audio copy — device-untested BETA (2026-11-07)

## Authority
- **Latest USER DEVICE BASIC GOLDEN is still R163**, frozen signed SHA256 `f789a3a579102bfb34a77da11be9b99b18b54906527c428603885bbd130e68e1`; do not edit/overwrite it. The user requested external media protection LIKE Gallery, but insisted on no loss of working recording, transcription and Diary functions.
- New signed R165 BETA `com.juhyeon.familyjournea`, versionCode **165**, size **5,551,221 B**, SHA256 `989c50d3b06fb91a853c84a64f23e427d58afb8255a6b3449a843682456547e5`; original signer SHA256 `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`. Independent nested APK-v2 RSA signature, full signed digest, ZIP CRC+alignment PASS.
- Baseline diff vs R163: **126/128 APK payload members unchanged**. Only binary Manifest versionCode 163→165, and isolated native `classes7.dex` changed; no other classes.dex–classes6.dex, voice JS, Diary, video, map, camera, calendar code changed.
- Feature branch `feature/moa-r165-media-audio-safe-export-20261107` based on R163 frozen source. CI isolated Android SDK35+Java17/d8 compile PASS; new DEX SHA256 `481d4f52425784019884f1b775a68befcdb7e93adc9a63e1324dfca534718be1`, source SHA256 `118f4bf7609acdd84cf021f22fa50fd6a4ec9f9073433362e177d188fa5d4128`. Full historic repo Java job still fails due to incomplete old Android source; it is not used for this isolated APK.
- Signed R165 APK, ZIP, QA & no-key handoff private Library `/모아_프로젝트_근거_20261103/`; private Library binary re-read hash equals original local SHA.

## R165 real change and explicit limitations
1. On native camera “바로 기록”, **new M4A is saved app-private exactly as R163**; when Android file-source text recognition finishes, errors or times out, a background task copies it to Android MediaStore.Audio shared `Recordings/MOA/YYYY-MM-DD/MOA_YYYY-MM-DD_<id>.m4a`. SHA256 from original & external read-back must match, only then `IS_PENDING=0`. The app-private file stays untouched. R163 recognition speed is prioritized by not doing external copy in parallel with PCM decoding.
2. Scrollable “바로 기록” body adds a clear backup-status line and a confirmation button **“기존 녹음 원본 모두 외부 폴더에 보관하기”**. It copies existing app-private files from all dates (both native quick record and Diary voice recording) without deleting them. Date/name lookup and SHA matching avoid duplicate public files when re-exporting with the same accessible owner.
3. No new storage permission is needed to add audio files created by the app on Android 10+; on reinstall access to old media owned by prior installation may require `READ_MEDIA_AUDIO` permission or SAF, NOT yet implemented.
4. **R165 is a conservative copy+verify stage, NOT full relocation. App data is NOT lighter and total phone storage grows because both private and shared M4A exist**. This is deliberate to preserve R163 playback/recording/STT. Public shared audio may be visible to other apps.
5. On uninstall, successfully exported shared M4A survives; **unexported private audio and Diary/Text/IDB metadata are NOT preserved**. No automatic media import or re-link, no comprehensive Diary metadata export/restore yet. User must avoid uninstalling and must not clear app storage. Future R167+ after physical R165 validation: metadata/index backups, permission-aware re-link, optional primary audio store cut-over, then user-approved deletion of verified internal duplicates.

## QA and recovery
- **R165 Galaxy install & MediaStore folder/export and all R163 features: PENDING actual on-device verification. DO NOT PROMOTE R165 GOLDEN.**
- Emergency-only rollback-forward signed R166: exact R163 behavioral APK contents except binary Manifest versionCode **166**, SHA256 `4e10608fa3838e4cecf70e74e024a23f9dd16f49d89413f822b6b7b80698f395`, original signing cert, strict v2/ZIP PASS, **127/128** old payloads unchanged. Private Library `MOA_R166_EMERGENCY_RESTORE_R163_ONLY_IF_NEEDED.apk`. This is emergency restoration ONLY if R165 malfunctions, not a normal feature upgrade. It preserves same installed app data while changing APK version; shared copies remain separately retained.
- No email, no app uninstall/reset, no public signer backup upload, no unrelated AirPods code changes, no new helper app. Do not call a provided chat sandbox link verified as user-downloadable without recipient confirmation.

## Next-device checks
1. Install in-place R165; make short quick voice note and confirm text + play buttons unchanged.
2. After text conversion, confirm status “외부 원본 복사·SHA-256 검증 완료” and My Files > Recordings > MOA > date > audio exists and plays.
3. Use “기존 녹음 원본 모두 외부 폴더에 보관하기” and confirm summary, then rerun to verify no duplicates.
4. Confirm old Diary native recordings, all photos/Diary/map/calendar/video operations unchanged. App-private M4A must still exist and play.
5. On any error do NOT delete app/data; retain logs and emergency R166 ready.
