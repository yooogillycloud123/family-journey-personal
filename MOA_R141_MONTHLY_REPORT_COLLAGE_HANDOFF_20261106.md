# MOA R141 — 월간 사진·영상 리포트 및 콜라주 미리보기

**2026-11-06. Signed + static + isolated-browser mock PASS; actual Galaxy installation and native thumbnail loading PENDING.**

## 0. 사용자 요청 / 음악 기능 제외 확정
- 사용자는 R139 달력 통합 기능 적용 완료를 보고한 뒤, 기존 요청 4번을 이어서 진행하라고 명시했다.
- **음악 관련 개발은 제외한다.** YouTube Music, iTunes, 날짜별 곡 저장, 인앱 음악 플레이어 및 음악 파일 저장을 향후 MOA 기능 목록에서 제외한다. 이전 DayPic 연구 기록에 음악 기능이 있더라도 최신 사용자 지시가 우선한다.
- 추가 기능은 (1) 월간 사진 리포트·사진 콜라주 (2) 날짜별 **실제 원본 음성 녹음** (3) 가족 일정 반복·알림·기록 연결 (4) 옵트인 가족·Windows 동기화 (5) 기존 2D Map 보호 하 3D 지구본 순. 각 버전은 기존 골든의 최소 변경 원칙.

## 1. 실제 기반 파일과 버전 연속성
- 설치 앱: `com.juhyeon.familyjournea` (동일 패키지, 동일 서명 인증서 SHA256 `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`).
- 사용자 보고 R139 **'완료'**; 별도 일기/동기화/장치 저장 전체 기능 테스트 증빙은 제공되지 않음. R139 원본 보존: `MOA_R139_CALENDAR_PICKER_UNIFIED_BETA.apk`, 5,452,364 bytes, SHA256 `7821ff6afae7f064011a3a4ad531f552dde93e5713d0689d1d9e966608073a6f`.
- **신규 R141**: `MOA_R141_MONTHLY_REPORT_COLLAGE_BETA.apk`, **5,458,030 bytes**, SHA256 **`ccea7a3baa2197bef63793df820a81fa5a9913de86beb7f0db84cfc2a6e9c1c2`**, versionCode **141**.
- R139 APK 122 members → R141 124 members. **120/122 original members byte-for-byte identical**, changed only binary `AndroidManifest.xml` versionCode 139→141 and `assets/web/index.html` two loader references; added only `assets/web/moa-r141-monthly-report.js/css`. No removed ZIP members.
- Existing five DEX, resource table, `family-diary.js`, Diary/Family IndexedDB writers, Map, thumbnail bridge, camera/STT/audio native features, diary gallery, original 9 icons, theme picker unchanged. No permission change, no migration, no new network request, no deletion.

## 2. Implemented functionality (READ ONLY)
- **일기** calendar below its existing grid, adjacent to `오늘 / 일기 백업`: `월간 리포트 · 콜라주` button, generated only while original Diary calendar is visible, no extra banner above grid (preserve 5/6-week full viewport).
- Reads existing `FamilyJourneyDiary.state.month`, `byDay`, `byVideoDay`, `entries`, `curatedEntries` in memory. Original MediaStore IDs and indexed capture dates are used. Deduplicate by exact ID; no guessing date/location.
- Month popup: uppercase month/year, **사진 수 / 영상 수 / 촬영한 날짜 수 / 저장된 일기 날짜 수**, daily activity bars, and **up to 9 original-photo thumbnails** selected from dates across the month for a 3-column collage preview.
- Fetches at most 9 thumbnails through **existing** native-backed `window.__requestThumbs`; neither fetches full photo binary copies nor stores them persistently. If thumb unavailable, displays transparent unavailable state; no bogus substituted picture.
- Counts refer to on-device current indexed material and can omit not-indexed content; imported/approx capture time counts explicitly labeled as approximate; authored diaries counted by existing entry dates, no assumption each is long written text.
- Closing popup returns to **same** Diary calendar and month; no tab navigation. Popup itself is display-only, and report/collage data is recomputed on demand with no IndexedDB write.
- Important limitations: **collage is a screen preview**, no exported PNG/PDF yet. No music links added. **Actual recorded voice attachment, repeat/notifications, spouse/PC realtime sync, globe are NOT yet implemented.**

## 3. Verification
- APK v2 independent RSA PKCS#1 SHA256 signed-data signature PASS; content digest independent recomputation PASS; existing cert PASS, ZIP CRC PASS, 37 STORED resource alignment PASS, original five DEX headers SHA1/Adler32 PASS, unchanged native resource table and all other original members PASS.
- JS syntax (`node --check`) PASS.
- Isolated Chromium 393×852 fixture PASS (synthetic photo IDs and timestamps, *not* actual family photos): photo/video 5/2, unique capture days 5, unique diary-entry days 3, one approximated capture time, preview thumbnails, monthly chart, ESC close, next month October report (only one original photo), original synthetic `state` remains unmodified. Browser screenshot `MOA_R141_MONTHLY_INSIGHTS_MOCK.png` is a test fixture visual, **not phone evidence**.
- Not tested: in-place Galaxy install, Android native `__requestThumbs` result image rendering, actual MediaStore index completeness, 13k/1k large-library performance, original diary cold-start/add/edit, Family Calendar event DB persistence. Do not claim device Golden or complete DayPic parity.

## 4. Recovery and handoff
- R142 **EMERGENCY ONLY**: exact R139 APK contents except versionCode142, SHA256 `551cedd41b00a36d0ab4edaf2d859cf08e616f3d51520e807f368cb828742b3c`. Restores R139 code (does not erase user data), not a routine update. Do not encourage uninstall or clear storage.
- Private Library paths for R141 APK, no-key source QA ZIP, verification JSON, handoff and emergency original-R139-forward. GitHub handoff and append-only release ledger should reflect accurate status. APK delivered only in ChatGPT chat, no Gmail, no private keys in public repo.
- After real user test, next separated feature: date-linked original voice recording. That requires Android runtime mic permission and actual on-device recording/playback/storage/backup validation; cannot be called implemented merely because old STT text dictation exists.