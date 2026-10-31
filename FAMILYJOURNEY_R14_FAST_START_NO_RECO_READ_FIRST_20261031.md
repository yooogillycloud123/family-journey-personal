# FamilyJourney R14 — No recommendation + near-instant saved-map restore (2026-10-31)

## Verified user intent / screenshot
- R13 real Galaxy screenshot proves the independent app eventually loads the original style family travel map with photo-circle markers and visited districts; user says each *reopen* can show blank 20% screen for nearly **1 minute**.
- User explicitly removed **추천** (festivals, recommendations, likes) entirely, and previously removed 지도 대결. Keep original map, records/passport, travel video, existing exact individual-photo GPS + Naver candidate-review list. **Actual NAVER account favorites auto-save is not yet implemented**.
- User says precise location queue is now useful; DO NOT revert to city-only labels.

## Source findings
- Existing Android Host `HostActivity.scan()` on cache miss iterates **every** MediaStore image, opens original image streams and reads EXIF. With about 6,489 geotagged photos (reported by user's UI), scans can be costly. No actual phone timings/logs available; **repeated full scan is a plausible cause, not proven cause of user's exact 1 minute**.
- `native.js` already had IndexedDB keyed by `photo-map` and `deviceFp=MediaStore image count|last DATE_MODIFIED`, but waiting for Android's fingerprint/permission pipeline before displaying cached map made app appear blank and slow when startup handshake was late or full rescan triggered.

## R14 actual changes
- Public Android Host `HostActivity`: persisted compact **on-device EXIF GPS JSON cache** inside private app files. On same MediaStore fingerprint, reuse photo metadata rather than opening every image again. Force rescan bypasses cache. No location/personal data in PUBLIC repository. Commits `70c8fe965d4178d240481bbebc8d21d89ea1dcc4`, `d603feb09957cc6739adb18eb60dc68262fbbb6a`.
- Important reload bug fixed: WebView `readyReceived` one-shot latch is reset in `onPageStarted` so photo re-index and cache-refresh navigations can trigger NativeBridge again.
- Private user-owned app web files: `native.js` now attempts **optimistic cache-based map render on DOMReady**, independently of Android media indexing, then sends ready; 1.2s fallback prevents waiting forever for IndexedDB. If fingerprint differs, EXIF refreshes in background and saves new map; automatic reload only if user is on home (avoids interrupting video editor). If refresh returns invalid data, retain previously visible map.
- **추천/대결** bottom tabs hidden, legacy #reco / ?tab=reco routed to home; menu returns 3 tabs: **나의 지도 / 기록 / 설정**. The actual original tripbuilder/engine/video renderer, Korean polygon resolver, Naver precise-photo queue, assets remains untouched. UI scripts only modified privately in APK, not uploaded publicly.
- Previous `host-monitor.js` emergency modal's **샘플 여행 보기** button removed. Demo data was already absent from packaged R13.
- No original author server allowed by `NetworkPolicy` public Host. Full real-device packet capture still not validated.

## Tests/build
- Android Gradle CI run **41170138694**: SUCCESS, APK signing and ZIP integrity checks. Compiled public host only.
- Private signed combined APK `/mnt/data/FamilyJourney_R14_FAST_START_NO_RECOMMEND.apk` package `com.juhyeon.familyjourney`, versionCode **14**, 3,222,244 bytes, SHA256 **e46f4e9827ffadc291bc086c17bb61d00e241daf5cbe25dea4e9e118d245c588**, signer certificate SHA256 **1d471020bbdeccaac105a13ceac4bef95e795a4db17e7c07eef3c971186a396c** same as R13.
- Full package: v3 signed PASS, CRC PASS, unchanged important core scripts engine/app.js/tripbuilder/video, no demo.js, three tabs. No private purchased source/photographs/GPS uploaded to PUBLIC Github.
- Headless Chromium **synthetic cached-trip test PASS** 17 fake stops, 2.77 sec to render cached map (not a phone speed measurement); Home ↔ Record tabs PASS, unwanted tabs hidden, JS exceptions 0.
- Galaxy *real start timing* and real new-photo refresh remain **NOT TESTED**. First cold launch may still need full EXIF scan; instant path applies when a valid local travel map already exists. R13 existing IndexedDB cache should carry forward via same package/origin if user upgrades in place.

## Still unresolved
- NAVER account actual write/readback: NOT IMPLEMENTED. Current detailed photo GPS candidate review remains.
- External photo-service provider logins: NOT FULLY VERIFIED. Publisher-dependent recommendation/festival removed at user's request, no separate replacement needed.
- Do not claim exactly <3 seconds on user's Galaxy. Test app reopen after upgrade and observe actual startup; if still long, collect `FamilyJourney` log lines and distinguish cached-map IndexedDB vs Java MediaStore fingerprint vs forced rescan.
