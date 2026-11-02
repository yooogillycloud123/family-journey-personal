package com.juhyeon.familyjourney;

import android.Manifest;
import android.app.Activity;
import android.app.Application;
import android.content.Context;
import android.content.pm.PackageManager;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.view.View;
import android.view.ViewGroup;
import android.webkit.JavascriptInterface;
import android.webkit.WebView;
import org.json.JSONArray;
import org.json.JSONObject;
import java.util.Map;
import java.util.WeakHashMap;

/**
 * Works WITH existing final HostActivity without subclassing or mutating its
 * verified DEX. Application lifecycle callbacks attach one JS bridge per WebView.
 * No original MOA activity, diary, map, and widget classes are replaced.
 */
public class MoaMomentApplication extends Application implements Application.ActivityLifecycleCallbacks {
  private final Handler main=new Handler(Looper.getMainLooper());
  private final WeakHashMap<WebView,Boolean> attached=new WeakHashMap<>();
  @Override public void onCreate(){super.onCreate();registerActivityLifecycleCallbacks(this);}
  private WebView find(View v){
    if(v instanceof WebView)return (WebView)v;
    if(v instanceof ViewGroup){
      ViewGroup g=(ViewGroup)v;
      for(int i=0;i<g.getChildCount();i++){
        WebView r=find(g.getChildAt(i));if(r!=null)return r;
      }
    }
    return null;
  }
  private void install(Activity a) {
    if(a==null||a.isFinishing())return;
    WebView w=find(a.getWindow().getDecorView());
    if(w==null)return;
    String url=w.getUrl();
    if(url==null||!url.startsWith("https://familyjourney.local/"))return;
    if(attached.containsKey(w))return;
    w.addJavascriptInterface(new CaptureBridge(getApplicationContext()),"MoaMomentNative");
    attached.put(w,true);
    // Only once: injected JavascriptInterfaces become available on the next load.
    w.reload();
  }
  @Override public void onActivityCreated(Activity a,Bundle s){
    main.postDelayed(()->install(a),650);
    main.postDelayed(()->install(a),1800);
  }
  @Override public void onActivityResumed(Activity a){
    main.postDelayed(()->install(a),250);
    main.postDelayed(()->install(a),950);
  }
  @Override public void onActivityStarted(Activity a){}
  @Override public void onActivityPaused(Activity a){}
  @Override public void onActivityStopped(Activity a){}
  @Override public void onActivitySaveInstanceState(Activity a,Bundle s){}
  @Override public void onActivityDestroyed(Activity a){}
  public static final class CaptureBridge {
    private final Context c;
    public CaptureBridge(Context c){this.c=c;}
    @JavascriptInterface public boolean enabled(){return MoaMomentCaptureService.enabled(c);}
    @JavascriptInterface public void setEnabled(boolean on) {MoaMomentCaptureService.switchTo(c,on);MoaMomentCaptureService.updateTile(c);}
    @JavascriptInterface public String error(){return MoaMomentCaptureService.prefs(c).getString("lastError","");}
    @JavascriptInterface public String drafts(){
      JSONArray a=new JSONArray();
      for(Map.Entry<String,?> e:MoaMomentCaptureService.prefs(c).getAll().entrySet())
        if(e.getKey().startsWith("m:")&&e.getValue() instanceof String)
          try {a.put(new JSONObject((String)e.getValue()));}catch(Exception ignored){}
      return a.toString();
    }
    @JavascriptInterface public void ack(String key) {
      if(key!=null&&key.matches("v?\\d{1,19}"))
        MoaMomentCaptureService.prefs(c).edit().remove("m:"+key).apply();
    }
  }
}
