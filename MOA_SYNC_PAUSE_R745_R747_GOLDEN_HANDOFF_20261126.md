> **최신 사용자 정정 — R747 배포까지 마친 뒤 중단 (2026-11-26):** 사용자가 R747 업데이트까지 명시 요청. 이전 R747 미배포 상태는 역사적 기록이다. 기존 컴파일 CI 45796489841 산출물로 실제 원본서명 R747 APK 제작 및 APKv2 서명/내용 다이제스트/ZIP/DEX 무결성 검증 성공. R747 SHA256 451e240d713ceacfbcb8ceb4157be7083ddea85e7f3898e49f94dc4b6040eaac, 10773404 bytes, git blob 14e16f38123d06d2ad81460bc038dbed70458fcf. R745 대비 Manifest/classes6.dex/classes24.dex만 변경. R748 exact-R745 recovery SHA256 8ac8d077963eedf737d8ced0f9cbab8ef943e4b84a0ebd6c491b4874ab9ef7fc, 자동 배포 제외. 기존 R745 사진 실패 한계 포함. APK/QA/delta Library /에어팟안드로이드/MOA_R747_R748_20261126/. 배포 CI 45799734923 및 외부 검증 결과 아래 최신 추가 기록 확인. R747 실제 사진 화질 및 기존 기능 실기기 검증 미완료. R707 골든 원본 불변. R747 이후 추가 동기화 구현/배포는 사용자 재요청 전 중단, 차기 후보 >=749.

# 모아 동기화 개발 중단 및 골든 인계 — 2026-11-26
상태: USER_REQUESTED_PAUSE / PARTIAL_PHYSICAL_SUCCESS / PHOTO_QUALITY_FAIL / R747_COMPILED_NOT_RELEASED.
사용자가 "일단 동기화는 여기까지 기록 골든에 추가해서 기록하놓도록" 명시. 추가 구현/서명/배포는 사용자 재개 요청 전 중단. 이 기록은 R745 또는 R747을 완성 Golden으로 승격하지 않는다. R707 사용자 지정 불변 골든 원본 SHA256 b72856150410491b87cd01c3ecbe1a3178e2d1a6488fdf4494d06afcf50fb200 유지. AA AirPods는 별도 프로젝트, 변경 금지.

## 실기기 증거 및 보존할 성공
- R729: QR 등록, 같은 Wi-Fi에서 PC 없는 폰 허브-태블릿 원격 보관함 32개 목록 조회. 일반 달력 통합은 당시 미구현.
- R731: 설치 준비 실패 EBADF(설치는 진행), 원격 목록 IOException. R733에서 중복 stream close 및 날짜 포함 음성 ID 수정. 상세 기록 MOA_R733_INSTALLER_AND_REMOTE_CATALOG_FIX_20261126.md. 이후 기기 설치 준비 오류 완전 해결 여부 별도 검증.
- R741: 서로 다른 Wi-Fi로 추정되는 ConnectException, 같은 Wi-Fi 이후 실제 기존 일기 상세의 네이티브 영상 재생과 하단 레일, 원격 음성 2개 목록 표시 확인. 사용자가 영상은 스마트폰과 유사하게 재생된다고 보고. 음성 실제 재생, 모든 제스처, 4K/HDR 및 동일 체감은 별도 미검증.
- R741에서 사진 전체화면 화질 심하게 저하, 달력 대표 썸네일 누락. R743에서 달력 썸네일 실제 표시 성공(24775 등), 상세 갤러리 구형 Web fallback 및 사진 공백 발생. R745에서 전체 파일 AFD declared length UNKNOWN_LENGTH(-1) 복구, 실제 네이티브 갤러리 재진입 확인.
- 최신 실기기 24778.mp4 및 사용자 보고: 영상은 선명하지만 사진은 여전히 매우 흐림. R745 사진 화질 FAIL. 달력 썸네일과 영상/기존 UI 성공 경로를 보존하고 전체 구형 롤백이나 별도 간이 갤러리 금지. R743/R745 원본 사진 코드가 있다는 이유로 화질 PASS 주장 금지.

## 현재 배포 및 미완 작업
- 최신 실제 배포 manifest versionCode 745, published=true, 10764536 bytes, SHA256 6e9a8b924553c638e2461350b20c19ffa84de11dbe66204f6124921192f1ae31. 원본 signer 5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15. Library /에어팟안드로이드/MOA_R745_R746_20261126/. R746 exact-R741 recovery는 사진 흐림/달력 공백 한계 포함; 자동 배포 제외.
- R747 소스 브랜치 feature/moa-r747-selected-original-photo-20261126, experiments/moa-r747/. 기존 getBitmap/refreshPages에서 작은 poster를 표시한 후 full bitmap 적용 실패/누락 시 poster가 그대로 남는 결함 확인. 정확한 실기기 실패 분기 미확정. R747은 선택 사진 전용 worker, pinned raw 원본 range 읽기, seekable temporary original, 화면 기준 고해상도 decode, 현재 ID 일치 확인 후 UI 반영, 실패 상태 표시/재시도, 기존 네이티브 갤러리 refreshPages hook. 화면 렌더링 실제 테스트는 미수행. R745 AFD UNKNOWN_LENGTH 유지.
- 첫 CI 45796392808 실패(QA 출력 경로 불일치); 경로 수정 후 CI 45796489841 SUCCESS, head d00dc8d4284109596e787e630be28a6c8a104426. Artifact 15104957632 moa-r747-compiled-dex-and-qa, 133447 bytes, classes6/24 DEX + QA. **R747 원본 서명 APK 제작/인앱 배포 안 함, 실기기 미검증**. 현재 채널 R745 그대로. 다음 재개 시 R747 산출물부터 활용하되 코드 안전성 검토 및 실제 렌더링 확인 필요. R747/추후 복구 버전 번호는 실제 배포·설치 상태 확인 후 결정.
- 개인 Library /에어팟안드로이드/MOA_SYNC_PAUSE_R747_20261126/ 에 R747 컴파일/QA ZIP과 최신 사용자 영상 24778.mp4 보관. 가족 미디어는 공개 GitHub에 업로드 금지.

## 영구 요구 및 재개 기준
- 스마트폰 기존 모아와 동일한 달력/사진형/상세형/전체화면/지도 갤러리, 대표 사진, 원본 화질, 스와이프·관성, 확대, 하단 레일, 영상 탐색·음량, 첫/마지막 이동. 원격 연결 성공만으로 완료 금지.
- 원본 화질 문제는 원본 encoded bytes hash, 원본 헤더 해상도, 실제 decoded bitmap 크기, 최종 ImageView 적용 여부를 동일 사진에서 비교. EXIF/회전, 가로세로, 확대, 빠른 사진 전환 시 오래된 결과 차단 및 원본 실패 표시 검증. 작은 poster를 full cache나 성공 결과로 간주 금지.
- R735/737/739/741 누적 최적화(다중 RAM cache, 디스크 cache, 방향/속도 예측, 적응형 선읽기, 원본 범위 묶음, 프레임 손실 기반 부하 조절, 제한된 자동 재시도)는 기존 성공 영상 경로와 함께 보존. 실제 부드러움은 실측 전 보장 금지.
- 자동 허브 재시작/재탐색, 네트워크 단절 복구, 장시간 발열/배터리, 원격 편집·삭제·공유/대표 변경 및 순간기록 완전 동등성, 지도/음성 실제 기능은 완료 판정하지 말 것. 읽기 전용 원격 미디어, 전체 원본 일괄 복제 금지, 인증/권한 유지. 앱 삭제/데이터 초기화 금지.
- MOA_R733_REMOTE_GALLERY_PARITY_GATE_20261126.md 및 MOA_PERMANENT_INAPP_UPDATE_RELEASE_GATE_20261126.md 적용. R707 불변. 사용자 재개 전 추가 APK 배포 금지. 이 문서의 최신 상태가 기존 과거 handoff의 PENDING 표현보다 우선.

## 최종 R747 실제 배포 검증 및 중단 상태 (사용자 정정 이후)
- 배포 CI 45799734923 SUCCESS, 외부 검증 CI 45799820327 SUCCESS. 2026-11-26 19:16:51 KST 기존 exact URL/nonce/immutable HTTP 200 versionCode747, 전체 APK 10773404 bytes SHA256 451e240d713ceacfbcb8ceb4157be7083ddea85e7f3898e49f94dc4b6040eaac 일치. https://github.com/yooogillycloud123/family-journey-personal/blob/moa-update-channel/android/verification/r747-public-endpoint.json
- 최신 실제 배포 R747. R748 exact-R745 recovery 별도 보존. R747 실기기 사진 화질/갤러리 검증 미완료. R707 원본 Golden 불변. 동기화 추가 개발은 R747 배포에서 사용자 요청대로 중단.
