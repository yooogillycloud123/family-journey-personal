# FamilyJourney — NAVER FAVORITES / NO BATTLE canonical (2026-10-31)

## Exact user choices (override old feature inventory)
- **지도 대결/친구 랭킹/소셜 로그인은 완전히 제외.** 이 기능을 유지하기 위해 서버를 만들 필요가 없음. 기존 개인 여행기록·추천·여권·영상은 보존해야 함.
- **원작자 도메인, 계정, 분석 및 서버 연결은 0건이어야 함.** 네이버지도와 사용자가 명시적으로 선택한 지도/공공 데이터 제공업체만 따로 허용. 기존 R12 실제 기기에 배포된 앱은 이 조건을 충족하지 않음.
- **PC용 '주소→네이버지도 실제 즐겨찾기 등록'이 최근 1주일 내 실제 성공했다고 사용자가 확인함.** 과거 8월 스크립트, 2026-10-24 전국 근무지/보훈수당 지도 검증(등록 0건)과 혼동하지 말 것. 성공한 최근 PC 소스/재현 기록은 현재 연결된 repo/project 파일에서 아직 찾지 못했으므로 임의로 구현했다고 단정 금지.
- 요청 기능: **자동 사진 EXIF GPS/촬영시각→장소/주소 후보→여행별 중복제거→네이버지도 사용자의 저장 목록에 진짜 즐겨찾기로 등록**, 완전 별도 독립 Android 앱에 일체형. 원본 사진 외부 전송 금지.

## Pipeline
1. 기존 R12+ native MediaStore + ACCESS_MEDIA_LOCATION + EXIF 자동 수집 엔진 재사용. 이미지마다 위치가 없는 경우는 구분하여 건너뜀.
2. Local trip+stop grouping (same city, close distance/time); individual-photo-per-favorite 하지 않음. 예: 80장 찍은 한 장소 => 최대 1개 후보.
3. 250 국내 시군구 행정경계와 공간 데이터로 좌표→지역명; 주소(지번/도로명) 및 Naver POI 검색/매칭 별도 구현. 단순 좌표를 Naver 지도에 띄운 것 ≠ 즐겨찾기 실제 등록. 식당/숙소/카페 위치 오인 방지용 후보 신뢰도와 확인 단계.
4. Naver account login is performed only in its own domain/client on user device; never collect or send passwords/token to FamilyJourney/backend.
5. Android-specific saving driver needs an observed Naver Maps mobile-site UI or official supported API; as of 2026-10-31 official `nmap://search` and `nmap://place` support SEARCH/SHOW, **not favorites insertion**. Adapt validated recent PC automation **only after locating actual original code + establishing mobile UI controls**; do not claim direct URL intent auto-saves.
6. Persistent local queue with exact Naver place identity (when available), target personal favorite list, per-record state: DISCOVERED/REVIEWED/PENDING/CONFIRMED/FAILED; after actual saved-state UI readback confirm success. Dedup by POI ID and prior saves; interruption-safe/resumable.
7. Show '네이버지도 저장' on app's trip/place page with batch save progress. Explicit approval and visible export/sync action; avoid silent upload of full history; location/place query to Naver only after consent.
8. Regression checks: original EXIF autocapture, map UI/region fill, camera/resolution/video, Korean place names and user photo privacy unaffected. One APK; no extra helper APK/PC required as final. Separate PC fallback only for comparison/testing, not product requirement.

## Limits and verification gates
- The successful user PC implementation is a user-reported verified result, but its exact source and selectors have not been retrieved. Not safe to invent implementation details (Selenium etc.).
- Naver Maps official Android app deep-link docs show navigation/search/place but no automatic favorites add command; actual mobile registration requires app/site UI mechanism or provider-supported write API.
- Android WebView vs native Naver app contexts have separate auth/session restrictions; may require user logging in once on the Naver site, and site DOM can change. No guarantee before physical tests.
- Original developer's code/servers may remain in existing R12 APK; a source patch to network allowlist cannot be equated with shipping validated private R13.
- Data sent to Naver for user-initiated searches is distinct from leaking data to original travel app vendor; demonstrate audit of each externally contacted domain.
