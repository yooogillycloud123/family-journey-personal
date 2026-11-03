package com.juhyeon.familyjourney;

import android.Manifest;
import android.app.Activity;
import android.app.Application;
import android.content.Intent;
import android.content.ComponentName;
import android.content.pm.ShortcutInfo;
import android.content.pm.ShortcutManager;
import android.graphics.drawable.Icon;
import android.widget.Toast;
import java.util.Collections;
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
  private final WeakHashMap<Activity,Boolean> toggledByShortcut=new WeakHashMap<>();
  private static final String MOA_TOGGLE_SHORTCUT_ACTION="com.juhyeon.familyjournea.TOGGLE_MOMENT_MONITOR";
  @Override public void onCreate(){super.onCreate();registerActivityLifecycleCallbacks(this);MoaMomentDirectDiaryStore.requestSync(this);publishMomentToggleShortcut();}
  /**
   * OHO+ can select ordinary launcher shortcuts from its "Home screen shortcuts"
   * gesture action. Do NOT create a new app icon or a new privileged TileService.
   * Reuse the exact QuickTile state setter with one single user swipe.
   */
  private void publishMomentToggleShortcut(){
    try{
      ShortcutManager sm=getSystemService(ShortcutManager.class);
      if(sm==null)return;
      Intent toggle=new Intent(MOA_TOGGLE_SHORTCUT_ACTION);
      toggle.setComponent(new ComponentName(this,"com.juhyeon.familyjourney.HostActivity"));
      toggle.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK|Intent.FLAG_ACTIVITY_MULTIPLE_TASK
        |Intent.FLAG_ACTIVITY_NO_ANIMATION);
      ShortcutInfo item=new ShortcutInfo.Builder(this,"moa-recording-toggle")
        .setShortLabel("모아 기록 전환")
        .setLongLabel("모아 순간 기록 ON/OFF")
        .setActivity(new ComponentName(this,"com.juhyeon.familyjourney.HostActivity"))
        .setIcon(Icon.createWithResource("android",android.R.drawable.ic_menu_camera))
        .setIntent(toggle)
        .build();
      sm.addDynamicShortcuts(Collections.singletonList(item));
    }catch(Throwable e){
      MoaMomentCaptureService.prefs(this).edit().putString("shortcutPublishDiagnostic",
        "SHORTCUT_UNAVAILABLE "+e.getClass().getSimpleName()).apply();
    }
  }
  private boolean toggleFromShortcut(Activity a){
    if(a==null||!"com.juhyeon.familyjourney.HostActivity".equals(a.getClass().getName()))return false;
    Intent intent=a.getIntent();
    if(intent==null||!MOA_TOGGLE_SHORTCUT_ACTION.equals(intent.getAction()))return false;
    if(Boolean.TRUE.equals(toggledByShortcut.get(a)))return true;
    toggledByShortcut.put(a,true);
    try{
      boolean turnOn=!MoaMomentCaptureService.enabled(a);
      MoaMomentCaptureService.switchTo(a,turnOn);
      MoaMomentCaptureService.updateTile(a);
      boolean actual=MoaMomentCaptureService.enabled(a);
      if(turnOn&&!actual){
        Toast.makeText(a,"모아 기록을 켜려면 사진·영상·알림 권한을 허용하세요.",Toast.LENGTH_SHORT).show();
        Intent setup=new Intent(a,MoaMomentSetupActivity.class);
        a.startActivity(setup);
      }else{
        Toast.makeText(a,actual?"모아 순간 기록 켜짐":"모아 순간 기록 꺼짐",Toast.LENGTH_SHORT).show();
      }
    }catch(Throwable e){
      Toast.makeText(a,"모아 기록 전환 실패 · 설정에서 확인해 주세요.",Toast.LENGTH_SHORT).show();
    }finally{
      a.finish();
      a.overridePendingTransition(0,0);
    }
    return true;
  }
  // R49: attach the Java bridge to the WebView owned by the original
  // HostActivity. Do not assume getUrl() has become non-null when the view exists.
  // WebView can load an asset URL asynchronously; URL-gated injection missed it
  // on the user's Galaxy. Only the trusted Activity class is eligible.
  private final WeakHashMap<Activity,Boolean> polling=new WeakHashMap<>();
  private final WeakHashMap<WebView,Boolean> installed=new WeakHashMap<>();
  private final WeakHashMap<WebView,Boolean> retried=new WeakHashMap<>();
  private WebView findWebView(View v){
    if(v instanceof WebView)return (WebView)v;
    if(v instanceof ViewGroup){
      ViewGroup g=(ViewGroup)v;
      for(int i=0;i<g.getChildCount();i++){
        WebView w=findWebView(g.getChildAt(i));
        if(w!=null)return w;
      }
    }
    return null;
  }
  private boolean install(Activity a){
    if(a==null||a.isFinishing()||a.isDestroyed())return false;
    if(!"com.juhyeon.familyjourney.HostActivity".equals(a.getClass().getName()))return true;
    final WebView web=findWebView(a.getWindow().getDecorView());
    if(web==null)return false;
    if(installed.containsKey(web))return true;
    try {
      // addJavascriptInterface is exposed on the NEXT page load.
      web.addJavascriptInterface(new CaptureBridge(getApplicationContext()),"MoaMomentNative");
      installed.put(web,true);
      String url=web.getUrl();
      MoaMomentCaptureService.prefs(this).edit().putString(
        "bridgeDiagnostic","R49 interface registered url="+url+" progress="+web.getProgress()).apply();
      if(url!=null && !"about:blank".equals(url)) {
        main.postDelayed(()->{
          if(!a.isFinishing()&&!a.isDestroyed()){
            try{web.reload();}
            catch(Exception e){MoaMomentCaptureService.prefs(this).edit()
              .putString("bridgeDiagnostic","R49 reload failed: "+e).apply();}
          }
        },300L);
      }
      // If URL is null, the initial load (which follows addJavascriptInterface)
      // will expose the interface; no premature reload is necessary.
      main.postDelayed(()->{
        try{web.evaluateJavascript(
          "(function(){return typeof window.MoaMomentNative==='object' && typeof window.MoaMomentNative.setEnabled==='function'})()",
          result->{
            MoaMomentCaptureService.prefs(this).edit().putString(
              "bridgeDiagnostic","R59 JS check="+result+" url="+web.getUrl()).apply();
            // One guarded retry during the initial WebView bootstrap only.
            // Do not reload a user editing a diary or every time the app resumes.
            if(!"true".equals(result) && !Boolean.TRUE.equals(retried.get(web))
                && web.getUrl()!=null && web.getUrl().startsWith("https://familyjourney.local")
                && web.getProgress()==100) {
              retried.put(web,true);
              main.postDelayed(()->{
                if(a.isFinishing()||a.isDestroyed())return;
                try {
                  web.evaluateJavascript(
                    "(function(){return !!(window.FamilyJourneyDiary&&window.FamilyJourneyDiary.state&&window.FamilyJourneyDiary.state.editing)})()",
                    editing->{
                      if(!"true".equals(editing))
                        try{web.reload();}catch(Exception ignored){}
                    });
                }catch(Exception ignored){}
              },200L);
            }
          });
        }catch(Exception e){MoaMomentCaptureService.prefs(this).edit()
          .putString("bridgeDiagnostic","R49 JS check failed: "+e).apply();}
      },2500L);
      return true;
    }catch(Throwable e){
      MoaMomentCaptureService.prefs(this).edit().putString(
        "bridgeDiagnostic","R49 injection failed: "+e).apply();
      return false;
    }
  }
  private void ensureBridge(Activity a) {
    if(a==null||a.isFinishing()||a.isDestroyed())return;
    if(!"com.juhyeon.familyjourney.HostActivity".equals(a.getClass().getName()))return;
    if(Boolean.TRUE.equals(polling.get(a)))return;
    polling.put(a,true);
    final int[] tries={0};
    final Runnable[] task=new Runnable[1];
    task[0]=()->{
      if(a.isFinishing()||a.isDestroyed()){polling.remove(a);return;}
      if(install(a)){polling.remove(a);return;}
      if(++tries[0]<120) main.postDelayed(task[0],750L);
      else{polling.remove(a);MoaMomentCaptureService.prefs(this).edit()
        .putString("bridgeDiagnostic","R49 no WebView in HostActivity after retry").apply();}
    };
    main.postDelayed(task[0],100L);
  }
  @Override public void onActivityCreated(Activity a,Bundle s){if(toggleFromShortcut(a))return;ensureBridge(a);}
  @Override public void onActivityResumed(Activity a){
    if(toggleFromShortcut(a))return;
    ensureBridge(a);
    // R59: This class (not MoaMomentSyncApplication) is the actual
    // AndroidManifest application in the shipped R57/R58 APK.
    // The standalone reliable inbox path compiled into the DEX was never
    // registered. Run it whenever the original HostActivity resumes.
    // It synchronizes native SharedPreferences memo drafts through the
    // token-ACK IndexedDB path even if addJavascriptInterface never appears.
    MoaMomentInboxSync.onResume(a);
  }
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
        ; // Overlay is optional; notification and MediaStore foreground monitor remain available.
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
