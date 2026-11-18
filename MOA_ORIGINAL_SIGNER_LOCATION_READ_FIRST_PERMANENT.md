# MOA 원본 서명키 영구 위치 확인 지침 — 최우선, 새 채팅 필독 (2026-11-18)

## 0. 절대 오판 금지

**"새 세션 /mnt/data 에 키가 없으므로 모아 원본 서명키가 없다"라는 판단을 절대 하지 말 것.**
2026-11-03 비공개 개인 Library에서 실제 원본 서명키가 복구되고, R42 APK 서명과 키-인증서 일치 검증이 PASS였다. 2026-11-18 새 채팅에서 사용자가 원본 서명키가 보관되어 있다고 재강조했고, 실제 Library 목록에서 ZIP 및 비공개 등록문서 파일의 존재를 다시 확인했다. 키를 매번 사용자에게 재요청하지 말 것.

## 1. Files/Library에서 먼저 반드시 확인할 정확한 경로

- 백업 ZIP: `/모아_프로젝트_근거_20261103/PRIVATE_SIGNERS/MOA_R39_SIGNING_BACKUP_PRIVATE_KEEP.zip`
- 비공개 암호/복구 레지스트리: `/모아_프로젝트_근거_20261103/PRIVATE_SIGNERS/MOA_PRIVATE_SIGNER_REGISTRY_DO_NOT_PUBLISH.md`
- 공개 해시/검증 이력: `MOA_RELEASE_SIGNATURE_LEDGER_20261103.json` (개인 Library), `MOA_R53_NEW_CHAT_CHECKPOINT_20261103.md` (개인 Library)
- 원본 서명키 ZIP의 저장소는 GitHub가 아니라 **개인 Library**. 설치환경에 파일이 없다면 먼저 `files.search`/`files.list`로 위 개인 Library 경로를 찾아 `files.materialize`로 해당 원본 파일을 안전한 로컬 실행 공간에 복사한다. 암호는 비공개 레지스트리에서만 읽어 처리한다. 원본 비밀키, 비밀번호, PEM, PKCS#12를 공개 저장소·답변·CI 로그·공개 ZIP에 기재하거나 업로드하지 않는다.

## 2. 원본 앱 서명 검증 고정값

- 동일 패키지: `com.juhyeon.familyjournea`
- 원본 APK v2 인증서 SHA-256: `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`
- 2026-11-03 R39 백업 ZIP SHA-256: `3fc12c31c2f91a350d9a77d2c104b815ebbdc73b11e50b2c1de01458de86ea27`
- 당시 ZIP CRC, PKCS#12 복호화, 개인키 존재, 개인키↔인증서 SPKI 일치, R42 APK v2 인증서 일치 **PASS**. 다시 재료를 로딩한 뒤에 현재 파일 SHA-256과 실제 키/인증서 일치 여부를 재검증한다.
- **R49와 R50/R51 백업은 인증서가 다른 별도 키임. R697 계열의 업데이트 서명으로 사용하지 않는다.**

## 3. 모든 새 채팅과 APK 릴리스 첫 절차

1. 최상위 `yooogillycloud123/workexcel-devbridge/main/AA_AirPods_FINAL_READ_FIRST_v1.0_20261005.md` 읽기 (AirPods 코드는 MOA 작업과 무관하므로 변경 금지).
2. `yooogillycloud123/family-journey-personal/main/MOA_READ_FIRST_NEW_CHAT.md` 읽기.
3. **이 문서**와 개인 Library의 비공개 등록문서/백업 ZIP을 먼저 검색·확인·복원. 개인 Library의 실제 현재 항목을 확인하기 전에는 "서명키 없음/재요청 필요"라 답하지 말 것.
4. 최신 사용자 실기기 정상 기준 R697 및 불변 골든 R683을 실제 GitHub/Library에서 확인한다. R697 SHA-256 `67a8892c661e38ea9ec4227baa6ecb053bfe612ef874594e6fdf1b250820328e`; R683 SHA-256 `e20e446d5e02358e833fe223471735abc3fd042234b4efc53acc208118ee9e8b`.
5. 기존 소스·산출물 재사용, 최신 작업 브랜치 확인. 버전 코드 상향, 동일 패키지/원본서명, APK v2 전체 digest/CRC/DEX/Manifest/zipalign, 실제 원본 기능 보전 비교 및 **후보보다 높은 버전의 R697 정확 기능 복구 APK** 준비.
6. 실기기에서 사용자가 성공했다고 확인한 범위 외에는 Golden/실기기 PASS를 선언하지 않는다. 앱 삭제·데이터 초기화·원본 미디어 삭제 금지.

## 4. 2026-11-18 R699 대응

사용자가 요구한 Galaxy 측면 음량/모아 음소거 동기화, 사진 추가 후 달력 전체 버퍼링·재렌더 억제 소스 수정은 `feature/moa-r699-system-volume-calendar-incremental-20261118` 브랜치. 이전 응답의 "원본 서명키가 없어 APK를 못 만든다"는 주장은 Library 확인을 누락한 잘못된 판단이다. **원본 키는 개인 Library에 존재한다.** 다만 R699 **서명 APK가 제작·실기기 검증 완료되었다는 뜻은 아님**. 실제 최신 산출물 확인 후 기존 R697에서 안전하게 후속 처리한다.
