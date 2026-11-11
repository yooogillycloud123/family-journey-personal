import asyncio
from playwright.async_api import async_playwright
from pathlib import Path
SCRIPT=Path('/mnt/data/moa_r357_work/moa-r357-home-dot.js')
HTML='<html><body><section class="page" data-page="settings"><div class="section"><div class="section-title">앱</div><ul class="rows"></ul></div></section><div id="tabbar"><button data-tab="diary"></button></div></body></html>'
async def main():
 async with async_playwright() as p:
  b=await p.chromium.launch(executable_path='/usr/bin/chromium',args=['--no-sandbox','--disable-dev-shm-usage'])
  page=await b.new_page(viewport={'width':390,'height':844})
  errs=[];page.on('pageerror',lambda e:errs.append(str(e)))
  await page.set_content(HTML)
  await page.evaluate("""window.__ls={};Object.defineProperty(window,'localStorage',{value:{getItem(k){return Object.prototype.hasOwnProperty.call(window.__ls,k)?window.__ls[k]:null},setItem(k,v){window.__ls[k]=String(v)}}});window.FamilyJourneyDiary={state:{page:'day',dirty:false},open(){window.__homeCalls=(window.__homeCalls||0)+1;this.state.page='calendar'}};""")
  await page.add_script_tag(path=str(SCRIPT))
  n=page.locator('#moa-r349-home-float');await n.wait_for()
  box=await n.bounding_box();x=box['x']+box['width']/2;y=box['y']+box['height']/2
  await page.mouse.move(x,y);await page.mouse.down();await page.wait_for_timeout(730);await page.mouse.up()
  assert await n.evaluate("e=>e.classList.contains('moa-r349-editing')"),'longhold edit failed'
  assert await n.locator('svg').count()==0, 'no icon allowed in pink dot'
  before=await n.bounding_box();handle=n.locator('.moa-r349-handle[data-handle="w"]');h=await handle.bounding_box();assert h
  hx=h['x']+h['width']/2;hy=h['y']+h['height']/2
  await page.mouse.move(hx,hy);await page.mouse.down();await page.mouse.move(hx-24,hy,steps=5);await page.mouse.up()
  after=await n.bounding_box();assert after['width']>=before['width']+12,(before,after)
  await n.click(force=True)
  assert not await n.evaluate("e=>e.classList.contains('moa-r349-editing')")
  await page.locator('#moa-r349-home-settings summary').click()
  # Independent auto-shrink toggle: OFF remains full-size after delay.
  await page.evaluate("""const s=document.querySelector('#moa-r349-home-settings input[type=range]');s.value='1';s.dispatchEvent(new Event('input',{bubbles:true}));""")
  await page.wait_for_timeout(1150)
  assert not await n.evaluate("e=>e.classList.contains('moa-r349-tiny')"),'auto-shrink OFF must stay full-size'
  await page.evaluate("""const t=[...document.querySelectorAll('#moa-r349-home-settings label')].find(x=>x.textContent.includes('자동 축소 기능'));const c=t.querySelector('input');c.checked=true;c.dispatchEvent(new Event('change',{bubbles:true}));""")
  delay=page.locator('#moa-r349-home-settings input[type=range]').first
  await page.evaluate("""const s=document.querySelector('#moa-r349-home-settings input[type=range]');s.value='1';s.dispatchEvent(new Event('input',{bubbles:true}));""")
  await page.wait_for_timeout(1200)
  assert await n.evaluate("e=>e.classList.contains('moa-r349-tiny')"),'idle collapse failed'
  old=await page.evaluate('window.__homeCalls||0');await n.click(force=True)
  assert not await n.evaluate("e=>e.classList.contains('moa-r349-tiny')"),'tap expand failed'
  assert (await page.evaluate('window.__homeCalls||0'))==old,'first tap should only expand'
  await n.click(force=True);assert (await page.evaluate('window.__homeCalls||0'))==old+1,'second tap home failed'
  assert not errs,errs
  print('PASS: plain pink dot no icon; independent shrink OFF; long-hold/resize/lock; shrink ON 1s; expand; one-tap calendar; no JS errors')
  await b.close()
asyncio.run(main())
