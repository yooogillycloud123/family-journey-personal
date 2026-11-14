# MOA R580 / R581 signed deliverable — actual R578 user-video regressions (2026-11-15 KST)

## Physical truth and protected Golden
- User supplied real Galaxy `22041.mp4` (gallery photo/video transitions and rail gap) and `22042.mp4` (native Quick Record then detail/photo-calendar comparison). R578 DID NOT resolve these on-device issues; do not mark R578 PASS.
- User-approved immutable Golden stays **R567** original APK SHA256 `f205afb72744391ce9f2594f898728699870be006f787c712599a1ee8492e93c`. R580 NOT Galaxy tested.
- Important observation: in `22041.mp4` roughly 15.75–16.75s a blurred full-card video preview precedes the actual playing video, visually jolting. In `22042.mp4` photo-form is blank in tested views after a native Quick Record, even though detailed diary records persist. Date selection also varies in the captured sequence; verify **identical capture day + media ID** instead of assuming every blank day should show media.

## Source-supported failure explanations
1. R578's Web video CSS displays a full-card blurred backdrop while the native Video TextureView/MediaPlayer is still preparing; its native blurred video ambient thumbnail also decodes on a separate thread, resulting in mismatched visual transitions. Native photo host became VISIBLE and ACKed before the selected original ImageView drawable necessarily existed.
2. R578 calculated the actual filmstrip bottom but then translated ONLY railView (limited to 68dp); original lower controls' touch-hit rectangle stayed in place and type changes reset rail translation.
3. R578 hydrated `curated` IndexedDB only after a photo **day** was open, and only when its media list was empty/approximate; it did not hydrate calendar month on return and the automatic view excluded not-yet-indexed native Quick Record IDs. Detail and photo-mode therefore used different freshness/provisional-media gates.

## R580 constrained patch
- Separate feature branch: `feature/moa-r580-r578-photo-day-consistency-smooth-reveal-rail-20261115` (commit `868452f1eee4ccacee757018309db6252f65d4bf`).
- Java original-in-card native bridge only: keep native PHOTO host INVISIBLE behind existing Web static photo until ORIGINAL gallery `images[1]` drawable is ready; do not falsely call JS native-mounted ACK on blank. Existing bounded original photo `refreshPages` remains. Keep existing video engine; native ambient poster transitions from transparent to blurred only after MediaStore thumbnail is loaded; Web video pre-entering blurred preview is suppressed (sharp media thumbnail remains).
- Rail measured between actual `railView` drawn bottom and actual independent `actionDeck` top, but translates ORIGINAL `nativeLower` parent (contains touch rectangle and original children), not detached railView; bounded card safe max with reset on type change. No new buttons/listeners/renderer.
- JS calendar and photo day read ONLY existing same IndexedDB `curated`, via month-range IDBKeyRange.getAll / day.get; photo mode resolves saved photoIds/moment timestamps and preserves removedMediaIds; automatic mode includes provisional saved media until existing MediaStore catches up. No writes/new DB and no forced close of healthy native R567 gallery.
- Changed APK members relative to R578 exactly: `AndroidManifest.xml`, `assets/web/moa-r483-vertical-calendar.js`, `assets/web/moa-r483-vertical-calendar.css`, `classes18.dex`. 140/144 same. Core 17 native DEX byte-identical.

## Verifiable release
- R580 original-signer in-place-install APK `MOA_R580_PHOTO_GALLERY_RAIL_SMOOTH_ENTRY_SAME_SIGNER_BETA.apk` code **580**, 9,092,032 B, SHA256 **`11fb4e99aee51d3260988f49f84e8a98e62e10fc851f3b4941603f976c0e5cf2`**.
- R581 exact-R567-function same-signer forward recovery `MOA_R581_EXACT_R567_GOLDEN_FORWARD_RECOVERY_ORIGINAL_SIGNED.apk` code **581**, 9,069,600 B, SHA256 **`a2b6aa9b79f25623e8f0d207b808280515b66d62ca8c30c7d24daef674da526b`**; 142/143 R567 ZIP members byte-identical; only version Manifest differs.
- Identical original cert SHA256 `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`; APK v2 RSA and signed-content digest, Manifest, ZIP CRC/alignment, DEX checks PASS.
- CI SDK35 Java/D8/JS source contract **SUCCESS** [run 43649593446](https://github.com/yooogillycloud123/family-journey-personal/actions/runs/43649593446); actual-JS-function isolated Node regression tests **9/9 PASS** (MOCK, NOT Samsung on-device).
- Verified bundle `MOA_R580_R581_APK_SOURCE_QA_20261115.zip` 19,769,689 B SHA256 **`38810c627b1272436386557c98404a99ba403fb7c42f82abe8f45377c72fb544`**, private Library `/모아_프로젝트_근거_20261103/R580_R581_SIGNED_20261115/` (archive, both signed APKs), SHA256SUMS for every entry. NO private signer/password, no family video.
- **Device R580 functional QA NOT TESTED, NOT GOLDEN.** This patch is a proposed source-grounded repair, not a declaration of user-visible resolution.

## Installation and regression
- Update-install R580 over same-signer existing MOA (version <=579) **without uninstall, data/cache clear, NAVER cookie removal, or personal media deletion**.
- R581 only on severe regression to recover exact Golden R567 behavior, not for everyday installation. After R581, future code >=582.
- Real device: 3 photo entries, 3 video entries, 5 photo/video switches; inspect initial black/blur jolt, filmstrip↔8-icon physical gap and touch/scroll; native Quick Record saved on same date → detail and photo mode immediately and after full app relaunch; Back/Home/Recents, original NAVER favorite writer.
- Never edit AirPods/Android Auto daemon for MOA work.
