# GOLDEN Developer Rule — Gallery Action Registry Must Match Visible Icons (2026-11-17)

User-approved permanent requirement: **Whenever a Gallery bottom icon is added, removed, or its visibility changes, update its order/settings registry at the same time.** A release with nine actual PHOTO icons but an eight-item `아이콘 순서` editor is a FAILURE.

## Invariants / tests
1. Model the set of live actions by stable semantic ID and native View tag. Confirm the SAME semantic IDs and count appear in the user-facing order editor. Do not silently drop or replace any action with a dummy button. Preserve actual native onClick listeners.
2. Keep independent profiles and storage keys:
   - `photo_inline`: PHOTO diary main embedded native card, **9 actions** in R694 including trash; migrate R570 legacy saved 8-icon order by appending new trash rather than resetting.
   - `photo_full`: PHOTO's expanded original native Gallery, **6 actions** in R694 including cover/trash.
   - `detail_full`: DETAIL expanded original native Gallery, **6 actions** in R694 including cover/trash, independently customizable.
   - `picker`: PHOTO ADD separate original native picker Gallery, its existing **4 original action tools** in R694, independent saved order; uncommitted selection is reversible by deselection.
3. On future additions, modify BOTH native action attachment and profile-aware order preference serializer/dialog/upgrade, update the expected icon count and all QA fixtures. Ensure scope transitions do not apply one profile's saved order to another or change expanded/icon sizes. Store user ordering persistently.
4. Preserve original classes6 native gallery rendering, smooth video/seek/rail, photo zoom, GPS/Naver/favorites/capture, mute-volume behavior and QuickRecord. No relabeling a button to a nonworking substitute; never delete physical files as part of diary cleanup.
5. Test on Galaxy PHOTO/DETAIL/PHOTO ADD (open/close; fullscreen); all buttons individually; 9/6/6/4 order lists; long-press reorder, persist across reopen/process restart; existing legacy preference migration; non-destructive diary multi-remove & undo; cover-first viewing playlist; same photo's metadata & MediaStore remain intact.
6. Promote a release to Golden only after real device user confirmation; exact R683 user-accepted signed Golden remains immutable until another explicit user approval. New APK same package/cert, higher versionCode with a higher-code exact-function recovery; never uninstall/reset user data.

**Current R694 source**: `feature/moa-r694-multiselect-gallery-actions-cover-first-20261117/experiments/moa-r694/`.
**Current signed release handoff**: [R694/R695/R696](MOA_R694_MULTI_SELECT_DELETE_ICON_ORDER_COVER_FIRST_R695_R696_HANDOFF_20261117.md).
