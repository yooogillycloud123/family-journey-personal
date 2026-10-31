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
    document.body?.classList.add('moa-r32');
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
      if(labels.has(label)){
        e.classList.add('moa-r32-action');
        const parent=e.parentElement;
        if(parent&&Array.from(parent.children).filter(x=>labels.has(trim(x.textContent))).length>=2)
          parent.classList.add('moa-r32-photo-action-row');
      }
      if(e.hasAttribute('data-moa-r32-look'))continue;
      const style=getComputedStyle(e);
      if(/^다음 사진\s*[›>]?\s*$/.test(label))e.classList.add('moa-r32-next-photos');
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
    return b.top<innerHeight+360&&b.bottom>-40;
  }
  // Original picker renders a page of photo cards, then '다음 사진'.
  // Preserve the actual thumbnail DOM nodes/event handlers when the original
  // implementation swaps the grid on page changes; do not clone thumbnails
  // (cloning breaks native selection callbacks and disabled-state updates).
  function photoKey(node){
    const img=node?.querySelector?.('img');
    return img?.getAttribute('data-media-id')||img?.getAttribute('data-id')||
      img?.currentSrc||img?.getAttribute('src')||'';
  }
  function photoGridNear(btn){
    const rootEl=pickRoot();if(!rootEl)return null;
    const bb=btn.getBoundingClientRect();
    let winner=null,best=Infinity;
    for(let p=btn.parentElement,level=0;p&&rootEl.contains(p)&&level<5;p=p.parentElement,level++){
      for(const candidate of p.querySelectorAll('div,ul')){
        if(candidate===btn||candidate.contains(btn))continue;
        const kids=Array.from(candidate.children);
        if(kids.length<4||kids.length>3500)continue;
        const valid=kids.filter(x=>x.querySelector?.('img')&&photoKey(x));
        if(valid.length<4||valid.length/kids.length<.78)continue;
        const rect=candidate.getBoundingClientRect();
        const dist=bb.top-rect.bottom;
        if(dist< -65||dist>2400)continue;
        const score=Math.abs(dist)+level*20;
        if(score<best){best=score;winner=candidate;}
      }
      if(winner)break;
    }
    return winner;
  }
  function appendOldPhotos(btn,oldGrid,oldNodes,oldKeys){
    // Allow the original render/mutation to finish before merging.
    let tries=0;
    const repair=()=>{
      tries++;
      const now=nextButton()||btn;
      const newGrid=photoGridNear(now);
      const newNodes=newGrid?Array.from(newGrid.children).filter(x=>photoKey(x)):[];
      if(!newGrid||(!newNodes.length&&tries<5)){
        if(tries<6)setTimeout(repair,100);
        return;
      }
      if(oldNodes.every(x=>x.isConnected))return; // original engine already appended.
      const newKeys=new Set(newNodes.map(photoKey));
      const missing=oldNodes.filter((node,i)=>node&&!node.isConnected&&!newKeys.has(oldKeys[i]));
      if(!missing.length)return;
      // Reuse *exact* prior nodes; retain their click handlers and selection UI.
      const fragment=document.createDocumentFragment();
      missing.forEach(n=>fragment.appendChild(n));
      newGrid.insertBefore(fragment,newGrid.firstChild);
    };
    setTimeout(repair,90);
  }
  function loadNext(){
    const btn=nextButton();
    if(!btn||!seenScroll||loading||!nearViewport(btn)||Date.now()-lastAutoClick<700)return;
    loading=true;lastAutoClick=Date.now();seenScroll=false;
    const scroll=scrollParent(btn),old=scroll.scrollTop;
    const sx=window.scrollX,sy=window.scrollY;
    const oldGrid=photoGridNear(btn);
    const oldNodes=oldGrid?Array.from(oldGrid.children).filter(x=>photoKey(x)):[];
    const oldKeys=oldNodes.map(photoKey);
    try{
      btn.click();
      if(oldNodes.length>=4)appendOldPhotos(btn,oldGrid,oldNodes,oldKeys);
      // Do not jump to the bottom when the app replaces a photo page.
      requestAnimationFrame(()=>requestAnimationFrame(()=>{
        if(Math.abs(scroll.scrollTop-old)>28)scroll.scrollTop=old;
        if(Math.abs(window.scrollY-sy)>28)window.scrollTo(sx,sy);
      }));
    }catch(e){console.warn('MOA R32 photo paging',e);}
    setTimeout(()=>{loading=false;schedule();},650);
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
