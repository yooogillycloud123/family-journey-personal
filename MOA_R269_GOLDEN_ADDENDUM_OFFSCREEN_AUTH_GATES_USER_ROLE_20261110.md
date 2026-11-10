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


---

## 10. 2026-11-10 R279 실기기 추가인증 반복 — 영상 20180 및 원본 smali 확인
- 사용자 갤럭시 실제 R279 영상 `20180.mp4`: 네이버 공식 `nid.naver.com` 영수증형 자동입력방지 문제에서 사용자가 정답을 수동 입력하고 초록색 '확인'을 여러 차례 누름. **버튼 터치 시각 효과는 관찰**되지만 페이지 진행, 로그인 성공, 오류 메시지 등 최종 인증 결과는 기록되지 않음. 문제 정답·비밀번호·회원 아이디는 공개 저장/전달하지 않음.
- **R279 실제 smali 재점검** `MoaNaverWebProbeHost.smali`: WebView `setJavaScriptEnabled(true)`, `setDomStorageEnabled(true)`, `CookieManager.setAcceptCookie(true)`, `setAcceptThirdPartyCookies(web,true)`, 기본 `WebChromeClient`가 이미 존재함. 따라서 'WebChromeClient 없음', '쿠키를 꺼둠', 'JS 비활성'을 원인으로 **재차 주장 금지**. 재빌드하면서 동일 설정만 추가하는 무의미한 재시도 금지.
- 문제를 좁히는 **유력 미검증 가설**: 공개 네이버 PC지도를 여는 이유로 WebView `setUserAgentString`을 `Mozilla/5.0 (Windows NT 10.0; Win64; x64)... Chrome/131.0.0.0`으로 강제함. 실제 Android WebView 및 다른 클라이언트 힌트, 독립 쿠키 저장소의 차이가 공식 네이버 로그인 리스크 탐지/인증에 영향을 줄 수 있음. 로그인 요청·CAPTCHA 제출 서버 응답이나 JS 오류를 수집한 증거는 없으므로 원인 확정 불가.
- 네이버 공식 고객센터 [자동입력방지 안내](https://help.naver.com/service/5640/contents/1024?lang=ko&osType=COMMONOS)는 과거 아이디·비밀번호 오류 누적, 잘못된 자동완성 입력, 기기·네트워크 장애 등을 가능한 이유로 제시. **사용자 계정에 비밀번호 오류가 있었다고 단정 금지**. 기존 모바일 브라우저에서 정상이었다는 사용자 보고와 충돌하지 않도록 계정 단정 대신 임베디드 환경 비교 우선.
- 다음 작업의 안전한 한 변수 비교: 네이버 로그인 시에만 별도 앱 소유 WebView를 **실제 기본 Android UA**로 새로 띄우는 인증 UI 연구를 하되, 웹사이트 자체 보안장치·확인문제를 우회/자동풀이하지 않고, 개인 식별정보·쿠키·토큰·보안답·요청본문을 수집/기록하지 않음. 브라우저 인증 UI 동작과 실제 계정 저장 성공은 독립 게이트. 필요 시 정상 시스템 브라우저 Custom Tab으로 수동 로그인하는 접근을 제공하되 **시스템 브라우저 쿠키는 MOA WebView로 자동 전송/공유되지 않음**, 무음·비점유 백그라운드 저장의 해답인 것처럼 소개 금지.
- **현재 상태**: R279 실기기 추가 인증 진행 **FAIL/OPEN**, 네이버 로그인/장소·리스트·별명·메모 저장 및 독립 계정 조회 전부 미확인. R279/R281 기존 서명·설치 파일은 재발급 없이 그대로 보존, 사용자 R269 원본 Golden APK SHA256 `c0663e65aac2b72feb86cb0f1ba5eac448b6599c3850858de4d942f2aa446920` 불변. 로그인 실패 반복이나 사용자 보안설정 해제·강제 비밀번호 변경을 요청하지 않음.


---

## 11. R283 — 공식 로그인 Android 기본 UA 한정 전환, R285/R287 순방향 복구
**작성일 2026-11-11 KST. R279 실기기 영수증 추가인증 실패를 해결하기 위한 설치형 후보. 실제 본인 인증 성공/서버 쓰기는 아직 NOT PASS.**

1. **수정 원인 가설 (확정 아님):** R279 MOA-owned WebView는 Android 단말인데 `Windows NT 10.0; Chrome/131` 고정 UA로 네이버 PC 지도와 공식 `nid.naver.com` 로그인을 함께 열었다. NAVER 보안 챌린지 반응 실패 원인이 이 불일치인지 미검증. 기존 쿠키/JS/DOM/WebChromeClient 활성화 상태는 유지.
2. **R283 엄격한 최소 수정:** 기존 사용자가 눌러 여는 공식 지도 `map.naver.com` 상위 문서는 PC UA를 유지하고, **오직 https://nid.naver.com 공식 HTTPS 호스트의 인증 메인 프레임** 탐지 시 `WebSettings.setUserAgentString(null)`을 사용해 기기 자체 Android WebView 기본 UA로 되돌린다. 인증 중인 로딩을 한번 중단한 뒤 *기존 받은 공식 URL 그대로 한 번* 재개한다. `shouldOverrideUrlLoading`에서 먼저 처리하고, redirect가 이를 건너뛰면 `onPageStarted`로 보완. WebViewClient 안의 `nativeAuthUaSelected` boolean으로 같은 세션 중 재실행 루프 방지. `NAVER_AUTH_NATIVE_ANDROID_UA_MANUAL_ONLY` 상태는 **정보표시만 하며 인증/저장 성공이 아님**.
3. **보안/개인정보:** 로그인 폼/영수증 문제 내용/비밀번호/OTP/쿠키/개인 데이터 탐지·전송·로그 없음. `nid.naver.com` 페이지에는 기존 진단용 JS를 실행하지 않음. 공식 로그인, 사용자가 직접 인증. CAPTCHA 자동 해결, 쿠키 복사, 비공개 API, 보안 우회 없음. 정상 앱 데이터/IDB/사진/M4A 삭제 없음. 승인하지 않은 자동 저장 없음.
4. **같은 서명 설치 가능 후보:** `MOA_R283_OFFICIAL_NAVER_ANDROID_UA_LOGIN_BETA.apk` 8,916,258 B, SHA256 `f6391c3d388f10438b0366c587f64e95a133d268920320bd5939b835eb76cff0`, package `com.juhyeon.familyjournea` versionCode283, 원본 인증서 SHA256 `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`. R279 대비 바뀐 비서명 엔트리는 **AndroidManifest.xml / classes13.dex / assets/web/moa-r231-settings.js 세 개뿐**. R279의 기존 R269 복귀 DEX/classes2.dex/classes6.dex, 사진/음성/갤러리/일기 등 다른 앱 내용은 바이트 동일.
5. **순방향 복구 (미검증):** `MOA_R285_RECOVER_TO_R279_FEATURES.apk` code285 SHA256 `08982e3d50ca3c875e2a2628f5ae4a82583444087b784999e9e3ffb540dd4d56`는 기존 R279 기능 재현 후보; `MOA_R287_EMERGENCY_R269_FEATURE_EQUIVALENT.apk` code287 SHA256 `2317ed5a97a548ac6c6b08ffad12186fdc76726a2f393be506ea7ec80b427a19`는 R269의 *보관된 복귀 패치*를 R265 원본에 적용한 기능 동등 후보. 둘 다 실제 사용자 지정 **정확한 R269 골든 바이너리**가 아니고 실기기 QA 전; 앱 삭제/데이터 초기화/서명 변경/버전 다운그레이드 금지.
6. **현재 정적 검증:** apktool 2.12.1 재컴파일 PASS; 원본 v2 APK 인증서/ZIP 정렬·CRC/16 DEX SHA-1+Adler32/바이너리 패키지·버전/JS Node syntax PASS. R283 대비 R279 비서명 변경 엔트리 정확히 세 개; `nid.naver.com` host+HTTPS 정확 비교, 공식 인증 URL 1회 재개 설계 소스 확인 PASS. Android 공식 WebSettings 문서에 따르면 UA 교체 중 추가 페이지 로드가 일어날 수 있으므로 `stopLoading` 후 1회 명시적인 재개 및 보호 플래그로 대응.
7. **절대 경계:** 위 정적 PASS는 NAVER 로그인/영수증 확인/인증 서빙/지도 서버 계정 저장/리스트 생성/별명·메모/readback/갤럭시 R283 구동 성공을 의미하지 않는다. 온라인 서비스 정책으로 비내장 브라우저 로그인이 거부될 수 있음. 안 되면 동일 보안문제 입력 반복 금지, 사용자 공식 네이버 앱/Chrome 로그인 확인 후 네이버 공식 지원 문의. 새로운 Android WebView 테스트는 실제 Galaxy에서 사용자 참여로 1회 시도 후 판정.
8. **프로젝트 보호:** 사용자 지정 R269 Golden code269 SHA256 `c0663e65aac2b72feb86cb0f1ba5eac448b6599c3850858de4d942f2aa446920`, R227 Golden, AirPods/AndroidAuto 프로젝트 모두 불변. 본 기록은 **Golden 부록 문서에만 추가**. R283/R285/R287 서명키는 비공개 Library/로컬에서만 사용했고 공개 GitHub에 저장하지 않음.

**다음 실제 기능 게이트:** (가) Galaxy R283 기존 기능 회귀 + 실제 로그인 화면 확인 → (나) Android UA 인증 정상 여부 → (다) 사용자 본인 공식 로그인 1회 → (라) 같은 MOA 앱으로 인증 쿠키 지속 → (마) 정확한 장소 SID/리스트/별명/메모 쓰기와 별도 재조회. 현재 (가)~(마) 미검증.

- **동일 APK 포함 ZIP 검증:** 현재 대화 산출물 `MOA_R283_NAVER_ANDROID_UA_BETA_AND_RECOVERY_20261111.zip` 19,353,452 B SHA256 `978a47a53b27c20b73099c4399f6ffd498dba9e6f1bb2b93881bc1e2640d4e5f`. 정확히 동일 바이트 R283/R285/R287 APK 3개와 정적 QA JSON, 한국어 설치·복구 안내, 공개 가능한 소스 패치 1개를 포함. ZIP CRC PASS, 각 내부 APK SHA-256이 단독 파일과 동일. 개인 서명키·비밀번호·네이버 개인정보는 ZIP에 없음. **사용자 실기기 로그인 성공은 여전히 미검증**.


---

## 12. 2026-11-11 Galaxy R283 실제 네이버 로그인 사용자 PASS + 다중 장소 동적 저장 버튼/비점유 검증

### 새로운 최우선 실제 사용자 증거
- 사용자 본인 Galaxy에서 기존 R283 `MOA_R283_OFFICIAL_NAVER_ANDROID_UA_LOGIN_BETA.apk`를 업데이트 설치하고 공식 네이버 추가 인증을 통과하여 **“드디어 로그인됨”**이라고 직접 보고. 비공개 사용자 첨부 `20190.png`, `20192.mp4`, `20193.mp4`가 함께 제공됨. 이 보고는 R275/R279 로그인 불가보다 우선하는 **R283 실기기 LOGIN USER PASS (보고 범위)**. 영상이나 실계정 개인 정보·인증정보는 GitHub에 게시하지 않음.
- 공개된 `20190.png` 화면에는 MOA 로그인 진단 영역 `VISIBLE_DESKTOP_PAGE_FINISHED_UNVERIFIED` 아래 네이버 모바일 첫 화면이 표시됨. **로그인 후 네이버 홈 표출과 지도 탭에서 실제 로그인 쿠키 유지/즐겨찾기 서버 쓰기는 별도 검증**. 위 상태 문자열도 구형 진단 라벨이어서 로그인 성공/실패 판정으로 사용 금지.
- 사용자 실기 추가 요구: 검색 결과가 여러 주소/장소를 표시하면 위치와 레이아웃에 따라 실제 **장소별 즐겨찾기 저장 버튼의 좌표가 달라짐**. 고정 화면 좌표/목록 첫 항목 강제 클릭은 위험. 장소 SID를 먼저 정확히 확인하고 해당 장소 상세 프레임의 실제 `a[data-nlog-area="map_btp.save"]`만 대상으로 제한. SID 불일치/다수 모호/DOM 미완성/좌표 화면 밖/저장 여부 미확정이면 **누르지 않고 정지**해야 함.

### 2026-11-11 별도 연구 브랜치 실제 작업
- `research/moa-r269-webview-kvm-frame-gate-20261110`에 `experiments/moa-r269-android-webview-frame-test/moa_naver_dynamic_save_gate.js` 및 `test_dynamic_save_gate.cjs`를 추가함. 안전한 exact SID 분류, 여러 검색결과, 잘못 열린 장소, 중복 버튼, 저장목록 이동 메뉴와 실제 장소 저장 버튼 구분, 숨김/비활성/이미 저장된 상태, 인증 미검증 등 거절 게이트를 각각 테스트.
- 이어 `moa_naver_frame_geometry_gate.js`와 `test_frame_geometry_gate.cjs`를 추가함. **실제 장소 iframe 내부 버튼 중심좌표 → 지도 부모 iframe의 실측 위치·크기 → 해당 앱 WebView의 물리 픽셀**을 동적으로 계산하는 순수 함수. 모든 DOM 상태/화면 변환은 현재 프레임에서 재측정, 고정 좌표 없음, 각 단계 SID·first-party 출처·프레임 유일성·가시 영역·width/height 확인, 실패시 무조건 동작 중단. 이 파일들은 **사용자 앱에 아직 통합되지 않은 연구용 코드**.
- `.github/workflows/moa-r283-semantic-place-selector.yml`로 위 테스트와 **무로그인 공개 네이버 검색** 두 레이아웃을 비교함. 첫 run [42876527239](https://github.com/yooogillycloud123/family-journey-personal/actions/runs/42876527239) CI SUCCESS: 1차 SID 안전 분류 Node 테스트 + 공개 지도 두 검색 화면 Chromium 로딩 확인. 단, 일반 검색 결과에서 **링크에 SID가 직접 노출되지 않아 `distinctSids=0`**으로 확인됨. 따라서 검색 결과 목록을 URL만으로 바로 식별·저장 가능하다고 주장 금지, 해당 장소 상세 프레임에서 정확한 SID 확인이 선행되어야 함.
- 이어 위치 이동/확대축소/모호한 iframe/iframe이 화면 바깥인 경우의 계산 테스트를 워크플로에 추가. **해당 새 CI의 실제 통과 여부는 별도 결과 확인 전 PASS로 기재 금지.** 인증정보/쿠키·비밀번호/OTP·개인 자료를 공개 CI에 넣지 않음.

### 기술적 비점유 목표와 현 상태 엄격 분리
- 기존 무로그인 Android35 실험은 MOA 모의 전경을 터치 가능하게 둔 채 **자기 앱 내부 WebView에 native ACTION_DOWN/UP → 실제 first-party DOM `isTrusted=true`** 발생을 증명했음. 이는 비점유 방식의 기반을 보여 주지만 **Galaxy 개인 로그인 세션에서 같은 방식으로 네이버 서버 즐겨찾기를 쓰고 재조회한 PASS는 없음**.
- 다음 필수 관문: (1) R283 갤럭시 Map 복귀 후 세션 유지 → (2) 정확한 SID/실제 장소 저장 버튼 유일성 확인 → (3) 사용자 승인 아래 네이버 1건 저장 → (4) 같은 앱에서 실제 리스트·별명·메모 설정 → (5) 서버 계정의 별도 재조회 → (6) 모아 전경을 유지한 채 동일 엔진 재시험 → (7) 기존 사진/일기/바로기록·오디오·복귀 회귀.
- **지금 로그인 성공만으로 ‘비점유 자동저장 최종 완성’이라고 하면 안 된다.** 프레임 좌표/서버 저장 미확인, 실제 Galaxy에서 테스트해야 함.
- 기존 원본 R269 code269 user-designated GOLDEN SHA256 `c0663e65aac2b72feb86cb0f1ba5eac448b6599c3850858de4d942f2aa446920` 및 R227 Golden, 기존 데이터·원래 서명은 완전 보존. 이번 Golden 변경은 이 연구 결과를 설명하는 **문서 추가만**.


---

## 12. 2026-11-11 R283 실제 로그인 유지와 R289 비점유 저장 실험 베타

- **실기기 직접 증거:** 사용자 영상 20192.mp4/20193.mp4에서는 R283 계정 로그인 유지, 네이버 저장 리스트 열기, 주소별 별명·메모 편집, 저장 후 초록색 별표 표출 확인. 실제 계정의 독립 저장 데이터 재조회 여부는 별도 미검증. 영상/개인 주소·이메일·계정 화면은 GitHub에 게시하지 않음.
- **R237 WebView 쓰기 엔진의 실제 결함 수정:** 기존 출처 정규식은 pcmap.place.naver.com/pages.map.naver.com의 2단계 서브도메인을 허용하지 않아 frame 명령이 막힐 수 있었다. HTTPS map.naver.com, pcmap.place.naver.com, pages.map.naver.com만 정확히 허용하며 네이버 외부 광고 iframe에 개인 alias/memo/address를 메시지로 보내지 않음.
- **대상·입력 안전:** 새로운 실제 장소 Save 속성(data-nlog-area) 및 이전 셀렉터 동시 지원. 단일 정확 SID/unsaved 상태 아니면 클릭하지 않음. 주소와 상호를 구분하고 복수 검색결과·복수 Save 컨트롤에서는 중단. React 입력 setter 사용. 원래 R237 메모 제한 50자를 초과할 때 잘라 버리지 않고 요청 중단.
- **옵트인:** 기존 MOA 설정에 '모아 화면 비점유 저장 실험 (직접 누를 때만)'을 추가하되 기본 OFF. OFF에서는 기존 R283/네이버 전경 저장 경로 보존. ON일 때 사용자가 기존 사진 GPS 저장을 눌러야만 같은 모아 앱의 숨김 WebView와 phone_submit 엔진에 전달. 숨김 브라우저 연결/정확한 대상 없으면 중단하고, readback 성공 전 상태를 PENDING으로 유지.
- **R289 설치 후보:** MOA_R289_OFFSCREEN_TARGET_SAFE_TEST_BETA.apk, 8,907,764 bytes, SHA256 3217857e08c3e966e8f1772767098b3ba475848f652cd9f5fa5ef5a07a8cdcb7. 패키지 com.juhyeon.familyjournea versionCode 289, 기존 인증서 SHA256 5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15, APK v2/zipalign/ZIP CRC/16 DEX checksum/JS 구문 PASS. R283 대비 정확히 4 non-signature ZIP payload 변경: AndroidManifest.xml, assets/web/fj-naver-favorites.js, assets/web/moa-r231-naver-frame-probe.js, assets/web/moa-r231-settings.js. 모든 16 DEX 및 다른 파일은 바이트 동일.
- **순방향 복구 후보:** MOA_R291_RESTORE_R283_ORIGINAL_FEATURES.apk SHA256 cb284471d6cb8a8c233c64fce91ec8cbcc4b36ca434b32d8bb561372a0e0fe73, versionCode 291, R283 대비 manifest versionCode만 변경. 실제 R269 Golden 바이트 복제 아님. R291 실기기 복구 QA는 아직 미수행.
- **동봉 ZIP:** MOA_R289_OFFSCREEN_SINGLE_APP_TEST_WITH_R291_RECOVERY_20261111.zip SHA256 4d3433b2ae89b494ba00a9e6b7d81aa15bdb1aa11dea002fac9227b7175c2119, 12,883,399 bytes, signed APK 둘·QA JSON·source diff·가이드·5개 합성 테스트 증거. 암호/키/계정/개인 영상 포함 없음.
- **합성 테스트 PASS 5건:** 잘못된 SID 클릭 거부, 다중 저장버튼 클릭 거부, 단일 SID/버튼 UI 요청 후 UNVERIFIED 유지, 상태 메시지 송신 origin 엄격 확인, 동일 주소 결과 중복 시 임의 첫 행 클릭 거부.
- **주의:** 사용자 실제 Galaxy R289 비점유 자동 쓰기 및 네이버 서버 리스트/장소/별명/메모의 독립 readback은 아직 미검증. R289를 FINAL/Golden으로 승격하지 말 것. 기존 R269 사용자 지정 Golden SHA256 c0663e65aac2b72feb86cb0f1ba5eac448b6599c3850858de4d942f2aa446920, R227, AA/AirPods 코드·사용자 데이터·서명은 변경하지 않음. 앱 제거/데이터 초기화/강제 다운그레이드 금지.
- **연구 인수:** https://github.com/yooogillycloud123/family-journey-personal/blob/research/moa-r269-webview-kvm-frame-gate-20261110/MOA_R289_OFFSCREEN_TARGET_SAFE_HANDOFF_20261111.md


---

## 13. 2026-11-11 R289 실제 비점유 요청 대기·R293 네이티브 웹 경로 진단 수리

- 사용자 실기기 동영상 20209.mp4/20210.mp4 재검토: 20210에서 설정 토글은 일기 이동 전 ON이었고, 20209 일기 저장 상태 '요청 대기(QUEUED)'는 비점유 phone_submit 작업 접수의 직접 화면 증거. 먼저 축소된 접촉표를 보고 스위치가 OFF라 판단한 것은 오류로 정정. 사용자가 제공한 영상을 GitHub에 게시하지 않음.
- 20210의 '3분 안에 저장을 확인하지 못했습니다' 메시지는 기존 접근성 네이버 전경 워커 TIMEOUT에 해당. 이전 요청에서 늦게 온 알림일 수 있어 이번 비점유 작업과 동일 job이라고 단정 금지.
- R289 원본 smali MoaNaverPhoneWorker.submit은 존재하는 WebView 객체만 확인하고 QUEUED_IN_MOA_PHONE 반환. UI thread lambda$deliver$0은 현재 페이지가 top map.naver.com인지 확인 없이 private task를 window.postMessage()로 보냈음. 허용 지도 document-start listener가 없을 수 있는 로그인/네이버 홈 화면에서는 실제 전달 없이 QUEUED만 남을 수 있다는 **소스로 확정된 설계 결함**. 사용자가 실제 어떤 페이지에 있었는지는 영상에서 증명 불가.
- **R293 수리 베타:** MOA_R293_OFFSCREEN_ROUTE_GUARD_DIAG_BETA.apk SHA256 da2ce84c0bbc882b6ebeb0a401bdac1ee2eb9c65830b3a2999b16efedd2b3fd3, package com.juhyeon.familyjournea code293, original cert 5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15, 8,907,764 B. 네이티브 UI thread에서 WebView.getUrl 확인 후 HTTPS map.naver.com/ 페이지가 아니면 NAVER_PAGE_NOT_READY로 즉시 차단. 일기 GPS 카드에 비점유 저장 실험 / 기존 네이버 저장 별도 버튼을 만들고 각각 별도 명시적 route 전달해 설정 localStorage 불일치·늦은 네이티브 알림 혼동을 줄임. 지도 프레임 ACK 없이 QUEUED 16초 경과 시 WEB_NO_FRAME_ACK로 중지. 계정/쿠키/메모/로그인 비밀정보 출력·수집 없음.
- 정확한 변경 멤버 R289 대비 4개: AndroidManifest.xml, classes14.dex, assets/web/fj-naver-favorites.js, assets/r28-diary-location.js. 나머지 15 DEX와 모든 다른 기존 앱 파일 동일. APKv2 기존인증서/zipalign/ZIPCRC/DEX SHA1+Adler32/JS Node 구문, 기존 5건 mock UI 안전 시나리오와 신규 명시적 web/native 라우트+스레드 map root 검사 PASS. 아직 갤럭시 R293 실기기 네이버 저장 및 서버 readback은 미검증.
- **R295 복구 후보:** MOA_R295_RESTORE_R289_FEATURES.apk SHA256 ef950657b016d6fa998cffe9d8b6ba1882ee1611edb4a40081fcc3d51462d6d3, code295. R289과 비서명 페이로드 차이는 Manifest versionCode 한 개뿐; 동일 인증서/정적 검증 PASS. 사용자 R269 Golden의 바이트 동일 복사본이 아니고 실기기 복구 테스트 미수행.
- 짝 ZIP: MOA_R293_EXACT_ROUTE_DIAGNOSTIC_WITH_R295_RECOVERY_20261111.zip 12,882,508 B SHA256 cf798031a932deb5a1f55c889390065e2306954835b9010255b0fe2958e59ab3. 동일 바이트 APK 2개+QA JSON+문제 범위/테스트 한국어 안내+공개 가능한 소스 diff, 비공개 서명키·사용자 영상 없음.
- R293는 실계정 자동저장 FINAL이 아니라 실패 경로를 **실제 기기에서 더 정확하게 확인할 진단/보수 베타**. 사용자 본인 계정의 실제 즐겨찾기 리스트·주소/SID·별명·메모 저장 및 독립 서버 readback은 OPEN. 20209/20210만으로 서버 실패 이유까지 확정하지 말 것. 앱 삭제·데이터 초기화·다운그레이드·Golden 인플레이스 수정 금지.
- 연구 문서: https://github.com/yooogillycloud123/family-journey-personal/blob/research/moa-r269-webview-kvm-frame-gate-20261110/MOA_R293_VIDEO_CORRELATED_OFFSCREEN_ROUTE_GUARD_20261111.md
- R269 사용자 지정 원본 Golden SHA256 c0663e65aac2b72feb86cb0f1ba5eac448b6599c3850858de4d942f2aa446920, R227, AA AirPods audio 모두 불변.


---

## 14. 2026-11-11 R293 실기기 LIST 실패 확정·R297 전체 뷰포트 보수

- 사용자의 실제 R293 비점유 테스트 20219.mp4/20222.mp4 및 20220.png: 네이버 로그인·기존 전경 저장 기능은 정상, 비점유 일기 카드의 결과는 **[비점유] 네이버 화면이 달라져 저장을 중단했습니다**. 설정 DOM read-only counters는 saveButton1, 저장목록/확인/생성 등 0. 이것은 실제 계정 저장 성공이 아니며 '16초간 무응답'이라고 단정해서도 안 됨.
- 원인 중 확인된 두 가지 소스 설계 결함: (1) R293 첫 phase LIST에서 button.btn_navbar 첫 요소를 선택, 저장목록 iframe 'myPlaceBookmarkFolderListIframe' 고정 가정, 35×550ms 만료 시 NAVER_UI_CHANGED로 광범위하게 반환해 실패 지점을 숨겼음. (2) setHidden에서 네이버 WebView의 shell/holder를 실제 1dp×1dp로 축소해 iframe 전체 렌더링을 보장할 수 없는 구조. 이 두 결함이 각각 이번 실제 저장 실패를 얼마나 설명하는지는 아직 실기기 수정 전/후 비교 필요.
- 별도 공개 공식 네이버지도 라이브 브라우저 CI 42890803638 SUCCESS: 샘플 Place 부모 PC지도에서 button.btn_navbar=7, 표시명이 정확한 '저장' 컨트롤=1, 구형 이름의 저장 목록 iframe=0. 따라서 구형 목록 메뉴 첫 요소/iframe 이름을 절대 진리로 취급 금지.
- 로컬 비공개 original-signer **R297** MOA_R297_FULL_VIEWPORT_LIST_STAGE_REPAIR_BETA.apk, code297, 8,879,092 bytes, SHA256 47317bde99b00b6fc609a0c5ac44835753db2aa80b8c47a1521b7faf80bd9697. 기존 패키지 com.juhyeon.familyjournea/서명 cert 5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15. R293 대비 변경은 정확히 AndroidManifest.xml, classes13.dex, classes14.dex, assets/web/moa-r231-naver-frame-probe.js, assets/web/fj-naver-favorites.js, assets/web/moa-r231-settings.js. **나머지 14 DEX 및 전원 바이트 동일**.
- R297 변경: 숨긴 WebView는 전체 크기 유지, 같은 Activity 내 기존 모아 main content를 앞에 배치하고 hidden WebView는 포커스/클릭/접근성 제외. R237 root 저장 목록 NAV는 기존 button.btn_navbar 첫 요소 대신 공식 DOM에서 단일 '저장' 메뉴 정확 식별; 복수·미확인 컨트롤 클릭 금지; LIST_NAV_NOT_FOUND, LIST_UI_NOT_FOUND로 실제 단계 구분. 불필요하게 중복된 설정 체크박스 제거; 일기 GPS 사진 카드의 비점유 저장 실험/기존 네이버 저장 두 버튼으로 명시적 선택. '지도 웹창 뒤로 보내기'는 표시 기능이지 계정 저장 명령이 아님.
- 정적 QA: Apktool2.12.1 classes13/14 컴파일 PASS, Node JS 3파일 구문 검사, 세 개 synthetic root Save 메뉴 mock (7개 메뉴 중 한 개 정확 '저장' 1탭, 중복/없을 때 0탭), APK v2/기존 서명/zipalign/CRC/16DEX checksum/manifest code297 PASS. **실기기에서 네이버 서버 저장, 리스트/장소/별명/메모 독립 재조회, WebView full viewport 효과 아직 미검증**. 보안 우회·CAPTCHA 자동 처리·쿠키/개인정보 채팅 전송 없음.
- R299 순방향 복구 후보 MOA_R299_RESTORE_R293_EXISTING_FEATURES.apk code299 SHA256 539931f4418bcafdff69f0e11bf9a0a6f46652007161c4c7750d55d041c72851, R293의 manifest versionCode만 변경. R269 Golden 원본 바이트 동일본 아니고 실기기 복구 QA 없음. APK+동일 bytes 복구+QA ZIP MOA_R297_FULL_VIEWPORT_LIST_REPAIR_WITH_R299_RECOVERY_20261111.zip SHA256 9caa7a38f3f32d024adf3d09f7dcddc9c63bd92d45249df61e85a0ffc9956733.
- 상세 인수 문서: https://github.com/yooogillycloud123/family-journey-personal/blob/research/moa-r269-webview-kvm-frame-gate-20261110/MOA_R297_REAL_NAVER_LIST_SELECTOR_AND_FULL_VIEWPORT_HANDOFF_20261111.md. 서명키/사용자 사적 사진·동영상 및 인증정보는 공개 GitHub에 업로드하지 않음.
- R269 사용자 지정 정확한 원본 Golden APK code269 SHA256 c0663e65aac2b72feb86cb0f1ba5eac448b6599c3850858de4d942f2aa446920/기존 AA·AirPods Golden/사용자 일기 데이터 일체 불변. 앱 삭제·데이터 초기화 금지. 실제 NAVER 계정 저장 성공 전 FINAL 주장 금지.


---
## 15. 2026-11-11 R297 실기기 내 장소 중복 생성 위험 확정·R301 신규 리스트 생성 차단
- **실제 Galaxy 영상·사진:** 20233.mp4, 20238.mp4, 20234.png, 20236.png. 네이버 '저장'에 장소 185개가 있는 원래 내 장소와 장소 0개의 동명 내 장소가 여러 개, 앱에는 LIST_CREATE_FAILED가 표시됨. 전체 리스트 68개가 모두 앱에서 생성되었다는 근거는 없음. 사용자의 원본 계정 개인정보·촬영물은 공개 GitHub에 기록하지 않음.
- **R297 실제 소스로 확인된 자동 생성 경로:** assets/web/moa-r231-naver-frame-probe.js list()는 기존 목록을 button[class*="_list_item_"]로만 탐색하다 못 찾으면, 이미 원본 리스트가 있어도 새 리스트 만들기 create.click()→이름 입력→완료를 무조건 시도. 부모 tick은 35×550ms 전달 및 3.6s 재실행, fail(status)은 task/sessionStorage를 해제하지 않아 실패 후 재시도 가능. 이것이 빈 동명 목록 반복 생성과 정합성이 높지만 개별 목록 생성 사건의 확정 로그는 없음.
- **R301 긴급 안전판:** MOA_R301_NO_DUPLICATE_LISTS_SAFE_BETA.apk, package com.juhyeon.familyjournea code301, 8,883,188B SHA256 a86602f99f7b997268b66dbf6ab48ffddafbc85017b11f370d127ec909c2430e. R297 대비 변경 멤버는 Manifest code, assets/web/moa-r231-naver-frame-probe.js, assets/web/fj-naver-favorites.js의 3개뿐, 16 DEX 전부 불변. 기존 원래 서명 cert SHA256 5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15, APKv2, zipalign, CRC, DEX checksum/JS syntax PASS.
- **동작 계약:** 기존 목록이 유일하게 일치할 때만 LIST_READY, 동명 다수면 LIST_DUPLICATE_NAME, 목록을 정확히 찾지 못하면 LIST_NOT_FOUND_NO_CREATE. 신규 리스트 자동 생성 코드 전부 제거; 터미널 오류 시 sessionStorage 작업/반복 timer 대상을 해제하고 child jobId+phase 중복 처리 억제. 4개 mock 시나리오에서 어떤 경우에도 생성 click=0. 네이버 실계정 비점유 쓰기는 미검증이며 현재 동명 목록이 많기 때문에 안전하게 저장이 차단될 수 있음.
- **복구 후보 R303:** MOA_R303_RESTORE_R283_LOGIN_AND_VISIBLE_SAVE.apk code303, 8,879,195B SHA256 abb406ed187bd7d9f7647ca31db7397ad7523df004a859d84e0cfa2915529a22. 이전 실제 Galaxy 인증/전경 저장에 성공했던 R283 기능을 versionCode만 증가해 순방향으로 유지하는 후보. R269 정확 바이너리 골든 아님, R303 실기기 복구 미검증.
- **전체 백업 ZIP:** MOA_R301_DUPLICATE_LIST_SAFE_BETA_AND_R303_RECOVERY_20261111.zip, 12,828,447B SHA256 b7da1b1dc6c0216db3d447fd884f5e760e7bd42dbdab832fc90f1485c447978b. R301/R303 byte-exact APK와 QA/sanitized source patch/mock tests/한국어 안내 포함, 계정·미디어·키 없음.
- **PC 코드 재활용 경계:** 사용자는 최근 PC 주소검색→네이버 즐겨찾기/메모/별명 저장 실제 성공을 보고. 과거 산출물명 '주소지자동저장 파이썬.zip', '출장지(초고속버전+자동로그인+구동버전+최고버전).py', '사진지도부동산_ONEQUEUE.py'의 정확 원본은 현재 Files/GitHub에서 찾지 못했으므로 재사용했다고 주장할 수 없음. 별도 R235 PC Playwright+SQLite 연구에는 UUID 중복방지/고유목록 확인/readback 설계가 있지만 실계정 저장 PASS는 해당 R235 문서상 미검증.
- **다음 관문:** 동명이 존재하는 기존 185개짜리 진짜 목록의 first-party folder/shareId를 사용자가 명시적으로 선택·고정하는 read-only 도구가 필요. 이름만으로 첫 번째 일치 클릭 금지, 새 목록은 명시적으로 새 리스트 만들기 요청과 idempotent 사전 조회에만 허용. 별명/메모/장소 정확 읽기 재확인 전 FINAL 주장 금지. 사용자의 수십 개 빈 폴더는 확인 전 자동 삭제 금지.
- **상세 인수:** https://github.com/yooogillycloud123/family-journey-personal/blob/research/moa-r269-webview-kvm-frame-gate-20261110/MOA_R301_DUPLICATE_MY_PLACE_LISTS_FORENSIC_AND_SAFETY_HANDOFF_20261111.md
- R269 사용자 지정 Golden 원본 SHA256 c0663e65aac2b72feb86cb0f1ba5eac448b6599c3850858de4d942f2aa446920, R227, AA AirPods/Android Auto audio source, 사용자 일기·사진·M4A 데이터 모두 불변. 앱 삭제·초기화·서명변경 금지.
