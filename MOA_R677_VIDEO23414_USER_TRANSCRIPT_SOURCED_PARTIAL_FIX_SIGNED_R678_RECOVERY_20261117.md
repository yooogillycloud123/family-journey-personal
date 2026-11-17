# MOA R677 / R678 — user narrated video 23414.mp4 (2026-11-17)

## Exact authoritative user observations
The user provided 4m19s narrated Samsung video and Korean transcription. Do not ask them to narrate it again.
- 00:01–01:08: navigating Naver “나의 지도” ↔ calendar/PHOTO/DETAIL shows retired diary background text, flashes, Android status bar (clock, Wi-Fi, battery).
- 01:09–01:40: date header text/font/switch jumps between calendar, PHOTO, detail.
- 01:40–02:00: photo-add gallery grid looks extremely blurry.
- 02:29–02:54: photo-add scope switch is too visually big.
- 02:54–04:19: separate photo-add full gallery differs in quality/controls from original PHOTO/DETAIL gallery. User requires THE EXACT ORIGINAL `MoaNativeGallery` engine from existing classes6.dex, with only a bottom-right selected photo `+`; NO new lookalike engine.

## Current immutable source truth
R675 original-cert signed APK code675 SHA256 `fd5ebcee07b4a72a432fb06e91962bec4484f22ec9e78af8b7ecad7c5a9c3119`. Its original PHOTO/DETAIL/QuickRecord DEX1..18 already preserved. Its picker separately creates a NEW instance of actual original classes6 `MoaNativeGallery` using real constructor/open methods, and appends an R463 native ActionDeck + select. It was built and official SDK35 verified before this work, but physical user acceptance **NOT proven**. R676 version676 is R673-functional rescue, not user-physical Golden.

## R677 scope: surgically limited (NOT a complete resolution)
Build from exact R675, keep original PHOTO/DETAIL/QuickRecord DEX1..18 **byte identical**:
1. Picker-only 3-column grid thumbnail request from 260 to 640px, ensure low 260 cached thumbnail does not suppress 640 upgrade; normal 260 calendar/rail unchanged. 
2. Picker-only CSS 68×40 touch target but 44×19 visual slider matching original PHOTO/calendar; TODAY 34×40. Original PHOTO CSS unchanged. 360/390/412 Chromium mock tests PASS.
3. Picker-only Native Activity FLAG_FULLSCREEN and IMMERSIVE_STICKY flags, suppress status bar exposure in separate picker context. Original PHOTO/DETAIL Native Activity untouched.
4. Keep actual original native Gallery engine + old action deck / selected + from R675. NO ImageView lookalike.

## What is not fixed / must not be falsely claimed
- Calendar/map-to-photo ghost text + intermittent black/gray flashes, and original PHOTO/DETAIL transition Android clock/status bar: **not yet source-confirmed or physically fixed**. Do not blindly rewrite protected R507 PHOTO owner, classes6 or QuickRecord.
- Header date alignment beyond picker switch visual scope was not independently physically retested.
- Full-resolution original native viewer/device video/share/GPS/Naver/inertia parity is NOT physically reverified. R677 thumbnail change primarily affects the picker list, not original full-frame decoder.
- Device install, background lifecycle, Naver/IndexedDB regression and Gemini matching are all untested.
- R677 candidate must NOT be called FINAL or user-physical PASS.

## Build / sign / QA
R677 `MOA_R677_VIDEO23414_PICKER_HIRES_FULLSCREEN_SIGNED_BETA.apk`, package `com.juhyeon.familyjournea`, versionCode **677**.
- 9,621,455 bytes, SHA256 `26297718c3306bfac54ebb653ec15b3e56ac853ce7a0ee7b261583ca6c96aefc`.
R678 exact R675 functional **forward** recovery (except versionCode), 9,565,293 bytes SHA256 `e8d22bb0498b55b567ff2a4f02a77817611e5bc5fb5540f7f832b9868f2ce747`, code678. It does not revert app data/runtime cache.
Both signed privately with original cert SHA256 `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15` (private signing materials NEVER upload to GitHub).
- Android SDK35 GitHub javac+D8 `classes19.dex` compilation SUCCESS in workflow **44019039300**; previous failed workflow was artifact push permission problem after DEX compile, fixed by removing push stage.
- RSA APK v2 independent signature+content digest PASS, Android binary manifest parser 101 nodes, original package and versionCode PASS; ZIP CRC, 4-byte STORED alignment, all 19 DEX SHA1/adler32 PASS; original DEX1..18 exact, original R675 class6 Gallery byte exact.
- Browser UI/selection/native dispatch/date-wheels 360/390/412 PASS, no JS errors; isolated 640/260 thumb request QA PASS.
- No local official Android apksigner/aapt2 installed for *new* APK; custom independent verifier PASS, original R675 was officially SDK verified. Samsung actual install/test PENDING.

## Provenance / continuity
Branch `feature/moa-r677-video23414-evidence-surgical-20261117`: source Java, JS, CSS + isolated no-key GitHub Actions CI. Changes kept isolated; unmodified original PHOTO/DETAIL engine retained.
Private Library `/모아_프로젝트_근거_20261103/R677_VIDEO23414_SOURCE_STAGE_20261117/` contains exact R677/R678 APKs and bundle `MOA_R677_R678_23414_SOURCE_QA_INSTALL.zip`, public-safe source+QA. Private signer kept ONLY in existing PRIVATE_SIGNERS folder, not GitHub or bundle.
Bundle local SHA256 `56be7262c33c04dabcb146f2c70b0858944119eac1c49680261b0040dd337aaa`.

**Do not uninstall app, clear app data/cookies/IndexedDB/Naver, change signer, modify unrelated AirPods Android Auto audio.** Test R677 over code<=676, if regression use R678 exact R675 functional forward rescue. If R678 installed future version>=679.
