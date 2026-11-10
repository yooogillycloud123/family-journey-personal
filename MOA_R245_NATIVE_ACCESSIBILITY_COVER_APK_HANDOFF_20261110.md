# MOA R245 — One-APK NAVER native accessibility screen-cover implementation (2026-11-10)
## Real artifact and what it does
New beta APK `MOA_R245_NAVER_NATIVE_COVER_ACCESSIBILITY_BETA.apk` produced locally. SHA256 **b2f5fac017b11ff8b87693f585bb03238f8d5180c4b8fd3b548ccf3bb43719af**, bytes **8,932,583**, versionCode **245**, package `com.juhyeon.familyjournea`, unchanged signer SHA256 `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`. Signed APK v2 PASS, ZIP CRC PASS, DEX SHA1+Adler32 PASS for 15 DEX, resources STORED, zipalign PASS. Backup ZIP with exact same APK + install guide + QA SHA256 **2043d12beadfd2b8a4ab15af7f6779391aabc6a2557863399a662dd494829c4c**.

Old R241 hard failure: Android WebView `ERR_TOO_MANY_REDIRECTS` to `https://map.naver.com/?app=Y&appmarket=N` as observed in private 20042.mp4. R245 removes failed WebView login/hidden/save buttons from user settings; original NAVER→MOA overlay settings stay.

### Actual source changes from R241 signed parent
- Only four APK payload differences: `AndroidManifest.xml` code241→245; `classes2.dex` patch to existing `HostActivity` and `NaverSaveService`; `assets/web/moa-r231-settings.js`; `assets/web/fj-naver-favorites.js`. New `classes15.dex` compiled from `MoaNaverAccessibilityCover.java`.
- R241's other **133 shared APK member payloads** are byte identical (signature metadata naturally changes).
- Existing same-APK `NaverSaveService` accessibility component is reused (android:packageNames=`com.nhn.android.nmap`, flags retrieve interactive windows). Existing NAVER app login session used by native app's UI; no app cookie reading or private API POST.
- UI calls original native bridge command `naverSave` with strict name+address+list+alias+memo and tracks `naverStatus`, not the R241 `phone_submit` WebView worker.
- Before Naver launch, `HostActivity` calls `MoaNaverAccessibilityCover.begin`. When accessibility is enabled, service draws MOA full-screen `TYPE_ACCESSIBILITY_OVERLAY` on top of Naver UI, allowing existing accessibility service to continue seeing Naver windows and performing accessibility actions. Cancel on cover returns to MOA. It attempts auto-create absent list via normal UI, only if named list editor is accessible. UI-only 'VERIFIED' does not auto-promote to account-readback 'CONFIRMED'.
- Original Gallery native/photo/diary/quick-record DEX and assets are preserved unchanged, but **real phone regression remains untested**.

### Critical limitations / NO false success
**R245 is not a proof of true non-occupying background saving.** Its temporary full-screen MOA overlay covers Naver's foreground activity while the real Naver app UI is manipulated. The phone screen **is still temporarily occupied**. One-app / no-PC / no-root / no-Shizuku / no helper APK design is satisfied, but user strict no-foreground-occupation and uninterrupted use of MOA are NOT satisfied. If accessibility is OFF or Naver UI changes, execution may fail. Auto-list create and alias/memo save have never been verified on current real Galaxy. Account list readback is NOT implemented. This is a meaningful distinct native-UI route from broken WebView, **beta only**; do not declare final/GOLDEN and do not remove user requirements.

### Environment checks
- APKtool build original classes2 smali patch PASS; Android SDK35 Java17 compile of native cover PASS; D8 --min-api29 PASS; node --check for both patched JS PASS.
- Original signer cryptographically matched; APK v2 signed, ZIP and DEX checks verified; 4 payload changes + one added DEX; app data update compatibility metadata verified.
- No Galaxy installation / real NAVER account save / create list / alias/memo readback / screen-stability physical test. R243 GeckoView experiment Android APK build PASS but emulator process failed from guest OS boot/ADB Broken pipe before map navigation; not evidence that GeckoView works or fails on Naver.

### Test/use with appropriate warning
Update-install only, no uninstall/clear data. In MOA Settings expand NAVER return settings, scroll to '네이버 즐겨찾기 · MOA 앱 내 저장 보조', enter exact place+full address+list and optional alias/memo, press '③ 네이버 저장 시작'. Existing installed native NAVER app must be logged in. On first request Android Accessibility approval for MOA NaverSaveService may be requested; enable explicitly then return and press again. The overlay displays progress; system may still show Naver briefly or if overlay setup fails. At success, manually inspect NAVER account's actual saved list and requested fields; no false green status. Keep R227 immutable, previous R241 as byte baseline only.

### Next real implementation requirement
To meet the user's original strict contract, need a phone-embedded independent browser (GeckoView/Chromium) that can actually load NAVER, preserve legitimate user login, automate first-party save UI *without taking foreground*, AND independently read back exact place+alias+memo from that account, or an official supported write API. Samsung Internet Custom Tabs do not grant MOA arbitrary DOM control or shared native app cookies. Accessibility overlay is not a full substitute. No arbitrary token or captcha bypass.
