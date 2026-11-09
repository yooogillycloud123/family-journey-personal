# MOA R227 — 현재 기능·소스·저장소·상호영향/회귀 검증 레지스트리 (초기 정적 근거판)

> **성격:** 2026-11-09 R227 **실제 보존 APK 정적 열람** + GitHub `MOA_R227_MASTER_HANDOFF...`, R227 상세/과거 기능별 handoff를 교차한 **변경 영향관리의 초기 기준**. 이 문서는 향후 릴리스마다 버전별 사본/정정 이력을 갱신해야 한다. `확인`은 코드/기록 확인이지 실기기 PASS가 아니다. 실제 호출 관계가 불명확한 구간은 `UNKNOWN / 후속 조사`로 둔다. R227 골든 APK/소스·R219/R209/R203/R187 골든을 변경한 것이 아니다.

## A. 기준·증거 계층

- Immutable APK: `com.juhyeon.familyjournea` vCode **227**, SHA256 `53c4c04ce32ad13de3c0613f4e5ec7abbc75ccbdfe9db5da05d8fa9b806ec6cd`, signer cert SHA256 `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`.
- 이번 정적 열람: 위 **Library 보존 APK**를 원본 바이트 그대로 읽음, 총 **130 ZIP 멤버**, AndroidManifest.xml, `classes.dex`~`classes9.dex`, `assets/web/*`을 확인. R227 기존 signed ZIP은 내부 APK 정확히 동일, CRC PASS.
- R225→R227: **128/130 멤버 내용 변경 없음**; `AndroidManifest.xml`, `classes6.dex`만 변경. 새 라이브러리/소스 재컴파일을 수행하지 않음.
- Android SDK35 CI **42573910075 SUCCESS** (기존 handoff). 이번 신규 제품전략 문서 작업은 APK 빌드/실기기 검증 아님.
- 상태 레이블: `KNOWN_APK_CONTENT` 실제 ZIP 엔트리·문자열 확인 / `HANDOFF_DERIVED` 기존 인수인계 기재 / `UNKNOWN` 정밀 호출·실기기 동작 미확인 / `PLANNED` 아직 구현하지 않은 향후 기능.

## B. 기능별 실물 영향 지도 (R227)

| ID / 화면 | 현재 실제 APK/소스 앵커 | 쓰기/읽기·연결 대상 | 변경 시 반드시 확인할 회귀 | 근거/상태 |
|---|---|---|---|---|
| `GALLERY_NATIVE` Diary/Map 큰 사진·영상 | R227 `classes6.dex`, `experiments/moa-r175/MoaNativeGallery.java`, `assets/web/fj-naver-favorites.js`, `assets/web/app.js` | `MoaLocalAudio.openNativeGallery` 호출; MediaStore/EXIF, 영상 player, 하단 필름·갤러리 선택 state | 상단 한 장 스와이프, 하단만 관성, 선택썸네일, 영상 확장/seek/접기, 캡처/뮤트, 상태 유지 | APK + R227 handoff, DEVICE QA 일부 OPEN |
| `GALLERY_TO_NAVER` 위치 카드/외부지도/복귀 | R227 `classes6.dex` 중 native Gallery/Host, `experiments/moa-r227/patches/MoaMomentAudioHostActivity.smali.patch` | 사진 인덱스/촬영시간·실제 GPS, `nmap://place`, Activity onPause/onResume | 네이버 갔다 동일 사진 복귀, 없는 GPS 위조 금지, 주소 6줄/핀, 외부 화면 stack/Back, 영상 위치 | HANDOFF_DERIVED, device OPEN |
| `MAP_NATIVE_ROUTING` 나의 지도, 팝업 OFF/ON | `assets/web/app.js`, `assets/web/fj-naver-favorites.js`, `assets/web/moa-r141-monthly-report.js`(R211 변경 이력) | `moa.gallery.return.sheet.v1`, `#place-root`, `#fj-naver-photo-sheet`, MediaStore ID, native gallery | OFF/미설정에 목록 시트가 튀어나오지 않음, ON에서만 목록, 이미지/영상 순서·선택 유지 | APK 파일 존재 + R211 handoff |
| `NAVER_FAVORITES_EXISTING` 네이버 즐찾 후보/장소 화면 | `assets/web/fj-naver-favorites.js` (코드 주석: GPS photo positions→verified NAVER place review queue) | localStorage 상태/장소·좌표 후보, 외부 네이버 검색/UI | 후보/실제 네이버 저장 상태 구별, 허위 장소명, 중복/리스트, 사용자 화면 점유/권한 | APK 문자열 확인, **실제 Naver account write 미확인** |
| `NAVER_ACCESSIBILITY_HISTORIC` 별도 역사적 자동 저장 | `androidHost/app/src/main/java/com/juhyeon/familyjourney/NaverSaveService.java`(과거 R18 prototype) | `com.nhn.android.nmap` 접근성 event, 저장 sheet, list/count, memo/alias | 현재 R227에 정확히 내장된 것으로 주장 금지, 접근성·권한·상태 확인, UI 변형 | R18 handoff, 다른 옛 패키지의 소스, device PASS 없음 |
| `DIARY_CORE` 날짜별/선택 사진 일기 | `assets/web/family-diary.js`, `assets/web/moa-r133-diary-unified.js`, `assets/web/moa-r125-calendar.js` | `familyjourney-diary-v1` IndexedDB, `entries`/`curated` 등 기존 상태 | 사진 선택 vs 자동 사진 달력, 날짜 이동·뒤로가기, 저장·복원/백업, 원본 사진 URI | APK 코드/과거 handoff |
| `QUICK_CAPTURE` 촬영 후 플로팅 바로기록 | `classes8.dex`, `assets/web/moa-r121-ui.js`, `MoaMomentNative` 기존 브리지 | 촬영 미디어/위치, 오버레이 설정(이동/크기/opacity/자동 종료), PendingIntent | 작은 원형 기록 + 작은 X, 8방향 resize, 키보드/팝업/터치 44dp, 기존 일기 진입 | APK + R221 handoff, touch QA OPEN |
| `MEMO_STT` 메모/음성 기록/음성 녹음/저장 | `classes7.dex`, `classes9.dex`, 기존 MemoRecorderActivity / SpeechListener 및 `MoaMomentVoice` | M4A record/listen, 음성 텍스트, Diary save; 폰 키보드와 인셋 | `음성 기록→기록 종료→인식 정리→음성 기록`, 듣는 중 중지, 오디오 파일/일기 원본 저장, 버튼 레이아웃 | APK + R223/R225 handoff, device QA OPEN |
| `DIARY_AUDIO_EXIT` 일기 M4A 듣기 종료 | `classes6.dex` host, `assets/web/moa-r149-voice.js`, `assets/web/family-diary.js` | `MoaLocalAudio.stopPlayback` 또는 bridge, native MediaPlayer | Back/Home/일기닫기/탭 전환에서 실제 오디오 중지, JS `playing` null에서도 중지 | APK `moa-r149-voice.js` stopPlayback 문자열 확인 + R219 handoff |
| `FAMILY_CALENDAR` 가족 일정 별도 메뉴 | `assets/web/moa-r135-family-calendar.js`, `moa-r137-calendar-parity.js`, `moa-r139-calendar-unify.js`, CSS | `moa-family-calendar-v1` IndexedDB `events`; 기존 Diary와 별도 | 일정이 일기 DB/사진선택 기록을 덮지 않음, 월 스와이프/알림/향후 가족 동기화 | APK 코드/old handoff, 전 기능 실기기 범위 미검증 |
| `MONTHLY_REPORT_ALBUM` 월 리포트/콜라주 | `assets/web/moa-r141-monthly-report.js`+CSS | 기존 MediaStore/Diary read-only 집계, 썸네일 공급 | 9장 미리보기만 갤러리 전체 목록으로 오인하지 않음, 1개월 전체 미디어 탐색/메모/영상 정상 | APK + R141/R143 handoff |
| `THEME_SETTINGS` 아이콘/바로기록 설정 | `assets/web/moa-icon-theme-settings.js/css`, `moa-r121-ui.js`, `moa-r117-ui.js`, `index.html` | localStorage/네이티브 설정 bridge, 설정 UI mount | 설정 메뉴 late mount/숨김, 검은 셀렉트, 투명도 무효, 바로기록 크기 리셋, 테마 | APK + R217/R219/R221 handoff |
| `HOST_NATIVE_BRIDGE` Web/native 통합 | `assets/web/native.js`, `assets/web/host-bootstrap.js`, `host-monitor.js`, `classes*.dex` | JS bridge, native Activity lifecycle/permissions, MediaStore, audio | 인자/스레드/권한 변경이 Diary·Gallery·M4A·Map에 연쇄 영향 | APK 실물, **정확한 전체 함수 호출 그래프 추가 조사 필요** |
| `CLOUD_ORIGINAL_WEB` 원본 웹 cloud/account 코드 | `assets/web/cloud.js`, `cloud-config.js`, `account.js` | 과거 호스트/네트워크/계정 의존 후보 | 가족 기록 외부 서버 무단 전송 방지, 사용 여부/도메인 네트워크 로그 조사 | APK 파일 존재; 현재 네트워크 사용 여부 UNKNOWN |
| `PC_COMPANION` Windows 수동 사진 일기 | GitHub `pcApp/README_KO.md`, `pcApp/app.py` 등(**APK 밖**) | PC SQLite·EXIF 폴더 색인·ZIP import/export | Android R227 데이터와 자동 양방향이라고 주장 금지, 가족사진/경로 개인정보 보호 | GitHub PC v0.1 source; 사용자 언급 v0.3 별도 미확인 |
| `LEARNING_FUTURE` 일상 연쇄 학습 | **R227에는 이 제품전략 수준의 통합 학습 엔진을 구현한 근거 없음** | 추가로 설계할 LearningSource/KnowledgeGraph/StudyEngine/PrintExport | 원본 diary·GPS·MediaStore/M4A 불변, 파생·AI 추정 별도 저장 | `PLANNED` |
| `SYNC_FUTURE` Windows↔Android ↔다기기 기록 동기화 | **R227에 실제 완성된 자동양방향 SyncEngine 근거 없음** | 추가로 설계할 stable ID·outbox·conflict·tombstone | 사진 원본 삭제/덮어쓰기/ID 충돌 방지, 사용자 확인/백업 | `PLANNED` |

## C. 선행 기능→영향/회귀 관계 그래프

```text
[카메라/MediaStore/EXIF] ─┬─> [바로기록 Overlay R221] ─> [Quick Memo R223]
                          │           ├─> [Diary/녹음/전사/원본 저장] ─> [Diary Audio Exit R219]
                          │           └─> (미래) [PlaceCollections] ─> [NaverSyncAdapter]
                          ├─> [R227 Native Gallery] <─ [Map OFF route R211]
                          │             ├─> [위 큰 사진: 1 swipe=1 item]
                          │             ├─> [아래 rail: inertia + 확대 video timeline]
                          │             └─> [GPS/주소/네이버 PIN] ─> [onPause 보호] ─> [같은 사진 복귀]
                          ├─> [Diary/Monthly Report]
                          └─> (미래) [ExperienceIndex] ─┬─> [앨범·일기 링크]
                                                       ├─> [한국어/영어·발음 학습]
                                                       ├─> [지리·역사 연결 카드]
                                                       ├─> [PDF 학습지/사진책]
                                                       └─> [SyncEngine] <─> [PC Companion]
[Settings] ──────────────────────────> [Map OFF / Quick Popup / Theme / Future opt-in]
[FamilyCalendar] ─── (연결만) ───────> [Diary / Place / ExperienceIndex]
```

### 소스 손대기 전 검사 규칙

- **`classes6.dex` 및 native Gallery** 수정: `GALLERY_NATIVE`, `GALLERY_TO_NAVER`, `DIARY_AUDIO_EXIT`, 캡처·영상, `onPause` 인수인계까지 전부 확인. 원본 R227 이외 128/130 protected 멤버 불변 비교.
- **`classes7.dex`** 수정: 음성 인식/녹음 중지·finish callback·일기 저장, 키보드·음성 녹음 회귀.
- **`classes8.dex` / `moa-r121-ui.js`** 수정: 8방향 플로팅 크기, 초기 세팅/사용자 설정 유지, `X`/기록 버튼 실제 터치.
- **`classes9.dex`** 수정: 메모 저장 버튼과 입력 UI·키보드·백업 접기, 다른 클래스와 호출 경계.
- **`app.js` / `fj-naver-favorites.js`** 수정: `moa.gallery.return.sheet.v1` OFF/ON, native gallery 경유, `#place-root`/`#fj-naver-photo-sheet`, Map↔Diary/Gallery 기록 및 새 즐찾 큐.
- **`family-diary.js` / `moa-r149-voice.js`** 수정: 원본 일기 저장·음성 종료·M4A 링크·탭/Back/Home·기기 재시작 후 파일 접근.
- **`pcApp`/새 `SyncEngine`** 수정: 실제 Android 패키지는 현재 R227, 이전 `com.juhyeon.familyjourne2`/R25와 다름. old SQL/JSON 마이그레이션 실제 데이터 샘플로 검증.

## D. 설정 레지스트리(관찰됨 vs 추후 식별)

| 설정/키 | 실제 확인·이력 | QA |
|---|---|---|
| `moa.gallery.return.sheet.v1` | R211 과거 handoff. OFF/미설정 = 네이티브 갤러리 바로 열기; ON = 목록 시트 허용 | OFF/ON/미설정 각각 Map/네이버/Diary 진입 |
| `moa-r121-ui.js` QuickRecord `DEFAULTS` | R227 APK 정적 코드에 `show:true`, `style:'A'`, `xStyle:'basic'`, `text:false`, `move:true`, `resize:true`, `snap:false`, `opacity:85`, `hideSec:5`, `sizePct:85` 확인. 저장키/Android native 실제 적용은 별도 실기기 확인 | 값/마운트·미리보기·기기 회전·리셋·터치 |
| `moa-family-calendar-v1` | R227 APK `moa-r135-family-calendar.js` 내 IndexedDB DB 이름 `moa-family-calendar-v1`, store `events` 확인 | Diary DB 분리, 캘린더 CRUD/재시작 |
| 나머지 설정/권한 키 | 많은 Web/Native 설정이 분산돼 있으며 **이번 작업에서 정확한 사용처 전체 소진 조사하지 않음** | 추후 APK Web/native bridge keys 자동 색인 + source map |

## E. 다음 단계에서 실제로 채워야 할 미완성 카탈로그

1. `R227_APK_SYMBOL_MAP` 전체 DEX class/method 및 source/handoff 대응과 `AndroidManifest` permission/component 실증; 기존 키 공개/업로드 금지.
2. `DATA_REGISTRY` IndexedDB DB/store name, localStorage key, SQLite/PC path, M4A path, backup formats, 실제 삭제/수정/마이그레이션 함수 목록.
3. `CALL_GRAPH` `MoaLocalAudio/MoaMomentNative` JS↔Java 각 메서드 호출자/소비자, 라이프사이클 이벤트 (`onPause/onResume/onDestroy`) 및 실제 permission 경로.
4. `NAVER_RUNTIME` 과거 R18 Android 다른 패키지와 현재 R227에 설치된 실제 접근성 서비스/화면 제약 차이, user-reported PC 성공 원본 코드와 정확한 자동화 상태.
5. `SYNC_RUNTIME` Codex PC v0.3 실제 GitHub/개인 파일/워크플로 산출물 및 PC v0.1과 diff; R227 IndexedDB↔PC schema compatibility.
6. `REGRESSION_PHYSICAL` R227 실기기 항목들 및 이후 신규 릴리스 각 장치/OS별 PASS/FAIL/NOT_TESTED 기록.

**관리 규칙:** 이 파일을 추측으로 채우지 않는다. 이후 릴리스마다 `base APK SHA`, `changed files`, `affected feature IDs`, `settings/data migrations`, `pass/fail/open`, `new APK+ZIP SHA`, `next steps`를 수정/승격한다. 최상위 기능 확장 전략은 `MOA_R227_PLUS_LIFELONG_FAMILY_KNOWLEDGE_PLATFORM_CANONICAL_20261109.md`와 함께 필독.

## F. 이번 레지스트리 작성 자체의 변경 범위

- 실제 R227 APK는 **read-only inspection**. 새 APK·소스·서명·앱 데이터 변경 **0**.
- 라이브 앱에서 음성/갤러리/네이버 로그인·저장을 직접 실행하지 않았으며 기기 QA 결과 **0 추가**.
- 이 문서는 최신 개발에 필요한 **첫 번째 검증된 구조지도**, 전모가 확정된 리팩터링 명세라고 주장하면 안 된다.