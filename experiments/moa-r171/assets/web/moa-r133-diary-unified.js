/* MOA R133. Additive Diary-only mixed-media day sheet + viewer.
 * IMPORTANT: No writes to diary DB, no media deletes/migrations.
 * Preserve original thumbnail/native video player, original R129 Map place sheet,
 * R121 GPS information and all R131 scroll behavior.
 */
(()=>{
'use strict';
const D=()=>window.FamilyJourneyDiary;
const $=(s,r=document)=>r.querySelector(s);
const isVideo=p=>String(p?.id||'').startsWith('v')||p?.video===true;
const ID_RE=/^(?:v[0-9]{1,18}|[0-9]{1,19})$/;
const safeId=id=>String(id??'');
const rootId='moa-r133-day-sheet', viewerId='moa-r133-mixed-viewer';
let current=null,backBound=null,mapBackBound=null,observing=false,inlineVideo=null,inlineFailedId="";
const timeFormat=t=>Number.isFinite(+t)&&+t>946684800000
  ?new Intl.DateTimeFormat('ko-KR',{year:'numeric',month:'2-digit',day:'2-digit',hour:'2-digit',minute:'2-digit',second:'2-digit',hour12:false}).format(new Date(+t))
  :'촬영시각 확인 중';
const dayName=x=>{try{return new Date(x+'T12:00:00').toLocaleDateString('ko-KR',{year:'numeric',month:'long',day:'numeric',weekday:'long'});}catch(_){return x||'일기';}};
const dur=ms=>{let n=Math.floor(Math.max(0,+ms||0)/1000);return `${Math.floor(n/60).toString().padStart(2,'0')}:${(n%60).toString().padStart(2,'0')}`;};
function mediaFromDay(){
 const s=D()?.state;if(!s||!s.open||s.page!=='day')return [];
 const curated=s.mode==='curated',day=s.date;
 const entry=(curated?s.curatedEntries:s.entries)?.get?.(day);
 const excluded=new Set((entry?.removedMediaIds||[]).map(safeId));
 const raw=curated?Array.from(s.selection||entry?.photoIds||[]).map((id,i)=>{
   id=safeId(id);const item=s.byId?.get?.(id);
   return item?{...item,id,seq:i}:{id,video:id.startsWith('v'),t:0,seq:i,unindexed:true};
 }):[...(s.byDay?.get?.(day)||[]),...(s.byVideoDay?.get?.(day)||[])];
 const unique=new Map();raw.forEach((p,i)=>{const id=safeId(p?.id);if(ID_RE.test(id)&&!excluded.has(id)&&!unique.has(id))unique.set(id,{...p,id,seq:i});});
 return [...unique.values()].sort((a,b)=>{
  // Trust original MediaStore capture time; stable list order for missing/old selected IDs.
  const at=Number.isFinite(+a.t)&&+a.t>0?+a.t:Infinity;
  const bt=Number.isFinite(+b.t)&&+b.t>0?+b.t:Infinity;
  return at-bt||a.seq-b.seq;
 });
}
function make(tag,cls,text){const e=document.createElement(tag);if(cls)e.className=cls;if(text!==undefined)e.textContent=String(text);return e;}
function btn(label,cls,action){const b=make('button',cls,label);b.type='button';b.addEventListener('click',action);return b;}
function requestNative(command,id){try{if(window.NativeHost?.post){window.NativeHost.post(command,JSON.stringify({id}));return true;}}catch(e){console.warn('MOA native media action',e);}return false;}
function getThumbs(ids,size=150){if(typeof window.__requestThumbs!=='function')return Promise.resolve(new Map());return window.__requestThumbs(ids,size).catch(()=>new Map());}
function openDaySheet(media,selectedId,openFull=true){
 // Date content only; new sheet is a presentation of actual diary-selected media.
 if(!Array.isArray(media)||!media.length)return false;
 closeAll();
 const state=D()?.state,day=state?.date||'';
 const sheet=make('div','moa-r133-sheet');sheet.id=rootId;sheet.setAttribute('role','dialog');sheet.setAttribute('aria-modal','true');
 const shade=make('div','moa-r133-dim');const panel=make('div','moa-r133-panel');
 const head=make('header','moa-r133-sheet-head');
 const title=make('div','moa-r133-sheet-title');title.append(make('strong','',dayName(day)),make('small','',`사진 ${media.filter(p=>!isVideo(p)).length}장 · 동영상 ${media.filter(isVideo).length}개`));
 const sheetClose=btn('닫기 ×','moa-r133-small-close',()=>closeAll());head.append(title,sheetClose);
 const intro=make('p','moa-r133-intro','사진·영상을 눌러 크게 보고, 뒤로 가면 이 목록으로 돌아옵니다. 아래로 스크롤하면 계속 불러옵니다.');
 const grid=make('div','moa-r133-grid'),label=make('p','moa-r133-paging','');
 panel.append(make('div','moa-r133-handle'),head,intro,grid,label);sheet.append(shade,panel);
 shade.addEventListener('click',()=>closeAll());
 document.body.append(sheet);
 const ctx={media,day,sheet,panel,grid,label,shown:0,loading:false,active:0,thumbCache:new Map(),videoPlaying:false};current=ctx;
 const append=()=>{
  if(current!==ctx||ctx.loading||ctx.shown>=media.length)return;
  ctx.loading=true;
  const from=ctx.shown,to=Math.min(from+30,media.length),batch=media.slice(from,to),nodes=new Map();
  for(const p of batch){
   const tile=btn('', 'moa-r133-tile',()=>showViewer(ctx,media.findIndex(v=>v.id===p.id)));
   tile.setAttribute('aria-label',(isVideo(p)?'동영상':'사진')+' '+timeFormat(p.t)+' 열기');
   const img=make('img','');img.alt=isVideo(p)?'동영상 썸네일':'사진 썸네일';img.loading='lazy';img.decoding='async';
   tile.append(img);
   if(isVideo(p))tile.append(make('span','moa-r133-playmark','▶ '+dur(p.duration)));
   grid.append(tile);nodes.set(p.id,img);
  }
  ctx.shown=to;
  label.textContent=`${ctx.shown.toLocaleString('ko-KR')} / ${media.length.toLocaleString('ko-KR')} · 계속 아래로 스크롤`;
  // Do not block auto-paging while the thumbnail worker is busy.
  ctx.loading=false;
  for(let n=0;n<batch.length;n+=15){const part=batch.slice(n,n+15);
   getThumbs(part.map(p=>p.id),160).then(map=>{
    if(current!==ctx||!sheet.isConnected)return;
    for(const p of part){const thumb=map.get(p.id),img=nodes.get(p.id);
      if(img?.isConnected&&typeof thumb==='string'&&thumb.startsWith('data:image/')){
       ctx.thumbCache.set(p.id,thumb);img.src=thumb;
       // Do not retain the whole library in RAM; at most recent 70 posters.
       if(ctx.thumbCache.size>70)ctx.thumbCache.delete(ctx.thumbCache.keys().next().value);
      }
    }
    });
  }
  if(ctx.shown<media.length)requestAnimationFrame(maybeMore);
 };
 let running=false;
 function maybeMore(){
  if(running||current!==ctx||!sheet.isConnected||$('#'+viewerId))return;
  if(ctx.shown>=media.length)return;
  const gap=panel.scrollHeight-panel.scrollTop-panel.clientHeight;
  if(gap>Math.min(panel.clientHeight*.75,520))return;
  running=true;append();setTimeout(()=>{running=false;maybeMore();},160);
 }
 panel.addEventListener('scroll',maybeMore,{passive:true});
 ctx.append=append;append();
 if(openFull){const idx=Math.max(0,media.findIndex(p=>p.id===safeId(selectedId)));showViewer(ctx,idx);}
 return true;
}
function closeViewer(){if(inlineVideo){inlineVideo.destroy();inlineVideo=null;}const viewer=$('#'+viewerId);if(!viewer)return false;viewer.remove();
 if(current){current.videoPlaying=false;current.panel?.focus?.({preventScroll:true});}
 // Optional direct-return mode: avoid showing the day photo list after closing the viewer.
 if(window.MoaGalleryPreference?.enabled?.()===false){$('#'+rootId)?.remove();current=null;}
 return true;
}
function closeAll(){closeViewer();$('#'+rootId)?.remove();current=null;}
function coords(id){let rows=[];try{rows=window.FamilyJourneyExtension?.getData?.()?.photos||[];}catch(_){return null;}
 const row=Array.isArray(rows)?rows.find(r=>Array.isArray(r)&&String(r[0])===id):null;
 if(!row)return null;
 const lat=Number(row[1]),lon=Number(row[2]);
 return Number.isFinite(lat)&&Number.isFinite(lon)&&Math.abs(lat)<=90&&Math.abs(lon)<=180&&(lat!==0||lon!==0)?{lat,lon}:null;
}
function openNaver(point,address){
 const q=(address||`${point.lat.toFixed(6)}, ${point.lon.toFixed(6)}`).trim();
 const url='https://map.naver.com/p/search/'+encodeURIComponent(q);
 try{if(window.NativeHost?.post)window.NativeHost.post('openUrl',JSON.stringify({url}));else window.open(url,'_blank','noopener');}catch(e){console.warn(e);}
}
function showViewer(ctx,initial){
 if(!ctx||current!==ctx)return;
 closeViewer();
 const overlay=make('div','moa-r133-viewer');overlay.id=viewerId;overlay.setAttribute('role','dialog');overlay.setAttribute('aria-modal','true');
 const top=make('header','moa-r133-viewer-head');
 const close=btn('← 목록','moa-r133-viewer-close',closeViewer);
 const title=make('div','moa-r133-viewer-title',dayName(ctx.day));
 const counter=make('span','moa-r133-counter','');top.append(close,title,counter);
 const info=make('div','moa-r133-viewer-info'),stamp=make('div','moa-r133-stamp',''),geo=make('div','moa-r133-geoinfo');
 const address=make('span','moa-r133-address',''),naver=btn('네이버 지도에서 보기','moa-r133-navermap',()=>{});
 geo.append(address,naver);info.append(stamp,geo);
 const stage=make('div','moa-r133-stage');stage.setAttribute('aria-label','사진·동영상 순서대로 넘기기');
 const image=make('img','moa-r133-image');image.alt='선택한 사진';image.draggable=false;
 const placeholder=make('div','moa-r133-video-poster');
 const posterImg=make('img','');posterImg.alt='선택한 동영상 미리보기';
 const videoPlay=btn('▶','moa-r133-video-play',()=>{
   const p=ctx.media[ctx.active];if(!p||!isVideo(p))return;
   const id=p.id;
   // If the in-gallery native video cannot open, only an EXPLICIT user tap
   // opens the previous Android player. Never auto-spawn a second activity.
   if(inlineVideo)return;
   if(inlineFailedId===id){closeAll();ctx.videoPlaying=requestNative('diaryPlayVideo',id);return;}
   const token=renderSeq;
   inlineVideo=window.MoaInlineVideo?.mount(stage,id,{
    onReady:()=>{if(overlay.isConnected&&token===renderSeq)placeholder.hidden=true;},
    onError:()=>{if(overlay.isConnected&&token===renderSeq){inlineVideo=null;inlineFailedId=id;placeholder.hidden=false;}},
    onNext:()=>move(1),onPrev:()=>move(-1)});
   if(!inlineVideo){closeAll();ctx.videoPlaying=requestNative('diaryPlayVideo',id);
     if(!ctx.videoPlaying)alert('동영상 재생 장치를 열 수 없습니다.');}
 });
 placeholder.append(posterImg,videoPlay);
 placeholder.addEventListener('click',e=>{if(e.target!==videoPlay)videoPlay.click();});
 const progress=make('span','moa-r133-loading','');
 const left=btn('‹','moa-r133-left',()=>move(-1)),right=btn('›','moa-r133-right',()=>move(1));
 stage.append(image,placeholder,progress,left,right);
 const filmstrip=make('div','moa-r171-filmstrip');filmstrip.setAttribute('aria-label','사진·동영상 연속 목록');
 const foot=make('footer','moa-r133-footer');
 const actions=make('div','moa-r133-actions');
 const share=btn('공유 · 카톡 등','moa-r133-action',()=>requestNative(isVideo(ctx.media[ctx.active])?'diaryShareVideo':'sharePhoto',ctx.media[ctx.active].id));
 const gallery=btn('갤러리에서 열기','moa-r133-action',()=>requestNative(isVideo(ctx.media[ctx.active])?'diaryOpenVideoGallery':'openInGallery',ctx.media[ctx.active].id));
 actions.append(share,gallery);foot.append(filmstrip);
 const guidance=make('div','moa-r133-guidance','사진 확대·축소 · 좌우 넘기기 · 영상은 ▶ 눌러 재생');
 foot.append(actions,guidance);
 overlay.append(top,info,stage,foot);document.body.append(overlay);
 let idx=Math.max(0,Math.min(ctx.media.length-1,initial)),renderSeq=0,zoom=1,dx=0,dy=0,gesture=null,addrSeq=0;
 function reset(){zoom=1;dx=0;dy=0;image.style.transform='translate3d(0,0,0) scale(1)';}
 function renderStrip(){
  const from=Math.max(0,idx-6),to=Math.min(ctx.media.length,idx+7);
  filmstrip.replaceChildren();const pics=[];
  for(let a=from;a<to;a++){
   const item=ctx.media[a],node=btn('', 'moa-r171-frame'+(a===idx?' is-active':''),()=>move(a-idx));
   node.setAttribute('aria-label',(isVideo(item)?'영상 ':'사진 ')+(a+1)+'번');
   const img=make('img','');img.alt='';img.loading='lazy';node.append(img);
   if(isVideo(item))node.append(make('span','moa-r171-mark','▶'));
   filmstrip.append(node);pics.push({item,img});
  }
  const anchor=filmstrip.querySelector('.is-active');anchor?.scrollIntoView?.({block:'nearest',inline:'center'});
  getThumbs(pics.map(p=>p.item.id),96).then(map=>{
    if(!overlay.isConnected)return;
    for(const p of pics){let url=map?.get?.(p.item.id);
      if(p.img.isConnected&&typeof url==='string'&&url.startsWith('data:image/'))p.img.src=url;
    }
  });
 }
 function render(){
  if(!overlay.isConnected)return;
  idx=Math.max(0,Math.min(ctx.media.length-1,idx));ctx.active=idx;
  const p=ctx.media[idx],id=p.id,video=isVideo(p),token=++renderSeq;
  if(inlineVideo){inlineVideo.destroy();inlineVideo=null;}
  reset();renderStrip();counter.textContent=(idx+1)+' / '+ctx.media.length;
  left.disabled=idx===0;right.disabled=idx===ctx.media.length-1;
  stamp.textContent=(p.approx?'촬영시각(추정) · ':'촬영 · ')+timeFormat(p.t)+(video?' · 동영상 '+dur(p.duration):'');
  const point=coords(id);naver.hidden=!point;naver.onclick=()=>{};
  const addrToken=++addrSeq;let known='';
  if(point){address.textContent='GPS 상세 주소 확인 중…';naver.onclick=()=>openNaver(point,known);
   if(point.lat>=31.43&&point.lat<=44.35&&point.lon>=122.37&&point.lon<=132&&typeof window.FamilyJourneyNaver?.reverse==='function'){
    try{window.FamilyJourneyNaver.reverse(point,result=>{
     if(!overlay.isConnected||addrSeq!==addrToken)return;
     known=String(result?.address||'').trim();address.textContent=known||`GPS ${point.lat.toFixed(5)}, ${point.lon.toFixed(5)} · 주소 조회 실패`;
    });}catch(_){address.textContent=`GPS ${point.lat.toFixed(5)}, ${point.lon.toFixed(5)}`;}
   }else{address.textContent=`GPS ${point.lat.toFixed(5)}, ${point.lon.toFixed(5)}`;naver.hidden=true;}
  }else address.textContent='지도 색인에서 GPS 미확인 · 원본 GPS 여부는 미검증';
  placeholder.hidden=!video;image.hidden=video;
  progress.textContent=video?'':'사진 불러오는 중…';
  posterImg.removeAttribute('src');image.removeAttribute('src');
  if(video){
   videoPlay.textContent='▶';videoPlay.setAttribute('aria-label','동영상 재생 · '+dur(p.duration));videoPlay.setAttribute('title','동영상 재생');
   // R169: attempt silent inline HTML5 video first; native fallback remains available.
   inlineVideo=window.MoaInlineVideo?.mount(stage,id,{
    onReady:()=>{if(overlay.isConnected&&token===renderSeq)placeholder.hidden=true;},
    onError:()=>{if(overlay.isConnected&&token===renderSeq){inlineVideo=null;inlineFailedId=id;placeholder.hidden=false;progress.textContent='기기 재생에 문제가 있어 ▶ 버튼으로 기존 플레이어를 열 수 있습니다.';}},
    onNext:()=>move(1),onPrev:()=>move(-1) });
   const cached=ctx.thumbCache.get(id);if(cached)posterImg.src=cached;
   else getThumbs([id],300).then(m=>{
    if(overlay.isConnected&&token===renderSeq&&isVideo(ctx.media[idx])){
      const src=m.get(id);if(src?.startsWith('data:image/'))posterImg.src=src;
    }
   });
  }else{
   image.onload=()=>{if(token===renderSeq)progress.textContent='';};
   image.onerror=()=>{if(token===renderSeq)progress.textContent='사진 원본을 열지 못했습니다.';};
   image.src='https://familyjourney.local/fj-photo/'+encodeURIComponent(id)+'.jpg';
  }
 }
 function move(n){const next=idx+n;if(next<0||next>=ctx.media.length)return;idx=next;render();}
 stage.addEventListener('touchstart',e=>{
  if(e.target.closest('button'))return;
  if(e.touches.length===2){const a=e.touches[0],b=e.touches[1];gesture={kind:'pinch',distance:Math.hypot(a.clientX-b.clientX,a.clientY-b.clientY),initial:zoom};}
  else if(e.touches.length===1)gesture={kind:zoom>1.01?'pan':'swipe',x:e.touches[0].clientX,y:e.touches[0].clientY,dx,dy,time:Date.now()};
 },{passive:true});
 stage.addEventListener('touchmove',e=>{
  if(!gesture)return;
  if(gesture.kind==='pinch'&&e.touches.length===2&&!isVideo(ctx.media[idx])){
   const a=e.touches[0],b=e.touches[1];zoom=Math.max(1,Math.min(5,gesture.initial*Math.hypot(a.clientX-b.clientX,a.clientY-b.clientY)/Math.max(1,gesture.distance)));
   image.style.transform=`translate3d(${dx}px,${dy}px,0) scale(${zoom})`;e.preventDefault();return;
  }
  if(e.touches.length!==1)return;
  const x=e.touches[0].clientX-gesture.x,y=e.touches[0].clientY-gesture.y;
  if(gesture.kind==='pan'&&!isVideo(ctx.media[idx])){
   const w=stage.clientWidth,h=stage.clientHeight;
   dx=Math.max(-(w*zoom-w)/2,Math.min((w*zoom-w)/2,gesture.dx+x));
   dy=Math.max(-(h*zoom-h)/2,Math.min((h*zoom-h)/2,gesture.dy+y));
   image.style.transform=`translate3d(${dx}px,${dy}px,0) scale(${zoom})`;
   e.preventDefault();
  }else if(gesture.kind==='swipe'&&Math.abs(x)>14&&Math.abs(x)>Math.abs(y)*1.2)e.preventDefault();
 },{passive:false});
 stage.addEventListener('touchend',e=>{
  if(!gesture)return;
  if(e.touches.length)return;
  if(gesture.kind==='swipe'&&zoom<=1.01){
   const p=e.changedTouches[0];const x=p.clientX-gesture.x,y=p.clientY-gesture.y;
   if(Math.abs(x)>=42&&Math.abs(x)>Math.abs(y)*1.3)move(x<0?1:-1);
  }else if(gesture.kind==='pinch'&&zoom<1.02)reset();
  gesture=null;
 },{passive:true});
 stage.addEventListener('touchcancel',()=>{gesture=null;},{passive:true});
 const key=e=>{if(!overlay.isConnected)return;if(e.key==='Escape'){e.preventDefault();closeViewer();}else if(e.key==='ArrowLeft'){e.preventDefault();move(-1);}else if(e.key==='ArrowRight'){e.preventDefault();move(1);}};
 document.addEventListener('keydown',key);
 const obs=new MutationObserver(()=>{if(!overlay.isConnected){document.removeEventListener('keydown',key);obs.disconnect();}});
 obs.observe(document.body,{childList:true});
 render();
}
function openFromDay(id){const media=mediaFromDay();if(!media.length)return false;return openDaySheet(media,id,true);}
function daySheetOnly(){const media=mediaFromDay();return media.length?openDaySheet(media,null,false):false;}
function intercept(e){
 const s=D()?.state;if(!s?.open||s.page!=='day'||$('#'+rootId))return;
 const tile=e.target.closest?.('#fj-diary-root .fd23-photo');if(!tile)return;
 const id=tile.querySelector('img[data-photo-id]')?.dataset.photoId||'';
 if(!ID_RE.test(id))return;
 e.preventDefault();e.stopPropagation();e.stopImmediatePropagation();
 openFromDay(id);
}
function addSheetButton(){
 const state=D()?.state,root=$('#fj-diary-root');if(!root||root.hidden||!state?.open||state.page!=='day')return;
 const stats=$('.fd23-daystats',root);if(!stats||$('#moa-r133-open-day-list',root))return;
 const button=btn('▦ 이 날짜 사진·영상 전체 보기','moa-r133-open-day',daySheetOnly);
 button.id='moa-r133-open-day-list';
 stats.insertAdjacentElement('afterend',button);
}
function wrapBack(){
 for(const key of ['__fjBackOverlay','__photoMapBack']){
  const existing=window[key];if(typeof existing!=='function'||existing.__moaR133)return;
  const wrapped=function(...args){if($('#'+viewerId)){closeViewer();return true;}if($('#'+rootId)){closeAll();return true;}return existing.apply(this,args);};
  wrapped.__moaR133=true;window[key]=wrapped;
 }
}
function init(){
 const root=$('#fj-diary-root');if(!root){setTimeout(init,400);return;}
 root.addEventListener('click',intercept,true);
 // Diary replaces its direct children on every day/calendar render.
 let scheduled=false;
 const scan=()=>{scheduled=false;addSheetButton();wrapBack();const state=D()?.state;
  if(current&&(!state?.open||state.page!=='day'||state.date!==current.day))closeAll();};
 const obs=new MutationObserver(()=>{if(scheduled)return;scheduled=true;requestAnimationFrame(scan);});
 obs.observe(root,{childList:true,attributes:true,attributeFilter:['hidden']});
 // Keep a single native Back hook; R127 may wrap it on foreground resumes.
 // Re-wrapping on every visibility event would create an unbounded chain.
 scan();
 window.MoaUnifiedDiary={openFromDay,openSheet:daySheetOnly,closeAll,mediaFromDay};
}
if(document.readyState==='loading')document.addEventListener('DOMContentLoaded',init,{once:true});else init();
})();

/* R171 Native in-gallery video. A VideoView is placed in this same Android
 * Activity at the current stage bounds. No content:// URI is passed to WebView
 * and no external player Activity is opened unless the user explicitly taps
 * the fallback ▶ button after a native failure. */
;(()=>{'use strict';
 let active=null;
 const api=()=>window.MoaLocalAudio;
 function mount(host,id,opts={}){
  const n=api();if(typeof n?.openInlineVideo!=='function')return null;
  if(active)active.destroy();
  const rect=host.getBoundingClientRect();
  let yes=false;
  try{yes=!!n.openInlineVideo(id,rect.left,rect.top,rect.width,rect.height,window.innerWidth);}catch(_){yes=false;}
  if(!yes)return null;
  const state={id,opts,destroy(){if(active===state)active=null;
   try{api()?.closeInlineVideo?.();}catch(_){} }};
  active=state;return state;
 }
 window.MoaNativeInline={onState(id,type){
  const a=active;if(!a||a.id!==id)return;
  if(type==='started'){a.opts.onReady?.();return;}
  if(type==='error'){a.destroy();a.opts.onError?.('안드로이드 영상 재생 실패');return;}
  if(type==='next'){a.opts.onNext?.();return;}
  if(type==='prev'){a.opts.onPrev?.();return;}
 }};
 window.MoaInlineVideo={mount};
})();