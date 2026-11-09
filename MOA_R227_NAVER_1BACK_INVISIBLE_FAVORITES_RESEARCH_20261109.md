# MOA R227 — 네이버지도 1회 복귀 + 화면 비점유 실제 즐겨찾기 심층 조사·실행 계약

- 기준일: 2026-11-09. 사용자의 새로운 직접 실기기 테스트와 화면녹화 `19966.mp4`(8.4초), `19967.mp4`(17.38초), R227 immutable APK/소스를 교차 검토.
- **목표가 다른 두 기능을 절대 혼동하지 않는다**: A. 사진 갤러리에서 장소 확인은 지도 화면이 실제 보여야 하며, 지도 보고 **뒤로가기 한 번에 MOA 동일 사진**으로 복귀. B. 위치정보 화면의 **실제 네이버 계정 즐겨찾기·메모·리스트 생성/선택·저장**은 **사용자 주 화면을 차지하지 않으면서**, Shizuku·루트·추가 APK 없이 MOA 내부 흐름에서 완료.
- R227 원본 package `com.juhyeon.familyjournea`, versionCode227, exact APK SHA256 `53c4c04ce32ad13de3c0613f4e5ec7abbc75ccbdfe9db5da05d8fa9b806ec6cd`. 원본 골든·서명·사진·일기·가족정보·과거 골든 절대 변경 금지. 문서와 PoC 소스만 새 브랜치에 추가, **새 설치 APK 미생성 / 현장 네이버 자동저장 완성 주장 금지.**

## 1. 영상에서 실제로 확인된 것 — 실기기 결과를 R227에 정확히 반영

**19966.mp4**: MOA native gallery의 날짜·상세주소와 지도핀→네이버지도 네이티브 장소패널→이전 네이버지도 화면과 홈/탐색 화면들을 거쳐→MOA의 **원래 동일 사진/필름스트립**으로 돌아옴. 사용자 명시 보고에 따르면 뒤로가기 **3회**. 결과는 `R227 same-photo-restore=USER_DEVICE_PASS(해당 경로)`, `strict single-Back=FAIL`. 기존 R225는 지도에서 돌아오면 다른 화면으로 복귀했던 것을 R227에서 고친 것이 확인됨. R227 카메라/영상/GPS의 다른 일반화된 실기 PASS로 확대 금지.

**19967.mp4**: MOA 일기/사진 위치정보에서 원본 GPS 관련 `★ 네이버 즐겨찾기 + 메모` 입력 UI; 네이버지도 앱이 전체 화면에 올라와 장소 선택→네이버 실제 저장 시트 `+ 메모, 별명, URL 추가`→리스트 선택→저장. 종료부 네이버 장소에서 초록 저장 별표 및 **`내 장소에 저장됨`** 표기를 확인할 수 있음. 따라서 단일 시범 작업에서 `네이버 앱 내 저장 UI에 실제 저장 표시됨`은 사용자 영상 근거 PASS. **하지만 MOA 화면 비점유 저장=FAIL(네이버가 화면을 차지함)**, 신규 리스트 자동생성=NOT_TESTED, 실계정에서 앱 재시작 후 재확인=NOT_TESTED. 영상은 네이버 앱 내부 UI의 실제 실행을 증명하지만 native 접근성 서비스가 어느 입력을 자동 처리했는지의 인과는 추가 로그 없이는 단정 금지.

## 2. R227 소스의 실제 원인

- `experiments/moa-r175/MoaNativeGallery.java` R227 고정 브랜치: `r225OpenNaver()`가 `Intent.ACTION_VIEW` + `nmap://place?lat=...&lng=...&name=...&appname=...`로 `com.nhn.android.nmap`을 실행. `r227ExternalMapPending=true`; 영상재생 일시정지; MOA 호스트 `onPause()`에서 `r227RetainForExternalMap()` 체크해 native gallery를 닫지 않고 `onResume()`에서 같은 인덱스 복원. **네이버 앱 내부 Back stack을 MOA가 제거하거나 한 번으로 축약하는 로직은 없음**.
- APK 실제 `assets/r28-diary-location.js`는 사진 GPS 정보 영역에 `★ 네이버 즐겨찾기 + 메모`를 붙여 alias/memo/list를 가져와 `FamilyJourneyNaver.saveFromDiaryGps()`로 넘김. `assets/web/fj-naver-favorites.js`는 `naverArm` 네이티브 브리지로 앱 조작을 시작하고 `내 장소` 등 **이미 존재하는 리스트를 전제**, 없으면 사용자 수동 생성 안내를 명시. 구동되는 네이버 저장 단계는 별도 Android 접근성 서비스이며 `com.nhn.android.nmap`의 실제 foreground accessibility tree에 종속.
- `androidHost/.../NaverSaveService.java`는 이전 R18에서 user-armed 단발성 자동화, UI에 visible confirmation 있을 때만 VERIFIED. 이 저장소의 공개 소스가 R227 정확 DEX와 byte-identical하다고 **입증된 것은 아님**. R227 내 로드된 JS는 `naverArm` 호출이 확인되지만 모든 실행 경로는 실기 로그로 확인 필요.
- `nmap://place`는 표시/검색용 공식 Deep Link이며 저장/리스트 생성 API가 아님. NAVER SDK 또한 자신의 앱 지도 화면/검색과 NAVER 사용자 지도 저장 기능을 구분해야 함.

## 3. 공신력 있는 제약과 공개 구현 비교

| 기술/방안 | MOA 화면 비점유 | Shizuku 불필요 | 네이버 계정 저장/리스트 생성 | 검증 근거 및 한계 | 권고 |
|---|---|---|---|---|---|
| 실제 네이버 앱 + 현재 Accessibility | **아니오** | 예(이미 켜져 있다면) | 기존 저장 일부 사용자 영상에 확인. 리스트 자동생성 미확인 | UI가 전면을 점유, 네이버 앱 화면 상태에 의존 | fallback 한정 |
| 네이버 공식 URL scheme / 네이버 OAuth / 일반 지도 SDK | 네이티브 제어 아님 | 예 | **공식 문서상 계정 즐겨찾기 쓰기/리스트 생성 공개 인터페이스 확인 안 됨** | Naver 지도 scheme에 지도/검색/마커/경로만 명시; OAuth는 프로필/지원 오픈 API | 저장 엔진이 아님 |
| 타사 네이버 앱을 별도 비공개 VirtualDisplay로 옮김 | 가능하면 화면 비점유 | **일반 Android 앱 권한으로는 원칙적 불가** | UI자동화 추가 필요 | Android 10+ private display cross-UID start 제한; 확인 가능한 공개 구현은 Shizuku/root 사용 | 현재 조건에 부적합, PoC 우선순위 낮음 |
| **MOA 소유 isolated WebView + NAVER Web 로그인/iframe 프레임 자동화** | **성공 시 가능** (MOA 전면 사용 유지) | **예** | 이론상 PC 웹 UI의 실제 저장 흐름을 재현 가능, **네이버 WebView 세션/DOM/readback 현장 검증 전에는 미확인** | AndroidX WebKit `addDocumentStartJavaScript`/`addWebMessageListener`는 특정 오리진의 각 프레임에 주입 가능. 페이지 DOM/로그인/iframe/백그라운드 실행은 별개 문제 | **1순위 실험** |
| PC Playwright headless browser worker / NAS | 휴대폰은 비점유 | 예 | GitHub에 실제 code path(리스트 만들기+저장) 있음, 실계정 현장 검증 미확인 | PC 항상 가동/로그인/네트워크 필요. 개인 세션 쿠키 보호 필수 | **2순위 대안**, 사용자가 PC 의존 동의할 때만 |
| 자체 MOA 장소·리스트 DB | 예 | 예 | **네이버 계정과 별개**; 네이버 동기화를 구현해야만 실제 계정 저장 | 정직한 오프라인 queue/backlog에 필수 | 모든 방식 공통의 안전 바탕 |

### 조사 출처(검증 후 참조)

1. Naver Maps 공식 scheme: https://guide.ncloud-docs.com/docs/maps-url-scheme (지도/검색/마커/길찾기/내비게이션, 즐겨찾기 쓰기 지원 문서 없음).
2. Naver 고객센터 장소 저장/내 장소/별도 리스트: https://help.naver.com/service/5637/contents/692?lang=ko
3. Naver Developers Login API allowed open APIs: https://developers.naver.com/docs/login/api/api.md
4. Android AOSP virtual display launch restriction: https://source.android.google.cn/docs/core/display/multi_display/activity-launch?hl=en
5. AndroidX WebKit origin-scoped per-frame script injection and secure messaging: https://developer.android.com/reference/androidx/webkit/WebViewCompat
6. Android task back stack, external app's own task/stack cannot be rewritten by MOA: https://developer.android.com/guide/components/activities/tasks-and-back-stack
7. GitHub dayeonisme/navermap-converter Playwright login session/list_create/place save: https://github.com/dayeonisme/navermap-converter (author notes selectors need live testing; **not proven device-compatible**).
8. GitHub symoon94/share-places-naver2kakao-selenium another historical favorites automation: https://github.com/symoon94/share-places-naver2kakao-selenium
9. GitHub Virtual Screen requires root/Shizuku: https://github.com/lejw0925/android-virtual-screen ; https://github.com/HakaI963/headless-android
10. Reddit Tasker original-app-return via user-initiated overlay: https://www.reddit.com/r/tasker/comments/z7q9ir ; AutoInput screen-only limitation: https://www.reddit.com/r/tasker/comments/127f5so/dev_autoinput_actions_v2_single_action_total_ui/
11. Google Play Accessibility automation and consent policy: https://support.google.com/googleplay/android-developer/answer/10964491?hl=ko-PY

## 4. 실현 가능성을 가장 빨리 가르는 No-Shizuku 1순위 실험

**POC-WEB-01 단계(A): 보기 전용 진단** — 기존 MOA와 별도 WebView 프로필(가능 시)을 만들고 네이버 도메인만 오리진 allowlist로 허용한다. 최초 사용자가 네이버 웹 UI에 **직접 로그인**하도록 독립된 보이는 login view를 제공(비밀번호·OTP·쿠키 외부 수집 금지). 로그인 실패/iframe 미로딩/별도 브라우저 강제면 즉시 FAIL. 네이버 계정과 개인정보는 절대 GitHub/로그 업로드 금지.

**POC-WEB-01 단계(B): 프레임별 UI 접근성 검증** — `map.naver.com`, `pcmap.place.naver.com`, `pages.map.naver.com` 등 현재 검증된 프레임 오리진만 대상으로 iframe 내 저장버튼·새 리스트 만들기·장소결과·메모편집·완료 UI가 보이는지 **비민감 요소 존재 여부만 계측**한다. `WebViewCompat.addDocumentStartJavaScript`와 `addWebMessageListener`를 사용하되, WebView/AndroidX 지원 버전 및 보이지 않는 WebView 타이머·렌더링 수명 확인이 전제. **소스 실험 스크립트는 DOM 존재 여부만 읽고 어떤 버튼도 클릭하지 않는다**.

**POC-WEB-01 단계(C): 사용자 한 건만 허용한 저장** — 정확한 사용자가 `네이버 즐겨찾기 저장`을 눌렀을 때 MOA 내부 persistent queue 등록→정확한 네이버 POI 후보 표시 또는 자신 있게 유일할 때만 선택→목표 리스트가 없으면 UI에서 생성→메모/별명→실제 저장 클릭→**네이버 웹 저장 목록을 다시 열어 같은 계정+장소ID+리스트 존재 재확인**. 다중 후보/로그인 만료/저장 제한/보안 확인 시 자동완료 금지, 사용자의 입력 대기. 네이버 내부 비공개 API를 추정 호출하거나 세션 토큰을 전용 서버로 보내지 않는다.

**POC-WEB-01 단계(D): 화면 비점유, 안정성 검증** — MOA Diary에서 스크롤·녹음·갤러리를 계속 쓰는 동안 최소 10회 연속 저장; 화면 전환 0회/키보드 강탈 0회/실저장 10/10/정확 리스트 10/10/동일장소 중복0/배터리·저장시간/앱 재시작에 대한 중복방지 검증. 모든 테스트는 개인정보가 없는 더미 장소 1~3건으로 시작. 코드가 웹 세션에 로그인을 보장하는 것이 아니고 진짜 계정 저장의 최종 실기검증은 필수. 사이트 UI 변경시 실패를 겉으로 알리고 queue를 보호.

**POC-WEB-01 단계(E): 최종 판단** — A/B가 실제 기기에서 불가하면 ① WebView/웹사이트 지원 제약 원인 분석 ② PC headless local agent 가능성 판단 ③ 사용자에게 MOA 로컬 우선 + 선택 전면 Naver 자동화 fallback 설명. 막힌다고 Android 보안·네이버 인증을 우회하거나 비공개 토큰/자격증명 훔치기 금지.

## 5. '뒤로가기 1회' 분리 해결안 — 정확한 물리 Back 보장은 외부 Naver 앱에 강제할 수 없음

- **원인:** 현재 NAVER는 R227의 `nmap://place`로 열려도 네이버 내부 장소패널→네이버지도 탐색화면/홈 등 자신이 소유한 Back stack을 거침. MOA는 자기 갤러리를 남겨뒀을 뿐 그 위의 타 앱 화면을 `finish()`할 수 없음. 의도를 무시하고 다른 앱 task를 강제 `CLEAR_TASK`하는 해킹은 기존 네이버 사용 상태를 깨뜨릴 수 있어 기본 금지.
- **선택안 R1(원하는 정확한 하드 Back 1회):** `MOA 내부 지도 뷰`를 별도 전체화면 패널로 열고 MOA 자체 OnBack에서 패널을 즉시 닫아 **동일 사진**을 보여줌. Naver 지도 SDK 또는 합법적 공식 Web Map SDK의 현재 위치·마커/상세를 표시하고, 실제 네이버 앱의 모든 기능과 동일하다고 주장하지 않음. Naver Web 페이지가 내부 WebView에서 정상동작하고 로그인/장소정보가 보이는지 장치 QA 필요. 실제 Naver 앱 열기는 별도 옵션으로 유지.
- **선택안 R2(실제 네이버 앱 UI를 그대로 유지하면서 한 번의 동작):** 네이버에 들어갔을 때 한시적으로 작게 뜨는 `◀ MOA 사진` **플로팅 복귀 버튼**/빠른설정·알림 액션. 사용자가 누르면 original MOA task/gallery를 전면으로 가져옴. 다른 앱 위 표시 권한과 최신 Android BAL/overlay 요건 확인 필요. **1탭 복귀**이지 물리 Back 제스처 1회와 동일하지 않음. 네이버를 자동 종료하거나 사용자 화면을 빼앗지 않는다. Android SYSTEM_ALERT_WINDOW를 요구할 경우 별도 명시 동의 및 사용 중에만 표시/해제.
- **선택안 R3(실제 네이버 앱에서 물리 Back 1회만):** 네이버 앱 스스로 stack을 한 화면으로 유지해야 하는데 **공개 API와 앱 소유권상 MOA가 보장 불가**. 단순 플래그 변경만으로 3→1 반드시 보장한다고 주장 금지. 추후 네이버 앱 버전/Intent 동작 비교가 가능하지만 불가능할 가능성 정직하게 보고.

**추천 UX**: 사진의 핀 기본 탭은 한 화면 `MOA 지도` (내부 지도 구현 가능성과 네이버 기능 비교 검증 이후 사용자 선택), `네이버지도 앱에서 자세히`는 외부 네이티브 유지. 또는 실제 네이버 앱 보기 선호 시 `◀ MOA 사진` 한시적 복귀 액션(새 helper APK 없음). 저장 자동화는 완전히 별도 WebView worker이며 화면이 나타나면 FAIL로 기록.

## 6. 데이터/원본 골든 보호·검증 규칙

- `placeRecord`는 사진의 실제 GPS vs 사용자가 선택한 POI ID/주소를 구분. 지자체/역사/여행앨범/영어학습과 공유되는 stable local ID 유지. 가짜 GPS/시간/장소명 추정 금지.
- Naver task status: `DRAFT` → `USER_APPROVED` → `WEB_SESSION_READY` → `LIST_READY` → `SAVE_SUBMITTED_UNVERIFIED` → `NAVER_LIST_READBACK_VERIFIED`; 실패 `LOGIN_REQUIRED`/`AMBIGUOUS_POI`/`UI_CHANGED`/`WAITING_USER`/`RETRYABLE_ERROR` 별도 저장. 확인 전에는 사용자에게 `네이버 저장 완료` 표시 금지.
- 작업별 `place id`·`list key`·`session`·`idempotency key`로 중복 방지. 한 개 실패가 원래 일기 저장/M4A/가족 일정 앱 동작을 중단시키지 않음. 비공개 로그인/세션/원본 사진은 공개 Repo·진단 로그·클라우드로 전송하지 않음. 사용자가 신뢰할 수 있는 로컬 보안 저장소에 최소 세션만 보유, 로그아웃·권한 철회 제공.
- APK 개발은 R227 원본 freeze branch 수정 금지. R229+ feature branch, 다른 DEX/assets 보존, APK+동일 APK ZIP, 원본 인증서+v2 전체 서명 검증, Android 시스템 Back·지도·메모·갤러리·음성·사진/영상 회귀 QA 필수.
- 이 문서는 연구+실험 착수이며 완성 앱 아님. **영상 19966/19967의 개인 사진 및 정확한 주소를 GitHub에 올리지 않음.**

## 7. 다음 실행 작업 (담당 구분)

- **개발 담당:** origin-scoped `WebViewCompat` iframe view-only PoC(별도 신규 브랜치) 구현, 로그인/프레임 접근성 GO/NO-GO 확인; 성공하면 네이버 웹 저장 목록 readback 1건→자동 리스트 생성 1건→주 화면 비점유 반복검증. R227의 지도 유지 코드는 보존하고 one-back UX는 독립 실험.
- **사용자:** 지금은 추가 ADB/Shizuku/다른 앱 설치 필요 없음. PoC 실제 기능이 포함된 동일 서명 신규 MOA APK가 준비된 경우에만 네이버 웹 한 번 로그인, 더미 장소 하나 저장 결과 및 지도복귀 1탭/1 Back를 짧게 실기기 확인. 그 전까지 R227 현행 앱을 평소처럼 사용.