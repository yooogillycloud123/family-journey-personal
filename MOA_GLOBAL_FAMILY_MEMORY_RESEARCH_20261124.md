# 모아(MOA) 글로벌 가족 기록·책장·포토북 벤치마킹 및 구현 전략 v1.0

**조사일:** 2026-11-24 (KST)  
**상태:** 조사·제품 설계, **앱 소스 수정/빌드/실기기 검증 아님**.  
**프로젝트 기준:** MOA R707 원본 서명 사용자 지정 Golden `b72856150410491b87cd01c3ecbe1a3178e2d1a6488fdf4494d06afcf50fb200`, `USER_DESIGNATED_GOLDEN/STATIC_VERIFIED/PHYSICAL_QA_NOT_DOCUMENTED`. 기존 R707 APK, 가족 IndexedDB, MediaStore, 오디오/지도/일기, 원본 서명키 불변. 새 APK 제작은 명시적 후속 요청과 고코드 복구본이 마련된 때에만 진행.

> **핵심 제안**: 모아는 별도의 사진 인쇄 서비스가 아니라 **“기록은 한 번, 추억은 여러 번: 가족의 모든 날을 책·영상·지도·배움으로 재구성하는 개인 소유 가족 메모리 OS”**가 되어야 한다. 앱의 기록 원장이 진실의 출처이고, 책장/포토북은 원장에 대한 되돌릴 수 있는 별도 구성·출판 결과물이다.

## 1. 조사 방법과 증거 등급

- **A 공식 근거**: 제조사/개발사 기능 문서, 앱스토어, GitHub README/LICENSE, 플랫폼 공식 개발 문서.
- **B 사례/신호**: Reddit 등 공개 사용자 후기; 개인 경험이므로 통계적 대표성 없음.
- **C 모아 설계 제안**: 직접 구현 전 가설/아키텍처. 기존 R707에 이미 탑재됐다는 뜻 아님.
- FamilyAlbum·CEWE·Popsa의 수치는 기업 발표치이며 **이용자·누적 인쇄 권수·출하 건수는 서로 단위가 달라 순위를 계산하지 않는다**. 회사 자료 발표 시점은 확인했지만 오늘의 실시간 수치로 간주하지 않는다.
- 사용자 제공 `FamilyAlbum-23.3.0-split-apks.zip`에서 **외부 공개를 하지 않은 채 로컬로 패키지 메타데이터만 확인**: `us.mitene`, `versionName 23.3.0`, `versionCode 548`, `base.apk + arm64_v8a + ko + xxhdpi` 구성. 상용 비공개 코드를 모아에 복제하지 않는다.
- 사용자가 공유한 스크린샷·영상: 연도별 성장사진을 페이지에 배치한 종이책, 레이아웃이 있는 추억책, 휴대폰·태블릿 화면에서 책을 펼치는 컨셉. **외부 공개 저장소에는 사용자 가족 이미지/영상을 올리지 않는다**.

## 2. 글로벌 대표 서비스·제품 (회사 설명 기반, 모아 적용 아이디어)

| 서비스 / 운영 성격 | 확인된 기능·성공 증거 | 모아에 참고할 핵심 원리 | 검토 난이도 |
|---|---|---|---|
| **FamilyAlbum (MIXI)** / 가족 사진·영상 공유 | 2026-05-07 전 세계 사용자 3천만 명 돌파 공식 발표; 월간 포토북 추천 | 친척 초대·비공개 가족 피드, 월말 책 제안, 성장 타임라인 | 중 |
| **Journi Print** / 여행·포토북 | EXIF 날짜·GPS→자동 지도·스탬프·책 페이지; 자동 배열 | 모아 세계지도·장소·GPS·기존 여행 일기 결합한 여행책 | 중 |
| **Polarsteps** / 여행기 | 경로와 사진을 Travel Book으로 재구성·주문 | 방문 장소/순서→챕터/지도 펼침 페이지 | 중 |
| **Day One** / 저널 | 일기 인쇄/PDF 출판; 공식 문서상 주문 기능은 현재 iPhone/iPad | **일기 원문/사진→책**, Android에서도 표준 PDF 생성으로 플랫폼 제한 극복 | 중 |
| **Remento** / 목소리 회고 | 음성 녹음→원문/편집된 글→책 장별 QR로 원래 목소리 연결 | 기존 모아 음성파일을 보존한 채 인쇄책 QR 연동 | 중~상 |
| **Storyworth** / 가족 구술·전기 | 질문 프롬프트, 이메일/문자/음성 응답, 완성 후 하드커버 책 | 부모·조부모 추억 인터뷰, 빈 기록 날짜에 선택형 질문 | 중 |
| **Qeepsake** / 육아 기록 | 선택형 질문에 응답해 가족 일기·챕터북 제작 | 아이의 첫 말·처음 한 일 같은 **성장 질문 후보함** | 하 |
| **Once Upon** / 포토북 | 스마트폰·태블릿·PC에서 자동 배열+설명 편집+협업 | 책 표지, 텍스트/사진 재배치, 동일 프로젝트 다기기 편집 | 중 |
| **Mixbook** / AI 편집·인쇄 | Story Mode/Auto Create/다양한 레이아웃·직접 수정 | 자동 초안을 만들되 모든 페이지를 사람이 고칠 수 있어야 함 | 중~상 |
| **Popsa** / 모바일 인쇄 | 회사 발표상 1천만+ 사용자, 포토북 5백만+ 제작 | 사진 선택·표지·인쇄까지 단순한 완료 퍼널 | 중 |
| **Chatbooks** / 월간 구독 책 | Monthbooks/Monthly Minis/Baby's First Year | 월마다 1권 자동 초안 → 승인 → 책장에 추가 | 하~중 |
| **Tinybeans** / 가족 일지 | 초대형 비공개 기록·성장 활동 | 빠른 기록, 가족마다 다른 열람 권한 | 중 |
| **23snaps** / 비공개 가족공유 | 가족별 사진·동영상 및 책 인쇄 (공개 설명) | 다이어리보다는 초대·접근 제어 참고 | 중 |
| **1 Second Everyday (1SE)** / 영상일기 | Journal/Freestyle 프로젝트, 날짜별 클립 연결 | 포토북의 비디오 버전, 월간/연간 성장 영상 | 중 |
| **Google Photos** / 미디어·책 | 사진앨범에 텍스트/지도 삽입, 사진책 생성·주문 (지역 제한 확인) | 검색, 자동 분류, 중복·사진 품질 관리 | 중 |
| **Apple Photos** / 공유 라이브러리 | 최대 5명 추가 가족/친구와 협업 | iOS 향후 확장 시 공동 라이브러리/기기 사이 권한 정책 | 상 |
| **CEWE** / 유럽 포토북 인쇄 | 2026-03 누적 포토북 1억 권 발표 | 책 규격·양면 펼침·재단·제본을 별도 인쇄 엔진으로 설계 | 중 |
| **스냅스** / 국내 출력 파트너 후보 | 국내 공유 포토북 서비스·AI 포토북 소개 | 초기에는 출력용 PDF/이미지 패키지 후 수동 주문 | 미확인 API |

**공식 근거 URL** (2026-11-24 확인)

- FamilyAlbum 3천만: https://mixi.co.jp/en/news/2026/0507/52325/
- FamilyAlbum 포토북: https://help.family-album.com/hc/en-us/articles/360038641953-What-are-FamilyAlbum-photobooks
- FamilyAlbum 기본 설명: https://help.family-album.com/hc/en-us/articles/360038267214-What-is-FamilyAlbum
- Journi Print 자동 지도: https://support.journiapp.com/hc/en-us/articles/35948285564701-Add-edit-or-delete-maps-in-your-Photo-Book
- Journi Print 옵션/레이아웃: https://support.journiapp.com/hc/en-us/articles/5449295861661-Photo-Book-Settings
- Journi Print 책: https://www.journiapp.com/p/pb/
- Polarsteps Travel Book: https://support.polarsteps.com/hc/en-us/articles/24005113311634-What-is-a-Travel-Book
- Day One 책/PDF: https://dayoneapp.com/book-printing/ ; https://dayoneapp.com/guides/settings/exporting-entries/
- Day One iOS에만 주문 기능: https://dayoneapp.com/guides/tips-and-tutorials/book-printing/
- Remento 녹음/QR: https://help.remento.co/en/articles/8365951-how-do-i-record-a-memory ; https://www.remento.co/faq
- Storyworth 음성/책: https://help.storyworth.com/en_US/getting-started/what-products-does-storyworth-offer
- Qeepsake: https://help.qeepsake.com/article/116-how-does-qeepsake-work ; https://help.qeepsake.com/article/161-what-are-qeepsake-chapter-books
- Once Upon: https://onceupon.photo/ ; https://apps.apple.com/us/app/once-upon-photo-book-creator/id1187208815
- Mixbook: https://www.mixbook.com/photo-books ; https://help.mixbook.com/hc/en-us/articles/61128856919577-How-do-I-use-the-Auto-Create-feature
- Popsa 1천만/5백만 업체 소개: https://popsa.com/careers/seo-executive/
- Chatbooks: https://help.chatbooks.com/en/articles/10542494-how-do-i-create-a-subscription
- Tinybeans: https://hinata.tinybeans.com/
- 1SE: https://apps.apple.com/us/app/1-second-everyday-video-diary/id587823548
- Google Photos 사진책: https://support.google.com/photos/answer/7378811?co=GENIE.Platform%3DAndroid
- Apple Shared Photo Library: https://support.apple.com/en-us/118229
- CEWE 1억 권: https://www.cewe-group.com/en/press/cewe-germany/press-releases/detail/100-million-cewe-photobook-copies.html
- 국내 스냅스: https://www.snaps.com/share-photobook

## 3. 우선 비교해야 할 GitHub 공개 프로젝트 (라이선스/채택 구분)

**우선 채택 후보: 기능별 MIT 컴포넌트 (각 버전·하위 의존성 재검사 필수)**

| 프로젝트 | 용도 | 확인된 라이선스 | 모아에 쓰는 방식 |
|---|---|---|---|
| [Nodlik/StPageFlip](https://github.com/Nodlik/StPageFlip) | 웹 페이지 넘김 효과 | MIT | 휴대폰 책 펼치기 UI의 독립 컴포넌트, 접근성 폴백 필수 |
| [pagedjs/pagedjs](https://github.com/pagedjs/pagedjs) | HTML/CSS → 책 페이지 분할 | MIT | 글이 많은 일기 페이지·장 구성 인쇄 미리보기 |
| [pdfme/pdfme](https://github.com/pdfme/pdfme) | JSON 템플릿 WYSIWYG PDF | MIT | 편집 가능한 PDF 레이아웃/내보내기 PoC |
| [diegomura/react-pdf](https://github.com/diegomura/react-pdf) | React → 벡터 PDF | MIT | 책 프로젝트→반복 생성 가능한 인쇄 PDF 후보 |
| [foliojs/pdfkit](https://github.com/foliojs/pdfkit) | Node/브라우저 PDF | MIT | 폰트·텍스트·좌표 기반 인쇄 출력 비교 |
| [konvajs/konva](https://github.com/konvajs/konva) | 캔버스 사진 위치/크롭 편집기 | MIT | 편집 모드의 사진 이동/크기/회전·드래그 |
| [fabricjs/fabric.js](https://github.com/fabricjs/fabric.js) | Canvas/SVG 편집기 | 라이선스 재확인 | Konva 대안, 1개만 선택 |
| [clauderic/dnd-kit](https://github.com/clauderic/dnd-kit) | 페이지/사진 재정렬 | MIT | React 기반 책 편집 시 드래그 재정렬 |
| [soldair/node-qrcode](https://github.com/soldair/node-qrcode) | QR 생성 | MIT | 영상·음성 리소스 연결 인쇄용 QR 생성 |
| [meigo/slop-photo-album](https://github.com/meigo/slop-photo-album) | 로컬 AI 선별/자동 포토북/달력 | MIT (저장소 표기) | 사진 품질·날짜별 TOP N·페이지 배열 로직 참조, 통째 내장 비권장 |
| [davidcjw/life-journal](https://github.com/davidcjw/life-journal) | 기록이 쌓이면 자라는 디지털 책 | MIT (README 표기) | 여러 권·동적 자동 페이지 재구성·HTML/PDF 참고 |
| [agammann/picture-book](https://github.com/agammann/picture-book) | 스프레드 편집·프로젝트 파일 | MIT (README 표기) | JSON 프로젝트 보존/복구 UX 참고 |

**설계 검토 위주 / 배포 전 라이선스 검토 필요**

| 프로젝트 | 참고 포인트 | 주의 |
|---|---|---|
| [immich-app/immich](https://github.com/immich-app/immich) | 대규모 타임라인, 얼굴 군집, 로컬 백업 | AGPL-3.0: 코드 이식 전 법적 의무 검토, 전체 시스템 이식 비권장 |
| [ente/ente](https://github.com/ente-io/ente) | E2EE, 멀티 기기, 가족별 비공개 공유 | AGPL-3.0; 계정/키/복구 아키텍처 연구 |
| [pulsejet/memories](https://github.com/pulsejet/memories) | Nextcloud EXIF 연대기·지도·백업 | AGPL-3.0; 서버 인프라 자체 구축 부담 |
| [LibrePhotos/librephotos](https://github.com/LibrePhotos/librephotos) | 얼굴/인물, 자동 사건 분류, 앱/서버 구조 | MIT 저장소; ML 메모리 요구·모델별 재배포 조건 별도 검증 |
| [photoprism/photoprism](https://github.com/photoprism/photoprism) | 사진 EXIF·자동 조직화 | AGPL 계열 배포 의무 확인 |
| [oiahoon/Photo-Book-Studio](https://github.com/oiahoon/Photo-Book-Studio) | 브라우저 편집·원본 연결·백업·책 표지/책등·300PPI | 라이선스 원문 직접 검증 전 코드 복사 금지; 아키텍처 참조 우선 |
| [Spacerat/photobook](https://github.com/Spacerat/photobook) | 1파일 오프라인 날짜순 자동 배열 | 별도 LICENSE 확인 안 됨 → 코드 복사 금지, 알고리즘 아이디어만 참조 |
| [remotion-dev/remotion](https://github.com/remotion-dev/remotion) | 책 기록→월간 성장영화 | 일반 MIT로 단정 불가. 회사 규모/사용 형태별 특수 라이선스 확인 |
| [eKoopmans/html2pdf.js](https://github.com/eKoopmans/html2pdf.js) | 빠른 웹 PDF 시험 | MIT이나 캡처·래스터화로 고급 인쇄 품질 저하 우려, 최종 엔진 기본값 비권장 |
| [OceanLabs/Photobook-iOS](https://github.com/OceanLabs/Photobook-iOS) | 오래된 iOS 포토북 SDK 예제 | 수정 MIT 등 별도 제한·유지보수 점검 전 이식 금지 |

**기술 판단**: 지금 모아는 원본 Android/WebView 기반의 앱이다. 우선 **StPageFlip(열람) + 간단한 자체 JSON 편집 프로젝트 + Paged.js 또는 react-pdf(인쇄 PDF)** 두 독립 출력 경로를 비교하는 것이 최소 위험이다. 복잡한 Konva/Fabric 본격 편집기는 기본 기능과 출력 엔진을 검증한 뒤 채택한다. React 기반 라이브러리를 기존 단일 WebView에 무조건 추가하지 않으며 번들 크기/기존 앱 충돌을 확인해야 한다. 벤치마킹 대상의 테스트·디자인·알고리즘 아이디어는 가능하되 상용 앱 비공개 APK 소스 복사 금지.

## 4. 공개 사용자 후기에서 얻은 실패 예방 원칙 (통계 아닌 사례)

- **인쇄 재단·글자 잘림**: 2026년 Reddit 인쇄 사례에서 bleed/재단 품질에 대한 불만이 확인됨. 모아는 표지/내지 안전 영역·bleed 미리보기와 출력사별 사양 검사를 제공해야 한다. https://www.reddit.com/r/photography/comments/1q5t9tz/best_quality_online_design_printing_of_photo_books/
- **고정 템플릿의 긴 일기 글 문제**: Day One 인쇄 경험 공유에서 짧은 일기/긴 글/사진 여러 장을 같은 틀로 처리하기 어려운 문제가 드러남. 모아는 텍스트 전용·사진 단독·2쪽 펼침·긴 글 이어짐 템플릿을 구분. https://www.reddit.com/r/dayoneapp/comments/1xhjeb2/printing_your_day_one_journal_how_i_get_a_book_in/
- **공유 프라이버시 경계**: 가족에게 모든 카메라 사진을 자동 공유하면 업무·사생활 사진까지 섞일 수 있다는 사용자 우려. 모아는 비공개가 기본이고 **책/공유 대상은 명시적으로 선택**, 앨범별 분리 권한 필요. https://www.reddit.com/r/immich/comments/1q4opru/finally_pulled_the_plug_on_google_photos_immich/
- **백업과 출판본을 혼동하면 안 됨**: 앱 메타데이터와 실제 미디어를 따로 복원해야 한다는 자가 호스팅 경험. 모아는 프로젝트 JSON만으로 원본 사진이 백업된 것으로 표시하지 않음. https://www.reddit.com/r/immich/comments/1x8kyyo/its_up_and_running_now_what/

## 5. 모아 북셸프(BookShelf)의 제품 구조 — 중요한 차별점

1. **책장**: 실제 책등이 보이는 서재, 클릭하면 표지/책장(페이지) 펼침. 연도·여행·인물·기념일·가족 전체 필터. 100권 이상에서 검색/가상 목록 렌더.
2. **자동 책 추천함**: 매월 1회, 분기·연말·여행 종료 시 **승인 전 미완성 초안**을 제안. 날짜/장소/아이/일기 연결 기반. 새 일기를 작성하라고 반복 강요하지 않음.
3. **디지털 포토북**: 크롭·레이아웃·표지·목차·챕터·검색·원문으로 돌아가기·원본 영상/음성 재생. 온라인이 아니어도 가능한 범위에서 열람.
4. **성장책**: 수동 인물 태그로 아이별 0세부터 현재까지. 한 사진에 가족 4명 동시에 포함되어도 중복 원본 저장 없이 여러 책에 참조 가능.
5. **여행책**: GPS/지도/경로가 있는 장, 날짜별 일기, 지도 위치 근처 사진/장소 편집. 좌표가 없는 사진은 사실처럼 위치를 만들지 않음.
6. **가족 목소리책**: 원본 음성 보존→선택적 음성 인식 글 초안→편집→QR 또는 디지털북 재생 버튼. QR은 영구 보증 URL이 아니므로 오프라인 백업/재지정 도구 제공.
7. **출판소**: 디지털북에서 원본 고해상도 사진으로 PDF 내지·표지/책등·QR 생성. 출력사별 종이 크기, bleed, 마진, CMYK/ICC 등 사양 확정 후 내보내기.
8. **책장 모드와 원장 독립성**: 앱의 기존 일기를 고치더라도 이미 주문/출판한 책의 특정 리비전은 그대로 재현 가능해야 함.
9. **라이브 vs 확정본**: 아직 쓰는 성장책은 새 일기 자동 반영 제안을 보여주는 **살아 있는 책**, 인쇄 완료한 연간책은 **동결 스냅샷**. 자동 덮어쓰기 금지.
10. **가족 공유/초대는 후속**: 처음에는 로컬 프라이버시 보호. 보호자/친척 계정, 동기화·암호화·초대 권한은 검증된 별도 모듈로 확장.

### 처음 만드는 6개 템플릿

- 우리 가족 2026 (연간, 12개월/계절 목차)
- 우리 아이 성장기 (0세~현재, 연도·나이·생일 순)
- 가족 여행기 (장소 지도 + 날짜 사진 + 일기)
- 이달의 20장 (월간 1권, 자동 추천)
- 할머니·할아버지 이야기 (질문+음성+사진+QR)
- 사진 없는 하루도 소중해 (일기 본문 중심 에세이)

### 기본 화면 동선

`현재 하단 탭 그대로` → `더보기 또는 설정 내 '모아 책장' 입구` → `가로 책등/표지 책장` → `책 선택` → `페이지 넘김` → `편집/출판 모드` → `PDF 내보내기 또는 재생`. 기존 탭을 임의 재배치하지 않고 처음엔 독립 기능 입구로 추가. 커다란 종이 책장 애니메이션은 선택적으로; 저사양 기기·접근성 설정에서 목록/페이지 스와이프 대체 제공.

## 6. 구현 계층 및 원장 보호 아키텍처 (제안, 아직 개발 안 됨)

```
R707 Native Android / WebView (변경 최소)
  ├─ EXISTING familyjourney-diary-v1 / curated, entries / MediaStore / GPS / audio [READ ONLY]
  └─ MOA Bookshelf sidecar (NEW independent store)
       ├─ BookCatalog (shelves, books, drafts, published revisions)
       ├─ MediaLinkResolver (diaryRef, mediaRef, date, local uri, available)
       ├─ AutoCurator (month/year/trip/person; consent-first suggestions)
       ├─ PageModel (spread, frames, crop, caption, text, audio/video/QR)
       ├─ Reader (StPageFlip + fallback)
       ├─ Editor (page order / cover / chosen theme / optional drag-drop)
       └─ Exporter (high-res originals -> PDF print profile + manifest)
```

- **한 레코드에서 여러 권**: 책의 미디어는 원본 파일 복사가 아닌 `assetRef`로 참조. 원장 저장시각·카메라 시각·미디어 ID·EXIF GPS는 서로 구별. 기존 MediaStore ID는 같은 기기에서만 유효한 키; 태블릿/PC에는 고유 assetId 및 실제 파일/썸네일 동기화 필요.
- **안전한 사이드카 DB**: 기존 `familyjourney-diary-v1`의 레코드/스키마 수정하지 않음. 새 `moa-bookshelf-v1`(명칭 가칭) IndexedDB의 books, revisions, pages, media_links, export_jobs, audit 트랜잭션.
- **정렬·선정**: 하루 100장 중 **중복/흔들림 의심 사진을 후보로 표시**하되 자동 삭제하지 않는다. 사람·아이·여행일은 보호자 수동 선택 우선. 자동 선별은 opt-in 후보만, 가족 사진의 외부 AI 전송 기본 OFF.
- **백업**: 프로젝트 JSON(책 구조)은 미디어 원본을 포함하지 않으므로 별도 원본 자산 아카이브 or 명시적 참조/대체 사진 매핑. 원본 소실 시 조용히 빈 이미지 PDF로 내보내지 말고 실패·재선택 UI.
- **페이지 렌더**: 동일 BookProject에서 Reader(반응형 화면)과 PDF(실제 mm 좌표·벡터 글·인쇄 RGB/프로파일 정책)를 **분리**. `html2canvas` 스크린샷만으로 PDF 제작하지 않음. JSON으로 재생성 가능한 출력과 exportRevision, assetHash 저장.
- **텍스트·권한**: 부모의 원래 일기 본문 `textSource=diary, copiedAt, originalId` 표시; 책에서 수정하면 **책 사본만 변경**. 장/사진 이동/책 삭제가 기존 일기에 영향을 주지 않아야 함.

### 설계 JSON 예시 (가상값)

```json
{
  "schemaVersion": 1,
  "bookId": "book-uuid",
  "title": "우리 가족의 2026",
  "kind": "year",
  "mode": "live_draft",
  "sourceSelection": {"fromDay": "2026-01-01", "toDay": "2026-12-31", "peopleIds": []},
  "chapters": [{"chapterId": "ch1", "title": "봄", "pageIds": ["pg1"]}],
  "pages": [{
    "pageId": "pg1", "layoutId": "hero-caption-01",
    "assets": [{"assetId": "stable-asset-id", "mediaStoreLocalId": "local-only-id", "crop": [0,0,1,1]}],
    "blocks": [{"type":"caption", "value":"오늘의 작은 이야기", "sourceDiaryId":"diary-id", "editableCopy":true}]
  }],
  "printProfile": {"sizeMm": [200,200], "bleedMm": 3, "revision": 1},
  "publishedRevisionId": null
}
```

## 7. 출력물·화질·영상·음성 설계 (스펙이 아닌 추천/실험값)

- **처음 지원 크기**: 200×200mm 정사각과 A5 세로 등 2종 정도. 출력사별 실제 주문 가능한 크기 확인 후 제품화.
- **고해상도**: 인쇄 공급자의 PDF 규격에 맞춘 사진 원본 사용. Blurb의 공개 PDF 가이드는 이미지 최대 300 PPI, 실제 최종 재단 크기와 bleed 요구. 200mm 정사각에 300ppi면 한 변 약 2,362px 필요(bleed 별도). 숫자는 예시이며 인쇄사는 반드시 개별 체크.
- **bleed**: 일반적으로 3mm 예시로 PoC하되 **모든 업체에 3mm 고정 금지**. 안전마진/제본 쪽 글자 금지 영역 별도.
- **비디오의 종이책 표현**: 비디오에서 사용자가 지정한 대표 프레임을 사진으로 인쇄하고, QR은 해당 기록의 음성·동영상으로 연결. 책으로만 QR에 의존하지 말고 로컬 보관 가능한 공개 범위 옵션·유효성 진단 마련.
- **QR의 장기 유효성**: `bookId+assetId+rev` 내부 해석자와 소유자 인증을 설계. 도메인이 사라지면 QR은 죽을 수 있으므로 명시적 백업/재지정 기능, 공개 링크에는 지리/아동 개인정보 비노출.
- **폰트**: 한글 줄바꿈, 조사/한자/이모지 fallback, 임베드 허가된 글꼴, 이중 페이지·긴 본문 인쇄, 작은 글씨 보호.
- **인쇄가 아닌 전자책**: HTML 파일로 내보낼 경우 가족 미디어를 파일에 포함하면 크기·유출 위험 증가. 단순 링크 버전/선택형 오프라인 번들 버전을 구분하고 암호화·접근 권한 안내.
- **프로세스**: 선택 → 썸네일 미리보기 → 원본 고해상도 리졸브 → 출력 품질 경고 → 글·bleed 교정 → PDF 제작 → 미리보기 → 파일 저장 → 임의 인쇄 업체 주문. **인쇄 업체의 공개 API가 확인되지 않은 동안 주문/결제 자동화 약속 금지**.

**기술·인쇄 공식 자료:**
https://support.blurb.com/hc/en-us/articles/207792946-PDF-to-Book-specifications-and-checklist
https://developer.android.com/reference/android/graphics/pdf/PdfDocument
https://developer.android.com/training/data-storage/shared/media
https://developer.android.com/media/media3/transformer/transformations
https://developer.apple.com/documentation/photokit
https://developer.apple.com/documentation/photosui/photospicker
https://developer.apple.com/documentation/pdfkit

## 8. iOS / Android / PC 적용 의존관계

| 플랫폼 | 우선 접근 | 실현 전에 확인할 부분 |
|---|---|---|
| Galaxy Android R707 | 현재 웹뷰에 독립 책장 모듈 + Android MediaStore 원본 읽기 브리지 + Android SAF PDF 저장 | MEDIA 권한, 로컬 EXIF, WebView 번들/메모리, Android 17 실기기 |
| Android 태블릿 | 같은 페이지 데이터 모델 + 가로 spread 레이아웃/키보드·펜 입력 | 휴대폰의 MediaStore ID는 태블릿에 통하지 않음: 사진 동기화 필요 |
| PC | 사진 고해상도 출력 작업용 PWA/웹 포토북 편집기 (동일 프로젝트 포맷) | 원본 미디어 전송/인증, 책 로컬 백업, 폰트·색공간 검증 |
| iOS 추후 | Swift/PhotoKit·PhotosUI/PhotosPicker, PDFKit 뷰어 또는 동일 Web UI | Apple PhotoKit 권한, iCloud 공유 라이브러리 자동 접근 여부, iOS MediaStore 대체 식별자·동기화 |

- Android에서 원본 EXIF 위치를 읽을 때는 `ACCESS_MEDIA_LOCATION`과 위치 권한/동의·URI 조건 확인 필요; 갤러리 개별 선택 권한과 전체 미디어 권한을 혼동하지 말 것.
- Apple의 Photos picker는 사용자가 고른 콘텐츠에 접근하는 공식 경로지만, 타 앱의 비공개 Photos DB나 클라우드 원본을 자동 복제할 수 있다는 뜻이 아니다.

## 9. 개발 우선순위 / 구체적 검증 게이트

| 단계 | 산출물 | 골든/데이터 보호 게이트 |
|---|---|---|
| **A0 분석/PoC** | R707 데이터 연결 read-only 계약, 가상 데이터로 8~12쪽 책 생성 | 현행 원장 writes=0, 설치 APK 변경=0 |
| **A1 책장 MVP** | 책 표지 1~N, 실제 넘김, 연도/날짜/여행별 책 초안, 기존 기록 원문 참조 | 원장·갤러리·Naver·GPS·OneUI 정상, 취소/재진입 무손실 |
| **A2 편집+자동 제안** | 페이지/사진 순서, 레이아웃, 표지, 수동 인물태그, 월간 추천 | 기존 일기 내용/사진 수정 0; 기존 설정/뒤로가기/빠른 넘기기 보존 |
| **A3 디지털 미디어 책** | 동영상·음성 재생, 원래 일기 이동, QR 링크 | 오프라인/권한 없음/사진 유실/도메인 만료 안전 처리 |
| **A4 인쇄 MVP** | 사진+글 10~20p 300ppi 대상 PDF, 실물 인쇄용 품질 경고 | 글 잘림 0, 누락 이미지 0, 2종 PDF 인쇄사 프로파일 수용 |
| **A5 PC·태블릿** | 책 프로젝트 export/import, 인증된 동기화, 공동 편집 옵션 | 충돌/중복/백업복원, 가족 비공개 기본, 원본 사진 정확 |
| **A6 AI 확장** | 인물/장면 후보, 자동 문구, 계절·일생 복합 포토북 | 옵트인, 오인 인물 자동 확정 금지, 원본 변형 0 |

- **기존 고정**: R707 SHA 불변; 신규 APK 빌드 지시 시 원래 서명/패키지 유지, versionCode **≥709**, 새 후보보다 더 높은 코드(**첫 709면 ≥710**)의 **정확한 R707 골든 기능 복구 APK**를 함께 만들 것. R708은 R705 기능 복구이지 R707 완전 복구가 아니다.
- 단계마다 앱 데이터 삭제/재설치 금지. R707과 R683 등의 과거 골든 유지.
- 성공 선언 게이트: 모든 소스/정적 QA와 별개로 Galaxy S26 Ultra 사용자가 직접 해당 기능/기존 기능을 테스트하여 확인할 때만 `DEVICE_PASS`.

## 10. 결정 프레임과 첫 추천

**지금 가장 적합한 다음 구현**: A0~A1 `모아 책장 v0.1`.

- 앱 기존 기록에서 사용자가 `기간 선택`을 하면 **사진과 일기를 읽기만 해서** 8~12쪽 임시 디지털 책을 자동 생성한다.
- 책장에는 표지와 제목이 생기고, 펼쳐 보면 실제 페이지를 넘기며 사진·일기 문구가 나온다.
- 편집하기/월간 초안 제안/고화질 인쇄/가족 공유는 *A1 안정 확인 이후* 늘린다.
- 첫 사용자 체감은 '만드는 노동 없이 내 가족 기록이 한 권의 책이 되어 나타난다'이며, 각 책은 기존 원본을 공유해 용량 폭증을 억제한다.

**기존 연구 계획과의 관계**: [MOA FUTURE VISION v1.0](https://github.com/yooogillycloud123/family-journey-personal/blob/main/MOA_FUTURE_VISION_RESEARCH_IMPLEMENTATION_ROADMAP_v1.0_20261118.md) 내 Phase 4 '자동 추억책·인쇄 포토앨범'을 독립적으로 앞당겨 구체화하는 **추가 제안**이다. 앱에서 이미 동작하는 기능이 아니라는 상태 표시 필요.

## 11. 재개 체크리스트

1. R707 Golden 원본 문서/해시와 최신 새 채팅 지침 확인.
2. 공개 서비스 기능/오픈소스 라이선스를 **실제 라이브러리 도입 직전에 다시 확인**.
3. 실제 골든 앱의 `assets/web/app.js`, `family-diary.js`와 IndexedDB 읽기 경로, 미디어 Native Bridge는 현재 APK 및 QA에서 재확인. 과거 R697 데이터 모델만 보고 R707 직접 분석했다고 주장하지 않는다.
4. 사용자에게 기본 UI나 특정 단계 확정 요구하기 전, 샘플 데이터로 실험해서 작동 수준을 보여주기.
5. 사용자가 명시적으로 개발 요청한 뒤에만 feature 브랜치와 테스트 APK 제작. 이전 골든 변조 금지.
6. 모든 가족 사진·음성·아동 데이터는 로컬/개인 Library에만; **공개 GitHub/외부 AI 서비스/테스트 로그 유출 금지**.