# MOA R251 repeated crash on Galaxy — R255 emergency update-in-place recovery (2026-11-10)

## User real evidence
Private image `20077.png` (do NOT publish): Android One UI dialog **모아 · 촬영 즉시 기록이(가) 계속 중단됨**, with App info / Close app. Underlying third-party Privacy Display overlay visible, **not proven cause**. User reports previous R249 app launched; R251 newly will not launch. This is a **P0 launch blocker**; NO new features before restoring boot.

## Actual concrete source bug in R251 (high-confidence causal hypothesis, logcat unavailable)
Decoded `HostActivity.smali` R251 in `/mnt/data/moa_r251_work/HostActivity.smali`:
- `lambda$handle` 'naverSave' job branch stores UUID as a `java.lang.String` in register **v8**, marked `.local v8, "job":Ljava/lang/String;`.
- Inserted R251 patch then performs `invoke-virtual {v8, v0, v2}, Lorg/json/JSONObject;->optBoolean(Ljava/lang/String;Z)Z`. Calling an instance `JSONObject` method on a string register produces invalid type flow; Android ART verifier may throw **VerifyError** loading HostActivity and prevent app startup.
- Exact bad source came from mixing R251 native popup SharedPrefs added call into existing v8 job variable. R251 also wrote extra job/status fields and called `MoaNaverAccessibilityCover.begin` early, adding unnecessary fragility.
- No live device logcat was supplied; therefore **actual FATAL EXCEPTION class remains unconfirmed**. Do not claim certainty absent AndroidRuntime stack trace.
- A prebuilt R253 research candidate exists but had no real launch test and is NOT used as recovery baseline.

## R255 deliberate narrow crash recovery
- **Signed update APK:** `MOA_R255_EMERGENCY_APP_LAUNCH_RECOVERY.apk` bytes **8,928,487**, SHA256 **`3b34cfef5f1344d683a181f556d3e9f76fa7474b4cbdb2b1f5a2b00fd3cf7342`**.
- Signed exact-package `com.juhyeon.familyjournea`, versionCode **255**, original certificate SHA256 **`5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`**, APK signature v2 verify PASS, ZIP CRC PASS, STORED resources, all 15 DEX SHA1+Adler32 PASS, zipalign PASS, manifest version PASS.
- R255 is **BYTE-FOR-BYTE IDENTICAL to the user's last app-opening R249 in all 136 original non-signature payload members except `AndroidManifest.xml` versionCode 249→255**. In particular `classes2.dex`, `classes15.dex`, all diary/gallery/audio/voice/settings/QuickRecord files are **byte-identical R249**. It contains **NONE of R251 invalid v8 JSONObject calls**.
- The higher code permits ordinary Android update-install over R251 **without uninstall, data deletion or signer change**.
- Backup with same APK: `MOA_R255_EMERGENCY_APP_LAUNCH_RECOVERY_WITH_GUIDE.zip`, SHA256 **`1209ba4912baffc5704fe6e5e5e28baf36137f6bf1669efe02d9950f718d1184`**, ZIP CRC and inner APK hash PASS; Korean guide + QA included.
- Private Library exact archive `/모아_프로젝트_근거_20261103/R255_EMERGENCY_CRASH_RECOVERY_20261110/`. Local signed APK/ZIP/QA/guide under `/mnt/data`; NO private signer/key/password in GitHub.
- Base signed R249 SHA256 `336b8429e4fb5aa404fcf6ed0477913852da697e22dc81e0592f97208110cdac`. User R249 real Galaxy boot confirmed by private `20062.mp4` showing screen and diary; favorites failed then. R227 original immutable Golden remains SHA256 `53c4c04ce32ad13de3c0613f4e5ec7abbc75ccbdfe9db5da05d8fa9b806ec6cd`.

## Honest release/test scope
- R255 **real Galaxy boot AFTER UPDATE NOT YET VERIFIED**. Do not label FINAL or say actual user's crash solved until they confirm opening.
- Since R255 is exactly R249 functionality with higher manifest version, **R249 NAVER favorites limitations and old accessibility relay issues remain**. This emergency only recovers app usability, NOT real NAVER account saving, no new popup setting.
- No dynamic Android emulator or real phone was available. However ART verifier crash source defect is obvious and R251 changed classes2 differs from R249.
- Install flow: close crash dialog → download R255 → update existing app (same signer; data preserved) → **check main screen + diary + photos first**. No uninstall/data clear/manual downgrade to R227/229. Do not ask for repeated NAVER tests until boot passes.
- If R255 still crashes, ask for **AndroidRuntime logcat FATAL EXCEPTION** or system bug report, with family photos, tokens, account, GPS redacted; do not guess another root cause.
- Original goal remains: MOA normal functioning plus camera-location→existing NAVER favorites save one tap, accurate stage UI, result popup ON/OFF, no PC/root/Shizuku, no screen takeover; current fix makes no false claims.

## Why release R255 rather than speculative R251 hotfix
A fully byte-identical known-booted R249 DEX rollback is lower risk than patching R251 smali with further untested register modifications. It maintains every current R249 feature as available; exact only manifest version changed. User must not be subjected to a second broken boot just to test favorite popup.
