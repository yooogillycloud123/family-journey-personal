# 모아 새 채팅 재개 — 2026-11-16 R625 / R611 골든

반드시 `yooogillycloud123/workexcel-devbridge/main/AA_AirPods_FINAL_READ_FIRST_v1.0_20261005.md` 전체를 먼저 읽고 `family-journey-personal/main/MOA_READ_FIRST_NEW_CHAT.md`, R611 Golden Lock, R623/R624 handoff, R625/R626 handoff 순으로 확인하라.

최상위 **불변 사용자 실기기 골든 R611**: 네이버 One Hand Operation+ 접근성 OFF/ON 반복에도 Android 원본 갤러리 8기능/필름스트립/영상 유지. R611 원본 APK SHA256 `38a507cf2e88a235282ae4d9ad64cf0799033f34ae8fe3e179a58960d1213ccd`. 골든 원본 절대 수정/삭제 금지.

현재 **R625 설치용 베타**는 R623의 카카오형 선택기 기능 위에 작은 확대 아이콘, 최상단 선택수/안내/일기열기/선택추가 단일 sticky 바, 아래 사진 미가림, 큰 이미지 FAST ON/OFF(하단 rail은 항상 관성), 선택 썸네일 흰 테두리 들뜸, 고해상도 원본 사진 URI + 2048 fallback + 저해상도 덮어쓰기 차단, 동영상 원본 content URI 재생 시도+실측 시간 슬라이더를 추가. R623 대비 Manifest/photo JS/photo CSS만 바뀌고 18 DEX 동일. 원본 R611/네이버/일기/음성/MediaStore 기능은 그대로 보존.

**R625 정적·브라우저·서명 통과, Galaxy 실기기 PENDING**, 특히 content:// 고화질 사진과 영상 seek 동작을 미리 성공이라 단정하지 마. 사용자 실제 재현 순서를 먼저 검증해라.

**R626 복구**는 정확한 R623 기능으로의 상위 버전 복원(Manifest만 변경), 순수 R611 UI는 아님. R626 설치한 경우 다음 code>=627. 앱 삭제/데이터/네이버 쿠키 초기화 금지. AirPods Android Auto 오디오 소스 변경 금지.
