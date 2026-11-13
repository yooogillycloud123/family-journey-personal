# MOA R503 / R505 — photo diary UI/bridge fixes, original-signer APKs (2026-11-14)

**STATUS: R503 PARTIAL BETA, not final full in-card native Gallery.** The only user-approved immutable GOLDEN remains **R463**, SHA256 `9d2fd10d32a3bc35eb3132333e96edd8f565abd5daf3ce954b052f77083d8379`, frozen branch `golden/moa-r463-user-approved-20261113`. Existing R499, R501, R463 source/binaries untouched.

## User evidence and nonnegotiable acceptance
- User video `21377.mp4`, screenshot `1794586899548.png`: Photo diary screen is NOT meant to launch a separate high-end Gallery on tap. The picture/video stage **itself** must be the original fluid native Gallery (R203 physics with R463 4-button native footer, fullscreen-quality images, native inline video/media audio/volume/capture/seek and real GPS/Naver), integrated with diary story below. User reports home pink dot not returning from photo entry via center +. Current R499 photo-mode button gestures/geo/metadata/cover-star are inconsistent; original Gallery works elsewhere.
- Period title border/underline should be entirely absent; year/month picker both should use consistent vertically scrollable white, bordered cards (dark theme proper contrast).

## Exact built outputs
- **R503** `MOA_R503_PHOTO_DIARY_UI_BRIDGE_ORIGINAL_SIGNER_BETA.apk`, versionCode **503**, 9,009,872B, SHA256 `2667b3f123955aa88fd7c0787e6d7a430a75f1ad4fd55dbd341b119a6f9c6de2`.
- **R505 emergency-only exact R463 functional recovery** `MOA_R505_EXACT_R463_GOLDEN_FORWARD_RECOVERY.apk`, code **505**, 8,978,144B, SHA256 `ece15ddb56b3e5f1fc453d07f859b5e2c0a662398968490255593aaf1b141037`.
- ZIP with exact signed APKs, exact JS/CSS/Home source, QA, preview, Korean readme: `MOA_R503_R505_SIGNED_APK_SOURCE_QA_20261114.zip` 13,165,319B SHA256 `31a0432d63cd2d41bbdc4a1bc9ea6dc67c122bf9f7ddfeef5591c809247a2a1d`.
- Same original installed package `com.juhyeon.familyjournea`; certificate SHA256 `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`. Private signing keys are only in protected user private Library and not uploaded to public GitHub or release files.
- Private Library `/모아_프로젝트_근거_20261103/R503_R505_PHOTO_DIARY_BRIDGE_20261114/`, includes direct R503 APK, direct R505 rescue APK, combined ZIP, exact JS/CSS/Home files, README. Exact source branch `feature/moa-r503-photo-diary-home-cover-picker-20261114`.
- R499→R503 changed **only** 4 archive members: `AndroidManifest.xml` (499→503), `assets/web/moa-r483-vertical-calendar.js`, `.css`, `assets/web/moa-r389-home-dot.js`. The original **17/17 DEX fully identical**, untouched native R463 Gallery, Naver offscreen writer, data schemas, themes and original Diary remain frozen.
- R501→R505 has ONLY Manifest code 501→505, all R463 Golden functional content identical.

## R503 changes actually implemented
1. **Pink home button real root fix:** R389 `home()` called original `FamilyJourneyDiary.open()` even when unified Photo mode active, so it did not change the overlay. Minimal R389 script patch calls `MoaR469SimpleDiary.home()` ONLY while unified overlay is active. Home uses existing `goBack()` with unsaved-writing confirmation and returns to the unified calendar, preserving drag/edit/resize/idle operation otherwise. Four-theme synthetic Playwright pointer tap PASS, zero legacy `Diary.open()` calls.
2. **Representative photo stars restored:** small star visible at top of main photo, separate star on *each thumbnail*, selected state synced to the same `calendar-covers-r29` record as original app. Existing save avoids re-creating entire media stage and interrupting video/rail. No photo copies.
3. **Actual native GPS/Map action connection:** R499 `geo` just opened an info panel; R503 calls original `FamilyJourneyDiaryGeo.attach()` and, only after original media GPS yields the actual native `네이버지도` button, dispatches that button (which invokes original `NativeHost.post('diaryOpenNaverPlace',{lat,lon})`). No invented GPS: absent GPS -> info panel only. Same owner still handles address lookup and Naver favorite route.
4. **Day photo tap** now toggles the in-card media action area, instead of launching an unrelated full-screen Gallery automatically. Video button still offers existing native Gallery route, **NOT in-place native playback parity**.
5. **Month/year picker**: period header fully borderless/underline-free; both year and month equal-width vertical scrollable option lists in white theme-matched card surfaces with narrow contrast-safe outline, selected item auto-centered on opening.
6. Original R495/R499 one-calendar routing, scrolling toggle, thumb-to-stage sync, diary data flow untouched.

## Verification and known blocker
- Node JS syntax PASS for changed JS/Home.
- Synthetic Chromium 420x870 all four app themes pink/peach/white/black: 201 year options, 12 month options, two independent scrollable identical columns, white month container or black theme dark equivalent, period underline absent, 4 original-like footer actions, visible stage+thumbnail star, native Map callback simulated and invoked, floating pink Home real pointer tap returns to unified calendar without legacy Diary.open(), no JS runtime errors. **Simulated native callback is NOT physical NAVER PASS.**
- Independently verified original signer, v2 RSA signer's signature and full APK signed content SHA256 digest, ZIP CRC, stored-entry alignment; APK-in-ZIP byte identity, 17 original DEX identical **PASS**.
- **Hard blocker / not delivered:** Actual R463 `MoaNativeGallery` in `classes6.dex` builds a full-screen native `FrameLayout host` added to `android.R.id.content` and is controlled by supplementary `classes17.dex` R463 gallery actions. R499/R503 do NOT move native media `TextureView/MediaPlayer` renderer + R203 scroller *inside* the WebView photo card. Full genuine embedded high-quality native Gallery/inline video/volume/seek/capture and real card-to-native photo rail sync still require a new native View-host bridge and on-device integration QA; should not try CSS tricks or say complete. **R503 is a transparent partial beta**, user has not approved promotion.
- Galaxy device install, real NAVER/EXIF capture info, volume/video/native within photo mode, 14k media performance, 201-year picker on hardware, home flow under actual Android BACK **NOT tested**. Recipient Android ChatGPT link may still show `Library file not found`; successful sandbox file presence != user's download confirmed.

## Installation / rescue
- Only update-install R503 over installed code <503 and same package/cert; **never uninstall, clear app data/cookies, delete photos/IDB**.
- R505 for serious regression only, restores R463 function; after R505 install all future candidates code **>505**.
- Do not change any AA AirPods/Android Auto software.
- Next candidate must prioritize **actual embedded native Gallery**: source inspection `R227_MoaNativeGallery.java` and R463 `MoaR391SessionPersistProvider.java`, add dedicated native photo-card host that reuses original Gallery engine/controller while preserving original full-screen entrypoints. Evidence with real Galaxy required before FINAL. Do not call new APK FINISHED if it only opens the existing full-screen Gallery.

Before any new work read `MOA_READ_FIRST_NEW_CHAT.md`, `MOA_R463_GOLDEN_LOCK_READ_FIRST_20261113.md`, `MOA_WIP_CHECKPOINT_CURRENT.md`, this handoff, signed R503/505 artifacts, and original R463 immutable source.
