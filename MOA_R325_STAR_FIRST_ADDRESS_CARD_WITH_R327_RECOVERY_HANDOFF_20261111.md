# MOA R325 — 주소 검색 결과 별표 우선 실행 수정 / R327 기능복구 (2026-11-11)

> 상태: **원본 서명 APK 빌드·정적 검증 및 모의 브라우저 3건 PASS. 실제 Galaxy R325 별표 클릭·네이버 계정 저장은 미검증.**

## 실기기 새 증거와 직접 코드 원인

사용자가 제공한 비공개 `20324.mp4`에서 R321의 일기 사진 GPS 주소가 네이버 PC 지도 검색 결과 헤더로 전달되고, 그 아래 실제 주소 전용 ☆ 별표가 보이는 사실을 확인. 사용자 인증정보·실주소·가족 사진·영상은 공개 GitHub에 넣지 않음.

배포된 R321 원본 JS `assets/web/moa-r231-naver-frame-probe.js`의 확인된 실행 순서는 `SEARCH → FOLDER(불확실한 내부 GET API) → SAVE/주소 ☆`. `saveExactAddress()` 진입 자체에 `validId(job.folderId)`를 요구해, **아직 저장 다이얼로그를 열어 보기도 전에 기존 리스트 조회 실패가 별표 클릭을 막는 구조적 결함**. 이전 R317/R321에서 별표 선택자를 추가해도 이 선행 차단이 남아 있었으므로 동일 실패를 반복했다.

예전 PC 자동화 인수인계에는 주소 결과 별표 `button.btn.btn_favorite`, 저장 목록 `button.swt-save-group-info` 기록이 있음. **원본 PC Python 자체는 현재 연결된 GitHub/Library에서 확보되지 않았으므로 읽었다고 주장하지 않는다.** 실제 사용자 화면에서는 주소 헤더 바로 아래 독립 별표가 확인된다.

## R325 변경 (R321 성공 주소검색과 다른 코드 유지)

- `MOA_R325_ADDRESS_STAR_FIRST_EXISTING_LIST_BETA.apk` code **325**, 8,906,741 bytes SHA256 `06c3d646e61f11f87e6042585380906b2c41d0de6843748cfd204afd8cfe8d97`, package `com.juhyeon.familyjournea`.
- 원본 APK 서명 certificate SHA256 `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`, Android APKv2 전체 digest/RSA, ZIP CRC/STORED alignment PASS.
- R321과 비교 **두 파일만 변경**: `AndroidManifest.xml` (321→325), `assets/web/moa-r231-naver-frame-probe.js`; **16개 DEX 전부 byte-identical**, 나머지 앱/일기/갤러리/녹음/기존 점유형 네이버 저장 기능 payload 불변.
- 정확한 원본 주소/지번 확인 후 **FOLDER보다 ☆ 클릭 먼저**, 기존 PC `button.btn.btn_favorite` 지원. 화면 전역 저장·widget_favorite 제외, 다른 지번/복수 후보/이미 저장된 별표는 건드리지 않음.
- `STAR`→`DIALOG` 단계로 분리, 최상위 DOM 또는 정당한 `searchIframe` 하위문서에서 같은 주소 확인. 별표는 job당 최대 1회.
- 별표 뒤의 네이버 본래 저장창에서 **사용자가 선택해 둔 기존 폴더 ID**를 찾고 별명/메모/확정 버튼을 누르는 순서. 이 ID가 없거나 확인 안 되면 별표는 눌리지만 **어느 동명 리스트에도 무단 커밋하지 않음**. 새로운 목록 생성/삭제 없음. `NAVER_READBACK_VERIFIED`는 같은 계정의 정확한 주소+folderId+별명+메모 재조회 시에만 표시하도록 이전 안전게이트 유지.
- 외부 마켓/도우미 앱·root/Shizuku/전화기 화면 점유 기능 추가 없음.

## 검증

- 실제 서명 R321 APK에서 바이트 diff 비교 2/138 entries만 변경; DEX 16/16 보존, 원본 인증서 및 V2 서명 검증 PASS.
- JS 23,491자 (native WebView 24,000자 제한 이하), Node syntax PASS.
- **Node VM 집중 14/14 PASS** (선행 folder gate 제거, 정확 주소 1회 별표, 불확실한 주소/중복/글로벌 버튼 무클릭, child searchIframe 이벤트, 폴더 ID 있을 때만 커밋).
- **실제 로컬 Chromium 브라우저에서 가상 네이버 형태 DOM 3/3 PASS**: ID가 없어도 ☆ 클릭 후 저장창 열림; 사전 고유 ID가 있으면 목록 선택+커밋 1회; 다른 지번 무클릭. **실제 NAVER 도메인이 아님**: 이 실행환경의 직접 NAVER/localhost 네트워크가 차단돼 테스트 전용 about:blank origin으로 실행. 테스트 성공을 네이버 서버 저장 성공으로 혼동 금지.
- 실제 Galaxy R325 설치, NAVER DOM 셀렉터, synthetic .click()의 실제 사용자 활성화 요구, popup의 폴더 ID 노출, 서버 독립 readback 전부 미검증.

## R327 복구

`MOA_R327_RECOVER_R321_ORIGINAL_FUNCTIONS.apk` code327, 8,906,599B, SHA256 `d79d6598a84e70d41ef5216dc741bee7d258fd82a799a76836fd50c7d7fd0d97`. R321과 functional payload 정확히 같고 AndroidManifest의 versionCode만 상향. 원본 서명 동일; update-install 후보이며 실제 Galaxy 복원 테스트는 아직 미실시. 앱 삭제·데이터 초기화·네이버 계정 로그아웃 금지.

전체 ZIP `MOA_R325_ADDRESS_STAR_FIRST_R327_RECOVERY_QA_20261111.zip`, 12,916,381B, SHA256 `ab6bb33a310824f747a44c2908d3411c39cf8a9cd71c7ad963d5985c7c53dcba`. 두 서명 APK + 수정 JS + 테스트 코드/출력 + 정적 QA + diff 포함. 현재 채팅 첨부로 제공. Library 전체 ZIP 저장 시도는 용량 초과로 실패했으므로 저장했다고 주장하지 말 것.

**개인 Library에는 안전한 텍스트 소스가 성공적으로 보관됨**: `/모아_프로젝트_근거_20261103/R325_20261111/moa-r325-star-first-compact.js`, `R325_README_KO_AND_LIMITS.md`. 원본 서명 비밀값/개인 주소/영상 공개 업로드 금지.

## 이어서 할 것

1. R325를 기존 R321 위에 제거/초기화 없이 업데이트한 실기기에서 **이미 성공한 주소 검색을 다시 분석하지 말 것**. 결과 주소 바로 아래 ☆ 자동 클릭 → 네이버 저장목록 화면 오픈 여부만 확인.
2. ☆ 클릭 후 목록 화면이 실제로 열리면 해당 퍼스트파티 실제 리스트 DOM에서 저장 대상의 **고유 folder/shareId** 취득→동명 리스트의 사용자 지정/마지막 사용 선택→별명·메모→한 번만 저장→실제 계정 readback을 이어 구현. 기존 리스트 연결 별도 필수 UI 제거가 최종 목표. 이름만 같거나 '185개'라는 숫자만으로 위험하게 자동 선택 금지.
3. 별표가 여전히 눌리지 않으면 현재 네이버 웹의 실제 주소 헤더/별표 DOM와 프레임 유무를 **좁혀서 관찰**하고 해당 한 단계만 보수; 재빌드로 검색을 망가뜨리지 않는다.
4. 개인정보·원본 사진·지도·음성·기존 점유형 네이버 저장·R269 사용자 Golden 및 AirPods 소스/데몬 유지, 절대 uninstall/clear.
