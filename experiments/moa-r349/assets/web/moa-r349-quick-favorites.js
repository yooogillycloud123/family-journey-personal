/* MOA R349 opt-in bridge to R345 first-party NAVER engine.
   This web companion supplements native camera Quick Record after the original diary IDB commit;
   the native camera popup itself is intentionally unmodified in this signed web-only increment. */
(()=>{'use strict';
const KEY='moa.r349.quick.nav.v1', MAX=600;
const prefs=()=>window.MoaR349Prefs||{};
let data={};try{data=JSON.parse(localStorage.getItem(KEY)||'{}')||{}}catch(_){}
const $=(s,r=document)=>r.querySelector(s);
const update=()=>{const items=Object.entries(data);if(items.length>MAX){items.sort((a,b)=>(a[1].updated||0)-(b[1].updated||0));data=Object.fromEntries(items.slice(-MAX))}try{localStorage.setItem(KEY,JSON.stringify(data))}catch(_){}}
function existing(id){return data[id]||{check:!!prefs().quickCheck,alias:'',memo:'',list:'',mode:'',status:'NOT_SUBMITTED'}}
function put(id,patch){data[id]={...existing(id),...patch,updated:Date.now()};update();return data[id]}
function candidate(id){const fn=window.FamilyJourneyNaver;if(!fn?.candidates)return null;let points=[];try{points=fn.candidates().filter(p=>(p.photoIds||[]).map(String).includes(String(id)))}catch(_){}return points.length===1?points[0]:null}
function listFor(item){return String(item.list||prefs().naverFolder||'내 장소').trim().slice(0,70)||'내 장소'}
function doSave(id,item,notify){const F=window.FamilyJourneyNaver;if(!F?.saveFromDiaryGps){notify?.('네이버 엔진 준비 중');return false}
 if(!item.check){notify?.('즐겨찾기 체크 해제됨 · 일기는 그대로 저장');return false}
 if(item.status==='VERIFIED'||item.status==='SUBMITTED_UNVERIFIED'||item.status==='PENDING'){notify?.('이미 진행 중이거나 확인이 필요한 기록이에요. 중복 저장을 실행하지 않았어요.');return false}
 const point=candidate(id);if(!point){put(id,{status:'NEEDS_LOCATION'});notify?.('사진의 정확한 위치를 아직 확인하지 못했어요. 일기는 저장돼 있습니다.');return false}
 const alias=String(item.alias||'').slice(0,25),memo=String(item.memo||'').slice(0,400),list=listFor(item);
 put(id,{status:'PENDING',alias,memo,list,check:true});
 const mode=(item.mode||prefs().naverMode)==='visible'?'web_visible':'web';
 let called=false;
 try {called=F.saveFromDiaryGps(point,alias,memo,list,(x)=>{
   const code=String(x?.state||'UNVERIFIED');let status=code;
   if(code==='NAVER_READBACK_VERIFIED')status='VERIFIED';
   else if(['WEB_SAVE_QUEUED_UNVERIFIED','SAVE_SUBMITTED_UNVERIFIED','SEARCHING'].includes(code))status='SUBMITTED_UNVERIFIED';
   else if(/(?:LOGIN|NEEDS|FAILED|UNAVAILABLE|AMBIGUOUS|NO_FRAME|UI_CHANGED|NOT_READY|NOT_STARTED)/.test(code))status=code;
   // NEVER turn an unverified DOM click into a claimed account-write success.
   put(id,{status,lastWebCode:code});notify?.(x?.message||code);
 },{mode});
 }catch(e){put(id,{status:'DISPATCH_ERROR'});notify?.('저장 작업 연결 실패');return false}
 if(!called)put(id,{status:'NOT_SUBMITTED'});
 return called;
}
function make(tag,txt){const n=document.createElement(tag);if(txt!=null)n.textContent=txt;return n}
function editor(tile){if(tile.querySelector('.moa-r349-quick-card'))return;const id=String(tile.dataset.moaMediaId||'');if(!/^(?:v?\d{1,19})$/.test(id))return;
 // Only render this companion where the native Quick Record / per-photo record pane exists.
 const details=tile.querySelector('.moa-r191-memo-fold, .moa-r191-media-record,details');if(!details)return;
 const info=existing(id),box=make('details');box.className='moa-r349-quick-card';const summary=make('summary','☆ 바로기록 · 네이버 즐겨찾기 연동');box.append(summary);
 const body=make('div');body.className='moa-r349-quick-body';
 const toggle=make('input');toggle.type='checkbox';toggle.checked=!!info.check;const label=make('label');label.append(toggle,make('span','네이버 즐겨찾기에도 저장'));body.append(label);
 const note=make('p','기존 일기 기록은 먼저 보존합니다. 이 항목은 정확한 사진 위치가 있을 때만 네이버에도 저장합니다.');note.className='r349-hint';body.append(note);
 const line=(title,el)=>{const row=make('label');row.append(make('span',title),el);body.append(row);return el};
 const alias=line('별명',make('input'));alias.maxLength=25;alias.placeholder='네이버에 표시할 별명';alias.value=info.alias||'';
 const memo=line('네이버 메모',make('textarea'));memo.rows=2;memo.maxLength=400;memo.placeholder='기록 메모와 다르게 작성할 수 있어요';memo.value=info.memo||tile.querySelector('.moa-r191-capture-text')?.textContent?.trim().slice(0,400)||'';
 const list=line('저장 리스트',make('input'));list.maxLength=70;list.value=info.list||prefs().naverFolder||'내 장소';list.placeholder='설정한 기본 리스트';
 const mode=line('저장 방식',make('select'));for(const [k,n] of [['offscreen','비점유 자동저장'],['visible','화면 보며 저장']]){const o=make('option',n);o.value=k;mode.append(o)}mode.value=info.mode||prefs().naverMode||'offscreen';
 const button=make('button','일기 기록 유지 · 네이버에도 저장');button.type='button';button.className='moa-r349-submit';const status=make('div');status.className='moa-r349-save-status';status.textContent=info.status==='VERIFIED'?'네이버 계정 재조회 확인':info.status==='SUBMITTED_UNVERIFIED'?'저장 확인 중':'일기에 저장된 기록 · 네이버 미신청';
 toggle.onchange=()=>{put(id,{check:toggle.checked});setFields()};function setFields(){[alias,memo,list,mode,button].forEach(x=>x.disabled=!toggle.checked)}setFields();
 for(const el of [alias,memo,list,mode])el.addEventListener('change',()=>put(id,{alias:alias.value.trim(),memo:memo.value.trim(),list:list.value.trim(),mode:mode.value}));
 button.onclick=()=>{const item=put(id,{check:toggle.checked,alias:alias.value.trim(),memo:memo.value.trim(),list:list.value.trim(),mode:mode.value});doSave(id,item,v=>status.textContent=v)};
 body.append(button,status);box.append(body);details.insertAdjacentElement('afterend',box);
}
function scan(){const root=$('#fj-diary-root');if(!root||root.hidden)return;let count=0;for(const tile of root.querySelectorAll('.moa-r191-media-tile[data-moa-media-id]')){if(count++>120)break;editor(tile)}}
let scheduled=0;function schedule(){if(scheduled)return;scheduled=setTimeout(()=>{scheduled=0;scan()},250)}
function style(){const s=make('style');s.id='moa-r349-quick-css';s.textContent=`
.moa-r349-quick-card{margin:6px 0 10px;border-radius:12px;border:1px solid #ead6e2;background:#fffafc;font-family:system-ui;color:#302831!important}
.moa-r349-quick-card summary{padding:10px;font-size:12px;font-weight:700;cursor:pointer;list-style:none}.moa-r349-quick-card summary::-webkit-details-marker{display:none}
.moa-r349-quick-body{padding:10px;display:grid;gap:9px}.moa-r349-quick-body label{display:flex;flex-direction:column;gap:4px;font-size:11px}.moa-r349-quick-body label:has([type=checkbox]){flex-direction:row;align-items:center}.moa-r349-quick-body input[type=checkbox]{width:19px;height:19px;accent-color:#b82d68}
.moa-r349-quick-body input:not([type=checkbox]),.moa-r349-quick-body textarea,.moa-r349-quick-body select{width:100%;min-width:0;box-sizing:border-box;border:1px solid #decbd6;border-radius:9px;padding:8px;font-size:12px;background:white;color:#332d34}
.moa-r349-quick-body .moa-r349-submit{border:0;border-radius:10px;background:#bd276b;color:white;padding:10px;font-weight:750;font-size:12px}.moa-r349-quick-body .moa-r349-submit:disabled{opacity:.5}.moa-r349-save-status,.moa-r349-quick-body .r349-hint{font-size:11px;color:#70616b;line-height:1.45}
`;document.head.append(s)}
// User-selected default checkbox ON can submit after the native popup really committed
// ONLY when a unique photo-position, previously saved diary note and first-party engine are available.
// To prevent unexpected duplicates, an already-submitted, ambiguous, or location-missing job is never retried automatically.
function nativeCommitted(drafts){if(!prefs().quickCheck)return;const items=Array.isArray(drafts)?drafts:[];for(const draft of items){
 const id=String(draft.id||''),note=String(draft.note||'').trim();if(!id||!note||!/^(?:v?\d{1,19})$/.test(id))continue;
 if(data[id])continue; // record-specific override or prior attempt always wins
 const item=put(id,{check:true,alias:note.split(/\n/)[0].slice(0,25),memo:note.slice(0,400),list:prefs().naverFolder||'내 장소',mode:prefs().naverMode||'offscreen',status:'QUEUED_FROM_DIARY'});
 // A location still must be in the user's real photo GPS index; if not, record stays safe pending.
 const p=candidate(id);if(!p){put(id,{status:'NEEDS_LOCATION',retryUntil:Date.now()+45000});continue}
 doSave(id,item,()=>{});
 }}
function retryPendingGPS(){for(const [id,item] of Object.entries(data)){if(item.status!=='NEEDS_LOCATION'||!item.retryUntil||Date.now()>item.retryUntil)continue;if(!candidate(id))continue;put(id,{status:'QUEUED_FROM_DIARY'});doSave(id,data[id],()=>{});}}
function main(){style();document.body&&new MutationObserver(schedule).observe(document.body,{childList:true,subtree:true});setTimeout(scan,700);setInterval(retryPendingGPS,3500);window.addEventListener('focus',()=>setTimeout(retryPendingGPS,250));
 window.addEventListener('moa:r349-native-committed',e=>nativeCommitted(e.detail?.drafts));
 window.MoaR349Quick={save:doSave,get:existing,find:candidate,scan};}
if(document.readyState==='loading')document.addEventListener('DOMContentLoaded',main,{once:true});else main();
})();
