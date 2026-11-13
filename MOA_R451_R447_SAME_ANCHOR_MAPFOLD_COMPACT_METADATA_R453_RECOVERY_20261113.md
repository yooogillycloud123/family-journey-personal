# MOA R451 — Same-anchor folded-map metadata control, compact capture time/address/checkbox; R453 exact R447 recovery (2026-11-13)

## User requirements and grounded private evidence

- Actual current user-installed R447 screen shows a top center `정보 ⌃/⌄` capsule and when expanded a **separate, wide black panel BELOW it** containing original capture time, address, redundant upper NAVER pin and `기본 표시` checkbox. User provided 20938, 20940, 20942, 20944, 20946 screenshots (PRIVATE Library only).
- User wants **NO "정보" text**, only a very small **folded paper-map silhouette** resembling the uploaded map icon when collapsed.
- Clicking the same top-center button should expand **AT THAT EXACT EXISTING POSITION**, replacing the icon with a compact (not separate lower card) panel containing only **actual capture time, actual address, and a checkbox to default-show**. Clicking that panel again folds it IN PLACE.
- If unchecked, user can manually collapse, and subsequent native gallery opens start folded; if checked, subsequent opens start expanded. Checkbox selection should not unexpectedly collapse the current panel.
- Remove the duplicate upper NAVER navigation pin/button because a separate, tested NAVER Map icon already exists in the gallery bottom Share/Map bar.
- Keep font/card responsive; 322dp maximum width (host screen width minus 24dp), compact text 11.3sp/10.5sp with modest scaling on narrow screens, address max 2 lines. Small overlap over videos is acceptable; never relocate original video/filmstrip/media controls or shrink photo/video stage.
- User-provided images contain personal family content and must not be pushed to GitHub. They are stored only in PRIVATE Library `/모아_프로젝트_근거_20261103/R451_MAP_FOLD_INFO_20261113/`.

## Exact technical implementation

- Baseline: latest user-confirmed in-device R447 versionCode 447 signed APK SHA256 `27ddce6749c68c6f81b87bb3e03f6da63c0b8d72a01f3e9916ae04473d96a3f2`. Immutable primary integrated user GOLDEN remains **R435**, original SHA `e36e55b823d9d8aa1650c05fb8314b5773df7b00287dab2e102440eea51f910c`; no changes to frozen Golden source or binary.
- Branch: `feature/moa-r451-gallery-mapfold-info-anchor-20261113`, source `experiments/moa-r391/MoaR391SessionPersistProvider.java`. Based only on R447 feature branch. Bounded additional changes to supplemental provider `classes17.dex`; do not patch original `classes6.dex` native Gallery or app JS.
- R447 original `r225Info` remains alive, and original native `r225CaptureTime`/`r225Address` still update from existing per-media async metadata code. R451 mirrors original text via guarded reflection into compact card every ~400ms while expanded. No duplicated GPS/date parsing, no user data copy or network actions.
- Native new `GalleryFoldMapGlyph` Canvas View draws 3 folded map segments (custom app-native artwork, no external icon asset dependencies) in a single 42×36dp top-center control at the **same R447 status-bar-inset-safe Y coordinate**. No label/text.
- Tapping that SAME parent FrameLayout switches its children: folded icon `GONE`, compact card `VISIBLE`; changes parent width 42dp → min(hostWidth-24dp,322dp), height 36dp → WRAP_CONTENT. Top/center anchor remains identical. The card itself is clickable to fold, except `CheckBox` touches are handled by the checkbox.
- Expanded compact 3-row card displays actual captured time, actual address (max 2 lines, ellipsize if long), checkbox `기본 표시`. No upper GPS/Map button. Background 0xcc1b1d22 and narrow padding, rounded radius13dp.
- The source `r225Info` remains `GONE` while Gallery is live (so the original huge lower card cannot reappear). Its metadata TextView and original pin state are still live; bottom GPS button continues to inspect original `r225Naver` visibility and call original `r225OpenNaver()`.
- Persistent preference key **unchanged** from R443/R447: `moa_r443_gallery_top_info_v1/show_on_open`. On gallery attach: auto false default folded, auto true expanded; the checkbox sets future-open default without collapsing immediately.
- Gallery teardown restores untouched original info panel for original lifecycle. R447 gallery video and bottom 50dp icon-only Share/Map deck, Share chooser return retention, horizontal GalleryRail, playback/mute/snapshot/volume, account-save JS, NAVER cookies, draggable pink Home and theme splash unchanged.
- No new permissions/app package, no DEX changes other than original supplemental `classes17.dex`.

## Exact signed static deliverables and validation

- GitHub Android SDK35 javac + D8 [run 43366929914](https://github.com/yooogillycloud123/family-journey-personal/actions/runs/43366929914) **SUCCESS**; new `classes17.dex` 57,852B SHA256 **`549b59a3e3b8c407c12a295d7c35cd6e4c3b5df92e1542d72d286acc6dd22f7b`**.
- Original signer cert SHA256 `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`.
- **R451 signed candidate:** `MOA_R451_R447_COMPACT_MAPFOLD_INFO_SIGNED_BETA.apk`, versionCode451, 8,970,759B, SHA256 **`df04e9207afbb5c3d43763a4d1186846b10113e2cc14e888110714b38e8c7e77`**.
- Exact R447 140 archive member payloads, only `AndroidManifest.xml` version code and `classes17.dex` changed: **138/140 original content payloads byte-identical**; original 16 DEX incl advanced native `classes6.dex`, original `fj-naver-favorites.js` and `moa-r389-home-dot.js` unchanged.
- **R453 emergency exact R447 functional forward restore:** `MOA_R453_EXACT_R447_FUNCTIONS_FORWARD_RECOVERY.apk`, versionCode453, 8,968,411B SHA256 **`d59a535319303db72ee2c65a627158e083b15605189441244fe6e0cef12a1929`**. **139/140 R447 member contents original**, only Manifest version changed. Use ONLY after serious regression with R451. After R453 install, next app versionCode must exceed 453. R453 restores R447 user-approved functionality, NOT R451 map-fold UI.
- Both APKs independently verified original cert APK Signature Scheme v2 RSA signature and **full signed-content chunked SHA256 digest** PASS, ZIP CRC/STORED alignment, 17 DEX SHA1/Adler32 PASS. R451 source contract checks same-anchor, original time/address mirror, checkbox persistence and no upper map button.
- Full release `MOA_R451_COMPACT_MAPFOLD_R453_R447_RECOVERY_QA.zip` 12,979,139B SHA256 **`90fa5c0a8d6b656dea27d62d96722af00b5b5fdf43ce350e2aaa9e8781c5f420`**, contains R451/R453 signed APKs, safe Java source/diff/source patch generator, QA JSON, README, SHA256SUMS. **NO private signing key/password/keystore/cookies/family media**.
- PRIVATE Library `/모아_프로젝트_근거_20261103/R451_MAP_FOLD_INFO_20261113/` stores full ZIP, two APKs, Java source/diff, QA and the 5 user screenshots.

## Physical status / next work

- **R451 Android compiler and crypto/ZIP/DEX/static preservation: PASS.**
- **R451 real Samsung Galaxy visual/tap/card content, location mapping and video/gallery regressions: NOT DEVICE TESTED.** Do not claim complete success before user result.
- Update in-place from matching original signer installed code<=450. Never uninstall, clear app data/cache or NAVER cookies.
- Check folded 3-panel map icon at same top center; tap opens compact card with current selected photo/video capture time/address/checkbox **at same anchor**, not separate lower panel. Tap card folds it. Checkbox checked/unchecked persists across Gallery reopen.
- Check original bottom Share/Map still works, no duplicate map button above, video play/mute/capture/volume/horizontal rail untouched, Share chooser returning to same Gallery, NAVER offscreen favorite and pink Home drag persist.
- If serious regression only, use R453 in-place to recover exact R447 function set. User-approved primary Golden R435 remains immutable and separate. No AA AirPods/Android Auto changes.
