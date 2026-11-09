from pathlib import Path
p=Path(__file__).resolve().parents[1]
over=(p/'source/com/juhyeon/familyjourney/MoaNaverReturnOverlay.java').read_text()
web=(p/'source/com/juhyeon/familyjourney/MoaNaverWebProbeController.java').read_text()
s=(p/'assets/web/moa-r231-settings.js').read_text()
assert all(x in over for x in ('moa_naver_return_overlay_v1','settingsJson','updateSettings','sizePct','opacity','restartExpiry','resize'))
assert all(x in web for x in ('visible','hidden','stop','WebProbeHost','onHostResumed','4*60*1000L','getAssets'))
assert all(x in s for x in ('네이버지도 복귀 버튼','바로기록 팝업 설정과 독립','네이버 웹 연결','숨김 진단','naverReturnPrefs','naverWebProbeControl'))
assert 'CookieManager.getInstance().getCookie(' not in web
assert 'getPassword' not in web
assert 'saveCommit.click()' not in s
print('R231_READ_ONLY_AND_ISOLATION_STATIC_CONTRACT=PASS')