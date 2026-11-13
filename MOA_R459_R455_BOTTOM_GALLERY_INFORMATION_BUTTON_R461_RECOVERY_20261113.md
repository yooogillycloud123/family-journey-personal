# MOA R459 — move top folded-map information toggle to third bottom Gallery action (2026-11-13)

## User intent and evidence
- R455 Galaxy screenshot `20978.png` shows a good ~20dp folded-map icon at top-center. User proposes moving THIS icon to the bottom **extensible** Gallery action row next to Share and actual NAVER map destination, eliminating the standalone top folded-icon click target.
- Required three LOWER icon-only controls, in order: **공유 / GPS 네이버 지도 이동 / 접이식 지도 그림 = 촬영 시간·주소 정보 펼침**. The third glyph must NOT navigate to NAVER Maps. All existing Gallery video/rail buttons must remain untouched.
- Clicking bottom third button displays the **existing compact top capture-time/address/`기본 표시` checkbox at the original same anchor** used by R451/R455, not above the footer or in a new modal. Clicking again while `기본 표시` unchecked collapses. When checked, the top card stays pinned and is the default visible state upon reopening; uncheck to collapse again.
- Original private screenshot remains in private Library only; **do not publish screenshot/face/GPS**.

## Immutable baselines
- Current user-approved integrated Golden remains **R435** in frozen branch `golden/moa-r435-user-approved-20261113`, exact APK SHA256 `e36e55b823d9d8aa1650c05fb8314b5773df7b00287dab2e102440eea51f910c`. DO NOT modify or silently promote new beta.
- R455 immediate user-visual-confirmed baseline `MOA_R455_TOP_MAP_ICON_21DP_SIGNED_BETA.apk` versionCode455 SHA256 `9676fc801c67d547a972505f3353ac261f19d37e33d92851dda2df68f97ff166`. R459 is based on its exact APK and source, not an older R451/R443/R435 rewind.
- Source feature branch: `feature/moa-r459-gallery-bottom-info-toggle-20261113`, file `experiments/moa-r391/MoaR391SessionPersistProvider.java`; changes compile to supplementary `classes17.dex`. No modifications to original `classes6.dex`, GalleryRail, video decoder, R227 Sharesheet retention, NAVER writer or cookies.

## R459 UI implementation
- Original Gallery action capsule 50dp height, kept below existing filmstrip. Add third 42dp button with `GalleryFoldMapGlyph` drawing same R455 ~20dp white three-panel map mark. Capsule scales its **width only** from 2 to 3 equal action slots. Buttons are native and have accessibility descriptions but do not display labels.
- Existing `share.touch` calls original R443 share-retain path; existing `map.touch` calls original `r225OpenNaver()` with GPS gating. Both remain untouched.
- New `infoAction` toggles `GalleryActions.infoExpanded`; no external navigation, no new permissions, no extra APK.
- Remove the upper collapsed map glyph entirely. Top `toggle` native FrameLayout becomes **non-clickable and GONE while collapsed**. The only visible thing at the top when expanded is the compact metadata card, kept at R455's status-inset-safe top-center y-position. It mirrors original native metadata text `r225CaptureTime` and `r225Address` (including asynchronous resolution).
- `CheckBox 기본 표시` persists original `GALLERY_INFO_PREFS / show_on_open`. Checked => pinned panel/auto-open on future Gallery; unchecked => pressing bottom third button again hides top panel. This deliberate pinned behavior matches user request.
- All original R455 Gallery/video/filmstrip/audio control heights and positions unchanged; footer remains 50dp. Reopening native Gallery from various MOA entry points uses this common implementation; **separate legacy/external image viewers are not automatically proven**.

## Exact build and QA
- Android SDK35 javac + D8 CI [run 43370601796](https://github.com/yooogillycloud123/family-journey-personal/actions/runs/43370601796): **SUCCESS**, new `classes17.dex` 58,328 bytes SHA256 `ee7492ca9fde45f66238370cc15689b4e72f48c780da9971bc2d44d95dc41125`.
- Signed candidate **`MOA_R459_BOTTOM_GALLERY_INFO_BUTTON_SIGNED_BETA.apk`**, versionCode459, size **8,971,234 bytes**, SHA256 **`cbdb253a2f2e73439b26d0b1d292d59ba0bcdbc2292fbafa8edb7739e77b6a7b`**.
- Emergency exact R455 functional forward restore **`MOA_R461_EXACT_R455_FUNCTIONAL_FORWARD_RECOVERY.apk`**, versionCode461, size **8,970,800 bytes**, SHA256 **`a80cef29f396cf0283a82a68b61b4f186358a4f678c661a34f2ae5b62679a5c9`**. This returns original R455 two-button footer with upper folded-map icon, so use only for serious R459 failure. After R461 is installed, future APK versionCode **>461**.
- Same original signer cert SHA256 `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`. Independent APK v2 RSA signature **plus full signed-content SHA256 digest** PASS, ZIP CRC and alignment PASS, **all 17 DEX SHA1/Adler32** PASS.
- Exactly **138/140** R455 original ZIP payloads byte-identical in R459 (only Manifest version + `classes17.dex` changed). Exactly **139/140** R455 payloads identical in R461 (Manifest version only). Protected native advanced Gallery `classes6.dex`, first-party NAVER writer JS `assets/web/fj-naver-favorites.js`, original R389 pink Home JS, all other native/media assets identical.
- Release ZIP **`MOA_R459_GALLERY_BOTTOM_INFO_R461_R455_RECOVERY_QA.zip`** size12,979,313 bytes SHA256 **`c3567db8c777d8aa0b4913f42c82e7ffd59645de40dbb8e49e7cec33672e3457`**. Contains two original-signer APKs, Java source, diff, JSON QA, README, new-chat prompt and checksums. **No key, password, family photo/video, cookies or GPS**.
- PRIVATE Library: `/모아_프로젝트_근거_20261103/R459_BOTTOM_GALLERY_INFO_BUTTON_20261113/`, includes exact APKs, source, QA, ZIP, and original private user screenshot.

## Test truth / next turn
- R455 top map glyph proportion and existing video/Share/Map user screenshot: **previous user reports working**. R459 novel three-button footer / pinned checkbox: **compiled/signed and static PASS, Galaxy physical NOT TESTED**. Do not call R459 final Golden or real-world PASS yet.
- In-place same signer install over current <459. **NEVER uninstall, reset app data/cache, NAVER login cookies**, or touch AirPods/Android Auto.
- Test: original upper folded map gone; footer three icon-only controls in order; bottom third toggles original top card in exact same location while `기본 표시` is OFF; when ON pinned and auto-displayed after new Gallery open; original NAVER pin navigation still only second; Share Android chooser retains same photo/video; video play/pause/mute/capture/audio/filmstrip and first-party NAVER nonoccupying account writes unchanged.
- On serious regression use only R461 emergency restore. For the next normal modification, branch from R459 source and package, use original signer and versionCode >461 if R461 may have been installed; include separate exact R459 functional high-version recovery. Maintain R435 immutable integrated Golden.
