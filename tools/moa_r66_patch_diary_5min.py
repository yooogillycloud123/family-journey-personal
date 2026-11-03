#!/usr/bin/env python3
"""Only change display grouping: 1h chained photos -> fixed wall-clock 5-minute windows.
R63 Golden original capture times and all IndexedDB write/readback remain unchanged.
"""
from pathlib import Path
import sys
src,dst=map(Path,sys.argv[1:3])
s=src.read_text(encoding='utf-8')
old="function segments(list){const all=[...list].sort((a,b)=>a.t-b.t);const result=[];for(const p of all){let last=result[result.length-1];if(!last||p.t-last.end>3600000){last={start:p.t,end:p.t,photos:[]};result.push(last)}last.end=p.t;last.photos.push(p)}return result}"
new="const FIVE_MIN_MS=5*60*1000;\\nfunction segments(list){const all=[...list].sort((a,b)=>a.t-b.t);const result=[];for(const p of all){const slot=Math.floor(Number(p.t)/FIVE_MIN_MS);let last=result[result.length-1];if(!last||last.slot!==slot){last={start:p.t,end:p.t,photos:[],slot};result.push(last)}last.end=p.t;last.photos.push(p)}return result}"
new=new.replace('\\n','\n')
old_heading="dt.append(elem('strong','',timeOf(g.start)+(g.end===g.start?'':' ~ '+timeOf(g.end))),elem('span','',counts(g.photos)));"
new_heading="dt.append(elem('strong','',timeOf(g.slot*FIVE_MIN_MS)+' ~ '+timeOf((g.slot+1)*FIVE_MIN_MS-60000)),elem('span','',counts(g.photos)));"
assert s.count(old)==1 and s.count(old_heading)==1
s=s.replace(old,new).replace(old_heading,new_heading)
assert "const MOA_R58_SINGLE_NATIVE_CAPTURE=true" in s
assert "await refreshCuratedFromDatabase();render();" in s
assert "w.__moaNativeSync=function(packet)" in s
assert "dbPut('curated',day,updated)" in s
dst.write_text(s,encoding='utf-8')
