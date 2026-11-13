> **SIGNED APK UPDATE:** This historical SOURCE-ONLY checkpoint is superseded by [R487+R489 actual signed ZIP release](MOA_R487_R489_SIGNED_DAYPIC_ZIP_RELEASE_HANDOFF_20261113.md). Do not treat previous signing blocker as current.

> **2026-11-13 MOA R487+R489 ORIGINAL-SIGNED APK AND COMPLETE ZIP — USER-RERPORTED LINK FAILURE ON PRIOR DIRECT APK:** R487 signature issue definitively resolved via verified PRIVATE Library signer backup; real original-signer R487 APK SHA256 `d9c09d4824419b0d96e15a8da54533ce7f4b0cdf7f3380994a188463c91eec3c` code487 and R489 exact user-approved R463-function recovery SHA256 `badee091d8afd20c39afcc5c9862ef09068a21768e6a2856f0ae7efaaa2c2b5e` code489; original signer cert `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`, v2 RSA/full digest, 17 original DEX verified. Full ZIP `MOA_R487_R489_SIGNED_APK_SOURCE_QA_20261113.zip` 13,211,615 B SHA256 `e11d959d5563757d4fb7d292ef01f1e38bd66ad6c5a090d8a6d20ffcafb27ded`, includes 2 APK+source+QA+screenshots+README+SHA sums, local ZIP CRC/content parity PASS, private Library upload `/모아_프로젝트_근거_20261103/R487_R489_DAYPIC_SIGNED_RELEASE_20261113/` SUCCEEDED. **Android recipient link `Library file not found` was reported for earlier direct APK links; NEW ZIP recipient opening is NOT VERIFIED**, do not conflate local artifact/Library upload with recipient success; no public GitHub APK or email without permission. R487 static/synthetic PASS, on-device UI/NAVER/Gallery UNTESTED. R463 IMMUTABLE Golden. If R489 recovery installed then new code >489. **Read [full actual signed ZIP handoff](MOA_R487_R489_SIGNED_DAYPIC_ZIP_RELEASE_HANDOFF_20261113.md)** before continuing. Older R487 source-only blocker is superseded; do not claim signer unavailable. No user data reset; unrelated AA AirPods untouched.

# MOA R487 DayPic photo-first calendar — SOURCE + BROWSER QA, NOT SIGNED APK
Date: 2026-11-13 Asia/Seoul

User rejected R483's ordinary-looking month calendar, large exposure of the following month, and top-right Today button. User explicitly supplied DayPic photo mosaic inspiration and a video showing a brown bottom Today navigation bar. R463 remains the only user-approved Golden.

## Exact implementation
Based on signed R483 (versionCode483, SHA256 dcd4ff0f5b623b4503c133d83d38d4c9dd39499b01c89c7691581a8980ecc408) and its exact source. The new isolated branch changes only `experiments/moa-r483/moa-r483-vertical-calendar.js` and `.css`.
- Calendar month becomes a full-height 7-column photographic mosaic; rows expand according to the actual 4–6 weeks of each month. Following month is below the fold initially, yet vertical month-by-month touch scroll remains.
- Duplicate per-month displayed heading removed (accessible heading retained), year/month picker and tiny two-state curated/all photo switch preserved.
- Upper Today button removed. One full-width warm-brown "오늘 달력으로 이동" bar sits directly above the original bottom five-tab navigation.
- Existing full-tile Today border and photo-free 9px family event marker remain. Async family markers are now inserted into the reserved event lane, not photo region.
- Bounded 18-month virtual-feed trim used to jump backward due double scroll adjustment; remove the redundant manual corrections so Chromium's own anchored layout preserves the visible month. Original R483 month creation/owner and all diary data functions unchanged.
- Original R463 native 17 DEX, diary/voice/storage/quick record/Naver assets and actual signed APKs are UNMODIFIED.

## Verification
- Node JS parsing PASS.
- Synthetic Chromium 420x870 and 360x780 PASS: initial next month visible 0px, bottom Today dock touches bottom tab boundary, photo tiles render, year list 201 and month choices 12, family event line in 9px lane, day opens and Today returns to November.
- Stress QA 20 months down and 20 back up, including 18-section trim/prepend, PASS in headless Chromium after corrective patch; no JavaScript errors.
- Screenshot images use SYNTHETIC placeholders. Real Galaxy/14k media/DB/Naver/advanced Gallery physical verification NOT RUN.

## APK blocker — do not misrepresent
The original R483 signed APK and R485 exact R463 functional recovery are preserved in private Library folder `/모아_프로젝트_근거_20261103/R483_VERTICAL_CALENDAR_R485_RECOVERY_20261113/`.
R485 SHA256 d5639c07a34e963c679a0a772a16c25845d0ce530e237f88ab6261cf535901c3 (versionCode485).
This session DOES NOT have the original APK's private signing key or an authorized original-signer signing service. A modified APK cannot be update-installed with a different certificate. Thus R487 changes are COMMITTED SOURCE ONLY, not an installable same-signer APK; never claim built/verified device APK. When authorized original signing is available, create code>485 original-signed candidate from frozen R483 with ONLY the two updated assets and Manifest version increment, verify all original 17 DEX bytes, APK v2 RSA full digest, original cert, and install-in-place. Do not uninstall/reset app or Naver cookies. Do not relabel R487 as Golden before physical testing.

Source path on this feature branch: `experiments/moa-r483/moa-r483-vertical-calendar.js/.css`.
