> **2026-11-06 LATEST RELEASE CANDIDATE R117 (NOT GOLDEN):** From exact R115 device Golden, a new signed code117 beta APK was built for **일기 첫 화면·일기→지도→기록→설정 하단 순서·기본 접힘 설정 그룹·아이콘 색상 연동/선택 가능한 화면 테마**. R117 sha256 `667e6caa97ffc76b10df15594d5be0672ea892ae0be2692b293161eba94dfdb0`, 5,412,356 bytes, same package/signer; 100/103 baseline files unmodified, original DEX/diary/map untouched; static/browser-mock verification PASS; **Samsung installation & user feature tests PENDING**. **Current Golden is still R115**. Read [R117 release handoff](MOA_R117_DIARY_FIRST_COMPACT_SETTINGS_ICON_LINKED_UI_HANDOFF_20261106.md) and `MOA_RELEASE_LEDGER_CURRENT.md`; exact signed APK/source QA private Library. R118 reserved signed R115 restore only, next regular code >=119. Do not claim successful hardware verification without user report.

> **2026-11-06 USER DEVICE CONFIRMATION:** User has now expressly reported R115 real-device verification complete and approved this exact R115 as the ongoing Golden for future improvements. STATUS: **USER-REPORTED REAL-DEVICE TEST PASS / ACTIVE R115 GOLDEN**. Individual optional feature-level checklists were not supplied, so do not invent them. The exact signed R115 APK/sha remains unchanged. Older "pending" statements below are historical before this confirmation.

# MOA — NEXT NEW CHAT: START HERE, 2026-11-06
**ACTIVE HIGHEST-PRIORITY MOA ENTRY POINT. Do not start from R63/R89/R96/R99 or historical "LATEST" sections.**

## 0. Mandatory first actions (before analysis, source changes, builds, or new APK)
1. For this shared project, obey top-level `yooogillycloud123/workexcel-devbridge/main/AA_AirPods_FINAL_READ_FIRST_v1.0_20261005.md` read-full requirement first; **do not change AirPods code** when working on MOA.
2. Read **this entire document** and `MOA_R115_USER_APPROVED_VISUAL_GOLDEN_LOCK_20261106.md` in full.
3. Read `MOA_RELEASE_FAILURE_LEDGER_AND_BUILD_GATES_20261106.md` (what failed R100–R115, why, how repaired, tests preventing recurrence).
4. Read `MOA_ARCHITECTURE_EXTENSION_AND_QA_MAP_20261106.md` (actual signed APK layout, data protection, UI and feature verification map).
5. Read `MOA_RELEASE_LEDGER_CURRENT.md` for dated per-release version history and actual status; it is **append only**.
6. Read `MOA_DELIVERY_CHAT_ONLY_NO_EMAIL_RULE_20261106.md` and `MOA_RELEASE_DOWNLOAD_LINK_RELIABILITY_CRITICAL_RULE_20261105.md` before ANY file link.
7. Open the exact **private Library Golden APK** and compare bytes/SHA to `MOA_R115_GOLDEN_LOCK_MANIFEST_20261106.json`. Check actual runtime outputs `_analysis*`, APK, DEX, temporary patch/test and verification files first; **continue from the most recent verified evidence, never regenerate blindly.**
8. Only after the above, load task-specific older source/handoff (e.g. R63 storage, R83 speech, R89 keyboard, R96 navigation, R99 settings, R111 density, R113 icon, R115 splash).
9. Resolve any contradictory historical "CURRENT" header by timestamp and evidence: this document **overrides older 2026-11-03/04/05 status claims**, not the old factual evidence.

## 1. Current exact source of truth
- **R115 USER-APPROVED VISUAL GOLDEN**. User stated **"오케이 이 버전을 골든버전에 추가해놓고"** on 2026-11-06 after the R115 splash popup repair and asked for permanent engineering history and future-proof documentation.
- package `com.juhyeon.familyjournea`, code **115**, signer cert SHA256 `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`.
- SHA256 `1118bdc249e2d941a899518e58be0185b120a887ff2c371c8f5a01037a5002a8`, **5,406,744 bytes**, 103 APK members.
- Freeze Library file: `/모아_프로젝트_근거_20261103/MOA_R115_USER_APPROVED_VISUAL_GOLDEN_20261106_DO_NOT_MODIFY.apk`.
- Freeze manifest: same Library folder `MOA_R115_GOLDEN_LOCK_MANIFEST_20261106.json`, digest file `MOA_R115_GOLDEN.sha256`; preceding verification `MOA_R115_INDEPENDENT_VERIFICATION.json`.
- R113 SHA `024f788ca890f1eccbc3a1cdd08aee5dbe78baf6b43dfaa5cf72d24ce32b7f25` → R115 changes **only** `AndroidManifest.xml` (code 115) and `assets/web/index.html` (early CSS/critical splash dimensions). **101/103 members byte-identical**.
- Prior user-confirmed Golden boundaries R63 direct IndexedDB, R83 native speech, R89 keyboard-aware native memo, R96 navigation. **Do not overwrite or silently combine/revert these.**
- **Next normal code >=117** because code116 reserved for emergency R113 rollback-forward; avoid legacy "latest" versions on main.
- Current Golden approval = **visual UX freeze, not a claim all existing features tested on R115**.

## 2. What is done
- Approval screen icon 3 styles × 3 colors; B's A is consistent crossbar-less `Λ`.
- R111 fixed the binary `resources.arsc` PNG nodpi vs adaptive XML anydpi density configuration; actual home icon pixelation went away on user phone.
- R113 shrank/centered MOA launcher wordmark, cleansed nine splash icons, removed black blotches/cropped poster ghosts.
- R115 loads icon CSS early in `<head>` and first-paint constraints at 180px to prevent raw 768px splash image jumping outward while opening; Chromium reproduced R113 failure and R115 fix.
- User explicitly designated R115 Golden. Artifact signatures and bytes checked. No extra helper app, no data wipe, no signing key rotation.
- **No new software feature was requested in the Golden-archival conversation.** Do documentation, safe freeze and future process, not unsolicited APK rebuild.

## 3. What remains pending, DO NOT claim PASS
The user clearly stated they would test the pre-existing MOA functions **after** visuals are finalized. Therefore R115 comprehensive device tests **PENDING**:
- old diary, notes, photos, calendar/day thumbnail display, exact timestamp/MediaStore id, IndexedDB save/readback;
- Samsung camera `바로 기록`, voice/STT, keyboard alignment, record edit and safe delete confirmation;
- top/bottom move/drag/lock accordion; settings touch;
- full 9 variant icon switch/persist/launcher and cold start for each;
- offline continuity, shortcuts/OHO if used.
No need to force the user to reshoot/rewrite old entries; prioritize read-only non-destructive checks. If something fails, capture one exact screenshot/log, preserve data, and patch only proven root cause.

## 4. Nonnegotiable "never again" lessons
- Binary Manifest `activity-alias` typed attr resource-map ID must be correct; R100 installed FAIL even though ZIP/v2 PASS.
- Never crop 150px icons out of a promotional poster and scale to 768px; this baked shadows/black captions into R103.
- Adaptive XML only isn't enough; inspect binary `ResTable_config.density`; `anydpi XML / nodpi bitmap` boundary was the R109 → R111 critical fix.
- Wordmark must stay inside launcher's safe zone: R111 huge glyph clipped; R113 fixed.
- Splash icon and launcher icon are different assets; a clean launcher does not clean WebView PNG.
- Load critical splash CSS BEFORE the large 768px IMG can first paint; R113 "popup" flash → R115 fixed.
- APK signature and container file existence aren't actual phone delivery, install or user test; separate gates.
- **NO Gmail, mail drafts, mail attachments.** Current conversation APK direct only. Repeated `Library file not found` must be handled as delivery trouble, not code trouble.
- No premature "can't build" or arbitrary zip handoffs; reuse correct signing/build tools from verified chain and finish bounded work honestly.

## 5. Future work protocol on every single message asking for a change
1. Read exact latest Golden/digest/previous task status. Distinguish verified facts vs hypotheses.
2. State short change plan, touched members and must-not-touch; protect old data.
3. Patch a COPY of Golden, minimum change; use source-accurate branch and no secrets in public.
4. Static verify (ZIP, full APK v2 and cert, binary AXML, resources, DEX, member diff, CSS/JS tests).
5. Provide real in-chat installable APK if requested; no email; no broken-link claims.
6. User tests physical behavior; record results exactly, including FAIL and precise cause, in `MOA_RELEASE_LEDGER_CURRENT.md`.
7. Always update this bootstrap, Golden pointer if user approves new Golden, the WIP checkpoint, main README and top of `MOA_ABSOLUTE_READ_FIRST_20261103.md`; attach private frozen binary+manifest+rollback and no-key checks. Never report a newer version as Golden without explicit acceptance.

## 6. Further background
- The public repo contains historical experimental `android/` project with **different package**; do not replace the real signed APK with that debug prototype.
- NAVER hidden/background bookmark update is **ON HOLD** and must not be inserted during icon/diary fixes.
- English learning with user's family photo diary is a possible separate opt-in extension, **not implemented by this checkpoint**.
- `MOA_R116_EMERGENCY_RESTORE_R113_NOT_ROUTINE_INSTALL.apk` is a **recovery only** file which returns R113's flash, not a perfect R115 rollback.
- Do not expose private signers, family photos, account credentials or private records.
- Keep WIP `MOA_WIP_CHECKPOINT_CURRENT.md` as historical verbose timeline, but this entry point controls *current state*. Never destroy historic logs.

**Next action now: collect R115 legacy feature tests if/when user supplies results, or implement the next expressly requested feature from this exact R115 Golden.**


## 7. Frozen engineering snapshot / guard available now
- Private Library `MOA_R115_GOLDEN_NO_KEYS_ENGINEERING_SNAPSHOT_20261106.zip`, 1,935,084 bytes, SHA256 `65dacf44688f4eeb45e91b20e3e83693ec1913d22c8015b5abbc2ecd36b93e13`. This is selected R115 exact source/resource extract + verification + R113 HTML diff, **not** a complete native build project. The full signed Golden APK is separate.
- Public keyless guard: `tools/moa_golden_release_guard.py` and private inventory `MOA_R115_GOLDEN_LOCK_MANIFEST_20261106.json` are ready. Execute before any new APK release with an explicit changed-member allowlist. Pass/fail of this tool does **not** prove v2 signing, PackageManager installation or user device feature tests.
- Guard self-tests archived: frozen R115 against itself PASS; R113 intentionally fails due to its 2 changed members. No need to recalculate these from scratch unless source or tool changes.

**Named GitHub freeze branch:** `golden/moa-r115-20261106-visual-user-approved-do-not-modify` (documentation/test/source-reference snapshot based on main at freeze time, not an installable APK or complete native build). Exact signed R115 bytes remain in private Library; never mistake branch for reproducible binary source.
