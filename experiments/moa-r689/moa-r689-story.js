/* MOA R689 — ONLY "오늘의 이야기" optional collapse, default expanded. */
(()=>{'use strict';
 const ROOT='#moa-r469-root[data-page="day"]';
 const decorate=()=>{
  const root=document.querySelector(ROOT);
  if(!root||root.hidden)return;
  for(const card of root.querySelectorAll('.moa-r469-story')){
   if(card.dataset.moaR689Story==='ready')continue;
   const title=card.querySelector('.moa-r469-story-title');
   const input=card.querySelector('.moa-r469-text');
   if(!title||!input)continue;
   card.dataset.moaR689Story='ready';
   const head=document.createElement('button');head.type='button';
   head.className='moa-r689-story-toggle';
   head.setAttribute('aria-expanded','true');
   head.setAttribute('aria-label','오늘의 이야기 글 접기');
   const label=document.createElement('span');label.textContent='오늘의 이야기';
   const arrow=document.createElement('span');arrow.className='moa-r689-story-arrow';
   arrow.textContent='⌃';arrow.setAttribute('aria-hidden','true');
   head.append(label,arrow);title.replaceWith(head);
   head.addEventListener('click',()=>{
    const closed=card.classList.toggle('moa-r689-story-folded');
    head.setAttribute('aria-expanded',String(!closed));
    head.setAttribute('aria-label',closed?'오늘의 이야기 글 펼치기':'오늘의 이야기 글 접기');
    arrow.textContent=closed?'⌄':'⌃';
    // Do NOT fold the separate QuickRecord/Voice rows or modify text data.
    if(!closed){input.style.height='auto';input.style.height=Math.max(125,input.scrollHeight+2)+'px';}
   });
  }
 };
 let queued=false;
 const schedule=()=>{if(queued)return;queued=true;requestAnimationFrame(()=>{queued=false;decorate();});};
 const start=()=>{
  schedule();
  new MutationObserver(schedule).observe(document.body,{subtree:true,childList:true});
  document.addEventListener('click',schedule,true);
  document.addEventListener('visibilitychange',()=>{if(!document.hidden)schedule();});
 };
 if(document.readyState==='loading')document.addEventListener('DOMContentLoaded',start,{once:true});else start();
})();
