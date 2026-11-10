"""Public Place detail + Save button opens login; never logs in or writes bookmarks."""
import json,asyncio
from playwright.async_api import async_playwright
URL="https://pcmap.place.naver.com/place/1628573942/home"
async def main():
 async with async_playwright() as p:
  browser=await p.chromium.launch(headless=True)
  ctx=await browser.new_context(viewport={"width":393,"height":852},is_mobile=True,has_touch=True,
   user_agent="Mozilla/5.0 (Linux; Android 17; SM-S948N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Mobile Safari/537.36")
  page=await ctx.new_page()
  out={"url":URL,"note":"unauthenticated page only, never submit save"}
  try:
   resp=await page.goto(URL,wait_until="domcontentloaded",timeout=20000)
   await page.wait_for_timeout(1000)
   out["http"]=resp.status if resp else None
   b=page.get_by_text("저장",exact=True).first
   out["save_found"]=bool(await b.count())
   if out["save_found"]:
    await b.click(timeout=4000)
    await page.wait_for_timeout(2000)
    out["post_click_url"]=page.url.split("?")[0]
    out["post_click_text"]=(await page.locator("body").inner_text(timeout=5000))[:600]
    out["field_labels"]=await page.locator("input").evaluate_all("(xs)=>xs.slice(0,20).map(x=>({type:x.type,placeholder:x.placeholder}))")
    out["button_texts"]=[s[:80] for s in (await page.locator("button").all_text_contents())[:35]]
    out["iframes"]=[f.url.split('?')[0][:160] for f in page.frames]
  except Exception as e:out["error"]=type(e).__name__+" "+str(e)[:160]
  finally:
   await browser.close()
 with open("MOA_NAVER_PUBLIC_SAVE_MODAL_NO_AUTH.json","w",encoding="utf-8") as f:
  json.dump(out,f,ensure_ascii=False,indent=2)
 print(json.dumps(out,ensure_ascii=False))
if __name__=="__main__":asyncio.run(main())
