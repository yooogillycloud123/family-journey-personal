# 모아 R621/R622 — 고정 날짜 제스처 · 원본 스타일 연월 휠 · 세로 사진 선택 · 큰 미리보기

**날짜: 2026-11-16. 상태: R621 정적/브라우저/동일서명 PASS, Galaxy 실기기 PENDING, 골든 아님.**

## 1. 사용자 실기기 관찰과 과거 오해
사용자 제출 `22611.png`, `22613.mp4`(51.32초), `22614.mp4`(64.87초): R619의 날짜 칸 전체가 좌우로 미끄러지는 동작은 사용자가 원한 '자리 고정 + 숫자만 변화'가 아님. R619 길게 누르기 팝업은 기존 일기 달력의 바텀시트 연·월 세로 스크롤 대신 별도 전체 페이지 선택 형태. 사진형 설정은 원본 Android 네이티브 갤러리 뷰 뒤로 묻히기 쉬움. `+` 사진 선택 화면에서 다시 `+`를 누르면 이전 일기로 복귀해야 함. R619 사진 선택은 가로 레일·날짜별 '더 보기' 의존; 요구는 세로 자연 스크롤·자동 로딩·날짜 구분·큰 미리보기에서 이동과 선택.

## 2. 실제 R619 소스 대비 좁은 수정
- R619 기준 원본 APK SHA256 `8251ede19b932147445fed3d991cc9ee5fcaf5c74c78ca7b1084ee5ed277416c` versionCode 619.
- `r619DateRail` 91개 움직이는 셀을 **한 개 고정 텍스트**로 변경. Pointer 제스처 거리·속도만 계산하며 텍스트 내용만 갱신, 최종 프레임에서 기존 `r619ChangeDay` 1회 호출. 빠른 제스처 이동 수 ±14일 제한. 터치 560ms 길게 누르기 또는 날짜 짧게 탭하면 연·월·일 휠 선택.
- 기존 달력 메인 `r479PeriodSheet`의 `.moa-r479-picker-backdrop`, `.moa-r479-picker-sheet`, `.moa-r483-picker-columns`, `.moa-r483-year-list`, `.moa-r483-picker-months`를 **실제 공통 CSS로 재사용**. 연도 1900~2100과 월 1~12를 **세로 스크롤**하고, 날짜는 바텀시트 내부 7열 숫자에서 고름. 선택 후 원래 사진형·상세형 날짜로 연결.
- 사진형 설정: `r539PhotoSettings`를 별도 페이지의 **아래에서 올라오는 바텀시트**로 전환. 설정이 Android Activity-root 원본 갤러리 Surface 아래에 가려지는 것을 방지하려고 사용자 설정 진입 순간 기존 R619 선택기와 같은 방식으로 원래 갤러리를 정상적으로 일시 종료함. 닫을 때 같은 날짜의 원본 R611 네이티브 갤러리 재진입. 기존 원본 8아이콘·필름스트립·외부 네이버 서비스는 수정하지 않음. 삼성 실기기 실제 복귀 확인 필수.
- `r472Nav` 하단 중앙 `+` 콜백: `picker`/`period`/`settings` 화면이면 새 선택기를 열지 않고 `r619ReturnFromAux()`로 **원래 선택 날짜 일기** 복귀. 기존 달력/일기 화면 직접 연결 유지.
- 사진 선택: 기존 MediaStore index `FamilyJourneyDiary.state.photos/videos/byDay/byVideoDay`와 원래 `r619CommitPicked` IndexedDB curated ID 병합 보존. `r619RenderPicker`를 날짜별 **3열 세로 grid**, 매 날짜 32개 썸네일 배치, `IntersectionObserver`에 따른 자동 추가/다음 그룹 제공. 더 보기 버튼 없음. 좌우 scroll-snap 사용하지 않음.
- 큰 미리보기: 원래 `fillImages` 큰 썸네일 요청 재사용, 미리보기에서 좌우 이동·선택·선택 해제, 사진/영상 같은 날짜 목록 공유, 원래 `r619PickSelection` Set 그대로 유지. 동영상 미리보기의 WebView `content://` 재생은 기기 권한에 따라 제한 가능. 네이티브 동영상 엔진은 수정하지 않음.
- Back/Escape에서 미리보기 먼저 닫기 → 보조 시트 닫기 → 원래 날짜 일기로 돌아가기 우선순위 보완. 원래 일기·음성·태그·촬영 GPS·네이버 계정 데이터를 편집하지 않음.

## 3. 검증·해시·복구
- **R621 배포 APK**: `MOA_R621_R619_GOLDEN_FIXED_DATE_WHEEL_VERTICAL_MEDIA_PREVIEW_ORIGINAL_SIGNED_BETA.apk`, versionCode **621**, SHA256 **`748efd3c2836b1325393f1815006948d373e76c7ea85415a9d8c98633bffaca3`**, 9,121,637B.
- **R622 긴급 R619 기능 복구**: `MOA_R622_EXACT_R619_FUNCTIONAL_FORWARD_RECOVERY_ORIGINAL_SIGNED.apk`, versionCode **622**, SHA256 **`bbc08c67cb2e849ad38cdc43051be39990739896706fa9834e488ae6b6e2a8b5`**, 9,117,539B. 원래 R619 대비 AndroidManifest.xml 버전만 변경. **R622는 R611 순정 UI가 아니라 R619 기능으로 복원**하는 점 유의. 이후 신규 버전Code ≥623.
- R621은 R619 144 APK 엔트리 중 Manifest/photo JS/photo CSS **3개만 변경**, **141개 내용 완전 동일**, 모든 **18 DEX 바이트 동일** (최고 불변 R611 골든에서 이어진 One Hand Operation+ NAVER 접근성 재진입 복구 포함). 원본 서명 인증서 SHA256 `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15` 일치, APK v2 signed contents 검증 SDK 29·35·37 PASS, ZIP CRC PASS, stored 멤버 4바이트 정렬 PASS.
- Node 전체 수정 JS `--check` PASS. 실제 수정 JS 함수+CSS Chromium: 고정 날짜만 표시 및 터치 플링 1회 최종 날짜 변경, 기존 스타일 하단 연월 시트 201년/12월/일 달력, 세로 3열 date group (no More, no horizontal snap), 자동 추가 62→94개, 큰 미리보기 선택/해제와 사진형 설정 하단 시트 PASS. 이는 **브라우저 모의 데이터**이며 실제 Galaxy의 Android native overlay·영상 권한·관성·네이버 접근성·미디어 저장 결과를 증명하지 못함.
- **최상위 불변 실기기 골든: R611** APK SHA256 `38a507cf2e88a235282ae4d9ad64cf0799033f34ae8fe3e179a58960d1213ccd`, One Hand Operation+ 네이버 접근성 OFF→ON 반복해도 기존 네이티브 갤러리 원본 8기능 작동. R619·R621은 아직 골든 승격 금지.

## 4. 절대 금지 및 새 채팅 규칙
원본 R611/R605 골든 GitHub 브랜치·APK 변경 금지. 앱 삭제/저장공간·쿠키·네이버 세션 초기화, 원본 갤러리/네이버 접근성 DEX 변경, 새로운 미디어 저장 엔진 생성, 근거 없는 자동 재시작 금지. 원본 APK와 브라우저 결과, 사용자 실제 휴대폰 결과를 별개로 검증. 수정 기능의 **방향/보이는 요소의 고정 여부/관성/컨트롤 위치/네이티브 Z-order**까지 확인할 것. R622는 문제가 심각할 때만 동일 서명 덮어 설치.
