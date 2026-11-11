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
import android.os.Handler;
import android.os.Looper;
import android.content.ContentUris;
import android.provider.MediaStore;
import android.media.ExifInterface;
import android.media.MediaMetadataRetriever;
import java.io.InputStream;
import java.util.regex.Pattern;
import java.util.regex.Matcher;
import java.util.HashMap;
import java.util.Map;
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
  private Application application;
  private final Handler main=new Handler(Looper.getMainLooper());
  private final Map<String,Choice> pending=new HashMap<>();
  private SharedPreferences watched;
  private SharedPreferences.OnSharedPreferenceChangeListener listener;
  private static final class Choice{
    final String id,list;final boolean checked;final long at;
    volatile boolean locationResolved;
    volatile double lat=Double.NaN,lon=Double.NaN;
    Choice(String id,boolean checked,String list){this.id=id;this.checked=checked;this.list=list;this.at=System.currentTimeMillis();}
  }
  @Override public boolean onCreate(){
    Context ctx=getContext();if(ctx==null)return false;
    application=(Application)ctx.getApplicationContext();
    application.registerActivityLifecycleCallbacks(this);
    watched=prefs(ctx);
    listener=(sp,k)->{
      if(k==null||!k.startsWith("m:"))return;
      String mediaId=k.substring(2);
      if(!pending.containsKey(mediaId))return;
      main.post(()->applyAfterOriginalSave(mediaId));
    };
    watched.registerOnSharedPreferenceChangeListener(listener);
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
  private static boolean precise(double lat,double lon){
    return Double.isFinite(lat)&&Double.isFinite(lon)&&lat>=33&&lat<=39&&lon>=124&&lon<=132;
  }
  private static double[] readNativeGps(Context ctx,String mediaId){
    boolean video=mediaId!=null&&mediaId.startsWith("v");
    if(mediaId==null||!mediaId.matches("v?[0-9]{1,19}"))return null;
    long id;try{id=Long.parseLong(video?mediaId.substring(1):mediaId);}catch(Exception e){return null;}
    Uri uri=ContentUris.withAppendedId(video?MediaStore.Video.Media.EXTERNAL_CONTENT_URI:
      MediaStore.Images.Media.EXTERNAL_CONTENT_URI,id);
    try{
      if(video){
        MediaMetadataRetriever r=new MediaMetadataRetriever();
        try{
          r.setDataSource(ctx,uri);
          String v=r.extractMetadata(MediaMetadataRetriever.METADATA_KEY_LOCATION);
          if(v==null)return null;
          Matcher m=Pattern.compile("^([+-][0-9]{1,2}(?:\\.[0-9]+)?)([+-][0-9]{1,3}(?:\\.[0-9]+)?).*$").matcher(v);
          if(!m.matches())return null;
          double lat=Double.parseDouble(m.group(1)),lon=Double.parseDouble(m.group(2));
          return precise(lat,lon)?new double[]{lat,lon}:null;
        }finally{r.release();}
      }
      try(InputStream input=ctx.getContentResolver().openInputStream(uri)){
        if(input==null)return null;
        float[] xy=new float[2];
        if(!new ExifInterface(input).getLatLong(xy))return null;
        double lat=xy[0],lon=xy[1];
        return precise(lat,lon)?new double[]{lat,lon}:null;
      }
    }catch(Throwable deniedOrAbsent){return null;}
  }
  private void applyAfterOriginalSave(String id){
    Choice choice=pending.get(id);
    if(choice==null)return;
    if(!choice.locationResolved&&System.currentTimeMillis()-choice.at<2100)return;
    SharedPreferences sp=watched;if(sp==null)return;
    String raw=sp.getString("m:"+id,null);
    if(raw==null||raw.isEmpty())return;
    try{
      JSONObject d=new JSONObject(raw);
      if(!d.optBoolean("memoSaved",false))return;
      String dest=choice.checked?choice.list:"";
      if(d.optBoolean("naverQuickFavorite",false)==choice.checked&&
        dest.equals(d.optString("naverQuickList",""))&&
        d.optLong("naverQuickRequestedAt",0)==choice.at){
          pending.remove(id);return;
      }
      d.put("naverQuickFavorite",choice.checked);
      d.put("naverQuickList",dest);
      d.put("naverQuickRequestedAt",choice.at);
      if(precise(choice.lat,choice.lon)){
        d.put("naverQuickGpsLat",choice.lat);
        d.put("naverQuickGpsLon",choice.lon);
      }
      if(!sp.edit().putString("m:"+id,d.toString()).commit())throw new Exception("COMMIT_FAILED");
      pending.remove(id);
      mark(application,choice.checked?"R361_NATIVE_OPT_IN_AFTER_SAVE":"R361_NATIVE_NO_NAVER_AFTER_SAVE");
    }catch(Exception e){mark(application,"R361_NATIVE_CHOICE_COMMIT_FAILED");}
  }
  private void afterSaveTouch(Activity a,String id,boolean checked,String rawList){
    String list=String.valueOf(rawList).trim();if(list.length()>70)list=list.substring(0,70);
    Choice choice=new Choice(id,checked,list);
    pending.put(id,choice);
    mark(a,"R361_NATIVE_INTENT_WAITING_FOR_ORIGINAL_SAVE");
    if(checked)new Thread(()->{
      double[] pair=readNativeGps(a.getApplicationContext(),id);
      main.post(()->{
        if(pending.get(id)!=choice)return;
        if(pair!=null){choice.lat=pair[0];choice.lon=pair[1];}
        choice.locationResolved=true;applyAfterOriginalSave(id);
      });
    },"moa-r361-exif").start();
    else choice.locationResolved=true;
    for(int delay:new int[]{100,300,700,1400,2600,4600})main.postDelayed(()->applyAfterOriginalSave(id),delay);
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
    checkbox.setOnCheckedChangeListener((b,yes)->folder.setVisibility(yes?View.VISIBLE:View.GONE));
    // Observe original Save touch BEFORE original View.OnClickListener runs;
    // return false so the original recorder/diary save remains untouched.
    save.setOnTouchListener((v,event)->{
      if(event.getActionMasked()==MotionEvent.ACTION_DOWN){
        afterSaveTouch(activity,id,checkbox.isChecked(),folder.getText().toString());
        // Original Save listener may persist its note after DOWN. Re-apply only
        // these optional fields after the original listener without replacing it.
        save.postDelayed(()->afterSaveTouch(activity,id,checkbox.isChecked(),folder.getText().toString()),120);
        save.postDelayed(()->afterSaveTouch(activity,id,checkbox.isChecked(),folder.getText().toString()),350);
      }
      return false;
    });
    attached.put(activity,Boolean.TRUE);mark(activity,"NATIVE_COMPACT_UI_INSTALLED");
  }
  @Override public void onActivityDestroyed(Activity activity){attached.remove(activity);}
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
