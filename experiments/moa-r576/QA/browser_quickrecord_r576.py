from pathlib import Path
import json
from playwright.sync_api import sync_playwright
SRC=Path('/mnt/data/.moa_r576_work/assets/web/moa-r483-vertical-calendar.js').read_text()
DAY='2026-11-14'
BOOT='''
window.moaOpenCalls=[];window.moaIndexCalls=0;window.moaOpenAccepted=true;
window.moaState={
 open:true,page:'calendar',date:'2026-11-14',mode:'curated',load:false,
 curatedEntries:new Map(),entries:new Map(),byDay:new Map(),byVideoDay:new Map(),byId:new Map(),
 covers:{curated:{},automatic:{}},photos:[],videos:[],editing:false,dirty:false
};
window.FamilyJourneyDiary={state:window.moaState,
 loadIndex:function(){window.moaIndexCalls++;window.moaState.load=true;},
 localDay:()=>'2026-11-14'};
window.MoaLocalAudio={list:()=>'[]',openNativeGallery:function(ids,index,day){
 window.moaOpenCalls.push({ids:JSON.parse(ids),index,day});return window.moaOpenAccepted;},closeNativeGallery:()=>true};
window.__moaR507BridgeReady=true;
window.MoaVoicePlaybackUI={stop:()=>{}};
setInterval(()=>{if(window.__moaR511InlineArm)window.__moaR511NativeArmed=true;},20);
'''
def setup(page):
 page.goto('about:blank');page.evaluate(BOOT);page.add_script_tag(content=SRC)
 page.wait_for_function('!!window.MoaR469SimpleDiary')
def put(page,day,id,indexed=False):
 page.evaluate('''([day,id,indexed])=>{
 const s=window.moaState;
 s.curatedEntries.set(day,{day,photoIds:[id],moments:[{uid:'native-'+id,at:Date.parse(day+'T12:00:00'),photoIds:[id],note:'Quick Record saved'}],selectionMode:'manual'});
 if(indexed)s.byId.set(id,{id,t:Date.parse(day+'T12:00:00'),video:id.startsWith('v')});
 }''',[day,id,indexed])
results=[]
with sync_playwright() as p:
 browser=p.chromium.launch(headless=True,executable_path='/usr/bin/chromium',args=['--no-sandbox'])
 # Actual R574 regression: pre-index quick-capture ID must NEVER block native opener.
 page=browser.new_page();setup(page);put(page,DAY,'987650001',False)
 page.evaluate(f"window.MoaR469SimpleDiary.openDay('{DAY}')")
 page.wait_for_function('window.moaOpenCalls.length>=1',timeout=3000)
 a=page.evaluate('''()=>({opened:window.moaOpenCalls[0],n:window.moaOpenCalls.length,scan:window.moaIndexCalls,media:window.MoaR469SimpleDiary.readOnlyStatus().mediaCount})''')
 assert a['opened']=={'ids':['987650001'],'index':0,'day':DAY} and a['media']==1,a
 results.append({'name':'new Quick Record indexedDB photo ID starts REAL native even when cached byId missing','pass':True,'observed':a})
 # Legacy user-approved photo index must still launch directly, same identity.
 page.close();page=browser.new_page();setup(page);put(page,DAY,'987650002',True)
 page.evaluate(f"window.MoaR469SimpleDiary.openDay('{DAY}')")
 page.wait_for_function('window.moaOpenCalls.length>=1',timeout=3000)
 b=page.evaluate('window.moaOpenCalls[0]');assert b['ids']==['987650002'] and b['index']==0,b
 results.append({'name':'Golden pre-indexed photo IDs retain direct launch','pass':True,'observed':b})
 # Confirm rejected opens don't trap app behind a permanent native-owner blanket.
 page.close();page=browser.new_page();setup(page);put(page,DAY,'987650003',False)
 page.evaluate('window.moaOpenAccepted=false')
 page.evaluate(f"window.MoaR469SimpleDiary.openDay('{DAY}')")
 page.wait_for_timeout(6500)
 print('DEBUG',page.evaluate('''()=>({calls:window.moaOpenCalls.length,pending:window.__moaR507NativePending,arm:window.__moaR511NativeArmed,waiting:window.__moaR511InlineArm,ui:window.MoaR469SimpleDiary.readOnlyStatus(),button:!!document.querySelector('.moa-r576-native-retry'),html:document.querySelector('.moa-r469-stage')?.outerHTML.slice(0,350),state:document.getElementById('moa-r469-root')?.className})'''))
 page.wait_for_function("!!document.querySelector('.moa-r576-native-retry')",timeout=1500)
 state=page.evaluate('''()=>({tries:window.moaOpenCalls.length,button:!!document.querySelector('.moa-r576-native-retry'),
  owner:document.getElementById('moa-r469-root')?.classList.contains('moa-r547-native-owner')})''')
 assert state['button'] and not state['owner'] and 2<=state['tries']<=5,state
 page.evaluate('window.moaOpenAccepted=true')
 page.locator('.moa-r576-native-retry').click()
 page.wait_for_function('window.moaOpenCalls.length>4',timeout=2500)
 results.append({'name':'rejected native opener bounded retry, visible manual recovery, no black owned state','pass':True,'observed':state})
 browser.close()
out=Path('/mnt/data/.moa_r576_work/QA/browser_quickrecord_r576.json')
out.write_text(json.dumps(results,ensure_ascii=False,indent=2))
print(json.dumps(results,ensure_ascii=False,indent=2))
