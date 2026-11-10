# MOA 네이버 즐겨찾기 자동저장 — 기존 기능 중심 정정 설계 (2026-11-10)

> **연구/요건 문서, APK가 아니다. R245 이전에 확정된 사용자 목표를 다시 축소하지 않는다.**

## 1. 사용자 요구: 별도 테스트 패널이 아니라 기존 흐름 그대로
- 사용자는 MOA 일기/사진의 **이미 존재하는 위치 기록 기능**을 사용한다. 사진의 원본 GPS·촬영시각/메타데이터와 기존 주소 자동 조회를 이용한다.
- 이미 갖고 있는 장소명/주소/POI/저장리스트/별명/메모는 **두 번 입력받지 않는다**. 목록이 없으면 네이버 계정에 비공개 목록 자동 생성; 장소·별명·메모를 정확한 목록에 반영한다.
- 사용자 터치는 기존 '네이버 즐겨찾기 저장' 한 번. 장소가 모호한 때만 해당 사진 카드 내부에서 후보를 확인한다. 새 설정 폼, 수동 6칸 테스트, 번호 붙은 테스트 버튼, 반복 로그인/승인, 보조앱, PC/NAS/VPS는 목표가 아니다.
- **화면 가림은 진짜 무중단 백그라운드 실행이 아니다.** 네이버 앱 전면·오버레이 화면 점유·네이버 웹 리다이렉트는 기준 불합격.
- 네이버 계정 목록을 실제로 읽어서 **정확한 리스트+장소 식별자+별명+메모**를 재검증하기 전에는 '저장 완료' 표시 금지.
- R227 user-designated immutable gold SHA256 `53c4c04ce32ad13de3c0613f4e5ec7abbc75ccbdfe9db5da05d8fa9b806ec6cd`, R229 one-tap same-photo NAVER→MOA physical PASS 등 기존 기능 원본 보존. 원본 패키지/서명으로 **높은 versionCode 업데이트 설치**, 데이터 삭제 금지.

## 2. 실제 R245 디컴파일 소스 감사 결과 (가설 아님)
실제 설치 파일 `MOA_R245_NAVER_NATIVE_COVER_ACCESSIBILITY_BETA.apk`를 디코드해 원본 JavaScript/Smali를 확인. APK의 독립적인 실제 계정 저장 여부는 미검증.

| 현재 실제 코드 | 무엇을 하는가 | 무엇이 잘못됐나 / 보존할 부분 |
| --- | --- | --- |
| `assets/r28-diary-location.js` `requestLocation()` | `NativeHost.post('diaryMediaLocation',{request,id})`로 원본 사진 위치 요청 | **보존**. 사진 ID와 원본 GPS를 새 기능도 그대로 이어받아야 함 |
| `assets/r28-diary-location.js` `diaryReverseAddress` 및 `HostActivity` | 좌표→상세 주소 조회 | **보존**. 불필요한 '주소 수동 입력' 금지 |
| `assets/r28-diary-location.js` 저장 버튼 | 이미 있는 `FamilyJourneyNaver.diaryDraftForGPS`, `saveFromDiaryGps` 호출 | **바로 여기가 연결 지점**, 설정의 새 6칸 폼 아님 |
| `assets/web/fj-naver-favorites.js` `sourceRows()/build()` | 기존 사진 GPS 인덱스 3만 건 표본, 25m 군집·후보 | **보존·보강**. 군집 좌표=실제 가게 신원이라는 추정은 금지 |
| `assets/web/fj-naver-favorites.js` `saveFromDiaryGps` | 저장 전 `prompt('...정확한 장소명...')` 호출 | **중복 수동 입력 버그**. 불확실할 때만 후보 확인 UI |
| `assets/web/fj-naver-favorites.js` `startNativeSave()` | 리스트·장소를 두 번 `prompt`하고 저장 요청 | **기존 자동화 흐름 파괴**. 자동 전달과 단일 확인으로 교체 |
| `assets/web/moa-r231-settings.js` | 장소명·주소·POI·리스트·별명·메모 **별도의 수동 시험 UI** | **사용자 반대**. 정상 기능 확인 전에 제품 화면에 노출하지 않음 |
| `NaverSaveService.smali` | 네이버지도 앱의 접근성 UI를 읽고 버튼 조작; `VERIFIED`는 UI 표시 기반 | **실제 계정 readback 아님**. 일치하는 계정 목록 검증 필수 |
| `MoaNaverAccessibilityCover.java` | 접근성 오버레이로 네이버 앱을 덮음 | **사용자 요구 불충족**. 실제 화면은 점유, 사용자 자유 조작 불가 |
| R233/R241 WebView | `https://map.naver.com/?app=Y&appmarket=N` `ERR_TOO_MANY_REDIRECTS` Galaxy 실제 영상 | **FAIL 고정**. 동일 WebView·UA 변경 APK 반복 배포 금지 |
| R243 GeckoView Android emulator | APK build 성공, emulator guest ADB/boot `Broken pipe`로 지도 진입 미실행 | 지도 접속 **성공도 실패도 아님**, 로그인·저장 근거 아님 |

## 3. 권장 단일 기능 파이프라인 (기존 UI에서 시작)
```
기존 사진/일기에서 '네이버 저장' 한 번
  → 사진 ID/원본 EXIF MediaStore GPS (권한 검사)
  → 기존 diaryReverseAddress · 저장된 장소/별명/메모/리스트 재사용
  → 동일 위치에 매핑된 확정 NAVER POI ID가 있으면 즉시 사용
  → 없다면 합법적 장소 검색 자료로 근접 후보 매칭
       정확한 주소와 좌표로 유일하게 검증 가능한 후보 → 자동 채택
       업체 둘 이상/명칭 불명확/POI 없음 → 기존 사진 카드 안에서만 후보 선택/보류
  → 암호화된 로컬 지속 작업 큐 (photoID, GPS, exact POI, list, alias, memo, UUID)
  → 사용자 소유 동일 MOA 내부의 인증 세션을 쓰는 **진짜 오프스크린 실행 엔진**
  → 네이버 지도 본래 저장 UI에서 목록 유무 검사 → 없다면 자동 생성
  → 정확한 POI+별명+메모 저장 (중복 저장/해제 방지)
  → 같은 네이버 계정의 목록·장소 ID·별명·메모 독립 재조회
  → 모든 필드 일치할 때만 CONFIRMED, 아니면 PENDING/NEEDS_ACTION/UNVERIFIED
```

### 자료 근거에 기반한 API 구분
- 네이버 공식 지역 검색 API는 **업체명/도로명주소/지번주소/좌표**를 제공하여 'GPS→실제 POI 후보 특정' 단계를 보완할 수 있음. 공식 문서: https://developers.naver.com/docs/serviceapi/search/local/local.md . 단, 호출에는 발급된 Client ID/Secret 필요; 민감한 자격증명 APK 소스 공개/무단 하드코딩 금지, 제공 좌표계와 실제 GPS 비교 검증 필수.
- 네이버 공식 Maps/Android SDK 및 reverse geocoding은 **지도/주소** 기능을 제공하며, 사용자의 개인 즐겨찾기 목록 생성·장소·별명·메모 **쓰기 API는 공개 문서에서 확인되지 않음**. 곧바로 가능하다고 주장하지 않음. 공식: https://www.ncloud.com/api-cms/service-product/static/maps / https://guide.ncloud-docs.com/docs/maps-reversegeocoding-api .
- Android 접근성 `TYPE_ACCESSIBILITY_OVERLAY`는 아래 창 인식은 허용하지만 사용자 화면을 **점유**함. https://developer.android.com/reference/android/view/accessibility/AccessibilityWindowInfo
- 삼성 인터넷 Custom Tabs는 브라우저 웹페이지를 MOA에 표시할 수 있으나 MOA가 마음대로 웹 DOM/쿠키를 읽고 버튼을 누르는 API가 아님. 확장은 별도 승인·패키지 필요. https://developer.samsung.com/browser/android/overview.html / https://developer.samsung.com/browser/android/extensions-dev-overview.html
- 자체 내장 GeckoView는 가능한 후보이지만 NAVER 지도와의 호환성, 첫 로그인, 비가시 상태 JavaScript 작동, 네이버 계정 실제 저장 **모두 검증 전**. GeckoView의 비가시 상태는 JS freeze될 수 있으므로 `GeckoSession.setActive` 설계를 포함해 Android 실기기 검증 필요: https://firefox-source-docs.mozilla.org/mobile/android/geckoview/contributor/geckoview-architecture.html

## 4. 현 시점 선택의 엄격한 기준
**기술 방향 우선순위:** 기존 R28+FJNaver 자동 메타데이터 흐름 재사용 > 정확한 POI 특정 > 휴대폰 내 독립 인증 브라우저/세션의 비점유 가능성 실제 입증 > 실제 계정 저장 및 목록 readback > 최소 변경으로 동일 MOA APK 통합.

*삼성 인터넷 외부 창/Custom Tabs* 및 *네이버앱 접근성 덮개*는 실제 무점유 백그라운드라는 조건을 충족하지 않으므로 최종안으로 승격 금지. *독립 GeckoView* 또한 NAVER PC 화면 로드·로그인·비활성 JS·실계정 저장/읽기 확인 전에는 '가능한 완성 기술'이라 부르지 않는다. *공식 미공개 사설 POST API*는 보안/토큰/캡차 제약이 있으므로 작동이 입증되지 않은 상태에서 마음대로 우회한다는 약속 금지.

## 5. 다음 릴리스의 객관적 승격 게이트
1. 테스트용 설정 폼/중복 prompt가 **사용자 화면에 0개**. 기존 일기 사진의 위치정보→저장 한 번에서 request 구성.
2. 정상 GPS 사진 한 장의 실제 좌표·주소·POI를 **검증 가능하게** 대응시킴. 다수 후보의 경우 기존 카드 내 한 번만 확인; 잘못된 장소 자동 선택 0.
3. **Android 실제 S26 Ultra 한 기기에서** MOA 화면 전환·오버레이 점유 없이 엔진 실행, 사용자 명시 동의로 브라우저 로그인(최초 1회는 화면 인증이 필요할 수 있음), 이후 저장 시 화면 비점유.
4. 본인 네이버 계정에서 누락 리스트 생성 + 장소 저장 + 별명/메모 + 저장 목록 readback **종단간 검증**, 반복 3회, 중복/재실행/오프라인 복구.
5. R227 immutable/ R229 same-photo return + 촬영/일기/음성/영상/GPS/QuickRecord 재검증.
6. 동일 패키지, 원본 서명, versionCode 상향, APK v2/ZIP/DEX SHA/CRC, 사용자 가이드, APK + 내용 일치 ZIP 제공. 이전 정적 PASS로 실계정 PASS 대체 금지.

**배포 규칙:** 위 핵심 작업이 실증될 때까지 무작위 R246/R247 APK 등 **사용자에게 시험 설치를 반복 요구하는 새 테스트 APK 금지**. 기존 골든·현재 앱데이터는 변경하지 않는다.
