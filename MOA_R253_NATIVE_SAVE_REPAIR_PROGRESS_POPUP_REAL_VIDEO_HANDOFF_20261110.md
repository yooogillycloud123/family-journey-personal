# MOA R253 — Repair native NAVER save regression and add real progress/result feedback (2026-11-10)

## New user-provided device evidence 20062.mp4 (95 seconds; PRIVATE)
- Existing MOA diary photo/GPS metadata and native NAVER Map/↶ MOA overlay remain present.
- R249 native accessibility auto-save was not functioning as expected; user could not tell whether a save was in progress, completed, failed or why. In video the NAVER Save/list selection UI is accessible **manually**, but that is NOT proof the accessibility task successfully created/saved a favorite.
- User demands: preserve original MOA and Golden functions; prioritize restoring **existing** first-party NAVER accessibility saving. Show unobtrusive saving progress, success/failure popup, optional completion popup toggle default ON. Do not re-create 6-field tester or remove existing photo GPS automation. Requirement for truly screen-uninterrupted saving remains OPEN.

## Confirmed R249 source regression cause
- R249 added a full WebView-reparent-to-accessibility-overlay `MoaNaverAccessibilityCover.arm()` that sets `armed=false` on `MOA_LIVE_WEBVIEW_NOT_FOUND` / service missing / overlay add failure. `HostActivity.lambda$handle$35` explicitly checks `armed` and then **refuses to launch NAVER**. Thus experimental overlay failure can disable **proven existing NaverSaveService**: wrong dependency.
- Original `NaverSaveService` has real state sequence `WAITING_ADDRESS_RESULT -> SHEET_FOUND/WAITING_LIST -> ... -> SAVE_CLICKED_UNVERIFIED -> VERIFIED` plus error states, stored in private `familyjourney_naver_oneshot`. `HostActivity` already exposes `naverStatus` callback `__fjNaverSaveStatus` but R249 JS **polled only when Settings's #fj-naver-panel was present**, not globally from Diary/photo. It did not notify user on completion.
- R249 callback erroneously looked up `state[value.key]` where the native key is a search place string, while local JS records indexed by GPS key. R253 uses tracked photo GPS key.
- VIDEO alone does not prove the R249 overlay guard was the ONLY failure; this is a concrete code-level blocker and corrected, while Galaxy physical test remains open.

## Actual signed R253 APK
- `com.juhyeon.familyjournea` versionCode **253**, original signer certificate SHA256 `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`.
- APK `MOA_R253_NAVER_SAVE_RECOVERY_PROGRESS_POPUP_BETA.apk` size **8,928,487B**, SHA256 `503f1abcf41dc280e30d3ff7c0f2590151344b8582f9d6353694be1cf41834dc`. APK V2 original cert, ZIP CRC, 15-DEX SHA1/Adler, zipalign PASS, AAPT package and code 253 PASS.
- ZIP `MOA_R253_APK_BACKUP_WITH_QA.zip` size 6,458,301B SHA256 `a49cfe54a785758278650505682267b41f419ec925735192396d2fae84d69cf6`; internal APK byte-identical PASS. Includes full Korean guide, SHA, QA.
- R249 parent 141 ZIP members; **133 non-signature entries byte-identical**. Only 4 payloads changed: `AndroidManifest.xml` 249->253, `classes15.dex` status-only accessibility overlay, `assets/web/fj-naver-favorites.js` status and GPS record tracking, `assets/web/moa-r231-settings.js` popup toggle. **classes2.dex EXACT BYTE MATCH**, so original `HostActivity` and `NaverSaveService` methods unchanged. Gallery/Diary/audio/map/record/assets untouched.
- Local Java17 SDK35 compile + D8 min29 PASS, JS `node --check` both scripts PASS; VM-based original GPS→native job + non-fake `VERIFIED` UI popup + default ON and OFF setting smoke PASS. Real Galaxy NAVER account save/readback QA **NOT PERFORMED**.
- Source-only, no secrets, SHA256 `411238db7665475a79d614ab767a79225c28825f9ab1c85a13fc2a7a1f9e3e5c`.
- Private Library exact folder `/모아_프로젝트_근거_20261103/R253_NATIVE_SAVE_RECOVERY_STATUS_20261110/` includes APK, ZIP, install guide, QA, source-only patch diff. Do not put private signer, actual video, user's media, GPS or login on public GitHub.

## Implementation change
`MoaNaverAccessibilityCover` only adds a **small non-touchable accessibility status CHIP** while native `com.nhn.android.nmap` is foreground. No removal/reparent of the real MOA WebView, no full-size screen cover. Flags `FLAG_NOT_FOCUSABLE | FLAG_NOT_TOUCHABLE | FLAG_NOT_TOUCH_MODAL`; displays localized stage label and non-user-facing raw status in accessibility content description. **If cosmetic overlay fails, `armed` stays TRUE** and original `NaverSaveService` continues. When it completes or errors, it returns to existing MOA via original Activity where possible; R229 return bubble remains.
- MOA frontend starts global `naverStatus` 1.2-second polling during active job, including after visibility/resume, and restores pending state from MOA localStorage after page reload. Existing GPS+address+alias+memo+list, zero 6-field tester.
- Non-modal bottom compact chip during active job + localized errors; on `VERIFIED` or known failure, optional actual MOA modal. Default popup **ON**, Settings → `네이버지도 복귀 버튼` → `저장 결과 팝업 표시` OFF/ON. Native UI `VERIFIED` only means Naver UI save indicator; **not authenticated account readback**. Do not say 'saved to NAVER account' until list/place/alias/memo readback.
- This repair deliberately disables experimental `MOA WebView` foreground mimic: NAVER may temporarily occupy screen. User's original full no-screen-occupation requirement remains OPEN; do not quietly downgrade permanently. The current priority is return to functioning original Accessibility saver without losing MOA.

## Next essential test/regression gate
One physical Galaxy S26 Ultra single GPS-photo tap → Naver exact location shown → real small progress chip → list/alias/memo selection/save → `VERIFIED` or exact failure stage → automatic/native popup and MOA's exact photo remains. Confirm actual NAVER account saved list, name/alias/memo manually (independent readback NOT implemented). Repeat twice. If stage sticks, capture stage chip and result; do NOT ask the user to re-enter 6 fields, uninstall, wipe data or redo old unrelated tests.

User wants **fully working one APK**, not endless betas: this release is a scoped regression repair candidate with honest pending real-device gate, **NOT FINAL**.
