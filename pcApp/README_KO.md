# FamilyJourney PC v0.1 — Windows portable

원본 Android FamilyJourney 앱과 별도로 실행하는 **오프라인 PC 사진 일기**입니다. 독립 작성 코드이며 원작 상용 앱 웹 자산이나 개인 자료를 포함하지 않습니다.

## 사용
- GitHub Actions `Build FamilyJourney PC for Windows`의 `FamilyJourney-PC-Windows-Portable` ZIP 아티팩트에서 `FamilyJourney-PC.exe`를 꺼내 실행. Python 별도 설치 불필요.
- 시작 시 브라우저로 `127.0.0.1`의 임시 포트 열림. 프로그램 창은 별도로 뜨지 않으며, EXE를 종료하면 사이트 연결도 종료됩니다.
- `＋ PC 사진 폴더 가져오기`로 PC 사진 폴더를 선택하면 EXIF 촬영일로 색인. 사진 원본은 복사되지 않고 폴더 경로를 참조합니다.
- `내가 고른 사진 일기`는 메인, `자동 사진 달력`은 보조. 서로 별도의 기록으로 저장됩니다.
- 사진 선택(다른 촬영월 허용) → 날짜/제목/글/기분·태그 작성 → 저장.
- `일기/동기화 파일 가져오기`: Android R25 `familyjourney-diary-v3` JSON에서는 **글과 메모만** 가져옵니다. 기존 Android MediaStore 숫자 ID만으로는 PC 원본 사진을 찾을 수 없습니다.
- PC 전용 `familyjourney-sync-v1` ZIP은 선택 일기 기록과 연결 사진을 포함하며 두 Windows PC 간 수동 복원 가능합니다. 원본 사진을 포함하므로 ZIP 자체에는 가족사진·일기 개인정보가 들어 있습니다. GitHub 등에 업로드하지 마세요.
- PC 데이터 위치: `%USERPROFILE%\Documents\FamilyJourney\familyjourney.sqlite3`. PC 사진 폴더를 이동하면 경로를 다시 지정하거나 수동 복원해야 할 수 있습니다.

## 검증
- Windows CI 41189841854 success: EXIF 날짜, 독립 diary DB, ZIP 원본 사진 무결성 복원, 로컬 인증 토큰 HTTP 인터페이스 테스트 + PyInstaller 실행 파일 생성.
- 사용자 PC 실사용/바이러스 백신 동작/대량 사진 처리 시간 미검증.

## 완성하지 않은 기능
- Windows PC의 Android R25와 자동 양방향 동기화는 아직 없음.
- iPhone 동기화·iOS 앱은 아직 없음.
- Android판의 여행 GPS 지도/영상/네이버지도 저장 자동화는 PC v0.1에 포함되지 않음.

최종 통합/동기화 지침: `AA_FAMILYJOURNEY_PC_IOS_SYNC_READ_FIRST_20261031.md`.
