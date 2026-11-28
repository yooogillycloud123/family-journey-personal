from pathlib import Path
import sys
old=Path('experiments/moa-r783/prepare-unsigned.py').read_text().split('root=Path(sys.argv[1])')[0]
exec(compile(old,'old-prepare','exec'))
r=Path(sys.argv[1]);base=r/'moa-r789.apk';pin='e7f5afbaf637d231f80f754b488d77f88d2e12a5ef85fcd0bfc972499a81fbf7'
prepare(base,r/'r791-unaligned.apk',789,791,{'assets/web/moa-r117-ui.js':r/'web/moa-r117-ui.js'},pin)
prepare(base,r/'r792-unaligned.apk',789,792,{},pin)
