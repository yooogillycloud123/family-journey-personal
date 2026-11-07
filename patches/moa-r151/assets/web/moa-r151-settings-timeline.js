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
   const play=mk('button','moa-r151-play',`▶ ${stamp} · ${Math.round((item.bytes||0)/1024)}KB`);
   play.type='button';play.addEventListener('click',()=>{try{voice().play(day,item.id);}catch(e){console.warn(e);}});
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