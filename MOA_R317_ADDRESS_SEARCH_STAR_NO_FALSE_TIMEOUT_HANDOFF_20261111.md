# MOA R317 — R313 실기기 영상으로 원인 확정한 주소 결과 별표 보수 / R319 안전 복구 (2026-11-11)

> **실제 APK 산출·서명·정적 테스트 PASS, NAVER 실제 계정 저장 및 실기기 R317 PASS는 아직 없음.** 모아 기존 골든/일기/영상/점유형 저장을 유지한 베타다.

## 업로드된 R313 실기기 영상의 증거

- 사용자는 모아 일기 사진 GPS에서 네이버 PC 지도 검색까지 양쪽(화면 보이게, 뒤로 보내기) 모드에서 실기기 성공했다고 확인했다.
- 약 16초 후 MOA 화면에는 실패가 발생하지만, 웹 지도로 복귀하면 해당 사진의 실제 주소 검색 결과가 남았다.
- 사용자가 **해당 주소 결과 헤더의 별표를 직접 클릭**하니 네이버 PC 지도 원래 저장 목록 선택 UI가 정상 열렸다.
- 이 별표는 지도 상단 전역 저장 위젯이나 업체 numeric POI 상세의 별표가 아니다.
- 개인정보 포함 주소/영상/사진은 공개 GitHub에 업로드하지 않음. 사용자가 저장을 실제 완료했다는 증거 없음.

## 배포 R313 소스에서 확인한 원인

1. 시작 후 native 상태는 QUEUED만 기록하고, 주소 검색 SEARCHING 보고를 빠뜨렸다. 앱 쪽 기존 16초 QUEUED 감시가 **진짜 검색 성공도 WEB_NO_FRAME_ACK로 오인**할 수 있다.
2. 검색 자동화는 `li.UEzoS,li.VLTHu` + numeric `/place/<sid>` POI만 선택, `entryIframe`에서만 별표/리스트/메모/저장을 수행한다. 실기기 주소 검색 결과 카드 **헤더 별표 경로는 애초에 구현되어 있지 않았음**.

## 이번 R317 바이너리 변경

원본 R313 APK SHA256 `eb0768cdb2c8f22ae315081710a83ce53996b002b9a2d214cfe3946d76e033e1`.

- R317 `com.juhyeon.familyjournea`, versionCode **317**, `MOA_R317_ADDRESS_RESULT_STAR_ONE_APP_BETA.apk` 8,908,129B SHA256 `041e1bda35653ffa2f3f35c28c82959e94e50dde80a466a86751175e3ba31c4c`.
- R313 대비 정확히 **2 ZIP member만 변경**: `AndroidManifest.xml` (313→317) 및 `assets/web/moa-r231-naver-frame-probe.js`. 기존 다른 JS, 16 DEX와 136개 나머지 멤버 그대로.
- 원래 package/signing certificate SHA256 `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`, 독립 APKv2 RSA/전체 content digest/CRC/ZIP 정렬/DEX 비교 PASS.
- **검색 시작 SEARCHING 즉시 보고** (16초 무응답 오판 수정).
- 신규 '주소 결과' 분기: 지번/도로명 결과 헤더의 정밀한 주소 매칭(행정구역 명칭 약칭만 정규화) 후 동일 카드 근처 유일한 미저장 별표만 선택. 상단 전역 저장 메뉴/오른쪽 widget_favorite는 제외.
- 네이버 동일 인증 세션에서 사용자가 **기존 폴더 ID를 직접 연결했을 때만** 별표를 한 번 누를 수 있고, 실제 목록 ID 행·별명·메모·저장 버튼을 확인한다. 없는 ID, 중복, 비매칭, 불명확한 저장 상태는 차단.
- 클릭 기록 선저장·중복 토글 금지. 최종 `NAVER_READBACK_VERIFIED`는 같은 인증 계정의 정확한 folderId + 원본 주소(또는 실제 numeric SID) + 별명 + 메모를 **독립 읽기**로 확인한 경우만 허용. 실제 NAVER 비공개 GET endpoint 및 UI attribute 호환 **미확인**.
- 새 폴더 생성/삭제, 이름·185개 숫자만 보고 고르기, ROOT/Shizuku/PC 강제 도우미, NAVER 전면 점유는 추가하지 않음.

## 복구 안전망

- R319 `MOA_R319_RESTORE_R313_FUNCTIONS_SAME_SIGNER.apk` 8,906,089B SHA256 `bc79acb9e37f4cde39c5816b992c8a80bb88ebb7a81c60fff5c7db9628e27a9e`.
- R313 대비 Manifest versionCode 313→319만 달라서 **R313 기능 소스와 16 DEX가 바이트 동일**. 같은 원본 서명; R317 위에 높은 버전 덮어쓰기 후보. 실기기 R319 복구 역시 미시험.
- 별도 새 앱/기존 앱 제거·데이터 삭제/로그인 초기화 금지. R269 Golden SHA256 `c0663e65aac2b72feb86cb0f1ba5eac448b6599c3850858de4d942f2aa446920` 보존.

## 검증 결과 / 배포 위치

- `node --check` PASS.
- 기존 R313 호환 **18/18 Node**, 신규 주소 헤더·행정구역 약칭·번호 혼동 방지·전역 위젯 금지·고유 ID 없을 때 금지·한 번만 터치·주소 재조회 **10/10 Node** = 28/28 로컬 PASS. **모의 DOM 시험이며 실제 NAVER 웹 클릭 PASS 아님.**
- 비로그인 공개 PC 지도 구조 별도 CI [42958535557](https://github.com/yooogillycloud123/family-journey-personal/actions/runs/42958535557) SUCCESS; 샘플 검색은 결과 없음으로 실계정 주소 카드 DOM 상세까지 검증할 수 없었음.
- 패키지 ZIP `MOA_R317_APK_R319_RECOVERY_SOURCE_QA_20261111.zip` 12,909,470B SHA256 `d078ba5841ad134201e30315fa6bfcc5483382ff77fe6c8ac79776b51e68956c`, signed APK 2개 + 실제 수정 JS + unified diff + SHA manifest + 28 tests+QA/README. 기존 채팅 container download artifact로 생성; private Library quota 문제를 건너뛴 업로드 성공 주장을 하지 않음. **민감한 서명키/패스워드와 영상, 실주소 원문 없음.**

## 다음 실제 단계

R317 동일 앱 업데이트(현재 설치 code보다 높을 때만), MOA 내부 PC 로그인 세션 유지 → 네이버 PC 웹창 `MOA 기존 리스트 연결`에서 사용자가 **진짜 원본 폴더 ID** 명시 지정 → 기존 일기 사진 네이버 저장 버튼 1회 → SEARCHING/주소 결과 별표/해당 리스트 ID 행/별명/메모/실계정 GET 재조회 확인. 저장 완료가 확인되지 않으면 반복 탭/자동 생성 금지.

**남은 차단 지점:** 진짜 네이버 PC 웹의 주소 카드 selector, 기존 폴더 first-party ID가 DOM/비공개 GET 응답에 존재하는지, WebView synthetic click의 사용 승인, 인증된 저장·readback은 실기기에서 아직 확인하지 못했다. 사용자 실계정 PASS 전 FINAL 금지.

기존 R309/R313 및 본 사용자 관찰/기록을 보존하고, 성공한 주소 검색을 새 코드로 처음부터 재작성하지 않는다.
