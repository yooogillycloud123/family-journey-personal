# 2026-10-31 — blank first screen and unresponsive “시작하기” — real device FAIL then correction R9

## Device observation
User installed independent clean host v8. Screen shows mostly blank white page, thin blue progress line at 20%, static blue **시작하기** button at bottom. The exact original `index.html` has all travel `section[data-page]` hidden by default and the 20%-width progress line and button in static markup. Those are only replaced/initialized when `app.js boot(DATA)` runs. This strongly suggests **WebView loaded HTML but original travel app boot has not completed**. Source evidence, NOT yet proven phone log of which upstream photo/permission/cache step failed. Do not blame Google Play nor claim that pressing 시작하기 should work before dataset boots.

## Source changes
Public independent Android host only, not original user-owned copyrighted assets:
- `630d1488` first WebChromeClient JS error observer, permission-phase tracking, page-loaded watchdog; initially Java compile FAIL due incorrect escapes.
- `4f17a5e9` corrected Java compilation syntax (JSON object WebView callback), later `ca866ea` added permission retry command and original back navigation.
- `40529d40` bump host from code8 to **versionCode9**, package `com.juhyeon.familyjourney`.
- Independent Android host CI **run 41159429025, build/sign/ZIP verify PASS**.
- Separate **private user-supplied source** integration added a new `assets/web/host-monitor.js` (after original app.js, before native.js), detecting successful `__bootPhotoMap(DATA)`, sending native boot ack, and after 18 seconds presenting a retry/permission/sample diagnostics panel rather than silent white screen. Original `app.js`, `native.js`, `engine.js`, `render-worker.js`, `tripbuilder.js`, `style.css`, geography data unchanged byte for byte.
- Private signed APK `FamilyJourney_Original_UI_CleanHost_v1.0.4_START_FIX_R9.apk` SHA256 **62c080e673983eec604bbeedef6aa1d64f5fdc8a66c594c6dba6de2c3ed525b3**, 3,201,235 bytes, Android v3 signature PASS, stable signer SHA256 **1d471020bbdeccaac105a13ceac4bef95e795a4db17e7c07eef3c971186a396c** (same as earlier v8), versionCode9, activity, ZIP CRC PASS.
- The 18s fallback is a **diagnostic/recovery improvement, not proof underlying EXIF/map problem solved**. App may take longer to scan >7000 photos. Only real phone can establish success.

## Important honesty
- No original commercial APK / private photos / signing key in PUBLIC GitHub.
- **No real device PASS yet**. Purchased Google Play premium from `com.hueeng.phototravelmap` does not migrate to this separate package. Do not call full premium complete or bypass entitlement.
- Never uninstall official app. Since v8/v9 same package & signing cert, v9 can update existing clean-host beta in-place, preserving its app data. Legacy earlier re-signed Pairip version may use a different signer and cannot overlay; distinguish correctly.
- App remains independently compiled runtime with original user-provided web assets bundled privately, not a "fully tested final" release.
