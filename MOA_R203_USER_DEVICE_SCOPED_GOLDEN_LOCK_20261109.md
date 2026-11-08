# MOA R203 — USER DEVICE SCOPED GOLDEN LOCK (2026-11-09)

## Decision / limit
The user explicitly confirmed that R203's inertia and general gallery behavior were satisfactory and asked it to be added to Golden. This is **a user-reported, scope-limited physical success**, not complete Samsung Gallery pixel parity, 120 Hz timing, all media/codec testing, or all-app full regression.

## Immutable exact binary
- Package: `com.juhyeon.familyjournea`; versionCode **203**.
- Exactly **5,709,983 bytes**; SHA-256 **`6d85add0d0d97b08e90cec1fc13923cfa49faea1af66907350eb1f54a2b2c6a7`**.
- Original update-compatible signer certificate SHA-256 **`5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`**.
- Frozen exact APK: PRIVATE Library `/모아_프로젝트_근거_20261103/GOLDEN_R203_20261109/MOA_R203_USER_DEVICE_SCOPED_GOLDEN_DO_NOT_MODIFY.apk`.
- Frozen **128-member** checksum manifest: PRIVATE Library `/모아_프로젝트_근거_20261103/GOLDEN_R203_20261109/MOA_R203_USER_SCOPED_GOLDEN_128_MEMBER_FREEZE_20261109.json`.
- Frozen **source-only** GitHub branch `golden/moa-r203-20261109-user-device-gallery-inertia-pass-do-not-modify` from exact R203 commit `592745659ebbd6e249c7c78cd7426529f90e978e`. Source is traceability, not a substitute for the signed original APK.

## Earlier Golden remains immutable
R187 versionCode187 SHA-256 `4380ca0a421c3a12cfad0334e860e659112b116f6cc7099f8989475c646a97e9` remains protected separately. Do not replace or delete R187 or R203.

## R203 scope and new work
R203 introduced native `VelocityTracker` + `OverScroller` kinetic multi-photo scrolling on stage and bottom rail, full center capsule hit testing, compact controls, and preserved earlier video seeking. User expressly praised R203's inertia but requested additional icon, pressed affordance, saved-frame popup, and vertical thumbnail wave parity. Implement these **only in separate feature branch / versionCode205**.

## Release rules
- Never alter the R203 Golden branch/APK in place.
- Never uninstall or clear `com.juhyeon.familyjournea` app data or replace the original signer; same-package update-install only.
- Keep private signer, family media and user diary off public GitHub.
- Keep AA AirPods/Android Auto routing code untouched.
- Future build is **beta** until actual Galaxy device feedback; failures must return to a known-good feature-set by a safe, higher-code signed update rather than uninstall/data wipe.
