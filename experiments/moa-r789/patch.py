#!/usr/bin/env python3
from pathlib import Path
import sys
web=Path(sys.argv[1]);native=Path(sys.argv[2])
p=web/'moa-r755-inline-ai.js';s=p.read_text()
def rep(a,b,n=1):
 global s
 assert s.count(a)==n,(s.count(a),a[:120]);s=s.replace(a,b,n)
# Old authCheckAfter783 was set before any session request and sometimes never cleared on disk.
# Only a genuine observed failure may set the NEW persisted hold; old ambiguous timestamps ignored.
rep("function bgDelay785(){",r"""const AUTH789='moa.study.auth.failure.v789';
let bgKick789=false;
function authHold789(){try{const x=JSON.parse(localStorage.getItem(AUTH789)||'null');return x&&['auth','quota','transient'].includes(x.kind)&&Number(x.until)>Date.now()?x:null}catch{return null}}
function authUntil789(){return authHold789()?.until||0}
function clearAuth789(){try{localStorage.removeItem(AUTH789)}catch{}prefs.authCheckAfter783=0;sessionBlocked781=false;sessionRetries779=0}
function holdAuth789(kind,message){kind=kind==='quota'?'quota':kind==='auth'?'auth':'transient';const old=authHold789(),until=Date.now()+(kind==='quota'?3600000:kind==='auth'?1800000:60000);if(old?.kind==='quota'&&old.until>until)return;try{localStorage.setItem(AUTH789,JSON.stringify({kind,until,message:String(message||'').slice(0,120)}))}catch{}}
function stopReason789(){const now=Date.now(),hold=authHold789(),t=tally783();if(!prefs.auto||!prefs.background785)return '자동 생성 OFF';if(scopeError783)return '등록 확인 오류 · '+scopeError783;if(Number(prefs.quotaUntil783)>now||hold?.kind==='quota')return 'AI 사용량 제한 해제 대기';if(!state.connected&&hold)return (hold.kind==='auth'?'계정 인증 확인 대기':'계정 연결 재시도 대기')+' · '+hold.message;if(state.connected&&!autoModel781())return '선택한 AI 모델 확인 필요';if(t&&t.done===t.total)return '직접 등록 학습 모두 완료';return '다음 생성 대상 / 재시도 대기'}
function bgDelay785(){""")
rep("if(!state.connected&&Number(prefs.authCheckAfter783)>now)return Math.max(1000,prefs.authCheckAfter783-now);","if(!state.connected&&authUntil789()>now)return Math.max(1000,authUntil789()-now);")
rep("function backgroundTick785(){",r"""function backgroundNotice789(){const t=tally783(),j=state.job;return (j?.op==='generate'?(j.nativeSeen789?'학습 생성 · ':'학습 요청 준비 · ')+lastStatus777:j?.op==='session'?'AI 계정과 모델 확인 중':stage787)+(t?' · 완료 '+t.done+'/'+t.total:'')}
function invalidateScope789(){scanDirty783=true;bgScopeReady785=false}
function backgroundTick785(){""")
rep("if(bgProcessed785)return 'done:'+Math.max(1000,bgDelay785());","// Continue the next registered job in the same bounded OS worker/session.")
rep("if(scopeError783||Number(prefs.quotaUntil783)>now||(!state.connected&&Number(prefs.authCheckAfter783)>now)||state.connected&&!autoModel781()||t&&t.done===t.total)return 'done:'+Math.max(1000,bgDelay785());","if(!scanDirty783&&(scopeError783||Number(prefs.quotaUntil783)>now||(!state.connected&&authUntil789()>now)||state.connected&&!autoModel781()||t&&t.done===t.total)){const reason=stopReason789();worker787(reason);return 'done:'+Math.max(1000,bgDelay785())+':'+reason}")
rep("const old=localStorage.getItem(ACTIVE777);\n  if(!ready&&!old)return 'done:'+Math.max(1000,bgDelay785());","const old=localStorage.getItem(ACTIVE777),authBlocked=!state.connected&&Object.entries(pending).some(([k,q])=>registered783?.has(k)&&q.state==='blocked'&&q.kind783==='auth');\n  if(!ready&&!old&&!authBlocked&&!scanDirty783){const reason=stopReason789();worker787(reason);return 'done:'+Math.max(1000,bgDelay785())+':'+reason}")
rep("if(BG785&&Number(prefs.authCheckAfter783)>now)return;\n  if((sessionBlocked781||sessionRetries779>=3)&&now>=Number(prefs.authCheckAfter783||0)){sessionBlocked781=false;sessionRetries779=0}\n  if(!state.autoChecking&&!sessionBlocked781&&sessionRetries779<3){state.autoChecking=true;prefs.authCheckAfter783=now+1800000;persist771();request('session')}", "if(authUntil789()>now){if(BG785)worker787(stopReason789());return;}\n  if(sessionBlocked781||sessionRetries779>=3){sessionBlocked781=false;sessionRetries779=0}\n  if(!state.autoChecking&&!sessionBlocked781&&sessionRetries779<3){state.autoChecking=true;request('session')}")
rep("if(BG785&&j?.auto&&j.op==='generate')bgProcessed785=true;","if(BG785&&j?.auto&&j.op==='generate')scanDirty783=true;")
rep("state.connected=false;sessionBlocked781=true;prefs.authCheckAfter783=Date.now()+1800000}persist771()","state.connected=false;sessionBlocked781=true;holdAuth789('auth',q.error)}persist771()")
rep("if(state.connected){state.autoChecking=false;sessionBlocked781=false;sessionRetries779=0;prefs.authCheckAfter783=0;recoverBlocked783();wake783()}else{state.autoChecking=false;sessionBlocked781=true;sessionRetries779=3;prefs.authCheckAfter783=Date.now()+1800000;persist771();autoStatus771()}","if(state.connected){state.autoChecking=false;clearAuth789();persist771();recoverBlocked783();wake783()}else{state.autoChecking=false;sessionBlocked781=true;sessionRetries779=3;holdAuth789('auth','ChatGPT 계정 연결 필요');persist771();autoStatus771()}")
rep("if(j.op==='session'){state.autoChecking=false;sessionRetries779++;if(retryable779(e.message)){if(sessionRetries779<3)schedule771(sessionRetries779*15000)}else{sessionBlocked781=true;sessionRetries779=3;prefs.authCheckAfter783=Date.now()+1800000;persist771()}}","if(j.op==='session'){state.autoChecking=false;sessionRetries779++;const kind=classify783(e.message);holdAuth789(kind,e.message);if(!retryable779(e.message))sessionBlocked781=true;persist771();schedule771(60000)}")
rep("if(j.op==='session'){state.autoChecking=false;sessionRetries779++;if(sessionRetries779<3)schedule771(sessionRetries779*15000)}","if(j.op==='session'){state.autoChecking=false;sessionRetries779++;holdAuth789('transient','계정 조회 시간 초과 또는 연결 실패');schedule771(60000)}",2)
rep("if(e.type==='probe'){state.verified=true;finishJob(j);status(e.message);sync();schedule771();return}","if(e.type==='probe'){state.verified=true;clearAuth789();persist771();finishJob(j);status(e.message);sync();configure785(true);schedule771();return}")
rep("if(e.reconnect||j.op==='login'||j.op==='session'){state.connected=false;","if(e.reconnect||((j.op==='login'||j.op==='session')&&!/다른 AI 작업|백그라운드 자동 학습 진행 중/.test(e.message||''))){state.connected=false;")
rep("if(e.type==='progress'){if(j.op==='generate'","if(e.type==='progress'){if(j.op==='generate')j.nativeSeen789=true;if(j.op==='generate'")
rep("core:!!j?.coreSaved,chars:", "core:!!j?.coreSaved,accepted:!!j?.nativeSeen789,chars:")
rep("if(e.type==='delta'){j.text+=","if(e.type==='delta'){j.nativeSeen789=true;j.text+=")
# Foreground start handshake is separate from read-only monitor. Allow retry button to
# request immediate start, but never bypass the genuine provider hold or native conditions.
rep("if(BG785||bgCfgBusy785||!window.MoaPeerControl?.request)return;\n const body={enabled:!!(prefs.auto&&prefs.background785),wifi:!!prefs.wifi785,charge:!!prefs.charge785,retry:!!retry};\n const k=[body.enabled,body.wifi,body.charge].join('|'),now=Date.now();","if(BG785||!window.MoaPeerControl?.request)return;if(bgCfgBusy785){if(retry)bgKick789=true;return;}\n const body={enabled:!!(prefs.auto&&prefs.background785),wifi:!!prefs.wifi785,charge:!!prefs.charge785,retry:!!retry,interactive:!document.hidden&&!state.job,wantWork:!!retry||!observed787||observed787.done<observed787.total};\n const k=[body.enabled,body.wifi,body.charge,body.interactive,body.wantWork].join('|'),now=Date.now();")
rep("now-bgCfgAt785<12000","now-bgCfgAt785<5000")
rep(".finally(()=>{bgCfgBusy785=false;autoStatus771()});",".finally(()=>{bgCfgBusy785=false;autoStatus771();if(bgKick789){bgKick789=false;configure785(true)}});")
rep("persist771();wake783();autoStatus771();sync();return true;","persist771();if(!BG785)configure785(true);wake783();autoStatus771();sync();return true;")
rep("if(!state.connected&&!state.job&&!d.checked785){d.checked785=true;request('session')}","if(!(prefs.auto&&prefs.background785)&&!state.connected&&!state.job&&!d.checked785){d.checked785=true;request('session')}")
rep("button('보류 작업 다시 확인',()=>retryAll783())","button('지금 학습 시작 · 보류 작업 재확인',()=>{if(!prefs.auto){if(!setAuto783(true))return}retryAll783();void refresh787(true)})")
rep("if(n?.running&&w&&now-w.at<15000)return (w.op==='generate'?'백그라운드 생성 진행 · ':'백그라운드 · ')+w.stage","if(n?.running&&w&&now-w.at<15000)return (w.op==='generate'?(w.accepted||w.chars?'실제 학습 생성 · ':'AI 요청 준비 · '):'백그라운드 · ')+w.stage")
rep("if(n?.running)return 'Android 작업 시작 · AI 실행 신호 확인 중';\n if(n?.scheduled)return 'Android 예약 대기 · 아직 AI 실행 확인 안 됨';","if(n?.running)return (n.foreground?'즉시 실행 서비스 · ':'Android 작업 시작 · ')+(n.phase||'AI 실행 신호 확인 중');\n if(n?.reason)return n.reason;if(n?.starting)return '즉시 실행 서비스 시작 중';\n const hold=authHold789();if(hold)return (hold.kind==='quota'?'AI 사용량 제한':'계정 재확인 대기')+' · '+clock787(hold.until)+' 이후 · '+hold.message;\n if(n?.scheduled)return (n.lastStop||'Android 예약 대기 · 아직 AI 실행 확인 안 됨')+(n.nextAt>Date.now()?' · 다음 확인 '+clock787(n.nextAt):'')+(n.startError?' · '+n.startError:'');")
rep("backgroundTick785,invalidateBackground:invalidateBackground785","backgroundTick785,backgroundNotice789,invalidateScope789,invalidateBackground:invalidateBackground785")
# Keep old pending work and all card/consent schema. Do not obscure the missing count.
p.write_text(s)
# Enforce actual fixed dimensions rather than a min-height that old ID rules can enlarge.
p=web/'moa-r117-ui.js';s=p.read_text()
rep("min-height:57px!important;padding:15px 16px!important","height:56px!important;min-height:56px!important;max-height:56px!important;padding:0 16px!important;margin:0!important")
rep("justify-content:space-between!important;gap:12px!important;font-size:16px!important","justify-content:space-between!important;gap:12px!important;font-size:16px!important")
rep("padding:13px 16px!important;margin:0 0 10px!important","box-sizing:border-box!important;height:58px!important;min-height:58px!important;max-height:58px!important;padding:0 16px!important;margin:0 0 10px!important")
rep("padding:13px!important;font-size:15px!important","padding:0 16px!important;font-size:15px!important")
rep("@@ .r787-head .moa-r98-icon{width:34px!important;height:34px!important;flex:0 0 34px!important;border-radius:10px!important}","@@ .r787-head .moa-r98-icon{display:none!important}")
# Apply exact inline box geometry to the original direct card and header, avoiding any legacy ID selector override.
rep("function cls(n,c){if(n&&!n.classList.contains(c))n.classList.add(c)}",r"""function cls(n,c){if(n&&!n.classList.contains(c))n.classList.add(c)}
function px789(n,k,v){if(n&&n.style.getPropertyValue(k)!==v||n&&n.style.getPropertyPriority(k)!=='important')n.style.setProperty(k,v,'important')}
function card789(n){if(!n)return;cls(n,'r787-card');for(const [k,v] of Object.entries({'box-sizing':'border-box','padding':'0px','margin':'0px 0px 10px','border-width':'1px','min-height':'0px','gap':'0px'}))px789(n,k,v)}
function container789(n){if(!n)return;for(const [k,v] of Object.entries({'padding':'0px','margin':'0px','border-width':'0px','min-height':'0px','gap':'0px','box-shadow':'none'}))px789(n,k,v)}
function header789(n){if(!n)return;for(const [k,v] of Object.entries({'box-sizing':'border-box','height':'56px','min-height':'56px','max-height':'56px','padding':'0px 16px','margin':'0px','font-size':'16px','font-weight':'750','line-height':'1.35','gap':'12px'}))px789(n,k,v);for(const a of n.querySelectorAll('.moa-r98-icon,.moa-r99-icon,.moa-r495-scroll-label')){if(a.matches('.moa-r495-scroll-label')){px789(a,'font-size','16px');px789(a,'font-weight','750')}else px789(a,'display','none')}}""")
rep("function head(h){if(!h)return;cls(h,'r787-head');","function head(h){if(!h)return;cls(h,'r787-head');header789(h);")
rep("function fold(d){const h=d.querySelector(':scope > summary');if(!h)return;head(h);for(const n of d.children)if(n!==h)cls(n,'r787-body');const p=d.parentElement;cls(p?.classList.contains('moa-r117-fold')?p.parentElement:p?.matches('li')?p:d,'r787-card')}","function fold(d){const h=d.querySelector(':scope > summary');if(!h)return;head(h);for(const n of d.children)if(n!==h)cls(n,'r787-body');const p=d.parentElement,c=p?.classList.contains('moa-r117-fold')?p.parentElement:p?.matches('li')?p:d;card789(c);if(c!==d)container789(d);if(p!==c&&p!==d)container789(p)}")
rep("cls(c,'r787-card');head(h);cls(p,'r787-body');","card789(c);head(h);cls(p,'r787-body');")
rep("if(u){cls(u,'r787-card');head","if(u){card789(u);head")
rep("if(sy){cls(sy,'r787-card');head","if(sy){card789(sy);head")
# Fix wrapper margins that changed measured vertical spacing; maintain section heading and actual errors.
rep("@@ .r787-inner-row .row-desc", "@@ #moa-r117-advanced-group.r787-card{margin:0 0 10px!important}@@ .r787-card .r787-head>span:not(.r787-old-arrow){min-width:0}@@ #moa-r783-auto-study .moa-r98-control{box-sizing:border-box;min-height:48px!important;padding:0!important;margin:0!important}@@ #moa-r783-auto-study select{height:40px!important;min-height:40px!important;max-height:40px!important}@@ .r787-inner-row .row-desc")
p.write_text(s)
# Native foreground ownership remains single; allow explicit manual action when worker is idle.
p=native/'MoaInline755.java';s=p.read_text()
rep("MoaStudyJob785.configure(ctx,j);","MoaStudyJob785.configure(ctx,j,activity(web.get()));")
rep("if(!background785&&MoaStudyJob785.ownsWorker()){","if(!background785&&MoaStudyJob785.ownsWorker()&&!MoaStudyJob785.yieldToManual()){")
# Prevent null WebView edge on closed Activity.
rep("private static Activity activity(WebView w){Context c=w.getContext();","private static Activity activity(WebView w){if(w==null)return null;Context c=w.getContext();")
p.write_text(s)
print('R789 guarded session persistence, same-worker continuation, immediate service and exact settings heights')
