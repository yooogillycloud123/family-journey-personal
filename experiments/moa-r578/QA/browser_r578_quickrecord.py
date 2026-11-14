from pathlib import Path
import json
from playwright.sync_api import sync_playwright
SRC=Path('/mnt/data/.moa_r578_work/assets/web/moa-r483-vertical-calendar.js').read_text()
DAY='2026-11-14';results=[]
BOOT='''
window.moaOpenCalls=[];window.moaIndexCalls=0;
window.__testStore=new Map();
Object.defineProperty(window,'indexedDB',{configurable:true,value:{open:()=>{const q={};setTimeout(()=>{q.result={close(){},transaction:()=>({objectStore:()=>({get:(key)=>{const req={};setTimeout(()=>{req.result=__testStore.get(key)||null;req.onsuccess?.()},0);return req}})})};q.onsuccess?.()},0);return q;}}});
window.moaState={open:true,page:'calendar',date:'2026-11-14',mode:'curated',load:false,
 curatedEntries:new Map(),entries:new Map(),byDay:new Map(),byVideoDay:new Map(),byId:new Map(),
 covers:{curated:{},automatic:{}},photos:[],videos:[],editing:false,dirty:false};
window.FamilyJourneyDiary={state:window.moaState,loadIndex:function(){window.moaIndexCalls++;},localDay:()=>'2026-11-14'};
window.MoaLocalAudio={list:()=>'[]',openNativeGallery:function(ids,index,day){window.moaOpenCalls.push({ids:JSON.parse(ids),index,day});return true;},closeNativeGallery:()=>true};
window.__moaR507BridgeReady=true;window.MoaVoicePlaybackUI={stop:()=>{}};
setInterval(()=>{if(window.__moaR511InlineArm)window.__moaR511NativeArmed=true;},25);
'''
SEED='''([day,id,updatedAt]) => {__testStore.set(day,{day,photoIds:[id],moments:[{uid:'native-'+id,photoIds:[id],note:'saved'}],selectionMode:'manual',updatedAt});return true}'''

def setup(p):
 p.goto('about:blank')
 p.evaluate(BOOT)
 p.add_script_tag(content=SRC)
 p.wait_for_function('!!window.MoaR469SimpleDiary')

with sync_playwright() as pw:
 browser=pw.chromium.launch(headless=True,executable_path='/usr/bin/chromium',args=['--no-sandbox'])
 # Scenario A: brand new Quick Record persisted only to IndexedDB before cached map hydrated.
 page=browser.new_page();setup(page)
 page.evaluate(SEED,[DAY,'987650001',1731542400000]);page.evaluate(f"window.MoaR469SimpleDiary.openDay('{DAY}')")
 page.wait_for_timeout(2200)
 print('DEBUG R578',page.evaluate('''()=>({s:MoaR469SimpleDiary.readOnlyStatus(),curated:[...moaState.curatedEntries.keys()],opened:moaOpenCalls,cache:[...__testStore.keys()],nativeArmed:window.__moaR511NativeArmed,entering:document.querySelector('#moa-r469-root')?.className,error:document.querySelector('.moa-r469-status')?.textContent})'''))
 page.wait_for_function('window.MoaR469SimpleDiary.readOnlyStatus().mediaCount === 1 && window.moaOpenCalls.length > 0',timeout=8000)
 a=page.evaluate('''() => ({calls:moaOpenCalls,media:MoaR469SimpleDiary.readOnlyStatus().mediaCount,record:moaState.curatedEntries.get('2026-11-14')?.photoIds})''')
 assert a['record']==['987650001'] and a['calls'][0]['ids']==['987650001'],a
 results.append({'test':'cold-start same persisted Quick Record loaded into photo gallery from existing curated IndexedDB','result':'PASS','observation':a})
 # Scenario B: fresh same-date photoId replaces the day record without Map.size changing.
 page.evaluate(SEED,[DAY,'987650002',1731542402000]);page.evaluate('''()=>{moaState.curatedEntries.set('2026-11-14',{day:'2026-11-14',updatedAt:1731542402000,photoIds:['987650002'],moments:[],selectionMode:'manual'})}''')
 page.evaluate('window.MoaR469SimpleDiary.close()');page.evaluate(f"window.MoaR469SimpleDiary.openDay('{DAY}')")
 page.wait_for_function("window.moaOpenCalls.some(c=>c.ids.includes('987650002'))",timeout=3500)
 results.append({'test':'a second same-day Quick Record does not require calendar Map.size increase','result':'PASS'})
 page.close()
 # Scenario C: an already indexed original photo opens at first request (R567 fast path).
 page=browser.new_page();setup(page)
 page.evaluate("""()=>{moaState.curatedEntries.set('2026-11-14',{day:'2026-11-14',photoIds:['987650003'],moments:[],selectionMode:'manual'});moaState.byId.set('987650003',{id:'987650003',t:Date.now(),video:false})}""")
 page.evaluate(f"window.MoaR469SimpleDiary.openDay('{DAY}')")
 page.wait_for_function('moaOpenCalls.length>0',timeout=2500)
 assert page.evaluate('moaOpenCalls[0].ids[0]')=='987650003'
 results.append({'test':'existing indexed R567 photo retains immediate native gallery open','result':'PASS'})
 page.close()
 # Scenario D: user-deleted/photoRemoved ID is never restored solely from orphaned moment.
 page=browser.new_page();setup(page)
 page.evaluate('''()=>{moaState.curatedEntries.set('2026-11-14',{day:'2026-11-14',photoIds:[],removedMediaIds:['987650004'],moments:[{photoIds:['987650004'],note:'keep without re-adding'}],selectionMode:'manual'})}''')
 page.evaluate(f"window.MoaR469SimpleDiary.openDay('{DAY}')")
 page.wait_for_timeout(1000)
 assert page.evaluate('window.MoaR469SimpleDiary.readOnlyStatus().mediaCount')==0
 assert page.evaluate('window.moaOpenCalls.length')==0
 results.append({'test':'orphaned moment does not resurrect intentionally removed photo','result':'PASS'})
 page.close();browser.close()
Path('/mnt/data/.moa_r578_work/QA/browser_r578_quickrecord.json').write_text(json.dumps(results,ensure_ascii=False,indent=2))
print(json.dumps(results,ensure_ascii=False,indent=2))
