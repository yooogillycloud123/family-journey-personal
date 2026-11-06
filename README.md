> **2026-11-06 MOA CURRENT:** R115 immutable user Golden; R117 user-tested. User R121 installed but CALENDAR CLIPPED/NAVER nmap blocked; new same-signer R123 code123 beta (SHA256 `f9f2553dda70fb0eb8f48787173b0c8593aa590233c4004fe20c3947fadbf58f`) signed/static+Chromium mock PASS, Galaxy install PENDING. Details: [`R123 handoff`](MOA_R123_R121_DEVICE_FINDINGS_HANDOFF_20261106.md), [`Loglog sync research`](MOA_LOGLOG_REALTIME_SYNC_TECHNICAL_REVIEW_20261106.md), [`append-only release ledger`](MOA_RELEASE_LEDGER_CURRENT.md). Family Schedule must be independent fifth bottom tab (NOT inside Record); 3D globe optional within Map. Never send email, expose keys or alter user's old diary/photos. Older repo prototype is NOT exact installed package.

> **2026-11-06 NEW MOA R117 UI BETA:** Diary-first tabs and compact settings / icon-linked screen color selection were added from R115 signed user Golden (unchanged). R117 APK `667e6caa97ffc76b10df15594d5be0672ea892ae0be2692b293161eba94dfdb0` is STATIC VERIFIED ONLY, device PASS pending. Start from [R117 handoff](MOA_R117_DIARY_FIRST_COMPACT_SETTINGS_ICON_LINKED_UI_HANDOFF_20261106.md) and [current release ledger](MOA_RELEASE_LEDGER_CURRENT.md); current Golden R115 remains protected. No Gmail or reinstallation/data clearing.

> **2026-11-06 MOA LATEST ACTIVE GOLDEN OVERRIDE — R115 (USER-APPROVED VISUAL GOLDEN).** THIS TOP BLOCK OVERRIDES ALL OLDER "LATEST R63/R89/R96/R99" HEADINGS BELOW; THOSE ARE HISTORICAL, NOT A REQUEST TO DOWNGRADE. User explicitly requested Golden registration after R115 fix. Exact signed private Library APK `/모아_프로젝트_근거_20261103/MOA_R115_USER_APPROVED_VISUAL_GOLDEN_20261106_DO_NOT_MODIFY.apk`, package `com.juhyeon.familyjournea`, versionCode **115**, **5,406,744 B**, SHA256 **`1118bdc249e2d941a899518e58be0185b120a887ff2c371c8f5a01037a5002a8`**, original signer cert SHA256 `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`. ZIP/v2 verification PASS, R113→R115 changed ONLY binary Manifest/version and `assets/web/index.html` early CSS/180px splash first paint (101 of 103 other members identical). User visually approved R115; **full existing diary/photo/calendar/voice/native feature regression is PENDING, NOT PASS**. R63/R83/R89 and R96 historical Goldens remain frozen. Emergency R116 reserved for R113 recovery; next feature code **>=117**. Read **[MOA_R115_NEXT_CHAT_START_HERE_20261106.md](MOA_R115_NEXT_CHAT_START_HERE_20261106.md)** FIRST, then **[R115 GOLDEN LOCK](MOA_R115_USER_APPROVED_VISUAL_GOLDEN_LOCK_20261106.md)**, **[FAILURE/REPAIR LEDGER](MOA_RELEASE_FAILURE_LEDGER_AND_BUILD_GATES_20261106.md)**, **[ARCHITECTURE + QA MAP](MOA_ARCHITECTURE_EXTENSION_AND_QA_MAP_20261106.md)**, **[APPEND-ONLY RELEASE REGISTRY](MOA_RELEASE_LEDGER_CURRENT.md)**. In every new chat: read project AA canonical first if required, inspect actual Library artifact/hash, do not rely on stale source. **NO Gmail/email/drafts** and no misleading ChatGPT sandbox delivery claims. Never uninstall/clear existing app or publish private signer/photo/data.

---

> **MOA 순간 기록 / 새 채팅 필독 (2026-11-03):** 모아 앱의 기존 일기·지도·기록·사진 달력 보존, R42 귀환 후 기록 경로 보호, R44~R51 기능 퇴행 재발 금지, 앱 하나/동일 서명·데이터 연속성 요구는 **[MOA_ABSOLUTE_READ_FIRST_20261103.md](MOA_ABSOLUTE_READ_FIRST_20261103.md)** 전문을 최우선으로 읽어야 한다. 최신 상태는 **[MOA_WIP_CHECKPOINT_CURRENT.md](MOA_WIP_CHECKPOINT_CURRENT.md)**. R49/R50/R51은 정상 기준본 아님. 정적 PASS != 실기기 PASS. 이 문장은 2026-11-03 당시 원형/프로토타입 기록이며, 최신 실사용 MOA R115의 상태를 뜻하지 않습니다.

> **2026-10-31 사용자 요청 정정:** 이 저장소의 v0.1/v0.2 Android APK는 원본 여행여권과 UI·자동 사진첩·영상 프리미엄 기능의 동등성이 입증되지 않은 **실패한 프로토타입**입니다. **사용자 설치·교체 대상으로 권장하지 않습니다.** 사용자는 여행여권 프리미엄을 이미 정식 구매했으며, 원본 앱과 구매 데이터를 보존하는 것이 우선입니다. [정확한 진행 기준](ORIGINAL_APP_FIRST_PREMIUM_PURCHASED_READ_FIRST_20261031.md)\n\n# FamilyJourney — 우리 가족 여행

가족사진의 **EXIF GPS와 촬영 시각**을 휴대폰/PC 안에서 읽어 여행별로 자동 분류하고 지도와 MP4 여행 영상으로 만드는 오픈 개발 프로젝트입니다.

## Android

`android/`에는 독립적인 Android 앱 소스가 있습니다. 사진 선택 후 EXIF 읽기, 위치 기반 방문지 그룹, 로컬 경로 시각화, PNG/MP4 내보내기를 목표로 합니다. `Android APK` 워크플로가 성공하면 실행 가능한 디버그 APK를 제공합니다.

## Windows

Windows 버전의 Python MVP는 별도 개발 소스로 관리하며 EXE는 `Windows EXE` 워크플로 통과 뒤 배포합니다.

## 개인정보 및 범위

- 가족사진, 위치 이력, 자택 좌표, 계정, 개인 결과물은 공개 GitHub에 올리지 않습니다.
- 원본 여행여권 APK, DEX, 추출된 저작권 소스 또는 결제 우회 코드를 포함하지 않습니다. 기능은 독립적으로 구현합니다.
- 네이버지도 연결은 위치 표시 링크부터 시작합니다. 계정 내 저장목록 자동 추가 기능은 지원 검증 전까지 미구현입니다.
- 초기 여행지도는 좌표로 그린 경로이며, 실제 도로/지도 타일과는 다릅니다.

## 상태

Android: 소스/CI 준비 및 컴파일 검증 중. Windows: 기존 v0.1 Python 엔진 준비, CI 연결 예정. 스마트폰 실기 동작은 APK를 설치해서 별도로 검증해야 합니다.
