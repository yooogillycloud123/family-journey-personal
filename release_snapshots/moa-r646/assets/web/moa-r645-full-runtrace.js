/* MOA R645 permanent full-run trace, additive to user-confirmed R641 engine.
 * Runs BEFORE host-bootstrap.js; no native-gallery ownership, router or
 * diary/QuickRecord hooks are changed by this file. No user text, media
 * IDs, URLs, coordinates, cookies or authentication credentials are recorded.
 */
(function(){'use strict';
  if(window.MoaFullRunTraceR645)return;
  const BUILD='R646_R641_NATIVE_CORE_QUICK_RECORD_REARM', DB_NAME='moa_full_runtrace_r645', STORE='events';
  const BACKUP_KEY='moa.runtrace.r645.rolling', ID_KEY='moa.runtrace.r645.boot';
  const boot=Date.now().toString(36)+'-'+Math.random().toString(36).slice(2,8);
  const start=Date.now();let serial=0, database=null, unavailable=false;
  let queue=[],lastState='',lastNative='',lastPage='',lastStage='',lastScroll=0,lastPointer=0;
  let backup=[],pendingBackupTimer=0;const observed=new Set();let loading=false;
  const nativeSeen=new Set(),qrSeen=new Set();
  // Deduplicate Gallery heartbeat observations without losing any lifecycle
  // transition. Prior R645 wrote ~1000 repeats; those IDB rows stay intact.
  const highFreq=new Map();
  function stageKeepalive(type,d){
    if(type!=='GALLERY_NATIVE_STAGE_SYNC'&&type!=='GALLERY_NATIVE_STAGE')return false;
    const ev=String(d?.event||'');
    if(ev!=='NATIVE_GALLERY_OPEN_OBSERVED'&&ev!=='NATIVE_8_ACTION_DECK_READY')return false;
    const key=type+'|'+ev,now=Date.now(),old=highFreq.get(key);
    if(!old){highFreq.set(key,{at:now,suppressed:0,since:now});return false;}
    if(now-old.at>=8500){
      if(old.suppressed)add('REPEATED_GALLERY_EVENT_SUMMARY',{
        event:ev,count:old.suppressed,durationMs:now-old.since});
      highFreq.set(key,{at:now,suppressed:0,since:now});return false;
    }
    old.suppressed++;return true;
  }

  const safeName=(x)=>String(x==null?'':x).replace(/https?:\/\/\S+/gi,'[url]')
    .replace(/content:\/\/\S+/gi,'[media-uri]')
    .replace(/\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}\b/g,'[email]')
    .replace(/\b\d{4}-\d\d-\d\d\b/g,'[day]')
    .replace(/\b\d{2,3}[- ]?\d{3,4}[- ]?\d{4}\b/g,'[phone]')
    .replace(/\b(?:Bearer|token|cookie|password|authorization|session)[=:]?[^ ,;\n]*/gi,'[secret]')
    .slice(0,150);
  const permitted=(o)=>{let out={};if(!o||typeof o!=='object')return out;
    const keys=['event','type','code','reason','last','page','active','bridge','arm','pending','opened',
      'mounted','visibleDay','stageAttached','rootHidden','nativeOpen','nativeMethod',
      'hasError','count','total','delay','errorName','target','gesture','direction',
      'durationMs','source','isConnected','method','width','button','status','index',
      'step','previous','current','kind','timeMs','resource','state','result','signal',
      'sameDay','inlineArm','exiting','elapsedMs','stage','suppressed'];
    keys.forEach(k=>{if(!Object.prototype.hasOwnProperty.call(o,k))return;
      const v=o[k];if(v===null||typeof v==='boolean'||typeof v==='number'&&Number.isFinite(v))out[k]=v;
      else if(typeof v==='string')out[k]=safeName(v);});return out;};
  try {const old=JSON.parse(localStorage.getItem(BACKUP_KEY)||'[]');if(Array.isArray(old))backup=old.slice(-700);}catch(_){}
  function backupNow(){pendingBackupTimer=0;try{localStorage.setItem(BACKUP_KEY,JSON.stringify(backup.slice(-700)));localStorage.setItem(ID_KEY,boot);}catch(_){}}
  function add(type,detail,critical){
    try {
      if(stageKeepalive(type,detail))return null;
      const row={ts:new Date().toISOString(),boot,seq:++serial,elapsedMs:Date.now()-start,
        type:safeName(type),detail:permitted(detail)};
      backup.push(row);if(backup.length>700)backup.splice(0,backup.length-700);
      queue.push(row);if(database)drain();
      if(critical){if(pendingBackupTimer){clearTimeout(pendingBackupTimer);pendingBackupTimer=0;}backupNow();}
      else if(!pendingBackupTimer)pendingBackupTimer=setTimeout(backupNow,400);
      return row;
    }catch(_){return null;}
  }
  // IndexedDB is independent of diary stores. No automatic log clearing or
  // silent rolling deletion. LocalStorage holds an immediately recoverable tail.
  function drain(){if(!database||!queue.length||loading)return;loading=true;
    const batch=queue.splice(0,Math.min(queue.length,100));
    try{const tx=database.transaction(STORE,'readwrite'),s=tx.objectStore(STORE);
      batch.forEach(row=>s.add(row));
      tx.oncomplete=()=>{loading=false;if(queue.length)drain();};
      tx.onerror=()=>{loading=false;unavailable=true;database=null;};
      tx.onabort=()=>{loading=false;unavailable=true;database=null;};
    }catch(_){loading=false;unavailable=true;database=null;}
  }
  try {
    const req=indexedDB.open(DB_NAME,1);
    req.onupgradeneeded=()=>{const d=req.result;if(!d.objectStoreNames.contains(STORE))
      d.createObjectStore(STORE,{keyPath:'id',autoIncrement:true});};
    req.onsuccess=()=>{database=req.result;drain();add('TRACE_STORAGE_READY',{status:'indexeddb'});};
    req.onerror=()=>{unavailable=true;add('TRACE_STORAGE_UNAVAILABLE',{errorName:'IndexedDB'},true);};
    req.onblocked=()=>{unavailable=true;add('TRACE_STORAGE_BLOCKED',{errorName:'IndexedDB'},true);};
  }catch(_){unavailable=true;}
  let previous='';try{previous=localStorage.getItem(ID_KEY)||'';}catch(_){}
  if(previous && backup.length && !backup.slice(-12).some(x=>x.boot===previous&&x.type==='APP_EXIT'))
    add('PREVIOUS_SESSION_END_NOT_OBSERVED',{reason:'process-killed-or-webview-reloaded'},true);
  add('APP_JS_ENTRY',{source:'document-head',state:'start'},true);
  function page(){
    try {const p=document.querySelector('section.page[data-page]:not([hidden])');
      const tab=document.querySelector('#moa-r469-root');
      return p?'tab:'+safeName(p.getAttribute('data-page')):tab&&!tab.hidden?'diary-root':'none';
    }catch(_){return'unknown';}
  }
  function elementKey(el){
    try {if(!(el instanceof Element))return'non-element';
      const target=el.closest('button,[role="button"],a,select,textarea,input,[data-tab],[data-action]')||el;
      let ident=target.id ? '#'+target.id : target.getAttribute('data-tab')?'tab:'+target.getAttribute('data-tab'):
        target.getAttribute('data-action')?'action:'+target.getAttribute('data-action'):
        target.getAttribute('role')?'role:'+target.getAttribute('role'):target.tagName.toLowerCase();
      if(target.type==='password'||target.closest('[autocomplete="current-password"],[autocomplete="one-time-code"]'))
        return '[private-input]';
      return safeName(ident);
    }catch(_){return'unknown';}
  }
  function poll(){
    try{const p=page();if(p!==lastPage){add('PAGE_STATE',{previous:lastPage||'BOOT',current:p});lastPage=p;}
      const r=document.querySelector('#moa-r469-root'),stage=document.querySelector('#moa-r469-root .moa-r469-stage');
      const snapshot={page:p,rootHidden:r?!!r.hidden:null,stageAttached:!!stage?.isConnected,
        mounted:!!document.querySelector('.moa-r507-native-mounted'),
        nativeMethod:typeof window.MoaLocalAudio?.openNativeGallery==='function',
        bridge:!!window.__moaR507BridgeReady};
      const sig=JSON.stringify(snapshot);if(sig!==lastState){add('GALLERY_DOM_STATE',snapshot);lastState=sig;}
      let diag=null;
      try{if(typeof window.__moaR602GalleryDiagnostic==='function')
        diag=JSON.parse(window.__moaR602GalleryDiagnostic()||'{}');}catch(_){add('GALLERY_DIAG_PARSE_ERROR',{hasError:true});}
      if(diag){
        if(Array.isArray(diag.events))diag.events.forEach(ev=>{
          const k=String(ev.at)+'|'+String(ev.event);if(nativeSeen.has(k))return;
          nativeSeen.add(k);if(nativeSeen.size>8000){nativeSeen.clear();nativeSeen.add(k);}
          add('GALLERY_NATIVE_STAGE',{event:ev.event,reason:ev.reason,count:ev.count,code:ev.code});
        });
        if(Array.isArray(diag.r641Timeline))diag.r641Timeline.forEach(ev=>{
          const k=String(ev.at)+'|'+String(ev.type);if(qrSeen.has(k))return;
          qrSeen.add(k);if(qrSeen.size>8000){qrSeen.clear();qrSeen.add(k);}
          add('R641_LIFECYCLE',{type:ev.type,active:ev.active,page:ev.page,
            mounted:ev.mounted,opened:ev.opened,arm:ev.arm,pending:ev.pending,
            nativeOpen:ev.nativeOpen,bridge:ev.bridge,delay:ev.delay});
        });
        const cur={last:diag.last,arm:!!diag.arm,pending:!!diag.pending,
          opened:!!diag.opened,mounted:!!diag.mounted,bridge:!!diag.bridge,
          visibleDay:!!diag.visibleDay,count:diag.count};
        const n=JSON.stringify(cur);if(lastNative!==n){add('GALLERY_SNAPSHOT',cur);lastNative=n;}
      }
    }catch(_){add('TRACE_POLL_FAILED',{hasError:true});}
  }
  function trackEvent(type,fn){window.addEventListener(type,fn,{capture:true});}
  trackEvent('error',ev=>{if(ev instanceof ErrorEvent){add('JS_ERROR',
    {errorName:safeName(ev.error?.name||'Error'),resource:safeName(ev.filename||'script'),reason:safeName(ev.message)},true);
    }else add('RESOURCE_LOAD_ERROR',{resource:elementKey(ev.target)},true);});
  window.addEventListener('unhandledrejection',ev=>add('UNHANDLED_PROMISE',
    {errorName:ev.reason?.name||'PromiseRejection',reason:String(ev.reason?.message||'promise rejected')},true));
  trackEvent('pagehide',()=>{add('APP_EXIT',{reason:'pagehide'},true);drain();});
  trackEvent('beforeunload',()=>{add('APP_EXIT',{reason:'beforeunload'},true);drain();});
  trackEvent('pageshow',()=>add('APP_PAGE_SHOW',{state:document.visibilityState},true));
  trackEvent('focus',()=>add('APP_FOCUS',{state:document.visibilityState}));
  trackEvent('blur',()=>add('APP_BLUR',{state:document.visibilityState}));
  try{document.addEventListener('visibilitychange',()=>add('APP_VISIBILITY',
    {state:document.visibilityState},true));}catch(_){}
  document.addEventListener('click',ev=>add('USER_CLICK',{target:elementKey(ev.target),page:page()}),true);
  document.addEventListener('change',ev=>add('USER_CHANGE',{target:elementKey(ev.target),page:page()}),true);
  document.addEventListener('submit',ev=>add('USER_SUBMIT',{target:elementKey(ev.target),page:page()}),true);
  document.addEventListener('pointerdown',ev=>{const t=Date.now();if(t-lastPointer<120)return;
    lastPointer=t;add('USER_POINTER',{target:elementKey(ev.target),page:page(),gesture:ev.pointerType});},true);
  document.addEventListener('scroll',ev=>{const t=Date.now();if(t-lastScroll<900)return;
    lastScroll=t;add('USER_SCROLL',{target:elementKey(ev.target),page:page()});},true);
  window.addEventListener('moa:native-diary-committed',()=>{
    add('QUICK_RECORD_NATIVE_COMMIT',{result:'event-received'},true);setTimeout(poll,0);},true);
  // Capture non-sensitive logging from existing native Gallery path without
  // replacing its Java bridge, methods, callbacks, or owner.
  function recordGalleryStage(stage,extra){add('GALLERY_NATIVE_STAGE_SYNC',
    {event:stage,reason:extra?.reason,code:extra?.code,count:extra?.count,
     elapsedMs:extra?.elapsedMs,arm:extra?.arm,inlineArm:extra?.inlineArm,
     stageAttached:extra?.stageAttached,page:extra?.page,
     mounted:extra?.mounted,pending:extra?.pending,nativeOpen:extra?.nativeOpen},
     stage!=='NATIVE_GALLERY_OPEN_OBSERVED'&&stage!=='NATIVE_8_ACTION_DECK_READY');}
  const style=`#moa-r645-trace-settings{padding:13px;border:1px solid #d7d9de;border-radius:13px;background:#f8f9fb;margin:9px 0;color:#222}#moa-r645-trace-settings h3{font-size:16px;margin:0 0 5px}#moa-r645-trace-settings p{font-size:12px;color:#555;line-height:1.5;margin:5px 0 10px}#moa-r645-trace-settings .actions{display:flex;gap:7px;flex-wrap:wrap}#moa-r645-trace-settings button{border:0;border-radius:9px;padding:11px 13px;background:#202736;color:#fff;font-size:13px;font-weight:700}#moa-r645-trace-settings textarea{width:100%;height:190px;box-sizing:border-box;border:1px solid #cbd0d8;border-radius:9px;margin-top:9px;background:white;color:#171717;font:11px/1.35 monospace;white-space:pre;resize:vertical}#moa-r645-trace-settings .state{margin:9px 0;font-size:12px;word-break:break-all}`;
  function reportHeader(total){return ['MOA COMPLETE RUN TRACE','build='+BUILD,
    'export='+new Date().toISOString(),'records='+total,
    'storage='+(!unavailable&&database?'IndexedDB+LocalStorage':'LocalStorage tail only'),
    'note=No user text/media/GPS/URLs/auth fields collected.',
    'note=Android process termination without callbacks is marked at next launch.',
    '---- EVENTS (oldest to newest) ----'].join('\n');}
  async function report(){
    // Ensure queued writes finish before opening an IndexedDB readonly cursor.
    if(database){drain();for(let i=0;i<18&&(loading||queue.length);i++)await new Promise(r=>setTimeout(r,80));}
    let rows=[];
    if(database){
      try{rows=await new Promise((resolve,reject)=>{
        const result=[],tx=database.transaction(STORE,'readonly');
        const cur=tx.objectStore(STORE).openCursor();
        cur.onsuccess=()=>{const c=cur.result;if(!c){resolve(result);return;}
          const item={...c.value};delete item.id;result.push(item);c.continue();};
        cur.onerror=()=>reject(cur.error);tx.onerror=()=>reject(tx.error);
      });}catch(_){rows=[];}
    }
    if(!rows.length)rows=backup.slice();
    // Merge any pending tail without duplicates.
    const seen=new Set(rows.map(r=>r.boot+'|'+r.seq));
    backup.forEach(r=>{const k=r.boot+'|'+r.seq;if(!seen.has(k)){rows.push(r);seen.add(k);}});
    rows.sort((a,b)=>(a.ts||'').localeCompare(b.ts||'')||(a.seq||0)-(b.seq||0));
    return reportHeader(rows.length)+'\n'+rows.map(x=>JSON.stringify(x)).join('\n');
  }
  async function copyText(text,area){
    try{if(navigator.clipboard?.writeText){await navigator.clipboard.writeText(text);return true;}}catch(_){}
    try{area.focus();area.select();area.setSelectionRange(0,area.value.length);
      if(document.execCommand('copy'))return true;}catch(_){}return false;
  }
  function mount(){
    const settings=document.querySelector('section.page[data-page="settings"] > ul.rows');
    if(!settings||document.getElementById('moa-r645-trace-settings'))return;
    const li=document.createElement('li');li.id='moa-r645-trace-settings';
    const h=document.createElement('h3');h.textContent='전체 실행 경로 진단 · R646';
    const p=document.createElement('p');p.textContent='앱 실행부터 화면 이동, 터치, 순간기록, 갤러리 상태·오류·종료까지 누적 기록합니다. 앱을 닫았다 다시 열어도 이전 기록을 유지합니다. 입력 내용·사진·위치·로그인 정보는 수집하지 않습니다.';
    const bar=document.createElement('div');bar.className='actions';
    const show=document.createElement('button');show.type='button';show.textContent='전체 기록 보기';
    const copy=document.createElement('button');copy.type='button';copy.textContent='전체 진단 복사';
    const status=document.createElement('p');status.className='state';status.textContent='자동 기록 활성 · 기기 내부에 저장 중';
    const area=document.createElement('textarea');area.readOnly=true;area.placeholder='[전체 기록 보기]로 실행 기록을 표시할 수 있습니다.';area.style.display='none';
    let active=false;
    async function render(autoCopy){if(active)return;active=true;try{
      add('DIAGNOSTIC_REQUEST',{method:autoCopy?'copy':'view'},true);
      status.textContent='누적 기록을 불러오는 중…';const value=await report();
      area.style.display='block';area.value=value;
      status.textContent='진단 기록 '+value.split('\n').length+'줄 준비 완료 · 앱 재실행 후에도 유지';
      if(autoCopy){const ok=await copyText(value,area);status.textContent=ok?
        '전체 실행 경로를 복사했습니다. 채팅에 붙여넣어 보내세요.':
        '자동 복사가 제한됐습니다. 아래 기록을 길게 누르고 전체 선택 → 복사하세요.';
      }
    }catch(_){status.textContent='진단 읽기 실패 · 자동 기록은 계속됩니다.';}finally{active=false;}}
    show.addEventListener('click',()=>render(false));copy.addEventListener('click',()=>render(true));
    bar.append(show,copy);li.append(h,p,bar,status,area);settings.prepend(li);
  }
  function initialize(){
    const css=document.createElement('style');css.id='moa-r645-trace-css';css.textContent=style;document.head.append(css);
    mount();add('DOM_READY',{status:document.readyState},true);
    const observer=new MutationObserver(()=>{if(!document.getElementById('moa-r645-trace-settings'))mount();});
    const settings=document.querySelector('section.page[data-page="settings"]');
    if(settings)observer.observe(settings,{childList:true,subtree:false});
    poll();setInterval(poll,450);
    setInterval(()=>{add('APP_HEARTBEAT',{page:page()},true);},15000);
  }
  window.MoaFullRunTraceR645={emit:add,stage:recordGalleryStage,exportText:report,
    build:BUILD,bootId:boot};
  window.MoaFullRunTraceR646=window.MoaFullRunTraceR645;
  if(document.readyState==='loading')document.addEventListener('DOMContentLoaded',initialize,{once:true});
  else initialize();
})();
