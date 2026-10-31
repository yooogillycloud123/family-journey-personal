# FamilyJourney 최신 Canonical READ FIRST — 2026-10-31 R21

**새 대화에서 모든 분석·소스 변경·APK 빌드 전에 이 파일을 처음부터 끝까지 읽고 가장 최신 체크포인트부터 재개한다.** 본 파일은 이 저장소의 오래된 v0.1/v0.2 시제품 설명이나 R12 이하 인계 문서보다 최신이다. AirPods 별도 프로젝트 지침과 섞지 말 것.

## 1. 사용자 확정 요구
- **사용자 가족용 단일 Android 앱** `FamilyJourney`, 삼성 Galaxy S26 Ultra.
- 기존 여행여권과 별도로 설치, 기존 정품 앱·프리미엄 구매 데이터 보존. 기존 R15~R21 개인 앱의 정상 지도/사진 GPS/사진 마커/영상/여권/고급 해상도·테마/빠른 실행 기능은 삭제하지 않는다.
- 추천/축제/지도대결/불필요한 소셜 서버 기능은 사용자 요청으로 제거 완료. 새 릴리즈에서 복구하지 않는다.
- 원작자 서버·개인정보 전송 차단 유지. 온라인 지도를 켜면 지도 제공사 요청 가능, 네이버 검색/저장은 사용자가 명시적으로 실행한 경우에 한함.
- 사진 위치 **원본 EXIF GPS**로 25m 단위 군집, 실제 주소/좌표 사용. 남원/전주 같은 시군 지역명을 네이버 즐겨찾기 장소로 저장하지 않는다. 상세주소 조회(예: 전남 진도군 의신면 초사리 1205) 성공을 보존.
- 장소에 연결된 사진 N장 3열 미리보기와 **앱 자체 전체화면 사진 뷰어** 1~6x 두 손가락 연속 확대, 축소, 확대 후 이동, 자연스러운 가로 스와이프/다음 사진, 뒤로가기 닫기 보존.
- 최신 요청: **현재 선택된 원본 사진을 Android 공유 시트(카카오톡 등)로 보내고 삼성 갤러리에서 해당 사진 직접 열기.** 사용자 요청 시에만 명시된 사진 1장 URI 공유, 앨범 자동 전송 절대 금지.
- 현재 네이버 저장: 사진 GPS 상세 주소를 네이버지도에서 찾아, 사용자가 입력한 **메모 최대 50자, 별명 최대 25자**, 저장 리스트(예: `내 장소`)를 골라 네이버 계정 즐겨찾기 저장. 기존 PC 성공 절차는 아직 원본 소스 미확인. 임의 지명/별명으로 네이버 검색하는 오류 재발 금지.
- 최근 실기 영상 `17519.mp4`에서 사용자가 메모·별명 입력, `내 장소` 선택, 저장을 하기 위해 매번 추가로 화면을 터치해야 했음. **원인은 AccessibilityService가 이벤트만 기다려 stage 전환을 놓치고 IME 키보드가 NAVER UI를 가린 경우**로 분석; 가설이며 실제 기기 로그 검증 필요. 사용자는 각 단계 사이 터치 없이 자동으로 진행되기를 원함.
- 사용자 계정 실제 저장 완료 여부를 **버튼 클릭 자체와 혼동하지 말 것**. 앱에서 `VERIFIED`는 네이버지도 저장 확인 UI 판독 후에만. 기기에서 검증하기 전 "완전 자동 저장 성공" 주장 금지.

## 2. 위치/아티팩트
- GitHub: `yooogillycloud123/family-journey-personal` `main`, 공용 소스는 `androidHost/app/src/main/java/com/juhyeon/familyjourney` 등. **상용 앱에서 추출된 웹 자산, 가족사진/GPS, 서명키는 공개 GitHub에 업로드 금지.**
- R20 유저 설치 검증: `/mnt/data/FamilyJourney_R20_PinchZoom_NaverFavorites_Fix.apk` 패키지 `com.juhyeon.familyjourne2` versionCode20, 개인 서명키 `/mnt/data/_fj_r17/signer/familyjourney_v16_owner_stable.p12`와 pw 파일 (절대 외부 공유 금지).
- R20 자체 웹 갤러리 소스 `/mnt/data/_fj_r19/fj-naver-favorites-r20.js`. R20 패키징 레시피 `/mnt/data/_fj_r19/package_r20.py`. R20 host `FamilyJourney-R20-NativeHost.zip`.
- 최신 R21 수정 웹 갤러리 `/mnt/data/_fj_r21/fj-naver-favorites-r21.js`, synthetic JS 검증 `/mnt/data/_fj_r21/test_share_gallery_r21.py` PASS.
- R21 native source commits: `701333723f658cdcd5a36d01277b29357373044d` photo sharing; `e5e5bab0a0f3560a2d266f664aa11a63ab14fb4f` periodic NAVER advance + keyboard-aware stage3; `4d1f021421a0f0ac13ccff9106384bdccf0a166a` NAVER window obtained even if IME foreground; version21 at `3d63b58def723a5e7a85af1957fa4f1665c6fc07`.
- Commit/build native path may change on latest branch; always check main SHA and CI. Initial R21 CI 41183868443.
- R21 APK package/signature MUST stay `com.juhyeon.familyjourne2` and same signing cert as R20 so in-place upgrade and user data preservation. Do not change identity or create extra apps.

## 3. New R21 code design
- Photo gallery R20 core untouched; added a row `공유 · 카톡 등` and `갤러리에서 열기`; JS `NativeHost.post('sharePhoto', {id})` or `('openInGallery',{id})` for *currently viewed* original MediaStore ID.
- Native HostActivity: ACTION_SEND with `content://media/external/images/media/<id>`, `ClipData`, `FLAG_GRANT_READ_URI_PERMISSION` and Android chooser; ACTION_VIEW with Samsung Gallery `com.sec.android.gallery3d` and generic view fallback. No external media selected without user intent.
- NaverSaveService: no new event after programmatic clicks can stall; add Handler poll every 500ms while armed (2.4 sec while idle) and only inspect Naver Maps package, 180sec job expiry. Once text filled in NAVER, if keyboard TYPE_INPUT_METHOD present, try back action to hide keyboard only, and proceed to list/submit. Uses `getWindows()` Naver root even with IME focus. Avoid repeated toggling and taps after confirmed list selection, prevent fake verified.
- **Still not verified on Galaxy**: share sheets, Gallery URI association, permission selection, NAVER real account list/alias/memo saved state. If UI automation fails, need status logs per stage and adjust exact NAVER UI, not invent finished claim.

## 4. Verification gates
- Android CI success Gradle compile → zipalign → release signed with SAME cert as prior → apksigner verify (v2/v3) → aapt package/version → APK CRC → main old JS bytes unchanged except the additive `fj-naver-favorites.js`.
- Chromium synthetic photo gallery navigation/pinch/share button action and Android Back. User screenshots R20 prove pinch and preview actually working.
- Real Galaxy user test: first installed R21 → open one photo → Share (Kakao chooser), open Galaxy Gallery; then NAVER `주소로 저장 + 메모` → exact address remains → user only chooses correct result if ambiguous → auto star, text fields, list, blue Save without extra taps → verify in saved list and memo. If unverified, report stage and do not say complete.

## 5. Do not repeat regressions
- Do NOT add separate "로컬 즐겨찾기" substituting NAVER account saved list (R16 was rejected); do NOT re-add 추천/대결; do NOT show demo/premium billing.
- Do NOT remove all features because an external endpoint blocked. Preserve map, picture, film, premium-grade options, independent network.
- Do NOT use a different package/signing key and break upgrade; no additional helper apps; no R15 rollback.
- Do NOT claim PC favorites script identified; it was not in available data.
