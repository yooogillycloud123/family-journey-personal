# MOA 글로벌 가족 기록·성장앨범·디지털책·실물 포토북 벤치마킹 v1.0

- 조사일: **2026-11-24**
- 구분: **외부 사실/사용자 제공 화면/모아 현재 구조/새 제품 제안**을 명확히 구별한다.
- 범위: 주요 상용 앱, 신흥 특화 앱, 한국 유사 서비스, 공식 Android/iOS 개발 자료, 공개 GitHub, 개별 사용자 의견.
- 상태: **RESEARCH_ONLY / NO_SOURCE_CHANGE / NO_APK_CHANGE / NO_DATA_MIGRATION**.
- 기준: 사용자 지정 불변 MOA R707 Golden SHA256 `b72856150410491b87cd01c3ecbe1a3178e2d1a6488fdf4494d06afcf50fb200`. Golden 실기기 전체 QA는 확인되지 않았다. 복구 R708은 **R705 기능 복구**, R707 완전 복구가 아니다. 새 기능 APK는 versionCode **≥709**, 함께 R707 exact-functional recovery **≥710**를 준비한다.
- 본 문서의 목표: 사용자가 매일 쌓아온 기록을 재입력하지 않고 **원본 → 가족/성장/여행 책장 → 디지털책 → 인쇄 PDF → 선택적 실물 포토북**으로 확대하는 전략을 정한다.

## 1. 중요한 결론 (기술·제품 제안)

> MOA를 '앨범 앱 + 일기 앱 + 포토북 제작 앱' 3개로 분리하지 않는다. **한 번 기록된 원본을 참조하는 하나의 메모리 원장과 여러 읽기/제작 뷰**로 설계한다.

1. 1단계는 **내 책장 → 자동 포토북 생성 → 읽기 전용 책 펼치기 → 원본 일기로 돌아가기**. 전체 편집과 인쇄는 다음 단계.
2. 책은 기본적으로 기존 사진/영상 파일을 복사하지 않는 **참조형 BookProject**이며, 삭제·복구·일기 수정은 기본 원장에 영향을 주지 않는다.
3. 책 생성 시 **스냅샷 vs 원본 일기와 동기화(사용자가 선택)**를 분리한다. 인쇄 확정본이 일기 수정 때문에 저절로 바뀌지 않게 한다.
4. 디지털책은 사진/텍스트/동영상/음성/GPS 장소를 담고, 인쇄본은 고해상도 사진+벡터 텍스트+영상/음성의 **지속 가능한 QR**을 담는다.
5. 가족 사진과 음성의 외부 업로드/AI 분석/원격 공유는 기본 OFF. 초기에는 **로컬 퍼스트**. 선택적 백업, 동기화, 공유는 별도 권한·암호화 설계.
6. iOS로 확장할 때는 Android의 MediaStore ID를 사용하지 않는 독립 BookProject JSON + 플랫폼별 자산 제공자(Android MediaStore / iOS PhotoKit)로 구성한다. 현재 APK를 Flutter/React Native로 전면 교체하지 않는다.
7. 인쇄는 책 프로젝트와 동일한 레이아웃 소스를 사용하되 별도 출력 규칙(용지·재단·제본·실제 dpi·색공간)으로 렌더링한다. 특정 인쇄소의 자체 편집기/주문 API가 있다고 가정하지 않는다.

## 2. 상용·공식 제품 22개 — 검증된 핵심 기능

아래 '플랫폼'은 확인된 배포·설명 수준으로 표시했다. 지역·국가별 상품/주문 기능은 별도 확인해야 한다. '히트/성공'은 공개 수치가 있는 경우만 정량 언급하며, 나머지는 **벤치마크 대상**이지 시장 점유율 순위가 아니다.

| 제품 | 플랫폼/형태 | 공식 확인된 핵심 | MOA 적용 포인트 | 근거 |
|---|---|---|---|---|
| FamilyAlbum (일본) | Android+iOS+웹 | 가족 비공개 공유, 성장 타임라인, 월간 포토북 제안. 회사 발표 2026-05 누적 등록 3,000만+ (활성 사용자와 다름) | '성장 기록에서 자동 월간 책' | [공식 FAQ](https://help.family-album.com/hc/en-us/articles/360038267214-What-is-FamilyAlbum), [실적 발표](https://blog.family-album.com/announcements/weve-surpassed-30-million-users-worldwide/) |
| Chatbooks (미국) | Android+iOS+웹 | Monthbooks, 월별 인쇄 정기 제작, 회사 기준 누적 2,500만 권 인쇄 | 자동 월간 책장/연속된 책등 디자인 | [홈](https://chatbooks.com/), [Monthbooks FAQ](https://help.chatbooks.com/en/articles/7862697-how-do-monthbooks-work) |
| Remento (미국) | 웹/녹음 기반 | 음성/영상 → 글 → 종이책의 QR로 원음 재생; 해지 후 기존 QR 접근 보장한다고 공식 안내 | 원본 목소리 보존+종이책 QR+오프라인 백업 | [공식](https://www.remento.co/), [QR/해지 FAQ](https://help.remento.co/en/articles/9749302-why-is-remento-a-subscription-and-what-happens-if-i-don-t-renew) |
| Polarsteps (네덜란드) | Android+iOS | 여행 경로/사진/글/통계 → Travel Book 자동 생성 | 나의 지도 GPS와 여행 책 연결 | [Travel Book FAQ](https://support.polarsteps.com/hc/en-us/articles/24005113311634-What-is-a-Travel-Book), [서비스](https://www.polarsteps.com/travel-tracker) |
| Once Upon (스웨덴) | Android+iOS+웹 | 자동 배치/직접 편집, 가족 공동 편집, 포토북 인쇄 | 초보자용 자동 초안+수동 재배열 | [공식](https://onceupon.photo/), [공동제작](https://onceupon.photo/stories/make-the-photo-book-together) |
| Day One (미국) | Android+iOS 등 | 사진/동영상/글/음성/위치 포함 일기, 프린트 북; **주문 생성은 현재 iOS만 지원** | 원본 일기부터 인쇄까지 한 파이프라인 | [서비스](https://dayoneapp.com/), [인쇄 범위](https://dayoneapp.com/book-printing/) |
| Qeepsake (미국) | Android+iOS | 육아 질문 프롬프트, 일기/사진/성장 마일스톤 → 책 | '오늘 아이에게 묻기' 한 줄 기록 후보 | [공식 FAQ](https://help.qeepsake.com/article/116-how-does-qeepsake-work), [AppStore](https://apps.apple.com/us/app/qeepsake-family-photo-album/id1332312787) |
| Tinybeans | iOS 앱/웹(안드로이드 배포 별도 확인) | 신뢰할 가족 대상 성장 기록/비공개 일기/포토북 | 조부모용 열람 권한과 안전한 피드 | [AppStore](https://apps.apple.com/us/app/tinybeans-private-family-album/id521633042) |
| 23snaps | iOS 앱/가족 공유 서비스 | 비공개 사진·영상 공유, 가족 대상 열람 | 공유권한/인쇄 글 포함 검증 | [공식](https://www.23snaps.com/), [AppStore](https://apps.apple.com/us/app/23snaps-private-family-album/id526481189) |
| Journi Print (오스트리아) | Android+iOS | 날짜·장소 중심 자동 포토북/여행 지도 | 여행 책 자동 장/지역 구분 | [공식](https://www.journiapp.com/p/pb/fpb/), [AppStore](https://apps.apple.com/us/app/journi-print-photobooks/id1359161090) |
| Storyworth (미국) | 웹/이메일/전화 | 질문에 글/목소리로 응답→회고록/가족 이야기를 실제 책으로 인쇄 | 부모·조부모 인터뷰/가족 구술사 | [FAQ](https://help.storyworth.com/en_US/getting-started/what-products-does-storyworth-offer), [공식](https://welcome.storyworth.com/what-is-storyworth) |
| CEWE (독일) | Android+iOS+PC+웹 | 다양한 인쇄 사진책과 Smart Layout | 인쇄소 규격별 렌더 프리셋 | [공식 앱](https://www.cewe.co.uk/mobile-app.html) |
| Popsa (영국) | Android+iOS | 빠른 자동 레이아웃/인쇄, 사용자가 이후 수정 | '3분 자동 초안' 디자인 | [앱](https://popsa.com/en-us/download/), [기술 설명](https://popsa.com/technology/) |
| Mixbook (미국) | **iOS 앱, Android 앱은 2026-11 현재 미출시** / 웹은 별도 | 풍부한 디자인 템플릿·AI 편집 | 스토리텔링 중심 잡지형 레이아웃 | [기기 공식 FAQ](https://help.mixbook.com/hc/en-us/articles/61128856784665-Which-devices-support-the-Mixbook-app), [앱](https://apps.apple.com/us/app/mixbook-photo-book-album/id1562974920) |
| Shutterfly (미국) | 웹/앱 | 포토북 자동 채우기/수동 편집 | 자동 배치 실패 시 항상 수동 편집 가능 | [개인화 FAQ](https://support.shutterfly.com/s/article/personalizing-a-photo-book) |
| 1 Second Everyday (미국) | Android+iOS | 매일 1초 영상/프로젝트별 영화 | 포토북과 병행되는 짧은 성장 영화 | [iOS](https://apps.apple.com/us/app/1-second-everyday-video-diary/id587823548), [Android](https://play.google.com/store/apps/details?id=co.onese.android) |
| Albumbook (독립 iOS) | iPhone/iPad | 여러 책장, 페이지 넘김/스크롤, 페이지 내 영상, PDF 공유 | '모아 책장' 인터랙션에 가장 직접적 | [AppStore](https://apps.apple.com/us/app/albumbook-photo-album-book/id853360967) |
| Dots Memories (iOS) | iPhone | 디지털 PDF/실물 Dotbook, 음성·동영상 QR | 하이브리드 책+음성/영상 자산 설계 | [AppStore](https://apps.apple.com/us/app/dots-memories-your-story/id6449039420) |
| Project Life (미국) | iPhone/iPad | 드래그앤드롭 스크랩북, 카드·문장·프린트 | 손글씨 감성 템플릿/개별 페이지 편집 | [AppStore](https://apps.apple.com/us/app/project-life/id915861546) |
| Chapters (한국) | 웹 기반 포토북 판매 | 여행책, 영상 연결 QR, 책장처럼 누적되는 시리즈 | 국내 PDF/QR 인쇄·제본 요구 | [공식](https://chapters.kr/) |
| 모모앨범 (한국) | Android+iOS+웹 열람 | 공동 업로드, EXIF 촬영일 정렬, 그룹 사진·영상, 포토북 | 부부 공동 사진 모으기/중복 정리 | [공식](https://www.momoalbum.com/) |
| Google Photos Print Store | Android+iOS/웹, **국가별 판매 다름** | 사진선택 후 포토북 편집/주문 | 다른 서비스 배송 API 가정하지 말고 인쇄용 PDF 기본 | [Google 지원](https://support.google.com/photos/answer/7378811?co=GENIE.Platform%3DAndroid&hl=en-en) |

### 화면/영상 참고 자료 (사용자가 제공한 것)

- `24517.mp4` (27.39초), `24536.mp4` (54.32초): 모바일 웹 광고와 데모에서 **디지털책장/책표지 → 실제 책 넘김 → 하단 미리보기 썸네일, 읽기/음악 선택**을 보여주는 화면. 이 파일은 **UX 벤치마크** 자료로만 활용한다.
- 6개 화면 캡처: 연도별 성장 사진, 사진 옆 일기 글, 실제 인쇄된 책과 연결용 키/QR 콘셉트, 페이지 넘기기와 책장 묶음.
- `FamilyAlbum-23.3.0-split-apks.zip` (사용자 제공): 안전한 ZIP 메타데이터 검사에서 `base.apk` 및 `config.arm64_v8a`, `config.ko`, `config.xxhdpi`의 **총 네 APK**와 `manifest.json`을 확인. 앱 패키지 `us.mitene`, manifest상 버전 `23.3.0`, 코드 `548`. **이 메타데이터는 앱의 실제 기능 동작 검증을 대체하지 않음**. 타사 소스/개인키/권한/결제 우회·코드 복제를 수행하지 않는다.

## 3. 사용자 후기에서 읽어야 할 실패 사례 (소수 표본, 전체 서비스 평가 아님)

- **23snaps AppStore 후기 한 건**: 웹 피드의 스토리 텍스트가 인쇄책에 누락된다는 불만. ⇒ MOA는 **디지털 ↔ 인쇄의 사진+글 일치**를 테스트 필수 항목으로 둔다. [원문 후기 포함 앱 페이지](https://apps.apple.com/us/app/23snaps-private-family-album/id526481189).
- **Popsa Google Play 사용자 후기**에는 사진 순서가 예상과 달라지거나 페이지 편집 내용이 사라졌다는 내용이 있다. ⇒ **자동 레이아웃은 제안만** 하고, 페이지 순서/자동저장/버전 복구/되돌리기를 분명히 한다. [Play 리뷰](https://play.google.com/store/apps/details?id=com.popsa.android).
- **Immich Reddit 사용자 경험**에서 가족 계정 권한, 백업 신뢰성, 중복 자산 문제가 반복 토론된다. ⇒ 동기화를 원본 백업으로 오인하지 않고 **검증 가능한 복구/권한별 가시성/중복검사**를 분리한다. 이는 일화이지 오류 발생률 자료가 아니다. [가족 공유](https://www.reddit.com/r/immich/comments/1ngo58l/immich_is_great_until_you_try_using_it_with_family/), [백업 질문](https://www.reddit.com/r/immich/comments/1u9r1jy/do_you_trust_immich_enough_to_use_it_as_your/).
- **Remento 회사 FAQ**는 구독 종료 후 기존 QR이 동작한다고 설명한다. 그러나 MOA가 수십 년간 책을 보존하려면 타사의 선언을 복제하지 말고 **미디어 자체를 별도 내려받아 복원할 수 있는 개인 백업**을 제공해야 한다. [공식 FAQ](https://help.remento.co/en/articles/9749302-why-is-remento-a-subscription-and-what-happens-if-i-don-t-renew), [다운로드](https://help.remento.co/en/articles/8865649-how-to-download-and-protect-your-family-memories).

## 4. GitHub / 오픈소스 기술 후보 — 라이선스 구별

| 구분 | 저장소 | 확인된 특성 | 라이선스/취급 |
|---|---|---|---|
| 책 넘김 핵심 | [Nodlik/StPageFlip](https://github.com/Nodlik/StPageFlip) | 모바일 터치 책 넘김, DOM 콘텐츠 | **MIT**, Android MOA WebView에 독립 라이브러리로 PoC 우선 |
| React 책 넘김 | [Nodlik/react-pageflip](https://github.com/Nodlik/react-pageflip) | React wrapper | **MIT**. 현재 MOA 화면에 React가 필수가 아니면 StPageFlip 원형 우선 |
| 인쇄 페이지 CSS | [pagedjs/pagedjs](https://github.com/pagedjs/pagedjs) | HTML/CSS page layout, CLI/Puppeteer PDF | **MIT**, 큰 페이지용 PC/웹 렌더 검토 |
| PDF 생성(JS) | [Hopding/pdf-lib](https://github.com/Hopding/pdf-lib) | 브라우저 JS에서 이미지/텍스트/페이지 PDF 구성 | **MIT**, 단일/소량 PDF PoC; 폰트 임베딩·대형 파일 성능 확인 |
| PDF 생성(React) | [diegomura/react-pdf](https://github.com/diegomura/react-pdf) | 선언형 PDF Document/Page | **MIT**, 별도 렌더 프로젝트일 때 검토 |
| 페이지 편집 | [fabricjs/fabric.js](https://github.com/fabricjs/fabric.js) | 캔버스 객체 편집, 위치·크롭·텍스트 | **MIT**, 2차 편집기 PoC; R707 기존 DOM 건드리지 않음 |
| 프린트북 화면/아키텍처 | [GraphicMeat/PhotoBooks](https://github.com/GraphicMeat/PhotoBooks) | PhotoKit + 원본 점수화 + 스크린/PDF 공통 레이아웃 | 소스 참조용. **라이선스 의무 세부 확인 후 사용** |
| 인쇄 PDF 북 데스크톱 | [oiahoon/Photo-Book-Studio](https://github.com/oiahoon/Photo-Book-Studio) | 로컬 퍼스트 편집·PDF | 소스 참조용. **라이선스 확인 전 코드 가져오기 금지** |
| 로컬 앨범 구성 | [meigo/slop-photo-album](https://github.com/meigo/slop-photo-album) | CV 기반 사진 선별·인쇄 가능 PDF/Tauri | 검토용, 라이선스 확인 필요 |
| 웹 그림책 만들기 | [agammann/picture-book](https://github.com/agammann/picture-book) | 웹/Windows 서사형 그림책 편집·수출 | README **MIT** |
| 프라이버시 가족 책장 | [Gnadi/0815memories](https://github.com/Gnadi/0815memories) (Kaydo) | 가족 메모리·편지·스크랩북·PDF | **MIT**, 그러나 README 자체에 **가족 키가 서버 Firestore에 있어 아직 zero-knowledge가 아니라고 명시**. 모델 그대로 보안 복제 금지 |
| 가족 포토 저널 | [svrforum/BebeMoment](https://github.com/svrforum/BebeMoment) | 한 가족별 서버, 일기/성장/댓글·권한·증분 백업 | **AGPL-3.0-only**, 서비스 아키텍처 참고. 폐쇄 소스에 무심코 코드 합치지 말 것 |
| 대규모 사진 인덱스 | [immich-app/immich](https://github.com/immich-app/immich) | 얼굴/위치/중복·사진 영상 백업, 공유 | **AGPL-3.0**, 내부 로직 파악/비교 우선 |
| 암호화·가족 공유 | [ente/ente](https://github.com/ente/ente) | 종단간 암호화/개인 가족 앨범 | **AGPL-3.0**, 개념 참고, 직접 가져오면 의무 검토 |
| 개인 클라우드 갤러리 | [pulsejet/memories](https://github.com/pulsejet/memories) | Nextcloud 타임라인/지도/큰 컬렉션 | **AGPLv3** |
| 로컬 얼굴/의미 검색 | [LibrePhotos/librephotos](https://github.com/LibrePhotos/librephotos) | 얼굴/장소/객체 검색 | 프로젝트 설명 **MIT**, 컴포넌트별 라이선스 재검증 |
| 사진 서버 | [photoprism/photoprism](https://github.com/photoprism/photoprism) | AI 사진 메타 관리/분류 | **AGPL-3.0** |
| iOS 일상 기록 예제 | [qyinm/glimm](https://github.com/qyinm/glimm) | 사진·음성·장소 local-first iOS 저널 | **MIT** |
| 개인 가족 프로젝트 | [chendren/family-memories](https://github.com/chendren/family-memories) | 로컬 가족 스토리/계보 | **MIT** (설명 기준), 실제 채택 전 소스 QA |

**중요**: 오픈소스 공개 = 제한 없이 복제 가능은 아니다. MIT도 NOTICE·저작권 표시 등 이행 필요. AGPL은 네트워크 제공 및 파생물 배포 상황의 소스 공개 의무가 생길 수 있다. 제품화 전에 각 종속성과 라이선스를 법률·배포 범위에 맞춰 다시 확인한다. 타사 APK는 제품 체험/UI 비교용, 비공개 알고리즘이나 디자인 자산을 복제하지 않는다.

## 5. 모아 전용 정보 아키텍처: 한 번 저장한 데이터로 여러 책 만들기

### 5.1 현재 기준 사실

- 기존 R707 프로젝트는 Android WebView/JS + 네이티브 갤러리, IndexedDB `familyjourney-diary-v1`의 `curated`, `entries`와 `photoIds`, `moments`, `body`, `removedMediaIds` 등 일기 원장을 가진다. 실물 사진/영상은 Android `MediaStore`의 로컬 ID/URI로 참조한다.
- R707 원본 `classes6.dex` 갤러리, `classes18.dex` PHOTO 호스트, GPS/지도 자동 갱신, OneUI 음량/영상, 네이버 로그인/일기/원장 **변경하지 않는다**.
- 책 만들기를 위해 기존 IndexedDB 원장을 직접 통합/이관하지 않는다. **read-only BookSourceAdapter**로 읽고 별도의 `moa-books-v1` DB와 `BookProject`에만 쓴다.

### 5.2 추천 도메인 개체

```text
FamilyMember        가족 구성원/권한/표시 프로필 (선택)
SourceDiaryRef      원본 일기 식별자와 당시 수정본 버전
MediaAssetRef       디바이스별 content URI/MediaStore ID + 독립적 assetKey
BookCollection      가족/여행/성장 등 책장·분류
BookProject         책 표지, 판형, 순서, 레이아웃, 초안/인쇄판 분기
BookChapter         분기(연도/월/장소/인물)와 설명
BookPage            블록 배열(사진, 영상 poster, 텍스트, 음성, GPS, QR)
BookRevision        버전 기록/undo/restore
PrintEdition        특정 시점 고정 인쇄판 (페이지, 텍스트, 사진 crop, PDF checksum)
SharedAccess        가족 역할별 책 열람/편집/원본 접근 권한
```

```json
{
  "bookId": "book_ulid",
  "schemaVersion": 1,
  "title": "우리 가족 2026",
  "collectionId": "family-yearbooks",
  "pagePreset": "square-200mm",
  "themeId": "moa-classic-01",
  "sourcePolicy": "snapshot_on_create",
  "chapters": [{"id":"ch1","title":"2026년 봄","pageIds":["p1","p2"]}],
  "pages": [{
    "id": "p1", "template":"photo-diary-01",
    "blocks": [
      {"type":"photo","assetKey":"local-asset-...","crop":[0,0,1,1],"refDay":"2026-04-01"},
      {"type":"text","sourceDiaryRef":"diary-id","textSnapshot":"그날의 이야기"},
      {"type":"audio","audioRef":"voice-id","qrExport":"off"}
    ]
  }],
  "editRevision": 3,
  "printEditions": []
}
```

이 코드는 **제안 스키마**다. 실제 앱 원본 DB 키/ID 매핑은 읽기 전용 스캐너로 확인 후 구현한다.

### 5.3 참조·스냅샷 정책

- **live-linked**: 사용자가 수락할 때만 원본 일기의 최신 사진/글 자동 반영.
- **snapshot-on-create** (초기 기본): 선정된 사진 자산과 당시 글 문구를 별도로 기억하되 원본을 덮어쓰지 않음. 원본 이미지 픽셀은 필요할 때 MediaStore에서 읽음.
- **print-frozen**: 인쇄 확정 후 책의 순서·글·Crop·QR 자산 목록 고정. 원본 일기 수정/사진 추가로 자동 변경 금지.
- **고유 미디어 ID**: 로컬 Android MediaStore ID를 전역 ID로 사용하면 기기 교체 시 깨질 수 있으므로 `deviceId/uri/captureTime/optionalSha256` → 앱 자체 `assetKey`를 갖게 하고, `missing/originalAvailable/previewOnly` 상태 표시. iOS에서는 PhotoKit의 플랫폼별 localIdentifier가 별도 자산 참조.
- 파일 삭제·일기 제외·유저가 책에서만 사진 제외를 **서로 다른 명령**으로 취급하고 원본 파일 삭제는 이 모듈에서 절대 수행하지 않음.

### 5.4 페이지 자동 편집 규칙

1. 날짜 범위/여행/가족 구성원/태그로 일기+미디어 **선별**. 일기 없는 사진도 명시적으로 선택 가능.
2. 날짜·장소 변화로 챕터 구성, 시간 근접·이미지 유사도로 비슷한 컷은 그룹화. 작은 아이가 찍힌 소중한 사진을 AI가 점수 낮다고 임의로 삭제하지 않는다.
3. 기본 템플릿: `표지`, `한 장 사진`, `좌우 2장`, `4장 그리드`, `사진+한 줄 일기`, `사진+긴 일기`, `월간 달력`, `지도+장소`, `성장 Before/After`, `음성 QR`.
4. 사진 가로/세로 방향과 텍스트 분량으로 배치안 생성, 인쇄 시 얼굴 잘림 경고·해상도 부족 경고.
5. 사용자는 언제든 페이지 순서/사진/제목/크롭/일기 인용을 수정하고 되돌릴 수 있음. 자동 엔진은 **제안**만 한다.
6. 기본 생성은 로컬/오프라인으로 가능. 인물 인식, 문장 다듬기 등 AI 추가는 **명시적 선택 동의**, 원본 일기 텍스트/오디오 절대 자동 대체하지 않음.

### 5.5 책장 UX (구현안)

```text
[일기] [나의 지도] [+] [기록] [설정]  (기존 탭 유지)
                 |
기존 일기 상단 '모아 책장' 진입 / 설정 > 모아 스튜디오
                 |
[책장]  [모두] [가족] [아이 성장] [여행] [기념일] [보관함]
    ├── 2026 우리 가족 (표지/책등/쪽수/업데이트 뱃지)
    ├── 아이 A의 첫 번째 봄
    └── 부산 여행
       ↓ 책 터치
[읽기] 표지 → 목차 → 페이지 넘김 / 하단 페이지 썸네일
       [원본 일기 보기] [영상 ▶] [음성 듣기] [지도]
       [편집] [복사하여 새 판 만들기] [PDF 만들기]
```

- 모바일: 세로 한 페이지/가로 두 쪽; 삼성 탭/PC: 양면 펼침, 텍스트 가독성.
- StPageFlip은 질감/애니메이션만 담당; 장애인 접근성·대량 미디어·저사양 폰을 위해 `세로 스크롤(애니메이션 OFF)`도 제공.
- 책장 썸네일은 작은 미리보기만 캐시. 실제 원본 사진은 화면 페이지에 도달할 때 lazy decode/해제.
- 수천 개 사진을 책 생성 UI에 올려도 현재 R707 네이티브 갤러리의 스와이프/사진선택 처리에 영향 없어야 함.

## 6. 디지털·인쇄·영상·QR의 실제 기술 선택

**디지털 읽기**: 현재 앱의 WebView에 `StPageFlip` 등 독립 웹 자산으로 book reader만 붙인다. 원본 포토 갤러리 엔진 `classes6.dex` 및 일기 화면을 교체하지 않는다. 실제 비디오 재생은 원본 미디어 URI를 읽기 전용 브리지로 연결하고 `AudioFocus`/뮤트/OneUI 음량은 기존 로직과 충돌하지 않게 별도 테스트한다.

**PDF 초안**: `pdf-lib` 또는 Android `PdfDocument`를 사용한 10~20쪽 인쇄 테스트. 같은 JSON 디자인 정의를 화면과 인쇄 렌더러가 사용하지만 **화면 캡처 PDF가 아님**. 한글 폰트 임베딩, 가로/세로 이미지 Crop, 텍스트 줄바꿈, 페이지 번호, 실제 300dpi 기준 사진 품질 테스트.

**대량/전문 인쇄**: `Paged.js`+PC/headless PDF 렌더 또는 별도 print renderer, 책 표지/본문/책등을 분리. 판형/여백/재단 규칙은 **선택한 업체별 프리셋**. 어떤 인쇄소는 일반 3mm bleed를 요구하지만, 어떤 인쇄 파트너는 'bleed 추가하지 말 것'을 요구한다. 한 가지 전역 3mm 규칙 적용 금지. [일반 가이드](https://www.printready.live/how-to), [Prodigi 제품별 규격](https://support.prodigi.com/hc/en-us/articles/17150478672540-Layflat-photo-books-File-set-up-guidelines).

**QR 음성/영상**: 초기 디지털책에서는 앱 안의 원본으로 재생. 인쇄 QR은 앱 전용 `bookId/pageId/assetId`로 수명을 관리하고, 링크 공유는 인증/공개범위/기간을 제어. **Android `content://` URI, 로컬 기기 IP, 유효기간이 짧은 직접 signed URL을 종이책 QR에 넣으면 안 됨**. QR 대상 원음의 독립 백업과 교체/복구 정책도 필수.

**성장 영화**: 동일 BookProject 페이지/자산을 활용한 영상 프리뷰·연말 영상은 장기 단계에서 Android Media3 Transformer 검토. [Android SDK 문서](https://developer.android.com/media/implement/editing-app).

**아이폰/태블릿/PC**: iOS는 사진 선택에 PhotoKit/PhotosPicker를 사용하며 `MediaStore` 접근 불가. 책 스키마/HTML 페이지 템플릿은 공통으로, 입출력/권한은 각 OS 전용 adapter로 구성. [Apple PhotosUI](https://developer.apple.com/documentation/photosui), [Android MediaStore](https://developer.android.com/training/data-storage/shared/media).

## 7. 가족 정보 보호·원본 내구성

- 아이 얼굴·음성·GPS·집 위치와 일정은 민감. 기본 비공개, 외부 공유/인물 검색/AI 업로드 개별 OFF, 최소 권한, 접근 로그/해제 기능.
- FamilyAlbum 같은 클라우드 서비스의 '무제한 저장'을 모아에 즉시 약속하지 않는다. 저장 비용·보안·실제 다중 복구가 필요.
- 장기 보존을 위해 메타데이터 JSON/원본 사진·영상·음성/포토북 편집 원본/PDF를 포함하는 export manifest + SHA256; 복원 테스트를 보장한다. **동기화 ≠ 검증된 백업**.
- `Kaydo`는 클라이언트 암호화를 안내하지만 공식 README는 가족 키가 Firestore에도 있어 아직 zero-knowledge가 아니라고 직접 인정한다. MOA는 'E2EE' 또는 'zero-knowledge'를 실제 키 관리/보안 리뷰 전에는 주장하지 않는다. [원본](https://github.com/Gnadi/0815memories).
- AGPL 참고 서비스의 코드를 몰래 결합하지 않고 알고리즘 개념/공개 문서 참조 또는 허용된 MIT 유틸만 엄격히 추적.

## 8. 실제 개발 로드맵 (제안, 착수 승인 아님)

| 단계 | 결과물 | 완료 게이트 | R707 영향 |
|---|---|---|---|
| P0. 원본보호 | R707 Golden 바이트 잠금, 실제 일기+미디어 read-only 진단, 테스트용 가짜 데이터 fixture, 백업 검증 | 원장 쓰기 ZERO, 미디어 경로/권한 안전 | 변경 없음 |
| P1. 책장 MVP | 독립 `moa-books` 저장소, 책장 UI, 날짜 범위→자동 10~20쪽 디지털책, 원본 일기 점프 | 1/100/10000 미디어, 원본 변경 ZERO, 재시작 후 동일 책 | 새 독립 파일 및 최소 연결 |
| P2. 편집기 | 서체/표지/페이지 템플릿/재배치/undo/자동저장/편집판 고정 | 주문 실수·순서 소실·중복없는 복원 | 기존 갤러리 수정 금지 |
| P3. 책 수출 | 완성책 고해상도 PDF/표지/책등/QR 옵션, 인쇄 품질·규격 검사 | 한글 폰트, 인쇄 dpi, 페이지 10~100, 자산 없을 때 안내 | PDF 외부 저장만 |
| P4. 가족 공유 | 조부모 읽기 전용, 부부 공동 편집, 권한/동기화 및 검증된 백업 | 암호화/동기화 충돌/기기 교체 복원, 원본 권한 | 서버 독립 모듈 |
| P5. 프리미엄 | 음성 인터뷰책, 한/영 성장책, 과거의 오늘, 1초 성장영화, 아이별 책장 | 옵트인 AI/영상·QR 장기 존속, 비용/권한 | 별도 모듈 |

새 실제 APK 빌드 시 **후보 code ≥709 + 정확한 R707 기능 복구 code ≥710**를 한 세트로 서명·검증한다. 동시 구현 범위가 커지면 각 모듈별 작은 업데이트로 분리한다. R708은 R705 기능 복구이므로 R707 Golden 전체 복구 수단이 아니다.

### 최소 테스트 픽스처/수용 기준

- 1일=사진1/영상1/음성1/본문1, noGPS, 해외 GPS, 원본 일기 중복, 동일 사진 여러 책, 날짜 미상, 동영상 마지막 장, 삭제/이동된 자산, 사진 10,001장 창 경계, 세로/가로 회전.
- 일기 본문 편집→책 `snapshot` 불변 / `live`는 동의 후 갱신.
- 책 페이지 제거해도 원래 일기·MediaStore 사진 그대로; 화면 뷰어 닫아도 기존 갤러리·음량·QuickRecord·네이버 쿠키 그대로.
- 30일→자동 책 생성→책장에서 열림→페이지 10장 넘김→원본 일기 이동→책 장수정/재시작 동일→PDF 출력→완전 복구.
- 인쇄 PDF의 사진 원본 해상도 경고/책등·재단 영역/한글 글리프/QR 링크 테스트.
- 외부 공유 OFF면 앱 밖으로 아동 사진·목소리·위치가 자동 업로드되지 않음.
- Android Galaxy 실제 테스트와 GitHub/JS 단위 테스트를 구분. 사용자가 실기기 PASS 보고하기 전 새로운 Golden 명명 금지.

## 9. 외부 소스 모음 사용 규칙

- 이 문서는 **대표성 있는 조사 샘플**, 전 세계 모든 앱·전체 버전을 망라했다는 뜻은 아니다. 세부 가격/라이선스/지역별 주문 가능성은 착수 직전 최신 확인.
- 아래 함께 저장한 `MOA_GLOBAL_APP_GITHUB_REFERENCE_INDEX_20261124.csv`는 제품/오픈소스/SDK의 검색 가능한 인덱스다.
- 본 자료와 인덱스는 **공개 링크/비개인적 설계만** GitHub에 보관한다. 사용자 제공 사진, 아이 얼굴, 영상, private signing key, FamilyAlbum 상용 APK 바이너리 원본을 GitHub에 올리지 않는다.
- 실제 코드/앱은 이번 조사에서 **전혀 수정하지 않았다**.

## 10. 원 프로젝트의 동결·인계 근거

- [MOA R707 Golden lock](https://github.com/yooogillycloud123/family-journey-personal/blob/main/MOA_R707_GOLDEN_LOCK_AND_NEW_CHAT_20261121.md)
- [MOA R707/R708 signed release handoff](https://github.com/yooogillycloud123/family-journey-personal/blob/main/MOA_R707_R708_ORIGINAL_SIGNED_MAP_GALLERY_RELEASE_HANDOFF_20261121.md)
- [MOA 2026-11-18 future roadmap (historical R697 baseline; current baseline now R707)](https://github.com/yooogillycloud123/family-journey-personal/blob/main/MOA_FUTURE_VISION_RESEARCH_IMPLEMENTATION_ROADMAP_v1.0_20261118.md)
- [MOA read first](https://github.com/yooogillycloud123/family-journey-personal/blob/main/MOA_READ_FIRST_NEW_CHAT.md)