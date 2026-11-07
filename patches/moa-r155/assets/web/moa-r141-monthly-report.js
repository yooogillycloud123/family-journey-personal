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
let videoCtx=null,backWrapped={},gridCleanup=null;
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
function closeViewer(){if(!viewer)return false;viewer.remove();viewer=null;videoCtx=null;return true;}
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
 closeViewer();const items=shownMonth.media;let at=Math.max(0,Math.min(index,items.length-1));
 const layer=el('div','moa-r143-viewer');layer.id=VIEW_ID;layer.setAttribute('role','dialog');layer.setAttribute('aria-modal','true');layer.setAttribute('aria-label','월간 사진·영상 전체보기');
 const head=el('header','moa-r143-viewer-head');const back=btn('← 월간 목록','',closeViewer),count=el('span','','');head.append(back,count);
 const stamp=el('div','moa-r143-time','');const stage=el('div','moa-r143-viewer-stage');const photo=el('img','moa-r143-full');photo.alt='월간 사진';photo.draggable=false;
 const vid=el('div','moa-r143-video');const poster=el('img','');poster.alt='영상 미리보기';const play=btn('▶ 동영상 재생','moa-r143-play',()=>{
  const p=items[at];if(!p?.video)return;
  if(!native('diaryPlayVideo',p.id))alert('동영상은 모아 Android 앱에서 재생할 수 있습니다.');
 });vid.append(poster,play);
 const progress=el('span','moa-r143-progress',''),prev=btn('‹','moa-r143-left',()=>change(-1)),next=btn('›','moa-r143-right',()=>change(1));stage.append(photo,vid,progress,prev,next);
 const foot=el('footer','moa-r143-viewer-foot');foot.append(btn('공유 · 카톡 등','',()=>{const p=items[at];native(p.video?'diaryShareVideo':'sharePhoto',p.id);}),
  btn('갤러리에서 열기','',()=>{const p=items[at];native(p.video?'diaryOpenVideoGallery':'openInGallery',p.id);}));
 layer.append(head,stamp,stage,foot);document.body.append(layer);viewer=layer;wrapBack();
 let finger=null,requestId=0;
 function render(){if(!viewer)return;const p=items[at],v=p.video,seq=++requestId;
  count.textContent=`${fmt(at+1)} / ${fmt(items.length)}`;stamp.textContent=(p.approx?'촬영일(추정) · ':'촬영 · ')+formatTime(p);
  prev.disabled=at===0;next.disabled=at===items.length-1;photo.hidden=v;vid.hidden=!v;
  photo.removeAttribute('src');poster.removeAttribute('src');progress.textContent=v?'':'사진 불러오는 중…';
  if(v){play.textContent='▶ 동영상 재생';if(cache.get(p.id))poster.src=cache.get(p.id);else getThumbs([p.id],340).then(m=>{if(viewer&&seq===requestId){const s=m?.get?.(p.id);if(typeof s==='string'&&s.startsWith('data:image/'))poster.src=s;}});}
  else{photo.onload=()=>{if(seq===requestId)progress.textContent='';};photo.onerror=()=>{if(seq===requestId)progress.textContent='사진을 불러오지 못했습니다.';};photo.src=photoUrl(p.id);}
 }
 function change(dx){const nextIndex=at+dx;if(nextIndex>=0&&nextIndex<items.length){at=nextIndex;render();}}
 stage.addEventListener('touchstart',e=>{if(e.touches.length===1&&!e.target.closest('button'))finger={x:e.touches[0].clientX,y:e.touches[0].clientY};},{passive:true});
 stage.addEventListener('touchend',e=>{if(!finger)return;const p=e.changedTouches[0];if(p){const dx=p.clientX-finger.x,dy=p.clientY-finger.y;if(Math.abs(dx)>48&&Math.abs(dx)>Math.abs(dy)*1.35)change(dx<0?1:-1);}finger=null;},{passive:true});
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
 makeGrid(panel,gallery,galleryInfo,data);wrapBack();return true;
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
  let list=$('.moa-r151-recordings',container);if(!list){list=mk('div','moa-r151-recordings');container.append(list);}list.replaceChildren();
  for(const item of items){const row=mk('div','moa-r151-recording');
   const time=new Date(Number(item.time));const stamp=Number.isFinite(time.getTime())?time.toLocaleTimeString('ko-KR',{hour:'2-digit',minute:'2-digit'}):'음성';
   const title=window.MoaVoicePlaybackUI?.metaFor?.(day,item.id)?.title;
   const play=mk('button','moa-r151-play',`▶ ${title||stamp+' · '+Math.round((item.bytes||0)/1024)+'KB'}`);
   play.type='button';play.dataset.moaAudioPlay=day+'/'+item.id;play.dataset.moaAudioTitle=title||stamp;
   play.addEventListener('click',()=>{try{if(window.MoaVoicePlaybackUI)window.MoaVoicePlaybackUI.play(day,item.id,play);else voice().play(day,item.id);}catch(e){console.warn(e);}});
   row.append(play);list.append(row);
  }
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
   bar.replaceChildren();const add=mk('button','moa-r151-slot-record','● 이 시간대 음성 녹음');add.type='button';
   add.addEventListener('click',()=>showRecorder(d,slot));bar.append(add);
   const attached=entries.filter(item=>{const assignedSlot=links[d+'/'+item.id]||slotOf(item.time);if(assignedSlot===slot){assigned.add(item.id);return true;}return false;});
   addAudioRow(bar,attached,d);
  }
  let standalone=$('#moa-r151-standalone');if(!standalone){standalone=mk('section','moa-r151-standalone');standalone.id='moa-r151-standalone';timeline.append(standalone);}
  standalone.replaceChildren();
  const others=entries.filter(x=>!assigned.has(x.id));
  if(others.length){standalone.append(mk('h3','','사진 시간대 밖에 녹음한 음성'));addAudioRow(standalone,others,d);}else{standalone.append(mk('p','moa-r151-empty','시간대가 연결되지 않은 녹음은 여기 표시됩니다.'));}
  // Link back to all-day recorder for recording management/delete while preserving old UI.
  const manage=mk('button','moa-r151-manage','이 날짜의 전체 녹음 목록·삭제');manage.type='button';manage.addEventListener('click',()=>window.MoaVoiceDiaryNative?.open?.());standalone.append(manage);
 }finally{rendering=false;}}
 window.MoaVoiceTimelineRefresh=()=>{lastSignature='';renderTimeline();};
 function tick(){addSetting();wrapEvents();monitorMapClose();if(chosen&&!$('#moa-r149-voice-modal')&&Date.now()-chosen.start>2000)chosen=null;renderTimeline();}
 function init(){
  // Avoid a visible intermediate map-sheet flash when close is tapped.
  document.addEventListener('click',e=>{
    if(enabled())return;
    const oldViewerClose=e.target.closest?.('#viewer-close');
    const naverFullClose=e.target.closest?.('#fj-naver-photo-full > div:first-child > button:first-child');
    if(oldViewerClose||naverFullClose)setTimeout(()=>{
      if(!$('#fj-naver-photo-full')&&$('#fj-naver-photo-sheet'))$('#fj-naver-photo-sheet')?.remove();
      if($('#place-root')?.hidden===false&&($('#viewer-root')?.hidden!==false)&&!$('#fj-naver-photo-full')){
       try{window.__photoMap?.closePlace?.();}catch(_){}
      }
    },0);
  },true);
  tick();setInterval(tick,900);
}
 if(document.readyState==='loading')document.addEventListener('DOMContentLoaded',init,{once:true});else init();
})();