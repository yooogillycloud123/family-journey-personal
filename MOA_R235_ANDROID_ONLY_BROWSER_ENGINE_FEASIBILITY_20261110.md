# MOA Android 단독 화면 비점유 네이버 실계정 자동저장 — 독립 기술 트랙 (2026-11-10)

## 사용자의 최종 목표 유지

- **스마트폰 단독**, Shizuku/루트/ADB/추가 도우미 앱 없음.
- MOA를 떠나거나 네이버지도 전체화면으로 전환하지 않고 실제 네이버 즐겨찾기·메모·별명·신규 리스트 저장.
- 1건씩 실제 네이버 계정 재조회 후에만 완료 표시.
- 갤러리→네이버지도 기존 외부 보기 및 사용자 검증 `↶ MOA` 한 번 탭 복귀 유지.
- 2026-11-10 현재 위 조건 전체 동시 PASS **미달성**. PC 브라우저 R1은 그 자체로 최종 버전이 아니다.

## 현재 근거로 좁힌 Android 단독의 세 가지 탐색 경로

### 트랙 S1: MOA APK 내부에 독립적인 **완전한 브라우저 엔진** 포함

기존 Android WebView R231 앱 설치 랜딩→R233 redirect loop **실기기 FAIL**과 달리, Firefox 엔진 GeckoView는 자체 브라우저 엔진을 앱에 포함한다. `GeckoSessionSettings.USER_AGENT_MODE_DESKTOP`/`VIEWPORT_MODE_DESKTOP`을 사용해 네이버 PC 지도 UI 접근성을 확인하고, 성공 시 사용자 직접 네이버 웹 로그인(네이버 앱 세션 직접 공유 아님)→새 리스트 생성→POI 저장→읽기 재검증→렌더러 숨김 상태 지속 동작까지 실증한다. 단, 네이버 고객센터는 **Firefox를 정식 지원 환경으로 안내하지 않으므로 실패 가능성을 분명히 전제**한다. GeckoView의 추가 앱 용량·메모리 부담도 평가해야 한다.

### 트랙 S2: 자체 서명 MOA APK에 Chromium 네이티브 런타임을 **라이브러리로 패키징**

Android에서 별도 Chromium/Termux 브라우저를 무루트로 headless 실행하는 공개 프로젝트가 존재한다. 그러나 Termux 같은 별도 앱을 설치하라는 요구는 사용자의 조건과 다르다. 더구나 Android 10(API 29)+ 타깃 앱은 앱의 **쓰기 가능한 홈 디렉터리 바이너리를 execve로 실행할 수 없는 W^X 제약**이 있다. `filesDir`에 `chromium` 실행 파일을 다운받아 `ProcessBuilder.exec`하는 단순 구조는 현재 MOA에 맞지 않는다. 따라서 Android NDK·APK 내 네이티브 라이브러리 코드 패키징/지원 ABI/공용 라이브러리 의존성/런타임 프로세스 정책을 먼저 검증해야 한다. **앱 목표 SDK를 28로 낮춰 정책을 우회하지 않는다.** 실제 네이버 PC 웹 접속→로그인·리스트 UI 확인 전에는 전체 Chromium 수십~수백 MB를 기존 앱에 합치지 않는다.

### 트랙 S3: 휴대폰 단독 UI + 항상 켜진 **사용자 소유 개인 브라우저 워커**

PC R1 엔진과 같은 API를 개인 NAS/VPS/사용자 관리 서버에서 실행한다면 집 Windows PC를 켜두지 않아도 MOA에서 저장 버튼을 누른 뒤 **휴대폰 화면이 다른 앱으로 전환되지 않는** 작업은 가능할 수 있다. 그러나 서버 로그인 세션 보호, 사용자의 동의, 지속 비용, 실계정 네이버 브라우저 접근·CAPTCHA, 종단간 암호화, 원격 접속 인증이 요구된다. 사용자가 원하지 않는 외부 클라우드에 가족 GPS/네이버 세션을 저장하지 않는다. 여전히 **엄격한 네트워크 없는 휴대폰 단독 처리와 동일하지 않다.**

## 공통 엔진과 기능 보호

- `placeRecord`/outbox: 기록 저장 즉시 `QUEUED`, 해당 기기 사진/일기 원본 영향 0.
- `NAVER_READBACK_VERIFIED`는 실제 사용 계정 대상 리스트에 POI 동일성 확인 후에만.
- 1회 사용자 동의(최초 로그인), 리더·라이터 분리, CAPTCHA·로그인 만료 시 승인 대기, 메모 50자/별명25자 제한, 중복 방지.
- 애매한 검색 후보는 자동 선택 금지. GPS는 네이버 POI ID가 아니며 사진의 MediaStore ID도 네이버 장소 ID가 아니다.
- 정식 후보 S1/S2를 개발해도 **외부 지도보기 + `↶ MOA` 사용자 확인 PASS** 기능은 절대 삭제하지 않는다.

## 다음 실증 게이트

0. 후보 엔진 자체의 별도 브랜치·샌드박스 테스트(일기/갤러리 기존 패키지 변경 0).
1. S1 GeckoView/ S2 Chromium 엔진으로 `https://map.naver.com/p/` PC 지도 화면이 **실제로 열리는지** 확인. redirect/앱 설치 안내면 바로 FAIL, 반복 APK 사용자 강요 금지.
2. 지도 저장 리스트 iframe 접근, 계정 로그인 유지, 실제 POI 조회.
3. 동의한 목록 1개 생성 및 장소 1건 저장 후 실제 네이버 목록 재확인.
4. 동일 휴대폰에서 MOA 스크롤·녹음·갤러리 계속 사용하는 동안 10회 비점유 저장, RAM/배터리/CPU 측정, 나머지 기능 회귀 0.

## 출처

- Mozilla GeckoView: https://mozilla.github.io/geckoview/
- Mozilla desktop user agent/viewport: https://mozilla.github.io/geckoview/javadoc/mozilla-central/org/mozilla/geckoview/GeckoSessionSettings.html
- 네이버 공식 PC 지도 지원 브라우저 (Firefox 미지원 안내): https://help.naver.com/service/5637/contents/20007?lang=ko&osType=PC
- 무루트 Android Termux/Chromium headless 공개 프로젝트(현 MOA에 설치형으로 곧바로 이식된다는 뜻 아님): https://github.com/aidoctor654-sys/constrained-browser-automation
- Android 10+ W^X execve 제약: https://developer.android.com/about/versions/10/behavior-changes-10