# MOA R261 — 실제 원인 확인: JavaScript `naverSave` vs Android `naverArm` 불일치 (2026-11-10)

## 사용자의 실제 증거
- 기존 R255는 Galaxy에서 정상 실행됨 — 사용자 직접 확인. **R255 BOOT PASS**, 네이버 즐겨찾기 FAIL.
- R257 실기기 영상 `20083.mp4` / `20090.mp4` 및 사진 `20091.png`, `20093.png`, `20095.png` (개인 데이터이므로 GitHub 업로드 금지): MOA 사진 위치 기록 카드의 `★ 네이버 즐겨찾기 + 메모`에서 리스트/별명/메모를 작성해 `주소로 저장 + 메모`를 누르지만 네이버 앱 저장 동작 없이 "저장 중"으로만 보임. 앱 정상 동작은 유지됨. 일부 영상에서 다른 `네이버지도` 수동 버튼으로 Naver 앱이 열리지만 이는 자동저장 PASS가 아님. R257 '최종' 다운로드 링크가 사용자에게 `Library file not found`로 실패한 기록도 있음.
- 사용자는 정상 동작하던 네이버 접근성 저장 (화면 점유 허용했던 fallback) 복구가 우선이고, 그 위에서 MOA 유지·비점유 기능을 실증하길 요구. 수동 6칸 폼/블랙 오버레이/기능 축소 금지.

## 실제 APK 역분해로 확인한 **결정적 연결 버그**
1. R255 및 R257 서명된 APK의 `assets/web/fj-naver-favorites.js` `sendPreparedLocation()`은 `root.NativeHost.post('naverSave',JSON.stringify(native))`를 호출.
2. 그러나 동일 APK의 `classes2.dex` `HostActivity.handle(String,JSONObject)` 액션 스위치에는 **`naverArm`** (native 저장 작업 등록·접근성 확인·네이버 인텐트 실행)와 **`naverStatus`** (상태 조회)만 있고 **`naverSave` case는 전혀 없음**.
3. 지원되지 않는 액션은 원래 HostActivity switch default `Unsupported original bridge operation: <name>` 로그 후 조용히 종료. 프런트엔드는 bridge 메서드가 예외를 던지지 않았다는 이유로 "NAVER_UI_SAVE_RUNNING"을 띄웠음. 그 결과 **네이버 앱 실행도 작업 등록도 없는데 UI에 저장 중만 표시**, 진행/완료 팝업 없음.
4. 이전 R257 단위 테스트는 잘못된 명령 `naverSave`가 나가는 것을 PASS로 기대했다. 따라서 테스트 PASS가 기능 PASS가 아니었던 것. **기존에 설명했던 R249 armed guard·WAITING_ADDRESS_RESULT은 가능한 후속 관문일 뿐, 이번 '아무 반응 없음'의 선행 원인은 잘못된 명령 자체.**

## 실제 제작한 R261 고정 경로
- **검증된 앱 실행 R255 원본 APK를 기준으로 다시 시작.** 변경된 본문: R255와 비교 `classes2.dex`(오직 HostActivity의 위험한 `MoaNaverAccessibilityCover.begin(Context)` 1명령을 NOP로 변경, 기존 접근성 서비스/HostActivity의 처리 자체는 보존), `assets/web/fj-naver-favorites.js`(실제 액션 `naverArm`, 원본 GPS/주소·리스트·별명·메모·상태 연결 및 잘못된 성공 표시 금지), `assets/web/moa-r231-settings.js`(기존 결과 팝업 ON/OFF), `AndroidManifest.xml`(versionCode255→261) **정확히 네 파일만**. 나머지 APK 132개 비서명 엔트리는 원본 R255와 바이트 일치.
- 이전 R257의 위험한 바뀐 라우터/Dex16은 R261에 포함하지 않음. 원래 성공했다고 했던 nmap://search와 접근성 UI 편집 플로우 그대로 사용. 즉 Naver 앱이 **일시 전경으로 나오는 점유형 복구 방식**, 완전 무점유는 아니며 사용자 목표 변경 아님.
- JS는 NativeHost의 실제 `naverArm` 요청 응답을 확인. 4.5초 안에 Host ACK가 없는 상황에서는 `NATIVE_ACK_MISSING` 오류 표출(앱이 화면에 보일 때); 초기 '저장 중'만 무조건 믿지 않음. Android 반환 `key`를 원래 GPS 사진 카드에 다시 연결하며 UI `VERIFIED`는 서버 readback이 아닌 **`REVIEW`**.
- 사용자의 사진 GPS·주소·기존 별명·메모·리스트 자동 전달, 수동 반복 입력 없음. 필요 시 네이버 앱에서 정확한 주소 결과 선택.
- **Signed R261 APK:** `MOA_R261_NATIVE_NAVER_ARM_RESTORE.apk` SHA256 **`db6d34067a7d2f3b97291ca1746a58c97d71d30f4b3f120cefe7751933a5c9a2`**, bytes **8,928,487**, package `com.juhyeon.familyjournea`, versionCode **261**, original signer cert SHA256 **`5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`**.
- **Backup ZIP:** `MOA_R261_APK_BACKUP_AND_KOREAN_GUIDE.zip`, SHA256 `a076863e8a92f9b61a808059bf480f428cdbea1c501a195f7e6847834a04ffae` (exact signed APK + Korean user guide + QA + hashes), CRC PASS.
- **Boot-safe high-version emergency fallback** `MOA_R263_EMERGENCY_RESTORE_R255_APP.apk`, SHA256 `d35fc402e94155b2d69d3329a98289675ccd86a05831116d7bec1b4bd47ac7e0`; functionally **EXACT R255 original APK bytes for every non-signature payload except versionCode 255→263**. Use only if R261 fails to launch; no data wipe. Previous R259 is lower than R261 so would NOT update-install.
- All original-signer APKv2, exact cert, ZIP CRC, 15-DEX SHA1/Adler32, zipalign, aapt package/version, Node syntax checks PASS. **Node VM bridge contract test actually asserts `naverArm`** rather than wrong naverSave; original photo GPS + address/alias/memo/list and reverseAddress fallback, photo-key remap, native ACK and TIMEOUT asserts PASS. APK files/ZIP/QA/patch-only source are in private Library `/모아_프로젝트_근거_20261103/R261_SUPPORTED_NAVERARM_BRIDGE_REPAIR_20261110/`.
- **Galaxy R261 actual launch, Naver account save/list/memo still UNTESTED.** Browser back and original gallery user-proof remains separate. Never declare actual account success before real account list readback.

## Procedure
Update-install over R255/R257 with original package/signature, no uninstall/clear data. In the original diary/photo position card use the same `★ 네이버 즐겨찾기 + 메모` → `주소로 저장 + 메모`, no new manual tester; Naver should now launch by supported `naverArm` dispatch. If existing Android Accessibility MOA NAVER Save service is off, native Host should prompt. Since this version prioritizes restoring the formerly working fallback, Naver app can be visible temporarily; not yet zero-screen-occupancy. Result popup default ON, Settings > NAVER return > popup OFF. If user confirms Naver save works, separately pursue truly non-occupying MOA UI while retaining this working path as immutable fallback.

## Do not repeat
- Do not replace native action string without cross-checking signed HostActivity switch.
- Do not call `naverSave` and label queued.
- No more static-only PASS relabeled real NAVER account completion.
- Do not patch R255 known boot into unstable R251 unrelated registers.
- Never share family photos/video/GPS/private signer.
