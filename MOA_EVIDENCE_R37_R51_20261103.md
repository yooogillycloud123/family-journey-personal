# 모아 R37~R51 — 업로드된 APK 실제 코드·서명 비교
2026-11-03 작성. **정적 분석과 사용자 스크린샷에 의한 관찰을 구분한다.** 이것은 정상 작동이 입증된 Android 실기기 테스트 결과가 아니다.

## 근거 자료
- 사용자 실물 `MOA_R37_PhotoCalendar_ColdStart_Install.apk`, `MOA_R41_Moment_Diary_Camera_Return_BETA.apk`, `MOA_R42_Moment_Timeline_Memo_Voice_Compat_BETA.apk`, `MOA_R44_NATIVE_CAMERA_MOMENT_TEST.apk`, `MOA_R45_재첨부_실제APK_20261102.apk`, `MOA_R47_삼성카메라_촬영즉시기록.apk`, `MOA_R49_NATIVE_WEBVIEW_BRIDGE_FIX.apk`, `MOA_R50_삼성카메라_직접연결_실험APK.apk`. 이전 작업공간에는 R38·R51 등과 확인 보고서도 있었다.
- 주요 분석 대상: APK `assets/web/family-diary.js`, `assets/web/index.html`, `assets/web/app.js`, `AndroidManifest.xml`, classes*.dex, APK v2 서명 인증서.
- 당시 로컬 실측 도구 `MOA_version_regression_tests.py`의 정적 체크 9개 PASS. **새 채팅에서 해당 실물 파일·검증자료가 실제 보이는지 먼저 재확인**.

## 범위별 확인 (정적 증거)
| 버전 | 정적 기능 및 문제 | 검증 한계 |
|---|---|---|
| R37 | IndexedDB `familyjourney-diary-v1`, 자동/선택 일기 `entries`/`curated`, `photoIds`, 사진·영상 선택 및 달력. 신규 삼성 카메라 촬영 자동 감지 없음 | 이 APK를 현재 사용 중인 앱이라고 단정 불가 |
| R41 | 화면/카메라 귀환 후 신규 사진 탐색 및 선택 일기 연결 `mmHandleIndex/mmFlush/mmPersist`, 순간 기록 모드 복원 | 카메라 위 실시간 팝업 아님 |
| R42 | 사진+영상 감지 `[...nextPhotos,...nextVideos]`, 촬영 시간대 메모 `mmGroupNotes(entry,g,section)`, Web Speech `mmVoiceToTextarea` | 음성 `not-allowed` 사용자 보고; 모든 상황 정상 동작 PASS 아님 |
| R44 | `mmEnabled=false;mmArmedAt=0` 및 `mmToggle()` 조기 `return`; 기존 R42 귀환 기록 경로를 네이티브 준비 전 제거 | **명시적 기능 퇴행 확인** |
| R45 | R44 일기 JavaScript와 바이트 동일, 패키지/서명 변경 | 데이터 자동 인계되지 않음 |
| R47~R49 | 네이티브/JS 브리지 `MoaMomentNative`를 필요로 함; 사용자 화면에서 연결 실패 | 실제 Java·WebView 런타임 예외는 미확정 |
| R50 | `MoaR50Bridge`라는 다른 런처 클래스 변경; 사용자 설치 오류·수정 후 즉시 종료 | DEX 검증 PASS는 Activity 실행 PASS 아님 |
| R51 | 원래 `HostActivity` 복귀했으나 별도 패키지, 사용자 사진에서 기존 일기 탭 누락 | 원본 앱 데이터가 삭제됐다는 증거는 없음 |

## R42→R44 기능 퇴행의 재현 근거
```javascript
// R42: 원래 기능, 사용자가 켜 둔 상태 복원
mmEnabled=mode.enabled===true; mmArmedAt=Number(mode.armedAt)||0;
// R42: 사용자가 켜고 끌 수 있음
function mmToggle(){mmEnabled=!mmEnabled; /* ... */ }
// R42: 촬영 후 새 미디어 감지와 기존 시간대 메모 연결
// mmHandleIndex, mmFlush, mmPersist, mmGroupNotes(entry,g,section)
```
```javascript
// R44: 기존 동작을 끔
mmEnabled=false;mmArmedAt=0; // foreground native camera watcher replaces ...
function mmToggle(){
  status('모아 기록은 휴대폰 빠른 설정창에서 켜거나 끌 수 있습니다.');
  return; // 기존 카메라 귀환 후 기록 모드는 실행되지 않음
}
```
R44 이후 네이티브 감지가 실패해도 R42 폴백이 실행되지 않는 구조는 원천적으로 위험하다. **R42 코드를 단순히 APK에 복붙하는 것도 데이터 연속성/서명/동시 이벤트 검증 없이는 안전한 통합이라고 할 수 없다.**

## 고정할 실제 파일 SHA-256 (APK 전체)
- R37: `49a06e88a95195db8a14cd3cd703e3540f0b5925c626c9c267b5f2f248b66eba`
- R41: `942b023a51366b132eddd8df457cc2dc497454eaec31bd85ac2029eb225a3fd4`
- R42: `40835356c6c7f4bdbfaf3f07763f99e49fc817dfd9dbd2ba28e2a4094b19cba1`
- R44: `8689f53dcac5c2361ca44e147ff2a11e04863d60febb5ff2cfa6ee30d8f79cde`
- R45: `9f9343f985e343f8650bfd08ac5317ca12c95760d03fc6f20a48f54bf00f961f`
- R47: `2d3b5839c41534932ec38a7afc269bda5258896a2cc7cc227a5232b4f4055315`
- R49: `b09e9a90b31a5d59d02602619e9d585ecc4dfc1473099aff15835dbfc82cd489`
- R50: `e69791de6d756d4ace48c03facc7e9bbea16e09398b20eb95a8a48d4087bad48`
- R51: `f42c4e7984913bb60b63ebf73382f412c95ab12440cb5eff778923b22be79e51`
- R42 `assets/web/family-diary.js`: `9919553479b77ab01a60051074796d1f4865fb284f310982e153864fa7b639da`.

## 패키지·서명 비교
R37=`com.juhyeon.familyjourne8`; R41/R42/R44=`com.juhyeon.familyjournea`(같은 인증서); R45/R47=`com.juhyeon.familyjourneb`; R49=`com.juhyeon.familyjournec`; R50/R51=`com.juhyeon.familyjournef`. 지문은 [READ FIRST](MOA_ABSOLUTE_READ_FIRST_20261103.md) 참고. 개인 서명키 없이 같은 앱 업데이트를 보장할 수 없다. 설치된 원래 모아의 정확한 패키지/서명 미확정.

## 증거 수준
- **확정:** APK 파일/해시/JavaScript 분기/패키지/인증서 차이.
- **사용자 기기 관찰:** 브리지 오류, R50 즉시 종료, R51 일기 화면 퇴행, 음성 `not-allowed`.
- **미확정:** 왜 브리지 객체가 없었는지의 정확한 Android 예외; 원래 설치된 모아의 앱 ID·원본 서명키 확보 여부; 통합된 최종 APK의 실기기 정상 동작.
- **결론:** R42를 *기능 회복 기준*으로, 기존 사용자 설치 모아를 *데이터 보호 기준*으로 분리하여 새 기능을 덧붙여야 한다.
