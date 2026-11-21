# MOA R707 / R708 — Native Map Gallery first/last + live installed version (2026-11-21)

## STATUS — ACTUALLY BUILT AND ORIGINAL-SIGNED

**Installable APK binaries and QA/source ZIP have been created, independently verified, and archived in PRIVATE PERSONAL LIBRARY.** This supersedes R707's earlier Work screenshot of an unfinished DEX comparison stage. User-device installation and physical functionality are **NOT YET VERIFIED**, so do not promote R707 to user Golden.

Private Library:
`/모아_프로젝트_근거_20261103/R707_R708_MAP_GALLERY_SOURCE_QA_20261121/`

| Artifact | VersionCode | Exact SHA-256 | Bytes |
| --- | ---: | --- | ---: |
| `MOA_R707_R705_MAP_GALLERY_FIRST_LAST_REAL_VERSION_ORIGINAL_SIGNED_BETA.apk` | 707 | `b72856150410491b87cd01c3ecbe1a3178e2d1a6488fdf4494d06afcf50fb200` | 9823805 |
| `MOA_R708_EXACT_R705_FUNCTIONAL_ORIGINAL_SIGNED_RECOVERY.apk` | 708 | `cb85d0cffb721d4a937960964ea638d4f98b7b6d0cc3519909ba91b33e565c15` | 9820725 |
| `MOA_R707_R708_ORIGINAL_SIGNED_MAP_GALLERY_SOURCE_QA_20261121.zip` | n/a | `9f772a52617aa28e25a3b0693303c9ff0000ce4c28610866817e2e518a9a103a` | 21815169 |

R707 exact baseline: the *ACTUALLY SIGNED R705 APK* versionCode705 sha256 `97001d02495cf8c9c01597bcc30be59bf933a97d4b9f0c360397631fd7dc52ae`, not the older unmodified R703.

Original package: `com.juhyeon.familyjournea`. Original signing certificate SHA-256 `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`.

## Changes and source provenance

1. R705's PHOTO/DETAIL native fullscreen first/last buttons preserved.
2. R707 **My Map native Gallery** now displays its own first/last buttons via `map_full` action profile; excludes diary-only cover/trash from MAP profile, while PHOTO/DETAIL fullscreen keep 8 icons, PHOTO inline 9, PHOTO ADD picker 4.
3. Java native `r707CheckProfile` and `r705JumpBoundary` use existing Gallery `r203ReleaseWithVelocity(FFF)V` for an in-window target, and an origin-safe JS Map adapter `window.__moaR707MapGallery` for actual first/last across the **10,000-photo native window**. The adapter preserves original `mapR211OpenNative` media ID normalization and map order; it checks exact playlist count + endpoints, rejects old tokens, leaves non-Map gallery untouched, never deletes photos or resets WebView.
4. Settings' existing `r681VersionInSettings` falls back to `MoaR667NativePicker.version()`. Work R707 native `Bridge.version()` now reads actual PackageManager versionCode instead of a historical hardcoded R697 label. APK Manifest code707. Existing versionName field is preserved for install compatibility; versionCode is authoritative.
5. GitHub Work source branch: `feature/moa-r707-map-gallery-installed-version-20261121`, commit `d3a5668b58574d1e68a702f2a1d820edfcdbb0a0`. Official GitHub Actions Android SDK35 javac/D8 run **44859057941 SUCCESS**. ZIP artifact `MOA-R707-SDK35-native` ID `14688577921`: `classes17.dex` SHA256 `a3091b8896c2547bd3a2a9702cf3ade951cb4f8a71af313902499d582d157250` and `classes19.dex` SHA256 `96a464993e2d4e02cdcc9cd1d39f5cb936a46ce3f143bf07e39933d760a28966`, byte-identical to signed R707 APK. **The extra R707 Web JS adapter was added directly against actual installed R705 `assets/web/app.js`; the full updated script and unified diff are in the private QA ZIP**. Do not assume Work's Java-only branch contained this missing JS.
6. R707 vs exact R705: 163/167 APK member payloads, compressed bytes and complete local ZIP records identical. ONLY `AndroidManifest.xml`, `assets/web/app.js`, `classes17.dex`, `classes19.dex` changed. R708 vs R705: 166/167 identical; ONLY Manifest versionCode changed. In both, unchanged original `classes6.dex` native Gallery engine, `classes18.dex` PHOTO owner, `assets/web/native.js`, all diary/Naver/Audio/GPS assets preserved.

## Verification and limitations

PASS: both APK RSA PKCS#1 v1.5 SHA-256 signature and full APKv2 content digest independently verified, exact original cert, package + versionCode + minSDK29/targetSDK35, 167 ZIP CRCs, 49 STORED entry 4-byte alignment, 19 DEX SHA1+Adler32+SHA256, unchanged member compressed data and local record hashes, exactly one version-code byte in Manifest. CI SDK35 native compile PASS. New `app.js` `node --check` PASS. Node contract test PASS for 10,001 mixed photos/videos, both window-edge reopens, stale token isolation, video ID normalization, no-GPS fallback.

NOT DONE: Samsung Galaxy S26 Ultra real physical installation, real Map overlay, onehand gesture/volume output, zoom/thumbnail sync and persistence with personal data. This release is **BETA**, not Golden. No complete Android SDK CLI apksigner binary was independently available in the local assembly environment; APKv2 RSA and full digest were independently cryptographically checked instead.

**Install:** update-install R707 without uninstall, data reset, Naver logout or deleting photos. Test existing PHOTO/DETAIL fullscreen first and last, My Map fullscreen first and last including a large map-region window, Settings version, OneUI volume and zero mute glyph, incremental GPS map updates, PHOTO inline/picker icon ordering and diary multi-remove. On failure update-install **R708** (version 708 >707) which restores EXACT R705 functionality, including prior PHOTO/DETAIL first/last feature. R706 is a lower-version R703 functional recovery and cannot update-install over R707. Future versionCode must be **>=709** if R708 was installed.

**Signers/private credentials:** key used only in trusted local process from private Library `PRIVATE_SIGNERS/MOA_R39_SIGNING_BACKUP_PRIVATE_KEEP.zip`. Neither key nor password was included in public GitHub/CI/QA ZIP. Independent AA AirPods code/runtime unchanged.
