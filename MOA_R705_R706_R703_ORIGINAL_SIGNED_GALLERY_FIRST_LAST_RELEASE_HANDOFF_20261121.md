# 모아 R705 전체화면 첫·마지막 이동 및 R706 R703 기능 복구 배포

2026년 11월 21일 원본 서명 설치 APK 두 개를 제작해 정적 검증을 완료했다. 정상 기능 기준은 사용자가 사용 중인 R703이다. Galaxy S26 Ultra 실제 설치와 화면 동작은 사용자 확인 대기 상태다.

## 배포 파일

개인 보관 위치는 `/모아_프로젝트_근거_20261103/R705_R706_GALLERY_FIRST_LAST_20261121/`이다. QA ZIP에 설치용 두 APK, 두 버전의 정확한 Java 소스, 적용 재현을 검증한 unified diff, 원본 CI ZIP, 멤버별 해시, 도구 로그, 호스트 테스트 결과와 SHA256SUMS.txt를 포함했다.

| 용도 | 파일 | 바이트 | SHA-256 |
| --- | --- | ---: | --- |
| R705 기능 업데이트 | `MOA_R705_R703_GALLERY_FIRST_LAST_ORIGINAL_SIGNED_BETA.apk` | 9823782 | `97001d02495cf8c9c01597bcc30be59bf933a97d4b9f0c360397631fd7dc52ae` |
| R706 R703 기능 복구 | `MOA_R706_EXACT_R703_FUNCTIONAL_ORIGINAL_SIGNED_RECOVERY.apk` | 9819686 | `4fd2fcb356027cd8da0858f7914ecf1524651342c63a6c6aeb9ed61fe5639f29` |
| APK·소스·QA 24개 엔트리 | `MOA_R705_R706_ORIGINAL_SIGNED_GALLERY_FIRST_LAST_SOURCE_QA_20261121.zip` | 14644269 | `a06fecbe2a1a820a50650f98717e74abc447326cbca364fca0b9dadd56c383fc` |

## 입력과 코드 계보

- 실제 R703 APK SHA-256은 `5cd3d68c4485a739869daa8b64152c9945232656a9171365ec2a42442744827b`이다. R703 원본 서명, 167개 엔트리와 모든 ZIP CRC를 먼저 확인했다.
- 기존 [원본 SDK 35 Actions 실행](https://github.com/yooogillycloud123/family-journey-personal/actions/runs/44829536544)의 `MOA-R705-GALLERY-FIRST-LAST-DEX17-SDK35-QA` 아티팩트 ID는 `14675737527`이다. ZIP SHA-256은 `f02c57b314f10dacc5b464ae74a1de149df84d187f973709b98f9f9ed0b8145f`다. 그 안의 103,188바이트 classes17.dex는 서명된 R705 안의 DEX와 바이트 단위로 일치한다. DEX SHA-256은 `1df6dff3ac34c80449bf38271d8f8b5815361cc4603ab4dc2660fc1c182b208b`이다.
- R705 구현 커밋은 `044e4717be0b9f49ed028119fc167a6198e73b45`, 성공한 CI의 HEAD는 `db53a2d109f253212c857bf70d34db0bb1fde394`이다. R703 원본 소스와 R705 CI 소스의 Git blob은 각각 `7d134c2ffb40ef1338c067d049c8506654eb8f9a`, `1af58ae4b0f4dfd3b0fae6944615527946c3a8ec`이다.

## 서명과 APK 비교

두 APK의 패키지는 `com.juhyeon.familyjournea`, 서명 인증서 SHA-256은 `5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15`이다. 기존 개인키를 신뢰 가능한 로컬 환경에서만 사용했다. Android SDK apksigner가 R703, R705, R706의 APK v2 서명을 검증했다. 별도의 검증 코드가 전체 APK 콘텐츠 다이제스트와 RSA 서명을 확인했다.

| 항목 | R705 | R706 |
| --- | --- | --- |
| versionCode | 705 | 706 |
| R703과 다른 파일 | AndroidManifest.xml, classes17.dex | AndroidManifest.xml |
| R703과 같은 로컬 ZIP 헤더 및 압축 전후 데이터 | 165/167 | 166/167 |
| 4바이트 정렬·CRC·DEX 19개 SHA-1/Adler32·SHA-256 | 통과 | 통과 |

두 매니페스트는 오프셋 8216에서 versionCode 값 1바이트만 달라졌고, 설치 권한·컴포넌트·저장소 설정을 포함한 나머지 바이트가 모두 일치한다. Android SDK 파서와 별도 파서로 패키지, 버전 코드, minSdk 29, targetSdk 35를 확인했다. 표시용 versionName은 기존 `MOA-R701-MEDIA-BETA1`이다. ZIP 엔트리 순서는 같고 각 APK의 49개 비압축 엔트리가 SDK zipalign 검사를 통과했다. 갤러리 classes6.dex, PHOTO 호스트 classes18.dex, 모든 웹 자산이 R703과 일치한다. R706은 19개 DEX 전체가 R703과 같다. OneUI 음량 처리·무음 표시, 지도/GPS, 빠른 넘기기, 대표사진·다중 제외 관련 Java 메서드 16개도 원본 소스와 대조했다.

## 갤러리 검증 범위

PHOTO/DETAIL 전체화면에서 첫 항목과 마지막 항목 버튼이 R203의 `r203ReleaseWithVelocity(float,float,float)`를 호출한다. 실제 classes6.dex에서 해당 메서드 시그니처를 확인했다. 전체화면 사용자 순서 레지스트리는 8개, PHOTO 내부는 9개, 별도 사진 추가 갤러리는 4개다.

JVM 호스트 테스트에서 CI 소스의 경계 이동·버튼 상태·순서 복원 메서드를 그대로 추출해 실행했다. 각 전체화면 프로필의 가상 10,000개 항목에서 첫·마지막으로 이동할 때 R203 호출은 각각 한 번이었고 중간 미디어 항목을 읽지 않았다. 각 프로필의 기존 6개 아이콘 순열 720개와 8개 순열 40,320개 전부를 검증했다. 두 버튼의 끝 상태, 빈 목록, 한 장, 범위 밖 인덱스, 다른 프로필도 확인했다. 실제 썸네일 레일·영상 출력·OneUI·새 해외 GPS 사진 반영·사용자 데이터 유지 결과는 Galaxy S26 Ultra 확인 대상이다.

## 업데이트와 복구

현재 앱을 설치한 상태에서 R705를 업데이트 설치한다. 복구가 필요하면 같은 패키지와 서명인 R706을 업데이트 설치해 R703 동작으로 돌아간다. 패키지·인증서·상향 버전 조건을 확인했다. R706 설치 뒤 다음 일반 업데이트는 versionCode 707 이상으로 준비한다. R704는 R701 기능 복구용이다.

[기능 소스와 CI 인계](MOA_R705_R703_NATIVE_GALLERY_FIRST_LAST_SOURCE_ONLY_HANDOFF_20261121.md) · [R703 기준 배포](MOA_R703_R704_ORIGINAL_SIGNED_R701_BASELINE_RELEASE_HANDOFF_20261120.md) · [갤러리 아이콘 원칙](MOA_GALLERY_ACTION_REGISTRY_PERMANENT_RULES_20261117.md)
