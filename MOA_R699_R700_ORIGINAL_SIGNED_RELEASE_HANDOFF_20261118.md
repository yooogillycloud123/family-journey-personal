# MOA R699 / R700 원본 서명 APK — 키 복구 / 정적 검증 / 실기기 대기 (2026-11-18)

## 0. 서명키 "없음" 판단 정정

이전 R699 source-only 응답의 "개인 원본 서명키가 없다"는 **거짓 장애 원인**이었다. 이유: 새 세션 임시 폴더에서 파일을 못 찾았다는 것만으로 개인 Library를 검색하지 않았다.

실제 원본 서명키는 개인 Library `/모아_프로젝트_근거_20261103/PRIVATE_SIGNERS/MOA_R39_SIGNING_BACKUP_PRIVATE_KEEP.zip` (3910 bytes), 암호·복구지침은 같은 Library 폴더의 **비공개** `MOA_PRIVATE_SIGNER_REGISTRY_DO_NOT_PUBLISH.md`. 2026-11-18 현재 실제 ZIP materialize 재확인, SHA256 `3fc12c31c2f91a350d9a77d2c104b815ebbdc73b11e50b2c1de01458de86ea27`, CRC PASS, PKCS#12 decrypt PASS, private key ↔ cert public SPKI PASS, 동일 R697/R683 인증서 SHA256 `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15` PASS. **키·암호를 공개 GitHub/ZIP/CI로 보내지 않았다.** 새 채팅은 [영구 서명키 위치 지침](MOA_ORIGINAL_SIGNER_LOCATION_READ_FIRST_PERMANENT.md)을 가장 먼저 읽을 것.

## 1. 실제 원본 서명 APK 산출물

|용도|파일|Android versionCode|SHA256|크기|
|---|---|---:|---|---:|
|R699 기능 후보| `MOA_R699_GALAXY_VOLUME_CALENDAR_ORIGINAL_SIGNED_BETA.apk` |699| `35dddbf1993f64a68a989bae7ed14b597393661af8f426b2fdc5409f03b5fbb7` |9,804,068|
|정확 R697 기능 복귀| `MOA_R700_EXACT_R697_FUNCTIONAL_FORWARD_RECOVERY_ORIGINAL_SIGNED.apk` |700| `e63d723b3ffd1933c3a51542b6e388f99b85af47184ff371af0e20dac85648fd` |9,801,420|
|사용자 전달 원본 APK 2개+소스+QA| `MOA_R699_R700_SIGNED_RELEASE_QA_20261118.zip` |—| `40e0738ba6ec7e689decf6673b0f89ad9fd5175d9ad1b415a3ae7838dbd2d9f9` |14,518,345|

비공개 Library 영구 저장:
`/모아_프로젝트_근거_20261103/R699_GALAXY_VOLUME_CALENDAR_R700_RECOVERY_20261118/`
위 2개 APK, ZIP 및 검증 JSON 직접 업로드 성공.

## 2. 어떤 기능을 변경했고 무엇을 보존했는가

- 원본 `R697`은 사용자 실기기 성공 확인된 **최신 작동 기준**, SHA256 `67a8892c661e38ea9ec4227baa6ecb053bfe612ef874594e6fdf1b250820328e`. 이전 R683 불변 Golden SHA256 `e20e446d5e02358e833fe223471735abc3fd042234b4efc53acc208118ee9e8b` 보존.
- R699: (1) 갤럭시 측면 음량키와 모아 원본 Gallery 자체 볼륨 UI의 `AudioManager.STREAM_MUSIC` 값 동기화 및 음소거 해제 시 시스템 볼륨의 부당 상승 방어; (2) MediaStore/일기 상태 갱신에서 기존 달력 전체 재렌더 대신 표시 중 날짜만 반영, 제한된 260px 달력 커버 캐시 재사용.
- R699 대 R697 167 원본 ZIP 엔트리 중 **163개 uncompressed payload byte-exact**. 변경 4개: `AndroidManifest.xml`, `classes17.dex`, `classes19.dex` (표시 버전명 변경), `assets/web/moa-r697-vertical-calendar.js`. 기존 `classes6.dex` 원본 네이티브 Gallery, `classes18.dex` PHOTO native host 등 보호.
- R700은 R697 167 original entries 중 **166개 uncompressed payload byte-exact**, **Manifest만** code700으로 변경한 위쪽 버전 복구. R699 기능은 R700 복구 시 없어짐. 기존 앱 데이터, IndexedDB, 사진 원본, 네이버 로그인·쿠키는 삭제하지 않음.
- R699 변경 소스: `feature/moa-r699-system-volume-calendar-incremental-20261118`. 컴파일 DEX CI: https://github.com/yooogillycloud123/family-journey-personal/actions/runs/44259284642 (SUCCESS).

## 3. 실제 검증 결과와 미검증

**PASS:** 개인키·인증서 검증, 원본 R697 APK 출처 SHA, 원본 동일 패키지 `com.juhyeon.familyjournea`, v2 RSA 서명 + signed-data / full APK content digest 양쪽 PASS, ZIP CRC + stored entry alignment PASS, 모든 DEX SHA1/Adler PASS, 본문 보전 비교, manifest UTF-16 versionName와 versionCode=699/700, Node JS syntax/모의 테스트 PASS, GitHub Android SDK35 DEX17 컴파일 PASS.

**PENDING / 주장 금지:** 로컬 실행 환경의 별도 Android SDK `aapt` / `apksigner` 공식 파서 검사, 실제 Galaxy update-install 및 진짜 물리 음량 버튼/달력·사진/영상/대표사진/다중선택/네이버/홈 재진입 회귀 테스트. 서명이 정적으로 검증되었어도 Galaxy 실제 설치/동작을 성공했다고 단정하지 말 것. R699은 **BETA**, R697 유저 실기기 성공 기준 그대로.

## 4. 설치 / 문제 시 복구

1. 앱 제거·데이터 삭제 없이 R697 위에 code699 원본서명 APK **업데이트 설치** (실제 설치 성공은 사용자 기기 확인 필요).
2. 동영상 음소거 ON/OFF, 갤럭시 측면 음량키, 0/중간/최대 시스템 음량, 모아 볼륨 막대, 새 사진 추가 후 달력 재진입·전체 로딩 여부 테스트. 갤러리/음성/다중제외/네이버 기존 기능도 검사.
3. 이상 발견 시 앱 삭제/데이터 초기화 없이 versionCode700 **정확 R697 기능 복귀 APK**를 업데이트 설치. R700 설치 후 차기 후보 코드는 **701 이상**.
4. 비공개 Library 내 R39 원본 키 백업이나 비밀번호를 사용자에게 다시 달라고 하지 말 것. 원본 인증서 확인 후 기존 키를 재사용.

## 5. 기술 한계에 대한 정직한 표현

R699 캐시/갱신 변경은 전체 달력 재렌더와 썸네일 재디코딩을 줄이는 소스 패치이지, 삼성 Android MediaStore 백그라운드 색인·권한 변화 점검을 무조건 0회로 만든다는 뜻이 아니다. 실기기에서 재시작 버퍼링이 여전히 발생하면 실제 트레이스/로그로 원인을 추가 분리한다.

