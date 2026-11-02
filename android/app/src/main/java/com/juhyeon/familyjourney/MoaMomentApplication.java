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
  // HostActivity constructs and loads its WebView asynchronously. A fixed
  // 650/1800ms check misses it on cold starts with a large media library.
  // Retry until the exact trusted MOA WebView exists; never inject into external pages.
  private final WeakHashMap<Activity,Boolean> polling=new WeakHashMap<>();
  private WebView findMoaWebView(View v){
    if(v instanceof WebView){
      WebView web=(WebView)v;
      String url=web.getUrl();
      if(url!=null&&url.startsWith("https://familyjourney.local/"))return web;
    }
    if(v instanceof ViewGroup){
      ViewGroup g=(ViewGroup)v;
      for(int i=0;i<g.getChildCount();i++){
        WebView w=findMoaWebView(g.getChildAt(i));
        if(w!=null)return w;
      }
    }
    return null;
  }
  private boolean install(Activity a) {
    if(a==null||a.isFinishing()||a.isDestroyed())return false;
    if(!a.getClass().getName().equals("com.juhyeon.familyjourney.HostActivity"))return true;
    WebView w=findMoaWebView(a.getWindow().getDecorView());
    if(w==null)return false;
    if(attached.containsKey(w))return true;
    try {
      w.addJavascriptInterface(new CaptureBridge(getApplicationContext()),"MoaMomentNative");
      attached.put(w,Boolean.TRUE);
      MoaMomentCaptureService.prefs(this).edit().putString("bridgeDiagnostic","attached; url="+w.getUrl()).apply();
      // The JS interface is visible only on the NEXT page load.
      // Reload just once, and never again while notes may be edited.
      w.reload();
      return true;
    } catch(Exception error) {
      MoaMomentCaptureService.prefs(this).edit().putString("bridgeDiagnostic","attach failed: "+error).apply();
      return false;
    }
  }
  private void ensureBridge(Activity a){
    if(a==null||a.isFinishing()||a.isDestroyed())return;
    if(!a.getClass().getName().equals("com.juhyeon.familyjourney.HostActivity"))return;
    if(Boolean.TRUE.equals(polling.get(a)))return;
    polling.put(a,Boolean.TRUE);
    final int[] tries={0};
    final Runnable[] next=new Runnable[1];
    next[0]=()->{
      if(a.isFinishing()||a.isDestroyed()){polling.remove(a);return;}
      if(install(a)){polling.remove(a);return;}
      tries[0]++;
      if(tries[0]<120)main.postDelayed(next[0],1000L);
      else {
        MoaMomentCaptureService.prefs(this).edit().putString("bridgeDiagnostic",
          "MOA WebView not found after "+tries[0]+" attempts").apply();
        polling.remove(a);
      }
    };
    main.postDelayed(next[0],220L);
  }
  @Override public void onActivityCreated(Activity a,Bundle s){ensureBridge(a);}
  @Override public void onActivityResumed(Activity a){ensureBridge(a);}
  @Override public void onActivityStarted(Activity a){}
  @Override public void onActivityPaused(Activity a){}
  @Override public void onActivityStopped(Activity a){}
  @Override public void onActivitySaveInstanceState(Activity a,Bundle s){}
  @Override public void onActivityDestroyed(Activity a){}
  public static final class CaptureBridge {
    private final Context c;
    public CaptureBridge(Context c){this.c=c;}
    @JavascriptInterface public boolean enabled(){return MoaMomentCaptureService.isRunning(c);}
    @JavascriptInterface public void openSetup(){
      android.content.Intent i=new android.content.Intent(c,MoaMomentSetupActivity.class);
      i.addFlags(android.content.Intent.FLAG_ACTIVITY_NEW_TASK);
      c.startActivity(i);
    }
    @JavascriptInterface public boolean permissionsReady(){
      return c.checkSelfPermission(android.Manifest.permission.READ_MEDIA_IMAGES)==android.content.pm.PackageManager.PERMISSION_GRANTED
        && c.checkSelfPermission(android.Manifest.permission.READ_MEDIA_VIDEO)==android.content.pm.PackageManager.PERMISSION_GRANTED
        && c.checkSelfPermission(android.Manifest.permission.POST_NOTIFICATIONS)==android.content.pm.PackageManager.PERMISSION_GRANTED
        && android.provider.Settings.canDrawOverlays(c);
    }
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
