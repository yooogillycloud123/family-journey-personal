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
let ui={audioPlaying:false,open:false,page:'calendar',selected:dayOf(Date.now()),month:new Date(new Date().getFullYear(),new Date().getMonth(),1),date:'',media:[],idx:0,fast:false,tools:false,rail:false,info:false,clip:0,clips:[],dirty:false,photoToken:0,gesture:null,dragTarget:null,videoFallback:false,requestGeneration:0};
let view=null, observer=null, pending=0, backInstalled=false;
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
 return (selected.length?selected:all.filter(p=>!hidden.has(String(p.id))))
   .filter(p=>safeMedia(p.id)).sort((a,b)=>(Number(a.t)||0)-(Number(b.t)||0));
}
function mainCover(day,media){const s=getState();const preferred=String(s?.covers?.curated?.[day]||'');return media.find(x=>String(x.id)===preferred)||media[0]||null;}
async function fillImages(targets,large=false){const get=window.__requestThumbs;if(typeof get!=='function'||!targets.length)return;
 const generation=ui.requestGeneration;
 const grouped=new Map();for(const x of targets){if(!x.isConnected||!safeMedia(x.dataset.id))continue;const id=x.dataset.id;if(!grouped.has(id))grouped.set(id,[]);grouped.get(id).push(x)}
 const ids=[...grouped.keys()];for(let k=0;k<ids.length;k+=18){let map;try{map=await get(ids.slice(k,k+18),large?400:130)}catch(e){continue}
  if(generation!==ui.requestGeneration)return;
  for(const [id,nodes] of grouped){const src=map?.get(id);if(!src||!src.startsWith('data:image/'))continue;
   for(const n of nodes){if(n.isConnected&&n.dataset.id===id){n.src=src;n.dataset.loaded='1'}}}
 }
}
function mount(){if(view)return view;const n=elem('section','moa-r469-root');n.id='moa-r469-root';n.setAttribute('aria-label','간편 사진 일기');n.hidden=true;document.body.append(n);view=n;return n;}
function open(page='calendar',day){const s=getState();if(!s?.open)return false;mount();ui.open=true;ui.page=page==='day'?'day':'calendar';ui.selected=valid(day)?day:ui.selected;ui.date=ui.selected;ui.month=new Date(ui.selected+'T12:00:00');ui.month.setDate(1);ui.idx=0;ui.fast=false;ui.tools=false;ui.rail=false;ui.dirty=false;view.hidden=false;
 try{localStorage.setItem(KEY,'simple')}catch(e){}render();installBack();return true;}
function close(){window.MoaVoicePlaybackUI?.stop?.();ui.audioPlaying=false;ui.open=false;ui.requestGeneration++;if(view)view.hidden=true;try{localStorage.removeItem(KEY)}catch(e){}return true;}
function goBack(){if(!ui.open)return false;if(ui.page==='day'){if(ui.dirty&&!confirm('작성 중인 내용이 있습니다. 저장하지 않고 돌아갈까요?'))return true;window.MoaVoicePlaybackUI?.stop?.();ui.page='calendar';ui.dirty=false;render();return true;}return close();}
function installBack(){if(backInstalled)return;backInstalled=true;const old=window.__fjBackOverlay;window.__fjBackOverlay=function(...args){if(ui.open&&!document.getElementById('moa-r149-voice-modal'))return goBack();return typeof old==='function'?old.apply(this,args):false};}
function addMode(){const s=getState(),root=diaryRoot();if(!s?.open||s.page!=='calendar'||!root||root.hidden)return;
 const modes=$('.fd23-modes',root);if(!modes||modes.querySelector('.moa-r469-choose'))return;
 const b=btn('사진 일기',()=>open('calendar',ui.selected),'moa-r469-choose');b.title='기존 일기와 자료를 공유하는 새 간편형 사진 달력';modes.append(b);}
function sync(){if(pending)return;pending=requestAnimationFrame(()=>{pending=0;addMode();});}
function start(){mount();observer=new MutationObserver(sync);observer.observe(document.body,{childList:true,subtree:true});const root=diaryRoot();if(root)observer.observe(root,{childList:true,subtree:false,attributes:true,attributeFilter:['hidden']});sync();}
function render(){if(!ui.open||!view)return;ui.requestGeneration++;view.replaceChildren();view.dataset.page=ui.page;
 ui.page==='day'?renderDay():renderMonth();view.append(elem('div','moa-r469-status',''));view.scrollTop=0;}
function header(title,back){const h=elem('header','moa-r469-head');h.append(btn('‹',back,'moa-r469-back'),elem('strong','',title),btn('홈',()=>{close();window.__photoMap?.showTab?.('home')},'moa-r469-home'));return h;}
function renderMonth(){const s=getState();if(!s)return;const y=ui.month.getFullYear(),m=ui.month.getMonth(),days=new Date(y,m+1,0).getDate(),offset=new Date(y,m,1).getDay();
 const h=header('사진 일기',()=>close());view.append(h);
 const monthBar=elem('nav','moa-r469-month-head');monthBar.append(btn('‹',()=>changeMonth(-1)),btn(`${y}년 ${m+1}월`,()=>{const v=prompt('이동할 연도-월 (YYYY-MM)',`${y}-${String(m+1).padStart(2,'0')}`);if(/^\d{4}-(0[1-9]|1[0-2])$/.test(v||'')){ui.month=new Date(v+'-01T12:00:00');render();}},'moa-r469-month-name'),btn('›',()=>changeMonth(1)),btn('오늘',()=>{ui.month=new Date();ui.month.setDate(1);ui.selected=dayOf(Date.now());render()},'moa-r469-today'));view.append(monthBar);
 const records=new Set([...(s.curatedEntries?.values()||[]),...(s.entries?.values()||[])].filter(e=>e?.day?.startsWith(`${y}-${String(m+1).padStart(2,'0')}-`)&&(e.body||e.title||(e.moments||[]).length)).map(e=>e.day)).size;
 const progress=elem('div','moa-r469-progress');progress.append(elem('span','',`이번 달 기록 ${records} / ${days}일`),elem('span','',`${Math.round(records/days*100)}%`));view.append(progress);
 const bar=elem('div','moa-r469-progressbar');const inner=elem('span');inner.style.width=(records/days*100)+'%';bar.append(inner);view.append(bar);
 const grid=elem('div','moa-r469-month-grid');for(const d of ['일','월','화','수','목','금','토'])grid.append(elem('span','moa-r469-week',d));
 const images=[];for(let i=0;i<offset+days;i++){if(i<offset){grid.append(elem('span','moa-r469-blank'));continue}
  const n=i-offset+1,d=`${y}-${String(m+1).padStart(2,'0')}-${String(n).padStart(2,'0')}`;const photo=mainCover(d,mediaFor(d));const tile=btn('',()=>{ui.selected=d;ui.date=d;ui.page='day';ui.idx=0;ui.fast=false;render()},'moa-r469-date');tile.setAttribute('aria-label',`${d} 일기 열기`);
  if(d===ui.selected)tile.classList.add('selected');if(d===dayOf(Date.now()))tile.classList.add('today');
  if(photo){const img=elem('img');img.dataset.id=String(photo.id);img.alt='달력 사진';tile.append(img);images.push(img);if(isVideo(photo))tile.append(elem('span','moa-r469-video-mark','▶'));}
  tile.append(elem('span','moa-r469-day-number',n));if(s.curatedEntries?.has(d))tile.append(elem('span','moa-r469-record-mark','•'));grid.append(tile);
 }
 view.append(grid);const foot=elem('nav','moa-r469-footer');foot.append(btn('‹ 기존 일기',close),btn('＋',()=>{ui.page='day';ui.date=valid(ui.selected)?ui.selected:dayOf(Date.now());render()},'moa-r469-plus'),btn('오늘',()=>{ui.selected=dayOf(Date.now());ui.month=new Date();ui.month.setDate(1);render()}));view.append(foot);
 fillImages(images);}
function changeMonth(k){ui.month=new Date(ui.month.getFullYear(),ui.month.getMonth()+k,1);render();}
function dayMedia(index){const m=ui.media[index];return m&&safeMedia(m.id)?m:null;}
function setDay(day){if(!valid(day))return;ui.date=day;ui.selected=day;ui.page='day';ui.fast=false;ui.idx=0;ui.dirty=false;render();}
function renderDay(){const d=ui.date,s=getState();if(!valid(d)||!s)return;ui.media=mediaFor(d);const chosen=mainCover(d,ui.media);const ri=ui.media.findIndex(x=>String(x.id)===String(chosen?.id));ui.idx=Math.min(ui.media.length-1,Math.max(0,ui.idx||ri));if(ui.idx===0&&ri>0)ui.idx=ri;
 const current=s.curatedEntries?.get(d)||s.entries?.get(d),wrap=elem('div','moa-r469-day');wrap.append(header(dateLabel(d),goBack));
 const stage=elem('div','moa-r469-stage');stage.dataset.moaStage='yes';stage.tabIndex=0;stage.setAttribute('aria-label','사진 영상 좌우로 이동');stage.append(elem('div','moa-r469-stage-media'));
 const more=btn('···',()=>{ui.tools=!ui.tools;toggleTools()},'moa-r469-more');more.setAttribute('aria-label','사진 기능');stage.append(more);wrap.append(stage);
 stage.addEventListener('pointerdown',e=>{if(e.target.closest('button'))return;ui.gesture={x:e.clientX,y:e.clientY,at:Date.now()}});
 stage.addEventListener('pointerup',e=>{if(e.target.closest('button')||!ui.gesture)return;const x=e.clientX-ui.gesture.x,y=e.clientY-ui.gesture.y,dt=Math.max(1,Date.now()-ui.gesture.at);ui.gesture=null;
  if(Math.abs(x)>28&&Math.abs(x)>Math.abs(y)*1.25){const step=ui.fast?Math.min(5,Math.max(1,Math.round(Math.abs(x)/Math.max(55,dt<150?52:90)))):1;changeMedia(ui.idx+(x<0?step:-step));}
  else if(Math.abs(x)<12&&Math.abs(y)<12){ui.tools=!ui.tools;toggleTools()}
 });
 stage.addEventListener('keydown',e=>{if(e.key==='ArrowLeft'){changeMedia(ui.idx-1);e.preventDefault()}else if(e.key==='ArrowRight'){changeMedia(ui.idx+1);e.preventDefault()}});
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
 const foot=elem('div','moa-r469-story-footer');foot.append(btn('상세 기록',()=>{if(ui.dirty&&!confirm('저장하지 않은 글을 버리고 상세 일기로 이동할까요?'))return;close();window.FamilyJourneyDiary?.selectDay?.(d)},'moa-r469-detail'),btn('저장',()=>saveStory(),'moa-r469-save'));story.append(foot);wrap.append(story);
 const status=elem('div','moa-r469-status','');wrap.append(status);view.append(wrap);renderMedia();refreshVoices();}
function renderMedia(){const stage=$('.moa-r469-stage-media',view),dots=$('.moa-r469-pager',view),m=dayMedia(ui.idx);if(!stage)return;
 stage.replaceChildren();dots?.replaceChildren();ui.requestGeneration++;
 if(!m){stage.append(elem('div','moa-r469-empty','오늘의 사진을 추가해 보세요.'));return;}
 const img=elem('img');img.dataset.id=String(m.id);img.alt='선택한 사진·영상';stage.append(img);fillImages([img],true);
 if(isVideo(m)){const play=btn('▶',()=>playInlineVideo(m),'moa-r469-video-play');play.setAttribute('aria-label','영상 재생');stage.append(play);}
 for(let i=0;i<Math.min(30,ui.media.length);i++){const dot=btn('',()=>changeMedia(i),'moa-r469-dot'+(i===ui.idx?' active':''));dot.setAttribute('aria-label',`${i+1}번째 사진`);dots?.append(dot);}
 const star=$('[data-op="cover"]',view);if(star)star.classList.toggle('active',String(getState()?.covers?.curated?.[ui.date]||'')===String(m.id));
 const fast=$('[data-op="fast"]',view);if(fast)fast.classList.toggle('active',ui.fast);renderRail();}
function changeMedia(i){if(!ui.media.length)return;window.MoaVoicePlaybackUI?.stop?.();ui.audioPlaying=false;const video=$('.moa-r469-stage-media video',view);if(video){video.pause();video.src='';video.remove()}
 ui.idx=Math.max(0,Math.min(ui.media.length-1,i));ui.info=false;const info=$('.moa-r469-info',view);if(info){info.hidden=true;info.replaceChildren()};renderMedia();}
function toggleTools(){const t=$('.moa-r469-tools',view);if(t)t.hidden=!ui.tools;}
function toggleRail(){const r=$('.moa-r469-rail',view),b=$('.moa-r469-rail-toggle',view);if(r)r.hidden=!ui.rail;if(b)b.textContent=ui.rail?'사진 목록 ⌃':'사진 목록 ⌄';if(ui.rail)renderRail();}
function renderRail(){const r=$('.moa-r469-rail',view);if(!r)return;r.replaceChildren();if(!ui.rail)return;const imgs=[];
 ui.media.forEach((m,i)=>{const tile=btn('',()=>changeMedia(i),'moa-r469-rail-item'+(i===ui.idx?' active':''));const img=elem('img');img.dataset.id=String(m.id);tile.append(img);if(isVideo(m))tile.append(elem('small','','▶'));r.append(tile);imgs.push(img)});fillImages(imgs);}
async function onAction(e){const op=e.target.closest('button[data-op]')?.dataset.op,m=dayMedia(ui.idx);if(!op||!m)return;
 if(op==='fast'){ui.fast=!ui.fast;renderMedia();notify(ui.fast?'빠른 연속 넘기기 ON':'한 장씩 넘기기 OFF');return}
 if(op==='share'){if(!nativePost(isVideo(m)?'diaryShareVideo':'sharePhoto',{id:String(m.id)}))notify('Android 공유 기능을 연결할 수 없습니다.');return}
 if(op==='cover'){await saveCover(m.id);return}
 if(op==='geo'){const pane=$('.moa-r469-info',view);if(pane){pane.hidden=false;pane.replaceChildren();try{if(typeof window.FamilyJourneyDiaryGeo?.attach==='function')window.FamilyJourneyDiaryGeo.attach(pane,String(m.id));else pane.textContent='현재 사진의 GPS 지도를 연결할 수 없습니다.'}catch(err){pane.textContent=String(err)}}return;}
 if(op==='info'){const pane=$('.moa-r469-info',view);if(!pane)return;ui.info=!ui.info;pane.hidden=!ui.info;if(ui.info){pane.replaceChildren(elem('p','',`촬영: ${new Date(Number(m.t)||Date.now()).toLocaleString('ko-KR')}`));try{window.FamilyJourneyDiaryGeo?.attach?.(pane,String(m.id))}catch(e){}}return;}
}
async function saveCover(id){const s=getState();if(!s?.covers)return;const covers=s.covers,old=covers.curated?.[ui.date];if(!covers.curated)covers.curated={};covers.curated[ui.date]=String(id);
 try{await persist('meta',coverKey,covers);notify('대표 사진이 달력 표지로 저장됐습니다.');renderMedia();}catch(e){if(old===undefined)delete covers.curated[ui.date];else covers.curated[ui.date]=old;notify('대표 사진 저장 실패: '+String(e))}}
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
function playInlineVideo(media){const stage=$('.moa-r469-stage-media',view);if(!stage||!isVideo(media))return;window.MoaVoicePlaybackUI?.stop?.();
 const video=elem('video','moa-r469-inline-video');video.controls=true;video.playsInline=true;video.preload='metadata';video.poster=stage.querySelector('img')?.src||'';
 video.src=`content://media/external/video/media/${String(media.id).slice(1)}`;video.onerror=()=>{
  video.pause();video.remove();notify('이 기기 WebView에서 직접 재생을 지원하지 않아 기존 네이티브 영상 플레이어를 사용합니다.');
  const fallback=btn('기존 재생기로 보기',()=>nativePost('diaryPlayVideo',{id:media.id}),'moa-r469-native-fallback');stage.append(fallback);
 };
 stage.append(video);const promise=video.play();if(promise?.catch)promise.catch(()=>{video.controls=true;});}
const originalAudioEvent=window.__moaNativeAudioEvent;
if(typeof originalAudioEvent==='function'){window.__moaNativeAudioEvent=function(evt){originalAudioEvent.apply(this,arguments);if(!ui.open||ui.page!=='day')return;const event=String(evt?.event||'');if(event==='play_started'||event==='play_resumed'){ui.audioPlaying=true;const b=$('.moa-r469-voice-play',view);if(b)b.textContent='Ⅱ';}else if(['play_paused','play_finished','play_error'].includes(event)){ui.audioPlaying=false;const b=$('.moa-r469-voice-play',view);if(b)b.textContent='▷';}if(['record_saved','delete'].includes(event))setTimeout(refreshVoices,250);};}
window.MoaR469SimpleDiary={openCalendar:()=>open('calendar'),openDay:d=>open('day',d),close,readOnlyStatus:()=>({active:ui.open,page:ui.page,date:ui.date,mediaCount:ui.media.length,voiceCount:ui.clips.length})};
if(document.readyState==='loading')document.addEventListener('DOMContentLoaded',start,{once:true});else start();
})();