/* MOA R231 — one-tap NAVER return popup Settings + read-only WebView feasibility UI.
 * Additive module. Never edits photo, diary, location or existing Quick Record settings.
 * No third-party account credentials, cookies, favorite writes or personal data transport.
 */
(()=>{'use strict';
  const ID='moa-r231-naver-return-settings';
  const WEB_ID='moa-r231-naver-webview-settings';
  const DEF={enabled:true,style:'glass',move:true,resize:true,snap:false,opacity:92,sizeWidthDp:154,sizeHeightDp:48};
  let state={...DEF},busy=false,lastStatus='';
  const el=(tag,cls='',txt='')=>{const x=document.createElement(tag);if(cls)x.className=cls;if(txt)x.textContent=txt;return x;};
  const root=()=>document.querySelector('section.page[data-page="settings"]');
  const bridge=()=>window.MoaNaverFeatures||null;
  function read(){
    try{const b=bridge();if(!b||typeof b.returnPopupSettings!=='function')return false;
      const j=JSON.parse(b.returnPopupSettings()||'{}');if(j.error)return false;
      state={...DEF,...j};return true;
    }catch(e){return false;}
  }
  function save(patch){
    const b=bridge();if(!b||typeof b.saveReturnPopupSettings!=='function')return;
    try{b.saveReturnPopupSettings(JSON.stringify(patch));state={...state,...patch};read();refreshControls();drawPreview();}
    catch(e){setHint('설정 저장에 실패했습니다.');}
  }
  function setHint(text){const hint=document.getElementById(ID+'-hint');if(hint)hint.textContent=text;}
  function refreshControls(){
    const item=document.getElementById(ID);if(!item)return;
    for(const control of item.querySelectorAll('[data-moa-key]')){
      const k=control.dataset.moaKey;
      if(control.type==='checkbox')control.checked=!!state[k];else control.value=String(state[k]);
      const output=control.closest('.moa-r231-sliderwrap')?.querySelector('output');
      if(output)output.textContent=Number(state[k])+'%';
    }
    const scale=item.querySelector('[data-moa-size]');if(scale){
      scale.value=String(Math.max(85,Math.min(190,Math.round((+state.sizeWidthDp||154)/154*100))));
      const output=scale.closest('.moa-r231-sliderwrap')?.querySelector('output');
      if(output)output.textContent=scale.value+'%';
    }
  }

  function section(title){return el('div','moa-r231-section',title);}
  function row(title,ctrl){let r=el('div','moa-r231-row');let l=el('label','',title);r.append(l,ctrl);return r;}
  function checkbox(key,title){const c=el('input');c.type='checkbox';c.dataset.moaKey=key;c.checked=!!state[key];c.setAttribute('aria-label',title);
    c.addEventListener('change',()=>save({[key]:c.checked}));return row(title,c);}
  function select(key,title,opts){const c=el('select');c.dataset.moaKey=key;c.setAttribute('aria-label',title);
    for(const [value,label] of opts){const o=el('option','',label);o.value=value;c.append(o);}c.value=String(state[key]);
    c.addEventListener('change',()=>save({[key]:c.value}));return row(title,c);}
  function slider(key,title,min,max,step,format){let r=el('div','moa-r231-sliderwrap');let h=el('div','moa-r231-sliderhead');
    let label=el('span','',title),num=el('output','',format(state[key]));h.append(label,num);
    let c=el('input');c.type='range';c.dataset.moaKey=key;c.min=min;c.max=max;c.step=step;c.value=state[key];
    c.addEventListener('input',()=>{num.textContent=format(+c.value);});
    c.addEventListener('change',()=>save({[key]:+c.value}));r.append(h,c);return r;}
  function drawPreview(){
    const p=document.getElementById(ID+'-preview');if(!p)return;
    const s=state.style||'glass';p.dataset.style=s;p.style.opacity=String(Math.max(.45,Math.min(1,(+state.opacity||92)/100)));
    const w=Math.min(300,Math.max(130,+state.sizeWidthDp||154));
    const h=Math.min(108,Math.max(44,+state.sizeHeightDp||48));
    p.style.width=Math.round(w*.9)+'px';p.style.height=Math.round(h*.9)+'px';
  }
  function addControls(panel){
    panel.append(section('기본 설정'));
    panel.append(checkbox('enabled','네이버지도 복귀 버튼 표시'));
    panel.append(select('style','버튼 디자인', [['glass','미니멀 글래스'],['peach','피치'],['light','화이트']]));
    panel.append(slider('opacity','팝업 불투명도',45,100,5,n=>n+'%'));
    panel.append(section('크기 및 위치'));
    const scale=Math.max(85,Math.min(190,Math.round((+state.sizeWidthDp||154)/154*100)));
    let sizeRow=el('div','moa-r231-sliderwrap');
    let head=el('div','moa-r231-sliderhead');const output=el('output','',scale+'%');head.append(el('span','','기본 크기 (현재 화면 방향)'),output);
    let range=el('input');range.type='range';range.dataset.moaSize='true';range.min='85';range.max='190';range.step='5';range.value=String(scale);
    range.addEventListener('input',()=>output.textContent=range.value+'%');
    range.addEventListener('change',()=>{
      const f=+range.value/100;
      const width=Math.min(300,Math.max(130,Math.round(154*f))),height=Math.min(108,Math.max(44,Math.round(48*f)));
      save({sizeWidthDp:width,sizeHeightDp:height});
    });sizeRow.append(head,range);panel.append(sizeRow);
    panel.append(checkbox('move','길게 눌러 자유 이동'));
    panel.append(checkbox('resize','길게 눌러 8방향 크기 조절'));
    panel.append(checkbox('snap','가장자리 자동 정렬'));
    panel.append(el('p','moa-r231-help','네이버지도 위에서 길게 누르면 편집됩니다. 이동 또는 상·하·좌·우·4개 모서리 드래그로 크기를 조정하고 X로 편집을 종료하세요. 세로·가로 위치와 크기는 따로 저장됩니다.'));
    panel.append(section('위치·크기 초기화'));
    const actions=el('div','moa-r231-actions');
    for(const [name,patch] of [['위치 초기화',{resetPosition:true}],['크기 초기화',{resetSize:true}],['모두 초기화',{resetPosition:true,resetSize:true}]]){
      let b=el('button','',name);b.type='button';b.addEventListener('click',()=>{
        save(patch);setHint('초기화가 적용됐어요. 다음 지도 실행부터 반영됩니다.');
      });actions.append(b);
    }panel.append(actions);
    panel.append(section('현재 설정 미리보기'));
    const previewBox=el('div','moa-r231-previewbox');const preview=el('div','moa-r231-preview');preview.id=ID+'-preview';
    preview.append(el('span','moa-r231-previewprimary','↶  MOA'),el('span','moa-r231-divider'),el('span','moa-r231-x','×'));
    previewBox.append(preview);panel.append(previewBox);
    drawPreview();
    panel.append(el('p','moa-r231-help','실제 네이버지도로 나갈 때만 표시되며, 누르면 현재 MOA의 같은 사진으로 복귀합니다. 바로기록 팝업과 설정이 분리되어 있습니다.'));
  }
  function mount(){
    const page=root();if(!page||document.getElementById(ID))return;
    let list=page.querySelector(':scope > ul.rows');
    if(!list){list=page.querySelector('#moa-r117-photo-settings .moa-r117-inner-rows');}
    if(!list)return;
    const available=read();
    const item=el('li','moa-r231-card');item.id=ID;
    const btn=el('button','moa-r231-title');btn.type='button';btn.setAttribute('aria-expanded','false');
    const title=el('span');title.append(el('strong','','네이버지도 복귀 팝업'),el('small','','아이콘 · 위치 · 크기 · 불투명도 설정'));
    btn.append(title,el('span','moa-r231-caret','⌄'));
    const panel=el('div','moa-r231-panel');panel.hidden=true;
    panel.append(el('p','moa-r231-info',available?'바로기록과 독립된 네이버지도 복귀 버튼 설정입니다.':'네이티브 설정 연결 대기 중입니다. MOA 화면을 다시 열어주세요.'));
    addControls(panel);const hint=el('p','moa-r231-help');hint.id=ID+'-hint';panel.append(hint);
    btn.addEventListener('click',()=>{
      panel.hidden=!panel.hidden;btn.setAttribute('aria-expanded',String(!panel.hidden));
      if(!panel.hidden){read();refreshControls();drawPreview();}
    });item.append(btn,panel);
    const quick=document.getElementById('moa-r215-quick-popup-settings');
    if(quick?.parentNode===list)quick.insertAdjacentElement('afterend',item);else list.append(item);
    mountWeb(list,item);
  }
  function mountWeb(list,prev){
    if(document.getElementById(WEB_ID))return;
    const item=el('li','moa-r231-card');item.id=WEB_ID;
    const title=el('button','moa-r231-title');title.type='button';title.setAttribute('aria-expanded','false');
    const head=el('span');head.append(el('strong','','네이버 즐겨찾기 웹 연결 · 실험'),el('small','','네이버 로그인 · 웹뷰 표시·숨김 실행 진단'));
    title.append(head,el('span','moa-r231-caret','⌄'));
    const panel=el('div','moa-r231-panel');panel.hidden=true;
    panel.append(el('p','moa-r231-info','현재는 실제 네이버 웹뷰 접근 가능성을 확인하는 단계입니다. 즐겨찾기 저장이나 리스트 생성은 실행하지 않으며, 로그인 정보를 MOA가 읽거나 전송하지 않습니다.'));
    const actions=el('div','moa-r231-web-actions');
    const start=el('button','moa-r231-primary','네이버 웹뷰 진단 시작');
    const status=el('button','','진단 결과 확인');const stop=el('button','','진단 종료');
    actions.append(start,status,stop);panel.append(actions);
    const result=el('p','moa-r231-result','아직 웹뷰를 실행하지 않았습니다.');panel.append(result);
    function update(){try{const b=bridge();if(!b?.webProbeStatus)return result.textContent='네이티브 진단 연결 대기 중';
      const s=JSON.parse(b.webProbeStatus());
      result.textContent=`진단: ${s.state||'IDLE'} · 숨김: ${s.hidden?'예':'아니오'} · iframe: ${s.frameCount??'-'} · 저장 실행: 없음`;
    }catch(e){result.textContent='진단 정보 확인 실패';}}
    start.addEventListener('click',()=>{if(bridge()?.openWebProbe)bridge().openWebProbe();else result.textContent='네이티브 연결 대기 중';});
    status.addEventListener('click',update);
    stop.addEventListener('click',()=>{bridge()?.stopWebProbe?.();setTimeout(update,200);});
    title.addEventListener('click',()=>{panel.hidden=!panel.hidden;title.setAttribute('aria-expanded',String(!panel.hidden));if(!panel.hidden)update();});
    item.append(title,panel);prev.insertAdjacentElement('afterend',item);
  }
  let timer=null;
  function delayedMount(){if(timer)clearTimeout(timer);timer=setTimeout(mount,120);}
  document.addEventListener('DOMContentLoaded',delayedMount,{once:true});
  document.addEventListener('click',e=>{if(e.target.closest?.('[data-page="settings"], [data-tab="settings"], [data-view="settings"]'))delayedMount();},true);
  document.addEventListener('visibilitychange',()=>{if(!document.hidden)delayedMount();});
  let attempts=0;const boot=setInterval(()=>{if(document.getElementById(ID)||++attempts>18){clearInterval(boot);return;}mount();},550);
  mount();
})();