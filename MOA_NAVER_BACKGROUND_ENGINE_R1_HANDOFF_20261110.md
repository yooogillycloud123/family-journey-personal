# MOA: 네이버지도 **실계정 즐겨찾기 비점유 자동화** 재출발 — 실행 엔진 R1 인수인계 (2026-11-10)

## 1. 사용자 목표 절대 하향 금지

사용자가 명시적으로 고집하는 조건: Galaxy S26 Ultra MOA 앱에서 `★ 네이버 즐겨찾기`를 누르면 네이버지도 앱이 사용자 화면을 가져가지 않고 실제 네이버 계정의 기존/자동 신설 리스트에 장소·메모·별명을 저장, 저장 후 실계정 목록 재조회. Shizuku/루트 없음, 다른 APK 다수 설치 없음, 기존 모든 가족 일기·갤러리·바로기록·네이버지도→MOA 같은 사진 1회 복귀 그대로 유지. **PC 의존성, 별도 로그인, 화면 전환이 남으면 이 모든 조건을 만족하는 최종 기능이라고 표시 금지.**

## 2. 기존 영상/골든/실패

- 사용자 기기 R229/R231 네이버지도 위 `↶ MOA` 탭 → 동일 갤러리 사진 복귀 PASS. 보호 필수.
- R233 WebView는 `https://map.naver.com/?app=Y&appmarket=N`에서 `ERR_TOO_MANY_REDIRECTS`, 기기 FAIL. 이전 R231은 앱 설치 유도 모바일 랜딩. 다시 URL/UA만 바꾸는 반복 테스트 중지.
- R227 사용자 지정 골든 APK `com.juhyeon.familyjournea` code227 SHA256 `53c4c04ce32ad13de3c0613f4e5ec7abbc75ccbdfe9db5da05d8fa9b806ec6cd` 불변 유지. R229 PASS APK SHA256 `823bed41210be28b971860c88879bbc43e934793cf9847d1f0cb7e3e4f1cef74`도 소스 회귀 금지.

## 3. 2026-11-10 신규 실증 가능한 발견

- **사용자 소유 PC 브라우저 Playwright**가 네이버 PC 지도 내 리스트 생성/장소 저장 UI를 자동 조작하도록 작성된 공개 저장소 존재: `dayeonisme/navermap-converter` (실제 최신 네이버 UI 검증은 저자도 아직 보류). 무라이선스 공개 소스라 **코드 복사 금지**, API/UI 전략만 참고하여 독립 재구현.
- 네이버 고객센터는 로그인 사용자의 PC 지도 저장과 새 리스트 만들기를 공식 지원하므로 UI 조작 경로는 존재.
- 별도의 개발 기록은 읽기 전용 사용자 목록 JSON 조회와 `ncaptcha token is invalid`를 보이는 쓰기 API 실패를 보고. 비공개 쓰기 API를 억지로 호출하지 않고 **Playwright에서 정상 UI 저장 후 읽기 전용 목록 재검증**이 합리적.
- Reddit Tasker 논의에서도 일반 Android에서 화면 밖 타사 앱 조작에는 ADB/root 등의 높은 권한이 필요한 사례가 있다. 권한을 우회해 네이버 앱의 다른 UID 세션을 훔치는 접근은 금지.

## 4. 실제 구현(공개 소스/비공개 실행자료)

- SOURCE BRANCH: `feature/moa-r235-naver-background-real-favorites-engine-20261110`.
- 경로: `experiments/moa-naver-background-r1/` (Python FastAPI+Playwright Chromium+SQLite, Windows batch, local TLS generator, Android source-only `MoaNaverBackgroundClient.java`, tests).
- CI: [GitHub Actions #42713723957](https://github.com/yooogillycloud123/family-journey-personal/actions/runs/42713723957) **SUCCESS**: 독립 Python 패키지 설치+Playwright mock Chromium 테스트+Android35/Java17 통신 소스 컴파일. 최초 CI 패키징 실패 수정 후 재실행 성공.
- 로컬 검증: `pytest -q` **6 PASS**, PEP517 pip wheel 빌드 PASS, Android SDK35 javac PASS, 21개 파일 소스 ZIP CRC PASS.
- 실제 동작 계약: 로컬 사용자 브라우저에 직접 한번 로그인 → 작업 요청 UUID+장소+주소/정확 네이버 장소 ID+리스트+메모/별명 → SQLite outbox → UI `새 리스트 만들기`→장소 후보 1개일 때만 선택 → UI 저장 → **실제 네이버 계정 조회에서만 `NAVER_READBACK_VERIFIED`**. 검색 결과 복수/네트워크/로그인/네이버 UI 변경 시 보류 또는 명시적 미확인 상태. 사용자 GPS/사진/세션/인증키 GitHub 업로드 금지.
- Android↔PC 통신은 PIN된 HTTPS 인증서+비공개 토큰 소스까지 **컴파일만 검증**. **R233 배포 APK에 내장되지 않았으므로, 지금 바로 MOA 버튼으로 서버에 저장 가능한 상태는 아니다.**

## 5. 제약 및 개발 순서

**현 단계 미완료:** 네이버 실계정에서 새 리스트와 실제 장소 1건 저장 후 원격 readback, 사용자 휴대폰에서 화면 비점유로 작업 전송, WiFi/LTE/PC 미가동 시 동기화, Android 단독 완전 수행.

**실질 후속순서:** (1) 사용자 소유 PC Chromium의 실제 Naver 웹 UI로 더미/승인된 장소 1건 리스트 생성+저장+readback 성공 입증 → (2) MOA 현재 패키지 위치정보 UI 버튼과 SQLite/IndexedDB 모바일 Outbox를 별도 후속 코드에 연동 → (3) LAN TLS 핀/페어링+WiFi/LTE/모바일 배터리 QA → (4) 사용자가 PC를 켜지 않아도 되는 대안인 개인 상시구동 NAS/VPS와 Android 자체 브라우저 엔진 연구 병렬 진행(여전히 인증/정책/계정 보호 문제 포함) → (5) 화면 전환 0/리스트 저장 10/10/중복 0/기존 갤러리·일기·바로기록 회귀 0을 만족해야 정식 승격.

## 6. 외부 근거

- 네이버 공식 저장: https://help.naver.com/service/5637/contents/692?lang=ko
- Playwright 실제 구현 참고: https://github.com/dayeonisme/navermap-converter
- 읽기/쓰기 분리+ncaptcha 내부 API 제약 기록: https://saramjh.github.io/naver-map-save-list-bulk-reorganize-guide/
- Playwright 영속 계정 세션: https://playwright.dev/docs/auth
- Reddit Android 화면 외 자동화 제약 사례: https://www.reddit.com/r/tasker/comments/12bcdnj/project_share_turn_display_onoff_dont_disturb/

**중요: 이번 산출물은 독립 실행 백그라운드 엔진 소스·테스트 패키지이며, 완성된 MOA 업데이트 APK가 아니다. 사용자에게 실계정 저장이 성공했다고 말하지 않는다.**