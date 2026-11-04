#!/usr/bin/env python3
"""R80 voice-only overlay patch against exact R79 packaged diary JavaScript.
No DB schema/write changes, no picture/timestamp modifications.
"""
from pathlib import Path
import sys
source=Path(sys.argv[1]);target=Path(sys.argv[2])
s=source.read_text(encoding='utf8')
start=s.index('const r78PendingVoice=new Map();')
end=s.index('function mmVoiceToTextarea(input,button){',start)
replacement='''// R80: one user action and one native SpeechRecognizer. Live provisional text
// replaces previous partials instead of accumulating duplicate paragraphs.
const r78PendingVoice=new Map();let r78VoiceSequence=0;
function r80VisibleSpeech(pending,words,isFinal){
 const input=pending.input;
 if(!input||!input.isConnected||!words)return;
 const speech=String(words).trim();if(!speech)return;
 if(pending.original===undefined){
   pending.original=input.value;
   pending.start=typeof input.selectionStart==='number'?input.selectionStart:input.value.length;
   pending.end=typeof input.selectionEnd==='number'?input.selectionEnd:pending.start;
   pending.lastRendered=input.value;
 }
 // The user might edit manually while dictating; retain their newest text.
 if(input.value!==pending.lastRendered){
   pending.original=input.value;
   pending.start=typeof input.selectionStart==='number'?input.selectionStart:input.value.length;
   pending.end=typeof input.selectionEnd==='number'?input.selectionEnd:pending.start;
 }
 const before=pending.original.slice(0,pending.start),after=pending.original.slice(pending.end);
 const prefix=before&&!/\\s$/.test(before)?' ':'';
 const suffix=after&&!/^\\s/.test(after)?' ':'';
 const visible=before+prefix+speech+suffix+after;
 input.value=visible;
 pending.lastRendered=visible;
 if(typeof input.setSelectionRange==='function'){
   const cursor=(before+prefix+speech).length;
   input.setSelectionRange(cursor,cursor);
 }
 input.dispatchEvent(new Event('input',{bubbles:true}));
 pending.partial= !isFinal;
 if(isFinal){pending.committed=true;pending.original=undefined;}
}
window.__moaVoiceNativeResult=function(token,payload,phase){
 const pending=r78PendingVoice.get(String(token));if(!pending)return;
 const {input,btn,initial}=pending;
 if(phase==='listening'){
   btn.textContent='⏹ 음성 종료';btn.disabled=false;return;
 }
 if(phase==='permission_wait'){
   btn.textContent='마이크 권한 승인 대기…';btn.disabled=true;return;
 }
 if(phase==='partial'){r80VisibleSpeech(pending,payload,false);return;}
 if(phase==='success'){r80VisibleSpeech(pending,payload,true);return;}
 if(phase==='error'||phase==='permission'){
   alert(String(payload||'음성 인식에 실패했습니다. 다시 시도해 주세요.'));
 }
 if(phase==='finished'||phase==='error'||phase==='permission'){
   btn.textContent=initial;btn.disabled=false;
   r78PendingVoice.delete(String(token));
 }
};
function r80VoiceEnd(token){
 try{
   if(window.MoaVoiceNative&&typeof window.MoaVoiceNative.finish==='function'){
     window.MoaVoiceNative.finish(token);return true;
   }
   return window.prompt('MOA_R80_NATIVE_VOICE_END',token)==='MOA_R79_ACCEPTED';
 }catch(e){return false;}
}
function r78VoiceText(input,button){
 // A second tap ends recognition; do not create another listener/session.
 for(const [token,pending] of r78PendingVoice.entries()){
   if(pending.btn===button){
     button.textContent='최종 음성 인식 중…';button.disabled=true;
     if(!r80VoiceEnd(token)){
       button.textContent='⏹ 음성 종료';button.disabled=false;
     }
     return true;
   }
 }
 // Clear any old session UI before transferring the native recognizer to
 // another diary field. Keep already displayed words as draft, not a DB save.
 for(const [token,pending] of r78PendingVoice.entries()){
   pending.btn.textContent=pending.initial;pending.btn.disabled=false;
   r78PendingVoice.delete(token);
 }
 const token='v'+String(Date.now())+String(++r78VoiceSequence%10000).padStart(4,'0');
 const initial=button.textContent;
 button.textContent='음성 준비 중…';button.disabled=true;
 r78PendingVoice.set(token,{input,btn:button,initial,partial:false,committed:false});
 try{
   if(window.MoaVoiceNative&&typeof window.MoaVoiceNative.start==='function'){
     window.MoaVoiceNative.start(token);
   }else{
     // R79 bug: the readiness flag could remain false even though onJsPrompt
     // had already been installed. Probe the actual native action on click.
     const ack=window.prompt('MOA_R79_NATIVE_VOICE',token);
     if(ack!=='MOA_R79_ACCEPTED')throw Error('native voice prompt not intercepted');
   }
 }catch(e){
   r78PendingVoice.delete(token);button.textContent=initial;button.disabled=false;
   alert('모아 네이티브 음성 인식 연결을 시작하지 못했습니다. 현재 작성 중인 글은 보존됩니다.');
 }
 return true;
}
function r78VoiceButton(input,label){
 const btn=elem('button','fd78-voice-field','🎙 음성 입력');btn.type='button';
 btn.setAttribute('aria-label',label+' 음성으로 입력');
 btn.style.cssText='display:inline-flex;align-items:center;justify-content:center;gap:5px;min-height:40px;padding:8px 14px;margin:6px 0 13px;border:1px solid #e5caca;border-radius:11px;background:#fff3ee;color:#9c6274;font-size:14px;font-weight:600';
 btn.addEventListener('click',()=>r78VoiceText(input,btn));
 return btn;
}

'''
s=s[:start]+replacement+s[end:]
# Old mmVoiceToTextarea() still calls the R80 function, no WebSpeech fallback.
assert 'function mmVoiceToTextarea(input,button)' in s
assert 'window.webkitSpeechRecognition' not in s
for x in ['function renderEditor(entry,photos)','button(\'일기 삭제\',remove','dbPut(', 'R76','r76']:
 if x in ('R76','r76'):continue
 assert x in s,x
assert s.count('window.__moaVoiceNativeResult=function(')==1
assert s.count('function r78VoiceText(input,button)')==1
assert s.count("window.prompt('MOA_R79_NATIVE_VOICE'")==1
assert s.count("window.prompt('MOA_R80_NATIVE_VOICE_END'")==1
target.write_text(s,encoding='utf8')
print('R80_DIARY_VOICE_PATCH=PASS',len(source.read_text()),'->',len(s))