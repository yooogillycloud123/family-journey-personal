# MOA R269 비점유 네이버 저장 — Android WebView 실증 재시작 기록 (2026-11-10)

## 변경 범위 / 보호
- **R269 GOLDEN 절대 불변**. 원본 `com.juhyeon.familyjournea` code269 APK SHA256 `c0663e65aac2b72feb86cb0f1ba5eac448b6599c3850858de4d942f2aa446920`, signer cert `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`; 본 연구에서는 APK/가족 사진/실계정 세션/개인 서명키 변경 또는 업로드 **없음**.
- 독립 브랜치: `research/moa-r269-webview-kvm-frame-gate-20261110`. 원형 branch `research/moa-r269-navermap6721-offscreen-evidence-20261110`에서 분기. 골든 브랜치/기존 foreground Accessibility 네이버 저장 기능은 수정하지 않음.
- 이 브랜치 산출물은 연구용 **익명/no-write Android WebView QA**, 사용자 설치용 MOA 업데이트 APK 아님.

## 직접 로그로 확인한 실패 원인
1. 최초 Actions `42804245257`: `/dev/kvm` 사용 권한 부재 → emulator `-accel off` → `Timeout waiting for emulator to boot`. 이는 NAVER 자체 응답/거절이 아니라 테스트 인프라 실패.
2. 새 Actions `42808916039`: `sudo chmod a+rw /dev/kvm` 후 실제 **Android 35 부팅 28.6초 PASS**. 이어서 `reactivecircus/android-emulator-runner` 내부 `/bin/sh`가 `set -euxo pipefail`을 받아들이지 않아 테스트 스크립트 중단. 앱/네이버 저장 실패 증거 아님.
3. Actions `42809363317`: isolated Android WebView APK 컴파일 + 부팅 + 앱 기동 **PASS**. 실제 익명 WebView `https://map.naver.com/p/entry/place/1628573942` 에서 `MAIN_ERROR -2` (host lookup) 기록, 따라서 **지도 로딩 FAIL / Places iframe 미도달**. `MAIN_FINISHED_NOT_PASS`를 성공으로 판단하지 않음. 이 회차 스크립트는 multiline `if`가 per-line `sh -c`로 나뉘는 오류도 있었음. 네이버 차단/무한 redirect로 단정 금지.

## 구현한 실험 보완 (이 브랜치만)
- GitHub Actions runner KVM 접근 허용 + 하드웨어 가속 Android35 boot.
- 에뮬레이터 쉘 스크립트 POSIX 호환 + 한 줄 검사. 진단용 host DNS 값/ping, `-dns-server 8.8.8.8,1.1.1.1` 추가.
- 기존 안드로이드 실험 Activity에서 2x2 픽셀부터 시작하지 않고 **full-size WebView 35초 → 2x2 화면 유지/JS 관측**으로 변경.
- 상단 navbar '저장' 문구 탐지는 폐기. Place detail 자식 iframe의 진짜 `a[data-nlog-area="map_btp.save"]` 해당 속성을 정확히 비교하여 `placeSaveCount` 관측. 단, **읽기만** 하고 로그인/클릭/쓰기는 절대 하지 않음.
- 증거 있는 대안: `https://pcmap.place.naver.com/place/1628573942/home`를 **독립 최상위 WebView**로 직접 여는 연구 단계를 추가. 이는 구 R241 `?app=Y&appmarket=N` 주소를 재실행하는 무작위 UA 시도가 아니며, 실제 PC Place iframe 출처 자체를 직접 시험하는 경로임.
- parent 및 direct Place 경로 모두 full-size, 2x2 상태 분리; 프레임 host/DOM 존재 여부/오류를 민감 데이터 없이 Logcat/CI artifact로 기록.

## 아직 증명하지 못한 핵심 (FAIL/PENDING 엄격 구분)
- 익명 실제 Android WebView에서 Place UI 렌더링 및 저장 버튼을 읽는지.
- 실제 Android **MOA 내부** 공식 네이버 계정 로그인 허용 여부 및 세션 지속.
- UI의 실제 장소 ID, 리스트 자동 생성, 별명/메모 원격 서버 저장, 네이버 목록 독립 readback.
- 숨김 렌더러에서 일기/갤러리/바로기록이 그대로 조작되는지.
- 기존 `↶ MOA`와 Golden 기능 퇴행이 없는 원본 서명 동일 패키지 업데이트 APK.

## 다음 기술 판정 (엄격한 순서)
1. 현재 Android emulator CI의 네트워크 DNS/host lookup을 진단하고 parent/Place 직접 접근에서 **실제 frame DOM**을 관찰. 렌더러 오류, 디바이스 미지원, 네이버 HTTP/인증 차단을 각각 별개 FAIL로 분류.
2. 프레임이 살아야만 MOA 기존 `job/expectedAddress/list/memo/alias` 계약을 새 **보안 출처 제한** bridge로 옮긴다. 모호한 장소는 자동선택 금지. 원래 foreground Accessibility path는 그대로 보존.
3. 공식 로그인은 사용자가 Galaxy에 직접 수행하는 단계이고 비밀번호/OTP/쿠키는 개발자나 채팅으로 전달하지 않는다.
4. 실제 계정에서 새 리스트 및 정확 SID+별명+메모를 저장한 뒤, **독립적인 인증 계정 목록 재조회 일치**가 있을 때에만 `NAVER_READBACK_VERIFIED` 및 저장완료 팝업.
5. 이후 원본 R269 signer/same-package update-only APK, 정적 서명/DEX/ZIP 및 기존 일기·갤러리·바로기록·↶MOA 실기기 회귀 PASS 전에는 FINAL/GOLDEN 승격 금지.

## 사용자 참여 구분
현재 사용자에게 네이버 자격증명/실기기 디버깅/여러 테스트 APK 설치 요구 **없음**. 개발자 내부 브라우저 검증을 마치고 본인 폰의 정식 네이버 로그인이 필요할 때만 사용자 참여; 그 이후 네이버 계정 내 실제 저장된 1건의 리스트·장소·별명·메모 확인이 필요.

## 참조
- Canonical/Golden addendum `MOA_R269_GOLDEN_ADDENDUM_OFFSCREEN_AUTH_GATES_USER_ROLE_20261110.md`
- Research original Android WebView source `experiments/moa-r269-android-webview-frame-test/`
- CI `https://github.com/yooogillycloud123/family-journey-personal/actions/workflows/moa-r269-android-webview-frame-test.yml`
- AndroidX WebKit docs `https://developer.android.com/reference/androidx/webkit/WebViewCompat`

## 2026-11-10 추가 실측 — 실제 네이버 장소 저장 버튼 DOM 발견
- Actions [#42811224085](https://github.com/yooogillycloud123/family-journey-personal/actions/runs/42811224085): Android35 emulator KVM boot, actual Android WebView, `WebViewCompat` per-origin frame messaging PASS.
- PC parent `map.naver.com/p/entry/place/1628573942`: 실제 `FRAME_CHILD pcmap.place.naver.com saveCount=1;bodyLen=863;errorDocument=false`. 상위 내비게이션 '저장'이 아니라 정확히 자식 프레임의 `a[data-nlog-area="map_btp.save"]` 감지.
- 같은 부모 WebView를 **2×2픽셀** 축소 후에도 `FRAME_CHILD pcmap.place.naver.com saveCount=1;bodyLen=863;ready=complete` 반복. 사용자 화면 점유 없이 JS/DOM 읽기 지속되는 실증 단서.
- 직접 `https://pcmap.place.naver.com/place/1628573942/home` Android WebView: `FRAME_TOP ... saveCount=1;bodyLen=1089;ready=complete`; 2×2 축소 후에도 `FRAME_TOP ... saveCount=1;bodyLen=1087` 확인. **PC 부모 우회가 가능한 직접 장소 경로**를 실측 확보.
- CI 최종 exit는 **false-negative FAIL**: 쉘 single-quoted 정규식에 과잉 백슬래시 `pcmap\\.place`가 사용돼 실제 `pcmap.place` 로그를 놓침. 계정 저장 오류/브라우저 UI 실패 아님. `pcmap[.]place[.]naver[.]com`으로 수정한 별도 커밋 `7a11418095928d8973e59f4e1474d19825be4524`.
- `ping example.com`과 `ping map.naver.com`은 해당 CI에서 여전히 `unknown host`. 그러나 **실제 WebView는 Place 본문 DOM과 저장 버튼을 로딩**했으므로 ping 실패만으로 브라우저 네트워크 차단을 단정할 수 없다. 실기기 계정 인증/저장 여부는 별도 검증 필요.
- 다음 익명/no-account 실험: 저장 버튼을 WebView 축소(2×2) 상태에서 **인증 전 단 한 번** 눌러 공식 로그인 진입/팝업 경로를 살핀다. CI 에뮬레이터는 NAVER 로그인 정보가 없고, 네이버 로그인/계정 저장/쿠키 추출은 하지 않는다.
- **절대 아님:** 서버 저장, 리스트 생성, 별명/메모 저장, 독립 실계정 readback, MOA R269 통합 signed APK. 이것들이 모두 남아 있으며 최종 완료/골든 승격 금지.
