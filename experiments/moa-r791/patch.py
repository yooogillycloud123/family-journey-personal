from pathlib import Path
import sys
p=Path(sys.argv[1]);s=p.read_text()
a="padding-bottom:28px!important"
b="padding-bottom:max(calc(var(--cta-h,56px) + 36px + env(safe-area-inset-bottom,0px)),calc(var(--moa-settings-tabbar-height791,76px) + 16px))!important"
assert s.count(a)==1
s=s.replace(a,b)
# The original document scroller is preserved. Measure only the fixed bottom navigation;
# never auto-scroll, move controls, or change any other screen.
s+=r"""
// R791: Settings only — reserve measured fixed tabbar height plus comfortable clearance.
(()=>{
'use strict';
const Q='section.page[data-page="settings"]';
let bar=null,observer=null,queued=false;
function update(){
 queued=false;
 const page=document.querySelector(Q),next=document.getElementById('tabbar');
 if(next!==bar){if(observer)observer.disconnect();bar=next;if(bar&&typeof ResizeObserver==='function'){observer=new ResizeObserver(queue);observer.observe(bar)}}
 if(!page||!bar||bar.hidden)return;
 const rect=bar.getBoundingClientRect();
 if(rect.height<=0)return;
 const h=Math.ceil(Math.max(rect.height,window.innerHeight-rect.top));
 const value=h+'px';
 if(page.style.getPropertyValue('--moa-settings-tabbar-height791')!==value)page.style.setProperty('--moa-settings-tabbar-height791',value);
}
function queue(){if(!queued){queued=true;requestAnimationFrame(update)}}
function start(){
 queue();window.addEventListener('resize',queue,{passive:true});window.visualViewport?.addEventListener('resize',queue,{passive:true});
 const app=document.getElementById('app');if(app)new MutationObserver(queue).observe(app,{subtree:true,childList:true,attributes:true,attributeFilter:['hidden']});
}
if(document.readyState==='loading')document.addEventListener('DOMContentLoaded',start,{once:true});else start();
})();
"""
p.write_text(s)
