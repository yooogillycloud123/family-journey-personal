# MOA R383 — native NAVER auth trace exported in-app (2026-11-12)

## User evidence
R379 JSON only captured the MOA Host focus lifecycle and high-level NAVER probe state, explicitly not NAVER WebView callbacks. At 2026-11-12 10:04Z it showed `VISIBLE_DESKTOP_PAGE_FINISHED_UNVERIFIED`, `NAVER_OFFICIAL_LOGIN_ENTRY_UNVERIFIED`, and later `PROBE_DISPOSED`; it did **not** establish the precise cause of the receipt challenge/relogin loop.

## Signed APK (real artifact)
- `MOA_R383_NAVER_AUTH_NATIVE_EXPORT_SIGNED_BETA.apk`
- Package `com.juhyeon.familyjournea`, versionCode `383`
- Size **8,960,537 bytes**
- SHA-256 `6738c3038366c3e8adb5236717b8a2c9ab7f27722371b0b1efebe9d5927e068e`
- Original signing certificate SHA-256 `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`; original private key remains **only in personal Library**, never in GitHub.
- Source branch `feature/moa-r383-auth-trace-export-20261112`
- Compiled `classes18.dex` SHA-256 `5d24a217477210ec3c78b048a57f04eaa9903b0ad010a780786071a97f320184`; GitHub Actions compiler artifact id `13935780139` (no signing material).

## Exact R381 -> R383 content change
- `AndroidManifest.xml`: versionCode 381 -> 383.
- `classes18.dex`: adds privacy-filtered native-to-original-host-WebView event forwarding and automatic re-wrap if original NAVER WebViewClient changes; keeps original NAVER WebViewClient methods delegated, with hidden-bootstrap auth guard.
- `assets/web/moa-r379-auth-diag.js`: adds a receiver for native callback events and batch replay to existing *진단 복사* export; label/scope updated to R383.
- **Other 140/143 APK payload members unchanged**; in particular original **17 DEX byte-content-identical**, existing diary, gallery, voice, NAVER writer, quick record, and storage JS unchanged.

## Gates passed
- CI R383 native javac / Android D8 compile, DEX header checksum, source privacy checks: PASS.
- APK v2 RSA signature and signed APK content digest verified independently: PASS.
- Exact original certificate matched: PASS.
- ZIP CRC, stored payload alignment: PASS.
- 18/18 DEX SHA-1 + Adler-32 headers: PASS.
- Node VM in-app native event receiver test, duplicate suppression, UA/page classification and URL/secret suppression: PASS.
- AndroidManifest package/versionCode confirmed.

## Not proven
- No access to the physical Samsung Android device in this build session.
- NAVER real login, receipt challenge resolution, stable session, and real NAVER save/list readback are **NOT TESTED**; do not claim this version fixes them.
- This is a diagnostic instrumentation and narrow interference guard, **not** a CAPTCHA or account-verification bypass.
- Native WebViewClient wrapping has static code evidence but physical lifecycle regressions remain unverified.

## Safe next test
Update-install **without uninstall/data clear**. Use MOA settings `R383 네이버 로그인 네이티브 진단`, start collection, attempt first-party NAVER login, copy log once. It should now include `NAVER_NATIVE_ON_PAGE_STARTED`, `NAVER_NATIVE_SHOULD_OVERRIDE_*`, `NAVER_NATIVE_USER_AGENT_CLASS_CHANGED` where events occur. If native events are still missing, record that as R383 device FAIL instead of speculating; do not re-request empty R379 logs. Root-cause remediation requires those actual observations or other direct device evidence.
