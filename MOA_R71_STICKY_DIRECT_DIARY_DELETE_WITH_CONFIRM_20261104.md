# MOA R71 — Sticky Diary Delete Action (user clarified 2026-11-04)

## Exact user requirement (latest)
The original R68/R70 diary editor sticky bar `제목·본문 | 시간대 메모 | 일기 저장` works on the Samsung screenshot. User requires **a fourth `일기 삭제` BUTTON that calls the SAME existing delete function directly like the Save button**, NOT a jump-to-delete-position button. Previous in-session R71 scratch proposal `삭제로 이동` was corrected before release and MUST NOT be used. Screenshot evidence shows original floating bar and all original editor fields.

## Verified minimal patch
- **APK base is exact R70** `MOA_R70_Install.apk`, SHA256 `483994e3decd8e01828bcad5beed5290cc5699594b074298748ce58c758aa8a5`; package `com.juhyeon.familyjournea`, unchanged historical signing cert.
- New **versionCode 71**, same package and signer. Change only `AndroidManifest.xml` (versionCode, versionName) and `assets/web/family-diary.js` (one sticky toolbar button). **Other 53/55 APK entries BYTE-IDENTICAL**, including `classes4.dex` R70 ON/OFF code, original R63 Golden `assets/web/moa-direct-diary-commit.html`, Naver native/JS and media resources.
- Existing `renderEditor(entry, photos)` retains all original title, body, tags, feeling, photo management, time notes, Save, Cancel and original bottom Delete. Add a 4th fixed `일기 삭제` button only if `entry` exists, wired to the **EXACT original `remove()` callback**. Original `remove()` displays `confirm('이 날짜의 일기 내용을 삭제할까요? 원본 사진은 삭제되지 않습니다.')` BEFORE invoking `dbDelete(S.manual?'curated':'entries',S.date)`. Cancel means NO deletion. Confirm means only that day's diary record is removed; gallery originals are not deleted. This is intentionally destructive only after explicit device confirmation.
- Do **NOT** call `remove()` merely for screen navigation, do NOT silently auto-confirm and do NOT delete media files/photos.
- UI toolbar order: `제목·본문 | 시간대 메모 | 일기 저장 | 일기 삭제`. No extra app/helper.
- Earlier draft R71 `SCROLL_ONLY_TO_EXISTING_DELETE_CONTROL` was **never user-released** and is not the accepted product. The only downloadable R71 is this DIRECT-CALL with native confirmation.

## Local validation status
- DEX not altered. `node --check` for modified JS PASS.
- Focused Node mock executes **the existing actual `remove()` function**: confirm CANCEL retains diary row, confirm YES deletes exactly one `curated` day and calls original render, confirmation/status says gallery media retained. PASS.
- Original Node fake-IDB test (save 2 photos, note edit, timestamps, deduplication, authored fields) PASS.
- APK v2 signature verify, certificate hash compare, ZIP CRC, changed-entry diff and original protected R63 assets compare PASS.
- **GALAXY R71 RUNTIME NOT YET VERIFIED**. This is a minimal editor UX update; R63 remains immutable actual Golden; R70 direct toggle mechanism unmodified.

## Next step
Install same-package R71 APK over R70 without uninstall/clear. Open an existing diary editor. Verify all four sticky buttons visible; tap `일기 삭제` and **first choose Cancel** to confirm no deletion. To intentionally delete diary, tap again then confirm. Gallery originals must remain unchanged. Do not test deletion on valuable diary data unless the user actually wants to delete that date.
