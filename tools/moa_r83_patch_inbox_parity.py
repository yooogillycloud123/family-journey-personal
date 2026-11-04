#!/usr/bin/env python3
"""R83 original memo-to-diary inbox parity for direct HostActivity subclass.
Allow exactly the original or direct launcher. R63 writer/store remain untouched."""
from pathlib import Path
p=Path('android/app/src/main/java/com/juhyeon/familyjourney/MoaMomentInboxSync.java')
s=p.read_text(encoding='utf8')
old="return a!=null&&HOST.equals(a.getClass().getName())&&!a.isFinishing()&&!a.isDestroyed();"
new='return a!=null&&(HOST.equals(a.getClass().getName()) || "com.juhyeon.familyjourney.MoaMomentVoiceHostActivity".equals(a.getClass().getName()))&&!a.isFinishing()&&!a.isDestroyed();'
assert s.count(old)==1
s=s.replace(old,new)
old='Field f=a.getClass().getDeclaredField("web"); f.setAccessible(true);'
new='Field f=HostActivity.class.getDeclaredField("web"); f.setAccessible(true);'
assert s.count(old)==1
s=s.replace(old,new)
p.write_text(s,encoding='utf8')
print('R83 native memo -> diary inbox parity patch PASS')