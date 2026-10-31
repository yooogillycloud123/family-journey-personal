# 우리 가족 여행 — iOS R1 (독립 네이티브 앱)

안드로이드 R29 GOLDEN은 수정하지 않았습니다. 안드로이드 앱을 iOS로 변환하거나 기존 유료 상용 앱의 소스를 재배포한 것이 아닙니다. Apple PhotosKit·MapKit·AVKit로 별도 구현한 개인용 앱입니다.

## 실제 구현된 기능(소스 코드)
- iPhone Photos 보관함 접근 권한, 사진·동영상 날짜/촬영 좌표 메타데이터 자동 인덱싱(원본 복제 없음)
- 내가 고른 사진·동영상 일기 (첫 화면) / 날짜별 자동 사진 달력 분리, 저장·편집·삭제, 대표 사진 변경
- 특정 날짜 전체 사진과 시간대별 묶음 보기, 사진 전체화면 확대·좌우 이동, 영상 내장 재생
- 사진/영상 공유 시트(카카오톡 등), 날짜별 위치 공개/접기, 정확한 GPS 마커의 네이버지도 열기
- Apple 지도 마커와 방문 위치 기록 (약 25 m 그룹화), 지도 테마 변환
- 기기 로컬 일기 JSON 백업/복원, 인스타그램 계열 색상의 하트 앱 아이콘

## Android R29와 아직 다른 점
- iOS는 Apple 보안 구조 때문에 Android AccessibilityService 방식의 네이버 저장 목록 선택·즐겨찾기·메모 자동 입력을 복제하지 못함. 네이버지도 위치 열기와 사용자가 직접 즐겨찾기하는 방식.
- 기존 Android R29 IndexedDB 일기를 iPhone에 자동 동기화하지 않음. JSON 메모만 수동 백업 가능하며 안드로이드와 사진 ID 체계가 다름.
- 현재 iOS R1에는 기본 지도 이동선 MP4 생성은 구현했으나 Android 원본의 사진 삽입/다중 지도 테마/고급 렌더링 엔진과 여권 방문지역 색칠, 별도 PC 사진 가져오기 고급 기능이 미구현. **기능 완전동등이라 주장하지 말 것**.
- iOS 갤러리의 개별 asset 위치로 Apple 사진 앱 내부를 강제 이동하는 공식 공개 딥링크 없음: `사진 앱에서 열기`는 공유 대화상자로 대체됨.
- iCloud Photos 사용시 해당 기기 사진의 원본 다운로드는 Apple iCloud 인프라를 사용할 수 있음.

## 빌드와 설치
- Xcode 16 이상 설치된 Mac에서 아래 프로젝트를 열어 빌드합니다. 소스 묶음의 `project.yml`은 XcodeGen을 이용해 `.xcodeproj`를 생성합니다: `brew install xcodegen && xcodegen generate`.
- 무료 Apple 계정으로 자신의 기기에 직접 테스트하는 방법은 가능하지만, **배우자 iPhone에 배포할 ipa/TestFlight는 올바른 Apple 서명 자격 및 경우에 따라 유료 Developer Program이 필수**입니다.
- CI: GitHub Actions 공개 저장소의 macOS runner에서 XcodeGen 후 iOS Simulator 타깃 `CODE_SIGNING_ALLOWED=NO` 빌드를 진행. CI PASS는 실제 iPhone 설치 PASS가 아닙니다.
- 개인/가족 사진과 GPS, Apple 비밀번호·인증서·서명키는 공개 GitHub에 올리지 않습니다.