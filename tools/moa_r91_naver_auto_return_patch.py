#!/usr/bin/env python3
"""R91 optional, confirmed-save NAVER -> source app automatic return.
No Shizuku, root, shell privilege, screenshots, or background activity launch.
This patch applies only to the older androidHost NAVER accessibility implementation.
The signed MOA R89 user Golden must NOT be modified or regarded as patched.
"""
from pathlib import Path
import hashlib
root=Path("androidHost/app/src/main/java/com/juhyeon/familyjourney")
n=root/"NaverSaveService.java"
h=root/"HostActivity.java"
def replace_once(s,old,new,name):
    count=s.count(old)
    if count!=1: raise SystemExit(f"R91_FAIL_CLOSED {name} matched={count} expected=1")
    return s.replace(old,new)
nav=n.read_text(encoding="utf8")
old_nav_hash=hashlib.sha256(nav.encode()).hexdigest()
assert "static final String NAVER=\"com.nhn.android.nmap\"" in nav
assert "private void state(SharedPreferences p,String status,boolean stop)" in nav
nav=replace_once(nav,
'''    e.apply();
    Log.i("FJ_Naver","naver_save_stage="+status);
  }''',
'''    e.apply();
    Log.i("FJ_Naver","naver_save_stage="+status);
    // Only a confirmed real NAVER save, tied to this explicit one-shot job,
    // may trigger an automatic return. A click alone is NEVER success.
    // Keep uncertain memo/list persistence visible for manual inspection.
    if(stop && "VERIFIED".equals(status) && p.getBoolean("returnAfterVerified",false)){
      final String job=p.getString("job","");
      if(job.length()>=6) scheduler.postDelayed(()->returnAfterSave(job,0),650);
    }
  }

  // User-initiated NAVER save work can return to the prior app through normal
  // Android Back. Unlike startActivity() from a background Service this does
  // not rely on background-activity-start privileges (Android 16/17).
  // Press Back only while NAVER is the actual active foreground window;
  // NEVER press Back on the user's foreground app or launch another task.
  // Limit to four actions; never force-stop NAVER or manipulate login screens.
  private void returnAfterSave(String job,int attempt){
    if(attempt>=4)return;
    SharedPreferences p=getSharedPreferences(STORE,MODE_PRIVATE);
    if(!job.equals(p.getString("job",""))||
       !"VERIFIED".equals(p.getString("state",""))||
       !p.getBoolean("returnAfterVerified",false))return;
    AccessibilityNodeInfo root=getRootInActiveWindow();
    if(root==null)return;
    try{
      CharSequence pkg=root.getPackageName();
      if(pkg==null || !NAVER.contentEquals(pkg))return;
      // If a NAVER authentication or security challenge appears, do not
      // close it or interfere with account-related user action.
      if(has(root,"로그인")||has(root,"본인 인증")||has(root,"보안 확인"))return;
    }finally{root.recycle();}
    if(!performGlobalAction(GLOBAL_ACTION_BACK))return;
    scheduler.postDelayed(()->returnAfterSave(job,attempt+1),750);
  }''',"state/auto-return")
n.write_text(nav,encoding="utf8")
host=h.read_text(encoding="utf8")
host=replace_once(host,
'''          .putLong("started",System.currentTimeMillis()).putBoolean("armed",true)
          .putString("state","WAITING_ADDRESS_RESULT").apply();''',
'''          .putLong("started",System.currentTimeMillis()).putBoolean("armed",true)
          .putBoolean("returnAfterVerified",true)
          .putString("state","WAITING_ADDRESS_RESULT").apply();''',"source-job-intent")
h.write_text(host,encoding="utf8")
assert "returnAfterSave(job,0)" in nav
assert "if(!performGlobalAction(GLOBAL_ACTION_BACK))return;" in nav
assert "SHIZUKU" not in nav and "Shizuku" not in nav
print("R91_NAVER_VERIFIED_AUTO_RETURN_PATCH=PASS")
print("R91_NAVER_ORIGINAL_SHA256="+old_nav_hash)
print("R91_NAVER_NEW_SHA256="+hashlib.sha256(nav.encode()).hexdigest())
