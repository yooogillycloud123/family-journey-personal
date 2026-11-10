# MOA R301 — NAVER '내 장소' 목록 중복 생성 사고 원인·안전 보수·동일 목록 ID 관문 (2026-11-11)

## 실제 사용자 증거 (개인 미디어는 저장소에 넣지 않음)
- 사용자 제공 private `20234.png`, `20236.png`, `20233.mp4` (92s), `20238.mp4` (42s): 계정의 네이버 공식 '저장' 아래 내 장소와 비슷한 이름의 빈 목록이 많이 보이고, **원래 '내 장소'에는 185개 장소, 여러 다른 동명 목록에는 0개**가 표시됨. 필터 '내가 만든 리스트 68'은 모든 리스트를 포함하므로 68개가 전부 자동 생성된 목록이라고 단정하지 않음.
- 비점유 처리 UI에서 `LIST_CREATE_FAILED` 관측. 사용자 본인은 새 목록을 반복 생성하라고 요청하지 않았고 기존 보이는 저장도 정상. 생성된 각 폴더의 생성 시간·계정 변경 이력이 없으므로 **모든 빈 목록의 직접 작성 주체는 미확정**.
- 비공개 사진·동영상·GPS·계정/메모·영수증/비밀번호는 GitHub에 절대 업로드하지 않음.

## R297 실제 소스에서 확인된 결정적 3가지 설계 결함
- `assets/web/moa-r231-naver-frame-probe.js` 187~203줄의 `list()`: 오래된 `button[class*="_list_item_"]`에서 일치 행이 없으면, 진짜 이미 기존 목록이 있어도 **'새 리스트 만들기'를 찾고 `create.click()` → 이름 입력 → 완료 버튼 클릭**을 자동 수행. 정확한 folder/shareId 사전 확인이나 한 번만 생성하는 idempotency가 없음.
- 부모 `tick()`은 LIST 상태에서 최대 35×550ms 동안 자식 iframe에 동일 명령을 반복 전송하고, 3.6초 주기로 또 tick. 자식 `working`이 실패 후 false로 돌아오면 같은 LIST 작업을 재실행할 수 있음.
- `fail(status)`가 보고만 하고 `task`/상위 `sessionStorage`를 제거하지 않아 오류·화면 재이동 뒤에도 반복 실행될 수 있음. 이 3가지 결함은 **실제 원본 JS에서 증명됐으며**, 사용자의 0개 동명 목록 생성 현상과 강하게 일치한다.

## 이전 PC 성공 코드 비교
- 사용자는 다른 대화에서 PC 주소 검색→네이버지도 즐겨찾기·리스트·별명·메모 저장을 실제 성공했다고 명시했고, 그때의 Python 산출물 이름으로 `주소지자동저장 파이썬.zip`, `출장지(초고속버전+자동로그인+구동버전+최고버전).py`, `사진지도부동산_ONEQUEUE.py` 등이 기록됨. **이번 턴의 Files/Library·GitHub 코드 검색으로 해당 정확한 실행 원본을 회수하지 못했으므로 그대로 복사·대조했다고 주장 금지.**
- 별도 실증 자료 `feature/moa-r235-naver-background-real-favorites-engine-20261110/experiments/moa-naver-background-r1/README_KO.md`: PC Playwright/FastAPI/SQLite 연구 엔진이 **UUID 중복 방지, QUEUED→WORKING→독립 NAVER_READBACK_VERIFIED**를 사용하나, 자체 문서상 실제 계정 저장은 미검증 및 PC 의존. 현재 Android 단독 최종 완성본과 동일시 금지.
- 재사용할 원칙: **기존 목록을 먼저 고유 folder/shareId로 확인 → 사용자 승인 및 작업 ID 한 번만 집행 → 확인된 하나의 장소만 저장 → 동일 folderId/장소/메모/별명 독립 조회.** 목록을 못 찾으면 새로 만들기 금지.

## R301 보수 범위 / 실제 파일
- Private-local signed `MOA_R301_NO_DUPLICATE_LISTS_SAFE_BETA.apk`: package `com.juhyeon.familyjournea`, versionCode **301**, bytes **8,883,188**, SHA256 `a86602f99f7b997268b66dbf6ab48ffddafbc85017b11f370d127ec909c2430e`, same original cert SHA256 `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`.
- **R297와 변경된 non-signature APK member는 정확히 3개**: binary `AndroidManifest.xml` code297→301, `assets/web/moa-r231-naver-frame-probe.js`, `assets/web/fj-naver-favorites.js`. **16개 DEX와 다른 앱 엔트리 바이트 동일**, 정상 R283 실제 모바일 네이버 로그인·점유 저장 경로/일기·사진·바로기록은 네이티브 소스 불변.
- 기존 list()에서 `create.click()`, `input.value=task.listName`, 비공개/새 목록 완료 자동 경로 **완전히 제거**. 목록 정확 일치가 하나면 LIST_READY, 2개 이상이면 `LIST_DUPLICATE_NAME`, 없으면 `LIST_NOT_FOUND_NO_CREATE`로 **절대 저장/신설 안 함**.
- 치명 상태 발생 시 새 `STOP` 상태 집합으로 실제 상위 `sessionStorage` 미완료 작업을 제거하고 `task=null`, 단말의 3.6초 반복 타이머로 같은 LIST 작업 재시작하지 않음. 동일 자식 jobId+phase도 중복 처리 억제.
- `fj-naver-favorites.js`가 새 상태를 **오류 종료 메시지로 표시**하고 16초 폴링을 마침. 예전 정상 전경 저장과 로그인을 바꾸지 않음.
- **R303 emergency source-equivalent R283 behavior:** `MOA_R303_RESTORE_R283_LOGIN_AND_VISIBLE_SAVE.apk` version303 8,879,195B SHA256 `abb406ed187bd7d9f7647ca31db7397ad7523df004a859d84e0cfa2915529a22`, R283 대비 오직 binary Manifest code만 변경, 동일 인증서. R269 Golden 바이트 동일 복제품 아니며 실제 복원 설치 QA 미수행.
- QA ZIP `MOA_R301_DUPLICATE_LIST_SAFE_BETA_AND_R303_RECOVERY_20261111.zip` **12,828,447 bytes** SHA256 `b7da1b1dc6c0216db3d447fd884f5e760e7bd42dbdab832fc90f1485c447978b`; 안에 R301/R303 exact same bytes, QA JSON, sanitized source patch, four-case mocked list tests, Korean README. ZIP CRC PASS, original cert/APK v2/zipalign, 16 DEX SHA1/Adler checks, JS Node syntax PASS. Private signer keys/password and personal images excluded.
- Synthetic mock four cases: single 내 장소 185 -> LIST_READY (read-only); 내 장소 185+0+0 -> LIST_DUPLICATE_NAME (no new list); empty list -> LIST_NOT_FOUND_NO_CREATE; unrelated list -> LIST_NOT_FOUND_NO_CREATE; every case **create click count=0**.
- **중요 한계:** R301은 안전 차단 베타이며 이미 **동명 목록이 많기 때문에 사용자 단말의 비점유 저장은 명시적으로 BLOCK**될 수 있다. 실계정 서버 저장·별명/메모·folderId 정확 선택 및 독립 readback은 여전히 OPEN. 이를 90%/FINAL로 표현하지 않음. 이미 생성된 동명 리스트는 **앱이 임의 삭제/일괄 삭제하지 않음**.

## 다음 기술 관문 (명확한 단일 목표)
1. 동일 이름이 여러 개여도 **원본 사용자의 185개짜리 기존 리스트를 실계정 first-party UI에서 folder/shareId로 고유 식별**, MOA 앱의 목록 선택 UI에 사용자 확인 후 보관(이름·개수만으로 write 대상 결정 금지). 이 과정은 읽기 전용이며 개인정보/토큰 GitHub 수집 금지.
2. native in-app WebView 프레임 → 특정 folderId로 정확히 하나의 목록 선택 후 저장 Star, 별명·메모 입력/저장. 선택자·이벤트의 정상 사용자 제스처 여부 검증.
3. 동일 folderId/장소 sid(or strict address)/alias/memo의 **독립 계정 readback** 뒤에만 저장완료. 휴대폰 MOA 화면 유지, 별도 앱/PC/root/Shizuku 없이 최소 1회 실제 Galaxy PASS, 기존 점유 저장 PASS 회귀.
4. 사용자가 이미 작성한 빈 리스트는 별도 정리 가능성만 검토하며, 자동 삭제는 구현/실행 금지.

**Golden protection:** user-designated immutable R269 original APK SHA256 `c0663e65aac2b72feb86cb0f1ba5eac448b6599c3850858de4d942f2aa446920` and R227/AA Goldens untouched. No uninstall, app-data clear, forced downgrade, private key disclosure.
