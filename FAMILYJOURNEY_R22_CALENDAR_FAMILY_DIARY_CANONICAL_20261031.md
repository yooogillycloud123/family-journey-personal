# FamilyJourney R22 — 가족 달력·사진 일기 Canonical 확장 지침 (2026-10-31)

## 사용자 요구 (2026-10-31 최신)
기존 FamilyJourney R21(사진 GPS 여행 지도·정밀 25m 장소·네이버지도 주소/메모/별명 보조·사진 풀스크린 1~6x 확대/좌우 제스처·공유/갤러리·여행 영상·기록)의 모든 정상 작동을 유지하고 **한 앱에 사진 중심 달력형 가족 일기**를 추가한다. 사용자가 제공한 D·LOG v1.14.3 (com.softlunch.dlog) split APK는 기능 참고자료이며, 해당 상용 앱의 자산·코드·결제/서버 의존성을 복제하거나 공개 GitHub에 게시하지 않는다. Google Play 데이픽 (com.teamgugu.daypic)도 '사진 달력 + 일기' 방향 참고용이며 UI/코드 복제 금지.

원하는 사용자 흐름: 달력에서 날짜별 대표 사진과 사진 수 확인 → 해당 날 원본 사진을 자동 모아서 촬영 시각 순으로 여러 활동 구간 정리 → 여러 장을 임의 선택 또는 **하루 전체 일괄 선택** → 제목/본문/태그/감정/활동별 메모 기록 → 저장·수정·삭제·다시 보기 → 나중에 여행 GPS 지도/영상과 상호 이동. 사진의 시간·GPS로 확인할 수 없는 식사/장소/활동을 AI가 추정해 사실처럼 기재하지 않는다. 장소/날씨/동선 자동 복원은 명시적 신뢰 가능한 데이터가 있을 때만 가능하다.

## R22 구현 단계
- 기존 하단 [나의 지도 | 기록 | 설정]을 유지하면서 **[일기]** 탭 하나만 추가 (추천/대결 재추가 절대 금지).
- Android native `diaryIndex`: MediaStore 이미지 전체에 대해 DATE_TAKEN/DATE_ADDED와 ID만 읽어 (GPS 없는 가족사진도 포함) WebView로 160건씩 전달. 시간 없으면 DATE_ADDED 대체를 반드시 `approx=true` 표시. 원본 파일·사진·GPS의 외부 전송 금지. 이 색인은 사용자가 일기를 열거나 '사진 다시 읽기'할 때만 수행하며 앱 홈의 1분 지연을 재도입하지 않는다.
- `family-diary.js/css`: 독립/신규 저작물로 구축. 월 이동, 날짜 대표 사진, 사진 개수/기록 여부, 시간순(60분 이상 간격) 자동 묶음, 같은 날짜 N장 선택/일괄 선택, 제목·본문·태그·기분·활동별 메모, IndexedDB 내보내기(JSON), 일기 수정·삭제, Android Back 처리, 한 장 확대·공유·갤러리 열기.
- 앱에는 사진 원본을 복사하지 않고 MediaStore ID 참조만 저장. 삭제/이동된 사진은 표시 불가하므로 사용자에게 안내. **기기 교체 시 JSON 메모 백업만으로 원본 사진이 복구되는 것은 아님**.
- 향후 단계: 다른 날짜 사진 임의 추가 Android 시스템 다중 선택기, 위치별 그룹 정밀화와 기존 네이버 장소·방문 지도 연결, 여행별 다일기 자동 생성 전 확인, 사진 없는 가족 일정, 사진/글 백업 및 복원, 선택적 외부 사진 저장소 연결. 정품 D·LOG/데이픽 계정 동기화 또는 서비스 복제는 범위 밖.

## R22 보존·출시 조건
- 기준 실기 사용 승인 APK: `/mnt/data/FamilyJourney_R21_PhotoShare_NaverAutoFlow.apk` package `com.juhyeon.familyjourne2`, versionCode21, signer SHA256 `0d25313c1a6f769d1a9b43ea9d3b7a4626a12924a887062ad25dc69907fbad09`.
- 기존 public repo `yooogillycloud123/family-journey-personal`, branch main. 네이티브 코드는 공개 가능하나 원본 상용 웹 자산·사진·실제 GPS·키·가족 일기는 공개 금지.
- 패키지·서명 유지, `versionCode=22`, **R21 위에 덮어쓰기 설치**, 기존 사진/여행/설정 데이터 무삭제.
- 기존 웹 `app.js`, `native.js`, `tripbuilder.js`, `engine.js`, `render-worker.js` 바이트 변경 금지. `fj-naver-favorites.js`는 기존 전체화면 제스처 뷰어를 재사용하기 위해 공개 API 객체에 `openFullGallery:openInternalFullGallery` **한 항목만 추가**하고 나머지는 바꾸지 않는다. 신규 `family-diary.js`, `family-diary.css` 및 index.html 참조만 추가.
- Android Java GitHub Actions 빌드 PASS, 앱 ZIP CRC/APK v2/v3 서명 PASS, JS 문법/달력·일기 IndexedDB 저장 회귀 테스트 PASS. 실기 미검증 사항은 명시한다.
- 네이버 저장 R21는 사용자가 메모/별명·목록/저장 사이 터치가 필요했던 마지막 실기 과제였음. 새 일기 기능 추가하면서 이것을 해결됐다고 주장하거나 저장 메커니즘을 조용히 바꾸지 않는다.

## 후속 최우선 개발
1. Galaxy에서 R22 앱 일기: 기존 날짜 사진 수, 6월/10월 사진 N장 로드, 앨범 그룹 체크, 저장 후 재실행 데이터 유지, 뒤로가기 영상/사진 기능 회귀 확인.
2. 날짜 타임존/EXIF DATE_TAKEN 정확도 및 대량 사진 렌더 성능 기록; 비GPS 사진 포함 확인.
3. 선택한 N장 한 번에 원본 사진 공유/표지 고르기, 재생 가능한 가족 앨범·일기 PDF 및 자동 요약 단계적 확장.
