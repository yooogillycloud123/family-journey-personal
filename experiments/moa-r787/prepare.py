#!/usr/bin/env python3
from pathlib import Path
import sys
old=Path('experiments/moa-r783/prepare-unsigned.py').read_text().split('root=Path(sys.argv[1])')[0]
exec(compile(old,'old-prepare','exec'))
r=Path(sys.argv[1]);base=r/'moa-r785.apk';pin='b3021949745299d47de71d424b0b29b5de94a726d3d77adf1ee434966e791f7d'
changes={'assets/web/'+n:r/'web'/n for n in ('moa-r755-inline-ai.js','moa-r117-ui.js')}
prepare(base,r/'r787-unaligned.apk',785,787,changes,pin)
prepare(base,r/'r788-unaligned.apk',785,788,{},pin)
