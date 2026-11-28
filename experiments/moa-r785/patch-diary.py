#!/usr/bin/env python3
from pathlib import Path
import sys
p=Path(sys.argv[1]);s=p.read_text()
for f in ('dbPut','dbDelete'):
 a=s.index('async function '+f+'(');b=s.index('\n',a)
 line=s[a:b]
 assert line.count('tx.oncomplete=yes;')==1
 key='key' if f=='dbPut' else 'day'
 line=line.replace('tx.oncomplete=yes;', "tx.oncomplete=()=>{yes();if(table==='curated')try{w.MoaInline755?.invalidateBackground?.("+key+")}catch(_){}};")
 s=s[:a]+line+s[b:]
p.write_text(s)
