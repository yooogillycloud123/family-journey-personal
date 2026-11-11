# MOA R345 Golden — 바로기록 × 사용자 지정 기본 리스트 × 진짜 비점유 유지 UX 설계 (2026-11-11)

**상태: 설계안. 신규 APK 미제작 / 기기 테스트 미실시.** User confirmed R345 existing-list, NEW private list-create+save and both visible/offscreen methods on device. Preserve same-signer R345 SHA256 `fe2aaaac15d39a610268ee3d10361652a95537e0ce8ec9cde86e98edf3f8ceb1` IMMUTABLE; source-only Golden branch `golden/moa-r345-20261111-user-naver-list-visible`; R347 restores R341 and is NOT Golden recovery. Future candidates >=349.

## User correction superseding prior plan
- `내 장소` is only the **first-time fallback default**, never mandatory permanent destination.
- User must be able to **pin any existing NAVER saved list** as global default and persist that choice across new records, app restarts and diary/photo/Quick Record.
- Within an individual record select **another existing list** or explicitly **create a new private list** without silently modifying global default. Offer clear optional `이 리스트를 앞으로 기본값으로` for user's explicit change. List name alone is not identity, use unique list/folder/shareId verified against account; duplicate names and missing selected ID fail closed, never silently fallback to '내 장소' or create duplicates.
- User explicitly wants checkbox ON for Quick Record candidate and base mode `비점유` in this scenario. Settings may specify whether future new records start checked, but per-record check remains independently controllable.
- **STRICT UX:** WebView must not spontaneously become visible during offscreen save, including session startup/restart/auth expiry/config change. Only a real user action `네이버 웹 화면 열기` may show it. Saving must not steal MOA foreground or scroll/focus.

## R345 source evidence — actual reasons for occasional visible PC page
APK-extracted exact code in frozen branch:
- `assets/web/fj-naver-favorites.js`, function `tryR289Offscreen`: if `!probe.running` it directly calls `naverWebProbeControl('visible')` and returns WEB_LOGIN_REQUIRED. This means a save request can **explicitly open visible web UI** after the probe is disposed/not started.
- If `probe.running && !probe.hidden`, it calls `naverWebProbeControl('hidden')`, polls `naverWebProbeStatus`, then resumes the same job. There is an observable **visible→hide transition**, not a stable hidden-only policy.
- `assets/web/moa-r231-settings.js`: experimental manual buttons `네이버 PC 지도 열기` (`visible`), `지도 웹창 뒤로 보내기` (`hidden`), and `웹창 종료` (`stop`). Hence manual run-state and desired mode are currently mixed in UI.
- `assets/web/fj-naver-favorites.js` function `startNativeSave` list decision: `const list=String(old.list||preferred)...`, with `preferred=localStorage.getItem('fj.naver.targetlist')||'내 장소'`. For **preexisting photo state**, old.list silently outranks newly changed global preference. Distinguish deliberate record-specific override from stale inherited value; never rebind old saved records without consent.
- Android official WebView guidance: configuration changes can recreate WebView and lose ephemeral page state; minimize recreation and use lifecycle save/restore carefully; `pauseTimers()` applies globally to all WebViews and may suspend required JS, so do not use casually. [Android WebView state](https://developer.android.com/develop/adaptive-apps/cookbook/webview-state), [WebView reference](https://developer.android.com/reference/android/webkit/WebView).
- **NOT PROVEN:** the precise trigger of each observed reappearance (native `visible` request vs Activity recreation vs WebView renderer restart / z-order) requires R345 native lifecycle event trace. Source proves a visible-opening route exists, not the complete runtime chronology.

## Proposed architecture: desired policy independent of live WebView
- Persistent `NaverSavePreferences` local-only: `defaultMode='OFFSCREEN'`, `defaultFolder={id,name,accountScope,validatedAt}` initially unset→'내 장소' fallback only, `quickRecordDefaultChecked` user-controlled, `noticeEnabled`.
- Immutable job snapshot `SaveDraft`: `recordId`, `photoId?`, precise `address` and location consent, `alias` ≤25, `memo` ≤400 (R345 submit cap), `selectedFolderId?`, `listName`, `explicitNewList`, `mode`, `idempotencyKey`, `source='quick_record'`.
- Effective folder priority for NEW record: `explicit record choice` > `user-pinned global default folder ID` > `내 장소` first-use fallback. For EXISTING record, an explicitly saved record override stays unless the user actively resets to app default; do not misuse legacy `old.list` as an implicit override.
- Native `WebSessionCoordinator` owns one attached full-size-layout but non-focusing WebView behind MOA (R345 known success shape), not an independent WebView per Quick Record. **desiredMode=OFFSCREEN** persists even when runtime probe disappears. Native reattach/load must apply nonvisible hierarchy/z-order **before** navigation; hold MOA foreground throughout; no `bringToFront` on worker path.
- State flow: `STOPPED → STARTING_HIDDEN → READY_HIDDEN → SAVING_HIDDEN → VERIFYING_HIDDEN → READY_HIDDEN`. On expired login `AUTH_REQUIRED`, browser/renderer lost `RECOVERY_NEEDED`, invalid DOM `UI_CHANGED`; all **remain on MOA**. No implicit `visible`. **Only explicit user `네이버 웹 화면 열기` transitions to `VISIBLE_USER_REQUEST`**. If auth needed show unobtrusive banner `네이버 로그인 확인 필요 [웹 화면 열기]`; diary already persisted, job paused safely.
- Never destroy/recreate functioning R345 WebView per individual task, never `pauseTimers` indiscriminately, and don't use 1×1 layout since historical tests showed broken PC DOM. Save transient navigation state on legitimate Activity recreation where safe, but do not promise session survives OS process kill/force stop. Relaunch must verify account state without automatically opening visible page.
- Log sanitized transitions (no account cookies/password/precise address or private photos): `session_started_hidden, native_visible_requested, view_attached, onPause, onResume, onDestroy, renderer_gone, auth_required` and correlation ID. One screenshot flicker test plus event log needed before attributing native root cause.

## Quick Record user flow
UI:
```text
바로기록
[사진·음성·기록내용 — 기존 기능]
[x] 네이버 즐겨찾기에도 저장
    장소           [원본 GPS/주소 확인]
    별명           [사용자 지정]
    네이버 메모     [일기 메모 가져오기] [따로 수정]
    저장 리스트     [기본: 사용자 지정 리스트 ▼] [+ 새 리스트]
    저장 방식       [비점유 기본] [이번 건만 화면 보며]
[일기 저장]
```
1. Save **diary/record locally first** in existing `familyjourney-diary-v1`/native M4A chain, obtain authoritative recordId; never condition diary persistence on NAVER auth.
2. If checkbox ON and location specific, atomically queue a **single** job using existing R345 phone-submit/WebView engine (no new Playwright/duplicate engine) with exact chosen folder and idempotencyKey. Checkbox OFF = original Quick Record behavior with no WebView side effects.
3. Status separately: `일기 저장 완료 · 네이버 대기`, `네이버 저장 중`, `계정 확인 완료` (strict first-party readback only), `로그인 필요`, `위치 확인 필요`, `저장 확인 불가`. No rollback of diary if NAVER fails, no indefinite retries/new folders.
4. If photo GPS missing or destination ambiguous, diary saved and NAVER job `NEEDS_LOCATION`. User may explicitly assign an address. GPS coordinate or MediaStore ID is not a NAVER POI ID.
5. New folder create only after complete authenticated list scan and explicit user intent; creation checked, uniqueness verified, then one commit and first-party account readback. Selected global default only changes when user explicitly chooses `앞으로 기본 저장 리스트로 설정`.
6. Multiple quick records while one browser task is active queue sequentially; never click twice on uncertain commit; preserve local outbox through navigation for permitted lifetime. Do not claim reliable unattended saved-after-force-stop without physical tests.

## Settings IA — production, not testing UI
```text
설정 > 네이버 즐겨찾기
  기본 저장 리스트        [사용자 지정 리스트 ▼]  [기본으로 지정]
  기본 저장 방식          (● 비점유 자동저장  ○ 화면 보며 저장)
  바로기록에서 기본 체크  [ON / OFF]
  연결 상태              [준비됨 / 로그인 확인 필요] [웹 화면 열기]
  저장 알림              [ON / OFF]
  저장 기록              [진행 중 / 저장 확인 / 확인 필요]
  고급                   [웹 연결 진단 · 수동 종료 · 기존 네이버앱 방식]

설정 > 네이버지도 복귀 버튼
  기존 이동·크기·표시 설정 그대로
```
No top-level master OFF duplicating per-record checkbox. `기본 저장 방식` is a **radio/segmented single choice**, not two independent ON/OFF switches. `기본 저장 리스트` is user-pinned rather than silently adopting the last selected list. Show visible browser explicitly only on user tap.

## Testing / release gates
No R345 source mutation. First fork exact R345, original signer, versionCode >=349; backup and R345-functional higher-code recovery before testing. Tests: global pinned folder survives app restart and per-record override; new list creation with explicit default selection; Quick Record checkbox ON/OFF, alias/memo address and diary success independent of NAVER; 2 consecutive offscreen saves without screen flash when session healthy; expired session/renderer restart never steals focus; settings navigation/phone rotation/manual login; 10 sequential saves no duplicate, folder identity verification, voice/M4A/auto-transcription/gallery/return overlay regression zero. Physical device/runtime gates must be distinguished from synthetic unit tests.

**This document is architecture/design only, not a claim of implementing APK or solving unseen native lifecycle events.**
