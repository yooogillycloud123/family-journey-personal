# MOA R251 — R249 Accessibility native-save regression recovery + live progress + optional result popups (2026-11-10)

## Real user video evidence — PRIVATE, never publish raw file
`20062.mp4` (95s): existing MOA Diary GPS card → `주소로 저장 + 메모` → message '사진의 정확한 주소 위치를 네이버에 저장 중' → NAVER visible briefly / app transition → returns to MOA; no actual saved-place UI observed; prior attempt shown `3분 안에 저장을 확인하지 못했습니다`. This **does not** prove NAVER account saved or not saved: no server readback.

## R249 source-level root cause
Decoded R249 HostActivity `lambda$handle$35(search,prefs)` contained a newly inserted guard `if(!prefs.getBoolean("armed",false)) return` before NAVER start. The new interactive WebView relay helper's `begin(Context)` was NOT called from the live HostActivity save dispatch (its prior invocation was replaced with `nop`); hence the relay and guard were not a functioning integrated transaction. Original native `NaverSaveService` remains in classes2, but R249 could block actual NAVER launching and had no reliable end-state progress feedback. The user reports real Galaxy accessibility path broken.

## Actual R251 APK, signature and limits
- `MOA_R251_RESTORED_NATIVE_ACCESSIBILITY_STATUS_POPUP_BETA.apk` **8,932,583B SHA256 edff7f98a51583fd38fc19efe5ceb8217e3da2105b07549e33d16fa611e987f2**.
- Original app `com.juhyeon.familyjournea`, versionCode 251, original signer cert `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`; APK v2/dex CRC/zipalign/JS node and Java17 Android35 D8 compile **PASS**. No Galaxy installation or real account test performed.
- Matching backup `MOA_R251_APK_BACKUP_AND_STATUS_GUIDE.zip` **6,461,975B SHA256 cc46f659a62a37e966c4f0e2b8177736c88104734b86ec20348b87080542c913**; inner signed APK exact byte match, ZIP CRC PASS.
- Source only (no signing secrets) `MOA_R251_SOURCE_ONLY_NO_KEYS.zip` private Library. APK and ZIP privately archived in Library.
- R249 parent changed only AndroidManifest code 249→251, classes2 (original Naver first-party save launch restored + job-aware naverStatus + result-notification setting), classes15 (small status chip instead of WebView reparent), assets/web/fj-naver-favorites.js and assets/web/moa-r231-settings.js; 132 non-signature entries identical, including gallery/voice/quickrecord.
- `MoaNaverAccessibilityCover` keeps the existing required Java API attach/detach/begin/onNaverEvent; now **NO WebView reparenting, NO full-screen fake cover**, and a 310dp non-touchable accessibility chip with real job status. Existing accessibility service retains full control over genuine NAVER native UI; attempts optional one-list creation through its existing first-party UI helper.
- HostActivity `lambda$handle$35` R249 `armed` guard removed entirely, first-party NAVER app open no longer depends on relay success. `begin` wired BEFORE native NAVER launch so status UI/Activity weak-reference initialized. Native status returns job ID, started time, armed bit for stale suppression.
- Result popup default ON, opt-out through existing MOA Settings → NAVER return → `저장 결과 팝업 표시`, stored by JS and forwarded as native JSON 'notify' per task, persisted in private SharedPreferences. A terminal device toast is shown but never says 'verified NAVER server' unless actual account readback is implemented.
- Native status chip distinguishes no accessibility-service binding, NAVER window not visible, WAITING_ADDRESS_RESULT too long, save sheet/list/memo, UI 'saved' indication vs account list readback. Ends after timeout instead of silently waiting forever. Existing diary/photo GPS path retained.

## Truthful product scope
R251 is a targeted **accessibility compatibility repair / observability BETA**, not fully invisible nonoccupying account-save FINAL. NAVER Maps may become foreground temporarily, and can still require the user to select exact matching address. Real Galaxy save/list/alias/memo and independent NAVER account readback not verified. In-app toast `VERIFIED` means NAVER UI saved indicator only. Do not claim server success. The screenshot/video evidence cannot guarantee the precise failure until service runtime stage logs are obtained; the guard+missing begin are code facts.

## Installation and evidence rules
Update-install same package/signer, never uninstall/data clear or touch R227 Golden SHA256 53c4c04ce32ad13de3c0613f4e5ec7abbc75ccbdfe9db5da05d8fa9b806ec6cd / R229 user-confirmed return. User guide: `MOA_R251_INSTALL_AND_STATUS_GUIDE_KO.txt`, linked with APK ZIP.
If real device remains stuck: report displayed status string (no screenshots of private family photos needed) to isolate Naver window, address result, save control, list, memo or confirmation. Do NOT add fake fullscreen overlay or manual test form.

## Future strict goal
No PC/root/Shizuku/helper APK, MOA screen untouched while genuine NAVER account list/create/place+memo+alias write and independent server readback. Remains OPEN pending actual authenticated first-party UI semantics and runtime evidence. Do not present R251 as meeting strict non-occupying goal.
