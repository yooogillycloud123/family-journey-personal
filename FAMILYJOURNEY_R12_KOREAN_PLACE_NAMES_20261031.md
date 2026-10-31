# R12 — Korean travel place-name correction (2026-10-31)

## Source/video evidence — not a guess
- User's **actual 60-second, 1440×1440 H.264 MP4** showed `경성(으)로 이동 중` around 00:02 and `Nangen` around 00:10 despite Korean UI.
- Original **`data/cities.js`** has literal records `["Seoul","경성",37.566,126.9784,"KR",10349312]` and `["Nangen","",35.41,127.3858,"KR",81257]`. `tripbuilder.js:102` chooses CITIES Korean alias if present and English if missing.
- Android independent host's `HostActivity.java` geocode handler returned `__geocodeResult(id,[])` rather than actual reverse-geocoder data, so almost every place fell back to bad GeoNames CITIES aliases. **This is the confirmed primary cause.** Rendering quality or video English language setting is not the cause.
- Offline TopoJSON `data/kr-sigungu.js` already bundled with original app holds 250 Korean polygons. Running original vendor d3/topojson against it confirmed points `35.41,127.3858 => 남원시` and `37.566,126.9784 => 중구, code 11020 => 서울특별시`.

## Fix delivered privately
- Added independent `geo-ko-fix.js` script after original map engine and before `native.js`. Uses local municipal polygons and bounding-box checks to supply Korean geocode results **without uploading photos/coordinates**, without editing original app.js/engine.js/native.js/tripbuilder.js or any premium logic.
- Adapted independent `host-bootstrap.js` geocode callback so `native.js` sees proper `{city,county,admin1,country,cc,tz}` for KR; non-Korean points retain original fallback.
- On every `__bootPhotoMap(DATA)`, normalize **cached and newly generated** stop/home/trip titles; previously stored `경성` -> `서울`, `Nangen` -> `남원`; original cached-photo IndexDB remains and no forced rescan is necessary.
- Target naming: 서울, 남원, 전주, 고창, 장흥, 수원 (verified using exact original 250 municipal regions).
- Checked Node/V8 JS syntax, source-driven 6-point polygon lookup, 3-point geocode bridge, cached DATA+trip title migration; all PASS.
- Public GitHub `androidHost` version bump commit `e65521ca1781e8c7a733ce04bce719ff9fb38cda`, host run `41164555940`, compile/sign PASS. Original proprietary data and photo video NOT uploaded.
- Private signed **`FamilyJourney_OriginalUI_KoreanPlaceNames_R12.apk`**, package `com.juhyeon.familyjourney`, versionCode12, SHA256 `578707e314045f779aeba045177c3e89b01f682bcc1b05abb43b61ad49af2419`, size 3,209,794, stable signer `1d471020bbdeccaac105a13ceac4bef95e795a4db17e7c07eef3c971186a396c`. 13 important original source/style files byte-identical with immediately previous R11 switch version; only independent bootstrap/index insert/new script differ. ZIP CRC, apksigner v3, aapt package+code PASS.
- This build includes previous user switch touch controls, previous options changes; no rewrite, original engine code is unchanged.
- **Real Galaxy regenerated MP4 unverified;** user needs actual install and video regeneration to establish phone PASS. Existing saved MP4 files are immutable and will retain previously rendered English labels.
- No Play purchase receipt migrated to new package; do not make an inaccurate claim that separate app is the original paid license.
