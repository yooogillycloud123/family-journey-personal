> **2026-11-26 사용자 영구 필수 지침 — 모든 MOA 설치용 업데이트는 GitHub 인앱 배포까지 검증해야 완료.** [MOA 인앱 업데이트 영구 배포 Gate](MOA_PERMANENT_INAPP_UPDATE_RELEASE_GATE_20261126.md)를 먼저 읽는다. 기존 moa-update-channel/android/latest.json + 정확한 서명 APK를 원자적 활성화하고 CI SUCCESS/manifest/실제 APK hash 확인. 복구 APK는 자동 최신으로 올리지 않는다. R727은 실기기 미검증 베타이며 R707 Golden 원본은 변경 금지. APK만 제공한 뒤 사용자가 R725 최신 표시에 막히는 오류 재발 금지.

# 모아(MOA) R707 사용자 지정 Golden — 동결·복구·새 채팅 인계 (2026-11-21)

## 0. 이 문서의 지위

2026-11-21 사용자가 명시적으로 **"골든으로 저장 제대로 새채팅 프롬포트등 지침등 기재해놓고"**라고 지시하였다. 이에 따라 **정확한 R707 원본 서명 APK 바이트를 사용자 지정 최신 Golden 기준본으로 영구 동결**한다.

**중요한 증거 범위:** 여기서 Golden은 **사용자가 보존을 승인/요구한 기준본**을 뜻한다. 사용자가 이 턴에서 Galaxy S26 Ultra에 설치하여 모든 기능을 검증했다는 증거는 없다. 그러므로 `USER_DESIGNATED_GOLDEN / STATIC_VERIFIED / PHYSICAL_QA_NOT_DOCUMENTED`로 반드시 구분하고, 실기기 PASS를 만들어 내거나 기록하지 말라. 구버전의 사용자 실기기 검증 Golden(R683 등)은 독립적인 역사적 기준으로 그대로 보존한다.

## 1. 변경 불가 원본 바이트와 서명

| 구분 | 파일 | 버전 코드 | 바이트 | SHA-256 |
|---|---|---:|---:|---|
| **GOLDEN LOCK (불변)** | `MOA_R707_R705_MAP_GALLERY_FIRST_LAST_REAL_VERSION_ORIGINAL_SIGNED_BETA.apk` | **707** | **9,823,805** | `b72856150410491b87cd01c3ecbe1a3178e2d1a6488fdf4494d06afcf50fb200` |
| 복구용: **R705 기능** | `MOA_R708_EXACT_R705_FUNCTIONAL_ORIGINAL_SIGNED_RECOVERY.apk` | 708 | 9,820,725 | `cb85d0cffb721d4a937960964ea638d4f98b7b6d0cc3519909ba91b33e565c15` |
| Golden 계보 입력 | `MOA_R705_R703_GALLERY_FIRST_LAST_ORIGINAL_SIGNED_BETA.apk` | 705 | 9,823,782 | `97001d02495cf8c9c01597bcc30be59bf933a97d4b9f0c360397631fd7dc52ae` |
| 전체 원본소스/검증 증거 | `MOA_R707_R708_ORIGINAL_SIGNED_MAP_GALLERY_SOURCE_QA_20261121.zip` | - | 21,815,169 | `9f772a52617aa28e25a3b0693303c9ff0000ce4c28610866817e2e518a9a103a` |

공통 패키지 `com.juhyeon.familyjournea`; 원본 서명 인증서 SHA-256 `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`.

개인 Library의 **불변 Golden 복사본**: `/모아_프로젝트_근거_20261103/GOLDEN_R707_USER_DESIGNATED_STATIC_VERIFIED_20261121/`. 기존 배포 원본은 `/모아_프로젝트_근거_20261103/R707_R708_MAP_GALLERY_SOURCE_QA_20261121/`에 별도 유지한다. 기존 모든 Golden 및 원본 APK는 덮어쓰지 않는다.

## 2. 정확한 기능 기준

- R703의 삼성 OneUI 실제 미디어 음량 연동, 0 음량의 음소거 아이콘 표시, MediaStore/GPS 사진 자동 세계지도 갱신, 가족 일기·달력·지도·네이버 데이터 보존.
- R705 PHOTO/DETAIL **전체화면**에서 첫 사진/마지막 사진 버튼을 통한 기존 네이티브 갤러리 인덱스 즉시 이동. PHOTO 인라인 9개·PHOTO ADD 4개 아이콘 보존.
- R707 **나의 지도** 전체화면에도 첫·마지막 이동 버튼; 지도 사진 10,000장 창 경계 간 이동을 위해 실제 R705 APK `assets/web/app.js`에 추가한 `window.__moaR707MapGallery` WebView JS 어댑터 동작(지도 순서 및 미디어 ID 정규화/토큰 유효성 보존).
- 기존 아이콘 순서 설정은 PHOTO/DETAIL 전체화면 8개, 지도 전체화면 6개, PHOTO 인라인 9개, 선택갤러리 4개. 각 프로필 독립 저장.
- 실제 PackageManager 버전 코드 확인을 통한 설정의 앱 버전 표시. 주의: Manifest `versionName`은 역사적 `MOA-R701-MEDIA-BETA1` 문자열이 남아 있지만 **실제 설치 판별은 versionCode 707**이다.

`classes6.dex` 기존 네이티브 갤러리 렌더러/영상 엔진, `classes18.dex` PHOTO 호스트, `assets/web/native.js`, 일기/네이버/음량/GPS 자산은 원본 기준과 바이트 단위로 동일하다.

## 3. 정적 검증 사실 — 재실행 확인

- SDK 35 GitHub Actions R707 Java→DEX17/DEX19 컴파일 **SUCCESS**, run `44859057941`, branch `feature/moa-r707-map-gallery-installed-version-20261121`, commit `d3a5668b58574d1e68a702f2a1d820edfcdbb0a0`.
- 2026-11-21 보존 직전 로컬에서 **R707 및 R708 원본 파일을 다시 읽어 SHA-256, APK Signature Scheme v2 RSA 서명 + 전체 콘텐츠 다이제스트, 원본 인증서, ZIP CRC, 19 DEX SHA-1/Adler32 검사 모두 PASS**.
- R707 vs 실제 R705: **163/167** ZIP 엔트리 바이트 그대로. 변경 4개만 `AndroidManifest.xml`, `classes17.dex`, `classes19.dex`, `assets/web/app.js`.
- R708 vs R705: **166/167** 그대로, 오직 `AndroidManifest.xml` versionCode만 변함.
- 10,001개 혼합 미디어를 대상으로 지도 window-boundary/토큰 격리 Node 단위 테스트는 QA ZIP 내 PASS 자료에 있음.
- **아직 기록되지 않은 것:** Galaxy S26 Ultra 사용자 실기기 R707 설치/지도 이동/영상/썸네일/음량/GPS/Naver/데이터 보존 전체 PASS. 정적 검증이 실기기 성공을 대체하지 않음.

## 4. 복구 기준과 차기 버전 규칙

**R708은 정확한 R705 기능 복구본이다. R707 기능을 완전 복구하는 Golden 롤백 APK가 아니다.** R708 설치 시 R707에서 추가한 나의 지도 갤러리 끝점 이동 및 실제 버전 읽기 변경이 빠진다. 대신 기존 R705의 PHOTO/DETAIL 전체화면 버튼은 그대로 유지된다.

- R707 설치 후 문제가 있다면 **삭제/데이터 초기화 없이** R708로 업데이트 복구 가능(708 > 707).
- R708 설치 후 R707을 다시 설치하는 것은 버전코드가 낮아 일반 업데이트로 불가능.
- **다음 기능 업데이트는 반드시 versionCode ≥709**, 동시에 **동일 서명 versionCode ≥710의 R707 기능 정확 복구 APK**를 제작하고 정적 검증까지 마친 다음 실기기 제공한다. 새 버전이 더 올라가면 각각의 코드도 상향한다.
- 기존 R707 Golden 바이너리를 in-place 덮어쓰기·재서명·버전 변경·코드 수정하지 않는다. 필요하면 새로운 브랜치/새 APK에서만 작업한다.
- 원본 서명키는 PRIVATE Library `/모아_프로젝트_근거_20261103/PRIVATE_SIGNERS/MOA_R39_SIGNING_BACKUP_PRIVATE_KEEP.zip` 및 비공개 registry에 보관. **절대 GitHub/Actions/QA ZIP/새 채팅 프롬프트에 개인키나 비밀번호 원문을 공개하지 말라.**
- 갤러리 `classes6.dex`, PHOTO 호스트 `classes18.dex`, R703 지도 자동 갱신, OneUI 음량/음소거, 썸네일 및 삭제/대표사진, 네이버/일기 데이터는 성공 기능 동결 대상.
- 앱 uninstall, app data reset, Photos/MediaStore 삭제, 디버깅 토큰/로그인 삭제, 기존 Golden 덮어쓰기 금지.

## 5. 이후 새 채팅/개발 지침 — 우선순위

1. GitHub `yooogillycloud123/workexcel-devbridge@main/AA_AirPods_FINAL_READ_FIRST_v1.0_20261005.md` 전체 확인(별도 AA 프로젝트 자체는 건드리지 말 것).
2. GitHub `yooogillycloud123/family-journey-personal@main/MOA_READ_FIRST_NEW_CHAT.md` 첫머리에서 **최신 R707 Golden 잠금** 먼저 확인.
3. **이 파일** `MOA_R707_GOLDEN_LOCK_AND_NEW_CHAT_20261121.md` 전체 확인.
4. `MOA_R707_R708_ORIGINAL_SIGNED_MAP_GALLERY_RELEASE_HANDOFF_20261121.md`의 R707 기초 소스·정적 QA 확인.
5. 개인 Library Golden 폴더의 파일이 그대로 있고 실제 SHA가 표와 일치하는지 확인. ZIP 내 원본 소스(`SOURCE/app_r707.js`)·변경 diff·CI·QA를 함께 읽는다.
6. 사용자가 새 기능을 요구하지 않았다면 **Golden을 수정/재빌드/재배포하지 않는다**. 요청이 있다면 기존 APK와 소스에서 출발하여 변경 최소화 + version 709+/710+ 복구 세트 + 실제 APK 사용자 전달.
7. **사용자가 요청한 실행 APK는 일반 채팅 도구로도 제작한다. Work 모드는 필수 사항이 아니다.** 실행 환경 장애가 재발하면 다른 가용 로컬 실행 도구로 전환한 뒤 이어서 진행한다. DEX/ZIP만을 APK라 주장하거나, 이전 자료를 반복 요구하지 말라.
8. R707의 실기기 성공 보고가 나올 때까지 `PHYSICAL_QA_NOT_DOCUMENTED` 상태 그대로 유지한다. 사용자의 실제 체크 결과가 오면 명시적 증거와 함께 별도 append-only 기록한다.

## 6. 나중에 확인할 테스트 항목

- PHOTO/DETAIL 전체화면 각각 첫/마지막 버튼; 순서 저장, 수천장, 영상 포함, 썸네일 일치.
- 나의 지도에서 국내/해외 사진과 10,000장 창 경계를 넘는 첫/마지막 이동.
- 설정의 실제 설치 버전 `R707`, 기존 음량/음소거/영상 재생, GPS 새 사진 자동 반영, 일기/사진 데이터, 네이버 쿠키/저장 기능.
- 위 항목의 실제 성공은 사용자가 기기에서 확인한 후에만 실기기 PASS로 기록한다.

**권위 있는 기술 인계:** https://github.com/yooogillycloud123/family-journey-personal/blob/main/MOA_R707_R708_ORIGINAL_SIGNED_MAP_GALLERY_RELEASE_HANDOFF_20261121.md