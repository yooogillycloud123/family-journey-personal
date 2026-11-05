# MOA R96 — top/bottom only + draggable, lockable floating navigator

Date: 2026-11-05
**STATUS: SIGNED BETA, STATIC/JS MOCK PASS; GALAXY DEVICE NOT VERIFIED; CHATGPT DOWNLOAD STILL UNVERIFIED.**

## User's exact change to R94
User: "그냥 상하당 이동만 가능하면되고 위치이동이랑 고정등 기능을 추가해줘".
Remove the R94 `≡` contextual section picker completely. Keep **↑ 맨 위 / ↓ 맨 아래**, enable moving the small floating rail around the display and lock/fix its position.

## Implemented actual R96 behavior
- User taps ↑ or ↓: instant `S.root.scrollTop=0` or maximum scroll.
- Small center **🔒**: rail locked, tap to unlock.
- When unlocked, center changes to **⠿**, touch and drag center horizontally/vertically; movement is bounded away from status/header and bottom tabs.
- Tap center again to **🔒 pin**; locked rail cannot be moved accidentally.
- Lock state and normalized `x/y` position persist via same-origin localStorage key `moa.r96.diary-nav-position.v1`; responsive resizing clamps it to available display region.
- Rail hides while editing an input field, when diary closed, or when no scrolling is available; foreground diary/navigation unaffected.
- Android pointer capture, touch-action:none on move grip, drag-click suppression, and timeout reset of suppressed click.
- No section jump menu, no extra app, no database/data change, no Naver R91 work.

## Exact source and artifacts already complete
- Current APK accessible in original working container: `/mnt/data/MOA_R96_Install.apk`; private persistent Library `/모아_프로젝트_근거_20261103/MOA_R96_DRAGGABLE_PIN_TOP_BOTTOM_BETA_Install.apk`.
- Exact package `com.juhyeon.familyjournea`; versionCode **96**, versionName `MOA-R96-Safe-Capture`.
- APK size **3,498,902 bytes**.
- APK SHA256 **`d90a6ccd70a24ad261a54788a8a795c881fd429a37dcf71b6d9d25970a5f1eaf`**.
- Same original signing cert SHA256 `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`.
- R89 immutable user-Golden SHA256 `2b52826fc0dd8653a70d3c503d3654ae33071bfc4ec075753ec4464a1e2dc493`.
- Signed R94 SHA256 `0bf0dd26f3c455e9ad4cf5305399bb4c0695d117612f2d388260a3de21bad699`.
- R96 JS SHA256 `5cce7612eb0e959293be88daf80a96fbd7220036d4bb938cba3f20167d0fc569`.
- R96 classes4.dex is **byte-identical to R94/R92** SHA256 `a975be1c091441a9f1111bc6d5d8ed09a0fc1143cb7187ee35466ab8984ce5f5`, so R92 native Samsung auto-keyboard behavior and R89 Mic/Clear/Save remain untouched.
- Compared 55 decompressed APK members: **R94 → R96 changes only manifest version and `assets/web/family-diary.js`** (53/55 identical). **R89 → R96 exactly three changed** (version manifest, previous R92 native IME DEX, diary UI JS), 52/55 identical. Original IndexedDB commit HTML, images/maps, other DEX, CSS, app shell unchanged.
- APK v2 RSA signed data + content digest + certificate verification PASS, ZIP CRC PASS, stored ZIP 4-byte alignment PASS; Node `--check` PASS.
- JS mock PASS: top/bottom, no section menu, unlock/drag/pin, lock prevents accidental movement, position+lock persist on reinitialize, device rotation/resize clamps, keyboard edit hide, close hide.
- **NO REAL GALAXY PASS claimed.** Need user test. **No actual ChatGPT Android recipient-download verification**; past repeated `Library file not found` remains a delivery risk. See `MOA_RELEASE_DOWNLOAD_LINK_RELIABILITY_CRITICAL_RULE_20261105.md`; do not claim fixed.

## Exact reproducibility material
In same private Library folder:
- `MOA_R96_DRAG_PIN_PATCH_SOURCE.py` (exact hash-pinned R94→R96 JS source diff, no signing secrets)
- `MOA_R96_NAV_BEHAVIOR_MOCK_TEST.cjs`
- `MOA_R96_DIARY_ASSET.js` (result JS)
- `MOA_R96_VERIFICATION.json` (full APK/signing checks)
- Signed `MOA_R96_DRAGGABLE_PIN_TOP_BOTTOM_BETA_Install.apk`.
The signed APK is the source of truth; GitHub source branch `feature/moa-r96-draggable-pinned-top-bottom-20261105` derives from R94, which derives from R89 Golden. Android local signer never enters GitHub.

## Next
1. User installs over current app (no uninstall/data wipe) and verifies top/bottom jump, drag and lock persistence, original diary records and native quick memo.
2. Do not merge R91 NAVER; it was explicitly parked.
3. Preserve R89 user-Golden. If R95 emergency was installed, R96 is still a valid upgrade. If future release, versionCode must be greater than installed R96.

**Do not make the user repeat what they already requested.**
