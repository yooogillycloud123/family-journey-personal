# MOA R703 진행 결과 — R701 삼성 음량 유지 + 볼륨 0 아이콘 소스 컴파일 성공 / 지도·APK 미완료 (2026-11-20)

## 사용자 최종 요청

2026-11-20 사용자: "진행해서 apk까지 가져와". 요구사항은 **두 기능을 함께 넣은 설치형 APK**:
1. **R701 사용자 실제 정상 작동 확인한** Galaxy 실제 미디어/OneUI 음량 동기화 보존. 단 실제 STREAM_MUSIC=0이 되면 갤러리 스피커 버튼이 소리 재생 중(음소거 아님)처럼 보이는 혼란을 제거. 실제 MediaPlayer의 `muted`는 변경하지 않으면서 **effectiveSilent = localMuted || actualMusicStreamVolume==0**으로 아이콘 표시만 바꾼다. 볼륨을 1 이상 올리면 원래 Native Gallery 소리 아이콘 복원. 앱이 시스템 전체 미디어 볼륨을 임의 수정하면 안 된다.
2. 사진 촬영·추가 / 앱 복귀 / '나의 지도' 탭 열기에 맞춰 새로운 **GPS 사진만** 자동 인덱스+지도 집계 갱신 (해외 좌표 포함). 이미 달력/일기에 자동 반영한 데이터 흐름을 재사용. 수동 **'사진 다시 읽기'는 복구용**. MediaStore 전체 0회 스캔으로 만드는 것 아님, 전체 앱/달력/지도 재시작 또는 전 사진 재분석 금지.

## 현재 source 수정 실적 (확실하게 PASS)

- GitHub branch `feature/moa-r703-volume-zero-icon-map-auto-20261120` from R701 source, commit `10c53573c969fe7c93d014bf3926dede31916c3e`
- 수정 파일: `experiments/moa-r697/MoaR391SessionPersistProvider.java`, 신규 `r703ReconcileEffectiveMuteGlyph(Activity,GalleryActions,Object,Class<?>,boolean)`.
- 이 코드는 원본 Native Gallery에서 실제 묵음/재생 버튼 `getText()`, `getContentDescription()`을 학습하여 시스템 음량 0에서만 **원본 묵음 그림 문자**를 UI에 표시, 다시 음량>0에서 원본 소리 표시를 복원. 하드코딩 아이콘 문자열 지양. Native player `toggleMute`를 0에서 부르거나 시스템 MediaStream 볼륨을 0으로 재설정하는 일 없음.
- 기존 R701의 `r701ApplyGalaxyVolumeUnified`, `r701OpenGalaxySystemVolume`, `r701HideNativeVolumeBubble`, R699 날짜별 증분 달력 소스 유지. 기존 R697 `classes6.dex` Gallery 엔진 직접 수정 없음.
- Android SDK35 Android java17 `javac --release 8` / D8 `classes17.dex` compile workflow **PASS** https://github.com/yooogillycloud123/family-journey-personal/actions/runs/44729680362
- 컴파일 DEX와 검사 JSON artifact `MOA-R703-MUTE-ICON-DEX17-SOURCE-QA-ONLY` available in that workflow. Neither an APK nor runtime proof.

## BLOCKER 및 주장 금지

- **APP MAP JS UNIMPLEMENTED**: 정확한 사용자 R701 실물 APK 속 `assets/web/app.js`, `assets/web/native.js`, `assets/web/family-diary.js`를 아직 추출/분석하지 못함. Github tracked R701 branch includes native provider + calendar scripts but **not** these bundled minified/extracted map assets. 가족 지도 데이터 흐름을 추정으로 고쳐서는 안 됨. 매핑 데이터/IndexedDB/MediaStore 기존 사용자 데이터 깨뜨리지 말 것.
- **SIGNED R703/R704 APK NOT BUILT**. 2026-11-20 이 채팅에서도 **container.exec, python.exec, python_user_visible.exec**가 `ClientError`를 반환 (간단한 shell echo 및 print조차 실패). Files materialize / GitHub connector는 정상. 최신 R701 installable APK, 원본 signing ZIP/비공개 registry는 개인 Library에서 발견했고 `files.materialize`를 통해 `/mnt/data/moa_r703_input/` 아래까지 다시 복사했으나, 실행할 도구가 고장나 있어 APK ZIP extraction, JS 수정, zipalign/v2 signing/crypto verification을 할 수 없는 상태.
- 이는 **서명키가 없어** 생긴 문제가 아니다. 원본 private signer는 Library `/모아_프로젝트_근거_20261103/PRIVATE_SIGNERS/MOA_R39_SIGNING_BACKUP_PRIVATE_KEEP.zip` / `MOA_PRIVATE_SIGNER_REGISTRY_DO_NOT_PUBLISH.md`. 키나 비밀번호 공개 GitHub/CI에 넣거나 사용자에게 재요구 금지.
- Github actions 컴파일 성공이 **원본서명 설치형 APK 완성**이라는 뜻은 절대로 아님. Github public repo의 debug APK는 사용자의 설치된 모아 패키지를 업데이트할 수 없는 다른 signer. 사용자가 앱 제거하거나 데이터 초기화하도록 지시 금지.

## 원본 바이너리와 실제 위치

- R701 user-reported Galaxy volume pass `MOA_R701_ONEUI_SINGLE_SYSTEM_VOLUME_ORIGINAL_SIGNED_BETA.apk`, versionCode 701, SHA256 `1a655d25cc81cf97aa6d16c124fb8214c44da55a479fc5d4f5e439bf36e12b6c`.
- R702 `MOA_R702_EXACT_R697_FUNCTIONAL_FORWARD_RECOVERY_ORIGINAL_SIGNED.apk`, versionCode 702, SHA256 `f57bffc84aa2eee4e5ab07e100afab796e6fadc5058399c543b797518dfeb170`. NOTE: R702 복구 시 R701 음량 개선도 되돌려지므로 R703 이슈 복구본은 **R701 정확 기능 유지 + code704**로 제작이 맞음.
- 원본 APK/QA `/모아_프로젝트_근거_20261103/R701_ONEUI_SIGNED_R702_R697_RECOVERY_20261118/`, signer ZIP / registry `/모아_프로젝트_근거_20261103/PRIVATE_SIGNERS/`. 원본 cert SHA-256 `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`.
- R697 original user-confirmed Golden remains safe. R701 later volume feature user-confirmed working for volume synchronization; do NOT regress it.

## Build once execution available

1. 원본 R701 APK와 source/QA hash 검증 (원본 signer unchanged), 원본 R39 signer ZIP CRC+PKCS12 match current APK cert, never paste password into logs.
2. R701 `assets/web/app.js`, `native.js`, `family-diary.js` 실제 추출, 상태 변경 이벤트/MediaStore incremental detection/map loaded cache/coordinate idempotency 검증. 수정은 사진 단위 변경 통지와 지도 탭 활성 시 보이는 지역·국가 집계 갱신만, 전체 사진/모든 지도 재분석 금지.
3. 지금 compile-PASS 된 R703 volume source를 정확 R701 기능 소스에서 빌드, 맵 실물 asset만 최소 변경, code>=703, 원본 동일 package/sign certificate v2 sign, APK ZIP/DEX checks; R704는 **정확 원본 R701 기능**과 manifest-only code704 복구, 별도로 서명.
4. 앱 삭제하지 않는 업데이트 설치, 갤럭시 스트림0/볼륨증가/사운드, 신규 GPS 해외사진 추가 후 나의 지도 auto region 표시, 기존 다중선택/편집/저장/네이버/camera/달력 생존 QA. 정적 CI PASS와 사용자 Galaxy 실기기 PASS 구분.
5. 최종 APK 2개+QA ZIP을 private Library, GitHub checkpoint에 기록하고 사용자에게 유효 링크 직접 제공. 지금은 **미완료**.

이 문서는 **실제 결과와 차단 요인**을 반영한 인계이며, 소스만 내고 완료를 주장하는 문서가 아님.
