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
import android.webkit.WebView;
import org.json.JSONArray;
import org.json.JSONObject;
import java.util.WeakHashMap;

/** Separate, optional R357 UI decorator; NEVER replaces or recompiles the user-Golden Activity. */
public final class MoaR357CaptureHookProvider extends ContentProvider implements Application.ActivityLifecycleCallbacks {
  private static final String CAPTURE_PREF="moa_camera_native_v1";
  private static final String TARGET="com.juhyeon.familyjourney.MoaMomentMemoRecorderActivity";
  private final WeakHashMap<Activity,Boolean> attached=new WeakHashMap<>();
  private final WeakHashMap<Activity,SharedPreferences.OnSharedPreferenceChangeListener> listeners=new WeakHashMap<>();
  private final WeakHashMap<Activity,Boolean> writing=new WeakHashMap<>();
  private Application application;
  @Override public boolean onCreate(){
    Context ctx=getContext();if(ctx==null)return false;
    application=(Application)ctx.getApplicationContext();
    application.registerActivityLifecycleCallbacks(this);
    return true;
  }
  @Override public void onActivityResumed(Activity activity){
    try{
      if(activity==null)return;
      if(TARGET.equals(activity.getClass().getName()))activity.getWindow().getDecorView().postDelayed(()->{
        try{install(activity);}catch(Throwable failure){mark(activity,"UI_HOOK_ERROR_ORIGINAL_PRESERVED");}
      },110);
      else syncWebPrefs(activity);
    }catch(Throwable ignored){/* The Golden activity must never crash from this observer. */}
  }
  private void syncWebPrefs(Activity activity){
    if(activity==null||activity.isFinishing()||activity.isDestroyed())return;
    collectWebPrefs(activity,activity.getWindow().getDecorView());
  }
  private void collectWebPrefs(Activity activity,View view){
    if(view instanceof WebView){
      WebView web=(WebView)view;
      String url=String.valueOf(web.getUrl());
      if(url.startsWith("file:///android_asset/")||url.startsWith("https://appassets.androidplatform.net/assets/")){
        String script="(function(){try{return JSON.stringify({checked:localStorage.getItem('moa.r357.quick.default.checked')==='on',list:localStorage.getItem('fj.naver.targetlist')||''});}catch(e){return '{}';}})()";
        try{web.evaluateJavascript(script,value->{
          try{
            if(value==null||value.equals("null"))return;
            String json=new JSONArray("["+value+"]").getString(0);
            JSONObject o=new JSONObject(json);
            String list=o.optString("list","").trim();if(list.length()>70)list=list.substring(0,70);
            prefs(activity).edit().putBoolean("r357.quick.default.checked",o.optBoolean("checked",false))
              .putString("r357.quick.default.list",list).apply();
          }catch(Exception ignored){}
        });}catch(Exception ignored){}
      }
    }
    if(view instanceof ViewGroup){
      ViewGroup p=(ViewGroup)view;
      for(int i=0;i<p.getChildCount();i++)collectWebPrefs(activity,p.getChildAt(i));
    }
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
      final String chosen=checked?safe:"";
      if(obj.optBoolean("naverQuickFavorite",false)==checked &&
        chosen.equals(obj.optString("naverQuickList","")) && obj.optLong("naverQuickRequestedAt",0)>0)return;
      obj.put("naverQuickFavorite",checked);
      obj.put("naverQuickList",chosen);
      obj.put("naverQuickRequestedAt",System.currentTimeMillis());
      writing.put(activity,Boolean.TRUE);
      try{
        if(!sp.edit().putString("m:"+id,obj.toString()).commit())throw new Exception("PREFS_COMMIT_FAILED");
      }finally{writing.remove(activity);}
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
    CheckBox checkbox=new CheckBox(activity);checkbox.setText("장소 저장");
    checkbox.setTextSize(13f);checkbox.setButtonTintList(android.content.res.ColorStateList.valueOf(0xffb52b69));
    checkbox.setChecked(old.optBoolean("naverQuickFavorite",prefs(activity).getBoolean("r357.quick.default.checked",false)));
    EditText folder=new EditText(activity);folder.setSingleLine(true);folder.setTextSize(14f);
    folder.setHint("저장 리스트 이름");folder.setMaxLines(1);folder.setMaxEms(24);
    folder.setText(old.optString("naverQuickList",prefs(activity).getString("r357.quick.default.list","")));
    LinearLayout.LayoutParams inputP=new LinearLayout.LayoutParams(dp(activity,174),dp(activity,45));
    inputP.gravity=Gravity.END;inputP.bottomMargin=dp(activity,2);
    // Prepare UI fully before moving the existing title. Roll back on any
    // unexpected Android/OneUI layout exception; never leave a broken editor.
    try{
      parent.removeView(title);
      LinearLayout.LayoutParams headingP=new LinearLayout.LayoutParams(0,ViewGroup.LayoutParams.WRAP_CONTENT,1f);
      header.addView(title,headingP);
      header.addView(checkbox,new LinearLayout.LayoutParams(ViewGroup.LayoutParams.WRAP_CONTENT,dp(activity,48)));
      parent.addView(header,originalIndex,oldParams);
      parent.addView(folder,originalIndex+1,inputP);
    }catch(Throwable uiError){
      try{
        if(folder.getParent()==parent)parent.removeView(folder);
        if(header.getParent()==parent)parent.removeView(header);
        if(title.getParent() instanceof ViewGroup)((ViewGroup)title.getParent()).removeView(title);
        if(title.getParent()==null)parent.addView(title,Math.min(originalIndex,parent.getChildCount()),oldParams);
      }catch(Throwable ignored){}
      mark(activity,"COMPACT_UI_ABORT_ORIGINAL_RESTORED");
      return;
    }
    folder.setVisibility(checkbox.isChecked()?View.VISIBLE:View.GONE);
    // Optional intent gets persisted BEFORE original Save; never hijack its
    // touch/click listener or race it with delayed writes after activity exit.
    checkbox.setOnCheckedChangeListener((b,yes)->{
      folder.setVisibility(yes?View.VISIBLE:View.GONE);
      commitChoice(activity,id,yes,folder.getText().toString());
    });
    folder.addTextChangedListener(new TextWatcher(){
      @Override public void beforeTextChanged(CharSequence value,int start,int count,int after){}
      @Override public void onTextChanged(CharSequence value,int start,int before,int count){
        if(checkbox.isChecked())commitChoice(activity,id,true,value.toString());
      }
      @Override public void afterTextChanged(Editable value){}
    });
    // Golden recorder can rewrite the native draft on Save. Only attach these
    // optional keys to the completed draft, keeping its original note/voice.
    SharedPreferences originalPrefs=prefs(activity);
    SharedPreferences.OnSharedPreferenceChangeListener watcher=(sp,key)->{
      if(!("m:"+id).equals(key)||Boolean.TRUE.equals(writing.get(activity)))return;
      try{
        JSONObject updated=draft(activity,id);
        if(updated.optBoolean("memoSaved",false))
          commitChoice(activity,id,checkbox.isChecked(),folder.getText().toString());
      }catch(Throwable ignored){}
    };
    originalPrefs.registerOnSharedPreferenceChangeListener(watcher);
    listeners.put(activity,watcher);
    if(checkbox.isChecked())commitChoice(activity,id,true,folder.getText().toString());
    attached.put(activity,Boolean.TRUE);mark(activity,"NATIVE_COMPACT_UI_INSTALLED");
  }
  @Override public void onActivityDestroyed(Activity activity){
    SharedPreferences.OnSharedPreferenceChangeListener watcher=listeners.remove(activity);
    if(watcher!=null)try{prefs(activity).unregisterOnSharedPreferenceChangeListener(watcher);}catch(Throwable ignored){}
    writing.remove(activity);attached.remove(activity);
  }
  @Override public void onActivityCreated(Activity a,Bundle b){}
  @Override public void onActivityStarted(Activity a){}
  @Override public void onActivityPaused(Activity a){if(a!=null && !TARGET.equals(a.getClass().getName()))syncWebPrefs(a);}
  @Override public void onActivityStopped(Activity a){}
  @Override public void onActivitySaveInstanceState(Activity a,Bundle b){}
  @Override public Cursor query(Uri uri,String[] projection,String selection,String[] args,String sort){return null;}
  @Override public String getType(Uri uri){return null;}
  @Override public Uri insert(Uri uri,ContentValues v){return null;}
  @Override public int delete(Uri uri,String selection,String[] args){return 0;}
  @Override public int update(Uri uri,ContentValues vals,String where,String[] args){return 0;}
}
