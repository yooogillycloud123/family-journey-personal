# MOA R219 — User-accepted scoped Golden archive (2026-11-09)

The user explicitly requested that the current installed R219 version be included in the Golden records on 2026-11-09 while documenting a **visible, unaccepted floating Quick Record overlay geometry bug**: forced minimum size, diagonal-only resize, grotesquely oversized red Record field and X proportions. Archive R219 binary without rewriting it; only promote user-confirmed functionality, **not the faulty popup resize UX**.

Exact signed immutable binary:
- Package `com.juhyeon.familyjournea`, versionCode 219
- Exact APK filename `MOA_R219_AUDIO_STOP_FLOATING_POPUP_VERTICAL_VOLUME_MEMO_UI_BETA.apk`, 5,751,199 bytes, SHA256 `d45d976a8c08a011a5e8cc5590a3634d37d6369d7f364e46dea6e93f91c338c1`
- Original signer cert SHA256 `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`
- Immutable private Library APK `/모아_프로젝트_근거_20261103/GOLDEN_R219_20261109/MOA_R219_SIGNED_USER_ACCEPTED_SCOPE_FREEZE.apk`
- Immutable private Library SHA256/CRC per 130 APK entries `/모아_프로젝트_근거_20261103/GOLDEN_R219_20261109/MOA_R219_USER_SCOPED_GOLDEN_FREEZE_20261109.json`
- Source-only trace branch `golden/moa-r219-20261109-user-accepted-except-popup-resize` (not a replacement for signed APK).
- Preserve separately frozen R209, R203, R187 scoped Goldens. No untested code becomes Golden.

R221 follow-on requirements: physically independent horizontal/vertical resize on each of all 4 edges and all 4 corners; true dynamic width and height, not single diagonal-size percentage; record/X hit weighting roughly 7:3 except minimum accessible 44dp X touch; **red record graphic remains small and balanced, not filling 70% of the capsule with a grotesque red pill**; text on/off never reserves giant empty red region; 8 edit grips, persistent per-orientation position and two dimensions, normalize/clamp into safe system bars; existing Camera capture observer, PendingIntent record and X dismiss, photos/voice/gallery untouched; regular update-install only, original signer and matched APK+ZIP required. Real device QA still required for R221. Never upload signing secrets or family media to public GitHub or modify AirPods Android Auto routing.

## User evidence
- Private screenshot `19865.png`: overlay occupies excessive horizontal space in Samsung Camera; Record area oversized relative to white dot, X looks misproportioned; old minimum size and one diagonal resize mechanism are inconsistent with user expectations. The screenshot is user-supplied and not stored in public repo.
