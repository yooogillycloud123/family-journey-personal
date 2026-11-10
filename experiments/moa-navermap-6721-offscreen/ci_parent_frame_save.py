"""Read-only anonymous Android-like Chromium desktop-map parent/child frame test.
No login, credentials or bookmark server writes.
"""
import asyncio,json
from playwright.async_api import async_playwright
URL="https://map.naver.com/p/entry/place/1628573942"
async def main():
 out={"url":URL,"scope":"anonymous public page, one Save-control click"}
 async with async_playwright() as p:
  browser=await p.chromium.launch(headless=True)
  ctx=await browser.new_context(
    is_mobile=True,has_touch=True,viewport={"width":390,"height":840},
    user_agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36")
  page=await ctx.new_page()
  popups=[];page.on("popup",lambda x:popups.append(x))
  try:
   resp=await page.goto(URL,wait_until="domcontentloaded",timeout=25000)
   out["http"]=resp.status if resp else None
   await page.wait_for_timeout(5200)
   out["top_url"]=page.url.split("?")[0]
   out["frames_before"]=[f.url.split("?")[0][:180] for f in page.frames]
   out["candidate_frames"]=[]
   out["candidate_elements"]=[]
   target=None
   for frame in page.frames:
    try:
     candidates=frame.locator('[data-nlog-area="map_btp.save"],[aria-label="저장"],button:has-text("저장"),a:has-text("저장")')
     count=await candidates.count()
     out["candidate_frames"].append({"url":frame.url.split("?")[0][:150],"count":count})
     if count>0:
      for j in range(min(6,count)):
       el=candidates.nth(j)
       try:
        out["candidate_elements"].append({"frame":frame.url.split("?")[0][:140],
          "html":(await el.evaluate("(e)=>(e.closest('a,button,[role=button]')||e).outerHTML"))[:800]})
       except Exception as e:out["candidate_elements"].append({"error":str(e)[:80]})
     if count>0 and target is None:
      target=frame.locator('button.widget_favorite[aria-pressed="false"]').first if await frame.locator('button.widget_favorite[aria-pressed="false"]').count() else None
    except Exception as e:out["candidate_frames"].append({"error":type(e).__name__})
   if target is not None:
    try:
     await target.click(timeout=5000)
     out["clicked"]=True
     out["clicked_kind"]="place_widget_favorite_NOT_navbar"
     await page.wait_for_timeout(1800)
     out["frames_after"]=[f.url.split("?")[0][:180] for f in page.frames]
     out["popup_count"]=len(popups)
     out["after_url"]=page.url.split("?")[0]
     out["login_texts_count"]=sum([await f.get_by_text("로그인",exact=True).count() for f in page.frames])
     out["modal_candidates"]=[]
     for f in page.frames:
      try:
       d=await f.locator('[role="dialog"],[aria-modal="true"],[class*="modal"],[class*="Modal"]').count()
       if d:out["modal_candidates"].append({"frame":f.url.split("?")[0][:130],"count":d})
      except: pass
    except Exception as e:out["click_error"]=str(e)[:200]
   else:out["clicked"]=False
   out["public_body_sample"]=(await page.locator("body").inner_text(timeout=8000))[:600]
  except Exception as e:out["error"]=type(e).__name__+" "+str(e)[:200]
  finally:await browser.close()
 open("MOA_NAVER_PARENT_FRAME_SAVE_ANON_PROOF.json","w",encoding="utf-8").write(json.dumps(out,ensure_ascii=False,indent=2))
 print(json.dumps(out,ensure_ascii=False),flush=True)
if __name__=="__main__":asyncio.run(main())
