> **2026-11-16 CORRECTION R649 QUARANTINE:** New optional R649 candidate has now FAILED user's real Galaxy QuickRecord Gallery return and photo-add content preview, despite all original Gallery protected source hashes matching R648. Read [MOA_R649_REAL_GALAXY_QUICKRECORD_AND_PHOTO_PICKER_FAIL_20261116.md](MOA_R649_REAL_GALAXY_QUICKRECORD_AND_PHOTO_PICKER_FAIL_20261116.md). Protect actual R648 successful scope; R649 is not a safe update recommendation. R650 original-function recovery candidate available, hardware QA pending. No application uninstall or user data reset. 

# MOA R648 사용자 실기기 성공 범위 보호 · 사진추가 완전 요구사항 · 새 채팅 필독
2026-11-16 / USER-PHYSICAL-EVIDENCE / CANONICAL MOA PHOTO-ADD SAFETY LOCK

## 먼저 읽을 것 / 순서
1. `yooogillycloud123/workexcel-devbridge/main/AA_AirPods_FINAL_READ_FIRST_v1.0_20261005.md` (공통 프로젝트 첫 문서; AA 오디오 변경은 본 MOA 작업에서 절대 금지)
2. `family-journey-personal/main/MOA_READ_FIRST_NEW_CHAT.md`
3. **본 문서** 및 `MOA_R648_R641_GOLDEN_PASSIVE_FULL_TRACE_PHYSICAL_R647_FAILURE_HANDOFF_20261116.md`
4. R611/R641 immutable Golden, R619/R621/R623/R625 사진 추가 요구·실패 이력, permanent full-runtrace policy, 최신 소스 및 artifact. 다른 버전에서 최신 실제 사용자 승인을 덮어쓰지 말 것.

## 실기기 R648 판정 — 성공 범위와 미검증 범위를 엄격하게 구별
- 사용자는 2026-11-16 Galaxy S26 Ultra에서 **One Hand Operation+ OFF → ON 한 다음에** 잠금화면, 화면 켜진 상태, MOA 앱 실행 중 각각 바로기록 및 원본 네이티브 갤러리가 동작했다고 직접 확인했다. 이 성공한 범위의 R648을 **현재의 사용자 실기기 확인·보호 기준(SCOPED GOLDEN)**으로 고정한다.
- **One Hand OFF→ON 조작 없이 최초부터 성공하는지는 미검증**, R648의 사진 추가 UX 및 전체 미디어 품질은 미완성/미검증. 이 버전을 사진 추가까지 완성된 FINAL로 지칭하지 않는다.
- 첨부 `테스트.txt` SHA256 `e035a003f9571df2f2772a70eab04cca00f8919e8a3f41a06b5b59301f952276`(2662 rows, 이전 세션 포함). R648 태그만 581행/6 부팅에 `START_INLINE=14`, `NATIVE_PREDRAW_ARMED=14`, `NATIVE_OPEN_ACCEPTED=14`, `NATIVE_HOST_MOUNTED_ORIGINAL_STAGE=14`, `NATIVE_8_ACTION_DECK_READY=14`, `NATIVE_MOUNT_ACK=20`, `QUICK_RECORD_NATIVE_COMMIT=4`. 이 이벤트 수는 서로 독립적인 실기기 성공 횟수로 착각하면 안 된다. 이전 R647 실기기 실패는 START_INLINE 뒤 ARM/open/mount 관측 불가. 근본 Java/OS failure root cause는 미확정.
- R648 행에 `RESOURCE_LOAD_ERROR` **이미지 6건 / 동영상 2건**이 있음. 로그에는 리소스 유형만 있고 URL/URI/실패코드/개별 로드 시도 여부가 없으므로 **사진 추가 기능 실패와 직접 인과관계는 아직 증명되지 않았다**. 확인 전에는 권한·URI·네트워크·WebView 원인이라 단정하지 말 것. 이 이벤트만으로 정상인 native gallery를 수정하지 말 것.
- APK R648 SHA256 `6b5984e1b3892c0ed10606008d2627c0393ba02661e22a13565571f1a47be3c1`, versionCode 648, package `com.juhyeon.familyjournea`, 원래 서명 cert SHA256 `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`. R641 SHA256 `bf1633ad830057b61ef1d256d57a9215b393800c739c75a113dbb10f06167e89`, R611 SHA256 `38a507cf2e88a235282ae4d9ad64cf0799033f34ae8fe3e179a58960d1213ccd`. R611 / R641 / R648 정확한 signed binaries와 해시를 모두 별도 immutable rollback 근거로 보존.
- R648 is R641-exact functional clone + passive diagnostic: 145/147 entries byte-exact, all 18 native DEX exact. Only Manifest version and index script hook differ; one additive passive trace JS. Native gallery/photo/calendar JS/CSS, QuickRecord safeguarding, OneHand/Naver, diary, voice must remain protected.
- **정상 동작 R648을 현재 사용자 폰에서 삭제·다운그레이드·데이터 삭제·권한 초기화하지 말 것.** 단순 byte-identical/static/Chromium QA는 Galaxy hardware PASS가 아니다.

## 사진 추가: 완료해야 하는 원래 사용자 요구 — 기능 축소 금지
A. 날짜·화면: 중앙 `+`로 **원본 Gallery와 독립된** 사진 추가 화면 진입. 선택한 날짜 / 전체 기간 전환. 촬영 날짜로 구분한 **세로 3열** 사진·영상 혼합 그리드, 더보기 버튼 없이 스크롤 하단 자동 추가 로딩(페이지 단위; 대량 미디어에서도 부드럽게). 보조 화면에서 `+` 재탭 시 원래 날짜 일기로 복귀. 사진형/상세형 전환과 기존 미디어·메모·음성·GPS·네이버 데이터 유지.
B. 카카오톡형 선택: 사진 **본문 탭=선택/해제**, 우상단 원형 숫자 배지로 순서 1,2,3…, 상단 선택 개수·안내·선택 추가 버튼 연동. **좌하단 별도 작은 확대 아이콘**(과거 29px 너무 커서 23px 제안). 360ms 롱프레스+드래그로 연속 선택/해제, 가장자리 자동스크롤; 평범한 수직 스크롤 제스처 방해 금지. 그리드/확대/필름스트립은 **한 선택 상태** 공유.
C. 확대: 본문 큰 미리보기에서 사진 앞뒤 스와이프. **FAST ON/OFF는 큰 사진 전환에만 영향**(OFF 1장, ON 제스처 속도·거리 비례 여러 장). 하단 필름스트립은 FAST ON/OFF 무관하게 **항상 부드러운 수평 관성**; 사진 탭 이동, 필요 시 펼침/접힘, 현재 사진 흰 테두리와 약 6px 들어 올린 강조. 프리뷰 이동이나 자동 중앙정렬이 사용자의 실제 손가락 스크롤을 덮어쓰지 말 것. 미리보기에서도 선택/해제 가능.
D. 배치: 고정된 **상단 컴팩트 바**에 선택수·안내·일기 열기·선택 추가. 하단 sticky 버튼이 이미지 셀을 가리는 오류 금지. 상단 선택 표시가 새 선택/이미지 로딩 시 흔들리지 않음. 작은 확대버튼을 UI에 자연스럽게 배치.
E. 원본 화질·영상: 사진은 실제 원본 content URI 우선, 지원 불가 시 최대 허용 고해상도 fallback. 이미 원본/고해상도 뜬 DOM이 낮은 260px 썸네일로 다시 칠해지지 않게 품질 floor 유지. 동영상 **실제 재생/일시정지/진행 시간/탐색(seek)**과 가능한 음량·음소거, 원하는 장면으로 이동; 단순 썸네일 시뮬레이션/HTML video 버튼만 만들어 성공이라 주장 금지. 실기기 content:// 접근과 MediaStore 권한, 파일별 표시 품질, 영상 앞뒤 구간 seek 검증.
F. 날짜 조작(기존 요구 보존): 날짜 헤더 **위치는 고정, 숫자만 스와이프에 따라 변경**; 날짜 탭/길게누름은 기존 일기와 같은 **아래에서 올라오는 연/월 세로 휠·날짜 선택**. 사진형 설정 시트가 네이티브 갤러리 뒤로 숨거나 원본 native host를 위험하게 종료·재시작하면 안 됨. ESC/뒤로가기는 미리보기→보조시트→원래 일기 순서.
G. 저장: 기존 `curated.photoIds` writer와 기존 미디어 ID/IndexedDB/원본 파일을 유지하며, 선택 사진·영상만 해당 날짜 일기에 추가; 저장 후 그 날짜의 사진형과 원본 네이티브 갤러리 정상 복귀. 사용자 데이터·네이버 로그인/쿠키 손실 절대 금지.
H. 과거 R623/R625 웹뷰 모의 갤러리는 원본 Android 네이티브 갤러리와 동등한 엔진이 아님. 진짜 네이티브급 UX가 필요하면 별도 owner Android native component를 구현·물리 검증하고 원본 갤러리의 shared owner/host/r507StopInline/r531Advanced/MoaLocalAudio.openNativeGallery 호출을 사진 추가에서 재사용하지 않는다.

## 반드시 막을 재발 실수
- 실패 R629~R647 코드를 통째로 합치거나 R625 사진 UI를 기존 Gallery 소스에 덮어쓰지 않는다.
- R648 원본 gallery/QuickRecord/OneHand/native host/DEX/native photo JS 변경 금지. 필요하다면 먼저 명확한 증거와 사용자 승인/별도 기능 분리, 보호 byte/hash 범위 명시.
- 원본 Android native open/close, shared gallery host, lifecycle listener, global state, page navigation, background timers, recover/rearm, WebView startup injection 등 **간접 간섭**까지 diff/교차 이벤트 감사를 한다. 원본 DEX 불변만으로 안전하다고 주장 금지.
- 새 기능은 명확히 격리된 owner에서 실행. 일단 독립 진입/선택/저장/닫기까지 구현하고 원본 Gallery 재진입 경로는 기존 R648 검증 코드를 호출하는 원래 의미만 유지.
- 무근거 timed retry/강제 Gallery reopen·close, 정상 native reset, 데이터/권한 초기화, signer 교체 금지.
- 진단 `Settings > 전체 실행 경로 진단 > 전체 기록 보기/전체 진단 복사`는 지속·보존. 개인 미디어·GPS·토큰 원문 기록 금지; 부팅→사용자액션→Java stage→저장/복귀/오류의 순서 보존; 누락 콜백을 추정으로 성공·충돌 판정 금지.

## 릴리스 게이트
1. R648 source/APK immutable freeze 및 SHA 목록, 새 브랜치에서 수정.
2. 원본 R648 대비 보호 파일/18DEX SHA 및 변경 파일 전수 목록; picker가 원본 host API에 간섭하지 않는지 정적+실행 검증.
3. 별도 격리 사진 선택 그리드/제스처/미리보기/원본 고화질/동영상/선택 저장 테스트. MEDIA_RESOURCE_LOAD_ERROR 6+2 원인별 검증(코드만 보고 특정 원인 단정 금지).
4. 원래 서명, APK v2/digest, ZIP CRC, package, versionCode **>648**, update-install compatibility, 기존 데이터 유지, source diff, CI artifact, APK SHA-256.
5. **복구판도 후보보다 높은 versionCode로, 실제 R648 기능 복원**(Manifest version만 변경)하고 같은 signer/업데이트 경로 확보. 하위버전 R648 APK는 일반 update-install 롤백 불가.
6. 사용자 갤럭시 실기기에서 *원핸드 OFF→ON 후* 잠금화면·일반 화면·모아 전면에서 바로기록/원본 갤러리 복귀 + 사진형↔상세형 + 반복 + 새 사진 추가 + 실제 사진 화질/영상 seek 검증. **추가로 원핸드 OFF→ON 없이 최초 실행은 독립 미검증 게이트로 남김.**
7. 모든 실기기 동작 실제 PASS 전 신규 설치본을 FINAL/GOLDEN 승격 금지. 실패시 변경한 picker-only component를 제거한 상위 버전 R648 기능 복귀. **사용자 현재 R648 설치 상태는 그대로 유지**.

## 공통 프로젝트 경계
이 문서는 MOA 사진 기능 개발 지침이다. 독립 AA AirPods Android Auto 오디오/daemon/GitHub runtime의 소스나 상태를 변경하지 않는다.

## 추가 실제 소스 감사 (2026-11-16)
R648 실제 설치 APK를 이전 Library release ZIP에서 읽어 확인한 결과 기존 사진 추가 자산은 `assets/web/moa-r640-lazy-picker.js`(19,577B) 및 CSS(6,785B)이고, 원본 native Gallery open/close 함수에 직접 접근하지 않는다는 주석·코드가 존재한다. 그러나 기존 picker JS의 `ensureBack()`는 실행 시 전역 `window.__fjBackOverlay`와 `window.__photoMapBack`을 체인으로 감싸며, ESC/Backspace 캡처 및 `popstate` 이벤트 리스너를 설치한다. 이는 **새 기능과 원본 화면의 간접적인 상태/네비게이션 충돌을 감사해야 할 구체적 지점**이지, 기존 R629~R647 실패의 확정 원인이라는 뜻은 아니다. 기존 R648 구현에서 정상 동작 중인 전역 경로는 함부로 정리하거나 고치지 말고, 새 사진 추가 구현은 자체 로컬/독립 owner의 닫기·뒤로가기 계약을 갖춰 원본 글로벌 callback을 중복 후킹하지 않는다. 기존 picker의 `render()`/`renderPreview()`에서 `root.replaceChildren()`과 `resetVideo()`를 호출하는 구조, `content://media/external/video/media/` WebView 재생, `__requestThumbs` 썸네일 fallback도 품질/영상/상태 전환의 감사 대상이다. R648의 6 img + 2 video RESOURCE_LOAD_ERROR는 구체 URL/예외 타입을 로그에 싣지 않으므로 위 각 경로의 인과관계는 아직 미확정이다.

## 2026-11-16 R649 build addendum (DO NOT overwrite R648 scoped Golden)
Optional **R649 code649 same-original-signer photo-add beta** SHA256 `0ce91e563f8076a7b0218b2488b1f9e0127d6d5014a96a0ebc82680d31ad061e`; **R650 code650 exact R648-function forward recovery** SHA256 `dac8e53eabe4cef3132a94deee8c85b4025440a1d40f5f58126f681863f6ce6c`. Signed source+APK+QA ZIP SHA `5cb053e4953fbc533bfc17e4fc063f523ca2792f79f732c37697e40d12f82184` private Library `/모아_프로젝트_근거_20261103/R649_R648_GOLDEN_ISOLATED_PHOTO_ADD_20261116/`. R649 changes only Manifest/pickerJS/pickerCSS/trace build label; 144/148 original members byte exact, DEX18 exact, native Gallery/calendar/QuickRecord guarded source exact. Static/browser QA PASS; **NO physical Galaxy success yet**. Read full [R649/R650 handoff](MOA_R649_R650_R648_GOLDEN_ISOLATED_PHOTO_ADD_SIGNED_HANDOFF_20261116.md) before any later changes. Never auto-install/auto-reset current R648. Only user-authorized R649 update and emergency R650 restore.
