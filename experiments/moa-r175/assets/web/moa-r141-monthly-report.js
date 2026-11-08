/* MOA R143: complete, virtualized monthly photo/video report. READ ONLY.
 * No mutations of Diary, photo-index, Family Calendar, original media or locations.
 * User requested ALL indexed media rather than 9 fixed preview thumbnails.
 */
(()=>{'use strict';
const ROOT_ID='moa-r141-report', VIEW_ID='moa-r143-month-viewer';
const $=(s,r=document)=>r.querySelector(s);
const el=(tag,cls,value)=>{const e=document.createElement(tag);if(cls)e.className=cls;if(value!==undefined)e.textContent=String(value);return e;};
const btn=(label,cls,cb)=>{const e=el('button',cls,label);e.type='button';e.addEventListener('click',cb);return e;};
const fmt=n=>Number(n||0).toLocaleString('ko-KR');
const months=['JAN','FEB','MAR','APR','MAY','JUN','JUL','AUG','SEP','OCT','NOV','DEC'];
const ID_RE=/^(?:v\d{1,18}|\d{1,19})$/;
const isVideo=p=>p.video||String(p.id).startsWith('v');
const native=(command,id)=>{try{if(typeof window.NativeHost?.post==='function'){window.NativeHost.post(command,JSON.stringify({id}));return true;}}catch(e){console.warn('MOA media action',e);}return false;};
let report=null,viewer=null,shownMonth=null,cache=new Map(),pending=new Set(),sliceKey='',rendering=false;
let videoCtx=null,backWrapped={},gridCleanup=null,monthMotion=null;
const diary=()=>window.FamilyJourneyDiary?.state||null;
function collectMonth(state,year,month){
 const prefix=`${year}-${String(month+1).padStart(2,'0')}-`;
 const media=[],unique=new Set(),shotDates=new Set(),approx=new Set(),dailyCounts=new Map();
 for(const [source,isVid] of [[state.byDay,false],[state.byVideoDay,true]]){
  if(!source||typeof source.entries!=='function')continue;
  for(const [day,items] of source.entries()){
   if(typeof day!=='string'||!/^\d{4}-\d\d-\d\d$/.test(day)||!day.startsWith(prefix)||!Array.isArray(items))continue;
   for(const item of items){const id=String(item?.id||'');if(!ID_RE.test(id)||unique.has(id))continue;
    unique.add(id);shotDates.add(day);dailyCounts.set(day,(dailyCounts.get(day)||0)+1);
    const row={id,day,t:Number(item?.t)||0,approx:!!item?.approx,video:isVid||!!item?.video||id.startsWith('v'),duration:Number(item?.duration)||0};
    media.push(row);if(row.approx)approx.add(id);
   }
  }
 }
 const writtenDays=new Set();for(const source of [state.entries,state.curatedEntries]){
  if(!source||typeof source.keys!=='function')continue;
  for(const key of source.keys())if(typeof key==='string'&&/^\d{4}-\d\d-\d\d$/.test(key)&&key.startsWith(prefix))writtenDays.add(key);
 }
 const daysInMonth=new Date(year,month+1,0).getDate(),daily=[];
 for(let i=1;i<=daysInMonth;i++){
  const key=prefix+String(i).padStart(2,'0');daily.push({day:i,count:dailyCounts.get(key)||0,diary:writtenDays.has(key)});
 }
 // Newest first, stable original MediaStore id tie-breaker. Both videos and photos.
 media.sort((a,b)=>b.day.localeCompare(a.day)||b.t-a.t||a.id.localeCompare(b.id));
 return {year,month,media,photoCount:media.filter(x=>!x.video).length,videoCount:media.filter(x=>x.video).length,
  shootingDays:shotDates.size,diaryDays:writtenDays.size,approxCount:approx.size,daily,daysInMonth};
}
function closeViewer(){if(monthMotion){monthMotion.destroy();monthMotion=null;}if(window.__moaR169MonthVideo){window.__moaR169MonthVideo.destroy();window.__moaR169MonthVideo=null;}if(!viewer)return false;viewer.remove();viewer=null;videoCtx=null;return true;}
function close(){if(viewer){closeViewer();return true;}if(!report)return false;gridCleanup?.();gridCleanup=null;report.remove();report=null;shownMonth=null;cache.clear();pending.clear();sliceKey='';return true;}
function onBack(){if(viewer)return closeViewer();if(report)return close();return false;}
function wrapBack(){for(const k of ['__fjBackOverlay','__photoMapBack']){
 const prev=window[k];if(typeof prev!=='function'||prev.__moaR143Back)return;
 const wrapped=function(...args){if(onBack())return true;return prev.apply(this,args);};
 wrapped.__moaR143Back=true;window[k]=wrapped;backWrapped[k]=wrapped;
 }}
function stat(label,n){const x=el('div','moa-r141-stat');x.append(el('strong','',fmt(n)),el('span','',label));return x;}
function formatTime(p){if(Number(p.t)>946684800000){try{return new Date(p.t).toLocaleString('ko-KR',{year:'numeric',month:'long',day:'numeric',hour:'2-digit',minute:'2-digit',second:'2-digit',hour12:false});}catch(_){}}return p.day+' · 원본 촬영시각 미확인';}
function photoUrl(id){return 'https://familyjourney.local/fj-photo/'+encodeURIComponent(id)+'.jpg';}
function getThumbs(ids,size){if(typeof window.__requestThumbs!=='function')return Promise.resolve(new Map());try{return Promise.resolve(window.__requestThumbs(ids,size)).catch(()=>new Map());}catch(_){return Promise.resolve(new Map());}}
function requestVisibleThumbs(ids){if(!report)return;
 const todo=ids.filter(id=>!cache.has(id)&&!pending.has(id));
 for(let j=0;j<todo.length;j+=18){const batch=todo.slice(j,j+18);batch.forEach(id=>pending.add(id));
  getThumbs(batch,170).then(map=>{if(!report)return;batch.forEach(id=>{
   pending.delete(id);const v=map?.get?.(id);if(typeof v==='string'&&v.startsWith('data:image/')&&v.length<800000){
    cache.set(id,v);if(cache.size>105)cache.delete(cache.keys().next().value);
    const mounted=report.querySelector(`.moa-r143-media[data-id="${id}"] img`);if(mounted)mounted.src=v;
   }
  });}).catch(()=>batch.forEach(id=>pending.delete(id)));
 }
}
function openViewer(index){if(!shownMonth?.media?.length||!report)return;
 const nativeApi=window.MoaLocalAudio;
 if(typeof nativeApi?.openNativeGallery==='function'){
  try{
   const items=shownMonth.media;
   const selected=Math.max(0,Math.min(items.length-1,Math.floor(index||0)));
   if(nativeApi.openNativeGallery(JSON.stringify(items.map(p=>String(p.id||''))),selected,String(shownMonth.day||shownMonth.month||''))){
    closeViewer();return;
   }
  }catch(e){console.warn('Native monthly Gallery unavailable; using original viewer',e);}
 }
 closeViewer();const items=shownMonth.media;let at=Math.max(0,Math.min(index,items.length-1));
 const layer=el('div','moa-r143-viewer');layer.id=VIEW_ID;layer.setAttribute('role','dialog');layer.setAttribute('aria-modal','true');layer.setAttribute('aria-label','월간 사진·영상 전체보기');
 const head=el('header','moa-r143-viewer-head');const back=btn('← 월간 목록','',closeViewer),count=el('span','','');head.append(back,count);
 const stamp=el('div','moa-r143-time','');const stage=el('div','moa-r143-viewer-stage');const photo=el('img','moa-r143-full');photo.alt='월간 사진';photo.draggable=false;
 const vid=el('div','moa-r143-video');const poster=el('img','');poster.alt='영상 미리보기';const play=btn('▶','moa-r143-play',()=>{
  const p=items[at];if(!p?.video)return;
  const id=p.id;
  if(window.__moaR169MonthVideo)return;
  closeViewer();if(!native('diaryPlayVideo',id))alert('동영상은 모아 Android 앱에서 재생할 수 있습니다.');
 });vid.append(poster,play);
 vid.addEventListener('click',e=>{if(e.target!==play)play.click();});
 const progress=el('span','moa-r143-progress',''),prev=btn('‹','moa-r143-left',()=>change(-1)),next=btn('›','moa-r143-right',()=>change(1));stage.append(photo,vid,progress,prev,next);
 const foot=el('footer','moa-r143-viewer-foot');
 const film=el('div','moa-r171-month-film');film.setAttribute('aria-label','월간 사진·영상 이어보기');
 const act=el('div','moa-r171-month-actions');
 act.append(btn('공유 · 카톡 등','',()=>{const p=items[at];native(p.video?'diaryShareVideo':'sharePhoto',p.id);}),
  btn('갤러리에서 열기','',()=>{const p=items[at];native(p.video?'diaryOpenVideoGallery':'openInGallery',p.id);}));
 foot.append(film,act);
 layer.append(head,stamp,stage,foot);document.body.append(layer);viewer=layer;wrapBack();
 let requestId=0;
 function renderFilm(){monthMotion?.setCurrent(at);}
 function render(){if(!viewer)return;
  renderFilm();
  if(window.__moaR169MonthVideo){window.__moaR169MonthVideo.destroy();window.__moaR169MonthVideo=null;}
  const p=items[at],v=p.video,seq=++requestId;
  count.textContent=`${fmt(at+1)} / ${fmt(items.length)}`;stamp.textContent=(p.approx?'촬영일(추정) · ':'촬영 · ')+formatTime(p);
  prev.disabled=at===0;next.disabled=at===items.length-1;photo.hidden=v;vid.hidden=!v;
  photo.removeAttribute('src');poster.removeAttribute('src');progress.textContent=v?'':'사진 불러오는 중…';
  if(v){play.textContent='▶';play.setAttribute('aria-label','동영상 재생');
    window.__moaR169MonthVideo=window.MoaInlineVideo?.mount(stage,p.id,{
      onReady:()=>{if(viewer&&seq===requestId)vid.hidden=true;},
      onError:()=>{if(viewer&&seq===requestId){window.__moaR169MonthVideo=null;vid.hidden=false;}},
      onNext:()=>monthMotion?.snap(at+1),onPrev:()=>monthMotion?.snap(at-1),onDrag:f=>monthMotion?.nativeDrag(f)});
    if(cache.get(p.id))poster.src=cache.get(p.id);else getThumbs([p.id],340).then(m=>{if(viewer&&seq===requestId){const s=m?.get?.(p.id);if(typeof s==='string'&&s.startsWith('data:image/'))poster.src=s;}});}
  else{photo.onload=()=>{if(seq===requestId)progress.textContent='';};photo.onerror=()=>{if(seq===requestId)progress.textContent='사진을 불러오지 못했습니다.';};photo.src=photoUrl(p.id);}
 }
 function change(dx){const nextIndex=at+dx;if(nextIndex>=0&&nextIndex<items.length){at=nextIndex;render();}}
 monthMotion=window.MoaGallerySmooth?.attach({
  strip:film,stage,items,getIndex:()=>at,select:i=>{at=i;render();},
  thumbs:getThumbs,photoUrl, isVideo,
  canSwipe:()=>true
 });
 render();
}
function makeGrid(panel,section,info,data){
 const grid=el('div','moa-r143-grid');grid.setAttribute('aria-label','이 달의 모든 사진과 동영상');section.append(grid);
 const current=data.media;
 if(!current.length){grid.append(el('p','moa-r141-empty','이 달에 사진·영상 색인이 없습니다.'));return;}
 const rowGap=6,columns=3;
 function renderSlice(){if(!grid.isConnected||!report||!shownMonth)return;
  const width=grid.getBoundingClientRect().width;
  if(width<=0)return;
  const tile=(width-rowGap*2)/columns,rowH=tile+rowGap,rows=Math.ceil(current.length/3);
  grid.style.height=Math.max(0,rows*rowH-rowGap)+'px';
  const panelRect=panel.getBoundingClientRect(),gridRect=grid.getBoundingClientRect();
  const relStart=Math.max(0,panelRect.top-gridRect.top-3*rowH),relEnd=Math.max(0,panelRect.bottom-gridRect.top+3*rowH);
  const start=Math.max(0,Math.floor(relStart/rowH)),end=Math.min(rows,Math.ceil(relEnd/rowH));
  const key=`${start}:${end}:${Math.round(width)}`;if(sliceKey===key)return;sliceKey=key;
  const fragment=document.createDocumentFragment(),need=[];
  for(let row=start;row<end;row++)for(let col=0;col<3;col++){
   const idx=row*3+col;if(idx>=current.length)break;const p=current[idx];const tileNode=btn('', 'moa-r143-media',()=>openViewer(idx));tileNode.dataset.id=p.id;
   tileNode.style.top=(row*rowH)+'px';tileNode.style.left=(col*(tile+rowGap))+'px';tileNode.style.width=tile+'px';tileNode.style.height=tile+'px';
   const img=el('img');img.alt=`${p.day} ${p.video?'영상':'사진'}`;img.loading='lazy';img.decoding='async';
   if(cache.has(p.id))img.src=cache.get(p.id);else need.push(p.id);
   tileNode.append(img);
   const dateLabel=el('span','moa-r143-date',p.day.slice(5).replace('-','.'));
   tileNode.append(dateLabel);
   if(p.video)tileNode.append(el('span','moa-r143-video-mark','▶ 영상'));
   fragment.append(tileNode);
  }
  grid.replaceChildren(fragment);requestVisibleThumbs(need);
 }
 let raf=false;function tick(){if(raf)return;raf=true;requestAnimationFrame(()=>{raf=false;renderSlice();});}
 panel.addEventListener('scroll',tick,{passive:true});window.addEventListener('resize',tick,{passive:true});gridCleanup=()=>{panel.removeEventListener('scroll',tick);window.removeEventListener('resize',tick);};requestAnimationFrame(renderSlice);
 info.textContent=`전체 ${fmt(current.length)}개 · 사진 ${fmt(data.photoCount)}장 + 영상 ${fmt(data.videoCount)}개 · 아래로 내려 모두 보기`;
}
function show(){const s=diary();if(!s?.open)return false;
 if(viewer)closeViewer();if(report)close();
 const m=s.month instanceof Date?s.month:new Date(),data=collectMonth(s,m.getFullYear(),m.getMonth());shownMonth=data;
 const overlay=el('div','moa-r141-overlay');overlay.id=ROOT_ID;overlay.setAttribute('role','dialog');overlay.setAttribute('aria-modal','true');
 const shade=el('div','moa-r141-shade');shade.addEventListener('click',close);
 const panel=el('section','moa-r141-panel');
 const top=el('header','moa-r141-top'),heading=el('div','moa-r141-headline');
 heading.append(el('span','moa-r141-overline','우리 가족의 한 달'),el('h2','',months[data.month]+' '+data.year),el('p','',`${data.month+1}월 · 실제 기기 사진 색인 기반`));
 top.append(heading,btn('닫기 ×','moa-r141-close',close));panel.append(top);
 const summary=el('div','moa-r141-summary');summary.append(stat('사진',data.photoCount),stat('동영상',data.videoCount),stat('촬영한 날짜',data.shootingDays),stat('저장된 일기 날짜',data.diaryDays));panel.append(summary);
 const trend=el('section','moa-r141-trend');trend.append(el('h3','','일자별 촬영 기록'));
 const bars=el('div','moa-r141-days'),max=Math.max(1,...data.daily.map(x=>x.count));
 for(const x of data.daily){const d=el('div','moa-r141-day');d.setAttribute('aria-label',`${x.day}일 사진·영상 ${x.count}개`);const track=el('div','moa-r141-track');const bar=el('span','moa-r141-bar');bar.style.height=(x.count?Math.max(10,Math.round(x.count/max*100)):0)+'%';if(!x.count)bar.classList.add('empty');track.append(bar);d.append(track,el('small','',String(x.day)));if(x.diary)d.classList.add('has-diary');bars.append(d);}trend.append(bars);panel.append(trend);
 const gallery=el('section','moa-r141-gallery');gallery.append(el('h3','','이달의 사진·영상 전체'));
 const galleryInfo=el('p','moa-r143-gallery-info','');gallery.append(galleryInfo);panel.append(gallery);
 panel.append(el('p','moa-r141-disclaimer',`현재 기기 사진·영상 색인만 읽어 표시합니다. 촬영시각 추정 ${fmt(data.approxCount)}개 포함 · 원본은 수정·이동·업로드하지 않습니다.`));
 panel.append(btn('일기로 돌아가기','moa-r141-done',close));overlay.append(shade,panel);document.body.append(overlay);report=overlay;
  makeGrid(panel,gallery,galleryInfo,data);
  // R167: jump in a virtual 700+ item grid without inserting 700 DOM nodes.
  // The month panel itself scrolls; never scroll the underlying Diary page.
  const jumps=el('nav','moa-r167-month-jumps');jumps.setAttribute('aria-label','월간 리포트 빠른 이동');
  const jumpTop=btn('↑ 맨 위','moa-r167-month-jump',()=>panel.scrollTo({top:0,behavior:'auto'}));
  const jumpBottom=btn('↓ 맨 아래','moa-r167-month-jump',()=>requestAnimationFrame(()=>{
    panel.scrollTo({top:panel.scrollHeight,behavior:'auto'});
    panel.dispatchEvent(new Event('scroll'));
  }));
  jumpTop.setAttribute('aria-label','월간 리포트 맨 위로 이동');
  jumpBottom.setAttribute('aria-label','월간 리포트 마지막 사진으로 이동');
  jumps.append(jumpTop,jumpBottom);overlay.append(jumps);
  function stateOfJump(){const atBottom=panel.scrollTop+panel.clientHeight>=panel.scrollHeight-50;
    jumpTop.disabled=panel.scrollTop<50;jumpBottom.disabled=atBottom;}
  panel.addEventListener('scroll',stateOfJump,{passive:true});
  requestAnimationFrame(stateOfJump);
  wrapBack();return true;
}
let queued=false;
function enhance(){queued=false;const root=$('#fj-diary-root'),s=diary();if(!root||!s?.open||s.page!=='calendar'||root.hidden)return;
 const actions=$('.fd23-actions',root);if(!actions||$('.moa-r141-trigger',actions))return;
 actions.append(btn('월간 리포트 · 콜라주','fd23-btn moa-r141-trigger',show));
}
function schedule(){if(queued)return;queued=true;requestAnimationFrame(enhance);}
function init(){const root=$('#fj-diary-root');if(root)new MutationObserver(m=>{if(m.some(v=>v.type==='childList'))schedule();}).observe(root,{childList:true,subtree:false});
 const pages=$('#pages');if(pages)new MutationObserver(schedule).observe(pages,{childList:true,subtree:false});
 document.addEventListener('keydown',e=>{if((e.key==='Escape'||e.key==='Backspace')&&(viewer||report)){e.preventDefault();e.stopImmediatePropagation();onBack();}
 else if(viewer&&e.key==='ArrowLeft'){e.preventDefault();viewer.querySelector('.moa-r143-left')?.click();}
 else if(viewer&&e.key==='ArrowRight'){e.preventDefault();viewer.querySelector('.moa-r143-right')?.click();}},true);
 document.addEventListener('visibilitychange',()=>{if(!document.hidden)wrapBack();});
 schedule();}
if(document.readyState==='loading')document.addEventListener('DOMContentLoaded',init,{once:true});else init();
window.MoaMonthlyInsights={open:show,close,collectMonth,version:'R143'};
})();

/* R153: integrated original R151 add-on without new APK members or HTML loader edits. */

;(()=>{if(!document.getElementById("moa-r153-style")){const s=document.createElement("style");s.id="moa-r153-style";s.textContent="/* R151 additive presentation; preserved existing photo/Diary/media/native behavior */\n#moa-r151-popup-pref{padding:12px 4px;border-bottom:1px solid #eee3eb;list-style:none}\n.moa-r151-pref-label{display:flex;align-items:center;gap:12px;justify-content:space-between;cursor:pointer;color:#29252b}\n.moa-r151-pref-copy{display:flex;flex-direction:column;gap:5px;flex:1;min-width:0}\n.moa-r151-pref-copy strong{font-size:15px}.moa-r151-pref-copy small{font-size:12px;color:#8b8290;line-height:1.45}\n#moa-r151-popup-checkbox{position:absolute;opacity:0;width:1px;height:1px}\n.moa-r151-toggle-track{position:relative;display:block;flex:0 0 47px;width:47px;height:28px;border-radius:16px;background:#aaa3ab;transition:background .16s}\n.moa-r151-toggle-track::after{content:'';position:absolute;width:22px;height:22px;left:3px;top:3px;border-radius:50%;background:#fff;transition:transform .16s}\n#moa-r151-popup-checkbox:checked+.moa-r151-toggle-track{background:var(--moa-accent,var(--accent,#ee086d))}\n#moa-r151-popup-checkbox:checked+.moa-r151-toggle-track::after{transform:translateX(19px)}\n#moa-r151-popup-checkbox:focus-visible+.moa-r151-toggle-track{outline:3px solid #888}\n#fj-diary-root .moa-r151-group-tools{display:flex;flex-direction:column;align-items:flex-start;gap:6px;margin:10px 0 12px}\n#fj-diary-root .moa-r151-slot-record,#fj-diary-root .moa-r151-manage{border:1px solid #eed4df;background:#fff3f8;color:#b70653;font-weight:700;border-radius:12px;padding:9px 12px;font-size:13px;max-width:100%;text-align:left}\n#fj-diary-root .moa-r151-recordings{display:flex;flex-wrap:wrap;gap:6px;width:100%}\n#fj-diary-root .moa-r151-recording{display:flex;max-width:100%}\n#fj-diary-root .moa-r151-play{border:1px solid #dfd3dc;background:#fff;border-radius:14px;padding:8px 12px;color:#36313a;font-size:13px;white-space:normal}\n#fj-diary-root .moa-r151-standalone{border-top:1px dashed #ded7df;padding-top:14px;margin-top:16px}\n#fj-diary-root .moa-r151-standalone h3{font-size:15px;margin:0 0 12px}\n#fj-diary-root .moa-r151-empty{font-size:12px;color:#8b8792}\n#fj-diary-root .moa-r151-manage{margin-top:12px}\n.moa-r151-link-hint{background:#fff0f6;color:#ae0956;border-radius:12px;padding:10px;font-size:13px;line-height:1.5}\n";document.head.appendChild(s)}})();
/* MOA R151: gallery return choice and photo-time voice slots.
 * Does NOT replace legacy STT/MediaRecorder/photo/Diary writers.
 */
(()=>{'use strict';
 const KEY='moa.gallery.return.sheet.v1', SLOT='moa.voice.timeline.links.v1';
 const $=(s,root=document)=>root.querySelector(s);
 const enabled=()=>{try{return localStorage.getItem(KEY)!=='off';}catch(_){return true;}};
 const setEnabled=on=>{try{localStorage.setItem(KEY,on?'on':'off');}catch(_){}syncToggle();};
 window.MoaGalleryPreference={enabled,setEnabled};
 const mk=(tag,cls,content)=>{const n=document.createElement(tag);if(cls)n.className=cls;if(content!=null)n.textContent=content;return n;};
 function addSetting(){
  if($('#moa-r151-popup-pref'))return;
  let list=$('#moa-r117-photo-settings .moa-r117-inner-rows');
  if(!list)return;
  const li=mk('li','moa-r151-pref-row');li.id='moa-r151-popup-pref';
  const label=mk('label','moa-r151-pref-label');
  const copy=mk('span','moa-r151-pref-copy');copy.append(mk('strong','','사진 전체보기 후 목록으로 돌아가기'),mk('small','','켜기: 사진 목록 창으로 복귀 · 끄기: 이전 일기/지도 화면으로 바로 복귀'));
  const input=mk('input');input.type='checkbox';input.id='moa-r151-popup-checkbox';input.checked=enabled();
  input.setAttribute('role','switch');input.addEventListener('change',()=>setEnabled(input.checked));
  const track=mk('span','moa-r151-toggle-track');label.append(copy,input,track);li.append(label);list.append(li);
 }
 function syncToggle(){const control=$('#moa-r151-popup-checkbox');if(control)control.checked=enabled();}
 // Map's original place viewer leaves its place sheet open on viewer-close.
 // Preserve that exact behavior when enabled, otherwise close only parent sheet.
 let priorMapOpen=false,priorNaverOpen=false;
 function closeMapBackdropBeforeViewer(){
  if(enabled())return;
  const place=$('#place-root');if(place&&!place.hidden){
   place.hidden=true;
   try{window.__photoMap?.closePlace?.();}catch(_){}
  }
  $('#fj-naver-photo-sheet')?.remove();
 }
 function wrapMapHardwareBack(){
  const previous=window.__photoMapBack;
  if(typeof previous==='function'&&!previous.__moaR157){
   const wrap=function(...args){
    if(!enabled()&&((!$('#viewer-root')?.hidden)||!!$('#fj-naver-photo-full')))closeMapBackdropBeforeViewer();
    return previous.apply(this,args);
   };wrap.__moaR157=true;window.__photoMapBack=wrap;
  }
  const originalOverlayBack=window.__fjBackOverlay;
  if(typeof originalOverlayBack==='function'&&!originalOverlayBack.__moaR157){
   const wrapped=function(...args){
    if(!enabled()&&$('#fj-naver-photo-full'))closeMapBackdropBeforeViewer();
    return originalOverlayBack.apply(this,args);
   };wrapped.__moaR157=true;window.__fjBackOverlay=wrapped;
  }
 }
 let observedViewer=null;
 function observeViewerClose(){
  const viewer=$('#viewer-root');if(!viewer||viewer===observedViewer)return;
  observedViewer=viewer;
  new MutationObserver(()=>{if(!enabled()&&viewer.hidden){closeMapBackdropBeforeViewer();}})
   .observe(viewer,{attributes:true,attributeFilter:['hidden']});
 }
 function monitorMapClose(){
  const map=$('#viewer-root'),naver=$('#fj-naver-photo-full');
  const mapOpen=!!map&&!map.hidden,naverOpen=!!naver;
  if(!enabled()){
   if(priorMapOpen&&!mapOpen&&$('#place-root')?.hidden===false){
    try{window.__photoMap?.closePlace?.();}catch(_){}
   }
   if(priorNaverOpen&&!naverOpen){$('#fj-naver-photo-sheet')?.remove();if($('#place-root')?.hidden===false)try{window.__photoMap?.closePlace?.();}catch(_){}}
  }
  priorMapOpen=mapOpen;priorNaverOpen=naverOpen;
 }
 const voice=()=>window.MoaLocalAudio;
 const isVoiceReady=()=>!!voice()&&typeof voice().list==='function';
 function voices(day){try{const v=JSON.parse(voice()?.list(day)||'[]');return Array.isArray(v)?v.filter(x=>/^[-\w]{8,90}\.m4a$/.test(x?.id||'')):[];}catch(_){return [];}}
 function loadLinks(){try{const x=JSON.parse(localStorage.getItem(SLOT)||'{}');return x&&typeof x==='object'&&!Array.isArray(x)?x:{};}catch(_){return {};}}
 function saveLink(day,id,slot){if(!/^\d{4}-\d{2}-\d{2}$/.test(day)||!/^[-\w]{8,90}\.m4a$/.test(id))return;
  const all=loadLinks();all[day+'/'+id]=slot;
  try{localStorage.setItem(SLOT,JSON.stringify(all));}catch(_){}
 }
 function slotOf(time){const d=new Date(Number(time));if(!Number.isFinite(d.getTime()))return '';
  const hh=String(d.getHours()).padStart(2,'0'),mm=String(Math.floor(d.getMinutes()/5)*5).padStart(2,'0');return hh+':'+mm;
 }
 const day=()=>{const s=window.FamilyJourneyDiary?.state;return s?.open&&s.page==='day'?s.date:null;};
 const validDay=d=>/^\d{4}-\d{2}-\d{2}$/.test(d||'');
 let chosen=null,existing=new Set(),lastSaved='',rendering=false,lastSignature='';
 function showRecorder(day,slot){
  if(!isVoiceReady()){window.alert('Android 원본 음성 녹음 기능을 사용할 수 없습니다.');return;}
  const before=voices(day);existing=new Set(before.map(x=>x.id));
  chosen={day,slot,start:Date.now()};
  if(!window.MoaVoiceDiaryNative?.open?.()){chosen=null;return;}
  const panel=$('#moa-r149-voice-modal .moa-r149-panel');
  if(panel){$('#moa-r151-link-hint',panel)?.remove();const hint=mk('p','moa-r151-link-hint',`${slot} 사진 시간대에 연결할 음성을 녹음합니다. 녹음은 지금 시작되며, 저장 후 이 시간대에서 재생할 수 있습니다.`);hint.id='moa-r151-link-hint';panel.insertBefore(hint,panel.children[1]||null);}
 }
 // Preserve R149 native handler; new metadata is saved AFTER native successful save.
 function onAudioEvent(obj){
  if(!obj||!chosen)return;
  if(obj.event==='record_error'){chosen=null;return;}
  if(obj.event!=='record_saved')return;
  const pending=chosen;chosen=null;
  const latest=voices(pending.day).filter(x=>!existing.has(x.id)).sort((a,b)=>b.time-a.time);
  const match=latest[0];if(!match)return;
  saveLink(pending.day,match.id,pending.slot);lastSignature='';renderTimeline();
 }
 function wrapEvents(){const old=window.__moaNativeAudioEvent;
  if(typeof old!=='function'||old.__moaR151)return;
  const wrapped=function(x){const result=old.apply(this,arguments);try{onAudioEvent(x);}catch(err){console.warn('MOA audio timeline',err);}return result;};
  wrapped.__moaR151=true;window.__moaNativeAudioEvent=wrapped;
 }
 function addAudioRow(container,items,day){
   let list=$('.moa-r151-recordings',container);if(!list){list=mk('div','moa-r151-recordings');container.append(list);}
   const keep=new Set();
   for(const item of items){
    const key=day+'/'+item.id;keep.add(key);
    const time=new Date(Number(item.time));
    const stamp=Number.isFinite(time.getTime())?time.toLocaleTimeString('ko-KR',{hour:'2-digit',minute:'2-digit'}):'음성';
    const getMeta=()=>window.MoaVoicePlaybackUI?.metaFor?.(day,item.id)||{};
    const current=getMeta(),name=current.title||stamp;
    let row=[...list.children].find(x=>x.dataset.moaVoiceKey===key);
    if(row){
      const play=$('.moa-r151-play',row);if(play){play.dataset.moaAudioTitle=name;}
      row.moaR167Refresh?.();
      continue;
    }
    row=mk('div','moa-r151-recording moa-r167-voice-row');row.dataset.moaVoiceKey=key;
    const actions=mk('div','moa-r167-voice-actions');
    const play=mk('button','moa-r151-play',`▶ ${current.title||stamp+' · '+Math.round((item.bytes||0)/1024)+'KB'}`);
    play.type='button';play.dataset.moaAudioPlay=key;play.dataset.moaAudioTitle=name;
    play.addEventListener('click',()=>{try{if(window.MoaVoicePlaybackUI)window.MoaVoicePlaybackUI.play(day,item.id,play);else voice().play(day,item.id);}catch(e){console.warn(e);}});
    const expand=mk('button','moa-r167-voice-expand','▾ 내용·편집');expand.type='button';
    const preview=mk('p','moa-r167-voice-preview');
    const drawer=mk('div','moa-r167-voice-drawer');drawer.hidden=true;
    function refreshPreview(){const m=getMeta();const summary=String(m.transcript||m.autoTranscript||m.captureNote||'').trim();
      preview.textContent=summary?(m.transcript?'메모 · ':m.autoTranscript?'자동 글 · ':'촬영 메모 · ')+summary:'';
      preview.hidden=!summary;play.dataset.moaAudioTitle=m.title||stamp;
      if(!play.classList.contains('moa-voice-playing'))play.textContent='▶ '+(m.title||stamp+' · '+Math.round((item.bytes||0)/1024)+'KB');
    }
    const titleLabel=mk('label','moa-r167-field-label','녹음 이름');
    const title=mk('input','moa-r167-voice-name');title.type='text';title.maxLength=120;title.placeholder='예: 아이와 나눈 이야기';titleLabel.append(title);
    const auto=mk('div','moa-r167-auto-text');
    const captureNote=mk('div','moa-r169-capture-note');
    const noteLabel=mk('label','moa-r167-field-label','기록할 글');
    const note=mk('textarea','moa-r167-voice-text');note.rows=3;note.maxLength=50000;
    note.placeholder='녹음 내용을 직접 입력하거나 자동 인식된 글을 수정해 보관하세요.';noteLabel.append(note);
    const editActions=mk('div','moa-r167-edit-actions');
    const save=mk('button','moa-r167-voice-save','저장');save.type='button';
    const cancel=mk('button','moa-r167-voice-cancel','접기');cancel.type='button';
    const remove=mk('button','moa-r169-voice-delete','삭제');remove.type='button';
    remove.addEventListener('click',()=>{
      if(!window.confirm('이 녹음 원본을 정말 삭제할까요? 이 작업은 되돌릴 수 없습니다.'))return;
      const bridge=voice();if(!bridge||typeof bridge.delete!=='function')return;
      status.textContent='음성 원본 삭제 요청 중…';
      try{bridge.delete(day,item.id);}catch(e){status.textContent='삭제하지 못했습니다: '+e.message;}
    });
    const status=mk('div','moa-r167-edit-status','');status.setAttribute('role','status');
    save.addEventListener('click',()=>{
      const api=window.MoaVoicePlaybackUI;
      if(!api?.saveMeta){status.textContent='저장 기능이 아직 준비되지 않았습니다.';return;}
      if(api.saveMeta(day,item.id,title.value,note.value,true)){
        refreshPreview();status.textContent='이 녹음의 이름·글이 저장되었습니다.';
        drawer.hidden=true;expand.textContent='▾ 내용·편집';expand.setAttribute('aria-expanded','false');
      }else status.textContent='저장 실패 · 기존 내용은 유지됩니다.';
    });
    cancel.addEventListener('click',()=>{drawer.hidden=true;expand.textContent='▾ 내용·편집';expand.setAttribute('aria-expanded','false');});
    editActions.append(save,cancel,remove);
    drawer.append(auto,captureNote,titleLabel,noteLabel,editActions,status);
    expand.setAttribute('aria-expanded','false');
    expand.addEventListener('click',()=>{
      const willOpen=drawer.hidden;
      if(willOpen){
        const m=getMeta();title.value=m.title||'';note.value=m.transcript||'';
        auto.replaceChildren();const raw=String(m.autoTranscript||'').trim();
        auto.append(mk('strong','','녹음 텍스트 · 전체 보기'));
        if(raw){
          const full=mk('p','moa-r169-voice-fulltext',raw);auto.append(full);
          const copy=mk('button','moa-r167-copy-auto','이 글을 편집창에 복사');copy.type='button';
          copy.addEventListener('click',()=>{note.value=raw;status.textContent='자동 글을 가져왔습니다. 확인 후 저장해 주세요.';});
          auto.append(copy);
        }else{
          auto.append(mk('p','moa-r167-empty','이 녹음에 연결된 자동 인식 텍스트가 없습니다.'));
          const retry=mk('button','moa-r167-copy-auto','이 파일 자동 텍스트 인식');retry.type='button';
          retry.addEventListener('click',()=>{
            const api=window.MoaVoicePlaybackUI;
            if(!api?.requestTranscript){status.textContent='녹음 파일 인식 기능 연결을 찾지 못했습니다.';return;}
            api.requestTranscript(day,item.id,false);
            status.textContent='자동 인식 요청됨 · 완료 후 접었다 다시 펼쳐 확인해 주세요.';
          });auto.append(retry);
        }
        captureNote.replaceChildren();
        if(m.captureNote){captureNote.append(mk('strong','','촬영 당시 기록'));
          captureNote.append(mk('p','',String(m.captureNote)));}
        if(m.transcript){captureNote.append(mk('strong','','직접 저장된 글'));
          captureNote.append(mk('p','',String(m.transcript)));}
        status.textContent='';
      }
      drawer.hidden=!willOpen;
      expand.textContent=willOpen?'▴ 접기':'▾ 내용·편집';expand.setAttribute('aria-expanded',String(willOpen));
    });
    row.moaR167Refresh=refreshPreview;
    actions.append(play,expand);row.append(actions,preview,drawer);refreshPreview();list.append(row);
   }
   for(const child of [...list.children])if(!keep.has(child.dataset.moaVoiceKey))child.remove();
   window.MoaVoicePlaybackUI?.updatePlayback?.();
 }
 function renderTimeline(){if(rendering)return;rendering=true;try{
  const d=day(),root=$('#fj-diary-root');if(!validDay(d)||!root||root.hidden)return;
  const timeline=$('.fd23-timeline',root);if(!timeline)return;
  const sections=[...timeline.querySelectorAll('.fd23-log')];
  const entries=isVoiceReady()?voices(d):[],links=loadLinks();
  const signature=d+'|'+sections.map(x=>x.querySelector('.fd23-logtime strong')?.textContent||'').join('|')+'|'+entries.map(x=>x.id+':'+x.time+':'+links[d+'/'+x.id]).join('|');
  if(signature===lastSignature&&$('#moa-r151-standalone'))return;lastSignature=signature;
  const assigned=new Set();
  for(const section of sections){const header=$('.fd23-logtime strong',section);const label=header?.textContent||'';
   const m=label.match(/([01]\d|2[0-3]):([0-5]\d)/);if(!m)continue;
   const slot=m[1]+':'+String(Math.floor(Number(m[2])/5)*5).padStart(2,'0');
   let bar=$('.moa-r151-group-tools',section);if(!bar){bar=mk('div','moa-r151-group-tools');section.querySelector('.fd23-logtime')?.insertAdjacentElement('afterend',bar);}
    let add=$('.moa-r151-slot-record',bar);
    if(!add){add=mk('button','moa-r151-slot-record','● 이 시간대 음성 녹음');add.type='button';
      bar.append(add);}
    // Update the correct time slot without replacing existing playback or edit DOM.
    add.onclick=()=>showRecorder(d,slot);
   const attached=entries.filter(item=>{const assignedSlot=slotOf(item.time); /* R169 actual recording time only, no implicit backdated group. */ if(assignedSlot===slot){assigned.add(item.id);return true;}return false;});
   let fold=$('.moa-r169-slot-fold',bar);
   if(!fold){fold=mk('button','moa-r169-slot-fold','');fold.type='button';
     fold.setAttribute('aria-expanded','false');bar.append(fold);
     fold.addEventListener('click',()=>{const details=$('.moa-r169-slot-details',bar);if(!details)return;
       details.hidden=!details.hidden;fold.setAttribute('aria-expanded',String(!details.hidden));
       fold.textContent=(details.hidden?'▾ ':'▴ ')+(details.dataset.count||'0')+'개 음성';});}
   let details=$('.moa-r169-slot-details',bar);
   if(!details){details=mk('div','moa-r169-slot-details');details.hidden=true;bar.append(details);}
   details.dataset.count=String(attached.length);
   fold.hidden=attached.length===0;
   fold.textContent=(details.hidden?'▾ ':'▴ ')+attached.length+'개 음성';
   addAudioRow(details,attached,d);
  }
  let standalone=$('#moa-r151-standalone');if(!standalone){standalone=mk('section','moa-r151-standalone');standalone.id='moa-r151-standalone';timeline.append(standalone);}
   const others=entries.filter(x=>!assigned.has(x.id));
   let heading=$('.moa-r151-unlinked-title',standalone);
   if(!heading){heading=mk('h3','moa-r151-unlinked-title','사진 시간대 밖에 녹음한 음성');standalone.append(heading);}
   heading.hidden=!others.length;
   let otherFold=$('.moa-r169-others-fold',standalone);
   if(!otherFold){otherFold=mk('button','moa-r169-others-fold','');otherFold.type='button';standalone.append(otherFold);
     otherFold.addEventListener('click',()=>{const details=$('.moa-r169-others-details',standalone);
       if(!details)return;details.hidden=!details.hidden;
       otherFold.setAttribute('aria-expanded',String(!details.hidden));
       otherFold.textContent=(details.hidden?'▾ ':'▴ ')+(details.dataset.count||'0')+'개 녹음 확인';});}
   let otherDetails=$('.moa-r169-others-details',standalone);
   if(!otherDetails){otherDetails=mk('div','moa-r169-others-details');otherDetails.hidden=true;standalone.append(otherDetails);}
   otherDetails.dataset.count=String(others.length);
   otherFold.hidden=others.length===0;
   otherFold.textContent=(otherDetails.hidden?'▾ ':'▴ ')+others.length+'개 녹음 확인';
   addAudioRow(otherDetails,others,d);
   let empty=$('.moa-r151-empty',standalone);
   if(!empty){empty=mk('p','moa-r151-empty','시간대가 연결되지 않은 녹음은 여기 표시됩니다.');standalone.append(empty);}
   empty.hidden=!!others.length;
   let manage=$('.moa-r151-manage',standalone);
   if(!manage){manage=mk('button','moa-r151-manage','이 날짜의 전체 녹음 목록·삭제');manage.type='button';
     manage.addEventListener('click',()=>window.MoaVoiceDiaryNative?.open?.());standalone.append(manage);}
 }finally{rendering=false;}}
 window.MoaVoiceTimelineRefresh=()=>{lastSignature='';renderTimeline();};
 function tick(){addSetting();wrapEvents();wrapMapHardwareBack();observeViewerClose();monitorMapClose();if(chosen&&!$('#moa-r149-voice-modal')&&Date.now()-chosen.start>2000)chosen=null;renderTimeline();}
 function init(){
  // Avoid a visible intermediate map-sheet flash when close is tapped.
  document.addEventListener('click',e=>{
    if(enabled())return;
    const oldViewerClose=e.target.closest?.('#viewer-close');
    const naverFullClose=e.target.closest?.('#fj-naver-photo-full > div:first-child > button:first-child');
    if(oldViewerClose||naverFullClose)closeMapBackdropBeforeViewer();
    if(oldViewerClose||naverFullClose)setTimeout(()=>{
      if(!$('#fj-naver-photo-full')&&$('#fj-naver-photo-sheet'))$('#fj-naver-photo-sheet')?.remove();
      if($('#place-root')?.hidden===false&&($('#viewer-root')?.hidden!==false)&&!$('#fj-naver-photo-full')){
       try{window.__photoMap?.closePlace?.();}catch(_){}
      }
    },0);
  },true);
   // R167: observe only the Diary's own newly constructed timeline, not our
   // injected voice controls. This avoids the 900ms late-appearance reflow.
   const diaryRoot=$('#fj-diary-root');
   if(diaryRoot){let queuedAudio=false;
     new MutationObserver(changes=>{
       const addedDiary=changes.some(change=>{
         if(change.target.closest?.('.moa-r151-group-tools,.moa-r151-standalone'))return false;
         return [...change.addedNodes].some(n=>n.nodeType===1&&(
           n.matches?.('.fd23-timeline,.fd23-log,.fd23-logtime')||
           n.querySelector?.('.fd23-timeline,.fd23-log,.fd23-logtime')));
       });
       if(addedDiary&&!queuedAudio){queuedAudio=true;requestAnimationFrame(()=>{queuedAudio=false;renderTimeline();});}
     }).observe(diaryRoot,{subtree:true,childList:true});
   }
   tick();setInterval(tick,900);
}
 if(document.readyState==='loading')document.addEventListener('DOMContentLoaded',init,{once:true});else init();
})();

/* MOA R173: one motion model drives both the photo/video stage and thumbnail rail.
 * The rail is a stable, virtualized absolute-position timeline, not 13 DOM buttons
 * reconstructed at every selection. Only nearby assets enter memory/DOM.
 * All hand gestures drive continuous transforms before a final selection commits.
 * This module is idempotently embedded into both legacy viewer JS assets. */
;(()=>{'use strict';
 if(window.MoaGallerySmooth)return;
 const clamp=(x,a,b)=>Math.max(a,Math.min(b,x));
 const raf=fn=>requestAnimationFrame(fn);
 const decel=t=>1-Math.pow(1-t,3.2);
 function attach(cfg){
  const {strip,stage,items,thumbs,photoUrl,isVideo,getIndex,select,canSwipe}=cfg;
  if(!strip||!stage||!items?.length)return null;
  const n=items.length,step=55,thumbWidth=49,visible=new Map(),thumbCache=new Map(),previewCards=new Map(),pendingThumbs=new Set();
  let destroyed=false,selected=clamp(getIndex(),0,n-1),selectedFloat=selected,scheduled=false;
  let draggingStrip=false,stageGesture=null,scrollStop=0,animation=0,animationFrame=0,previewTimer=0;
  let motionCommitted=false,nativeDragMode=false,touchWasScroll=false,lastX=0,pointerDownX=0;
  const edge=()=>Math.max(0,strip.clientWidth/2-thumbWidth/2);
  const track=document.createElement('div');track.className='moa-r173-track';strip.replaceChildren(track);
  const preview=document.createElement('div');preview.className='moa-r173-preview';preview.hidden=true;
  stage.appendChild(preview);
  const wrap=document.createElement('div');wrap.className='moa-r173-railwrap';
  strip.parentNode.insertBefore(wrap,strip);wrap.appendChild(strip);
  const centerLine=document.createElement('span');centerLine.className='moa-r173-centerline';wrap.appendChild(centerLine);
  const staticPhoto=(id)=>typeof photoUrl==='function'?photoUrl(id):'https://familyjourney.local/fj-photo/'+encodeURIComponent(id)+'.jpg';
  function getImage(ids,size=340){
   const target=ids.filter(id=>!thumbCache.has(id)&&!pendingThumbs.has(id));
   target.forEach(id=>pendingThumbs.add(id));
   if(!target.length)return;
   try{Promise.resolve(thumbs(target,size)).then(map=>{
     if(destroyed)return;
     target.forEach(id=>{
      pendingThumbs.delete(id);
      const src=map?.get?.(id);
      if(typeof src==='string'&&src.startsWith('data:image/')&&src.length<900000)thumbCache.set(id,src);
     });
     if(thumbCache.size>70)thumbCache.delete(thumbCache.keys().next().value);
     for(const [i,node] of visible){let src=thumbCache.get(items[i].id);if(src&&node.img.src!==src)node.img.src=src;}
     for(const [i,node] of previewCards){let src=thumbCache.get(items[i].id);
      if(src&&isVideo(items[i])&&!node.img.dataset.ready)node.img.src=src;
     }
   }).catch(()=>{target.forEach(id=>pendingThumbs.delete(id));});}catch(_){target.forEach(id=>pendingThumbs.delete(id));}
  }
  function insertThumb(i){
   if(visible.has(i))return;
   const item=items[i],node=document.createElement('button');node.type='button';
   node.className='moa-r173-thumb';node.setAttribute('aria-label',(isVideo(item)?'영상 ':'사진 ')+(i+1)+'번');
   node.style.left=(edge()+i*step)+'px';node.dataset.index=String(i);
   const img=document.createElement('img');img.alt='';img.loading='lazy';img.decoding='async';node.appendChild(img);
   if(isVideo(item)){const badge=document.createElement('span');badge.className='moa-r173-video-badge';badge.textContent='▶';node.appendChild(badge);}
   node.addEventListener('click',()=>{if(destroyed||touchWasScroll)return;snap(i);});
   track.appendChild(node);visible.set(i,{node,img});
   const known=thumbCache.get(item.id);if(known)img.src=known;
  }
  function ensureThumbs(center){
   if(destroyed)return;
   const half=Math.min(22,Math.ceil(strip.clientWidth/step)+11);
   const lo=Math.max(0,Math.floor(center)-half),hi=Math.min(n-1,Math.ceil(center)+half);
   const need=[];
   for(let i=lo;i<=hi;i++){insertThumb(i);if(!thumbCache.has(items[i].id))need.push(items[i].id);}
   for(const [i,v] of visible)if(i<lo||i>hi){v.node.remove();visible.delete(i);}
   getImage(need,130);
   for(const [i,v] of visible){v.node.classList.toggle('is-active',i===Math.round(center));
    v.node.setAttribute('aria-current',i===Math.round(center)?'true':'false');}
  }
  function ensurePreview(f){
   const near=Math.round(f),lo=Math.max(0,near-2),hi=Math.min(n-1,near+2);
   const need=[];
   for(let i=lo;i<=hi;i++){
    if(!previewCards.has(i)){
     const pane=document.createElement('div');pane.className='moa-r173-slide';pane.dataset.index=i;
     const img=document.createElement('img');img.alt='';img.draggable=false;pane.append(img);preview.appendChild(pane);
     previewCards.set(i,{pane,img});
     if(!isVideo(items[i])){img.src=staticPhoto(items[i].id);img.dataset.ready='1';}
    }
    if(isVideo(items[i])&&!thumbCache.has(items[i].id))need.push(items[i].id);
   }
   for(const [i,c] of previewCards)if(i<lo||i>hi){c.pane.remove();previewCards.delete(i);}
   getImage(need,360);
  }
  function visual(f,fromNative=false){
   if(destroyed)return;
   selectedFloat=clamp(f,0,n-1);ensureThumbs(selectedFloat);ensurePreview(selectedFloat);
   preview.hidden=false;
   const w=Math.max(1,stage.clientWidth);
   for(const [i,c] of previewCards){
    const d=i-selectedFloat;
    c.pane.style.transform='translate3d('+(d*w).toFixed(2)+'px,0,0)';
    c.pane.style.opacity=Math.abs(d)>1.16?'0':'1';
   }
   if(!fromNative&&typeof window.MoaLocalAudio?.shiftInlineVideo==='function'){
    const fractional=clamp(selectedFloat-selected,-1.6,1.6);
    try{window.MoaLocalAudio.shiftInlineVideo(fractional);}catch(_){}
   }
  }
  function updateFromScroll(){
   scheduled=false;if(destroyed)return;
   const f=clamp(strip.scrollLeft/step,0,n-1);
   if(Math.abs(f-selected)>0.008||!preview.hidden)visual(f,nativeDragMode);
   else ensureThumbs(f);
   if(draggingStrip||animation)return;
   clearTimeout(scrollStop);
   scrollStop=setTimeout(()=>snap(Math.round(f)),105);
  }
  function onScroll(){if(destroyed||scheduled)return;scheduled=true;raf(updateFromScroll);}
  function commit(i){
   if(destroyed)return;
   const value=clamp(i,0,n-1);selected=value;selectedFloat=value;
   cancelAnimationFrame(animationFrame);animationFrame=0;animation=0;
   strip.scrollLeft=value*step;ensureThumbs(value);
   try{window.MoaLocalAudio?.shiftInlineVideo?.(0);}catch(_){}
   if(getIndex()!==value)select(value);
   clearTimeout(previewTimer);
   previewTimer=setTimeout(()=>{if(!destroyed)preview.hidden=true;},210);
  }
  function snap(i){
   if(destroyed)return;
   const dest=clamp(i,0,n-1);
   clearTimeout(scrollStop);cancelAnimationFrame(animationFrame);animationFrame=0;animation=1;
   const start=strip.scrollLeft,end=dest*step,duration=205,t0=performance.now();
   if(Math.abs(start-end)<.4){commit(dest);return;}
   const loop=now=>{
    if(destroyed||!animation)return;
    const t=clamp((now-t0)/duration,0,1);
    strip.scrollLeft=start+(end-start)*decel(t);
    visual(strip.scrollLeft/step,nativeDragMode);
    if(t<1)animationFrame=raf(loop);else commit(dest);
   };
   animationFrame=raf(loop);
  }
  function setCurrent(i){
   if(destroyed)return;
   selected=clamp(i,0,n-1);selectedFloat=selected;
   clearTimeout(scrollStop);
   ensureThumbs(selected);
   if(!animation&&!draggingStrip&&!stageGesture){
    if(Math.abs(strip.scrollLeft-selected*step)>2)snap(selected);
    else {strip.scrollLeft=selected*step;preview.hidden=true;}
   }
  }
  function positionTrack(){
   const pad=edge();track.style.width=(2*pad+(n-1)*step+thumbWidth)+'px';track.style.height='53px';
   for(const [i,v] of visible)v.node.style.left=(pad+i*step)+'px';
   if(!draggingStrip&&!animation)strip.scrollLeft=selected*step;
  }
  function downStrip(e){
   draggingStrip=true;cancelAnimationFrame(animationFrame);animationFrame=0;animation=0;
   pointerDownX=e.clientX||0;lastX=pointerDownX;touchWasScroll=false;
   clearTimeout(scrollStop);clearTimeout(previewTimer);
  }
  function moveStrip(e){
   lastX=e.clientX||lastX;
   if(Math.abs(lastX-pointerDownX)>9)touchWasScroll=true;
  }
  function upStrip(){draggingStrip=false;
   setTimeout(()=>{touchWasScroll=false;if(!destroyed&&!animation)snap(Math.round(strip.scrollLeft/step));},120);
  }
  strip.addEventListener('pointerdown',downStrip,{passive:true});
  strip.addEventListener('pointermove',moveStrip,{passive:true});
  strip.addEventListener('pointerup',upStrip,{passive:true});
  strip.addEventListener('pointercancel',upStrip,{passive:true});
  strip.addEventListener('scroll',onScroll,{passive:true});
  function startStage(e){
   if(destroyed||e.touches.length!==1||e.target.closest?.('button')||canSwipe?.()===false)return;
   const touch=e.touches[0];stageGesture={x:touch.clientX,y:touch.clientY,last:touch.clientX,at:performance.now(),dir:null};
   clearTimeout(scrollStop);cancelAnimationFrame(animationFrame);animationFrame=0;animation=0;
  }
  function moveStage(e){
   if(!stageGesture||e.touches.length!==1)return;
   const t=e.touches[0];const dx=t.clientX-stageGesture.x,dy=t.clientY-stageGesture.y;
   if(!stageGesture.dir&&Math.max(Math.abs(dx),Math.abs(dy))>8)stageGesture.dir=Math.abs(dx)>Math.abs(dy)*1.1?'x':'y';
   if(stageGesture.dir!=='x')return;
   e.preventDefault();e.stopImmediatePropagation();
   const f=clamp(selected-dx/Math.max(1,stage.clientWidth),0,n-1);
   strip.scrollLeft=f*step;visual(f);
   stageGesture.last=t.clientX;
  }
  function endStage(e){
   if(!stageGesture)return;
   const g=stageGesture;stageGesture=null;
   if(g.dir!=='x')return;
   e.preventDefault();e.stopImmediatePropagation();
   const t=e.changedTouches?.[0];const dx=(t?.clientX??g.last)-g.x;
   const velocity=Math.abs(dx)/Math.max(50,performance.now()-g.at);
   const target=clamp(selected+(Math.abs(dx)>stage.clientWidth*.23||velocity>.48?(dx<0?1:-1):0),0,n-1);
   snap(target);
  }
  stage.addEventListener('touchstart',startStage,{capture:true,passive:true});
  stage.addEventListener('touchmove',moveStage,{capture:true,passive:false});
  stage.addEventListener('touchend',endStage,{capture:true,passive:false});
  stage.addEventListener('touchcancel',endStage,{capture:true,passive:false});
  function nativeDrag(progress){
   if(destroyed)return;
   nativeDragMode=true;
   const f=clamp(selected+Number(progress||0),0,n-1);
   strip.scrollLeft=f*step;visual(f,true);
   nativeDragMode=false;
  }
  function destroy(){destroyed=true;
   cancelAnimationFrame(animationFrame);clearTimeout(previewTimer);clearTimeout(scrollStop);
   strip.removeEventListener('scroll',onScroll);
   strip.removeEventListener('pointerdown',downStrip);
   strip.removeEventListener('pointermove',moveStrip);
   strip.removeEventListener('pointerup',upStrip);
   strip.removeEventListener('pointercancel',upStrip);
   stage.removeEventListener('touchstart',startStage,true);
   stage.removeEventListener('touchmove',moveStage,true);
   stage.removeEventListener('touchend',endStage,true);
   stage.removeEventListener('touchcancel',endStage,true);
   try{window.MoaLocalAudio?.shiftInlineVideo?.(0);}catch(_){}
   preview.remove();strip.replaceChildren();
  }
  requestAnimationFrame(()=>{if(!destroyed){positionTrack();setCurrent(selected);ensurePreview(selected);preview.hidden=true;}});
  return {setCurrent,snap,nativeDrag,destroy,handlesStage:true,getCenter:()=>selectedFloat,getLoadedThumbs:()=>visible.size};
 }
 window.MoaGallerySmooth={attach};
})();