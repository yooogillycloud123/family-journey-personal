# 모아 프로젝트 새 채팅 재개 프롬프트 — R611 불변 골든 / R619 날짜 관성·기존 사진영상 추가 베타 (2026-11-16)

모아 프로젝트 최신 진행에서 이어서 작업한다. 모든 분석·수정·APK 제작 전에 GitHub `yooogillycloud123/workexcel-devbridge/main/AA_AirPods_FINAL_READ_FIRST_v1.0_20261005.md`를 처음부터 끝까지 읽고, `yooogillycloud123/family-journey-personal/main/MOA_READ_FIRST_NEW_CHAT.md`, `MOA_R611_USER_DEVICE_APPROVED_GOLDEN_LOCK_20261115.md`, `MOA_R611_GOLDEN_ROOT_CAUSE_ENGINEERING_AND_R613_UI_HANDOFF_20261115.md`, `MOA_R617_R615_VISIBLE_SETTINGS_TRACK_REGRESSION_HANDOFF_20261115.md`, `MOA_R619_R620_DATE_FLING_MEDIA_MULTIADD_SIGNED_HANDOFF_20261116.md`, 최신 WIP와 Library를 읽어라.

## 절대 불변
- 사용자가 휴대폰에서 직접 성공 판정한 최신 골든 **R611**, APK SHA256 `38a507cf2e88a235282ae4d9ad64cf0799033f34ae8fe3e179a58960d1213ccd`. Native Gallery 원본 8버튼/필름스트립/동영상, 상세형↔사진형, 다른 앱 복귀, **One Hand Operation+ 네이버 즐겨찾기 접근성 OFF/ON 반복 후에도 갤러리 유지**. 원본 R611 APK 및 GitHub `golden/moa-r611-user-device-approved-onehand-naver-native-gallery-20261115` 브랜치 수정 금지. R605 이전 골든도 보존.
- 실제 사용자 설치용 서명 및 앱 식별자 그대로 유지. 앱 삭제·데이터/캐시/네이버 로그인 초기화·원본 네이티브 갤러리 DEX 교체 금지. 사용자 승인 없이 수정본을 새 골든으로 승격 금지.
- 사용자 지적을 무시하고 추측으로 전혀 다른 토글을 고친 R609와 시각적 클릭영역만 비교한 R615를 반면교사로 삼아, 사용자가 실제 실행한 기능 ID와 실제 가시 UI 크기부터 검증하라.

## 최신 제작
- R617 기존 설치 기준 원본 서명 부모 APK SHA256 `080049a3b736efcc3add032df9de09e23f5dd69302cbb87a0e00ad343ab7099c`; R617 실제 물리 화면 승인은 아직 없음.
- **R619 설치용 베타** `MOA_R619_R617_NATIVE_GOLDEN_DATE_FLING_MEDIA_MULTIADD_ORIGINAL_SIGNED_BETA.apk`, versionCode619 SHA256 `8251ede19b932147445fed3d991cc9ee5fcaf5c74c78ca7b1084ee5ed277416c`. R617 대비 144 멤버 중 Manifest + 사진 JS + 사진 CSS 3개만 변경, 141개 그대로, **18 DEX 전부 바이트 동일**. 실제 삼성 휴대폰 실기기 PASS 미확인.
- R619 구현: 사진형·상세형 동일 줄 왼쪽 날짜/오른쪽 모드 슬라이더·설정, 날짜 좌우 관성 스와이프 및 정지 후 날짜 이동, 560ms 길게 눌러 년·월·일 선택, 중앙 +에서 기존 일기 열기와 별도로 해당 날짜 사진·동영상 기본 목록/전체 기간 전환, 사진·영상 혼합 날짜별 수평 관성 스크롤, 다중선택, 기존 IndexedDB curated.photoIds에 안전한 병합(메모/음성/태그 보존), 복귀. 원본 MediaStore 파일 복사/삭제 없음.
- `feature/moa-r619-r617-golden-day-fling-photo-video-multiadd-20261116` 브랜치의 `release_snapshots/moa-r619/assets/web/`에 실제 R619 APK JS/CSS 바이트 일치 원본 백업. 브라우저 테스트 12/12, 원본 인증서 APKv2/ZIP/18DEX PASS이나 삼성 실기기 완주 테스트 아님.
- **R620 비상 복구** `MOA_R620_EXACT_R617_FUNCTIONAL_FORWARD_RECOVERY_ORIGINAL_SIGNED.apk` versionCode620 SHA256 `6149633358139c475008ac2fcad0794b0986b02c75641c0c530110b3bb59c3f7` = R617 실제 기능 그대로, Manifest 버전만 변경. **R620은 R611 불변 골든 기능으로 바로 복귀하는 파일이 아니라 R617 기능으로 복귀**하는 점 구분. 이후 코드는 versionCode>=621.
- 전체 소스/설치/복구/QA ZIP `MOA_R619_R620_R611_GOLDEN_DATE_FLING_MEDIA_MULTIADD_SIGNED_QA_20261116.zip` SHA256 `a7eb63836fcf6e0106b7911087238c927233c88c498a4205ebe993b2e062a560`, Library `/모아_프로젝트_근거_20261103/R619_R620_R611_GOLDEN_DATE_MEDIA_20261116/`.

## 실기기 검증 필수
기존 네이티브 사진형 8개 메뉴·동영상·필름스트립 확인 → One Hand Operation+ 네이버 서비스 반복 OFF/ON 후 여전히 원본 갤러리인지 → 사진형·상세형 날짜 줄 위치·간격 → 좌우 플링으로 여러 날짜 이동·뒤로가기 → 길게 눌러 년월일 선택 → +에서 해당 날짜/전체 기간, 사진+영상 혼합 다중선택과 원본 일기 내용·음성 유지 확인. 실패 시 원인을 좁히고 새 APK를 기존 골든 복제 브랜치에서 수정, 화면이 검은색/구형 Web fallback이면 성공이라고 말하지 말 것.

성공한 원본 기능 보호, 변경 멤버/서명/버전 해시 검증, 사용자 실제 재현에 근거한 가설·반증, 가장 좁은 수정, 실제 설치 가능 APK까지 완료를 우선한다. AirPods Android Auto 프로젝트 별도 오디오 소스 변경 금지.
