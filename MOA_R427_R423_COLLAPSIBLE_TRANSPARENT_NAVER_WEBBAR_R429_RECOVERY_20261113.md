# MOA R427 — tiny transparent chevron for the built-in NAVER PC WebView (2026-11-13)

## User intent and private evidence
After R423 user reports near-complete working state, user asks only for a refined NAVER PC map browser chrome: eliminate the visible dark top bar labeled "네이버 웹 연결 실험 · 읽기 전용 / 모아로 / 종료", leaving only a barely visible tiny transparent `›` icon. Tap `›` to expand the existing "모아로" and "종료" buttons; tap `‹` to fold again. The point is visual minimalism, not changing the actual NAVER account write or authentication path.

Private real-Galaxy videos `20844.mp4` (~2.71 seconds) and `20846.mp4` (~5.54s) show the 64dp dark bar and page content near the top during automatic startup/saving. These videos and all personal context must remain PRIVATE; do not upload to GitHub.

## Source of unwanted bar
- Real original `classes6.dex` contains `MoaNaverWebProbeController.start(Activity)`; its `shell` is a full-size FrameLayout, with a LinearLayout column: header index0 (dark 64dp, title, preexisting MOA/Stop Buttons), stateLabel index1 (diagnostic 46dp) and webArea index2.
- The undesired chrome is **the app's own native controller**, NOT the remote NAVER DOM. Do not inject DOM/CSS or modify NAVER login to fix it.
- The user's functional startup relies on the original full-size **visible** NAVER WebView for 460ms, then hiding; don't collapse the header during that bounded successful warmup.

## R427 isolated native UI change
- Source fork: `feature/moa-r427-collapsible-transparent-webbar-20261113` from R423 branch `feature/moa-r423-splash-theme-opaque-20261113`. Source at `experiments/moa-r391/MoaR391SessionPersistProvider.java`.
- Add only to supplemental provider `classes17.dex` a guarded, first-party native reflection of the existing `MoaNaverWebProbeController.shell`. Confirm it is attached to the same Activity and has the exact known "네이버 웹 연결 실험" native label.
- Default after the original hidden warmup: set native header and diagnostic stateLabel to `View.GONE` (ZERO height, not transparent-but-taking-space); put one transparent 28×30dp touch overlay in the shell's top-right bearing a faint 12sp `›` chevron. It is clipped away automatically when shell hidden at 1dp. Native `TextView` description is accessible.
- Additional final correction: immediately after the original controller start() returns during an already-drawn opaque MOA mask, fold the chrome **before the browser's first visible frame**, while leaving the full-size WebView's 460ms rendering intact. The code only ignores the in-flight Run guard once maskDrawn is confirmed. This avoids the original dark header briefly appearing during cold launch.
- Tap chevron: show **original header with original "모아로" and "종료" Button objects and original onclick handlers**, leave unnecessary title and stateLabel hidden, chevron becomes `‹`. Tap again: fold to `›`.
- `Activity.onGlobalLayout` watcher collapses newly created manual browser shells before next draw; 400ms native monitor is secondary. Avoid applying while the original R423 startup/rearm `Run` is in-flight, to preserve the user-proven initial full-size visible render. Install/remove the observer on resume/pause/destroy and track by Activity.
- Keep R423 icon theme, opaque centered startup cover, PixelCopy freeze, original stop→visible start→460ms hide, R391 cookie persistence, R411 one-shot first-party NAVER retry, keepalive, R415 Gallery host/bridge repair unmodified.
- No new permissions/services, no root/Shizuku, no user data migration, no cookie access. Original `classes6.dex` **NOT modified**; it still has the title strings internally, but they are not drawn in default collapsed state.

## Exact signed deliverables / verified invariants
- User baseline original signed R423 SHA256 `aa2a4f8d1f42103a766587aded968cbbf77aa2c65f43320be4a65b77d309ce6a`, versionCode423; cert SHA256 `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`.
- GitHub CI Android35 javac/D8 [43320814452](https://github.com/yooogillycloud123/family-journey-personal/actions/runs/43320814452) **SUCCESS**.
- **R427 signed APK** `MOA_R427_R423_COLLAPSIBLE_TRANSPARENT_NAVER_WEBBAR_SIGNED_BETA.apk` versionCode427, 8,937,164 bytes, SHA256 `cae807166acb206bc3c1757cac919ba5987747864448af671cb4ffba70a54527`. Exactly **138/140 original R423 ZIP member CONTENTS byte-identical**, only `AndroidManifest.xml` code change + `classes17.dex` changed; all original 16 DEX including native Gallery/controller and all NAVER/Diary JS/assets remain untouched.
- **R429 exact R423 functional forward recovery** `MOA_R429_EXACT_R423_FUNCTIONS_FORWARD_RECOVERY.apk` versionCode429, 8,933,000 bytes, SHA256 `dcc75116e66d0c33549831bacb6a2277ea715d8ee9e487005ec1bcba7fc02ea1`. Original R423 **139/140 member content unchanged**, only Manifest version bumped to 429. This is an emergency restore only, NOT a normal update.
- Both APKs are signed with the original private user signer. Independent APK Signature Scheme v2 RSA PKCS1 SHA256 signature verification and **full chunked signed-content SHA256 digest** PASS, ZIP CRC PASS, all 17 DEX SHA1/Adler32 PASS, STORED resources/DEX 4-byte align PASS. ZIP contents re-encoded with matching member methods; checksum compares uncompressed member payloads.
- Combined `MOA_R427_COLLAPSIBLE_WEBBAR_R429_R423_RECOVERY_QA.zip` SHA256 `e2860fb8970104c8f4bf6f2236b7b9449a01367d068ccdf0d8848a17c8db912f`, contains both APKs, provider source, limited diff, QA, Korean README, hashes, **no signer/password/cookies or family media**.
- Private Library `/모아_프로젝트_근거_20261103/R427_COLLAPSIBLE_NAVER_CHROME_20261113/` stores signed APKs, full backup, source change and QA. Prior R423/R419/R415 user-confirmed scoped Goldens preserved.

## Physical status
- Compile/crypto/DEX/in-place update compatibility: STATIC PASS.
- On Samsung Galaxy, screen chrome default folding, chevron expansion, actual initial NAVER map list write, long-idle session keepalive, advanced native Gallery regression gate: **NOT YET TESTED**. Do not call R427 Golden/FINAL prematurely.
- In-place install over current original-signer code<=426; never uninstall/clear app data or NAVER cookies. Test manual "네이버 PC 지도 열기": top-right faint `›` only; click expands original "모아로"/"종료"; click folds; then save an actual location to account; test rearm and native Gallery.
- If severe R427 UI or save regression, R429 updates in place to **exact R423 functional content**; after R429 next version must exceed429. No AA AirPods or Android Auto changes.
