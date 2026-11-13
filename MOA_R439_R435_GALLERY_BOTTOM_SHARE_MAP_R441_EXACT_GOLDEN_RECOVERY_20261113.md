# MOA R439 — R435 Gold-protected Samsung-style Gallery bottom action deck (2026-11-13)

## User request and grounded private evidence
- User supplied a screenshot `1794537473936.png` and three videos `20887.mp4`, `20888.mp4`, `20889.mp4`.
- Samsung Gallery reference: the horizontal media thumbnail strip stays immediately ABOVE a separate bottom pill containing actions (favorite/edit/enhance/share/delete in the reference). The videos show mixed photo/video media navigation, thumbnail rail and small media overlay.
- Actual MOA R435 video `20889.mp4`: native gallery has capture-time/GPS info at top, photo/video stage, video play/mute/still controls and existing swipeable media filmstrip at the bottom, **but no independent lower action row**.
- New user request: first introduce **Share** and **Naver Maps/GPS** at Samsung-like lower position; more actions later. Crucial: never let new bottom row displace/overlap independently with R227/R415 native video media timeline, horizontal rail, frame capture, mute, volume or native Gallery Back semantics.
- All user media and reference images remain PRIVATE in Library `/모아_프로젝트_근거_20261103/R439_GALLERY_BOTTOM_ACTIONS_20261113/`, NOT uploaded to GitHub/public release bundle.

## Exact immutable Golden source and scope
- Gold remains **R435**, chosen by user. `MOA_R435_USER_APPROVED_GOLDEN_20261113`, original signed v435 SHA256 `e36e55b823d9d8aa1650c05fb8314b5773df7b00287dab2e102440eea51f910c`.
- Frozen branch: `golden/moa-r435-user-approved-20261113` UNMODIFIED; all private Gold APK/source/archive remain in separate Library `GOLDEN_R435_USER_APPROVED_20261113/`.
- New isolated development branch: `feature/moa-r439-gallery-bottom-actions-20261113`.
- Modified source only: `experiments/moa-r391/MoaR391SessionPersistProvider.java` compiled into supplementary `classes17.dex`. No replacement or recompilation of R435 original `classes6.dex` and no NAVER JS or media database changes.
- R435 high-fidelity native Gallery class `MoaNativeGallery` in `classes6.dex` already exposes the **tested private** `shareOriginal()` and `r225OpenNaver()` methods. The activity super class `MoaMomentAudioHostActivity` retains `unifiedGallery` object; the original gallery owns `host`, `lowerControls`, `r225Naver`, `chromeVisible`, `anchorVolumeBubble`. These exact method/field names were found in the R435 original DEX and historical native source. R439 uses guarded Reflection to call them; no duplicated media URI/GPS extraction.

## R439 implementation
- Supplemental provider watches actual native gallery mounting via existing global layout listener and ~400ms Activity monitor. It ONLY attaches to `MoaNativeGallery` when `open=true`, `host` and `lowerControls` exist, both attached to the live original host activity, and the lower controls parent is correct.
- Single separately identified overlay `moa.gallery.action.deck.r439` at bottom (72dp reserved vertical region, original lowerControls whole block bottomMargin increased by that exact amount). This moves the **entire unchanged original thumbnail/video control block upward** rather than individually relocating video buttons/rail. Media stage's bounds, TextureView, MediaPlayer, original GalleryRail class, native volume/seek/capture controls remain untouched.
- Native dark charcoal rounded floating bottom pill with real actions `공유` / `지도`; touch hit region and accessible content labels. Icon strokes via native Canvas (no Samsung proprietary code or image assets).
- **Share:** invokes R435 original private `shareOriginal()`, preserving photo/video MediaStore selection and Android share chooser with read-grant.
- **Map:** checks original `r225Naver` GPS pin visibility and enables only when first-party metadata recognized valid GPS; invokes original private `r225OpenNaver()`, preserving original direct Naver Maps URI, fallback and R227 gallery/video return state. Button dimmed when no GPS.
- Bar follows existing `chromeVisible` and `lowerControls` visibility; hides when original gallery is in full-immersive mode. On gallery close/recreation it removes its overlay and restores original lowerControls bottomMargin (if still attached). Calls original `anchorVolumeBubble` once after moving lower block.
- **Future extension contract:** add buttons solely in Gallery action deck's action construction, never alter original GalleryRail or place buttons inside original video controls; no inert placeholders.
- No new permissions, extra APK, root/Shizuku, cookie access, NAVER account automation. Existing R435 startup covered NAVER WebView, one-shot rearm, keepalive, chevron/home drag/persist, R423 theme, high-fidelity Gallery intact.

## Real build/cryptographic static evidence
- GitHub Actions Android SDK35 javac/D8 [run 43355039629](https://github.com/yooogillycloud123/family-journey-personal/actions/runs/43355039629) **SUCCESS**.
- New `classes17.dex` SHA256 **`9bd3edfde9fd4baaca2f9026569f06e80ee8eef38c8dd19105ec34d14dd360aa`**, 50,736 bytes, compiled from branch source.
- Original signer certificate SHA256 `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`.
- **R439** `MOA_R439_R435_GALLERY_BOTTOM_SHARE_MAP_SIGNED_BETA.apk`, versionCode **439**, 8,963,643B, SHA256 **`1043d8333e1a2a49e5ce14b6d9b74050afc68fb15da285a6eb2e9d940a5b4b4b`**.
- Exactly **138/140** original R435 archive member contents identical; only `AndroidManifest.xml` versionCode and `classes17.dex` changed. Original `classes6.dex` Gallery SHA256 `cf93d66d08f1700b95949760093bd50689fa8b45e7cbe4a42b962b2afbb6f61b`, `assets/web/fj-naver-favorites.js` SHA256 `ee9d62ace062c38876105eec2f2a974cae243e15851dc6897197577a924d924b`, original 16 DEX and all first-party assets remain byte-identical.
- **R441 EXACT R435 functionality forward recovery** `MOA_R441_EXACT_R435_GOLDEN_FORWARD_RECOVERY.apk`, versionCode **441**, 8,954,927B, SHA256 **`404cf409b39b0b30a7f74b90d2194421a09676ac66fdee6f46bd00a7a5f49e4f`**. Exactly 139/140 original R435 contents identical (only Manifest code advanced); restores *R435 Home drag and Gallery*, unlike older R437 which only recovers R431. Use R441 **ONLY for serious R439 regression**; after R441 future code must exceed 441.
- APK v2 RSA PKCS#1 v1.5 SHA256 signature plus complete APK-v2 chunked signed-content SHA256 digest VERIFIED against original cert for baseline R435, R439, and R441. ZIP CRC, 17 DEX/entry counts and STORED alignment checks PASS. Static source contract confirms only gallery action attach, original original-method calls, no lower media child relocation. This is **STATIC VERIFICATION**, not actual Samsung Galaxy behavior.
- Full release `MOA_R439_GALLERY_BOTTOM_ACTIONS_R441_R435_RECOVERY_QA.zip` SHA256 **`94baf0b6ffed7b0774639f0a81fbf016a001d882f5ae27c43b4f137274088fca`**, 12,963,685B, contains both signed APKs, limited Java source and diff, README, QA JSON, SHA256SUMS, **NO private signing keys/passwords/cookies/user images/videos or GPS**.
- Private Library: `/모아_프로젝트_근거_20261103/R439_GALLERY_BOTTOM_ACTIONS_20261113/` contains both APKs, QA ZIP, source/diff, README, and private reference videos/image.

## Device test gates — not yet physically verified
1. In-place update over original signer installed code <=438; NEVER uninstall or wipe data/cache/NAVER cookies.
2. Open R435 advanced native Gallery from diary, confirm filmstrip now sits ABOVE separate Share/Map row without overlap/cutoff during swipe; in immersive viewer, controls can still hide.
3. Photo **and video** share opens Android chooser and references the selected original media.
4. GPS-positive photo Map opens Naver Maps then returns to same Gallery media/index without losing playback state; GPS-negative item Map disabled.
5. Re-test video auto/mute/frame capture/volume scrub/horizontal filmstrip and Gallery Back.
6. Check R435 startup NAVER automatic hidden prewarm, first-party account favorite write, manual stop->offscreen auto rearm, foldable chevron and draggable/position-persistent pink Home.
7. If any serious regression use **R441** in-place; never R437 for R435 Golden recovery. Future builds after R441 >441.

**CURRENT TRUTH:** R435 remains USER GOLDEN. R439 is SIGNED STATIC PASS BETA; user physical device Gallery/NAVER results NOT YET VERIFIED. No AirPods/Android Auto changes.
