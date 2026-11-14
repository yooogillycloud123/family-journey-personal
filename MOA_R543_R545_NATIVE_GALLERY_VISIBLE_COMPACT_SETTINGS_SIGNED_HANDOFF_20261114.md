# MOA R543 original-signer native Gallery visibility repair / R545 exact R463 forward recovery — 2026-11-14

## Latest user evidence and priority
Physical Galaxy screenshot `21683.png` and user video `21682.mp4` show **R539 regression**: in-card original native Gallery itself no longer appears reliably; old Web fallback with a single photo/video poster and play/fullscreen controls remains visible, and the newly added settings control is a huge square beside the narrow photo/detail switch. User demands FIRST restore original usable Gallery, and match settings button visual dimensions to switch. Never call R539 or R543 user-approved Golden; only R463 is Golden.

## Actual signed current candidate and rollback
- Combined conversation ZIP: `MOA_R543_R545_NATIVE_GALLERY_VISIBLE_COMPACT_SETTINGS_SIGNED_SOURCE_QA_20261114.zip` **13,112,311B**, SHA256 `4d0604a30c529d142895aefe92bf54ce226ddc87941eccb3cf28344d3ab89b1f`. Includes exact signed APKs, 3 source files and compiled DEX, public QA verifier, 3-theme mock QA, README and checksums. User download in present conversation.
- **R543 test APK**: `MOA_R543_NATIVE_GALLERY_VISIBLE_COMPACT_SETTINGS_ORIGINAL_SIGNED_TEST.apk`, versionCode **543**, 9,058,089B, SHA256 `58835b12bc9e7ce72343d5608a925224ee291d445dce5e8521d8646f7058a48c`.
- **R545 forward rescue APK**: `MOA_R545_EXACT_R463_GOLDEN_FUNCTION_FORWARD_RECOVERY.apk`, versionCode **545**, 8,978,095B, SHA256 `bd44ec952c1e01d2ec01e977335d00fdbd62f9d95e4b1a211177d5914ed1156c`.
- Both package `com.juhyeon.familyjournea`, **original certificate SHA256** `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`. APK-v2 RSA-SHA256 signature, full signed-content digest, ZIP CRC/stored 4-byte alignment, DEX SHA1/Adler32 verified independently after extracting ZIP. **All 139 R539 archive entries except Manifest / additive JS / additive CSS / classes18.dex remain byte-identical**, including **17/17 original R463 native DEX**. R541→R545 rescue changes ONLY Manifest 541→545, 139/139 R463 functional payload items exact.
- GitHub source branch `feature/moa-r543-native-visible-menu-compact-20261114`, code CI [43572345545](https://github.com/yooogillycloud123/family-journey-personal/actions/runs/43572345545) **SUCCESS**, final `classes18.dex` 40,036B SHA256 `7689e075337732d1737ccb51496a4de3c31833396690e2459ac56357100043c1`, exact source Java/JS/CSS and DEX bytes match CI artifact and R543 APK.

## Root cause and implemented repair
1. **R539 alpha-hide compositor proxy was unsafe and disabled/removed.** `r539OnDayScroll` enabled `.moa-r539-scroll-proxy` and sent `s,<token>,1` to Android native provider, setting `nativeHost.setAlpha(0f)`. If the WebMessagePort closed, the `s,0` restore could never be processed, leaving original Gallery permanently transparent while a Web fallback photo remained. R543 removes the scroll alpha message path and web proxy, restores direct R527 event-driven geometry, and in provider ticker uses `setAlpha(1f)` for any owned but unexpectedly transparent Gallery. Initial pre-draw guard of original R511 remains unchanged.
2. **Foreground display and duplicate close safety:** R539 rebind previously destroyed even a healthy original Gallery on every resume and `__moaR539RecoverAfterReturn` called `r507StopInline`, issuing a second `MoaLocalAudio.closeNativeGallery()` even though provider had already closed the old host. Such an asynchronous close can target a newly opened instance. R543 verifies existing host ownership, attachment and video Texture availability; if healthy it restores opacity and mounted callback WITHOUT tearing down. Only an invalid host is closed/restarted; JS forgets its old native state WITHOUT an extra native-close command.
3. **Exact visual control size:** photo AND detailed settings touch target **44×34** with a physical **44×19 pill**, matching the neighboring photo/detail oval switch shape/height. Previous square 34×34 border removed. The photo settings popup is now max **178px** wide with two compact options; the broken `스크롤 중 화면 고정` toggle is removed. Original detailed settings button's handler and full timeline kept.
4. R539 fullscreen selected media ID and same-day re-entry path retained. Original R463 Gallery, Diary, Naver, audio, native DEX remain frozen. These code fixes are candidate, not on-device success assertions.

## What was actually tested
- Java compile+D8/JS syntax and source safety CI SUCCESS.
- APK original-cert v2 RSA signed-content digest/full signature, ZIP and DEX checksum PASS.
- Synthetic Chromium Peach/Black/White: original fullscreen selected index, photo/detail header/setting behavior, JS no errors; added regression assertions that mounted native class remains after scroll, Web fallback remains hidden, **no proxy class**, settings ::before **44×19**, settings popup max 178px, no broken checkbox. PASS.
- **Physical Galaxy R543 native/gallery/activity-foreground/120Hz scroll: NOT TESTED.** User reports R539 failure, do not mark R543 as working without user screenshot/video.

## Install / recovery
- R543: in-place update if installed original-signer versionCode <=542 (user's current R539). **NEVER uninstall**, clear app data, delete NAVER auth/cookies, or alter AirPods project.
- R545: only if a serious R543 regression; higher versionCode and identical R463 functional bytes except manifest. After installing R545, any new test version must be **>=546**. R545 removes experimental photo-day UI while restoring R463 accepted functional behavior.
- R463 immutable original APK SHA256 `9d2fd10d32a3bc35eb3132333e96edd8f565abd5daf3ce954b052f77083d8379`. Never overwrite `golden/moa-r463-user-approved-20261113`.
- Existing protected Library signing material was accessed **locally only**; no private key, keychain, password, P12 or signing source included in GitHub/release. Do not disclose.
- Previous Library storage quota blocked R539 13MB upload. R543 persistent upload unconfirmed; do not claim stored unless tool returns success.

## Specific upcoming device confirmation
1. Open a diary day: original native action row with star/share/GPS/map-info/fast-swipe/thumbnail/expand, native rail visible/toggle.
2. Scroll vertically slowly and quickly 5 times: photo/video stable, never blank or lose native controls.
3. Enter original fullscreen, swipe to second photo, close: in-card index follows selected media.
4. App switch then resume: photo and video card visible.
5. Photo ↔ detail header same date/slide+small pill ⋯, real detail settings open, journal/audio/NAVER unaffected.

Canonical new chat order: `MOA_READ_FIRST_NEW_CHAT.md` → `MOA_R463_GOLDEN_LOCK_READ_FIRST_20261113.md` → latest `MOA_WIP_CHECKPOINT_CURRENT.md` → this exact R543 handoff. Do not restart analysis from R483 or accidentally use R539 as a safe baseline.
