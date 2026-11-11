# MOA R309 → 기존 리스트 비점유 저장 작업 재개 — 구현/실제 검증 경계 (2026-11-11)

## 사용자 확정 목표
기존 점유형 네이버지도 접근성 저장 기능을 새로 만드는 작업이 아니다. **MOA 앱 한 개, 안드로이드폰 자체**에서 사진 원본 GPS/주소 → NAVER PC 지도 검색 → 정확한 주소 또는 가게/POI 선택 → 그 상세 페이지의 별표 저장 → 기존 리스트 고유 ID 선택 → 기존 일기 자료의 별명·메모 자동 입력 → 한 번만 저장 → 본인 네이버 계정에서 ID/메모/별명 재조회 성공. **작업 도중 네이버 앱 전면 점유/오버레이 전면 점유 금지**. Shizuku/root/추가 보조앱/PC 강제 의존 금지.

새 리스트 자동 생성은 사용자가 **이번 단계에서 보류**했으므로 만들거나 삭제하지 않는다. 동일 이름의 원본 '내 장소'(185개) 및 중복 0개 리스트를 이름/개수/순서로 자동 선택하면 안 된다. 본인 계정에서 first-party로 읽은 실제 folder/shareId를 직접 명시 선택하게 한다. 이전 사진·일기·음성·갤러리·GPS·점유형 저장/빠른 복귀, 서명·데이터·R269 Golden·AA AirPods 전부 보존. APK uninstall/data clear 금지.

## 확인된 기존 상태 (R309)
R309 package `com.juhyeon.familyjournea` versionCode 309, signed original APK 8,924,347B SHA256 `33660fc08ab25ced4053faf571f18c53880f421c59ea58967e8b8456c4b785e4`. R305 대비 Manifest+JS 2개만 변경, 16 DEX와 다른 리소스 동일. 주소 우선, page navigation 동안 job 복원, 고유 폴더 ID 선택 개념 구현 / 10 mocked tests PASS **but real NAVER account write/readback OPEN**. R311 same-signature forward recovery candidate SHA256 `172d4aab07eb847ad0375070df3217e44d0f8cb1fc9882455c8e270552f424b3`; device recovery NOT VERIFIED. R269 user Golden SHA256 `c0663e65aac2b72feb86cb0f1ba5eac448b6599c3850858de4d942f2aa446920` immutably protected.

**중요:** 공개 GitHub에는 실제 서명된 R309 APK와 정확한 R309 웹 JS 바이너리가 보관되지 않았고, private Library R309 공간도 용량 초과로 비어 있었다. 소스만 갖고 원본 signer update APK를 만든다고 주장하면 안 된다.

## 이번 세션에서 실제 수행 — source only
새 분리 브랜치:
`feature/moa-r309-existing-list-transaction-safety-20261111`

- [저장 트랜잭션 소스](https://github.com/yooogillycloud123/family-journey-personal/blob/feature/moa-r309-existing-list-transaction-safety-20261111/experiments/moa-r309-existing-list-transaction/moa-naver-existing-list-transaction.js)
- [16개 안전 테스트](https://github.com/yooogillycloud123/family-journey-personal/blob/feature/moa-r309-existing-list-transaction-safety-20261111/experiments/moa-r309-existing-list-transaction/tests/transaction.test.cjs)
- [독립 CI 성공 #42953356537](https://github.com/yooogillycloud123/family-journey-personal/actions/runs/42953356537)

구현한 source-only 트랜잭션:
- 사진/원본 주소/gps/별명/메모로 idempotency job, 이동 중 90초 지속
- 정확한 first-party 주소 일치 및 불확실한 후보는 인간 확인
- 기존 리스트 목록 first-party read **필수**; 명시적으로 클릭한 고유 ID만 허용
- 저장 UI에서 targetId/folderId/alias/memo 전부 일치 확인
- **커밋 직전 기록하고 최대 한 번만 실행**, 비정상 종료/ACK 상실 시 blind retry 금지
- 네이버 계정의 readback으로 ID+별명+메모가 일치할 때만 VERIFIED
- 기존 목록 생성/삭제 API는 포함하지 않음
- 16개 deterministic Node 테스트 **GitHub CI PASS**. 실제 NAVER 웹 DOM/본인 계정/실기기 저장에 대한 테스트가 아님.

별도 현재 대화 산출물 `MOA_R309_EXISTING_LIST_OFFSCREEN_TRANSACTION_SOURCE_ONLY_20261111.zip` (SHA256 `bacf097725d1c49ff5595d2a3eacda2d18b307e66eeba99ceeb4cd78388c4c81`)에는 별도로 구현한 standalone 소스, 16개 테스트, README 및 SHA manifest 포함. 실제 APK는 아님.

## 다음 차례 — 막힌 정확한 연결 경계
1. 실제 **동일 SHA R309 signed APK**를 확보해 배포된 `assets/web/moa-r231-naver-frame-probe.js`, `assets/web/fj-naver-favorites.js`, 저장 서비스 DEX를 확인하고 동등성 검증. 소스 없는 재구성/골든 변경 금지.
2. 실기기에서 first-party NAVER PC 웹세션, 정확한 검색 결과 `targetId`, 기존 사용자 목록 `folderId/shareId` 읽기 방식과 저장 UI의 실제 동작 확인. 현재 언급된 **비공식 GET endpoint 및 synthetic click acceptance는 미검증**; 추측한 endpoint 또는 셀렉터로 계정 쓰기 금지.
3. 위 두 항목이 입증되면 source-only 트랜잭션 adapter를 **기존 일기 네이버 저장 단일 버튼**에 연결한다. 별도 테스트 폼·주소 재입력 요구/앱 전면 전환 금지.
4. 사용자 **실제 한 건** readback(동일 POI/주소 target ID + 기존 folder ID + 별명 + 메모)을 통과하고 기존 사진/일기/음성/Gallery/점유형 저장 회귀를 통과할 때만 비점유 저장 SUCCESS.
5. 원본 패키지+동일 signer+상위 versionCode의 설치 APK와 비교 가능한 ZIP을 만든 뒤에만 배포. 이전 R309/R311을 다시 무단 설치하거나 데이터 삭제하지 않는다.

## 결론
현재 완료 = 안전한 일회성 주소→기존 ID→저장→계정 readback 트랜잭션의 **독립 소스**와 16 CI PASS.
현재 미완 = 실제 R309 signed APK에 연결, NAVER PC 로그인/DOM/실계정 쓰기/독립 서버 readback, S26 Ultra 비점유 실차 외 일반 UI QA.
**더 이상 source mock을 실제 계정 PASS라고 표현하지 않는다.**
