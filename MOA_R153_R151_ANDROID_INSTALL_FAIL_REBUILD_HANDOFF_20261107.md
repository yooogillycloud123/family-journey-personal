# MOA R153 — R151 Galaxy install failure / conservative R149 rebuild (2026-11-07 KST)

## Authoritative device finding
- User supplied Samsung My Files screenshot `19243.png`: extracted `MOA_R151_APK_Fallback.zip / MOA_R151_Install.apk` (~5.49 MB), Android package installer says **`앱이 설치되지 않음`**.
- Mark **R151 DEVICE INSTALL FAIL**. Its prior ZIP/v2/digest/cert/static PASS claims cannot override the actual install failure. APK download and extracted file visibility did succeed; failed step is installation.
- Exact `INSTALL_FAILED_*` code **UNKNOWN** without PackageManager output. Do not invent a cause (versionCode, signer conflict, parser/resource, policy or copied ZIP); static inspection has not isolated one.
- R149 remains the latest **user physically verified voice/STT/M4A baseline** SHA256 `6fddee1d808162eff1c333abe891bb1cb4b9d005600fa63e7aaa5179f5ad0852`, package `com.juhyeon.familyjournea` (confirmed user screenshots 19226–19234).
- R151 original SHA256 `b0626d91b710dcda4496f554cc0191a6abf2d1f0d1d5b0a1602b82d88a774f2c`, same original signer cert SHA256 `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`, versionCode151; static v2 sign and ZIP pass on recheck but user INSTALL FAIL.
- Binary manifest diff R149→R151 was only one byte at original typed versionCode offset 7268 (149→151); not a confirmed manifest defect. Original 127 members R149, R151 had 129 due 2 new UI assets and index loader. Installer failure mechanism remains unproven.

## R153 current proposed repair (NOT device confirmed)
- **APK** `MOA_R153_R149_BASE_SAFE_INSTALL_REPAIR_BETA.apk` / chat copy `MOA_R153_Install_Chat.apk`; versionCode **153**, **5,488,505 bytes**; SHA256 **`65a95ef03130c3f1662534ea60a11e9a803566ba498f59d042a17d8d575b2573`**.
- Recreated from exact R149 signed APK, not R151 output. **Same 127 ZIP member names and order, no added ZIP entries, no index.html loader change**. Modified exactly 3 existing entries: `AndroidManifest.xml` one typed versionCode149→153; `assets/web/moa-r141-monthly-report.js` appends original R151 settings/time-slot voice UI and embedded CSS as an independent IIFE; `assets/web/moa-r133-diary-unified.js` adds prior return-sheet-off check.
- All original six DEX and `assets/web/family-diary.js`, `assets/web/moa-r149-voice.js` and native M4A recorder, SpeechRecognizer, Quick Record, image/photo/Family IDB engines unchanged (byte identical).
- R151 features preserved: Settings `사진 전체보기 후 목록으로 돌아가기` toggle default ON; OFF skips intermediate photo sheet, ON retains it; Diary 5-min photo-time group can record native M4A, list and play matching old/linked voice clips without changing native file. LocalStorage associations `moa.voice.timeline.links.v1`, **voice M4A files and link mapping not yet in regular Diary JSON export**. No data deletion/migration.
- Local verification: independent RSA v2 signature + full content digest and same signer, 127-member count/order, 124 member payloads byte-identical to R149, ZIP CRC and 4-byte stored entry alignments, Node JS syntax PASS; Chromium isolated fixture verified settings ON/OFF, legacy native voice in photo slot, new voice save/list/play, map viewer off closure, no runtime JS exceptions. **THIS DOES NOT PROVE ANDROID INSTALL**; do not label Golden.
- Private Library archive `/모아_프로젝트_근거_20261103/MOA_R153_R149_BASE_SAFE_INSTALL_REPAIR_BETA.apk`, QA JSON and no-key source ZIP confirmed uploaded; chat-only direct APK + fallback ZIP produced and hash-verified. Do not use Gmail or publish private signing keys.

## Recovery
- R154 **emergency only** exact R149 original feature contents, only manifest versionCode149→154; size 5,484,517 bytes, SHA256 `99b3de2b6edd0ca7eb8c415480a913046668c6a8a079d4d515c856cb6645bfcb`; same cert and 126/127 payloads unchanged. Archived in private Library, not routine delivery.
- Do not uninstall/clear data; R149 original photos, diary, M4A must be protected. Keep R115 immutable visual Golden and AirPods sources untouched.

## Next strict gate
- In-place install R153 and ask for actual on-device result. Verify old Diary STT + voice clip and both R151 extra settings before any Golden label.
- If installation again fails, stop blind APK rebuilds: use read-only `adb install -r MOA_R153_Install.apk` on a trusted USB-debugging host to obtain `INSTALL_FAILED_*` text from PackageManager and use it to identify precise failure; capture `pm path com.juhyeon.familyjournea` / `dumpsys package` when possible, no uninstall. Distinguish downgrade from signature mismatch, malformed Manifest, existing profile policy and APK extraction corruption with actual code, not guesses.



## 2026-11-07 additional user physical video — R153 INSTALL FAIL
- User uploaded `19253.mp4` (~5.2 sec, 1080×2340): Samsung My Files path `Download > MOA_R153_Install_Fallback`, tapping `MOA_R153_Install.apk` (~5.49MB), package installer visibly presents **`앱을 업데이트하시겠습니까?`** and the attempt returns **`앱이 설치되지 않음`**. **R153 DEVICE INSTALL FAIL**. The fact that the file was launched from a directory named for the fallback ZIP does not prove whether it was actually extracted or why install failed.
- At this point **both R151 and R153** failed real Samsung installation; static v2 signature and ZIP checks did not predict installation; do **not** send a third blind version or claim a fix. `INSTALL_FAILED_*` Android PackageManager detail remains UNKNOWN.
- Offline recheck of server-side files: R149 127 ZIP entries, R151 129, R153 127. The v2 signing block exists for each, ZIP integrity passes; these tests **cannot verify compatibility with the actual installed package/users/profiles and platform policy**. No exact cause identified.
- Required next evidence (do not uninstall / clear data): obtain explicit **Android PackageManager failure code** from the user's existing debugging connection, e.g. PC with adb: `adb install -r "MOA_R153_Install.apk"` (this does attempt update if installable) and capture `Failure [INSTALL_FAILED_...]`. Run only with user's intention to update; not strictly read-only. Alternatively user can first try a clearly extracted standalone APK in Downloads rather than navigating inside archive, but that does not prove fix.
- Protected last real-world working feature baseline remains R149 (STT + original audio M4A user PASS); R153 not Golden. No further modifications to user data, source, or signing in this checkpoint.
