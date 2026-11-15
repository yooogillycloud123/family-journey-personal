# MOA R617 — R615가 잘못 비교한 것은 버튼 외곽이 아니라 가시 트랙 크기 (2026-11-15)

## 사용자 실기기 증거 (절대 추측보다 우선)
- 사용자가 R615 설치 후 올린 `22551.png`에서 왼쪽 사진형/상세형 토글은 얇고 긴 트랙인데 오른쪽 설정 버튼은 두껍고 큼. 둘은 시각적 중심과 높이가 다른 상태.
- R615 이전 답변은 "왼쪽 68×34, 오른쪽 36×34, 높이가 같다"고 보고했으나 이것은 **CSS 버튼 외곽 터치 영역의 크기**로, 사용자가 실제 보는 가시형 배경을 비교하지 않은 부정확한 QA였음.
- 실제 R615 `moa-r483-vertical-calendar.css`: 왼쪽은 `html #... .moa-r483-oval-switch::before`에서 **44×19 CSS px 가시 트랙**으로 나타남. 오른쪽 설정의 `.moa-r615-settings-control`은 **36×34 CSS px 버튼 면 전체**에 배경과 테두리를 채움. Galaxy 화면 스케일에서 약 84×36 vs 68×64 물리 px로 불균형하게 보이는 원인. 이전 QA는 이 차이를 시험하지 않음.

## 수정 방식 — 실제 사용자가 보는 가시 트랙 측정
- 원본 R615 서명 APK를 기준으로 변경. 기존 버튼이 연결된 `r539DayChrome()`의 `onSettings` 클릭 핸들러, 날짜형 전환, 사진/상세형의 완전한 기능은 일절 바꾸지 않음.
- 정확히 `assets/web/moa-r483-vertical-calendar.css` **끝에 규칙을 추가**해 오른쪽 독립 설정 버튼 바깥 영역은 48×34를 유지하되, 설정 버튼 **눈에 보이는 `::before` 타원은 왼쪽과 같은 44×19 CSS px**로 표시함. 같은 색상/테두리/반지름을 공유하고 두 배경의 세로 중심선을 일치시킴.
- 설정 아이콘 14×14px; 원래 기능은 설정이며 왼쪽 슬라이더의 움직이는 노브를 복제하지 않음. 클릭 대상 사이 flex gap 4px.
- 사진형과 상세형 모두 동일 selector로 적용. 8개 native Gallery 아이콘/미디어·네이버 One Hand 접근성 서비스·음성 녹음/재생·바로기록/일기 저장 로직 변경 없음.

## 실제 QA
- 실제 R615 앱 CSS 전체를 적용한 Chromium `360/390/412 CSS viewport × 사진형/상세형` 6/6 PASS.
- 각 테스트에서 왼쪽 **가시 트랙** 44×19, 오른쪽 가시 트랙 44×19, 버튼 바깥 높이 양측 34, 세로 중심 차이 0, 설정 원래 클릭 이벤트 정상. 이는 브라우저 검사이며 **Samsung Galaxy 실제 화면에 설치한 결과는 아직 아님**.
- 원본 R615 APK vs R617: APK 144개 내부 항목 중 **142개 정확히 동일**, 변경 `AndroidManifest.xml` versionCode615→617과 **photo CSS 하나**뿐. 원본 R611 골든의 **18개 DEX 모두 바이트 단위 동일**, 총 144 항목 ZIP CRC PASS, 저장 항목 정렬 PASS, Android APKv2 SHA256/RSA 원본 인증서 서명 검증 SDK29–37 PASS.
- R617 설치: `MOA_R617_R611_GOLDEN_MATCHED_SETTINGS_VISIBLE_TRACK_ORIGINAL_SIGNED_BETA.apk`, versionCode **617**, size **9,113,279 bytes**, SHA256 **`080049a3b736efcc3add032df9de09e23f5dd69302cbb87a0e00ad343ab7099c`**.
- R618 응급 복구: `MOA_R618_EXACT_R611_USER_GOLDEN_FORWARD_RECOVERY_ORIGINAL_SIGNED.apk`, versionCode **618**, SHA256 **`ff16c59582229b2065dfc0b83dea20c132f51dfc37c2e90e6121ca7a527a8e93`**, R611 골든 대비 **143/144 항목 동일**, `AndroidManifest.xml` versionCode만 변경. R613/R615 UI 개선은 복구 시 손실. 이후 신규 APK versionCode>=619.
- 배포 ZIP `MOA_R617_R618_R611_GOLDEN_VISIBLE_SETTINGS_TRACK_SIGNED_QA_20261115.zip` SHA256 **`395f05bd34f31406b4be0c951e03219694aadea73c8b3d46e73d492a286e0a96`**. 원본 서명 키/비밀번호, 사용자 사진/메모는 ZIP에 없음.

## 필수 향후 원칙
- **현재 사용자 승인 최상위 골든은 여전히 R611**, R615/R617은 브라우저 테스트 PASS만 확인된 베타. R611 Immutable APK·Github Golden 브랜치 수정하지 않음.
- UI 크기 비교에는 (a) 클릭 영역, (b) 실제 보이는 가시 표면, (c) 내부 아이콘, (d) 부모 정렬·간격을 각각 측정할 것. 자식 요소 `::before/::after`의 실측 크기를 확인하지 않은 채 "동일 높이"라고 주장 금지.
- `R611` 성공 원리(네이버 접근성 서비스 OFF→ON 시 native Gallery owner 보존)와 `R613` 음성·사진 UI 기능을 안전하게 보존. APK 설치는 덮어쓰기만; 앱 삭제·캐시/데이터 초기화 금지.
