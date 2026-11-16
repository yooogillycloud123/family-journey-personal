package com.juhyeon.familyjourney;

import android.app.Activity;
import android.app.Application;
import android.content.ContentProvider;
import android.content.ContentValues;
import android.content.Intent;
import android.database.Cursor;
import android.net.Uri;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.view.View;
import android.view.ViewGroup;
import android.webkit.WebMessage;
import android.webkit.WebMessagePort;
import android.webkit.WebView;
import org.json.JSONObject;
import java.lang.ref.WeakReference;

/** Independent photo-picker command/result bridge. Never reads or mutates the existing Gallery owner. */
public final class MoaR651PickerBridgeProvider extends ContentProvider implements Application.ActivityLifecycleCallbacks {
  private static final String ORIGIN="https://familyjourney.local";
  private static final String PREF="moa_r651_picker_result";
  private final Handler handler=new Handler(Looper.getMainLooper());
  private WeakReference<Activity> owner=new WeakReference<>(null);
  private WeakReference<WebView> attached=new WeakReference<>(null);
  private WebMessagePort recv;
  private boolean portConfirmed=false;
  private long lastOfferAt=0L;

  @Override public boolean onCreate(){
    ((Application)getContext().getApplicationContext()).registerActivityLifecycleCallbacks(this);
    return true;
  }
  private WebView find(View v){
    if(v instanceof WebView)return(WebView)v;
    if(v instanceof ViewGroup){ViewGroup g=(ViewGroup)v;for(int i=0;i<g.getChildCount();i++){
      WebView w=find(g.getChildAt(i));if(w!=null)return w;
    }}return null;
  }
  private void log(String event){android.util.Log.i("MOA_R651",event);}
  private boolean trusted(WebView web){
    if(web==null)return false;
    String url=web.getUrl();return url!=null&&(url.equals(ORIGIN+"/")||url.startsWith(ORIGIN+"/"));
  }
  private void attach(Activity activity){
    if(activity==null||activity.isFinishing()||activity.isDestroyed()||activity instanceof MoaR651PhotoPickerActivity)return;
    WebView web=find(activity.getWindow().getDecorView());
    if(!trusted(web))return;
    if(attached.get()==web && recv!=null){
      if(portConfirmed){deliverPending();return;}
      if(android.os.SystemClock.uptimeMillis()-lastOfferAt<700L)return;
    }
    try{
      if(recv!=null)recv.close();
      WebMessagePort[] pair=web.createWebMessageChannel();
      final WebView target=web;
      pair[0].setWebMessageCallback(new WebMessagePort.WebMessageCallback(){
        @Override public void onMessage(WebMessagePort port,WebMessage message){
          if(owner.get()!=activity||attached.get()!=target||!trusted(target))return;
          onCommand(activity,message.getData());
        }
      });
      owner=new WeakReference<>(activity);attached=new WeakReference<>(web);recv=pair[0];
      portConfirmed=false;lastOfferAt=android.os.SystemClock.uptimeMillis();
      web.postWebMessage(new WebMessage("MOA_R651_PORT",new WebMessagePort[]{pair[1]}),Uri.parse(ORIGIN));
      log("BRIDGE_OFFERED");
      deliverPending();
    }catch(Throwable err){log("BRIDGE_UNAVAILABLE:"+err.getClass().getSimpleName());recv=null;}
  }
  private void onCommand(Activity activity,String text){
    try{
      JSONObject cmd=new JSONObject(text);String type=cmd.optString("type","");
      if("hello".equals(type)){portConfirmed=true;log("BRIDGE_READY");deliverPending();return;}
      if("open".equals(type)){
        String day=cmd.optString("day","");if(!day.matches("\\d{4}-\\d{2}-\\d{2}"))return;
        if(!activity.hasWindowFocus()||activity.isFinishing())return;
        Intent intent=new Intent(activity,MoaR651PhotoPickerActivity.class);
        intent.putExtra("moa_day",day);
        log("PHOTO_PICKER_LAUNCH_REQUEST");
        try{activity.startActivity(intent);}catch(Throwable error){
          log("PICKER_LAUNCH_FAILED:"+error.getClass().getSimpleName());
          if(recv!=null)recv.postMessage(new WebMessage("{\"type\":\"picker_open_failed\"}"));
        }
      }else if("saved_ack".equals(type)){
        String token=cmd.optString("token","");String stored=getContext().getSharedPreferences(PREF,0).getString("result","");
        if(!stored.isEmpty()&&token.equals(new JSONObject(stored).optString("token"))){
          getContext().getSharedPreferences(PREF,0).edit().remove("result").apply();
          log("PICKER_RESULT_ACK");
        }
      }
    }catch(Throwable err){log("BRIDGE_COMMAND_ERROR:"+err.getClass().getSimpleName());}
  }
  private void deliverPending(){
    if(recv==null)return;
    String result=getContext().getSharedPreferences(PREF,0).getString("result","");
    if(result.isEmpty())return;
    try{recv.postMessage(new WebMessage(result));log("PICKER_RESULT_DELIVERED");}
    catch(Throwable err){log("RESULT_POST_FAILED:"+err.getClass().getSimpleName());}
  }
  private void schedule(Activity activity){
    for(long delay:new long[]{100,450,1100,2500,4500})handler.postDelayed(()->attach(activity),delay);
  }
  @Override public void onActivityCreated(Activity a,Bundle b){schedule(a);}
  @Override public void onActivityResumed(Activity a){
    if(a==owner.get())log("PARENT_RESUMED_OWNER");
    schedule(a);
  }
  @Override public void onActivityStarted(Activity a){}
  @Override public void onActivityPaused(Activity a){if(a==owner.get())log("PARENT_PAUSED_OWNER");}
  @Override public void onActivityStopped(Activity a){}
  @Override public void onActivitySaveInstanceState(Activity a,Bundle b){}
  @Override public void onActivityDestroyed(Activity a){if(owner.get()==a){if(recv!=null)try{recv.close();}catch(Throwable ignored){}recv=null;owner.clear();attached.clear();}}
  @Override public Cursor query(Uri uri,String[] projection,String selection,String[] args,String sort){return null;}
  @Override public String getType(Uri uri){return null;}
  @Override public Uri insert(Uri uri,ContentValues v){return null;}
  @Override public int delete(Uri uri,String where,String[] args){return 0;}
  @Override public int update(Uri uri,ContentValues values,String where,String[] args){return 0;}
}