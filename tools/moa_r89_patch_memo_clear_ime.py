#!/usr/bin/env python3
"""MOA R87: adjust ONLY native single-photo memo UI.
Run after R80/R81/R82/R83 source patch sequence; never edit proven STT engine.
Add one confirmed clear-input action and keep two existing actions above IME.
"""
from pathlib import Path
P=Path("android/app/src/main/java/com/juhyeon/familyjourney/MoaMomentMemoActivity.java")
s=P.read_text(encoding="utf-8")
before=s
def change(a,b):
 global s
 assert s.count(a)==1,("R87 anchor mismatch",s.count(a),a[:100])
 s=s.replace(a,b)
change(
'    LinearLayout root=new LinearLayout(this);',
'''    // R87: local editor-field clearing only; no shared preferences, diary,
    // photo, or already-saved memo is touched until the original Save path.
    Button clear=new Button(this);clear.setText("내용 전체 지우기");clear.setTextSize(14);
    clear.setOnClickListener(v->{
      if(text.getText().length()==0){
        Toast.makeText(this,"지울 내용이 없습니다.",Toast.LENGTH_SHORT).show();return;
      }
      new android.app.AlertDialog.Builder(this)
        .setTitle("현재 메모 글자 모두 지우기")
        .setMessage("이 입력창의 글자만 모두 지울까요? 다른 기록과 원본 사진은 지워지지 않습니다. 저장된 메모도 '모아 일기에 메모 저장'을 누르기 전에는 바뀌지 않습니다.")
        .setNegativeButton("취소",(dialog,which)->{})
        .setPositiveButton("모두 지우기",(dialog,which)->{
          // Never allow a late partial callback to repopulate cleared text.
          if(speech!=null){speech.stop();speech=null;}
          text.setText("");
          text.requestFocus();
        })
        .show();
    });
    LinearLayout root=new LinearLayout(this);''')
change(
'''    footer.addView(mic,new LinearLayout.LayoutParams(-1,dp*4));
    footer.addView(save,new LinearLayout.LayoutParams(-1,dp*4));''',
'''    LinearLayout actionRow=new LinearLayout(this);
    actionRow.setOrientation(LinearLayout.HORIZONTAL);
    mic.setTextSize(13);clear.setTextSize(13);
    actionRow.addView(mic,new LinearLayout.LayoutParams(0,dp*4,1f));
    actionRow.addView(clear,new LinearLayout.LayoutParams(0,dp*4,1f));
    footer.addView(actionRow,new LinearLayout.LayoutParams(-1,-2));
    footer.addView(save,new LinearLayout.LayoutParams(-1,dp*4));''')
change(
'''    setContentView(root);
    getWindow().setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_ADJUST_RESIZE|WindowManager.LayoutParams.SOFT_INPUT_STATE_ALWAYS_HIDDEN);''',
'''    setContentView(root);
    getWindow().setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_ADJUST_RESIZE|WindowManager.LayoutParams.SOFT_INPUT_STATE_ALWAYS_HIDDEN);
    // Samsung edge-to-edge can ignore ADJUST_RESIZE. If the window content
    // stays underneath IME, add only the overlap; if already resized, add 0.
    // This moves mic + clear + Save above keyboard together, without
    // rerendering the EditText or discarding typed/recognized draft text.
    if(android.os.Build.VERSION.SDK_INT>=30){
      root.setOnApplyWindowInsetsListener((view,insets)->{
        final int keyboardInset=insets.getInsets(android.view.WindowInsets.Type.ime()).bottom;
        final boolean keyboardVisible=insets.isVisible(android.view.WindowInsets.Type.ime());
        root.post(()->{
          if(isFinishing()||isDestroyed())return;
          int overlap=0;
          if(keyboardVisible&&keyboardInset>0){
            android.graphics.Rect win=getWindowManager().getCurrentWindowMetrics().getBounds();
            int top=win.bottom-keyboardInset;
            int[] xy=new int[2];root.getLocationOnScreen(xy);
            overlap=Math.max(0,xy[1]+root.getHeight()-top);
            overlap=Math.min(overlap,Math.max(0,root.getHeight()-dp*9));
          }
          if(root.getPaddingBottom()!=overlap)
            root.setPadding(root.getPaddingLeft(),root.getPaddingTop(),root.getPaddingRight(),overlap);
        });
        return insets;
      });
      root.requestApplyInsets();
    }''')
P.write_text(s,encoding="utf-8")
assert "new MoaMomentVoice(this,new MoaMomentVoice.Listener()" in s
assert "MoaMomentDirectDiaryStore.requestSync(this)" in s
print("MOA_R87_NATIVE_MEMO_UI_ONLY_PATCH=PASS")
