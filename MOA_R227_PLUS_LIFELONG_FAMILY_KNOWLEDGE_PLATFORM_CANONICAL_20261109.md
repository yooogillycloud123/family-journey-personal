> **2026-11-09 MOA R231 — SIGNED BETA, DEVICE QA OPEN; R229 USER-TESTED 1-TAP RETURN PASS:** User's private video `19976.mp4` confirms R229 real Galaxy NAVER floating `↶ MOA` appears, is editable and taps back to original in-memory gallery photo; screenshot `19977.png`/`19979.png` shows only old Quick Record Settings, lacking NAVER return own settings. **READ IN FULL** [MOA_R231_POPUP_SETTINGS_NAVER_WEBVIEW_REAL_PROBE_HANDOFF_20261109.md](MOA_R231_POPUP_SETTINGS_NAVER_WEBVIEW_REAL_PROBE_HANDOFF_20261109.md) after earlier R227 Golden/vision/impact and R229 handoff. **Actual R231 same-signer signed installable APK** `com.juhyeon.familyjournea` versionCode **231**, 5,815,249 B SHA256 `57ba08ff7491270f6e71c8b41d00c32911dc6cf8eb27f9d7c1faa5536970f343`, original cert SHA256 `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`; byte-identical APK inside ZIP SHA256 `a8b9083f00a8e40cafd89abddea5f5a8d887943c434cedd0ed9fabaa6d5c302d`. 133 members/10 DEX, 127/131 R229 member contents unchanged; signed v2/CRC/static PASS; **R231 Galaxy tests PENDING**. New independent `네이버지도 복귀 팝업` Settings (show/style/opacity/size/drag/8-way resize/snap/reset/preview, separate Quick Record prefs). New explicitly-launched `네이버 즐겨찾기 웹 연결 · 실험` real in-MOA Android WebView: visible NAVER web login, numeric-only top-frame DOM presence diagnostics and 30s clipped attached invisible probe while MOA remains foreground. **Actual hidden NAVER account favorite/list write NOT IMPLEMENTED, Naver login/hidden memory/performance NOT TESTED**; do not call this feature complete. Source-only branch `feature/moa-r231-popup-settings-naver-webview-probe-20261109`, independent Java17/Android35 CI run 42639469975 SUCCESS. Private signed APK/ZIP/QA at `/모아_프로젝트_근거_20261103/GOLDEN_R227_20261109/R231_SIGNED_NAVER_WEBVIEW_PROBE_20261109/`. Immutable R227 original SHA256 `53c4c04ce32ad13de3c0613f4e5ec7abbc75ccbdfe9db5da05d8fa9b806ec6cd` unchanged. No app uninstall/data clear/new signer, no NAVER password/cookie scraping, no AirPods work. **Next** real Galaxy R231 login/iframe/hidden callback + Settings/device QA; only after proven, origin-scoped per-frame NAVER write/list readback in R233+ without screen takeover.

> **2026-11-09 NAVER NO-SHIZUKU USER-VIDEO RESEARCH ADDENDUM (MANDATORY):** Private videos 19966.mp4 and 19967.mp4 confirm R227 returns to the same gallery photo after THREE Back actions, not requested ONE Back. Its onPause/onResume gallery preservation PASS only for the observed path. The diary/location NAVER-favorites+memo flow launches full-screen NAVER; after save, the green saved star and '내 장소에 저장됨' are shown. Background save, automatic creation of a list, and server persistence after restart are NOT PROVEN.
Read [MOA_R227_NAVER_1BACK_INVISIBLE_FAVORITES_RESEARCH_20261109.md](MOA_R227_NAVER_1BACK_INVISIBLE_FAVORITES_RESEARCH_20261109.md) FULLY before NAVER changes. Highest-priority no-Shizuku/no-helper experiment: internal AndroidX WebKit WebView cross-frame origin-scoped view-only probe, then only upon actual user-approved physical feasibility, real NAVER account list creation + save + readback with MOA screen uninterrupted. Existing source-only probe passes a Node mock, but real WebView login/hidden behavior and actual NAVER account write are NOT TESTED.
Distinct return UX: an in-MOA map can enforce one system Back, but differs from the full NAVER native app. Keeping the native NAVER app may allow a one-tap MOA return control after explicit permission, NOT a guaranteed single system Back. No Shizuku, root, ADB or extra APK. Issues #6 and #7. Never publish the uploaded personal videos/precise location. Original R227 APK and frozen source remain immutable.

> **2026-11-09 APPROVED MOA EXECUTION ORDER — REQUIRED BEFORE ANY NEW APP BUILD:** User approved the complete strategy and ordered real execution. Read [MOA_R227_PLUS_APPROVED_EXECUTION_ORDER_AND_ROLES_20261109.md](MOA_R227_PLUS_APPROVED_EXECUTION_ORDER_AND_ROLES_20261109.md) FULLY **AFTER** R227 Golden and long vision/impact map, then apply [MOA_R227_FIRST_DEVICE_NAV_RETURN_TEST_MATRIX_20261109.md](MOA_R227_FIRST_DEVICE_NAV_RETURN_TEST_MATRIX_20261109.md) on actual R227 before patching NAVER return. P0 immutable baseline/code+dependency audit → P1 test exact R227 gallery→Naver→same photo (repair only evidenced FAIL) → P2 offline MOA own Places/Collections → P3 proven persisted NAVER account favorites/list automation without occupying screen if technically feasible → P4 Quick Record with independent diary/voice/memo/place/learning tasks → P5 Android↔Windows robust sync (recover actual Codex v0.3 first) → P6 family natural English/geography/history linked lessons/print, then family tools. **Assistant handles source/audit/implementation/build; user's only immediate job is short Galaxy R227 NAVER→same-photo physical smoke test.** Prepared isolated `feature/moa-r229-nav-return-qa-gated-20261109` branch at immutable R227 commit `801592a0621a4b90caf313b6c4b0a16837ec136d`; **NO new APK/release/device PASS yet**. Original R227 SHA256 `53c4c04ce32ad13de3c0613f4e5ec7abbc75ccbdfe9db5da05d8fa9b806ec6cd` unchanged; never overwrite Golden, uninstall, clear app, alter signer, or fabricate verified NAVER behavior.

# MOA R227+ — 가족 기억·지도·영어·역사·학습·PC 동기화 장기 제품 비전 및 불변 개발 계약

- **상태:** 2026-11-09 사용자 신규 요구를 빠짐없이 반영한 **향후 개발용 필독 Canonical Addendum / 설계 계약**.
- **중요한 구분:** **현재 구현 완료를 뜻하지 않음.** 이 문서의 로드맵·스키마·UI는 구현 후보/승인된 장기 목표이며, 기능별 물리 PASS는 별도 증거가 필요하다.
- **적용 저장소:** `yooogillycloud123/family-journey-personal`의 MOA 제품. 기존 `workexcel-devbridge`의 AA AirPods 오디오·Android Auto 골든에는 영향 없음.
- **원본 롤백/보존 기준:** **MOA R227 사용자 지정 불변 골든** `com.juhyeon.familyjournea`, versionCode **227**, APK SHA-256 `53c4c04ce32ad13de3c0613f4e5ec7abbc75ccbdfe9db5da05d8fa9b806ec6cd`, 원본 signer cert SHA-256 `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`. Private Library `/모아_프로젝트_근거_20261103/GOLDEN_R227_20261109/`의 원본 APK/ZIP/130-member CRC·SHA 기록과 frozen source branch `golden/moa-r227-20261109-user-designated-preserve-device-qa-open`는 **절대 변경하지 않는다**.
- **이전 보존본:** R219 사용자 수락 범위형 골든, R209, R203, R187 모두 별도 불변 보존. R225는 R227 이전 서명 기준본.
- **필독 현재 구조 레지스트리:** `MOA_R227_CURRENT_MODULE_DEPENDENCY_IMPACT_REGISTER_20261109.md` — R227 APK 실제 130-member 점검, 기능별 소스·Native/Web/데이터 연결, 회귀 영향, 설정 키와 미확인 사항의 **초기 기준**. 향후 릴리스마다 반드시 갱신한다.
- **독서 순서:** ① `workexcel-devbridge/main/AA_AirPods_FINAL_READ_FIRST_v1.0_20261005.md` 전체 → ② `family-journey-personal/main/MOA_READ_FIRST_NEW_CHAT_R227_20261109.md` → ③ `MOA_R227_MASTER_HANDOFF_FOR_NEW_CHAT_20261109.md` → ④ `MOA_R227_USER_DESIGNATED_GOLDEN_LOCK_20261109.md` + WIP/Release Ledger/R227 detailed handoff → **⑤ 이 문서 전체** → ⑥ 해당 기능의 변경 영향 지도/최신 검증 자료 및 개인 Library 파일. 이 문서는 과거 인수인계를 대체하거나 골든 바이너리 기준을 바꾸지 않고 추가한다.

---

## 1. 이 프로젝트의 본질: 하나의 기록에서 평생의 지식으로

MOA는 단순한 사진 뷰어·일기장·저장 버튼을 모은 앱이 아니다. 가족이 실제로 경험한 순간을 **원본 증거가 있는 개인 연대기**로 남기고, 장소·사람·행동·감정·시간·계절·날씨·대화·문화·역사·언어·학습·생활 정보를 계속 연결하는 **장기적인 가족 기억 및 학습 기반 플랫폼**이다.

사용자 요구의 본질을 다음과 같이 영구 보존한다.

1. 가족의 사진과 영상, 음성, 메모, 일기, 촬영시각, GPS, 방문 장소는 **일상에서 자연스럽게 수집되는 1차 원자료**다. 인위적으로 공부 시간을 따로 만들기 전에, 실제로 있었던 일을 손실 없이 편리하게 기록하는 것이 시작이다.
2. 같은 경험은 **모아 일기**, **나의 지도/네이버 즐겨찾기**, **사진첩·여행앨범**, **우리 가족 일정**, **학습 카드·영어 표현**, **지리·역사 배경지식**, **출력·인쇄 자료**로 각각 확장된다. 한 번 기록한 사실을 기능마다 다시 타이핑하지 않아야 한다.
3. 예를 들어 여행지 사진을 하나 골라 '무엇을 봤는지, 누가 무엇을 했는지, 어떤 말을 했는지' 기록하면, 영어 일상 표현과 단어·발음, 여행지의 행정구역·문화유산·역사, 관련 인물·시대·사건까지 단계적으로 탐색한다. **내가 실제 경험한 장면을 학습 기억의 닻(anchor)으로 삼는다.**
4. 단일 정보를 외우는 것에서 끝나지 않는다. 장소 → 지역 → 나라 → 역사적 사건 → 인물 → 그 시대의 생활 → 오늘 경험한 행동·영어 단어로 가지가 뻗는 **연쇄 연상·배경지식 학습**을 지향한다. 사용자가 학습할 깊이와 가지를 선택한다.
5. 훗날 프린터, PC 앱, 가족 사진앨범, 복습 프로그램, 여행 백서, 가계부, 가족 일정, 지도·지구본 등 다양한 파생 도구를 붙이더라도 **동일한 신뢰 가능한 기록을 재사용**해야 한다. 이것은 수년 이상 유지할 개인 자산이므로 데이터·검증·마이그레이션·복구가 UI보다 중요할 수 있다.
6. 일상 기록을 강제로 공부 과제로 만들지 않는다. **기록은 즉시·가볍게, 보강과 학습 생성은 나중에 선택적으로/자동 대기열에서** 수행한다. 오프라인에서도 기록은 가능해야 한다.
7. 사용자·가족의 실제 사진, 세부 GPS, 집 위치, 아이의 목소리, 일기 원문을 공개 GitHub·공용 테스트로그에 올리지 않는다. 외부 AI·지도·클라우드 사용은 별도 동의·최소 범위·삭제/철회 체계를 갖춘다.

**제품 지향 문장:** “우리 가족의 실제 순간을 한 번 안전하게 남기면, 그 기억이 일기·지도·앨범·영어·지리·역사·인쇄·생활 도구로 자연스럽게 확장되고, 휴대폰과 PC 어디서나 회상하고 배울 수 있는 MOA.”

## 2. 사용자 신규 요청 원문 의미를 보존한 요구사항 목록

### 2.1 [요구 1] 현재 위치 → 네이버지도 '실제 계정 즐겨찾기'를 화면을 빼앗지 않고 저장

- 지금은 MOA가 위치 기반 즐겨찾기를 요청하면 실제 네이버 지도 앱 화면이 열리고 터치·입력·리스트 선택이 이어져 사용자가 자신의 스마트폰 화면을 이용할 수 없다.
- 목표: 사용자가 현재 위치/사진 위치에서 저장을 누르면 **가능한 한 MOA 내부에서 끝나고**, 네이버 지도 등록 작업은 **백그라운드·독립 가상 화면·대기 중 별도 실행·PC 보조 처리 등 현실적으로 가능한 경로**로 분리한다. 그동안 다른 앱을 평소대로 사용할 수 있어야 한다.
- '지도 화면 표시'나 'MOA 자체 북마크 저장'은 **네이버 계정에 실제 즐겨찾기 저장 완료와 다르다.** 실제 네이버의 저장 탭·대상 리스트·장소 기록·중복 여부로 확인해야 한다.
- 현재 위치는 **위치 권한을 받은 시점의 좌표**로 명시하고, 촬영 사진의 과거 GPS와 구분한다. GPS 정확도·시각·실내 오차·POI 매칭 후보를 표시하고 사용자가 확인할 수 있어야 한다.
- 촬영한 사진이 여러 장 있어도 한 장소를 80번 중복 등록하지 않도록 방문/좌표/POI ID별로 묶되, 사용자가 서로 다른 장소라고 지정하면 분리한다.
- 앱이 네이버 비밀번호, 쿠키, 계정 토큰을 수집·저장하거나 비공식 비밀 API에 의존해 무단 로그인/무단 요청하지 않는다.

### 2.2 [요구 1-1] 기존 네이버 리스트에만 저장하지 않고 '새 리스트 자동 생성 → 저장'

- 현재는 네이버 계정에 `내 장소` 등 **이미 생성된 리스트**를 이용하거나 사용자가 미리 리스트를 만들어야 한다.
- 목표: MOA에서 `가족 여행/경주`, `카페`, `아이와 갔던 곳`, `2026 가을 여행` 등 리스트 이름·분류를 만들고, **실제 네이버 지도 계정의 리스트에도 생성 및 장소 저장**까지 이어지게 한다.
- MOA 자체 분류(언제든 가능)와 네이버 계정 리스트(외부 서비스의 생성 성공 확인 필요)를 분리 저장한다. 리스트 이름 충돌/기존 리스트 검색/중복 생성 방지/생성 불가/저장 실패/계정 변경/네이버 UI 변경을 처리한다.
- 사용자 정의 리스트, 자동 규칙 후보(방문연도·지역·여행·장소유형), 리스트별 사진/메모/연결 일기, 타사 서비스 교체 가능한 매핑을 지원하도록 설계한다.
- 단순 자동 분류로 사용자의 네이버 계정에 무한 리스트를 생성하지 않는다. 최초 카테고리 정책과 대량 생성은 승인·미리보기·취소가 가능해야 한다.

### 2.3 [요구 1-2] 갤러리 → 네이버 지도 → MOA로 바로 돌아오기

- 현재 사진/영상 갤러리에서 상단 위치 핀을 눌러 네이버 지도를 열면, 확인 후 MOA로 돌아가기 위해 지도 앱 안에서 뒤로가기를 4~5회 해야 하는 불편이 있다.
- 목표는 단순히 한 단계 줄이는 것을 넘어서 **가능하면 지도 확인 후 'MOA로 돌아가기' 한 동작**으로 같은 사진/영상, 같은 갤러리 선택 위치·영상 재생 상태·하단 필름스트립으로 복귀하는 경험이다.
- R227은 `nmap://place` 직접 핀과 NAVER 외부 실행 중 갤러리를 파괴하지 않는 `onPause` 보호가 **정적으로 구현**되었으나 **실제 네이버 앱 내부 Back 1회 및 동일 사진 실기기 QA 미완료**다. 네이버의 내부 화면 스택을 외부 앱이 임의로 지우는 것은 보장할 수 없다.
- 권장 경로들을 별도로 시험한다: (a) MOA의 **내장 경량 위치 미리보기**에서는 외부 네이버를 열 필요 없이 한 번에 닫기, (b) `nmap://place` 최단 화면 진입, (c) 사용자가 탭하는 **MOA 복귀 알림·바로가기**로 원래 항목을 복원, (d) 필요시 명시적 허가를 받은 조심스러운 복귀 오버레이(권한·시스템 제약·네이버 호환 실험 후). 네이버 화면을 강제로 종료하거나 과도한 권한을 요구하는 방식은 기본 경로가 아니다.
- 사진만이 아니라 영상·다양한 인덱스·혼합 미디어·다녀오기 반복·홈 제스처·프로세스 재시작의 성공 범위를 분리 검증한다. **실기기 PASS 없이 1회 뒤로가기 보장 표현 금지.**

### 2.4 [요구 1-3] 바로기록에서 일기/음성/메모/즐겨찾기/학습을 연계

- 기존 바로기록은 카메라 촬영 후 음성 녹음(M4A), 음성→텍스트, 텍스트 메모, 일기 저장이 핵심이다. 이 플로우가 빠르다는 장점과 기존 저장 콜백을 지킨다.
- 목표: 사진/영상과 현재 위치 또는 실제 촬영 GPS를 붙여 **일기 저장**과 함께 선택적으로 **MOA 장소 즐겨찾기 → 네이버 등록 작업**, **학습 자료 생성 대기열**, **영어 표현 초안**, **추억/앨범 분류**를 연결한다.
- UX 원칙: 기본 `기록 저장`은 크게, 음성 녹음/음성 기록/메모는 편리하게 유지. 보조 기능은 별도 **`연결 저장 ▼` 또는 접힌 체크 옵션**에 둔다. 예: `[ ] 지도/즐겨찾기에도 저장`, `[ ] 학습자료로 만들기`, `[ ] 앨범 분류` 등. 화면이 키보드나 버튼으로 과밀해져 기존 빠른 기록이 느려지면 실패.
- 본문, 녹음, 전사, 사진 원본, 일기 연결이 우선 커밋된다. 네이버 반영과 외부 AI 생성이 실패해도 **일기/오디오/메모는 절대 유실되거나 롤백되지 않는다.** 이후 각 작업이 재시도되는 **outbox 방식**으로 처리한다.
- 저장 결과는 `일기에 저장됨`, `MOA 즐겨찾기 저장됨`, `네이버 등록 대기/검토 필요/확인됨`, `학습 카드 생성 대기/완료`를 나누어 보여준다. 사용자가 추적/취소/재시도 가능해야 한다.

### 2.5 [요구 1-4 및 4] 실생활 기록 → 영어·역사·지리·교양·출력 학습

- 사진 속 사물, 하던 행동, 이동, 감정, 가족의 대화, 방문 목적, 음식, 날씨 등 **사용자가 제공한 실제 상황**을 한국어로 정돈하고, **원어민이 일상에서 자연스럽게 쓰는 영어 표현**으로 변환한다. 한국어 직역/교과서식 문장만 내놓지 않는다.
- 영어 단어뿐 아니라 문장·발음 음성(TTS)·듣기·쉐도잉·문장 패턴·동사/전치사(예: `in`, `into`, `in the room`의 공간/이동 차이)·자주 하는 오류·자연스러운 대안·퀴즈·간격 반복을 연결한다.
- 그날의 날짜·촬영시각·계절·나이/발달단계에 맞는 표현·시간대·기온·날씨·지역·나라·역사적 맥락을 학습에 활용한다. **날씨는 실제 관측 데이터 출처가 있을 때만 사실로 표시**하고, 이미지에서 추정한 계절·활동은 추정으로 명시한다.
- 경주 여행 예: 대한민국 → **경상북도** → 경주시(경주는 경남이 아닌 경북) → 해당 장소의 역사·문화재·시대·인물·사건 → 우리 가족이 사진에서 본 것과 연결된 어린이/성인 수준의 지식 카드. 세부 사실은 검증한 출처와 함께 둔다.
- 하나의 소재에서 '이 인물은 어느 나라에 살았는가 → 그 지역은 어디인가 → 동시대의 중요한 사건은 무엇인가 → 지금의 사진·여행지와 어떻게 연결되는가'처럼 **관계 기반 배경지식 가지**를 뻗는다. 불필요한 무한 생성보다는 사용자가 확장할 가지를 선택하게 한다.
- 출력 방향: A4 학습지, 단어 카드, QR 음성 듣기, 여행 사진책, 타임라인, 우리 가족 연표, 스티커/미션북, 아이용 이미지 카드, 가족 교육 포트폴리오. 구매할 프린터 종류와 관계없이 **먼저 표준 PDF·이미지·JSON/CSV로 내보내기**를 설계한다.
- 영어학습용 외부 도구/AI 앱/PC 프로그램으로 내보내고, 추후 MOA 내부 복습기/학습 도구와도 **같은 `LearningItem` 식별자로 왕복**해야 한다. 특정 업체 포맷에 영구 종속되지 않는다.

### 2.6 [요구 2] Windows PC와 Android의 연결·실시간에 가까운 동기화·양 플랫폼 사용

- 사진·영상·원본 자산·선택 일기·자동 사진 달력·가족 일정·음성 기록·장소·학습 자료를 필요에 따라 Windows PC에서 조회/정리/편집/출력하며 Android와 **상호 반영**하는 것이 장기 목표다.
- 사용자는 Codex에서 **0.3v 정도까지 개발한 다른/후속 PC 관련 작업을 잠시 보류**했다고 기억한다. 정확한 산출물/커밋/빌드 경로는 **아직 대조되지 않았으므로 미확인**으로 두고, 해당 파일/브랜치를 먼저 찾아 실제 상태에서 이어갈 것. 기존에 만든 작업을 v0.1부터 무작정 다시 만들지 않는다.
- **증거 확인된 이전 PC 코드:** 같은 저장소 `pcApp/`의 `FamilyJourney PC v0.1`은 Python 로컬 HTTP·브라우저 UI·SQLite·EXIF 촬영일 색인·사진 선택 일기·Windows PC↔PC 수동 ZIP이 있으며 CI **41189841854 SUCCESS** 기록이다. Android R25 JSON 가져오기는 **일기 글/메모 중심**, 자동 양방향 사진·일기 동기화는 **완료되지 않음**. R227과 동일 계층/패키지로 재연동한 제품이라고 주장하지 말 것.
- 초기 실사용은 Windows ↔ 현재 Android MOA **정확한 기존 데이터 구조**로 시작하고, 태블릿·iOS·가족 다기기는 별도 검증 후 확장한다. 가족 일정/대용량 원본/AI 학습까지 한 번에 묶어 동기화 리팩터링하지 않는다.

### 2.7 [요구 3] 현재 앱 설정·기능·의존관계의 지속 관리와 안전한 고도화

- 설정이 무엇을 바꾸는지, 기능과 클래스/JS/브리지/DB/권한/외부 서비스가 어떻게 연결되는지, 한 곳을 수정하면 어느 부분이 영향을 받는지 **기능 단위 영향 지도(Dependency & Impact Graph)**가 반드시 있어야 한다.
- 릴리스마다 '변경 파일·메서드·데이터 계약·예상 영향·보호 기능·검증 근거·미검증·롤백 경로'를 갱신하고 다음 채팅에서도 가장 최신 체크포인트를 읽도록 한다.
- 이 문서와 기능 레지스트리는 형식적인 한 번짜리 보고서가 아니라 **업데이트마다 변경해야 하는 개발 산출물**이다.

### 2.8 [요구 4] 장기 다기능 플랫폼과 대규모 확장

- 훗날 가계부·생활 관리·가족 일정·여행 준비·기념일·지구본·백과 연결·아이 학습·전자책·인쇄 등 다양한 기능이 추가될 수 있다.
- 이때 **MOA 기록의 원본성과 정체성, 불변 골든과 데이터 호환, 복구 가능성**이 우선이다. 독립 모듈로 붙일 수 있는 확장성을 처음부터 계약으로 관리하되, 당장 전면 재작성/새 프레임워크로 갈아타는 것을 목표로 삼지는 않는다.

---

## 3. 네이버 즐겨찾기·외부 앱 연계의 실제 기술 검증 기준

### 3.1 관찰된 기존 구현 이력(현재 R227 구현과 구분)

- 역사적 `FAMILYJOURNEY_R18_NAVER_SAVE_SHEET_USER_SCREENSHOT_FIX_20261031.md`에 과거 `com.juhyeon.familyjourne2` 계열의 `NaverSaveService.java` 접근성 자동화 후보가 기록되어 있다. 사용자 화면에서는 `+ 메모, 별명, URL 추가`, `+ 새 리스트 만들기`, `내 장소 174`처럼 개수가 붙는 항목, 하단 저장 버튼 등이 관찰되었다.
- R18는 180초 만료·지정한 한 작업·`ACTION_SET_TEXT`·UI 상태 확인을 목표로 컴파일됐지만 **실제 네이버 계정에 자동 저장되었다는 기기 PASS 증거가 없다.** 역사적 코드와 현재 R227 `com.juhyeon.familyjournea`가 같은 패키지/서명/컴포넌트라고 간주하지 말 것.
- 과거 문서에는 사용자가 PC에서 주소 기반 네이버 실제 즐겨찾기 등록 성공을 확인했다는 기록이 있으나, **정확한 최신 PC 원본 스크립트와 재현 결과는 아직 확보되지 않았다.** 발견 후 해당 성공 절차를 검증하고 재사용 가능 여부를 평가해야 한다.
- **네이버 앱 URL Scheme 공식 범위:** `nmap://search`, `nmap://place`, 경로/내비 기능으로 네이버 화면을 열 수 있으나 이 명령만으로 즐겨찾기 리스트 생성·추가가 되었다고 말하면 안 된다.

### 3.2 방법별 분류: 가능/실험/불가 주장 금지

| 접근 | 장점 | 현재 제한·입증할 것 | 기본 판정 |
|---|---|---|---|
| **A. MOA 자체 장소·목록 즉시 저장** | 백그라운드·오프라인·빠른 응답, 다른 기능 연계 가능 | 네이버 서버의 실제 저장과 동일하지 않음 | **즉시 개발 가능한 독립 기반** |
| **B. 네이버의 공식 지원 쓰기 API/제휴** | 공식 지원 시 안정적인 진짜 계정 저장 | 일반 개발자에게 장소/리스트 쓰기 API의 공식 제공 여부·인증범위 확인 필요 | **공식 문서 검증 전 지원한다고 단정 금지** |
| **C. 네이버 앱 접근성 UI 자동화** | 기존 R18 상태기계 재검증 가능, 사용자 동의·좁은 작업 | 화면 점유 가능, UI 변경/포커스/권한/스토어 정책, 네이버 로그인 필요, 명시적 사용자 작동 | **실험 기능; 저장 확인 후 승격** |
| **D. Android 가상 디스플레이에 타 앱 실행** | 성공하면 화면 비점유 목표에 접근 | 사설 디스플레이 권한, 타 UID Activity, 입력·포커스, Android 17 제한. 단순 MediaProjection은 화면 캡처이지 백그라운드 독립 NAVER 조작이 아님 | **증거 없는 구현 약속 금지; 별도 기술 PoC** |
| **E. PC/로컬 중계 자동화** | 실제 성공한 PC 경로가 있으면 재활용 가능; 모바일은 계속 사용 가능 | PC가 켜짐·로그인 유지·정확한 성공 소스·보안·동기화·오프라인 대기 필요 | **선택형 백엔드 드라이버** |
| **F. 네이버 모바일/웹 페이지 조작** | 일부 저장 UI를 직접 접근할 수 있는지 조사 가능 | 계정 세션·DOM 변경·사이트 정책·인증·캡차·보안 우회 금지 | **공식 허용 경로/동의와 실사용 증거 있을 때만** |

- root/Shizuku, 비공식 인증 탈취, 네이버 비공개 엔드포인트 리버스 엔지니어링, 백그라운드 화면 강제 납치, 접근성 임의 자율행동을 **기본 해결책으로 채택하지 않는다**. 자동화는 사용자 명시적 트리거를 가진 좁고 결정적 흐름이며 권한 고지/철회가 가능해야 한다.
- `nmap://place`로 위치가 보이는 상태, '저장' 버튼이 눌린 상태, 실제 서버에 저장된 상태는 서로 다른 검증 단계다.

### 3.3 데이터와 상태기계

```text
MoaPlaceSavedLocal → POI_REVIEW_REQUIRED? → NAVER_QUEUED
→ DRIVER_READY → NAVER_LIST_LOOKUP → NAVER_LIST_CREATE_REQUIRED?
→ NAVER_PLACE_MATCH → NAVER_SAVE_SUBMITTED
→ NAVER_VERIFY_READBACK → NAVER_CONFIRMED
                                  ├→ NAVER_UNVERIFIED / 사용자 확인 필요
                                  └→ NAVER_FAILED_RETRYABLE / 영구 실패 / 취소
```

- 키: `moaPlaceId`, 좌표/정확도/시각/출처, `naverPlaceId?`, `moaListId`, `naverListId?`, `jobId`, `attempt`, `lastVerifiedAt`, 확인 증거·응답, 자동화 방식 버전. **계정별 리스트 ID와 로컬 이름을 1:1로 혼동하지 않는다.**
- 동일 위치·POI·계정·리스트에 대한 idempotency key로 재실행/재부팅 후 **중복 저장 방지**. 등록 취소/장소 삭제는 처음부터 다른 작업으로 관리하며, 임의로 네이버의 기존 자료를 지우지 않는다.
- 위치 확신이 낮거나 서로 다른 가게가 밀집되어 있으면 `후보 검토` 상태. 사진 EXIF가 없으면 '현재 위치'를 과거 사진의 촬영 장소로 위조하지 않는다.
- 도중 화면 포커스가 바뀌거나 사용자가 직접 네이버를 조작하면 자동화를 안전하게 중지하고, 재개는 사용자 선택. 저장 작업 때문에 가족 사진/일기 데이터가 변하지 않는다.

### 3.4 갤러리→지도→복귀: 상태 스냅샷 필수

- 출발 전에 `origin=gallery`, 미디어 안정 ID·선택 index·전체 ordered media list hash/필터, 하단 offset, 확대/영상 currentPosition/playing, source Diary/Map route, 캡처 정보 card 상태를 저장한다.
- 복귀 시 **동일 이미지/영상 인덱스**가 우선이다. `onPause`에서 외부 NAVER 진입만 이유로 갤러리 닫기 금지(기존 R227 원칙). 프로세스 종료 후 복구는 별도 스냅샷 영속화/QA로 확장한다.
- 반환 UI의 선택지는 `앱 안에서 위치 보기`(외부 스택 없음), `네이버 상세 보기`(최단 딥링크), `MOA로 돌아가기`(명시적 사용자 동작)로 구분할 수 있다. 외부 네이버의 Android Back 하나만으로 강제 종료할 수 있다고 확언하지 않는다.

---

## 4. 순간기록 → 하나의 경험(Event)과 여러 산출물로 연결

### 4.1 단일 경험 레코드 개념

**사용자 입력:** 사진/영상 1개 또는 여러 개, 촬영/방문 시각, 메모, 녹음 M4A, 인식 텍스트, 정확한 GPS 또는 '없음', 감정/행동/동행(선택), 방문 장소 후보(선택).

**공통 연결:** `ExperienceEvent`의 안정 ID가 DiaryEntry, MediaAsset, Recording, Place, FavoriteJob, LearningSource, Album, FamilyCalendarEvent, ExportJob을 잇는다. **이들을 한 테이블에 섞거나 원본 DB를 한 번에 갈아엎지 않는다.** 기존 레코드에 read-only 또는 부가 링크 인덱스를 붙이는 **strangler/adapter 방식**부터 시작한다.

### 4.2 UI 행동 계약

- 사진 촬영 후 현재 골든의 `모아` 이동·`바로기록` 진입·작은 `X` 닫기/자동 닫힘, 편집 설정·8방향 리사이즈와 기존 음성/녹음/메모의 손맛을 깨지 않는다.
- 기록 화면의 주 버튼과 상단 텍스트 영역·키보드 가시성을 보호한다. 학습/지도 옵션을 스크롤해야만 글쓰기 가능한 UI로 만들지 않는다.
- 선택적 보조 섹션의 모의 화면 의미: `기록하기` → `[기본] 일기에 저장` / `[선택] 지도에 저장` / `[선택] 학습카드 만들기` / `[선택] 여행앨범에 추가`.
- `일기 저장`은 기존 로컬 DB/음성 원본 저장의 성공으로만 표시. 네이버 반영/AI 학습은 별도 상태·배지·재시도 메뉴. 네이버 실패로 일기 저장 실패 Toast를 띄우면 안 된다.
- 녹음·전사·파일 보관은 '기록 생성 당시 원문'과 '후속 편집본'을 구분. 외부 TTS/AI 모델은 원문을 덮어쓰지 않는다.
- 자동 생성되는 키워드·장소명·설명·영어는 반드시 **사용자 정정 가능**하고, 정정 사실이 다음 생성과 검색에 반영되어야 한다.

### 4.3 일기 저장과 확장 작업의 트랜잭션 분리

1. 원본 사진 참조와 음성/텍스트/일기 저장(기존 golden 경로). 성공 시 로컬 커밋.
2. 동일 커밋 또는 후속 안전 트랜잭션으로 `ExperienceEventId`와 관계/outbox 작업을 idempotent 기록.
3. 별도 서비스가 장소 후보 탐색, 네이버 동기화, AI 생성, PC 동기화/프린트 준비를 수행.
4. 재부팅/전파 오류/권한 거부 시 지수 백오프, 중복 방지, 명확한 오류 상태, 수동 취소.
5. 확장 작업 삭제는 링크나 파생 카드만 삭제한다. 원본 일기/사진/녹음은 자동 삭제 금지.

---

## 5. 일상 학습 엔진 설계 — 한국어·영어·지리·역사·연상·인쇄

### 5.1 다단계 학습 파이프라인

1. **원본 증거 수집:** 촬영 사진/영상, 녹음, 음성→텍스트, 직접 작성 메모, 정확한 시각과 GPS, 사진 파일 해시. 출처와 작성/수정 시각을 기록.
2. **한국어 장면 기록:** 사용자가 실제로 한 말·행동을 시간 순서로 정리. '사진에서 확인 가능'과 '사용자 설명'과 'AI가 추정한 내용'을 분리 표시. 얼굴/감정/관계·연령 등을 사진만으로 단정하지 않는다.
3. **맥락 보강:** 연·월·일·요일·현지 시각·계절, 행정구역(나라→광역자치단체→도시), 장소 카테고리, 출처 있는 기상/역사/지리 사실. 경계·행정구역·시간대 변경을 처리하고 사실에 근거 링크를 단다.
4. **자연스러운 영어화:** 원문 의미 보존 + 실제 일상에서 쓸 자연스러운 문장 1~3개, 아이/부모 난이도, 구어체/정중체, 핵심 문형·전치사·시제·발음·연음·어휘·동의어. 예: 방 **안에** 있음 `in the room` ↔ 방 **안으로 들어감** `go into the room`(상황에 맞는 전치사), 단순한 한국어 조사 대체가 아님.
5. **듣기와 말하기:** TTS(영국/미국 등 선택), 문장/단어 속도, 구간 반복, 자신의 녹음과 비교(옵트인), 쉐도잉/딕테이션. 아이 발화 기록은 본인이 정정할 수 있게 하고 점수화로 위축시키지 않는다.
6. **의미 연결:** 장소 → 지리 → 문화/역사 → 관련 인물/사건 → 언어/과학/생활의 원인·결과 연결. 한 가지씩 단계 확장, 오래된 카드와 연결, 학습 난이도와 자료 출처 보존.
7. **복습과 퀴즈:** 단어/문장 카드, 사진 보고 말하기, 참/거짓, 순서 배열, 지도에서 찾기, 과거 사진 회상, 간격 반복(예: SM-2 계열 연구 후보; 알고리즘은 구현 시 확정), 오답 기록·부모 피드백.
8. **정리와 출력:** 생활 사진첩, 교육용 1~2쪽 요약, 단어장, 주간 복습지, 테마 학습지, 역사 연표, 여행지도, QR로 연동되는 음성학습, PDF/출력. 가족 데이터 공유/내보내기 전 개인정보 선택 제거.

### 5.2 경주 여행 사례(실제 사용자 아이디어 보존)

- 출발점: `가족이 경주에 놀러 감` → 사진/영상/한글 메모/목소리/촬영 시각/원본 GPS를 연결한다.
- 지도 가지: `지구 → 아시아 → 대한민국 → 경상북도 → 경주시 → 확인된 촬영 장소`. **경주가 경남이라는 가정은 사실이 아니므로 검증된 행정구역으로 정정**한다.
- 상황 가지: `무엇을 봤나? 누가 무엇을 했나? 어디로 걸어갔나? 무엇을 느꼈나?` → 자연스러운 영어 `We visited ...`, `We walked into ...`, `We were inside ...` 등 실제 맥락에 맞는 예문 선택.
- 역사 가지: **촬영 장소가 정확히 무엇인지 검증한 뒤** 해당 유적/시대/관련 인물/사건·문화유산을 어린이용/성인용으로 풀어낸다. 사진 위치만으로 임의의 특정 역사 유적을 만들어 내지 않는다.
- 배경지식 가지: 경주의 시대/역사 → 당시 생활·건축·문화 → 연결된 다른 도시/인물 → 다른 여행 사진으로 이동. 출처와 '더 알아보기'를 남긴다.
- 기억 강화: 그 사진을 다시 보여 주며 “우리는 어디에 있었지?”, “영어로 '방 안에'와 '방 안으로'는 어떻게 다른가?”, “경주는 어느 도에 있을까?”를 묻는다.
- 프린터: 그날 사진과 한글 일기, 영어 문장, 3~5개 핵심 단어, 발음 QR, 작은 지도, 역사 한 토막, 퀴즈를 PDF 한 묶음으로 출력한다.

### 5.3 지식 그래프(Knowledge Graph) — 관계는 얇고 출처는 강하게

```text
Person/FamilyMember --participatedIn--> ExperienceEvent
ExperienceEvent --capturedBy--> MediaAsset
ExperienceEvent --describedBy--> DiaryEntry/Transcript
ExperienceEvent --visitedAt?--> Place --locatedIn--> City/Region/Country
ExperienceEvent --generated--> LearningItem --relatedTo--> Concept
Concept --relatedTo--> Concept / HistoricalEvent / Person / Era
LearningItem --reviewedIn--> StudySession / PrintEdition
ExperienceEvent --includedIn--> Album / Trip / Timeline
```

- 기본 단위로 `id`, `type`, `sourceRefs`, `author`, `createdAt`, `updatedAt`, `confidence`, `verified`, `visibility`, `schemaVersion`을 가진다.
- `FACT_VERIFIED`, `USER_REPORTED`, `AI_SUGGESTED`, `UNKNOWN` 등 근거 등급을 분리하며 자동 추론을 개인의 사실 원본으로 승격하지 않는다.
- 사람·아이·장소 이름은 비공개가 기본. 필요한 경우에만 가명·위치 정밀도 낮추기·얼굴 흐림·동의 상태를 저장한다.
- 학습카드와 지식 그래프는 **원본 사진/일기와 분리된 파생 계층**으로 두어 AI 재생성/공급업체 변경이 원문에 영향을 주지 않도록 한다.
- 온라인 AI가 불가능할 때도 사용자가 한국어/영어 문장, 단어, 역사 링크를 수동 작성·수정·출력하는 오프라인 기본 기능을 제공한다.

### 5.4 학습 도구 선택 기준 — 업체명을 먼저 고르지 않는다

- **입력:** 사진/영상/음성/글/원본 메타데이터를 선택적 전송할 수 있는가? 아동 사진을 보내지 않고 **익명화된 텍스트만**으로도 학습 가능해야 한다.
- **생성:** 한국어 자연스럽게 정리 + 원어민 회화 영어화 + 문형/어휘/발음 + 실제 근거 있는 역사/지역 정보 검증 + 난이도별 버전.
- **학습:** TTS, 단어·문장 반복, 간격 반복, 발음 연습, 퀴즈, 부모 검토, 실생활 복습, 오프라인 캐시.
- **교환:** PDF/JSON/CSV/HTML 등 공개 포맷, 향후 Anki형 카드 내보내기 등은 검증 후 어댑터로 추가; 특정 벤더에 학습 기록을 잠그지 않는다.
- **비용/성능:** 신규 유료 서비스 필수 사용을 기본으로 전제하지 않는다. 로컬·기기 TTS·무료/기존 도구·PC 후처리 후보를 먼저 평가하고 선택적 클라우드 AI 경로를 둔다. 제공 모델·요금/라이선스는 구현 당시 다시 확인한다.
- **정확성:** 역사·지리·기상·언어 설명은 정보 출처, 생성 시점, 검증 상태, 교정 이력을 함께 보관. 외부 API가 실패해도 원래 기록은 정상.

---

## 6. Windows↔Android 동기화와 PC 작업실

### 6.1 증거에 기반한 현재 상태

- `pcApp`에는 **Windows 휴대형 FamilyJourney PC v0.1** 코드/README와 `build-familyjourney-pc.yml` 이력 존재. 로컬 `127.0.0.1` 임시 포트 브라우저 UI, SQLite 파일 `%USERPROFILE%\Documents\FamilyJourney\familyjourney.sqlite3`, PC 폴더 EXIF 인덱스, 수동 일기 JSON import/ZIP 내보내기/가져오기가 구현되었다고 기록됨.
- 해당 PC 코드는 **R227 원본 갤러리·음성·지도·학습과 동등 기능을 가진 검증된 동기화 제품이 아니다.** Android R25 ID 기반 기록의 글/메모만 가져오는 한계가 명시됨.
- 사용자가 언급한 **Codex PC 프로그램 'v0.3 정도'**의 다른 브랜치/소스/실기기 성공 로그를 확인하기 전 **v0.3 완성/부재 단정 금지**. 먼저 `pcApp/`·전체 GitHub branches/workflows/CI artifacts·사용자 기존 ZIP과 비교하여 최신 재사용 가능 산출물을 확정한다.

### 6.2 동기화 제품 원칙

- **로컬 우선:** 휴대폰·Windows 각각 네트워크 없어도 기록·수정·읽기가 가능해야 한다. 저장 즉시 UI에 '로컬 저장'이 보이고 네트워크 복제 여부는 별도 표시.
- **양방향 증분:** 전체 사진을 계속 복사하지 않고 변경된 논리 레코드 + 명시적으로 허가된 첨부 자산만 전송. 사진의 Android `MediaStoreId`, iOS `PHAssetId`, PC `C:\...` 경로를 공유 전역 ID로 쓰지 않는다.
- **안정 ID:** `eventId/entryId/assetId/deviceId/opId` 생성, 파일 원본 SHA-256과 기기별 URI 매핑. 원본 변형·편집 사진은 별도 자산/parent ID로 연결; 모든 원본을 매번 재해시해 배터리를 소모하지 않는다.
- **안전한 충돌 관리:** 기기별 revision·oplog/outbox·서버/동기화 시퀀스·tombstone·취소·복원·중복 적용 방지. 같은 글을 두 기기에서 수정하면 마지막 수정시각 하나만 보고 **무조건 덮어쓰지 않는다**. 자동 병합 가능한 항목과 사용자 선택 필요한 항목을 구분한다.
- **삭제 보호:** 갤러리 사진/일기/음성 파일 삭제·권한변경/MediaStore ID 재할당·갤러리 원본 이동을 예상. 다른 기기의 원본 사진을 기본으로 자동 삭제하지 않는다. '일기에서 사진 링크 제거'와 '파일 삭제'를 분리.
- **전송 경로:** 초기에는 USB/LAN/명시적 ZIP import-export로 데이터 계약 검증 → 개인용 동기화 허브/암호화 백업/필요 시 클라우드 Realtime 검토. Google Drive는 선택적 백업/복구에 적합하지만 자동 수초 이하 양방향 편집 보장의 주 경로라고 단정하지 않는다.
- **실시간 가족 편집:** 나중에 사용자의 승인에 따라 Supabase/Firestore/자체 서비스 **중 하나**를 선택해 RLS/권한·오프라인 큐·변경 피드+누락 복구를 구현. 첫 단계에서 두 백엔드를 동시에 만들지 않는다. 0.1초 동기화 보장 같은 수치를 증거 없이 광고하지 않는다.
- **원본 업로드 선택:** 1만 장 이상 개인 사진 전체 자동 업로드 금지. 사진 미리보기와 원본의 다른 동기화 정책, 와이파이/충전/요금제/용량 제한, 로컬 암호화와 가족 공유 권한 분리.

### 6.3 PC에 필요한 기능 범위

- 사진 폴더/EXIF·GPS·동일/중복 사진·촬영 날짜별 색인, 대량 사진 성능과 중단 재개.
- 갤럭시 일기/기록/메모/M4A/음성 전사와 연결된 사진·영상 검색·편집(원본 비파괴).
- 지도·방문기록/네이버 등록 대기열/장소 리스트 관리, PC에서 확인된 자동 저장 수단이 있다면 별도 드라이버로 연결.
- 영어학습 한국어/영어 비교 편집, 용어장, 지리/역사 확장 카드, 여러 사진 묶음 배치 생성·검수.
- 출력용 앨범/학습지/여행기/연표·PDF 표지/목차·인쇄, 원본 보존형 내보내기.
- 동기화 상태/충돌/백업/검증/복원 대시보드, 사용자 데이터가 외부로 전달되는 항목 투명 표시.
- PC는 내부적으로 브라우저 UI일 수 있지만 최종 사용성은 **사용 가능한 Windows 프로그램**으로 검증해야 한다. 모바일 원본 기능이 손상되면 PC 기능이 늘어나도 실패.

### 6.4 동기화 QA

- Android에서 기록/사진 연결 생성 → Windows에서 확인/수정 → Android 재실행 후 수정 반영 → Windows/Android 동시 편집 충돌 검토.
- 네트워크 OFF·접속 변경·중복 전송·동일 ZIP 2회 import·중단 후 재개·대용량 사진·파일 경로 변경·권한 회수·데이터베이스 백업 복원을 각각 확인.
- 기존 `familyjourney-diary-v1/curated` 및 사진 선택 일기 vs 자동 사진 달력의 구분을 보존. 잘못된 sync가 전체 일기/사진·영상 목록을 바꾸면 즉시 실패/rollback.

---

## 7. 소프트웨어 구조 원칙: 현재 골든을 지키는 확장형 Modular Monolith

**금지:** 새로운 장기 방향을 이유로 R227 전체 네이티브 갤러리, WebView, Diary/Map JS, 녹음, 서명, IndexedDB를 한꺼번에 Flutter/Compose/React/서버로 **재작성**하는 것. 구조화는 기존 엔진 위에 **방화벽처럼 추가 모듈을 하나씩 붙이는 방식**으로 진행한다.

### 7.1 책임 분리 모듈 목록(설계 목표)

| 모듈 | 소유 데이터/책임 | 외부 의존/영향 범위 |
|---|---|---|
| `CaptureAdapter` | 카메라/원본 미디어 ID·시각·GPS 읽기 | 현행 native 사진 저장·권한, 원본 파일은 불변 |
| `DiaryGateway` | 기존 일기/메모/M4A/전사 읽기·기존 저장 콜백 | `familyjourney-diary-v1`, curated, Web/native bridge **보존** |
| `ExperienceIndex` | 기록의 안정 ID와 원본 사이 관계·출처 | 새 sidecar DB/ID 매핑, 원본 DB migration 최소화 |
| `GeoEvidence` | 정확한 위치·출처·POI 후보·주소/행정구역 | EXIF·MediaStore·기존 지도 DB; 근거 없는 GPS 생성 금지 |
| `PlaceCollections` | MOA 로컬 목록·장소 분류·중복 관리 | 네이버와 독립, 사용자 수정 가능 |
| `NaverSyncAdapter` | 네이버 외부 로그인 존중·리스트/즐겨찾기 등록 큐/확인 | 공식 API/조건부 Accessibility/PC 드라이버 등 **교체 가능** |
| `ExternalNavigation` | 지도 딥링크와 같은 사진 복귀 | R227 native gallery `onPause/onResume`, stack snapshot |
| `QuickRecordLinker` | 기존 바로기록 저장 후 연결 작업 생성 | 음성/텍스트/일기 원본 콜백과 분리 |
| `LearningSources` | 한국어 기록/메타데이터/권한 정규화 | 원본 비파괴, AI 전송은 opt-in |
| `EnrichmentProviders` | 영어·지리·역사·기상·출처 연계 | 로컬/외부 공급자 어댑터, AI 추정 표시 |
| `KnowledgeGraph` | 장소/시간/행동/개념/관계 | 출처·confidence·corrections, original과 분리 |
| `StudyEngine` | 음성/TTS·카드·퀴즈·간격복습·학습 통계 | 사용자 수준·동의·오프라인 캐시 |
| `PrintExport` | PDF/사진책/학습지/JSON·CSV 출력 | 프린터 기종 비종속, 권한 검토 |
| `SyncEngine` | PC/다기기 변경 기록·중복 방지·충돌·백업 | 로컬 우선, 스토리지/네트워크와 분리 |
| `FamilyCalendar` | 일정·알림·반복·일기 링크 | 별도 DB, 기존 일기 무단수정 금지 |
| `SettingsRegistry` | 설정 키/기본값·UI/구현/영향 기능/QA | 호환 migration·수정 뒤 설정 테스트 |
| `Diagnostics/ReleaseQA` | 로그·상태·빌드/복구/회귀 결과 | 개인 정보 자동 마스킹 |

### 7.2 데이터계약 기본 예시(아직 구현 확정 스키마 아님)

```json
{
  "schema": "moa-experience-v1-proposal",
  "experienceId": "stable-uuid",
  "occurredAt": "ISO8601-with-offset-or-unknown",
  "mediaRefs": [{"assetId":"stable-uuid","localUriRef":"device-scoped","sha256":"optional"}],
  "diaryRef": {"existingStore":"familyjourney-diary-v1","localKey":"device-scoped"},
  "voiceRefs": [{"recordingId":"stable-uuid","transcriptRef":"optional"}],
  "location": {"lat":null,"lon":null,"accuracyM":null,"source":"original_exif|device_live|user_pin|none","verified":false},
  "places": ["moa-place-uuid"],
  "derived": {"naverJobIds":[],"learningIds":[],"albumIds":[]},
  "provenance": {"source":"user|device|external_verified|ai_suggested","schemaVersion":1},
  "sync": {"revision":0,"lastOpId":null}
}
```

- 시간: `takenAt`(촬영), `occurredAt`(실제 경험), `createdAt`(기록 작성), `editedAt`, `weatherObservationAt`, `ingestedAt`은 서로 별도. 임의로 하나로 합치지 않는다.
- 장소: 사진 찍힌 GPS, 현재 기기 GPS, 사용자가 선택한 실제 방문지, 네이버 POI 검색 결과를 **별개의 근거**로 유지. 국내 주소가 없는 경우도 정상 처리.
- 학습: 원본 한국어·수정 한국어·AI 영어·사용자 영어 정답·TTS 메타·출처·검증·복습 이력을 분리 저장.
- 개인정보: 사람 이름, 미성년자·얼굴·세부 GPS, 위치 히스토리, 건강·금전정보 등 민감한 파생 기록은 접근권한·기기/클라우드 보존·삭제 계약을 따로 가진다.

### 7.3 확장 규칙

1. **플러그인과 DB를 구분:** 학습 공급자/네이버 드라이버/PC 동기화는 교체 가능한 adapter. 실제 핵심 데이터와 의도하는 사용자 행동은 플랫폼 중립 도메인으로 유지.
2. **원본을 감싸기:** 기존 UI·native Java/DEX·Web JS를 분석해 '읽기 래퍼→새 sidecar 쓰기→신규 화면' 순서로 구현. 골든 기존 파일을 정리 목적으로 대거 수정하지 않는다.
3. **역호환 migration:** 새 스키마가 이전 기록을 읽지 못하면 실패. migration 전에 전체 백업 검증과 복구 가능 여부. 새 앱 설치 후 Android app data clear/uninstall 금지.
4. **경계 단위 테스트:** `Capture↔Diary`, `Diary↔Voice`, `Gallery↔Map`, `QuickRecord↔Favorite`, `Favorite↔Naver`, `Experience↔Learning`, `Sync↔PC`, `Print↔Privacy` 각 계약을 테스트.
5. **Feature flag:** 새로운 UI/AI/네이버 드라이버는 기본 OFF/안전모드 또는 사용자 선택 가능. 끄더라도 기존 데이터에 영향이 없어야 한다.
6. **성능:** 만 장 이상 사진, 대용량 동영상, 오프라인·배터리·권한 변동·작업 큐, 메모리/CPU 부하·백그라운드 수명을 측정. 새 인덱스를 위해 사진 전체를 매 실행 재스캔하지 않는다.

---

## 8. 살아 있는 기능 명세·코드 지도·설정 레지스트리: 개발할 때마다 강제 갱신

### 8.1 반드시 관리할 문서/DB 항목

1. **Feature Inventory (실제 현재 버전 기준):** `featureId`, 이름, 사용자 진입 화면, 역할, 승인범위, 구현/물리검증 상태(`IMPLEMENTED|STATIC_PASS|DEVICE_PASS|FAIL|NOT_TESTED|PLANNED`), 알려진 회귀, source owner.
2. **Source Map:** 파일·클래스·메서드/JS 함수·브리지 이름·Native↔Web 호출, Manifest 선언·권한·Android SDK 제약, config flags.
3. **Data Contract:** IndexedDB store/database·SQLite 테이블·MediaStore ID·M4A 경로·prefs key·백업 포맷/버전·암호화/권한·읽기/쓰기/삭제 주체.
4. **Call/Impact Graph:** 예를 들어 갤러리 수정이 지도 팝업 OFF, 원본 EXIF, 외부 Naver return, 촬영 메모, 영상 필름스트립에 영향을 미칠 수 있음을 source별로 연결. 녹음 종료 수정이 Web native MediaPlayer, Diary 닫기, 홈/Back/탭 전환에 영향을 줄 수 있음을 기술.
5. **UX & Settings Registry:** 설정명/키/기본값/OFF 의미/기존 사용자 값 보존/모바일·PC 노출/UI 위치/수정 영향/QA.
6. **Regression Matrix:** 사용자 실기기 합격/정적만 PASS/실패/미검증을 분리. 기종·OS·시간·증거 캡처/로그·빌드 해시·실패 재현 단계를 기록.
7. **Release Ledger & WIP:** 각 배포 APK/ZIP/커밋/브랜치/서명/원본 대비 변경 멤버와 미검증, 현재 최우선 문제·복구 경로.
8. **Decision Log & Roadmap:** 도입/기각한 방법, 이유(특히 가상화면·외부 API·전면 리팩터링), 근거, 잠정 여부, 다음 검증 게이트.
9. **Privacy & Export:** 가족 데이터 중 외부 송신 대상·동의·철회·보존/삭제·익명화·권한·백업 상태.

### 8.2 매 변경 시 Impact Report 필수 필드

```text
CHANGE_ID / Date / User request / Priority
BASE_GOLDEN_APK_SHA / BASE_BRANCH_SHA / New branch / Target versionCode
Changed source files + methods + APK ZIP members
Before behavior / After behavior / Explicitly unchanged behavior
Affected screens / Web-to-native calls / DB stores / Manifest permissions / Settings keys
Read-write paths / Sync implications / External APIs / Privacy implications
Existing Golden protections / Risk category / Feature flag / Rollback-forward path
Test plan: unit / contract / integration / device / network / update-install
Exact results: PASS | FAIL | NOT_TESTED per gate + evidence/log SHA
Build CI run/artifact / direct APK SHA / ZIP inner APK SHA / APK v2+signer cert
WIP + Ledger + Feature Inventory + Source Map + Settings Registry updates
Open issues / Next work / Future new-chat handoff
```

- 영향 파일을 모른다는 이유로 수정부터 시작하지 않는다. 구현 전에 호출 관계와 저장 경로를 조사하고, 자료가 없으면 **UNKNOWN/조사 필요**로 표시.
- 반드시 **한 릴리스당 작은 변경 범위**로 분리. 'UI 예쁘게 정리하면서 마이크/갤러리/네이버/데이터까지 교체' 같은 결합 수정 금지.
- 골든 정적 검증과 실기기 검증은 별도 열로 관리. 'CI 성공'은 '사용자 폰에서 정상 동작'을 뜻하지 않는다.

### 8.3 R227에서 보호해야 하는 회귀 계약(지난 오류 이력)

- R203/R215 회귀: **위 큰 사진·영상은 한 번 스와이프에 정확히 한 장**, 아래 필름스트립에서만 다중 관성, 선택 항목에 맞춰 위 화면 동기화. 이웃 썸네일 파도식 흔들림 금지.
- R209/R219: 삼성 갤러리 비교 정확한 작은 mute/capture 아이콘, 배치·음소거/오디오 세로 볼륨 컨트롤, 캡처 미리보기, 중복 완료 Toast 금지.
- R211: 지도 팝업 `moa.gallery.return.sheet.v1` OFF(미설정 포함) 시 **직접 최신 native gallery**, ON일 때만 장소 시트. 구형 뷰어 재도입 금지.
- R217/R219: 일기 음성 재생 후 안드로이드 Back, 내부 Diary 닫기, 탭 전환, Home 시 **실제 native `stopPlayback()`**, JS playing flag가 null이어도 반드시 중단.
- R219/R221: 바로기록 큰 빨간 알약·고정 크기 회귀 금지, 작은 원+작은 X(터치 안전 ≥44dp), 8방향 resize/가로세로 독립·방향별 위치/크기 저장, 투명도/크기·자동닫힘 설정.
- R223: `음성 기록` → `기록 종료` → `인식 정리` → `음성 기록`, 듣는 중에도 중지 가능. 구형 마이크 이모지/버튼 재등장·키보드 겹침 금지. M4A·일기 원본 기록 보존.
- R225/R227: 사진/영상별 실제 촬영 시각·주소/GPS·네이버 핀, 긴 주소 표시, 검증되지 않은 GPS/추정 장소 만들지 않음, 원본 EXIF 허용권한, `nmap://place` 직접 열기. 외부 네이버 전환 시 갤러리 onPause가 원본 객체를 파괴하는 회귀 금지.
- R227: 선택 영상의 장면 필름스트립은 아래 전체 영역으로 펼쳐 이웃 썸네일을 밀며 드래그 seek/탭 접기. 펼침 상태가 상단 한 장 전환/하단 관성을 깨면 실패.
- 모든 버전: 카메라 촬영, 위젯/오버레이, 녹음, 일기·음성·메모·사진/영상 파일, 개인 기록, 설정, 업데이트 설치, 서명/데이터와 다른 골든까지 보호.

**주의:** 위 일부 항목은 코드의 정적 PASS 또는 과거 사용자 승인 범위가 있을 뿐, **R227의 전체 갤럭시 재현 검증은 미완료**. 금지 조건을 적었다고 PASS가 되는 것이 아니다.

---

## 9. 단계를 나눠 완성하는 권장 개발 순서와 수락 기준

**P0 — 증거 동결/현상 인벤토리(먼저 수행).** R227 exact binary SHA, signer/manifest/DEX v2, 기존 사용자 실기기 최신 증거, UI/기능 Source Map, old NAVER R18 코드 및 성공 PC 자동화 실체, Codex PC v0.3 실제 branch/artifact, DB/설정/권한/네트워크 의존을 확인. **산출물:** `FEATURE_INVENTORY`, `IMPACT_GRAPH`, `SYNC_BASELINE`, `NaverDriverCandidate`, QA Open 표. 골든 APK 변경 없음.

**P1 — R227+ 작은 기능으로 'MOA 자체 장소/리스트 저장 + 저널 연결'.** 네이버 외부 계정과 독립된 안전한 `PlaceCollections`와 일기/사진 링크·재시도 큐를 신설. MOA 로컬 즐찾이 오프라인에도 저장되고 같은 사진에 다시 돌아올 수 있는지 우선 확인. **신규 versionCode >227**, 동일 서명, 새 feature branch, 이전 필름/음성/설정 회귀 PASS.

**P2 — 외부 지도 복귀 UX 개선(독립 릴리스).** R227 `nmap://place`/onPause 기준에서 실제 Galaxy 반복 테스트 후 `내장 지도 미리보기` 또는 사용자 액션형 `MOA로 돌아가기`를 추가. 동작/권한 별로 테스트해 승격. 외부 네이버의 강제 1-Back을 완성이라고 광고하지 않음.

**P3 — 네이버 리스트 자동생성·즐겨찾기 동기화 PoC.** 공식 API 지원 확인, 역사적 R18 접근성·실기기 UI, 가상 디스플레이, 사용자가 성공한 PC 드라이버를 **독립 실험으로 비교**. 최종 유저가 화면을 계속 사용할 수 있는지, 실제 NAVER 계정·리스트 반영 readback, 중복방지·로그인/취소·앱 업데이트 대응을 검증. 미달 시 MOA 로컬 완전 저장+네이버 대기만 제공하고 상태를 정직하게 표시.

**P4 — 바로기록 확장(독립 릴리스).** 빠른 일기·음성/M4A·메모 저장을 그대로 두고 선택형 즐찾/학습 큐/앨범 태그를 sidecar로 연결. 키보드·화면 크기·8방향 팝업·다중 저장 실패와 데이터 무손실 QA.

**P5 — PC 동기화 기반/프로그램 고도화.** 기존 `pcApp` v0.1과 사용자 언급 v0.3의 실제 소스를 비교→R227의 공통 식별자/백업/증분 프로토콜→Android↔Windows 한 방향 import/export→검증 후 양방향·충돌/복원. PC에서 사진·일기·학습 원본 연결까지 성공한 뒤 온라인 실시간 옵션 검토.

**P6 — 한국어 기록 보강·영어 학습 MVP.** 가족 실제 사진 하나를 한국어→영어 자연스러운 문장→발음/TTS→단어·문형 카드→복습까지 이어서 완결. `사용자 사실/AI 추정` 표시·교정·재생성·오프라인 보존 검증. 여러 공급자·배치 처리·개인정보 전송 제어.

**P7 — 역사·지리 연쇄 지식 + 앨범·인쇄.** 정확한 장소/국가·행정구역/역사 소스 연결, 지식 그래프 및 부모 편집·아이용 뷰, 사진 앨범·PDF 학습지·QR 발음·사진책/연표 출력. 방문지 추론 오류와 출처 없이는 사실 카드 자동 확정 금지.

**P8 — 생활 플랫폼 확장.** 가족 일정/반복·알림/여행 지구본/가계부 등은 새 모듈로 독립 추가, 필요시 부부/가족 공유 권한을 분리. 이미 존재하는 일정 5번째 탭·기존 코드와 충돌 분석 후 점진 구현.

**모든 단계의 Gate:** (1) 새로운 기능 자체 (2) 전체 골든 회귀 (3) 사용자 데이터 생존 (4) original signer/update-install (5) 정적 서명/DEX/ZIP integrity (6) 실기기 여부 구분 (7) 새 기기/PC 동기화 시 실패·재시작 복원. 실패한 단계는 다음 단계에 섞지 않는다.

---

## 10. 릴리스·브랜치·개인 Library 정책(변경 금지)

1. R227 exact APK SHA `53c4c04ce32ad13de3c0613f4e5ec7abbc75ccbdfe9db5da05d8fa9b806ec6cd`, `versionCode=227`, cert `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`와 `GOLDEN_R227_20261109`의 파일은 **새 요구라도 덮어쓰지 않는다**.
2. frozen source branch `golden/moa-r227-20261109-user-designated-preserve-device-qa-open`도 건드리지 않는다. 새 기능은 현재 유효한 서명 baseline을 복사한 신규 `feature/moa-r228plus-<one-scope>-<date>` 등 **별도 branch**에서, **higher versionCode**로 적용.
3. 원본 앱 `com.juhyeon.familyjournea` package와 signer 유지. 앱 삭제, `pm clear`, 저장소 초기화, 서명 변경, ADB 페어링 삭제나 기기 재설정 요구 금지. `versionCode`만 높이고 이전 데이터/DB/설정/음성 파일을 보존하는 update-install.
4. 브랜치와 코드 변경 전에 `git diff`, 실제 APK 130 member content hash 비교, protected files semantics, manifest, v2 signature/full APK digest, DEX checksum, ZIP CRC/alignment, CI, 변경 파일 목록, 병렬 regression을 기록.
5. 새 APK를 만들면 **사용자가 다운로드 가능한 실제 sandbox APK 링크**와 **해당 APK 바이트가 동일하게 포함된 ZIP 링크**를 같은 응답에 제공. ZIP 내부 APK SHA-256과 단독 APK SHA-256은 같아야 한다. 현재 문서 작업에는 APK 변경 없음; 새 APK를 만든 것처럼 링크/성공 주장 금지.
6. 모든 후속 버전은 QA 결과를 `STATIC_PASS`, `DEVICE_PASS`, `DEVICE_QA_OPEN`, `DEVICE_FAIL`로 분리. R227은 **사용자 지정 보존 골든**이지 모든 기능 실기기 PASS가 아니다.
7. Private Library는 실제 서명된 APK, ZIP, 개인 메모, 가족/사진/좌표 자료의 권위 있는 보존소. GitHub 공개 저장소에는 **개인 키·가족 사진·GPS·일기·계정 토큰을 절대 올리지 않는다**. 안전한 소스/문서/해시만 공개 GitHub에 둘 수 있다.
8. 릴리스 후 `MOA_WIP_CHECKPOINT_CURRENT.md`, `MOA_RELEASE_LEDGER_CURRENT.md`, `MOA_READ_FIRST_NEW_CHAT_R227_20261109.md` 또는 후속 READ FIRST, 새 Canonical Addendum, 실제 feature inventory와 impact register를 동기화한다.
9. 새 대화에서는 파일을 읽기 전부터 재작성·재빌드·근거 없는 상태 주장 금지. 새 기능은 사용자가 이미 결정한 방향성을 재질문하지 말고 최신 artifact/증거를 이어받는다.

---

## 11. 새 채팅용 반드시 포함할 시작 지시 문구

> **MOA 장기 플랫폼 확장 계속.** 무엇보다 먼저 `workexcel-devbridge/main/AA_AirPods_FINAL_READ_FIRST_v1.0_20261005.md`의 최상위 지침 전체와 `family-journey-personal/main/MOA_READ_FIRST_NEW_CHAT_R227_20261109.md`, `MOA_R227_MASTER_HANDOFF_FOR_NEW_CHAT_20261109.md`, R227 골든 잠금·WIP·릴리스 원장을 모두 읽고, **이 문서 `MOA_R227_PLUS_LIFELONG_FAMILY_KNOWLEDGE_PLATFORM_CANONICAL_20261109.md`도 처음부터 끝까지 필독**한다. 개인 Library의 R227 APK/ZIP/130-member 매니페스트 및 최신 작업 결과와 비교하라. R227 원본 SHA256 `53c4c04ce32ad13de3c0613f4e5ec7abbc75ccbdfe9db5da05d8fa9b806ec6cd` 및 R219/R209/R203/R187 골든은 절대 변경하지 말 것. 새 기능은 새 브랜치/높은 versionCode/원본 서명으로만 진행하고, 정상 동작·기존 일기·음성·갤러리·바로기록·GPS·Naver 복귀를 보존한다. 앞으로의 모든 변경은 **기능→소스→브리지→DB→설정→영향범위→회귀 QA**를 기록하는 문서와 함께 관리한다. **미래 비전은 현재 구현 완료가 아니다.** 장기 목표는 (1) 화면 비점유 네이버 실제 즐찾과 자동 리스트 생성, 갤러리 즉시 복귀, (2) 바로기록 한 번으로 음성/메모/일기/즐찾/학습연결, (3) 일상 장면의 한국어·자연스러운 영어·발음/단어/복습·지리/역사 연쇄학습/사진책·인쇄, (4) Windows↔Android 안정적 로컬 우선 동기화 및 가족 지식 플랫폼 확장이다. 모든 R227 신규 기능의 정적/실기기 검증을 구분하고, 신규 APK 배포 시 서명/해시/업데이트 설치를 검증한 APK+바이트 동일 ZIP을 반드시 같이 제공하라. AA AirPods 오디오 소스는 건드리지 말 것.

---

## 12. 관련 실제 근거 문서 및 공식 제약(검증 당시 기준)

### 기존 프로젝트 자료(2026-11-09)

- `MOA_READ_FIRST_NEW_CHAT_R227_20261109.md`
- `MOA_R227_MASTER_HANDOFF_FOR_NEW_CHAT_20261109.md`
- `MOA_R227_USER_DESIGNATED_GOLDEN_LOCK_20261109.md`
- `MOA_R227_GALLERY_BACK_SAME_PHOTO_NAVER_DIRECT_EXIF_FULL_VIDEO_HANDOFF_20261109.md`
- `MOA_WIP_CHECKPOINT_CURRENT.md`, `MOA_RELEASE_LEDGER_CURRENT.md`
- `MOA_ARCHITECTURE_EXTENSION_AND_QA_MAP_20261106.md`
- `MOA_GLOBEMARK_TIMETREE_ARCHITECTURE_AND_PHASED_ROADMAP_20261106.md`
- `MOA_LOGLOG_REALTIME_SYNC_TECHNICAL_REVIEW_20261106.md`
- `FAMILYJOURNEY_NAVER_EXIF_FAVORITES_NO_BATTLE_READ_FIRST_20261031.md`
- `FAMILYJOURNEY_R12_1_NAVER_GPS_QUEUE_PRIVACY_20261031.md`
- `FAMILYJOURNEY_R18_NAVER_SAVE_SHEET_USER_SCREENSHOT_FIX_20261031.md`
- `AA_FAMILYJOURNEY_PC_IOS_SYNC_READ_FIRST_20261031.md`, `pcApp/README_KO.md`, `pcApp/app.py`

### 외부 공식 자료(기술 실험 전 최신 재확인 필수)

- NAVER 지도 앱 URL Scheme: https://guide.ncloud-docs.com/docs/maps-url-scheme — 외부 `search/place` 등 앱 열기. **즐겨찾기 쓰기 API 문서가 아님**.
- NAVER 지도 저장 기능 도움말: https://help.naver.com/service/5637/contents/692?lang=ko — 계정 로그인, `내 장소` 및 사용자 리스트, 메모/별명 등 사용 UI.
- Android `DisplayManager` / virtual display: https://developer.android.com/reference/android/hardware/display/DisplayManager — private display 및 보안/UID 제한.
- Android secondary display Activity launch: https://developer.android.com/reference/android/app/ActivityManager#isActivityStartAllowedOnDisplay(android.content.Context,int,android.content.Intent) — 다른 앱 타 디스플레이 실행 허용 여부가 시스템 제약을 받음.
- Android tasks/back stack: https://developer.android.com/guide/components/activities/tasks-and-back-stack — 타 앱 내부 back stack 임의 제어와 별개로 자기 앱 상태 복원 설계.
- Android `MediaProjection`: https://developer.android.com/media/platform/av-capture — 사용자가 허용하는 화면 캡처, 타 앱을 숨겨 독립 조작하는 자동화 API로 취급 금지.
- Google Play Accessibility API policy: https://support.google.com/googleplay/android-developer/answer/10964491?hl=en — 좁은 사용자 의도 자동화/고지/권한, 자율행동 제한.

## 13. 최종 준수 선언

- **이번 파일은 제품 비전과 장기 불변 개발 계약을 확정하는 문서 작업이며, R227 앱에 새 기능을 구현한 것이 아니다.**
- 이후에는 **어떤 신규 기능이 생기든 이 문서와 최신 변경 영향표를 읽고**, 사진·여행·일기·음성·지도·학습·동기화의 장기 연쇄 구조에 어떤 영향을 주는지 확인해야 한다.
- **원본 기록은 믿을 수 있어야 하고, 골든은 되돌릴 수 있어야 하며, 새 기능은 기존에 정상 작동하던 것을 깨뜨려서는 안 된다.**