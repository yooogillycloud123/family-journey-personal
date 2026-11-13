/* MOA R469 | R463 Golden-additive, one shared diary/MediaStore/voice storage, UI-only additions.
 * No new IndexedDB schema; never replaces native Gallery DEX or original audio functions.
 */
(()=>{'use strict';
const KEY='moa.r469.view.v1', DB='familyjourney-diary-v1', coverKey='calendar-covers-r29';
const getState=()=>window.FamilyJourneyDiary?.state;
const $=(q,r=document)=>r.querySelector(q);
const valid=d=>/^\d{4}-(0[1-9]|1[0-2])-(0[1-9]|[12]\d|3[01])$/.test(d||'')&&Number.isFinite(new Date(d+'T12:00:00').getTime())&&dayOf(new Date(d+'T12:00:00'))===d;
const dayOf=d=>{const x=new Date(d);return `${x.getFullYear()}-${String(x.getMonth()+1).padStart(2,'0')}-${String(x.getDate()).padStart(2,'0')}`;};
const safeMedia=id=>/^(?:[0-9]{1,19}|v[0-9]{1,18})$/.test(String(id));
const isVideo=p=>!!p&&(p.video===true||String(p.id).startsWith('v'));
const dateLabel=d=>new Date(d+'T12:00:00').toLocaleDateString('ko-KR',{year:'numeric',month:'long',day:'numeric',weekday:'short'});
let ui={source:'curated',audioPlaying:false,open:false,page:'calendar',selected:dayOf(Date.now()),month:new Date(new Date().getFullYear(),new Date().getMonth(),1),date:'',media:[],idx:0,fast:false,tools:false,rail:false,info:false,clip:0,clips:[],dirty:false,photoToken:0,gesture:null,dragTarget:null,videoFallback:false,requestGeneration:0};
let view=null, observer=null, pending=0, backInstalled=false;
let r475ExitUntilHidden=false, r475AutostartScheduled=false, r475CalendarRefreshPending=false, r475LastDataKey='';

const elem=(tag,cls,txt)=>{const x=document.createElement(tag);if(cls)x.className=cls;if(txt!==undefined)x.textContent=txt;return x};
const btn=(label,action,cls)=>{const x=elem('button',cls,label);x.type='button';if(action)x.addEventListener('click',action);return x};
function notify(msg){const x=$('.moa-r469-status',view);if(x)x.textContent=String(msg||'');}
function nativePost(op,payload){try{if(typeof window.NativeHost?.post==='function'){window.NativeHost.post(op,JSON.stringify(payload));return true}}catch(e){}return false;}
function diaryRoot(){return document.getElementById('fj-diary-root');}
function db(){return new Promise((resolve,reject)=>{const r=indexedDB.open(DB,2);r.onsuccess=()=>resolve(r.result);r.onerror=()=>reject(r.error);r.onblocked=()=>reject(Error('기존 일기 저장소 사용 중'));});}
async function stored(table,key){const d=await db();try{return await new Promise((resolve,reject)=>{const r=d.transaction(table,'readonly').objectStore(table).get(key);r.onsuccess=()=>resolve(r.result||null);r.onerror=()=>reject(r.error);});}finally{d.close();}}
async function persist(table,key,record){const d=await db();try{await new Promise((resolve,reject)=>{const tx=d.transaction(table,'readwrite'),st=tx.objectStore(table);table==='curated'||table==='entries'?st.put(record):st.put(record,key);tx.oncomplete=resolve;tx.onerror=()=>reject(tx.error);});}finally{d.close();}}
async function mergeDiaryBody(day,body,table){if(!['curated','entries'].includes(table))throw Error('unsupported diary table');const d=await db();try{return await new Promise((resolve,reject)=>{
 const tx=d.transaction(table,'readwrite'),store=tx.objectStore(table);let result=null;
 const get=store.get(day);get.onsuccess=()=>{const original=get.result||{day,selectionMode:'manual',title:'',tags:[],feeling:'',activities:{},photoIds:[],moments:[]};
  result={...original,day,body,selectionMode:original.selectionMode||'manual',updatedAt:Date.now(),source:original.source||'owner'};
  store.put(result);};get.onerror=()=>{try{tx.abort()}catch(_){}};
 tx.oncomplete=()=>resolve(result);tx.onerror=()=>reject(tx.error);tx.onabort=()=>reject(tx.error||Error('record transaction aborted'));
 });}finally{d.close();}}

function dayEntry(day){return getState()?.curatedEntries?.get(day)||null;}
function mediaFor(day){const s=getState();if(!s)return [];
 const entry=s.curatedEntries?.get(day),hidden=new Set((entry?.removedMediaIds||[]).map(String));
 const curated=Array.isArray(entry?.photoIds)?entry.photoIds.map(String).filter(id=>safeMedia(id)&&!hidden.has(id)):[];
 const all=[...(s.byDay?.get(day)||[]),...(s.byVideoDay?.get(day)||[])];
 const byId=new Map(all.map(p=>[String(p.id),p]));
 const selected=curated.map(id=>s.byId?.get(id)||byId.get(id)||({id,t:Date.parse(day+'T12:00:00'),video:id.startsWith('v'),approx:true}));
 return (ui.source==='automatic'?all.filter(p=>!hidden.has(String(p.id))):selected)
   .filter(p=>safeMedia(p.id)).sort((a,b)=>(Number(a.t)||0)-(Number(b.t)||0));
}
function mainCover(day,media){const s=getState();const preferred=String(s?.covers?.[ui.source]?.[day]||'');return media.find(x=>String(x.id)===preferred)||media[0]||null;}
let r475ScheduleCache=[];
function r475Events(day){try{const f=window.MoaFamilySchedule;const e=f?.ready?f.visibleEvents:r475ScheduleCache;return Array.isArray(e)?e.filter(x=>x?.date===day):[]}catch(_){return []}}
function r475UpdateFamilyDom(){
 if(!ui.open||!view)return;
 for(const tile of view.querySelectorAll('.moa-r469-date')){
  const day=(tile.getAttribute('aria-label')||'').slice(0,10);
  const has=r475Events(day).length>0, dot=tile.querySelector('.moa-r475-event-mark');
  if(has&&!dot){const node=elem('span','moa-r475-event-mark');node.setAttribute('aria-label','가족 일정 있음');tile.append(node)}
  if(!has&&dot)dot.remove();
 }
 const panel=$('.moa-r475-family',view);if(!panel||ui.page!=='day')return;
 const events=r475Events(ui.date),header=panel.querySelector('.moa-r475-family-top span');
 if(header)header.textContent='가족 일정'+(events.length?' · '+events.length:'');
 panel.querySelector('.moa-r475-family-list')?.remove();
 if(events.length){const list=elem('div','moa-r475-family-list');
  for(const ev of events){const row=elem('div','moa-r475-family-item');row.append(elem('span','moa-r475-family-time',String(ev?.allDay?'종일':ev?.start||'')),elem('span','',String(ev?.title||'일정')));list.append(row)}
  panel.append(list);
 }
}
async function r475RefreshFamily(){
 try{
  const f=window.MoaFamilySchedule;
  if(f?.ready){r475ScheduleCache=f.visibleEvents||[];r475UpdateFamilyDom();return}
  // Avoid opening a nonexistent DB at version 1, which would break original onupgradeneeded schema creation.
  if(typeof indexedDB?.databases!=='function')return;
  const names=await indexedDB.databases();if(!names.some(x=>x.name==='moa-family-calendar-v1'))return;
  const d=await new Promise((resolve,reject)=>{const q=indexedDB.open('moa-family-calendar-v1');q.onsuccess=()=>resolve(q.result);q.onerror=()=>reject(q.error)});
  try{
   if(!d.objectStoreNames.contains('events'))return;
   r475ScheduleCache=await new Promise((resolve,reject)=>{const req=d.transaction('events','readonly').objectStore('events').getAll();req.onsuccess=()=>resolve(req.result||[]);req.onerror=()=>reject(req.error)});
  }finally{d.close()}
  r475UpdateFamilyDom();
 }catch(e){console.debug('R475 family read-only unavailable',String(e))}
}
const r472Cache=new Map();
let r472ThumbRetryTimer=0;
function r472Cached(id,size){return r472Cache.get(size+':'+id)||r472Cache.get('400:'+id)||r472Cache.get('250:'+id)||r472Cache.get('130:'+id)||null;}
function r472Store(id,size,data){if(typeof data!=='string'||!data.startsWith('data:image/'))return;
 const key=size+':'+id;r472Cache.delete(key);r472Cache.set(key,data);
 while(r472Cache.size>22)r472Cache.delete(r472Cache.keys().next().value);
}
function r472Paint(node,src){if(!node?.isConnected||!src?.startsWith('data:image/'))return;
 if(node.src!==src){node.onerror=()=>{node.classList.remove('moa-r472-image-ready');node.removeAttribute('src');r472ScheduleRetry()};node.src=src;node.classList.add('moa-r472-image-ready');}
}
function r472ScheduleRetry(){if(r472ThumbRetryTimer||!ui.open||document.hidden)return;
 r472ThumbRetryTimer=setTimeout(()=>{r472ThumbRetryTimer=0;
  if(!ui.open||document.hidden)return;
  const missing=[...view.querySelectorAll('img[data-id]')].filter(x=>{
   if(!x.isConnected||Number(x.dataset.tries||0)>=6)return false;
   const slide=x.closest('.moa-r472-slide');
   if(slide&&Math.abs(Number(slide.dataset.idx)-ui.idx)>5)return false;
   return !x.classList.contains('moa-r472-image-ready')||!!slide&&!x.dataset.fullLoaded;
  });
  if(missing.length){const large=missing.filter(x=>x.closest('.moa-r472-slide'));
   const small=missing.filter(x=>!x.closest('.moa-r472-slide'));
   if(large.length)fillImages(large,true);if(small.length)fillImages(small,false);}

 },1600);
}
async function fillImages(targets,large=false){
 if(!targets?.length||!view)return;
 const size=large?1024:260;
 const get=window.__requestThumbs;
 const grouped=new Map();
 for(const node of targets){
  if(!node.isConnected||!safeMedia(node.dataset.id))continue;
  node.alt='';const id=node.dataset.id;
  const cached=r472Cached(id,size);
  if(cached)r472Paint(node,cached);
  if(cached&&(!large||r472Cache.has('1024:'+id)))continue
  if(Number(node.dataset.tries||0)>=6)continue;
  node.dataset.tries=String(Number(node.dataset.tries||0)+1);
  if(!grouped.has(id))grouped.set(id,[]);
  grouped.get(id).push(node);
 }
 if(!grouped.size)return;
 if(typeof get!=='function'){r472ScheduleRetry();return;}
 const keys=[...grouped.keys()];
 for(let i=0;i<keys.length;i+= (large?3:12)){
  const ids=keys.slice(i,i+(large?3:12));let got;
  const accept=got=>{for(const id of ids){const img=got instanceof Map?got.get(id):got?.[id];
   if(img?.startsWith('data:image/')){
    r472Store(id,size,img);
    for(const node of grouped.get(id)||[])if(node.dataset.id===id){r472Paint(node,img);if(large)node.dataset.fullLoaded='1';}
   }
  }};
  let completed=false;
  const task=Promise.resolve().then(()=>get(ids,size)).then(x=>{completed=true;accept(x)}).catch(()=>{completed=true});
  await Promise.race([task,new Promise(resolve=>setTimeout(resolve,2500))]);
  if(!completed)r472ScheduleRetry();
 }
 const missed=[...grouped.values()].flat().filter(x=>x.isConnected&&(!x.classList.contains('moa-r472-image-ready')||large&&!x.dataset.fullLoaded));
 if(missed.length)r472ScheduleRetry();
}
function r472RefreshVisibleThumbs(){if(!ui.open||!view||view.hidden)return;
 const missing=[...view.querySelectorAll('img[data-id]')].filter(x=>{
  if(!x.isConnected||Number(x.dataset.tries||0)>=6)return false;
  const slide=x.closest('.moa-r472-slide');
  if(slide&&Math.abs(Number(slide.dataset.idx)-ui.idx)>5)return false;
  return !x.classList.contains('moa-r472-image-ready')||!!slide&&!x.dataset.fullLoaded;
 });
 if(missing.length){const large=missing.filter(x=>x.closest('.moa-r472-slide'));
  const small=missing.filter(x=>!x.closest('.moa-r472-slide'));
  if(large.length)fillImages(large,true);if(small.length)fillImages(small,false);}

}
window.addEventListener('pageshow',()=>{setTimeout(r472RefreshVisibleThumbs,200)},{passive:true});
document.addEventListener('visibilitychange',()=>{if(!document.hidden)setTimeout(r472RefreshVisibleThumbs,300)},{passive:true});

function mount(){if(view)return view;const n=elem('section','moa-r469-root');n.id='moa-r469-root';n.setAttribute('aria-label','간편 사진 일기');n.hidden=true;document.body.append(n);view=n;return n;}
function open(page='calendar',day){const s=getState();if(!s?.open)return false;mount();ui.open=true;ui.page=page==='day'?'day':'calendar';ui.selected=valid(day)?day:ui.selected;ui.date=ui.selected;ui.month=new Date(ui.selected+'T12:00:00');ui.month.setDate(1);ui.idx=0;ui.fast=false;ui.tools=false;ui.rail=false;ui.dirty=false;view.hidden=false;
 try{localStorage.setItem(KEY,'simple')}catch(e){}render();r475LastDataKey=[s.curatedEntries?.size||0,s.entries?.size||0,s.byDay?.size||0,s.byVideoDay?.size||0].join(':');installBack();setTimeout(r475RefreshFamily,100);return true;}
function close(){window.MoaVoicePlaybackUI?.stop?.();ui.audioPlaying=false;ui.open=false;ui.requestGeneration++;if(view)view.hidden=true;try{localStorage.removeItem(KEY)}catch(e){}return true;}
function goBack(){if(!ui.open)return false;if(ui.page==='day'){if(ui.dirty&&!confirm('작성 중인 내용이 있습니다. 저장하지 않고 돌아갈까요?'))return true;window.MoaVoicePlaybackUI?.stop?.();ui.page='calendar';ui.dirty=false;render();return true;}r475ExitUntilHidden=true;close();window.FamilyJourneyDiary?.close?.(false);return true;}
function installBack(){if(backInstalled)return;backInstalled=true;const old=window.__fjBackOverlay;window.__fjBackOverlay=function(...args){if(ui.open&&!document.getElementById('moa-r149-voice-modal'))return goBack();return typeof old==='function'?old.apply(this,args):false};}
function r475ModeToggle(active,onPhoto,onDetail){
 const wrap=elem('nav','moa-r475-view-toggle');wrap.setAttribute('aria-label','일기 보기 전환');
 for(const [name,label,action] of [['photo','사진형',onPhoto],['detail','상세형',onDetail]]){
  const b=btn(label,action,'moa-r475-view-option'+(active===name?' active':''));
  b.setAttribute('aria-pressed',String(active===name));wrap.append(b);
 }
 return wrap;
}
function r475OpenDetail(day){if(ui.dirty){notify('작성 중인 글을 먼저 저장한 뒤 상세형으로 전환해 주세요.');return;}
 // Render the ORIGINAL detailed editor first while covered by current Photo View.
 // No duplicate diary form/records; the original owner remains intact.
 const s=getState();if(!s)return;
 s.mode=ui.source;
 window.FamilyJourneyDiary?.selectDay?.(day);
 close();r475DecorateDetail();
}
function r475DecorateDetail(){
 const s=getState(),root=diaryRoot();if(!s?.open||s.page!=='day'||!root||root.hidden||ui.open)return;
 if(root.querySelector('.moa-r475-detail-switch'))return;
 const top=root.querySelector('.fd23-top');if(!top)return;
 const bar=r475ModeToggle('detail',()=>{
  const state=getState();if(state?.dirty&&state?.editing&&!confirm('저장하지 않은 변경사항이 있습니다. 사진형으로 이동할까요?'))return;
  if(state?.mode==='automatic'||state?.mode==='curated')ui.source=state.mode;
  open('day',state?.date||s.date);
 },()=>{});
 bar.classList.add('moa-r475-detail-switch');top.insertAdjacentElement('afterend',bar);
}
function addMode(){
 const s=getState(),root=diaryRoot();
 if(!s?.open||!root||root.hidden){r475ExitUntilHidden=false;return;}
 if(ui.open&&ui.page==='calendar'&&!s.load){
  const key=[s.curatedEntries?.size||0,s.entries?.size||0,s.byDay?.size||0,s.byVideoDay?.size||0].join(':');
  if(key!==r475LastDataKey&&!r475CalendarRefreshPending){r475LastDataKey=key;r475CalendarRefreshPending=true;
   setTimeout(()=>{r475CalendarRefreshPending=false;if(ui.open&&ui.page==='calendar'&&!ui.dirty)render()},240);
  }
 }
 if(s.page==='day'&&!ui.open){r475DecorateDetail();return;}
 if(s.page!=='calendar'||ui.open||r475ExitUntilHidden||r475AutostartScheduled)return;
 r475AutostartScheduled=true;
 setTimeout(()=>{r475AutostartScheduled=false;
  const current=getState(),host=diaryRoot();
  if(current?.open&&current.page==='calendar'&&host&&!host.hidden&&!ui.open&&!r475ExitUntilHidden)open('calendar',current.date||ui.selected);
 },80);
}
function sync(){if(pending)return;pending=requestAnimationFrame(()=>{pending=0;addMode();r472Nav();});}
function r472Nav(){
 const bar=document.getElementById('tabbar');if(!bar)return;
 const q=tab=>bar.querySelector(`[data-tab="${tab}"]`);
 const diary=q('diary'),map=q('home'),record=q('record'),settings=q('settings');
 if(!diary||!map||!record||!settings)return;
 const family=q('family');if(family)family.hidden=true;
 // Keep the original event handlers by moving, NOT cloning, old buttons.
 let plus=q('moa-plus');if(!plus){plus=btn('+',async()=>{
  const s=getState();const date=ui.open?ui.page==='day'?ui.date:ui.selected:(s?.page==='day'?s.date:ui.selected);
  if(!s?.open)await window.FamilyJourneyDiary?.open?.();
  if(!open('day',valid(date)?date:dayOf(Date.now())))console.warn('MOA new diary unavailable');
 },'moa-r472-bottom-plus');plus.dataset.tab='moa-plus';plus.innerHTML='<span class="moa-r472-plus-disc" aria-hidden="true">+</span>';plus.setAttribute('aria-label','선택한 날짜 사진 일기 작성');}
 const wanted=[diary,map,plus,record,settings];
 const visible=[...bar.children].filter(b=>!['family','reco','battle'].includes(b.dataset.tab));
 if(visible.some((b,i)=>b!==wanted[i])||visible.length!==wanted.length)for(const b of wanted)bar.append(b);
 // Family schedule remains one-tap accessible INSIDE original diary.
 const root=diaryRoot(),modes=root&&$('.fd23-modes',root);
 if(modes&&!modes.querySelector('.moa-r472-family-inside')){
  modes.append(btn('가족 일정',()=>{close();window.FamilyJourneyDiary?.close?.(false);window.MoaFamilySchedule?.open?.()},'moa-r472-family-inside'));
 }
 // Family Schedule is available in the original diary mode row.

}
function start(){mount();observer=new MutationObserver(sync);observer.observe(document.body,{childList:true,subtree:true});const root=diaryRoot();if(root)observer.observe(root,{childList:true,subtree:false,attributes:true,attributeFilter:['hidden']});sync();setTimeout(r472Nav,500);
 const bar=document.getElementById('tabbar');if(bar)bar.addEventListener('click',e=>{
  if(!ui.open)return;const tab=e.target.closest('button[data-tab]')?.dataset.tab;
  if(tab&&tab!=='moa-plus'){r475ExitUntilHidden=true;close();}
 },true);}

function render(){if(!ui.open||!view)return;ui.requestGeneration++;view.replaceChildren();view.dataset.page=ui.page;
 ui.page==='day'?renderDay():renderMonth();view.append(elem('div','moa-r469-status',''));view.scrollTop=0;r472Nav();setTimeout(r472RefreshVisibleThumbs,600);}
function header(title,back){const h=elem('header','moa-r469-head');h.append(btn('‹',back,'moa-r469-back'),elem('strong','',title),btn('⌂',()=>{r475ExitUntilHidden=true;close();window.__photoMap?.showTab?.('home')},'moa-r469-home'));return h;}
function renderMonth(){const s=getState();if(!s)return;const y=ui.month.getFullYear(),m=ui.month.getMonth(),days=new Date(y,m+1,0).getDate(),offset=new Date(y,m,1).getDay();
 const h=header('우리 가족 일기',goBack);view.append(h);
 const monthBar=elem('nav','moa-r469-month-head');
 const pickerWrap=elem('label','moa-r472-month-picker');
 pickerWrap.append(elem('strong','',`${y}년 ${m+1}월`));
 const nativeMonth=elem('input');nativeMonth.type='month';nativeMonth.min='1900-01';nativeMonth.max='2100-12';nativeMonth.value=`${y}-${String(m+1).padStart(2,'0')}`;
 nativeMonth.setAttribute('aria-label','연도와 월 선택');nativeMonth.addEventListener('change',()=>{const v=nativeMonth.value;if(/^\d{4}-(0[1-9]|1[0-2])$/.test(v)){ui.month=new Date(v+'-01T12:00:00');render()}});pickerWrap.append(nativeMonth);
 monthBar.append(btn('‹',()=>changeMonth(-1)),pickerWrap,btn('›',()=>changeMonth(1)),btn('오늘',()=>{ui.month=new Date();ui.month.setDate(1);ui.selected=dayOf(Date.now());render()},'moa-r469-today'));view.append(monthBar);
 const records=new Set([...(s.curatedEntries?.values()||[]),...(s.entries?.values()||[])].filter(e=>e?.day?.startsWith(`${y}-${String(m+1).padStart(2,'0')}-`)&&(e.body||e.title||(e.moments||[]).length)).map(e=>e.day)).size;
 const progress=elem('div','moa-r469-progress');progress.append(elem('span','',`이번 달 기록 ${records} / ${days}일`),elem('span','',`${Math.round(records/days*100)}%`));view.append(progress);
 const bar=elem('div','moa-r469-progressbar');const inner=elem('span');inner.style.width=(records/days*100)+'%';bar.append(inner);view.append(bar);
 const filter=elem('div','moa-r475-source-filter');filter.setAttribute('aria-label','달력 사진 보기');
 for(const [mode,label] of [['curated','내가 고른 사진'],['automatic','전체 사진']]){
  const button=btn(label,()=>{if(ui.source===mode)return;ui.source=mode;ui.idx=0;render()},'moa-r475-source-option'+(ui.source===mode?' active':''));
  button.setAttribute('aria-pressed',String(ui.source===mode));filter.append(button);
 }
 view.append(filter);
 const grid=elem('div','moa-r469-month-grid');for(const d of ['일','월','화','수','목','금','토'])grid.append(elem('span','moa-r469-week',d));
 const images=[];for(let i=0;i<offset+days;i++){if(i<offset){grid.append(elem('span','moa-r469-blank'));continue}
  const n=i-offset+1,d=`${y}-${String(m+1).padStart(2,'0')}-${String(n).padStart(2,'0')}`;const photo=mainCover(d,mediaFor(d));const tile=btn('',()=>{ui.selected=d;ui.date=d;ui.page='day';ui.idx=0;ui.fast=false;render()},'moa-r469-date');tile.setAttribute('aria-label',`${d} 일기 열기`);
  if(d===ui.selected)tile.classList.add('selected');if(d===dayOf(Date.now()))tile.classList.add('today');
  if(photo){const img=elem('img');img.dataset.id=String(photo.id);img.alt='';tile.append(img);images.push(img);if(isVideo(photo))tile.append(elem('span','moa-r469-video-mark','▶'));}
  tile.append(elem('span','moa-r469-day-number',n));if(s.curatedEntries?.has(d))tile.append(elem('span','moa-r469-record-mark','•'));if(r475Events(d).length){const mark=elem('span','moa-r475-event-mark');mark.setAttribute('aria-label','가족 일정 있음');tile.append(mark);}grid.append(tile);
 }
 view.append(grid); // Global bottom navigation owns the ONLY central plus button.
 fillImages(images);}
function changeMonth(k){ui.month=new Date(ui.month.getFullYear(),ui.month.getMonth()+k,1);render();}
function dayMedia(index){const m=ui.media[index];return m&&safeMedia(m.id)?m:null;}
function setDay(day){if(!valid(day))return;ui.date=day;ui.selected=day;ui.page='day';ui.fast=false;ui.idx=0;ui.dirty=false;render();}
function renderDay(){const d=ui.date,s=getState();if(!valid(d)||!s)return;ui.media=mediaFor(d);const chosen=mainCover(d,ui.media);const ri=ui.media.findIndex(x=>String(x.id)===String(chosen?.id));ui.idx=Math.min(ui.media.length-1,Math.max(0,ui.idx||ri));if(ui.idx===0&&ri>0)ui.idx=ri;
 const current=s.curatedEntries?.get(d)||s.entries?.get(d),wrap=elem('div','moa-r469-day');
 wrap.append(header(dateLabel(d),goBack));
 const views=r475ModeToggle('photo',()=>{},()=>r475OpenDetail(d));
 views.classList.add('moa-r475-photo-switch');wrap.append(views);
 const stage=elem('div','moa-r469-stage');stage.dataset.moaStage='yes';stage.tabIndex=0;stage.setAttribute('aria-label','사진 영상 좌우로 이동');stage.append(elem('div','moa-r469-stage-media'));
 const more=btn('···',()=>{ui.tools=!ui.tools;toggleTools()},'moa-r469-more');more.setAttribute('aria-label','사진 기능');stage.append(more);wrap.append(stage);
 stage.addEventListener('keydown',e=>{
  if(e.key==='ArrowLeft'){changeMedia(ui.idx-1);e.preventDefault()}
  else if(e.key==='ArrowRight'){changeMedia(ui.idx+1);e.preventDefault()}
 });
 const dots=elem('div','moa-r469-pager');wrap.append(dots);
 const tools=elem('section','moa-r469-tools');tools.hidden=!ui.tools;tools.innerHTML=`<div class="moa-r469-actions"><button data-op="cover" aria-label="대표 사진">☆</button><button data-op="share" aria-label="공유">↗</button><button data-op="geo" aria-label="GPS 지도">⌖</button><button data-op="info" aria-label="촬영 정보">ⓘ</button><button data-op="fast" aria-label="빠른 넘기기">»</button></div><div class="moa-r469-info" hidden></div><button class="moa-r469-rail-toggle">사진 목록 ⌄</button><div class="moa-r469-rail" hidden></div>`;
 tools.querySelector('.moa-r469-actions').addEventListener('click',onAction);tools.querySelector('.moa-r469-rail-toggle').onclick=()=>{ui.rail=!ui.rail;toggleRail()};wrap.append(tools);
 const story=elem('section','moa-r469-story');story.append(elem('strong','moa-r469-story-title','오늘의 이야기'));
 const area=elem('textarea','moa-r469-text');area.placeholder='오늘의 소중한 순간을 기록해 보세요.';area.value=current?.body||'';area.oninput=()=>{ui.dirty=true;};story.append(area);
 const momentNotes=(current?.moments||[]).filter(x=>String(x.note||'').trim());if(momentNotes.length){const details=elem('details','moa-r469-moments');details.append(elem('summary','',`바로기록 ${momentNotes.length}개`));for(const m of momentNotes){const p=elem('p','',m.note);details.append(p)}story.append(details);}
 const voicehead=elem('div','moa-r469-voice-head');const recButton=btn('',()=>openNativeRecorder(),'moa-r469-record');recButton.innerHTML='<svg viewBox="0 0 24 24" aria-hidden="true"><rect x="9" y="3" width="6" height="12" rx="3"/><path d="M6 11a6 6 0 0 0 12 0M12 17v4M8.5 21h7"/></svg>';recButton.setAttribute('aria-label','기존 음성 녹음 기능');voicehead.append(elem('span','','음성 메모'),recButton);story.append(voicehead);
 const voice=elem('div','moa-r469-voice-player');voice.innerHTML='<button class="moa-r469-voice-play" aria-label="녹음 듣기">▷</button><div class="moa-r469-voice-detail"><span></span><input type="range" min="0" max="100" value="0" aria-label="재생 시간 탐색" disabled></div><button class="moa-r469-voice-select" aria-label="녹음 선택">0/0⌄</button>';
 voice.querySelector('.moa-r469-voice-play').onclick=()=>playVoice();voice.querySelector('.moa-r469-voice-select').onclick=()=>voiceListToggle();story.append(voice);
 const chooser=elem('div','moa-r469-voice-list');chooser.hidden=true;story.append(chooser);
 const foot=elem('div','moa-r469-story-footer');foot.append(elem('span','moa-r475-save-note','같은 날짜의 기록을 공유합니다'),btn('저장',()=>saveStory(),'moa-r469-save'));story.append(foot);wrap.append(story);
 const family=elem('section','moa-r475-family');const dayEvents=r475Events(d);
 const familyTop=elem('div','moa-r475-family-top');familyTop.append(elem('span','','가족 일정'+(dayEvents.length?' · '+dayEvents.length:'')));
 familyTop.append(btn('일정 관리 ›',()=>{r475ExitUntilHidden=true;close();window.FamilyJourneyDiary?.close?.(false);window.MoaFamilySchedule?.open?.()},'moa-r475-family-manage'));
 family.append(familyTop);
 if(dayEvents.length){const list=elem('div','moa-r475-family-list');dayEvents.forEach(ev=>{
  const entry=elem('div','moa-r475-family-item');const time=String(ev?.allDay?'종일':ev?.start||'');
  entry.append(elem('span','moa-r475-family-time',time),elem('span','',String(ev?.title||'일정')));list.append(entry);
 });family.append(list)}
 wrap.append(family);
 const status=elem('div','moa-r469-status','');wrap.append(status);view.append(wrap);renderMedia();refreshVoices();}
function r472MediaSelected(index){
 if(!Number.isFinite(index)||!ui.media.length)return;
 const next=Math.max(0,Math.min(ui.media.length-1,index));
 if(next===ui.idx)return;
 const oldSlide=$(`.moa-r472-slide[data-idx="${ui.idx}"]`,view);
 const oldVideo=oldSlide?.querySelector('video');if(oldVideo){oldVideo.pause();oldVideo.removeAttribute('src');oldVideo.load();oldVideo.remove()}
 window.MoaVoicePlaybackUI?.stop?.();ui.audioPlaying=false;
 ui.idx=next;ui.info=false;
 const info=$('.moa-r469-info',view);if(info){info.hidden=true;info.replaceChildren()}
 r472UpdatePager();r472LazyPhotos();
}
function r472UpdatePager(){
 const dots=$('.moa-r469-pager',view);if(!dots)return;
 dots.replaceChildren();const count=ui.media.length;if(!count)return;
 const range=count<=9?Array.from({length:count},(_,i)=>i):Array.from({length:7},(_,i)=>Math.max(0,Math.min(count-7,ui.idx-3))+i);
 for(const i of range){const dot=btn('',()=>changeMedia(i),'moa-r469-dot'+(i===ui.idx?' active':''));dot.setAttribute('aria-label',`${i+1}번째 사진`);dots.append(dot)}
 const star=$('[data-op="cover"]',view),m=dayMedia(ui.idx);
 if(star&&m)star.classList.toggle('active',String(getState()?.covers?.curated?.[ui.date]||'')===String(m.id));
 const fast=$('[data-op="fast"]',view);if(fast)fast.classList.toggle('active',ui.fast);
 if(ui.rail)renderRail();
}
function r472LazyPhotos(){
 const strip=$('.moa-r472-track',view);if(!strip)return;
 const files=[];
 for(let i=Math.max(0,ui.idx-5);i<=Math.min(ui.media.length-1,ui.idx+6);i++){
  const frame=strip.children[i];const img=frame?.querySelector('img[data-id]');
  if(img&&!img.dataset.fullLoaded)files.push(img);
 }
 if(files.length)fillImages(files,true);
}
function renderMedia(){
 const stage=$('.moa-r469-stage-media',view);if(!stage)return;
 stage.replaceChildren();const medias=ui.media;ui.requestGeneration++;
 if(!medias.length){stage.append(elem('div','moa-r469-empty','사진을 추가하면 여기에 표시돼요.'));r472UpdatePager();return;}
 const track=elem('div','moa-r472-track');
 track.classList.toggle('is-fast',ui.fast);track.setAttribute('aria-label','좌우로 사진·영상을 넘기는 갤러리');
 let pendingScroll=0,settleTimer=0;
 track.addEventListener('scroll',()=>{
  clearTimeout(settleTimer);
  if(ui.fast)settleTimer=setTimeout(()=>{
   if(!track.isConnected)return;const w=track.clientWidth||1;const at=Math.round(track.scrollLeft/w)*w;
   if(Math.abs(track.scrollLeft-at)>1)track.scrollTo({left:at,behavior:'smooth'});
  },170);
  if(pendingScroll)return;
  pendingScroll=requestAnimationFrame(()=>{pendingScroll=0;
   const width=track.clientWidth||1;const next=Math.max(0,Math.min(medias.length-1,Math.round(track.scrollLeft/width)));
   r472MediaSelected(next);
  });
 },{passive:true});
 track.addEventListener('click',e=>{
  if(e.target.closest('button,video,input'))return;
  ui.tools=!ui.tools;toggleTools();
 });
 medias.forEach((m,i)=>{
  const slide=elem('div','moa-r472-slide');slide.dataset.idx=String(i);
  const image=elem('img');image.alt='';image.dataset.id=String(m.id);image.loading='lazy';
  slide.append(image);
  if(isVideo(m)){
   const play=btn('▶',()=>playInlineVideo(m),'moa-r469-video-play');play.setAttribute('aria-label','이 자리에서 영상 재생');slide.append(play);
  }
  track.append(slide);
 });
 stage.append(track);
 requestAnimationFrame(()=>{if(!track.isConnected)return;track.scrollLeft=ui.idx*(track.clientWidth||1);r472LazyPhotos()});
 r472UpdatePager();
}
function changeMedia(i){if(!ui.media.length)return;
 const track=$('.moa-r472-track',view);if(!track)return;
 const to=Math.max(0,Math.min(ui.media.length-1,i));
 track.scrollTo({left:to*(track.clientWidth||1),behavior:Math.abs(to-ui.idx)>2?'auto':'smooth'});
 r472MediaSelected(to);
}

function toggleTools(){const t=$('.moa-r469-tools',view);if(t)t.hidden=!ui.tools;}
function toggleRail(){const r=$('.moa-r469-rail',view),b=$('.moa-r469-rail-toggle',view);if(r)r.hidden=!ui.rail;if(b)b.textContent=ui.rail?'사진 목록 ⌃':'사진 목록 ⌄';if(ui.rail)renderRail();}
function renderRail(){const r=$('.moa-r469-rail',view);if(!r)return;r.replaceChildren();if(!ui.rail)return;const imgs=[];
 ui.media.forEach((m,i)=>{const tile=btn('',()=>changeMedia(i),'moa-r469-rail-item'+(i===ui.idx?' active':''));const img=elem('img');img.dataset.id=String(m.id);tile.append(img);if(isVideo(m))tile.append(elem('small','','▶'));r.append(tile);imgs.push(img)});fillImages(imgs);}
async function onAction(e){const op=e.target.closest('button[data-op]')?.dataset.op,m=dayMedia(ui.idx);if(!op||!m)return;
 if(op==='fast'){ui.fast=!ui.fast;const track=$('.moa-r472-track',view);if(track)track.classList.toggle('is-fast',ui.fast);r472UpdatePager();notify(ui.fast?'빠른 연속 넘기기 ON':'한 장씩 넘기기 OFF');return}
 if(op==='share'){if(!nativePost(isVideo(m)?'diaryShareVideo':'sharePhoto',{id:String(m.id)}))notify('Android 공유 기능을 연결할 수 없습니다.');return}
 if(op==='cover'){await saveCover(m.id);return}
 if(op==='geo'){const pane=$('.moa-r469-info',view);if(pane){pane.hidden=false;pane.replaceChildren();try{if(typeof window.FamilyJourneyDiaryGeo?.attach==='function')window.FamilyJourneyDiaryGeo.attach(pane,String(m.id));else pane.textContent='현재 사진의 GPS 지도를 연결할 수 없습니다.'}catch(err){pane.textContent=String(err)}}return;}
 if(op==='info'){const pane=$('.moa-r469-info',view);if(!pane)return;ui.info=!ui.info;pane.hidden=!ui.info;if(ui.info){pane.replaceChildren(elem('p','',`촬영: ${new Date(Number(m.t)||Date.now()).toLocaleString('ko-KR')}`));try{window.FamilyJourneyDiaryGeo?.attach?.(pane,String(m.id))}catch(e){}}return;}
}
async function saveCover(id){const s=getState();if(!s?.covers)return;const covers=s.covers;const source=ui.source;const old=covers[source]?.[ui.date];if(!covers[source])covers[source]={};covers[source][ui.date]=String(id);
 try{await persist('meta',coverKey,covers);notify('대표 사진이 달력 표지로 저장됐습니다.');renderMedia();}catch(e){if(old===undefined)delete covers[source][ui.date];else covers[source][ui.date]=old;notify('대표 사진 저장 실패: '+String(e))}}
async function saveStory(){const s=getState();if(!s)return;const textarea=$('.moa-r469-text',view);if(!textarea)return;const text=textarea.value.trim(),day=ui.date;
 try{const table=s.curatedEntries?.has(day)?'curated':s.entries?.has(day)?'entries':'curated';const updated=await mergeDiaryBody(day,text,table);(table==='curated'?s.curatedEntries:s.entries).set(day,updated);ui.dirty=false;notify('기존 일기 저장소에 저장했습니다. 바로기록·시간대별 기록은 보존됩니다.');}
 catch(e){notify('저장 실패: '+String(e))}
}
function parseVoices(){let list=[];try{list=JSON.parse(window.MoaLocalAudio?.list?.(ui.date)||'[]')}catch(e){}
 return (Array.isArray(list)?list:[]).filter(x=>/^[A-Za-z0-9_-]{8,90}\.m4a$/.test(String(x?.id||''))).sort((a,b)=>(Number(a.time)||0)-(Number(b.time)||0));}
function refreshVoices(){ui.clips=parseVoices();ui.clip=Math.max(0,Math.min(ui.clips.length-1,ui.clip));const count=$('.moa-r469-voice-head span',view);if(count)count.textContent=`음성 기록 · ${ui.clips.length}개`;
 const play=$('.moa-r469-voice-play',view),detail=$('.moa-r469-voice-detail span',view),select=$('.moa-r469-voice-select',view);const current=ui.clips[ui.clip];
 if(play){play.disabled=!current;play.textContent=ui.audioPlaying?'Ⅱ':'▷';}if(detail)detail.textContent=current?window.MoaVoicePlaybackUI?.metaFor?.(ui.date,current.id)?.title||`녹음 ${ui.clip+1} · ${new Date(current.time).toLocaleTimeString('ko-KR',{hour:'numeric',minute:'2-digit'})}`:'저장된 음성이 없습니다.';
 if(select)select.textContent=ui.clips.length?`${ui.clip+1}/${ui.clips.length}⌄`:'0/0';}
function voiceListToggle(){const list=$('.moa-r469-voice-list',view);if(!list)return;list.hidden=!list.hidden;if(list.hidden)return;list.replaceChildren();ui.clips.forEach((x,i)=>{const b=btn(`녹음 ${i+1} · ${new Date(x.time).toLocaleTimeString('ko-KR',{hour:'numeric',minute:'2-digit'})}`,()=>{window.MoaVoicePlaybackUI?.stop?.();ui.audioPlaying=false;ui.clip=i;list.hidden=true;refreshVoices()},'moa-r469-voice-choice');list.append(b)})}
function playVoice(){const clip=ui.clips[ui.clip],button=$('.moa-r469-voice-play',view);if(!clip||!button)return;try{window.MoaVoicePlaybackUI?.play?.(ui.date,clip.id,button);ui.audioPlaying=!ui.audioPlaying;button.textContent=ui.audioPlaying?'Ⅱ':'▷';}catch(e){notify('음성을 재생할 수 없습니다: '+String(e))}}
function openNativeRecorder(){const s=getState();if(!s)return;window.MoaVoicePlaybackUI?.stop?.();ui.audioPlaying=false;
 // Existing voice host accepts only S.page==='day'; call the *original* day navigation
 // so all original record-save side-effects, UID and data ownership remain intact.
 if(s.page!=='day'||s.date!==ui.date){s.mode='curated';window.FamilyJourneyDiary?.selectDay?.(ui.date)}
 const result=window.MoaVoiceDiaryNative?.open?.();if(!result){notify('기존 녹음 화면 연결이 준비되지 않았습니다.');return}
 const check=()=>{if(!ui.open)return;if(document.getElementById('moa-r149-voice-modal')){setTimeout(check,1200);return;}refreshVoices()};setTimeout(check,1300);
}
function playInlineVideo(media){
 const slide=$(`.moa-r472-slide[data-idx="${ui.idx}"]`,view);if(!slide||!isVideo(media))return;
 const old=slide.querySelector('video');if(old){old.paused?old.play().catch(()=>{}):old.pause();return;}
 window.MoaVoicePlaybackUI?.stop?.();ui.audioPlaying=false;
 const video=elem('video','moa-r469-inline-video');video.controls=true;video.playsInline=true;video.preload='metadata';
 video.poster=slide.querySelector('img')?.src||'';
 // Android WebView must be allowed to read the MediaStore URI. On devices that reject it,
 // original native playback stays a user-visible explicit fallback, not a false success.
 video.src=`content://media/external/video/media/${String(media.id).slice(1)}`;
 video.onerror=()=>{
  video.pause();video.removeAttribute('src');video.load();video.remove();
  notify('이 기기에서 화면 내 영상 열기가 제한되어 있습니다. 원본 재생기를 사용할 수 있습니다.');
  if(!slide.querySelector('.moa-r469-native-fallback'))slide.append(btn('원본 재생기로 보기',()=>nativePost('diaryPlayVideo',{id:media.id}),'moa-r469-native-fallback'));
 };
 slide.querySelector('.moa-r469-video-play')?.remove();slide.append(video);
 video.play().catch(()=>{video.controls=true});
}

const originalAudioEvent=window.__moaNativeAudioEvent;
if(typeof originalAudioEvent==='function'){window.__moaNativeAudioEvent=function(evt){originalAudioEvent.apply(this,arguments);if(!ui.open||ui.page!=='day')return;const event=String(evt?.event||'');if(event==='play_started'||event==='play_resumed'){ui.audioPlaying=true;const b=$('.moa-r469-voice-play',view);if(b)b.textContent='Ⅱ';}else if(['play_paused','play_finished','play_error'].includes(event)){ui.audioPlaying=false;const b=$('.moa-r469-voice-play',view);if(b)b.textContent='▷';}if(['record_saved','delete'].includes(event))setTimeout(refreshVoices,250);};}
window.MoaR469SimpleDiary={openCalendar:()=>open('calendar'),openDay:d=>open('day',d),close,readOnlyStatus:()=>({active:ui.open,page:ui.page,date:ui.date,mediaCount:ui.media.length,voiceCount:ui.clips.length})};
if(document.readyState==='loading')document.addEventListener('DOMContentLoaded',start,{once:true});else start();
})();
