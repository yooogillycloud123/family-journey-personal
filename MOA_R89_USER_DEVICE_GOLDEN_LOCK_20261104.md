# MOA R89 — USER DEVICE GOLDEN LOCK / READ FIRST (2026-11-04)

## NEW CURRENT GOLDEN STATUS — USER CONFIRMED
The user explicitly confirmed **"오케이 일단 성공 골든버전으로 저장하고 이걸 기반으로 확장하는 방향으로 가자"** on 2026-11-04 immediately after sharing four Samsung Galaxy screenshots `18777.png`, `18779.png`, `18781.png`, `18783.png`.

This supersedes the earlier R89 **PHYSICAL UNTESTED** language in `MOA_R89_R87_CLEAR_NATIVE_MEMO_IME_FINAL_HANDOFF_20261104.md` **for the features visible and confirmed in these screenshots**. Previous R83 native diary speech Golden and R63 direct IndexedDB writer Golden remain protected historical components, not replaced or downgraded.

### Verified observed features and boundaries
- `18777.png`: with Samsung IME **open**, the native photo memo screen shows **mic**, **내용 전체 지우기**, and **모아 일기에 메모 저장** clearly above the keyboard; recognized speech text is present.
- `18779.png`: user typed additional Korean text with Samsung IME open; all three controls stay visible.
- `18781.png`: Android confirmation dialog for **현재 메모 글자 모두 지우기** is shown with **취소** and **모두 지우기**, explains clearing only the current input and preserving other records and originals.
- `18783.png`: Samsung camera displays `메모 임시 저장 완료 · 모아 일기 동기화 대기`. This establishes a native temporary-save acknowledgment, **NOT independent proof that this exact R89 capture has completed final IndexedDB synchronization**. R63's earlier real-device photo/diary save Golden is separately protected.
- User explicitly confirmed current R89 as success. Do **not** rewrite or re-test already passed screen behavior needlessly. Do **not** infer landscape/alternate keyboard/edge-cases tested.

## Frozen exact release artifact
- Name: **MOA R89 USER DEVICE GOLDEN**; original installed delivery name `MOA_R89_NATIVE_MEMO_CLEAR_IME_FINAL_Install.apk`.
- Exact frozen private copy `MOA_R89_USER_DEVICE_GOLDEN_20261104_DO_NOT_MODIFY.apk`, **3,491,886 bytes**.
- SHA-256: **`2b52826fc0dd8653a70d3c503d3654ae33071bfc4ec075753ec4464a1e2dc493`** (verified from the actual local APK bytes and private Library copy).
- Package: `com.juhyeon.familyjournea`; versionCode **89**, versionName `MOA-R89-Safe-Capture`; public signing cert SHA256 `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`.
- Private Library folder: `/모아_프로젝트_근거_20261103/`. New frozen files: `MOA_R89_USER_DEVICE_GOLDEN_20261104_DO_NOT_MODIFY.apk`, `MOA_R89_USER_DEVICE_GOLDEN_LOCK_MANIFEST_20261104.json`; original R89 no-key source/verification ZIP and R89 base APK already retained.
- Immutable code/source reference branch: `golden/moa-r89-20261104-user-device-pass-do-not-modify`; parent `release/moa-r89-native-memo-keyboard-clear`. Frozen branch is a source anchor; **actual exact runnable baseline is the private SHA-256-verified signed APK** (source branch alone is not a copy of the signed APK).
- Compiled DEX GitHub Actions: **41819061843 SUCCESS**; R89 signed APK v2, ZIP CRC, manifest, DEX static checks **PASS**.
- R87→R89 member diff independently rechecked using the actual two APKs: 55 ZIP entries, ONLY **`AndroidManifest.xml`** (version) and **`classes4.dex`** (native capture memo UI) changed; **53 unchanged**, including the previously physically successful R87 whole-field-clear `assets/web/family-diary.js`, original native launcher class in `classes2.dex`, original IDB `assets/web/moa-direct-diary-commit.html`, and unrelated photos/maps/OHO assets.
- Preserve exact frozen R89 bytes; do not repack, patch, resign or overwrite this APK or the protected branch.

## Ready-to-use next-work branch (no code changes yet)
- NEW working branch: `develop/moa-from-r89-golden-next`, created directly from the frozen R89 Golden source anchor. Implement future features here or on a feature branch based on it, NEVER on the frozen Gold branch.
- The exact signed APK snapshot remains private Library's SHA256-verified R89; new compilation must reproduce protected behavior and compare original members before release code >=91.

## Nonnegotiable future expansion rules
1. Before work, read the AA project canonical as instructed, then this R89 Golden lock, the R83 native speech Golden lock and R89 original handoff; check current private Library and runtime checkpoint first.
2. **Start each new experiment on a NEW branch from the R89 Golden anchor** and package it as a new code **>=91**. R90 was already issued as a rollback-forward to older R87 behavior (it lacks the R89 keyboard/clear improvements). R90 is **NOT** a Golden replacement. Never silently revert to R83/R87/R90 for new features.
3. Keep: R89 IME keyboard-aware toolbar, mic/clear/save, confirmed clear dialogue; R87 diary title/body/5-minute group clear; R85 title auto-grow; R83 exact native STT WebView bridge; R63 direct per-photo timestamp/ID/memo to IndexedDB + ACK; photo thumbnails, camera notifications, OHO, navigation and maps. No data migration or user-data wipe.
4. **Small reversible diffs only**; verify package, signer, APK v2, manifest, DEX, ZIP CRC, protected-member hash and regression tests. Voice recognition accuracy improvements remain **ON HOLD** until explicitly requested; never silently replace the current provider or transmit recordings.
5. A new APK is **BETA** until the new behavior is shown working on the Galaxy; only then promote its exact SHA-256 and screenshots to Golden. Keep R89 untouched as an always-available signed rollback reference; for Android downgrade restrictions, prepare separate higher-code rollback-forward when needed.
6. No extra helper app, uninstallation, clear storage, signing key rotation, original photo deletion, unrelated AirPods app modifications or unverified assertions about device success.

## Read-first references
- Current: `MOA_R89_USER_DEVICE_GOLDEN_LOCK_20261104.md` (**this file**)
- Technical R89: `MOA_R89_R87_CLEAR_NATIVE_MEMO_IME_FINAL_HANDOFF_20261104.md` (historical status now updated by this Gold proof)
- Voice Golden: `MOA_R83_USER_DEVICE_GOLDEN_LOCK_20261104.md`
- R85 title: `MOA_R85_R83_GOLDEN_TITLE_AUTOGROW_AND_STT_ACCURACY_PLAN_20261104.md`
- Original saved-data Golden: `MOA_R63_USER_DEVICE_GOLDEN_LOCK_20261103.md`
