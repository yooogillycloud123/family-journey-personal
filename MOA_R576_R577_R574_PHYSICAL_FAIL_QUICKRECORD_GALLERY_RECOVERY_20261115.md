# MOA R576 — 실제 R574 실패 분석·수정 및 원본 서명 R577 복구 (2026-11-15 KST)

## 사용자 실기기 증거와 상태
- 직접 첨부 `22007.mp4` (75.6초): **R574에서 카메라 바로기록 후 상세형에는 기록이 있지만 사진형에서는 화면이 검게 남고 재진입해도 갤러리가 작동하지 않음**. 또한 사진/영상 처음 진입 때 검정 번쩍임 및 새로 만든 검은 빈 영역, 사진·영상 썸네일과 하단 8개 아이콘 사이 과도한 간격 지적.
- 사용자 확인: R574는 **FAIL**. 별도의 회색 전체 폭 바 제거, R572의 연속 넘김 ON/OFF 기억 및 비점유 네이버 저장 진행 안내 자동 종료는 이미 정상. 이 정상 기능들을 후속 패치에서 지켜야 함.
- **현재 사용자 실기기 승인 골든은 R567**. R576은 CI·브라우저 테스트·서명 검증 통과했지만 **Galaxy 실기기 NOT TESTED**. 절대로 승인 골든으로 승격하지 않음. 사진/영상 첫 프레임 완전 무깜빡임 역시 미확정.

## 실제 소스 증거 — R574의 결정적 가드 오류
- 상세형 원본 `assets/web/family-diary.js`: `r73Media(id)`는 `state.byId`에 없더라도 R73 임시 `fast` 색인의 새 촬영 ID를 표시. `mmNativeSaveDraft`는 상세형 IndexedDB `curated`에 ID/메모를 먼저 커밋하며 `loadIndex(false)`는 비동기로 따름.
- R574 사진형 `experiments/moa-r483/moa-r483-vertical-calendar.js`의 `r507StartInline.tryOpen()`가 `state.byId.has(id)`가 될 때까지 **원본 `openNativeGallery` 호출 자체를 계속 건너뛰도록** 개발됨. `byId`는 정식 MediaStore 목록 캐시일 뿐 실제 원본 ID 존재의 증거가 아니므로 사용자 Quick Record를 영구 차단할 수 있음.
- **이전 R574 Chromium 테스트는 해당 차단(오픈 안 함)을 PASS로 판정한 잘못된 기대값**이었음. 이 테스트를 재사용해 기능 성공을 주장하지 말 것.
- R574 네이티브 `MoaR507InlineGalleryProvider.updateVideoAmbient`는 R570의 TextureView **아래** 정적 배경을 변경해 비디오 TextureView **위에** 검은 `ImageView`를 생성하고 시간·준비 상태에 따라 닫음. 인위적인 검은 첫 진입 화면/변동의 추가 원인.
- R574 `nativeLower` 높이(사진 100dp/영상 126dp)와 rail `translationY=7/9dp`는 실제 썸네일·아이콘 사이 거리를 측정하지 않았기 때문에 사용자가 표시한 빈 공간이 남음.

## R576 패치, 수정 범위
1. 기존 R73 임시 사진 ID를 정식 `byId`의 등록 여부와 무관하게 **원래 Native Gallery로 전달**. full index refresh는 부수적으로/비차단으로만 실행. IndexedDB 사진 ID/메모/비점유·기존 저장 엔진은 유지.
2. R574 검정 오버레이를 제거하고 R570에서 쓰던 **TextureView 아래 고정 정적 배경** 방식으로 복원. Web 비디오 배경도 일률적 black/동적 blur 대신 썸네일 정지 이미지와 중립색을 사용. 원래 R463 영상 재생·다중 스와이프·캡처·TextureView 핸들러 불변.
3. 원래 썸네일 포함 하단 컨트롤의 **실제 표시된 하단 경계**와 액션 덱의 상단 경계를 Android 화면 좌표로 측정. 사용 가능한 공간이 크면 카드 내부 `nativeLower`를 최대 38dp 이동해 7dp 가시 간격 목표. 원본 리스너·위치 토큰·터치 엔진을 바꾸지 않음. 실제 픽셀 결과는 기기 확인 필요.
4. 동시/비점유 네이버 저장, 토스트 자동 종료, 8개 버튼·커스텀 순서, 연속 넘김 선호 설정, 사진/영상·일기/음성/스토리지 로직 보존. 고급 전체 갤러리 변경 없음.

## 빌드·보호
- **R576 설치 APK:** `MOA_R576_QUICKRECORD_PHOTO_GALLERY_COMPACT_RAIL_ORIGINAL_SIGNED_BETA.apk` versionCode **576**, 9,087,382 bytes, SHA256 `5bab7d434157bb9c755cbfa70db569012016d89fd1e55bcf760de096afaeb054`.
- **R577 긴급 복구 APK:** `MOA_R577_EXACT_R567_GOLDEN_FORWARD_RECOVERY_ORIGINAL_SIGNED.apk` versionCode **577**, 9,069,600 bytes, SHA256 `7a2a9d9eb04a25c7f6894efda454e278a36d6b7896fa403f87c7755172b362bb`. 기존 R567 골든 143개 멤버 중 AndroidManifest 버전 외 **142개 동일**.
- 원본 패키지 `com.juhyeon.familyjournea`, 동일 signing certificate SHA256 `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15` RSA/v2 signed-content/ZIP CRC/DEX checksum PASS. **서명 비밀/개인 사진/실기기 영상은 공개 파일에 포함하지 않음**.
- R574→R576 **144개 중 140개 바이트 동일**, 변경 `AndroidManifest.xml`, `classes18.dex` (격리 Java 사진형 provider), `assets/web/moa-r483-vertical-calendar.js`, `.css` 네 개뿐. 원본 네이티브 17 DEX, `family-diary.js`, 원본 `fj-naver-favorites.js`, 신규 `moa-r570-photo-favorites.js`, index.html 모두 동일.
- [GitHub SDK35 Java/D8/Node CI SUCCESS](https://github.com/yooogillycloud123/family-journey-personal/actions/runs/43612793745), `classes18.dex` 63,416 bytes, SHA256 `cab2e7e6591d430157178f906d3f4dfb38b4faac5b66602205c4fd56886ea611`.
- 새로운 Chromium 5/5: **R73 provisional ID에서 native open을 실제 호출**, 기존 indexed photo, 앱 재시작 후 provisional ID, native open 거부 시 IDB/페이지 보존, native ACK 후 웹 포스터 해제. R572 기존 GPS/Naver 요청/토스트 스코프 Node 계약 테스트 PASS. 브라우저·정적은 삼성 실제 MediaStore/플레이어 구현의 전수 증명이 아님.
- **전체 배포 ZIP:** `MOA_R576_R577_SAME_SIGNER_INSTALL_RECOVERY_SOURCE_QA_20261115.zip`, 26,334,242 bytes SHA256 `daa52a935cd47cebb86e7d0cb92dbc4618a4c1d70d4a0f9644ca634fac1d1a9b`, 19개 payload SHA/CRC 전부 PASS. 원본 R567 APK, 이전 R574 비교 APK, 변경 소스, CI DEX, 자체 검사·서명 무결성 검증 스크립트, 한국어 README 포함.
- R567 불변 브랜치: `golden/moa-r567-user-device-pass-20261114`. 새 소스 브랜치: `feature/moa-r576-provisional-capture-gallery-first-frame-rail-gap-20261115`. 둘 다 별도 운영, Golden 직접 수정 금지.

## 설치·복구·이후
- 기존 설치 R574에서 **R576만 덮어쓰기**. 앱 삭제/데이터 초기화/네이버 쿠키 삭제 절대 금지.
- 심각한 회귀 발생 시 **R577만** 설치해 정확 R567 기능으로 forward recovery. R577 설치 후 미래 새 APK는 code **>=578**.
- 실기기에서는 카메라 촬영→바로기록 후 상세형/사진형 동일 사진·메모→앱 재시작 후 다시 표시, 사진/영상 5회 첫 진입, 영상 조작, 실제 썸네일 간격, 원래 8 버튼 순서/다기능, 네이버 저장·Back·Home/Recents 순서로 확인. 물리 PASS 전에는 R576을 골든으로 지정하지 않음.
- AirPods / Android Auto 소스와 데몬은 본 작업에서 수정하지 않음.
