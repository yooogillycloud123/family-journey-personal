# MOA R227+ 승인된 실제 개발 실행 순서·책임 분담·릴리스 게이트 (2026-11-09)

> 상태: 사용자가 2026-11-09 장기 플랫폼 확장 로드맵을 승인하고, 해당 진행 순서를 골든 필독 지침으로 등록한 뒤 실제 작업 착수를 요청함. **이 파일은 골든 APK 수정이 아닌 추가 Canonical 실행 지침**이다. 개발 단계의 일부 설계는 아직 구현되지 않았으며, 단계별 PASS는 실제 증거가 있어야 한다.

## 0. 불변 기준과 출처

1. 모든 신규 대화는 기존 프로젝트 최상위 문서와 R227 READ FIRST/master/golden lock/WIP/release ledger, `MOA_R227_PLUS_LIFELONG_FAMILY_KNOWLEDGE_PLATFORM_CANONICAL_20261109.md`, `MOA_R227_CURRENT_MODULE_DEPENDENCY_IMPACT_REGISTER_20261109.md`, **본 실행 순서 문서**를 모두 읽는다.
2. Immutable original MOA APK `com.juhyeon.familyjournea`, versionCode **227**, APK SHA256 `53c4c04ce32ad13de3c0613f4e5ec7abbc75ccbdfe9db5da05d8fa9b806ec6cd`, signer cert SHA256 `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`; fixed R227 baseline golden Library `/모아_프로젝트_근거_20261103/GOLDEN_R227_20261109/`. Earlier R219/R209/R203/R187 preserved. R227 source-only golden branch and exact APK never edit/overwrite.
3. R227 native SDK35 CI **42573910075 SUCCESS** + original APK integrity/130 ZIP members/DEX/v2 verification PASS (per original handoff). **R227 실제 갤럭시 기능 QA PENDING**: 특히 네이버 내부 뒤로가기, 동일 사진, GPS, 확장 영상 필름스트립. Static PASS is not DEVICE PASS.
4. No Android uninstall, clear data, package/signature changes, arbitrary DB migration, private image/audio/GPS uploads to public GitHub, or AA AirPods code changes. GitHub stores only safe source/docs/test metadata; personal media/keys private Library.
5. For each implemented release: separate new feature branch based on exact R227 verified source, higher versionCode >227, minimal patch; pre/post ZIP-entry hash manifest, original signer/Android APK v2 digest and DEX, install-over-existing, media/audio/Map/Diary/UI data regression; deliver verified direct APK and ZIP containing byte-identical APK. Existing full functionality must remain.

## 1. 확정 개발 순서: 한 번에 한 기능, 단계별 게이트

### P0 — 실제 현행 상태 고정과 데이터/코드 영향 지도 (assistant 착수·계속 유지)
- R227 signed APK static manifest/DEX/JS keys + exact GitHub native source and branch/CI provenance inventory. Build a feature-to-native/web/storage/settings/QA map; mark unknown honestly.
- A full clean rebuild is NOT a prerequisite. Do not replace the installed R227 with unrelated `androidHost` prototype `com.juhyeon.familyjourney`/older `familyjourne2`.
- Preserve source-controlled *additive* logical identity contract for future `Experience`, `Place`, `Learning`, `Sync`; do not rewrite `familyjourney-diary-v1/curated` or other existing IDB records until migration/rollback tested.
- Automated checks, static environment investigation and documents = assistant responsibility. User only asked for **physical behavior evidence that cannot be simulated**.
- Exit gate: source/setting/data/function map, R227 source versus actual APK evidence, protected regression matrix and clear device QA OPEN list.

### P1 — 갤러리 → 네이버지도 → 동일 사진으로 직관적 복귀 (첫 사용자 체감 목표)
- **FIRST test installed R227**, because code already contains protective implementation. R227 source `experiments/moa-r175/MoaNativeGallery.java` in `feature/moa-r227-gallery-nav-return-original-gps-expanded-video-20261109`: `r225OpenNaver()` launches native `nmap://place`, sets `r227ExternalMapPending`; `r227RetainForExternalMap()` retains gallery on host `onPause`; `r227ResumeFromExternalMap()` clears state and resumes media. Exact R227 `classes6.dex` contains all these method/string references. `experiments/moa-r227/patches/MoaMomentAudioHostActivity.smali.patch` guards the existing `close()` in onPause and calls resume in onResume.
- This **does not guarantee a single Android Back from arbitrary Naver-internal pages**; Naver owns those pages. Device evidence distinguishes (a) Naver app Back loops (b) MOA native gallery destroyed (c) MOA background process death (d) wrong photo index restored.
- Target user experience: when done with NAVER Maps, a single simple **return-to-MOA shortcut/action** should reveal **same photo and selected rail** without repetitive internal NAVER Back. A return notification/explicit app deep link/Recents or app-level switch mechanism should be evaluated only after confirming where current R227 fails; no intrusive new helper APK, notification channel or Accessibility permission by default. Never pretend to control another app's Back stack.
- Device gate: R227 in Diary and Map, 3 cycles each, one GPS picture and different picture/video if applicable, internal Naver page movement; actual return count, photo ID/index and full stage position; real device screenshot/video. More detail `MOA_R227_FIRST_DEVICE_NAV_RETURN_TEST_MATRIX_20261109.md`.
- **If R227 PASS:** do not make a meaningless new APK. Mark QA PASS and advance to P2. **If FAIL:** assistant records exact failure and patches only the needed R227-based native host or navigation component in code >227; sign/verify APK+ZIP, request next short physical retest. Maintain protected R203 stage one-swipe/rail inertia and existing R227 Gallery/Pause semantics.

### P2 — MOA local-first 장소·즐겨찾기 리스트/큐 엔진
- Add own `Places`/`Collections` store with stable UUID, exact GPS source/time, place candidate ID, `UNKNOWN/CONFIRMED` source flags, and dedup. Can save a place instantly while offline without starting Naver or blocking screen.
- Users may select existing collection or auto-create a meaningful new list (e.g. family trip/city/category). Native Naver account collection creation is separate from MOA local list; label `MOA 저장됨` vs `네이버 동기화 완료` distinctly.
- Optional photo EXIF GPS only when actually present, location permission consent. Disallow fake coordinates and automatic home/school outing disclosure.
- Gate: same place batch/dedup; local list create+save without Naver; process restart; PHOTO no GPS/permission denied; Diary/Calendar/Gallery unaffected.

### P3 — 네이버 계정 실제 즐겨찾기와 신규 리스트 등록, 비점유 실행 가능성 비교
- Discover existing user-confirmed PC favorites automation original source (if available), existing R18 `NaverSaveService` beta evidence and exact R227 app/service availability. `nmap://place` opens maps ONLY; it does not register a favorite.
- Evaluate supported official API (if any), Naver app accessibility (with on-device approval), authenticated web UI in separate allowed session, screenless/virtual-display constrained proof, PC assistant relay. No assumed background UI controls, no credential collection, no stealth automation or UI claims without device evidence. Respect platform accessibility/security policy and user consent.
- Durable per-item queue: `DISCOVERED → REVIEWED → PENDING → UI_ACTION_ATTEMPTED → VERIFIED` only upon Naver account list readback; `FAILED/RETRY` with idempotency. New Naver list creation must be proven separately from MOA list creation.
- Gate: Naver account actual persisted place+list readback; fallback manual review when unsupported; MOA app foreground and UI availability measured; no duplicate saves.

### P4 — 바로기록 통합
- Preserve small record target / smaller X, 8-direction resize/move/persist; native mic recording/dictation STOP and Diary originals. Add independent choices such as `일기 저장`, `음성`, `메모`, `MOA 장소 즐겨찾기`, `네이버 동기화 요청`, `학습 후보`.
- One user action writes local Diary/media/audio successfully *before* asynchronous independent Naver/AI tasks; offline tasks queue and status, user may retry or cancel. Each output link references the same Experience ID; failure in one plugin cannot cancel Diary commit.
- Gate: true recorded M4A, transcript/stop, selected photo/video/day, saved place, reboot restart, cancel and permission failure; no regression QuickRecord size/UI.

### P5 — Android ↔ Windows PC and then additional devices
- First recover actual Codex v0.3 file/commit/CI evidence; currently GitHub `pcApp` and PC v0.1 README tested but there is no proven Android R227 ↔ Windows automatic bidirectional sync. Do not fabricate v0.3.
- Stable media identity via SHA256 of selected *accessible* originals and device-to-local URI index; event UUID, sync outbox, changesets, revision+tombstones, idempotent import, safe conflicts/backups. Photos/audio opt-in only, no forced upload all family media.
- First manual verified Android↔Windows roundtrip of diary/selection/metadata and selected originals; then background sync and optional private endpoint. Cloud backups distinct from bidirectional realtime. Never silently delete/overwrite.
- Gate: 2-device offline edits, duplicate/conflict handling, restart, restored original photos + audio, selective transfer, privacy, no data loss.

### P6 — 자연스러운 영어·지리·역사 연상 학습 → 인쇄/앨범, then modular life tools
- From actual photos/diary/capture situation and verified GPS create Korean descriptions, idiomatic conversational English variants, pronunciation/audio, vocabulary, phrase patterns (in/into etc contextually), time/date/season, memory/quiz/review schedule; mark AI-generated content separately from user fact and provide correction.
- Geographic graph: earth → country → verified region/province → city/town/landmark → historical context/events; preserve authoritative source citation and uncertainty. **경주는 경상북도에 위치**하므로 사용자 대화의 일시적 `경남` 예시는 사실로 저장하지 않는다.
- Source-linked experiences can spawn travel album, photo-book PDF, printable card, history timeline, family learning session, later spending/household tools, without rewriting originals. Printer integration only after print-ready layout proof.
- Gate: one single real, user-approved sample moment full pipeline fact↔translation↔audio↔quiz↔print, then batch/backfill with local consent and correction.

## 2. 누가 무엇을 하나 — 사용자에게 반복 질문 금지

### Assistant autonomous default tasks
- Source/branch/WIP/Library comparison; read current authoritative evidence.
- Document and code audit; regression inventory/updated dependency map, accessible static tests, new dedicated feature branch, minimal patch/CI, original signer app-over-install APK+ZIP only if actual build achieved.
- Save newly accepted product vision, priority changes, gates, QA statuses, known open items into mandatory GitHub docs and Library additive addendum; keep the *original* R227 Golden bytes immutable.
- Cross-device protocol design and independent PC code investigation, with privacy-preserving logs and explicit inability reporting.

### User only when physical or private access is needed
- **First and only immediate request:** On actual Galaxy with installed R227, open GPS-tagged photo from MOA gallery → tap native Naver pin → navigate into Naver once or twice → attempt normal Back and use Recents to switch to MOA if needed; note **(i)** how many Back taps, **(ii)** returns to same photo or Diary calendar, **(iii)** which Naver screen it lands on. Short screen recording/screenshots if available. The same photo should remain selected.
- Optional later: explicit Naver account permission/login and real account favorites list readback; private PC v0.3 file/source if not discoverable through connected GitHub/Library. Never ask for Naver password or private family photo upload to GitHub.
- Test new APK *only after assistant actually provides a signed original-signer compatible build*. Never uninstall/clear data.

## 3. Near-term work tickets & stop/go gates

| Ticket | Owner | Concrete deliverable | Status / gate |
|---|---|---|---|
| `MOA-P0-01` | Assistant | Golden SHA, R227 existing native map-return implementation verification | Static code/APK verification DONE 2026-11-09; device NOT DONE |
| `MOA-P0-02` | Assistant | Source↔feature↔storage impact register and R227 regression matrix | initial register DONE, incremental deep audit OPEN |
| `MOA-P1-01` | User physical phone | Six core gallery-to-Naver-to-same-gallery tests / or first 1× smoke test | NOT TESTED |
| `MOA-P1-02` | Assistant conditional | minimal return issue fix R229+ only if R227 observed FAIL; archive APK and ZIP | NOT STARTED; needs failing observation |
| `MOA-P2-01` | Assistant after P1 | stable local Place+Collection data schema/queue and first isolated module | PLANNED |
| `MOA-PC-01` | Assistant research | identify PC v0.3 actual code/project and relation to `pcApp` v0.1 | OPEN |
| `MOA-LEARN-01` | Assistant after sync | one-experience knowledge learning card full proof | PLANNED |

## 4. No fictional completions

- Approval of roadmap is not implementation or R227 real-device PASS.
- Stage 1 correct start is **test exact existing R227 behavior first**, not a duplicate new version. The user shouldn't have to test unrelated builds or reinstall any app.
- If GitHub/Library lacks Codex v0.3, say so instead of overwriting PC v0.1.
- Update this table, feature dependency register, and WIP/release ledger on each completed ticket. If no new APK, do not mark release or invent APK/ZIP.