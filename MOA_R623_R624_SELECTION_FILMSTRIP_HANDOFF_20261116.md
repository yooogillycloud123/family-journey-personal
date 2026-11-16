# MOA R623/R624 — 카카오톡형 선택 순서·드래그, 큰 미리보기 필름스트립 (2026-11-16)

## 원천 자료와 실제 관찰
- 사용자가 제공한 **`22620.mp4` 약 46.44초**: 카카오톡 전체보기에서 사진 터치 시 바로 확대되는 대신 **선택 순서 번호**가 썸네일 우측 상단 원 안에 표시, 상단 선택 개수, 연속 드래그 다중 선택. 확대는 선택과 분리되며 미리보기에서도 선택 유지.
- 사용자 **`22622.mp4` 약 37.48초**: 현재 모아 R621 날짜별·전체기간 세로 3열 선택기는 사진 본문 누르면 즉시 확대, 작은 + 클릭해야 선택, 확대 화면에는 원래 갤러리 스타일의 관성 필름스트립 부재. 사용자 의도는 **사진 클릭=선택, 좌하단 별도 확대, 길게 눌러 드래그 선택, 확대 안에서도 ON/OFF 빠른 이미지 넘김·하단 관성 필름스트립·선택**.
- 사용자가 승인한 최상위 **불변 골든 R611**: 원래 Android 네이티브 갤러리 8기능/하단 고속 필름스트립, 상세형 왕복·앱 복귀, Samsung One Hand Operation+ 네이버 즐겨찾기 접근성 OFF→ON 반복 이후에도 갤러리 유지. 해시 `38a507cf2e88a235282ae4d9ad64cf0799033f34ae8fe3e179a58960d1213ccd`. 새 베타는 골든으로 자동 승격하지 않음.
- **직전 R621 베타 원본 실제 SHA256** `748efd3c2836b1325393f1815006948d373e76c7ea85415a9d8c98633bffaca3`, versionCode621. 과거 인계 상충 시 실제 원본 APK 바이트 해시가 우선.

## 수정 범위 및 동작
- R621 실제 서명 APK에서 변경한 구성요소 **3개**: `AndroidManifest.xml`(version621→623), `assets/web/moa-r483-vertical-calendar.js`, `assets/web/moa-r483-vertical-calendar.css`. **141/144개의 원본 payload byte-identical**, **네이티브 classes.dex ~ classes18.dex 18/18 byte-identical**. 네이버 AccessibilityService, 원래 Android Gallery, 직접 기록 M4A, diary IndexedDB writer 원본을 수정하지 않음.
- 기존 `r619PickSelection` Set 하나를 그리드·미리보기·필름스트립이 공유. 사진 본문을 클릭하면 선택·해제, **번호는 Set 삽입 순서**로 계산. 우측 상단 원형 배지(빈 원/숫자), 상단 개수와 기존 저장 버튼 개수 동기화.
- **좌측 하단 29px 독립 확대 버튼**은 선택을 바꾸지 않고 큰 미리보기만 연다. 큰 미리보기에서는 본문 사진 스와이프로 앞뒤 이동; 일반모드 한 장, **빠른 이동 ON**에서 제스처 거리/속도에 따라 최대 9장 이동. 원래 네이티브 Gallery fast 모드를 조작하지 않는 별도 선택기 상태이며 로컬 설정을 보존한다.
- **하단 필름스트립**은 손가락 `overflow-x:auto` 관성 스크롤(`-webkit-overflow-scrolling:touch`, `touch-action:pan-x`), 썸네일 탭으로 현재 사진으로 이동. 125개 이내의 가까운 원본 항목 윈도우로 대량 MediaStore 성능을 보호하고 `IntersectionObserver`로 보이는 썸네일만 로딩. 선택 순서 숫자와 현재 위치 테두리, ON/OFF 빠른 이동(스냅 근접/없음), 펼치기/접기 가능. **이는 R611 네이티브 필름스트립을 대체하는 것이 아니라 사진 추가 Web 선택기 내부 유사 동작**이다.
- **연속 터치 선택**: 360ms 장기 터치 후 드래그 중 지나는 사진을 원본 배열의 연속 구간으로 선택 또는 해제. 시작 시 Set을 복사하고 매번 범위를 재구성하여 반대로 이동해도 불필요한 중복 없음; 상단/하단 가장자리에서는 자동 스크롤. 평소 상하 스크롤은 10px 움직임에서 long-press를 취소해 보존. 사진 확대 버튼 터치는 제외.
- 날짜별/전체기간·영상 혼합·오토로드·원본 이미지 요청(`fillImages`)·실제 저장 `r619CommitPicked`/IndexedDB curated.photoIds 병합은 **기존 코드 그대로**. 큰 미리보기 하단의 바로 추가는 원래 저장 함수를 호출.

## 검증 결과
- 실제 JS 전체 `node --check` PASS.
- 원본 수정 JS 함수+CSS로 Chromium 모바일 390×850 실행: 사진 본문 터치 선택→원형 번호1,2; 좌하단 확대는 선택 수 유지; 큰 미리보기의 동일 Set 선택/해제; 썸네일 필름스트립 렌더; 빠른 모드 긴 스와이프 여러 장 vs OFF 한 장; 필름스트립 펼침/접힘; 360ms 손가락 길게 누름+세 번째 사진까지 드래그 연속선택 **PASS**. 생성 화면은 인공 ID/색 블록, 사용자 원본 사진 아님.
- 원본 APK v2 전체 서명 SDK29·35·37 동일 인증서 SHA256 `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15` PASS. ZIP CRC·stored 4바이트 정렬 PASS, 18 DEX 바이트 일치 PASS. 기존 `r619CommitPicked`, 날짜 변경, MediaStore 원본 조회, 음성·상세형 파일 내용 동일 확인.
- **R623 실제 갤럭시 실기기 검증 = PENDING**, Kakao UI와 기능 완전 동일하다는 주장은 금지. WebView 단말의 long-press 제스처 충돌·대형 미디어 성능은 Galaxy에서 테스트 필요.

## 서명 APK와 복구
- **R623 설치본:** `MOA_R623_R621_GOLDEN_KAKAO_MULTIDRAG_PREVIEW_FILMSTRIP_ORIGINAL_SIGNED_BETA.apk`, versionCode623, 9,125,927 bytes, SHA256 `400ddac95278906a93b81ce640cf9aeef37afe57f5b27b7d7c406b241843983a`.
- **R624 비상 복구본:** `MOA_R624_EXACT_R621_FUNCTIONAL_FORWARD_RECOVERY_ORIGINAL_SIGNED.apk`, versionCode624, 9,121,831 bytes, SHA256 `e60d3167e3206a5ed97ba7091e4432ef8eb7d7929426da656bca05e4396eb457`. R621 대비 **143/144 payload 동일**, Manifest 버전만 변경; R623 신기능은 복구 후 없어짐. R624 설치 후 새 후보 versionCode≥625.
- APK 동일 패키지 `com.juhyeon.familyjournea`, 원래 인증서. 사용자 앱 삭제/데이터/네이버 쿠키 초기화 금지, R611 골든 원본 불변.

## 새 채팅 필수
먼저 `workexcel-devbridge/main/AA_AirPods_FINAL_READ_FIRST_v1.0_20261005.md` 전체 → `family-journey-personal/main/MOA_READ_FIRST_NEW_CHAT.md` → R611 Golden Lock → R621 Handoff → **이 문서** → 실제 최신 소스/APK 검사. 사용자가 지적한 실제 선택 동작을 우선하고 모호한 '빠른 이동'으로 네이티브 Gallery 엔진을 함부로 교체하지 않는다.
