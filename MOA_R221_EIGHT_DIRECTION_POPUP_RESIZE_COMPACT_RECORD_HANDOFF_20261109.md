# MOA R221 — Eight-direction independent floating Quick Record resizing, compact record glyph (2026-11-09)

## State and user evidence

**SIGNED ORIGINAL-CERT APK + MATCHING ZIP CREATED AND VERIFIED. Android 35 native CI and geometry contracts PASS; Galaxy on-device R221 touch UX NOT TESTED; R221 is BETA, NOT GOLDEN.**

User's `19865.png` Samsung Camera screenshot of installed R219 showed that the Quick Record overlay had an enormous red Record pill, an unnatural X ratio, an imposed minimum size and only a bottom-right diagonal handle. User specifically asked for 4 edges + 4 corners, independent width/height resizing, dynamically proportioned controls and a smaller default, and for accepted portions of R219 to be added to Golden.

## User-approved R219 frozen separately

- Signed original R219 APK `com.juhyeon.familyjournea`, versionCode **219**, **5,751,199B**, SHA256 **`d45d976a8c08a011a5e8cc5590a3634d37d6369d7f364e46dea6e93f91c338c1`**.
- User-scoped Golden binary `/모아_프로젝트_근거_20261103/GOLDEN_R219_20261109/MOA_R219_SIGNED_USER_ACCEPTED_SCOPE_FREEZE.apk` with all **130 entries** SHA-256/CRC in adjacent `MOA_R219_USER_SCOPED_GOLDEN_FREEZE_20261109.json`. Frozen source-only GitHub branch `golden/moa-r219-20261109-user-accepted-except-popup-resize`.
- **Important:** R219 popup resize/visual geometry expressly FAILED user acceptance; the R219 archive is scoped to existing verified functionality and as an exact baseline, not a claim that this bug passed. R209/R203/R187 old Goldens remain frozen.
- [R219 freeze manifest](MOA_R219_USER_SCOPED_GOLDEN_LOCK_AND_R221_POPUP_FIX_20261109.md).

## R221 exact installables

- Original-signer package `com.juhyeon.familyjournea`, versionCode **221**, original cert SHA256 **`5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`**.
- Direct APK **`MOA_R221_ALL_EDGES_DYNAMIC_QUICKRECORD_BETA.apk`**, **5,753,163 bytes**, SHA256 **`f46f77fb1a749676f99e7b519ba6309907e63522198d390fcc54b3f362a414b5`**.
- Paired ZIP **`MOA_R221_ALL_EDGES_DYNAMIC_QUICKRECORD_BACKUP.zip`**, **5,411,257 bytes**, SHA256 **`6d08b24dcd3bde778ce9eceda2b7658151d13bf78a2184d317600eb9b6f4b5cf`**, containing **byte-identical APK**, `MOA_R221_RELEASE_QA_20261109.json`, `README_INSTALL_R221.txt`, SHA256SUMS. ZIP CRC PASS; inner APK hash equals direct APK.
- APK-v2 RSA PKCS#1 SHA256 signature independently verified against original signer certificate, including entire signed APK content digest. DEX header SHA1+Adler32, ZIP130 CRC and stored alignment PASS.
- Private Library `/모아_프로젝트_근거_20261103/` has both direct APK + ZIP + QA/README; no secret signer or private photos included.
- Compared to exact original signed R219: **127 of 130 APK entry contents byte-identical**. Exactly THREE changed: `AndroidManifest.xml` versionCode219→221, `classes8.dex` native popup helper, `assets/web/moa-r121-ui.js` user settings live preview. `classes6.dex` Gallery + native audio stop, `classes7.dex` recorder Activity, `classes9.dex` memo styling, all other JS/Diary/Map/voice content byte-identical.

## R221 repair details

1. **Removed harmful fixed minima:** old `width=Math.max(dp(178),width)`, `primaryW=Math.max(dp(111),...)`, and one scalar `sizePct` applied to both dimensions during grip drag caused awkward huge content. New minimum total width **120dp**, minimum height **44dp** to preserve 44dp X hit, maximum only within safe display bounds, and normal default approximately 150dp width (85% setting; previous stored 70% also respected).
2. **All 8 edit handles:** middle of LEFT, RIGHT, TOP, BOTTOM + top-left, top-right, bottom-left, bottom-right. Edge bitmask `1,2,4,8,5,6,9,10` updates width and/or height **independently**, maintains opposite edge, clamps safe status/navigation insets, never stretches whole window diagonally for a single-direction drag. Root/Record/X center drag remains the existing position move. User long-press enters edit; edit suspends auto-hide; small cross changes into check mark for exit; edit exit saves and restarts timer.
3. **Independent saved size and position:** separate `panel_width_portrait/height_portrait` and corresponding landscape keys (in dp), plus existing normalized relative `position_*_x/_y`; migrate old `sizePct` only when no independent dimensions exist. User settings `sizePct` re-scales both (clears custom dimension overrides), resetSize clears both orientation sizes, and live settings preview reflects separately saved width and height.
4. **Dynamic record and X proportion:** right X hit remains at least **44dp**, with 7:3-ish overall area ratio where physical width permits. The wide Record *hit target* is NOT a giant red background: now only a small centered red circle with a tiny white inner dot, size responsive to both panel width and height and bounded to prevent grotesque growth. Optional '기록' text only when it fits; when narrow, never reserve an oversized red region for it. X symbol is small white strokes without a circular badge. Divider/padding and border scale subtly and remain visible.
5. **Settings preview parity:** tiny red dot instead of red pill, 8-direction guidance, live reset of `hasCustomDimensions` on changing default size, opacity unchanged.
6. **Record and close semantics untouched:** original `PendingIntent.send()` on Record, notification cancellation on X, original camera observer, photo tagging, album/diary/voice, Map native Gallery, video vertical mute slider and R215 upper one-step/lower inertial rail unchanged. No new Activity, service or overlay permission requested.

## Exact source and CI

- Feature branch: `feature/moa-r221-floating-resize-eight-directions-20261109` in `yooogillycloud123/family-journey-personal`.
- Native file `experiments/moa-r217/MoaR215QuickOverlay.java` and exact new web settings script `experiments/moa-r221/assets/web/moa-r121-ui.js`.
- Android 35 Java+DEX & 8-direction geometry/accessibility/save contracts GitHub Actions run **42564761925 SUCCESS**, artifact **13651276011**, compiled `classes8.dex` SHA256 **`daa730b8d2ee81d070d776736ae54cb755291979146195a7a03686a09c965618`**; native Java SHA256 **`bae4a233172a29d3c555f8ead455d3c2d8b28ad6e5f0ca6c2e5a3615715ad636`**, web JS SHA256 **`3f4ecbf8840e48acedeb659f9fd43f325e42a0a466596dc613eb3b8ca405268f`**. Local artifact hashes matched CI reports.

## Mandatory real Galaxy QA before promotion
1. In Samsung Camera record popup normal: tap red dot region→original memo record; tap X→dismiss; NO accidental record when resizing.
2. Long press → drag each of four edges separately: left/right changes width **only**, top/bottom changes height **only**; drag each of four corners changes both dimensions; opposite edge anchors correctly.
3. With '기록' text OFF and ON, rescale small, medium, large: circle/X/divider/spacing respond proportionally, no overflowing red pill; X remains touchable. Touch 7:3 distribution roughly at normal sizes.
4. Finish edit via X checkmark; rotate and capture; relaunch and capture, per-orientation width, height and position persistence works. Tap Settings size slider and individual/all reset; saved manual dimensions reset as expected.
5. System bars, gesture navigation, camera UI and auto-dismiss: no clipped overlay; timer paused while editing and restarted after.
6. Existing Gallery stage one-step + lower inertial rail, vertical media volume, diary voice stop, Map popup OFF native Gallery, M4A, memo recorder/save/backup regression tests.

**R221 device physical PASS is NOT established. Do not uninstall/clear app data, downgrade, rewrite golden binary, leak signer/user data or modify AA AirPods/Android Auto daemon/audio code. Future APK delivery must always pair a tested file path for APK with ZIP holding exact same APK bytes.**
