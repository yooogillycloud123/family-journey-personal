# MOA — READ FIRST IN EVERY NEW CHAT

**Updated:** 2026-11-13 (Asia/Seoul)
**CURRENT USER-APPROVED GOLDEN:** **R435**. This is the first entrypoint for MOA work, unless a later explicitly user-approved Golden is documented above it. **Do NOT treat older R415/R419/R423/R427/R431 as the active implementation baseline.**
**Latest development candidate (NOT Gold):** **R455** signed versionCode455, from user-confirmed R451. Only top-center three-panel folded-map WHITE symbol draw size reduced from ~29dp to ~20dp, matching lower Share icon (21dp); unchanged 42×36dp touch target, same anchor, compact time/address/checkbox, bottom Share/Map and native video/gallery/NAVER. CI/API signed content+DEX PASS, user Galaxy visual test PENDING. Read [R455 handoff](MOA_R455_R451_TOP_MAP_SYMBOL_21DP_R457_RECOVERY_20261113.md); private Library `/모아_프로젝트_근거_20261103/R455_TOP_GLYPH_21DP_20261113/` includes APK, exact R451 functional recovery R457, full ZIP QA and new-chat prompt. R435 user Golden stays immutable. After R457 installed, next versionCode>457.


## Read in order
1. Project-level canonical `yooogillycloud123/workexcel-devbridge/main/AA_AirPods_FINAL_READ_FIRST_v1.0_20261005.md` and Library `AA_AirPods_READ_FIRST_NEW_CHAT.txt`, `AA_AirPods_MASTER_HANDOFF_v3.3_20260928.md` as required by this ChatGPT Project. **Do not touch AirPods/Android Auto for MOA requests.**
2. **[R435 user-approved Golden Lock](MOA_R435_USER_APPROVED_GOLDEN_LOCK_20261113.md)** — full binary identity, artifacts, preservation and rollout rules.
3. **[Current work checkpoint](MOA_WIP_CHECKPOINT_CURRENT.md)** — the most recent user-reported results and subsequent development, if any.
4. **[R435 implementation handoff](MOA_R435_R431_DRAGGABLE_NAVER_HOME_R437_EXACT_RECOVERY_20261113.md)** — original native draggable-home implementation and static QA.
5. **[Copy/paste new-chat prompt](MOA_NEW_CHAT_RESUME_PROMPT_R435_20261113.md)** — ready to reuse in any new conversation.
6. Read detailed older R415/R419/R423/R427/R431 handoffs only when tracing historical features/bugs.

## Immutable Golden identity
- User designated current Gold: `MOA_R435_USER_APPROVED_GOLDEN_20261113`
- Original package: `com.juhyeon.familyjournea`, versionCode **435**
- Original APK SHA-256 `e36e55b823d9d8aa1650c05fb8314b5773df7b00287dab2e102440eea51f910c`
- Original signing cert SHA-256 `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`
- Frozen GitHub source branch: `golden/moa-r435-user-approved-20261113`
- Original APK + source + QA in PRIVATE Library: `/모아_프로젝트_근거_20261103/GOLDEN_R435_USER_APPROVED_20261113/`.
- R435 preserves full native gallery (rail/video/mute/capture/volume), first-party NAVER nonoccupying save/rearm and cookies, covered launcher prewarm, theme splash, collapsible NAVER UI, safe chevron and native pink Home drag/position persistence.

## Non-negotiable continuation
- No reset/uninstall; preserve MOA/NAVER sessions and user data.
- No changes to AirPods/Android Auto.
- No premature "device PASS" from compile or APK signature alone; user approval of Golden is a baseline choice, not universal feature-by-feature independent validation.
- Future candidate must be built from exact R435, same original signer, **versionCode >437**, with an **exact R435 function forward-recovery** APK higher than that candidate. R437 is **only an R431 forward recovery**, NOT an R435 Golden recovery.
- Never rewrite Golden folder/branch.
- Do not forget actual user request in the active new conversation; deliver the requested delta and updated signed APK/QA when asked.

**Operational default:** If a new-chat request says "모아 계속" or "R435 이어서", open this file first, then the Golden Lock, current checkpoint, QA and source; proceed using R435, not older versions.
