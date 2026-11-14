from pathlib import Path
from playwright.sync_api import sync_playwright
import json,sys,subprocess
ROOT=Path(__file__).resolve().parent.parent
source=Path(sys.argv[1]) if len(sys.argv)>1 else ROOT/'03_MODIFIED_SOURCE'
css=(ROOT/'QA/fixtures/family-diary.css').read_text()+'\n'+(source/'moa-r483-vertical-calendar.css').read_text()
js=(source/'moa-r483-vertical-calendar.js').read_text().replace("const r527TrustedOrigin=()=>location.origin==='https://familyjourney.local';","const r527TrustedOrigin=()=>true;")
pre='''<html><head><meta name="viewport" content="width=device-width,initial-scale=1"><style>body{margin:0;font-family:system-ui}#tabbar{position:fixed;bottom:0;height:67px;left:0;right:0;display:flex;background:white;z-index:30}#tabbar button{flex:1}</style><style>'''+css+'''</style></head><body><div id="tabbar"><button data-tab="diary">diary</button><button data-tab="home">map</button><button data-tab="record">record</button><button data-tab="settings">settings</button></div><section id="fj-diary-root"></section><script>
window.indexedDB.databases=undefined;
const day='2026-11-14',photos=[{id:'1',t:Date.parse(day+'T08:12:00')},{id:'2',t:Date.parse(day+'T09:12:00')},{id:'3',t:Date.parse(day+'T10:12:00')}];
window.galleryOpen=false;window.eventTrace=[];window.nativeOpenCount=0;window.closeCount=0;window.menuHits=0;
window.FamilyJourneyDiary={state:{open:true,page:'calendar',date:day,mode:'curated',curatedEntries:new Map([[day,{day,photoIds:['1','2','3'],body:'기록'}]]),entries:new Map(),byDay:new Map([[day,photos]]),byVideoDay:new Map(),byId:new Map(photos.map(p=>[p.id,p])),covers:{curated:{},automatic:{}},load:false},open:()=>Promise.resolve(),close:()=>true,selectDay(d){window.galleryOpen=true;window.eventTrace.push('original.selectDay');let s=this.state;s.page='day';s.date=d;let root=document.getElementById('fj-diary-root');root.hidden=false;root.dataset.page='day';root.innerHTML='<div class="fd23-top"><button class="moa-r191-day-menu-trigger">···</button></div><div class="fd23-timeline"><h3>사진·영상으로 보는 하루</h3></div>';root.querySelector('.moa-r191-day-menu-trigger').onclick=()=>window.menuHits++;}};
window.MoaLocalAudio={openNativeGallery:()=>{window.galleryOpen=true;window.nativeOpenCount++;window.eventTrace.push('native.open');return true},closeNativeGallery:()=>{window.galleryOpen=false;window.closeCount++;window.eventTrace.push('native.close');return true}};
window.__requestThumbs=async(ids)=>Object.fromEntries(ids.map(id=>[id,'data:image/svg+xml,%3Csvg%20xmlns="http://www.w3.org/2000/svg"%20width="10"%20height="10"%3E%3C/svg%3E']));
</script><script>'''+js+'''</script></body></html>'''
results=[]
with sync_playwright() as p:
 b=p.chromium.launch(headless=True,executable_path='/usr/bin/chromium',args=['--no-sandbox'])
 for theme in ['peach','black','white']:
  page=b.new_page(viewport={'width':420,'height':900},device_scale_factor=1)
  errors=[];page.on('pageerror',lambda e:errors.append(str(e)))
  page.set_content(pre,wait_until='domcontentloaded');page.wait_for_timeout(150)
  page.evaluate('(t)=>document.documentElement.dataset.moaUi=t',theme)
  assert page.evaluate('MoaR469SimpleDiary.openDay("2026-11-14")')
  page.evaluate('window.__moaR507BridgeReady=true;window.__moaR511NativeArmed=true;')
  page.wait_for_timeout(300)
  assert page.evaluate('galleryOpen')
  # No mounted callback to simulate slow Galaxy UI; timer must not close.
  page.wait_for_timeout(3000)
  assert page.evaluate('galleryOpen')
  assert page.evaluate('closeCount')==0
  page.evaluate('window.__moaR507NativeMounted(true)')
  # Verify *real* ordering: photo Gallery.close BEFORE original detailed selectDay open.
  page.locator('#moa-r469-root .moa-r483-toggle-hit[data-option="detail"]').click(force=True)
  trace=page.evaluate('eventTrace')
  assert trace[-2:]==['native.close','original.selectDay'],f'wrong native ownership order {trace}'
  assert page.evaluate('galleryOpen'),'detail screen native Gallery closed by photo teardown'
  assert page.locator('#fj-diary-root .moa-r539-day-chrome').count()==1
  # Ensure detailed current Gallery remains original, original menu kept.
  page.locator('#fj-diary-root .moa-r539-day-settings').click(force=True)
  assert page.evaluate('menuHits')==1,'original detailed settings button broke'
  for repeat in range(3):
   page.locator('#fj-diary-root .moa-r483-toggle-hit[data-option="photo"]').click(force=True)
   page.evaluate('window.__moaR507BridgeReady=true;window.__moaR511NativeArmed=true;')
   page.wait_for_timeout(220)
   assert page.evaluate('galleryOpen')
   assert page.locator('#moa-r469-root').evaluate('e=>!e.hidden')
   for selector in ['.moa-r469-video-play','.moa-r499-video-play','.moa-r531-web-advanced','.moa-r469-pager','.moa-r469-tools']:
    loc=page.locator('#moa-r469-root '+selector)
    if loc.count():assert loc.first.evaluate('e=>getComputedStyle(e).visibility')=='hidden',selector
   page.evaluate('window.__moaR507NativeMounted(true)')
   page.locator('#moa-r469-root .moa-r483-toggle-hit[data-option="detail"]').click(force=True)
   assert page.evaluate('galleryOpen'),'native original detail Gallery broken at repeat '+str(repeat)
  # user Back from photo should exit to calendar after entry
  page.locator('#fj-diary-root .moa-r483-toggle-hit[data-option="photo"]').click(force=True)
  page.evaluate('window.__moaR507BridgeReady=true;window.__moaR511NativeArmed=true;')
  page.wait_for_timeout(350)
  page.evaluate('window.__moaR507NativeMounted(true)')
  val=page.evaluate('window.__moaR523NativeBack(window.__moaR527DayToken)')
  assert val=='exit',val
  assert page.evaluate('MoaR469SimpleDiary.readOnlyStatus().page')=='calendar'
  assert page.evaluate('galleryOpen')==False
  assert not errors,errors
  results.append(dict(theme=theme,no_timer_close='PASS',detail_owner_order='PASS',detail_to_photo_3x='PASS',original_settings='PASS',native_back_to_calendar='PASS',js_errors=errors))
  page.close()
 b.close()
print(json.dumps(results,ensure_ascii=False,indent=2))
if source==ROOT/'03_MODIFIED_SOURCE':(ROOT/'QA/R555_BROWSER_REGRESSION.json').write_text(json.dumps(results,ensure_ascii=False,indent=2)+'\n')
