package com.juhyeon.familyjourney;

import android.app.Activity;
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
  private String id; private EditText text;
  @Override protected void onCreate(Bundle b){
    super.onCreate(b);id=getIntent().getStringExtra("id");
    if(id==null||!id.matches("v?\\d{1,19}")){finish();return;}
    LinearLayout l=new LinearLayout(this);l.setPadding(32,28,32,24);l.setOrientation(LinearLayout.VERTICAL);l.setBackgroundColor(Color.WHITE);
    TextView title=new TextView(this);title.setText("방금 찍은 사진·영상 · 모아 시간대별 메모");title.setTextSize(20);title.setTextColor(0xff243140);title.setTypeface(null,Typeface.BOLD);
    l.addView(title);
    TextView explain=new TextView(this);explain.setText("기억나는 말을 적거나 음성으로 말해 주세요. 모아를 다시 열면 해당 촬영 시간대에 동기화됩니다.");explain.setPadding(0,20,0,15);explain.setTextSize(14);explain.setTextColor(0xff39495a);l.addView(explain);
    text=new EditText(this);text.setMinLines(4);text.setMaxLines(7);text.setGravity(48);text.setHint("지금 무슨 일이 있었나요?");
    text.setTextSize(17);l.addView(text);
    try{JSONObject j=new JSONObject(MoaMomentCaptureService.prefs(this).getString("m:"+id,"{}"));text.setText(j.optString("note",""));}catch(Exception ignored){}
    Button mic=new Button(this);mic.setText("🎙 음성으로 말하기");l.addView(mic);mic.setOnClickListener(v->{
      try{Intent recog=new Intent(RecognizerIntent.ACTION_RECOGNIZE_SPEECH);
      recog.putExtra(RecognizerIntent.EXTRA_LANGUAGE_MODEL,RecognizerIntent.LANGUAGE_MODEL_FREE_FORM);
      recog.putExtra(RecognizerIntent.EXTRA_LANGUAGE,"ko-KR");recog.putExtra(RecognizerIntent.EXTRA_PROMPT,"사진을 찍은 순간의 이야기를 말해 주세요.");
      startActivityForResult(recog,91);}catch(Exception x){Toast.makeText(this,"음성 인식 앱이 없어 키보드 마이크를 사용하세요.",Toast.LENGTH_LONG).show();}
    });
    Button save=new Button(this);save.setText("모아 일기에 메모 저장");l.addView(save);
    save.setOnClickListener(v->{
      try{String previous=MoaMomentCaptureService.prefs(this).getString("m:"+id,"");if(previous.isEmpty()){Toast.makeText(this,"사진 기록을 찾지 못했습니다.",Toast.LENGTH_LONG).show();return;}
        String note=text.getText().toString().trim();\n        if(note.isEmpty()){Toast.makeText(this,"메모를 입력하거나 음성으로 말한 뒤 저장해 주세요.",Toast.LENGTH_LONG).show();return;}\n        JSONObject data=new JSONObject(previous);data.put("note",note);data.put("memoSaved",true);data.put("updatedAt",System.currentTimeMillis());
        if(!MoaMomentCaptureService.prefs(this).edit().putString("m:"+id,data.toString()).commit())throw new Exception("저장 오류");
        Toast.makeText(this,"기록 저장됨 · 모아에서 해당 시간대 확인",Toast.LENGTH_SHORT).show();finish();
      }catch(Exception x){Toast.makeText(this,"저장 실패 "+x,Toast.LENGTH_LONG).show();}
    });
    ScrollView sc=new ScrollView(this);sc.addView(l);setContentView(sc);
    getWindow().setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_ADJUST_RESIZE);
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
