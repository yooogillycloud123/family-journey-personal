# MOA R683 — USER-APPROVED PHYSICAL GOLDEN LOCK (2026-11-17)

## User's actual device acceptance (authoritative)
The user explicitly states on Samsung Galaxy that **R683 succeeds across the previously requested functions**, accompanied by original photo gallery screenshot `23449.png`. Promote **the exact installed signed R683 APK** to the next protected Golden baseline, never the R684 R680-functional recovery. This is a **user-physical acceptance** (not a laboratory claim for every future environment). Do not retroactively edit R683.

- Original exact APK: `MOA_R683_PRECISE_HEADER_GALLERY_VERSION_ORIGINAL_SIGNED_BETA.apk`
- Package `com.juhyeon.familyjournea`; versionCode **683**; original certificate SHA256 `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`
- APK SHA256 **`e20e446d5e02358e833fe223471735abc3fd042234b4efc53acc208118ee9e8b`**
- Size 9,685,046 bytes, preserves original native Gallery classes6.dex and original PHOTO/DETAIL/QR DEX 1–18 baseline of R679 except R683's original unchanged content. Preserve `classes19.dex` as included in the EXACT R683 APK.
- Original source/build handoff: `MOA_R683_HEADER_GEOMETRY_REPAIR_HANDOFF_20261117.md`, release archive `MOA_R683_R684_SOURCE_QA_RELEASE_20261117.zip`.
- Original browser/static QA includes matched CALENDAR, PHOTO, PHOTO-ADD header and TODAY, legacy ghost protection, original native PHOTO-ADD host identity fix, version in Settings. The user now confirms the installed version functions as intended.
- The screenshot shows original gallery photo, native thumbnail rail, lower Share, GPS, map-info and double-chevron fast-swipe controls. Do not publish user photo/GPS/private media in this repository.

## The ONE newly requested change
The lower `>>` upper-stage fast continuous swipe toggle returns to OFF upon leaving/reopening Gallery, even when previously set ON. The **new user's requirement is persistent preference: ON remains ON, OFF remains OFF on gallery re-entry, PHOTO↔DETAIL, photo-add, app resume and process restart**, unless user explicitly changes it. Keep the original stage physics, original 4-action deck and all other functions unchanged.

Exact R463 original native ActionDeck source `MoaR391SessionPersistProvider_R463.java` contains `r463DisableFastSwipe(entry)` as lifecycle cleanup, while the click handler only mutates `entry.fastSwipeEnabled` in memory. **Persist explicit user ON/OFF to SharedPreferences on successful click; when new Gallery opens, read and restore preferred state after native stage is attached. Do not store OFF during automatic close/cleanup, and never interfere with original Photo native 8 actions.** PHOTO ADD separate original-copy deck may need the same preference key to match all gallery paths. State read/write must not edit IndexedDB, cookies, Naver, images or raw data.

## Golden / QA non-negotiables
1. R683 must remain BYTE-EXACT and IMMUTABLE. Create an isolated new branch, not an in-place source revision.
2. Every candidate higher code >=685 if R684 could have been installed, plus independently prepared forward restore **higher than candidate** containing all exact R683 original APK functional ZIP members except the Manifest version.
3. Same package, original signing cert and APK v2; validate DEX, ZIP, Android SDK35 aapt/aapt2 parser, zipalign, apksigner, actual installed version displayed in Settings and update-install compatibility. No falsely claimed Samsung physical PASS before user test.
4. Regression: PHOTO/DETAIL original 8 native actions, pinch/rail/video/seek, Naver return, QuickRecord and OneHand behavior, CALENDAR/PICKER top geometry, TODAY, system-bar transitions, Settings version; fresh press ON→close/reopen ON; OFF→close/reopen OFF; app restart both states. Preserve photo/date UI, gallery native full quality.
5. No app uninstall, no clear data/IndexedDB/cookies, no Naver wipe, no signer/package switch, no AA AirPods/Android Auto changes.
6. Every new chat: read this lock after `MOA_READ_FIRST_NEW_CHAT.md`, protect this R683 baseline and continue only from this exact user-verified R683 APK—not R680/R684, R625, or older experiments.
