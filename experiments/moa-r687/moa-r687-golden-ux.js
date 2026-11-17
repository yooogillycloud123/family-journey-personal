/* MOA R687: isolated UX-only, additive to the user-physical R683 GOLDEN.
 * Keep existing data owners and navigation handlers. No IndexedDB writes,
 * no photo/media URI access and no native Gallery open/close wrappers.
 */
(()=>{'use strict';
 const VERSION='R687';
 const AUX_KEY='moa.r687.todaybar.aux.v1';
 const TITLE_KEY='moa.r687.story.fold.';
 const $=(selector,root=document)=>root.querySelector(selector);
 let activeFrame=0,scheduled=false,bar=null,settingsRefresh=false;
 const store=(k,v)=>{try{localStorage.setItem(k,v)}catch(_){}};
 const read=(k,def)=>{try{return localStorage.getItem(k)??def}catch(_){return def}};
 const auxOn=()=>read(AUX_KEY,'off')==='on';
 const today=()=>{const d=new Date();return `${d.getFullYear()}-${String(d.getMonth()+1).padStart(2,'0')}-${String(d.getDate()).padStart(2,'0')}`};
 function tabbar(){return $('#tabbar')}
 function activeTab(){const b=$('#tabbar button[data-tab].active');return b?.dataset.tab||null}
 function diaryCalendarReady(){const root=$('#moa-r469-root');return !!root&&!root.hidden&&root.dataset.page==='calendar'&&!!$('.moa-r487-today-action',root)}
 function gotoToday(){
  const diary=$('#tabbar button[data-tab="diary"]');if(!diary)return;
  // Reuse the proven R683 real Diary-tab handler AND the original Today handler.
  // No direct writes to original calendar/day state (critical for Golden).
  diary.click();
  let tries=0;
  function tryToday(){
   if(!diaryCalendarReady()){
    if(++tries<45)setTimeout(tryToday,45);
    return;
   }
   const anchor=$('#moa-r469-root .moa-r487-today-action');
   if(anchor)anchor.click();
  }
  setTimeout(tryToday,0);
 }
 function ensureAuxBar(){
  const barNav=tabbar();if(!barNav||!barNav.parentNode)return;
  if(!bar){
   bar=document.createElement('div');bar.id='moa-r687-aux-today';
   bar.setAttribute('aria-label','오늘 날짜 일기로 바로 이동');
   const btn=document.createElement('button');btn.type='button';btn.className='moa-r687-today-action';
   btn.setAttribute('aria-label','오늘 날짜 일기 달력으로 이동');btn.title='오늘의 일기';
   btn.addEventListener('click',gotoToday);
   bar.append(btn);
  }
  if(bar.parentNode!==barNav.parentNode)barNav.parentNode.insertBefore(bar,barNav);
 }
 function syncAuxBar(){
  ensureAuxBar();const nav=tabbar();if(!bar||!nav)return;
  const active=activeTab();
  const wizard=nav.hidden;
  // On pages unknown to old 5-tab code, simply follow their tabbar active
  // state: compatible with future additional tabs without a hardcoded whitelist.
  const show=auxOn()&&!wizard&&active&&active!=='diary'&&active!=='moa-plus'&&active!=='family';
  bar.hidden=!show;
  if(show){const rect=nav.getBoundingClientRect();bar.style.bottom=Math.max(0,innerHeight-rect.top)+'px';}
 }
 const groupInfo={
  diary:{title:'일기 · 바로기록',description:'달력, 촬영 팝업, 갤러리, 네이버 복귀, 오늘 이동'},
  map:{title:'나의 지도',description:'지도·위치·사진 출처'},
  record:{title:'기록 · 영상',description:'여권, 영상 제작, 기록 기능'},
  app:{title:'앱 · 공통',description:'계정, 데이터, 접근성, 개인정보, 버전'}
 };
 function classify(node){
  const id=String(node.id||'');const name=String(node.textContent||'').slice(0,220);
  if(id==='moa-r687-todaybar-setting')return 'diary';
  if(/moa-r231|moa-r495|moa-r602|moa-r117|moa-r215|moa-r610|moa-r615|diary|calendar|photo-settings/.test(id))return 'diary';
  if(/바로\s*기록|오늘\s*이야기|일기|달력|갤러리|네이버|촬영\s*팝업|복귀\s*버튼/.test(name))return 'diary';
  if(/지도|GPS|위치/.test(name)&&!/지원|처리방침|계정/.test(name))return 'map';
  if(/영상|여권|기록|릴스|스토리/.test(name)&&!/실행\s*경로/.test(name))return 'record';
  return 'app';
 }
 function newHeader(key){
  const li=document.createElement('li');li.className='moa-r687-settings-group';li.dataset.moaGroup=key;
  const btn=document.createElement('button');btn.type='button';btn.className='moa-r687-settings-toggle';
  const label=document.createElement('span');label.className='moa-r687-settings-name';label.textContent=groupInfo[key].title;
  const count=document.createElement('span');count.className='moa-r687-settings-count';count.textContent=groupInfo[key].description;
  const arrow=document.createElement('span');arrow.className='moa-r687-settings-arrow';arrow.setAttribute('aria-hidden','true');arrow.textContent='⌄';
  btn.append(label,count,arrow);li.append(btn);
  btn.addEventListener('click',()=>{
   const root=$('section.page[data-page="settings"] > ul.rows');if(!root)return;
   const open=li.dataset.open!=='true';li.dataset.open=String(open);btn.setAttribute('aria-expanded',String(open));
   for(const item of [...root.children])if(item.dataset.moaCategory===key)item.classList.toggle('moa-r687-row-folded',!open);
  });
  li.dataset.open='false';btn.setAttribute('aria-expanded','false');return li;
 }
 function addAuxSetting(){
  const list=$('section.page[data-page="settings"] > ul.rows');if(!list)return;
  if($('#moa-r687-todaybar-setting'))return;
  const li=document.createElement('li');li.id='moa-r687-todaybar-setting';li.className='row switch-row';
  li.innerHTML='<div class="row-body"><div class="row-title">다른 탭에도 오늘 일기 이동 바</div><div class="row-desc">일기 탭은 항상 표시 · 나의 지도/기록/설정 및 향후 추가 탭에 동일한 검은 바 표시</div></div><label class="moa-r687-switch"><input type="checkbox" aria-label="다른 탭의 오늘 일기 이동 바"><span aria-hidden="true"></span></label>';
  const check=$('input',li);check.checked=auxOn();check.addEventListener('change',()=>{store(AUX_KEY,check.checked?'on':'off');syncAuxBar()});
  list.append(li);
 }
 function arrangeRootSettings(){
  const root=$('section.page[data-page="settings"] > ul.rows');if(!root)return;
  addAuxSetting();
  const groups=['diary','map','record','app'];
  const original=[...root.children].filter(n=>!n.classList.contains('moa-r687-settings-group'));
  if(!original.length)return;
  const heads={};for(const key of groups){heads[key]=root.querySelector(`li.moa-r687-settings-group[data-moa-group="${key}"]`)||newHeader(key)}
  const ordered=[];
  for(const key of groups){
   const subset=original.filter(n=>classify(n)===key);
   if(!subset.length)continue;
   ordered.push(heads[key]);
   for(const li of subset){li.dataset.moaCategory=key;li.classList.toggle('moa-r687-row-folded',heads[key].dataset.open!=='true');ordered.push(li)}
  }
  if(root.children.length!==ordered.length||[...root.children].some((el,i)=>el!==ordered[i]))root.replaceChildren(...ordered);
 }
 function decorateSections(){
  const settings=$('section.page[data-page="settings"]');if(!settings)return;
  for(const section of [...settings.children].filter(n=>n.classList?.contains('section'))){
   if(section.dataset.moaR687Section==='yes')continue;
   const heading=$(':scope > .section-title',section);
   if(!heading)continue;
   section.dataset.moaR687Section='yes';
   const title=heading.textContent.trim();
   const btn=document.createElement('button');btn.type='button';btn.className='moa-r687-section-toggle';btn.textContent=title+'  ⌄';
   btn.setAttribute('aria-expanded','false');section.insertBefore(btn,heading);
   section.classList.add('moa-r687-section-collapsed');
   btn.addEventListener('click',()=>{const closed=section.classList.toggle('moa-r687-section-collapsed');btn.setAttribute('aria-expanded',String(!closed));btn.textContent=title+(closed?'  ⌄':'  ⌃')});
  }
 }
 function settings(){arrangeRootSettings();decorateSections()}
 function attachStoryToggle(){
  for(const story of document.querySelectorAll('#moa-r469-root[data-page="day"] .moa-r469-story')){
   if(story.dataset.moaR687Story==='yes')continue;
   const title=$('.moa-r469-story-title',story),input=$('.moa-r469-text',story);
   if(!title||!input)continue;
   story.dataset.moaR687Story='yes';
   const date=$('#moa-r469-root')?.dataset.r661PhotoDay||'';
   const key=TITLE_KEY+date;
   const head=document.createElement('button');head.type='button';head.className='moa-r687-story-toggle';
   head.setAttribute('aria-controls','moa-r687-story-input');
   const label=document.createElement('span');label.textContent='오늘의 이야기';
   const arrow=document.createElement('span');arrow.className='moa-r687-story-arrow';arrow.setAttribute('aria-hidden','true');arrow.textContent='⌄';
   head.append(label,arrow);title.replaceWith(head);
   input.id='moa-r687-story-input';
   function apply(collapse){story.classList.toggle('moa-r687-story-collapsed',collapse);head.setAttribute('aria-expanded',String(!collapse));arrow.textContent=collapse?'⌄':'⌃';if(!collapse){input.style.height='auto';input.style.height=Math.max(125,input.scrollHeight+2)+'px'}}
   apply(read(key,'open')==='closed');
   head.addEventListener('click',()=>{const next=!story.classList.contains('moa-r687-story-collapsed');apply(next);store(key,next?'closed':'open')});
  }
 }
 function restoreDiaryChrome(){
  // Native/pink MOA Home can return from the record video wizard directly to
  // unified Diary without running old app.js goStep(0). This left CTA's
  // Previous/Next visible instead of the bottom five tabs.
  const state=window.MoaR469SimpleDiary?.readOnlyStatus?.();
  const root=$('#moa-r469-root'),nav=tabbar();
  if(!state?.active||!root||root.hidden||!nav||!nav.hidden)return;
  nav.hidden=false;
  const cta=$('#cta');if(cta)cta.hidden=true;
  const top=$('#top');if(top)top.hidden=true;
  $('#app')?.classList.add('tabs');
 }
 function update(){restoreDiaryChrome();syncAuxBar();attachStoryToggle();const settingsPage=$('section.page[data-page="settings"]');if(settingsPage&&(!settingsPage.hidden||!$('#moa-r687-todaybar-setting')))settings()}
 function schedule(){if(scheduled)return;scheduled=true;requestAnimationFrame(()=>{scheduled=false;update()})}
 function start(){
  schedule();
  const root=document.body||document.documentElement;
  const observer=new MutationObserver(schedule);
  observer.observe(root,{subtree:true,childList:true});
  // The wizard toggles tabbar.hidden without changing children. Observe that
  // specific native tab container only, never broad attribute mutation loops.
  if(tabbar())observer.observe(tabbar(),{attributes:true,attributeFilter:['hidden']});
  document.addEventListener('click',e=>{if(e.target.closest('#tabbar button[data-tab],#moa-r687-todaybar-setting'))setTimeout(schedule,0)},true);
  addEventListener('resize',schedule,{passive:true});addEventListener('pageshow',schedule,{passive:true});
  document.addEventListener('visibilitychange',()=>{if(!document.hidden)schedule()});
 }
 if(document.readyState==='loading')document.addEventListener('DOMContentLoaded',start,{once:true});else start();
 window.__moaR687UX={version:VERSION,refresh:schedule,goToday:gotoToday};
})();
