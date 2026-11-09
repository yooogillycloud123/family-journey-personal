# MOA R227 사용자 지정 골든 잠금 (2026-11-09)

**정확한 상태:** 사용자의 명시적 요청으로 R227 전체 파일을 **변경 금지 개발·복원 기준본**으로 등록했다. R227 서명·바이너리 무결성·CI는 통과했지만, **네이버 앱 내부 뒤로가기 한 번, 같은 사진 복귀, 실제 GPS 읽기, 영상 전체 필름스트립의 R227 갤럭시 현장 PASS는 별도 미확인**이다. '골든 보존'이 모든 실기기 검증을 의미하지 않음.

- Package: `com.juhyeon.familyjournea` / versionCode **227**
- Frozen exact APK `MOA_R227_USER_DESIGNATED_GOLDEN_DO_NOT_MODIFY.apk`: **5,769,220 bytes** / SHA-256 **`53c4c04ce32ad13de3c0613f4e5ec7abbc75ccbdfe9db5da05d8fa9b806ec6cd`**
- Original signer certificate SHA-256: `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`
- Original release ZIP `MOA_R227_ORIGINAL_RELEASE_BACKUP_DO_NOT_MODIFY.zip`: **5,419,383 bytes** / SHA-256 **`adf45a5b72ce58b0e7e0d3048846670740449d46fbe8ddf1ad36e7cb3b7eccae`**, contains exact APK, ZIP CRC PASS
- Frozen APK members: **130** with each member SHA256/CRC in `MOA_R227_GOLDEN_LOCK_MANIFEST_20261109.json`.
- R225 대비 완전 동일 **128/130**; 바뀐 두 멤버: `AndroidManifest.xml`, `classes6.dex`.
- Android 35 CI: `42573910075` SUCCESS. 릴리스 당시 서명·v2/전체 digest·DEX/CRC 검증 PASS.
- GitHub source-only freeze branch: `golden/moa-r227-20261109-user-designated-preserve-device-qa-open` at `801592a0621a4b90caf313b6c4b0a16837ec136d`.
- Private archive folder: `/모아_프로젝트_근거_20261103/GOLDEN_R227_20261109/`.
- Earlier immutables R219(수락 범위 제한), R209, R203, R187 **모두 별도로 보호**.

## 새 채팅 필수 순서
1. `AA_AirPods_FINAL_READ_FIRST_v1.0_20261005.md` (project top canonical; AA 소스 수정 금지)
2. `MOA_READ_FIRST_NEW_CHAT_R227_20261109.md`
3. `MOA_R227_MASTER_HANDOFF_FOR_NEW_CHAT_20261109.md` — 오류 이력과 기능별 재발 방지 체크리스트 전부
4. `MOA_WIP_CHECKPOINT_CURRENT.md`, `MOA_RELEASE_LEDGER_CURRENT.md`, `MOA_R227_GALLERY_BACK_SAME_PHOTO_NAVER_DIRECT_EXIF_FULL_VIDEO_HANDOFF_20261109.md`
5. Library의 원본 APK/ZIP/130-entry 매니페스트 확인, 최신 새 유효 산출물이 있는지 확인하고 연속 작업.

## 새 작업 방침
- 이 골든 파일·브랜치 **직접 수정 금지**. 별도 브랜치 + 더 높은 versionCode + 원래 서명·패키지로만 후속 빌드.
- 원래 성공 기능 보호: 큰 사진 한 장 스와이프, 필름스트립만 관성(상단 동기), 선택 영상 필름 확장, GPS/시각/네이버 링크, 갤러리 사진 복귀, 지도 팝업 OFF, 캡처/뮤트/세로 볼륨, 음성재생 Back 시 중지, 음성기록 중지, 8방향 바로기록 팝업, 기록·M4A·데이터 저장.
- APK를 만들었다는 사실과 사용자가 다운로드 링크를 열 수 있다는 것은 별개. 정확한 파일 경로·SHA 확인, **APK + 바이트 동일 APK가 들어 있는 ZIP** 함께 제공.
- 실기기 기능 PASS를 주장하려면 실제 기기 증거가 있어야 한다. AA AirPods/Android Auto 데몬이나 오디오 코드 변경 금지.
