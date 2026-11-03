#!/usr/bin/env python3
"""Add a fixed Delete action using the ORIGINAL confirm-protected remove() callback.
The journal data model, source timestamps, original save/remove methods and
same-origin IndexedDB writer must remain EXACTLY unchanged.
"""
from pathlib import Path
from zipfile import ZipFile
import sys

source,target = map(Path,sys.argv[1:3])
with ZipFile(source) as z:
    s=z.read('assets/web/family-diary.js').decode('utf-8')
old="if(entry)buttons.append(button('일기 삭제',remove,'danger'));form.append(buttons);"
new="const originalDelete=entry?button('일기 삭제',remove,'danger'):null;if(originalDelete)buttons.append(originalDelete);form.append(buttons);"
assert s.count(old)==1
s=s.replace(old,new)
oldbar=""" const shortcutSave=button('일기 저장',save,'primary');
 for(const x of [shortcutTitle,shortcutMemo,shortcutSave]){
   x.style.flex='1 1 0';x.style.minWidth='0';x.style.padding='11px 5px';x.style.fontSize='13px';x.style.borderRadius='10px';
   shortcutBar.append(x);
 }"""
newbar=""" const shortcutSave=button('일기 저장',save,'primary');
 // Reuse original remove() exactly; its confirmation protects against mistakes.
 const shortcutDelete=originalDelete?button('일기 삭제',remove,'danger'):null;
 if(shortcutDelete){
   shortcutDelete.setAttribute('aria-label','현재 날짜 일기 삭제 · 삭제 확인창 표시');
   shortcutDelete.title='현재 날짜의 일기를 삭제합니다. 확인 전에는 삭제되지 않습니다.';
   shortcutDelete.style.color='#a84a54';
 }
 for(const x of [shortcutTitle,shortcutMemo,shortcutSave,shortcutDelete].filter(Boolean)){
   x.style.flex='1 1 0';x.style.minWidth='0';x.style.padding='11px 3px';x.style.fontSize='12px';x.style.borderRadius='10px';
   shortcutBar.append(x);
 }"""
assert s.count(oldbar)==1
s=s.replace(oldbar,newbar)
assert s.count("button('일기 삭제',remove,'danger')")==2
assert "button('삭제로 이동'" not in s
assert "if(!confirm('이 날짜의 일기 내용을 삭제할까요? 원본 사진은 삭제되지 않습니다.'))return" in s
assert "dbPut('curated',day,updated)" in s
assert "refreshCuratedFromDatabase" in s
target.parent.mkdir(parents=True,exist_ok=True)
target.write_text(s,encoding='utf-8')
