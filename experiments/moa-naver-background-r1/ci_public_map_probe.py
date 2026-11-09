"""CI-only public unauthenticated NAVER PC map feasibility test.
No login, no cookies, no private user data, no favorites writes.
Prints only booleans and sanitized origin path, NOT page HTML.
"""
import asyncio,json,urllib.parse
from playwright.async_api import async_playwright

async def run():
    result={'probe':'public_desktop_naver_map_only','real_account_login':False,
            'real_account_favorite_saved':False,'naver_private_data_read':False}
    try:
        async with async_playwright() as pw:
            browser=await pw.chromium.launch(headless=True)
            try:
                context=await browser.new_context(viewport={'width':1440,'height':900},locale='ko-KR')
                page=await context.new_page()
                try:
                    await page.goto('https://map.naver.com/p/',wait_until='domcontentloaded',timeout=35000)
                    await page.wait_for_timeout(6000)
                    u=urllib.parse.urlsplit(page.url)
                    result.update({'origin':u.hostname or '', 'path':u.path[:100],
                                   'frame_count':len(page.frames),
                                   'has_navbar_save':await page.locator('button.btn_navbar').count()>0,
                                   'has_search_input':await page.locator('input.input_search').count()>0,
                                   'has_pcmap_frame':any('pcmap.place.naver.com' in f.url for f in page.frames),
                                   'mobile_app_redirect':u.hostname=='m.map.naver.com',
                                   'status':'PUBLIC_WEB_RENDERED_UNVERIFIED'})
                    if result['origin']=='map.naver.com' and (result['has_navbar_save'] or result['has_search_input']):
                        result['status']='PUBLIC_PC_MAP_DOM_PRESENT'
                    elif result['mobile_app_redirect']:
                        result['status']='PUBLIC_MOBILE_APP_REDIRECT'
                except Exception as e:
                    result['status']='PUBLIC_PAGE_NAV_ERROR'
                    result['error_type']=type(e).__name__
                finally:await context.close()
            finally:await browser.close()
    except Exception as e:
        result['status']='PUBLIC_BROWSER_LAUNCH_ERROR'
        result['error_type']=type(e).__name__
    print(json.dumps(result,ensure_ascii=False,indent=2))
    with open('MOA_NAVER_PUBLIC_MAP_CI_RESULT.json','w',encoding='utf-8') as f:
        json.dump(result,f,ensure_ascii=False,indent=2)

if __name__=='__main__':asyncio.run(run())
