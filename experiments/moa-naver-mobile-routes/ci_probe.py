"""Unauthenticated mobile Chromium routes only; NO NAVER account/cookies/actions."""
import asyncio, json, os
from playwright.async_api import async_playwright

ROUTES=[
 "https://map.naver.com/p/",
 "https://m.place.naver.com/place/1628573942/home",
 "https://pcmap.place.naver.com/place/1628573942/home",
 "https://m.search.naver.com/search.naver?query=%EB%B0%B1%EC%84%9D%EB%A1%9C%20145",
 "https://pages.map.naver.com/save-pages/",
 "https://pages.map.naver.com/save-widget/",
 "https://pages.map.naver.com/save-pages/api/maps-bookmark/v3/folders?start=0&limit=20&sort=lastUseTime&folderType=all",
]
BROWSER_CONTEXTS=[
 ("android_mobile", {"viewport":{"width":393,"height":852},"device_scale_factor":3,"is_mobile":True,
  "has_touch":True,"user_agent":"Mozilla/5.0 (Linux; Android 17; SM-S948N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Mobile Safari/537.36"}),
 ("android_desktop_ua", {"viewport":{"width":393,"height":852},"device_scale_factor":3,"is_mobile":True,
  "has_touch":True,"user_agent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36"}),
 ("pc_desktop", {"viewport":{"width":1365,"height":900},"is_mobile":False,
  "user_agent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36"}),
]
async def run():
 results=[]
 async with async_playwright() as p:
  browser=await p.chromium.launch(headless=True)
  try:
   for label,kwargs in BROWSER_CONTEXTS:
    context=await browser.new_context(**kwargs)
    for url in ROUTES:
     page=await context.new_page()
     try:
      resp=await page.goto(url,wait_until="domcontentloaded",timeout=18000)
      await page.wait_for_timeout(1300)
      frames=[{"origin":f.url.split('/')[2] if f.url.startswith('https://') else "local", "path":('/'+('/'.join(f.url.split('/')[3:]).split('?')[0]))[:90]} for f in page.frames][:8]
      result={"mode":label,"requested":url.split('?')[0],"http":resp.status if resp else None,
        "final_url":(page.url.split('?')[0])[:160],"title":(await page.title())[:120],
        "frame_count":len(page.frames),"frames":frames,
        "body_text_len":len((await page.locator("body").inner_text(timeout=3500))[:20000]),
        "sample_text":(await page.locator("body").inner_text(timeout=3500))[:200],
        "save_controls":await page.locator('button:has-text("저장"),a:has-text("저장"),[aria-label*="저장"]').count()}
     except Exception as e:
      result={"mode":label,"requested":url.split('?')[0],"error":type(e).__name__+" "+str(e)[:130]}
     results.append(result)
     print(json.dumps(result,ensure_ascii=False),flush=True)
     await page.close()
    await context.close()
  finally:await browser.close()
 with open("MOA_NAVER_MOBILE_ROUTES_NO_LOGIN_20261110.json","w",encoding="utf-8") as f:json.dump({"scope":"public pages only; no credentials", "results":results},f,ensure_ascii=False,indent=2)
if __name__=="__main__": asyncio.run(run())
