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
let r475ScheduleCache=[];let r479FamilyLocallyWritten=false,r479SwipeBlockUntil=0,r479Animating=false;
function r475Events(day){try{const f=window.MoaFamilySchedule;const e=!r479FamilyLocallyWritten&&f?.ready?f.visibleEvents:r475ScheduleCache;return Array.isArray(e)?e.filter(x=>x?.date===day):[]}catch(_){return []}}
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
  for(const ev of events){const row=btn('',()=>r479ScheduleEditor(ui.date,ev),'moa-r475-family-item');row.append(elem('span','moa-r475-family-time',String(ev?.allDay?'종일':ev?.start||'')),elem('span','',String(ev?.title||'일정')));list.append(row)}
  panel.append(list);
 }
}
function r479ScheduleEditor(day,existing){
 if(!valid(day))return;
 const shade=elem('div','moa-r479-picker-backdrop');shade.setAttribute('role','presentation');
 const pane=elem('section','moa-r479-picker-sheet moa-r479-schedule-sheet');pane.setAttribute('role','dialog');pane.setAttribute('aria-modal','true');pane.setAttribute('aria-label',existing?'가족 일정 확인 및 수정':'가족 일정 추가');
 const header=elem('div','moa-r479-picker-heading');header.append(elem('strong','',existing?'가족 일정':'새 가족 일정'),btn('×',()=>shade.remove(),'moa-r479-picker-close'));pane.append(header);
 const form=elem('form','moa-r479-schedule-form');
 const field=(label,type,value)=>{const row=elem('label','moa-r479-schedule-field');row.append(elem('span','',label));const input=elem('input');input.type=type;input.value=String(value||'');row.append(input);form.append(row);return input};
 const title=field('일정 이름','text',existing?.title||'');title.required=true;title.maxLength=120;
 const date=field('날짜','date',existing?.date||day);date.required=true;
 const allDayRow=elem('label','moa-r479-schedule-check');const allDay=elem('input');allDay.type='checkbox';allDay.checked=existing?.allDay??false;allDayRow.append(allDay,elem('span','','하루 종일'));form.append(allDayRow);
 const times=elem('div','moa-r479-time-fields');const start=elem('input'),end=elem('input');start.type=end.type='time';start.value=existing?.start||'09:00';end.value=existing?.end||'10:00';times.append(start,end);form.append(times);const toggleTimes=()=>{times.hidden=allDay.checked};allDay.addEventListener('change',toggleTimes);toggleTimes();
 const note=field('메모','text',existing?.note||'');
 const err=elem('p','moa-r479-form-error','');form.append(err);
 const actions=elem('div','moa-r479-form-actions');
 if(existing)actions.append(btn('삭제',async()=>{if(!confirm('해당 가족 일정만 삭제할까요?'))return;try{await r479WriteFamily('delete',existing.id);shade.remove();await r475RefreshFamily();r475UpdateFamilyDom()}catch(e){err.textContent='삭제 실패: '+String(e)}},'moa-r479-remove'));
 actions.append(btn('취소',()=>shade.remove(),'moa-r479-cancel'));const save=btn('저장',()=>form.requestSubmit(),'moa-r479-submit');actions.append(save);form.append(actions);
 form.addEventListener('submit',async e=>{e.preventDefault();if(save.disabled)return;const name=title.value.trim();if(!name||!valid(date.value)||(!allDay.checked&&start.value>end.value)){err.textContent='일정 이름·날짜·시간을 확인해 주세요.';return}
  const now=new Date().toISOString(),old=existing||{};
  const item={...old,id:old.id||((typeof crypto!=='undefined'&&crypto.randomUUID)?crypto.randomUUID():String(Date.now())+'-'+Math.random().toString(36).slice(2)),title:name,date:date.value,allDay:allDay.checked,start:allDay.checked?'':start.value,end:allDay.checked?'':end.value,who:old.who||'가족',note:note.value.trim(),tzid:old.tzid||Intl.DateTimeFormat().resolvedOptions().timeZone||'Asia/Seoul',createdAt:old.createdAt||now,updatedAt:now,revision:(Number(old.revision)||0)+1};
  save.disabled=true;try{await r479WriteFamily('put',item);shade.remove();await r475RefreshFamily();r475UpdateFamilyDom();if(ui.page==='calendar')render()}catch(ex){save.disabled=false;err.textContent='저장 실패: '+String(ex)}
 });pane.append(form);shade.append(pane);shade.addEventListener('click',e=>{if(e.target===shade)shade.remove()});view.append(shade);
}
async function r479WriteFamily(op,value){
 const d=await new Promise((resolve,reject)=>{const r=indexedDB.open('moa-family-calendar-v1',1);r.onupgradeneeded=()=>{const db=r.result;if(!db.objectStoreNames.contains('events')){const store=db.createObjectStore('events',{keyPath:'id'});store.createIndex('date','date',{unique:false})}};r.onsuccess=()=>resolve(r.result);r.onerror=()=>reject(r.error)});
 try{await new Promise((resolve,reject)=>{const tx=d.transaction('events','readwrite'),store=tx.objectStore('events');if(op==='delete')store.delete(value);else store.put(value);tx.oncomplete=resolve;tx.onerror=()=>reject(tx.error);tx.onabort=()=>reject(tx.error)});}finally{d.close()}
 r479FamilyLocallyWritten=true;
}
async function r475RefreshFamily(){
 try{
  const f=window.MoaFamilySchedule;
  if(f?.ready&&!r479FamilyLocallyWritten){r475ScheduleCache=f.visibleEvents||[];r475UpdateFamilyDom();return}
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
   const month=x.closest('.moa-r483-month');if(month&&r483Feed){const r=month.getBoundingClientRect(),f=r483Feed.getBoundingClientRect();if(r.bottom<f.top-250||r.top>f.bottom+250)return false;}
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
  const month=x.closest('.moa-r483-month');if(month&&r483Feed){const r=month.getBoundingClientRect(),f=r483Feed.getBoundingClientRect();if(r.bottom<f.top-250||r.top>f.bottom+250)return false;}
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

function mount(){if(view)return view;const n=elem('section','moa-r469-root');n.id='moa-r469-root';n.setAttribute('aria-label','통합 사진 일기 달력');n.hidden=true;n.addEventListener('click',e=>{if(Date.now()<r479SwipeBlockUntil&&e.target.closest('.moa-r469-date')){e.stopImmediatePropagation();e.preventDefault()}},true);document.body.append(n);view=n;return n;}
function open(page='calendar',day){const s=getState();if(!s?.open)return false;mount();ui.open=true;ui.page=page==='day'?'day':'calendar';ui.selected=valid(day)?day:ui.selected;ui.date=ui.selected;ui.month=new Date(ui.selected+'T12:00:00');ui.month.setDate(1);ui.idx=0;ui.fast=false;ui.tools=false;ui.rail=false;ui.dirty=false;view.hidden=false;
 try{localStorage.setItem(KEY,'simple')}catch(e){}render();r475LastDataKey=[s.curatedEntries?.size||0,s.entries?.size||0,s.byDay?.size||0,s.byVideoDay?.size||0].join(':');installBack();setTimeout(r475RefreshFamily,100);return true;}
function close(){r483ImageObserver?.disconnect();r483ImageObserver=null;r483Feed=null;window.MoaVoicePlaybackUI?.stop?.();ui.audioPlaying=false;ui.open=false;ui.requestGeneration++;if(view)view.hidden=true;try{localStorage.removeItem(KEY)}catch(e){}return true;}
function goBack(){if(!ui.open)return false;if(ui.page==='day'){if(ui.dirty&&!confirm('작성 중인 내용이 있습니다. 저장하지 않고 돌아갈까요?'))return true;window.MoaVoicePlaybackUI?.stop?.();ui.page='calendar';ui.dirty=false;render();return true;}r475ExitUntilHidden=true;close();window.FamilyJourneyDiary?.close?.(false);return true;}
function installBack(){if(backInstalled)return;backInstalled=true;const old=window.__fjBackOverlay;window.__fjBackOverlay=function(...args){if(ui.open&&!document.getElementById('moa-r149-voice-modal'))return goBack();return typeof old==='function'?old.apply(this,args):false};}
function r475ModeToggle(active,onPhoto,onDetail){
 const wrap=r483Pill(active,[{key:'photo',label:'사진형'},{key:'detail',label:'상세형'}],mode=>{if(mode==='photo')onPhoto();else onDetail()},'moa-r483-day-mode');
 wrap.classList.add('moa-r475-view-toggle');return wrap;
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
 // No separate family-calendar tab or old three-way diary selector is exposed.
 // Family events are rendered directly in each date cell and the date's inline agenda.
 const root=diaryRoot();root?.querySelector('.moa-r472-family-inside')?.remove();

}
function start(){mount();observer=new MutationObserver(sync);observer.observe(document.body,{childList:true,subtree:true});const root=diaryRoot();if(root)observer.observe(root,{childList:true,subtree:false,attributes:true,attributeFilter:['hidden']});sync();setTimeout(r472Nav,500);
 const bar=document.getElementById('tabbar');if(bar)bar.addEventListener('click',e=>{
  if(!ui.open)return;const tab=e.target.closest('button[data-tab]')?.dataset.tab;
  if(tab&&tab!=='moa-plus'){r475ExitUntilHidden=true;close();}
 },true);}

function render(){if(!ui.open||!view)return;ui.requestGeneration++;view.replaceChildren();view.dataset.page=ui.page;
 ui.page==='day'?renderDay():renderMonth();view.append(elem('div','moa-r469-status',''));view.scrollTop=0;r472Nav();setTimeout(r472RefreshVisibleThumbs,600);}
function header(title,back){const h=elem('header','moa-r469-head');h.append(btn('‹',back,'moa-r469-back'),elem('strong','',title));return h;}
function r483MonthKey(date){return `${date.getFullYear()}-${String(date.getMonth()+1).padStart(2,'0')}`}
function r483MonthDate(str){const [y,m]=str.split('-').map(Number);return new Date(y,m-1,1)}
function r483JumpToMonth(y,m){
 if(y<1900||y>2100||m<0||m>11)return;
 ui.month=new Date(y,m,1);render();
}
function r479PeriodSheet(){
 if($('.moa-r479-picker-backdrop',view))return;
 let selectedYear=ui.month.getFullYear();const selectedMonth=ui.month.getMonth();
 const shade=elem('div','moa-r479-picker-backdrop');shade.setAttribute('role','presentation');
 const sheet=elem('section','moa-r479-picker-sheet moa-r483-picker-sheet');sheet.setAttribute('role','dialog');sheet.setAttribute('aria-modal','true');sheet.setAttribute('aria-label','연도와 월 이동');
 const heading=elem('div','moa-r479-picker-heading');heading.append(elem('strong','','연도 · 월 선택'),btn('×',()=>shade.remove(),'moa-r479-picker-close'));sheet.append(heading);
 const picker=elem('div','moa-r483-picker-columns'),years=elem('div','moa-r483-year-list'),months=elem('div','moa-r483-picker-months');
 years.setAttribute('role','listbox');years.setAttribute('aria-label','연도 선택');
 const updateYear=year=>{
  selectedYear=year;
  for(const b of years.children){const active=Number(b.dataset.year)===year;b.classList.toggle('active',active);b.setAttribute('aria-selected',String(active))}
  for(const b of months.children)b.classList.toggle('active',Number(b.dataset.month)===selectedMonth&&year===ui.month.getFullYear());
 };
 for(let y=1900;y<=2100;y++){
  const b=btn(String(y),()=>updateYear(y),'moa-r483-year-option'+(y===selectedYear?' active':''));b.dataset.year=String(y);b.setAttribute('role','option');b.setAttribute('aria-selected',String(y===selectedYear));years.append(b)
 }
 for(let m=0;m<12;m++){
  const b=btn(String(m+1)+'월',()=>{shade.remove();r483JumpToMonth(selectedYear,m)},'moa-r483-month-option'+(m===selectedMonth?' active':''));b.dataset.month=String(m);months.append(b)
 }
 const label=elem('div','moa-r483-picker-labels');label.append(elem('span','','연도'),elem('span','','월'));sheet.append(label);
 picker.append(years,months);sheet.append(picker);
 sheet.append(elem('p','moa-r479-picker-hint','연도를 스크롤해 선택하고 월을 누르면 해당 달로 이동합니다.'));
 shade.append(sheet);shade.addEventListener('click',e=>{if(e.target===shade)shade.remove()});shade.addEventListener('keydown',e=>{if(e.key==='Escape'){shade.remove();e.preventDefault()}});
 view.append(shade);
 requestAnimationFrame(()=>{const active=years.querySelector('.active');if(active)years.scrollTop=active.offsetTop-years.offsetTop-years.clientHeight/2+active.clientHeight/2});
}
function r479SetSource(source){
 if(!['curated','automatic'].includes(source)||ui.source===source)return;
 ui.source=source;ui.idx=0;render();
}
function r483Pill(active,items,onSelect,cls){
 const wrap=elem('div','moa-r483-oval-switch '+cls);wrap.setAttribute('role','group');wrap.setAttribute('aria-label',cls==='moa-r483-photo-source'?'사진 범위 변경':'일기 보기 변경');wrap.dataset.source=active;
 const thumb=elem('span','moa-r483-thumb');thumb.setAttribute('aria-hidden','true');wrap.append(thumb);
 for(const item of items){
  const button=btn('',()=>{if(Date.now()<r479SwipeBlockUntil)return;onSelect(item.key)},'moa-r483-toggle-hit');button.dataset.option=item.key;button.setAttribute('aria-label',item.label);button.setAttribute('aria-pressed',String(item.key===active));button.title=item.label;wrap.append(button)
 }
 let begin=null;
 wrap.addEventListener('pointerdown',e=>{begin={id:e.pointerId,x:e.clientX,y:e.clientY}});
 wrap.addEventListener('pointerup',e=>{
  if(!begin||begin.id!==e.pointerId)return;const dx=e.clientX-begin.x,dy=e.clientY-begin.y;begin=null;
  if(Math.abs(dx)>15&&Math.abs(dx)>Math.abs(dy)*1.1){r479SwipeBlockUntil=Date.now()+300;onSelect(dx>0?items[1].key:items[0].key)}
 });
 wrap.addEventListener('pointercancel',()=>{begin=null});return wrap;
}
function r479SourceControl(){
 return r483Pill(ui.source,[{key:'curated',label:'내가 고른 사진'},{key:'automatic',label:'전체 사진'}],r479SetSource,'moa-r483-photo-source');
}
/* R483: Photos365-style VERTICAL calendar feed. No pointer-based horizontal month jumps. */
let r483Feed=null,r483OnScroll=0,r483ExtendBusy=false,r483ImageObserver=null;
function r483MonthSection(date){
 const y=date.getFullYear(),m=date.getMonth(),days=new Date(y,m+1,0).getDate(),offset=new Date(y,m,1).getDay();
 const section=elem('section','moa-r483-month');section.dataset.month=r483MonthKey(date);
 section.append(elem('h2','moa-r483-month-title',`${y}년 ${m+1}월`));
 const grid=elem('div','moa-r469-month-grid');grid.setAttribute('aria-label',`${y}년 ${m+1}월 달력`);
 for(const dow of ['일','월','화','수','목','금','토'])grid.append(elem('span','moa-r469-week',dow));
 for(let i=0;i<offset;i++)grid.append(elem('span','moa-r469-blank'));
 const prefix=`${y}-${String(m+1).padStart(2,'0')}-`;
 for(let n=1;n<=days;n++){
  const d=prefix+String(n).padStart(2,'0'),photo=mainCover(d,mediaFor(d));
  const tile=btn('',()=>{if(Date.now()<r479SwipeBlockUntil)return;ui.selected=d;ui.date=d;ui.month=new Date(y,m,1);ui.page='day';ui.idx=0;ui.fast=false;render()},'moa-r469-date');
  tile.setAttribute('aria-label',`${d} 일기 및 가족 일정`);tile.dataset.day=d;
  if(d===ui.selected)tile.classList.add('selected');if(d===dayOf(Date.now()))tile.classList.add('today');
  if(photo){const img=elem('img');img.dataset.id=String(photo.id);img.alt='';img.draggable=false;tile.append(img);if(isVideo(photo))tile.append(elem('span','moa-r469-video-mark','▶'))}
  tile.append(elem('span','moa-r469-day-number',n));
  const lane=elem('span','moa-r483-event-lane');lane.setAttribute('aria-hidden','true');
  if(r475Events(d).length){const mark=elem('span','moa-r475-event-mark');lane.append(mark)}
  tile.append(lane);
  if(getState()?.curatedEntries?.has(d)){const mark=elem('span','moa-r469-record-mark','•');tile.append(mark)}
  grid.append(tile);
 }
 let after=(offset+days)%7;if(after)for(;after<7;after++)grid.append(elem('span','moa-r469-blank moa-r479-trailing-blank'));
 section.append(grid);return section;
}
function r483FetchMonth(section){
 if(!section||!section.isConnected)return;
 const images=[...section.querySelectorAll('img[data-id]:not(.moa-r472-image-ready)')];
 if(images.length)fillImages(images.slice(0,32));
}
function r483SyncToolbar(){
 if(!r483Feed||!r483Feed.isConnected)return;
 const sections=[...r483Feed.children];if(!sections.length)return;
 let active=sections[0];const top=r483Feed.getBoundingClientRect().top;
 for(const section of sections){if(section.getBoundingClientRect().top<=top+78)active=section;else break}
 const displayed=r483MonthDate(active.dataset.month),title=$('.moa-r479-period strong',view);
 if(title)title.textContent=`${displayed.getFullYear()}년 ${displayed.getMonth()+1}월`;
 ui.month=displayed;
}
function r483EnqueueMonth(direction){
 if(r483ExtendBusy||!r483Feed||!r483Feed.isConnected)return;
 const feed=r483Feed,children=[...feed.querySelectorAll(':scope > .moa-r483-month')];
 if(!children.length)return;
 r483ExtendBusy=true;
 const current=direction<0?children[0]:children[children.length-1],date=r483MonthDate(current.dataset.month);
 const news=[];
 for(let j=1;j<=2;j++){
  const next=new Date(date.getFullYear(),date.getMonth()+direction*j,1);
  if(next.getFullYear()<1900||next.getFullYear()>2100)break;
  news.push(r483MonthSection(next));
 }
 if(direction<0){
  const originalHeight=feed.scrollHeight;
  for(const section of news)feed.prepend(section);
  feed.scrollTop+=feed.scrollHeight-originalHeight;
 }else for(const section of news)feed.append(section);
 // Keep a bounded render window while retaining the anchored scroll position.
 const all=[...feed.querySelectorAll(':scope > .moa-r483-month')];
 if(all.length>18){
  const remove=all.slice(direction<0?18:0,direction<0?undefined:all.length-18);
  const oldHeight=feed.scrollHeight;
  for(const section of remove){r483ImageObserver?.unobserve(section);section.remove()}
  if(direction>0)feed.scrollTop-=oldHeight-feed.scrollHeight;
 }
 for(const section of news)r483ImageObserver?.observe(section);
 r483ExtendBusy=false;
}
function r483HandleScroll(){
 if(!r483Feed)return;
 const feed=r483Feed;
 r483SyncToolbar();
 if(feed.scrollTop+feed.clientHeight>feed.scrollHeight-360)r483EnqueueMonth(1);
 if(feed.scrollTop<340)r483EnqueueMonth(-1);
}
function renderMonth(){
 if(!getState())return;
 r483ImageObserver?.disconnect();r483ImageObserver=null;r483Feed=null;r483ExtendBusy=false;
 const toolbar=elem('div','moa-r479-calendar-toolbar');
 const period=btn('',r479PeriodSheet,'moa-r479-period');period.append(elem('strong','',`${ui.month.getFullYear()}년 ${ui.month.getMonth()+1}월`),elem('span','','⌄'));period.setAttribute('aria-label','연도와 월 선택');toolbar.append(period);
 const right=elem('div','moa-r479-right-stack');right.append(btn('오늘',()=>{ui.month=new Date(new Date().getFullYear(),new Date().getMonth(),1);ui.selected=dayOf(Date.now());render()},'moa-r479-today'));right.append(r479SourceControl());toolbar.append(right);view.append(toolbar);
 const feed=elem('div','moa-r483-month-feed');feed.setAttribute('role','region');feed.setAttribute('aria-label','월별 사진 일기, 위아래로 스크롤');r483Feed=feed;
 const selected=new Date(ui.month.getFullYear(),ui.month.getMonth(),1);
 for(let offset=-1;offset<=4;offset++){
  const section=r483MonthSection(new Date(selected.getFullYear(),selected.getMonth()+offset,1));feed.append(section)
 }
 view.append(feed);
 r483ImageObserver=new IntersectionObserver(entries=>{for(const entry of entries)if(entry.isIntersecting)r483FetchMonth(entry.target)},{root:feed,rootMargin:'240px 0px'});
 for(const section of feed.children)r483ImageObserver.observe(section);
 feed.addEventListener('scroll',()=>{if(r483OnScroll)return;r483OnScroll=requestAnimationFrame(()=>{r483OnScroll=0;r483HandleScroll()})},{passive:true});
 requestAnimationFrame(()=>{
  if(!feed.isConnected)return;
  const section=feed.querySelectorAll(':scope > .moa-r483-month')[1];
  if(section)feed.scrollTop=section.offsetTop;
  r483SyncToolbar();
 });
}
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
 familyTop.append(btn('＋ 일정',()=>r479ScheduleEditor(d,null),'moa-r475-family-manage'));
 family.append(familyTop);
 if(dayEvents.length){const list=elem('div','moa-r475-family-list');dayEvents.forEach(ev=>{
  const entry=btn('',()=>r479ScheduleEditor(d,ev),'moa-r475-family-item');const time=String(ev?.allDay?'종일':ev?.start||'');
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
