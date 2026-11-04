# R73 fast curated-diary calendar / deletion-safe media reconciliation

**Actual compiled APK and full reproducible Python patch script are stored in the private Library, not committed into the old AndroidHost source branch as an unverified recomputation of the huge signed HostActivity classes2 DEX.**

- Exact R72 base APK sha256 `974667456d09ebf43053de9039a4431df751defbae08b4b89da1604bc6b9dd76`.
- R73 same signer signed apk sha256 `34efac2a395c6c21a615b5367ac1101523c36c5732133701217870a06cbe07a1`.
- Library `/모아_프로젝트_근거_20261103/MOA_R73_FAST_SAFE_DIARY_SYNC_BETA.apk`.
- Library `/모아_프로젝트_근거_20261103/MOA_R73_FAST_SAFE_Source_Verification_NoKeys.zip`: includes actual exact binary-applied JS, source patch script, mock gallery deletion tests and hashes.
- Latest release-read-first: `main/MOA_R73_FAST_SAFE_SELECTED_DIARY_SYNC_READ_FIRST_20261104.md`.
- Changed signed APK entries only `AndroidManifest.xml` version and `assets/web/family-diary.js`. **All 53 other ZIP entries byte-for-byte identical**, including R63 direct writer and all DEX.
- Newly inserted code provides `R73.fast` ephemeral map from R63 already committed `curated` photoIds and original moment capture ms, only for selected diaries. Never saved to `meta`, photo-index or `curated`.
- Original R72 full native MediaStore scan remains and removes cached preview from the selected diary when a gallery original is verified absent. Original written notes are retained in a missing-media section. User's intentional excludedMediaId is respected. Safety cutoff protects files captured during a scan.
- **DO NOT pretend Android native delta-indexing is implemented**. Future Stage B needs separate source-DEX parity tests and generation/permission/deletion invalidation handling.
- Samsung real-device latency and regression: NOT YET CHECKED; only static+mock tests PASS.
