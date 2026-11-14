> **LATEST 2026-11-14 CORRECTION — USER CONFIRMED R567 PHYSICAL GALAXY SUCCESS AND APPROVED GOLDEN.** This document below was written **before** the user's explicit confirmation. Do **not** use its obsolete phrases "R567 physical PASS not established", "DEVICE PASS PENDING" or "R463 current Golden" as current facts. Current authoritative status = **R567 USER_REPORTED_GALAXY_PASS + USER_APPROVED_CURRENT_GOLDEN**. Read [current approved lock](MOA_R567_USER_APPROVED_GOLDEN_LOCK_READ_FIRST_20261114.md) and [current new-chat prompt](MOA_NEW_CHAT_RESUME_PROMPT_R567_USER_DEVICE_PASS_20261114.md). The original R567 APK/source/QA bytes remain unchanged, and R463 is preserved as previous Golden.

# MOA R567 original-signer native Gallery foreground return and first-Back stability, R569 forward R463 recovery

**Date:** 2026-11-14 KST. **Release:** Same-original-signer test APK + same-signer higher-version emergency restore. **Physical Samsung R567 NOT YET TESTED. R463 remains the ONLY user-approved Golden.**

## User's authoritative new physical evidence

Videos `21846.mp4` (~12.22s), `21847.mp4` (~12.42s), `21850.mp4` (~21.18s), user confirmed repeatedly on R563: when continuously using MOA, native Gallery Back once mostly goes to diary calendar but shows gray card for ~0.5–1s; reentry usually restores original Gallery. HOWEVER, after leaving MOA briefly to Recents, Home or another app and returning, first Back shows gray/old Web and Gallery cannot reopen until force-restarting MOA. Do not generalize this to a random startup bug or say device pass from a mock.

## Source-verified R563 defects

- `MoaR507InlineGalleryProvider.onActivityResumed` called `rebindAfterReturn` only **once at 580ms**. If the WebView isn't trusted/ready yet, the method returns without a retry, leaving `returnFromBackground=true`. That flag makes `tick()` ignore confirmed original Gallery close, so Back/reentry can deadlock.
- A valid and still attached original Gallery host can remain `View.INVISIBLE` because R535 geometry hides offscreen native host. R563's healthy check looks only at `isOpen` and `host.getParent()`. Its `bringToFront()/setAlpha(1)` is INSUFFICIENT to display a View that's still INVISIBLE. Video/Photo readiness isn't proof of VISIBILITY.
- Original R227/R463 `MoaNativeGallery.close()` sets `open=false` and detaches `host` in the same foreground action. R563 waited for ~155ms polling ticks plus 180ms dwell and JavaScript, exposing gray WebView for 0.5-1s while navigating Back.
- R563 required native mounted pending and exact `ownedDayToken` to recover on return. An independently reinitialized WebView can have the same DATE but reset `NativePending`/new token, causing recovery to abort.
- R535 and R563 integer scroll target expressions `nativeHost.setTranslationX(ix-baseX)`, `setTranslationY(iy-baseY)`, and fallback `host.setTranslationX(x-baseX);host.setTranslationY(y-baseY)` already match. No justification for another scroll rewrite. R567 does NOT alter CSS, geometry math or R527 push.

## R567 source changes

1. **Calendar before native Gallery close**: explicit JS photo-day Back marks exiting, synchronously renders diary calendar first, THEN calls original `MoaLocalAudio.closeNativeGallery()`. This removes the prior gap in which the native host vanished over an unrendered gray placeholder.
2. **Native host detached watcher**: install a `View.OnAttachStateChangeListener` on the EXACT original Gallery host while in photo card. Foreground original Gallery.close becomes an immediate same-date day Back callback instead of waiting on tick. `onActivityPrePaused` sets a pause fence BEFORE original Gallery's host onPause close decision so a real app background isn't confused with Back.
3. **Programmatic restart vs user Back**: JS sets a short marker before its own `r507StopInline` native close; Java `controlledRebuildInProgress` shields its return-repair operation, and the native-detached callback first checks JS intentional-vs-user classification. Do NOT repeat prior R547–R563 auto-reopen-of-user-Back bug.
4. **Healthy foreground return**: Java checks true original Gallery owner+root+host and asks trusted same-date JS `__moaR567RestoreLiveCard(day)` to reassert native ownership and pending/MessagePort. Java clears `returnFromBackground` ONLY AFTER successful JS acknowledgment and renewed day token, makes original host `VISIBLE`, sets alpha1, bringToFront, reinstalls Back watcher and resynchronizes R527 geometry. **Never close/reopen a healthy original Gallery**; selected image/index/video remains with original R463 engine.
5. **Bounded readiness rechecks**: instead of a single 580ms sample, verify at 150/480/950/1700/2750/3950ms, stopping once recovered. No autonomous native close retry for a healthy host.
6. **Only genuinely lost native host**: verify trusted same-day photo diary (not stale `NativePending`/token), then request `__moaR567ReopenLostCard(day)` once. If JS isn't ready, remain in return recovery for the next bounded check; never poison return state. No old Web play/control revival. Original R563 photo `refreshPages` and conditional video surface recovery are preserved.
7. NO original R463 Gallery/rail/MediaPlayer DEX, diary DB, voice/M4A, NAVER login, Android Auto/AirPods changes.

## Exact signed deliverables

Combined user-chat ZIP: `MOA_R567_R569_NATIVE_GALLERY_FOREGROUND_ONE_BACK_ORIGINAL_SIGNED_SOURCE_QA_20261114.zip` **13,132,663 bytes**, SHA256 **`0610b55bea13ee8a8b4dc742ffef232ead068d6e4f7f2c58d18d443d50d7f21a`**. Archive contains 17 entries: both APKs, exact Java/JS/CSS/DEX, SHA256 manifest, Korean README, public-only APKv2 verifier, 3-theme browser regression and actual R563/R567 source diff.

- `01_INSTALL/MOA_R567_FOREGROUND_NATIVE_RESTORE_ONE_BACK_SAME_SIGNER_TEST.apk`: package `com.juhyeon.familyjournea`, versionCode **567**, **9,069,544 bytes**, SHA256 **`f205afb72744391ce9f2594f898728699870be006f787c712599a1ee8492e93c`**.
- `02_RECOVERY/MOA_R569_EXACT_R463_GOLDEN_FUNCTION_FORWARD_RECOVERY.apk`: same package, versionCode **569**, **8,978,095 bytes**, SHA256 **`e3545a707402911eb9798d5e01007d066b776018d7e3d7faf96524bf9042fccd`**. Restores exact functional R463 Golden, loses newer photo-day experiment UI; only emergency, no app-data deletion.
- Both APKs original cert SHA256 **`5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`**; independent APK v2 RSA-PKCS1 SHA256 signature AND full signed-content digest PASS, ZIP CRC/aligned STORED payload, manifest versions and DEX SHA1/Adler32 PASS.
- R563→R567 **ONLY THREE APK entries changed**: `AndroidManifest.xml`, `assets/web/moa-r483-vertical-calendar.js`, additive `classes18.dex`. **140/140 protected original ZIP-member contents unchanged including all original native R463 DEX 17/17**. CSS byte-identical. R565→R569 rescue changed Manifest only, 139/139 functional payloads preserved.
- Private signing backup/key/passphrase were handled in local protected signing only and NEVER exported into public GitHub or the user ZIP.

## CI and QA

- Source branch: `feature/moa-r567-pause-resume-native-owner-back-cards-20261114`. CI latest successful [GitHub Actions run 43588010597](https://github.com/yooogillycloud123/family-journey-personal/actions/runs/43588010597). Shipped D8 classes18.dex SHA256 **`a073bd5222aa77f8ca452408d64469c07a556158064f91cfd9b642840982025d`** (49,732 bytes); 3 shipped source files exactly match CI artifact.
- Synthetic Chromium original Gallery fixture Peach/Black/White 3/3 PASS: photo→detail transitions, Back to calendar, no forced native timeout close, same-day live native-mounted flag restore WITHOUT re-opening already-live Gallery, intentionally closed native restart not misclassified as Back, calendar DOM rendered before original Gallery close, no JS exceptions. **This mock cannot prove actual Samsung OnBackInvoked priority, Activity/SurfaceTexture renderer or micro-scroll behavior.**
- Fresh bundle `QA/verify_release.py` verified both APK certificates/signatures/content digests/DEX, artifact ZIP CRC and identical protected members PASS.

## Physical acceptance, escalation and continuity

1. In-place install R567 over same-original-signer installed code <=566. NEVER uninstall/clear data or Naver cookies.
2. With no app switch: photo-day native rail, one hardware Back→calendar WITHOUT gray 0.5–1s interlude; same date reopen original native Gallery.
3. Recents / Home / another app, then same photo-day Back→calendar and reopen original native Gallery, verify photo and VIDEO without gray/legacy Web controls.
4. Repeat photo/detail mode toggle, selected fullscreen photo return, Naver route and original media/voice. Scroll should remain R535 lineage; do not call it perfectly synchronized until device tests.
5. If severe regression, R569 forward recovery (higher code, original same cert). After installing R569 future experiments require versionCode >=570.
6. **Real Samsung physical R567 PASS has not been observed; R567 TEST version only, not new Golden.** If it fails, collect `MOA_R567` logcat lines correlated with Back/PrePause/Return JS readiness and SurfaceTexture rather than adding more heuristic retries.
7. Original approved `MOA_R463_USER_APPROVED_GOLDEN_20261113` SHA256 `9d2fd10d32a3bc35eb3132333e96edd8f565abd5daf3ce954b052f77083d8379` immutable.

Prior Library full ZIP uploads repeatedly failed due user storage quota. Do NOT claim this 13MB ZIP is safely backed up to Library without verified success. GitHub branch/source/CI and this handoff persist; conversation ZIP is downloadable in this turn.
