# MOA R469 DayPic 간편 사진 일기 — 원본 연동 1차 개발본 (2026-11-13)

## 현재 상태 (엄격 구분)
- **실제로 작성된 앱용 WebView 소스:** `moa-r469-simple-diary.js`, `.css`; 기존 APK의 `assets/web/index.html`에 CSS/JS 두 줄만 추가한 로더 수정본과 최소 diff.
- **원본 R463 골든 바이너리는 수정하지 않았습니다.** 이 ZIP은 **설치 가능한 서명 APK가 아닙니다**. 동일 앱에 덮어쓰기할 APK는 최초 설치와 동일한 APK 인증서의 개인키로 다시 서명해야 하며, 현재 작업 환경에 원본 개인키가 검증 가능하게 준비돼 있지 않습니다. 새 서명으로 만든 APK를 기존 앱 위에 설치하라고 제공하지 않습니다.
- 개발본이 호출하는 기존 데이터/앱 API는 R463 APK 내부 `family-diary.js`, `moa-r149-voice.js`, `fj-naver-favorites.js`를 실제 추출해 확인했습니다.

## 실제 연동 구현 범위
1. 기존 `FamilyJourneyDiary.state`를 읽어 기존 선택 사진 달력/자동 사진 달력과 **동일한 사진 ID/날짜**로 세 번째 사진 가득 채운 달력 추가. 현재 선택한 날짜 테마 강조, 오늘 표시, 월 이동, 중앙 +, 홈 이동.
2. 달력의 날짜 → 간편 일기의 날짜/사진·영상 목록 연결. **원본 컬렉션 정렬 유지**, 수동 선택 기록에 사진이 없을 때 해당 날짜 자동 사진을 읽음.
3. 기존 `calendar-covers-r29`의 `curated` 대표 사진을 **동일 IndexedDB 메타 저장**으로 업데이트. 날짜 썸네일과 간편 화면 초기 사진에 적용.
4. 사진/영상 미디어의 실제 MediaStore ID 기준 `window.__requestThumbs`(400/130) 호출. **지정된 미디어 영역 안**에서 사진 좌우 이동, OFF 한 장씩, ON 빠른 다중 이동(현재 Web JS 제스처 구현이며 R203 네이티브 관성을 그대로 임베딩한 것은 아님). 도구/썸네일 숨김 기본, 필요한 경우 펼침.
5. 기존 네이티브 공유 명령 `sharePhoto`/`diaryShareVideo`, `FamilyJourneyDiaryGeo.attach`로 위치 패널·기존 지도 연결, 촬영시간 정보 접기/펼치기.
6. 현재 `curated` 원본 일기 문서의 body 필드에만 기록 저장. **동일 IndexedDB readwrite 트랜잭션**으로 기존 `moments`, `activities`, `photoIds`, `voiceIds`, 제목/태그 등을 보존하는 merge. 바로기록을 다른 시스템으로 복제하지 않음. 상세 편집기로 기존 `selectDay` 연결.
7. 기존 `MoaLocalAudio.list(day)`에서 날짜별 M4A 파일 여러 개를 받아 **한 줄짜리 선택 플레이어**, `MoaVoicePlaybackUI.play/stop` 연계. 녹음은 기존 `MoaVoiceDiaryNative.open`으로 연결해 원본 권한/파일 보존·auto-transcript 처리 유지.
8. WebView에 허용될 경우 Android content:// video URI에 HTML5 `<video>`로 화면 내 재생 시도. 실패 시 기존 `diaryPlayVideo` 네이티브 재생기로 수동 fallback (직접 내부 영상 완전 성공은 아직 미검증).

## 아직 실제 연결/실기 검증되지 않은 부분
- Android 원본 서명된 설치 APK의 제작·덮어쓰기 설치 (개인키 접근 확인 전 불가).
- R463 `classes6.dex` 원본 Gallery의 고품질 원본 이미지/`TextureView`/`MediaPlayer` 직접 카드 내 임베딩. 현재 모듈은 기존 400px 썸네일 브리지/HTML5 video 지원 여부에 따라 동작하며, **R203 오버스크롤러 관성의 정확한 재사용은 아직 아님**.
- 실제 기기에서 WebView video content:// 권한/디코딩 및 공유·지도 복귀, 마이크/플레이어 상태, 갤러리 확대/프레임캡처까지 전수 테스트.
- 음성 플레이어 seek(현재 네이티브 인터페이스는 play/toggle/stop 노출, seek는 검증된 API 없음) / 날짜별 원본 모두 연동 성공 단정 금지.
- 별도 신규 일기 저장 방식이나 사진 삭제는 추가하지 않았습니다.

## 보존·실행·검증 원칙
- 원본 골든 SHA256: `9d2fd10d32a3bc35eb3132333e96edd8f565abd5daf3ce954b052f77083d8379`, versionCode463, 패키지 `com.juhyeon.familyjournea`.
- 별도 개발 브랜치: `feature/moa-r469-daypic-real-web-bindings-20261113`. **R463 frozen branch 수정 금지**.
- 압축 파일은 실제 APK에 이식하기 위한 소스 패치 번들이며, 임의 서명·설치 시도가 아닌 코드 검증용입니다.
- 다음 단계: 원본 서명 가능한 빌드 환경 확보 → 설치형 code469+ 빌드 → 원본 기능 회귀/갤러리/음성/video 실기 PASS 판단 → 별도 code>candidate R463 정식 복구본 함께 제공.