# R611→R650 MOA actual user feedback / release timeline index (2026-11-17)

**READ FIRST** on any new MOA Gallery/QuickRecord/photo-add work, after shared AA Canonical and MOA_READ_FIRST. This is an audit of actual user device results, not a release approval.

**Full 40-code-number report (155 lines, 32,942 bytes, SHA256 `c483d5303c8cac25499f245755f327d5e7ccbfbb7c5193ed66582d2b4d967d74`)** saved in PRIVATE Library:
`/모아_프로젝트_근거_20261103/HISTORY_R611_TO_R650_USER_FEEDBACK_20261117/MOA_R611_TO_R650_COMPLETE_EVIDENCE_TIMELINE_20261117.md`.

Scope: original R611 user-approved Golden (2026-11-15) through R650 functional-R648 forward recovery APK (2026-11-16). Covers all code numbers R611–R650, every confirmed release/restoration, user screenshot/video feedback and explicit unknowns. Version numbers with **no independently verified distribution**: R612, R627, R630, R639; R628 filename only is confirmed in R631 verification script, not byte-checked. R621 and R622 had conflicting same-version APK hashes in older and later handoffs: never conflate them.

Most important user/device facts:
- R611 scoped real PASS: original Android native 8-action/filmstrip Gallery stays after One Hand Operation+ **NAVER ACCESSIBILITY** OFF→ON, unlike R609; do not confuse with camera watcher.
- R613→615→617: initial UI and user-visible control sizes; R615 QA compared hitboxes rather than actual visible track.
- R619→621→623→625: user explicitly asked stationary date digits, native-like bottom period wheel, vertical date-grouped media, Kakao ordered multi-select/long-drag, photo zoom, fixed top actions, independent kinetic filmstrip, original highres/video seek.
- R629→631→633→635: reused same native Gallery owner for picker and added extra picker observer/QuickRecord repair; original Gallery regressed on actual device. R637 restored DEX but actual initial Gallery still failed.
- R640 partially passed first-open and One Hand toggling but failed QuickRecord; R641 user-device PASS initial Gallery, NAVER toggle, photo/detail, QuickRecord; **scoped Golden** SHA `bf1633ad830057b61ef1d256d57a9215b393800c739c75a113dbb10f06167e89`.
- R643 picker JS/CSS-only candidate still physically failed QuickRecord and user's new photo-picker UX. R645 logs show retry-age gate missed at 1518ms; R646 bounded rearm mock PASS not proven real-device; R647 R625-ui/R611-core physical FAIL.
- R648 user-device PASS **only after One Hand OFF→ON**, in lock/on-screen/in-app QuickRecord/Gallery contexts; photo-add still incomplete. SHA `6b5984e1b3892c0ed10606008d2627c0393ba02661e22a13565571f1a47be3c1`. R648 2662-event historical log, 581 build-tagged new rows, image6+video2 RESOURCE_LOAD_ERROR cause unknown.
- R649 same-DEX + picker-only changes **physically failed** QuickRecord and photo preview despite browser static PASS. QR ACK→nativeOpen=true→fresh START_INLINE→nativeOpen=false. Age-gate check at 289ms skipped (<1800ms), proves missed recovery opportunity **NOT** the native Gallery closing root cause. R649 is quarantined, not Golden. User `23197.mp4` and R602 JSON.
- R650 SHA `dac8e53eabe4cef3132a94deee8c85b4025440a1d40f5f58126f681863f6ce6c` code650 is an emergency functional-R648 clone (Manifest version only); **no physical QA or confirmed install yet**. No uninstall/data clear or AA audio changes. Next candidate code>650.

Mandatory detailed source links:
- [R611 Golden](MOA_R611_USER_DEVICE_APPROVED_GOLDEN_LOCK_20261115.md)
- [R641 direct R611 guard](MOA_R641_R642_R611_GOLDEN_QUICKRECORD_ARM_DEDUP_HANDOFF_20261116.md)
- [R648 scoped Golden](MOA_R648_USER_PHYSICAL_SCOPED_GOLDEN_PHOTO_ADD_LOCK_20261116.md)
- [R649 REAL device FAIL](MOA_R649_REAL_GALAXY_QUICKRECORD_AND_PHOTO_PICKER_FAIL_20261116.md)
- [R649/R650 signed artifact evidence](MOA_R649_R650_R648_GOLDEN_ISOLATED_PHOTO_ADD_SIGNED_HANDOFF_20261116.md)

Read the **full private Library report**, not this abbreviated pointer, before new source modifications.
