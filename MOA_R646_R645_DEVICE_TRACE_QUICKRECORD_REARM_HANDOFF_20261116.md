# MOA R646 — R645 actual Galaxy full-run trace, QuickRecord single-check timing gate repair (2026-11-16)

## Authority and basis
- Mandatory first: cross-project canonical `yooogillycloud123/workexcel-devbridge/main/AA_AirPods_FINAL_READ_FIRST_v1.0_20261005.md`, `MOA_READ_FIRST_NEW_CHAT.md`, `MOA_PERMANENT_FULL_RUNTRACE_RELEASE_POLICY_20261116.md`, R611 and R641 physically verified Golden, R643 physical regression.
- The user installed R645 and supplied **1222 events** from real Galaxy S26 Ultra, 2026-11-16. The user reports **when MOA stays open, saving through QuickRecord again causes the original photo-day native Gallery to disappear**.
- **R641 physically scoped Golden APK remains immutable** SHA256 `bf1633ad830057b61ef1d256d57a9215b393800c739c75a113dbb10f06167e89`; original R611 Golden remains immutable. R643 device failure remains authoritative.

## Strict facts from user R645 trace (UTC → KST +9)
- At 12:58:50.069Z, `NATIVE_MOUNT_ACK` and `NATIVE_8_ACTION_DECK_READY`: native Gallery really mounted in the preceding day entry.
- At 12:58:58.352Z, `QUICK_RECORD_NATIVE_COMMIT`, followed by `R641_LIFECYCLE/QUICK_RECORD_COMMITTED`.
- At 12:59:00.079Z, R641 lifecycle reports `page:calendar,active:true,nativeOpen:false,arm/pending/opened/mounted:false`.
- `START_INLINE` at **12:59:00.359Z** (12 media), then another at **12:59:02.793Z** (12 media). No subsequent `NATIVE_PREDRAW_ARMED`, `NATIVE_OPEN_ACCEPTED`, or `NATIVE_MOUNT_ACK` before export at 12:59:15.728Z.
- At **12:59:01.877Z**, the existing R641 3200 ms QR checkpoint ran; latest `START_INLINE` was only **1518 ms** old. Original R641 code explicitly rejected `Date.now()-last < 1800`. It did not run a second checkpoint thereafter. This is a **verified recovery-gate timing defect**. It does NOT identify with certainty the Java/Android callback responsible for the initial absent native ARM.
- R645 logger wrote many repeated `NATIVE_GALLERY_OPEN_OBSERVED` and `NATIVE_8_ACTION_DECK_READY` entries (~hundreds), causing unnecessary journal writes. The R646 logger deduplicates periodic keepalive and records suppressed counts, preserving important transitions.

## R646 signed deliverables, source and install
- Primary `MOA_R646_R641_QUICKRECORD_RECOVERY_FULL_TRACE_ORIGINAL_SIGNED_BETA.apk`, **versionCode646**, package `com.juhyeon.familyjournea`, 9,097,706 bytes, SHA256 `0d2778071915bf871eb808dd37795b2e2bd8d03cb0e4dc881217b11528941a5f`.
- Original v2 RSA SHA256 signer certificate `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`, full signature/content digest & ZIP CRC PASS.
- Exact same APK in QA ZIP `MOA_R646_R641_QUICKRECORD_FULL_TRACE_APK_QA_20261116.zip`, SHA256 `d53729d2293de1000e33ad50265a7195e6b90c2da2cbc9c80062b9367acea075`.
- Library: `/모아_프로젝트_근거_20261103/R646_R641_QUICKRECORD_REARM_FULLTRACE_20261116/`; APK+ZIP+full source+QA+patch+README; no private signing material.
- Development branch: `feature/moa-r646-r641-quickrecord-rearm-fulltrace-20261116` with exact R646 updated QR bootstrap and logger; original calendar JS full source in private Library and diagnostic-only patch `release_snapshots/moa-r646/R645_R646_NATIVE_PATH_DIAGNOSTIC_ONLY.patch`.
- Built directly from exact signed R645 to preserve all R641-derived core functionality and R645 persistent log store. Of **147 R641 original APK members 143 remain unchanged**; only Manifest, index (R645 logger), photo JS R646 diagnostic hooks, and QR bootstrap R646 bounded retry differ. **18/18 original native DEX byte-for-byte R641**, original `family-diary.js`, voice JS, Gallery CSS, R640 picker JS/CSS identical.
- R645 → R646 changes exactly Manifest version, photo JS diagnostic breadcrumbs (no native open algorithm change), R641 QR bootstrap bounded retry and trace JS repeated-event coalescing.

## QR retry algorithm and QA limitations
- At native QuickRecord commit, R646 inspects original Gallery state at +550/1650/3200/5300/7300/10300/13500/16500 ms.
- **Maximum ONE** original `__moaR543RepairInline()` call, and only after +5300 ms if same selected photo-day matches committed date, actual DOM stage attached and wide enough, original Java `isNativeGalleryOpen` **explicitly returns FALSE**, no native ARM/pending/open/mount, bridge+method present, and last native `START_INLINE` path is stalled for >=1800 ms. Never restart while open, unknown, another day, exiting, or healthy native mounted. The 8 checks are observations; not 8 restarts.
- Adds precise `R646_TIMER_FIRED`, `R646_WAIT_BRIDGE`, `R646_WAIT_NATIVE_ARM`, `R646_ARM_CONFIRMED`, `R646_INLINE_STOP`, `R646_OPEN_STALLED`, `QUICK_RECORD_REARM_GATE`, `QUICK_RECORD_REARM_FINAL` to persistent full-run trace.
- Node JS parse PASS, **8 bounded QuickRecord guard simulated scenarios PASS**, Chromium isolated Settings/show/copy/QR logging & >350 repeated Gallery observations reduced to 1 each PASS with zero pageerrors and no text leak.
- Chromium actual local URL navigation was blocked by browser admin policy, so standalone browser QA does not claim real Android WebView IDB persistence. Original R645 real user export does establish that R645 indexedDB journal was working, not that R646 end-to-end Galaxy works.
- **R646 is untested on the user's real Galaxy, BETA only. Do not claim Golden or complete success before full device test including app-stays-open QuickRecord, photo/detail, repeated One Hand Operation+ NAVER accessibility OFF→ON.**
- Preserve all app/Naver/diary/cookies/media data: update install in place (NO uninstall/data clear). Do not modify unrelated AA AirPods Android Auto.
- All later builds **must** preserve Settings full-run accumulated trace + copy and add explicit last-failing gate indicators without high-frequency duplicate flood.
