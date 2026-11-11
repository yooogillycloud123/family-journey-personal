# MOA R321 source freeze — R317 native WebView launch guard regression repair (2026-11-11)

**Signed R321 BETA; live Naver account write/readback and physical Galaxy installation remain unverified.**

## User physical evidence
User screenshot 20318.png from R317 Settings showed `PROBE_DISPOSED` after attempts to click `샘플 장소 웹 연결`. Previous R313 physical video established photo-GPS address PC-map search PASS but 16-second result false-failure, and manual address-header ☆ opens actual NAVER saved-list popup. Do not publish private image/video/address.

## Proven root cause
R317 `assets/web/moa-r231-naver-frame-probe.js` had **27,697 Java String characters (28,205 UTF8 bytes)**. Existing unchanged native class `MoaNaverWebProbeHost.start()` requires `javascript.length() <= 24000` and exact marker `__MOA_NAVER_WEB_PROBE_V1__`. The failed start leads to native `PROBE_DISPOSED` status. R313 previous script was ~21,042 chars and could launch. This is an APK code-size regression, not a NAVER login error.

Separate R317 error: `phoneStatus('SEARCHING')` was called but `SEARCHING` was missing in JS `statuses` Set, so status never crossed to native despite claims of repaired 16s logic. Native classes14 already has `SEARCHING` literal.

## Signed deliverable
- `MOA_R321_WEB_REOPEN_DYNAMIC_LIST_SAME_SIGNER_BETA.apk`
- package `com.juhyeon.familyjournea`, code **321**, size **8,906,599 bytes**, SHA256 `0b07028c1d4754422c9828a717dfc6f9142d7d5526f4c720b2966541c499745e`
- same original signer cert SHA256 `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`, APKv2 RSA/full digest PASS.
- R317→R321 exact 3 uncompressed ZIP payload changes: compiled `AndroidManifest.xml` 317→321, `assets/web/moa-r231-naver-frame-probe.js`, `assets/web/moa-r231-settings.js`. All **16 DEX identical**, all other members identical; 138 ZIP members, CRC and stored-alignment PASS.
- Conservative JS whitespace/comment compression only, retains behavior. R321 script **23,470 Java characters and 23,971 UTF8 bytes** (both below original native 24,000-char cap), marker preserved, `node --check` PASS.
- Added `SEARCHING` to permitted JS bridge statuses and real VM reports `QUEUED`→`SEARCHING` before navigating.
- Existing folder: pinned last explicitly selected first-party folder ID used by default; user can change with **MOA 저장 리스트 선택·변경** in visible PC map, and changed title is refreshed from live same-ID folder list. Never auto-select by folder name/count, never create/delete list. **In-diary native popup list switching is not implemented**; actual folder GET endpoint behavior unverified.
- Settings button `네이버 PC 지도 열기` remains wired to native `naverWebProbeControl('visible')`; clearer disposed/failed status and second delayed refresh.

## Recovery
`MOA_R323_RESTORE_R313_WEB_WORKING_SAME_SIGNER.apk`, code323, size 8,906,089, SHA256 `e9a4208ef7f26487503d30caac1995d1a6a1f0e3d64b1d035a43e1d9692ec922`. This restores **R313 function bytes**, with Manifest versionCode updated to 323, original cert; only install if R321 causes regression. This is NOT byte-original R269 Golden; Galaxy R323 recovery untested. No uninstall/data clear.

## QA package
`MOA_R321_R323_SIGNED_APK_SOURCE_QA_20261111.zip` SHA256 `e8f19dd7ed2f49699f788e4ea376f3f45d6fd201b75b54253a9defac77bcfdbb` (12,944,901 bytes, 19 exact verified ZIP members). Contains two APKs, human JS, compact JS, settings JS, source patch/build scripts, 63 passing VM/Node tests and QA/README/manifest. **No signer keys/passwords, user account data or family images in ZIP.** Private Library upload not yet verified; files are current-conversation downloads.

## Next gate
1. On Galaxy update installed code≤317 **in place** to R321; Settings → NAVER return → `네이버 PC 지도 열기`: should no longer end in `PROBE_DISPOSED` due to length guard.
2. If webpage visible, test explicit user-owned first-party list ID selection, then existing diary photo address-first one tap, folder/alias/memo readback.
3. Actual first-party NAVER folder GET schema, save selector, synthetic click acceptance, app-screen non-occupying and independent server readback all remain **UNTESTED**. Do not label final.
4. Preserve user-selected R269 Golden, R227, existing foreground NAVER save, photo/GPS/diary/audio/gallery, signer, package and app data. No hidden wipes or new helper apps.

This is a minimal scoped repair of the *actual* R317 launch regression. No speculative major native refactor.
