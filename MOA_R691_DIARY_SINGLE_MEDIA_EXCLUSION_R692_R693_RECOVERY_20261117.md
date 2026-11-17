# MOA R691 — photo/video ONE-item diary exclusion (Golden preservation, 2026-11-17)

## User request and exact implementation
The user noticed that photos and videos may be ADDED to the diary, but there is no obvious REMOVE action in the PHOTO view despite an existing DETAIL view one-item management flow. They require an icon-only **trash bin in the PHOTO bottom action deck**, while preserving all other functions.

**Deletion semantics are deliberately DIARY-ONLY**: exclude the selected photo/video MediaStore ID from the selected day via the ORIGINAL IndexedDB `familyjourney-diary-v1` record; keep physical Gallery MediaStore photo/video untouched. Existing attached diary `moments`, text, voice, location, Naver, QuickRecord and other media IDs remain. The pre-existing DETAIL `removedMediaIds` / `restoreOneDiaryMedia` system is reused as the compatible tombstone/undo schema. Pending photo-picker selections are already removable by unselecting before committing.

## Exact sources and Golden
- Immutable user-physically-approved **R683 Golden**, SHA256 `e20e446d5e02358e833fe223471735abc3fd042234b4efc53acc208118ee9e8b`, preserved.
- User explicitly rolled back an unacceptable R687 release to R688. Later narrow **R689 VIDEO-only signed BETA** was delivered and replied to with “오케이”; no explicit hardware completion claim was supplied. R691 branches from **R689 functional APK** (which itself preserved original R683 media/gallery engine) to retain the recent same-day video/mute and Story work. Do not claim R689/R691 physical pass until user tests.
- Package `com.juhyeon.familyjournea`; original signer certificate SHA256 `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`.
- R691 original signed `MOA_R691_R689_GOLDEN_DIARY_MEDIA_REMOVE_ORIGINAL_SIGNED_BETA.apk`, versionCode 691 versionName `MOA-R691-DIARY-BETA1`, SHA256 **`acc49b750abce8e0a6d54a0ef198fc3ff38d671e545044dc74da82b1cf8a20b9`**, 9,716,837 bytes.
- R692 original signed `MOA_R692_EXACT_R689_FUNCTIONAL_RECOVERY_ORIGINAL_SIGNED.apk`, versionCode 692 SHA256 **`2486afa7f9bf1ee25bbe066dbbb8ab52b9a902b4e976d38d4cc3b3e285bdb5dd`**, exact R689 ZIP payloads except Manifest code/name.
- R693 original signed `MOA_R693_EXACT_R688_GOLDEN_FUNCTIONAL_RECOVERY_ORIGINAL_SIGNED.apk`, versionCode 693 SHA256 **`ee25ad207c54a7e598defdf43cbef2a6e629a85f1822e4661c8a74feeffdb380`**, exact R688 (R683 functional) ZIP payloads except Manifest code/name.
- **If R693 installed**, subsequent release code>=694. If R692 installed, subsequent release code>=693. User must NEVER uninstall app, clear IndexedDB, cookies, account data or native MediaStore.

## Precisely changed files (R689 → R691)
R689 APK 163 existing entries; **159/163 byte-exact**. Changes only:
1. `AndroidManifest.xml`: code/name.
2. `assets/web/index.html`: current `moa-r683-vertical-calendar.js` script URL replaced by versioned `moa-r691-vertical-calendar.js`.
3. `classes17.dex`: original R689 native Gallery footer class, with one EXTRA fifth trash glyph button **only when original inline Gallery is physically mounted in a small PHOTO diary card**. On fullscreen Gallery the trash is GONE and original 4 buttons retain their layout. Same existing original MediaPlayer/player/volume, Share/GPS/Info/Fast actions.
4. `classes19.dex`: same-length Settings version string R689→R691 (metadata only; exact native picker Activity unchanged).
New `assets/web/moa-r691-vertical-calendar.js`: original R683 diary JS plus minimal new `r691ExcludeMedia(day,id)`, existing WebView fallback PHOTO footer trash icon, and native callback `window.__moaR691RemoveDiaryMedia(day,id)`. No new database/table, no MediaStore file delete.
**Original native Gallery media classes6.dex and ALL other DEX, PHOTO css/story CSS/JS, Naver/QR, settings, record wizard, bottom tab navigation and account handling remain byte-identical to R689**. R687's rejected cross-tab or settings changes are not included.

## Safeguards / testing evidence
- Native PHOTO trash icon uses a small original canvas-based vector; bottom 5-action layout only for short card host; actual fullscreen original retains 4 actions.
- Native callback reads the **REAL Gallery's current `ids[index]` and `currentDay`** (not a stale web tile index). URL origin `https://familyjourney.local/` is validated; media ID/day formats verified; WebView handler rejects stale day/current media mismatch, dirty unsaved text and duplicate requests.
- Confirm explicitly asks to exclude one photo/video from diary only, retaining original gallery file and content. IndexedDB read-modify-write updates only `photoIds`, `removedMediaIds` and `updatedAt` of the selected original diary record, leaves `moments/body/activities` unchanged. If removed item is the day's cover, cover metadata entry is removed.
- JS stores a per-media tombstone; both PHOTO and DETAIL use existing excluded-media semantics. Existing DETAIL edit > media manager can restore.
- Recompile **exact original released R689 classes17.dex** with same GitHub javac --release8 + Android SDK35 D8: verified SHA256 `166998fe71e2797bc73d1a1c5415a029fcb1b8287e9cff457ea8ca959ad5ed8e`; compile new added native Java: PASS in [CI run 44081241694](https://github.com/yooogillycloud123/family-journey-personal/actions/runs/44081241694). SOURCE at [isolated R691 feature branch](https://github.com/yooogillycloud123/family-journey-personal/tree/feature/moa-r691-diary-media-exclude-20261117/experiments/moa-r691).
- Local Node/VM isolated data-store mock: curated photo/video, automatic video removal, no moment/body/other photo deletion, stale/invalid ID rejection, unsaved text guard PASS. **Not a real device test or full integrated IndexedDB browser test**.
- `node --check` source JS PASS. Official Android SDK35 aapt/aapt2/apksigner/zipalign PASS for R691/R692/R693, original signer/cert and APK v2 full contents PASS.
- **Galaxy physical: UNTESTED**. Need verify trash appears ONLY in embedded PHOTO native footer, confirm one ID, original photo/video remains in device Gallery, DETAIL undo, original gallery after update opens and plays, original volume popup, QuickRecord/Naver unaffected.

## Release install choices
1. Install **R691 over existing R689/R690** by update without uninstall; it has higher versionCode.
2. If new delete button breaks playback or gallery, install **R692** to restore exact R689 functional payload.
3. If the user prefers previously accepted Golden functionality instead, install **R693** to restore exact R688/R683 functionality (without R689 video fixes).
4. If R693 is installed, next code must be >=694; same signer/package. Never auto-rollback or reset any app data.
5. New-chat must first read `MOA_READ_FIRST_NEW_CHAT.md`, this document, R689 handoff, and R683 physical Golden lock; do not edit original Golden APK or any AA AirPods project source.

## Native behavior nuance
This scoped Android feature needs physical verification of the original Gallery host geometry (inline when host height significantly smaller than the Activity). The native trash icon is not shown in fullscreen on purpose; the existing DETAIL media management still supports re-adding/undo. **Do not overclaim Golden pass before phone testing.**
