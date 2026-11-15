# MOA R604 source-only checkpoint — 2026-11-15

## User-device evidence
- User supplied 17.04s Galaxy screen recording `22340.mp4` plus exact original-signer R602 and R603 APK.
- R602 SHA256 `ed21bddc7710921b433e3d0b5f80d661d71d0e16ba3553c92691191faa1bf64f`, R603 SHA256 `c95535a197ecab0058159dd4a7576896db675e026a4e080a2c5cbe0d53e099c5`.
- Video shows initial photo/day Web viewer, then app restart and black/blank photo-day stages. Original R463/R567 native eight-action controls/inertial strip NOT confirmed. **Physical native PASS=FAIL**; exact failure reason is unverified without in-app stage diagnostics.

## Evidence-derived source defect
- R567 Golden `r507StartInline()` never calls `MoaLocalAudio.openNativeGallery` before `window.__moaR511NativeArmed===true`, waiting up to 8s.
- R602 introduced unarmed bypass after ~3.5s, based on provider BridgeReady (not proof that R463 pre-draw ownership or View attachment is ready). This can open without the verified lifecycle handshake; device causality not yet proven.
- R602 earlier source-confirmed `render() -> r507StopInline() -> closeNativeGallery()` same-day QuickRecord defect was already repaired. Preserve that fix.

## Source-only R604 change
- Separate feature branch based on R602; **do not overwrite R567 Golden or main**.
- `experiments/moa-r483/moa-r483-vertical-calendar.js`: restore R567 pre-draw arm as a required gate. At 8s timeout, record `NATIVE_ARM_TIMEOUT`, display non-destructive fallback, schedule existing bounded index retry; never force unarmed open.
- Missing DOM photo stage reports `NATIVE_STAGE_NOT_ATTACHED` rather than silently returning.
- R602 `r592RefreshVisibleDay` in-place playlist update, original Java `classes18.dex`, all native DEX1–17, Gallery actions, diary/camera/Naver/M4A, audio project unchanged.

## Verification
- Entire JS parser: Node `--check` PASS.
- Actual extracted R604 `r507StartInline` in isolated fake-timer VM: unarmed 0 native calls + explicit failure, armed 1 accepted native call, source-level same-day list update does not call full render/close: 3/3 PASS.
- R604 JS SHA256 `18f045f300e79371d61a215cb423903a4e3f44e471d68568cf920117be1ae8b2`; Git blob SHA1 `a7bb90ce659347511d2308e42f8b2d126cc65db1`, matches source branch.
- No Android SDK/D8 build or original private signing key accessible in this session. **NO SIGNED R604 APK, NO DEVICE PASS, NO GOLDEN SUCCESS CLAIM.** Patching R602 APK contents would invalidate its v2 signature.

## Next authoritative gate
- Without uninstalling or clearing data: on existing R602, open previously populated photo-day then immediately Settings > 원본 갤러리 진단 복사; collect stage (BRIDGE, ARM, OPEN, HOST, DECK, MOUNT). Distinguish Android opener reject vs failed attach rather than blind timing changes.
- Then produce signed >=604 original-identity package only in authorized signer environment, verify original R567 native-first controls/rail, QuickRecord same-day update no native close, video, M4A, Naver, and update-install. R603 is R600 functionality already failed; do not call it Golden.
