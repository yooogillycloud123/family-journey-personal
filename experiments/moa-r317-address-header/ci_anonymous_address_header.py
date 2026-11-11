"""PUBLIC anonymous DOM-only evidence: NAVER address-search ☆ save button.
No account login, no user address, no save commits, no credentials.
"""
import asyncio,json
from urllib.parse import quote
from playwright.async_api import async_playwright
ADDRESS="서울특별시 중구 세종대로 110"  # public Seoul City Hall example, NOT user address
async def main():
  out={"address":"public Seoul City Hall sample","authenticated":False,"clicked":False}
  async with async_playwright() as p:
    browser=await p.chromium.launch(headless=True)
    ctx=await browser.new_context(
        is_mobile=True,has_touch=True,viewport={"width":393,"height":852},
        user_agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36")
    page=await ctx.new_page()
    try:
      resp=await page.goto("https://map.naver.com/p/search/"+quote(ADDRESS),
            wait_until="domcontentloaded",timeout=28000)
      await page.wait_for_timeout(8500)
      out["http"]=resp.status if resp else None
      out["page_url"]=page.url.split('?')[0][:170]
      out["frames"]=[]
      for frame in page.frames:
        try:
          info=await frame.evaluate("""() => {
           const n=(v)=>String(v||'').replace(/\\s+/g,' ').slice(0,145);
           const list=(sel,cap)=>[...document.querySelectorAll(sel)].slice(0,cap).map(e=>({
             tag:e.tagName,cls:n(e.className&&typeof e.className==='string'?e.className:''),
             id:n(e.id),aria:n(e.getAttribute('aria-label')),title:n(e.getAttribute('title')),
             pressed:n(e.getAttribute('aria-pressed')),text:n(e.textContent),
             html:n(e.outerHTML).slice(0,340)
           }));
           const matches=[...document.querySelectorAll('h1,h2,h3,strong,[role=heading]')].filter(e=>n(e.textContent).includes('세종대로')||n(e.textContent).includes('110')).slice(0,8);
           const btn=[...document.querySelectorAll('a,button,[role=button]')].filter(e=>{
             const s=[e.textContent,e.getAttribute('aria-label'),e.getAttribute('title'),e.getAttribute('class'),e.getAttribute('data-nlog-area')].join(' ');
             return /저장|save|favorit|bookmark|star|D_Xqt|swt/.test(s);
           }).slice(0,25);
           return {hasExactAddress:document.body?.innerText.includes('세종대로 110')||false,
             headings:matches.map(e=>n(e.textContent)),
             buttons:btn.map(e=>({tag:e.tagName,aria:n(e.getAttribute('aria-label')),title:n(e.getAttribute('title')),
                cls:n(e.className&&typeof e.className==='string'?e.className:''),
                pressed:n(e.getAttribute('aria-pressed')),html:n(e.outerHTML).slice(0,360)})),
             listed:list('li.UEzoS,li.VLTHu',5),
             saveCounts:{a:document.querySelectorAll('a[data-nlog-area="map_btp.save"]').length,
               old:document.querySelectorAll('button.btn_favorite[aria-pressed],a.D_Xqt[aria-pressed]').length},
             publicBodySample:n(document.body?.innerText).slice(0,450)};
          }""")
          out["frames"].append({"name":frame.name,"url":frame.url.split("?")[0][:190],**info})
        except Exception as ex:
          out["frames"].append({"name":frame.name,"error":type(ex).__name__+" "+str(ex)[:100]})
    except Exception as ex:out["error"]=str(ex)[:230]
    finally:await browser.close()
  with open("MOA_R317_ANONYMOUS_ADDRESS_DOM.json","w") as f:json.dump(out,f,ensure_ascii=False,indent=2)
  print("MOA_PUBLIC_ADDRESS_DOM="+json.dumps(out,ensure_ascii=False),flush=True)
if __name__=="__main__":asyncio.run(main())
