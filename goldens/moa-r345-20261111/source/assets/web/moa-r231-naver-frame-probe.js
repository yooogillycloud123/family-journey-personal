(() => {
'use strict';
if (window.__MOA_NAVER_WEB_PROBE_V1__) return;
Object.defineProperty(window, '__MOA_NAVER_WEB_PROBE_V1__', {value:true});
const ALLOWED = new Set([
'https://map.naver.com',
'https://pcmap.place.naver.com',
'https://pages.map.naver.com'
]);
if (!ALLOWED.has(location.origin)) return;
const bridge = window.MoaNaverProbeBridge;
if (!bridge || typeof bridge.postMessage !== 'function') return;
const MAX_REPORTS = 8;
const SELECTORS = Object.freeze({
saveButton: 'a[data-nlog-area="map_btp.save"], a.D_Xqt[aria-pressed], button.btn_favorite[aria-pressed], a[aria-label*="저장"][aria-pressed],button[aria-label*="저장"][aria-pressed]',
saveDialogList: 'button.swt-save-group-info',
saveCommit: 'button.swt-save-btn',
addMemo: 'button.swt-save-add-info-btn',
createList: 'button.swt-create-list, button[aria-label="새 리스트 만들기"]',
listTitle: 'input.swt-input-text',
saveListConfirm: 'button.swt-complete-btn',
resultRow: 'li.UEzoS, li.VLTHu'
});
let reports = 0, ended = false, mutations = 0, scheduled = false;
let prevSignature = '';
const expiresAt = performance.now() + 30000;
function report() {
if (ended || reports >= MAX_REPORTS || performance.now() > expiresAt || !document.querySelectorAll) {stop();return;}
const counts = {};
for (const [key, selector] of Object.entries(SELECTORS)) {
try { counts[key] = Math.min(99, document.querySelectorAll(selector).length); }
catch (_) { counts[key] = -1; }
}
const signature = JSON.stringify(counts);
if (signature === prevSignature && reports > 0) return;
prevSignature = signature; reports++;
const payload = {
schema: 'moa.naver.web.probe.v1', kind: 'ELEMENT_COUNTS',
origin: location.origin, isTopFrame: window === window.top,
counts, tsElapsedMs: Math.max(0, Math.floor(performance.now()))
};
try { bridge.postMessage(JSON.stringify(payload)); } catch (_) {}
if (reports >= MAX_REPORTS) stop();
}
let observer;
function stop() {ended=true; if(observer)observer.disconnect();}
if (document.readyState === 'loading') document.addEventListener('DOMContentLoaded', report, {once:true});
else report();
try {
observer = new MutationObserver(() => {
if (ended || ++mutations >= 100) {stop();return;}
if (scheduled) return;
scheduled=true;
setTimeout(() => {scheduled=false;report();}, 250);
});
observer.observe(document.documentElement || document, {childList:true,subtree:true});
} catch (_) {}
window.addEventListener('pagehide',stop,{once:true});
})();
/* MOA R333: actual user's 2026-10-25 PC Playwright source port.
   Scoped NAVER DOM only; no private APIs, no tokens, no credential handling.
   Source-only logic still needs physical Galaxy/NAVER account testing. */
(()=>{'use strict';
const ORIGINS=new Set(['https://map.naver.com','https://pages.map.naver.com','https://pcmap.place.naver.com']);
if(!ORIGINS.has(location.origin))return;
// R341: document-start scripts and WebMessageListener can initialize in either order.
// Wait for the origin-restricted bridge instead of silently dropping the entire writer.
const boot=()=>{if(window.__MOA_R341_WRITER_STARTED__)return;
 if(!window.MoaNaverProbeBridge)return false;
 window.__MOA_R341_WRITER_STARTED__=true;
 const root=window===window.top&&location.origin==='https://map.naver.com';
const KEY='moa.r345.task',LIFE=115000;
const norm=x=>String(x??'').normalize('NFKC').replace(/\s+/g,' ').trim();
// Ported faithfully from user's working PC matching.py (province tokens + full road/lot number).
const PROV={'서울':'서울특별시','서울시':'서울특별시','부산':'부산광역시','부산시':'부산광역시','대구':'대구광역시','대구시':'대구광역시','인천':'인천광역시','인천시':'인천광역시','광주':'광주광역시','대전':'대전광역시','대전시':'대전광역시','울산':'울산광역시','울산시':'울산광역시','세종':'세종특별자치시','세종시':'세종특별자치시','경기':'경기도','강원':'강원특별자치도','강원도':'강원특별자치도','충북':'충청북도','충남':'충청남도','전북':'전북특별자치도','전라북도':'전북특별자치도','전남':'전라남도','경북':'경상북도','경남':'경상남도','제주':'제주특별자치도','제주도':'제주특별자치도'};
const normalize=x=>norm(x).replace(/[\s.,()\[\]·ㆍ]/g,'').toLowerCase();
function searchAddr(v){let x=norm(v).replace(/^(?:(?:대한민국|한국|South Korea|Republic of Korea)\s+)+/i,'').replace(/^(?:(?:\(?\s*(?:도로명\s*주소|도로명|주소)\s*\)?\s*[:：]?\s*)|(?:\(?\d{5}\)?\s*))+/, '')
 .replace(/([가-힣])\s+(\d+[가-힣]*?(?:로|길))/g,'$1$2');
 let w=x.split(' ');if(PROV[w[0]])w[0]=PROV[w[0]];x=w.join(' ');
 const m=x.match(/^(.+?)\s+([^\s,()]+(?:대로|로|길))\s*(\d+(?:-\d+)?)(?=(?:번지)?(?:\s|,|\(|$))/);
 return m?[m[1],m[2],m[3]].join(' '):x}
function roadParts(v){const t=searchAddr(v),m=t.match(/^(.+?)\s+([^\s]+(?:대로|로|길))\s+(\d+(?:-\d+)?)(?=\s|,|\(|$)/);
 return m?[m[1].split(' '),normalize(m[2]),m[3]]:null}
function addrKey(v){let t=searchAddr(v),m=t.match(/^(.+?(?:대로|로|길)\s+\d+(?:-\d+)?)(?=\s|,|\(|$)/)||t.match(/^(.+?(?:동|리|가)\s+(?:산\s*)?\d+(?:-\d+)?)(?=\s|,|\(|$)/);
 return normalize(m?m[1]:t)}
function addrEqual(expected,actual){const key=addrKey(expected);if(!key||key.length<7)return false;
 if(key===addrKey(actual))return true;
 const l=roadParts(expected),r=roadParts(actual);if(!l||!r||l[1]!==r[1]||l[2]!==r[2])return false;
 const prefixes=l[0],withProvince=Object.values(PROV).includes(prefixes[0]);
 if(!((withProvince&&prefixes.length>=2)||(prefixes[0]?.endsWith('시')&&prefixes[0]!=='광주시')))return false;
 let i=0;for(const token of r[0])if(token===prefixes[i])i++;
 return i===prefixes.length}
const seen=e=>!!e&&!!e.getBoundingClientRect&&e.getBoundingClientRect().width>=2&&e.getBoundingClientRect().height>=2&&getComputedStyle(e).visibility!=='hidden';
const click=e=>{if(!seen(e)||e.disabled)return false;e.click();return true};
const statusSet=new Set(['QUEUED','SEARCHING','PLACE_AMBIGUOUS','LIST_UI_NOT_FOUND','NAVER_UI_CHANGED','SAVE_SUBMITTED_UNVERIFIED','NAVER_READBACK_VERIFIED','READBACK_UNAVAILABLE','LIST_READY','LOGIN_REQUIRED','EXISTING_PLACE_UNVERIFIED']);
let job=null,busy=false,lastStatus='',started=false,childWorking=false,lastFolderClickAt=0;
const phoneStatus=(status,verified=false)=>{if(!root||!job||!statusSet.has(status)||(status===lastStatus&&!verified))return;
 lastStatus=status;try{window.MoaNaverProbeBridge.postMessage(JSON.stringify({schema:'moa.naver.web.probe.v1',kind:'PHONE_STATUS',status,jobId:job.jobId,readbackMatched:!!verified}))}catch(_){}};
const store=()=>{if(root&&job)try{sessionStorage.setItem(KEY,JSON.stringify(job))}catch(_){}};
const fail=s=>{phoneStatus(s);if(root)try{sessionStorage.removeItem(KEY)}catch(_){}job=null};
const send=(code,extras={})=>{if(root){handleResult({code,jobId:job?.jobId,nonce:job?.nonce,...extras},window,location.origin);return}
 try{window.top.postMessage({r333:1,code,jobId:job?.jobId,nonce:job?.nonce,...extras},'https://map.naver.com')}catch(_){}};
const folders=()=>[...document.querySelectorAll('iframe')].filter(x=>{try{return ORIGINS.has(new URL(x.src,location.href).origin)}catch(_){return false}});
const forward=(cmd,j,depth=0)=>{if(!j||depth>4)return;for(const f of folders())try{
 f.contentWindow.postMessage({r333:1,cmd,job:j,depth:depth+1},new URL(f.src,location.href).origin)
 }catch(_){}};
const tellChildren=(cmd)=>{if(root&&job)forward(cmd,job)};
const value=(x,v)=>{if(!x)return false;const proto=x.tagName==='TEXTAREA'?HTMLTextAreaElement.prototype:HTMLInputElement.prototype;
 const setter=Object.getOwnPropertyDescriptor(proto,'value')?.set;if(!setter)return false;setter.call(x,v);x.dispatchEvent(new Event('input',{bubbles:true}));x.dispatchEvent(new Event('change',{bubbles:true}));return norm(x.value)===norm(v)};
// PC source: .address_info_area .address_title (NOT h1/h2/h3).
function detail(){const v=[...document.querySelectorAll('.address_info_area .address_title')].filter(seen);
 return v.length===1&&job&&addrEqual(v[0].textContent,job.address)?v[0]:null}
function result(){if(!job)return null;const all=[...document.querySelectorAll('li[role="option"] .search_result_title')].filter(seen);
 const matched=all.filter(e=>addrEqual(e.textContent,job.address));return matched.length===1?matched[0]:null}
// PC source: .btn_favorite:visible in a VERIFIED address detail, not global .btn_navbar.
function star(){if(job?.addressOnly&&!detail())return null;
 if(!job?.addressOnly){if(window.name!=='entryIframe'||!verifiedPoi())return null;const b=[...document.querySelectorAll('[role=\"checkbox\"],[aria-label*=\"저장\"],button[aria-pressed]')].filter(e=>seen(e)&&/(?:저장|save)/i.test([e.getAttribute('aria-label'),e.getAttribute('title'),e.textContent].join(' '))&&e.getAttribute('aria-pressed')!=='true');return b.length===1?b[0]:null}
const b=[...document.querySelectorAll('.btn_favorite')].filter(seen);
 const unique=[...new Set(b)].filter(x=>!/(?:on|active|saved|checked)/.test(String(x.className).split(/\s+/).filter(y=>y!=='btn_favorite').join(' '))&&x.getAttribute('aria-pressed')!=='true'&&x.getAttribute('aria-checked')!=='true');
 if(unique.length===1)return unique[0];
 const inPanel=unique.filter(x=>!!x.closest?.('.scroll_box,.address_info_area'));
 if(inPanel.length===1)return inPanel[0];
 // PC Playwright fallback: exact single saved-state button in address scroll box.
 const panel=[...document.querySelectorAll('.scroll_box')].filter(seen);
 if(panel.length!==1)return null;
 const alt=[...panel[0].querySelectorAll('button,[role=button]')].filter(seen).filter(x=>/^(?:저장|저장됨)$/.test(norm(x.getAttribute('aria-label')||x.textContent))&&x.getAttribute('aria-pressed')!=='true');
 return alt.length===1?alt[0]:null}
function verifiedPoi(){if(!job||!job.placeName||job.addressOnly)return false;const h=[...document.querySelectorAll('h1,[role=heading]')].find(x=>norm(x.textContent)===job.placeName);if(!h)return false;const text=norm(document.body?.innerText||'');return text.includes(job.address)||addrEqual(text.split('주소').pop().slice(0,110),job.address)}
function poiResult(){if(!job||job.addressOnly||window.name!=='searchIframe')return null;const pool=[...document.querySelectorAll('a[href*=\"/place/\"],button')].filter(seen).filter(e=>norm(e.textContent).includes(job.placeName));if(job.placeId){return pool.filter(e=>String(e.getAttribute('href')||'').includes('/'+job.placeId));}return pool.length===1?pool:[]}
function modal(){const list=[...document.querySelectorAll('.swt-save-modal')].filter(seen);return list.length===1?list[0]:null}
function widgetRows(m){if(!m)return[];return[...m.querySelectorAll('.swt-save-group-item')].map((e,i)=>{
 const name=norm([...e.querySelector('.swt-save-group-name')?.childNodes||[]].filter(n=>n.nodeType===3).map(n=>n.textContent).join(''))||norm(e.querySelector('.swt-save-group-name')?.textContent).replace(/^폴더명/,'');
 const count=Number((e.querySelector('.swt-save-group-count')?.textContent||'').replace(/[^\d]/g,''));
 const state=norm(e.querySelector('.swt-save-group-check-area .swt-blind')?.textContent);return {el:e,name,count,state,checkbox:e.querySelector('[role="checkbox"],input[type="checkbox"]'),index:i};})}
function findRow(m){const rows=widgetRows(m).filter(r=>r.name===job.listName);if(rows.length>1)return {error:'DUPLICATE'};return rows.length?rows[0]:null}
function metadata(m){if(!job)return false;if((job.alias&&!seen(m.querySelector('#swt-save-input-listview-nickname')))||(job.memo&&!seen(m.querySelector('#swt-save-input-listview-memo')))){const more=m.querySelector('.swt-save-add-info-btn');if(more&&seen(more))click(more);}
 for(const [s,v] of [['#swt-save-input-listview-nickname',job.alias],['#swt-save-input-listview-memo',job.memo]]){
  if(!v)continue;const e=m.querySelector(s);if(!seen(e))return false;
  if(norm(e.value)&&norm(e.value)!==norm(v))return false;if(!value(e,v))return false;
 }return true}
function stageDialog(){const m=modal();if(!m||!job||job.commitAttempted)return false;
 send('DIALOG_OBSERVED');if(!metadata(m))return false;
 const row=findRow(m);
 if(row?.error){send('AMBIGUOUS_FOLDER');return true}
 if(!row){const list=m.querySelector('.swt-save-group-list');if(!list||!seen(list)||!m.querySelector('.swt-save-group-item'))return false;send('FOLDER_MISSING');return true}
 if(!['선택됨','선택해제됨'].includes(row.state)){send('UI_CHANGED');return true}
 if(row.state==='선택해제됨'){if(!lastFolderClickAt){if(!click(row.checkbox))return false;lastFolderClickAt=Date.now()}else if(Date.now()-lastFolderClickAt>3500)send('UI_CHANGED');return false}
 if(job.alias&&norm(m.querySelector('#swt-save-input-listview-nickname')?.value)!==norm(job.alias))return false;
 if(job.memo&&norm(m.querySelector('#swt-save-input-listview-memo')?.value)!==norm(job.memo))return false;
 const commit=m.querySelector('button.swt-save-btn');if(!seen(commit)||commit.disabled)return false;
 send('PREPARED');return true}
function currentListCards(){const all=[...document.querySelectorAll('button')].filter(b=>/저장된 장소 수/.test(b.getAttribute('aria-label')||b.textContent));
 return all.map(b=>({el:b,name:norm(b.querySelector('span[class^="_name_"]')?.textContent),count:Number((b.querySelector('[class*="_count_"]')?.textContent||'').replace(/[^\d]/g,''))}))}
function selectExistingList(){const cards=currentListCards().filter(c=>c.name===job.listName);
 if(cards.length>1){send('AMBIGUOUS_FOLDER');return true}
 if(cards.length===1){if(click(cards[0].el))send('FOLDER_OPEN_REQUESTED');return true}
 return false}
function createFolder(){if(!job||job.folderCreateAttempted)return false;
 // PC _folder_cards() scrolls until ALL account-owned folder cards are present.
 // Incomplete lazy loading is NOT proof that a list is missing: no duplicate creation.
 if(seen(document.querySelector('#swt-save-input-folderview-list')))return false;
 const own=[...document.querySelectorAll('button')].find(x=>/내가 만든 리스트/.test(x.textContent||''));
 if(!seen(own))return false;
 if(own.getAttribute('aria-pressed')!=='true'){click(own);return false}
 const cards=currentListCards(),n=norm(own.textContent).match(/\d+/),expected=n?Number(n[0]):NaN;
 if(!Number.isFinite(expected)||expected<0||cards.length!==expected){
  if(cards.length&&cards.length<expected)try{cards[cards.length-1].el.scrollIntoView({block:'end'})}catch(_){};
  return false}
 const matches=cards.filter(c=>c.name===job.listName);
 if(matches.length>1){send('AMBIGUOUS_FOLDER');return true}
 if(matches.length===1){send('FOLDER_EXISTS');return true}
 const b=[...document.querySelectorAll('button')].filter(x=>norm(x.textContent)==='새 리스트 만들기');
 if(b.length!==1||!seen(b[0]))return false;click(b[0]);send('FOLDER_CREATE_FORM_OPEN');return true}
function finishFolderCreation(){if(!job||job.listName.length>20){send('UI_CHANGED');return false}const f=document.querySelector('#swt-save-input-folderview-list');if(!seen(f))return false;
 if(!value(f,job.listName))return false;const r=document.querySelector('input[type="radio"][value="private"]');
 if(!r)return false;if(!r.checked){const wrap=r.parentElement;click(wrap)}if(!r.checked)return false;
 const done=document.querySelector('.swt-complete-btn');if(!seen(done)||done.disabled)return false;send('FOLDER_CREATE_READY');return true}
function verifyCard(){const cards=[...document.querySelectorAll('div[class^="_card_area_"]')];
 const found=cards.filter(e=>{const title=e.querySelector('strong[class^="_main_title_"]')?.textContent||'';
 const ad=[title,...[...e.querySelectorAll('span[class^="_place_info_item_"]')].map(x=>x.textContent)];
 return ad.some(a=>addrEqual(a,job.address))&&(!job.alias||norm(e.querySelector('em[class^="_displayname_"]')?.textContent)===norm(job.alias))&&
 (!job.memo||norm(e.querySelector('span[class^="_memo_text_"]')?.textContent)===norm(job.memo));});
 if(!job.commitClickedAt||!job.folderOpenAttempted||!job.folderId)return false;
 if(found.length===1)send('READBACK_OK');else if(found.length>1)send('READBACK_AMBIGUOUS');return found.length>0}
async function child(cmd){if(!job||childWorking)return;childWorking=true;
 try{
 if(cmd==='SEARCH'){if(job.addressOnly){if(detail())send('DETAIL_READY');else if(result()){if(click(result()))send('RESULT_OPENED')}}else if(window.name==='entryIframe'&&verifiedPoi())send('DETAIL_READY');else{const xs=poiResult();if(xs?.length===1&&click(xs[0]))send('RESULT_OPENED')}}
 if(cmd==='STAR'&&((job.addressOnly&&detail())||(!job.addressOnly&&verifiedPoi()))){const b=star();if(b)send('STAR_READY')}
 if(cmd==='CLICK_STAR'&&((job.addressOnly&&detail())||(!job.addressOnly&&verifiedPoi()))){const b=star();if(b&&click(b))send('STAR_CLICKED')}
 if(cmd==='DIALOG'){stageDialog()}
 if(cmd==='COMMIT'){const m=modal();if(m&&job.commitAttempted){const r=findRow(m);const b=m.querySelector('button.swt-save-btn');
  if(r&&r.state==='선택됨'&&metadata(m)&&seen(b)&&!b.disabled&&click(b))send('COMMIT_CLICKED');else send('UI_CHANGED')}}
 if(cmd==='FOLDER_CREATE'){createFolder();finishFolderCreation()}
 if(cmd==='CREATE_ALLOW'&&job.folderCreateAttempted){const f=document.querySelector('#swt-save-input-folderview-list'),b=document.querySelector('.swt-complete-btn');
  if(seen(f)&&norm(f.value)===job.listName&&document.querySelector('input[type="radio"][value="private"]')?.checked&&click(b))send('FOLDER_CREATE_CLICKED');else send('UI_CHANGED')}
 if(cmd==='LIST_PICK'){selectExistingList()}
 if(cmd==='VERIFY_LIST'){verifyCard()}
 }catch(_){send('UI_CHANGED')}finally{childWorking=false}}
function restore(){if(!root)return;try{let j=JSON.parse(sessionStorage.getItem(KEY)||'null');if(j&&j.jobId&&j.startedAt&&Date.now()-j.startedAt<LIFE)job=j;else sessionStorage.removeItem(KEY)}catch(_){}}
function rootAction(){if(!job||busy)return;busy=true;try{
 if(Date.now()-job.startedAt>LIFE){fail('READBACK_UNAVAILABLE');return}
 const path=location.pathname;
 if(job.phase==='SEARCH'){phoneStatus('SEARCHING');const dest='/p/search/'+encodeURIComponent(job.addressOnly?job.address:(job.placeName+' '+job.address));
  if(!path.startsWith('/p/search/')){store();location.replace('https://map.naver.com'+dest);return}
  if(job.addressOnly&&detail()){job.phase='STAR';store()}else if(job.addressOnly&&result()){if(!job.resultOpened&&click(result())){job.resultOpened=true;store()}}else tellChildren('SEARCH')}
 else if(job.phase==='STAR'){if(job.addressOnly&&detail()&&!job.starAttempted){const b=star();if(b){if(click(b)){job.starAttempted=true;job.starClickedAt=Date.now();job.phase='DIALOG';store()}else fail('NAVER_UI_CHANGED')}else tellChildren('STAR')}
  else tellChildren('STAR')}
 else if(job.phase==='DIALOG'){if(modal())stageDialog();tellChildren('DIALOG');if(job&&job.starClickedAt&&!job.modalSeenAt&&Date.now()-job.starClickedAt>18000)fail('NAVER_UI_CHANGED')}
 else if(job.phase==='CREATE_LIST'){if(!path.startsWith('/p/favorite/myPlace')){store();location.replace('https://map.naver.com/p/favorite/myPlace');return}tellChildren('FOLDER_CREATE')}
 else if(job.phase==='WAIT_CREATED'){if(!path.startsWith('/p/favorite/myPlace')){store();location.replace('https://map.naver.com/p/favorite/myPlace');return}tellChildren('LIST_PICK')}
 else if(job.phase==='RESUME'){job.phase='SEARCH';job.resultOpened=false;job.starAttempted=false;job.modalSeenAt=0;job.starClickedAt=0;store();}
 else if(job.phase==='COMMIT_WAIT'){if(!job.commitClickedAt&&Date.now()-job.commitAt>10000){fail('READBACK_UNAVAILABLE');return}}
 else if(job.phase==='VERIFY_LIST'){if(!job.commitClickedAt){fail('READBACK_UNAVAILABLE');return}if(!path.startsWith('/p/favorite/myPlace')){store();location.replace('https://map.naver.com/p/favorite/myPlace');return}
  if(/\/folder\//.test(path)){job.folderId=decodeURIComponent(path.split('/folder/')[1].split(/[?#]/)[0]);store();tellChildren('VERIFY_LIST')}
  else tellChildren('LIST_PICK')}
 }catch(_){phoneStatus('NAVER_UI_CHANGED')}finally{busy=false}}
function handleResult(d,source,origin){
 if(d.code==='RESULT_OPENED'){job.resultOpened=true;store()}
 if(d.code==='DIALOG_OBSERVED'&&job.phase==='DIALOG'&&!job.modalSeenAt){job.modalSeenAt=Date.now();store()}
 if(d.code==='DETAIL_READY'&&job.phase==='SEARCH'){job.phase='STAR';store()}
 if(d.code==='STAR_READY'&&job.phase==='STAR'&&!job.starAttempted){job.starAttempted=true;job.starClickedAt=Date.now();job.phase='DIALOG';store();source===window?child('CLICK_STAR'):source.postMessage({r333:1,cmd:'CLICK_STAR',job,depth:0},origin)}
 if(d.code==='FOLDER_MISSING'&&job.phase==='DIALOG'){
  if(job.folderStageAttempted||job.listName.length>20){fail('LIST_UI_NOT_FOUND');return}
  job.folderStageAttempted=true;job.phase='CREATE_LIST';store();rootAction()}
 if(d.code==='AMBIGUOUS_FOLDER'||d.code==='UI_CHANGED'){fail(d.code==='AMBIGUOUS_FOLDER'?'LIST_UI_NOT_FOUND':'NAVER_UI_CHANGED')}
 if(d.code==='PREPARED'&&job.phase==='DIALOG'&&!job.commitAttempted){phoneStatus('LIST_READY');job.commitAttempted=true;job.commitAt=Date.now();job.phase='COMMIT_WAIT';store();source===window?child('COMMIT'):source.postMessage({r333:1,cmd:'COMMIT',job,depth:0},origin)}
 if(d.code==='COMMIT_CLICKED'&&job.phase==='COMMIT_WAIT'&&job.commitAttempted){job.commitClickedAt=Date.now();job.phase='VERIFY_LIST';store();phoneStatus('SAVE_SUBMITTED_UNVERIFIED')}
 if(d.code==='FOLDER_CREATE_READY'&&job.phase==='CREATE_LIST'&&!job.folderCreateAttempted){job.folderCreateAttempted=true;store();source===window?child('CREATE_ALLOW'):source.postMessage({r333:1,cmd:'CREATE_ALLOW',job,depth:0},origin)}
 if(d.code==='FOLDER_CREATE_CLICKED'&&job.phase==='CREATE_LIST'){job.phase='WAIT_CREATED';store()}
 if(d.code==='FOLDER_EXISTS'&&job.phase==='CREATE_LIST'){job.phase='RESUME';store()}
 if(d.code==='FOLDER_OPEN_REQUESTED'&&job.phase==='WAIT_CREATED'){job.phase='RESUME';store()}
 if(d.code==='FOLDER_OPEN_REQUESTED'&&job.phase==='VERIFY_LIST'&&job.commitClickedAt){job.folderOpenAttempted=true;store()}
 if(d.code==='READBACK_OK'&&job.phase==='VERIFY_LIST'&&job.commitClickedAt&&job.folderOpenAttempted&&job.folderId){phoneStatus('NAVER_READBACK_VERIFIED',true);fail()}
 if(d.code==='READBACK_AMBIGUOUS'&&job.phase==='VERIFY_LIST'){fail('READBACK_UNAVAILABLE')}

}
if(root){restore();window.addEventListener('message',e=>{
 const d=e.data||{};
 if(e.source===window&&d.type==='MOA_R237_PHONE_TASK'){
  const t=d.task;if(!t||!t.jobId||!t.address||!t.listName)return;
  if(job&&job.jobId===String(t.jobId))return;
  job={jobId:String(t.jobId),nonce:String(t.jobId)+'-'+String(Math.random()).slice(2),address:norm(t.address),placeName:norm(t.placeName),listName:norm(t.listName),addressOnly:!t.placeName||norm(t.placeName)===norm(t.address),placeId:String(t.placeId||''),alias:norm(t.alias).slice(0,25),memo:norm(t.memo).slice(0,400),startedAt:Date.now(),phase:'SEARCH',commitAttempted:false,folderCreateAttempted:false,starAttempted:false};
  store();phoneStatus('QUEUED');phoneStatus('SEARCHING');rootAction();return}
 if(!ORIGINS.has(e.origin)||d.r333!==1||!job||d.jobId!==job.jobId||d.nonce!==job.nonce||!d.code)return;
 handleResult(d,e.source,e.origin);
 });
 const start=()=>rootAction();if(document.readyState==='loading')document.addEventListener('DOMContentLoaded',start,{once:true});else start();
 setInterval(rootAction,850);return true}
window.addEventListener('message',e=>{if(!ORIGINS.has(e.origin)||e.source!==window.parent||e.data?.r333!==1)return;
 const msg=e.data;if(!msg.job||!msg.job.nonce||Date.now()-msg.job.startedAt>LIFE||msg.depth>4)return;
 job=msg.job;forward(msg.cmd,job,msg.depth||0);child(msg.cmd)});
 return true;};
if(!boot()){let tries=0;const timer=setInterval(()=>{if(boot()||++tries>=60)clearInterval(timer)},100)}
})();
