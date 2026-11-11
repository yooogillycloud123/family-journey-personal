# MOA R369 — R365 실제 Galaxy 영상 검토 후 순간기록 리스트/숨김 세션 재준비 보강 (2026-11-12)

## 실제 사용자 증거: 20596.mp4 (103초) + 20581/20583/20585/1794414841833/1794414888326 이미지
- 영상 약 0~5초: Android 네이티브 `모아 · 순간 기록`, `장소 저장` 체크, 저장 리스트 입력칸에 `잘 봐라 챗지피티`라는 **새 이름을 명시적으로 입력**.
- 약 8초: 원래 일기 저장 완료, 하지만 네이버 자동 저장 성공은 보이지 않음.
- 약 14~25초: 사진 카드의 네이버 저장 리스트 입력칸에는 새 입력값 대신 **이전 `새로운` 계열 값이 유지**. 이전 성공분을 현재 사진의 입력값으로 오인하지 말 것.
- 후반: 사용자가 네이버 PC 웹을 직접 열어 일기/네이버 작업을 진행하는 장면. 사용자 보고는 PC 웹 최초 수동 개방 이전에 이전 사진 비점유 저장이 전혀 진행되지 않는다는 것. **R365 완전 비점유/자동 저장 실패는 실제 사용자 실기기 증거**.

## 코드 확인과 구분한 원인
- R365 `MoaR365CompanionProvider.java`의 `deliver()`는 HostActivity.onActivityResumed() 시점에 시작하고 WebView 초기화 여부를 정해진 횟수만 재시도함. 그 시점이 끝나면 새로운 네이버 비점유 사진 저장 버튼에서는 native hidden-start를 다시 준비할 경로가 약함.
- R365 `findWeb(View)`는 첫 발견 WebView를 반환함. 기존 네이버 WebView와 모아 앱 WebView가 공존할 때 JS 전송 대상이 잘못될 수 있음. 이를 반드시 자체 앱 origin 기준으로 필터링해야 함.
- R365 기존 `fj-naver-favorites.js:diaryDraftForGPS()`는 둥근 GPS 좌표 키에 연결된 이전 `saved.list`를 사용하고, 실제 네이티브 moment의 photoId별 선택 리스트 값을 모름. 그래서 서로 다른 사진의 같은 좌표에 `새로운`이 표시될 수 있음. 사용자 영상은 바로 이 증상을 재현하지만 정확히 어느 시점에 native outbox가 누락됐는지까지는 별도 로그가 필요함.
- R365 네이버 작성 엔진의 기존 `tryR289Offscreen()`이 native `naverWebProbeControl('hidden')`만으로 stopped session을 시작하지 못하는 경우 90회 확인 후 `WEB_HIDDEN_START_UNAVAILABLE`로 종료. 이 오류에서 외부 계정 저장은 시작하지 않았으나 R365 JS `active` latch 때문에 같은 작업의 안전 재시도가 막히는 문제도 있음.

## 서명 완료 산출물 — STATIC/CONTRACT PASS, DEVICE NOT TESTED
- **R369**: `MOA_R369_CAPTURE_LIST_HIDDEN_RETRY_BETA.apk`, versionCode369, 8,948,725 bytes, SHA256 **531c475f97198553555b765d60a089b7d17abade4310c656759058ac04f2f826**.
- **R371**: `MOA_R371_FORWARD_RESTORE_EXACT_R355_GOLDEN.apk`, versionCode371, 8,907,248 bytes, SHA256 **5ed6a361ca9903c1ab9c01c924c36e582416f7cdec0e92ac650f8f03c6f51641**, only Manifest version differs from user-accepted R355 functional Golden. Emergency only.
- Paired release ZIP `MOA_R369_APK_R371_GOLDEN_RECOVERY_SOURCE_QA_20261112.zip`, SHA256 **8a12f74ce484b5800d93246e094fd9a5349435c9bed5392298278a7af92bdfa0**, includes two signed APKs, JS source, Node test, isolated native DEX compiler artifact, QA, Korean instructions, SHA manifest. Available in this turn's verified container.
- **Byte scope R365→R369:** only `AndroidManifest.xml` versionCode, `classes18.dex` (the standalone R365 companion provider only), and `assets/web/moa-r357-quick-bridge.js` changed. Original 17 DEX, entire latest native recorder + Gallery + Voice + original R345 NAVER save writer/frame + family-diary.js + settings remain **byte-identical**.
- Same original certificate SHA256 **5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15**. APK v2 RSA signature + complete signed content SHA256 digest, ZIP CRC/alignment, all 18 DEX integrity PASS.
- GitHub Actions isolated Java/D8 compile run **43062296131 SUCCESS**. JS Node test `R369_CONTRACT_PASS` verified per-photo list prefill and durable record selection even for same GPS, IDB commit before ONE existing NAVER save API call, no repeated write, old media state independence.

## Implementation delta
1. New native companion monitor: as long as MOA original HostActivity is active, re-checks readiness every 3 seconds and retries same existing native controller's `start(Activity)`→`setHidden(Activity,true)` on Android UI thread when the first session is missing. Does not invent a second NAVER WebView/login mechanism. Finds ONLY own local `familyjourney.local`/Android appassets WebView for JS; never injects into NAVER origin.
2. QuickRecord bridge retains `native list` per **exact media ID**, persists only the local saved draft's folder override for Diary field prefill; never uses GPS coordinate alone to identify a capture. On verified native outbox, '잘 봐라 챗지피티' overrides a previous point's '새로운' without changing the first-party account writer.
3. If the existing R361 native writer explicitly fails before account submission with `WEB_HIDDEN_START_UNAVAILABLE` or `WEB_HIDE_NOT_CONFIRMED`, release in-memory active latch and recheck with 5-second backoff; do NOT auto-repeat after any uncertain account submission.

## Outstanding device gates: Do not mark GOLDEN
- Real Galaxy first-frame WebView hidden startup WITHOUT pressing '네이버 PC 지도 열기' — **UNVERIFIED**.
- `모아 · 순간 기록` checked custom list `잘 봐라 챗지피티`, one original Diary save, automatic real first-party account list creation/write/readback **UNVERIFIED**. Source tests only prove function invocation in simulated JS.
- Exact prior native task `r365task:<mediaId>` production persistence and timing, session status and true account response require device observations.
- Never uninstall or wipe data. Update-install R369 over R365. If old native UI, Diary or NAVER known good manual saving regresses, stop and use R371 forward functional R355 restore only as emergency. After R371 any next code must be >371.

## Repositories and originals
- Native source/CI: feature branch `feature/moa-r369-repeat-hidden-list-ack-20261112`, `experiments/moa-r365/MoaR365CompanionProvider.java`, `.github/workflows/moa-r369-native-retry.yml`.
- JS exact bytes + tests: included inside verified release ZIP; private Library small upload blocked by storage quota, **do not claim an upload succeeded**.
- User-verified immutable R345 and R355 remain separate and protected. AA AirPods daemon/audio files untouched.