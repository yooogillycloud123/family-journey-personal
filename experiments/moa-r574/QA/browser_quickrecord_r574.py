from pathlib import Path
import json
from playwright.sync_api import sync_playwright
SRC=Path('/mnt/data/.moa_r574_work/assets/web/moa-r483-vertical-calendar.js').read_text()
DAY='2026-11-14'
# Original family-diary owner is mocked read-only; tests exercise the ACTUAL R574
# calendar JS in Chromium, not a reimplementation of its tryOpen/render routines.
BOOT='''
window.moaOpenCalls=[]; window.moaIndexCalls=0;
window.moaState={
 open:true,page:'calendar',date:'2026-11-14',mode:'curated',load:false,
 curatedEntries:new Map(),entries:new Map(),byDay:new Map(),byVideoDay:new Map(),byId:new Map(),
 covers:{curated:{},automatic:{}},photos:[],videos:[],editing:false,dirty:false
};
window.FamilyJourneyDiary={state:window.moaState,
 loadIndex:function(){window.moaIndexCalls++;window.moaState.load=true;},
 localDay:()=>"2026-11-14"};
window.MoaLocalAudio={list:()=>"[]",openNativeGallery:function(ids,index,day){
 window.moaOpenCalls.push({ids:JSON.parse(ids),index,day});return true;},closeNativeGallery:()=>true};
window.__moaR507BridgeReady=true;
window.MoaVoicePlaybackUI={stop:()=>{}};
setInterval(()=>{if(window.__moaR511InlineArm)window.__moaR511NativeArmed=true;},25);
'''
def setup(page):
 page.goto('about:blank')
 page.evaluate(BOOT)
 page.add_script_tag(content=SRC)
 page.wait_for_function('!!window.MoaR469SimpleDiary')

def add_media(page,day,id,indexed=False):
 page.evaluate('''([day,id,indexed])=>{
 const s=window.moaState;
 s.curatedEntries.set(day,{day,photoIds:[id],moments:[{uid:'native-'+id,at:Date.parse(day+'T12:00:00'),photoIds:[id],note:'quick saved'}],selectionMode:'manual'});
 if(indexed)s.byId.set(id,{id,t:Date.parse(day+'T12:00:00'),video:id.startsWith('v')});
 }''',[day,id,indexed])

with sync_playwright() as p:
 browser=p.chromium.launch(headless=True,executable_path='/usr/bin/chromium',args=['--no-sandbox'])
 page=browser.new_page()
 results=[]
 # Case A: Quick Record IndexedDB committed and visible in DETAIL, but MediaStore
 # index initially missing: the original Gallery must NOT be opened into black.
 setup(page);add_media(page,DAY,'987650001',False)
 page.evaluate(f"window.MoaR469SimpleDiary.openDay('{DAY}')")
 page.wait_for_timeout(1100)
 a=page.evaluate('''()=>({n:window.moaOpenCalls.length,scan:window.moaIndexCalls,
 media:window.MoaR469SimpleDiary.readOnlyStatus().mediaCount,
 stage:!!document.querySelector('.moa-r469-stage .moa-r472-slide')})''')
 assert a['n']==0 and a['scan']>=1 and a['media']==1 and a['stage'],a
 results.append({'case':'new capture before MediaStore index','result':'PASS','state':a})
 # New native media index callback: Gallery gets the original exact photo ID.
 page.evaluate('''()=>{window.moaState.byId.set('987650001',{id:'987650001',t:Date.parse('2026-11-14T12:00:00')});
 window.moaState.load=false;}''')
 page.wait_for_function('window.moaOpenCalls.length===1',timeout=4000)
 got=page.evaluate('window.moaOpenCalls[0]')
 assert got['ids']==['987650001'] and got['index']==0 and got['day']==DAY,got
 results.append({'case':'original Gallery opens only AFTER index','result':'PASS','state':got})
 # Case B: an already-indexed older photo must keep the R567 instant native route.
 page.close();page=browser.new_page();setup(page)
 add_media(page,DAY,'987650002',True)
 page.evaluate(f"window.MoaR469SimpleDiary.openDay('{DAY}')")
 page.wait_for_function('window.moaOpenCalls.length===1',timeout=3000)
 got=page.evaluate('window.moaOpenCalls[0]')
 assert got['ids']==['987650002'],got
 results.append({'case':'old indexed photo direct route unaffected','result':'PASS','state':got})
 # Case C: photo-day opened before async Quick Record DB commit; do not remain
 # blank: state changes without destroying the R567 already healthy Gallery.
 page.close();page=browser.new_page();setup(page)
 page.evaluate(f"window.MoaR469SimpleDiary.openDay('{DAY}')")
 assert page.evaluate('window.MoaR469SimpleDiary.readOnlyStatus().mediaCount')==0
 add_media(page,DAY,'987650003',False)
 page.evaluate("document.body.append(document.createElement('meta'))")
 page.wait_for_function("window.MoaR469SimpleDiary.readOnlyStatus().mediaCount===1",timeout=3000)
 assert page.evaluate('window.moaOpenCalls.length')==0
 page.evaluate("window.moaState.byId.set('987650003',{id:'987650003',t:Date.parse('2026-11-14T12:00:00')})")
 page.wait_for_function('window.moaOpenCalls.length===1',timeout=3500)
 results.append({'case':'active empty photo-day sees asynchronous Quick Record attachment','result':'PASS'})
 browser.close()
 Path('/mnt/data/.moa_r574_work/QA/browser_quickrecord_r574.json').write_text(json.dumps(results,ensure_ascii=False,indent=2))
 print(json.dumps(results,ensure_ascii=False,indent=2))