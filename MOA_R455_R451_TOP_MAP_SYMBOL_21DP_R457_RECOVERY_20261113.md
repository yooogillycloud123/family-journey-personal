# MOA R455 — top folded-map glyph only ~20dp, exact R451 forward recovery R457 (2026-11-13)

## User device report / objective
- User R451 device screenshot `20964.png`: R451 same-anchor compact map-fold info works; its **top white three-fold-map graphic is disproportionately large** relative to the bottom Share icon. User requests **only shrink the TOP icon to the same apparent size as the lower Share**, leaving everything else as it currently works.
- Grounding: R451 `GalleryFoldMapGlyph.onDraw()` scaled to whole 42×36dp hitbox (`min(getWidth(),getHeight())/35`), with polygon shapes occupying ~28/35 of the width and height -> ~29dp apparent graphic. Bottom Gallery Share glyph drawn at ~21dp.
- Do not confuse **top decorative map-fold metadata toggle** with bottom action button **지도**; top remains a SAME-ANCHOR reveal of capture time/address/`기본 표시`, **not** an additional GPS navigation link.
- User screenshot containing family imagery remains strictly PRIVATE: `/모아_프로젝트_근거_20261103/R455_TOP_GLYPH_21DP_20261113/20964_PRIVATE_USER_GALAXY_ICON_SCALE_REFERENCE.png`, not on public GitHub.

## Baseline and only source delta
- Immutable primary user-approved **Golden R435**; keep frozen. User's latest successful same-anchor functionality is **R451** versionCode451 signed APK SHA256 `df04e9207afbb5c3d43763a4d1186846b10113e2cc14e888110714b38e8c7e77`, from `feature/moa-r451-gallery-mapfold-info-anchor-20261113`.
- New feature branch `feature/moa-r455-gallery-mapglyph-21dp-20261113` derived EXACTLY from R451 (no base downgrade).
- One-site Java source change only: `experiments/moa-r391/MoaR391SessionPersistProvider.java`, nested `GalleryFoldMapGlyph.onDraw()`. Old:
  `float scale=Math.min(getWidth(),getHeight())/35f;`
  New:
  `float maxGlyphPx=25f*getResources().getDisplayMetrics().density; float scale=Math.min(Math.min(getWidth(),getHeight()),maxGlyphPx)/35f;`
  Actual white map three-panel artwork spans 28/35×25dp = **~20dp**, visually similar to bottom 21dp share glyph. Original top container **42×36dp**, touch target, centered map geometry, black translucent background, actual top inset, SAME-ANCHOR expansion width/height and click listeners unchanged. This is an on-canvas DRAW scale clamp, not a resize of button or panel.
- **Absolutely unchanged:** expanded original capture time/true address/checkbox and persisted default, no duplicate top GPS pin; bottom Share/Map 50dp bar; R227 Sharesheet onPause retention; advanced native Gallery `classes6.dex`, native video play/seek/mute/capture/volume, horizontal swipe rail; NAVER login/cookies/offscreen PC Map save/one-shot rearm; home pink draggable button; original theme.
- No extra APK/package, permissions, remote services or data reset.

## Files, cryptographic verification and CI
- GitHub javac/D8 [Actions run 43368650927](https://github.com/yooogillycloud123/family-journey-personal/actions/runs/43368650927) **SUCCESS**; `classes17.dex` **57,892 bytes**, SHA256 **`b2ff6c8de2a3da8e1bfbe334983f3bd0344857f17e07f715f9296db709b927a4`**.
- Original signer certificate SHA256 `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`, v2 APK RSA signature and complete chunked content digest VERIFIED, ZIP CRC, all 17 DEX SHA1/Adler32 + STORED alignment PASS.
- **R455 installable in-place candidate** `MOA_R455_TOP_MAP_ICON_21DP_SIGNED_BETA.apk`, versionCode455, size8,970,799B, SHA256 **`9676fc801c67d547a972505f3353ac261f19d37e33d92851dda2df68f97ff166`**. Exactly **138/140 original R451 ZIP payloads byte-identical**; changed only `AndroidManifest.xml` versionCode and `classes17.dex`. Source diff one actual expression in Canvas glyph plus comments. Static validation PASS; actual Galaxy visual result **not yet tested**.
- **R457 emergency exact R451 functional forward restore** `MOA_R457_EXACT_R451_FUNCTIONS_FORWARD_RECOVERY.apk`, versionCode457, size8,970,753B, SHA256 **`34d2dbabd2e9b370d898bda7a12d5750ea0162fb878cc637e2fcc350b3531fb6`**; **139/140 original R451 members byte-identical**, only Manifest versionCode changed. Use for serious R455 regression, not ordinary updates. If installed R457, future versionCode must be **>457**. Unlike R453, preserves R451 same-anchor map-fold control.
- Full release ZIP `MOA_R455_TOP_GLYPH_R457_R451_RECOVERY_QA.zip`, size12,974,435B SHA256 **`029ae2114de5e5812d04ef8b112d9c9103ce1dd27f354b56d8a075b245e82c23`**. Includes both signed APKs, full Java, minimal diff, README, checksum, QA and new-chat prompt, **no private signing material, user photos/video, cookies, GPS**.
- PRIVATE Library `/모아_프로젝트_근거_20261103/R455_TOP_GLYPH_21DP_20261113/` contains signed APKs, QA ZIP, source, README, new-chat prompt, device screenshot.

## Device checks and status
- **R451** previous user reported top map symbol and expanded card functionality works, with only icon oversize.
- **R455** compile/signing/static checks PASS; **user physical installation and visual ~20dp confirmation PENDING**. Do not declare R455 Golden without user.
- In-place install over R451 or any matching-signature version <455; **do not uninstall/wipe cache/data/NAVER session**.
- Verify folded icon at same top center is similar size to bottom Share, it still responds over old 42×36dp target, opens existing metadata at SAME location, checkbox persists, and bottom actions/photo/video/rail function unchanged.
- Emergency R457 exact R451 functionality available. R435 immutable Gold preserved. **No AirPods/Android Auto modifications.**
