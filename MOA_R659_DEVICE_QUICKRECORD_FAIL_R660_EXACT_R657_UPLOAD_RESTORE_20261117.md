# R659 QuickRecord failed on Galaxy; R660 from exact user-uploaded R657 original — 2026-11-17

## New physical evidence
User confirms the R659 emergency forward recovery (derived from R657) fails QuickRecord on real Galaxy after R658 broke PHOTO inline Gallery. Mark R659 PHYSICAL FAIL for QuickRecord. R658 also PHYSICAL FAIL. Neither is a Golden.
User re-uploaded exact previously successful R657 APK, SHA256 f8c0e460ecacc7ab6d5a9a7c41dcee5e6fa8f25c94554c446c814ec983d6861a. User explicitly asks restore from this file.

## R660 generated actual APK
File MOA_R660_EXACT_UPLOADED_R657_BINARY_FORWARD_SIGNED.apk, 9,124,042 bytes, SHA256 d8ce843fe812838443e3265f866f17a6ac2641fa314161fde7967700492feea1, versionCode 660, same original signing cert SHA256 5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15.
Generated directly from the newly user-uploaded R657 bytes. Unlike former full ZIP reconstruction, preserve exact ZIP entry order, data positions, all compression streams except AndroidManifest.xml, local and central headers apart from manifest CRC, same-sized v2 signature block. Update only decompressed AndroidManifest.xml versionCode 657 to 660, its matching DEFLATE stream of same size, ZIP CRCs, and re-sign original RSA-SHA256 APK v2 block using original private signer (never uploaded or published).
Strong signature check: regenerating the v2 block from original R657 produced byte-for-byte original signature block. New R660 independently verifies Android v2 whole-APK SHA-256 chunk digest and certificate signature, ZIP CRC and alignment PASS. 143 of 144 decompressed ZIP entries unchanged; all 18 of 18 DEX and all Web/Java/native QuickRecord/Gallery assets unchanged.

## Crucial limitation
R659 was already functional-byte-exact R657 except versionCode, and a raw byte comparison showed it also very closely matched original binary (same size, original manifest+signature differences only). Therefore R660 is NOT proven to fix the root cause of R659 QuickRecord failing. Android post-update/device or external One Hand Operation+ state may matter, but NO causation proven. R660 must be physically tested; if it fails, do NOT keep emitting manifest-only version bumps; request new device journal/observed steps, check actual Android shortcut/Activity lifecycle and One Hand OFF→ON context. No uninstall, app data wipe, Naver reset, or changes to AA AirPods audio.
Do not promote R660 to Golden until user confirms actual QuickRecord and original Gallery. The user-confirmed baseline remains the exact original R657.

## Future version
If user installs R660, further updates must have versionCode >660; keep exact R657 APK immutable; never mistake source-only R657 Java bounded-processing candidate for actual R657 APK.