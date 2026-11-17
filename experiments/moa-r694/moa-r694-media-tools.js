/* MOA R694 - diary-only media batch exclusion; original MediaStore untouched. */
(()=>{'use strict';
const DB='familyjourney-diary-v1', COVER='calendar-covers-r29';
const validDay=s=>/^\d{4}-(0[1-9]|1[0-2])-(0[1-9]|[12]\d|3[01])$/.test(s||'')&&
  !Number.isNaN(Date.parse(s+'T12:00:00'));
const validId=s=>/^(?:v?[0-9]{1,18})$/.test(String(s));
const st=()=>window.FamilyJourneyDiary?.state;
const $=s=>document.querySelector(s);
const mediaForDay=(day,mode)=>{
 const x=st();if(!x)return [];
 const row=x.curatedEntries?.get(day),auto=x.entries?.get(day);
 const record=mode==='automatic'?auto:row;
 const hidden=new Set([...(row?.removedMediaIds||[]),...(record?.removedMediaIds||[])].map(String));
 const ids=new Set();
 if(mode==='automatic'){
  for(const p of [...(x.byDay?.get(day)||[]),...(x.byVideoDay?.get(day)||[])])ids.add(String(p.id));
 }
 for(const id of record?.photoIds||[])ids.add(String(id));
 if(mode!=='automatic')for(const moment of record?.moments||[]){
   const time=Number(moment?.at);if(!Number.isFinite(time)||new Date(time).toLocaleDateString('en-CA')!==day)continue;
   for(const id of moment.photoIds||[])ids.add(String(id));
 }
 return [...ids].filter(id=>validId(id)&&!hidden.has(id)).map(id=>{
  const m=x.byId?.get(id);return {id,video:id.startsWith('v'),t:Number(m?.t)||0};
 }).sort((a,b)=>a.t-b.t);
};
function activeContext(){
 const p=window.MoaR469SimpleDiary?.readOnlyStatus?.();
 if(p?.active&&p.page==='day'&&validDay(p.date))return {day:p.date,mode:'curated',owner:'photo'};
 const d=st();if(d?.open&&d.page==='day'&&validDay(d.date))
  return {day:d.date,mode:d.mode==='automatic'?'automatic':'curated',owner:'detail'};
 return null;
}
let popup=null,busy=false;
function close(){if(popup){popup.remove();popup=null}window.__moaR694SelectorOpen=false;document.body.classList.remove('moa-r694-selection-open');}
async function batchExclude(context,selected){
 if(busy)return false;
 const {day,mode}=context,ids=[...new Set([...selected].map(String))];
 if(!validDay(day)||!['automatic','curated'].includes(mode)||!ids.length||!ids.every(validId))return false;
 const fresh=activeContext();
 if(!fresh||fresh.day!==day||fresh.mode!==mode){alert('날짜가 변경되었습니다. 일기를 다시 열고 선택해 주세요.');return false;}
 const diary=st();
 if((context.owner==='photo'&&window.MoaR469SimpleDiary?.readOnlyStatus?.()?.dirty)||
    (context.owner==='detail'&&diary?.dirty&&diary?.editing)){
   alert('작성 중인 일기를 먼저 저장해 주세요.');return false;
 }
 const visible=new Set(mediaForDay(day,mode).map(x=>x.id));
 if(!ids.every(id=>visible.has(id))){alert('선택한 사진이 변경되었습니다. 다시 확인해 주세요.');return false;}
 const typeCount=ids.filter(x=>x.startsWith('v')).length;
 if(!confirm(`일기에서 ${ids.length}개를 한 번에 제외할까요?\n사진 ${ids.length-typeCount}개 · 영상 ${typeCount}개\n\n휴대폰 원본 파일, 일기 글, 녹음, 바로기록은 삭제되지 않습니다.`))return false;
 busy=true;
 const table=mode==='automatic'?'entries':'curated';
 try{
  const db=await new Promise((resolve,reject)=>{const q=indexedDB.open(DB);q.onsuccess=()=>resolve(q.result);q.onerror=()=>reject(q.error)});
  let saved;
  try{
   saved=await new Promise((resolve,reject)=>{
    const tx=db.transaction(table,'readwrite'),store=tx.objectStore(table);
    store.get(day).onsuccess=e=>{
     const old=e.target.result||{day,selectionMode:mode==='automatic'?'automatic':'manual',photoIds:[],moments:[],activities:{}};
     saved={...old,day,photoIds:(old.photoIds||[]).map(String).filter(id=>!ids.includes(id)),
       removedMediaIds:[...new Set([...(old.removedMediaIds||[]).map(String),...ids])],updatedAt:Date.now()};
     store.put(saved);
    };
    tx.oncomplete=()=>resolve(saved);tx.onerror=()=>reject(tx.error);tx.onabort=()=>reject(tx.error||Error('transaction aborted'));
   });
  }finally{db.close()}
  if(!saved||!ids.every(id=>saved.removedMediaIds.includes(id)))throw Error('save not verified');
  (table==='curated'?diary.curatedEntries:diary.entries)?.set(day,saved);
  if(diary.selection)for(const id of ids)diary.selection.delete(id);
  let cv=diary.covers||{};if(ids.includes(String(cv?.[mode]?.[day]||''))){
   cv={...cv,[mode]:{...cv[mode]}};delete cv[mode][day];
   const db2=await new Promise((resolve,reject)=>{const q=indexedDB.open(DB);q.onsuccess=()=>resolve(q.result);q.onerror=()=>reject(q.error)});
   try{await new Promise((resolve,reject)=>{const tx=db2.transaction('meta','readwrite');tx.objectStore('meta').put(cv,COVER);tx.oncomplete=resolve;tx.onerror=()=>reject(tx.error)});}finally{db2.close()}
   diary.covers=cv;
  }
  close();
  if(context.owner==='photo')window.MoaR469SimpleDiary?.openDay?.(day);
  else if(context.owner==='detail')window.FamilyJourneyDiary?.selectDay?.(day);
  alert(`일기에서 ${ids.length}개를 제외했어요.\n원본 사진·영상은 그대로이며 상세형에서 다시 표시할 수 있습니다.`);
  return true;
 }catch(e){alert('일기에서 제외하지 못했습니다: '+String(e));return false;}
 finally{busy=false}
}
function open(context,items,initial){
 if(popup||busy)return false;
 if(!context||!validDay(context.day))return false;
 const available=new Set(mediaForDay(context.day,context.mode).map(x=>x.id));
 const records=Array.isArray(items)&&items.length?items.map(String).filter(x=>available.has(x)):[...available];
 if(!records.length)return false;
 const selected=new Set(available.has(String(initial))?[String(initial)]:[]);
 const shade=document.createElement('div');shade.className='moa-r694-shade';shade.id='moa-r694-media-selector';
 const dialog=document.createElement('section');dialog.className='moa-r694-dialog';dialog.setAttribute('role','dialog');dialog.setAttribute('aria-modal','true');
 const head=document.createElement('header');const title=document.createElement('strong');title.textContent='일기에서 제외할 사진·영상 선택';
 const counter=document.createElement('small');head.append(title,counter);dialog.append(head);
 const top=document.createElement('div');top.className='moa-r694-top';
 const all=document.createElement('button');all.textContent='전체 선택';
 const clear=document.createElement('button');clear.textContent='선택 해제';top.append(all,clear);dialog.append(top);
 const grid=document.createElement('div');grid.className='moa-r694-grid';
 const imgs=[];
 for(let i=0;i<records.length;i++){
  const id=records[i];const b=document.createElement('button');b.type='button';b.className='moa-r694-tile';b.dataset.id=id;
  const img=document.createElement('img');img.alt='';img.loading='lazy';
  const mark=document.createElement('span');mark.className='moa-r694-mark';
  const label=document.createElement('span');label.className='moa-r694-kind';label.textContent=id.startsWith('v')?'영상':'사진';
  b.append(img,mark,label);b.onclick=()=>{selected.has(id)?selected.delete(id):selected.add(id);sync()};
  grid.append(b);imgs.push([id,img]);
 }
 dialog.append(grid);
 const foot=document.createElement('footer');const cancel=document.createElement('button');cancel.textContent='취소';cancel.onclick=close;
 const remove=document.createElement('button');remove.className='moa-r694-delete';remove.textContent='선택한 항목 제외';remove.onclick=()=>batchExclude(context,selected);
 foot.append(cancel,remove);dialog.append(foot);shade.append(dialog);
 const sync=()=>{counter.textContent=`${selected.size} / ${records.length}개 선택`;
  remove.disabled=!selected.size||busy;for(const b of grid.children){const yes=selected.has(b.dataset.id);b.classList.toggle('selected',yes);b.setAttribute('aria-pressed',String(yes));}};
 all.onclick=()=>{for(const id of records)selected.add(id);sync()};clear.onclick=()=>{selected.clear();sync()};
 shade.addEventListener('click',e=>{if(e.target===shade)close()});
 window.__moaR694SelectorOpen=true;popup=shade;document.body.append(shade);document.body.classList.add('moa-r694-selection-open');sync();
 // Existing trusted native thumb bridge. Never send IDs to a server.
 const get=window.__requestThumbs;
 if(typeof get==='function')for(let i=0;i<imgs.length;i+=15){const slice=imgs.slice(i,i+15),ids=slice.map(x=>x[0]);
  Promise.resolve().then(()=>get(ids,260)).then(found=>{if(!shade.isConnected)return;
   for(const [id,img] of slice){const value=found instanceof Map?found.get(id):found?.[id];
    if(typeof value==='string'&&value.startsWith('data:image/'))img.src=value;
   }
  }).catch(()=>{});
 }
 return true;
}
window.__moaR694SetCover=async(day,id)=>{
 day=String(day||'');id=String(id||'');if(!validDay(day)||!validId(id))return false;
 const ctx=activeContext(),diary=st();
 if(!ctx||ctx.day!==day||!mediaForDay(day,ctx.mode).some(x=>x.id===id)||!diary)return false;
 try{
  const covers={...(diary.covers||{}),[ctx.mode]:{...(diary.covers?.[ctx.mode]||{})}};
  covers[ctx.mode][day]=id;
  const database=await new Promise((resolve,reject)=>{const q=indexedDB.open(DB);q.onsuccess=()=>resolve(q.result);q.onerror=()=>reject(q.error)});
  try{await new Promise((resolve,reject)=>{const tx=database.transaction('meta','readwrite');tx.objectStore('meta').put(covers,COVER);tx.oncomplete=resolve;tx.onerror=()=>reject(tx.error)})}
  finally{database.close()}
  diary.covers=covers;
  if(ctx.owner==='photo'){window.MoaLocalAudio?.closeNativeGallery?.();window.MoaR469SimpleDiary?.openDay?.(day)}
  alert('대표 사진을 맨 앞에 배치했어요. 나머지 촬영 순서는 그대로입니다.');return true;
 }catch(e){alert('대표 사진 지정 실패: '+String(e));return false}
};
window.MoaR694MediaUI=Object.freeze({
 openFromNative(day,current,ids){const ctx=activeContext();if(!ctx||ctx.day!==day)return false;
  return open(ctx,Array.isArray(ids)?ids:[],current);},
 openDetail(){const ctx=activeContext();return !!ctx&&ctx.owner==='detail'&&open(ctx,[],null);},
 close,
});
const observer=new MutationObserver(()=>{
 const manager=document.querySelector('#fj-diary-root .fd56-manage');
 if(!manager||manager.querySelector('.moa-r694-multi-entry'))return;
 const button=document.createElement('button');button.type='button';button.className='moa-r694-multi-entry';
 button.textContent='여러 사진·영상 한 번에 제외';button.onclick=()=>window.MoaR694MediaUI.openDetail();
 manager.insertBefore(button,manager.querySelector('.fd56-manage-list'));
});observer.observe(document.documentElement,{childList:true,subtree:true});
document.addEventListener('keydown',e=>{if(popup&&['Escape','Backspace'].includes(e.key)){
 e.preventDefault();e.stopImmediatePropagation();close();}},true);
})();
