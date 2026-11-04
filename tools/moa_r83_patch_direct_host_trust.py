#!/usr/bin/env python3
"""After R80, R81, R82 source scripts: admit the explicitly selected direct-host
Activity as a trusted native speech request owner, without altering storage/camera."""
from pathlib import Path
p=Path("android/app/src/main/java/com/juhyeon/familyjourney/MoaMomentVoiceBridge.java")
s=p.read_text(encoding="utf8")
old='      &&"com.juhyeon.familyjourney.HostActivity".equals(a.getClass().getName())'
new='''      &&("com.juhyeon.familyjourney.HostActivity".equals(a.getClass().getName())
        || "com.juhyeon.familyjourney.MoaMomentVoiceHostActivity".equals(a.getClass().getName()))'''
assert s.count(old)==1,(s.count(old),old)
p.write_text(s.replace(old,new),encoding="utf8")
print("R83 TRUSTED DIRECT HOST PATCH PASS")
