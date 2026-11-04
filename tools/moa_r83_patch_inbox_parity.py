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
# R89 temporary isolated build staging: same successfully compiled R83 native
# source base, modify ONLY MemoActivity UI (clear confirmation + IME footer).
# Do not change the user-confirmed R83 Golden branch or any voice engine.
import hashlib, runpy
from pathlib import Path as _Path
_r89_root=_Path("android/app/src/main/java/com/juhyeon/familyjourney")
_r89_frozen=["MoaMomentVoice.java","MoaMomentVoiceBridge.java",
    "MoaMomentVoiceChrome.java","MoaMomentVoiceHostActivity.java",
    "MoaMomentApplication.java","MoaMomentCaptureService.java",
    "MoaMomentDirectDiaryStore.java","MoaMomentInboxSync.java"]
_before={p:hashlib.sha256((_r89_root/p).read_bytes()).hexdigest() for p in _r89_frozen}
runpy.run_path("tools/moa_r89_patch_memo_clear_ime.py",run_name="__main__")
assert _before=={p:hashlib.sha256((_r89_root/p).read_bytes()).hexdigest() for p in _r89_frozen}, "R89 Golden dependency source changed"
print("R89_GOLDEN_VOICE_DEPENDENCIES_FROZEN=PASS")
