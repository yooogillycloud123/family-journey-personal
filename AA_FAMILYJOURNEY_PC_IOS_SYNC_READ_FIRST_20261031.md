# FamilyJourney — PC · Android · iOS 동기화 최상위 설계 및 2026-10-31 작업 인계

## 사용자가 직접 확정한 목표
- **최우선: Windows PC 앱은 반드시 제작·실사용 가능**. 기존 Galaxy S26 Ultra Android R25의 사진 선택 일기(메인), 자동 사진 달력(보조), 일기/사진/추억을 PC에서도 관리.
- 최종: Android ↔ Windows ↔ iOS 기기에서 **사진의 안정된 식별자, 일기 글/날짜/메모/사진 선택 목록**을 연동·동기화. 한쪽에서 기록 수정 시 다른 쪽에도 반영, 원본 무단 전송 금지.
- 기존 Android R25 잘 되던 지도/여행 영상/네이버지도/사진 뷰어/다이어리의 정상 동작은 그대로 보존. Android 패키지 `com.juhyeon.familyjourne2` 및 owner signing key 유지; 절대 삭제/재설치 요구 금지.
- 공개 GitHub에는 오직 새로 작성한 독립 PC 소스와 공용 프로토콜 코드만. 상용앱 웹 자산, 원본 사진/GPS, 사용자 가족 일기, 서명키·자격증명 업로드 금지.

## 실제 완료된 PC 1차 앱
- 원본 독립 앱 `pcApp/app.py`, `index.html`, `app.js`, `style.css` (Python stdlib + Pillow).
- Windows GitHub Actions 자동 빌드 `.github/workflows/build-familyjourney-pc.yml` (PyInstaller onefile GUI).
- 아티팩트 `FamilyJourney-PC-Windows-Portable.zip`, 내부 `FamilyJourney-PC.exe`: Python 미설치 PC에서 실행.
- EXE 127.0.0.1 임의 포트 HTTP 서버를 띄우고 사용자의 기본 브라우저로 UI 열기; 세션 토큰 확인, 외부 네트워크 서비스 없음. 저장 위치 `%USERPROFILE%\Documents\FamilyJourney\familyjourney.sqlite3`; 개인 데이터는 로컬.
- 원본 사진 폴더 검색→EXIF 날짜 정렬→선택사진 달력 및 자동사진 달력 독립→하루 일기 작성/수정/삭제→다른 월 사진 다중 선택→선택사진 썸네일·한국어 기록.
- Android R25의 기존 [일기 백업] JSON(`schema=familyjourney-diary-v3`)을 PC에서 **글·기분·태그·시간대 메모** 가져올 수 있지만, R25의 `photoIds`는 Android 기기 로컬 MediaStore ID여서 사진 원본은 자동 매칭되지 않는다.
- PC 자체의 `familyjourney-sync-v1` ZIP: 일기 기록 + **선택 일기에서 실제 연결된 원본 사진만** SHA-256 에셋으로 포함, 다른 PC의 동일 Windows 앱은 ZIP을 가져와서 기록·사진을 병합할 수 있도록 구현. 이것은 아직 **Android/iOS 연동 완료가 아니다**.
- Windows CI source syntax+동작 테스트: 사진 EXIF 날짜, 독립 diary storage, ZIP media export→import roundtrip, localhost 토큰 보호. 실사용 Windows 데스크톱 UI/대량사진 성능은 사용자 PC 검증 필요.
- 자동 사진 달력의 **전체 원본 수만 색인**하는 것은 PC 스캔 대상 폴더 기준. 스마트폰 12,783장과 동일한 PC 사진 라이브러리가 존재해야 숫자가 같아진다.
- PC는 현재 지도 경로 영상, 원작자 지도 렌더링, 네이버지도 Android 접근성 자동 저장 기능까지 포팅한 완전 동일 기능판이 **아니다**. 확대 해석 금지.

## 공통 Sync v1 포맷과 보존 규칙
```json
{
  "schema":"familyjourney-sync-v1",
  "device":"windows-pc",
  "created":0,
  "records":[
    {"day":"2026-10-31","mode":"curated","title":"우리 가족","body":"...",
     "tags":"","feeling":"","activities":{},"updated":0,
     "photos":["0123...64charsha256"]}
  ],
  "assets":[{"sha256":"...","file":"media/<sha256>.jpg","taken":0,"approx":false}]
}
```
- 사진 식별자는 Android 숫자 ID/iOS PHAsset ID/Windows 로컬 path가 아니라 **원본 파일의 SHA-256**. 기기별로 SHA-256→로컬 사진 URI 매핑 DB를 별도 유지.
- 선택사진 일기와 자동사진 일기는 **별도 mode/store**로 동기화, 112장 자동 사진이 선택 9장으로 대체되는 R23 회귀 방지.
- 삭제는 당장 반대편까지 즉시 삭제하지 않는다. 차기 동기화 모듈에서 삭제 tombstone/취소·충돌 관리와 백업 구현 전 실제 자동 삭제 동기화 금지.
- 충돌 시 사용자의 최신 기록을 묻거나 충돌 사본을 남긴다; 데이터 유실되는 단순 덮어쓰기는 금지.
- 기본은 기록 및 미리보기 우선, 원본 사진은 사용자가 지정한 폴더만 선택적 전송; 전량 12k장 자동 업로드 금지.

## 실제 3기기 자동 동기화에 필요한 단계
1. **R26 Android**에서 MediaStore 원본 SHA-256 계산(선택된 사진만), PC Sync v1 ZIP 내보내기/가져오기와 `familyjourney-diary-v1` IndexedDB의 entries/curated 양방향 병합. 검증 후에야 'Android↔PC 연동' 완료 주장 가능. 기존 R25 ZIP 가져오기 버튼은 사진을 Android Gallery로 가져올 뿐, PC 일기 기록을 자동 복원하지 않는다는 점을 분명히 한다.
2. 자동화: PC 공유 폴더/개인 NAS/자체 Nextcloud WebDAV 하나를 공통 동기화 공간으로 설정; 앱에서 사용자 승인 후 백그라운드 전송, 일정 제한, 충돌 처리, 디바이스 등록/폐기. 개인 WebDAV 운영 시 E2EE를 따로 구현하여 서버 운영자도 평문 가족 사진·일기를 못 보게 하는 것이 이상적.
3. **iOS 앱**: 별도 SwiftUI + PhotoKit(허가된 사진) + Files + 동일 Sync v1 및 충돌 해결. iOS 빌드는 Apple 계정/서명/TestFlight/실기검증 필요. iOS는 백그라운드 전송을 OS가 스케줄하기 때문에 절대적인 실시간 동기화를 보장할 수 없고, Android 네이버지도 Accessibility 조작은 동일 방식 포팅 불가. 사진 달력·일기·미디어 공유·일반 지도는 포팅 가능.
4. 기존 여행 지도/영상/장소 분류 PC·iOS 동등 구현은 별도의 원본 데이터/알고리즘 이식 프로젝트. '전체 기능 100% 이식'을 지금 완료했다고 주장하지 말 것.

## 새 채팅 READ FIRST
- AirPods 프로젝트 별도 최상위 지침을 읽은 후 FamilyJourney에서는 `AA_FAMILYJOURNEY_R25_READ_FIRST_20261031.md`와 이 파일을 먼저 끝까지 읽고 최신 PC workflow/ZIP 결과부터 재개할 것.
- 자동 동기화라고 표시하기 전에 Android R26↔Windows PC↔iPhone 실기 *수정→전송→재시작→양쪽 사진·글 보존* 검증이 필요.
