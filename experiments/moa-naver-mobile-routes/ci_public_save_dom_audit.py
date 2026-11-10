"""Read-only unauthenticated public save-control DOM audit. No login, no saves."""
from playwright.async_api import async_playwright
import asyncio,json
URL="https://pcmap.place.naver.com/place/1628573942/home"
async def main():
 async with async_playwright() as pw:
  b=await pw.chromium.launch(headless=True)
  ctx=await b.new_context(is_mobile=True,has_touch=True,viewport={"width":393,"height":852},
   user_agent="Mozilla/5.0 (Linux; Android 17; SM-S948N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Mobile Safari/537.36")
  page=await ctx.new_page()
  popups=[]
  ctx.on("page",lambda p:popups.append("new-page"))
  out={"scope":"public page DOM; no auth; no write","url":URL}
  try:
   await page.goto(URL,wait_until="domcontentloaded",timeout=18000)
   await page.wait_for_timeout(1200)
   loc=page.get_by_text("저장",exact=True)
   count=await loc.count()
   out["match_count"]=count
   out["matches"]=[]
   for i in range(min(8,count)):
    x=loc.nth(i)
    info=await x.evaluate("""e=>{
     const a=e.closest('button,a,[role=button],[onclick]')||e;
     const r=a.getBoundingClientRect();
     return {tag:e.tagName,html:e.outerHTML.slice(0,400),actionable:a.outerHTML.slice(0,950),
      rect:[Math.round(r.x),Math.round(r.y),Math.round(r.width),Math.round(r.height)],
      pressed:a.getAttribute('aria-pressed')};
    }""")
    out["matches"].append(info)
   if count:
    await loc.first.click(timeout=4000)
    await page.wait_for_timeout(1300)
    out["post_url"]=page.url.split("?")[0]
    out["popup_count"]=len(popups)
    out["after_save_texts"]=[x.strip()[:100] for x in (await page.get_by_text("저장",exact=True).all_text_contents())[:8]]
    out["after_iframes"]=[x.url.split("?")[0] for x in page.frames]
    out["login_visible"]=bool(await page.get_by_text("로그인",exact=True).count())
  except Exception as e:out["error"]=type(e).__name__+" "+str(e)[:160]
  await b.close()
 with open("MOA_NAVER_PUBLIC_SAVE_DOM_AUDIT_NO_AUTH.json","w",encoding="utf-8") as f:json.dump(out,f,ensure_ascii=False,indent=2)
 print(json.dumps(out,ensure_ascii=False))
if __name__=="__main__":asyncio.run(main())
