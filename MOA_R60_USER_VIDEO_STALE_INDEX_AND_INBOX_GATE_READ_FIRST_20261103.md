# MOA R60 — new user Galaxy failure video 18245.mp4 (2026-11-03) — mandatory newest checkpoint

> Real Samsung device **R59 FAIL**. R60 is a narrowly verified static candidate **not** a proven end-to-end fix. Must not claim Galaxy PASS from simulated tests. Original R54 camera overlay + Android Korean STT were real-device PASS and must remain immutable.

## Actual evidence observed by examining provided 18.879s recording
- 0–4s: Samsung camera successfully captures a photo and MOA native `바로 기록` notification appears.
- 6–9s: Native memo activity opened; user types `ㅇㅇㅇㅇ`, presses `모아 일기에 메모 저장`; an on-screen toast says **`메모 임시 저장 완료 · 모아 일기 동기화 대기`**.
- 9–11s: MOA photo diary shows **13,098 pictures / 980 videos** and an empty November 3 day; after native save, the diary does not show user's selected media or memo. This is **not** a successful full save. The toast only confirms commit of local native memo draft, not IndexedDB persistence.
- 12s: November 3 detail page says **선택 사진 0 / 영상 0**, although the existing auto gallery count indicates 73 photos/9 videos for that date. No selected note is visible.
- 15–17s: QS `모아 기록` tile and Android foreground notification are visible; the MOA web UI still says `촬영 감시 · 빠른 설정에서 확인`. Native watcher and WebView bridge aren't reflecting the same state.
- Video alone **does not prove** whether native Java InboxSync called `__moaNativeSync`, whether token ACK failed, whether media index stale, whether SharedPreferences still contains draft. Device state/source diagnostic is required to separate these; no more blind native patch.

## Confirmed source regression in R59 and preexisting defect
- R59 JS `async function open()` reads fresh media only if `!S.cached`; after first photo index load, `S.cached=true`, so later visits skip new MediaStore records.
- R58 previously deactivated the fallback camera-return scan `mmEnabled` and returned early from `mmRefreshWhenBack()`; this also removed the media-index reconciliation path. Both facts are directly seen in R59 JS and explain stale 13,098 photo index. **Stale index alone is not proof that the native note->IndexedDB sync is fixed.**
- The memo's native activity source uses `SharedPreferences.commit()` and shows `동기화 대기`, therefore a successful toast is **not** an IndexedDB ACK. Before deleting native draft, read-back exact-token verification required.

## R60 ready (prior artifact, independently rechecked 87/87 static)
- Existing private Library file: `/모아_프로젝트_근거_20261103/MOA_R60_촬영사진갱신_메모동기화진단_동일서명업데이트.apk`; SHA256 `c25d083a1f82d6ec7d73c9b020d50154f072fbfa11271815dcf98a03963cc938`.
- package `com.juhyeon.familyjournea`, versionCode 60 (R59 59), same signer cert `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`. Normal data-preserving update-install over R59. **Never uninstall or clear R37 and R59 or their data.**
- JS changes: on diary open and camera return, refresh MediaStore photos/videos regardless of `S.cached`, with 4.5s throttle and visible 30s poll; preserve already curated days without deleting; suppress obsolete R42 second popup. Adds `저장 상태 확인` display for native bridge, native packet delivery, IDB ACK, and current index so user need not repeatedly shoot to collect evidence.
- R59 4 native classes DEX and other 51 entries stay **byte-for-byte identical**, only manifest version + diary JavaScript changed. Local independent run of contained `verify_r60.py`: **87/87 PASS** (valid APK v2 signer/content digest, same signer, DEX/ZIP/JS, native ACK tests).
- **R60 Android physical proof is pending**; Java inbox delivery issue remains unresolved unless an actual user device confirms. If saved note is missing after upgrade, ask for *one screenshot* of `저장 상태 확인` (not another full camera video) and follow up with read-only diagnostic if Java sender never called JS.
- R60 upgrade is not a release called FINAL, no R59/R58 reinstall attempt/ data wipe; no R60 result evidence yet.

## Mandatory next success gate
Without shooting new photos, upgrade R59 to R60 and open 2026-11-03 diary. Previously saved native draft `ㅇㅇㅇㅇ` should transfer once, and photo index should refresh. No second modal. If this fails, `저장 상태 확인` screenshot and native `inboxSyncDiagnostic` from read-only state will distinguish sender/receiver/IDB. Focus on the one broken gate while preserving R54 camera + STT.
