# MOA R227 갤럭시 네이버지도 복귀 첫 현장 검증 — 최소 실행표 (2026-11-09)

**목적:** 기존 R227 코드가 이미 해결하도록 설계된 갤러리 유지/동일 사진 복귀를 실제 확인한 후, 실패한 부분만 R229+에서 고친다. 이번 문서는 테스트 절차이며 기능 구현 완료 주장이 아니다.

**테스트 버전:** MOA R227 `com.juhyeon.familyjournea`, APK SHA256 `53c4c04ce32ad13de3c0613f4e5ec7abbc75ccbdfe9db5da05d8fa9b806ec6cd`; 사용자 설치 여부 현장 확인 필요. **기존 앱 삭제/데이터 지우기 금지**.

## A. 1분 초간단 스모크 테스트 — 사용자가 지금 할 수 있는 유일한 필수 작업

1. MOA의 일기/갤러리에서 **네이버 지도 핀이 보이는** GPS 사진 한 장을 열고 사진이 몇 번째인지 기억한다.
2. 사진 상단 지도 핀 → **네이버 지도**로 이동한다. 실제 위치가 맞는지 보고, 네이버 내부 장소 화면이나 다른 화면을 한 번만 더 연다.
3. 휴대폰 시스템 뒤로가기를 여러 번 누를 필요가 있는지 기록한다. 네이버 내부 화면에서 빠져나오는 횟수와 **MOA로 돌아온 후 같은 사진인지**를 구분한다.
4. 여러 번 눌러야 한다면, 그 대신 **최근 앱(Recents)**에서 MOA를 탭하여 사진이 그대로인지도 한 번 확인한다.
5. 결과는 한 문장만 보내도 된다: `R227 / 네이버 뒤로가기 N번 / MOA 복귀=같은사진 or 일기화면 / 최근 앱 MOA=같은사진 or 일기화면`.

**첫 번째 스모크 결과 없이 R229+ 네이버 복귀 코드를 덧칠하지 않는다.** 이미 R227의 `nmap://place`, `r227ExternalMapPending`, `r227RetainForExternalMap`, `r227ResumeFromExternalMap` 로직이 존재한다.

## B. 이후 상세 매트릭스 (assistant가 다음 빌드 QA에 재사용)

| Case | 진입·작업 | 기대 | 현재 |
|---|---|---|---|
| N1 | 일기 → GPS 사진A → 네이버 핀 → 바로 시스템 Back | MOA 동일 사진 A/하단 레일 상태 | PENDING |
| N2 | 일기 → 사진A → 네이버 내부 장소 2단계 → 돌아오기 | 수차례 NAVER 내부 뒤로가기의 문제를 기록; MOA 전면 복귀 뒤 동일 사진 | PENDING |
| N3 | N2에서 Recents → MOA 직접 탭 | Naver Back 반복 없이 MOA 동일 사진 | PENDING |
| N4 | 나의 지도(사진 팝업 OFF) → 네이티브 갤러리 → NAVER → 복귀 | 원하지 않는 사진시트 없이 동일 미디어 | PENDING |
| N5 | 사진B/비디오C, 다른 레일 인덱스 → NAVER → 복귀 | 같은 ID/인덱스·비디오 재생 상태 보존 | PENDING |
| N6 | EXIF GPS 존재/없음 각각 | GPS 있으면 정확한 좌표, 없으면 안내; 인접 사진 좌표 허위 이식 금지 | PENDING |
| N7 | 선택 비디오 필름스트립 확장/드래그/축소, 큰 사진 스와이프 | R227 전체 폭 비디오, R203 위 1장, 아래 관성, 음성/캡처/뮤트 유지 | PENDING |
| N8 | 지도 실행 뒤 앱이 백그라운드 종료되거나 장시간 경과 | 프로세스 재생성 시 복구 정책 별도 확인; R227 메모리 상태 유지 한계 기록 | PENDING |
| N9 | Android Back/Home 시 일기 M4A 재생 종료, 바로기록 크기 | 기존 R219/R221 정상 기능 훼손 없음 | PENDING |
| N10 | NAVER 앱 미설치/권한 거부 | HTTPS fallback/명확한 안내, 크래시·데이터 유실 없음 | PENDING |

## C. R227 정적 근거 및 개발 분기

- R227 GitHub source `experiments/moa-r175/MoaNativeGallery.java` (branch `feature/moa-r227-gallery-nav-return-original-gps-expanded-video-20261109`): `r225OpenNaver()` sets flag; `r227RetainForExternalMap()` returns true only when gallery open and external map pending; `r227ResumeFromExternalMap()` resets flag & preserves view.
- Exact source patch `experiments/moa-r227/patches/MoaMomentAudioHostActivity.smali.patch` guards old Activity `onPause()` close and calls resume handler in `onResume()`.
- Exact frozen APK `classes6.dex`: these method names, native scheme, Naver package reference all present; APK ZIP CRC and SHA match Golden. This proves code presence, **not mobile flow PASS**.
- PASS N1-N4: release no redundant APK; move to local places P2.
- FAIL N1-N4 because Naver inner stack: consider **user-triggered one-action return shortcut**; do not promise overriding Naver's Back behavior.
- FAIL same selected photo when MOA foreground: diagnose Activity recreation/Gallery close/order, fix minimal host, same original signer; actual signed APK + byte-identical ZIP after build.
- FILE EVIDENCE: Screen recording if convenient; no personal photo/location should enter public GitHub.