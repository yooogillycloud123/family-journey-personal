# MOA R62 evidence-targeted same-package update — 2026-11-03
## Actual user-provided device evidence
- Read-only uploaded `MOA_R61_V4_20261103_212331.txt` confirmed ADB authorized, `run-as` successful, active MOA `HostActivity` after manually opening selected-photo diary.
- EXACT installed APK SHA256: `4b60d0230801a48e2cf5f3da334e4d8e37a5738adb219e9a7be0513c4a028ba1`; this identifies **first** of two materially differing R61 APKs.
- Native pending `m:`=31; eligible memos=11; ALL 11 eligible IDs and timestamps valid. `bridgeDiagnostic` and `inboxSyncDiagnostic` remain empty before/after entering app. This means Java-to-WebView save did not complete; exact lifecycle cause still not proven.
- v4 evidence disproves the prior suggestion that malformed timestamps among all 31 `m:` records prevented delivery: among the **11 eligible**, valid-time=11, invalid-time=0, invalid-id=0.
## Exact source build correction from identified installed R61
- Original installed R61 had `classes4.dex` SHA256 `223ac012106a3810054a4e01b12dbcdb7e9de10d9df2e601e5ecb8e242502da9`, whose `MoaMomentInboxSync` used cached WebView `getUrl()` gate and lacked early `R61_HOST_RESUMED` signal.
- Source-proven later R61 Java artifact from GitHub Android D8 CI #41621153060: `classes4.dex` SHA256 `60e08524dfc9aa66c5055ba46d6b786f3b14c344767695daea448cb0426467cb`. This probes the LIVE JavaScript document `location.origin` and `__moaNativeSync`, independent of `MoaMomentNative` JS interface, and sets `R61_HOST_RESUMED` before WebView gates.
- In the local builder, started from EXACT installed R61 APK (not the other R61 build), changed **only** `AndroidManifest.xml` (versionCode 61 -> 62; versionName R61 -> R62) and `classes4.dex` (CI-built later Java transport). Of 53 members, other 51 **byte-identical** including all JS/CSS/web assets, original HostActivity, camera/service/STT resources. No extra app or code for duplicate popup.
- Signed same private R39/R42-lineage signer held in private Library; certificate SHA256 `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`. **Never** expose signer, private registry, PKCS12, or password.
- APK: `MOA_R62_실설치R61기준_일기직접전달_동일앱업데이트_실기검증필요.apk`. SHA256 `e1abe553ee1a9d5565b0c90eb8a207524f794430c249363f8f9e39f6adc4df8e`, bytes 3413203, package `com.juhyeon.familyjournea`, code 62, name `MOA-R62-Safe-Capture`. ZIP integrity, DEX SHA1/adler32, APK v2 signature/digest verification PASS, Node tests (3 suites) PASS.
- **STATUS: signed static candidate, not Galaxy functional PASS.** This is one evidence-targeted correction of mistakenly installed older R61, NOT proof that missing app lifecycle callback has been fixed. Diagnostic in preserved UI still says R61 because diary JS was intentionally not modified.
- If it fails, no repeated speculative version increments. Read the now-instrumented `R61_HOST_RESUMED` / `R61_WAIT_CONSUMER` / commit status from existing preferences, then fix only the proven stop point.
## Safe installation/test
- Update-install over existing package. Do NOT uninstall, clear app data/cache or touch original R37 `com.juhyeon.familyjourne8`.
- Do not take another photo. Open '내가 고른 사진 일기' for Nov 3 and other original capture dates and confirm the already-existing 11 pending written notes and their original photos/videos appear at correct timestamps; close/reopen to test persistence.
- R62 is still only local/native draft save until the WebView commits existing `curated` IndexedDB. If missing, do not claim committed or discard native queue.
