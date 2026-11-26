# R735 — 원본 네이티브 갤러리 원격 읽기 성능 개선 (2026-11-26)

## 기준
- 사용자 24719.mp4 및 원격 갤러리 동등성 Gate: 스마트폰 기존 갤러리 UI, 원본 화질, 스와이프/관성/확대/영상 탐색/음량 유지. 사용자가 성능 개선까지 적용 가능한 인앱 업데이트로 명시 요청. R733 태블릿 실기기 결과는 미확인. R733 실제 서명 APK SHA256 a2b4452d92a6db3cac3d1a746124b897dfe24aa93c140565e00b42e3c3a8206c 기준으로 수정. R707 골든 불변.
- R733의 설치 후 중복 스트림 close 제거, 날짜 포함 음성 ID 호환, 원격 달력 및 QR 연결 경로 그대로 보존. Native Gallery 자체 DEX와 기존 JS 모두 byte-identical.

## 실제 변경 및 검증 범위
- classes24.dex: 기존 R733 MoaRemoteTimeline731.source를 MoaRangeCache735 기반 MediaDataSource로 연결. 기존 핀 TLS Client.get과 서버의 1MiB range contract, 길이 검사, 원본 read-only 유지. 재인코딩/영구 원본 파일 복제 없음.
- 다중 블록 LRU: 소스당 최대 8개 / 전체 캐시 32개 1MiB 블록, 선읽기 최대 3개, prefetch 작업자 2개와 bounded queue 8개. 진행 중 동일 블록 요청 합침. 탐색 시 오래된 대기 prefetch 취소, 이미 실행 중인 요청은 완료 가능하나 다음 stale 요청 발행 금지. 서로 다른 foreground 블록 읽기는 기존 prefetch에 묶이지 않음. 범위 응답 길이 검증 후 캐시 등록, 교차 블록 읽기와 EOF 처리. 소스 release 시 해당 캐시 삭제.
- ProxyFD 읽기 핸들러 최대 4개 분산, 썸네일 요청 작업자 2개 및 bounded queue 24개, 썸네일 캐시 최대 16개 / 15초 TTL, 카탈로그 새로고침 시 초기화. 기존 갤러리의 인접 썸네일 요청 재사용; 별도 인접 영상 원본 사전 로딩 엔진은 미구현. 기존 원격 보관함 간이 플레이어/음성 전용 Source는 별도 유지.
- 읽기/선읽기에서 기존 clientAllowed, 기기 pin/token, mode, 원본 ID/size/t/day/mime 및 owner 검사. 캐시된 데이터도 로컬 접근 조건 재검사. 인증/공유 TLS 및 서버 정책 변경 없음.
- JVM 원본 바이트 비교, read-ahead, 동일 요청 병합, 앞뒤 탐색, 블록 경계, EOF, 실패 후 재시도, 권한 중지, 오래된 요청 취소, 소스 격리/캐시 상한 PASS. 실제 혼합 사진/영상/음성 Row 테스트 PASS. Android SDK/D8/smali integration CI 45775918538 SUCCESS. 실제 기기 Wi-Fi, codec, 4K, HDR, seek/스와이프/재생 성능은 PENDING. 동일 체감/무끊김 보장 금지. 디스크 캐시 및 서버 요청 범위 coalescing(1MiB 초과), 고비트레이트 임시 파일 fallback은 이번 버전에 없음.
- APK R735 SHA256 1a55379b9976f71accd17210e807f8a6062574b1e4435181f7c9506a6127ea86, 10733092 bytes, git blob ba693f27d2468d7582b6137dfc30e9e593839750. R733 대비 AndroidManifest.xml/classes24.dex만 변경, 나머지 178개 entry/25 DEX 동일, 기존 signer 5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15. R736 exact-R733 기능 복구 SHA256 a9e827902fbf925616f59c8755e69743419ad54e47835a6a25ad5f8b86755182 (version manifest만 변경) 자동 배포 제외. 다음 후보 >=737.
- 소스 feature/moa-r735-buffered-native-gallery-20261126, Library /에어팟안드로이드/MOA_R735_R736_20261126/. 배포 gate/실제 CDN 검증 별도 기록.
- 실기기: 양쪽 R735 설치, 기존 허브/QR 등록 유지, 태블릿 원격 달력 갱신 후 같은 날짜/같은 원본을 기존 사진형·상세형 갤러리에서 열고 연속 스와이프, 확대, 영상 탐색, 가로세로, 음량, 장시간 비교. 설치 팝업/원격 목록 상태도 확인. 앱 데이터 초기화 불필요.

## 실제 배포 검증
- CI 45776086245 SUCCESS, latest.json R735 published=true. 외부 검증 CI 45776161640 SUCCESS, 2026-11-26 16:33:14 KST 기존 URL/nonce/immutable HTTP 200 R735, 전체 APK 다운로드 10733092 bytes SHA256 일치. https://github.com/yooogillycloud123/family-journey-personal/blob/moa-update-channel/android/verification/r735-public-endpoint.json
- 실제 사용자 기기 설치·동기화·동일 갤러리 품질 및 성능은 PENDING. 골든 승격 아님.
