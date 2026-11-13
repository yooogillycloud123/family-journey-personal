# MOA — READ FIRST IN EVERY NEW CHAT

**Updated:** 2026-11-13 (Asia/Seoul)

## Current user-approved primary GOLDEN: **R463**

**2026-11-13 explicit user declaration:** “오케이 이것도 골든으로 확정 여기에 이어서 업구레이드 진행한다. 이해하지? 새채팅용 프롬포트랑 내용들 깃허브등 다 제대로 보관 기재해”.

This **promotes exact R463** from signed beta to the latest **user-designated baseline**, not a claim of independent exhaustive on-device testing. **R435 is the prior user-approved Golden, archived and intact, but NOT the current development base.** Earlier R459/R455/R451/R443 etc remain historical. Do not select them for new MOA updates automatically.

## Latest user-requested UI direction (PROPOSAL ONLY — R463 Gold remains unchanged)

**2026-11-13:** User requests a DayPic-inspired **third photo-filled calendar and simple two-section daily diary**, not replacement of original manually chosen-photo calendar / automatic-photo calendar / rich time-segmented diary. See [R463 additive Photo Calendar + Simple Diary UI design](MOA_R463_DAYPIC_INSPIRED_ADDITIVE_PHOTO_CALENDAR_SIMPLE_DIARY_UI_PLAN_20261113.md) and top of [WIP](MOA_WIP_CHECKPOINT_CURRENT.md). New calendar fills date cells with photos, small date overlay, date-aware central `+`, explicit Today and Home. Simple editor uses **오늘의 사진 / 오늘의 일기** only (no `오늘의 음악`); reuse existing native Gallery/video/share/GPS and extend safely. This is a **briefing proposal, not implemented**; no APK, code, signing, or Golden change has been made. Await user's additional design choices before building. Retain R463 as the exact original Golden.

**CURRENT LATEST mandatory correction:** The user now explicitly **rejects the previous `바로기록` two-save-target chooser**. Keep ONE existing Quick Record flow; preserve original detailed chronological view and show same date's records in the new concise simple diary UI, no duplicate saves. In `오늘의 일기`, support *multiple separately playable voice clips* (append, never overwrite); in `오늘의 사진`, support direct swipes, mixed-video replay, native Gallery actions **inside only the bounded media region**, not a forced black viewer and not intercepting the rest of the scrollable Diary. Distinguish selected day from Today on new calendar. Prior chooser suggestions in older docs/WIP are SUPERSEDED. Read latest Section C and FINAL REFINEMENT of [proposal](MOA_R463_DAYPIC_INSPIRED_ADDITIVE_PHOTO_CALENDAR_SIMPLE_DIARY_UI_PLAN_20261113.md). R463 user Golden remains frozen, NO new APK built.

## Mandatory read order

1. Per ChatGPT Project-level rule, first read `yooogillycloud123/workexcel-devbridge/main/AA_AirPods_FINAL_READ_FIRST_v1.0_20261005.md` in full; also read private Library `/에어팟안드로이드/AA_AirPods_READ_FIRST_NEW_CHAT.txt` and `/에어팟안드로이드/AA_AirPods_MASTER_HANDOFF_v3.3_20260928.md`. For MOA requests, **do not modify AirPods/Android Auto code or runtime**.
2. **[R463 current Golden lock](MOA_R463_GOLDEN_LOCK_READ_FIRST_20261113.md)** — authoritative binary SHA, source branch, all protected features and recovery rules.
3. **[Current work checkpoint](MOA_WIP_CHECKPOINT_CURRENT.md)** — may describe newer user requests, candidates and their test status; change Golden only upon a **new explicit user approval**.
4. **[Original R463 function/CI handoff](MOA_R463_R459_GALLERY_UPPER_FAST_SWIPE_MODE_R465_RECOVERY_20261113.md)** — original R203 Gallery continuous-swipe implementation, pre-Golden static evidence.
5. **[New chat copy/paste prompt for R463 Gold](MOA_NEW_CHAT_RESUME_PROMPT_R463_GOLDEN_20261113.md)**.
6. Read [prior R435 Golden lock](MOA_R435_USER_APPROVED_GOLDEN_LOCK_20261113.md) and older R419–R459 handoffs only for historical analysis or protected module tracing. Do not use prior locks as *current*.

## Immutable R463 Golden identity and records

- Label: `MOA_R463_USER_APPROVED_GOLDEN_20261113`.
- Package `com.juhyeon.familyjournea`; **versionCode 463**.
- Exact original signed APK `MOA_R463_GALLERY_OPT_IN_FAST_STAGE_SWIPE_SIGNED_BETA.apk` (historical filename preserved), SHA-256 **`9d2fd10d32a3bc35eb3132333e96edd8f565abd5daf3ce954b052f77083d8379`**.
- Original signing cert SHA-256 `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`.
- **FROZEN source branch:** `golden/moa-r463-user-approved-20261113`; file `experiments/moa-r391/MoaR391SessionPersistProvider.java`. Do not commit future changes to this branch.
- Private Library **sealed current GOLDEN:** `/모아_프로젝트_근거_20261103/GOLDEN_R463_USER_APPROVED_20261113/`. Contains exact R463 APK, original R463 Java/diff, QA/sha, **true R463 function restoration R467**, archive ZIP, new-chat prompt. Earlier original R463 WIP also in `R463_STAGE_FAST_SWIPE_20261113/`.
- Original Android build [GitHub Actions 43372987065](https://github.com/yooogillycloud123/family-journey-personal/actions/runs/43372987065) SUCCESS; original v2 RSA/full signed-content digest & 17 DEX ZIP checks passed.

## Must preserve (new development must be a delta from R463)

1. Existing advanced native Gallery `classes6.dex`: photos/video, high-fidelity playback, sound/seek/capture, pinch/tap, smooth lower horizontal GalleryRail; keep selected media on Share and NAVER Map return.
2. Compact **50dp four-icon bottom deck**, order **Share / NAVER GPS map navigation / folded-map capture time/address/`기본 표시` panel / upper large-stage rapid continuous swipe ON-OFF**. No visible Korean labels, proper hitboxes, folded-map drawing optically small. Top has no redundant icon; info card appears in its original top location on third lower action tap.
3. Fourth toggle default **OFF** for original upper one-item motion, ON uses native R203 `r203Present/r203ReleaseWithVelocity` lower rail physics to permit full-size multi-item momentum; photo/video sync and original gestures preserved. Mode OFF on Gallery re-entry.
4. R435's protected original NAVER login/cookies, covered PC-map warmup and hidden offscreen first-party save/rearm/readback; screen theme and full diary/recording; separate NAVER WebView tiny foldable control and draggable persistent pink MOA Home.
5. Keep original package and cert. **Never uninstall, clear cookies/data/cache, or downgrade**.

## Recovery — prevent old mistake

- Prior **R465 = exact R459 functional restore**, and **is NOT R463 Golden recovery** (would lose fourth action/fast swipe).
- **New R467 = exact R463 functional restore** `MOA_R467_EXACT_R463_GOLDEN_FUNCTIONAL_RECOVERY.apk`, code **467**, SHA-256 **`0a477fc158daecfd0700f8accef33a9a04876645d4a61c0aace625d407753b0e`**. Same original signing cert; **139/140 R463 payloads unchanged**, only Manifest versionCode updated; v2 RSA/full-content digest VERIFIED. This is emergency-use only, not a normal upgrade.
- Future development use a **new branch from frozen R463**, normally **versionCode ≥469**, with separately signed **higher-than-candidate exact-R463 functional recovery**, verified before shipping. If R467 installed, all later APKs must have versionCode **>467**. Do not promise device success based on only static checks.
- Upload next results/APK/QA to private Library, update GitHub WIP plus new-chat docs and deliver working signed files. Keep prior R435 and all original Goldens immutable.

**Operational default:** Any future “모아 계속”, “골든 이어서”, “R463 업그레이드” -> read this page and current R463 Golden Lock, inspect source/APK/library/previous intermediate artifacts, then advance from R463 only.
