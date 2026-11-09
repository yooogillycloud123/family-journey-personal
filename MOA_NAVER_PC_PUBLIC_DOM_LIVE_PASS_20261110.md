# 2026-11-10 실제 공개 네이버지도 PC Chromium 페이지 접근 실증 — 사용자 로그인 없음

## 실제 GitHub Actions 검증

- Run [42715703388](https://github.com/yooogillycloud123/family-journey-personal/actions/runs/42715703388) **SUCCESS**, Chromium Playwright unauthed actual `https://map.naver.com/p/` load.
- 결과 artifact `MOA-NAVER-PUBLIC-UNAUTH-PC-MAP-ONLY`:
  - `origin = map.naver.com`, `path = /p`
  - `has_navbar_save = true` (실제 페이지 저장 네비게이션 버튼 존재)
  - `has_search_input = true` (실제 PC 지도 검색 입력 존재)
  - `frame_count = 5`
  - `mobile_app_redirect = false`
  - `has_pcmap_frame = false` (검색 UI/장소 선택을 실행하지 않았으므로 search/entry iframe은 이 테스트에서 미확인)
  - `status = PUBLIC_PC_MAP_DOM_PRESENT`
  - `real_account_login = false`, `real_account_favorite_saved = false`, `naver_private_data_read = false`
- 새 P1 게이트: **일반 브라우저에서 공개 네이버지도 PC UI 접근 가능**. MOA 자체 Android WebView R231/R233 FAIL과 명확히 구분.

## 거짓 승격 금지

이 결과는 **계정 즐겨찾기 저장의 성공이 아니다**. 공개 네이버지도 PC 진입, 검색과 저장 버튼 존재만 확인했다. 다음으로 사용자 소유 브라우저 프로필에서 한 번 직접 로그인, 새 리스트 UI 생성, 장소 1건 저장, 목록 readback을 통과해야 진짜 네이버 쓰기 PASS로 판정한다. 저장 버튼 클릭만으로는 PASSED 불가.

## 소스와 보안

- 새 source-only PC worker feature branch `feature/moa-r235-naver-background-real-favorites-engine-20261110`, 6 local Python/Chromium mock tests and Android35 Java compile PASS.
- `experiments/moa-naver-background-r1/ci_public_map_probe.py` and `.github/workflows/moa-naver-public-map-probe.yml` were committed separately, no cookies/user photos/GPS/session tokens/keys.
- 이 증거는 사용자 목표(실 네이버 계정, 화면 점유0, Android 단독/추가 앱 0)를 하향시키지 않는다. PC를 사용해야 한다는 제약이 남아 있고, Android-only embedded browser proof도 별도로 진행해야 한다.