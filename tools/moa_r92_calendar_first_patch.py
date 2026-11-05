#!/usr/bin/env python3
"""MOA R92 calendar-first layout patch, applied to the EXACT R89 Golden APK JS.
No new display widgets, no data change: move existing capture-monitor controls
below the full month grid and above the existing PC import/create actions.
Usage: python tools/moa_r92_calendar_first_patch.py R89_family-diary.js OUT.js
"""
import hashlib
import sys
from pathlib import Path

src,dst=map(Path,sys.argv[1:3])
original=src.read_bytes()
expected="1ee82f8e55ceb08c1a9daee8a6c6f10117405b7e29db8e61dab078854df81ec3"
assert hashlib.sha256(original).hexdigest()==expected,"Refuse non-R89 Golden diary asset"
s=original.decode("utf-8")
old="  if(S.mode==='curated')S.root.append(mmToolbar());\n"
assert s.count(old)==1,("capture card anchor",s.count(old))
s=s.replace(old,"")
old=" S.root.append(grid);\n S.root.append(elem('p','fd23-hint',curated?'날짜를 누르면 선택한 사진과 일기를 볼 수 있어요. 빈 날짜도 눌러 새 일기를 만들 수 있어요.':'날짜를 누르면 그날 촬영된 모든 사진을 볼 수 있어요. 직접 선택한 사진 일기는 별도 탭에만 표시돼요.'));\n"
assert s.count(old)==1,("calendar grid anchor",s.count(old))
s=s.replace(old,old+" // R92: keep the original ON/OFF and status panel, after the calendar.\n if(curated)S.root.append(mmToolbar());\n")
assert s.count("S.root.append(mmToolbar());")==1
assert s.index("S.root.append(grid);")<s.index("S.root.append(mmToolbar());")<s.index("const pc=elem('section','fd25-pc-import')")
for marker in ("function mmToggle()","dbPut('curated'","mmR60RefreshMedia","function renderEditor(","function renderDay(","function segments(","w.FamilyJourneyDiary={open,close"):
 assert marker in s,("protected",marker)
dst.write_text(s,encoding="utf-8")
print("R92_CALENDAR_FIRST_UI_ONLY=PASS",hashlib.sha256(dst.read_bytes()).hexdigest())
