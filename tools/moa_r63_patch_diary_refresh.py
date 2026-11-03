#!/usr/bin/env python3
"""R63 minimal patch of *installed R62* assets/web/family-diary.js.
Re-read curated IndexedDB whenever the selected-photo diary opens or resumes.
No second R42 modal, no legacy UI removal, no changed diary schema.
"""
from pathlib import Path
import sys

source=Path(sys.argv[1])
dest=Path(sys.argv[2])
text=source.read_text(encoding="utf-8")
old="async function open(){mount();S.open=true;S.mode='curated';S.page='calendar';S.editing=false;S.dirty=false;S.root.hidden=false;showTab();await init();render();mmR60RefreshMedia('diary-open')}"
new="async function refreshCuratedFromDatabase(){if(S.editing)return;try{const list=await dbAll('curated');S.curatedEntries=new Map(list.map(x=>[x.day,x]));}catch(e){status('선택 일기 새 기록 확인 실패 · 다시 열어주세요: '+String(e),true)}} async function open(){mount();S.open=true;S.mode='curated';S.page='calendar';S.editing=false;S.dirty=false;S.root.hidden=false;showTab();await init();await refreshCuratedFromDatabase();render();mmR60RefreshMedia('diary-open')}"
needle="w.FamilyJourneyDiary={open,close,selectDay:chooseDay,loadIndex,suppressNativePrompt:mmSuppressNativePrompt,momentToggle:mmToggle,momentStatus:"
inject="document.addEventListener('visibilitychange',()=>{if(!document.hidden&&S.open&&!S.editing)refreshCuratedFromDatabase().then(render)});window.addEventListener('focus',()=>{if(S.open&&!S.editing)refreshCuratedFromDatabase().then(render)});\n"
assert text.count(old)==1 and text.count(needle)==1
text=text.replace(old,new).replace(needle,inject+needle)
assert "const MOA_R58_SINGLE_NATIVE_CAPTURE=true" in text
dest.write_text(text,encoding="utf-8")
