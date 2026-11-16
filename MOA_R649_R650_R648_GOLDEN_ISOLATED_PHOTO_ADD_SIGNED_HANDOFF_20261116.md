> **RETRACTED AS WORKING CANDIDATE — 2026-11-16 USER R649 PHYSICAL FAIL:** Previous R649 signed/static/browser success is NOT app functionality success. User R649 real Galaxy video+R602: QuickRecord native Gallery loss and black/broken photo-add preview. Do not recommend R649 install anymore, do not promote Golden. See [MOA_R649_REAL_GALAXY_QUICKRECORD_AND_PHOTO_PICKER_FAIL_20261116.md](MOA_R649_REAL_GALAXY_QUICKRECORD_AND_PHOTO_PICKER_FAIL_20261116.md). R650 exact-R648 recovery still exists and is not yet phone-tested. R648 scoped Golden remains based on user-confirmed scenario only.

# 모아 R649/R650 — 사용자 실기기 R648 scoped Golden 보호, 독립 사진추가 signed APK/상위복구 (2026-11-16)

> **중요: R649는 서명된 설치용 베타이며 Galaxy 실기기 PASS 미확인. R648의 검증된 기능을 현재 사용자 scoped Golden으로 그대로 보호.** 모아 앱 사용자 데이터/네이버/권한 초기화 금지. AA AirPods Android Auto 오디오 별도 프로젝트 수정 금지.

## 최신 사용자 물리 증거와 기초 문서

필독: `AA_AirPods_FINAL_READ_FIRST_v1.0_20261005.md` (공통 첫 지침) → `MOA_READ_FIRST_NEW_CHAT.md` → `MOA_R648_USER_PHYSICAL_SCOPED_GOLDEN_PHOTO_ADD_LOCK_20261116.md` → 본 문서 → R611/R641/R648 근거 및 R621/R623/R625 사진추가 요구. 사용자 R648 실기기 물리 PASS 범위는 **Samsung One Hand Operation+ OFF→ON 뒤** 원본 네이티브 갤러리, 잠금화면·화면켜짐·모아 앱 전면 바로기록 후 원본 갤러리 복귀. 원핸드 조작 없이 최초 상태 성공은 미검증.

R648 SHA256 `6b5984e1b3892c0ed10606008d2627c0393ba02661e22a13565571f1a47be3c1`; exact R641 Golden SHA `bf1633ad830057b61ef1d256d57a9215b393800c739c75a113dbb10f06167e89`; older R611 `38a507cf2e88a235282ae4d9ad64cf0799033f34ae8fe3e179a58960d1213ccd`. 기존 2662줄 full-runtrace 중 R648 tagged 581줄; 이미지 RESOURCE_LOAD_ERROR 6회, 영상 2회, 구체 cause/URI unknown. 이를 사진 추가 문제의 확정 원인 또는 R649에서 이미 수정된 문제라고 주장하지 않음.

## 새 설치 후보와 기능 복구 APK

1. **R649**, code 649, `MOA_R649_R648_GOLDEN_ISOLATED_PHOTO_ADD_ORIGINAL_SIGNED_BETA.apk`, 9,099,476 bytes, SHA256 **`0ce91e563f8076a7b0218b2488b1f9e0127d6d5014a96a0ebc82680d31ad061e`**.
2. **R650**, code 650, `MOA_R650_EXACT_R648_FUNCTIONAL_FORWARD_RECOVERY_ORIGINAL_SIGNED.apk`, 9,097,037 bytes, SHA256 **`dac8e53eabe4cef3132a94deee8c85b4025440a1d40f5f58126f681863f6ce6c`**. R648 148/148 엔트리 중 Manifest versionCode 하나만 달라 기능 바이트 정확 복원. R649 설치 후 회귀 시에만 상위버전 update-install; 앱 삭제·데이터 초기화가 아님. 이후 신규 후보는 versionCode >650.
3. Source/QA ZIP `MOA_R649_R650_R648_GOLDEN_PHOTO_ADD_APK_SOURCE_QA_20261116.zip` SHA256 **`5cb053e4953fbc533bfc17e4fc063f523ca2792f79f732c37697e40d12f82184`**, 13,218,493 bytes. 동일 APK 2개, picker JS/CSS, diagnostic build-label JS, R648→R649 unified patches, README, QA JSON, 360/390/412 브라우저 테스트와 MOCK 이미지. 사용자 사진/영상/키/비밀번호/토큰/GPS 없음.

파일은 사용자 **개인 Library** `/모아_프로젝트_근거_20261103/R649_R648_GOLDEN_ISOLATED_PHOTO_ADD_20261116/`에 APK 두 개/ZIP/README/QA 모두 보관. 기존 Library R648 original signed baseline은 그대로.

Package `com.juhyeon.familyjournea`; 기존 original signer cert SHA256 `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`. RSA SHA-256 APK Signature Scheme v2 서명·서명된 데이터 digest 검증, ZIP CRC 및 STORED 4-byte alignment PASS. **공식 Android apksigner 도구가 실행 환경에 없어 자체 Python cryptography v2 검증**. 실제 Android package installer update-install 테스트 미실시.

## 정확한 수정 scope — 변경 4개, 보호 144개

R648 148개 APK member 중 R649 변경:
- `AndroidManifest.xml` versionCode 648→649.
- `assets/web/moa-r640-lazy-picker.js` 원본 gallery와 분리된 사진 추가 구성요소 대체.
- `assets/web/moa-r640-lazy-picker.css` 전용 UI.
- `assets/web/moa-r648-passive-full-runtrace.js` 빌드 tag와 설정 진단 제목만 R649 표시(IndexedDB/LocalStorage journal 이름 유지, 원본 stage hooks 불변).

**나머지 144/148 멤버 바이트 동일**, classes.dex ~ classes18.dex 18/18 바이트 동일, 원본 native photo-day calendar `moa-r483-vertical-calendar.js/.css` 바이트 동일, `moa-r641-safeguard-bootstrap.js`, `index.html`, `host-bootstrap.js`, `family-diary.js`, `moa-r149-voice.js` 등 핵심 보호 파일 바이트 동일. R649 picker가 `MoaLocalAudio.openNativeGallery`, `r507StopInline`, `__moaR543RepairInline` 등 native Gallery 직접 제어 메서드를 호출하지 않음을 정적/모의 실행 검사. **다만 동일 DEX/JS는 실기기 간접 회귀 없음의 증명이 아님.** 기존 R648 picker와 동일한 openCalendar/openDay 정상 user-navigation만 사용하며 기존 뒤로가기 처리에 inactive-pass-through wrapper를 유지하는 범위여서 실기기 이벤트 충돌 가능성은 별도 확인.

## 구현 사진 추가 UI

- 선택 날짜/전체기간, 세로 3열 날짜별 사진·동영상 혼합, 더보기 없는 48개 배치 증분 스크롤, 날짜가 제자리인 헤더·하단 세로 연월일 휠.
- 카카오톡식 사진 본문 탭 선택·해제, 우상단 1/2/3 순서원, 고정 상단 선택수·추가, 독립 23px 확대, 360ms 길게누르기 후 드래그 다중 선택 및 가장자리 자동 스크롤.
- 큰 미리보기 FAST ON/OFF(큰 이미지 전환에만), 하단 필름스트립 FAST 무관 관성 스크롤, 흰 현재사진 테두리/6px 강조, 필름스트립 DOM 유지로 자동 scroll 충돌 감소; 미리보기에서도 동일 selection.
- 사진은 original `content://media/external/images/media/...` 우선; 원본 URI 실패 시 2048 bridge 썸네일. 저화질 응답으로 고화질을 덮어쓰지 않도록 토큰/품질 장치.
- 영상은 `content://` 원본을 WebView HTML5 video로 재생·일시정지·음소거·슬라이더 seek 시도, 실패 시 **원래 Android native `diaryPlayVideo` 재생기 실행** 버튼. 실제 URI 접근·영상 디코더/seek는 Galaxy 실기기 미검증. 웹 가짜 영상이 native와 완전 동등하다고 주장하지 않는다.
- 실제 original `familyjourney-diary-v1` curated store의 photoIds 병합 writer/readback 방식 유지, 성공 시 기존 `MoaR469SimpleDiary.openDay(day)` 경유해 정상 복귀. 일기·네이버·음성 등의 저장 엔진을 대체하지 않음.

## 검증 / 미검증

PASS: Chromium 360/390/412 width synthetic media + mock IndexedDB/native, 그리드/탭/순서/줌/FAST/필름스트립/휠/저장/복귀, 360ms 드래그, 48→155 item 증분 로딩, rail DOM 유지, 원본 Gallery 직접 native 호출 0, JS syntax, signed RSA v2/digest, ZIP CRC, 18DEX protection.

**PENDING:** 실제 Galaxy 원본 native Gallery 첫 장착·상세↔사진 왕복, One Hand OFF→ON 후 재장착, 잠금/화면 켜짐/모아 전면 바로기록 저장·같은 날짜 복귀, 사진 추가 저장 실제 user content, 원본 full-res 이미지 URI, 영상 재생·seek, full-runtrace restart durability, 실제 update-install 및 R650 restore. 이 게이트를 사용자 실기기에서 통과하기 전 R649를 FINAL/GOLDEN으로 승격하지 말 것. 실제 기기에 연결된 ADB/테스트 장비가 없으므로 테스트하지 않은 항목을 PASS라 표현 금지.

## 설치·복구와 다음 채팅

- 현재 정상 R648은 **삭제/초기화/권한 재설정하지 않음**. R649 필요 시 동일 서명 apk를 덮어 설치. 앱 데이터와 네이버 세션 유지가 목표이나 실기기 검증 전 보장하지 않음.
- 신규 설치 후 **사진추가 + 사용 전후의** 원본 갤러리·바로기록 기능부터 확인. 회귀 시 앱 삭제 없이 R650 원본기능 복구본 update-install만 시도. 리커버리도 실기기 미검증.
- Settings > 전체 실행 경로 진단 > 전체 진단 복사 필수. BUILD=R649... 태그를 확인해 이전 R645–R648 기록과 분리.
- 다음 개선에서는 새로운 R651+ 후보를 만들되, 사용자가 실제 보고한 R649 장점·오류와 이 문서/ZIP을 먼저 읽고 **동시에 picker/native owner를 모두 수정하지 말 것**.
