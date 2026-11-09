# MOA → 네이버지도 **화면 비점유 즐겨찾기** : 실행 엔진 R1 (2026-11-10)

> **소스·로컬 자동화 테스트 PASS / 실제 네이버 계정 저장 미검증 / MOA APK 미통합.**
>
> 네이버 앱 화면을 사용자 휴대폰에 띄우지 않고, 별도 사용자가 소유한 컴퓨터에서 네이버 PC 웹 저장 UI를 자동 처리하는 독립 컴포넌트다. Shizuku, 루트, 휴대폰 보조 APK는 사용하지 않는다. **다만 PC가 켜져 있고 브라우저 로그인 세션을 유지해야 한다.** 휴대폰 단독 오프스크린 방식의 완성으로 홍보하지 않는다.

## 구현된 기능(코드+오프라인 모의검증)

- FastAPI 개인 작업함: `POST /v1/favorites` 요청에 대한 인증, UUID 중복 방지, SQLite 영속 대기열
- 수신 즉시 **QUEUED**, 브라우저 처리 중 **WORKING**, 네이버 목록에서 실제 동일 리스트/장소 재조회 일치했을 때만 **NAVER_READBACK_VERIFIED**
- 브라우저 자동화: Windows 전용 프로필의 Playwright Chromium(headless), 계정 로그인은 *최초 PC 브라우저에서 사용자가 직접 수행*, 웹 프레임의 `새 리스트 만들기` → 비공개 선택 → 목록 생성 확인 → 장소 검색 → 복수 후보면 보류 → 별명·메모·리스트 선택 → 저장
- 저장 후 사용자 소유 브라우저 세션으로 읽기 전용 목록 JSON을 재조회해 장소 ID 또는 엄격한 이름+주소 조합 확인(내부 읽기 URL은 공식 API가 아니므로 변경 가능). POST/PATCH 내부 비공개 API를 직접 호출하거나 `ncaptcha`를 우회하지 않는다.
- Windows 호스트가 꺼져도 모바일 작업을 잃지 않도록 **MOA 측 로컬 outbox** 연결을 위한 `android_integration/MoaNaverBackgroundClient.java` 컴파일 확인(이 파일은 아직 설치 APK에는 포함되지 않음).
- 암호화 통신을 위한 별도 LAN HTTPS 인증서 생성 스크립트; 안드로이드 네이티브 연결 샘플은 인증서 SHA-256 핀 + 24자 이상 비공개 토큰 사용. 데몬 기본은 **127.0.0.1 전용**, LAN 바인딩은 인증서 없으면 실패.

## 실제 실행 방법(Windows PC에서만; 아직 R233 MOA 앱 버튼에 자동 연결되지 않음)

1. 컴퓨터에 Python 3.11+ 설치. 이 폴더에서 `python -m pip install -e .` 및 `python -m playwright install chromium` 실행.
2. `python -m moa_naver_bridge.cli login` 실행 → **본인 컴퓨터의 별도 Chromium 프로필**에서 **네이버 사이트에 직접 로그인** → 콘솔 Enter. 쿠키·암호를 MOA나 서버로 옮기지 않는다.
3. `python -m moa_naver_bridge.cli token`으로 비공개 인증 토큰 생성·보관.
4. `python -m moa_naver_bridge.cli serve` 실행 (기본 `127.0.0.1:8765`).
5. PC 로컬 API 테스트는 본인 장소명·주소, UUID로 명시적으로 요청. 잘못된 장소가 저장되는 사고를 피하려면 **개발 시험용 더미 주소를 실제 네이버에 저장 요청하지 말 것**. UI 후보 미확정 시 `AMBIGUOUS_PLACE`로 보류. 첫 실제 저장은 사용자 승인 후 운영한다.
6. 실제 MOA에서 보내려면 후속 **동일 서명 APK에 `MoaNaverBackgroundClient` + 원래 위치정보 화면 연결 + 모바일 내 영속 Outbox** 패치를 추가해야 한다. 이 ZIP 자체는 **휴대폰 설치 APK가 아니다.**

## 네이버 앱 로그인을 그대로 가져올 수 없는 이유

Android의 네이버지도 앱 UID와 PC Chromium 프로필은 다른 세션이다. 다른 앱 인증 쿠키를 추출하거나 재사용하지 않는다. **PC 최초 로그인만 별도로 필요**, 로그인 세션 만료 시에는 사용자가 PC에서 재로그인. 이후 웹 브라우저는 숨김 실행할 수 있고 휴대폰 화면은 MOA 그대로 유지된다.

## 현실적 제약과 다음 Gate

1. **실제 네이버 계정에서의 목록 생성 → 장소 저장 → 읽기 재검증은 아직 미시험.** GitHub 공개 코드 `dayeonisme/navermap-converter`도 CSS 선택자 최신 네이버 실화면 확인을 숙제로 남겼다. 이 저장소는 무라이선스이므로 코드를 복사하지 않고 별도로 개발했다.
2. 네이버 UI 선택자가 바뀔 수 있고, CAPTCHA/인증이 생기면 **사용자 직접 해결 대기**; CAPTCHA를 자동으로 우회하지 않음. 내부 목록 GET이 바뀌면 `SUBMITTED_UNVERIFIED`로 남김.
3. PC가 꺼져 있거나 인터넷이 없으면 네이버 실계정에 즉시 저장은 불가능. 목표 기능을 포기하는 게 아니라 **로컬 outbox에 보관하고 PC/사용자 소유 항상 켜진 서버가 켜질 때 전송**하는 구조로 확장한다. 집 PC를 켜두지 않아도 되는 선택지로 프라이버시 동의 기반 개인 VPS/가정 NAS/Windows 작업 스케줄러/향후 별도 Android 내 브라우저 엔진을 비교한다.
4. 휴대폰 화면 점유 0, 네이버 리스트 자동 생성과 진짜 서버 반영 1건의 **실계정 종단간 PASS**가 다음 승격 조건이다. 현재는 독립 PC 브라우저 자동화/대기열 프로그램의 **로컬 테스트 PASS**만 확인됐다.
5. 주 사용자 골든: R227 절대 수정 금지. R229/R231의 사용자 확인 `↶ MOA` 원래 사진 복귀 기능 보존. R233 내장 WebView **기기 FAIL**이며 이 엔진이 이를 고쳤다는 주장 금지.

## 보안

`~/.moa-naver-background/browser-profile`은 개인 로그인을 가진 로컬 전용 폴더. `bridge-token.txt`, `jobs.sqlite3`, TLS 개인키도 개인 PC에서만 관리하고 GitHub·클라우드·스크린샷에 올리지 않는다. 별도 LAN 접근은 반드시 HTTPS 인증서+키/Android 인증서 핀/인증 토큰이 함께 설정되어야 한다. 임의 원격 서버에 자격증명을 업로드하지 않는다. 작업 JSON에는 사진 원본·녹음·일기가 포함되지 않고 장소명/주소 등 필요한 최소 데이터만 보낸다.

## 근거

- 네이버 고객센터 저장/리스트는 네이버 계정 로그인 기반: https://help.naver.com/service/5637/contents/692?lang=ko
- 네이버지도 PC 웹 자동 저장 공개 사례(실화면 선택자 변경 확인 필요): https://github.com/dayeonisme/navermap-converter
- 읽기 API/쓰기 ncaptcha 제약을 보고한 개인 연구 사례: https://saramjh.github.io/naver-map-save-list-bulk-reorganize-guide/
- Playwright 로그인 상태 지속: https://playwright.dev/docs/auth
- Reddit에서 화면 오프·타 앱 자동화를 위해 ADB/root가 필요했던 사례: https://www.reddit.com/r/tasker/comments/12bcdnj/project_share_turn_display_onoff_dont_disturb/