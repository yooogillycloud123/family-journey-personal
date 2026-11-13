MOA R469 DayPic 간편 사진 일기 — 실제 기존 앱 서명 업데이트 베타 (2026-11-13)

[릴리스 상태]
- 설치용 APK: MOA_R469_DAYPIC_REAL_BINDINGS_SIGNED_BETA.apk, versionCode469
- 동일 원본 PKCS#12 개인키의 인증서 SHA256 5a86862b...0f15로 재서명; APK Signature Scheme v2 RSA / 전체 APK content digest / ZIP CRC 통과.
- 기존 패키지 com.juhyeon.familyjournea 그대로. 앱 삭제나 앱 데이터 초기화 없이 설치하는 업데이트용.
- 실제 갤럭시에서 UI 실행·영상 스트리밍/음성 녹음 시험은 아직 하지 않았으며 사용자 현장 확인 전 골든 승격 금지.
- 복구용 APK: MOA_R471_EXACT_R463_GOLDEN_FUNCTIONAL_RECOVERY.apk (versionCode471, R463 기존 기능으로 복귀, manifest 버전만 다름).
- R471을 설치하면 이후 업데이트 APK versionCode는 471보다 높아야 함.

[원본 R463에서 보존]
- 원본 140개 APK 내부 항목 중 138개 payload 그대로. 변경 2개: AndroidManifest.xml 버전과 assets/web/index.html 스크립트 로더 각 한 부분.
- 원본 classes.dex ~ classes17.dex 17개 DEX 완전 동일. 원본 갤러리/영상, 네이버 비점유 저장/쿠키, 홈 버튼 등 그대로 보존.
- 새 자산 2개: assets/web/moa-r469-simple-diary.js, assets/web/moa-r469-simple-diary.css.

[이번 R469 실제 앱 WebView 코드에 추가한 연동]
1. 기존 일기에서 '사진 일기' 세 번째 진입 버튼, 사진이 날짜 칸을 채운 달력, 날짜 강조/오늘/월이동/중앙+.
2. 사진·영상 날짜/MediaStore 원본 ID 및 R463 기존 썸네일 브리지 읽기, 인라인 좌우 사진 넘기기, 토글 도구/썸네일, 본문 영역과 사진 영역 같은 좌우 여백·둥근 테두리.
3. 기존 diary meta/calendar-covers-r29에 대표 사진 저장, 커버/첫 사진 적용.
4. 기존 공유 NativeHost sharePhoto/diaryShareVideo, 위치 FamilyJourneyDiaryGeo.attach, 촬영 시간 표시 연결.
5. 기존 curated/entries 중 실제 존재하는 날짜 기록을 선택해 동일 IndexedDB readwrite 트랜잭션으로 본문 저장(활동/바로기록/moments/미디어 필드 보존, 중복 생성 회피).
6. 기존 MoaLocalAudio 날짜별 M4A 목록, MoaVoicePlaybackUI 재생·중지, 기존 MoaVoiceDiaryNative 녹음 화면 연계. 한 줄 음성 플레이어 + 여러 녹음 선택 목록.
7. 영상은 content://... WebView 인라인 재생 시도 및 실패 시 기존 네이티브 영상 플레이어 수동 호출.

[정직한 미구현/기기 검증 항목]
- 완전한 네이티브 Gallery classes6.dex TextureView/MediaPlayer 기능을 새 인라인 카드에 직접 이식한 상태는 아님. 현재는 원본 썸네일(최대 400px) + WebView 내 사진 전환 방식.
- R463 R203 네이티브 관성 OverScroller를 그대로 공유하는 것은 아직 미구현. R469은 ON시 JS 기반 다중 사진 넘기기만 제공.
- 동영상 inline content URI 권한/렌더링, 원본 영상 음소거/캡처/볼륨, 사진 핀치 줌, 사진 원본 화질 확대는 추가 Android 네이티브 통합·실기 검증이 필요.
- 음성 여러 파일은 목록과 기존 네이티브 플레이/녹음 기능에 연결됐지만 새 화면의 실제 파형·프로그레스 seek는 아직 네이티브 API 확인 전이므로 표시만 사용(탐색 입력 비활성화).
- 공유/지도 복귀 시 현재 페이지 보존, 모든 화면 진입, 사진 날짜 자동매핑/카메라 바로기록과의 실기 통합 검증 전.

[사용자 시험]
(1) 기존 모아를 제거하지 말고 R469 설치. 처음 '일기' 메뉴 → '사진 일기' 버튼 확인.
(2) 사진 달력 → 날짜 → 대표 사진(☆) 지정 → 달력 복귀 후 표지 확인. 기존 사진/영상 및 상세 일기/바로기록 보존 확인.
(3) 글 한 줄 저장, 기존 상세 일기 같은 날짜에서 해당 본문 확인. 기존 시간대별 활동/바로기록 유지 확인.
(4) 음성 2개 이상 보유 날짜에서 1/N 선택해 개별 재생/새 녹음 후 재확인.
(5) 영상 재생 및 share/GPS/비점유 저장 회귀 확인. 문제가 있으면 R471 복구 APK(동일 서명, 상위 버전)를 원앱 위에 덮어써 R463 골든 기능으로 복귀.

[개인키 관리]
- 서명 키·암호·백업 원본은 공개 GitHub, 배포 ZIP, 사용자 APK, QA 문서에 포함하지 않음.
- 이번 신규 APK를 골든으로 승격하려면 실제 갤럭시 동작 확인 필요. 최상위 사용자 승인 골든은 여전히 R463.