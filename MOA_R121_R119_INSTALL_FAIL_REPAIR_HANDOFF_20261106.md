# MOA R121 — 2026-11-06 R119 installation-failure follow-up

## Immediate current state
- User screenshot `19084.png` displays `앱이 설치되지 않음` after trying R119. This is a **real Galaxy INSTALL FAIL**, not a file-download error.
- R119 prior report: code119, 5,416,801 bytes, SHA256 `332e4508e4e7cce99592013be2b5e42be069e53aba44a670a6ad35d046d730fa`. Prior v2/ZIP static report PASS is **not** an install PASS. Actual original R119 APK/source QA were not found in accessible current runtime nor the current MOA private Library contents; root cause and Android `INSTALL_FAILED_*` code UNKNOWN. Do not claim to have repaired the unavailable R119 binary.
- Current trusted baseline R117: SHA256 `667e6caa97ffc76b10df15594d5be0672ea892ae0be2692b293161eba94dfdb0` and real-device tested per user. R115 user-approved frozen GOLDEN SHA256 `1118bdc249e2d941a899518e58be0185b120a887ff2c371c8f5a01037a5002a8`. Both original APKs read from private Library, unmodified.

## Exact R121 beta candidate generated in the 2026-11-06 conversation
- `MOA_R121_INSTALL_REPAIR_BETA.apk`; **versionCode121**, `com.juhyeon.familyjournea`; **5,415,933 bytes**; SHA256 `3e85d68ad652c5a55eafe01ec31ecbc2129bbea0e56a76eca70c4594b89a094a`.
- Original certificate SHA256 `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`; original private signer archive used locally and deliberately excluded from repository/QA.
- Exact R117 APK 105 entries: **103 byte-identical contents**; changed only `AndroidManifest.xml` versionCode (one byte 117->121) and `assets/web/index.html` loader references; appended only `assets/web/moa-r121-ui.js`, `assets/web/moa-r121-ui.css`. No DEX/native/diary/storage/launcher/map engine modification.
- Photo gallery info is an additive DOM layer on original `fj-naver-favorites.js` gallery: native MediaStore-derived diary timestamp if available, GPS from existing `FamilyJourneyExtension.getData().photos`, native address from existing `FamilyJourneyNaver.reverse` (absent/failure explicit), Naver `nmap://map?...&appname=com.juhyeon.familyjournea` via pre-existing native openUrl command. No fabricated address/GPS, updates when photo ID changes. Actual Android intent still untested.
- Diary cleanup is **CSS presentation only**: hides original capture toolbar, PC ZIP import panel and manual date/new diary form on diary screen, does not delete their handlers. Settings > 사진 및 데이터 appends a separate button that invokes original `FamilyJourneyDiary.momentToggle` and reads `MoaMomentNative.enabled`.

## Gate evidence
- Static ZIP CRC; STORED resource 4-byte alignment; 5 DEX SHA1/Adler; APK v2 signature/content digest/identical cert verified via independent parse; DOM mocked in Chromium: photo date/address updates, GPS absence hides map link, Settings switch calls native bridge wrapper, official scheme URL formed; Node syntax PASS.
- **NOT TESTED**: actual Galaxy install, verified Naver-app URL dispatch, actual capture/toggle, exact original EXIF availability for every photo, full function and data preservation during install. R121 is **BETA**, not Golden, not a confirmed R119 root-cause fix.
- In-chat user APK and no-key source ZIP were created and verified in the current runtime. Actual user download accessibility is not proven until recipient confirms. No Gmail/drafts/attachments.
- If installation again fails, first obtain read-only PackageManager failure code and inspect compatibility. No uninstall, no app-data clear, no blind signer rotation or manifest resource-ID edits.
- Upcoming family calendar/3D globe design is separate; do not bundle unvalidated large features into this minimal R121 candidate. AirPods source and all historical MOA Goldens protected.

## Next chat
Read AirPods canonical as required without changing AA, then R115/R117 handoffs, release ledger, this R121 handoff; check actual MOA files. Continue from confirmed user's R121 install result. No speculative new version until failure evidence or explicit feature request.
