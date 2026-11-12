# MOA R399 — PHYSICAL GALAXY FAIL: visible NAVER PC map after first offscreen save (2026-11-12)

## Decisive user-provided evidence
- Actual uploaded private video `20781.mp4` duration ~11.25 seconds, inspected with frames around one-second intervals; file and screenshots must remain PRIVATE and never be pushed to GitHub.
- 0–1 s Android home/startup followed by MOA splash; 2–6 s ordinary MOA diary; at ~6–7 s user selects `비점유 저장 실험`; around 7–8 s separate `네이버 웹 연결 실험 · 읽기 전용` NAVER viewer appears on top, and by 8–10 s official NAVER PC place browser is visible. This is explicitly **FAIL** against user's no-popup, first-save, masked warmup acceptance condition.
- User had already physically reported **R395 hidden-first failed**, returned to R397 and found manual PC map open -> hide once -> genuine account offscreen save worked. R399 was an unproven BETA; do not repeat static PASS as real solution.

## Code source inspection and constrained findings
- Original controller `MoaNaverWebProbeController.control('visible')` creates full-size window; `control('hidden')` when stopped returns `VISIBLE_LOGIN_REQUIRED_FIRST`. Original R397 favorite engine calls `visible` when no WebView session.
- R399 native `MoaR391SessionPersistProvider` uses Activity lifecycle callback `onActivityCreated` to add mask, `onActivityResumed` to find MOA WebView, `evaluateJavascript` checks offscreen preference, then `begin` only when gated; `poll` checks `FRAME_ELEMENTS_OBSERVED_READ_ONLY` or `VISIBLE_DESKTOP_PAGE_FINISHED_UNVERIFIED`, actual NAVER PC URL, and 450ms min within 3200ms max. On gate fail/timeout it calls `finish(false)` and removes mask, restoring original R397 unmodified JS; catches exceptions without reporting reason.
- The actual video shows the **original visible fallback after startup**. It proves startup did not leave a confirmed running-and-hidden NAVER WebView at time of save; **does not isolate exact failing step** (provider activity callback, MOA WebView match, localStorage mode, invoke,start/page readiness, timeout or unexpected disposal). Claiming one root reason without runtime evidence would be speculation.
- The R399 original native controller has four-minute expiry; unrelated to failure within 7 seconds.
- Full QA/static compile/v2 integrity for R399 only proves APK shape and code preservation, NOT first-save UX or real account write. Existing R397 working user baseline must be preferred.

## Risk reduction / next engineering requirement
1. Do not reuse R395 start+hide same-tick, R399 blind splash and 3.2s assumption, or alter the proven R345 first-party writer/real account list behavior blindly.
2. Keep current R397 functionality preserved. For a device already running R399, exact R397 functional equivalent can only be update-installed using versionCode401, original signer. **R401 is recovery, NOT a new fix**. Do NOT uninstall, clear data/cache/cookies or force re-login.
3. Before next production candidate, instrument non-sensitive native startup stages and display/export bounded state: CALLBACK_ATTACHED, OWN_WEBVIEW_FOUND, OFFSCREEN_PREF, CONTROL_START_ATTEMPT, PROBE_RUNNING, NAVER_MAP_URL_CLASS, FRAME_READY, HIDE_CONFIRMED, FAIL_REASON. No user credentials/cookie values/precise GPS.
4. Only if the instrumented device proves the missing gate should one specific correction be made. A pre-launch full-size browser under cover is not established feasible by static tests; do not promise zero visible frames. Preserve button behavior and no surprise map opening.
5. Test actual first account readback and repeat after app process restart / four-minute expiry; baseline no-session UI behavior may still require explicit user action.

### Truth status
**R399 PHYSICAL FAIL (visible popup).** R397 original first-visible-then-hide offscreen subsequent saves user-confirmed PASS. Next version after emergency R401 must be >401, same signer. AirPods Android Auto untouched.
