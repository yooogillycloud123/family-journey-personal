# FamilyJourney R17 — detailed-address first + NAVER favorites nickname/memo + Android Back (2026-10-31)

## User-confirmed issue and desired flow
- R16's newly invented **local favorites list UI is not wanted**; user asked to use the prior R15 experience.
- On each ~25 m photo GPS visit: tap 상세 주소 조회 -> Android geocoder yields street/lot address -> NAVER Maps must search that **actual address**, not a user nickname such as "고창 차 안".
- User-entered nickname and additional memo are **metadata for a NAVER saved place**, not a place search term.
- Gallery overlay cannot require tapping only the 닫기 button; Android system back should first close overlay, and pressing Back on settings should return to map rather than abruptly leave app.
- All original travel map/photo/video engines and automatic EXIF cached map must stay intact; no recommend/battle tabs; no original publisher API.

## What is actually implemented
- Reverted the public UI appearance from the R16 private custom local-bookmarks menu to R15's original precise GPS/photo gallery screen, while retaining the separate R16 app package for in-place update (`com.juhyeon.familyjourne2`). Old unwanted `fj-private-gps-v16.js` deleted from APK.
- Previous R15 `fj-naver-favorites.js` extended privately: GPS address now takes precedence over POI/alias; when none cached, request reverse-geocode on explicit user tap, save real address locally; separate nickname and memo fields; list prompt referring to an existing NAVER list. No dependency on city-level POI names.
- `HostActivity.java` public commit `f59ad7b814879160799d788d6b0bb617a7d8906e`: new address/alias/memo/list native bridge; uses official NAVER address-search intent; user-activated accessibility permission flow. Android onBackPressed calls `__fjBackOverlay` first, then original `__photoMapBack`, then switches settings/tab to HOME; asks before actual app exit.
- `NaverSaveService.java` public commits `f9cedf257f9b0db1311075cbc7d26fd6d22e4f3d`, `5f2e7bc4d65afb6105020a18fcb8f6238479691a`: opt-in **single place** service restricted to NAVER Maps app only; checks matching address detail (not arbitrary search result), attempts Save -> selected existing list -> memo dialog and local text write -> confirmation. Does not mark VERIFIED merely because it clicked a Save button. If the UI doesn't match, shows NEEDS_USER_MEMO_EDIT/NEEDS_USER_MEMO_VERIFY (manual input necessary); times out in 3 min.
- The above did **NOT** create a supported NAVER account write API or verified automatic save. Native NAVER UI is untested, may require user to select address search result and/or edit memo manually. No false Android Naver account PASS claim.
- GitHub Actions run `41180019765` succeeded compilation/sign for final native host. User-owned original web bundle and signing secret remain PRIVATE, not published to Github.

## Private APK validation
- APK: `FamilyJourney_R17_AddressSearch_NaverMemo_BackButton_FINAL.apk`
- Android package `com.juhyeon.familyjourne2`; code 17, version `1.0.4-addr---r17`. Updates R16 **without uninstalling**: same R16 signing certificate SHA256 `0d25313c1a6f769d1a9b43ea9d3b7a4626a12924a887062ad25dc69907fbad09`.
- SHA256 `d8395f859f66ecc037f7d4b63f6808c387774893f126055deadabfe2ac5d2737`, bytes 3,267,371.
- aapt package+version PASS, APK v3 signing PASS, ZIP CRC PASS, node JS syntax PASS, source-driven VM mock PASS: GPS reverse address -> NAVER native payload, alias/memo separate and not used as query, modal back hook closes gallery.
- Source files `app.js`, `native.js`, `engine.js`, `render-worker.js`, `tripbuilder.js`, `family-addon.js`, `geo-ko-fix.js` byte-identical to user-provided R15 APK.
- Samsung Galaxy actual back behavior and actual NAVER account saved list/nickname/memo read-back **NOT VERIFIED**. Screenshots from user will validate.
- R15 old app uses a different package/signing identity and remains unmodified. R17 upgrades R16, not R15.
