/* FamilyJourney - GPS photo positions -> verified NAVER place review queue.
 * Never substitutes city labels (남원/전주) for real venue names.  Precisely
 * located photo IDs come from native.js/data.photos, not grouped travel stops.
 * No claim of NAVER account write until external verified PC driver is ported.
 */
(function(root){'use strict';
 const STORAGE='familyjourney.naver.precise.v2';
 const $=s=>document.querySelector(s);const KM=6371.0088;
 let options={clusterMeters:25,homeRadiusKm:1.5,home:null};
 let state;try{state=JSON.parse(localStorage.getItem(STORAGE)||'{}')||{};}catch(e){state={};}
 function save(){try{localStorage.setItem(STORAGE,JSON.stringify(state))}catch(e){}}
 function number(x){let n=Number(x);return Number.isFinite(n)?n:NaN;}
 function valid(p){const a=number(p.lat),b=number(p.lon);return a>=33&&a<=39&&b>=124&&b<=132;}
 function km(a,b){const r=Math.PI/180;const la=(number(b.lat)-number(a.lat))*r,lo=(number(b.lon)-number(a.lon))*r;
   const v=Math.sin(la/2)**2+Math.cos(number(a.lat)*r)*Math.cos(number(b.lat)*r)*Math.sin(lo/2)**2;
   return 2*KM*Math.asin(Math.min(1,Math.sqrt(Math.max(0,v))));}
 function safe(s){return String(s||'').trim().slice(0,120);}
 function sourceRows(){
   const d=root.FamilyJourneyExtension?.getData?.();let rows=[];
   if(!d)return rows;
   const stops=Array.isArray(d.stops)?d.stops:[];
   if(d.home&&valid(d.home))options.home={lat:number(d.home.lat),lon:number(d.home.lon)};
   const idMap=new Map();
   for(const s of stops){if(!s)continue;for(const id of (s.ids||[]))idMap.set(String(id).replace(/\|v$/,''),s);}
   // Native photo index stores up to 30k real coordinates to 5 decimal places (~1m).
   if(Array.isArray(d.photos)&&d.photos.length){
     for(const item of d.photos){
       if(!Array.isArray(item)||item.length<3)continue;
       const id=String(item[0]||''),lat=number(item[1]),lon=number(item[2]);
       const s=idMap.get(id);if(!valid({lat,lon}))continue;
       rows.push({lat,lon,name:'',region:(s&&s.name)||'',photoId:id,start:String((s&&s.start)||'').slice(0,10),photos:1,source:'내 사진 GPS',precision:'photo'});
     }
   }else{
     // Old data fallback: 100m grid ONLY, never imply accurate venue identity.
     for(const s of stops){if(!s||s.home)continue;
       for(const pt of (s.pts||[])){if(!Array.isArray(pt)||pt.length<2)continue;
         rows.push({lat:number(pt[0]),lon:number(pt[1]),name:'',region:s.name||'',start:String(s.start||'').slice(0,10),photos:1,source:'여행 자리',precision:'100m'});
       }
     }
   }
   if(root.FamilyJourneyExtension?.getFamilyData){for(const s of root.FamilyJourneyExtension.getFamilyData()){
     if(s&&!s.home&&valid(s))rows.push({lat:number(s.lat),lon:number(s.lon),name:safe(s.name),region:'가족 사진',start:String(s.start||'').slice(0,10),photos:Number(s.n||1),source:s.member||'가족',precision:'family'});
   }}
   return rows;
 }
 function key(p){return number(p.lat).toFixed(4)+'|'+number(p.lon).toFixed(4);}
 function build(input,opts={}){
   const radius=Math.max(10,Math.min(60,number(opts.clusterMeters)||25))/1000;
   const home=opts.home&&valid(opts.home)?opts.home:null,exclude=Math.max(0,Math.min(10,number(opts.homeRadiusKm)||1.5));
   const rows=input.filter(valid).filter(x=>!home||km(x,home)>exclude).sort((a,b)=>number(a.lat)-number(b.lat)||number(a.lon)-number(b.lon));
   const out=[];
   for(const p of rows){
     let match=null;
     // Explicit place names must agree; otherwise use strict 25m photo clusters.
     for(let i=out.length-1;i>=0;i--){const a=out[i];if(number(p.lat)-a.lat>0.001)break;
       if(a.name&&p.name&&a.name!==safe(p.name))continue;
       if(km(a,p)<=radius){match=a;break;}
     }
     if(match){const n=match.pointCount;match.lat=(match.lat*n+number(p.lat))/(n+1);match.lon=(match.lon*n+number(p.lon))/(n+1);
       match.pointCount++;match.photos+=Number(p.photos||1);if(p.photoId)match.photoIds.push(String(p.photoId));if(!match.region&&p.region)match.region=safe(p.region);
       if(p.precision!=='photo')match.precision=p.precision;
     }else out.push({lat:number(p.lat),lon:number(p.lon),name:safe(p.name),region:safe(p.region),photoIds:p.photoId?[String(p.photoId)]:[],
         photos:Number(p.photos||1),start:String(p.start||''),precision:p.precision||'unknown',pointCount:1});
   }
   return out.map(p=>{let k=key(p);let prev=state[k]||{};return {...p,key:k,verifiedName:prev.name||'',address:prev.address||'',status:prev.status||'REVIEW',needsReview:!(prev.name&&prev.status==='CONFIRMED')};});
 }
 function candidates(){return build(sourceRows(),options);}
 function locationText(p){return p.address||p.lat.toFixed(5)+', '+p.lon.toFixed(5);}
 function query(p){return p.address||p.lat.toFixed(5)+', '+p.lon.toFixed(5);}
 function naverSearch(p){return 'https://map.naver.com/p/search/'+encodeURIComponent(query(p));}
 function open(url){if(root.NativeHost?.post)root.NativeHost.post('openUrl',JSON.stringify({url}));else root.open(url,'_blank');}
 function setStatus(p,status,name){state[p.key||key(p)]={...(state[p.key||key(p)]||{}),status,name:safe(name),updatedAt:new Date().toISOString()};save();}
 const pending=new Map();let seq=0;
 root.__fjNaverAddressResult=function(id,value){const cb=pending.get(id);if(!cb)return;pending.delete(id);cb(value||{});};
 function reverse(p,cb){if(!root.NativeHost?.post){cb({error:'native_unavailable'});return;}
   const id=++seq;pending.set(id,cb);root.NativeHost.post('reverseAddress',JSON.stringify({id,lat:p.lat,lon:p.lon}));
   setTimeout(()=>{if(pending.has(id)){pending.delete(id);cb({error:'timeout'});}},18000);
 }
  // R211: all GPS/Naver place photos share the R209 Diary native gallery.
  // The sheet is an explicit opt-in; no sheet is created when OFF or unset.
  function r211PlaceSheetEnabled(){
    try { return localStorage.getItem('moa.gallery.return.sheet.v1')==='on'; }
    catch (_) { return false; }
  }
  function r211NativeId(raw){
    const id=String(raw==null?'':raw);
    if(/^[0-9]{1,18}\|v$/.test(id))return 'v'+id.slice(0,-2);
    return /^v?[0-9]{1,18}$/.test(id)?id:'';
  }
  function r211OpenNative(ids,index){
    const valid=(ids||[]).map((x,i)=>({id:r211NativeId(x),i})).filter(x=>!!x.id);
    if(!valid.length||typeof root.MoaLocalAudio?.openNativeGallery!=='function')return false;
    const at=Math.max(0,Math.min((ids||[]).length-1,Number(index)||0));
    const selected=Math.max(0,valid.findIndex(x=>x.i>=at));
    const start=Math.max(0,Math.min(selected-4500,Math.max(0,valid.length-10000)));
    try{return !!root.MoaLocalAudio.openNativeGallery(JSON.stringify(valid.slice(start,start+10000).map(x=>x.id)),selected-start,'');}
    catch(e){console.warn('R211 Naver native gallery unavailable',e);return false;}
  }
 // This gallery uses only Android MediaStore thumbnails, never remote image URLs.
 function openInternalFullGallery(ids, initialIndex, place){
    // Prefer the exact R209 native gallery, even when an explicitly ON place sheet is open.
    if(r211OpenNative(ids,initialIndex)){
      if(!r211PlaceSheetEnabled())document.querySelector('#fj-naver-photo-sheet')?.remove();
      return true;
    }
    // No native MediaStore? Preserve prior full-screen viewer as explicit safe fallback.
    ids=ids.map(id=>String(id)).filter(id=>/^\d{1,18}$/.test(id));
    if(!ids.length)return false;
   document.querySelector('#fj-naver-photo-full')?.remove();
   const shell=document.createElement('div');shell.id='fj-naver-photo-full';
   shell.setAttribute('role','dialog');shell.setAttribute('aria-modal','true');
   shell.style.cssText='position:fixed;inset:0;z-index:100001;background:#090b10;color:#fff;display:flex;flex-direction:column;overflow:hidden;overscroll-behavior:contain';
   let idx=Math.max(0,Math.min(ids.length-1,initialIndex));
   const header=document.createElement('div');
   header.style.cssText='display:flex;align-items:center;justify-content:space-between;padding:calc(env(safe-area-inset-top,0px) + 8px) 10px 7px;gap:9px;min-height:46px;flex-shrink:0;z-index:4';
   const close=document.createElement('button');close.textContent='← 닫기';close.type='button';
   close.style.cssText='border:0;background:#ffffff25;color:white;border-radius:9px;padding:10px 13px;font-size:16px';
   close.onclick=()=>dismiss();
   const title=document.createElement('div');title.style.cssText='text-align:center;font-size:15px;flex:1;white-space:nowrap;overflow:hidden;text-overflow:ellipsis';
   const counter=document.createElement('span');counter.style.cssText='font-size:15px;text-align:right;min-width:55px';
   const fill=document.createElement('button');fill.textContent='채우기';fill.type='button';fill.setAttribute('aria-label','사진 화면 채우기 또는 전체 보기');
   fill.style.cssText='border:0;background:transparent;color:#c5ccd8;padding:8px 5px;font-size:12px';
   header.append(close,title,fill,counter);
   const stage=document.createElement('div');stage.id='fj-photo-gesture-stage';
   stage.style.cssText='position:relative;flex:1;min-height:0;overflow:hidden;background:#090b10;touch-action:none;overscroll-behavior:contain;user-select:none;-webkit-user-select:none';
   const img=document.createElement('img');img.alt='확대 및 좌우 넘김 가능한 원본 사진';
   img.draggable=false;img.style.cssText='position:absolute;inset:0;width:100%;height:100%;object-fit:contain;transform-origin:center center;transform:translate3d(0,0,0) scale(1);will-change:transform;pointer-events:none;-webkit-user-drag:none';
   const neighbor=document.createElement('img');neighbor.draggable=false;neighbor.alt='';
   neighbor.style.cssText=img.style.cssText+';display:none';
   const loading=document.createElement('span');loading.style.cssText='position:absolute;top:12px;left:10px;right:10px;text-align:center;color:#d5dae4;font-size:13px;pointer-events:none';
   const left=document.createElement('button'),right=document.createElement('button');
   for(const [b,label,side] of [[left,'‹','left'],[right,'›','right']]){
     b.textContent=label;b.type='button';b.setAttribute('aria-label',side==='left'?'이전 사진':'다음 사진');
     b.style.cssText='position:absolute;'+side+':8px;top:50%;transform:translateY(-50%);z-index:3;color:#fff;border:0;border-radius:50%;width:39px;height:39px;background:#151a22a8;font-size:29px;touch-action:manipulation';
   }
   stage.append(neighbor,img,loading,left,right);
   const footer=document.createElement('div');footer.textContent='두 손가락으로 확대·축소 · 확대 후 드래그 · 좌우 넘기기';
   footer.style.cssText='flex-shrink:0;color:#c5ced9;font-size:12px;text-align:center;padding:8px 7px calc(env(safe-area-inset-bottom,0px) + 9px)';
   // Intent actions share only the *currently selected* original MediaStore image.
   // Other group photos remain private; no upload happens without user choice.
   const actions=document.createElement('div');actions.id='fj-gallery-photo-actions';
   actions.style.cssText='display:flex;align-items:center;justify-content:center;gap:12px;flex-shrink:0;padding:10px 14px 2px;background:#090b10';
   function actionButton(text,command){
     const btn=document.createElement('button');btn.type='button';btn.textContent=text;
     btn.style.cssText='border:1px solid #4d5360;background:#171c27;color:#e5eaf4;border-radius:15px;min-width:0;padding:10px 16px;font-size:14px;font-weight:600;flex:1;max-width:185px';
     btn.onclick=()=>{
       const id=ids[idx];
       if(!/^\d{1,18}$/.test(id))return;
       if(root.NativeHost?.post)root.NativeHost.post(command,JSON.stringify({id}));
       else alert('휴대폰 Android 앱에서만 사용할 수 있어요.');
     };
     return btn;
   }
   actions.append(actionButton('공유 · 카톡 등','sharePhoto'),actionButton('갤러리에서 열기','openInGallery'));
   shell.append(header,stage,actions,footer);document.body.append(shell);
   const makeUrl=n=>'https://familyjourney.local/fj-photo/'+encodeURIComponent(ids[n])+'.jpg';
   let zoom=1,tx=0,ty=0,gesture=null,lastTap=0,transitioning=false,fillMode=false;
   function fitBounds(){
     const w=stage.clientWidth||1,h=stage.clientHeight||1;
     if(fillMode)return {w,h};
     if(!img.naturalWidth||!img.naturalHeight)return {w,h};
     const factor=Math.min(w/img.naturalWidth,h/img.naturalHeight);
     return {w:img.naturalWidth*factor,h:img.naturalHeight*factor};
   }
   function clamp(){
     const content=fitBounds();
     const maxX=Math.max(0,(content.w*zoom-stage.clientWidth)/2);
     const maxY=Math.max(0,(content.h*zoom-stage.clientHeight)/2);
     tx=Math.max(-maxX,Math.min(maxX,tx));ty=Math.max(-maxY,Math.min(maxY,ty));
     if(zoom<=1.001){zoom=1;tx=0;ty=0;}
   }
   function showZoom(animated){
     clamp();img.style.transition=animated?'transform .22s cubic-bezier(.2,.8,.2,1)':'none';
     img.style.transform='translate3d('+tx+'px,'+ty+'px,0) scale('+zoom+')';
   }
   function resetZoom(){zoom=1;tx=0;ty=0;showZoom(false);}
   function preload(){for(const n of [idx-1,idx+1])if(n>=0&&n<ids.length){let ahead=new Image();ahead.src=makeUrl(n);}}
   function render(){
     // R125: keep a fixed viewport, fade only the new image; never translate
     // the whole full-screen image during a normal swipe. Preserve pinch/pan.
     resetZoom();img.style.transition='opacity .12s ease-out';img.style.opacity='0';neighbor.style.display='none';neighbor.removeAttribute('src');
     img.style.objectFit=fillMode?'cover':'contain';neighbor.style.objectFit=img.style.objectFit;
     title.textContent=(typeof place==='string'?place:(place?.region||place?.name||place?.title||'방문 장소'))+' · 사진';counter.textContent=(idx+1)+' / '+ids.length;
     left.disabled=idx===0;right.disabled=idx===ids.length-1;
     left.style.opacity=idx===0?'.25':'.95';right.style.opacity=idx===ids.length-1?'.25':'.95';
     loading.textContent='사진을 불러오는 중…';
     img.onload=()=>{loading.textContent='';img.style.opacity='1';preload();};
     img.onerror=()=>{img.style.opacity='1';loading.textContent='사진을 열지 못했어요. 사진 접근 권한을 확인해 주세요.';};
     img.src=makeUrl(idx);
   }
   function move(n,dx=0){
     if(transitioning||zoom>1.01)return;
     const target=Math.max(0,Math.min(ids.length-1,idx+n));
     if(target===idx)return;
     // R125: render exactly one target frame. Previous implementation updated
     // two translated full-height bitmaps every touchmove and reloaded an
     // adjacent URL repeatedly, causing visible side panels/black gaps.
     transitioning=true;
     idx=target;
     render();
     transitioning=false;
   }
   left.onclick=()=>move(-1);right.onclick=()=>move(1);
   fill.onclick=()=>{fillMode=!fillMode;fill.textContent=fillMode?'전체 보기':'채우기';resetZoom();img.style.objectFit=fillMode?'cover':'contain';neighbor.style.objectFit=img.style.objectFit;};
   function distance(a,b){return Math.hypot(a.clientX-b.clientX,a.clientY-b.clientY);}
   function midpoint(a,b){return {x:(a.clientX+b.clientX)/2,y:(a.clientY+b.clientY)/2};}
   stage.addEventListener('touchstart',e=>{
     if(transitioning||e.target.closest('button'))return;
     if(e.touches.length>=2){
       const a=e.touches[0],b=e.touches[1];gesture={kind:'pinch',startDistance:Math.max(1,distance(a,b)),startZoom:zoom,startTx:tx,startTy:ty,startMid:midpoint(a,b)};
     }else if(e.touches.length===1){
       const a=e.touches[0];gesture={kind:zoom>1.01?'pan':'swipe',startX:a.clientX,startY:a.clientY,startTx:tx,startTy:ty,dx:0,dy:0,at:performance.now(),moved:false};
     }
   },{passive:true});
   stage.addEventListener('touchmove',e=>{
     if(!gesture||transitioning)return;
     if(e.touches.length>=2){
       if(gesture.kind!=='pinch'){
         const a=e.touches[0],b=e.touches[1];gesture={kind:'pinch',startDistance:Math.max(1,distance(a,b)),startZoom:zoom,startTx:tx,startTy:ty,startMid:midpoint(a,b)};
       }
       const a=e.touches[0],b=e.touches[1],mid=midpoint(a,b),rect=stage.getBoundingClientRect();
       const newZoom=Math.max(1,Math.min(6,gesture.startZoom*distance(a,b)/gesture.startDistance));
       const ox=gesture.startMid.x-rect.left-rect.width/2,oy=gesture.startMid.y-rect.top-rect.height/2;
       tx=mid.x-rect.left-rect.width/2-(ox-gesture.startTx)*(newZoom/gesture.startZoom);
       ty=mid.y-rect.top-rect.height/2-(oy-gesture.startTy)*(newZoom/gesture.startZoom);
       zoom=newZoom;showZoom(false);e.preventDefault();return;
     }
     if(e.touches.length===1){
       const p=e.touches[0],dx=p.clientX-gesture.startX,dy=p.clientY-gesture.startY;
       gesture.moved=gesture.moved||Math.abs(dx)+Math.abs(dy)>8;
       if(gesture.kind==='pan'){
         tx=gesture.startTx+dx;ty=gesture.startTy+dy;showZoom(false);e.preventDefault();return;
       }
       if(gesture.kind==='swipe'){
         gesture.dx=dx;gesture.dy=dy;
         // Keep the photograph physically stationary while the finger moves.
         // A vertical gesture must not nudge the current full-screen image.
         if(Math.abs(dx)>12&&Math.abs(dx)>Math.abs(dy)*1.15)e.preventDefault();
       }
     }
   },{passive:false});
   stage.addEventListener('touchend',e=>{
     if(!gesture||transitioning)return;
     if(e.touches.length>=2)return;
     if(e.touches.length===1){
       const t=e.touches[0];gesture={kind:zoom>1.01?'pan':'swipe',startX:t.clientX,startY:t.clientY,startTx:tx,startTy:ty,dx:0,dy:0,moved:false,at:performance.now()};return;
     }
     const g=gesture;gesture=null;
     if(g.kind==='swipe'){
       const w=stage.clientWidth||window.innerWidth;
       const horizontal=Math.abs(g.dx)>Math.abs(g.dy)*1.12;
       const velocity=Math.abs(g.dx)/Math.max(1,performance.now()-g.at);
       if(horizontal&&(Math.abs(g.dx)>w*.18||(Math.abs(g.dx)>25&&velocity>.48))){move(g.dx<0?1:-1,g.dx);return;}
       // Rejected swipe: current image never moved, so no snap-back.
       neighbor.style.display='none';
     }
     if(!g.moved&&e.changedTouches&&e.changedTouches.length){
       const tap=e.changedTouches[0],now=Date.now();
       if(now-lastTap<340){
         if(zoom>1.01){resetZoom();showZoom(true);}
         else {const rect=stage.getBoundingClientRect();zoom=2.6;
           tx=-(tap.clientX-rect.left-rect.width/2)*(zoom-1);
           ty=-(tap.clientY-rect.top-rect.height/2)*(zoom-1);showZoom(true);}
         lastTap=0;
       }else lastTap=now;
     }
   },{passive:true});
   stage.addEventListener('touchcancel',()=>{gesture=null;neighbor.style.display='none';showZoom(true);},{passive:true});
   stage.addEventListener('wheel',e=>{if(!e.ctrlKey)return;e.preventDefault();zoom=Math.max(1,Math.min(6,zoom*(e.deltaY<0?1.14:.87)));showZoom(false);},{passive:false});
   function dismiss(){document.removeEventListener('keydown',keys);shell.remove();}
   const keys=e=>{if(!shell.isConnected)return;
     if(e.key==='Escape'){dismiss();e.preventDefault();}
     if(e.key==='ArrowLeft'){move(-1);e.preventDefault();}
     if(e.key==='ArrowRight'){move(1);e.preventDefault();}};
   document.addEventListener('keydown',keys);
   render();
 }
 async function showPhotos(p){
   let old=document.querySelector('#fj-naver-photo-sheet');if(old)old.remove();
   const ids=[...new Set((p.photoIds||[]).map(v=>String(v)))].slice(0,180);
    if(!r211PlaceSheetEnabled()){
      document.querySelector('#fj-naver-photo-sheet')?.remove();
      if(r211OpenNative(ids,0))return;
      // Offline/cloud fallback may show FULL-SCREEN media, never an OFF bottom sheet.
      openInternalFullGallery(ids,0,p.verifiedName||p.region||'방문 장소');
      return;
    }
   const sheet=document.createElement('div');sheet.id='fj-naver-photo-sheet';
   sheet.setAttribute('role','dialog');sheet.setAttribute('aria-modal','true');
   sheet.style.cssText='position:fixed;inset:0;background:#0009;z-index:99998;display:flex;align-items:flex-end;justify-content:center';
   const box=document.createElement('div');box.style.cssText='width:100%;max-width:680px;max-height:87vh;overflow:auto;background:white;border-radius:22px 22px 0 0;padding:20px 16px 30px;box-shadow:0 0 30px #0002';
   const top=document.createElement('div');top.style.cssText='display:flex;justify-content:space-between;align-items:center;gap:12px';
   const title=document.createElement('h3');title.textContent=(p.verifiedName||p.region||'방문 장소')+' · 사진 '+ids.length+'장';title.style.cssText='font-size:20px;margin:0';
   const close=document.createElement('button');close.textContent='닫기 ×';close.type='button';close.style.cssText='border:0;background:#f1f3f5;border-radius:12px;padding:10px;font-size:15px';
   close.onclick=()=>sheet.remove();
   top.append(title,close);
   const subtitle=document.createElement('div');subtitle.textContent='사진을 누르면 앱 안에서 크게 열려요. 좌우로 넘기며 이 장소의 사진을 연속해서 볼 수 있습니다. 사진은 외부로 전송되지 않습니다.';
   subtitle.style.cssText='font-size:13px;color:#77818e;margin:14px 0';
   const grid=document.createElement('div');grid.id='fj-naver-photo-grid';grid.style.cssText='display:grid;grid-template-columns:repeat(3,minmax(0,1fr));gap:7px';
   const state=document.createElement('p');state.textContent='사진 불러오는 중…';state.style.cssText='color:#7b8999;font-size:14px';
   box.append(top,subtitle,state,grid);sheet.appendChild(box);document.body.appendChild(sheet);
   sheet.addEventListener('click',e=>{if(e.target===sheet)sheet.remove()});
   if(!ids.length){state.textContent='이 후보에는 연결된 사진 ID가 없습니다. 가족이 제공한 위치 정보만 있을 수 있어요.';return;}
   if(typeof root.__requestThumbs!=='function'){state.textContent='사진첩 썸네일 연결이 준비되지 않았습니다.';return;}
   let total=0;
   for(let i=0;i<ids.length;i+=24){
     if(!sheet.isConnected)break;
     const batch=ids.slice(i,i+24);
     let result;try{result=await root.__requestThumbs(batch,(window.matchMedia&&matchMedia('(min-width: 600px)').matches)?400:260)}catch(e){result=new Map()}
     for(const id of batch){
       if(!sheet.isConnected)break;
       const b=document.createElement('button');b.type='button';b.setAttribute('aria-label','원본 사진 열기');
       b.style.cssText='padding:0;border:0;background:#edf0f6;border-radius:9px;overflow:hidden;aspect-ratio:1;min-width:0';
       const data=result instanceof Map?result.get(id):null;
       if(data&&data.startsWith('data:image/')){
         const img=document.createElement('img');img.src=data;img.alt='해당 GPS 위치의 사진';img.loading='lazy';
         img.style.cssText='width:100%;height:100%;object-fit:cover';b.appendChild(img);total++;
       }else{b.textContent='사진 보기';b.style.color='#7a8394';}
       b.onclick=()=>openInternalFullGallery(ids,ids.indexOf(id),p.verifiedName||p.region||'방문 장소');
       grid.appendChild(b);
     }
     state.textContent='사진 '+Math.min(i+batch.length,ids.length)+' / '+ids.length+'장 확인 · 미리보기 '+total+'장';
   }
   if(!sheet.isConnected)return;
   if(!total)state.textContent='연결된 사진 '+ids.length+'장이 있지만, 썸네일을 가져오지 못했어요. 사진첩 권한을 확인하세요.';
 }
 function bridge(name,payload){try{if(root.NativeHost?.post){root.NativeHost.post(name,JSON.stringify(payload||{}));return true;}}catch(e){}return false;}
 let previousNativeState='';
 function naverResult(value){
   if(!value||typeof value!=='object')return;
   const label={
     SHEET_FOUND:'네이버지도 저장 목록 화면을 확인했어요. 메모·별명 입력 준비 중입니다.',
     WAITING_SAVE_SHEET:'네이버지도 저장 목록 화면이 열리기를 기다립니다.',
     WAITING_MEMO_EXPAND:'메모·별명 확장 버튼을 찾지 못했습니다.',
     WAITING_MEMO_EDITOR:'메모·별명 입력창이 열리기를 기다립니다.',
     FIELDS_NOT_ACCESSIBLE:'네이버지도 입력칸을 접근성으로 읽지 못했습니다.',
     MEMO_FIELDS_ENTERED_UNVERIFIED:'메모와 별명 자동 입력을 시도했습니다. 저장 준비 중입니다.',
     MEMO_INPUT_RETRY:'네이버지도 메모·별명 자동 입력 재시도 중입니다.',
     LIST_SELECTED:'저장 리스트 선택됨, 메모·별명 확인 후 저장합니다.',
     DEFAULT_LIST_VISUAL_CHECK:'기본 저장 리스트를 확인 중입니다.',
     NEEDS_LIST_SELECTION:'원하는 네이버지도 리스트가 보이지 않습니다. 직접 확인해 주세요.',
     MEMO_READBACK_FAILED:'메모/별명 입력값을 확인하지 못했습니다. 자동 저장하지 않았습니다.',
     SAVE_SUBMIT_NOT_FOUND:'네이버지도 저장 버튼을 찾지 못했습니다.',
     SAVE_DISABLED_CHECK_LIST:'저장 버튼이 비활성화되어 있어요. 네이버 리스트가 선택되었는지 확인해 주세요.',
     SAVE_CLICKED_UNVERIFIED:'네이버지도 저장 버튼을 눌렀습니다. 실제 계정 저장은 확인 중입니다.',
     PLACE_SAVED_MEMO_UNVERIFIED:'네이버지도에 장소 저장됨 표시는 있지만 메모 저장은 별도 확인이 필요합니다.',
     WAITING_NAVER_SAVE_CONFIRM:'네이버지도 저장 완료 표시를 기다리고 있습니다.',
     IDLE:'대기 중',WAITING_ADDRESS_RESULT:'네이버지도에서 해당 상세 주소의 검색 결과를 선택해 주세요.',
     WAITING_EXACT_PLACE:'정확한 주소 상세 페이지를 기다리고 있어요.',
     WAITING_SAVE_CONTROL:'저장 버튼을 찾지 못했어요. 화면을 확인해 주세요.',
     SAVE_CONTROL_CLICKED:'저장 버튼을 눌렀어요. 목록을 확인하는 중입니다.',
     WAITING_USER_LIST:'네이버지도 저장 목록을 직접 골라 주세요.',WAITING_LIST:'지정한 저장 목록을 찾는 중입니다.',
     LIST_CLICKED_UNVERIFIED:'저장 목록을 선택했지만 실제 저장 확인은 아직입니다.',
     COMMIT_CLICKED_UNVERIFIED:'완료를 눌렀지만 저장 확인은 아직입니다.',
     VERIFIED:'네이버지도에서 저장 완료 표시를 확인했습니다.',
     ALREADY_SAVED:'네이버지도에 이미 저장된 장소입니다.',
     UI_CHANGED_CHECK_MANUALLY:'네이버지도 화면 구성이 달라 자동 저장을 확인하지 못했습니다.',
     TIMEOUT:'3분 안에 저장을 확인하지 못했습니다.',
     NEEDS_ACCESSIBILITY_CONSENT:'접근성에서 우리 가족 여행의 네이버지도 저장 보조를 켜야 합니다.',
     ADDRESS_REQUIRED:'GPS로 조회한 상세 주소가 필요합니다.',NEEDS_USER_MEMO_EDIT:'네이버지도 메모/별명 입력 화면을 찾지 못했습니다. 네이버에서 직접 메모를 편집해 주세요.',
     MEMO_EDITOR_OPENED:'메모 편집기 열림',MEMO_ENTERED_UNVERIFIED:'메모 입력 후 저장 확인 중',
     MEMO_COMMIT_UNVERIFIED:'네이버 메모 저장 버튼을 누름, 결과 확인 중',NEEDS_USER_MEMO_VERIFY:'네이버지도에서 메모가 저장되었는지 확인이 필요합니다.',
     LIST_MAY_BE_SAVED:'네이버 저장 여부를 확인하는 중',ALREADY_SAVED_NOTE_PENDING:'기존 장소 저장을 발견했습니다. 메모 편집을 시도합니다.',WAITING_SAVED_CONFIRMATION:'네이버지도 저장 상태 확인 중',
     NAVER_APP_NOT_AVAILABLE:'네이버지도 앱이 설치되어 있는지 확인해 주세요.',CANCELLED:'자동 저장 보조를 중단했어요.'
   };
   const msg=label[value.state]||value.state||'';
   const box=document.querySelector('#fj-naver-notice');if(box)box.textContent='네이버지도 저장 보조: '+msg;
   if(value.key&&value.state==='VERIFIED'){
     const v=candidates().find(x=>x.key===value.key);
     if(v && v.status!=='CONFIRMED'){setStatus(v,'CONFIRMED',value.name||v.verifiedName);render();}
   }
   previousNativeState=value.state;
   // Diary uses the same verified feedback stream, not a second save mechanism.
   try{document.dispatchEvent(new CustomEvent('fj-naver-save-feedback',{detail:{...value,label:msg}}));}catch(e){}
 }
 root.__fjNaverSaveStatus=naverResult;
 function startNativeSave(p,input,memoBox){
   const alias=(input.value||'').trim();
   const memo=(memoBox.value||'').trim();
   if(!alias&&!memo){alert('네이버 저장 메모 또는 별명을 입력해 주세요. 예: 고창 차 안');return;}
   let current='내 장소';try{current=localStorage.getItem('fj.naver.targetlist')||current;}catch(e){}
   const entered=prompt('네이버지도에 실제로 존재하는 저장 리스트 이름을 입력해 주세요.\n네이버에 없는 새 리스트는 네이버지도 → 저장 → 새 리스트 만들기에서 먼저 생성해야 합니다.',current);
   if(entered===null)return;
   const list=(entered||'').trim()||'내 장소';
   try{localStorage.setItem('fj.naver.targetlist',list);}catch(e){}
   state[p.key]={...(state[p.key]||{}),name:alias,memo,list,status:'REVIEW'};save();
   function addressReady(address){
     address=String(address||'').trim();
     if(address.length<8){
       alert('상세 주소를 확인하지 못했습니다. 먼저 [상세 주소 조회]로 정확한 주소가 조회되는지 확인해 주세요.');
       return;
     }
     // The actual GPS-derived street/lot address is the NAVER search query.
     // Alias/memo go only into the optional Naver saved-place memo editor.
     const ok=bridge('naverArm',{key:p.key,address,alias,memo,list});
     if(!ok)alert('이 기능은 Android APK에서만 지원돼요.');
   }
   if(p.address){addressReady(p.address);return;}
   const notice=$('#fj-naver-notice');if(notice)notice.textContent='GPS 상세 주소 조회 중…';
   reverse(p,value=>{
     if(value.address){
       state[p.key]={...(state[p.key]||{}),address:value.address};save();
       addressReady(value.address);
     } else {
       if(notice)notice.textContent='상세 주소를 조회하지 못했습니다. 네이버 계정 저장을 시작하지 않았습니다.';
       alert('상세 주소 조회 결과가 없어 네이버지도에 임의 지역을 저장하지 않았습니다.');
     }
   });
 }
 function diaryDraftForGPS(point){
   if(!valid(point))return null;
   const saved=state[key(point)]||{};
   let preferred='내 장소';try{preferred=localStorage.getItem('fj.naver.targetlist')||preferred}catch(e){}
   return {alias:String(saved.name||''),memo:String(saved.memo||''),list:String(saved.list||preferred),address:String(saved.address||'')};
 }
 function saveFromDiaryGps(point,alias,memo,list,callback){
   if(!valid(point)){callback?.({state:'INVALID_GPS',message:'한국 내 원본 GPS 위치에서만 저장할 수 있어요.'});return false;}
   alias=safe(alias);memo=String(memo||'').trim().slice(0,400);list=String(list||'').trim().slice(0,70)||'내 장소';
   if(!alias&&!memo){callback?.({state:'NEEDS_TEXT',message:'별명 또는 메모를 입력해 주세요.'});return false;}
   const k=key(point);const loc={lat:number(point.lat),lon:number(point.lon)};
   // Do not silently mark a NAVER account save as successful.
   // It is verified only by the existing original native NAVER accessibility result.
   const old=state[k]||{};
   state[k]={...old,name:alias,memo,list,status:'REVIEW'};save();
   try{localStorage.setItem('fj.naver.targetlist',list)}catch(e){}
   const complete=(address)=>{
     address=String(address||'').trim();
     if(address.length<8){callback?.({state:'ADDRESS_UNAVAILABLE',message:'정밀 주소를 확인하지 못해 네이버 저장을 시작하지 않았어요.'});return;}
     state[k]={...(state[k]||{}),address};save();
     const accepted=bridge('naverArm',{key:k,address,alias,memo,list});
     callback?.({state:accepted?'STARTED':'NATIVE_UNAVAILABLE',key:k,message:accepted?'네이버지도 저장 보조를 시작했어요. 저장 결과는 네이버 화면에서 확인해 주세요.':'Android 네이버 저장 연결을 사용할 수 없어요.'});
   };
   if(old.address){complete(old.address);return true;}
   callback?.({state:'LOOKUP',key:k,message:'GPS에서 정밀 주소를 확인하는 중…'});
   reverse(loc,v=>complete(v.address));
   return true;
 }
 function exportList(list){let obj={version:2,generated:new Date().toISOString(),source:'local photo GPS',candidates:list};
   const blob=new Blob([JSON.stringify(obj,null,2)],{type:'application/json;charset=utf-8'});const url=URL.createObjectURL(blob);
   const a=document.createElement('a');a.href=url;a.download='가족여행_정밀GPS_네이버장소후보.json';a.click();setTimeout(()=>URL.revokeObjectURL(url),20000);
 }
 function render(){
   const panel=$('#fj-naver-panel');if(!panel)return;
   const list=$('#fj-naver-items'),rows=candidates();
   $('#fj-naver-summary').textContent=`정밀 위치 ${rows.length}곳 · 실제 네이버 저장 ${rows.filter(p=>p.status==='CONFIRMED').length}곳(사용자 확인) · 주소 검토 ${rows.filter(p=>p.needsReview).length}곳`;
   list.replaceChildren();
   for(let i=0;i<Math.min(rows.length,300);i++){
     const p=rows[i];const div=document.createElement('div');div.className='fj-naver-row';
     const heading=document.createElement('b');heading.textContent=p.verifiedName||'방문 장소 '+(i+1)+' · '+(p.region||'지역 확인');
     const meta=document.createElement('small');meta.textContent=[p.start,p.photos+'개 사진 위치',p.precision==='photo'?'사진 원래 GPS':p.precision==='100m'?'100m 격자(주소 재확인 필요)':p.source,p.status==='CONFIRMED'?'사용자 저장 확인':'미확인'].filter(Boolean).join(' · ');
     const adr=document.createElement('small');adr.textContent='좌표: '+locationText(p);adr.style.wordBreak='break-all';
     const input=document.createElement('input');input.value=state[p.key]?.name||p.verifiedName||'';
     input.placeholder='네이버 저장 별명 (예: 고창 차 안)';input.autocomplete='off';
     const memoBox=document.createElement('textarea');memoBox.value=state[p.key]?.memo||'';
     memoBox.placeholder='네이버 즐겨찾기 메모 (예: 아이들과 드라이브 중 촬영)';
     memoBox.rows=2;memoBox.style.cssText='border:1px solid #d7dce2;padding:10px;border-radius:10px;font:inherit;width:100%;box-sizing:border-box';
     input.addEventListener('change',()=>{state[p.key]={...(state[p.key]||{}),name:input.value.trim()};save();});
     memoBox.addEventListener('change',()=>{state[p.key]={...(state[p.key]||{}),memo:memoBox.value.trim()};save();});
     const buttons=document.createElement('div');buttons.className='fj-naver-actions';
     const lookup=document.createElement('button');lookup.textContent='상세 주소 조회';lookup.onclick=()=>{
       lookup.disabled=true;lookup.textContent='주소 확인 중…';
       reverse(p,value=>{lookup.disabled=false;lookup.textContent='상세 주소 조회';
         if(value.address){state[p.key]={...(state[p.key]||{}),address:value.address};save();render();}
         else alert('주소 조회 결과가 없습니다. GPS 좌표로 네이버지도에서 장소를 확인해 주세요.');
       });
     };
     const search=document.createElement('button');search.textContent='주소로 네이버지도 검색';search.onclick=()=>{
       if(p.address){open(naverSearch(p));return;}
       reverse(p,value=>{if(value.address){state[p.key]={...(state[p.key]||{}),address:value.address};save();open(naverSearch({...p,address:value.address}));}
         else alert('상세 주소를 조회하지 못했습니다. 먼저 위치정보를 확인해 주세요.');});
     };
     const done=document.createElement('button');done.textContent=p.status==='CONFIRMED'?'저장 확인 취소':'즐겨찾기 저장 확인';done.onclick=()=>{
       if(p.status==='CONFIRMED')setStatus(p,'REVIEW',input.value.trim());
       else if(!input.value.trim()){alert('남원 같은 시 이름이 아닌, 네이버지도에서 확인한 실제 장소명을 적어 주세요.');return;}
       else if(confirm('네이버지도 계정의 저장 목록에 해당 장소가 실제 등록된 것을 확인했나요?'))setStatus(p,'CONFIRMED',input.value.trim());
       render();
     };
     const photosBtn=document.createElement('button');
     photosBtn.textContent='이곳 사진 '+(p.photoIds||[]).length+'장 보기';
     photosBtn.style.cssText='background:#e7f2ff;color:#2179da';
     photosBtn.onclick=()=>showPhotos(p);
     buttons.prepend(photosBtn);
     const saveAuto=document.createElement('button');saveAuto.textContent='주소로 저장 + 메모 (실험)';
     saveAuto.style.cssText='background:#e2f8ef;color:#12855f';
     saveAuto.onclick=()=>startNativeSave(p,input,memoBox);
     buttons.append(lookup,search,saveAuto,done);div.append(heading,meta,adr,input,memoBox,buttons);list.append(div);
   }
   $('#fj-naver-export').onclick=()=>exportList(rows);
 }
 function setup(){if($('#fj-naver-panel'))return true;
   const settings=document.querySelector('section[data-page="settings"]');if(!settings)return false;
   const section=document.createElement('section');section.id='fj-naver-panel';section.className='section';
   section.innerHTML='<div class="section-title">네이버지도 · 사진 GPS 정밀 장소</div><p class="caption">남원/전주 같은 시 단위가 아니라 사진마다 원래 GPS를 약 25m 단위로 묶어 실제 카페·숙소·관광지를 찾습니다. 상세 주소 조회는 사용자가 누를 때에만 Android 위치정보 서비스에 해당 좌표를 전달할 수 있습니다. 장소명은 네이버에서 확인해야 합니다. GPS 상세주소를 네이버지도에서 검색하고, 개인 별명·메모를 저장하도록 보조합니다. 저장 성공은 네이버 화면 확인 후에만 인정합니다.</p><p class="caption" id="fj-naver-summary">위치 분석 대기</p><p class="caption" id="fj-naver-notice" aria-live="polite">자동 저장 보조는 사용자가 정확한 네이버 장소를 선택해야 합니다. 자동 저장 성공은 실제 네이버 확인 화면을 읽은 경우에만 표시합니다.</p><button type="button" class="btn secondary" id="fj-naver-refresh">정밀 장소 다시 읽기</button> <button type="button" class="btn secondary" id="fj-naver-export">후보 내보내기</button><div id="fj-naver-items" style="max-height:560px;overflow:auto;margin-top:14px"></div>';
   settings.appendChild(section);const style=document.createElement('style');
   style.textContent='.fj-naver-row{padding:14px 4px;border-bottom:1px solid #e5e7ed;display:flex;flex-direction:column;gap:7px}.fj-naver-row b{font-size:16px}.fj-naver-row small{color:#7e8a99}.fj-naver-row input{border:1px solid #d7dce2;padding:10px;border-radius:10px;font:inherit;max-width:100%}.fj-naver-actions{display:flex;flex-wrap:wrap;gap:8px}.fj-naver-actions button{background:#eef3f9;border:0;border-radius:10px;padding:10px;color:#3779c8;font-weight:700}';document.head.appendChild(style);
   $('#fj-naver-refresh').onclick=render;render();return true;
 }
 if(typeof document!=='undefined'){
   if(document.readyState==='loading')document.addEventListener('DOMContentLoaded',setup);else setup();
   setInterval(()=>{if(setup())render();},60000);
   document.addEventListener('visibilitychange',()=>{
     if(document.visibilityState==='visible'&&document.querySelector('#fj-naver-panel'))
       bridge('naverStatus',{});
   });
   setInterval(()=>{if(document.visibilityState==='visible' && document.querySelector('#fj-naver-panel'))bridge('naverStatus',{});},4500);
 }
 root.FamilyJourneyNaver={build,sourceRows,candidates,naverSearch,key,km,setStatus,render,reverse,showPhotos,openFullGallery:openInternalFullGallery,diaryDraftForGPS,saveFromDiaryGps};
 root.__fjBackOverlay=function(){
   const viewer=document.querySelector('#fj-naver-photo-full');
   if(viewer){viewer.remove();return true;}
   const sheet=document.querySelector('#fj-naver-photo-sheet');
   if(sheet){sheet.remove();return true;}
   return false;
 };
 })(typeof window!=='undefined'?window:globalThis);
