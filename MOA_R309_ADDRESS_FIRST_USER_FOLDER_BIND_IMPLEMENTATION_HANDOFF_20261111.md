# MOA R309 — 실제 APK에서 확인한 PC 웹 순서 결함 수정, 기존 목록 고유 ID 명시적 바인딩 (2026-11-11)

## 사용자 지적과 정확한 원인

- 기존 **점유형 네이버 앱 저장**과 **앱 내부 PC WebView 비점유형**은 별도 UI·저장 경로다. 같은 전경 접근성 좌표/셀렉터를 웹에 적용하지 않는다.
- 사용자가 요구한 올바른 PC 흐름: **사진 GPS에서 실제 주소 → 네이버 PC 검색 → 주소 자체/업체 정확 구분 → 해당 대상의 별표 → 사용자가 선택한 기존 리스트(고유 ID) → 별명·메모 → 저장 → 계정 재조회**. 새 리스트 만들기는 별도 추후 기능이다.
- 직접 추출한 *배포된* R305 JavaScript: `moa-r231-naver-frame-probe.js`가 무조건 `LIST`에서 시작하고 `LIST_READY`를 기다리지만 child `list()`에는 성공 `LIST_READY` 출력이 없었다. SEARCH가 정상 흐름으로 불가능. 이후 `location.replace`로 지도 최상위 페이지 이동 시 `sessionStorage.removeItem('moa.r237.pending')` 때문에 작업 소실. 원래 요청에는 목록 이름만 있고 shareId/folderId 없음. R305 16초 경과는 별도로 QUEUED로 프레임 ACK 미도착을 뜻하며 LIST 문제와 동일 원인이라고 단정하지 않는다.
- 공식 NAVER 지도 도움말도 장소 검색/탐색 → ☆ 클릭 → 리스트/별명/메모 저장 순서를 제시한다: https://help.naver.com/service/5637/contents/692?osType=COMMONOS

## 구현한 것 — 실제 원본 패키지에 JS 2개만 교체

- 동일 앱 `com.juhyeon.familyjournea` **R309 베타**, 서명된 파일 `MOA_R309_ADDRESS_FIRST_SINGLE_APP_VERIFICATION_BETA.apk`; size **8,924,347 B**, SHA256 **`33660fc08ab25ced4053faf571f18c53880f421c59ea58967e8b8456c4b785e4`**. 기존 인증서 SHA256 **`5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`** 및 APK v2 검증 PASS.
- R305에 대한 APK uncompressed payload diff는 **정확히 세 파일**: `AndroidManifest.xml` (binary code305→309), `assets/web/moa-r231-naver-frame-probe.js` (FSM 주소 우선/페이지 이동 후 job 복원/직접 목록 ID 연결/정확한 장소 판단/선택된 save UI 및 readback 시도), `assets/web/fj-naver-favorites.js` (원인별 피드백/검색 대기 오류). 16개 DEX와 나머지 전체 파일은 모두 **byte-identical**. 무관한 사진/일기/기존 네이버 점유 저장 native code 전혀 교체하지 않음.
- 이제 새 요청은 `PARENT_TASK_RECEIVED`→`SEARCHING`→`/p/search/<photo address>`를 먼저 진행. 인증된 `map.naver.com` **동일 탭** `sessionStorage`에 jobId, 정확 주소, 상태와 최장 90초 TTL을 저장해 navigation 후 복원. 복수 장소/다른 주소/정확한 장소 SID 불명 시 클릭하지 않고 보류. 새 목록 자동 생성·삭제 코드 없음.
- 기존 사용자의 동명 `내 장소`는 *이름/순서/장소 개수만으로 절대 자동 선택하지 않음*. 로그인된 공식 PC지도에서 보이는 `MOA 기존 리스트 연결` 버튼은 본인이 직접 눌렀을 때만 **same-origin credentialed GET read-only** 목록을 조회하고, 리스트 이름·장소개수·id 뒤 4자리를 보여 명시적으로 선택받아 동일 map sessionStorage에 folder/shareId를 보관. 해당 GET은 공식 문서화된 공개 API가 아니므로 실제 응답은 아직 미검증. 응답 실패 시 중단하고 목록 생성 없음. ID는 GitHub/채팅/로그에 보내지 않음.
- 사진의 실제 장소 상세와 고유 폴더ID를 모두 확보했을 때에만 *해당 상세의* Save star를 한 번 시도하도록 제한. 이미 저장된 star면 토글 금지. save modal의 첫-party ID와 선택된 ID가 정확히 일치해야만 이후 메모/별명/완료 버튼을 사용. 커밋 후 같은 로그인 세션의 **GET readback**에서 folderId + placeId + 정확 alias/memo가 일치해야 `NAVER_READBACK_VERIFIED` 표시. 실패/DOM 미확인/가짜 클릭 거부 시 성공 판정 금지, 자동 재시도 금지.
- 실기기에서 실제 네이버 서버 저장 결과/휴대폰 뒤쪽 WebView 터치 수락은 **여전히 UNVERIFIED**. 이 빌드는 실계정 'FINAL 자동저장'이 아니라 **정확한 실행 순서와 목록 ID 오선택 차단을 검증하는 R309 BETA**.

## QA

- Original R305 → R309 exact 3 payload member diff, 16/16 DEX SHA256 equal, APKv2 same original cert, zipalign, ZIP CRC, binary version309 all PASS.
- Node fake-browser state tests **10/10 PASS**: (1) 사진 주소 검색 first, (2) same-job reload persistence, (3) id 없으면 별표 전에 중단, (4) 복수 검색 결과 차단, (5) 다른 주소 클릭 안 함, (6) 이미 열어둔 다른 장소 무시, (7) 동일 first-party 자식 SID 이벤트, (8) 외부 origin 이벤트 차단, (9) 동명 기존 폴더 사용자 클릭 전 자동 바인딩 안 함, (10) 사용자 지정 고유 폴더 ID를 검색 작업으로 전달. **모의 테스트이지 NAVER 계정 PASS가 아니다**.
- **상위 버전 복구 후보 R311** `MOA_R311_RESTORE_R283_VISIBLE_SAVE_SAME_SIGNER.apk` code311, 8,916,155 B SHA256 **`172d4aab07eb847ad0375070df3217e44d0f8cb1fc9882455c8e270552f424b3`**. R303(original R283 로그인·점유저장 기능 동등) 대비 binary Manifest versionCode만 변경, 16 DEX byte equal, same original cert/v2/zipalign/CRC PASS, 아직 Galaxy 실기기 복원 QA 전. 기존 앱을 제거/초기화하지 않는 상위 코드 대체 후보, 원본 R269 Golden 바이너리 아님.
- **같은 APK 포함 QA ZIP** `MOA_R309_ADDRESS_FIRST_WITH_R311_RECOVERY_QA_20261111.zip` 12,923,306 B SHA256 **`bcb9466cdaf1f720f89e745c1e9f3f9834cefffdaacd480a8b15bebe21baae76`**, R309/R311 APK, 테스트 10건의 소스/로그, 수정 diff, QA JSON, 한국어 설치·복구 안내 포함. 비공개 keystore/비밀번호/사용자 영상/계정 정보 없음.
- R309 베타의 실제 Android 실행·네이버 내부 GET 응답·리스트 선택·계정 readback까지 **기기 검증 미실시**. 기존 네이버 WebView에서 script-synthetic `click()`이 Naver에 user activation으로 받아들여지는지도 아직 판단 불가. 이를 성공이라 주장하지 않는다.

## 안전 경계·Goldens
- 원본 R269 사용자 Golden code269 APK SHA256 **`c0663e65aac2b72feb86cb0f1ba5eac448b6599c3850858de4d942f2aa446920`** 및 R227/AA AirPods 등 변경 없음. 모든 개인 서명키는 로컬/개인 Library에서만 사용; 공개 GitHub와 사용자 ZIP에 전송 없음.
- 사용자가 만든 기존/중복 리스트를 임의 삭제·생성 금지. 사용자 계정에 잘못된 장소를 저장하지 않게 확인되지 않은 단계마다 fail closed. 기존 Android 점유 저장 경로 보존.
- 다음 실제 승격조건: Galaxy R309에서 선택한 기존 folderId 확인 → 사진주소 네이버지도 검색 → 정확 장소·별표·리스트→별명·메모→공식 계정 독립 재조회 **1회 이상 실제 PASS** + 기존 일기/사진/녹음/점유 저장 회귀 PASS. 실패 시 실제 first-party 화면 단계/메타(개인 내용 제외)를 확보한 뒤 수정, 무작정 selector 변경/APK 반복 금지.
