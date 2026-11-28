
// R787 UI contract: move existing nodes; never recreate action controls/listeners.
(()=>{'use strict';
if(window.MoaSettings787)return;
const Q='section.page[data-page="settings"]',id=x=>document.getElementById(x);
const el=(t,c,text)=>{const n=document.createElement(t);if(c)n.className=c;if(text!==undefined)n.textContent=text;return n};
const style=el('style');style.id='moa-r787-settings-style';style.textContent=String.raw`
@@{--m787-card:var(--moa-r117-surface,#fff);--m787-border:#d4d8dd;--m787-ink:var(--moa-r117-ink,#25282f);--m787-inner:#f6f7f9;--m787-page:#f3f5f7;--m787-sub:#626c76;background:var(--m787-page)!important;color:var(--m787-ink)!important;padding-bottom:28px!important}
html[data-moa-ui="black"] @@{--m787-border:#514a58;--m787-inner:#302d36;--m787-page:#211e25;--m787-sub:#b6aebd}
@@ .r787-card{list-style:none!important;padding:0!important;margin:0 0 10px!important;border:1px solid var(--m787-border)!important;border-radius:17px!important;background:var(--m787-card)!important;color:var(--m787-ink)!important;box-shadow:0 1px 3px #16192206!important;overflow:hidden!important;min-width:0!important;display:block!important}
@@ .r787-card[hidden]{display:none!important}
@@ .r787-card>.moa-r117-fold,@@ .r787-card>details{border:0!important;border-radius:0!important;background:transparent!important;margin:0!important;padding:0!important;box-shadow:none!important}
@@ .r787-head{width:100%!important;box-sizing:border-box!important;min-height:57px!important;padding:15px 16px!important;display:flex!important;align-items:center!important;justify-content:space-between!important;gap:12px!important;font-size:16px!important;font-weight:750!important;line-height:1.35!important;text-align:left!important;list-style:none!important;cursor:pointer;background:transparent!important;border:0!important;border-radius:0!important;color:var(--m787-ink)!important;box-shadow:none!important}
@@ .r787-head::-webkit-details-marker{display:none!important}
@@ .r787-head::marker{content:''}
@@ .r787-head::after{content:'';box-sizing:border-box;display:block;flex:0 0 9px;width:9px;height:9px;border-top:2px solid currentColor;border-right:2px solid currentColor;opacity:.65;margin-right:3px;transform:rotate(45deg);transition:transform .12s}
@@ details[open]>.r787-head::after,@@ .r787-head[aria-expanded="true"]::after{transform:rotate(135deg)}
@@ .r787-head strong{font-size:inherit!important;font-weight:inherit!important;color:inherit!important}
@@ .r787-head small,@@ .r787-head .moa-r99-subtitle,@@ .r787-head .row-desc,@@ .r787-head .r787-old-arrow{display:none!important}
@@ .r787-head .r787-title,@@ .r787-head .moa-r117-summary-copy,@@ .r787-head .moa-r99-heading-text{flex:1;min-width:0;overflow-wrap:anywhere}
@@ .r787-head .moa-r98-icon{width:34px!important;height:34px!important;flex:0 0 34px!important;border-radius:10px!important}
@@ .r787-body{padding:14px 16px!important;border-top:1px solid var(--m787-border)!important;background:var(--m787-inner)!important;box-sizing:border-box!important;min-width:0!important}
@@ .r787-body[hidden]{display:none!important}
@@ .section-title{font-weight:750!important;color:var(--m787-ink)!important;margin:18px 0 10px!important}
@@ #moa-r681-apk-version{display:flex!important;align-items:center;justify-content:space-between;gap:8px;padding:13px 16px!important;margin:0 0 10px!important;border:1px solid var(--m787-border)!important;border-radius:17px!important;background:var(--m787-card)!important;color:var(--m787-ink)!important}
@@ #moa-r681-apk-version strong{font-weight:750!important}
@@ #moa-r681-apk-version small{font-size:12px!important;color:var(--m787-sub)!important;text-align:right}
@@ #moa-r723-update-row>small{display:none!important}
@@ #moa-r723-update-row>small[data-r787-error]{display:block!important;padding:0 16px 12px!important;color:#b04a4a!important}
@@ #moa-r783-auto-study .moa-r98-controls{display:grid!important;gap:0!important}
@@ #moa-r783-auto-study .moa-r98-control{display:flex!important;align-items:center!important;justify-content:space-between!important;gap:10px!important;min-height:47px!important;padding:8px 0!important;border-bottom:1px solid var(--m787-border);font-size:14px!important;font-weight:600;line-height:1.45}
@@ #moa-r783-auto-study input[type="checkbox"]{flex:0 0 20px!important;width:20px!important;height:20px!important;accent-color:var(--moa-r117-accent-deep,#406957)}
@@ #moa-r783-auto-study select{max-width:60%;min-width:0;width:auto;min-height:42px!important;padding:7px 10px!important;border:1px solid var(--m787-border)!important;border-radius:11px!important;color:var(--m787-ink)!important;background:var(--m787-card)!important;font:inherit!important;font-size:13px!important}
@@ #moa-r783-auto-study .moa-r98-controls>strong{display:block;font-size:15px;margin:16px 0 3px;padding:12px 0 5px;border-top:1px solid var(--m787-border)}
@@ #moa-r783-auto-study .moa-r98-controls>small,@@ #moa-r783-auto-study .moa-r98-controls>p{display:block;margin:8px 0;color:var(--m787-sub);font-size:12px;line-height:1.55;overflow-wrap:anywhere}
@@ #moa-r783-auto-study .moa-r98-controls>button,@@ #moa-r787-status button{min-height:42px!important;padding:9px 12px!important;border:1px solid var(--m787-border)!important;border-radius:11px!important;background:var(--m787-card)!important;color:var(--m787-ink)!important;font-size:13px!important;font-weight:700!important;margin:4px 0!important}
@@ #moa-r602-gallery-diagnostic{padding:10px 0!important;display:grid;gap:6px}
@@ #moa-r602-gallery-diagnostic small,@@ .r787-credit{font-size:11px!important;color:var(--m787-sub)!important;line-height:1.6}
@@ .r787-inner-row .row-desc{display:none!important}
@@ .r787-inner-row .row-title{font-weight:700!important}
@@ .r787-inner-row{background:var(--m787-card)!important;border:1px solid var(--m787-border)!important;border-radius:12px!important;margin:6px 0!important}
@media(max-width:360px){@@ .r787-head{padding:13px!important;font-size:15px!important}@@ #moa-r783-auto-study .moa-r98-control{font-size:13px!important}}
`.replaceAll('@@',Q);document.head.append(style);
function cls(n,c){if(n&&!n.classList.contains(c))n.classList.add(c)}
function attr(n,k,v){if(n&&n.getAttribute(k)!==v)n.setAttribute(k,v)}
function head(h){if(!h)return;cls(h,'r787-head');
 for(const x of h.querySelectorAll('.moa-r117-arrow,.moa-r99-chevron,.moa-icon-theme-arrow,.moa-icon-theme-chevron,.chev'))cls(x,'r787-old-arrow');
 const last=h.lastElementChild;if(last&&/^[›>⌄▾▴▼▲⌃〉]$/.test(last.textContent.trim()))cls(last,'r787-old-arrow');
 if(!h.childElementCount&&h.textContent.trim()){const t=h.textContent;h.textContent='';h.append(el('span','r787-title',t))}
}
function fold(d){const h=d.querySelector(':scope > summary');if(!h)return;head(h);for(const n of d.children)if(n!==h)cls(n,'r787-body');const p=d.parentElement;cls(p?.classList.contains('moa-r117-fold')?p.parentElement:p?.matches('li')?p:d,'r787-card')}
function buttonFold(k,hs,ps){const c=id(k),h=c?.querySelector(hs),p=c?.querySelector(ps);if(!h||!p)return;cls(c,'r787-card');head(h);cls(p,'r787-body');attr(h,'aria-expanded',String(!p.hidden))}
function calendar(){const c=id('moa-r495-scroll-setting');if(!c||c.querySelector(':scope > details'))return;const title=c.querySelector('.moa-r495-scroll-label');if(!title)return;const d=el('details'),h=el('summary'),body=el('div','r787-body');h.append(title);for(const n of Array.from(c.childNodes))body.append(n);d.append(h,body);c.append(d);d.open=false}
function order(s){const top=s.querySelector(':scope > ul.rows'),v=id('moa-r681-apk-version'),u=id('moa-r723-update-row');if(top&&v?.parentElement===top&&top.firstElementChild!==v)top.prepend(v);if(top&&v?.parentElement===top&&u?.parentElement===top&&v.nextElementSibling!==u)v.after(u);if(u){cls(u,'r787-card');head(u.querySelector(':scope > button'));const a=u.querySelector(':scope > small');if(a&&a.textContent!=='현재 설치 버전 및 최신 배포 확인 · 기존 기록 유지')attr(a,'data-r787-error','1')}
 const p=id('moa-r117-photo-settings')?.querySelector('.moa-r117-inner-rows'),g=id('moa-r602-gallery-diagnostic');if(g&&p&&g.parentElement!==p)p.append(g);
 const help=id('moa-r117-help-group')?.querySelector('.moa-r117-fold-content');if(help)for(const p of s.querySelectorAll(':scope > p.caption'))if(p.textContent.includes('Natural Earth')){cls(p,'r787-credit');help.append(p)}
}
let queued=false,wasVisible=false;
function normalize(){queued=false;const s=document.querySelector(Q);if(!s)return;calendar();order(s);for(const d of s.querySelectorAll('details'))fold(d);
 buttonFold('moa-r215-quick-popup-settings','.moa-r215-title','.moa-r215-panel');buttonFold('moa-r231-naver-settings','.r231-title','.r231-content');
 const sy=id('moa-r715-sync-row');if(sy){cls(sy,'r787-card');head(id('moa-r711-sync-button'));cls(id('moa-r713-sync-modal'),'r787-body')}
 for(const n of s.querySelectorAll('.moa-r117-inner-rows>li.row'))cls(n,'r787-inner-row');
 const visible=!s.hidden&&s.getAttribute('aria-hidden')!=='true';if(!visible&&wasVisible){for(const d of s.querySelectorAll('details[open]'))d.open=false;for(const k of ['moa-r215-quick-popup-settings','moa-r231-naver-settings']){const h=id(k)?.querySelector('.moa-r215-title,.r231-title');if(h?.getAttribute('aria-expanded')==='true')h.click()}}wasVisible=visible
}
function queue(){if(!queued){queued=true;requestAnimationFrame(normalize)}}
window.MoaSettings787={normalize};
function start(){normalize();const s=document.querySelector(Q);if(s){new MutationObserver(queue).observe(s,{subtree:true,childList:true,attributes:true,attributeFilter:['open','hidden','aria-expanded','aria-hidden']});s.addEventListener('click',queue,true)}}
if(document.readyState==='loading')document.addEventListener('DOMContentLoaded',start,{once:true});else start();
})();
