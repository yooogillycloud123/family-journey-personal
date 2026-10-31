# FamilyJourney R25 — Canonical READ FIRST (2026-10-31)

## 사용자 검증된 기준
R24 실제 Galaxy에서 정상 작동 확인. 자동 사진 달력/내가 고른 사진 일기 별도 IndexedDB 저장소, 날짜별 원본 사진 인덱스, 줄바꿈 일기, 사진 제스처/공유, 여행 GPS 지도/동영상, 네이버지도 즐겨찾기 저장 보조를 **모두 유지**한다. 추천/대결/광고/원작자 서버 연결을 복원하지 않는다.

## 이번 R25 사용자 요청
1. 앱의 **일기**를 열면 **내가 고른 사진 일기**가 기본 메인으로 표시되도록 한다. '자동 사진 달력'은 보조 두 번째 탭으로 유지하고 기존 사진 전체 로딩·저장 내용은 무변경.
2. 휴대폰에 없는 **PC 보관 가족 사진**도 수동으로 넣을 수 있도록 한다. PC 자체에 무선으로 무조건 접근하는 건 불가능하므로, PC에서 휴대폰으로 복사한 여러 이미지 또는 ZIP 묶음을 Android 시스템 Files 선택기를 통해 가져오는 안전한 방식. 선택한 파일의 원본 바이트를 로컬 MediaStore `Pictures/FamilyJourney PC Imports`에 복사하고 EXIF 촬영일을 우선 사용. 없으면 파일 수정일(근사) 또는 가져온 날짜(근사). 개인정보 서버 업로드 없음. 같은 원본 SHA-256 재가져오기 방지, 한 사진 최대 90MiB, 한 작업 최대 3500장/약 2GB. 가져온 사진은 자동사진 달력과 수동 선택기에 재색인 후 나타나며 사용자가 사진을 골라 일기에 추가할 수 있음.
3. iOS 앱은 후속 요청 때 별도 빌드 필요. Flutter/Swift+PhotoKit/Files 접근 등 별도 포팅이며 Android 전용 Accessibility 네이버지도 앱 자동화와 완전히 동일한 기능 보장은 불가. **R25 iOS IPA는 아직 제작하지 않음**.

## 이번 산출물
- Android signed APK `FamilyJourney_R25_CuratedDefault_PCPhotoImport.apk`
- ZIP `FamilyJourney_R25_CuratedDefault_PCPhotoImport.zip`
- APK SHA256: `200e9c686b331f3778ec5514348cb1139e8f0cf27cf34bfb339008e6a7993508`
- package `com.juhyeon.familyjourne2`, versionCode `25` and versionName `1.0.4-addr---r25`, signing certificate SHA256 `0d25313c1a6f769d1a9b43ea9d3b7a4626a12924a887062ad25dc69907fbad09`, unchanged from R24; **기존 앱 삭제 금지, 덮어쓰기 설치**.
- R24 대비 APK modified entries ONLY: `AndroidManifest.xml`(version), `classes2.dex`(Native PC importer), `assets/web/family-diary.js`(curated default, importer button & callback), `assets/web/family-diary.css`(import UI).
- Public GitHub source change: `androidHost/app/src/main/java/com/juhyeon/familyjourney/HostActivity.java` commit `8042d2dae1e8e4b3dd681e4fafabae16fd1c5380`; native build version 25 commit `7251a3a3b5d39ba4107019f8d96f174c9387ebfc`; CI `41188389127` Android Java compile and signed host PASS; host artifact `FamilyJourney-R25-CompiledHost.zip` and private prior R24 base APK were combined locally preserving certificate and APK identity.
- Private development files `/mnt/data/_fj_r25/family-diary.js`, `family-diary.css`, `test_r25.py`, `package_r25.py`; **do not publicly upload original bundled commercial assets, key, private family photographs or GPS**.

## 검증 수준 및 미완료
- PASS: Node syntax; headless Chromium synthetic UI initial selected tab '내가 고른 사진 일기', button triggers `diaryImportPc`, synthetic 112 auto photos unaffected by 2→3 selected curated diary, R23 migration mock, newline activities and date dividers. No JS exceptions.
- PASS: GitHub Android native Java Gradle build, signed APK zip integrity, same signing certificate, versionCode25, classes2.dex native bridge and requested four changed entries.
- NOT YET TESTED ON USER PHONE: Android Files UI picking images/ZIP, EXIF capture dates from actual PC files, Gallery visibility, storage capacity, ZIP limits and reload after closing app. **Do not assert end-to-end physical Android import succeeded.**
- PC photos imported by **copying** to device's shared Pictures, therefore require available device storage and appear in device Gallery. No background Wi-Fi sync with user's PC, no direct SMB share yet.
- iOS parity needs new code and Apple signing/TestFlight, Android APK cannot run on iPhone.

## 다음 단계
User should test: install R25 without uninstall → first open 일기 defaults to curated → click '＋ PC 사진·ZIP 가져오기' → choose pre-transferred PC photo(s) or ZIP in Files → wait for imported count and photo rescan → navigate original date in 자동사진 달력 or 수동 사진 선택기 → choose photos and save. Compare with R24: existing curated 9-photo record/112-photo auto total should be intact except newly imported photos corresponding to a day increase the automatic photo count.

R25 success on phone not to be assumed until user verifies import and date counts.
