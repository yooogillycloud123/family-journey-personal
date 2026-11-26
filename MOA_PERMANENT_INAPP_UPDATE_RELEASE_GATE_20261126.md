# MOA 영구 필수 배포 Gate — 인앱 업데이트 누락 금지 (2026-11-26)

사용자가 2026-11-26 R727 직접 APK만 제공되어 R725에서 "현재 R725 · 최신 배포 버전입니다"라고 표시되는 오류를 지적하고 모든 후속 버전에 인앱 업데이트 배포를 의무화했다. **Golden 보존 규칙과 동일한 필수 단계**이며, 앱 제작 완료와 배포 완료는 별개다.

1. 모든 사용자 설치용 새 MOA APK(버그 수정/베타 포함)는 기존 원본 패키지 com.juhyeon.familyjournea, 원본 signer SHA256 5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15, 증가한 versionCode, 실제 설정 버전 표시를 확인한다. 기존 데이터/Golden 원본/서명키 보존. 서명 개인키 GitHub 금지.
2. 기존 실제 인앱 배포 채널 **moa-update-channel** 의 **android/latest.json** 과 **android/releases/moa-r<code>.apk** 를 사용한다. 새로운 배포 URL을 임의로 발명하지 않는다.
3. 로컬 서명한 정확한 APK를 staging으로 전달하고 GitHub Actions에서 SHA-256, byte length, git blob SHA, APK v2, signer, package, versionCode, ZIP integrity 검증 후 APK와 latest.json을 같은 커밋으로 원자적 활성화한다. 최신 활성 버전보다 낮거나 같은 code로 덮어쓰지 않는다. 실패하면 기존 정상 manifest 유지.
4. 실제 branch HEAD를 다시 읽어 latest.json의 published:true, versionCode, apkUrl, sha256, bytes, signer와 배포 APK tree blob을 확인하고 workflow SUCCESS 확인. APK만 전달하거나 staging commit만 완료한 상태에서 인앱 업데이트 완료라고 말하지 않는다. 사용자에게 설정의 기존 '모아 업데이트' 버튼으로 설치할 수 있게 해야 한다. 자동 설치/OS 확인 강제 우회는 요구가 아니며 Android 설치 승인 유지.
5. 긴급 복구 APK는 높은 code로 별도 보관하되 기본 인앱 최신 채널로 자동 활성화하지 않는다. 명시적 복구 요청 시에만 활성화한다. 베타는 실기기 PASS로 오인하지 않는다. Golden은 사용자가 승인하기 전 승격하지 않는다.
6. 결과 답변에는 인앱 배포 검증 상태, 실제 최신 버전, CI/커밋 근거, 직접 APK 대체 링크(가능할 때), 실기기 미검증을 명시한다. 배포 불가 시 정확한 실패 지점과 아직 Rxxx가 최신임을 공개한다. 새 채팅에서 이 파일을 읽기 전 신규 APK를 배포하지 않는다.
7. R725 실제 오류: 스마트폰 허브 시작 직후 TLS 보안 연결 실패/지문 검증·핸드셰이크 오류. R727 원본 서명 수정 후보 SHA256 133e53c10a6009518349d4dde79467e195444166e8ec9c462e78338415ac80bc, 10697156B, 19 host tests PASS, 실기기 PENDING. R728 exact-R725 recovery SHA256 671ef592285db6b22faf45ffb41f0c77aabcd2136a86cd54589c0c74ecaa50da, 자동 배포 금지. Library /에어팟안드로이드/MOA_R727_R728_20261126/. R727 배포 staging commit 50171f583320f94aa6804c7560cb56d16d8eb0f6; 실제 활성화는 branch/CI 재검증 필요.

## R727 실제 활성화 검증 완료 (2026-11-26)
- CI 45765680087 completed / success: https://github.com/yooogillycloud123/family-journey-personal/actions/runs/45765680087
- 배포 브랜치 HEAD bba3729f9f92366d2d2b9ace62047c2f428de75b, latest.json 실제 versionCode 727 / published true / SHA256 및 bytes 일치.
- 실제 android/releases/moa-r727.apk tree blob 8649d4c37e3536db3f368999db9d0cac1c356cb9, 10697156 bytes 일치. staging 제거 완료. R728 자동 활성화 없음. 기기 내 업데이트 UI 및 동기화 물리 검증은 아직 PENDING.
