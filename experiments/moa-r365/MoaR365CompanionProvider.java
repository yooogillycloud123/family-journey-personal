package com.juhyeon.familyjourney;

import android.app.Activity;
import android.app.Application;
import android.content.ContentProvider;
import android.content.ContentValues;
import android.content.Context;
import android.content.SharedPreferences;
import android.database.Cursor;
import android.net.Uri;
import android.content.ContentUris;
import android.provider.MediaStore;
import android.media.ExifInterface;
import android.media.MediaMetadataRetriever;
import java.io.InputStream;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.view.View;
import android.view.ViewGroup;
import android.webkit.WebView;
import org.json.JSONArray;
import org.json.JSONObject;
import java.lang.reflect.Method;
import java.util.Map;

/** Additive R365 checkpoint. No replacement of R345/R355/R361 native classes. */
public final class MoaR365CompanionProvider extends ContentProvider
  implements Application.ActivityLifecycleCallbacks {
  private static final String PREF="moa_camera_native_v1";
  private static final String HOST="com.juhyeon.familyjourney.HostActivity";
  private static final Handler MAIN=new Handler(Looper.getMainLooper());
  private SharedPreferences prefs;
  private final SharedPreferences.OnSharedPreferenceChangeListener observer=(sp,key)->{
    if(key==null||!key.startsWith("m:"))return;
    final String id=key.substring(2);
    if(!id.matches("v?[0-9]{1,19}"))return;
    // The restored native recorder writes first, then R361 attaches optional
    // fields. Read AFTER both callbacks instead of racing Save.ACTION_DOWN.
    snapshot(id); // synchronous observation BEFORE Golden inbox ACK deletion
    MAIN.postDelayed(()->snapshot(id),80);
    MAIN.postDelayed(()->snapshot(id),350);
  };
  @Override public boolean onCreate(){
    Context ctx=getContext();if(ctx==null)return false;
    prefs=ctx.getSharedPreferences(PREF,Context.MODE_PRIVATE);
    prefs.registerOnSharedPreferenceChangeListener(observer);
    ((Application)ctx.getApplicationContext()).registerActivityLifecycleCallbacks(this);
    return true;
  }
  private JSONObject obj(String value){
    try{return new JSONObject(value==null?"{}":value);}catch(Exception e){return new JSONObject();}
  }
  private void mark(String status){
    if(prefs!=null)prefs.edit().putString("r365Status",status).apply();
  }
  private void snapshot(String id){
    if(prefs==null)return;
    try{
      JSONObject m=obj(prefs.getString("m:"+id,"{}"));
      if(!id.equals(m.optString("id","")))return;
      JSONObject prior=obj(prefs.getString("r365choice:"+id,"{}"));
      boolean on=m.has("naverQuickFavorite")?m.optBoolean("naverQuickFavorite",false):
        prior.optBoolean("checked",false);
      String list=m.has("naverQuickList")?m.optString("naverQuickList",""):
        prior.optString("list","");
      if(list.length()>70)list=list.substring(0,70);
      if(!on){if(m.has("naverQuickFavorite")){
        prefs.edit().remove("r365choice:"+id).remove("r365task:"+id).apply();
      }return;}
      // Preserve the explicit target even when the Golden Save rewrites m:id.
      JSONObject choice=new JSONObject().put("checked",true).put("list",list);
      prefs.edit().putString("r365choice:"+id,choice.toString()).apply();
      if(!m.optBoolean("memoSaved",false))return;
      long updated=m.optLong("updatedAt",0);
      long age=System.currentTimeMillis()-updated;
      if(updated<=0||age<0||age>600000L)return;
      JSONObject q=new JSONObject()
        .put("id",id).put("checked",true).put("list",list)
        .put("note",m.optString("note","").trim())
        .put("at",m.optLong("at",0))
        .put("sourceUpdatedAt",updated)
        .put("requestedAt",updated);
      JSONObject old=obj(prefs.getString("r365task:"+id,"{}"));
      if(old.optLong("sourceUpdatedAt",0)==updated &&
          list.equals(old.optString("list","")))return;
      if(prefs.edit().putString("r365task:"+id,q.toString()).commit())
        mark("R365_NATIVE_TASK_DURABLE");
    }catch(Throwable ignored){mark("R365_NATIVE_TASK_SNAPSHOT_ERROR");}
  }
  private double[] exactMediaGps(String id){
    try{
      boolean video=id.startsWith("v");
      String number=video?id.substring(1):id;
      if(!number.matches("[0-9]{1,19}"))return null;
      Uri uri=ContentUris.withAppendedId(video?
        MediaStore.Video.Media.EXTERNAL_CONTENT_URI:MediaStore.Images.Media.EXTERNAL_CONTENT_URI,
        Long.parseLong(number));
      double lat=Double.NaN,lon=Double.NaN;
      Context ctx=getContext();if(ctx==null)return null;
      if(video){
        MediaMetadataRetriever mmr=new MediaMetadataRetriever();
        try{
          mmr.setDataSource(ctx,uri);
          String location=mmr.extractMetadata(MediaMetadataRetriever.METADATA_KEY_LOCATION);
          if(location!=null){
            Matcher match=Pattern.compile("([+-][0-9]+(?:\\.[0-9]+)?)([+-][0-9]+(?:\\.[0-9]+)?)").matcher(location);
            if(match.find()){lat=Double.parseDouble(match.group(1));lon=Double.parseDouble(match.group(2));}
          }
        }finally{mmr.release();}
      }else{
        try(InputStream in=ctx.getContentResolver().openInputStream(uri)){
          if(in!=null){
            float[] coordinates=new float[2];
            if(new ExifInterface(in).getLatLong(coordinates)){
              lat=coordinates[0];lon=coordinates[1];
            }
          }
        }
      }
      if(lat>=33&&lat<=39&&lon>=124&&lon<=132)return new double[]{lat,lon};
    }catch(Throwable ignored){/* Scoped media access can redact GPS; JS uses native photo index. */}
    return null;
  }
  private boolean isHost(Activity a){
    return a!=null&&!a.isFinishing()&&!a.isDestroyed()&&
      (HOST.equals(a.getClass().getName())||
       a.getClass().getName().endsWith("MoaMomentHostActivity"));
  }
  private WebView findWeb(View v){
    if(v instanceof WebView)return (WebView)v;
    if(v instanceof ViewGroup){ViewGroup p=(ViewGroup)v;
      for(int i=0;i<p.getChildCount();i++){
        WebView w=findWeb(p.getChildAt(i));if(w!=null)return w;
      }
    }return null;
  }
  private void hiddenStart(Activity a){
    if(!isHost(a))return;
    try{
      // Only reflect within this application's OWN existing controller.
      // start() then setHidden() execute on the SAME UI thread before redraw.
      Class<?> c=Class.forName("com.juhyeon.familyjourney.MoaNaverWebProbeController");
      Method status=c.getMethod("statusJson");
      JSONObject before=obj((String)status.invoke(null));
      if(before.optBoolean("running",false))return;
      c.getMethod("onHostResumed",Activity.class).invoke(null,a);
      Method start=c.getDeclaredMethod("start",Activity.class);
      Method hide=c.getDeclaredMethod("setHidden",Activity.class,boolean.class);
      start.setAccessible(true);hide.setAccessible(true);
      start.invoke(null,a);
      hide.invoke(null,a,true);
      JSONObject after=obj((String)status.invoke(null));
      mark(after.optBoolean("running",false)&&after.optBoolean("hidden",false)
        ?"R365_PREWARM_HIDDEN":"R365_PREWARM_NOT_CONFIRMED");
    }catch(Throwable ignored){mark("R365_PREWARM_FAILED");}
  }
  private void deliver(Activity a,int attempts){
    if(!isHost(a)||attempts>16)return;
    MAIN.postDelayed(()->{
      if(!isHost(a))return;
      WebView w=findWeb(a.getWindow().getDecorView());
      String url=w==null?"":String.valueOf(w.getUrl());
      if(w==null||!(url.startsWith("https://familyjourney.local/")||
        url.startsWith("https://appassets.androidplatform.net/")||
        url.startsWith("file:///android_asset/"))){
        deliver(a,attempts+1);return;
      }
      String pref="(function(){try{return localStorage.getItem('moa.naver.offscreen.try.v1')!=='off'}catch(e){return true}})()";
      try{w.evaluateJavascript(pref,value->{
        if(!"false".equals(value))hiddenStart(a);
      });}catch(Throwable ignored){}
      JSONArray arr=new JSONArray();
      for(Map.Entry<String,?> row:prefs.getAll().entrySet()){
        if(arr.length()>=100)break;
        if(!row.getKey().startsWith("r365task:") || !(row.getValue() instanceof String))continue;
        try{arr.put(new JSONObject((String)row.getValue()));}catch(Exception ignored){}
      }
      if(arr.length()==0)return;
      String packet=JSONObject.quote(arr.toString());
      String js="(function(){var b=window.MoaR365QuickBridge;return b&&typeof b.receiveNative==='function'?b.receiveNative("
        +packet+"):'NOT_READY'})()";
      try{w.evaluateJavascript(js,response->{
        if(response!=null&&response.contains("ACCEPTED"))mark("R365_TASKS_DELIVERED");
        else deliver(a,attempts+1);
      });}catch(Throwable ignored){deliver(a,attempts+1);}
    },attempts==0?420L:700L);
  }
  @Override public void onActivityResumed(Activity a){
    if(isHost(a))deliver(a,0);
  }
  @Override public void onActivityCreated(Activity a,Bundle b){}
  @Override public void onActivityStarted(Activity a){}
  @Override public void onActivityPaused(Activity a){}
  @Override public void onActivityStopped(Activity a){}
  @Override public void onActivitySaveInstanceState(Activity a,Bundle b){}
  @Override public void onActivityDestroyed(Activity a){}
  @Override public Cursor query(Uri uri,String[] projection,String selection,String[] args,String sort){return null;}
  @Override public String getType(Uri uri){return null;}
  @Override public Uri insert(Uri uri,ContentValues values){return null;}
  @Override public int delete(Uri uri,String where,String[] args){return 0;}
  @Override public int update(Uri uri,ContentValues values,String where,String[] args){return 0;}
}