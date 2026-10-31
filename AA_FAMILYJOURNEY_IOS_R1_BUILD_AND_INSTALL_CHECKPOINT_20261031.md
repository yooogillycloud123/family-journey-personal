# FamilyJourney iOS R1 — Native iPhone build completed (2026-10-31)

## User direct intent and Golden lock
- Android R29 declared GOLDEN by user. Refer first to `AA_FAMILYJOURNEY_R29_GOLDEN_LOCK_20261031.md`.
- Android GOLDEN APK SHA256 `95d82324beb1f0293a9bac49be1ff4f35be1931a3b0caf784009411f0446e041`, com.juhyeon.familyjourne3, v29, signer fingerprint 24868e5cdf5c8b6699435981f341752dd3fdae6ea89156eaca552605502e4d0c. Backup frozen as `/mnt/data/FamilyJourney_R29_GOLDEN_DO_NOT_MODIFY.apk`. Android never changed.
- Wife's iPhone requested with similar main functions, not an APK conversion. Only own code, no private APK or family photo uploaded.

## iOS source and binary
- Original SwiftUI app project at `ios/`, iOS 17+, independent bundle `com.juhyeon.familyjourney.ios`, Korean display name `우리 가족 여행`, gradient heart icon.
- XcodeGen `ios/project.yml`, full Swift sources: `FamilyJourneyApp.swift`, `Models.swift`, `MediaLibrary.swift`, `DiaryStore.swift`, `MainViews.swift`, `PhotoViews.swift`, `MapViews.swift`, `RouteMovie.swift`.
- Built successfully on GitHub Actions macOS (simulator **and physical iPhone architecture unsigned**) workflow run **41199085729**; artifact `FamilyJourney-iOS-R1-UNSIGNED-IPA` id **13042525090**.
- Local unsigned IPA `/mnt/data/FamilyJourney_iOS_R1_UNSIGNED_AppleID_Sign_Required.ipa`: **717,104 bytes**, SHA256 **4ad4873e3eecfe57fbfcfa0cec14d862837dde064dd0e14b0499034b4ff66850**; file has valid `Payload/FamilyJourneyIOS.app`, iOS 17 min, bundle id verified, ZIP CRC PASS, **NO Apple _CodeSignature**. Do NOT claim ready-to-tap install or phone-tested.
- Installation bundle `/mnt/data/FamilyJourney_iOS_R1_INSTALL_KIT_UNSIGNED.zip` includes unsigned IPA and Korean signed-install instructions. Xcode source ZIP `/mnt/data/FamilyJourney_iOS_R1_Source.zip` SHA256 `1dad91d4e450f733484c613968fbd32df9edd0f7abb04580538356d2eb40b80f`.
- For PC-assisted signing user can use Windows Sideloadly and their own Apple ID. Free Apple account test signing requires periodic reinstall/reprovision every ~7 days (Apple docs). For lasting spouse distribution, TestFlight/Apple Developer Program or applicable signing distribution is required. No Apple login or keys collected.

## iOS features actually in compiled source (but no iPhone real-device PASS)
- PhotoKit Photos-library permission and incremental metadata dates/GPS, local photo/video original library references.
- Two fully independent calendar tabs (curated MAIN, automatic all photos), day entries notes editing/deleting, manual multi-select across dates, day cover, image/video viewer and photo pinch/swipe.
- iOS sharing via system share sheet, AVKit video playback, local JSON diary backup and basic manual import (PhotoKit local ids do NOT map cross-device).
- Apple MapKit GPS map 25m approximate grouping; exact coordinate Naver app map link, explicit reverse address lookup.
- Basic GPS journey MP4 builder: map snapshot and animated route export 15/30/60s, 720p portrait/square/landscape, user-initiated save to Apple Photos. The MP4 itself uses temporary storage; Apple MapKit tiles may access the network.
- Gradient Instagram-family color heart icon.

## Explicit parity gaps (NEVER hide)
- No automatic NAVER favorites account save/list selection/memo accessibility automation on iOS. Just opens Naver app at GPS pin. Apple iOS sandbox doesn't expose equivalent Android AccessibilityService controls.
- No Android R29 IndexedDB diary automatic transfer to iOS; JSON backup import cannot resolve PhotoKit IDs across devices automatically. No family synchronization.
- No full original Android R29 video editor/theme/camera animations, detailed all region fill/world globe, full OS off-device PC photo imports.
- iOS PhotoKit managed iCloud Photos can download Apple-hosted originals if user chose iCloud Photos; user app does NOT run its own photos upload backend.
- No physical iPhone installation, permissions, Naver, gallery share, or video MP4 correctness testing yet. GitHub CI compilation != actual iPhone PASS.

## Next
- User's spouse signs unsigned IPA using Apple account through Windows Sideloadly (or Mac Xcode), enables Developer Mode; test photo permissions/auto vs curated diary/share/map video and Naver; preserve data and note errors for follow-up.
- Future iOS releases continue from current `ios/`; parity gaps must be addressed in priority order. Do not alter Android Golden R29.
