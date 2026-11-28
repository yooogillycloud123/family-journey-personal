
const LIVE787='moa.study.status.v787',SAVE787='moa.study.lastsave.v787';
let observed787=null,reading787=false,monitorError787='',nativeAt787=0,pulse787=0,stage787='작업 초기화';
function localRead787(k){try{return JSON.parse(localStorage.getItem(k)||'null')}catch{return null}}
function worker787(stage){if(!BG785)return;const now=Date.now();if(stage!==undefined)stage787=String(stage).slice(0,160);else if(now-pulse787<2500)return;pulse787=now;const j=state.job;try{localStorage.setItem(LIVE787,JSON.stringify({at:now,stage:stage787,op:j?.op||'',start:j?.start||0,core:!!j?.coreSaved,chars:j?.op==='generate'?String(j.text||'').length:0}))}catch{}}
function saved787(lesson){try{localStorage.setItem(SAVE787,JSON.stringify({at:Date.now(),complete:complete779(lesson),source:BG785?'백그라운드':'앱 내'}))}catch{}}
function clock787(t){return Number.isFinite(t)&&t>0?new Date(t).toLocaleString('ko-KR',{month:'numeric',day:'numeric',hour:'2-digit',minute:'2-digit',second:'2-digit',hour12:false}):'기록 없음'}
function elapsed787(t){const n=Math.max(0,Math.floor((Date.now()-t)/1000));return Math.floor(n/60)+'분 '+n%60+'초'}
function phase787(){const now=Date.now(),w=localRead787(LIVE787),j=state.job,n=now-nativeAt787<35000?bgNative785:null;
 if(j?.op==='generate')return (j.auto?'앱 내 자동 생성':'앱 내 수동 생성')+' · '+lastStatus777+' · '+elapsed787(j.start);
 if(!prefs.auto)return '자동 생성 꺼짐';
 if(!monitorError787&&observed787&&observed787.done===observed787.total&&(!w||now-w.at>15000||!w.op))return observed787.total?'등록 학습 모두 완료':'직접 등록된 학습 대상 없음';
 if(!prefs.background785)return '앱 내 자동 생성 대기';
 if(n?.error)return '예약 오류 · '+n.error;
 if(n?.running&&w&&now-w.at<15000)return (w.op==='generate'?'백그라운드 생성 진행 · ':'백그라운드 · ')+w.stage+(w.op==='generate'?' · '+elapsed787(w.start)+(w.chars?' · '+w.chars+'자 수신':''):'');
 if(n?.running)return 'Android 작업 시작 · AI 실행 신호 확인 중';
 if(n?.scheduled)return 'Android 예약 대기 · 아직 AI 실행 확인 안 됨';
 if(n)return '예약 없음 · 작업 재확인 필요';
 if(w&&now-w.at<15000)return '최근 작업 신호 · '+w.stage+' (OS 상태 조회 중)';
 return 'Android 예약 상태 확인 중';
}
function paint787(){if(BG785)return;const t=observed787,w=localRead787(LIVE787),last=localRead787(SAVE787),phase=phase787()+(monitorError787?' · '+monitorError787:'');
 const msg=phase+(t?' · 완료 '+t.done+'/'+t.total+' · 미생성 '+t.missing+' · 일부 '+t.partial+' · '+clock787(t.at)+' 조회':' · 등록/저장 목록 확인 전');
 if(state.view?.autoInfo)state.view.autoInfo.textContent=msg;const info=document.getElementById('moa-r783-auto-info');if(info)info.textContent=msg;
 const p=document.getElementById('moa-r787-status');if(!p)return;
 const put=(k,x)=>{const a=p.querySelector('[data-stat="'+k+'"]');if(a&&a.textContent!==String(x))a.textContent=String(x)};
 put('phase',phase);put('done',t?t.done+' / '+t.total:'—');put('missing',t?t.missing:'—');put('partial',t?t.partial:'—');put('retry',t?t.delayed:'—');put('held',t?t.blocked:'—');put('checked',t?'저장소 조회 '+clock787(t.at):'저장소 조회 대기');
 put('saved',last?'최근 실제 저장 '+clock787(last.at)+' · '+last.source+' · '+(last.complete?'전체 완료':'핵심/일부 저장'):'이 버전 이후 실제 저장 기록 없음');put('pulse',w?'최근 백그라운드 신호 '+clock787(w.at)+' · '+w.stage:'백그라운드 실행 신호 없음');
 const bar=p.querySelector('progress');if(bar){bar.max=Math.max(1,t?.total||1);bar.value=t?.done||0}
}
async function refresh787(force=false){if(BG785||reading787)return;const s=document.querySelector('section.page[data-page="settings"]'),v=state.view;
 if(!force&&(document.hidden||(!s||s.hidden||s.getAttribute('aria-hidden')==='true')&&!(v?.panel.isConnected&&v.details.open)))return;
 if(prefs.background785&&prefs.auto)configure785();
 reading787=true;try{
  if(typeof window.MoaStudyCurated783!=='function'||!storageReady771||!studyDB771)throw Error('학습 저장소 준비 대기');
  const bound=p=>new Promise((yes,no)=>{const t=setTimeout(()=>no(Error('조회 시간 초과')),8000);Promise.resolve(p).then(x=>{clearTimeout(t);yes(x)},e=>{clearTimeout(t);no(e)})});
  const reg=normalize783(await bound(window.MoaStudyCurated783())),stored=await bound(new Promise((yes,no)=>{const tx=studyDB771.transaction('cards','readonly'),r=tx.objectStore('cards').openCursor(),a={};r.onsuccess=()=>{const c=r.result;if(c){if(typeof c.key==='string'&&validLesson(c.value))a[c.key]=c.value;c.continue()}};tx.oncomplete=()=>yes(a);tx.onerror=()=>no(tx.error);tx.onabort=()=>no(tx.error||Error('읽기 중단'))}));
  const legacy=localRead787(K)||{},q=localRead787(QUEUE771)||{},t={total:reg.size,done:0,missing:0,partial:0,blocked:0,delayed:0,at:Date.now()};
  for(const k of reg.keys()){const x=stored[k]||legacy[k];if(complete779(x))t.done++;else{if(validLesson(x))t.partial++;else t.missing++;if(['blocked','paused','failed'].includes(q[k]?.state))t.blocked++;else if(Number(q[k]?.nextAt)>Date.now())t.delayed++}}
  observed787=t;monitorError787='';
 }catch(e){monitorError787='저장소 확인 오류 · '+String(e?.message||e).slice(0,100)}finally{reading787=false;paint787()}
}
function panel787(){const p=el('section');p.id='moa-r787-status';p.style.cssText='display:grid;gap:9px;padding:12px;border:1px solid var(--m787-border,#d4d8dd);border-radius:13px;background:var(--m787-card,#fff);margin:8px 0 10px;min-width:0';
 const stat=(tag,k,t)=>{const n=el(tag,t);n.dataset.stat=k;return n};const phase=stat('div','phase','실제 실행 상태 확인 중');phase.style.cssText='font-size:13px;font-weight:650;line-height:1.5;overflow-wrap:anywhere';
 const grid=el('div');grid.style.cssText='display:grid;grid-template-columns:repeat(3,minmax(0,1fr));gap:8px';
 for(const [k,label] of [['done','완료 / 등록'],['missing','미생성'],['partial','일부 누락'],['retry','재시도 대기'],['held','보류']]){const x=el('div');x.style.cssText='min-width:0;padding:8px;background:var(--m787-inner,#f6f7f9);border-radius:9px;text-align:center';const a=el('small',label),b=stat('strong',k,'—');a.style.cssText='display:block;font-size:11px;opacity:.75';b.style.cssText='display:block;font-size:17px;font-variant-numeric:tabular-nums';x.append(a,b);grid.append(x)}
 const bar=el('progress');bar.max=1;bar.value=0;bar.style.cssText='width:100%;height:10px;accent-color:#507e68';bar.setAttribute('aria-label','학습카드 전체 완료율');
 const d=el('div');d.style.cssText='display:grid;gap:4px;font-size:11px;line-height:1.5;opacity:.85';d.append(stat('span','checked',''),stat('span','saved',''),stat('span','pulse',''));p.append(el('strong','학습 생성 현황'),phase,grid,bar,d,button('실제 학습 현황 다시 확인',()=>{void refresh787(true)}));return p;
}
