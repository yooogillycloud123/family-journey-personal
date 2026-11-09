"""Real Chromium renders a harmless local fixture; no NAVER login or network."""
import os,pytest
from pathlib import Path
from playwright.sync_api import sync_playwright

def test_real_browser_click_and_iframe_saved_list_simulation():
    with sync_playwright() as p:
        browser=p.chromium.launch(headless=True, **({'executable_path':'/usr/bin/chromium','args':['--no-sandbox']} if Path('/usr/bin/chromium').exists() else {}))
        try:
            page=browser.new_page()
            page.set_content('''<html><body>
            <button class="btn_navbar">저장</button>
            <iframe name="myPlaceBookmarkFolderListIframe" srcdoc="<body><button id='make'>새 리스트 만들기</button><input class='swt-input-text'><button id='confirm'>확인</button><ul id='lists'></ul><script>document.querySelector('#confirm').onclick=()=>document.querySelector('#lists').appendChild(Object.assign(document.createElement('li'),{textContent:document.querySelector('input').value}));</script></body>"></iframe>
            </body></html>''')
            page.locator('.btn_navbar').click()
            frame=page.frame(name='myPlaceBookmarkFolderListIframe')
            assert frame is not None
            frame.locator('#make').click()
            frame.locator('input.swt-input-text').fill('가족 여행')
            frame.locator('#confirm').click()
            assert frame.locator('#lists li').all_text_contents()==['가족 여행']
        finally:browser.close()
