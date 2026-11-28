#!/usr/bin/env python3
from pathlib import Path
import sys
root=Path(sys.argv[1]);p=root/'moa-r755-inline-ai.js';s=p.read_text()
def rep(a,b):
 global s
 assert s.count(a)==1,(s.count(a),a[:140]);s=s.replace(a,b,1)
rep('function progress783(){',Path('experiments/moa-r787/study-monitor.js').read_text()+'\nfunction progress783(){')
rep("function backgroundTick785(){\n if(!BG785)return 'stop';","function backgroundTick785(){\n if(!BG785)return 'stop';worker787();")
rep("if(!storageReady771)return 'loading';","if(!storageReady771){worker787('학습 저장소 준비 중');return 'loading';}")
rep("try{await scan783();scopeError783='';if(BG785)bgScopeReady785=true}catch(e){scopeError783=String(e.message||e);if(BG785)bgScopeReady785=true;autoStatus771();return}","try{if(BG785)worker787('직접 등록 목록 확인 중');await scan783();scopeError783='';if(BG785){bgScopeReady785=true;worker787('등록 목록 확인 완료')}}catch(e){scopeError783=String(e.message||e);if(BG785){bgScopeReady785=true;worker787('등록 목록 읽기 오류 · '+scopeError783)}autoStatus771();return}")
rep("const status=(s)=>{lastStatus777=String(s||'');paintStatus777()};","const status=(s)=>{lastStatus777=String(s||'');paintStatus777();if(BG785)worker787(lastStatus777);else paint787()};")
rep("if(e.type==='bgStatus785'){bgNative785=e;autoStatus771();return}","if(e.type==='bgStatus785'){bgNative785=e;nativeAt787=Date.now();autoStatus771();paint787();return}")
rep("if(primary){state.lessons[k]=lesson;","if(primary){state.lessons[k]=lesson;saved787(lesson);")
rep("state.lessons=next;return true}","state.lessons=next;saved787(lesson);return true}")
rep("if(toggle)toggle.checked=!!prefs.auto}","if(toggle)toggle.checked=!!prefs.auto;if(!BG785)paint787()}")
rep("d.append(h,body);li.append(d);list.append(li);settings785=","body.prepend(panel787());d.append(h,body);li.append(d);list.append(li);settings785=")
rep("if(d.open){syncSettings785();wake783();autoStatus771();","if(d.open){syncSettings785();wake783();autoStatus771();void refresh787(true);")
rep("if(!BG785){configure785();window.addEventListener('storage'","if(!BG785){configure785();setInterval(()=>{void refresh787()},5000);document.addEventListener('visibilitychange',()=>{if(!document.hidden)void refresh787(true)});window.addEventListener('storage'")
rep("if(e.key===BGREV785||e.key===BGSTATUS785||e.key===BGMODELS785){void reloadForeground785().then(autoStatus771).catch(()=>{})}","if(e.key===LIVE787||e.key===SAVE787){paint787();if(e.key===SAVE787)void refresh787(true)}if(e.key===BGREV785||e.key===BGSTATUS785||e.key===BGMODELS785){void reloadForeground785().then(autoStatus771).catch(()=>{})}")
p.write_text(s)
p=root/'moa-r117-ui.js';p.write_text(p.read_text()+'\n'+Path('experiments/moa-r787/settings-unified.js').read_text())
print('R787 guarded exact R785 patch applied')
