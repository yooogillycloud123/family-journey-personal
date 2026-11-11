# MOA R305 — 사용자 영상 20261.mp4 직접 분석: 숨김 우선 호출 오류 (2026-11-11)

## 원인 확정 범위
- 사용자는 R305의 네이버지도 화면이 더 이상 열리지 않고 `[비점유] 모아 앱 안에서 네이버 계정에 로그인된 지도 화면을 먼저 연결해 주세요. 저장 요청을 보내지 않았습니다.` 메시지가 나타난다고 보고함.
- 실제 업로드 **개인 영상 20261.mp4 (~35초)**: Settings 진단은 `NOT_STARTED`, 사용자 누른 부분은 왼쪽 빨간 `샘플 장소 웹 연결`이 아니라 **가운데 `지도 웹창 뒤로 보내기`** 버튼임. 그 뒤 상태가 `VISIBLE_LOGIN_REQUIRED_FIRST`로 변하고 네이버 WebView 표시가 없음. 영상 시작에는 Android System WebView 업데이트 제거 확인창이 보이나 제거 실제 수행 여부는 알 수 없으므로 원인 단정 금지.
- R305 **실제 classes13.dex**의 `MoaNaverWebProbeController` smali를 디코딩하여 근거 확인: `visible` 시 `probe == null`이면 `start(activity)` 실행; **`hidden` 시 `probe == null`이면 `state = "VISIBLE_LOGIN_REQUIRED_FIRST"`만 기록하고 반환하며 WebView start 자체를 호출하지 않음**. 따라서 위 영상의 상태 값은 NAVER 계정 인증 실패/서버 차단/WebView crash 증거가 아니라 **웹 연결이 없는데 '숨기기' 명령부터 실행**한 정확한 반환 코드다.
- 같은 R305 `assets/web/fj-naver-favorites.js`의 `tryR289Offscreen`는 `naverWebProbeStatus()?.running`이 false면 사용자 메시지 `WEB_SESSION_NOT_READY`를 반환하며 `phone_submit` 작업을 보내지 않는다. 따라서 이번 영상에서 네이버 계정에 작업이 전송되지 않은 것은 맞다.
- **확정하지 않은 것**: 왼쪽 빨간 `샘플 장소 웹 연결`을 실제 누른 뒤에도 WebView 시작이 실패하는지 이번 영상에는 재현되지 않음. R305 WebView 호스트 classes13.dex 및 Settings JS는 R301에서 변경되지 않았으며, 'R305가 브라우저 자체를 파손했다'는 종전 분석은 직접 증거 없이 확정 금지.
- R305가 과거 연구에서 실계정 write를 의도적으로 차단하는 `non-writing diagnostic`임을 별도 명확히 구분. 브라우저가 보여도 이것만으로 비점유 즐겨찾기/메모 저장이 구현된 것은 아님.

## 사용자에게 즉시 제공 가능한 안전 작동·복구
1. **R305 현 설치본**에서 먼저 왼쪽 빨간 `샘플 장소 웹 연결`을 눌러 네이버지도 화면이 뜨는지 확인. 뜨고 로그인한 지도이면 그때 가운데 `지도 웹창 뒤로 보내기` 사용. 이미 보이는 네이버 계정/저장목록은 자동 삭제/생성 금지.
2. WebView 호스트 상태가 `NOT_STARTED`일 때 숨김 버튼을 먼저 눌러도 연결되지 않는 **UI 실수 방지** 소스 패치를 준비: `assets/web/moa-r231-settings.js`의 `probe('hidden')` 실행 전 running false이면 `visible`을 1회 시작하고 로그인/지도 보이는 상태에서 다시 숨기도록 안내. 이때 자동 hidden/로그인/쓰기/쿠키복사를 하지 않음.
3. **출력된 소스 패치** `MOA_WEBVIEW_START_ORDER_EXACT_SOURCE_FIX_20261111.zip`: Node syntax PASS, 모의 4건 (hidden+not running→visible, hidden+running→hidden, visible→visible, stop→stop) PASS. **APK 수정·서명 및 Galaxy 작동은 완료되지 않은 소스 전용**. 기존 앱 위에 서명 다른 재포장 APK 설치 금지.
4. **확인된 동일서명 상위 코드 복구** `MOA_R307_RESTORE_R301_NO_CREATE_SAME_SIGNER.apk` (R305→R307 가능, 사용자 데이터 wipe/uninstall 불필요), SHA256 `7306765f6d780d48ea35eee1648ec817cffb4ff9ec7792e40bce6e6d687c844d`, package `com.juhyeon.familyjournea`, code307, 인증서 SHA256 `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`, `apksigner verify v2 PASS`, zipalign PASS, ZIP CRC PASS. R307은 기존 R301의 **완성된 실계정 비점유 기능이 아니라 R301 기능 동등 복구 후보**, 기기 설치 회귀 미검증.
5. 기존 R303(실제 R283 로그인/전경저장 기능 동등) code303은 R305보다 낮으므로 **앱 삭제 없이 일반 업데이트로 설치 불가**. 절대 설치를 위해 앱 삭제·데이터 초기화 유도하지 말 것.

## 근본 목표/다음 개발 관문
- 숨김 전에 연결을 검증하는 UX 수리는 필요하지만, 실제 남은 별도 관문은 로그인된 네이버 계정의 **고유 folder/shareId 식별·사용자 명시적 선택 → 정확한 장소/주소/별명/메모 저장 → 독립 계정 readback**, 그리고 한 번만 실행/idempotency, 기존 리스트 새 생성 차단 및 잘못된 대상 쓰기 방지. 
- R269 사용자 원본 Golden code269 SHA256 `c0663e65aac2b72feb86cb0f1ba5eac448b6599c3850858de4d942f2aa446920` 원본 바이너리 절대 불변. 기존 사용자 일기·사진/영상·M4A·나의지도·동명 네이버 리스트는 그대로 보존, 사용자 개인 동영상·로그인 정보·개인키·암호는 공개 저장소에 올리지 않음.
