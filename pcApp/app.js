'use strict';const T=new URLSearchParams(location.search).get('token');const $=s=>document.querySelector(s);
const now=new Date();let mode='curated',month=new Date(now.getFullYear(),now.getMonth(),1),day=now.toLocaleDateString('sv-SE'),current=null,photos=[],sel=new Set(),pickMonth=new Date(month),pickPage=0;
const pad=x=>String(x).padStart(2,'0');const md=d=>d.getFullYear()+'-'+pad(d.getMonth()+1);
const fy=x=>x?String(x).slice(0,10):'';const dayLabel=d=>new Date(d+'T12:00').toLocaleDateString('ko-KR',{year:'numeric',month:'long',day:'numeric',weekday:'long'});
async function api(path,body){const url=path+(path.includes('?')?'&':'?')+'token='+encodeURIComponent(T);const opt=body===undefined?{}:{method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify(body)};const r=await fetch(url,opt);const data=await r.json();if(!r.ok||data.error)throw Error(data.error||r.status);return data}
function alertMsg(msg){$('#toast').textContent=msg;$('#toast').hidden=false;setTimeout(()=>$('#toast').hidden=true,5500)}
function node(tag,cls,text){const n=document.createElement(tag);if(cls)n.className=cls;if(text!==undefined)n.textContent=String(text);return n}
function img(id){const v=document.createElement('img');v.loading='lazy';v.src='/thumb/'+id+'?token='+encodeURIComponent(T);v.onerror=()=>{v.style.opacity='.2'};return v}
function viewMode(m){mode=m;document.querySelectorAll('.nav').forEach(n=>n.classList.toggle('active',n.dataset.mode===m));$('#heading').textContent=m==='curated'?'내가 고른 사진 일기':'자동 사진 달력';refresh()}
function moveMonth(n){month=new Date(month.getFullYear(),month.getMonth()+n,1);refresh()}
async function refresh(){const mm=md(month),out=await api('/api/month?month='+mm+'&mode='+mode);$('#monthTitle').textContent=month.getFullYear()+'년 '+(month.getMonth()+1)+'월';const calendar=$('#calendar');calendar.replaceChildren();const map=new Map(out.days.map(x=>[x.day,x]));const first=new Date(month.getFullYear(),month.getMonth(),1).getDay();const count=Math.ceil((first+new Date(month.getFullYear(),month.getMonth()+1,0).getDate())/7)*7;
for(let i=0;i<count;i++){const d=new Date(month.getFullYear(),month.getMonth(),i-first+1),ds=md(d)+'-'+pad(d.getDate()),x=map.get(ds);const b=node('button','day'+(d.getMonth()!==month.getMonth()?' other':'')+(ds===day?' selected':''));b.append(node('strong','',d.getDate()));if(x){if(x.cover)b.prepend(img(x.cover));b.append(node('span','count',x.count+'장'))}b.onclick=()=>{day=ds;if(d.getMonth()!==month.getMonth())month=new Date(d.getFullYear(),d.getMonth(),1);refresh();};calendar.append(b)}
await openDay()}
async function openDay(){let data=await api('/api/day?day='+day+'&mode='+mode);current=data.record;photos=data.photos;$('#dayTitle').textContent=dayLabel(day);$('#dayCaption').textContent=mode==='curated'?'선택한 사진 · 독립 일기':'촬영일 자동 분류 · 독립 일기';$('#dayCount').textContent=photos.length+'장';$('#title').value=current?.title||'';$('#body').value=current?.body||'';$('#tags').value=current?.tags||'';$('#feeling').value=current?.feeling||'';$('#pick').style.display=mode==='curated'?'':'none';const el=$('#photos');el.replaceChildren();if(!photos.length)el.append(node('div','empty',mode==='curated'?'아직 선택한 사진이 없어요. 사진을 골라 일기를 만들어 보세요.':'해당 날짜에 색인된 사진이 없습니다.'));else for(const p of photos.slice(0,140))el.append(img(p.id));if(photos.length>140)el.append(node('div','empty','총 '+photos.length+'장 · 처음 140장 표시'));}
async function save(){try{await api('/api/save',{day,mode,title:$('#title').value,body:$('#body').value,tags:$('#tags').value,feeling:$('#feeling').value,photoIds:mode==='curated'?photos.map(p=>p.id):[],activities:current?.activities||{}});alertMsg('이 날짜의 '+(mode==='curated'?'선택 일기':'자동 사진 일기')+'를 저장했습니다.');refresh()}catch(e){alertMsg('저장 실패: '+e.message)}}
async function remove(){if(!confirm('이 날짜의 '+(mode==='curated'?'선택':'자동')+' 일기만 삭제할까요? PC 원본 사진은 삭제하지 않습니다.'))return;try{await api('/api/delete',{day,mode});refresh()}catch(e){alertMsg(e.message)}}

function pickerOpen(){if(mode!=='curated')return;sel=new Set(photos.map(p=>Number(p.id)));pickMonth=new Date(month);pickPage=0;$('#pickerOverlay').hidden=false;drawPicker()}
async function drawPicker(){const mm=md(pickMonth);$('#pickerMonth').textContent=pickMonth.getFullYear()+'년 '+(pickMonth.getMonth()+1)+'월';$('#selectedCount').textContent='선택 '+sel.size+'장';const result=await api('/api/photos?month='+mm+'&page='+pickPage),grid=$('#pickerGrid');grid.replaceChildren();let last='';
for(const p of result.photos){if(p.day!==last){grid.append(node('h3','',dayLabel(p.day)));last=p.day}const b=node('button','picker-card'+(sel.has(p.id)?' selected':''));b.append(img(p.id),node('b','',p.time));b.title=p.day+' '+p.time;b.onclick=()=>{sel.has(p.id)?sel.delete(p.id):sel.add(p.id);b.classList.toggle('selected',sel.has(p.id));$('#selectedCount').textContent='선택 '+sel.size+'장'};grid.append(b)}
$('#pMore').disabled=result.photos.length<120}
function shiftPick(n){pickMonth=new Date(pickMonth.getFullYear(),pickMonth.getMonth()+n,1);pickPage=0;drawPicker()}
function pickerDone(){photos=[...sel].map(id=>({id}));$('#pickerOverlay').hidden=true;const gal=$('#photos');gal.replaceChildren();for(const p of photos.slice(0,140))gal.append(img(p.id));$('#dayCount').textContent=photos.length+'장';alertMsg('선택한 사진 '+photos.length+'장입니다. 일기 저장 버튼을 누르면 반영됩니다.')}
async function scan(){try{const r=await api('/api/scan',{});if(r.selected)alertMsg('PC 폴더를 선택했어요. 촬영일 분석 중…');}catch(e){alertMsg('폴더 검색 오류: '+e.message)}}
async function importFile(){try{const r=await api('/api/import',{});if(r.message){alertMsg(r.message);refresh()}}catch(e){alertMsg('일기 가져오기 실패: '+e.message)}}
async function exportFile(){if(!confirm('이 PC에서 작성한 일기와 선택한 사진을 ZIP으로 묶습니다. 원본 사진의 용량만큼 파일이 커질 수 있어요. 계속할까요?'))return;try{const r=await api('/api/export',{});if(r.ok)alertMsg('동기화 ZIP 내보내기 완료: '+r.records+'건의 일기, '+r.photos+'장 사진')}catch(e){alertMsg('백업 오류: '+e.message)}}
async function poll(){try{const r=await api('/api/status');$('#status').textContent='PC 사진 '+r.photos.toLocaleString('ko-KR')+'장 · 일기 '+r.diaries+'건 · '+r.message;const prev=poll.last||false;if(prev&&!r.scanning)refresh();poll.last=r.scanning}catch(e){$('#status').textContent='상태 확인 실패: '+e.message}}
document.querySelectorAll('.nav').forEach(n=>n.onclick=()=>viewMode(n.dataset.mode));
$('#prev').onclick=()=>moveMonth(-1);$('#next').onclick=()=>moveMonth(1);
$('#today').onclick=()=>{month=new Date(now.getFullYear(),now.getMonth(),1);day=now.toLocaleDateString('sv-SE');refresh()};
$('#save').onclick=save;$('#delete').onclick=remove;$('#pick').onclick=pickerOpen;
$('#scan').onclick=scan;$('#import').onclick=importFile;$('#export').onclick=exportFile;
$('#quit').onclick=async()=>{if(confirm('FamilyJourney PC 앱을 종료할까요? 작성 중인 내용은 먼저 저장해 주세요.')){try{await api('/api/quit',{});document.body.innerHTML='<main><h1>FamilyJourney PC 종료됨</h1><p>안전하게 종료했습니다. 이 창을 닫아도 됩니다.</p></main>'}catch(e){alertMsg(e.message)}}};
$('#pPrev').onclick=()=>shiftPick(-1);$('#pNext').onclick=()=>shiftPick(1);
$('#pMore').onclick=()=>{pickPage++;drawPicker()};$('#pickerDone').onclick=pickerDone;
$('#pickerClose').onclick=()=>$('#pickerOverlay').hidden=true;
window.addEventListener('keydown',e=>{if(e.key==='Escape')$('#pickerOverlay').hidden=true});
refresh().catch(e=>alertMsg('달력 불러오기 실패: '+e.message));poll();setInterval(poll,2500);
