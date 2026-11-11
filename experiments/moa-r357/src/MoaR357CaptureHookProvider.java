package com.juhyeon.familyjourney;

import android.app.Activity;
import android.app.Application;
import android.content.ContentProvider;
import android.content.ContentValues;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.database.Cursor;
import android.net.Uri;
import android.os.Bundle;
import android.text.Editable;
import android.text.TextWatcher;
import android.view.Gravity;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup;
import android.widget.CheckBox;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.TextView;
import org.json.JSONObject;
import java.util.WeakHashMap;

/** Separate, optional R357 UI decorator; NEVER replaces or recompiles the user-Golden Activity. */
public final class MoaR357CaptureHookProvider extends ContentProvider implements Application.ActivityLifecycleCallbacks {
  private static final String CAPTURE_PREF="moa_camera_native_v1";
  private static final String TARGET="com.juhyeon.familyjourney.MoaMomentMemoRecorderActivity";
  private final WeakHashMap<Activity,Boolean> attached=new WeakHashMap<>();
  private Application application;
  @Override public boolean onCreate(){
    Context ctx=getContext();if(ctx==null)return false;
    application=(Application)ctx.getApplicationContext();
    application.registerActivityLifecycleCallbacks(this);
    return true;
  }
  @Override public void onActivityResumed(Activity activity){
    if(activity==null||!TARGET.equals(activity.getClass().getName()))return;
    activity.getWindow().getDecorView().postDelayed(()->install(activity),110);
  }
  private int dp(Context c,int v){return (int)(v*c.getResources().getDisplayMetrics().density+0.5f);}
  private static TextView findTitle(View v){
    if(v instanceof TextView){String text=String.valueOf(((TextView)v).getText());
      if(text.contains("모아")&&text.contains("순간")&&text.contains("기록"))return (TextView)v;}
    if(v instanceof ViewGroup){ViewGroup p=(ViewGroup)v;for(int i=0;i<p.getChildCount();i++){
      TextView t=findTitle(p.getChildAt(i));if(t!=null)return t;}}
    return null;
  }
  private static TextView findSave(View v){
    if(v instanceof TextView && v.isClickable()){
      String text=String.valueOf(((TextView)v).getText());
      if(text.contains("일기 저장")||text.contains("일기에 메모 저장"))return (TextView)v;
    }
    if(v instanceof ViewGroup){ViewGroup p=(ViewGroup)v;for(int i=0;i<p.getChildCount();i++){
      TextView t=findSave(p.getChildAt(i));if(t!=null)return t;}}
    return null;
  }
  private SharedPreferences prefs(Context c){return c.getSharedPreferences(CAPTURE_PREF,Context.MODE_PRIVATE);}
  private JSONObject draft(Context c,String id){try{return new JSONObject(prefs(c).getString("m:"+id,"{}"));}catch(Exception e){return new JSONObject();}}
  private void mark(Context c,String status){prefs(c).edit().putString("r357hookStatus",status).apply();}
  private void commitChoice(Activity activity,String id,boolean checked,String list){
    try{
      SharedPreferences sp=prefs(activity);
      String original=sp.getString("m:"+id,null);
      if(original==null||original.isEmpty()){mark(activity,"CAPTURE_NOT_FOUND");return;}
      JSONObject obj=new JSONObject(original);
      String safe=String.valueOf(list).trim();if(safe.length()>70)safe=safe.substring(0,70);
      obj.put("naverQuickFavorite",checked);
      obj.put("naverQuickList",checked?safe:"");
      obj.put("naverQuickRequestedAt",System.currentTimeMillis());
      if(!sp.edit().putString("m:"+id,obj.toString()).commit())throw new Exception("PREFS_COMMIT_FAILED");
      mark(activity,checked?"SAVED_WITH_NAVER_INTENT":"SAVED_NO_NAVER_INTENT");
    }catch(Exception e){mark(activity,"DRAFT_UPDATE_FAILED");}
  }
  private void install(Activity activity){
    if(activity.isFinishing()||activity.isDestroyed()||attached.containsKey(activity))return;
    Intent intent=activity.getIntent();String id=intent==null?null:intent.getStringExtra("id");
    if(id==null||!id.matches("v?[0-9]{1,19}")){mark(activity,"INVALID_CAPTURE_ID");return;}
    View root=activity.getWindow().getDecorView();TextView title=findTitle(root);
    if(title==null || !(title.getParent() instanceof LinearLayout)){
      mark(activity,"ORIGINAL_TITLE_NOT_FOUND_PRESERVED");return;
    }
    TextView save=findSave(root);
    if(save==null){mark(activity,"ORIGINAL_SAVE_BUTTON_NOT_FOUND_PRESERVED");return;}
    LinearLayout parent=(LinearLayout)title.getParent();int originalIndex=parent.indexOfChild(title);
    if(originalIndex<0){mark(activity,"TITLE_NOT_ATTACHED");return;}
    JSONObject old=draft(activity,id);
    LinearLayout header=new LinearLayout(activity);header.setOrientation(LinearLayout.HORIZONTAL);
    header.setGravity(Gravity.CENTER_VERTICAL);
    ViewGroup.LayoutParams oldParams=title.getLayoutParams();
    parent.removeView(title);
    LinearLayout.LayoutParams headingP=new LinearLayout.LayoutParams(0,ViewGroup.LayoutParams.WRAP_CONTENT,1f);
    header.addView(title,headingP);
    CheckBox checkbox=new CheckBox(activity);checkbox.setText("장소 저장");
    checkbox.setTextSize(13f);checkbox.setButtonTintList(android.content.res.ColorStateList.valueOf(0xffb52b69));
    checkbox.setChecked(old.optBoolean("naverQuickFavorite",prefs(activity).getBoolean("r357.quick.default.checked",false)));
    header.addView(checkbox,new LinearLayout.LayoutParams(ViewGroup.LayoutParams.WRAP_CONTENT,dp(activity,48)));
    parent.addView(header,originalIndex,oldParams);
    EditText folder=new EditText(activity);folder.setSingleLine(true);folder.setTextSize(14f);
    folder.setHint("저장 리스트 이름");folder.setMaxLines(1);folder.setMaxEms(24);
    folder.setText(old.optString("naverQuickList",""));
    LinearLayout.LayoutParams inputP=new LinearLayout.LayoutParams(dp(activity,174),dp(activity,45));
    inputP.gravity=Gravity.END;inputP.bottomMargin=dp(activity,2);
    parent.addView(folder,originalIndex+1,inputP);
    folder.setVisibility(checkbox.isChecked()?View.VISIBLE:View.GONE);
    checkbox.setOnCheckedChangeListener((b,yes)->folder.setVisibility(yes?View.VISIBLE:View.GONE));
    // Observe original Save touch BEFORE original View.OnClickListener runs;
    // return false so the original recorder/diary save remains untouched.
    save.setOnTouchListener((v,event)->{
      if(event.getActionMasked()==MotionEvent.ACTION_DOWN){
        commitChoice(activity,id,checkbox.isChecked(),folder.getText().toString());
      }
      return false;
    });
    attached.put(activity,Boolean.TRUE);mark(activity,"NATIVE_COMPACT_UI_INSTALLED");
  }
  @Override public void onActivityDestroyed(Activity activity){attached.remove(activity);}
  @Override public void onActivityCreated(Activity a,Bundle b){}
  @Override public void onActivityStarted(Activity a){}
  @Override public void onActivityPaused(Activity a){}
  @Override public void onActivityStopped(Activity a){}
  @Override public void onActivitySaveInstanceState(Activity a,Bundle b){}
  @Override public Cursor query(Uri uri,String[] projection,String selection,String[] args,String sort){return null;}
  @Override public String getType(Uri uri){return null;}
  @Override public Uri insert(Uri uri,ContentValues v){return null;}
  @Override public int delete(Uri uri,String selection,String[] args){return 0;}
  @Override public int update(Uri uri,ContentValues vals,String where,String[] args){return 0;}
}
