# 모아 R605 골든 성공 원리와 R609 반복 감시 토글 회귀 분석·수정 인계서

**작성일:** 2026-11-15 · **상태:** R605 사용자 실기기 승인 골든, R607 기능 확장 사용자 확인, R609 원본 서명 베타(실기기 검증 전)

## 0. 이 문서를 읽는 이유 — 절대 변경 금지 규칙

모아의 원본 고속 네이티브 갤러리를 복구하기 위해 R594/R596/R598/R600/R602 등 여러 버전이 제작됐지만, 이전 갤러리 실기기 실패가 반복되었다. **성공한 R605의 구현을 다시 추정·리팩터링·구형 Web 갤러리로 대체하지 않는다.** 이후 새 채팅에서는 항상 이 문서와 R605 원본을 먼저 확인한다. 골든의 모든 검증되지 않은 변화는 새 개발 브랜치에서만 한다.

- 원본 앱: `com.juhyeon.familyjournea`, 서명 인증서 SHA256 `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`.
- 사용자 승인 골든 **R605 APK** 9,100,992B, SHA256 **`b357112dd2c90194b218ad197ee988b85fb4edd2a8275b0fe68cb283ed431030`**.
- 고정 소스 `golden/moa-r605-user-device-approved-native-gallery-20261115`; 개인 Library `/모아_프로젝트_근거_20261103/GOLDEN_R605_USER_DEVICE_APPROVED_20261115/`.
- 원래 골든 R567·R463도 역사적 완전 복구를 위해 별도 고정. 새 기준은 R605. 원본 R605 ZIP·APK/서명·보호 DEX를 수정하거나 덮어쓰지 않는다.
- 2026-11-15 사용자 영상 `22375.mp4` 107.7초에서는 갤러리 최초 진입, 네이티브 조작 메뉴와 빠른 필름스트립, 사진형/상세형 왕복을 확인했다. 사용자는 추가로 앱 홈/백그라운드와 타 앱 전환 뒤 복귀도 실제 성공했다고 보고했다. **이는 R605 실기기 성공의 근거**다. R609의 반복 감시 토글까지 검증된 것은 아니다.

## 1. 왜 이 문제가 오래 갔는가 — 실제 원본의 소유 구조

모아는 일반 Web 포토 뷰 하나가 아니다. (1) WebView/IndexedDB가 달력·사진형 프레임 위치·상세형 텍스트/기록을 소유하고 (2) Android 원본 `MoaNativeGallery`가 카메라 MediaStore 사진/영상 디코딩, TextureView/MediaPlayer, 8개 버튼, 하단 가로 관성 필름스트립을 소유하며 (3) `MoaR507InlineGalleryProvider`가 **기존 Activity 루트에 속한 원본 네이티브 Gallery.host + stage**를 WebView의 사진 카드 위치·폭·높이에 맞춰 배치한다. 웹뷰를 통째로 삭제하는 것이 아니라 **기존 위치 참조 DOM은 남기고 사용자에게는 네이티브 호스트가 보이게 한다**.

- 사진형 JS `assets/web/moa-r483-vertical-calendar.js`: `r507StartInline()` → `MoaLocalAudio.openNativeGallery(JSON.stringify(ids), index, day)` → 실제 Android 최초 MediaStore URI 검증.
- 진입 선행 조건 `__moaR507BridgeReady` 및 `__moaR511InlineArm` / `__moaR511NativeArmed`: 원래 Activity와 프레임 준비 이후 열기. 기존 R567에서 이 순서가 물리적으로 성공했었다.
- Java `MoaR507InlineGalleryProvider.java`: `maybeArm()` → 프리드로우 가드 → `attachCard()`에서 원본 `host/stage`의 실제 부모 계층과 위치·크기 검증 → 원래 갤러리 호스트를 사진 카드 위로 부착. 원본 Gallery/단축 버튼 click listeners 수정 없음.
- `r572FinishEntry()`가 `__moaR507NativeMounted(true, dayToken)`을 JS로 알리고 JS는 원본 네이티브 소유 클래스를 유지. 상세형·외부 앱 왕복은 명시적 Back과 단순 Activity pause/resume을 구분한다.
- **구형 Web 페이저는 성공 원본의 대체물이 아니다.** `r594Fallback/r596ShowWeb`은 실제 네이티브 Open 거부 등에서만 제한적으로 쓰며, 정상화했다고 보고할 근거가 아니다.

## 2. 과거 실패에서 실제로 확인된 코드 함정과 R605에 이른 교정 이력

아래는 **소스 확정 사실**과 **기기 성공 여부**를 분리한 기록이다. 모든 이전 버전이 전체 휴대폰에서 통과한 것은 아니다.

| 단계 | 소스에서 관찰한 결함/수정 | 실기기 상태 / 한계 |
|---|---|---|
| R463 / R567 | 원래 고속 네이티브 갤러리·필름스트립·액션버튼, Activity 호스트, 백그라운드 복귀를 유지하는 성공 계보 | 과거 사용자 승인 정상 기준 |
| R594 | 원본 갤러리의 이미지 비트맵 준비/JS와 네이티브 부착 판정이 어긋날 수 있고 사진 카드가 비거나 터치가 막힘 | 영상에서 문제 확인 |
| R596 | 네이티브 사진 준비 불확실 때 구형 Web 갤러리를 유효 fallback으로 표시하도록 변경 | 구형 갤러리 표시는 됐지만 네이티브 정상 복구 아님 |
| R598 | 새 바로기록의 IndexedDB ID는 저장됐지만 WebView `byId` 사진 색인이 비동기라 늦음. 원본 Android MediaStore 읽기 성공과 별개인데 이를 Open 금지 조건으로 혼동하던 검사를 완화 | 네이티브 기본동작 실기기 성공 미확정 |
| R600 | `ImageView.getDrawable()` 지연만으로 네이티브 전체 호스트를 비노출하거나 Web으로 강등시키지 않고 원본 Gallery 유지 시도 | 사용자 실기기 여전히 원본 메뉴/레일 부재 |
| R602 | **동일 날짜 새 사진 추가 → JS `render()` → `r507StopInline()` → `closeNativeGallery()`** 경로를 소스에서 발견. 원본 호스트·비디오·8개 액션까지 파괴. 사진 목록만 업데이트하는 Java `r602PollPlaylist()`/JS `__moaR602PlaylistUpdate`로 변경 | 갤럭시 최초 Open 실패는 여전히 남음 |
| R604 | R602에서 준비 신호 없이 일정 시간 뒤 강제 원본 Open 시도하던 경로를 제거하고 R567의 `__moaR511NativeArmed` 필수 준비 순서 복원 | 소스·모의테스트, 실기기 미검증 |
| **R605** | Java `r572FinishEntry()`가 **8개 버튼 `actionDeck`가 즉시 있어야** 원본 네이티브 장착 ACK를 보내던 불필요한 게이트 제거. 실제 Activity-root에 원본 `host + stage`가 붙으면 ACK하고, 액션덱은 비동기 준비와 분리. R602 동일 날짜 In-place hot playlist와 R567 진입 준비 절차 둘 다 유지 | **사용자 `22375.mp4` + 보고로 실제 성공 승인: 새로운 불변 Golden** |
| R607 | 오디오/바로기록 본문 저장을 `curated.body`에도 반영하는 좁은 웹 JS 수정. 상단 설정 UI를 오른쪽도 슬라이더처럼 만들어 사용자 의도와 다른 외형이 됨 | 사진 본문 반영 사용자 스크린샷 확인, 골든 재승격 아님 |

**R605 성공에 핵심적인 불변조건**
1. 정상 원본 갤러리가 이미 열렸으면 `render()`나 타이머 때문에 전체 close/reopen 금지.
2. 원본 Gallery의 활동 Activity/호스트/stage를 실제로 검증하고, 버튼 구성요소 초기화 지연을 네이티브 성공 실패로 오인하지 않기.
3. MediaStore URI 실제 읽기 가능성과 별개 Web 인덱스 업데이트 지연을 구분.
4. 카메라 촬영·바로기록은 기존 상세 일기 `curated.photoIds`, `moments[].note`, `body`, `voiceIds`를 공유하고 IndexedDB 저장 ACK 후 한 번만 갱신.
5. 새 사진이 같은 날짜에 추가되면 기존 네이티브 호스트와 선택·8개 버튼·TextureView를 보존하며 원본 갤러리의 `ids`만 갱신. 데이터 변경이 아닌 Home/Recents/외부 앱 복귀는 Android pause/resume으로 처리, 사용자가 Back 한 것으로 오인하지 않기.
6. GUI 설정, Naver 오프스크린 저장, 카메라 감시 ON/OFF는 갤러리 소유 전환과 무관한 별개 제어 영역. 단순 설정 변경은 갤러리 렌더 트리를 절대 재생성하면 안 됨.

## 3. 22427.mp4 반복 토글 회귀 — 정확한 관찰과 확정 소스

**실제 영상:** `22427.mp4` 약 76.34초. 중간에 홈으로 나갔다 앱 재진입 후 사진형에서 검은 화면(초반 약 4~26초), 상세형 이동(약 28초) 후 복귀에서 회색 영역을 거쳐 사진이 다시 표출(약 32~40초), 설정 화면의 **사진 및 데이터 → 촬영 즉시 기록 ON·끄기** 경로를 사용(60초 전후). 사용자는 설치 직후 첫 전환은 동작하고 두 번째부터 네이티브 갤러리가 사라진다고 보고했다. 영상만으로 Android Service 재시작/ContentProvider 수명/네이버 인증 세션의 정확한 원인까지 확정할 수는 없다.

**확정 소스 결함:** R607 `assets/web/family-diary.js:mmToggle()`의 네이티브 모드에서 `MoaMomentNative.setEnabled(desired)` 호출 뒤 다음 코드가 있었다.

```javascript
if(S.open){
  render();
  setTimeout(()=>{if(S.open)render()},700);
  setTimeout(()=>{if(S.open)render()},1900);
}
```

같은 파일의 `render()`는 실행 초반 `S.root.replaceChildren()`으로 상세 일기 전체 DOM을 교체한다. `S.open`은 상세 일기의 내부 열린 상태이며 네이티브 사진 카드가 별도 소유 중인 것과 동일하지 않다. **네이티브 카메라 감시만 전환할 때 일기 화면을 세 번 전부 재생성할 이유가 없다.** 앞서 R602에서 고친 네이티브 갤러리 소유·일기 DOM 재렌더링 경쟁을 다른 설정 경로가 다시 만들 수 있다. 따라서 이는 소스로 확인된 불필요·위험한 로직이며 실제 반복 실패의 합리적인 원인 후보이다. 이 경로만으로 기기 원인 전체를 확정하지는 않았다.

**서로 다른 기능임을 구별:** ‘촬영 즉시 기록 ON·끄기’는 원본 네이티브 촬영 감시 브리지 `MoaMomentNative.enabled()/setEnabled()`에 연결되어 있다. 네이버 PC 웹 로그인·숨김 WebView 계정 저장 기능과 동일한 스위치가 아니다. 사용자가 네이버 비점유 저장을 위해 껐다 켰다는 경험은 사실로 보존하지만, 이 설정이 네이버 저장의 필수조건이라고 코드가 보장하지는 않는다. 따라서 네이버 저장 세션을 강제로 재시작·초기화하지 않는다.

## 4. R609 패치 — 무엇만 고쳤는가

1. R607 원본에서 `family-diary.js`만 아주 좁게 수정: `native.setEnabled(desired)` 호출과 기존 네이티브 기록 처리·설정 유지. `render()` 3회 호출을 없애고 `mmSyncNativeSwitchUI()`로 현재 **버튼 텍스트·ON/OFF 클래스·ARIA 상태·안내문**만 갱신. 최초·700ms·1900ms 갱신은 **DOM 파괴 없는 작은 읽기/표기 갱신**. 감시 껐다 켜는 기능 자체를 제거하지 않는다.
2. R607 사진형 CSS의 오른쪽 슬라이더 복제품만 재정의: 68×34 버튼의 바깥 크기를 왼쪽 전환 버튼과 맞추되, 가운데는 `···` **일반 설정 버튼**, 스위치 트랙·이동하는 손잡이 없음. 기존 `onSettings` 클릭·접근성 이름·실제 메뉴 유지. 사진형/상세형 두 모드 동일.
3. 원본 `MoaNativeGallery`, Java ContentProvider, classes.dex~classes18.dex, Android Activity, MediaStore, 네이버 숨김 저장·쿠키·위치, 본문 `curated.body` 반영(이전 R607) **전혀 수정하지 않음**.
4. 검증: `mmToggle` **실제 수정 함수**를 Node VM에서 실행해 ON→OFF→ON→OFF 4회, `native.setEnabled()` 정확히 4회, `render()` **0회**, `replaceChildren()` **0회**, 버튼·ARIA 상태 일치 PASS. 브라우저 실제 CSS: 사진·상세 설정 버튼 각각 68×34, 중앙 `···` PASS. 정적 JS parse PASS.

## 5. 버전, 보호범위, 서명 및 복구

| 파일 | 버전 | 정확한 SHA256 | 변경 |
|---|---:|---|---|
| 설치 R609 `MOA_R609_R605_GOLDEN_CAPTURE_TOGGLE_GALLERY_SAFE_AND_SETTINGS_DOTS_SIGNED_BETA.apk` | 609 | `eed6629e9874d10c12b11beea199fa7d73f68aa564c25455088a8e0960c8d127` | R607 대비 `AndroidManifest.xml`, `assets/web/family-diary.js`, `assets/web/moa-r483-vertical-calendar.css`만 변경 (141/144 바이트 동일) |
| 비상 R610 `MOA_R610_EXACT_R605_GOLDEN_FORWARD_RECOVERY_ORIGINAL_SIGNED.apk` | 610 | `cc02a51b8c309a89e039bc9a587c10392c0507cbc15682d67d0b5249a98145e3` | 승인된 R605 기능 데이터 143/144 바이트 동일, AndroidManifest 버전만 605→610 |

R609/R610 모두 원래 서명 인증서 일치, APK Signature Scheme v2 RSA / Android SDK 29·35·37 검증, 18개 DEX SHA1/Adler32 및 원본 동일, ZIP CRC/정렬 PASS. **R609는 R605 골든이 아님.** R609 설치 후 새 심각한 회귀가 확인되면 R610으로 원래 R605 기능을 데이터 삭제 없이 덮어 복원한다. R610은 R607 이후 텍스트 기능까지 복원하는 것이 아니라 **R605 골든 기능**으로 돌아가는 복구다. R610 설치 이후 다음 개발 APK는 versionCode 611 이상이 필요.

원본 R605 APK/서명키/개인 사진·음성/로그인 인증은 GitHub나 공개 ZIP에 업로드하지 않는다. 공개 GitHub에는 비밀 없는 개발 문서·SHA·diff만 기록한다. 원본 R605과 개발 후보/복구용 파일은 개인 Library에서 서로 다른 폴더로 보존.

## 6. 다음 단계의 실기기 판정 — 통과 전 FINAL 금지

1. R609를 현재 설치된 같은 인증서 R607에 **업데이트 설치**. 앱 삭제/데이터·캐시 삭제, 네이버 로그아웃/재로그인 금지.
2. 첫 실행의 기존 사진 날짜 → **네이티브 8개 버튼·빠른 필름스트립·사진/영상·상세형 왕복** 확인.
3. 사진 및 데이터 → ‘촬영 즉시 기록’ OFF→ON→OFF→ON **최소 3회**, 매번 기존 사진형 복귀, 홈→모아 복귀, 타 앱→모아 복귀. 화면 검음/회색/구형 Web 갤러리 없는지 확인.
4. 바로기록 새 사진/음성 메모 저장: 네이티브 원본 갤러리 유지, `오늘의 이야기` 본문에 인식 텍스트, 기존 개별 기록 및 M4A 보존, 중복 추가 없는지 확인.
5. 네이버 저장: 기존 인증·비점유 저장 세션 유지. 수동으로 껐다 켜는 설정 없이 최초/반복 저장의 실측 결과를 구분. 네이버 저장 성공은 **별도 PASS 기준**이며 화면만으로 성공을 주장하지 않음.
6. 미통과시 즉시 **설정 → 원본 갤러리 진단 복사**의 비개인 단계 코드(`BRIDGE`,`ARM`,`OPEN`,`HOST`,`DECK`,`MOUNT`)를 확보. 이 진단에는 사진·메모 내용이 없지만 전송 전 사용자가 검토 가능. 원인이 확정되기 전에 타이밍 임의 변경, Gallery.close 반복, 앱 데이터 삭제는 금지.

**R609 실기기 상태: PENDING (정적/서명/모의 브라우저 검증만 완료).** R605만 현재 사용자 실기기 승인 Golden.