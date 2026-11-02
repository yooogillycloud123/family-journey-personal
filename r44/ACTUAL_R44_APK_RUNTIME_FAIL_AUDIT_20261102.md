# MOA R44 physical FAIL audit — 2026-11-02
User reports Quick Settings "모아 R44 · 촬영 즉..." tile remains inactive, in-app button does not enable, camera captures do nothing.

## VERIFIED against actual delivered APK (NOT the GitHub Java source)
APK local name: MOA_R44_NATIVE_CAMERA_MOMENT_TEST.apk
Full APK SHA256: 8689f53dcac5c2361ca44e147ff2a11e04863d60febb5ff2cfa6ee30d8f79cde
classes4.dex SHA256 begins 07a1d201348c1fd7d0; bytes 11288.

1. App's `assets/web/family-diary.js` contains `function mmToggle(){ status('모아 기록은 휴대폰 빠른 설정창에서 켜거나 끌 수 있습니다.'); return; ... }`: THE IN-APP BUTTON IS BY DESIGN A NO-OP. It must NOT be called an ON/OFF control.
2. Delivered DEX declares `com.juhyeon.familyjourney.MoaShotService`, `MoaShotTile`, `MoaShotApplication`, `MoaShotMemo`; GitHub R44 sources are `MoaMomentCaptureService`, `MoaMomentApplication`, `MoaMomentMemoActivity`. This is a critical SOURCE↔BINARY mismatch. The installed app has no evidence of the GitHub Java code being compiled.
3. Direct DEX bytecode disassembly of `MoaShotService.onStartCommand`:
   `new Notification.Builder(this,"moa_shot_active"); const/16 v1,66; invoke-virtual Notification.Builder.setSmallIcon(int)`. The notification icon is RESOURCE ID 0x00000042 (66), not a valid app or Android drawable ID (expected 0x7f... or 0x0108...). Foreground notification construction/validation is therefore invalid and prevents reliable `startForeground`; this is a concrete, plausible immediate runtime failure. Do NOT claim it as verified on-device exception without logcat.
4. `MoaShotTile.onClick` writes shared pref `moa_r44_camera/enabled` BEFORE `startForegroundService(MoaShotService)`. Failure during service start leaves the saved state misleading and quick tile display non-authoritative.
5. The native `MoaShotBridge` class in DEX is EMPTY (no methods/JS API). The timeline integration relies on `MoaShotApplication.pushInbox` and `window.__moaNativeInbox`, and does not provide a verified bridge for native event ACK/durable two-phase commit. This is NOT the repo importer architecture.
6. The DEX `MoaShotService` uses Handler periodic scans, not MediaStore ContentObserver (no ContentObserver type in DEX). Prior claims that packaged R44 used the confirmed GitHub observer are incorrect.
7. User has not received a tested working capture cycle. Existing UI memories/data MUST be preserved; no uninstall or data clear.

## Required pre-release validation gates
- Build latest exact reproducible Android source with SDK, not a hand-written DEX inconsistent with repo.
- Manifest service/Tile/Application actual class names match DEX; fg service icon is a valid R resource; permission flow explicit.
- Quick Tile must visibly show ACTIVE/OFF and service 'running' truth, with recorded error diagnostic on failure.
- Capture test on Galaxy stock Camera while MOA not foreground, written media thumbnail and capture time; overlay or tap-enabled notification; native speech recognizer; IndexedDB ACK after confirmed commit; user photo diary timeline, no separate section; repeat cycles.
- APK signer SAME existing installed R39-R44 signer; preserve data; ZIP, Manifest, DEX, v2 verify. Without actual signer never direct uninstall/downgrade.
- Do not label R44/R45 FINAL until physical pass.

The public GitHub family-journey-personal Android project is an old v0.2.0 base, not the full APK source. Merely building that project does NOT produce an update for user-installed MOA R44.
