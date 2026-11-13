# MOA R491 / R493 — theme-linked photo mosaic calendar, original-signer signed release (2026-11-13)

## Latest confirmed source of truth
- **User-approved Golden remains frozen R463.** Do not promote R491 without user's Galaxy verification. Golden branch: `golden/moa-r463-user-approved-20261113`, original signed APK SHA256 `9d2fd10d32a3bc35eb3132333e96edd8f565abd5daf3ce954b052f77083d8379`.
- Base: exact R487 original-signer APK, SHA256 `d9c09d4824419b0d96e15a8da54533ce7f4b0cdf7f3380994a188463c91eec3c`, versionCode 487.
- **R491 signed installable beta:** `MOA_R491_THEME_LINKED_ROUNDED_CALENDAR_ORIGINAL_SIGNER_BETA.apk`, versionCode **491**, 9,004,114 bytes, SHA256 `f3d7914d0ebfaf49ee4c2cd2aff70bd18a02d3b386fea6f8de3af6161bd210bf`.
- **R493 emergency exact R463-function restoration:** `MOA_R493_EXACT_R463_GOLDEN_FORWARD_RECOVERY.apk`, versionCode **493**, 8,978,143 bytes, SHA256 `de69599ceef79171f04cf66e1c9bb33e56baae8a9d0b1ecf9685d79a0a2a78a2`. Use only if regression; after R493 installed future candidates **>493**.
- Package `com.juhyeon.familyjournea`; original signing certificate SHA256 `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`; private keys excluded from ALL released materials.

## User's latest physical R487 correction
- Supplied screenshot shows R487 top-right oval 76×30 overly large, fixed brown full-width Today bar undesirable, sharp rectangular photo date cells, detached 9px white schedule lane between rows.
- User wants **visible slider half size (~44×19)** but keep adequate touch region; warm brown eliminated; **use existing R117 Settings app screen theme/icon palette** with adaptive text/border legibility; round outer/month/photo corners without changing viewport-height calendar; family schedule single accent line inside the same photo/day tile without a separate blank lane.
- Original `assets/web/moa-r117-ui.js` provides `html[data-moa-ui]` resolved color based on `moa.ui.theme.v1=auto/peach/pink/black/white` and icon key `moa.icon.theme.applied`. Existing settings owner is retained unchanged.

## Exact implementation
- Separate active feature branch: `feature/moa-r491-theme-linked-rounded-calendar-20261113`. Based on R487 branch. Exact committed CSS: `experiments/moa-r483/moa-r483-vertical-calendar.css`. **Unchanged R487 JS** on same branch. CSS-only feature delta appended after R487 rules (no other source changes).
- Photo-source and photo/detail oval controls: actual *visible* oval 44×19px instead of 76×30, hit area stays 68×40 (two 34×40 zones). Visual fill, track, selected thumb, focus outline use scoped theme colors.
- Today dock: no brown; 4 contrast-safe named palettes peach/pink/white/black; default/auto uses existing app icon-linked `data-moa-ui` resolver. Button text contrast ratios measured by browser: peach **5.75:1**, pink **5.78:1**, white **14.68:1**, black **12.54:1**.
- Existing fixed-height one-month viewport R487 preserved. Outer rounded 21px, date/photo tiles 7px rounding, 3px grid gap, theme-aware borders and blank cell background. Family event line 3px embedded at bottom of full-height photo/empty day tile; no 9px reserved white bottom stripe.
- Original R463 native Gallery, NAVER protected startup/offscreen writer, QuickRecord, family diary/voice/video photos, database & 17 DEX bytewise FROZEN; JS from R487 unchanged.
- Source-diff R487→R491 **exactly 2 changed APK archive members: AndroidManifest.xml (487→491) and assets/web/moa-r483-vertical-calendar.css**. R489→R493 changes **manifest only** and preserves R463 restoration function.

## QA, proof and delivery
- Original private PKCS12 from authorized user private Library locally verified against original certificate (not published). APK v2 RSA signed-data, signed-content digest, stored-entry alignment, ZIP CRC **PASS independently** for both APKs. R491 has 142 archive members/17 unchanged original DEX; R493 has 140 members/17 DEX. These are static checks, not Galaxy device install.
- Synthetic Chromium 420×870 and 360×780: one-month fully visible, following-month initially 0px, date opening, Today return, year/month picker and tiny source toggle PASS. 20 months down + 20 back, bounded 18 sections, PASS.
- Dynamic theme simulation for 4 named modes: tiny slider geometry/hit regions, source switch both ways, day mode toggle geometry, Today button contrast >=4.5, rounded corner, full-height photo behind in-cell family line, no JS errors — **PASS**. Galaxy device interaction/14k photo/NAVER/Advanced Gallery **NOT_TESTED**.
- **Combined full archive:** `MOA_R491_R493_THEME_LINKED_SIGNED_APK_SOURCE_QA_20261113.zip`, 13,381,343 bytes, SHA256 **`0be046a07dce99503743f09f1967b8cf003187ef77aae767021d919ad3220c45`**, ZIP CRC + embedded exact APK byte verification **PASS**. Contains two original-signer signed APKs, exact JS/CSS + delta CSS, independent QA and screenshots, SHA256SUMS and Korean readme.
- Private Library `/모아_프로젝트_근거_20261103/R491_R493_THEME_SIGNED_RELEASE_20261113/` contains combined ZIP, both APKs and CSS.
- Links appeared in current ChatGPT conversation, **but ChatGPT Android user's actual link opening remains unverified** (prior user saw `Library file not found`); do NOT call DOWNLOAD_CONFIRMED without user feedback.
- Install candidate over existing app **without uninstall, clearing cache/data, resetting IndexedDB, photographs, NAVER cookies or Login**, only when installed versionCode<491. Emergency R493 only for serious regression. Keep R463 immutable and AA AirPods project untouched.

## Next chat mandatory
Read `MOA_READ_FIRST_NEW_CHAT.md`, `MOA_R463_GOLDEN_LOCK_READ_FIRST_20261113.md`, `MOA_WIP_CHECKPOINT_CURRENT.md`, this release handoff; exact R491 source and ZIP in Library. **Never restart R483/R487 rebuilding from scratch** when these verified signed artifacts exist. Distinguish STATIC_PASS from REAL_DEVICE_PASS; preserve high-version update.
