# MOA R705 — fullscreen Gallery first/last instant jump / R703 preservation (2026-11-21)

## Real status: SOURCE + isolated DEX17 built, ORIGINAL-SIGNED INSTALLABLE APK NOT BUILT

**User request**: In the full-screen native Gallery with thousands of mixed photos/videos, add **first** and **last** single-tap vector symbols. Preserve all actual R703 features, including synchronized OneUI media volume, zero-volume glyph and GPS auto Map refresh, and existing native Gallery, video, thumbnail rails, Naver, diary, data and preferences. No uninstall/reset, no new app/package.

**R705 code is a small isolated additive native change**. Branch: [feature/moa-r705-r703-native-gallery-first-last-20261121](https://github.com/yooogillycloud123/family-journey-personal/tree/feature/moa-r705-r703-native-gallery-first-last-20261121). Source commit `044e4717be0b9f49ed028119fc167a6198e73b45`; final CI config commit `db53a2d109f253212c857bf70d34db0bb1fde394`.

**Actual successful CI** [Run 44829536544](https://github.com/yooogillycloud123/family-journey-personal/actions/runs/44829536544) **SUCCESS**. Android SDK35, JDK17 `javac --release 8`, D8 -> **valid 103,188-byte classes17.dex**, DEX SHA256 `1df6dff3ac34c80449bf38271d8f8b5815361cc4603ab4dc2660fc1c182b208b`, SHA1 and Adler checks PASS; static source preservation PASS; artifact **MOA-R705-GALLERY-FIRST-LAST-DEX17-SDK35-QA** ID `14675737527`. Initial CI run 44829306446 FAILED only due wrongly escaped Python DEX-magic literal, even though native javac/D8 compiled successfully; corrected in later successful run.

### Exact implementation

Updated **only one source file**, `experiments/moa-r697/MoaR391SessionPersistProvider.java` on R705 branch derived from exact R703 source. This **does not modify** historical R703 source branch, signed R703 release, the original `classes6.dex` Gallery engine or `classes18.dex` PHOTO host.

- In full-screen PHOTO and full-screen DETAIL bottom native capsule, add vector **|≪ (first)** and **≫| (last)** as separate clickable controls (tag `moa.gallery.action.first.r705`, `moa.gallery.action.last.r705`). They are **hidden in inline PHOTO** and PHOTO ADD picker remains unchanged.
- `r705JumpBoundary` validates Gallery open, active fullscreen profile, original MediaStore-derived playlist `ids`, legal `index`, and calls **the already existing private R203 Gallery method** `r203ReleaseWithVelocity((float)target, 0f, 1f)`. In its integer/zero-velocity path this directly presents the target index, refreshes three visible pages, centers the same thumbnail rail, and prepares only the final video, without iterating through thousands of images.
- Existing first/last disable at their respective bounds; disabled vector state reflects this; no fake jumps or alternative browser viewer.
- Fullscreen action registry goes **6 -> 8**, PHOTO inline stays **9**, PHOTO ADD stays **4**. `r694Actions` / `r694ApplyOrder` / `r694OrderDialog` maintain profile-aware existing long-press reordering. Legacy saved six-icon orders remain internally ordered and gain two edge icons at the ends; new eight-icon custom ordering persists.
- Existing `r701ApplyGalaxyVolumeUnified`, `r703SyncEffectiveSilenceGlyph`, R703 native `r703MapCheck`, original 4th fast-stage action, R697 native multi-remove and PHOTO cover are retained. No WebView, diary, cookies, GPS, MediaStore delete, volume, camera, AA or other subsystem changes.

### Blocker — MUST NOT FALSELY REPORT AN APK

The local `container.exec`, `python.exec` and `python_user_visible.exec` tools persistently return `ClientError` even for basic no-op commands (2026-11-21). This prevents fetching private R703 APK and R39 signing key into a trusted local process, minimally replacing the compiled classes17.dex, bumping manifest versionCode and original-signer signing. The **signer is known to exist** in PRIVATE Library `/모아_프로젝트_근거_20261103/PRIVATE_SIGNERS/MOA_R39_SIGNING_BACKUP_PRIVATE_KEEP.zip`, password only in private registry; do NOT ask user to re-provide it and do NOT publish or send secret to GitHub Actions. R703 actual signed APK is in private Library `/모아_프로젝트_근거_20261103/R703_R704_R701_BASELINE_20261120/`.

**No original-signed R705.apk, no R706 recovery APK, and no signed APK static or Galaxy physical verification exist yet.** Isolated DEX compilation does not equal a deliverable APK. If local execution resumes, perform the following WITHOUT redoing native implementation:

1. Materialize exact original-signed R703 APK (code703, SHA256 `5cd3d68c4485a739869daa8b64152c9945232656a9171365ec2a42442744827b`) and private R39 original signer from private Library. Verify cert `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`.
2. Obtain exact isolated DEX17 from **successful CI run 44829536544** artifact. Independently check SHA `1df6dff3ac34c80449bf38271d8f8b5815361cc4603ab4dc2660fc1c182b208b`.
3. Patch **only `classes17.dex` + `AndroidManifest.xml` versionCode 705** onto R703, retain all other R703 original entry payloads and alignment; do not modify app.js/native.js or any R703 GPS/volume code/assets, Gallery classes6, PHOTO host classes18. VersionName and manifest metadata should follow original package convention.
4. Sign APK locally with the same private original R39 key (never in public CI/repo). Validate true APKv2 RSA+content digest, cert match, ZIP CRC/alignment, DEX SHA/Adler, package `com.juhyeon.familyjournea`, versionCode705 and member diff: expected **165/167 unchanged R703 files**.
5. Make **R706 exact R703-functional** forward-recovery, versionCode706, only manifest different from R703 (expect 166/167 unchanged), same original signer/package. This preserves R703 Map+volume fixes rather than reverting to R701; never uninstall or clear data.
6. Pack actual 2 APK binaries and QA/source diff in a ZIP, archive all in private Library and hand user actual sandbox download links. Test PHOTO-full and DETAIL-full with thousands of photos, one item, video last, endpoint disabled, original thumbnail sync, 8-icon order customization, PHOTO inline 9-icon unchanged, PHOTO ADD 4-icon unchanged, gallery video sound, GPS map auto refresh, native multi-remove. Only physical user PASS can promote R705 to Golden.

**Do not install DEX or source as if it were an APK.** The previously delivered R703 remains untouched/user-installed baseline until a complete signed update is verified. AA AirPods project completely untouched.
