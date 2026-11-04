package com.juhyeon.familyjourney;

import android.app.Activity;
import android.app.NotificationManager;
import android.os.Bundle;
import android.content.Intent;
import android.speech.RecognizerIntent;
import android.graphics.Color;
import android.graphics.Typeface;
import android.view.View;
import android.view.WindowManager;
import android.widget.*;
import org.json.JSONObject;
import java.util.ArrayList;
import java.util.Locale;

/** Single-photo native input shown on tapping the capture notification. */
public final class MoaMomentMemoActivity extends Activity {
  private String id; private EditText text; private MoaMomentVoice speech; private Button micButton;
  @Override protected void onCreate(Bundle b){
    super.onCreate(b);id=getIntent().getStringExtra("id");
    if(id==null||!id.matches("v?\\d{1,19}")){finish();return;}
    // A user TAP on the capture notification may come from Samsung secure
    // camera over keyguard. Show this one intended input Activity in front of
    // keyguard; never automatically dismiss authentication or bypass unlock.
    android.app.KeyguardManager guard=getSystemService(android.app.KeyguardManager.class);
    if(guard!=null&&guard.isKeyguardLocked())setShowWhenLocked(true);
    LinearLayout l=new LinearLayout(this);l.setPadding(32,28,32,24);l.setOrientation(LinearLayout.VERTICAL);l.setBackgroundColor(Color.WHITE);
    TextView title=new TextView(this);title.setText("방금 찍은 사진·영상 · 모아 시간대별 메모");title.setTextSize(20);title.setTextColor(0xff243140);title.setTypeface(null,Typeface.BOLD);
    l.addView(title);
    TextView explain=new TextView(this);explain.setText("기억나는 말을 적거나 음성으로 말해 주세요. 모아를 다시 열면 해당 촬영 시간대에 동기화됩니다.");explain.setPadding(0,20,0,15);explain.setTextSize(14);explain.setTextColor(0xff39495a);l.addView(explain);
    text=new EditText(this);text.setMinLines(4);text.setMaxLines(7);text.setGravity(48);text.setHint("지금 무슨 일이 있었나요?");
    text.setTextSize(17);l.addView(text);
    try{JSONObject j=new JSONObject(MoaMomentCaptureService.prefs(this).getString("m:"+id,"{}"));text.setText(j.optString("note",""));}catch(Exception ignored){}
    Button mic=new Button(this);micButton=mic;mic.setText("🎙 음성으로 말하기");
    mic.setOnClickListener(v->beginInlineVoice());
    Button save=new Button(this);save.setText("모아 일기에 메모 저장");
    save.setOnClickListener(v->{
      try{String previous=MoaMomentCaptureService.prefs(this).getString("m:"+id,"");if(previous.isEmpty()){Toast.makeText(this,"사진 기록을 찾지 못했습니다.",Toast.LENGTH_LONG).show();return;}
        String note=text.getText().toString().trim();
        if(note.isEmpty()){Toast.makeText(this,"메모를 입력하거나 음성으로 말한 뒤 저장해 주세요.",Toast.LENGTH_LONG).show();return;}
        JSONObject data=new JSONObject(previous);data.put("note",note);data.put("memoSaved",true);data.put("updatedAt",System.currentTimeMillis());
        if(!MoaMomentCaptureService.prefs(this).edit().putString("m:"+id,data.toString()).commit())throw new Exception("저장 오류");
        MoaMomentDirectDiaryStore.requestSync(this);
        // Overlay-opened memo does not auto-cancel its event notification.
        // Dismiss ONLY this media item after the native draft commits.
        try{NotificationManager nm=getSystemService(NotificationManager.class);
          if(nm!=null)nm.cancel(43000+(id.hashCode()&0x7fff));}catch(Exception ignored){}
        Toast.makeText(this,"메모 임시 저장 완료 · 모아 일기 동기화 대기",Toast.LENGTH_SHORT).show();finish();
      }catch(Exception x){Toast.makeText(this,"저장 실패 "+x,Toast.LENGTH_LONG).show();}
    });
    LinearLayout root=new LinearLayout(this);
    root.setOrientation(LinearLayout.VERTICAL);
    root.setBackgroundColor(Color.WHITE);
    ScrollView sc=new ScrollView(this);
    sc.setFillViewport(true);
    sc.addView(l);
    root.addView(sc,new LinearLayout.LayoutParams(-1,0,1));
    LinearLayout footer=new LinearLayout(this);
    footer.setOrientation(LinearLayout.VERTICAL);
    footer.setBackgroundColor(0xfffaf8f7);
    int dp=(int)(getResources().getDisplayMetrics().density*16+0.5f);
    footer.setPadding(dp,dp/2,dp,dp);
    footer.addView(mic,new LinearLayout.LayoutParams(-1,dp*4));
    footer.addView(save,new LinearLayout.LayoutParams(-1,dp*4));
    root.addView(footer,new LinearLayout.LayoutParams(-1,-2));
    setContentView(root);
    getWindow().setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_ADJUST_RESIZE|WindowManager.LayoutParams.SOFT_INPUT_STATE_ALWAYS_HIDDEN);
  }
  // R78: microphone stays INSIDE this Activity (also on the secure lockscreen).
  private void beginInlineVoice(){
    if(!MoaMomentVoice.hasPermission(this)){
      Toast.makeText(this,"마이크 권한을 허용한 후 음성으로 기록할 수 있습니다.",Toast.LENGTH_SHORT).show();
      requestPermissions(new String[]{android.Manifest.permission.RECORD_AUDIO},7801);
      return;
    }
    if(speech!=null){speech.stop();speech=null;}
    final String beforeSpeech=text.getText().toString().trim();
    speech=new MoaMomentVoice(this,new MoaMomentVoice.Listener(){
      @Override public void onListening(){micButton.setText("🎙 듣는 중…");micButton.setEnabled(false);}
      @Override public void onText(String recognized){
        String next=beforeSpeech.isEmpty()?recognized:beforeSpeech+" "+recognized;
        text.setText(next);text.setSelection(text.length());
      }
      @Override public void onFailure(String message){Toast.makeText(MoaMomentMemoActivity.this,message,Toast.LENGTH_LONG).show();}
      @Override public void onFinished(){micButton.setText("🎙 음성으로 말하기");micButton.setEnabled(true);}
    });
    speech.start();
  }
  @Override public void onRequestPermissionsResult(int code,String[] permissions,int[] results){
    super.onRequestPermissionsResult(code,permissions,results);
    if(code==7801){
      if(results.length>0&&results[0]==android.content.pm.PackageManager.PERMISSION_GRANTED)beginInlineVoice();
      else Toast.makeText(this,"마이크 권한을 허용해야 음성 기록이 가능합니다.",Toast.LENGTH_LONG).show();
    }
  }
  @Override protected void onDestroy(){
    if(speech!=null){speech.stop();speech=null;}
    super.onDestroy();
  }
  @Override protected void onActivityResult(int code,int result,Intent data){
    super.onActivityResult(code,result,data);
    if(code==91&&result==RESULT_OK&&data!=null){
      ArrayList<String> words=data.getStringArrayListExtra(RecognizerIntent.EXTRA_RESULTS);
      if(words!=null&&!words.isEmpty()){String before=text.getText().toString().trim();
       text.setText(before.isEmpty()?words.get(0):before+" "+words.get(0));text.setSelection(text.length());}
    }
  }
}
