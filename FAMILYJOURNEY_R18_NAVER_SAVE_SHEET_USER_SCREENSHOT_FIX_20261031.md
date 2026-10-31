# FamilyJourney R18 — NAVER save-sheet memo+nickname automation beta (2026-10-31)

## User phone screenshots (real NAVER Maps, not simulated)
- R17 accurately opens NAVER Maps at photo GPS-derived precise address (example 전남광주 진도군 의신면 초사리 1205).
- R17 fails to click favorite/edit notes; status in user's private app says it cannot find memo/nickname input.
- User then manually taps **star/save** and sees NAVER's *actual* saved-place sheet:
  - `+ 메모, 별명, URL 추가`
  - `+ 새 리스트 만들기`
  - list row: `내 장소 174` (saved count appended)
  - blue bottom `저장` button
- User manually expands memo editor:
  - `메모를 남겨주세요. 0/50`
  - `지도 위에 표시될 별명을 남겨주세요. 0/25`
  - `관련 URL을 추가해주세요.`
These **screenshots explain code mismatch**: R17 searched "메모 추가", "별명" and list exact "내 장소", lacking the actual combined button and list count; it attempted to put alias+memo into ONE edit instead of two fields.

## R18 change
- Public native source: `androidHost/app/src/main/java/com/juhyeon/familyjourney/NaverSaveService.java` updated at `cc273fcf5e7ecbca455e5d99f8acc3e1d31ae8b8`. The service only receives `com.nhn.android.nmap` accessibility events when user arms one job. Expires after 180 sec; credential/password fields excluded.
- New UI state machine: address result **user selection remains necessary** (no guessing which search result is a location), then tap save, recognize `+ 메모, 별명, URL 추가`, expand editor, locate the 50-char memo and 25-char alias fields by accessible hint or three-field position in correct editor, use Android `ACTION_SET_TEXT`, check read-back, inspect requested saved list (label with count), click bottom save and wait for UI confirmation.
- **Important honesty**: Android service cannot prove real NAVER account persistence from just a tap. R18 reports `SAVE_CLICKED_UNVERIFIED` and only reports `VERIFIED` if NAVER exposes save-confirmation UI; this is not a real device successful save. If only saved place icon is visible then `PLACE_SAVED_MEMO_UNVERIFIED`, not VERIFIED.
- Public build version `versionCode=18` at `7037464ca64e1826ad9fd156358d6afd1c5b9c57`. Native Android GitHub Actions **41181436443** compiled and signed successfully.
- Private APK packages the R18 native bytecode with the user's R17 local, private original web assets (not uploaded to public GitHub). Adds user-visible status strings and more prompt status checks. All main original rendering, native.js, video, GPS, and gallery JS byte-identical with R17; no R16 separate-local-list UI.
- Local release `FamilyJourney_R18_NaverAutoMemo_SaveSheet_BETA.apk` SHA256 `6ac9e21bca70ccc3d676d5b50eff0bb6b6c4c2923b7203e7ee88c76bb950bc42`, versionCode18 package `com.juhyeon.familyjourne2`, signed with previous R17 certificate SHA256 `0d25313c1a6f769d1a9b43ea9d3b7a4626a12924a887062ad25dc69907fbad09`; APK v3 sign, aapt metadata, ZIP CRC PASS.
- **NAVER real device UI traversal, account favorites saved, memo/alias persisted: NOT TESTED**. Must obtain actual accessibility result/status on phone before claiming finished.
- Existing R15 `com.juhyeon.familyjourney`, original purchased app separate, and R16/17 `com.juhyeon.familyjourne2` remain untouched; R18 is R17 in-place update (same signer).
- "No UI automation possible on Android" is false: Android `AccessibilityService` supports programmatic node click and `ACTION_SET_TEXT`, but NAVER changes UI and the official URL scheme does not offer favorites write; this implementation is accessibility-dependent not an API authorization.

## Known risk and immediate test
1. NAVER Maps actual buttons may not expose accessible node text/typing hints; then service enters `FIELDS_NOT_ACCESSIBLE` or `SAVE_SUBMIT_NOT_FOUND` without pretending success. Users may need to tap save once manually.
2. Target list `내 장소` is default-selected in screenshots, so R18 avoids toggling the list unchecked. For other list names, selection is attempted and requires readback on device.
3. If R18 returns `SAVE_CLICKED_UNVERIFIED`, check NAVER list and saved place memo before treating as PASS. Report precise status. Preserve all private photos locally.
