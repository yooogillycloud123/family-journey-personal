# R645 R641 scoped user Golden + persistent full-run trace source manifest (2026-11-16)

- The source of truth is the **actual user-device-confirmed R641** signed APK in private Library `/모아_프로젝트_근거_20261103/GOLDEN_R641_NATIVE_QR_ONEHAND_DEVICE_APPROVED_20261116/`.
- **R641 signed APK SHA256:** `bf1633ad830057b61ef1d256d57a9215b393800c739c75a113dbb10f06167e89`. Golden APK and Golden git branch **immutable**.
- **R645 signed APK SHA256:** `9f155402c1b4bf4840e5f2566a1fbc19e62156aee51b4a50e9980bc97ce8bb7a`; size 9,096,304 bytes; package `com.juhyeon.familyjournea`; code645.
- **Original signed v2 cert SHA256** `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`.
- Exact APK delta against R641 **144 / 147 preexisting APK members byte-for-byte identical**; **all 18 original native DEX identical**.
- Three changed existing APK entries:
  1. `AndroidManifest.xml`: versionCode **641→645 only**.
  2. `assets/web/index.html`: add `<script src="moa-r645-full-runtrace.js"></script>` immediately under `<head>`, before existing `host-bootstrap.js`.
  3. `assets/web/moa-r483-vertical-calendar.js`: after `if(r602Diag.events.length>24)r602Diag.events.shift();`, add **one guarded line** `try{window.MoaFullRunTraceR645?.stage(code,row);}catch(_){/* diagnostics never blocks Gallery */}` before `return row;` in original `r602Mark`. No other original Gallery or QuickRecord behavior changed.
- One additional asset `release_snapshots/moa-r645/assets/web/moa-r645-full-runtrace.js` is stored on this feature branch and byte identical to its R645 APK member.
- Runtime: IndexedDB append-only event journal and localStorage recent-tail fallback, session/elapsed timestamp, UI click/gesture/page transitions, original R602 native Gallery stage, R641 QuickRecord timeline, native diary commit, browser exceptions, visible/hidden/exit markers, Settings full view/copy and copy fallback.
- **Important boundary:** no new pre-WebView Android native runtime logger or instant process death trap. Next boot marks a missing observed exit without inventing the cause.
- **Verified:** original-v2 RSA signature/content digest, ZIP CRC, original signer, 18 DEX protection, 144-member protection, Node syntax, Chromium controlled mock UI+copy+events/privacy.
- **Not verified:** Galaxy physical Gallery repeat behavior, real WebView IndexedDB across process restart, clipboard on Galaxy, full pre-WebView native lifecycle. **R645 is BETA, NOT Golden.**
- Private Library release folder: `/모아_프로젝트_근거_20261103/R645_R641_PERMANENT_FULL_RUNTRACE_20261116/`. Contains APK + exact-APK ZIP + QA + source, no signing key.
- Release contract: `main/MOA_PERMANENT_FULL_RUNTRACE_RELEASE_POLICY_20261116.md` and updated `MOA_READ_FIRST_NEW_CHAT.md`, R611/R641 Golden docs and cross-project canonical. All future releases retain full-run trace.
- No uninstall/app-data clearing, Naver auth reset, unrelated AA AirPods audio change or Golden overwrite.
