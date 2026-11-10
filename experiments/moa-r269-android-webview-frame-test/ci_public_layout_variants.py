"""Anonymous public NAVER search-result DOM geometry experiment.
Never logs in, clicks Save, reads credentials/cookies, records personal text or
performs account writes. Outputs only frame hosts, counts and geometry ranges.
"""
import asyncio, json
from urllib.parse import quote, urlsplit
from playwright.async_api import async_playwright

QUERIES=["서울역","스타벅스 강남"]
async def inspect_one(browser, query):
    context=await browser.new_context(viewport={"width":1300,"height":860},locale="ko-KR")
    page=await context.new_page()
    result={"query_case":QUERIES.index(query)+1,"authenticated":False,
            "save_clicked":False,"account_written":False,"source":"NAVER_PUBLIC_UI"}
    try:
        url="https://map.naver.com/p/search/"+quote(query)
        resp=await page.goto(url,wait_until="domcontentloaded",timeout=45000)
        result["http"]=resp.status if resp else None
        await page.wait_for_timeout(8500)
        frames=[]
        for fr in page.frames:
            host=urlsplit(fr.url).netloc
            if not (host=="naver.com" or host.endswith(".naver.com")):continue
            try:
                counts=await fr.evaluate("""() => {
                  const nodes=[...document.querySelectorAll('a[href*="/place/"]')];
                  const ids=[...new Set(nodes.map(a=>{
                    const m=(a.getAttribute('href')||'').match(/\\/place\\/(\\d{5,20})/);
                    return m?m[1]:null;
                  }).filter(Boolean))];
                  const saves=[...document.querySelectorAll('[data-nlog-area="map_btp.save"]')];
                  const widths=saves.map(x=>Math.round(x.getBoundingClientRect().width));
                  return {placeLinks:nodes.length,distinctSids:ids.length,
                    saveControls:saves.length,saveMinW:widths.length?Math.min(...widths):null,
                    saveMaxW:widths.length?Math.max(...widths):null,
                    hasSearchInput:!!document.querySelector('input')};
                }""")
                frames.append({"host":host,"counts":counts})
            except Exception:
                frames.append({"host":host,"unreadable":True})
        result["frame_metrics"]=frames
        result["naver_parent_loaded"]=any(f["host"]=="map.naver.com" for f in frames)
        result["distinct_sids_total"]=sum(f.get("counts",{}).get("distinctSids",0) for f in frames)
        result["result"]="NAVER_PUBLIC_UI_OBSERVED" if result["naver_parent_loaded"] else "PUBLIC_UI_NOT_LOADED"
    except Exception as ex:
        result["result"]="PUBLIC_BROWSER_FAILED"
        result["error_type"]=type(ex).__name__
    finally:
        await context.close()
    return result

async def main():
    async with async_playwright() as p:
        browser=await p.chromium.launch(headless=True)
        try: results=[await inspect_one(browser,q) for q in QUERIES]
        finally: await browser.close()
    output={"scope":"ANONYMOUS_NO_LOGIN_NO_SAVE",
            "fixed_pixel_click":False,"account_write_verified":False,
            "real_device_background_save_verified":False,"results":results}
    with open("MOA_R283_PUBLIC_MULTI_RESULT_LAYOUT_PROOF.json","w") as f:
        json.dump(output,f,ensure_ascii=False,indent=2)
    print(json.dumps(output,ensure_ascii=False,sort_keys=True))

if __name__=="__main__":asyncio.run(main())
