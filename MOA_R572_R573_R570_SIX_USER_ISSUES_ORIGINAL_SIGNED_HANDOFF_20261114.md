# MOA R572 — R570 사용자 실기기 6개 문제 수정 + R573 R567-정확 복구, 동일 서명 APK
**작성일:** 2026-11-14 KST  
**상태:** 원본 서명 APKv2/ZIP/DEX/Java35 CI/JS mock PASS. **R572 새 실기기 검증 전 BETA**. 현재 승인 **Golden = R567**, 절대 수정 금지.

## 0. 사용자 실기기 최신 증거
- 사용자 사진 `21905.png`, `21907.png`, `21912.png`와 34.07초 영상 `21909.mp4` (개인 첨부, 공개 GitHub 미업로드).
- 사용자 확인: R570에서 사진형 하단 아이콘 크기 불균형, 사진 썸네일과 아래 바 사이 빈 공간, 비점유 네이버 저장 white pill 진행 안내 잔존, 연속 넘김 ON 재진입 시 OFF 초기화, 사진 진입 검게 번쩍임과 영상 회색 전환 흔들림, 하단 아이콘을 사진과 구분해 하단 배치 요구.
- **문제는 R570 물리 결과이며, R567은 이전 사용자 실기기 성공 승인 Golden으로 고정 보존**. 새 실험은 별도 `feature/moa-r572-r570-compact-dock-rail-flash-fast-toast-20261114` 브랜치에서만 진행.

## 1. 각각의 확인된 소스 위치·수정
1. `MoaR507InlineGalleryProvider.UnifiedGlyph.onDraw` 및 `compactNativeCard/r570InitActionOrder`: 대표사진/추가저장/썸네일/전체화면 신규 Canvas 그림 및 원본 네 버튼의 그림 기준 차이. **모든 시각적 아이콘 그림을 대략 14–16dp로 축소·정렬**, 원래 34dp 터치 영역·OnClickListener와 ID 매핑·순서변경 데이터 유지.
2. `setRailExpanded` / `nativeLower`: 사진에서도 영상용 `lowerControls.height=137dp`를 남긴 것이 하단 빈 여백의 한 원인. **사진형 펼침만 137→112dp**로 수정, 영상 137dp 및 서브 제어기 unchanged; 64dp Native Rail 자체/선택 썸네일 8dp 들림/원본 Rail OverScroller 변경 없음. 사진↔영상 전환 시 공간 재평가.
3. `assets/web/moa-r570-photo-favorites.js` `status()`: DOM `.moa-r570-save-status` 생성 후 clear/removal 없음. **새 메시지마다 3.8초 타이머 재설정, fade 약 0.18초, node.remove()**. 기존 Naver writer/callback/state truth unchanged. 안내 제거는 원격 계정 저장 완료 판정이 아님.
4. `r463 GalleryActions.fastAction`: 원래 R463 버튼은 ON/OFF 자체를 정상 전환했으나 **재진입 저장 경로가 없음**. 사진형 전용 SharedPreferences `moa.r572.photo.fast:fast_enabled`, 기존 selected 확인 후 저장; 새 사진형 host 최초 mount에서 **원본 fastAction.performClick()으로만** ON 복원. 원본 StageScrub/영상/핀치/Advanced gallery 노변경, 최초 기본 OFF.
5. 사진 `attachCard()`가 `__moaR507NativeMounted(true)`를 원본 ImageView drawable 준비 전 보내면서 웹 사진 포스터를 숨겨 첫 네이티브 검정표면을 보여줄 수 있음. **사진형 최초 native drawable 준비까지 Web poster를 유지하고 최장 950ms 대기/Fail-open**, 다른 사진 스와이프/Back/외부 앱 복구 코드 보존. 영상의 R570 `ambientPoster #28272c` 및 `TextureView.setOpaque(false)`, Web legacy `.moa-r531-video-slide::before` blur background를 검정 + 불투명 TextureView/blur OFF로 변경. **삼성 Surface 첫 프레임의 완전무결한 물리 해결은 기기 QA 필요**.
6. R570 action capsule만 사진 위에 보이던 UI: native `actionDeck` 최하단 **40dp를 별도 dark dock**으로 표시하고 미디어/버튼의 경계를 명확히 함. **사용자 터치가 사라지는 host 바깥 재부모화/음수 마진/원본 compositor size 변경 없음**. 고급 전체화면 갤러리에는 적용하지 않음.

## 2. 원본 서명 설치/복구 바이너리
- 설치 APK: `MOA_R572_COMPACT_DOCK_RAIL_FLASH_FAST_TOAST_ORIGINAL_SIGNED_BETA.apk`, versionCode **572**, 9,084,761 bytes, SHA256 **`a5eeff113022894afa2f72fb4d149e8ee4c1269dabf8c78d16fca28e5ece10ab`**.
- 비상 복구: `MOA_R573_EXACT_R567_GOLDEN_FORWARD_RECOVERY_ORIGINAL_SIGNED.apk`, versionCode **573**, 9,069,599 bytes, SHA256 **`33217fc379284d028407d8cda85c3666a3782eb834c5d169c92c08162c6af951`**. R567 **Manifest versionCode 외 정확한 동일 기능**.
- 원본 승인 Golden R567: code567 SHA256 **`f205afb72744391ce9f2594f898728699870be006f787c712599a1ee8492e93c`** 바이트 그대로 영구 보존.
- 원본 사용 R570: code570 SHA256 `93ba81abe4d3d44e782bff361598bd070b73de2fe73754c58312a85f0ce01cf5`.
- 모두 `com.juhyeon.familyjournea`, original signing certificate SHA256 **`5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`**.
- 공유 원본 키 없는 통합 ZIP: `MOA_R572_R573_SAME_SIGNER_INSTALL_RECOVERY_SOURCE_QA_20261114.zip` **26,343,296 bytes**, SHA256 **`4e6f5a8e6b53199ad11e6d409d9cab1ac9496c432ff4d308159054f212878858`**. R572/R573 APK, R567 골든 읽기 전용, R570 비교 읽기 전용, 수정 소스+CI dex, exact source diff, keyless APK v2 verifier, JS tests, SHA256SUMS 및 한국어 README 포함. 모든 ZIP CRC/해시 PASS. 비밀 원본 서명키/암호/PKCS12 절대 포함하지 않음.
- 기존 원본 서명키는 **사용자의 개인 Library PRIVATE_SIGNERS**에서 정상 복원해 원본 cert와 key SPKI 매칭 후 **오프라인에서만** 사용; 키, 암호, keystore 절대 공개 저장소/배포 ZIP 업로드 금지.

## 3. 검증된 보호 범위
- **R570→R572:** 총 144 APK 멤버 중 **139개 바이트 동일**, 오직 `AndroidManifest.xml`, `classes18.dex` (독립 사진형 provider), `assets/web/moa-r483-vertical-calendar.js`, `.css`, `assets/web/moa-r570-photo-favorites.js` 5개만 변경. 기존 원본 (R463/R567) `classes.dex`~`classes17.dex` **17/17 바이트 동일**. 원래 `fj-naver-favorites.js`, `family-diary.js`, 음성, 기록, 사진·지도 원본 엔진 바이트 보호.
- **R567→R573:** 143개 중 **142개 바이트 동일**, AndroidManifest.xml versionCode만 변화.
- [R572 SDK35 Java/D8/JS CI **SUCCESS**](https://github.com/yooogillycloud123/family-journey-personal/actions/runs/43605438138), 새 `classes18.dex` **61,840 bytes** SHA256 `f59efcfc30e1f4e88fe1f9fab453ae4d3986391496c83a6317c64b27e07b2e82`. 네이버 기존 저장/GPS 오류/중복/사진교체 경계 모의 + 알림 3.8초 종료/수정된 안내 timer mock 통과.
- 공개 키 없는 독립 검증 코드 `05_QA/verify_release.py`가 4개 APK의 v2 RSA/signed content digest/cert, ZIP/Dex/header, 4종 hash+member diff 확인. `R572_RELEASE_QA.json` 실기기 `NOT_TESTED` 표시를 정확히 유지.

## 4. 설치와 테스트 (중요)
- **일반:** R572만 현재 R570 또는 R571과 원래 같은 서명 설치본 위에 **덮어쓰기**. 앱 삭제, 데이터/캐시 초기화, NAVER 쿠키 삭제 금지.
- **실기기 확인:** 사진·영상 첫 진입 5회 반복, 토스트 3.8초 사라짐, fast ON/재진입 ON·OFF/재진입 OFF, 사진만 썸네일 바에 붙음·영상 컨트롤 정상, 새 아이콘 크기·배치 및 저장/순서 재배치 후 각 버튼 정상, 사진/영상 전환·핀치·탭·Back1회·Home/Recents·NAVER 복귀, 상세형의 기존 네이버 저장·원래 음성/DB까지 회귀 없음.
- **실제 심각한 회귀 시에만 R573** 설치하여 정확한 R567 기능 복구. R573 설치 후 다음 업데이트 versionCode **574 이상**. R571이나 R569는 R573 대신 쓰지 말 것.
- **현재 물리 성공 승인 = R567 골든**, **R572 실기기 기능 검증 전 BETA**. 화면 번쩍임 소멸/하단 도크 편의성 전수 성공을 이미 물리적으로 확인했다고 쓰지 말 것.
- 새 기능은 사용자로부터 확인 후에만 Golden 승격; 이 브랜치의 코드를 기존 immutable Golden 브랜치에 직접 커밋하지 않음. 별도 AA AirPods/Android Auto 앱/daemon 소스는 수정하지 않았음.
