# MOA R289 — 실계정 로그인 후 비점유 자동저장 안전 실험 (2026-11-11)

## 실제 증거와 범위
- 사용자 R283 실기기 영상 20192.mp4 및 20193.mp4: 네이버 계정 로그인 유지, 네이버 장소 저장 리스트 접근, 주소별 저장창 별명·메모 입력, 저장 뒤 초록색 별표 전환, 업체 상세 화면의 별도 별표와 주소 페이지 별표 UI 차이를 확인. **최종 서버 계정 독립 재조회는 아직 수행되지 않았고 개인 영상/식별자/주소는 공개 GitHub에 올리지 않음.**
- R283의 공식 NAVER 로그인/Android 기본 UA 전환 동작은 보호. R283 기준 로컬 베타 APK SHA256 `f6391c3d388f10438b0366c587f64e95a133d268920320bd5939b835eb76cff0`.

## 사용자 직접 선택하는 R289 수정
1. 이전 `moa-r231-naver-frame-probe.js`에 이미 있던 R237 same-device NAVER 작업기를 다시 연결. 가장 중요한 blocker는 `^https://(?:sub\.)?naver.com$`이 **2단계 서브도메인 `pcmap.place.naver.com`, `pages.map.naver.com`을 거부**한다는 것. 이제 3개의 공식 NAVER origin 정확한 Set 허용. 네이버 외부 광고 iframe에 task의 메모·별명·주소를 `postMessage('*')`로 뿌리지 않도록, 허용 출처 src만 검증하여 명시적 targetOrigin으로 보낸다.
2. 새로운 장소 저장 컨트롤 `a[data-nlog-area="map_btp.save"]` 및 이전 클래스 셀렉터를 함께 고려하지만, 단일 대상/정확한 SID/저장 상태를 모두 만족해야 클릭. 둘 이상이면 절대 첫 번째 자동 선택 금지. 주소만 존재하는 사진은 업체를 추정하지 않고 주소 자체를 검색; 검색 결과 여러 개이면 `PLACE_AMBIGUOUS`. 정확한 주소·이름 조합을 찾지 못해도 같은 실패 안전 정책.
3. React 제어형 별명/메모 칸은 원본 HTMLInputElement/HTMLTextAreaElement value setter와 input/change 이벤트로 채운다. 기존 네이티브 R237 50자 메모 상한을 넘으면 **내용을 자르지 않고 저장 요청을 거절**한다.
4. `moa-r231-settings.js`에 `모아 화면 비점유 저장 실험 (직접 누를 때만)` 토글 **기본 OFF**. ON에서만 기존 사진·GPS 저장 버튼이 `MoaMomentNative.naverWebProbeControl('phone_submit:'+JSON)`과 `phone_status`를 사용한다. `naverWebProbeStatus()`의 running+hidden이 아니면 시작하지 않는다. OFF에는 기존 외부 네이버 앱 전경 저장 엔진이 완전히 유지된다. 자동 native fallback 없음.
5. `fj-naver-favorites.js`에서 사용자 승인/정확 장소 값으로 기존 native worker에 PENDING 전송. `NAVER_READBACK_VERIFIED`가 나오더라도 모아 사진 메타데이터를 자동 확정(CONFIRMED)하지 않고 PENDING 유지; 네이버 정식 계정 저장 목록에서 재조회가 필요하다.

## 배포된 파일과 검증
- Private-local same-certificate APK: `MOA_R289_OFFSCREEN_TARGET_SAFE_TEST_BETA.apk`, versionCode289, **8,907,764 B**, SHA256 `3217857e08c3e966e8f1772767098b3ba475848f652cd9f5fa5ef5a07a8cdcb7`.
- Forward recovery: `MOA_R291_RESTORE_R283_ORIGINAL_FEATURES.apk`, versionCode291 SHA256 `cb284471d6cb8a8c233c64fce91ec8cbcc4b36ca434b32d8bb561372a0e0fe73`. Only manifest versionCode changed from R283. Not byte-identical user R269 Golden.
- QA ZIP: `MOA_R289_OFFSCREEN_SINGLE_APP_TEST_WITH_R291_RECOVERY_20261111.zip`, SHA256 `4d3433b2ae89b494ba00a9e6b7d81aa15bdb1aa11dea002fac9227b7175c2119` (12,883,399 B). Includes signed R289/R291, QA JSON, local source diff, Korean guide, synthetic smoke outcomes; no personal media/key.
- **Exactly four R283→R289 APK member payload changes:** `AndroidManifest.xml`, `assets/web/fj-naver-favorites.js`, `assets/web/moa-r231-naver-frame-probe.js`, `assets/web/moa-r231-settings.js`; all 16 original DEX and all other 134 non-signature entries byte-for-byte equal. Original signer certificate SHA256 `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`, APK v2, zipalign, ZIP CRC, 16 DEX SHA1/Adler32, manifest package/version, JS syntax PASS.
- 5 mocked isolated scenarios PASS: wrong SID refuses click; multiple Save controls refuse click; unique exact SID invokes official button/list/commit but reports UNVERIFIED; cross-frame status target-origin exact; duplicate address rows block arbitrary first-row click.

## 출시 관문
- **R289는 베타일 뿐:** 실제 Galaxy에서 숨긴 WebView를 통한 NAVER 저장 입력, UI 리스트/별명/메모·서버 영속 저장, 독립 readback, 기존 일기/갤러리/오디오 회귀, 보호된 R269 Golden 기능과의 갭 **아직 미검증**. DOM/API 변경이면 fail closed. '비점유 자동 저장 완료', 'FINAL', '새 GOLDEN'으로 표시 금지.
- 정상 모아 앱 삭제/데이터 초기화/서명 변경/강제 다운그레이드 금지. R291은 higher-version emergency feature restoration이며 device QA open.
- R269 사용자 Golden SHA256 `c0663e65aac2b72feb86cb0f1ba5eac448b6599c3850858de4d942f2aa446920` 원본 바이너리/서명/잠금 문서 수정 없음; AirPods/AA 오디오 프로젝트 역시 변경 없음.
