#!/usr/bin/env python3
"""MOA R92: native camera memo opens focused with Samsung IME visible.
Run after unchanged R80 -> R83 native patch chain AND R87 memo clear/IME patch.
This changes only the initial keyboard state and text focus.
"""
from pathlib import Path
p=Path("android/app/src/main/java/com/juhyeon/familyjourney/MoaMomentMemoActivity.java")
s=p.read_text(encoding="utf-8")
old="  private String id; private EditText text; private MoaMomentVoice speech; private Button micButton;"
assert s.count(old)==1
s=s.replace(old,old+"\n  private boolean r92InitialImeRequested=false;")
old="    setContentView(root);\n    getWindow().setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_ADJUST_RESIZE|WindowManager.LayoutParams.SOFT_INPUT_STATE_ALWAYS_HIDDEN);"
new="""    setContentView(root);
    // First open: typing-ready. Existing mic/clear/save footer remains above IME.
    text.setFocusableInTouchMode(true);
    text.requestFocus();
    getWindow().setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_ADJUST_RESIZE|WindowManager.LayoutParams.SOFT_INPUT_STATE_ALWAYS_VISIBLE);"""
assert s.count(old)==1,("R89 keyboard state anchor",s.count(old))
s=s.replace(old,new)
anchor="  // R78: microphone stays INSIDE this Activity (also on the secure lockscreen)."
insert="""  // Samsung IME sometimes ignores state flags until this Activity owns focus.
  // Request only ONCE per Activity, never reopen IME after the user hides it.
  @Override public void onWindowFocusChanged(boolean hasFocus){
    super.onWindowFocusChanged(hasFocus);
    if(!hasFocus||r92InitialImeRequested||text==null)return;
    r92InitialImeRequested=true;
    text.post(()->{
      if(isFinishing()||isDestroyed()||!text.isAttachedToWindow()||!text.hasFocus())return;
      android.view.inputmethod.InputMethodManager imm=(android.view.inputmethod.InputMethodManager)getSystemService(INPUT_METHOD_SERVICE);
      if(imm!=null)imm.showSoftInput(text,android.view.inputmethod.InputMethodManager.SHOW_IMPLICIT);
    });
  }
"""
assert s.count(anchor)==1
s=s.replace(anchor,insert+anchor)
for marker in ("내용 전체 지우기","MoaMomentDirectDiaryStore.requestSync(this)","new MoaMomentVoice(this,new MoaMomentVoice.Listener()","root.setOnApplyWindowInsetsListener","SOFT_INPUT_ADJUST_RESIZE"):
 assert marker in s,marker
assert "SOFT_INPUT_STATE_ALWAYS_HIDDEN" not in s
p.write_text(s,encoding="utf-8")
print("R92_NATIVE_MEMO_INITIAL_IME_ONLY=PASS")
