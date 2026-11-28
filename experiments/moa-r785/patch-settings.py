#!/usr/bin/env python3
"""R783 -> R785 staging: reuse global controls and add native scheduler settings."""
from pathlib import Path
import sys
p=Path(sys.argv[1]);s=p.read_text()
def rep(a,b):
 global s
 assert s.count(a)==1,(s.count(a),a[:140]);s=s.replace(a,b,1)
a=s.index('function mountAutoSettings783(){');b=s.index('function recoverBlocked783(){',a)
s=s[:a]+'''// R785: both surfaces share the existing preferences and account session.
let settings785=null;
const voiceOptions785={accent:[['en-US','미국식'],['en-GB','영국식']],rate:[['0.65','0.65× 느리게'],['0.85','0.85× 천천히'],['1','1× 보통'],['1.2','1.2× 빠르게']],repeat:[['1','1회'],['2','2회'],['3','3회']]};
function preference785(k,value){
 if(k==='model'){
  if(state.job||!state.models.some(m=>m.slug===value))return false;
  state.model=value;prefs.model=value;state.autoChecking=false;sessionBlocked781=false;sessionRetries779=0;state.verified=false;
 }else if(k==='autoModelMode781'){
  if(!['sol','selected'].includes(value))return false;
  prefs[k]=value;state.autoChecking=false;sessionBlocked781=false;sessionRetries779=0;
 }else if(k==='autoPlace'){
  if(value&&!prefs.autoPlace&&!confirm('원본 미디어의 GPS를 OS 위치 검색에 사용하고, 도시·지역 후보만 ChatGPT에 전달합니다. 허용할까요?'))return false;
  prefs[k]=!!value;
 }else if(['background785','wifi785','charge785'].includes(k)){
  if(k==='background785'&&!value)readQueue785();
  prefs[k]=!!value;
 }else if(voiceOptions785[k]?.some(([v])=>v===value)){prefs[k]=value}else{return false}
 const ok=persist771();sync();autoStatus771();if(!Object.keys(voiceOptions785).includes(k))wake783();return ok;
}
function select785(label,values,callback){const s=el('select');s.setAttribute('aria-label',label);for(const [k,t] of values){const o=el('option',t);o.value=k;s.append(o)}s.onchange=()=>{callback(s.value);syncSettings785()};return s}
function syncSettings785(){
 const v=state.view;if(v?.ready&&v.panel.isConnected){for(const k of Object.keys(voiceOptions785))if(v[k]&&v[k].value!==prefs[k])v[k].value=prefs[k];if(v.autoMode785)v.autoMode785.value=prefs.autoModelMode781||'sol';if(v.autoPlace785)v.autoPlace785.checked=!!prefs.autoPlace}
 const z=settings785;if(!z?.li.isConnected)return;
 z.account.textContent=state.connected?(state.verified?'ChatGPT 실제 응답 확인됨':'계정·모델 조회 성공'):'ChatGPT 계정 확인 필요';
 z.login.hidden=state.connected;z.login.disabled=!!state.job;z.refresh.disabled=!!state.job;z.probe.disabled=!!state.job||!state.connected||!state.models.some(m=>m.slug===state.model);
 if(z.revision!==state.modelRevision){const options=state.models.map(m=>{const o=el('option',m.label);o.value=m.slug;return o});if(!options.length){const o=el('option','계정 확인 후 모델 선택');o.value='';options.push(o)}z.model.replaceChildren(...options);z.revision=state.modelRevision}
 z.model.value=state.model;z.model.disabled=!!state.job||!state.models.length;z.mode.value=prefs.autoModelMode781||'sol';z.place.checked=!!prefs.autoPlace;
 for(const k of Object.keys(voiceOptions785))z[k].value=prefs[k];
 for(const k of ['background785','wifi785','charge785'])z[k].checked=!!prefs[k];
 const resolved=autoModel781();z.effective.textContent='실제 자동 생성 모델: '+(state.models.find(m=>m.slug===resolved)?.label||'계정·모델 확인 필요 (자동 전환하지 않음)');
}
function mountAutoSettings783(){
 if(BG785)return;
 const settings=document.querySelector('section.page[data-page="settings"]');
 const list=Array.from(settings?.querySelectorAll('.section')||[]).find(s=>s.querySelector('.section-title')?.textContent.trim()==='앱')?.querySelector('.rows');
 if(!list||document.getElementById('moa-r783-auto-study'))return;
 const li=el('li');li.id='moa-r783-auto-study';li.className='moa-r98-settings';
 const d=el('details','','moa-r99-disclosure'),h=el('summary','자동 학습 설정','moa-r99-summary'),body=el('div','','moa-r98-controls');d.open=false;
 const label=el('label','직접 추가한 달력 자동 학습','moa-r98-control'),toggle=el('input'),info=el('p','','moa-r98-hint');
 toggle.type='checkbox';toggle.id='moa-r783-auto-toggle';toggle.checked=!!prefs.auto;label.append(toggle);info.id='moa-r783-auto-info';toggle.onchange=()=>{if(!setAuto783(toggle.checked))toggle.checked=!!prefs.auto};
 const account=el('p'),login=button('ChatGPT 계정 연결',()=>request('login')),refresh=button('계정 다시 확인',()=>request('session')),probe=button('실제 AI 연결 테스트',()=>request('probe',{model:state.model}));
 const model=select785('AI 모델',[],v=>preference785('model',v));
 const mode=select785('자동 생성 모델',[['sol','GPT-6.2 Sol 우선'],['selected','직접 선택한 AI 모델']],v=>preference785('autoModelMode781',v));
 const effective=el('small'),place=el('input'),placeLabel=el('label','촬영 도시·지역 후보 사용 (관련 있을 때만)','moa-r98-control');place.type='checkbox';placeLabel.append(place);place.onchange=()=>{preference785('autoPlace',place.checked);syncSettings785()};
 const voices={};for(const [k,title] of Object.entries({accent:'발음 지역',rate:'발음 속도',repeat:'반복 재생'}))voices[k]=select785(title,voiceOptions785[k],v=>preference785(k,v));
 const bg={};function check(k,title){const l=el('label',title,'moa-r98-control'),c=el('input');c.type='checkbox';c.checked=!!prefs[k];c.onchange=()=>{preference785(k,c.checked);syncSettings785()};bg[k]=c;l.append(c);return l}
 function field(title,control){const l=el('label',title,'moa-r98-control');l.append(control);return l}
 body.append(label,check('background785','백그라운드 자동 생성 (앱 닫기·화면 잠금 포함)'),check('wifi785','Wi-Fi 연결 시에만 자동 생성'),check('charge785','충전 중에만 자동 생성'),el('small','안드로이드가 예약 작업을 실행하며 연결 복구 후 이어갑니다. 강제 중지·전원 OFF 및 OS 절전 제한은 제외됩니다.'),info,button('보류 작업 다시 확인',()=>retryAll783()),el('strong','AI 연결 및 생성'),account,login,refresh,probe,field('AI 모델',model),field('자동 생성 모델',mode),effective,el('p','자동 생성 과목: 영어 기본 · 전체 7과목'),placeLabel,el('strong','음성 재생 기본값'),field('발음 지역',voices.accent),field('발음 속도',voices.rate),field('반복 재생',voices.repeat),el('small','다음 재생부터 적용됩니다. 자동 학습 카드 내용은 AI 모델과 학습 과목 설정을 따릅니다.'));
 d.append(h,body);li.append(d);list.append(li);settings785={li,account,login,refresh,probe,model,mode,place,effective,revision:-1,...voices,...bg};
 for(const type of ['click','change','input'])li.addEventListener(type,e=>e.stopPropagation());
 d.addEventListener('toggle',()=>{if(d.open){syncSettings785();wake783();autoStatus771();if(!state.connected&&!state.job&&!d.checked785){d.checked785=true;request('session')}}});syncSettings785();
}
'''+s[b:]
rep('function sync(){const v=state.view;','function sync(){syncSettings785();const v=state.view;')
rep('function autoStatus771(){const msg=progress783(),','function autoStatus771(){syncSettings785();const msg=progress783(),')
rep("sel.onchange=()=>{state.model=sel.value;prefs.model=state.model;persist771();state.autoChecking=false;sessionBlocked781=false;sessionRetries779=0;state.verified=false;sync();schedule771()};","sel.onchange=()=>{preference785('model',sel.value);sync()};")
rep("c.onchange=()=>{prefs[k]=c.value;persist771()}","c.onchange=()=>{preference785(k,c.value);syncSettings785()}")
rep("autoMode.onchange=()=>{prefs.autoModelMode781=autoMode.value;persist771();autoStatus771();schedule771()};","autoMode.onchange=()=>{preference785('autoModelMode781',autoMode.value);syncSettings785()};v.autoMode785=autoMode;")
a=s.index('autoPlace.onchange=()=>{if(autoPlace.checked&&!confirm(');b=s.index('autoRow.append(autoLabel',a)
s=s[:a]+"autoPlace.onchange=()=>{preference785('autoPlace',autoPlace.checked);syncSettings785()};v.autoPlace785=autoPlace;"+s[b:]
s=s.replace('let settings785=null;\n','',1)
rep("const PREF771='moa.study.preferences.v771'","let settings785=null;\nconst PREF771='moa.study.preferences.v771'")
p.write_text(s)
print('R785 shared collapsed study settings applied')
