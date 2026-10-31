# FamilyJourney R27 — R26 일기 CSS 회귀 완전 복원 (2026-10-31)

## 사용자 실기 증거 및 확정 원인
- Galaxy R26 업데이트 후 일기 탭이 전체화면으로 열리지 않고 기존 '나의 지도' 아래에 **맨 HTML 텍스트 + 일렬로 압축된 숫자 달력**이 나타남. 실제 스크린샷 `17613.png`, `17615.png`.
- **정확한 패키지 ZIP 재확인:** R25 `assets/web/family-diary.css` **9,851 bytes**, R26 **994 bytes**. R26 실수로 R25 전체 CSS를 보존하지 않고 새 동영상용 덧붙임 스타일만 패키지에 집어넣음.
- R25에서 필수였던 `#fj-diary-root{position:fixed;inset:...;z-index:18;overflow-y:auto;...}` 선택자가 R26 CSS에서 완전히 사라짐. 따라서 탭 클릭 이벤트/HTML은 살아도 화면이 앱 바디 아래에 unstyled 블록으로 흐름. **추측이 아니라 실제 APK ZIP 추출로 확정**.
- 사용자의 기존 사진/일기 DB가 삭제된 증거 없음. 저장소 정리, 앱 삭제, 캐시/데이터 삭제 **절대 금지**.

## R27 수정 범위 (안전 최소 수정)
- R27 `assets/web/family-diary.css` = **R25 9,851 bytes 원문 그대로** + 개행 두 개 + **R26 영상 스타일 994 bytes 원문 그대로**, 합계 10,847 bytes.
- R26 `family-diary.js` **100% 바이너리 동일**, 기존 동영상 메타데이터 인덱스/영상 원본 재생/공유 유지.
- Native R26 app/classes2.dex 재빌드 기준 완전 동일 바이트. `AndroidManifest.xml` versionCode만 26→27, versionName→`1.0.4-video-diary-cssfix-r27`, 동일 package/권한/서비스.
- R26→R27 *APK ZIP 실제 변경 entry는 정확하게 두 개*: `AndroidManifest.xml`, `assets/web/family-diary.css`. 그 외 지도, 영상, 사진, 네이버, IndexedDB JS, DEX 전부 동일.
- PC·iOS 작업 보류 유지. 기존 앱 `com.juhyeon.familyjourne2` 삭제·재설치 금지; R27 **기존 R26에 덮어쓰기**.
- 수정 앱: `/mnt/data/FamilyJourney_R27_VideoDiary_LayoutRestored.apk`, SHA256 `4290cb2a4501e7a867dbf17af4ef09688beeebeeaf4e15303a4abf89ba2b74e9`.
- ZIP: `/mnt/data/FamilyJourney_R27_VideoDiary_LayoutRestored.zip`.
- 서명 cert fingerprint **R26/R25와 동일**: `0d25313c1a6f769d1a9b43ea9d3b7a4626a12924a887062ad25dc69907fbad09`; v3 APK verify PASS.
- GitHub Android CI build `41191969052` PASS, code version bump commit `2acb797445e041ce2837d13c1592dfd1625341db`.

## 정적+시각 테스트
- Real APK diff PASS, ZIP CRC PASS, native DEX same PASS, JS identical PASS.
- Playwright Android-size viewport 430×930: full restored stylesheet `position: fixed`, `left=0`, `top=0`, `width=430`, `boxSizing=border-box`; no more raw text below home.
- Mock photo112 + video1 automatic calendar day shows `112장 · 영상 1개`; video tile play/share native bridge action PASS.
- Separate curated 2-photo + 1-video day remains distinct, save/edit vs automatic112 preserved PASS, no JavaScript page errors. Test `/mnt/data/_fj_r27/test_r27.py` and screenshot `R27_style_regression_test.png`.
- Galaxy physical UI launch/play still unverified until installation. **Cannot claim 100% real phone PASS based on mock only.**

## Next
- Install R27 **over** R26, do not uninstall.
- Tap diary: UI should show clean fixed diary screen, curated main, automatic secondary. Check existing curated entry (e.g. Oct31 9 photos) intact, auto photo112/video count intact. Test video permission once and native playback.
- Future release gate: fail packaging if family diary CSS lacks 9,851byte R25 baseline, or if `#fj-diary-root{position:fixed` absent; require Chromium screenshot + computed-style overlay assertions every Rxx.
