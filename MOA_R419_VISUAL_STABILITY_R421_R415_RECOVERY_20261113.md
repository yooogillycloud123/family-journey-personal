# MOA R419 visual stability beta / R421 R415 recovery — 2026-11-13

R415 is the preserved user-confirmed gallery and NAVER offscreen Golden. Its original signed APK SHA-256 is `448d6f98548023f7d7a82ae1bcb0124d456873c739f72795f245579b805cb487`.

R419 modifies only `AndroidManifest.xml` (versionCode 419) and `classes17.dex` compared with R415. All other 138 out of 140 archive entry contents are identical, including `classes6.dex` advanced Gallery and the original NAVER JS.

Changes: align the native launch-cover logo to the real HTML splash geometry, use top-coverage app-panel flags, draw frozen diary screenshot at original screen pixel coordinates without resizing, and defer cold-launch cover release until the original HTML splash has been dismissed (bounded timeout). Preserve the working browser stop/start/460ms/hide, gallery owner repair, and NAVER session rearm.

R419 `MOA_R419_R415_VISUAL_STABILITY_BETA.apk`: SHA-256 `c1527c5bf466fef6435cf32ebf5c87ff2963be00d196cafa2c5c392829bdc2f8`. Compile CI [43252743534](https://github.com/yooogillycloud123/family-journey-personal/actions/runs/43252743534) succeeded. ZIP/DEX alignment and APK signature/content verification passed. Galaxy visual and live account-save tests are pending.

R421 `MOA_R421_EXACT_R415_GOLDEN_FORWARD_RECOVERY.apk`: SHA-256 `4d72a9efb3db06e21295b7a810536632544bcf212d786b9c4ab648b8b3857558`; versionCode 421; 139/140 entry payloads identical to original R415; only Manifest version changed. This is for serious R419 regression only. R417 is an older R411 recovery and does not preserve R415 gallery repair.

Bundle `MOA_R419_VISUAL_STABILITY_R421_EXACT_R415_RECOVERY_QA.zip` SHA-256 `efab1b7a440f127e747b47dd81ed153bc0361ed6933a288125a840eaeb9fcfd1`, preserved in private Library `/모아_프로젝트_근거_20261103/R419_VISUAL_STABILITY_20261113/`. Original R415 Golden separately preserved. No uninstall or app data wipe. Future versions after R421 must exceed code421.

Source branch: `feature/moa-r419-visual-stability-20261113`.
