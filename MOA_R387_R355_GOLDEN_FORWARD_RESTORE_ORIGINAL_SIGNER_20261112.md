# MOA R387 — exact R355 functional GOLDEN forward restore (2026-11-12)

## Explicit user choice
User rejected the R383 failed NAVER login diagnostic and explicitly selected **R355 functional Golden** for recovery. User required a higher-version same-package original-signer APK preserving all Golden functional contents and existing MOA data, no uninstall.

## Real, locally cryptographically signed artifact
- APK: `MOA_R387_FORWARD_RESTORE_R355_GOLDEN_SIGNED.apk` **8,907,064 bytes**
- SHA-256: **`96bd015ff404ecd923cbc710e4f4bbb583b8d4b6b187890160bbd15bdd96ffca`**
- `com.juhyeon.familyjournea`, **versionCode 387** (> user installed code383, > R385 emergency)
- Original signer certificate SHA-256: `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`
- Original `versionName` untouched: `MOA-R111-Icon-Themes`. Only the native Manifest typed **versionCode** is updated.
- Original key/password fetched from user's private Library and verified locally; not published or included in the deliverables.

## Exact Goldens and bytewise checks
- Source: **literal immutable R345 user-device Golden** extracted from original Library release ZIP SHA-256 `cd63e8367c825be8fecd6738d0cb3cd1938f7d1025b9a450f4679fde07cda6ef`; APK SHA256 `fe2aaaac15d39a610268ee3d10361652a95537e0ce8ec9cde86e98edf3f8ceb1`.
- Historical R355 was a **manifest-only** exact R345 Golden functional restore, source recorded code355 SHA `e499ed03b59b1efc9ff85aa8bbaf442d214ddea3f6812d871c93bf584802be6a`.
- **Independent second binary comparison** using the user's preserved **exact R371 forward R355 functional recovery**, SHA256 `5ed6a361ca9903c1ab9c01c924c36e582416f7cdec0e92ac650f8f03c6f51641`, verifies:
  - **137/138 archive members byte-content-identical** R345↔R387 **and** R371↔R387.
  - The sole different file is `AndroidManifest.xml`; it equals R371 manifest with a **single typed versionCode 371→387** substitution, byte-for-byte elsewhere.
  - Original **all 16 DEX** and all account-write/Diary/Gallery/Voice/QuickRecord assets exactly preserved.
- App binary AXML independently decoded: package exact, versionCode 387, versionName original.
- Local cryptographic **APK v2 signer signature, chunked APK content digest, RSA SPKI/cert, ZIP CRC, stored entry 4-byte alignment, all 16 DEX SHA1+Adler32** PASS.
- APK same-binary ZIP backup `MOA_R387_R355_GOLDEN_RESTORE_APK_QA_BACKUP.zip`, SHA-256 `d3b8830e244badd277aa1e4296f0efe9f959700d85120175cc744ca9f1624c0f`, CRC PASS, includes same exact APK, QA JSON, Korean README, SHA sum.
- QA file `MOA_R387_R355_GOLDEN_RESTORE_QA.json`.

## Persistence / deliverables
All three original-signer APK, ZIP backup and QA were uploaded successfully to **private Library**:
`/모아_프로젝트_근거_20261103/R387_R355_RESTORE_20261112/`.
No private signing material in public GitHub or release bundle.

## Scope and device status
- R387 **removes R357–R383 experimental add-ons** by restoring exact R345/R355 functional Golden archive; this is intentional user choice, not a merged feature APK.
- User must **update install over installed MOA**, without uninstall, data/cache/cookie deletion. Same package/cert + increasing code means regular Android update should preserve app data.
- Physical Galaxy install, fresh NAVER login/re-auth and new account saves **NOT RUN** in this session. The R345 successful account save record was with existing authenticated session, so fresh login receipt challenge resolution is **NOT CLAIMED**.
- Old R345/R355/R371 signed binaries/frozen Goldens remain immutable. Next candidate code must be **>387**. Do not touch AirPods project.
