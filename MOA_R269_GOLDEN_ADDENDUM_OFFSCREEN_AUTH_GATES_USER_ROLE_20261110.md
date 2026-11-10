# MOA R269 사용자 지정 GOLDEN — 비점유 네이버 즐겨찾기 연구·사용자 참여 분리 부록
**기록일: 2026-11-10 / 문서만 추가. R269 Golden 바이너리 및 기존 잠금 문서 내용은 변경하지 않음.**

## 0. R269 골든 불변·기능 상태
- 원본 MOA APK: `com.juhyeon.familyjournea`, versionCode269, 8,932,642 bytes, SHA256 `c0663e65aac2b72feb86cb0f1ba5eac448b6599c3850858de4d942f2aa446920`, 원본 서명 SHA256 `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`.
- 이전 R227 사용자 골든 역시 별도 보존. 새 브랜치는 원본 코드와 바이너리를 덮어쓰지 않는 별도 구현·연구에 사용.
- R255 Galaxy 앱 기동 사용자 PASS / R261 네이버지도 전경 접근성 즐겨찾기 저장 사용자 보고 성공 / R269는 사용자 지정 골든. **R269 모든 경로의 완전한 실기기 PASS로 확대 해석 금지**.
- 보호 기능: 사진 원본 EXIF GPS 및 주소 자동 확인, 일기/기록/음성/바로기록, 기존 전경 접근성 즐겨찾기 저장, 네이버 지도 진입 시 ↶MOA 일회 복귀, 이미 저장한 사진/화면 상태, 본래 앱 데이터.
- 최종 요구: 단 한 개의 MOA APK, 루트/Shizuku/PC/보조 앱 없이 **MOA가 계속 전경에서 조작 가능하고 네이버 앱을 점유 실행하지 않은 채** 올바른 리스트·장소·별명·메모 저장, 없는 리스트 생성, 실제 네이버 계정 목록 재조회 후에만 '저장 완료'. 바로기록 같은 기존 저장 파이프라인에서 재사용 가능.

## 1. 이번 사용자 제공 NAVER 지도 6.7.2.1 APK 실제 분석 결과
관련 연구 근거 파일:
- `MOA_R269_NAVERMAP_6721_APK_REVERSE_OFFSCREEN_FEASIBILITY_20261110.md` 및
- `MOA_R269_REAL_ANDROID_WEBVIEW_FRAME_SAVE_GATE_AND_REUSE_HANDOFF_20261110.md`
(브랜치 `research/moa-r269-navermap6721-offscreen-evidence-20261110`).

NAVER 지도 앱 base APK `com.nhn.android.nmap`, 42 DEX; `BookmarkRepositoryImpl`, `BookmarkApi.addBookmark`, `BookmarkFolderApi.addFolder`, `BookmarkPlaceDialogFragment`, 인증된 내부 API 게이트웨이 및 URL 서명 계층 존재. 그러나 매니페스트 분석에서 **제3자 앱에 개방된 개인 즐겨찾기 저장·폴더 생성 구성요소가 없음**. 외부 `nmap://` 인텐트는 장소·지도 열기 등으로, 사유 북마크 쓰기 계약이 아니다. NAVER 앱 내부 클래스·세션·쿠키·서명 비밀을 MOA에 복사한다고 동작하는 구조가 아님. 비공개 인증 우회, 앱 사칭, 캡차 우회 구현 금지.

## 2. 이전 WebView 실패와 달라진 구체적 증거
- R241 실제 Galaxy WebView `ERR_TOO_MANY_REDIRECTS` on `map.naver.com/?app=Y&appmarket=N`. 이 주소 재사용, UA만 변경, `onPageFinished`를 성공 처리하는 오류 재현 금지.
- 2026-11-10 공개 무로그인 PC지도 브라우저 테스트: `https://map.naver.com/p/entry/place/{sid}` 접근 가능 (데스크톱 UA Chromium, Android 모사 viewport 환경). **이것은 실제 Galaxy WebView 성공을 증명하지 않음**.
- 상단 `저장` 내비게이션 메뉴는 **저장목록 화면 이동**이지 '장소 저장' 버튼이 아님.
- 실제 장소 상세 페이지는 자식 iframe `https://pcmap.place.naver.com/place/{sid}/home`이고, 실제 저장 후보 컨트롤은 `[data-nlog-area="map_btp.save"]` 등 첫 번째 당사자 DOM 내부. 해당 DOM selector는 언제든 변경될 수 있으며 로그인 없는 테스트의 클릭은 서버 저장 성공 아님.
- 표준 `WebView.evaluateJavascript()`는 최상위 문서에 작용하므로 cross-origin iframe의 저장 UI 제어 불가. 공식 AndroidX `WebViewCompat.addDocumentStartJavaScript` + `addWebMessageListener`를 허용된 네이버 출처별로 사용하는 구현 경로를 실험. 세션 인증/쓰기 가능 여부는 아직 **미검증**.
- Android emulator WebView 실제 프레임 시험: `experiments/moa-r269-android-webview-frame-test/**`; 검증 워크플로 run `42804245257`는 **FAIL**로 종료. 별도 Android 시험용 APK **컴파일은 PASS**했지만, GitHub Actions의 Android 35 에뮬레이터가 `Timeout waiting for emulator to boot`로 기동 실패해 **WebView가 실제 네이버 페이지를 연 결과는 전혀 얻지 못함**. 이는 네이버 저장 기능의 실패 판정이 아니라 시험 인프라 실패다. 기존 R241 실기기 리다이렉트 문제 역시 해결됐다는 근거 없음.
- 공개 페이지 무인증 실험 CI 성공은 **네이버 개인 계정 저장에 대한 PASS가 아님**.

## 3. 해결할 정확한 기술 관문
1. **내가 할 일 — 휴대폰 브라우저 실행 환경:** 실제 Android WebView에서 PC지도 부모·장소 상세 iframe 렌더링, 앱 강제 유도/리다이렉트, 프레임 통신, 비가시/극소 WebView에서 JS 실행 지속 여부 검증. WebView가 실패하면 별도 내장 브라우저도 근거 기반 대조.
2. **내가 할 일 — 기존 MOA 입력 재사용:** 사진 EXIF/GPS→주소→정확한 네이버 장소 SID 식별, 기존 저장리스트/별명/메모·바로기록의 값 재사용. 업체가 모호하면 자동 임의 선택 금지.
3. **내가 할 일 — 작업 안정성:** 하나의 앱 내부 영속 큐, 중복 저장 해제 방지, 실패 단계/사유, 팝업 ON/OFF, 확인 전 PENDING/UNVERIFIED, 사용자 화면 비점유 및 기존 `↶ MOA` 회귀 검증.
4. **공동 실계정 검증 — 사용자 승인이 필수:** MOA 소유 브라우저의 공식 네이버 로그인 UI가 실제 동작하면 사용자가 **본인 폰에서 최초 1회 로그인·추가 인증/동의**. 로그인 성공 후 내가 만든 엔진이 한 개의 무해한 테스트 장소·리스트·별명·메모 저장을 시도하고, 사용자가 네이버 계정에서 실제 반영을 검증. 자동 readback 일치가 저장완료의 필수 조건.
5. **인증 차단 시 중단 조건:** 네이버 인증·보안·캡차 정책상 통합 브라우저의 저장이 허용되지 않는다면 단순 HMAC/내부 API 카피나 외부 NAVER 앱을 화면만 덮는 트릭으로 '비점유 완료'를 주장하지 않음. 추가 사용자 입력이 필요한 경우 한 번에 최소한으로 요청.

## 4. 사용자 도움의 시점·내용
**지금 당장 필요한 사용자의 행동은 없음.**
내가 검증 가능한 공개 UI·Android 런타임·실제 통합 후보를 먼저 준비해야 한다. 그러고 나서 사용자에게 필요한 것은:
- **네이버 계정 본인 로그인:** 사용자 스마트폰에서 MOA 내부의 정식 네이버 로그인 화면을 직접 사용(비밀번호, OTP, 세션 쿠키, 인증 토큰을 채팅으로 전달하지 않음).
- **실계정 저장 결과 1건 확인:** 별도 테스트 리스트에 장소·별명·메모가 같은 값으로 저장됐는지 확인. 오류 발생 시 개인 정보가 제거된 상태코드/짧은 화면 기록만 필요.
- 이와 별개로 MOA 일기/갤러리/바로기록 정상 및 ↶MOA 복귀가 지속되는지만 간단히 확인.
사용자가 원하지 않는 6칸 수동 테스트 폼, 무작위 다수 APK 설치, PC·보조 앱 요청 금지.

## 5. 개발 릴리스 기준
- R269 골든 원본/서명 보존, 신규 브랜치에서만 개발.
- 최소: **실제 Android WebView 네이버 페이지 PASS → 본인 정식 인증 PASS → 폴더 만들기/정확한 장소·별명·메모 저장 PASS → 계정 readback PASS → 기존 MOA 회귀 PASS**.
- 소스 컴파일/모의 CI PASS는 계정 저장 PASS를 대체할 수 없다.
- 기존 점유형 저장이 되는 상태를 절대로 미검증 비점유 구현으로 바꾸지 않는다.

---

## 6. 2026-11-10 추가 실측 — R269 비점유 WebView Android35 네이티브 터치/신뢰된 클릭 (기존 골든 파일은 불변)

> **기존 문서의 앞선 에뮬레이터 부팅 FAIL(42804245257) 서술은 과거 시점의 상태다.** 이후 CI에서 KVM 접근/쉘 스크립트 등을 수정해 에뮬레이터를 실제 기동했다. 아래 날짜·run별 새 실측을 최신 증거로 사용한다. 소스 빌드 PASS와 NAVER 실제 계정 저장 PASS는 엄격히 구별한다.

### 실측 근거와 성공 범위

- [42812425818](https://github.com/yooogillycloud123/family-journey-personal/actions/runs/42812425818) **SUCCESS**: Android 35 실제 에뮬레이터 WebView에서 네이버 Place 원본 상세 URL `https://pcmap.place.naver.com/place/1628573942/home` 로딩, 실제 장소별 저장 버튼 `a[data-nlog-area="map_btp.save"]` 탐지. WebView를 정상 크기에서 **2×2픽셀**로 줄여도 `saveCount=1`, 본문 DOM 유지. 해당 버튼의 익명 JS `.click()` 호출 실행은 확인했지만 이후 `dialogCount=0;loginTextVisible=false`. **인증·계정 저장 아님**.
- [42822792604](https://github.com/yooogillycloud123/family-journey-personal/actions/runs/42822792604) **SUCCESS**: 직전 JS 실험 영향을 배제하기 위해 Place 문서 새로고침 후, 모아를 모사한 **완전 불투명하고 사용자 터치가 가능한 전경 커버** 뒤에서 동일 앱 소유 WebView에 Android `MotionEvent.ACTION_DOWN/ACTION_UP` 전달. `NATIVE_TOUCH_SENT`, `NATIVE_TOUCH_POST_UI`, `MOA_COVER_CLICK` 확인. 전달 후 `pressed=false;dialogs=0;loginTextVisible=false`. 모의 화면이 조작 가능한 것과 네이버가 장소를 저장하는 것은 서로 다른 검증 항목.
- [42824267351](https://github.com/yooogillycloud123/family-journey-personal/actions/runs/42824267351) **SUCCESS**, 원시 Android Logcat 재확인: `NATIVE_TOUCH_OBSERVER_READY "installed"`; `downHandled=true;upHandled=true`; 정확한 **저장 링크**에서 `pointerdown:trusted=true,touchstart:trusted=true,click:trusted=true`; `navigator.userActivation.hasBeenActive=true`. 즉 **같은 앱 내부 WebView의 저장 링크에 실제 trusted 클릭 이벤트가 발생했고, 전경 모아 모의 커버도 터치 입력을 받았다**. 그러나 이후 `pressed=false;dialogs=0;loginTextVisible=false`이며 `AUTH_POPUP_REQUESTED` 없음. **저장 처리·공식 로그인·계정 쓰기/조회는 전혀 증명되지 않음**.
- **메인 지도 호스트와 Place 상세 호스트를 구분**: `map.naver.com/p/entry/place/...`은 해당 Android 에뮬레이터에서 `MAIN_ERROR -2`(DNS/호스트 조회)였으나, `pcmap.place.naver.com/place/.../home`은 실제 DOM까지 로딩. 원인 불명의 메인 페이지 실패를 장소 상세 성공과 혼동하거나 R241 `ERR_TOO_MANY_REDIRECTS`가 모두 해결됐다고 말하지 않는다.
- [42824149532](https://github.com/yooogillycloud123/family-journey-personal/actions/runs/42824149532)는 **중간 CI run 취소**(컴파일 단계에서 취소)되어 실기능 PASS/FAIL의 증거가 아니다. 정상 완료한 위 세 run만 성공 범위에 사용한다.

### 로그인·실계정 사용자 협조 — 무엇을 했고, 무엇이 아직 필요한가

- **지금까지 사용자의 네이버 아이디/비밀번호, 네이버 앱 세션, 로그인 쿠키, OTP, 개인 계정은 한 번도 사용하지 않았다.** 사용자 본인 계정에는 실제 장소/리스트/별명/메모를 써보지 않았다. 연구는 무로그인 익명 Android 에뮬레이터/공개 Place 페이지만 사용.
- **지금 당장 사용자가 로그인하거나 보조 APK를 설치할 필요 없음.** 모아 내부에 정식 네이버 웹 로그인·저장 UI가 안전하게 동작하는 통합 후보가 확보되고, 본인 실계정 검증이 반드시 필요한 지점에 도달했을 때만 **본인 Galaxy의 공식 네이버 로그인 화면에서 직접 1회 로그인/추가 인증**. 채팅·GitHub·테스트 로그로 비밀번호/OTP/쿠키/인증 토큰을 전달하지 않는다.
- 그 뒤 테스트용 장소 **정확한 SID+기존/신규 리스트+별명+메모** 1건을 사용자가 승인한 상태에서 저장하고, 별도 네이버 계정 목록 **독립 재조회 일치**까지 증명해야 `NAVER_READBACK_VERIFIED` 및 저장 완료 가능. 단순 클릭, native dispatch, trusted click, UI toast는 절대 대신하지 않는다.

### 기존 보호선과 다음 검증 게이트

- 연구 브랜치 `research/moa-r269-webview-kvm-frame-gate-20261110`의 Java/Android35 CI만 변경. [중단 작업 인수 문서](https://github.com/yooogillycloud123/family-journey-personal/blob/research/moa-r269-webview-kvm-frame-gate-20261110/MOA_R269_RESUME_NATIVE_GESTURE_AB_GATE_20261110.md), [실험·진단 추적 이슈 #9](https://github.com/yooogillycloud123/family-journey-personal/issues/9).
- 미해결: 네이버 서비스 측 저장 동작/공식 인증 화면/개인 장소 데이터 쓰기, 새로운 리스트 생성, 별명·메모, 독립 서버 readback, 원래 `com.juhyeon.familyjournea`에 통합한 원본 서명 APK, 실제 Galaxy 회귀 검증.
- **골든은 계속 불변:** R269 user-designated code269 APK **8,932,642B SHA256 `c0663e65aac2b72feb86cb0f1ba5eac448b6599c3850858de4d942f2aa446920`**. R227 및 기존 일기/갤러리/바로기록/전경 네이버 저장/↶MOA 복귀 보호. 골든 APK·잠금 문서·원본 서명/사진·개인 데이터는 변경하지 않고 **이 부록 문서만 갱신**.


---

## 7. 2026-11-10 추가 검증 — 첫 공식 NAVER 로그인 UI 진입(무로그인, 개인계정 저장 미수행)

- **정확한 검증 도구/실행:** 실 네이버 PC 공개 지도 Playwright Chromium headless, GitHub Actions [42829152141](https://github.com/yooogillycloud123/family-journey-personal/actions/runs/42829152141) `SUCCESS`; 무로그인 익명 공개 Place SID `1628573942` A/B 테스트. 원시 JSON Artifact SHA256 `ed67b7ff3f15f53024c4f5fed43fcfab7dff429f48d3c9af5d824c85d96136aa` (Workflow artifact ZIP, 비공개 사용자 데이터 없음).
- **정상 부모/자식 구조 A (로그인 진입 PASS):** `https://map.naver.com/p/entry/place/1628573942` 의 `https://pcmap.place.naver.com/place/1628573942/home` iframe 내부, 실제 `a[data-nlog-area="map_btp.save"]` 버튼이 존재함을 확인. Playwright 신뢰된 브라우저 네이티브 클릭 후 기존 Place iframe 분리, **최상위 NAVER 지도 페이지가 정식 로그인 주소 `https://nid.naver.com/nidlogin.login`으로 이동** (`parent_after` 및 `frames_after` 값, `visible_login_ui_any_frame=true`). 계정 비밀번호 입력/로그인·저장 없음.
- **독립 장소 페이지만 열었을 때 B (저장 동작 미진행):** `https://pcmap.place.naver.com/place/1628573942/home`만 최상위 로딩하면 `pointerdown/mousedown/click:trusted=true`였지만 `navigation_changed=false`, `visible_login_ui_any_frame=false`, `pressed=false`. 단독 페이지와 **공식 네이버지도 부모 iframe 통합 경로는 동등하지 않음**. 기존 모아 연구에서 단독 Place 저장 버튼만 반복 클릭하는 시도는 실계정 자동저장 구현으로 승격 금지.
- **원인 해석:** 부모/자식 컨텍스트가 로그인/저장 진입에 실질적으로 관여한다는 강한 직접 증거. 다만 내부 JS 로직·인증 서버 정책·실제 개인 즐겨찾기 쓰기에는 아직 추가 검증 필요. `nid.naver.com` 진입은 **로그인 페이지 OPEN PASS**, **로그인 성공/폴더 생성/장소·별명·메모 저장/독립 readback PASS가 아님**.
- **Android 기기 관문 별도:** Playwright 데스크톱 Chromium의 부모 iframe 공식 로그인 진입과 Galaxy Android WebView의 동등성은 아직 물리 검증되지 않았다. 과거 R241/R233 실기기 루프·Android 에뮬레이터 `map.naver.com` DNS -2를 해결했다고 단정 금지. 연구 브랜치 `research/moa-r269-webview-kvm-frame-gate-20261110`는 프레임 detach 후 로그인/재내비게이션을 안전한 불리언·호스트 값만 기록하도록 수정. 여기까지는 소스/CI 증거이며 사용자 설치용 동일서명 MOA APK 아님.
- **사용자 참여:** 현재까지 본인 네이버 계정·쿠키·비밀번호·OTP **0건 사용**. 별도 로그인 앱 설치 및 다중 테스트 요구 없음. 실제 MOA 내부 공식 로그인 화면이 테스트 가능한 **같은 앱 설치용 후보**로 준비됐을 때 본인 Galaxy에서 사용자가 직접 로그인·동의하고 1건 readback 테스트가 필요하다. 인증정보를 채팅/로그/GitHub에 제출하지 않는다.
- **Golden 보존:** R269 원본 `com.juhyeon.familyjournea` versionCode269 SHA256 `c0663e65aac2b72feb86cb0f1ba5eac448b6599c3850858de4d942f2aa446920`, 기존 잠금문서·R227 별도 Golden·전경 네이버 저장·사진/일기/바로기록·복귀/사용자 데이터 변경 없음. 이번 업데이트는 **Golden 부록 문서만** 증보, FINAL APK/백그라운드 저장 성공 선언 금지.


---

## 8. 2026-11-10 실제 동일서명 R275 로그인 연결 베타 빌드 — 설치 가능 형식, 실기기 미검증

- **원본 R269 Golden은 건드리지 않음.** 사용자 지정 원본 code269 APK SHA256 `c0663e65aac2b72feb86cb0f1ba5eac448b6599c3850858de4d942f2aa446920` 및 R227 별도 Golden은 불변. 이 추가 내용은 Golden 부록 *문서*의 보존 기록.
- **개인 Library에서 확인한 재빌드 기초:** 사용자가 보유한 실제 original-signer R265 APK SHA256 `5c1d43bb99fd25e82d0ae960fbdbb3609d7235e8ce17736dcb2d518526c3dae5`와 `MOA_R269_SOURCE_DIFF_NO_PRIVATE_SIGNER.zip`의 원래 R269 복귀 패치 소스를 로컬 복원. 기존 원본 인증서 SHA256 `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`의 일치 여부를 개인 Library의 *비공개 서명 백업*과 실제 검증. 비밀번호/서명키/원본 개인 APK를 공개 GitHub·Actions에 업로드하지 않음.
- GitHub Actions `42832323985`는 **공개 apktool/Android build-tools 바이너리만** 준비한 성공한 워크플로이고, 사용자 개인 바이너리·서명키는 CI에 전달하지 않음.
- **R275 베타 산출물** `MOA_R275_NAVER_PARENT_LOGIN_ENTRY_SAME_SIGNER_BETA.apk`, code275, 8,916,258 bytes, SHA256 `9b5dc6ee1cedd2f4f3b74ee6bc8d2677070f2a89501d033c6c4d94489d52ed9e`. 원본과 같은 package `com.juhyeon.familyjournea`/인증서. R265 대비 변경된 비서명 엔트리는 **오직** `AndroidManifest.xml`, `classes2.dex`, `classes6.dex`, `classes13.dex`, `assets/web/moa-r231-settings.js`.
- **R275 추가 실험:** 기존 MOA 설정의 '네이버지도 복귀 버튼' 내부에 명시적 1탭 '샘플 장소 웹 연결'/'진단 종료' UI를 복구하고, 기존 MOA-owned WebView의 시작 주소를 부모 PC 지도 `https://map.naver.com/p/entry/place/1628573942`로 좁혀 공식 `nid.naver.com/nidlogin.login` 시작 시 `NAVER_OFFICIAL_LOGIN_ENTRY_UNVERIFIED`로만 진단. 별도 APK·루트·Shizuku·ADB가 필요한 정상 사용 흐름을 만들지 않았음. **샘플 장소 정적 진단일 뿐 사용자의 사진 GPS나 즐겨찾기를 자동 저장하지 않음.**
- **R277 복구 후보** `MOA_R277_RESTORE_R269_SOURCE_EQUIVALENT_BETA.apk`, code277, 8,916,258 bytes, SHA256 `82fbac6bfe4caaf8effe1be6c0b12e14bcb7984d3fb974c358cb5a8f213a12d3`. R265 원본에 보관된 R269 복귀 수정만 재적용한 기능적 복원 후보로, R275의 테스트 UI는 제외. 역시 실제 사용자 골든 APK와 바이트 동일하지 않고 실기기 미검증.
- **정적 QA:** 두 APK 모두 APK Signature Scheme v2 + 원래 인증서, zipalign, ZIP CRC, 16 DEX SHA1/Adler32, 바이너리 AXML package/버전 확인 PASS. JS Node syntax/실험 버튼 Native `naverWebProbeControl(visible/stop)` 계약 정적 확인 PASS. R275/R277 안에 개인 서명키·암호 파일 없음. **이것은 기동 PASS·지도 로그인 PASS·네이버 계정 저장 PASS가 아님.**
- **중요 안전 제한:** 원래 R269 설치본은 보존하되 기존 앱 제거/데이터 초기화 금지. 사용자는 실기기 미검증 후보를 강제로 설치할 필요 없음. 최신 빌드는 R269 실제 원본 APK를 바이트 복제한 것이 아니므로 R277을 원본 Golden으로 잘못 표기하지 말 것. Android 버전코드 내리기 강제/앱 삭제 금지.
- **남은 필수 게이트:** Galaxy 본인 기기의 R275 기동·일기/사진/바로기록/↶MOA 회귀, Android WebView의 실제 부모/iframe 렌더와 공식 로그인, 정식 사용자 자체 로그인·동의, 정확 SID/리스트/별명/메모 쓰기 및 독립 계정 재조회. **실계정 비점유 자동저장 최종 APK는 아직 완료되지 않음.**


---

## 9. 2026-11-10 R275 Galaxy 정식 네이버 보안 재확인 화면·R279 수리 베타

### 사용자 실제 Galaxy 증거 — 최우선 관측
- 사용자 제공 **개인 영상 20170.mp4·20171.mp4 및 20172.png**에서 기존 설치 R275의 설정 내 '샘플 장소 웹 연결'을 통해 네이버지도 PC Place 화면 및 `nid.naver.com` 로그인 화면 진입을 실제 갤럭시에서 확인. 따라서 이전에 열린 “PC Chromium 로그인 진입”은 **이제 Android WebView의 실제 로그인 화면 렌더링에도 도달한 것**으로 증거가 확대됨. 다만 R275 전체 앱 회귀나 실계정 로그인 성공은 증명되지 않음.
- 네이버 로그인 시 공식 서비스가 **자동입력방지/영수증 이미지 문제**를 요구했고, 사용자가 문제 입력 후 ‘확인’을 눌러도 정상 다음 단계로 넘어가지 않거나 인증이 재출현했다. 별도 정상 모바일 브라우저에서 사용자 계정의 보안설정/로그인 페이지 접근은 관찰됐으나 **MOA WebView와 외부 브라우저는 로그인 세션을 자동 공유하지 않음**.
- 이는 **네이버 서비스 자체의 추가 보안 확인**이며, 답/비밀번호 오류, 웹뷰의 UI/JS 다이얼로그 처리 또는 보안 정책 중 무엇이 원인인지는 이 자료만으로 확정 불가. 로그인 실패를 정상으로 오분류하거나 CAPTCHA 자동 풀이/세션 추출/보안 우회 금지. 원본 영상에는 개인 아이디 등 정보가 포함될 수 있어 **공개 GitHub·CI·산출물 ZIP에 영상/보안답변 업로드 금지**.

### 비공개 로컬 R279 보완 및 결과물
- R279 동일 패키지·기존 원본 인증서 베타 APK: `MOA_R279_NAVER_AUTH_UI_SAFE_SAME_SIGNER_BETA.apk` code279, SHA256 `7e2e76fb7683fab02ce096e00028697996a071d39b52abf8ef64865028299373`, 원본 인증서 SHA256 `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`.
- R275에 비해 **오직** `AndroidManifest.xml` (versionCode), `classes13.dex` (기존 MOA 소유 로그인 WebView), `assets/web/moa-r231-settings.js` (설정 안내/숨김 연구 버튼) 변경. 기존 일기/갤러리/바로기록/오디오/복귀 등의 다른 비서명 APK 엔트리는 바이트 동일.
- WebView에는 기본 `WebChromeClient`를 설치해 **정상 사용자가 누른 JS 다이얼로그 처리 경로**를 제공하되 인증 우회/자동입력 방지 비활성화나 비밀번호·쿠키 수집을 하지 않음. `nid.naver.com` 인증 페이지에 대해 `onPageFinished` 내 기존 진단 JS 실행을 중단하고 주소 호스트에 대한 상태코드 `NAVER_AUTH_SCREEN_MANUAL_ONLY`만 표시. 이를 네이버 로그인 성공으로 보지 않음.
- 기존 모아 설정의 '샘플 장소 웹 연결' 버튼은 유지. '모아 화면 유지(연구)' 버튼을 추가하여 **기존 WebView를 제거하지 않고 뒷면으로 배치**하는 UI 시험만 제공. 모아 화면 비점유의 일부 실험이며 자동 즐겨찾기 쓰기 기능이나 인증 화면의 비가시 입력으로 승격 불가. 진단 종료 버튼도 유지.
- R281 데이터 삭제 없는 업데이트 방향 복구 **후보** `MOA_R281_RESTORE_R269_SOURCE_EQUIVALENT_BETA.apk` SHA256 `948f02746d68199c3ca2bf09ba1e6bf4d5633f73d501a1890196630a2d9064de`는 R279 인증 진단 변경을 제외하고 기존 R269 복귀 패치를 R265에 복원한 것. **원본 R269 Golden과 바이트 동일하지 않으며 기동 실기기 미검증**. 앱 삭제/데이터 초기화·강제 다운그레이드 금지.
- 정적 검증: R279·R281 Android APK v2 서명/원본 인증서·zipalign/ZIP CRC·16개 DEX checksum·실제 APK versionCode 및 package·JS Node 문법 PASS. **네이버 CAPTCHA 확인 버튼 동작, 로그인/세션, 서버 즐겨찾기 저장 및 독립 readback, 숨김 상태 자동저장, 갤럭시 R279 실행 모두 PENDING**. 인증 실패가 계속되면 로그인 반복/보안 설정 해제 요구 금지; 실제 사용자 승인과 정상적인 네이버 공식 인증만 허용.
- 원본 R269 사용자 지정 Golden APK SHA256 `c0663e65aac2b72feb86cb0f1ba5eac448b6599c3850858de4d942f2aa446920` 및 별도 R227 Golden **완전 불변**. 이번 커밋은 설명 문서의 신규 섹션만 추가.
