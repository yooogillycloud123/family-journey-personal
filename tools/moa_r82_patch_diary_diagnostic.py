#!/usr/bin/env python3
"""R82 exact small JS patch on the R81 packaged diary JS. No database or photo edits."""
import sys
from pathlib import Path
if len(sys.argv)!=3: raise SystemExit("usage: patch.py <R81_family-diary.js> <output_R82.js>")
src=Path(sys.argv[1]); out=Path(sys.argv[2]); s=src.read_text(encoding="utf8")
old="""   button.textContent='음성 연결 재시도';button.disabled=false;
   button.title='모아 음성 연결을 확인하지 못했습니다. 다시 눌러 주세요. 기존 글은 그대로 유지됩니다.';"""
new="""   button.textContent='음성 연결 실패 · 다시 누르기';button.disabled=false;
   // R82: status of direct JS interface, prompt Chrome heartbeat,
   // original NativeHost and prior MoaMomentNative. Never save a diary.
   const diag='R82 '+[
     'V'+((window.MoaVoiceNative&&typeof window.MoaVoiceNative.start==='function')?'1':'0'),
     'C'+((Date.now()-Number(window.__moaR81VoiceChromeLiveAt||0)<1500)?'1':'0'),
     'N'+((window.NativeHost&&typeof window.NativeHost.post==='function')?'1':'0'),
     'M'+((window.MoaMomentNative&&typeof window.MoaMomentNative.enabled==='function')?'1':'0')
   ].join(' ');
   button.title='연결 실패 '+diag+' · 기존 글은 그대로 유지됩니다.';
   alert('모아 음성 인식 네이티브 연결이 시작되지 않았습니다.\\n진단: '+diag+'\\n작성 중인 글은 보존됩니다.');"""
assert s.count(old)==1,"R81 JS anchor mismatch; fail closed"
out.write_text(s.replace(old,new),encoding="utf8")
print("R82 JS patch PASS",out)
