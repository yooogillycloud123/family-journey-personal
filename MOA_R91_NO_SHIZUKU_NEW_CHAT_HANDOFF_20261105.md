# MOA R91 — NEW CHAT READ FIRST — NO SHIZUKU NAVER AUTO-RETURN / HIDDEN WEB EXPERIMENT (2026-11-05)

## 0. Non-negotiable user instructions
- Continue MOA app; **no Shizuku, root, persistent external helper, or routine ADB requirement**. No extra installed helper app in final.
- **Priority A (near term):** existing user-initiated NAVER Maps favorites save should return to originating MOA screen automatically after the genuine saved-place confirmation. Do not require user to manually close NAVER. A SAVE button click by itself is not success.
- **Priority B:** explore TRUE hidden operation while the user continues using other apps, via **our own Android VirtualDisplay + Presentation + WebView of NAVER mobile WEB**. Do NOT describe this as launching the native NAVER APK on a privileged virtual display; that route needs privileges beyond an ordinary app. Hidden NAVER web bookmarks remain UNPROVEN, including login, background WebView, and web write UI.
- No goal substitution to a merely auto-return solution: keep both tracks distinct.
- Preserve all previously working R89 MOA behavior. Do not overwrite the original Golden branch or APK; produce an in-place update only, with original package/signature and versionCode >=91. DO NOT UNINSTALL OR CLEAR DATA.
- Do not repeatedly describe generic blocks/issues. If tool/build step fails, inspect actual CI log and attempt a specific targeted fix. Label CI PASS separately from device PASS.
- User wants installable APK after implementation, minimal explanation, no further Shizuku test app.

## 1. First read (project-wide and app-specific)
1. GitHub `yooogillycloud123/workexcel-devbridge` `main/AA_AirPods_FINAL_READ_FIRST_v1.0_20261005.md` entire file (only because project instructions require it; NEVER modify AirPods behavior while fixing MOA).
2. Files/Library `/에어팟안드로이드/AA_AirPods_READ_FIRST_NEW_CHAT.txt` and `/에어팟안드로이드/AA_AirPods_MASTER_HANDOFF_v3.3_20260928.md` entire files as required.
3. MOA repository `yooogillycloud123/family-journey-personal` `main/MOA_R89_USER_DEVICE_GOLDEN_LOCK_20261104.md`, `main/MOA_R89_NAVER_HIDDEN_VIRTUAL_DISPLAY_RESEARCH_20261104.md`, `main/MOA_R89_R87_CLEAR_NATIVE_MEMO_IME_FINAL_HANDOFF_20261104.md`, `main/MOA_R83_USER_DEVICE_GOLDEN_LOCK_20261104.md`, and THIS file.
4. Check GitHub work branch `feature/moa-r91-naver-return-no-shizuku` and CI artifacts, private Library/runtime existing APK/DEX/temp BEFORE building.

## 2. MOA user-confirmed R89 Golden (IMMUTABLE)
- Package `com.juhyeon.familyjournea`, versionCode 89, exactly **3,491,886 bytes**, SHA-256 `2b52826fc0dd8653a70d3c503d3654ae33071bfc4ec075753ec4464a1e2dc493`, signer cert SHA256 `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`.
- Full signed APK private Library `/모아_프로젝트_근거_20261103/MOA_R89_USER_DEVICE_GOLDEN_20261104_DO_NOT_MODIFY.apk`; also conversation path `/mnt/data/MOA_R89_USER_DEVICE_GOLDEN_20261104_DO_NOT_MODIFY.apk` if confirmed actually present.
- Golden source anchor `golden/moa-r89-20261104-user-device-pass-do-not-modify`, safe dev branch `develop/moa-from-r89-golden-next`. User confirmed Samsung keyboard-open native memo mic/clear/save, voice, safe clear; R87 diary per-field clear, R85 long title, R83 direct native SpeechRecognizer bridge, R63 IDB photo/memo writer must all remain. Speech accuracy improvement on hold. R90 is a restore-to-old-R87 emergency and **NOT** current Golden.
- Source-branch head may not itself reproduce exact signed R89: canonical runnable base is this signed APK. Exact file-by-file diffs and same cert mandatory.

## 3. Current R91 work ALREADY PERFORMED
Repository: `yooogillycloud123/family-journey-personal`.
Work branch: `feature/moa-r91-naver-return-no-shizuku` (created from R89-derived dev branch).
Verified GitHub Actions run **41983346964 SUCCESS** — Java compilation of experimental source, NOT signed same-package R89 production APK and NOT device PASS.

File A: `tools/moa_r91_naver_auto_return_patch.py`
- Applies to legacy `androidHost/app/src/main/java/com/juhyeon/familyjourney/NaverSaveService.java` + legacy `HostActivity.java`.
- Sets `returnAfterVerified` true only for explicitly initiated NAVER save; calls capped `GLOBAL_ACTION_BACK` only after status `VERIFIED` and ONLY while the foreground window package remains `com.nhn.android.nmap`. Stops on authentication/security or another foreground app; does not force-stop NAVER.
- IMPORTANT: legacy host builds package **`com.juhyeon.familyjourne2`**, NOT the installed R89 `com.juhyeon.familyjournea`. Must port narrow feature to actual R89 codepath; do not hand user the legacy APK as an update.
- `SAVE_CLICKED_UNVERIFIED` or `PLACE_SAVED_MEMO_UNVERIFIED` intentionally do not auto-return; actual NAVER `VERIFIED` may be absent on device.

File B: `androidHost/app/src/main/java/com/juhyeon/familyjourney/MoaNaverHiddenWebProbe.java`
- Plain Android `DisplayManager.createVirtualDisplay` + private `Presentation` + `WebView` loads `https://m.map.naver.com/` in READ-ONLY experimental mode, 30s cleanup, no credentials/password/photo logging, no Shizuku/ADB required.
- This is NOT the actual NAVER native APK on a virtual display. Normal unprivileged Android does not allow launching arbitrary third-party Activities on a private display. Separate WebView web login/session and true persistent FAVORITES WRITE are NOT implemented.
- New proof must test whether Samsung Android17 permits this hidden WebView, whether NAVER web can login, whether UI/JS executes in background, and whether actual bookmark persists after independent check.
- Do not claim a hidden NAVER account save PASS based on rendering a WebView.

CI workflow file C: `.github/workflows/moa-r91-no-shizuku-nav.yml`; run **41983346964 SUCCESS** with protected-source hash assertions and Java compile.
Work checkpoint: `feature/moa-r91-naver-return-no-shizuku/research/R91_STATUS_20261105.md` — explicitly records `no Shizuku`, CI PASS, original R89 not yet integrated.

## 4. What NEXT chat MUST DO (no starting from scratch)
1. Retrieve exact R89 APK and inspect `AndroidManifest.xml`, its actual `classes*.dex` / embedded assets; verify real NAVER integration path. The legacy `androidHost` code may be separate and is NOT automatically in R89. Check whether current R89 has an accessibility service or invokes only NAVER deep links. Never transplant unknown old package wholesale.
2. Port safely to R89 either (A) NAVER save confirmed auto-return through existing accessibility service if present (and only after confirmed save), or (B) a user-triggered safe return where explicit verification impossible; preserve reliable verification semantics. Source/DEX changes must not break R83/87/89 Golden.
3. Independently build/test the unprivileged hidden `Presentation + WebView` with source pinned and without Shizuku, judge whether it can really save to NAVER account; if not, report exact failure and retain normal NAVER visible saved flow.
4. Compile with existing GitHub Actions and local private original signer, package `com.juhyeon.familyjournea`, code>=91, preserve user data. Verify signature, ZIP/DEX, file-by-file diff and source-level tests. Deliver installable APK only if APK exists and passes static gates.
5. Physical Samsung S26 Ultra results remain unknown until user tests. Treat their screenshots as the only device evidence.

## 5. URLs / evidence
- Source repo: https://github.com/yooogillycloud123/family-journey-personal
- No-Shizuku branch: https://github.com/yooogillycloud123/family-journey-personal/tree/feature/moa-r91-naver-return-no-shizuku
- CI 41983346964: https://github.com/yooogillycloud123/family-journey-personal/actions/runs/41983346964
- Saved Golden APK and evidence already in private Library, do not ask user to re-upload unless unavailable via Files.
- Shizuku-only prior R91 experiments (e.g. `moa-r91-displaycheck`) must NOT be repurposed or suggested as meeting the user requirement.
