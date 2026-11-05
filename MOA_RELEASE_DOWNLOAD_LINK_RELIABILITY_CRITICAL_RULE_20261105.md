# MOA — USER-REPORTED BROKEN APK DOWNLOAD LINKS: HIGHEST PRIORITY RELEASE GATE

Date: 2026-11-05
Status: USER-REPORTED DELIVERY FAILURE, OPEN ISSUE; NOT RESOLVED.
Scope: MOA APK deliveries and file links; applies to every new ChatGPT conversation and every future release. This rule has precedence over routine "build PASS" announcements. Does not alter or downgrade any AirPods audio code.

## 0. The explicit user instruction (highest priority)
User provided screenshot 18860.png, where tapping the R94 APK or R95 recovery link led to a toast **"Library file not found"**, after the same problem with earlier R92 links (screenshots 18843.png, 18845.png). User explicitly said further file-not-openable deliveries are unacceptable, and that they may cancel the paid plan if this repeats.

**Do not treat a generated path, successful compile, GitHub Actions artifact, successful Library upload, verified ZIP/DEX/APK hash, or sandbox file existence as proof that the user can actually open the download link in the ChatGPT Android app.** These prove file creation/integrity only, not delivery/accessibility.

## 1. Current observed incident
- MOA R92 APK sandbox / Library links had "Library file not found"; a shorter re-copied path was given, but actual user access success was NOT proven.
- The user again saw **"Library file not found"** for MOA R94/R95 ChatGPT file links in Android UI. Do not claim "fixed", "download verified", "APK delivered successfully" from local tests alone.
- Separate **BUILD_VERIFIED**, **FILE_PRESENT**, **LINK_RESOLVABLE**, **USER_DOWNLOAD_CONFIRMED**, **APP_INSTALLED**, and **DEVICE_FEATURE_PASS** statuses. These are SIX DIFFERENT gates.
- Current R94 underlying APK and its source/verification/rollback are in private Library `/모아_프로젝트_근거_20261103/`, but Library object presence still does NOT prove Android app delivery.

## 2. REQUIRED release delivery gate (not optional)
1. Locate the EXACT built signed APK already present. Verify file SHA256 and ZIP/DEX/Manifest/APK v2 signature + original package/certificate, versionCode and baseline preservation. Do NOT rebuild or rename blindly merely to "fix" a delivery URL.
2. BEFORE publishing a link, establish the exact artifact backing file exists in the CURRENT runtime, and validate the link's resource identity. Merely knowing a Library file ID or the appearance of a sandbox path in prior chat does not validate a new link.
3. **Independent recipient accessibility gate:** prefer an independently reachable, authenticated or public download endpoint supported by existing connected tools, and check its actual response/content; e.g. GitHub Release asset or controlled direct file endpoint when legitimately supported. If access from the user's ChatGPT Android app cannot be verified, make that uncertainty explicit; request/observe one real user's successful opening before declaring delivery SUCCESS. Do not provide fabricated public links.
4. Always provide an independently reachable **backup delivery route** when a primary sandbox/Library path has already failed for this user. If the alternate route cannot be established with current tools, say so explicitly rather than presenting the same failing link or pretending the issue is resolved.
5. Do not make the user repeat failures or unnecessarily reinstall, wipe/clear data, downgrade, install another app, or redo proven debugging.
6. If the ChatGPT Android UI returns "Library file not found", classify as **FILE_DELIVERY/REFERENCE_FAILURE** until proven otherwise—not APK signing/certificate corruption. Fix delivery before making any new APK feature changes.
7. A file passed checksum and signing verification is only **ARTIFACT_VERIFIED**. Only user-reported successful opening means **DOWNLOAD_CONFIRMED**. Only user hardware demonstration means **DEVICE_PASS**.
8. Protect R89 Golden original. Maintain same `com.juhyeon.familyjournea` and signer; preserve photos/IndexedDB/voice/diary. For R94 release code94 and R95 emergency version95, avoid silent downgrades; after installing R95 future versions >=96.
9. Respect user's time/money. Never claim to have performed Android-client accessibility verification if no Android client/tool test was actually performed. Do not promise reimbursement, cancellation outcome or account billing action that tools cannot perform.

## 3. MANDATORY user-facing message shape for future APK distribution
- State **actual file/source identity** (version, package, SHA256) and what was compiled.
- State link accessibility evidence separately from signature/bytes.
- State user-facing link as verified only with supported recipient-side evidence; otherwise label **UNVERIFIED DELIVERY**.
- Provide a verified alternate route if available; if not, be transparent.
- Never claim "this link definitely works", "problem fixed" or "100% accessible" based on upload/rename/Library success alone.

## 4. Source of truth and handoff
- Current MOA read-first: `MOA_ABSOLUTE_READ_FIRST_20261103.md`
- R89 physical Golden: `MOA_R89_USER_DEVICE_GOLDEN_LOCK_20261104.md`
- R92 two-screen UX: `MOA_R92_CALENDAR_FIRST_AUTO_IME_HANDOFF_20261105.md`
- R94 scroll elevator: `MOA_R94_SMART_DIARY_NAVIGATION_HANDOFF_20261105.md`
- R91 NAVER feature is ON HOLD by user's explicit request. Do not mix it with file delivery troubleshooting.
- Also reference this document at the TOP of the project read-first file so that every new chat reads it BEFORE claiming artifact delivery.

**Status as recorded: USER ACCESS FAILURE. A successful third-party download has NOT been established.**


## 2026-11-06 R109 REPEATED IN-CHAT DOWNLOAD FAILURE — DO NOT REPEAT
- User-provided screenshot 19007 confirms **another** `Library file not found` error tapping the R109 `sandbox:/mnt/data/MOA_R109_CHAT_DIRECT_HOME_ICON_FIX.apk` link in the ChatGPT Android native app. The link was freshly created using a local-file tool and the exact APK existed and passed hashes: local existence is **NOT** recipient accessibility.
- Previous attempts of copying/renaming the same APK inside /mnt/data and emitting new `sandbox:` links failed. **Do not claim this delivery method has been fixed or re-send a newly named sandbox link as proof of repair.**
- A separate Library file also exists and is verified: `/모아_프로젝트_근거_20261103/MOA_R109_ADAPTIVE_ICON_HOME_SHARPNESS_BETA_Install.apk`, size 5,486,325 bytes, SHA-256 `e32c0036a5f177c14f84f50404233247c29a0f798259f59201f50406583e8d5c`. This proves storage only.
- **NO EMAIL**: user explicitly prohibits email sending, Gmail drafts, and email attachments even as a fallback. See `MOA_DELIVERY_CHAT_ONLY_NO_EMAIL_RULE_20261106.md`. Never use Gmail, never propose email.
- The user wants the APK available directly inside the *same ChatGPT conversation*. Because the ChatGPT Android native app's sandbox/Library link is not resolving, one potential in-chat workaround is opening the same conversation on `chatgpt.com` in a mobile browser and using its attachment there; this is unverified until recipient confirms. Do not assert it works beforehand. Do not publish signed MOA builds publicly or use external delivery without explicit user consent.
- Required release statuses: APK built, verified, stored, linked, **mobile-recipient-opened**, installed, runtime feature passed. None of these imply the next. User already downloaded R103/R107 successfully by a different snapshot; do not conflate version histories.
- Upon another delivery error, stop duplicate link attempts and explain the platform-resolver limitation accurately, with practical in-conversation workaround or formally available alternative. Preserve original user data; no uninstall.
