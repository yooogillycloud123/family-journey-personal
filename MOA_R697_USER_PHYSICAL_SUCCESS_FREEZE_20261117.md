# MOA R697 — 사용자 실기기 성공 / 현재 정상 기준 동결 (2026-11-17)

## 확인된 사용자 회신 — 최우선 사실
- 사용자가 R694 오류로 **R695**(R691 기능 복구)를 설치한 후, R695를 기준으로 재수정한 **R697**을 전달받아 **"일단 실기기 성공 이제 여기서 추가적으로 업데이트는 생각나면 진행하자"**라고 명시적으로 보고했다.
- 따라서 R697은 **사용자 보고에 의해 실제 갤럭시 기기에서 성공한 최신 정상 작동 기준**이다. 이 보고를 이전 인계서의 “R697 실기기 미검증”보다 우선한다.
- 다만 사용자가 각 세부 시나리오별 로그·동영상을 새로 제출한 것은 아니므로, 확대 갤러리·PHOTO ADD·상세형·순서 저장·삭제 후 복구 등 **개별 항목마다 독립 테스트를 완료했다고 과장하지 않는다**.
- 사용자 지시: **당장 추가 기능·수정·빌드/업데이트를 하지 않고 보존 및 대기**. 다음에 사용자가 아이디어/수정 요청을 주면 그때 작업을 이어간다.

## 고정 보존 대상
1. **최신 사용자 실기기 성공 체크포인트**: `MOA_R697_R695_GOLDEN_SAFE_MULTI_REMOVE_FIX_ORIGINAL_SIGNED_BETA.apk`
   - package `com.juhyeon.familyjournea`
   - versionCode `697`, versionName `MOA-R697-MEDIA-BETA1`
   - APK SHA256 `67a8892c661e38ea9ec4227baa6ecb053bfe612ef874594e6fdf1b250820328e`
   - 원래 서명 인증서 SHA256 `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`
   - 종전 기록: [R697 원인·수정·복구·검증 인계](MOA_R697_R695_REBUILD_NATIVE_MULTI_DELETE_GALLERY_SURVIVAL_R698_RECOVERY_20261117.md)
   - 수정 소스 브랜치 `feature/moa-r697-r695-safe-native-multi-remove-20261117`; 소스/검증/원본 APK 포함 자료는 개인 Library `/모아_프로젝트_근거_20261103/R697_R695_SAFE_MULTI_DELETE_R698_RECOVERY_20261117/`.
   - **R697 APK·브랜치/산출물 절대 제자리 덮어쓰기 금지**. 후속 변경은 새 분리 브랜치.
2. **이전 사용자 명시 승인 불변 Golden**: R683 원본 SHA256 `e20e446d5e02358e833fe223471735abc3fd042234b4efc53acc208118ee9e8b`. 별도 백업 그대로 보존. R697 성공이 R683의 불변 원본을 삭제·대체한다는 뜻이 아니다.
3. **앞선 기능 기준 복구본**: R698은 `R695`(R691 기능)과 APK 구성요소가 같고 버전만 높은 복구본, SHA256 `8e56f44d89db13ccb2b82196ade160935b164ae4916eae0122f1040c144276bf`. R698은 **R697 신규 기능을 보존하는 복구본이 아니라 R695 기능으로 되돌리는 것**임을 반드시 고지.
4. 다음 빌드의 Android versionCode는 **실제 기기 설치 버전보다 반드시 높아야 함**. R697 설치 유지면 >=699 권장(기제작 R698과 충돌 방지). R698을 설치한 경우에도 >=699.

## 이어서 작업할 때 고정할 설계·회귀 기준
- R694는 **실제 기기 실패**. 구형 R694처럼 Gallery를 먼저 닫은 다음 지연된 WebView 다중 선택창을 띄우거나 삭제 직후 `openDay()`로 일기 전체를 재오픈하는 경로를 재도입하지 않는다.
- R697 정상작동 기준: 기존 네이티브 갤러리의 생명주기/원본 `classes6.dex` 재생 엔진/기존 PHOTO 카드 `classes18.dex` 보존, 사진·영상 여러 개를 선택하여 **일기 연결만 제외**, 원본 MediaStore 파일 유지, PHOTO의 같은 날짜 네이티브 갤러리는 가능한 한 유지/목록 갱신, 기존 상세형 복원 기능과 데이터 보존.
- 사진형 9개(휴지통 포함), PHOTO 전체화면 6개, DETAIL 전체화면 6개, 사진 추가 4개 **각자 독립 아이콘 순서와 설정**; 새 심볼을 추가하면 순서 설정·저장·마이그레이션도 함께 변경: [영구 심볼 동기화 지침](MOA_GALLERY_ACTION_REGISTRY_PERMANENT_RULES_20261117.md).
- 대표사진은 **보는 순서에서 첫 번째**로 이동시키되 나머지 기존 촬영순 유지. 원본 파일·촬영시각·일기 본문·음성·QR·바로기록·네이버 지도 연동·앱 데이터 보존.
- 설정 화면의 실제 앱 versionName/versionCode 표기를 다음 배포에도 동기화. 기존 동일 package/cert, APK v2, DEX, ZIP, 공식 Android SDK 검사, 동작 회귀/실기기 판정 및 상위 버전 복구본 필수.
- 사용자 요청 전 **새 개발·수정·자동 설치·실험 없음**. Android Auto / AA AirPods 프로젝트 별도이며 손대지 않는다.

## 새 채팅에서 읽을 순서
`MOA_READ_FIRST_NEW_CHAT.md` → **본 R697 실기기 성공 동결 파일** → [R697 기능 인계](MOA_R697_R695_REBUILD_NATIVE_MULTI_DELETE_GALLERY_SURVIVAL_R698_RECOVERY_20261117.md) → [R683 Golden lock](MOA_R683_USER_DEVICE_PHYSICAL_GOLDEN_LOCK_20261117.md) → [갤러리 심볼 영구 규칙](MOA_GALLERY_ACTION_REGISTRY_PERMANENT_RULES_20261117.md).

**요약: R697은 최신 사용자 실기기 성공 기준, R683은 종전 명시적 불변 Golden. 현 상태를 보호하고 사용자가 요청할 때만 R697에서 앞으로 개선한다.**
