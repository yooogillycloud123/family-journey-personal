/* MOA R32 — additive only, never redefines existing photo/diary/navigation functions.
   - Text-only app brand update.
   - Gentle boundaries for diary photo actions.
   - Automatic paginated photo append when scrolling the curated diary picker.
   No photo/media/network/upload/storage activity. */
(function(){
  'use strict';
  if(window.__moaR32Installed) return;
  window.__moaR32Installed=true;
  const root=()=>document.getElementById('fj-diary-root');
  const trim=s=>String(s||'').replace(/\s+/g,' ').trim();
  const isVisible=e=>{
    if(!e||!e.isConnected||e.getClientRects().length===0) return false;
    for(let x=e;x&&x.nodeType===1;x=x.parentElement){
      if(x.hidden) return false;
      const c=getComputedStyle(x);
      if(c.display==='none'||c.visibility==='hidden')return false;
    }
    return true;
  };
  function brandText(){
    document.title='모아';
    for(const selector of ['#top-title','.app-brand-name','.home-brand-name']){
      const e=document.querySelector(selector);
      if(e&&e.children.length===0&&trim(e.textContent)==='우리 가족 여행')e.textContent='모아';
    }
  }
  const labels=new Set(['공유','갤러리','달력 대표','위치 보기','위치 접기','사진 공유','영상 공유']);
  function rgb(s){
    const x=String(s||'').match(/rgba?\(\s*(\d+)[, ]+\s*(\d+)[, ]+\s*(\d+)/i);
    return x?[Number(x[1]),Number(x[2]),Number(x[3])]:null;
  }
  function isBlue(s){
    const c=rgb(s);
    return !!c&&c[2]>150&&c[2]>c[0]+60&&c[2]>c[1]+35&&c[1]>65;
  }
  function decorate(){
    brandText();
    const r=root(); if(!r||!isVisible(r))return;
    for(const e of r.querySelectorAll('button,a,[role="button"]')){
      if(!isVisible(e))continue;
      const label=trim(e.textContent);
      if(labels.has(label))e.classList.add('moa-r32-action');
      if(e.hasAttribute('data-moa-r32-look'))continue;
      const style=getComputedStyle(e);
      if(isBlue(style.backgroundColor)){
        e.classList.add('moa-r32-accent-fill');e.setAttribute('data-moa-r32-look','fill');
      }else if(isBlue(style.color)){
        e.classList.add('moa-r32-accent-text');e.setAttribute('data-moa-r32-look','text');
      }
    }
  }
  let observer=null,seenScroll=false,loading=false,chosenButton=null,lastAutoClick=0;
  function pickRoot(){
    const r=root();if(!r||!isVisible(r))return null;
    // Guard: must be the '내가 고른 사진 일기' photo composer, NOT any other gallery.
    const commit=Array.from(r.querySelectorAll('button,[role="button"]')).find(x=>
      isVisible(x)&&/선택한 사진.*일기 구성/.test(trim(x.textContent)));
    return commit?r:null;
  }
  function nextButton(){
    const r=pickRoot();if(!r)return null;
    return Array.from(r.querySelectorAll('button,[role="button"]')).find(x=>
      isVisible(x)&&/^다음 사진\s*[›>]?\s*$/.test(trim(x.textContent))&&!x.disabled&&x.getAttribute('aria-disabled')!=='true')||null;
  }
  function scrollParent(e){
    for(let p=e?.parentElement;p&&p!==document.body;p=p.parentElement){
      const st=getComputedStyle(p);
      if(/auto|scroll/.test(st.overflowY)&&p.scrollHeight>p.clientHeight+4)return p;
    }
    return document.scrollingElement||document.documentElement;
  }
  function nearViewport(e){
    const b=e.getBoundingClientRect();
    return b.top<innerHeight+720&&b.bottom>-40;
  }
  function loadNext(){
    const btn=nextButton();
    if(!btn||!seenScroll||loading||!nearViewport(btn)||Date.now()-lastAutoClick<500)return;
    loading=true;lastAutoClick=Date.now();
    const scroll=scrollParent(btn),old=scroll.scrollTop;
    const sx=window.scrollX,sy=window.scrollY;
    try{
      btn.click();
      // The old NEXT button implementation may jump the viewport; keep the
      // reader's previous position and append images below it instead.
      requestAnimationFrame(()=>requestAnimationFrame(()=>{
        if(Math.abs(scroll.scrollTop-old)>28)scroll.scrollTop=old;
        if(Math.abs(window.scrollY-sy)>28)window.scrollTo(sx,sy);
      }));
    }catch(e){console.warn('MOA R32 photo paging',e);}
    setTimeout(()=>{loading=false;schedule();},500);
  }
  function schedule(){
    if(schedule.pending)return;
    schedule.pending=true;
    requestAnimationFrame(()=>{schedule.pending=false;decorate();if(seenScroll)loadNext();});
  }
  function onScroll(){
    if(!pickRoot()){seenScroll=false;return;}
    seenScroll=true;schedule();
  }
  document.addEventListener('scroll',onScroll,{capture:true,passive:true});
  window.addEventListener('scroll',onScroll,{passive:true});
  const mo=new MutationObserver(schedule);
  mo.observe(document.documentElement||document,{childList:true,subtree:true});
  schedule();
  window.__moaR32Status=()=>({enabled:true,picker:!!pickRoot(),next:!!nextButton(),loading});
})();
