> **2026-11-18 RELEASE COMPLETED — THIS SOURCE-ONLY STATUS HAS BEEN SUPERSEDED:** R701 real original-signed code701 APK SHA256 `1a655d25cc81cf97aa6d16c124fb8214c44da55a479fc5d4f5e439bf36e12b6c` and code702 exact-R697-functional recovery APK SHA256 `f57bffc84aa2eee4e5ab07e100afab796e6fadc5058399c543b797518dfeb170` BUILT; Android SDK35 compile PASS, original cert APKv2 RSA/full digest, ZIP and DEX integrity PASS, Galaxy actual install/runtime NOT TESTED. Both APKs and complete QA ZIP saved in private Library `/모아_프로젝트_근거_20261103/R701_ONEUI_SIGNED_R702_R697_RECOVERY_20261118/`. See **[FINAL R701/R702 RELEASE HANDOFF](https://github.com/yooogillycloud123/family-journey-personal/blob/main/MOA_R701_R702_ORIGINAL_SIGNED_ONEUI_RELEASE_HANDOFF_20261118.md)**. Older `NO R701 APK` statements below are outdated and historical. Next version >=703.

# MOA R701 — 삼성 갤러리식 실제 OneUI 음량 통합, 사용자 영상 확인 및 소스 패치 상태 (2026-11-18)

## 사용자 요청과 정확한 원인 (23562.mp4)

사용자는 직접 촬영한 2026-11-18의 `23562.mp4` 화면녹화로, 모아 영상의 **자체 왼쪽 세로 볼륨 레일**과 **삼성 시스템 오른쪽 실제 미디어 볼륨 패널**이 따로 뜨고 서로 상태가 분리된 문제를 보여줌. 특히 00:18경 삼성 Bluetooth/미디어 볼륨 UI가 **100**까지 올라가도 모아 영상 하단 왼쪽 음소거 아이콘이 **계속 음소거**로 남음. 이는 영상 UI를 복제하는 문제가 아니라 `MoaNativeGallery` 내부 `muted`/MediaPlayer-local mute와 Android `AudioManager.STREAM_MUSIC` 사이 상태 동기화 결여다. `23563.jpg`는 별도 어린이 사진으로 볼륨 UI 비교 근거가 아니다.

## 원하는 동작 (R699와 엄격히 구분)

1. Gallery 영상 재생 중에는 OneUI 실제 **미디어 음량 패널만 하나** 표출. 앱이 만든 두 번째 세로 슬라이더 제거.
2. 갤럭시 측면 키로 실제 미디어 볼륨 ↑/↓ 조절. Galaxy 패널은 SystemUI가 담당. 영상이 로컬 음소거인 상태에서 **볼륨↑ 시 MediaPlayer 자체 음소거도 해제**, 아이콘/소리 즉시 일치. 비디오 자체 음소거 상태를 해제하지 못한 채 system volume만 100으로 오르는 현상 금지.
3. 영상 스피커 아이콘 탭하면 단일 실제 시스템 음량 UI가 표시됨. 해당 UI의 위/아래 손가락 드래그로 시스템 볼륨 변경.
4. 다른 곳 터치 시 시스템 UI 자동 닫힘은 **Samsung OneUI SystemUI가 통제**하므로 공개 SDK만으로 임의의 강제-dismiss/완전한 내부 Gallery 동일성을 보장하지 않는다. 기본 시스템 자동 숨김과 외부 터치를 이용.
5. 동영상 종료/다른 사진으로 이동 시 기존 사용자 사운드 선택 상태, 새 날짜 진입 규칙을 유지. 카메라/사진/갤러리 삭제/내비/네이버/달력 기능 보전. 앱 종료 후 다른 앱의 전체 미디어 볼륨을 강제로 0으로 설정하거나 부당하게 증가시키지 않는다.
6. 블루투스 AirPods, 갤럭시 스피커, 차량 오디오 ROUTING/AA 프로젝트는 절대 수정하지 않는다. 갤럭시 오디오 경로별 독립 볼륨 문제는 실제 연결 시 시험한다.

## 정확한 구현 설계

- `Activity.setVolumeControlStream(AudioManager.STREAM_MUSIC)`: 실제 측면 버튼의 제어 대상 지정. Gallery가 닫히면 `Window.getVolumeControlStream()`으로 기억해 둔 이전 값을 복원.
- `AudioManager.adjustStreamVolume(STREAM_MUSIC,ADJUST_SAME,FLAG_SHOW_UI)`: 앱이 새 레일을 그리지 않고 갤럭시 본래 시스템 오디오 패널 요청. 버튼 탭으로 실제 오디오 볼륨을 올려버리면 안 된다.
- 400ms Gallery monitor에서 `AudioManager.getStreamVolume(STREAM_MUSIC)` 증가를 감지. 기존 Gallery `muted=true`이고 비디오 준비 완료면 원본 `toggleMute()`를 한 번 호출하여 **플레이어-local** 음소거를 해제하고 상태를 기억. 원본 토글이 글로벌 볼륨을 바꾼 경우 즉시 이전 시스템 볼륨 복원.
- 원본 Gallery `volumeBubble`을 `GONE`으로 고정. `classes6.dex`의 갤러리 엔진은 직접 수정하지 않음.
- 한계: system stream이 **이미 최댓값**일 때 물리 볼륨↑을 눌러도 numeric 값은 불변이라 단순 변경 감지로는 무음 해제가 보장되지 않을 수 있음. 이 경우 시스템의 KeyEvent dispatch 연결을 추후 별도 QA해야 한다. 외부 볼륨 변경에 따른 오인 해제 여부도 테스트한다.
- 참고 Android 공식 API: https://developer.android.com/reference/android/media/AudioManager , https://developer.android.com/media/platform/output , https://developer.android.com/reference/android/view/Window .

## 현재 작업 상태 (2026-11-18)

- **SOURCE_PATCHED:** 기존 R699 기능(달력 전체 재렌더 억제 + 이전 음량 동기화) 위에 R701 Galaxy single-panel 구현 **별도 개발 브랜치**에 반영.
- GitHub branch: `feature/moa-r701-oneui-system-volume-single-panel-20261118`, code source path `experiments/moa-r697/MoaR391SessionPersistProvider.java`. `.github/workflows/moa-r699-video-calendar-compile.yml`을 R701 브랜치 컴파일 트리거로 변경했으나 **이 핸드오프 작성 당시 CI 실제 결과/artifact 미확인**. CI 성공이나 Android 컴파일 성공이라고 과장하지 말 것.
- 로컬 소스 정적 QA 10개 PASS, 원본 `classes6.dex`·캘린더 변경 없이 유지하도록 설계. 로컬 source-only ZIP `MOA_R701_ONEUI_SINGLE_VOLUME_SOURCE_ONLY_20261118.zip` SHA256 `86463311a54e5c1c39003cf0ee51bf7abd7d991a84e5c833bf19323e6231a23d`.
- **NO R701 APK**: 앱 설치용 원본 서명 업데이트 APK, versionCode 701, Android SDK D8 컴파일, APK v2 검사, Galaxy 물리 테스트, 상위 버전Code 702 정확 R697 기능 복구본은 아직 완료되지 않음. R699 원본 서명 BETA는 기존 동작이며 이 R701 단일패널 기능이 없음.
- 버전 관리: 후보 R701>=701 (사용자가 R700 복구 APK 설치했을 가능성을 감안), 복구본 R702 (정확 R697 original payload, Manifest code702만 수정), 이후 새 업데이트는 code>=703. 둘 다 원본 서명키: 개인 Library `/모아_프로젝트_근거_20261103/PRIVATE_SIGNERS/MOA_R39_SIGNING_BACKUP_PRIVATE_KEEP.zip`, 비공개 레지스트리 같은 폴더. **키는 있는 것이 확인되어 있고 비밀번호 재요청 금지**. 기존 서명 SHA256 `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`.
- 정상 사용자 실기기 기준 R697 SHA256 `67a8892c661e38ea9ec4227baa6ecb053bfe612ef874594e6fdf1b250820328e`, R683 Golden도 고정. 사용자 실기기 PASS로 인정된 새 버전은 없음.

## 실기기 테스트 매트릭스

- ① 처음 음소거 영상 재생, 실제 측면 볼륨↑ 1회 → 즉시 음소거 해제+소리+아이콘 일치
- ② Samsung 시스템 미디어 패널 손가락 위/아래 이동 → 실제 볼륨 및 소리 일치, 왼쪽 MOA 레일 없어야 함
- ③ 기기 볼륨 0/중간/최대에서 반복 ON/OFF, 글로벌 볼륨 몰래 증가/강제0 금지, 하드웨어 키 이벤트 상한/하한
- ④ 스피커 아이콘 탭 → 삼성 SystemUI 단일 볼륨 패널 확인; 외부 터치 시 시스템 수준 자동 닫힘 관찰
- ⑤ 연속 영상 A→B, 사진 섞인 영화 스트립, 인라인/확장 갤러리, 새 날짜 진입 시 음소거 유지 규칙
- ⑥ Galaxy 스피커/블루투스 헤드셋/차량 출력, 카메라 재진입, 달력 커버 재사용 R699, 네이버/삭제/데이터보전/앱 재시작 회귀
- ⑦ 문제 시 앱 삭제 또는 저장소 초기화 없이 정확 R697 기능 code702 forward recovery (아직 빌드 전)만 제공.

## 새 채팅 최우선

이 문서를 모아 R699/R700 원본서명 핸드오프 바로 뒤에 읽는다. 사용자가 분명히 말한 것은 **볼륨값 동기화(R699)**가 아니라 **실제 Samsung 시스템 볼륨 패널 통일 + 물리 볼륨↑으로 앱 영상 mute까지 해제(R701)**다. 이전 구현을 완성이라고 오인하지 말 것. 사용자 요청 범위 이외 앱 기능/AA 오디오 정책 수정 금지.
