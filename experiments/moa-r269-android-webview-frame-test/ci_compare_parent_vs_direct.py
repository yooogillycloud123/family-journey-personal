"""MOA R269: anonymous first-party NAVER Save button topology A/B.
No login, accounts, cookies, request bodies, tokens, screenshots or account writes.
Only public URL hosts, boolean DOM flags and event categories are recorded.
"""
import asyncio
import json
from urllib.parse import urlsplit
from playwright.async_api import async_playwright

SID = "1628573942"
URLS = {
    "parent": f"https://map.naver.com/p/entry/place/{SID}",
    "direct": f"https://pcmap.place.naver.com/place/{SID}/home",
}
SAVE = 'a[data-nlog-area="map_btp.save"][aria-pressed="false"]'

def loc(url):
    try:
        p = urlsplit(url)
        return f"{p.scheme}://{p.netloc}{p.path[:150]}"
    except Exception:
        return "UNPARSEABLE"

async def frame_data(frame):
    return await frame.evaluate("""() => {
       const a=document.querySelector('a[data-nlog-area="map_btp.save"]');
       const r=a?a.getBoundingClientRect():null;
       return {isTop:window.parent===window,hasSave:!!a,
       pressed:a?.getAttribute('aria-pressed')??'none',
       box:r?{w:Math.round(r.width),h:Math.round(r.height)}:null,
       dialogs:document.querySelectorAll('[role="dialog"],dialog,[aria-modal="true"]').length,
       loginText:!!(document.body&&document.body.innerText.includes('로그인')),
       navActivation:navigator.userActivation?.hasBeenActive??null,
       events:window.__moaTestEvents??[]};
    }""")

async def run_case(browser, key, url):
    ctx=await browser.new_context(viewport={"width":1365,"height":860},is_mobile=False,has_touch=False)
    page=await ctx.new_page()
    result={"case":key,"target":loc(url),"login":False,"personal_write":False,
            "readback":False,"save_success":False,"events":[]}
    popups=[]
    page.on("popup",lambda popup: popups.append(popup))
    try:
        resp=await page.goto(url,wait_until="domcontentloaded",timeout=45000)
        result["http"]=resp.status if resp else None
        # The page's PC iframe loads asynchronously.
        child=None
        for _ in range(48):
            frames=[f for f in page.frames if loc(f.url).startswith("https://pcmap.place.naver.com/place/")]
            if key=="direct":frames=[page.main_frame]
            if frames:
                test=frames[0]
                if await test.locator('a[data-nlog-area="map_btp.save"]').count():
                    child=test
                    break
            await asyncio.sleep(.5)
        result["frames"]=[loc(f.url) for f in page.frames]
        result["child_found"]=child is not None
        if child is None:
            result["failure_gate"]="PLACE_SAVE_CONTROL_NOT_LOADED"
            return result
        # Observe only anonymous click trust and whether the first-party page emits
        # parent messages. Message payloads and request details are NEVER recorded.
        await child.evaluate("""() => {
          window.__moaTestEvents=[];
          for (const n of ['pointerdown','mousedown','click']){
            document.addEventListener(n,(e)=>{
              const a=e.target?.closest?.('a[data-nlog-area]');
              if(a?.getAttribute('data-nlog-area')==='map_btp.save')
                window.__moaTestEvents.push(n+':trusted='+e.isTrusted);
            },true);
          }
        }""")
        await page.main_frame.evaluate("""() => {
          window.__moaParentMessageOrigins=[];
          window.addEventListener('message',e=>{
            if(window.__moaParentMessageOrigins.length<30)
              window.__moaParentMessageOrigins.push(e.origin);
          },true);
        }""")
        result["before"]=await frame_data(child)
        locator=child.locator(SAVE).first
        try:
            await locator.click(force=True,timeout=8000)
            result["click_method"]="playwright_native_force"
        except Exception as exc:
            result["click_error"]=type(exc).__name__+":"+str(exc).split("\n")[0][:180]
            result["failure_gate"]="NATIVE_BROWSER_TARGET_NOT_CLICKABLE"
            return result
        await page.wait_for_timeout(7000)
        result["after"]=await frame_data(child)
        result["popup_count"]=len(popups)
        result["popup_hosts"]=[urlsplit(p.url).netloc for p in popups][:5]
        result["parent_after"]=loc(page.url)
        result["parent_message_origins"]=(await page.main_frame.evaluate(
            "() => window.__moaParentMessageOrigins??[]"))[:30]
        result["navigation_changed"]=loc(page.url)!=loc(url)
        result["failure_gate"]="ANONYMOUS_CLICK_ONLY_ACCOUNT_WRITE_NOT_TESTED"
    except Exception as exc:
        result["failure_gate"]="BROWSER_OR_SITE_ERROR"
        result["error"]=type(exc).__name__+":"+str(exc).split("\n")[0][:180]
    finally:
        await ctx.close()
    return result

async def main():
    async with async_playwright() as p:
        browser=await p.chromium.launch(headless=True)
        try:
            results=[await run_case(browser,k,v) for k,v in URLS.items()]
        finally:
            await browser.close()
    proof={"scope":"ANONYMOUS_PUBLIC_NAVER_REAL_BROWSER_NO_AUTH_OR_ACCOUNT_WRITE",
           "results":results,
           "verified_account_write":False,
           "verified_readback":False}
    path="MOA_R269_PARENT_VS_DIRECT_ANON_BROWSER_PROOF.json"
    with open(path,"w",encoding="utf-8") as f:
        json.dump(proof,f,ensure_ascii=False,indent=2)
    print(json.dumps(proof,ensure_ascii=False,sort_keys=True),flush=True)
    # DOM gate only; DO NOT allow login or persistence conclusions.
    if not any(c.get("child_found") for c in results):
        raise SystemExit("NO_NAVER_PLACE_DOM_BOTH_CASES")

if __name__=="__main__":
    asyncio.run(main())
