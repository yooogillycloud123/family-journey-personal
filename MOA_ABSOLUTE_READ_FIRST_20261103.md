# 모아(MOA) 최상위 READ FIRST — 기존 기능 보존 + 삼성 카메라 순간 기록 통합
> 기준일: 2026-11-03. **새 채팅·새 작업·새 모델은 이 문서를 처음부터 끝까지 읽고 작업할 것.**
> 이 문서가 모아 관련 R37~R51 관찰 결과·사용자 목표의 기준이다. 별도 AirPods/Jelly/여행여권 지침과 충돌시키지 않는다.

## 0. 사용자 절대 지침
사용자는 **완성된 하나의 모아 앱**을 원한다. 설명만 하거나, 번호만 올린 미검증 APK, 별도 보조 앱, 기능 퇴행, 서명키·패키지 변경으로 앱이 늘어나는 방식은 **명시적으로 거부**했다. 사용자가 오류 스크린샷·영상을 제공하면 관찰 가능한 사실을 먼저 확정하고, 불충분한 근거는 해당 로그/파일을 최소한으로 요청한다. **추정/가설/정적 검증/실기기 PASS를 분리 기록**하고, 실패한 가설을 반복해 배포하지 않는다. 작업을 요청받으면 문구 작성으로 종료하지 말고, 가능한 환경에서 소스→빌드→테스트→동일 앱 업데이트 APK까지 진행하되 **미완성 결과를 완성본으로 포장하지 않는다.**

**절대 금지**
- 정상 사용 중인 원본 '모아'의 삭제, 데이터·캐시 초기화 권유, 기존 일기 데이터 덮어쓰기/변경.
- R38 등 오래된 화면 코드를 무검증 기반으로 재사용하거나, 기존 일기 탭을 삭제/숨김.
- R42의 **촬영 후 모아 복귀 감지·일기 저장 경로**를 검증되지 않은 네이티브 구현 때문에 제거/무력화.
- 원본 서명 개인키·패키지를 확인하지 않고 '기존 모아 덮어쓰기'라 주장하기.
- Android APK의 ZIP/DEX/v2 서명 확인만으로 '설치·실행·카메라 작동 PASS'라고 발표하기.
- 별도 앱 R45/R49/R50/R51을 계속 증식시키거나 원본 앱의 데이터 자동 승계를 주장하기.
- 사용자에게 실패 재현을 반복 요구하기 전에 제공된 사진·영상·APK·보고서·소스를 먼저 확인하기.

## 1. 최종 제품 요구사항 — 생략 불가
1. 기존 모아의 **나의 지도/여행여권/장소 기록/일기/내가 고른 사진 일기/자동 사진 달력/설정/사진·영상 타임라인/기존 데이터**를 유지.
2. 삼성 기본 카메라 그대로 사용. 모아에서 **한 번에 빠르게 ON/OFF**(빠른 설정 타일 등)한 경우에만 새로 찍는 사진·영상을 감지. 카메라와 기존 저장 과정에 간섭하지 않음.
3. 촬영 후 파일이 실제 저장되면 **즉시 기록 버튼·알림/적합한 오버레이**가 나타나 음성 또는 문자로 그 순간의 상황을 남김. Android 백그라운드 시작 제한 및 권한을 고려하되 불편한 매번 앱 실행을 기본 동작으로 만들지 않음.
4. **별도 메모가 아니라 사진·영상 자체에 해당 촬영 시간대 메모를 연결**, 기존 '내가 고른 사진 일기'에 해당 날짜와 촬영 시각으로 반영. 원본 사진/영상 무손실; EXIF·MediaStore의 신뢰 가능한 실제 촬영시각 우선, 없으면 메타데이터 한계를 명시하며 게시일/다운로드일을 촬영일로 추정 금지.
5. 같은 사진 중복 입력·시간대 잘못 연결·저장 누락·모아 재실행 후 유실 방지; 권한 거부·서비스 재시작·연속 촬영·영상·기기 잠금·배터리 정책 포함.
6. 음성 인식 실패(not-allowed 등)는 오류를 구분하고 문자 입력으로 안전하게 복귀. 영어 학습용 영작 확장은 **촬영·저장 안정화 이후**.
7. 궁극적으로 **원본 모아 한 앱**에서 업데이트 가능해야 한다. 기존 설치본과 패키지/동일 서명이 불가능하면 즉시 정직하게 제약을 기록하고, 데이터 이전 전략 검증 없이 새 앱 설치를 강제하지 않음.

## 2. 사용자 첨부 APK 기반 정적 비교 — 2026-11-03 검증
이전 대화에서 사용자 제공 실물 APK ZIP 내 `assets/web/family-diary.js`, Manifest, DEX 및 인증서를 검사함. 재현 검사: `MOA_version_regression_tests.py` (출처: `MOA_실제APK_R37_R51_퇴행검증_증거.zip`). **정적 코드 관찰이지 기기 PASS 아님.**
- R37 `MOA_R37_PhotoCalendar_ColdStart_Install.apk`: 선택 사진·영상/일기·달력·IndexedDB 구조 존재; **카메라 촬영 이후 자동 순간 기록 없음**. SHA-256 `49a06e88a95195db8a14cd3cd703e3540f0b5925c626c9c267b5f2f248b66eba`.
- R41 `MOA_R41_Moment_Diary_Camera_Return_BETA.apk`: 모아로 **복귀할 때** 신규 촬영 사진을 탐색·일기 추가·팝업. SHA-256 `942b023a51366b132eddd8df457cc2dc497454eaec31bd85ac2029eb225a3fd4`.
- **R42 `MOA_R42_Moment_Timeline_Memo_Voice_Compat_BETA.apk`: 기능 보존 기준(코드 기반, 완전 실기기 PASS 주장 아님)**. 사진·영상 감지, 촬영 시간대별 메모 연동, 웹 음성인식 시도. 사용자 실기기에서 귀환 후 동작하나 불편한 지연, Web Speech `not-allowed` 오류 보고. SHA-256 `40835356c6c7f4bdbfaf3f07763f99e49fc817dfd9dbd2ba28e2a4094b19cba1`. `assets/web/family-diary.js` SHA-256 `9919553479b77ab01a60051074796d1f4865fb284f310982e153864fa7b639da`.
- **R44 퇴행 확정(코드상)**: `mmEnabled=false;mmArmedAt=0;`, `mmToggle()`에서 '빠른 설정창에서 켜라' 표시 후 조기 `return`. R42의 귀환 후 감지 경로를 대체하며 비활성화. 네이티브 경로 기기 PASS 없이 바꿈. SHA-256 `8689f53dcac5c2361ca44e147ff2a11e04863d60febb5ff2cfa6ee30d8f79cde`.
- R45·R47·R49: 네이티브 브리지/권한/패키지 변화 후 사용자 화면에서 ON/OFF 실패·`MoaMomentNative` 미연결. **브리지 실패의 정확한 런타임 예외는 미확정**.
- R50: 사용자 설치 실패→수정본 설치 후 실행 즉시 종료 관찰. R51: 실행은 되나 일기 화면 퇴행 관찰. **원본 데이터 삭제 증거 아님**.
- 최신 기능 분기에서 **보호해야 하는 것은 R42의 일기/시간대 기록 경로**, 원본 모아가 실제로 설치된 앱 패키지·데이터 경로는 **별도 식별 필요**.

### 실제 패키지·서명 단절 (SHA-256 인증서 지문)
- R37: `com.juhyeon.familyjourne8` / `b20f69c55ddfa24d786f4bc0dd6514cf5082059af6ad44897e1f055bc4891f88`
- R41·R42·R44: `com.juhyeon.familyjournea` / `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`
- R45·R47: `com.juhyeon.familyjourneb` / `8f985150ed58e95cadf0e3fa0c999ff9ed4e36a84165c48cbd34aabee29c7a10`
- R49: `com.juhyeon.familyjournec` / `311f43eca8aa4bdf60fabe5086717b733bdfcee70f7616fde977ae7371599012`
- R50·R51: `com.juhyeon.familyjournef` / `6f18453caf65fd3d5dfbb11b3c049d2e671fc405ab304fa68c5af95c42826945`
`APK`의 공개 인증서로 개인 서명키를 복구할 수 없다. 실제 설치된 정상 '모아' 패키지·키는 이름만 보고 단정하지 말 것.

## 3. 올바른 개선·개발 우선순위
**P0 — 손상 방지와 기준선 고정:** 업로드된 R37/R41/R42/R44~R51 APK, 이전 증거 ZIP, 사용자 화면/영상, GitHub 실제 최신 소스, 빌드 로그·서명·DEX·runtime 산출물 순서대로 확인하고 SHA를 기록. 기존 정상 모아 앱 삭제/초기화 금지. 모아의 실제 운영 패키지를 확인하고, `R42=기능 기준`과 `현재 정상 설치본=데이터 기준`을 분리.
**P1 — 안전한 폴백 복구:** R42의 촬영 후 모아 복귀 감지와 기존 타임라인 저장 코드가 정상 동작하는 것을 유지. 네이티브 실패 시 이 경로가 계속 살아있어야 함. 원본 일기·지도·기록·사진 달력 UI 차이 회귀 검사.
**P2 — 촬영 엔진:** Android MediaStore `ContentObserver` 등을 이용하여 서비스 시작 실제 상태·권한·감지된 미디어 ID·촬영시각·중복·에러를 구조화하여 기록. 타일 UI만 보인다고 실제 서비스 동작 PASS 불가. WebView 연결이 실패해도 **촬영 감지·대기 레코드 저장**은 독립 가능해야 함.
**P3 — 입력/저장 연결:** 촬영 직후 오버레이/알림→입력(음성 STT+문자 폴백)→기존 일기의 해당 촬영 시간대에 연결→IndexedDB 및 백업/복원 스키마·중복·재시작/반복 저장 확인. 음성 인식은 권한/보안 출처/기기 지원이 확인된 Android 네이티브 방식 검토.
**P4 — 통합/배포 게이트:** APK 빌드→일치하는 소스 커밋·서명·버전/패키지·ZIP·DEX·Manifest→Android 에뮬레이터 설치 및 앱 실행/화면·저장 통합 테스트→갤럭시 삼성 기본 카메라 실제 촬영·2회 이상 반복 확인. 기기 PASS 전 FINAL/정상 완성본이라 부르지 말 것. 원본 한 앱 업데이트가 불가능하면 무단 신규 서명/별도 패키지 생성 금지.

## 4. 원인 분석 규칙
- 사용자가 제공한 화면에서 **관찰 가능한 증상**과 **검증된 코드 결함**과 **미확정 런타임 원인**을 표로 구분.
- 에러 문자열이 '서비스가 보이지 않음'이라도 실제 Android Service class 유무와 JS 브리지 가시성은 다르다. R47~R49 오류만으로 원인을 단정 금지.
- 앱 즉시 종료 시 `AndroidRuntime FATAL EXCEPTION`/PackageManager 설치 실패 코드/Activity 클래스로드 로그 등 **실제 예외 근거**를 확보. 자료가 모자라면 사용자가 이미 제공한 APK·스크린샷·영상에서 확인 후 최소 추가 로그만 요구.
- 서명 검증 PASS, JS 구문 PASS, CI D8 컴파일 PASS, 에뮬레이터 앱 실행 PASS, 갤럭시 실기기 촬영 PASS를 **서로 구별**.
- 이전 실패를 재발견하지 말고, 한 가설에 실패 기록을 남기고 다음 실측 근거로 원인을 좁혀라.

## 5. 새 채팅에서 반드시 수행할 순서
1. **이 파일 전체**와 `MOA_WIP_CHECKPOINT_CURRENT.md`, `MOA_R37_R51_실물APK_기능퇴행_정밀검증_20261103.md`을 먼저 읽는다.
2. 사용자가 올린 실물 APK·증거 ZIP의 정확한 SHA와 작업공간에 남은 빌드/DEX/_analysis_repair*/검증 파일을 조사하여 이전 결과를 재사용한다. **없는 첨부 파일을 있다고 주장하지 않는다**.
3. GitHub main 최신 커밋, 변경된 실제 소스 및 CI artifact/실패 로그를 확인하고 지난 채팅의 **미확인 PASS를 그대로 인용하지 않는다**.
4. 기존 정상 모아+R42 기능 기준의 차이와 데이터/서명 유지 문제를 먼저 해결. 기존 기능 보존 회귀테스트가 없는 변경은 배포 금지.
5. 소스/빌드/배포/실기 상태를 기록하고, 결과 APK 제공 시 업그레이드 경로·패키지·서명·데이터 연속성·검증 종류를 명시한다. 작동하지 않는 시험 APK를 '완성품'으로 주지 않는다.
6. 각 세션의 중요한 수정·증거·실패·잔여 단계는 `MOA_WIP_CHECKPOINT_CURRENT.md`에 **실제 수행한 사실만** 업데이트한다.

**현재 판정 (2026-11-03): 통합 완성 APK 부재. R42=기능 복원 기준, R37=사진 일기 기존 기능 참고, R44 이후 교체 방식은 퇴행. 원본 모아 앱 데이터 보존이 최우선.**

## 6. 재현용 자동 회귀 게이트 (2026-11-03 추가)
- 상세 정적 근거 영구 보존: [MOA_EVIDENCE_R37_R51_20261103.md](MOA_EVIDENCE_R37_R51_20261103.md).
- 재사용 검사: `python tools/moa_apk_regression_gate.py --baseline MOA_R42_Moment_Timeline_Memo_Voice_Compat_BETA.apk --candidate <새APK>`.
- 이 게이트는 R42에 존재한 **귀환 후 촬영 감지, 사진·영상, 타임라인 메모, ON/OFF**와 APK 패키지/서명 연속성의 정적 보존 여부를 검사한다. 직접 R42 APK(기준)와 R44 APK(퇴행)를 대조한 로컬 동등 스크립트에서 R42 PASS / R44 `R44_hard_disabled_fallback_absent` FAIL을 재현. GitHub 커밋 버전도 다음 세션에서 반드시 실행 검증.
- 이 검사 PASS는 앱 실행·실제 기기·일기 저장 PASS가 아니다. 기존 정상 모아 앱 패키지/서명과 달라도 R42 기준만 통과하면 된다는 의미가 **아님**.

## 7. 2026-11-03 Samsung Camera user-uploaded forensic finding — owner identity lock
- User-supplied actual installed '모아' APK: `모아-MOA-R37-Widget (2).apk`; **package `com.juhyeon.familyjourne8`, versionCode 37, signer `b20f69c55ddfa24d786f4bc0dd6514cf5082059af6ad44897e1f055bc4891f88`**. SHA256 identical to previous R37 original. This is the **original data owner**; do not mistake R42 for the original installed app.
- R54 package is **`com.juhyeon.familyjournea`**, signer R39/R42 lineage. **It installed as a separate app because package identity differs**. Do not claim R39 private key lets R54 update R37. Don't ask the user to re-upload known APKs/signers; inspect existing Library and checkpoint.
- R54 **web ON only toggles R42 on-return fallback**, no `MoaMomentNative.setEnabled()` call; not actual native MediaStore service ON. R54 mic button calls WebView SpeechRecognition and yields user-observed `not-allowed`; not native speech UI. **These are confirmed source defects, not unsolved mysteries**.
- User sent `카메라-17.0.00.43.apk` and `Camera Assistant-4.5.00.20.apk`; verified package IDs `com.sec.android.app.camera` and `com.samsung.android.app.cameraassistant`. Camera Assistant's public manifest contains camera settings/deeplink actions but no proven public capture-completed callback; do not modify/re-sign Samsung Camera. Native MediaStore ContentObserver + properly user-armed foreground service + overlay/notification is the independent, permission-respecting path.
- Next evidence: user turns on **real native '모아 기록' Quick Settings tile**, not web ON, and takes one Samsung camera photo without returning to MOA. If no camera overlay/notification, collect just native service, permissions, error status through attached **read-only** diagnostic ZIP. No extra test APK or camera APK is required.
- R37 is `android:debuggable=true`; read-only `adb shell run-as com.juhyeon.familyjourne8` data backup is a potential path to a **controlled one-time data migration** if R37 owner private key is actually absent. Must separately test and preserve the original, never wipe data. The owner's stored R39 signer is not a substitute for R37.
- Detailed evidence / no-install diagnostic toolkit: personal Library `/모아_프로젝트_근거_20261103/MOA_카메라_R37_R54_확인결과_원클릭진단.zip`. Prior R54 claims of an original R37 'update' are **retracted**. Device result not yet confirmed.
