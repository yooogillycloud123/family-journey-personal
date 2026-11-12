# MOA R431 — fix unclickable NAVER chevron and provide pink MOA home dot (2026-11-13)

## Physical user evidence / exact request
- Current user installed R427 and reported that the newly collapsed tiny `›` chevron was **not practically tappable**.
- Private Galaxy video `20861.mp4` (~9.92 s) shows the Android notification shade pulled down when attempting to tap near the **very top-right of NAVER PC WebView**, consistent with R427's `FrameLayout.LayoutParams(28dp,30dp,Gravity.TOP|END)` with `topMargin=0` overlapping the OS status/gesture area. That is directly source-confirmed; the precise Android dispatch event is not captured.
- Related user desire: reuse MOA's **pink round floating Home** in the separate NAVER browser, to return to the Diary without destroying the already initialized NAVER session. The original R389 main app JS home dot only exists in the *familyjourney.local* first-party WebView and is not visible in the separate `MoaNaverWebProbeHost` page.

## Scoped fix (not touching the remote NAVER page)
- R431 is based on exact signed R427 versionCode427 SHA256 `cae807166acb206bc3c1757cac919ba5987747864448af671cb4ffba70a54527` (NOT R423).
- Branch `feature/moa-r431-naver-webbar-safe-touch-home-20261113`, file `experiments/moa-r391/MoaR391SessionPersistProvider.java`. Only supplemental `classes17.dex` modified; baseline original `classes6.dex` owns `MoaNaverWebProbeController` and remains byte-identical.
- Replace the chevron's **28x30dp** hit region at 0dp top with a transparent **48x48dp** target at 70dp top (or Android status inset+32dp, whichever greater), right inset 5dp. Chevron glyph remains visually discreet with weak alpha, with Android native accessibility label.
- Expanded header retains **original** `모아로`/`종료` Button instances and handlers. Its height grows only in expanded state to 122dp and content top padding to 64dp, so controls are below OS notification/gesture area. Title and technical diagnostic line remain `GONE` by default.
- Add native circular pink Home dot (54dp, color `#cf739f`, edge `#e8b3ca`, approx 90% opacity) near original first-party MOA home dot default at x=12dp/y≈71% of shell height. Tap calls the **existing original `MoaNaverWebProbeController.setHidden(Activity,true)`**, not `dispose()`; MOA Diary behind it becomes visible, while NAVER account login and WebView are preserved. The dot is native, **not** an injection into NAVER DOM. The first-party Home dot's draggable/resize/idle preferences are not mirrored into the separate native shell in R431.
- Recompute only the controls' safe top/position on layout change (no change to WebView size beyond the original hidden 1dp). Guard shell owner and header label.
- Preserve exact R427 startup 460ms true-visible NAVER initialization, native higher window mask, PixelCopy freeze, one-shot offscreen rearm and favorite readback, R415 advanced native Gallery owner repair, R423 themed splash, login cookies and original R389 home-dot JS.

## Exact binary / signed static QA
- GitHub CI Android35 javac + D8 [run 43325512383](https://github.com/yooogillycloud123/family-journey-personal/actions/runs/43325512383) **SUCCESS** after resolving int/float dp compile errors. Compiled new DEX SHA256 `15f6481361b8a612ca6c96548d4566b7000792ea2619a94ed380780805ead811`.
- R431 `MOA_R431_NAVER_SAFE_TOUCH_PINK_HOME_SIGNED_BETA.apk`, code431, SHA256 **`88f999871908a32fbf9c55a628dcfb1287707e92d9ebb89f11ac1e2d4d687907`**, 8,940,193 bytes. Same original package and cert SHA256 `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`. Of original R427 **140** ZIP entry payloads, **138/140 byte-identical**; only Manifest versionCode and classes17.dex changed. All original 16 DEX (including native Gallery, NAVER Controller), first-party favorite writer JS, R389 home-dot JS, icon themes untouched.
- R433 `MOA_R433_EXACT_R427_FUNCTIONS_FORWARD_RECOVERY.apk`, code433, SHA256 **`82967c6b461b03d053d68241967a74e3002362bff0b7c507aed7e97c04d3974f`**, 8,937,540 bytes. Same R427 functional contents except Manifest version; 139/140 original entry payloads equal. Emergency ONLY for severe R431 regressions; not a fix for R427's unclickable chevron. Subsequent release after installing R433 must be code>433.
- Both APKs independently verified APK Signature Scheme v2 RSA with full signed SHA256 content digest; ZIP CRC, all 17 DEX SHA1/Adler32, STORED align and manifest code; PASS.
- ZIP `MOA_R431_SAFE_TOUCH_HOME_R433_EXACT_R427_RECOVERY_QA.zip` SHA256 **`4b4815c2b80c124f097f8d8a6bfa7ec95220359af743235c209493a2091cd0b5`** (12,921,041 bytes), containing both signed APKs, Java source, diff, JSON static QA and Korean README. NO private signer/keystore/password, user video, Naver cookies or personal media.
- Private Library `/모아_프로젝트_근거_20261103/R431_NAVER_SAFE_TOUCH_HOME_20261113/` stores exact releases, SHA records, and the private video `20861_PRIVATE_UNTOUCHABLE_TOP_EDGE_CHEVRON.mp4`.
- No modifications to AirPods or Android Auto.

## Android device test status
- **R431 compile/signer/full APK digest ZIP/DEX static PASS.**
- **R431 real Galaxy chevron tap, OS notification shade non-interference, expanded original button click, pink Home native hide and actual NAVER account save: NOT YET VERIFIED.** Do not label GOLDEN until physical evidence.
- In-place update only over versionCode<=430 with original signer; **NEVER uninstall MOA or clear cookies, data/cache**.
- Test manual PC map open: folded tiny chevron at top-right safely below status bar. Tap: header expands, original `모아로`/`종료` buttons usable. Tap native pink dot: map hides, MOA Diary shown. Then check offscreen account save and advanced Gallery. R433 emergency only on serious regression.

