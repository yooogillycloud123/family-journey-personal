'use strict';
const fs=require('fs'),assert=require('assert'),path=require('path');
const sourceRoot=process.env.MOA_R596_SRC||'/mnt/data/moa_r596_work/src';
const js=fs.readFileSync(path.join(sourceRoot,'moa-r483-vertical-calendar.js'),'utf8');
const css=fs.readFileSync(path.join(sourceRoot,'moa-r483-vertical-calendar.css'),'utf8');
const java=fs.readFileSync(path.join(sourceRoot,'MoaR507InlineGalleryProvider.java'),'utf8');
const slice=(start,end)=>{const a=js.indexOf(start),b=js.indexOf(end,a+start.length);assert(a>=0&&b>a,start);return js.slice(a,b)};
function classList(names){const s=new Set(names);return{contains:n=>s.has(n),add:(...ns)=>ns.forEach(n=>s.add(n)),remove:(...ns)=>ns.forEach(n=>s.delete(n)),get all(){return [...s]}}}
let railRendered=0;const tools={hidden:true}, v={hidden:false,classList:classList(['moa-r547-native-owner','moa-r519-native-entering'])};
const ui={open:true,page:'day',date:'2026-11-15',media:[{id:'123'},{id:'124'}],tools:false,rail:false};
const create=new Function('ui','r523DayExiting','view','getState','$','toggleRail','window',slice('function r596ShowWeb(reason){','function r596ScheduleWeb(){')+'\nreturn r596ShowWeb;');
const show=create(ui,false,v,()=>({byId:new Map([['123',{}]]),load:true}),(q)=>q==='.moa-r469-tools'?tools:null,()=>{railRendered++},{})
assert(show('MEDIA_IDS_UNINDEXED')===true);
assert(v.classList.contains('moa-r596-web-ready'));
assert(!v.classList.contains('moa-r547-native-owner')&&!v.classList.contains('moa-r519-native-entering'));
assert(ui.tools===true&&ui.rail===true&&tools.hidden===false&&railRendered===1);
assert(show('REPEAT')===true&&railRendered===1); // do not reset user's later choice
v.classList.add('moa-r507-native-mounted');assert(show('LATE')===false);
assert(js.includes("r596ShowWeb(state?.load?'MEDIA_INDEX_SCANNING':'MEDIA_IDS_UNINDEXED')"));
assert(js.includes("r594RequestIndexOnce();return;"));
assert(js.includes('r596ScheduleWeb();}else view.classList.remove'));
assert(js.includes('if(mounted){view.classList.remove')&&js.includes("else view.classList.remove('moa-r547-native-owner','moa-r519-native-entering')"));
assert(js.includes('window.__moaR596NativePhotoUnready=function(dayToken)'));
assert(js.includes('if(dayToken!==undefined&&Number(dayToken)!==window.__moaR527DayToken)return;'));
assert(js.includes("details.open=true;details.append(elem('summary'"));
assert(js.includes('r592HydrateDay(day)')&&js.includes('IDBKeyRange.bound(lo,hi)'));
assert(js.includes('moments||[]')&&js.includes('note'));
assert(css.includes('#moa-r469-root.moa-r596-web-ready:not(.moa-r507-native-mounted)'));
assert(css.includes('.moa-r469-tools:not([hidden]){')&&css.includes('display:block!important'));
assert(css.includes('pointer-events:auto!important;touch-action:pan-x pan-y!important;'));
assert(java.includes('if(!actualMediaReady(gallery)){\n        nativeHost.setVisibility(View.INVISIBLE);'));
assert(java.includes('window.__moaR596NativePhotoUnready&&window.__moaR596NativePhotoUnready('));
assert(java.includes('window.__moaR507NativeMounted(true,'));
assert(java.includes('deck.setBackgroundColor(Color.TRANSPARENT);'));
assert(java.includes('getBoolean("show_on_open",false)'));
assert(java.includes('putBoolean("rail_expanded",railExpanded).apply()'));
assert(!js.includes('r580PhotoPending')&&!js.includes('r584RecoverGallery'));
console.log('R596 user-saved media / real-native-photo ACK / touch fallback / stale callback / note visibility contracts: PASS');
