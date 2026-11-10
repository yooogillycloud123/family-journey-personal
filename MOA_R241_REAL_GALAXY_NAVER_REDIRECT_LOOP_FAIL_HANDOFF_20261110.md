# MOA R241 — 사용자 Galaxy 영상 20042.mp4 실증 FAIL (2026-11-10)

## 실제 사용자 보고와 영상 증거
사용자 제공 비공개 20042.mp4 (12.02s)를 살펴봤다. 개인 영상 원본은 공개 GitHub에 올리지 않는다.
- MOA 설정 화면 자체, '네이버지도 즐겨찾기 · 스마트폰 내부 실행' 장소명/주소/POI ID/리스트/별명/메모 UI는 보인다. **MOA Activity가 아예 실행되지 않은 것은 아니다.**
- ① 'MOA 내부 웹 로그인' 등으로 진입한 MOA 내 브라우저가 `https://map.naver.com/?app=Y&appmarket=N`에서 `net::ERR_TOO_MANY_REDIRECTS` 와 **'웹페이지를 사용할 수 없음'**을 표시한다.
- 보고 상태 `VISIBLE_DESKTOP_PAGE_FINISHED_UNVERIFIED`는 성공/로그인/저장 증거가 아니라 오류 화면의 onPageFinished도 잡았다는 뜻. PC 웹 접속 단계 자체가 실패했으므로 장소 저장·리스트 만들기·메모·별명 및 readback 실행 불가. **R241 Galaxy NAVER = FAIL**.
- R233 Galaxy에서 같은 리다이렉트 루프가 이미 알려져 있었으므로 R239/R241에 WebView 스크립트만 추가하고 정상 동작하는 듯한 사용 안내/완성 표현을 한 것은 회귀방지 실패다. 다시 같은 WebView를 포장한 상향 code APK 금지.

## 사용자 최상위 기능 목표 (축소/변경 금지)
한 개의 원래 `com.juhyeon.familyjournea` MOA APK가 Galaxy S26 Ultra에서 작동해야 한다. PC/NAS/VPS/도우미앱/Shizuku/root 없이, 사용자의 화면에서 NAVER지도 전면 전환 없이, 실제 사용자 계정의 **장소+별명+메모를 기존/자동 신설 네이버 리스트에 저장**해야 하며 **그 계정의 저장목록을 재조회해야만** 완료를 표시할 수 있다. 기존 R227 Golden과 R229/R231 '↶ MOA' 같은 사진 복귀, 일기·GPS·영상·녹음·바로기록을 보호한다. 임시 코드/모의 Chromium/CI 컴파일만으로 완제품이라고 말하지 않는다.

## 현재 보존 바이너리
- User-designated immutable Golden R227 APK SHA256 `53c4c04ce32ad13de3c0613f4e5ec7abbc75ccbdfe9db5da05d8fa9b806ec6cd`.
- R241 actual signed APK SHA256 `ca2139d083a76f66dbfca14949e60b8189780f6f8fe22e6b5c52c3aa541`; same package/versionCode 241/original cert `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`. ZIP structure valid but function FAIL. Do not ask user to uninstall, clear data, or blindly downgrade.
- R241 source/QA contained in private `/모아_프로젝트_근거_20261103/R241_ANDROID_ONLY_EXPERIMENT_20261110/`.

## 기술 조사 진행
The R241 worker injects task JS into the current `WebView` via `MoaNaverPhoneWorker`; the real map page never loads, so task code cannot run. Native NAVER app cookies do not automatically pass to MOA WebView. Public Android Map SDK does not expose user's personal NAVER favorites write interface. No bypass of CAPTCHA/private tokens.

On isolated source branch `feature/moa-r243-gecko-device-probe-20261110`, started GeckoView-in-app public PC-map Android-emulator probe (separate CI proof only; **not** an installable production MOA APK). GeckoView has its own browser engine and desktop UA/viewport, but NAVER customer help notes Firefox is not a supported map browser. Only a device result proving PC map loads may justify deeper private-account UI/re-readback architecture; it must never be sold as confirmed NAVER account saving. Another potential full embedded Chromium runtime requires ABI, permissions, resource/DEX and Android W^X feasibility; not assumed solved.

## Non-negotiable next acceptance gates
1. No redirect/app-install landing on Android emulator AND Galaxy in intended embedded engine.
2. User-consented first-party login in that engine (no cookie theft from native NAVER app).
3. In real NAVER account, one user-approved harmless place; create missing list; save exact place+alias+memo; read back the same list/place/metadata.
4. One original-signer update APK, not multiple assistants; MOA screen stays visible; repeated cycles/duplicate handling, offline/restart, data retention tested.
5. Original R227 golden+user-verified NAVER→MOA one-back regression, voice, diary, gallery all PASS.
6. Every APK must include exact user guide ('어디에 들어가서 무엇을 누르면 어떤 상태가 떠야 하는지'), direct APK+bit-identical ZIP, hash and real download link. No 'final' language without 1–5 real device PASS.

**현재 실패한 R241은 수정된 버전이 아니다. 성공이라고 표시하거나 다시 그대로 배포하지 않는다.**
