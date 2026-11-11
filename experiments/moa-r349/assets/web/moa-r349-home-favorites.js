/* MOA R349 feature fork from immutable R345. Floating one-tap Diary home and per-record NAVER preference UX.
 * No changes to existing R345 NAVER frame agent, DEX, voice files, Gallery or DB schema.
 */
(()=>{'use strict';
const KEY='moa.r349.user.prefs.v1', POSKEY='moa.r349.home.positions.v1';
const defaults={homeEnabled:true,homeSize:54,homeOpacity:0.9,homeLocked:true,homeSnap:false,homeIdle:true,homeIdleSec:6,homeTiny:18,naverFolder:'내 장소',naverMode:'offscreen',quickCheck:true};
const $=(s,root=document)=>root.querySelector(s);
const clamp=(v,a,b)=>Math.max(a,Math.min(b,v));
const read=()=>{try{const raw=localStorage.getItem(KEY);const x=JSON.parse(raw||'{}')||{};if(!raw){const prior=String(localStorage.getItem('fj.naver.targetlist')||'').trim();if(prior)x.naverFolder=prior.slice(0,70);}return {...defaults,...x};}catch(_){return {...defaults}}};
let pref=read(),floating=null,tiny=false,editing=false,idleTimer=0,gesture=null,hold=0,lastAction=0;
let pos={portrait:{x:12,y:0.48},landscape:{x:12,y:0.40}};
try{const p=JSON.parse(localStorage.getItem(POSKEY)||'{}');pos={...pos,...p}}catch(_){}
const orient=()=>innerWidth>innerHeight?'landscape':'portrait';
function write(){localStorage.setItem(KEY,JSON.stringify(pref));window.MoaR349Prefs={...pref};dispatchEvent(new CustomEvent('moa:r349-prefs-changed',{detail:{...pref}}));}
function savePos(){localStorage.setItem(POSKEY,JSON.stringify(pos));}
function setP(k,value){pref[k]=value;write();apply();if(['homeIdle','homeIdleSec','homeEnabled','homeSize','homeTiny'].includes(k))touch();}
window.MoaR349Prefs={...pref};
function coords(){const d=pos[orient()]||pos.portrait;const size=tiny?pref.homeTiny:pref.homeSize;return {x:clamp(d.x,0,Math.max(0,innerWidth-size)),y:clamp(d.y*innerHeight,8,Math.max(8,innerHeight-size-70))};}
function apply(){if(!floating)return;floating.hidden=!pref.homeEnabled;if(floating.hidden)return;
 const size=tiny&&!editing?pref.homeTiny:pref.homeSize;const p=coords();floating.style.width=size+'px';floating.style.height=size+'px';floating.style.left=p.x+'px';floating.style.top=p.y+'px';floating.style.opacity=String(tiny&&!editing?Math.min(.7,pref.homeOpacity):pref.homeOpacity);
 floating.classList.toggle('moa-r349-tiny',tiny&&!editing);floating.classList.toggle('moa-r349-editing',editing);
 floating.setAttribute('aria-label',tiny?'홈 바로가기 펼치기':editing?'홈 버튼 이동·크기 편집 중':'일기 달력 홈으로 바로 이동');
 const title=$('.moa-r349-status',floating);if(title)title.textContent=editing?'이동·크기 조절':(tiny?'':'일기 달력 홈');}
function touch(){clearTimeout(idleTimer);if(!editing&&pref.homeIdle&&pref.homeEnabled)idleTimer=setTimeout(()=>{tiny=true;apply()},clamp(Number(pref.homeIdleSec)||6,1,180)*1000);}
function awake(){tiny=false;apply();touch();}
function moveTo(x,y){const size=pref.homeSize;const px=clamp(x,0,Math.max(0,innerWidth-size)),py=clamp(y,6,Math.max(6,innerHeight-size-70));pos[orient()]={x:px,y:py/innerHeight};apply();}
function home(){
 const diary=window.FamilyJourneyDiary;
 const state=diary?.state;
 if(state?.editing&&state?.dirty&&!confirm('저장하지 않은 일기 수정 내용이 있습니다. 저장하지 않고 달력 홈으로 이동할까요?'))return false;
 try{window.MoaVoicePlaybackUI?.stop?.()}catch(_){}
 // Close independent overlays with their own controls; do not simulate repeated Android Back.
 for(const [sel,btn] of [['#viewer-root','#viewer-close'],['#place-root','#place-close'],['#map-root','#map-close'],['#place-detail','#pd-back'],['#sheet-root','#sheet-close']]){
  const layer=$(sel);if(!layer||layer.hidden)continue;try{$(btn)?.click()}catch(_){ }if(!layer.hidden&&layer.isConnected)layer.hidden=true;
 }
 for(const sel of ['#fj-naver-photo-full','#fj-naver-photo-sheet']){$(sel)?.remove();}
 try{if(typeof diary?.open==='function'){diary.open();return true}}catch(e){console.warn('MOA home diary open',e)}
 const btn=$('#tabbar [data-tab="diary"]');if(btn){btn.click();return true}return false;
}
function createFloat(){if(floating||!document.body)return;const n=document.createElement('div');n.id='moa-r349-home-float';n.setAttribute('role','button');n.tabIndex=0;
 n.innerHTML='<svg class="moa-r349-home-icon" viewBox="0 0 24 24" width="25" height="25" aria-hidden="true"><path d="M3.5 11 12 4l8.5 7v8a1.5 1.5 0 0 1-1.5 1.5h-5v-6h-4v6H5A1.5 1.5 0 0 1 3.5 19z" fill="none" stroke="currentColor" stroke-width="1.9" stroke-linecap="round" stroke-linejoin="round"/></svg><span class="moa-r349-status"></span><span class="moa-r349-edit-close" title="위치 고정" aria-hidden="true">✓</span>';
 n.addEventListener('contextmenu',e=>e.preventDefault());n.addEventListener('pointerdown',onDown);n.addEventListener('pointermove',onMove);n.addEventListener('pointerup',onUp);n.addEventListener('pointercancel',onCancel);
 n.addEventListener('keydown',e=>{if(e.key==='Enter'||e.key===' '){e.preventDefault();onTap();}});
 document.body.append(n);floating=n;apply();touch();
}
function onDown(e){if(e.button!==0)return;gesture={id:e.pointerId,x:e.clientX,y:e.clientY,origin:coords(),startSize:pref.homeSize,moved:false,resize:!!e.target.closest('.moa-r349-handle'),handle:e.target.closest('.moa-r349-handle')?.dataset.handle||'',held:false};clearTimeout(idleTimer);clearTimeout(hold);try{floating.setPointerCapture(e.pointerId)}catch(_){}
 if(!editing)hold=setTimeout(()=>{if(!gesture||gesture.moved)return;editing=true;pref.homeLocked=false;write();tiny=false;gesture.held=true;apply();},550);
}
function onMove(e){if(!gesture||gesture.id!==e.pointerId)return;const dx=e.clientX-gesture.x,dy=e.clientY-gesture.y;if(Math.abs(dx)+Math.abs(dy)>8){gesture.moved=true;clearTimeout(hold)}
 if(!editing)return;
 if(gesture.resize){const h=gesture.handle;const dirs=[];if(h.includes('e'))dirs.push(dx);if(h.includes('w'))dirs.push(-dx);if(h.includes('s'))dirs.push(dy);if(h.includes('n'))dirs.push(-dy);const delta=dirs.reduce((a,b)=>a+b,0)/Math.max(1,dirs.length);const size=clamp(Math.round(gesture.startSize+delta),32,104);const change=size-gesture.startSize;pref.homeSize=size;write();if(h.includes('w')||h.includes('n'))moveTo(gesture.origin.x-(h.includes('w')?change:0),gesture.origin.y-(h.includes('n')?change:0));else apply();return;}
 if(gesture.moved)moveTo(gesture.origin.x+dx,gesture.origin.y+dy);
}
function onUp(e){if(!gesture||e.pointerId!==gesture.id)return;clearTimeout(hold);const d=gesture;gesture=null;
 if(d.moved||d.held){if(pref.homeSnap&&editing){const p=coords();moveTo(p.x<innerWidth/2?6:innerWidth-pref.homeSize-6,p.y)}savePos();touch();return}
 onTap();}
function onCancel(){clearTimeout(hold);gesture=null;touch()}
function onTap(){if(!floating||!pref.homeEnabled)return;if(editing){editing=false;pref.homeLocked=true;write();awake();return}if(tiny){awake();return}const now=Date.now();if(now-lastAction<300)return;lastAction=now;home();touch()}
function css(){if($('#moa-r349-css'))return;const s=document.createElement('style');s.id='moa-r349-css';s.textContent=`
#moa-r349-home-float{position:fixed!important;z-index:2147483000!important;display:flex;justify-content:center;align-items:center;flex-direction:column;background:rgba(255,255,255,.96);border:1.5px solid #daaac1;box-shadow:0 4px 17px rgba(50,40,60,.22);border-radius:50%;box-sizing:border-box;color:#bb2b70;touch-action:none!important;user-select:none;-webkit-user-select:none;cursor:pointer;overflow:visible;}
#moa-r349-home-float[hidden]{display:none!important}#moa-r349-home-float .moa-r349-status{font-size:8px;line-height:1.1;text-align:center;max-width:90%;white-space:nowrap;pointer-events:none}#moa-r349-home-float.moa-r349-tiny{border-width:1px;background:#bf3877;box-shadow:0 2px 8px #0002}#moa-r349-home-float.moa-r349-tiny svg,#moa-r349-home-float.moa-r349-tiny .moa-r349-status{display:none}#moa-r349-home-float.moa-r349-editing{outline:2px dashed #c62e70;background:#fff2f9}#moa-r349-home-float .moa-r349-edit-close{display:none;position:absolute;right:-7px;top:-8px;width:20px;height:20px;border-radius:50%;background:#b92f68;color:white;text-align:center;font:14px/20px sans-serif}#moa-r349-home-float.moa-r349-editing .moa-r349-edit-close{display:block}
#moa-r349-home-float .moa-r349-handle{position:absolute;display:none;width:13px;height:13px;border:2px solid white;border-radius:50%;background:#b92f68;touch-action:none;box-shadow:0 0 0 1px #bd357a}
#moa-r349-home-float.moa-r349-editing .moa-r349-handle{display:block}
.moa-r349-settings{padding:0!important;margin:10px 0!important;border:1px solid #eee0e7!important;border-radius:20px!important;overflow:hidden;background:#fff!important;color:#292532!important}
.moa-r349-settings summary{list-style:none;display:flex;align-items:center;justify-content:space-between;gap:10px;padding:18px!important;font-size:16px;font-weight:750;cursor:pointer}.moa-r349-settings summary::-webkit-details-marker{display:none}.moa-r349-settings summary small{display:block;margin-top:4px;font-size:12px;color:#857781;font-weight:400}.moa-r349-settings .r349-fields{padding:10px 16px 18px;border-top:1px solid #f3e8ed;display:grid;gap:13px;font-size:13px}.moa-r349-settings label{display:flex;align-items:center;justify-content:space-between;gap:9px;min-height:38px}.moa-r349-settings input[type=checkbox]{width:20px;height:20px;accent-color:#b72368}.moa-r349-settings input:not([type=checkbox]):not([type=range]),.moa-r349-settings select{padding:8px;border-radius:9px;border:1px solid #d8cfd6;background:#fff;color:#222;min-width:0;max-width:65%;font:inherit}.moa-r349-settings input[type=range]{width:55%}.moa-r349-settings .r349-note{color:#83717b;font-size:11px;line-height:1.45}.moa-r349-settings button{background:#f7eaf0;color:#8d2057;padding:9px 11px;border:0;border-radius:10px;font-weight:700}
`;document.head.append(s);}
function make(tag,txt){const e=document.createElement(tag);if(txt!==undefined)e.textContent=txt;return e}
function card(id,title,subtitle){const d=make('details');d.id=id;d.className='moa-r349-settings';const sum=make('summary');const left=make('span');left.textContent=title;left.append(make('small',subtitle));sum.append(left,make('span','⌄'));d.append(sum);const area=make('div');area.className='r349-fields';d.append(area);return {d,area}}
function switcher(area,name,k){const row=make('label');const title=make('span',name);const v=make('input');v.type='checkbox';v.checked=!!pref[k];v.addEventListener('change',()=>setP(k,v.checked));row.append(title,v);area.append(row);return v}
function range(area,name,k,min,max,step,unit=''){const row=make('label');const title=make('span',name);const input=make('input');input.type='range';Object.assign(input,{min:String(min),max:String(max),step:String(step),value:String(pref[k])});const out=make('span',pref[k]+unit);input.addEventListener('input',()=>{out.textContent=input.value+unit;setP(k,Number(input.value))});row.append(title,input,out);area.append(row)}
function settings(){const page=$('section.page[data-page="settings"]');if(!page)return;const app=Array.from(page.querySelectorAll('.section')).find(x=>x.querySelector('.section-title')?.textContent.trim()==='앱');const list=app?.querySelector('.rows')||page.querySelector(':scope > ul.rows');if(!list)return;
 if(!$('#moa-r349-home-settings')){
  const c=card('moa-r349-home-settings','홈 바로가기 버튼','AssistiveTouch형 · 모든 탭에서 달력으로 바로 이동');switcher(c.area,'홈 버튼 사용','homeEnabled');switcher(c.area,'사용하지 않을 때 작게 축소','homeIdle');range(c.area,'자동 축소까지 대기','homeIdleSec',1,120,1,'초');range(c.area,'원형 버튼 크기','homeSize',32,104,2,'px');range(c.area,'축소 크기','homeTiny',12,30,2,'px');range(c.area,'투명도','homeOpacity',.45,1,.05,'');switcher(c.area,'위치 고정 (길게 눌러 편집 시 해제)','homeLocked');switcher(c.area,'가장자리 자동 정렬','homeSnap');const row=make('div');const reset=make('button','위치 · 크기 초기화');reset.type='button';reset.onclick=()=>{pos={portrait:{x:12,y:.48},landscape:{x:12,y:.40}};savePos();setP('homeSize',54);apply()};row.append(reset);c.area.append(row);{const note=make('p','버튼을 0.55초 길게 누르면 편집. 원형 버튼을 끌어서 이동하고 주변 작은 점을 끌어 크기를 조절해요. 편집 중 가운데를 누르면 위치가 고정돼요. 축소 상태는 첫 탭에 펼쳐지고 다음 탭에 홈으로 이동합니다.');note.className='r349-note';c.area.append(note);}list.prepend(c.d);
 }
 if(!$('#moa-r349-naver-settings')){
  const c=card('moa-r349-naver-settings','네이버 즐겨찾기','기본 리스트 지정 · 비점유/화면 보며 저장');const row=make('label');row.append(make('span','기본 저장 리스트'));const input=make('input');input.value=pref.naverFolder;input.maxLength=70;input.setAttribute('aria-label','기본 네이버 저장 리스트 이름');input.setAttribute('list','moa-r349-known-folders');const names=new Set(['내 장소']);try{const saved=JSON.parse(localStorage.getItem('familyjourney.naver.precise.v2')||'{}');for(const x of Object.values(saved))if(x?.list&&String(x.list).length<=70)names.add(String(x.list))}catch(_){}const suggestions=make('datalist');suggestions.id='moa-r349-known-folders';for(const name of names){const op=make('option');op.value=name;suggestions.append(op)}row.append(input,suggestions);c.area.append(row);
  const applyFolder=make('button','입력한 리스트를 기본으로 지정');applyFolder.type='button';applyFolder.onclick=()=>{const x=input.value.trim();if(!x||x.length>70)return;setP('naverFolder',x);localStorage.setItem('fj.naver.targetlist',x);applyFolder.textContent='기본 리스트 지정됨 ✓'};c.area.append(applyFolder);
  {const note=make('p','최초 기본값만 내 장소입니다. 사용자가 직접 지정한 리스트가 다음 기록의 기본값이 되며, 기록마다 별도로 바꿀 수 있어요. 실제 네이버 계정에 존재하는 리스트인지 저장할 때 확인합니다.');note.className='r349-note';c.area.append(note);}
  const modeRow=make('label');modeRow.append(make('span','기본 저장 방식'));const mode=make('select');[['offscreen','비점유 자동저장'],['visible','화면 보며 저장']].forEach(([v,n])=>{const o=make('option',n);o.value=v;mode.append(o)});mode.value=pref.naverMode;mode.addEventListener('change',()=>setP('naverMode',mode.value));modeRow.append(mode);c.area.append(modeRow);
  switcher(c.area,'바로기록 · 네이버 저장 기본 체크','quickCheck');const openWeb=make('button','네이버 웹 화면 직접 열기 (로그인 확인)');openWeb.type='button';openWeb.onclick=()=>{const b=window.MoaMomentNative;if(b?.naverWebProbeControl){try{b.naverWebProbeControl('visible')}catch(_){}}};c.area.append(openWeb);
  {const note=make('p','비점유 저장은 웹 화면을 자동으로 전면 표시하지 않습니다. 웹 연결이 사라지거나 로그인이 만료됐다면 현재 기록을 남기고 수동 로그인 안내만 표시합니다.');note.className='r349-note';c.area.append(note);}
  list.prepend(c.d);
 }
}
function installHandles(){if(!floating||$('.moa-r349-handle',floating))return;for(const [i,x,y] of [['n',.5,0],['ne',1,0],['e',1,.5],['se',1,1],['s',.5,1],['sw',0,1],['w',0,.5],['nw',0,0]]){const h=make('span');h.className='moa-r349-handle';h.dataset.handle=i;h.style.left=`calc(${x*100}% - 7px)`;h.style.top=`calc(${y*100}% - 7px)`;floating.append(h)}}
function main(){css();createFloat();installHandles();settings();window.addEventListener('resize',()=>{apply();touch()},{passive:true});document.addEventListener('visibilitychange',()=>{if(!document.hidden)apply()});
 // Settings can be rerendered dynamically; avoid frame-by-frame polling.
 new MutationObserver(()=>{if(!$('#moa-r349-naver-settings'))settings();if(!floating?.isConnected){floating=null;createFloat();installHandles()}}).observe(document.body,{subtree:true,childList:true});
}
if(document.readyState==='loading')document.addEventListener('DOMContentLoaded',main,{once:true});else main();
})();
