/* MOA R123, R121 photo info + live read-only GPS index correction, safe NAVER route.
 * Non-destructive DOM overlay: do NOT edit original native capture/diary/map/database.
 */
(()=>{
'use strict';
const PHOTO_RE=/\/fj-photo\/([0-9]{1,18})\.jpg(?:[?#]|$)/;
const $=(s,r=document)=>r.querySelector(s);
const clean=t=>String(t==null?'':t).trim();
const isValidGPS=(lat,lon)=>Number.isFinite(lat)&&Number.isFinite(lon)&&Math.abs(lat)<=90&&Math.abs(lon)<=180&&(lat!==0||lon!==0);
const inNaverArea=(lat,lon)=>lat>=31.43&&lat<=44.35&&lon>=122.37&&lon<=132;
const mapIndex=()=>{
  try {return window.FamilyJourneyExtension?.getData?.()||null;}catch(e){return null;}
};
const coords=id=>{
  const data=mapIndex();
  // This index contains only geopositioned images. An absent row is NOT proof
  // that the original MediaStore/EXIF has no GPS; do not claim otherwise.
  const rows=data&&Array.isArray(data.photos)?data.photos:[];
  const row=rows.find(p=>Array.isArray(p)&&String(p[0])===String(id));
  if(!row)return null;
  const lat=Number(row[1]),lon=Number(row[2]);
  return isValidGPS(lat,lon)?{lat,lon}:null;
};
const timeInfo=id=>{
  const state=window.FamilyJourneyDiary?.state;
  const item=state?.byId?.get?.(id);
  if(!item||!Number.isFinite(Number(item.t))||Number(item.t)<315532800000)return null;
  const date=new Date(Number(item.t));if(Number.isNaN(+date))return null;
  const txt=new Intl.DateTimeFormat('ko-KR',{year:'numeric',month:'2-digit',day:'2-digit',hour:'2-digit',minute:'2-digit',second:'2-digit',hour12:false}).format(date);
  return {text:(item.approx?'촬영시각(추정) · ':'촬영 · ')+txt};
};
function photoId(shell){
  const src=$('#fj-photo-gesture-stage img[alt="확대 및 좌우 넘김 가능한 원본 사진"]',shell)?.getAttribute('src')||'';
  const m=PHOTO_RE.exec(src);return m?m[1]:'';
}
const addressCache=new Map();
const fetchAddress=(id,point,cb)=>{
  const key=id+'|'+point.lat.toFixed(6)+'|'+point.lon.toFixed(6);
  if(addressCache.has(key)){cb(addressCache.get(key));return;}
  const owner=window.FamilyJourneyNaver;
  if(!owner||typeof owner.reverse!=='function'||!inNaverArea(point.lat,point.lon)){cb('');return;}
  try{owner.reverse(point,result=>{
    const addr=clean(result?.address);
    if(addr)addressCache.set(key,addr);
    cb(addr);
  });}catch(e){cb('');}
};
function openNaver(point,address){
  if(!point||!inNaverArea(point.lat,point.lon))return;
  // Important: R121's nmap:// URL is explicitly rejected by the installed
  // NativeHost external-service allowlist. Reuse the VERIFIED EXISTING
  // fj-naver-favorites.js HTTPS search + NativeHost.openUrl route instead.
  const query=clean(address)||point.lat.toFixed(6)+', '+point.lon.toFixed(6);
  const url='https://map.naver.com/p/search/'+encodeURIComponent(query);
  try{
    if(window.NativeHost?.post){window.NativeHost.post('openUrl',JSON.stringify({url}));return;}
    // Browser-only fallback; avoids arbitrary WebView scheme navigation.
    window.open(url,'_blank','noopener');
  }catch(e){alert('네이버 지도를 열지 못했습니다.');}
}
function attachGallery(shell){
  if(!shell||shell.dataset.moaR123Attached==='yes')return;
  shell.dataset.moaR123Attached='yes';
  const header=shell.firstElementChild;
  // R121 installed on the user device: preserve this same container and styling.
  const info=document.createElement('div');info.id='moa-r121-photo-info';
  const date=document.createElement('div');date.className='moa-r121-capture-time';
  const addr=document.createElement('div');addr.className='moa-r121-address';
  const addrText=document.createElement('span');addrText.className='moa-r121-address-text';
  const btn=document.createElement('button');btn.type='button';btn.textContent='네이버 지도에서 보기';btn.hidden=true;
  addr.append(addrText,btn);info.append(date,addr);header?.insertAdjacentElement('afterend',info);
  let selection='',pointKey='',requestSeq=0,lastAddr='';
  function render(){
    const id=photoId(shell);if(!id)return;
    const changed=id!==selection;
    if(changed){selection=id;pointKey='';lastAddr='';requestSeq++;}
    const infoTime=timeInfo(id);date.textContent=infoTime?infoTime.text:'촬영 날짜·시간 정보 확인 중';
    const point=coords(id);
    const currentKey=point?id+'|'+point.lat.toFixed(6)+'|'+point.lon.toFixed(6):'';
    if(!point){
      // No single-shot false negative. This may be a delayed or incomplete
      // travel index; native photo metadata is not exposed by this overlay.
      if(changed||pointKey!==''){
        addrText.textContent='지도 색인에서 이 사진의 GPS 미확인 · 원본 GPS 여부는 미검증';
        btn.hidden=true;btn.onclick=null;pointKey='';
      }
      return;
    }
    if(currentKey===pointKey&&!changed)return;
    pointKey=currentKey;const request=++requestSeq;
    addrText.textContent='GPS 주소 확인 중…';
    btn.hidden=!inNaverArea(point.lat,point.lon);
    btn.onclick=()=>openNaver(point,lastAddr);
    if(!inNaverArea(point.lat,point.lon)){
      addrText.textContent='GPS '+point.lat.toFixed(6)+', '+point.lon.toFixed(6)+' · 네이버 지도 국내 범위 밖';
      return;
    }
    fetchAddress(id,point,address=>{
      if(!shell.isConnected||request!==requestSeq)return;
      lastAddr=address;
      addrText.textContent=address||('상세 주소 미확인 · GPS '+point.lat.toFixed(6)+', '+point.lon.toFixed(6));
    });
  }
  const stage=$('#fj-photo-gesture-stage',shell);
  if(stage)new MutationObserver(render).observe(stage,{attributes:true,attributeFilter:['src'],childList:true,subtree:true});
  render();
  // Recheck selected photo's real index even if it arrives AFTER the viewer
  // opens. R121 only retried the DATE and silently fossilized missing GPS.
  let polls=0;
  const retry=()=>{
    if(!shell.isConnected)return;
    render();
    if(++polls<30)setTimeout(retry,1000);
  };
  setTimeout(retry,650);
}
function setupSettings(){
  const group=$('#moa-r117-photo-settings');
  if(!group||$('#moa-r121-capture-toggle'))return;
  const list=$('.moa-r117-inner-rows',group);if(!list)return;
  const item=document.createElement('li');item.id='moa-r121-capture-toggle';
  const button=document.createElement('button');button.type='button';button.className='moa-r121-capture-button';
  const hint=document.createElement('small');hint.textContent='삼성 카메라 촬영 직후 기록 감시 · 기존 네이티브 제어 사용';
  item.append(button,hint);list.insertBefore(item,list.firstChild);
  function refresh(){
    const native=window.MoaMomentNative;let active=null;
    try{if(native&&typeof native.enabled==='function')active=!!native.enabled();}catch(e){}
    button.disabled=active===null;
    button.textContent=active===null?'촬영 감시 · 연결 확인 중':active?'촬영 즉시 기록 ON · 끄기':'촬영 즉시 기록 OFF · 켜기';
    button.setAttribute('aria-pressed',active===null?'mixed':String(active));
  }
  button.onclick=()=>{
    const toggle=window.FamilyJourneyDiary?.momentToggle;
    if(typeof toggle!=='function')return;
    toggle();setTimeout(refresh,60);setTimeout(refresh,750);
  };
  refresh();let iter=0;
  const later=()=>{if(!item.isConnected)return;refresh();if(++iter<10)setTimeout(later,1200);};
  setTimeout(later,1200);
  group.addEventListener('click',refresh,{passive:true});
}
function reflowCalendar(){
  const root=$('#fj-diary-root');
  if(!root||root.hidden||!$('.fd23-modes',root))return;
  const grid=$('.fd23-calendar',root),actions=$('.fd23-actions',root),stat=$('#fd23-status',root);
  if(!grid||!actions)return;
  // Keep old "오늘", "다시 읽기", "백업" handlers in original DOM, but put
  // those controls and the large statistics strip BELOW the full month grid.
  if(actions.previousElementSibling!==grid)grid.insertAdjacentElement('afterend',actions);
  if(stat&&stat.previousElementSibling!==actions)actions.insertAdjacentElement('afterend',stat);
}
function scan(){
  setupSettings();reflowCalendar();
  const shell=$('#fj-naver-photo-full');if(shell)attachGallery(shell);
}
if(document.readyState==='loading')document.addEventListener('DOMContentLoaded',init,{once:true});else init();
function init(){
  scan();new MutationObserver(muts=>{
    if(muts.some(m=>m.addedNodes.length||m.removedNodes.length))scan();
  }).observe(document.body,{childList:true,subtree:true});
}
})();

/* MOA R215 camera quick-record floating overlay controls, paired to existing native CaptureBridge.
 * No recording, MediaStore, diary, voice or gallery state changed by this settings layer. */
(()=>{'use strict';
 const ID='moa-r215-quick-popup-settings', DEFAULTS={show:true,style:'A',xStyle:'basic',text:false,move:true,resize:true,snap:false,opacity:85,hideSec:5,sizePct:85};
 const byId=id=>document.getElementById(id);
 const bridge=()=>window.MoaMomentNative||null;
 let state={...DEFAULTS};
 const palettes={A:'미니멀 글래스',B:'텍스트형 (기록 표시)',C:'편집 아이콘형',D:'촬영 연계형',E:'아웃라인 포인트형',F:'라이트 보더형'};
 const xs={basic:'기본',bold:'볼드',round:'라운드',ring:'링',badge:'배지'};
 const styleEl=document.createElement('style');styleEl.textContent=`
 #${ID}{list-style:none!important;display:block!important;padding:0!important;margin:14px 0!important;background:#fff!important;color:#292735!important;border:1px solid #eadde5!important;border-radius:21px!important;overflow:hidden!important;box-shadow:0 2px 14px #31202f08!important;min-width:0!important;}
 #${ID} .moa-r215-title{display:flex;justify-content:space-between;align-items:center;gap:12px;width:100%;min-height:84px;padding:17px 19px;border:0;background:#fff!important;color:#252837!important;text-align:left;cursor:pointer;box-shadow:none!important;border-radius:0!important}
 #${ID} .moa-r215-title strong{font-size:17px;display:block;font-weight:750}#${ID} .moa-r215-title small{font-size:12px;opacity:.72;display:block;margin-top:5px}
 #${ID} .moa-r215-panel[hidden]{display:none!important}
 #${ID} .moa-r215-panel{padding:16px;display:grid;gap:17px;background:#fcfafc!important;border:0!important;border-top:1px solid #eee7ec!important;border-radius:0!important;color:#292735!important}
 #${ID} .moa-r215-row{display:flex;align-items:center;justify-content:space-between;gap:12px;min-height:48px;padding:3px 0;color:#292735!important}
 #${ID} .moa-r215-row label{flex:1;min-width:0;font-size:13px;font-weight:650}#${ID} .moa-r215-row select{box-sizing:border-box;max-width:59%;min-width:0;min-height:42px;background:#fff!important;color:#272735!important;color-scheme:light!important;appearance:auto!important;border-radius:12px!important;border:1px solid #d9cbd4!important;padding:8px 10px!important;font-size:13px!important}#${ID} .moa-r215-row select option{color:#252532!important;background:#fff!important}#${ID} .moa-r215-row input[type=number]{background:#fff!important;color:#252532!important;color-scheme:light!important;border:1px solid #d9cbd4!important}
 #${ID} .moa-r215-row input[type=checkbox]{width:20px;height:20px;flex:0 0 auto;accent-color:#ee304b}
 #${ID} .moa-r215-range{display:flex;gap:10px;align-items:center}
 #${ID} input[type=range]{width:100%;accent-color:#ee304b}
 #${ID} .moa-r215-range output{min-width:46px;text-align:right;font-variant-numeric:tabular-nums}
 #${ID} .moa-r215-actions{display:grid;grid-template-columns:repeat(3,minmax(0,1fr));gap:6px}
 #${ID} .moa-r215-actions button{min-height:42px;font-size:11px;border-radius:10px;padding:6px 3px;color:inherit;background:rgba(120,120,132,.12);border:1px solid rgba(140,140,145,.35)}
 #${ID} .moa-r215-preview-area{min-height:130px;display:flex;justify-content:center;align-items:center;overflow:hidden;border-radius:14px;background:radial-gradient(ellipse at top,#47505c,#191b22 75%);border:1px solid #6b6d78}
 #${ID} .moa-r215-preview{display:flex;align-items:center;justify-content:space-between;gap:5px;border:1px solid #a4afbb;border-radius:999px;padding:4px 7px;box-shadow:0 9px 22px #0008;max-width:95%}
 #${ID} .moa-r215-record{display:flex;align-items:center;justify-content:center;gap:7px;border-radius:999px;background:transparent!important;color:white;box-shadow:none!important;flex-shrink:1;min-width:0;font-weight:700}
 #${ID} .moa-r215-dot{width:28px;height:28px;flex:0 0 auto;border-radius:50%;background:#f13254;box-shadow:0 0 0 1px #ff759477;position:relative}#${ID} .moa-r215-dot::after{content:'';display:block;position:absolute;inset:36%;border-radius:50%;background:#fff}
 #${ID} .moa-r215-divider{width:1px;height:32px;background:#c4c9d6b5}
 #${ID} .moa-r215-x-hit{height:44px;width:44px;display:flex;align-items:center;justify-content:center;flex-shrink:0}
 #${ID} .moa-r215-x{display:flex;justify-content:center;align-items:center;border-radius:0!important;color:#f4f4f6!important;background:transparent!important;font-size:20px;font-weight:550;box-shadow:none!important}
 #${ID} .moa-r215-group-title{font-size:12px;font-weight:700;opacity:.73;margin:4px 0 0}
 #${ID} .moa-r215-help{font-size:11px;opacity:.72;line-height:1.5}
 `;
 document.head.appendChild(styleEl);
 function readNative(){try{const b=bridge();if(b&&typeof b.quickPopupPrefs==='function'){
  const got=JSON.parse(b.quickPopupPrefs()||'{}');state={...DEFAULTS,...got};
 }}catch(e){console.warn('MOA R215 native settings fetch',e)}return state;}
 function save(patch){try{const b=bridge();if(b&&typeof b.setQuickPopupPrefs==='function')b.setQuickPopupPrefs(JSON.stringify(patch));else console.warn('MOA R215 native popup bridge not found');}catch(e){console.warn('MOA R215 settings write',e)}state={...state,...patch};paint();}
 function el(tag,cls,text){const n=document.createElement(tag);if(cls)n.className=cls;if(text!=null)n.textContent=text;return n;}
 function fieldRow(label,control){let r=el('div','moa-r215-row');r.append(el('label','',label));r.append(control);return r;}
 function sel(key,options){let s=el('select');for(const [value,label] of Object.entries(options)){let o=el('option','',label);o.value=value;s.append(o)}s.value=String(state[key]);s.addEventListener('change',()=>save({[key]:key==='hideSec'?Number(s.value):s.value}));return s;}
 function check(key){let c=el('input');c.type='checkbox';c.checked=!!state[key];c.addEventListener('change',()=>save({[key]:c.checked}));return c;}
 let fields={};let preview;
 function paint(){
  for(const [key,field] of Object.entries(fields))if(field){
   if(field.type==='checkbox')field.checked=!!state[key];else if(field.tagName==='SELECT')field.value=String(state[key]);else field.value=String(state[key]);
  }
  if(byId('moa-r215-size-value'))byId('moa-r215-size-value').textContent=state.sizePct+'%';
  if(byId('moa-r215-opacity-value'))byId('moa-r215-opacity-value').textContent=state.opacity+'%';
  if(!preview)return;
  preview.replaceChildren();const f=Math.max(.7,Math.min(2,(+state.sizePct||100)/100));
  const w=state.hasCustomDimensions&&+state.widthDp>0?+state.widthDp:Math.max(120,(state.text||state.style==='B'?197:176)*f);
  const h=state.hasCustomDimensions&&+state.heightDp>0?+state.heightDp:Math.max(44,51*f);
  preview.style.width=Math.round(w)+'px';preview.style.height=Math.round(h)+'px';preview.style.minHeight='44px';preview.style.background='#262830';preview.style.opacity=String(Math.max(40,Math.min(100,+state.opacity||85))/100);
  const rec=el('div','moa-r215-record');rec.style.width=Math.max(54,Math.round(w)-52)+'px';rec.style.height='100%';
  const symbol=el('span','moa-r215-dot');if(['C','F'].includes(state.style))symbol.textContent='✎';else if(state.style==='D')symbol.textContent='▣';else if(state.style==='E')symbol.textContent='◎';
  if(!['A','B'].includes(state.style)){symbol.style.fontSize=Math.min(17,15*f)+'px';symbol.style.color='#fff';symbol.style.display='grid';symbol.style.placeItems='center'}
  symbol.style.transform='scale('+Math.max(.75,Math.min(1.25,h/51))+')';
  rec.append(symbol);if(state.text||state.style==='B'){const caption=el('span','', '기록');caption.style.fontSize=13*f+'px';rec.append(caption)}
  preview.append(rec,el('span','moa-r215-divider'));
  const hit=el('span','moa-r215-x-hit');const x=el('span','moa-r215-x','×');x.style.width='18px';x.style.height='18px';
  if(state.xStyle==='bold')x.style.fontWeight=900;if(state.xStyle==='ring')x.style.border='2px solid white';if(state.xStyle==='badge')x.style.background='#7b839ba0';
  hit.append(x);preview.append(hit);
 }
 function rowRange(panel,key,label,min,max,step){
  panel.append(el('div','moa-r215-group-title',label));let r=el('div','moa-r215-range');let s=el('input');s.type='range';s.min=min;s.max=max;s.step=step;s.value=state[key];
  s.addEventListener('input',()=>{state[key]=+s.value;paint()});s.addEventListener('change',()=>save({[key]:+s.value}));
  let out=el('output');out.id=key==='sizePct'?'moa-r215-size-value':'moa-r215-opacity-value';r.append(s,out);fields[key]=s;panel.append(r);
 }
 function create(){
  if(byId(ID))return true;
  // Mount as a discoverable top-level Settings card, not inside the collapsed
  // photo/data accordion. That accordion may be created long after app startup.
  const root=document.querySelector('section.page[data-page="settings"]');
  const list=root?.querySelector(':scope > ul.rows') || document.querySelector('#moa-r117-photo-settings .moa-r117-inner-rows');
  if(!list)return false;
  readNative();const li=el('li');li.id=ID;li.className='moa-r117-group-item';
  const heading=el('button','moa-r215-title');heading.type='button';heading.append(el('span'));
  heading.firstChild.append(el('strong','','바로기록 팝업'),el('small','','아이콘 · 위치 · 크기 · 자동 숨김 설정'));
  heading.append(el('span','', '▾'));
  const panel=el('section','moa-r215-panel');panel.hidden=true;
  heading.addEventListener('click',()=>{panel.hidden=!panel.hidden;heading.lastChild.textContent=panel.hidden?'▾':'▴';if(!panel.hidden){readNative();paint()}});
  function field(key,label,control){fields[key]=control;panel.append(fieldRow(label,control))}
  panel.append(el('div','moa-r215-group-title','기본 설정'));
  field('show','사진 촬영 후 팝업 표시',check('show'));
  field('style','기록 버튼 스타일',sel('style',palettes));
  field('xStyle','X 닫기 심볼',sel('xStyle',xs));
  field('text',"'기록' 텍스트 표시",check('text'));
  field('hideSec','자동 숨김 시간',sel('hideSec',{'0':'자동 숨김 없음','1':'1초','2':'2초','3':'3초','5':'5초','7':'7초','10':'10초','15':'15초','20':'20초','30':'30초','60':'60초'}));
  const seconds=el('input');seconds.type='number';seconds.min=1;seconds.max=60;seconds.step=1;
  seconds.style.cssText='width:74px;min-height:42px;text-align:center;border-radius:12px;border:1px solid #d9cbd4;padding:6px;background:#fff;color:#272735;color-scheme:light';
  seconds.value=state.hideSec||5;
  seconds.setAttribute('aria-label','자동 숨김 시간을 초 단위로 직접 입력');
  seconds.addEventListener('change',()=>{const n=Math.max(1,Math.min(60,Math.round(+seconds.value||5)));seconds.value=n;save({hideSec:n});});
  panel.append(fieldRow('직접 입력 (1~60초)',seconds));
  panel.append(el('div','moa-r215-group-title','크기 및 편집'));
  rowRange(panel,'sizePct','팝업 기본 크기 (현재 화면 방향)',70,200,5);
  panel.append(el('div','moa-r215-help','길게 눌러 편집 모드로 전환한 뒤 상·하·좌·우 변과 4개 모서리를 드래그하면 가로·세로 크기를 독립 조절합니다. X를 누르면 편집이 끝납니다.'));
  rowRange(panel,'opacity','팝업 불투명도',40,100,5);
  field('move','길게 눌러 자유 이동',check('move'));
  field('resize','길게 눌러 크기 조절',check('resize'));
  field('snap','가장자리 자동 정렬',check('snap'));
  panel.append(el('div','moa-r215-group-title','위치·크기 초기화'));
  const actions=el('div','moa-r215-actions');
  [['위치 초기화',{resetPosition:true}],['크기 초기화',{resetSize:true}],['모두 초기화',{resetPosition:true,resetSize:true}]].forEach(([label,p])=>{
   let b=el('button','',label);b.type='button';b.addEventListener('click',()=>{save(p);readNative();paint()});actions.append(b);
  });panel.append(actions);
  panel.append(el('div','moa-r215-group-title','현재 설정 미리보기'));
  const area=el('div','moa-r215-preview-area');preview=el('div','moa-r215-preview');area.append(preview);panel.append(area);
  panel.append(el('p','moa-r215-help','실제 팝업: 짧게 탭하면 기록 또는 닫기 · 길게 누르면 편집 모드 · 편집 중 패널 이동과 오른쪽 아래 핸들 크기 조절 · X를 눌러 편집 완료. 위치와 크기는 세로/가로로 따로 저장됩니다.'));
  li.append(heading,panel);list.insertBefore(li,list.firstChild);paint();return true;
 }
 function begin(){
  create();
  // R215 bug: the old 17-second polling window expired before many users opened Settings.
  // Keep a low-frequency, inexpensive mount check until the app is closed; the card
  // remains visible for all future Settings opens, even if the DOM is rebuilt.
  setInterval(()=>{if(!byId(ID))create();},1250);
  window.addEventListener('pageshow',()=>{if(!byId(ID))create()});
  document.addEventListener('click',e=>{if(e.target.closest('[data-page="settings"], [data-tab="settings"], [data-view="settings"]')){
    setTimeout(()=>{if(!byId(ID))create()},0);
  }},true);
}
 if(document.readyState==='loading')document.addEventListener('DOMContentLoaded',begin,{once:true});else begin();
})();
