# MOA R265 — 네이버 지도 진입 전경 경로 공통 복귀 버튼·저장 결과 알림 보강 (2026-11-10)

## 사용자 실제 영상 20113.mp4 — 비공개
- 50.4초 Galaxy 화면 녹화. MOA 설정에서 네이버지도 복귀 버튼 ON, 일기 사진/위치카드 → 네이버지도 장소 화면 이동, 저장 폴더 및 별명 입력 화면 → 네이버지도 지도 화면 복귀, 이후 MOA로 시스템 방식 복귀.
- 네이버지도 화면에 **↶ MOA 복귀 버튼이 보이지 않음**. 네이버 저장 관련 UI가 열리고 사용자 조작이 기록됐지만 MOA 완료 팝업은 보이지 않음.
- **영상에서 네이버 계정 서버 재조회 또는 자동화 자체의 전체 PASS는 확인할 수 없음.** 사용자는 네이버 즐겨찾기 저장 성공을 보고함. 개인정보(사진, 위치)는 공개 GitHub에 업로드하지 않음.

## R261 실제 서명 APK 코드에서 확인된 원인
- `MoaNaverReturnOverlay.show(Activity)` 원본 호출은 오직 `MoaNativeGallery.r227...openMap` 경로에 있었음.
- 일기 사진 네이버 열기 `HostActivity.lambda$diaryOpenNaverPlace$27`, 저장 보조 `lambda$handle$35`는 `HostActivity.startActivity()`를 직접 호출하지만 복귀 오버레이 초기화가 없음.
- `MoaNaverReturnOverlay.show`에는 사용자 설정 enabled와 Android `Settings.canDrawOverlays` 둘 다 참이어야 한다는 조건이 있음; 설정 ON = 권한 허용 아님.
- 즐겨찾기 결과 팝업은 `fj-naver-favorites.js` 내부 activeSave가 있는 상태에서 네이티브 `naverStatus` 응답이 터미널일 때만 표시됐고, 네이버 앱이 전경인 동안 WebView가 일시 정지하거나 재생성되면 알림이 소실될 수 있음. 기존의 Android 접근성 서비스 상태 기록과는 독립.
- 네이버지도를 단순히 여는 동작은 저장 요청 `naverArm`과 별개; 사용자가 네이버지도에서 *수동으로* 저장한 경우 네이티브 자동저장 완료를 무조건 주장해서는 안 됨.

## R265 실제 새 설치 APK
- **APK** `MOA_R265_NAVER_RETURN_AND_SAVE_RESULT_REPAIR.apk`
- SHA256 **`5c1d43bb99fd25e82d0ae960fbdbb3609d7235e8ce17736dcb2d518526c3dae5`**, 8,932,642 bytes, package `com.juhyeon.familyjournea`, versionCode 265, original signing certificate `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`.
- Backup ZIP `MOA_R265_APK_BACKUP_AND_KOREAN_GUIDE.zip`, SHA256 `86d85c1f4d70cb6b087fd84bd684905df5ec78a921d5062fc4dd1b559288a171` includes exact signed APK + Korean guide/QA.
- Patches from R261 only in `classes2.dex`, `classes10.dex`, `assets/web/fj-naver-favorites.js`, `assets/web/moa-r231-settings.js`, manifest version, plus `classes16.dex` containing an isolated `MoaNaverSaveNotifier`. Original Diary/Gallery/Voice/QuickRecord/Audio and main DB unchanged byte-for-byte.
- `HostActivity.startActivity(Intent)` override safely gates only first-party NAVER package/nmap/map.naver.com destinations and shows existing `MoaNaverReturnOverlay.showIfAbsent` before app launch. Therefore it applies to gallery, diary location and favorites; original native gallery call remains but duplicate popup mounts are avoided. Any hook failure falls through to super.startActivity, preserving normal app navigation.
- `HostActivity.onResume()` closes the overlay when MOA returns. The original panel task-id moveToFront/PendingIntent one-tap function remains unchanged.
- `NaverSaveService.state` keeps the existing Accessibility first-party save behavior byte-for-byte except for a new isolated `MoaNaverSaveNotifier.onState` call for terminal result feedback. Android Toast is opt-out with `moa_naver_return_overlay_v1.savePopupEnabled`, and wording specifies **UI confirmation only**, never server readback.
- Settings existing toggle now synchronizes both JS/localStorage and Android native result notifier; Settings also shows actual display-over-other-apps permission status (permitted) with real native values.
- Frontend retains local pending job identity with 5-minute TTL and on-resume status polling, allowing in-MOA popup after returning even if WebView was recreated.
- R265 uses neither fullscreen screen covering, WebView reparent, PC, Shizuku nor root. **It is NOT true offscreen background saving**, and Naver app still appears in foreground.

## Verified gates / remaining gates
- Android35 JDK compile of notifier and D8 API29 PASS; full APKtool smali build PASS (no errors); signed APK v2 PASS, original cert PASS, zipalign PASS; 16 DEX SHA1/Adler32 PASS; ZIP CRC PASS; JS node --check PASS.
- Independent post-sign APK reverse decode PASS: `HostActivity.startActivity`, `HostActivity.onResume`, `MoaNaverReturnOverlay.showIfAbsent`, `NaverSaveService.onState` and `classes16.MoaNaverSaveNotifier` confirmed present in signed APK. Backup ZIP embedded APK SHA exact.
- **Galaxy S26 Ultra R265 boot, overlay rendering and alert must still be tested in device**. No claim of user device PASS or verified NAVER account list/memo/alias readback. Android may restrict toast timing while background, so on-device verification is needed.
- Safe rollback **R267 APK** `MOA_R267_EMERGENCY_RESTORE_R261.apk` SHA256 `9754ed3053d77fdfb50db6404f64bc142fc2547947a70ec659cd9439dec8cad3`; same original signer, exact R261 functional contents except manifest code raised 261→267. Install only if R265 actually crashes, never uninstall/delete data.
- Private Library archive `/모아_프로젝트_근거_20261103/R265_RETURN_POPUP_STATUS_FIX_20261110/`: signed APK, ZIP, guide, QA, rollback, source patches. Never publish private keys or user videos.
- Original R227 golden SHA256 `53c4c04ce32ad13de3c0613f4e5ec7abbc75ccbdfe9db5da05d8fa9b806ec6cd` remains immutable. R261 can save through native Naver as reported by user; don't modify that automation blindly.

## Critical next step toward user's end goal
Move from a working user-controlled native NAVER foreground flow to **MOA-uninterrupted verified list-create + place + nickname + memo account write/readback**. R265 fixes display/feedback regressions only, not this hard requirement. No fake screen cover or unverified official API guesses.
