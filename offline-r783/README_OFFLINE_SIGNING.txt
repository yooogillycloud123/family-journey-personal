# MOA R783/R784 offline recovery
Already compiled. Do not install the unsigned APKs. No key included.
1. Use personal PC with Python 3 and Java (Android Studio JBR or trusted JDK).
2. Extract this kit. Download the existing private Library backup MOA_R39_SIGNING_BACKUP_PRIVATE_KEEP.zip to Downloads (never upload to GitHub or share). Keep it private.
3. Double-click SIGN_R783_WINDOWS.cmd (or python SIGN_R783.py). Choose original backup if prompted and enter original password privately. The original backup/key digests are pinned; official SDK signer verifies v2/cert and exact payload.
4. The signed/ folder contains the only two files to upload, MOA_R783_ORIGINAL_SIGNED.apk and MOA_R784_ORIGINAL_SIGNED.apk. On the personal PC with authenticated Git, run SIGN_R783_WINDOWS.cmd --stage-only (or python SIGN_R783.py --stage-only). Alternatively upload exactly both APKs into signed/ on branch release/moa-r783-signing-stage-20261128 (same commit recommended). No key, zip, password, or other file may be uploaded.
5. GitHub CI independently verifies original signer, exact R783/R784 payloads, version, 27 DEX, alignment and R781 base. Only if both pass and current channel is still R781, archives R784 separately and atomically publishes R783; then verifies exact public URL/nonce/immutable plus full APK download. Until this succeeds, R781 stays latest.
6. Do not uninstall, clear data or install R784 unless recovery required. Device AI behavior and elapsed time still need physical QA.
Existing build run 46126415194, artifact 15255504979. No rebuild necessary.