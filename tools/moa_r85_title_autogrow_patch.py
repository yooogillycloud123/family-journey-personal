#!/usr/bin/env python3
"""R85 TITLE ONLY: exact R83 physical Golden input -> wrapped auto-growing title.
Golden STT bridge, save(), R63 diary/MediaStore and all DEX are immutable.
Usage: python tools/moa_r85_title_autogrow_patch.py golden_family-diary.js output.js
"""
import hashlib,sys
from pathlib import Path
src=Path(sys.argv[1]);out=Path(sys.argv[2]);s=src.read_text(encoding="utf8")
expected="8a8e609220cddbf309c585202bc94a7e113b6450c57fe8942c9cd0c8c37a91d5"
assert hashlib.sha256(s.encode()).hexdigest()==expected,"FAIL: input is not exact frozen R83 JS"
old="const title=elem('input');title.type='text';title.id='fd23-title';title.placeholder='오늘의 제목';title.maxLength=120;title.value=entry?.title||'';form.append(title,r78VoiceButton(title,'일기 제목'));"
assert s.count(old)==1
new="""// R85: the user's R83 Golden recognizer now writes into a MULTILINE title.
 // Preserve the exact id, value, maxlength, voice button and original save path.
 // No schema changes; on-screen wrapping + vertical resize are display-only.
 const title=elem('textarea');title.id='fd23-title';title.rows=2;
 title.placeholder='오늘의 제목';title.maxLength=120;title.value=entry?.title||'';
 title.setAttribute('aria-label','일기 제목');title.setAttribute('enterkeyhint','next');
 title.style.cssText='min-height:58px;max-height:240px;resize:vertical;overflow-y:auto;white-space:pre-wrap;overflow-wrap:anywhere;box-sizing:border-box;line-height:1.55';
 let titleAutoHeight=0,titleManualHeight=0;
 const r85FitTitle=()=>{
   if(!title.isConnected)return;
   // Preserve a manual drag-resize while still expanding with longer text.
   const shown=title.getBoundingClientRect().height;
   if(titleAutoHeight&&Math.abs(shown-titleAutoHeight)>3)
     titleManualHeight=Math.max(58,Math.min(240,shown));
   const oldTop=title.scrollTop;
   title.style.height='auto';
   const needed=Math.max(58,Math.min(240,title.scrollHeight+2));
   const desired=Math.max(needed,titleManualHeight);
   title.style.height=desired+'px';titleAutoHeight=desired;
   title.scrollTop=oldTop;
 };
 title.addEventListener('input',r85FitTitle);
 form.append(title,r78VoiceButton(title,'일기 제목'));"""
s=s.replace(old,new)
old_end="S.root.append(form,shortcutBar)\n}"
new_end="""S.root.append(form,shortcutBar);
 // Wait until attached: textarea.scrollHeight is not measurable off-DOM.
 if(typeof requestAnimationFrame==='function')requestAnimationFrame(r85FitTitle);
 else setTimeout(r85FitTitle,0)
}"""
assert s.count(old_end)==1
s=s.replace(old_end,new_end)
assert s.count("function r81NativeVoiceInvoke")==1
assert s.count("function r78VoiceText")==1
assert s.count("title.id='fd23-title'")==1
out.write_text(s,encoding="utf8")
print("R85 TITLE ONLY PASS",hashlib.sha256(s.encode()).hexdigest())
