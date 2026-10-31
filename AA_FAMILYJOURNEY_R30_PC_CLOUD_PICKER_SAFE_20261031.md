# R30 PC/cloud FILE PICKER enhancement — Android FamilyJourney
Date: 2026-10-31.

## Absolute baseline
- **GOLDEN preserved**: R29 `/mnt/data/FamilyJourney_R29_GOLDEN_DO_NOT_MODIFY.apk` SHA256 `95d82324beb1f0293a9bac49be1ff4f35be1931a3b0caf784009411f0446e041`; never overwrite the backup.
- Test/update candidate: `FamilyJourney_R30_PC_Cloud_FileImport_GOLDEN_Safe.apk` SHA256 `cf95cab35851d6606d0eee597b019e4d1ba238ff69f25063ce7d5051118a61f6`; versionCode30, same package `com.juhyeon.familyjourne3`, same signer SHA256 `24868e5cdf5c8b6699435981f341752dd3fdae6ea89156eaca552605502e4d0c`.
- Changed ZIP entries **ONLY** AndroidManifest.xml(version 29→30), assets/web/app.js(source screens) and assets/web/family-diary.js(import summary UI). All R29 native DEX, photos/maps/naver, diary CSS and icons unchanged.
- user screenshot showed Google Drive, OneDrive, Dropbox pages with disabled buttons because `cloud-config.js` OAuth client IDs / provider app keys were blank. That is NOT a user's login error.
- R30 changes those three unconfigured *screen buttons* to Android native `diaryImportPc` SAF ACTION_OPEN_DOCUMENT picker for JPEG/PNG/WEBP/HEIC/ZIP supported by existing R25 native importer; gives clear PC>cloud>choose-file instructions, cloud provider may be offered if its installed DocumentsProvider supports it. Source list also offers shortcut.
- The R25 native importer COPIES originals into user's local `Pictures/FamilyJourney PC Imports`, reads EXIF shooting time, hashes to deduplicate, indexes in local diary; **storage grows proportionally**, and Google/OneDrive/Dropbox account is NOT live-linked. This is a manual one-time import, NOT cloud metadata-only streaming or cross-phone sync. No account tokens sent to publisher; no new permissions.
- Three-provider simulated browser flow PASS; local media diary regression PASS: photo/video share/gallery, geo collapse, selected-vs-auto cover persistence. JavaScript syntax PASS, APK zipalign + v3 signer verification + ZIP CRC PASS. Galaxy physical document-picker interaction still requires user test.
- R30 is **NOT GOLDEN** until user reports real phone PASS; rollback caution: since R30 versionCode30>R29 29, vanilla downgrade without data migration is not allowed; do NOT uninstall or clear diary data. Preserve R29 as untouched immutable baseline; if R30 regression, fix forward with v31 and same signer.
- No original commercial assets published to GitHub. Private APKs are generated locally from user's R29 installed-like binary; keep private.
## Next
- Show user APK and install OVER R29 without uninstalling.
- Test Settings > 사진 출처 > Google Drive (or OneDrive, Dropbox) > 사진·ZIP 파일 선택해서 가져오기 > Android Documents picker (select installed provider) > images/ZIP > diary photo rescan, verify original dates and count.
- Full automatic cloud sync requires registered OAuth apps, PKCE, provider-specific read APIs, and consent; not enabled, do not claim otherwise. Video import from PC picker not yet supported (user may import separately to Galaxy media library).
