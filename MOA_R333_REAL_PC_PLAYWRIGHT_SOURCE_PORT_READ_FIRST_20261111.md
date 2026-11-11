# MOA R333 — 사용자 실제 PC 네이버지도 자동등록 원본 코드 이식 / R335 복구 인수인계 (2026-11-11)

> **R333 원본 서명 APK·앱 회귀 무결성·58개 단위 테스트 PASS. 그러나 실제 Samsung Galaxy / NAVER 인증 계정의 비점유 저장·신규 리스트 생성·서버 재조회는 아직 물리 PASS 없음.** R325는 사용자가 실제 기기에서 주소 검색만 되고 별표가 눌리지 않아 FAIL 보고했다. 이를 성공으로 격상하지 않는다.

## 사용자 제공 실동작 코드의 출처
사용자가 ZIP `네이버지도_자동등록_20261025_수정판.zip`을 직접 제공. SHA256 `7b82a5494dbba6249dbb34edb9ebb9dcdb0922dd38459c8faa7e3392a244fdd4`; 1,218 ZIP entries CRC PASS, 실제 `소스코드/naver_browser.py`, `matching.py`, `models.py`, `app.py`, `runner.py`, Windows EXE, tests 모두 존재. **EXE는 실행하지 않았다.** 원본 Python 비브라우저 단위 26/26 pytest PASS. 브라우저 fixture E2E는 현 실행 환경 외부 및 localhost 네트워크 ERR_BLOCKED_BY_ADMINISTRATOR 때문에 실행 불가; PASS라고 주장하지 않음. 사용자의 PC 프로그램 실사용 성공 경험이 별도 근거.

### PC 실제 성공 코드와 R333 포팅 지점
| PC 실동작 파이썬 | R333 JS 실제 채택 |
| --- | --- |
| `_select_address_result` **`li[role="option"] .search_result_title`** 정확 주소 결과 **먼저 클릭** | R325/R329의 주소 URL 검색에서 별표까지 진행 못하던 결함 수정 |
| `_address_candidate` **`.address_info_area .address_title`** (often `em`) | 상세 주소·동일 번지 확인 후 다음 ☆ |
| `_open_save` `**.btn_favorite:visible**`, 업체 `#entryIframe` checkbox/button 저장 | 주소 상세 ☆ 1회 클릭; 전역 NAV bar Save 제외 |
| `_save_frame` `.swt-save-modal` main 또는 allowed `pages.map.naver.com/save-pages/` iframe | 같은 네이버 계열 문서의 실제 위젯만 작동 |
| `_metadata_fields` `.swt-save-add-info-btn`, `#swt-save-input-listview-nickname`, `#swt-save-input-listview-memo` | **별명 → 메모** 먼저 입력·값 재확인 |
| `_widget_items` `.swt-save-group-item`, `.swt-save-group-name`, `.swt-save-group-count`, `.swt-save-group-check-area .swt-blind` | **그 다음 마지막에 리스트 선택**, 동명 리스트 복수라면 자동선택 금지 |
| `create_folder` `새 리스트 만들기`, `#swt-save-input-folderview-list`, `input[type=radio][value=private]`, `.swt-complete-btn` | 요청 리스트가 **전체 목록 검증 후에도 없을 때** 비공개 리스트 자동 1회 생성; 재조회 후 이어서 저장 |
| `save` `.swt-save-btn`, `verify_saved`, `verify_folder_rows` | commit 1회, 동일 주소/별명/메모/리스트 계정 readback 전 성공 표시 금지 |

원본 Python `matching.py`의 **도로명 내 숫자와 실제 건물 번호**를 구분하는 규칙, 시도 축약형, 번지 오인 방지 이식. 특히 기존에 단순 정규식이 숫자 길 이름을 잘라버린 문제를 수정. 신규 별도 Node 13개 주소 매칭 case PASS.

### MOA 기존 일기 연동의 실제 범위
- 사용자가 해당 사진의 **즐겨찾기 카드에 직접 입력한** `alias/memo/list`를 우선 사용.
- 값이 없다면 기존 `FamilyJourneyDiary.state.curatedEntries`에서 **정확히 같은 사진 ID와 연결된** `moments[].note`만 메모로 자동 채움. 일기에 사진이 딱 한 장일 때만 그 일기 `title`을 별명·`body`를 메모 fallback으로 사용; 여러 사진 하루 전체 본문을 임의로 사진 하나에 복사 금지.
- 리스트명은 사진별 즐겨찾기에 저장된 `saved.list` 또는 사용자가 직접 정한 `fj.naver.targetlist` 사용. 일반 일기에는 공식적인 네이버 리스트명 필드가 없어서 **없는 리스트명을 추정해서 가져오는 동작은 없음**. 설정값/저장 입력이 없다면 `내 장소` 기본값.
- 리스트명이 실제 NAVER 계정에 없으면 **기존 전체 목록 완전 로드가 확인된 경우에만** 새 비공개 리스트 생성 시도. 동명 중복이거나 불확실하면 fail-closed; 기존 '내 장소' 185개와 동명 0개 리스트 무단 생성·삭제하지 않음.

### 실제 APK 및 검증 상태
- Main **`MOA_R333_PC_PROVEN_SELECTORS_GPS_DIARY_LISTCREATE_BETA.apk`**, versionCode333, **8,906,135B**, SHA256 **`4b1fc71172ee79788a59bb2a126bbd8b215107aa4a45f861ad83efc554f2deaa`**.
- Forward recovery **`MOA_R335_RESTORE_R329_FUNCTIONS_SAME_SIGNER.apk`**, versionCode335, **8,906,799B**, SHA256 **`7aa163b5714328cc88b514769a2dd30fd594ec9f9d729e98c343e839593effb9`**. R329 기능 바이트 identical, manifest code only changed. R335 Galaxy recovery itself untested.
- Package `com.juhyeon.familyjournea`, **original signer certificate** SHA256 **`5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`**, local APKv2 full signature/content digest PASS, ZIP CRC and stored align PASS.
- R329 → R333 **exactly 4 ZIP payload entries changed**: AndroidManifest version + `assets/web/moa-r231-naver-frame-probe.js`, `assets/web/fj-naver-favorites.js`, `assets/web/moa-r231-settings.js`; **16/16 DEX and all other 134 ZIP members byte-identical** (138 total).
- Native script length **21,405 Java chars <24,000** WebProbeHost hard guard. JS syntax PASS.
- **PC original 26/26 pytest + MOA JS 32/32 Node = 58 PASS** (offline/mock tests, NOT actual NAVER account write).
- Full private chat bundle **`MOA_R333_PC_PROVEN_SOURCE_PORT_R335_RECOVERY_QA_20261111.zip`**, size **12,978,647B** SHA256 **`dbf3526b340b2d83453f1a0823638a090d2b253b1f1b25e12782dd769f6bc74a`**, 26 files incl. both signed APKs, sanitized PC Python relevant code, ported JS/diff/build script, tests, full forensic Korean report, SHA manifest. **No actual EXE, private signing key/password, account cookies, addresses/photos**. Original uploaded ZIP private; do not post privately provided Windows sources to public GitHub without explicit approval.

### Remaining blockers (do not pretend success)
**PC Playwright `locator.click()` is user-like browser input whereas Android injected JS `HTMLElement.click()` has untrusted synthesized event**; PC success does not guarantee Android WebView/NAVER acceptance. Real current first-party DOM matching, address star, account login state, lazy-loaded folder creation, offscreen rendering/gesture, authentic commit and account readback are all **GALAXY physical unverified**. Public/localhost Chromium test site was blocked in current container (environment), so browser E2E PASS unavailable.

### Next action
1. User's currently installed code329 or lower → install same-package same-signature code333 **without uninstall or data wipe**.
2. Confirm visible official NAVER PC map login session once; then photo-specific place/folder/alias/memo inputs in MOA; run one photo address save **once**, do not mass-repeat or delete folders.
3. Focus only `search result click→address detail→specific ☆ click→save widget→alias/memo→existing or new private list→commit→readback`. Earlier proved address query transfer PASS, do not restart address discovery.
4. If physical error persists obtain stage-specific status/recording; preserve Golden R269/foreground save/diary/audio and fix one gate, never claim FINAL until real account verification.
5. Original signature and rollback candidate exist; R335 is higher-code function reversion but **physical untested**.

Full forensic report and QA bundled in conversation ZIP; ongoing main WIP and release ledger should link to this handoff.
