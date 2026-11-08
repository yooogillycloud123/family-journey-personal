/* MOA R149: Android-native recorded voice per diary day, separate from legacy STT.
 * Uses MoaLocalAudio Java bridge and Android MediaRecorder; no WebView getUserMedia.
 */
(()=>{'use strict';
const id='moa-r149-voice-modal';
const q=(s,root=document)=>root.querySelector(s);
const el=(t,c,text)=>{const x=document.createElement(t);if(c)x.className=c;if(text!==undefined)x.textContent=text;return x;};
const btn=(text,c,onClick)=>{const b=el('button',c,text);b.type='button';b.addEventListener('click',onClick);return b;};
let overlay=null,day='',recording=false,pending=false,lock=false,poll=0;
const native=()=>window.MoaLocalAudio;
const bridge=()=>!!(native()&&typeof native().recordStart==='function');
const text=s=>{const e=q('.moa-r149-status',overlay);if(e)e.textContent=String(s||'');};
const validDay=d=>/^\d{4}-(0[1-9]|1[0-2])-(0[1-9]|[12]\d|3[01])$/.test(d||'');
function stop(){if(!bridge()||!recording)return;lock=true;text('녹음 종료와 파일 저장을 진행 중입니다…');native().recordStop();}
function start(){if(!bridge()){text('기기 음성 저장 기능 연결을 찾을 수 없습니다. 앱을 완전히 종료하고 다시 열어 주세요.');return;}
 if(recording||lock)return;
 lastRecordingDay=day;beforeIds=new Set();
 try{for(const file of JSON.parse(native().list(day)||'[]'))if(file?.id)beforeIds.add(file.id);}catch(_){}
 lock=true;text('Android 마이크 권한을 확인하고 있습니다…');native().recordStart(day);
}
function close(){if(!overlay)return false;if(recording||lock){if(recording)stop();text('녹음 저장이 완료되면 닫을 수 있습니다.');return true;}
 overlay.remove();overlay=null;day='';return true;}
function statusButtons(){if(!overlay)return;const start=q('.moa-r149-start',overlay),stopBtn=q('.moa-r149-stop',overlay);if(start)start.disabled=recording||lock;if(stopBtn)stopBtn.disabled=!recording;}
// R155: Metadata is an additional local record. The .m4a file is never renamed, moved or edited.
const META_KEY='moa.voice.notes.v1';
const safeKey=(d,i)=>d+'/'+i;
function allMeta(){try{const obj=JSON.parse(localStorage.getItem(META_KEY)||'{}');return obj&&typeof obj==='object'&&!Array.isArray(obj)?obj:{};}catch(_){return {};}}
function metaFor(d,i){return allMeta()[safeKey(d,i)]||{};}
function saveMeta(d,i,title,transcript,quiet=false){try{
 const all=allMeta(),old=all[safeKey(d,i)]||{};all[safeKey(d,i)]={...old,title:String(title||'').trim().slice(0,120),transcript:String(transcript||'').trim().slice(0,50000),editedAt:Date.now(),origin:'user'};
 localStorage.setItem(META_KEY,JSON.stringify(all));if(!quiet)window.MoaVoiceTimelineRefresh?.();return true;
 }catch(e){text('녹음 제목·내용 저장 실패: '+e.message);return false;}}
let playing=null,playedSeconds=0,playTimer=0;
// One file -> one separately labeled transcript. Never overwrite manually written notes.
const transcribing=new Set();const timeouts=new Map();let beforeIds=new Set();let lastRecordingDay='';
const AUTO_PREF='moa.voice.record.autotext.v1';
function autoEnabled(){try{return localStorage.getItem(AUTO_PREF)!=='off';}catch(_){return true;}}
function autoSet(enabled){try{localStorage.setItem(AUTO_PREF,enabled?'on':'off');}catch(_){}}
function putAutoState(d,i,fields){try{
 const all=allMeta(),k=safeKey(d,i);all[k]={...(all[k]||{}),...fields};localStorage.setItem(META_KEY,JSON.stringify(all));return true;
 }catch(e){text('녹음 텍스트 상태 저장 실패: '+e.message);return false;}}

const transcribeAvailable=()=>!!(native()&&typeof native().transcribe==='function');
function requestFileTranscript(d,i,automatic=false){
 if(!transcribeAvailable()){text('저장된 음성 자동 변환을 지원하지 않는 현재 Android 호스트입니다.');return;}
 const k=safeKey(d,i);
 if(transcribing.has(k))return;
 if(!automatic&&!window.confirm('저장된 음성을 기기 음성인식기로 변환할까요? 결과는 정확하지 않을 수 있으며 수정 가능한 초안으로 저장됩니다.'))return;
 transcribing.add(k);putAutoState(d,i,{autoStatus:'pending',autoError:'',autoRequestedAt:Date.now()});
 if(timeouts.has(k))clearTimeout(timeouts.get(k));
 timeouts.set(k,setTimeout(()=>{if(!transcribing.has(k))return;transcribing.delete(k);timeouts.delete(k);
  putAutoState(d,i,{autoStatus:'error',autoError:'인식 시간이 초과되었습니다. 다시 시도할 수 있습니다.'});
  text('음성파일 변환 응답이 없어 종료했습니다. 원본 M4A는 유지됩니다.');
  if(overlay)list();updateTranscriptButtons();
 },180000));
 text('저장된 녹음파일 자동 글 변환을 시도하고 있습니다. 음성인식 서비스가 파일 입력을 지원하지 않을 수도 있습니다.');
 try{native().transcribe(d,i);}catch(e){transcribing.delete(k);text('파일 글 변환 요청 실패: '+e.message);}
 updateTranscriptButtons();
}
function updateTranscriptButtons(){
 document.querySelectorAll('[data-moa-transcribe]').forEach(b=>{
  const busy=transcribing.has(b.dataset.moaTranscribe);b.disabled=busy;
  b.textContent=busy?'변환 중…':'자동 글 변환';
 });
}
function onTranscriptionEvent(type,message){
 if(type!=='transcribe_result'&&type!=='transcribe_error'&&type!=='transcribe_started')return;
 let data={};try{data=JSON.parse(message);}catch(e){text(message||'음성 변환 상태를 확인할 수 없습니다.');return;}
 const d=String(data.day||''),i=String(data.id||'');if(!validDay(d)||!/^[0-9a-zA-Z_-]{8,90}\.m4a$/.test(i))return;
 const k=safeKey(d,i);
 if(type==='transcribe_started'){
  transcribing.add(k);putAutoState(d,i,{autoStatus:'pending'});updateTranscriptButtons();
  text('저장된 녹음에서 음성 텍스트를 추출하는 중입니다.');return;
 }
 transcribing.delete(k);if(timeouts.has(k)){clearTimeout(timeouts.get(k));timeouts.delete(k);}updateTranscriptButtons();
 if(type==='transcribe_error'){
  const reason=String(data.text||'인식 서비스 오류').slice(0,400);
  putAutoState(d,i,{autoStatus:'error',autoError:reason});
  text('음성 자동 변환을 완료하지 못했습니다. 원본 녹음은 안전하게 보존됩니다. '+reason);
 }else{
  const recognized=String(data.text||'').trim();
  if(!recognized){putAutoState(d,i,{autoStatus:'error',autoError:'인식된 문장이 없습니다.'});text('녹음에서 인식된 문장이 없습니다.');}
  else{
   putAutoState(d,i,{autoTranscript:recognized.slice(0,50000),autoStatus:'review',autoError:'',autoEngine:'Android 음성 파일 입력(기기 지원에 따라 결과 다름)',autoRecognizedAt:Date.now()});
   text('자동 녹음 텍스트 초안을 저장했어. 원본을 들으며 정확도를 확인해 주세요.');
  }
 }
 if(overlay&&!q('.moa-r155-editor',overlay))list();
}

function dictateInto(field,feedback){
 if(typeof native()?.speechStart!=='function'){feedback.textContent='기존 Android 음성입력을 사용할 수 없습니다.';return;}
 const token='moa-voice-note-'+Date.now().toString(36),previous=window.__moaVoiceNativeResult;
 let best='';
 const wrapper=function(t,p,phase){
  if(t!==token){if(typeof previous==='function')return previous.apply(this,arguments);return;}
  if(phase==='partial'){feedback.textContent='듣는 중… '+String(p||'');return;}
  if(phase==='success'&&p){best=String(p);field.value=(field.value.trim()?field.value.trim()+' ':'')+best;feedback.textContent='음성입력을 글에 추가했습니다. 저장을 누르면 보관됩니다.';}
  else if(phase==='error'||phase==='permission'){feedback.textContent=String(p||'음성인식 오류');}
  else if(phase==='finished'){
   if(window.__moaVoiceNativeResult===wrapper)window.__moaVoiceNativeResult=previous;
   if(!best)feedback.textContent='인식된 문장이 없습니다. 다시 말하거나 직접 입력할 수 있습니다.';
  }
 };
 window.__moaVoiceNativeResult=wrapper;
 feedback.textContent='말씀해 주세요…';
 try{native().speechStart(token);}catch(e){window.__moaVoiceNativeResult=previous;feedback.textContent='음성입력 시작 실패: '+e.message;}
}

const stampTime=ms=>new Date(Number(ms)).toLocaleTimeString('ko-KR',{hour:'2-digit',minute:'2-digit'});
const fmtSec=s=>String(Math.floor(s/60)).padStart(2,'0')+':'+String(s%60).padStart(2,'0');
function updatePlayback(){
 for(const b of document.querySelectorAll('[data-moa-audio-play]')){
  const selected=playing&&b.dataset.moaAudioPlay===safeKey(playing.day,playing.id);
  const t=b.dataset.moaAudioTitle||'듣기';
  b.textContent=selected?'◉ 재생 중 · '+fmtSec(Math.max(0,Math.floor((Date.now()-playing.since)/1000))):'▶ '+t;
  b.setAttribute('aria-label',selected?'음성 재생 중 (경과 시간 표시)':'음성 재생: '+t);
  b.classList.toggle('moa-voice-playing',!!selected);
 }
}
function playVoice(d,i,button){
 if(!native()||typeof native().play!=='function')return;
 // If the user saved a transcript, expose it together with playback.
 if(overlay&&day===d&&metaFor(d,i).transcript){
  const card=q('[data-moa-voice-id="'+CSS.escape(i)+'"]',overlay);
  if(card){const content=q('.moa-r155-text-value',card),toggle=q('.moa-r155-text-btn',card);
   if(content)content.hidden=false;if(toggle)toggle.textContent='글 내용 접기';}
 }
 playing={day:d,id:i,since:Date.now()};updatePlayback();
 try{native().play(d,i);}catch(err){playing=null;updatePlayback();text('재생 실패: '+err.message);}
}
function playbackEvent(event,message){
 if(event==='play_started'&&playing){playing.since=Date.now();}
 if(event==='play_finished'||event==='play_error'){playing=null;}
 if(event==='play_error'&&overlay)text(message||'재생 실패');
 updatePlayback();
}
function editMeta(d,i){
 if(!overlay)return;
 q('.moa-r155-editor',overlay)?.remove();
 const old=metaFor(d,i),section=el('section','moa-r155-editor');section.setAttribute('role','group');
 section.append(el('strong','','녹음 이름·내용'));
 const name=el('input','moa-r155-name');name.type='text';name.maxLength=120;
 name.placeholder='예: 오늘 가족과 나눈 이야기';name.value=old.title||'';section.append(name);
 const label=el('label','moa-r155-caption','녹음 내용 텍스트 (직접 작성·편집)');section.append(label);
 const body=el('textarea','moa-r155-transcript');body.rows=5;
 body.placeholder='녹음한 말을 텍스트로 기록해 두세요. 자동 받아쓰기는 아직 지원하지 않습니다.';
 body.value=old.transcript||'';label.append(body);
 const dictationHint=el('p','moa-r155-caption','음성입력은 말한 내용을 편집창에 추가합니다. 저장된 녹음의 자동 글 변환과는 별개입니다.');
 const dictate=btn('🎙 말로 글 입력','moa-r155-dictate',()=>dictateInto(body,dictationHint));
 section.append(dictate,dictationHint);
 if(old.autoTranscript){
  const draft=el('p','moa-r155-caption','별도 녹음 텍스트 초안: '+old.autoTranscript);
  section.append(draft,btn('녹음 텍스트를 수동 메모에 복사','moa-r155-dictate',()=>{body.value=old.autoTranscript;}));
 }
 const row=el('div','moa-r155-editor-row');row.append(btn('저장','moa-r155-save',()=>{
  if(saveMeta(d,i,name.value,body.value)){section.remove();list();}
 }),btn('취소','moa-r155-cancel',()=>section.remove()));section.append(row);
 const card=q('[data-moa-voice-id="'+CSS.escape(i)+'"]',overlay);
 if(card)card.append(section);else q('.moa-r149-files',overlay)?.prepend(section);
 name.focus();
}
function list(){if(!overlay)return;
 const box=q('.moa-r149-files',overlay);box.replaceChildren();
 if(!bridge()){box.append(el('p','moa-r149-note','네이티브 음성파일 목록을 사용할 수 없습니다.'));return;}
 let items=[];try{items=JSON.parse(native().list(day)||'[]');}catch(e){text('저장된 녹음을 불러오지 못했습니다: '+e.message);return;}
 if(!Array.isArray(items)||!items.length){box.append(el('p','moa-r149-note','이 날짜에 저장된 원본 음성 녹음이 없습니다.'));return;}
 for(const item of items){if(!item||!/^[0-9a-zA-Z_-]{8,90}\.m4a$/.test(item.id||''))continue;
  const note=metaFor(day,item.id),card=el('div','moa-r149-file');card.dataset.moaVoiceId=item.id;
  const when=new Date(item.time).toLocaleString('ko-KR');
  card.append(el('strong','moa-r155-title',note.title||('음성 기록 · '+stampTime(item.time))));
  card.append(el('div','moa-r149-file-name',when+' · '+Math.max(0,Math.round((item.bytes||0)/1024))+'KB'));
  const row=el('div','moa-r149-file-actions');
  const play=btn('▶ 듣기','moa-r155-play',()=>playVoice(day,item.id,play));
  play.dataset.moaAudioPlay=safeKey(day,item.id);play.dataset.moaAudioTitle=note.title||'듣기';
  const auto=btn('녹음 텍스트','moa-r159-show-automatic',()=>{
   const content=q('.moa-r159-autotext-value',card);if(content)content.hidden=!content.hidden;
  });
  auto.dataset.moaTranscribe=safeKey(day,item.id);
  row.append(auto);
  row.append(play,btn('이름·글 편집','moa-r155-edit',()=>editMeta(day,item.id)),btn('삭제','',()=>{
   if(!window.confirm('이 날짜의 선택한 음성 원본을 삭제할까요?'))return;
   native().delete(day,item.id);
  }));card.append(row);
  const info=el('div','moa-r155-text');
  const toggle=btn(note.transcript?'글 내용 보기':'글 내용 추가','moa-r155-text-btn',()=>{
    const content=q('.moa-r155-text-value',info);const shown=content.hidden;content.hidden=!shown;
    toggle.textContent=shown?'글 내용 접기':(note.transcript?'글 내용 보기':'글 내용 추가');
    if(shown&&!note.transcript)editMeta(day,item.id);
  });
  info.append(toggle);
  const content=el('div','moa-r155-text-value',note.transcript||'입력한 녹음 내용 텍스트가 아직 없습니다.');content.hidden=true;
  info.append(content);card.append(info);
  const autoBlock=el('div','moa-r159-autotext');
  const autoValue=el('div','moa-r159-autotext-value');autoValue.hidden=true;
  autoValue.append(el('strong','','녹음 원본 자동 인식 · 검토용 초안'));
  const recognized=String(note.autoTranscript||'').trim();
  autoValue.append(el('p','',recognized||
   (note.autoStatus==='pending'?'음성파일을 글로 변환하는 중입니다…':
    note.autoStatus==='error'?'자동 인식 미완료: '+String(note.autoError||'기기 음성인식 지원을 확인하세요.'):
    '아직 녹음 텍스트가 생성되지 않았습니다.')));
  if(recognized)autoValue.append(el('p','moa-r155-caption','자동 인식은 부정확할 수 있으므로 원본을 듣고 확인해 주세요.'));
  if(transcribeAvailable())autoValue.append(btn(recognized?'다시 자동 인식':'이 파일 자동 인식','moa-r159-retry',()=>requestFileTranscript(day,item.id)));
  autoBlock.append(autoValue);card.append(autoBlock);box.append(card);
 }
 updatePlayback();
}
function open(){const state=window.FamilyJourneyDiary?.state;
 if(!state?.open||state.page!=='day'||!validDay(state.date))return false;
 if(overlay)return true;day=state.date;recording=false;lock=false;
 const wrap=el('div','moa-r149-overlay');wrap.id=id;
 const shade=el('div','moa-r149-shade');shade.addEventListener('click',close);
 const panel=el('section','moa-r149-panel');panel.setAttribute('role','dialog');panel.setAttribute('aria-modal','true');
 const heading=el('header','moa-r149-head');heading.append(el('strong','',`원본 음성 기록 · ${day}`),btn('닫기 ×','moa-r149-close',close));panel.append(heading);
 panel.append(el('p','moa-r149-note','음성을 글로 바꾸는 기존 받아쓰기와는 별개입니다. 누르면 실제 목소리가 Android 내부 저장소에 날짜별 M4A 파일로 보관됩니다.'));
 const actions=el('div','moa-r149-controls');actions.append(btn('● 녹음 시작','moa-r149-start',start),btn('■ 종료·저장','moa-r149-stop',stop));panel.append(actions);
 const autoSetting=el('label','moa-r159-auto-setting');const cb=el('input');cb.type='checkbox';cb.checked=autoEnabled();cb.addEventListener('change',()=>autoSet(cb.checked));
 autoSetting.append(cb,document.createTextNode(' 녹음 저장 후 원본 음성 자동 텍스트 변환 시도 (기기 지원 시)'));
 panel.append(autoSetting);
 panel.append(el('p','moa-r149-status',bridge()?'마이크를 사용하려면 녹음 시작을 누르세요.':'Android 오디오 저장 기능에 연결하는 중입니다.'));
 panel.append(el('h3','','이 날짜에 저장한 녹음'));
 const files=el('div','moa-r149-files');panel.append(files);
 panel.append(el('p','moa-r149-note','녹음 원본은 앱 내부에 저장됩니다. R165의 외부 안전 보관을 완료한 복사본은 내 파일 → Music → MOA-Recordings → 날짜 폴더에서 확인할 수 있습니다. 목록에서 재생된다는 사실만으로는 외부 백업 성공을 확인할 수 없으며, 일기·메모 연결정보는 별도로 백업해야 합니다.'));
 wrap.append(shade,panel);document.body.append(wrap);overlay=wrap;statusButtons();list();wrapBack();return true;}
function wrapBack(){for(const k of ['__fjBackOverlay','__photoMapBack']){
 const prev=window[k];if(typeof prev!=='function'||prev.__moaR149)return;
 const wrap=function(...args){if(overlay)return close();return prev.apply(this,args);};wrap.__moaR149=true;window[k]=wrap;
}}
window.__moaNativeAudioEvent=function(obj){if(!obj||typeof obj!=='object')return;
 const event=String(obj.event||''),msg=String(obj.message||'');
 if(event==='record_started'){recording=true;lock=false;}
 if(event==='record_saved'||event==='record_error'){recording=false;lock=false;if(overlay)list();}
 if(event==='delete'&&overlay)list();
 onTranscriptionEvent(event,msg);
 if(event==='record_saved'&&autoEnabled()&&transcribeAvailable()){
  // Correlate the exact newly written M4A, never guess from the previous newest file.
  try{const files=JSON.parse(native().list(lastRecordingDay)||'[]');
   const added=files.find(f=>f&&f.id&&!beforeIds.has(f.id));
   if(added)requestFileTranscript(lastRecordingDay,added.id,true);
   else text('음성파일 저장은 완료되었으나 새 녹음 식별이 어려워 자동 변환을 건너뛰었습니다.');
  }catch(e){text('자동 변환용 파일 조회 실패: '+e.message);}
 }
 if(event==='record_saved'||event==='record_error')beforeIds.clear();
 playbackEvent(event,msg);
 if(overlay){if(!event.startsWith('transcribe_') && !(event==='record_saved'&&autoEnabled()&&transcribeAvailable()))text(msg);statusButtons();}
};
function enhance(){const root=q('#fj-diary-root'),state=window.FamilyJourneyDiary?.state;
 if(!root||root.hidden||!state?.open||state.page!=='day'||!validDay(state.date))return;
 if(q('#moa-r149-open',root))return;
 const anchor=q('#moa-r133-open-day-list',root)||q('.fd23-daystats',root);
 if(!anchor)return;
 const b=btn('🎙 음성 녹음·목록','moa-r149-open',open);b.id='moa-r149-open';
 anchor.insertAdjacentElement('afterend',b);
}
function init(){const root=q('#fj-diary-root');if(root){new MutationObserver(enhance).observe(root,{childList:true,subtree:false,attributes:true,attributeFilter:['hidden']});}
 document.addEventListener('keydown',e=>{if(overlay&&(e.key==='Escape'||e.key==='Backspace')){e.preventDefault();e.stopImmediatePropagation();close();}},true);
 document.addEventListener('visibilitychange',()=>{if(document.hidden&&recording)stop();});
 poll=window.setInterval(()=>{enhance();if(overlay)wrapBack();},800);
 playTimer=window.setInterval(()=>{if(playing)updatePlayback();},500);enhance();}
if(document.readyState==='loading')document.addEventListener('DOMContentLoaded',init,{once:true});else init();
window.MoaVoiceDiaryNative={open,close,list,version:'R159-auto-file-transcript-beta'};
 window.MoaVoicePlaybackUI={play:playVoice,metaFor,saveMeta,updatePlayback};
})();

;(()=>{const s=document.createElement('style');s.id='moa-r155-voice-style';s.textContent=`
.moa-r155-title{display:block;margin:4px 0 6px;font-size:15px;color:var(--ink,#27212b)}
.moa-r149-file-actions{display:flex;flex-wrap:wrap;gap:7px}
.moa-r149-file-actions button{min-height:40px}
.moa-r155-play.moa-voice-playing,.moa-r151-play.moa-voice-playing{background:var(--accent,#ef0070)!important;color:white!important;border-color:transparent!important}
.moa-r155-text{margin:7px 0 0}.moa-r155-text-btn{padding:8px 10px;border-radius:9px;border:1px solid #ead0dc;background:#fff8fb;color:var(--accent,#b80657);font-weight:600}
.moa-r155-text-value{margin-top:7px;border-radius:9px;padding:12px;background:#f6f3f6;white-space:pre-wrap;overflow-wrap:anywhere;color:#332a36;line-height:1.5}
.moa-r155-editor{margin-top:12px;display:flex;flex-direction:column;gap:8px;padding:12px;border:1px solid #ecd7e1;border-radius:12px;background:#fffafb}
.moa-r155-editor input,.moa-r155-editor textarea{width:100%;box-sizing:border-box;border:1px solid #ddd0db;border-radius:10px;padding:12px;color:#28222b;background:white;font-size:15px}
.moa-r155-caption{font-size:13px;color:#746a73}.moa-r155-editor-row{display:flex;gap:8px}
.moa-r155-editor-row button{flex:1;padding:10px;border-radius:10px;border:1px solid #e4cfda;background:#fff}
.moa-r155-editor-row button:first-child{background:var(--accent,#ef0070);color:#fff}
`;document.head.append(s);})();

;(()=>{if(!document.getElementById('moa-r157-voice-style')){const s=document.createElement('style');s.id='moa-r157-voice-style';s.textContent='.moa-r155-transcribe,.moa-r155-dictate{border:1px solid #e0ccdb;background:#fff4f8;color:#b60558;font-weight:700;border-radius:12px;padding:8px 12px;margin:3px}.moa-r155-transcribe:disabled{opacity:.5}';document.head.appendChild(s);}})();

;(()=>{if(document.getElementById('moa-r159-style'))return;const s=document.createElement('style');s.id='moa-r159-style';s.textContent=`
.moa-r159-auto-setting{display:flex;align-items:center;gap:8px;padding:9px 12px;font-size:13px;color:var(--ink,#27212b)}
.moa-r159-auto-setting input{accent-color:var(--accent,#ef0070);width:18px;height:18px;flex-shrink:0}
.moa-r159-show-automatic,.moa-r159-retry{border-radius:10px;border:1px solid #ecd5df;background:#fff4f9;color:var(--accent,#bf0060);padding:9px 13px;font-weight:650}
.moa-r159-autotext-value{border:1px solid #ebd8e0;border-radius:12px;margin-top:8px;padding:13px;white-space:pre-wrap;line-height:1.5;overflow-wrap:anywhere;background:#fff8fb}
.moa-r159-autotext-value p{margin:8px 0 10px}
`;document.head.appendChild(s);})();