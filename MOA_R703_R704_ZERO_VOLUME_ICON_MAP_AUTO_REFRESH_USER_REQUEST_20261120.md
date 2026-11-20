> **2026-11-20 20:xx KST SOURCE PROGRESS — R703 ZERO-VOLUME ICON COMPILED SUCCESS, MAP/APK STILL PENDING:** New branch `feature/moa-r703-r701-zero-volume-icon-map-autorefresh-20261120` created directly from R701. R703 `experiments/moa-r697/MoaR391SessionPersistProvider.java` now contains `r703SyncEffectiveSilenceGlyph` to show the existing custom Samsung-like speaker UI as muted when `playerMuted || AudioManager.STREAM_MUSIC == 0`, restore visual on positive system volume, preserve original `toggleMute()`/MediaPlayer/system volume and R701 speaker click. Original gallery core DEX6 untouched in source. Android SDK35 Java17 + D8 compile plus DEX/checksum checks **PASS**, GitHub Actions run [44731887713](https://github.com/yooogillycloud123/family-journey-personal/actions/runs/44731887713), artifact `MOA-R703-GLYPH-DEX17-ANDROID-SDK35-QA` id 14626547028. **R701 bundled Map app.js/native.js/family-diary.js still cannot be opened because container.exec/python.exec/python_user_visible.exec all return ClientError** despite original APK and private signer being present in Library; cannot safely modify actual map code or re-sign APK. Therefore no R703 or R704 installable APK, no complete dual-feature release and no physical QA claim. User explicitly demands APK; do not present compiled DEX as installation. Only actual unchanged R701 signed APK and R702 exact R697 recovery remain in Library. If runtime recovers, extract R701 APK assets and finish map; package R703 original signed & higher exact R701 R704 recovery + integrity checks. No uninstalls and no data resets.

# MOA R703/R704 — 사용자 R701 실기기 음량 성공 + 0 아이콘 오류 + '나의 지도' 사진 자동갱신 (2026-11-20)

## 사용자 발언 및 증거 (새 채팅 반드시 우선)

- 사용자 본인의 직접 실기기 평가: **"701에서 음량 동기화 잘했는"**. 이는 R701의 갤럭시 미디어 음량 버튼/영상 재생 값 연동이 실제로 성공했다는 의미이며, 재작성/롤백하지 말아야 함.
- 남은 문제: **갤럭시 볼륨을 최소(0)로 내리면 실제 소리는 0이지만 모아 갤러리 스피커 아이콘이 소리 재생 상태**. 사용자에게 혼란 유발. 실제 음량이 0일 때는 음소거 아이콘, 0 초과로 올리면 실제 상태에 맞춰 소리 나는 아이콘이 자동 복귀해야 함.
- 선행 사용자 스크린샷 23865/23867/23869/23871/23873: '나의 지도' 탭은 일기·달력과 달리 새 사진/GPS를 자동 반영하지 않고 '사진 다시 읽기' 수동 클릭이 필요. 사용자 요청: **촬영→모아 재진입/실행 중 사진 추가→일기·달력 및 '나의 지도' 둘 다 자동 반영**, 지도 탭 재진입 때도 자동 갱신. 사용자가 매번 수동 재읽기하지 않도록. '사진 다시 읽기'는 오류 복구용 수동 수단으로 유지.
- 사용자 요구: **소스/계획만 내지 말고 실제 업데이트 설치 가능한 APK + 상위 복구 APK로 완성**. 원본 데이터/갤러리 기능 전부 보존. 앞서 assistant 응답이 끊어져 사용자가 재촉; 작업 상태를 명확히 밝힐 것.

## R701 소스에서 확인한 원인

- 실제 Java 소스 `experiments/moa-r697/MoaR391SessionPersistProvider.java` (branch `feature/moa-r701-oneui-system-volume-single-panel-20261118`)의 `r689SyncGalleryVideoUX`는 원본 `MoaNativeGallery.muted` boolean을 읽어 `r701ApplyGalaxyVolumeUnified`의 숫자값 상승 시 unmute만 처리. **STREAM_MUSIC=0일 때 원본 갤러리 Button에 보여지는 음소거 glyph/contentDescription을 맞추는 로직 없음**.
- Android `AudioManager.getStreamVolume(AudioManager.STREAM_MUSIC)`가 0이면 사용자에게 소리가 나지 않는 상태. **로컬 MediaPlayer muted와 별도의 '실효 음소거' UI**: `effectiveSilent = localMuted || streamMusicVolume == 0`. 0 값에서 **절대로 원본 toggleMute를 호출하거나 시스템 전체 볼륨을 강제로 낮추지 말 것**. 음량 다시 올리면 실효 아이콘 즉시 복원, 본래 localMuted 상태/사용자 사운드 선택, 기존 R701의 VOL+ unmute 기능 보존.
- 원본 Gallery `classes6.dex` 유지. 현재 R701 `mute`는 Android `Button`; 정확한 glyph 구현은 **원본 APK 안의 classes6.dex 리소스/실제 버튼 텍스트/Drawable을 확인하고 동일 방식으로 반영**. 무조건 `setText("🔇")` 하는 것은 원본 비주얼을 깰 수 있음.
- 지도: 다른 채팅 스크린샷에서는 `family-diary.js`가 사진을 감지, `native.js`가 GPS 추출/지도 데이터 연결, `app.js` '나의 지도' 탭이 `renderHome()`만 호출한다는 설계 제안이 있었다. 이 분석은 **직접 R701 현재 assets/web/*.js를 재확인하기 전에는 확정된 실제 원인으로 단정하지 않는다**. 지도 코드가 GitHub main 추적 소스에 없는 것으로 확인, **Library의 실물 R701 APK에서 assets/web/app.js, assets/web/native.js, assets/web/family-diary.js를 추출**해 정확한 데이터 유입 및 지도 초기화·캐시·리렌더 경계를 검증해야 함. 새 사진의 GPS/EXIF 메타데이터만 증분 반영, 이미 인덱싱한 전체 사진 재분석/전체 맵 강제 리로드/전체 앱 재시작 금지. 기존 해외 국가/지역 집계 및 내부 지도 idempotency도 검사. 날짜/캘린더 동작 보존.

## 바이너리·서명 기준 / 절대 유지

- 패키지 `com.juhyeon.familyjournea`
- 사용자가 실제 작동 확인한 최신 R701 파일 `MOA_R701_ONEUI_SINGLE_SYSTEM_VOLUME_ORIGINAL_SIGNED_BETA.apk`, SHA256 `1a655d25cc81cf97aa6d16c124fb8214c44da55a479fc5d4f5e439bf36e12b6c`; GitHub [R701 release handoff](MOA_R701_R702_ORIGINAL_SIGNED_ONEUI_RELEASE_HANDOFF_20261118.md).
- R701 APK와 R702 정확 R697 기능 복구 APK, 검증 ZIP: **개인 Library** `/모아_프로젝트_근거_20261103/R701_ONEUI_SIGNED_R702_R697_RECOVERY_20261118/`.
- 원본 R39 서명키는 개인 Library `/모아_프로젝트_근거_20261103/PRIVATE_SIGNERS/MOA_R39_SIGNING_BACKUP_PRIVATE_KEEP.zip`, 비밀번호는 같은 개인 Library `MOA_PRIVATE_SIGNER_REGISTRY_DO_NOT_PUBLISH.md`. SHA cert `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`. **사용자 재요청/공개 GitHub 또는 CI에 암호·키 노출 금지.**
- 신규 후보는 versionCode **703 이상**, 문제 시 한 단계 더 높은 versionCode **704 이상**의 **정확 R701 기능 복구용** APK가 가장 적절. 역사적 R697 Golden/당시 복구본도 별도로 보호. APK v2 signature + signer fingerprint, DEX ZIP, asset diff, manifest, original data, GPS and gallery regression validation.
- 원본 사진 삭제/MediaStore 원본 수정·앱 제거·데이터 초기화 금지. AA AirPods/Android Auto 코드·오디오 정책 변경 금지.
- 백그라운드 GPS MediaStore 스캔을 전면 차단하면 새 사진 감지가 망가짐; 중복 처리만 줄이고 새 사진 빠르게 반영.

## 실제 이번 채팅 작업 진행 상황 (사실만)

- 2026-11-20 canonical GitHub 지침과 R701 Java source, Library R701/R702 패키지 이름 및 경로 읽음. 원인 파악 및 요구사항 위와 같이 기록.
- **BLOCKER: 실제 code execution 환경의 container.exec, python.exec, python_user_visible.exec 전부 ClientError** (단순 echo, print도 불가). 원본 APK/ZIP 추출, Android DEX patch/컴파일 결과 수령, PKCS12 개인키 로컬 서명, APK v2 검증, QA ZIP 생성이 **불가능한 상태**. 이것은 서명키가 없어서가 아님; 비공개 키는 Library에 있다.
- GitHub와 Files metadata tools만 정상. 따라서 **R703 서명 APK 또는 R704 복구 APK가 생성됐다고 주장 금지**. GitHub 소스 개정/정적 분석과 앱 설치 가능성은 다르다. 사용자가 요구한 최종 업데이트 상태는 아직 PENDING.
- 가동 환경이 정상화되면 **R701 원본 패키지를 기준으로**, 두 기능을 실제 소스에서 수정→Android DEX 컴파일→개인 Library 서명키 로컬 사용→v2 서명·실제 Android 패키지 검증→R703 설치형 APK + 정확 R701 기능 R704 복구 APK→개인 Library 백업→사용자 전달. 백그라운드 작업 예약이나 미래 완료 약속이 아니라, 다음 실제 실행 가능 세션이 최신 위치에서 곧바로 재개할 수 있는 인계사항임.
