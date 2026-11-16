> **2026-11-17 USER DEVICE RESULT OVERRIDES STATIC QA: R653 INITIAL PHOTO INLINE GALLERY FAIL + JAVA DIAG FAIL.** Read [MOA_R653_REAL_DEVICE_INITIAL_INLINE_FAIL_AND_FORENSIC_BLINDSPOT_20261117.md](MOA_R653_REAL_DEVICE_INITIAL_INLINE_FAIL_AND_FORENSIC_BLINDSPOT_20261117.md). START_INLINE emitted before async tryOpen, no proof whether JS early-return or Java ARM guard. R653 java observer's first `R507_NOT_RESUMED` was from STOPPED Activity, absent relevant failure snapshot. Previous signed APK builds still exist, but NOT Galaxy successful. Do not promote R653 or promise guaranteed R654 physical restore.

# 모아 R653 Java PHOTO-inline owner 상태 진단 APK / R654 R648 기능복원 — 2026-11-17

> **R653은 문제 해결 완료본이 아니라 실패 원인 수집용 실기기 미검증 베타다.** 골든은 기존 사용자 실기기 검증 R648 (One Hand Operation+ 네이버 접근성 OFF→ON 선행 조건). R651은 실제 Galaxy FAIL. 사진 추가 기능을 다시 수정하지 않았다. AA AirPods 음향 프로젝트 코드/데몬 수정 없음.

## 사용자 보고의 초점

- 상세형·나의 지도 갤러리는 열리지만 PHOTO 사진형에 붙은 원본 네이티브 8-action Gallery만 바로기록 이후 사라지고 앱을 다시 실행해도 나오지 않음.
- 2026-11-17 R651 사용자 영상 `23229.mp4` + 3509건 `txt_1794848998571.txt`: QuickRecord 17:07:09.340Z → START_INLINE 17:07:10.387Z → NATIVE_ARM_NOT_OBSERVED 17:07:11.686Z; 자동 `QUICK_RECORD_CLOSED_HOST_REARM` 17:07:12.987Z **실제 호출** → 다시 START_INLINE 17:07:13.637Z → ARM 없음. 재시작 17:07:30.448Z에도 START_INLINE만 있고 PRE-DRAW ARM/OPEN/MOUNT 없음.
- 소스 `MoaR507InlineGalleryProvider.java`에는 `tick()`과 `maybeArm()`의 nativeOwnerActivity/foreground/resumed/ownsGallery/processing/inlineArmed/suppressArmUntil/Stage status/rect guard가 있지만 개별 return reason 로그가 없음.
- 이번 APK는 갤러리의 open/close/rearm을 변경하지 않고 Java의 private state를 **동일 프로세스 ContentProviderClient.getLocalContentProvider() + reflection으로 수동 관찰**한다. 해당 접근이 Android 기기에서 작동하는지 포함해 실기기 검증 필요. 관측 당시 상태에 기반한 유력 guard 후보를 로그에 남기지만 **특정 원본 Java return 문이 실제 실행됐다고 직접 입증하는 내부 분기 계측은 아니다**.

## 빌드 산출물 (실제 signed APK 두 개)

- **MOA_R653_Diagnostic.apk** / code653 / 9,112,333 bytes / SHA256 **`a341303967416053f188368ef67a185ad323ec43181495054dbc972ff47b9599`**
- **MOA_R654_Recovery.apk** / code654 / 9,097,037 bytes / SHA256 **`85f49c3c4a476345c5ff2f8d84631bc5bfff6bf5626f572be067a2f60d83f32b`**, R648 기능 그대로 + Manifest version 654만 변경, 실기기 미검증.
- **MOA_R653_Diagnostic_Source_QA.zip** / 13,167,794 bytes / SHA256 **`1504c611085ff50c7e206fde1229231947e2e1061a7a94704684a55f1c7ee076`**. APK2 + Java source + binary manifest builder + adapted R648 trace JS + Java CI DEX + QA. **개인 signer 비밀정보 미포함**.
- Same package `com.juhyeon.familyjournea`, same original signing cert SHA256 **`5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`**; APKv2 digest verification PASS, ZIP CRC/alignment PASS. Android PackageInstaller/실물 기기 INSTALL/운영 검증 아직 미실시.
- Private Library `/모아_프로젝트_근거_20261103/R653_PASSIVE_JAVA_ARM_FORENSIC_20261117/RELEASE_DEVICE_UNTESTED/`.
- Java source GitHub branch `feature/moa-r653-passive-java-owner-diagnostic-20261117` under `experiments/moa-r653/`; SDK35 Java/D8 CI run **43920273046 success**, additive classes19.dex SHA `c71d033e4ef535e569efbabfbbc1635758cfda1a27a6e8907cc8a8f5ed4b9383`.
- Baseline R648 signed APK SHA `6b5984e1b3892c0ed10606008d2627c0393ba02661e22a13565571f1a47be3c1`. R653 148 existing members 중 146 exact; changed Manifest + R648 *tracer* JS build title/compact copy only; ADDED classes19.dex. **all 18 original DEX exact**, original gallery/calendar/R641 QuickRecord/naver/diary/gallery JS all exact. R654 147/148 exact, Manifest only.

## 실기기 최소 재현 / 제출해야 할 자료

1. **앱 삭제·데이터 초기화 없이** R653을 현재 R651 또는 R652 위에 업데이트 설치. R653은 사진 추가 기능이 아닌 PHOTO-inline Java 진단 전용. 새 사진 추가 Native Activity를 이번에는 탑재하지 않음.
2. 앱 최초 사진형 → 기존 성공 조건 원핸드 오퍼레이션+ 네이버 접근성 OFF→ON → 바로기록 한 번. 실패하면 불필요한 반복 테스트 중단. 앱 재실행 사진형 상태도 한 번 비교.
3. **설정 > 전체 실행 경로 진단 > Java 장착 원인 복사**를 눌러 결과를 채팅에 붙여넣음. R653 events `R653_JAVA_OWNER_TRANSITION`, `R653_JAVA_ARM_DENIAL_SNAPSHOT`, `R653_NATIVE_ACTIVITY_STATE`를 같은 IndexedDB/LocalStorage 역사 기록에 저장해 추출. 전체 원본 `전체 진단 복사`도 계속 작동.
4. `R507_OWNS_CLOSED_GALLERY`, `R507_ASYNC_PROCESSING`, `R507_ARM_SUPPRESSED`, `R507_FOREGROUND_OTHER_ACTIVITY`, `WEB_PAGE_NOT_ACTIVE_DAY`, `WEB_STAGE_INVALID_GEOMETRY`, `R507_PROVIDER_NOT_LOCAL`, `ARM_GATE_UNKNOWN_NEEDS_DIRECT_CALLBACK_TRACE` 등 **상태 기반 유력 guard 후보** 구분.
5. Java 진단 행이 없다면 R653 Provider가 시작되지 않았거나 Log -> WebView 전달이 되지 않은 것으로, 이번 계측 결과를 성공이라고 하지 말고 native logcat/manifest/provider origin 점검 후 수정.
6. 회귀가 심각하면 R654 동일 서명 상위 버전 기능 복구본으로 **업데이트 설치** 가능 (실기기 복구 아직 미검증). 미래 진단/수정 candidate code>=655.

## 반드시 지킬 조건

- R653 자체가 문제를 고쳤다고 주장 금지. 장착 거부 원인 입증 전 강제 자동재시도 추가 금지.
- 새 사진 추가 기능과 PHOTO-inline 갤러리 기능을 동시에 변경 금지. 원본 네이티브 갤러리/QuickRecord 소스 그대로 둠.
- 같은 Settings 진단에 Java guard/event trace가 보이지 않을 경우, 기존 과거 로그 BUILD label을 실제 앱 버전으로 착각 금지. R653 tracer marker explicitly updated to R653.
- 다음 APK는 위 실제 R653 사용자 로그에서 확인된 원인만 최소 변경하고, 실기기 첫 실행/바로기록/잠금화면/원핸드/상세형/나의지도 회귀 PASS 전 Golden 승격 금지.
