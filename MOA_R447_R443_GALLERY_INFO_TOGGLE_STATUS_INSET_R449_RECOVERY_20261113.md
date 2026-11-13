# MOA R447 — R443 갤러리 상단 촬영정보 펼치기 버튼 가시성·터치 위치 복구 / R449 정확한 R443 복구 (2026-11-13)

## 실기기 증거와 원인
- 사용자 보고: R443 개선사항 2~4번(컴팩트 하단 공유/지도, 공유 후 갤러리 유지, 기존 사진·영상 조작)은 적용됨. 그러나 1번(상단 촬영 시간/주소/네이버 지도 접기·펼치기)이 완전히 사라져 보임.
- 비공개 실기기 증거 `20918.png`, `20920.mp4` (~22초)에는 하단 아이콘 바/기존 갤러리가 정상 노출되나 최상단 펼치기 조작부는 쉽게 찾을 수 없음. 원본은 반드시 비공개 Library에만 보존.
- **실제 소스 원인:** R443 `MoaR391SessionPersistProvider`가 기존 `r225Info` 패널을 `GONE`으로 만들면서 새 `TextView("⌄")` 펼치기 버튼을 `FrameLayout.LayoutParams(Gravity.TOP|CENTER_HORIZONTAL)`, `topMargin=4dp`, 크기38×27dp로 추가. 삼성 갤러리의 시스템 상태표시줄/전체화면 좌표와 겹치고 희미한 반투명 문자라 터치와 시인성이 떨어짐. video contact sheet 일부 프레임에 상단에 아주 희미한 표시가 있으나 사용자 스크린샷에서는 사실상 보이지 않음. 별도의 갤러리 렌더러/네이버 저장 오류는 아님.

## R447만의 제한적 변경
- 개발 브랜치: `feature/moa-r447-gallery-info-toggle-inset-20261113`, 부모 `feature/moa-r443-gallery-top-collapse-share-retain-20261113`.
- 기존 부가 Java `experiments/moa-r391/MoaR391SessionPersistProvider.java`의 갤러리 상단 토글 **표시·배치 부분만 변경**.
- `r447TopToggleY(Activity,FrameLayout)`: Android `WindowInsets.Type.statusBars()`의 실제 상단 인셋과 갤러리 host `getLocationOnScreen()`를 기준으로 토글을 상태표시줄 아래에 배치; 호스트 크기에 따른 안전한 제한. 4dp 고정 위치 제거.
- 접힌 상태: 가독성 있는 반투명 둥근 **`정보 ⌄`** (74×36dp), 높아진 native elevation/Z-order, 기존 갤러리 영상 위에서도 `bringToFront()`. 펼친 상태 `정보 ⌃`를 눌러 닫을 수 있음.
- 기존 `r225Info` 메타데이터(촬영 시간·주소·네이버 지도 이동·`기본 표시` 체크박스)는 그대로 보존. 펼칠 때는 토글 아래에 카드가 놓이게 해서 겹침을 막음. 기본 접힘 및 SharedPreferences `moa_r443_gallery_top_info_v1/show_on_open` 기존 값을 그대로 사용.
- R443의 가벼운 하단 50dp 공유·지도 아이콘, R227 외부 Activity 공유 후 갤러리 유지 로직, 가로 썸네일/동영상 재생·음소거·캡처·음량, R435 네이버 비점유 저장·자동 재시도·홈 버튼 이동·로그인 쿠키 등 **수정하지 않음**. 네이버 지도/갤러리 경로의 모든 뷰어를 동일하게 만든다는 미검증 주장은 하지 말 것.

## 아티팩트와 검증
- 부모 R443 signed APK code443 SHA256 `4efee36ba1481e1d4a27509a2ad858577d5dc5ae55e64df9bbfec31b5fe7877d`.
- Android SDK 35 javac/D8 [GitHub Actions 43363123709](https://github.com/yooogillycloud123/family-journey-personal/actions/runs/43363123709) **SUCCESS**. 새 `classes17.dex` 55,504B SHA256 `7588e5a69b1142d78866a96a0b4c0236cc202de396cc49cdbaa7e83a1872b395`.
- **R447 설치 APK:** `MOA_R447_R443_GALLERY_INFO_TOGGLE_SAFE_BETA.apk`, versionCode447, 8,968,411B SHA256 **`27ddce6749c68c6f81b87bb3e03f6da63c0b8d72a01f3e9916ae04473d96a3f2`**.
- **R449 비상 복구 APK:** `MOA_R449_EXACT_R443_FUNCTIONS_FORWARD_RECOVERY.apk`, versionCode449, 8,967,715B SHA256 **`03883905e47a4c306173e6d6723e7764a7f934286644840b21d4b80ba7c465c3`**. R447에서 심각한 회귀가 생길 때만 설치. R443의 기존 버튼 위치 문제는 R449로 되돌리면 재발할 수 있음. 이후 업데이트 versionCode >449 필수.
- 두 APK는 original signer cert SHA256 `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`, APK Signature Scheme v2 RSA + 전체 signed-content digest **PASS**, ZIP CRC + STORED alignment + 17 DEX Adler32/SHA1 **PASS**.
- R447은 R443 APK 140개 항목 중 **138개 원본 payload 완전 동일**, 변경 `AndroidManifest.xml` + `classes17.dex`만. R449는 139개 동일(Manifest 버전만 변경). `classes6.dex` 고급 갤러리, `assets/web/fj-naver-favorites.js`, 일기·홈 JS, 사진/영상 기능 그대로 보존.
- 전체 백업 `MOA_R447_INFO_TOGGLE_R449_EXACT_R443_RECOVERY_QA.zip` 12,977,022B SHA256 `c3ed0ebc8f58a507c3bdc98cc4630452766bf2063d5febc297b76371a8b47fc8`. 실제 로그인 인증정보/서명키/사진/영상 없음.
- **PRIVATE Library:** `/모아_프로젝트_근거_20261103/R447_INFO_TOGGLE_FIX_20261113/`에 두 APK, 소스/QA ZIP, 영상/사진 비공개 보존. 과거 R435 통합 골든, R439/R443 기능 보존.
- **실기기 검증:** R447 갤럭시에서 토글이 보이고 눌리는지, 펼친 원본 촬영정보·GPS/네이버 지도 버튼과 기본 표시 체크박스가 정상인지 **아직 미확인**. Java 빌드와 정적 보존 검사는 PASS이나 physical PASS를 주장하지 말 것.

## 실기기 테스트와 후속
1. 원본 패키지 `com.juhyeon.familyjournea` 그대로 덮어쓰기 (기존 앱 삭제, 데이터/쿠키 지우기 금지).
2. 사진/동영상 갤러리 상단 상태표시줄 바로 아래 **`정보 ⌄`**가 보이는지 확인; 터치 후 시간·주소·지도·기본 표시가 보이는지 확인. 다시 접기.
3. 공유 → Android 공유창 → 돌아오기에서 사진/영상 유지, 하단 아이콘·레일·동영상 조작, Naver 지도 및 비점유 저장 확인.
4. 심각한 R447 회귀만 R449로 복구. R435 사용자 승인 통합 골든은 별도 원본으로 보존하고 자동 승격하지 않음.
