/* MOA R231 — independently configurable NAVER return overlay + opt-in read-only WebView experiment.
 * Existing R215 quick-record settings/preferences and Diary/Gallery DB are never edited.
 * This script is inert outside MOA Settings and uses the original MOA native bridge.
 */
(()=>{'use strict';
 const ID='moa-r231-naver-settings';
 const defaults={enabled:true,style:'glass',text:true,xStyle:'round',hideSec:0,move:true,resize:true,snap:false,opacity:92,sizePct:100,allowed:false};
 const $=id=>document.getElementById(id), bridge=()=>window.MoaMomentNative||null;
 const h=(tag,cls,txt)=>{const n=document.createElement(tag);if(cls)n.className=cls;if(txt!=null)n.textContent=txt;return n;};
 let state={...defaults},fields={},preview=null,statusLabel=null,panel=null,lastProbePoll=0;
 const opt={
  style:{glass:'미니멀 글래스',dark:'시크 블랙',light:'라이트 글래스',outline:'아웃라인'},
  xStyle:{round:'라운드',plain:'심플',bold:'볼드'},
  hideSec:{0:'자동 숨김 없음',5:'5초',10:'10초',15:'15초',30:'30초',60:'60초'}
 };
 const css=document.createElement('style');css.textContent=`
 #${ID}{list-style:none!important;margin:14px 0!important;padding:0!important;border:1px solid #e6dce4!important;border-radius:24px!important;overflow:hidden!important;background:#fff!important;color:#282636!important}
 #${ID} .r231-title{width:100%;padding:17px 19px;min-height:82px;border:0!important;background:#fff!important;display:flex;align-items:center;justify-content:space-between;text-align:left;color:#282636!important}
 #${ID} .r231-title strong{display:block;font-size:17px;font-weight:750}#${ID} .r231-title small{display:block;font-size:12px;margin-top:5px;color:#6d6470}
 #${ID} .r231-content{background:#fcfafc!important;padding:14px 16px 18px;display:grid;gap:14px;color:#292735}
 #${ID} .r231-content[hidden]{display:none!important}#${ID} .r231-heading{font-size:12px;font-weight:750;color:#6d636d;margin-top:12px}
 #${ID} .r231-row{display:flex;align-items:center;justify-content:space-between;min-height:50px;gap:12px}
 #${ID} label{font-size:13px;font-weight:650;line-height:1.5;color:#302b35}
 #${ID} input[type=checkbox]{accent-color:#ee3153;width:20px;height:20px;flex:none}
 #${ID} select{min-width:0;max-width:58%;padding:8px;border-radius:12px;border:1px solid #d9cbd4;background:#fff;color:#2d2c35;color-scheme:light;font-size:13px;min-height:43px}
 #${ID} input[type=range]{width:100%;accent-color:#ee3153}#${ID} .r231-range{display:flex;align-items:center;gap:12px}#${ID} output{width:56px;text-align:right;font-size:14px;color:#393440;font-variant-numeric:tabular-nums}
 #${ID} .r231-buttons{display:grid;grid-template-columns:repeat(3,minmax(0,1fr));gap:6px}
 #${ID} .r231-buttons button{min-height:43px;padding:7px 4px!important;border-radius:12px!important;background:#f0edf0!important;border:1px solid #d7ced4!important;font-size:11px!important;color:#332e38!important}
 #${ID} .r231-help{font-size:11.5px;line-height:1.65;color:#68606b;margin:0}
 #${ID} .r231-preview-area{min-height:111px;display:flex;justify-content:center;align-items:center;background:radial-gradient(circle at top,#50505a,#20222a 80%);border-radius:16px;border:1px solid #666774;overflow:hidden}
 #${ID} .r231-preview{max-width:95%;box-sizing:border-box;display:flex;align-items:center;justify-content:space-between;padding:0 5px;border:1px solid #bbc0c9;border-radius:99px;box-shadow:0 7px 18px #0008}
 #${ID} .r231-preview-main{font-weight:760;display:flex;align-items:center;justify-content:center;flex:1;letter-spacing:.2px}
 #${ID} .r231-x{height:36px;min-width:36px;display:grid;place-items:center;font-size:18px;border-left:1px solid #ffffff36}
 #${ID} .r231-state{min-height:47px;background:#f3edf2;border:1px solid #d9cfd8;border-radius:12px;padding:10px;font-size:11px;color:#453d48;line-height:1.5;word-break:break-word}
 #${ID} .r231-probe-actions{display:grid;grid-template-columns:repeat(2,minmax(0,1fr));gap:8px}
 #${ID} .r231-probe-actions button{min-height:46px;border:1px solid #d9cad2;background:#fff;border-radius:12px;color:#27252f;font-size:12px;font-weight:690;padding:7px}
 #${ID} .r231-probe-actions button:first-child{background:#e93557;color:white;border:0}
 `;document.head.append(css);
 const read=()=>{try{const b=bridge();if(b&&typeof b.naverReturnPrefs==='function')state={...defaults,...JSON.parse(b.naverReturnPrefs()||'{}')};}catch(e){console.warn('MOA R231 prefs read',e)}return state;};
 function save(up){const b=bridge();if(b&&typeof b.setNaverReturnPrefs==='function'){try{b.setNaverReturnPrefs(JSON.stringify(up));}catch(e){console.warn('MOA R231 prefs write',e)}}state={...state,...up};if('sizePct'in up||up.resetSize)state.hasCustomDimensions=false;read();paint();}
 const row=(name,control)=>{const r=h('div','r231-row');r.append(h('label','',name),control);return r;};
 const checkbox=(k)=>{const e=h('input');e.type='checkbox';e.checked=!!state[k];e.addEventListener('change',()=>save({[k]:e.checked}));fields[k]=e;return e;};
 const select=(k,values)=>{const e=h('select');for(const [v,label] of Object.entries(values)){const o=h('option','',label);o.value=v;e.append(o)}e.value=String(state[k]);e.addEventListener('change',()=>save({[k]:k==='hideSec'?Number(e.value):e.value}));fields[k]=e;return e;};
 function slider(k,label,min,max,step,unit){panel.append(h('div','r231-heading',label));const r=h('div','r231-range'),s=h('input'),v=h('output');s.type='range';s.min=min;s.max=max;s.step=step;s.value=state[k];fields[k]=s;
  s.addEventListener('input',()=>{state[k]=Number(s.value);paint()});s.addEventListener('change',()=>save({[k]:Number(s.value)}));v.id=ID+'-'+k;r.append(s,v);panel.append(r);}
 function paint(){
  for(const [key,el] of Object.entries(fields))if(el){if(el.type==='checkbox')el.checked=!!state[key];else el.value=String(state[key]);}
  for(const k of ['sizePct','opacity']){const el=$(ID+'-'+k);if(el)el.textContent=state[k]+'%'}
  if(!preview)return;
  const scale=(+state.sizePct||100)/100;
  const w=state.hasCustomDimensions?+state.sizeWidthDp||154:Math.round(154*scale);
  const ht=state.hasCustomDimensions?+state.sizeHeightDp||48:Math.round(48*scale);
  preview.style.width=Math.max(130,Math.min(300,w))+'px';preview.style.height=Math.max(44,Math.min(108,ht))+'px';
  preview.style.opacity=String(Math.max(.45,Math.min(1,state.opacity/100)));
  const light=state.style==='light';preview.style.background=light?'#fcfafd':state.style==='dark'?'#131419':'#252830';
  preview.style.color=light?'#2a2530':'#faf9fb';preview.style.borderColor=light?'#bdb0bd':'#b9bec9';
  preview.replaceChildren();const main=h('span','r231-preview-main',state.text?'↶  MOA':'↶');
  const x=h('span','r231-x','×');if(state.xStyle==='bold')x.style.fontWeight=950;
  if(state.xStyle==='round')x.style.borderRadius='50%';preview.append(main,x);
 }
 function probe(action){try{const b=bridge();if(!b||typeof b.naverWebProbeControl!=='function')return statusLabel.textContent='이 버전에서는 웹뷰 실험을 실행할 수 없어요.';
  const ret=b.naverWebProbeControl(action);statusLabel.textContent='요청: '+ret;setTimeout(readProbe,450);
 }catch(e){statusLabel.textContent='진단 호출 실패: '+String(e)}}
 function readProbe(){if(!statusLabel)return;try{const b=bridge();if(typeof b?.naverWebProbeStatus!=='function')return;
  const j=JSON.parse(b.naverWebProbeStatus()||'{}');
  const obj=j.counts||{};const names=['saveButton','saveDialogList','saveCommit','createList','listTitle','saveListConfirm'];
  const vals=names.filter(k=>typeof obj[k]==='number').map(k=>k+' '+obj[k]).join(' · ');
  const phrases={
   NAVER_APP_OPEN_REQUEST_SUPPRESSED_WEB_ONLY:'네이버 앱으로 이동하라는 요청을 막고 웹 화면을 유지했어요. 이것은 계정 차단이 아닙니다.',
   NAVER_APP_INSTALL_LANDING_DESKTOP_REQUEST_UNSUCCESSFUL:'네이버가 웹 지도 대신 앱 설치 화면을 보여줍니다. 현재 WebView에서는 지도 저장을 검증할 수 없어요.',
   EXTERNAL_WEB_NAVIGATION_BLOCKED:'네이버 외부 사이트로 이동하려는 요청을 차단했어요.',
   NON_HTTPS_NAVIGATION_BLOCKED:'웹 주소가 아닌 이동 요청을 차단했어요.',
   VISIBLE_DESKTOP_PAGE_FINISHED_UNVERIFIED:'PC용 네이버 웹 페이지가 로드됐습니다. 실제 지도 화면인지 확인해 주세요.',
   HIDDEN_DESKTOP_PAGE_FINISHED_UNVERIFIED:'숨김 상태의 웹 페이지 로드를 확인했습니다. 실제 지도·저장 기능은 검증 전입니다.',
   HIDDEN_ATTACHED_UNVERIFIED:'MOA 화면으로 돌아왔습니다. 백그라운드 지도 조작은 아직 검증 전입니다.'
  };
  const code=String(j.state||'대기');
  statusLabel.textContent='상태: '+(phrases[code]||code)+(j.hidden?' · 숨김 연결':'')+(vals?'\n'+vals:'');
 }catch(e){statusLabel.textContent='웹 진단 상태를 읽지 못했어요.'}}
 function mount(){if($(ID))return true;
  const list=document.querySelector('section.page[data-page="settings"] > ul.rows')||document.querySelector('#moa-r117-photo-settings .moa-r117-inner-rows');if(!list)return false;
  read();const li=h('li');li.id=ID;const heading=h('button','r231-title');heading.type='button';
  const left=h('span');left.append(h('strong','','네이버지도 복귀 버튼'),h('small','','스타일 · 위치 · 크기 · 고정 · 웹 연결 실험'));
  const arrow=h('span','', '▾');heading.append(left,arrow);panel=h('section','r231-content');panel.hidden=true;
  heading.addEventListener('click',()=>{panel.hidden=!panel.hidden;arrow.textContent=panel.hidden?'▾':'▴';if(!panel.hidden){read();paint();readProbe()}});
  panel.append(h('div','r231-heading','기본 설정'));
  panel.append(row('네이버지도 위 복귀 버튼 표시',checkbox('enabled')));
  panel.append(row('복귀 버튼 스타일',select('style',opt.style)));
  panel.append(row("'MOA' 글자 표시",checkbox('text')));
  panel.append(row('X 닫기 심볼',select('xStyle',opt.xStyle)));
  panel.append(row('자동 숨김 시간',select('hideSec',opt.hideSec)));
  panel.append(h('div','r231-heading','크기 및 편집'));
  slider('sizePct','팝업 기본 크기 (현재 화면 방향)',70,180,5,'%');
  slider('opacity','팝업 불투명도',45,100,5,'%');
  panel.append(row('길게 눌러 자유 이동',checkbox('move')));
  panel.append(row('길게 눌러 8방향 크기 조절',checkbox('resize')));
  panel.append(row('가장자리 자동 정렬',checkbox('snap')));
  panel.append(h('p','r231-help','네이버지도에서 팝업을 길게 누르면 편집 모드입니다. 이동하거나 4개 변·4개 모서리로 크기를 조절하세요. X를 눌러 편집을 끝내면 세로·가로별 위치와 크기가 저장됩니다. 바로기록 팝업 설정과 독립입니다.'));
  panel.append(h('div','r231-heading','위치·크기 초기화'));
  const buttons=h('div','r231-buttons');for(const [title,p] of [['위치 초기화',{resetPosition:true}],['크기 초기화',{resetSize:true}],['모두 초기화',{resetPosition:true,resetSize:true}]]){
   const b=h('button','',title);b.type='button';b.addEventListener('click',()=>save(p));buttons.append(b);}panel.append(buttons);
  panel.append(h('div','r231-heading','현재 설정 미리보기'));
  const pa=h('div','r231-preview-area');preview=h('div','r231-preview');pa.append(preview);panel.append(pa);
  panel.append(h('div','r231-heading','네이버 PC 웹 연결 진단 · 읽기 전용'));
  panel.append(h('p','r231-help','기존 네이버지도 앱 로그인은 MOA 웹뷰와 자동 공유되지 않습니다. 이번 실험은 네이버의 앱 설치 안내를 피하기 위해 PC 웹 화면을 요청합니다. 웹에서 로그인이 허용되면 한 번 로그인하고 유지될 수 있지만, 서비스가 웹 접근을 제한할 경우 로그인이나 저장을 강제로 처리하지 않습니다. MOA는 비밀번호나 쿠키를 읽지 않습니다. "모아로"를 누르면 화면을 가리고 지도 요소 숫자만 진단합니다. 실제 즐겨찾기 저장이나 새 리스트 생성은 이 실험에 포함되지 않습니다.'));
  const wb=h('div','r231-probe-actions');for(const [name,code] of [['PC 웹 연결 진단','visible'],['숨김 진단','hidden'],['실험 종료','stop']]){
   const b=h('button','',name);b.type='button';b.addEventListener('click',()=>probe(code));wb.append(b);}
  panel.append(wb);statusLabel=h('div','r231-state','웹뷰 실험을 시작하지 않았습니다.');statusLabel.style.whiteSpace='pre-line';panel.append(statusLabel);
  li.append(heading,panel);
  const anchor=document.getElementById('moa-r215-quick-popup-settings');if(anchor&&anchor.parentElement===list)anchor.after(li);else list.prepend(li);
  paint();return true;
 }
 function begin(){mount();setInterval(()=>{if(!$(ID))mount();if(panel&&!panel.hidden){const now=Date.now();if(now-lastProbePoll>2500){lastProbePoll=now;readProbe()}}},1500);
  document.addEventListener('click',e=>{if(e.target.closest('[data-page="settings"],[data-tab="settings"],[data-view="settings"]'))setTimeout(mount,0)},true);
 }
 if(document.readyState==='loading')document.addEventListener('DOMContentLoaded',begin,{once:true});else begin();
})();