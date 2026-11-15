# 2026-11-15 MOA R615: cohesive photo/detail settings and QuickRecord/Voice UI

## User's actual physical R613 screenshot defects
- Top right 68x34 pill containing tiny ellipsis sat far from left photo/detail 68x34 slider. User requires **visually aligned and closely grouped**, not same appearance. R615 uses 36x34 gear button, 6px gap, existing menu action.
- Photo-day `바로기록 28개` and `음성 기록 · 12개` accordion headers were visually inconsistent; large bright record circle and ambiguous `저장` button. R615 gives both rows 43px height, matching 12.5px typography, same arrow/border/rhythm, both collapsed by default; record 34x34 hit target with 11px red center; save relabeled `글 저장` and explanatory text `이 날짜의 ‘오늘의 이야기’ 글만 저장 / 음성은 녹음 완료 시 별도 저장`.
- Preserve all underlying original functions: photo native 8-action Gallery and filmstrip, One Hand Operation+ NAVER Accessibility OFF/ON R611 recovery, video playback, photo/detail mode, same-day record storage, native M4A playback, quick scroll panel, diary text auto-grow, original menu click. No accessibility/Java DEX or service change.

## Signed artifact truth
- **User-approved immutable Golden remains R611** code611 SHA256 `38a507cf2e88a235282ae4d9ad64cf0799033f34ae8fe3e179a58960d1213ccd`; R615 is **beta not user physical-approved**.
- R615 original-signer APK code615 `MOA_R615_R611_GOLDEN_COHESIVE_SETTINGS_RECORDS_UI_ORIGINAL_SIGNED_BETA.apk` size 9,113,281 SHA256 `fa045eaa191a03c09bd78e6a43e8be1b1a3270ba8238fa39928632638b9c3c3d`, cert `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`; APKv2 cryptographically verified; 18/18 R611 DEX unchanged; **141/144 APK members identical to R613**; only `AndroidManifest.xml`, `assets/web/moa-r483-vertical-calendar.js`, `assets/web/moa-r483-vertical-calendar.css` changed.
- R616 exact R611 forward emergency APK code616 SHA256 `89ad995fba01b8e5d80ce959cddb2b6bc5fbfc2a1fdca3745bcf9c26b466e5a0` original signer, **143/144 members same as R611**, only manifest code changed. Next code >=617 if installed.
- Combined ZIP `MOA_R615_R616_R611_GOLDEN_COHESIVE_UI_SIGNED_SOURCE_QA_20261115.zip` SHA256 `a1534911a20fb403ee662b74862716cbd5202326d2553dfc8d3072d2f8f50f31` contains signed APKs, exact source, diff, QA and Golden context. Stored privately, not public source user photos.
- Real browser CSS/layout test PASS: slider 68x34, gear 36x34, gap6, quick/voice headers 43px, record34 with red11, both collapsed, save scope explained. Native device test **NOT RUN**.
- R615 exact patched source on local release: `r615_photo.js`, `r615_photo.css` with diff vs R613; all other R613 web unchanged. Source must be compared to signed APK before subsequent edits.
- Install **over existing MOA** without uninstall/data reset or NAVER logout. First regression test repeated One Hand Operation+ NAVER accessibility OFF/ON, original native Gallery/8 actions/video, then menu alignment, both accordion behavior, recording, audio player and diary save. If physical FAIL, isolate changed JS/CSS, preserve R611 and roll forward R616 only when necessary.

## Mandatory anti-regression reasoning
The user already taught the distinction between actual NAVER Accessibility ON/OFF and wrongly guessed camera watcher. Do not change unverified subsystems. Confirm actual user interaction, call path, storage scope and exact source; preserve the user's physical R611 PASS over all synthetic QA. Read `MOA_R611_USER_DEVICE_APPROVED_GOLDEN_LOCK_20261115.md`, `MOA_R611_GOLDEN_ROOT_CAUSE_ENGINEERING_AND_R613_UI_HANDOFF_20261115.md` first.
