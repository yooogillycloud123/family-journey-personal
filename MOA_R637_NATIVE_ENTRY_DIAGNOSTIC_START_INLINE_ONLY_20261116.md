# MOA R637 physical native Gallery diagnosis — START_INLINE only — 2026-11-16
## User-supplied exact diagnostic, not an assistant-generated simulation
```json
{"version":602,"last":"START_INLINE","events":[{"event":"START_INLINE","at":1794818778820,"count":7}],"visibleDay":false,"count":7,"bridge":true,"arm":false,"pending":false,"opened":false,"mounted":false}
```
Local Asia/Seoul timestamp for START_INLINE: 2026-11-16 **17:46:18.820**.

## Grounded reading of the frozen R611 source
- The actual `r507StartInline()` emits START_INLINE **before** asynchronous `setTimeout(tryOpen,0)`. No actual native open acceptance is established by START_INLINE.
- `tryOpen` first silently returns when `generation!==r507Generation || !ui.open || ui.page!=='day' || view.hidden`; this abort **does not emit any diagnostic event**. A navigation to Settings can make the diagnostic `visibleDay:false`, `arm:false`, and `pending:false` even when the photo-day was earlier active. Do not misclassify `visibleDay:false` as proof photo page never activated.
- The `bridge:true` flag only means Java provider sent `__moaR507BridgeReady=true`; the source additionally needs callable `MoaLocalAudio.openNativeGallery`, stage attached and R611's `__moaR511NativeArmed` ACK.
- If `tryOpen` reached the bridge gate and waited the whole 8 seconds, original code would log `PROVIDER_BRIDGE_TIMEOUT` or `NATIVE_ARM_TIMEOUT` on failure. If it reached the open API, it would log `NATIVE_OPEN_ACCEPTED` or `NATIVE_OPEN_REJECTED`. Those events are **absent** here.
- Consequently this JSON **does NOT prove a specific cause** (cannot assert ARM gate, permission, JNI, DEX, stage, network, or picker script). It locates the last observed event: *before recorded native open result*. A silent early abort, timer canceled by UI transition, unobserved JavaScript error or navigation before timeout remain possibilities.
- User earlier reported R637 old Web fallback from first photo-day/QuickRecord/NAVER toggle despite **R611's 18 native DEX and original photo JS/CSS exact bytes**. R637 index.html + standalone picker JS/CSS are different; R638 is same-signature **R611-exact functional control**.
## Required next falsifiable test without inventing fixes
Install **R638** in-place *only as isolated control* when willing to temporarily forgo the photo-add feature. R638 APK SHA256 `6aaad8fb70fe0545810eba6c2dccbc1a454372872b31b7f6c18ad4926d53cbab`, versionCode638, 143/144 original members identical, only AndroidManifest version number changed, 18/18 original DEX exact. Preserve app data and Naver session. First open existing photo-day; One Hand NAVER OFF/ON; QuickRecord. If R638 works, R637-only index/standalone startup script is implicated. If R638 fails, runtime/preferences/provider/permissions/OS/process-level cause requires additional direct live-stage diagnostics (not another speculative UI patch). **No physical pass for R638 yet**.
## Future diagnostic minimal edit only if R638 also fails
Snapshot and persist *while photo-day is active*, before Settings navigation: `ui.open`, `ui.page`, `view.hidden`, `r507Generation`, timer scheduling, bridge method availability, `moa-r469-stage` attached status, `__moaR511InlineArm`, `__moaR511NativeArmed`, JNI provider ARM_SNAPSHOT result, and timeouts. Existing R602 diagnostic logs too sparsely to distinguish silent early abort. Use no gallery close/re-open fixes until the first failing gate is proved.
Never clear app storage/cookies, uninstall, revoke NAVER state, or modify immutable R611 Golden. No AA AirPods modification.
