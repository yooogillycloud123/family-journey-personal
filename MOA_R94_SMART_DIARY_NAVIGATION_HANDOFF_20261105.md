> **URGENT DOWNLOAD CORRECTION (2026-11-05):** User screenshot 18860.png shows **"Library file not found"** for R94/R95 APK links. The earlier handoff's APK build/signature verification does NOT prove the user could open ChatGPT links. **R94 DOWNLOAD DELIVERY NOT CONFIRMED.** Do NOT claim download success. Read [MOA_RELEASE_DOWNLOAD_LINK_RELIABILITY_CRITICAL_RULE_20261105.md](MOA_RELEASE_DOWNLOAD_LINK_RELIABILITY_CRITICAL_RULE_20261105.md) first. Provide a separately reachable verified delivery route instead of repeating the same broken sandbox link. R89 Golden stays frozen; no feature regressions or data wipe.

# MOA R94 — Quick-jump diary navigator (2026-11-05)

## User request and attached screenshots
User screenshots `18850.png`, `18852.png`, `18854.png`, `18858.png` show the R92 selected-calendar, automatic-calendar, and very long selected-day photo/video timeline. User wants iPhone-like immediate top/bottom navigation without thousands of pixels of manual scrolling.

**R94 design:** unobtrusive tiny vertical right-edge overlay navigator (fixed, above bottom tabbar) inside the SAME MOA app: `↑` one tap to top, `↓` one tap to bottom, `≡` to display a context-sensitive jump menu. Middle indicator tracks the scroll position.

- In selected-photo calendar: jumps to existing month calendar, existing `촬영 즉시 기록` panel, existing PC import, existing create-new-diary panel. The R92 calendar-first order is NOT changed.
- In automatic photo calendar: calendar jump, plus top/bottom.
- In day view: jump to date summary, photo/video timeline, existing edit/create control (scroll to it; does NOT trigger a save/edit), day navigation buttons.
- In photo picker: jump to header, selection grid or sticky footer.
- Automatic hidden state when diary closed, page not scrollable, or user editing a focused text input. Keyboard/memo/save flow is untouched.
- `S.root = #fj-diary-root` is a FIXED **independently scrolling** element; therefore `window.scrollTo` is incorrect. All scroll calculations are on `S.root.scrollTop`, `S.root.scrollHeight` and actual `getBoundingClientRect` anchor positions. Overlay is appended to document.body so it is not destroyed by existing `S.root.replaceChildren()` on render.
- JS-only patch (style injected in JS, no CSS binary modification) hooks `mount()`, `render()`, `close()`; R89/R92 DB/save/photo/stt functions are unchanged.

## Immutable Golden / R92 baseline
- Frozen same-app R89 Golden APK `MOA_R89_USER_DEVICE_GOLDEN_20261104_DO_NOT_MODIFY.apk`, SHA256 `2b52826fc0dd8653a70d3c503d3654ae33071bfc4ec075753ec4464a1e2dc493`, signer cert `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`; package `com.juhyeon.familyjournea`.
- R92 beta APK `MOA_R92_CALENDAR_FIRST_AUTO_KEYBOARD_BETA_Install.apk` SHA256 `6ce4f8de6f924c66e771ca16c8f3be5af1e5795afce092e6c7a39e2d51c68982`. R92's native auto-IME and existing R89 voice/clear/save are kept.
- NAVER R91 explicitly remains ON HOLD. No Shizuku, root, ADB, extra app or photo/data reset. Do not touch AirPods branch.

## Exact R94 signed BETA artifacts / verification
- Main install `/모아_프로젝트_근거_20261103/MOA_R94_QUICK_JUMP_CALENDAR_AUTO_IME_BETA_Install.apk` (also current sandbox `/mnt/data/moa_r94/MOA_R94_QUICK_JUMP_CALENDAR_AUTO_IME_BETA_Install.apk`).
- R94 package `com.juhyeon.familyjournea`, versionCode **94**, versionName `MOA-R94-Safe-Capture`, byte size **3,498,328**, APK SHA256 **`0bf0dd26f3c455e9ad4cf5305399bb4c0695d117612f2d388260a3de21bad699`**.
- Signing certificate SHA256 **`5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`**; APK Signature Scheme v2 RSA3072 full signature + content digests PASS; archive CRC PASS; stored alignment PASS; JavaScript syntax via Node `--check` PASS.
- All 55 R89 archive entries examined: **exactly THREE changed from R89**: manifest versionCode/name, classes4.dex (R92's earlier auto-IME only), and `assets/web/family-diary.js` (R92 calendar-first plus R94 navigator). **52 of 55 members match R89 decompressed byte-for-byte**, including DB writer, other DEX, CSS, NAVER assets, maps, media UI, original photo indexing.
- R94 native classes4.dex is EXACT R92 byte-for-byte, SHA256 `a975be1c091441a9f1111bc6d5d8ed09a0fc1143cb7187ee35466ab8984ce5f5`.
- R94 new diary JS SHA256 **`c398c6fea60fe94c16c199b518cf7d71b7e68be97ace007fb8d5481b359f626f`**. Source starts from verified R92 diary JS SHA256 `427fd8c42b4d7d890d5e05051352e4e879bce1f06f9e7c19f70531c280cba837`.
- Native DEX R89 baseline reproducibility had previously passed GitHub Actions #41993970386. R94 requires no native compilation: only a JS change from R92.
- Isolated JS mock NAV tests **PASS**: up/down, menu section anchors, sticky overlay, visibility when scrolled, hiding on editing input or close. This is NOT a real device pass; actual Samsung Galaxy WebView UI remains **UNTESTED**, therefore label BETA.
- Private Library verification `MOA_R94_VERIFICATION.json`, reproducible *source patch* `MOA_R94_QUICK_JUMP_PATCH_SOURCE.py`, and Node mock `MOA_R94_NAVIGATION_MOCK_TEST.cjs` are in the same folder. No private key in these.
- Dev source branch `feature/moa-r94-diary-smart-elevator-20261105` is based on R92 branch, itself from immutable R89 source anchor. The **exact signed APK** is in private Library and is the installable truth, not a generic Gradle debug APK.

## Emergency R95 (do not install unless R94 breaks original UX)
- `/모아_프로젝트_근거_20261103/MOA_R95_RESTORE_R89_GOLDEN_ONLY_IF_NEEDED.apk`, same package/cert, versionCode **95**, exact byte size **3,491,373**, SHA256 **`695e71c4aa78caf5135e5ff5ebf615df3d286f4d799454a4e896abc97d07102a`**.
- This restores original R89 Golden contents, with **54/55 members identical to R89**, except version manifest for Android forward-upgrade over R94. Android app uninstall/clear data is never necessary.
- Only use if R94 is defective. Installing R95 means all future versions must be >=96.

## User-device acceptance pending
1. Open `일기` and switch to selected/automatic calendar. Check a small `↑ ≡ ↓` overlay floats to the right above bottom tabs and does not hide a date, and tapping ↓ jumps to original bottom controls, ↑ returns to top.
2. On selected calendar, ≡ offers month calendar, capture status, PC import, new diary. On long day view, ≡ offers timeline and edit-button scroll, without clicking edit automatically.
3. Verify native camera `바로 기록` auto-focus + keyboard R92 behavior, same Mic/Clear/Save, original R63 diary photo/memo timestamp, R83 voice, R89 saved data. NAVER untouched.
4. Confirm the overlay disappears on closing diary, switching to another app tab, or typing in a diary input.

Status: **BUILD/INTEGRITY/MOCK PASS; GALAXY LIVE UI PENDING. R89 Golden is not altered.**
