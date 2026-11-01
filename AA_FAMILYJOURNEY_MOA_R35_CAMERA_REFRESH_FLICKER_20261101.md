# MOA camera photo refresh flicker — 2026-11-01 (R35 candidate, NOT installed)
## User physical observation
Immediately after taking a new phone photo/video, existing thumbnails in BOTH the automatic calendar and manually curated diary briefly appear broken (browser broken image icon / text like '달력 대표', '사진 미리보기'). They reappear after a prolonged wait. The user rejects an all-gallery blackout on every new photo.
## Evidence from mounted R31 APK
- R31 assets/web/family-diary.js render() starts with S.root.replaceChildren(), rebuilding every existing image DOM node.
- thumbs(...) then asynchronously calls __requestThumbs in batches and has no cross-render cached data:image snapshot. Consequently visible thumbnails can disappear during a full media reindex.
- __fjDiaryChunk(...) on completed photo-index scan calls render() without checking for identical photo indexes. Scan is batched, but only commit after 'done'.
- The separately installed R34 source/APK was NOT accessible in current runtime, so verify its exact code before merging; screenshots prove a regression but alone cannot establish identical code paths.
## Safe fix candidate prepared (not a signed APK)
- Preserve already decoded/current thumbnail data:image URIs in 18MiB capped in-memory LRU before render; reuse synchronously when DOM is reconstructed.
- Skip re-render if photo/video index identical.
- Keep previous index when a transient automatic rescan yields zero records rather than clearing visible content; distinguish explicit permission revoke and deliberate full gallery removal with correct native error signal.
- On a new entry fetch only missing images; hide broken-image glyph with neutral loading skeleton until thumbnail loads.
- Preserve diary entries, curated selection, calendar cover, Naver integration, videos, R33/R34 brand, native widgets and signer.
- Mounted source candidate path in 2026-11-01 work session: /mnt/data/MOA_R35_photo_refresh_source_patch/ (based on R31 JS, must be rebased on exact R34 before packaging).
- Node VM synthetic scan/cache test PASS; browser navigation denied by environment; actual Galaxy camera/new-media test still NOT PERFORMED.
## Release gate
Obtain exact installed R34 signed APK and assets/signer from prior build artifact; do not install R31-based patch over R34.
Diff against R34, update only targeted JS/CSS and any proven native ContentObserver race, preserve same package/version increment/release signature. Then full ZIP/v2 cert check and physical test: start in Oct calendar, take photo, return; existing 31-day thumbnails must stay visible, one new image appears without full gallery blanking. Repeat with video; verify curated/auto independence and widgets.
No APK release until these gates PASS.
