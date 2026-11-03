package com.juhyeon.familyjourney;

import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.app.Activity;
import android.content.SharedPreferences;
import android.view.View;
import android.view.ViewGroup;
import android.webkit.WebView;

/**
 * Exact host bridge: subclasses the original HostActivity so the normal diary,
 * map and photo viewer behavior is inherited, and registers the camera bridge
 * directly against that Activity's actual WebView.
 *
 * The original APK's HostActivity class is FINAL; the APK packaging step MUST
 * explicitly clear ACC_FINAL in its class_def and rehash classes2.dex, before
 * this subclass is enabled in the launcher manifest.
 *
 * This class is NOT a standalone launcher or second app.
 */
public final class MoaMomentBridgeHostActivity extends HostActivity {
  private final Handler main = new Handler(Looper.getMainLooper());
  private WebView attached;
  private boolean reloadIssued;
  private boolean verified;
  private int attempts;
  private long startedAt;

  @Override protected void onCreate(Bundle b) {
    super.onCreate(b);
    startedAt=System.currentTimeMillis();
    main.postDelayed(this::ensure, 100);
  }
  @Override protected void onResume() {
    super.onResume();
    main.postDelayed(this::ensure, 200);
  }
  @Override protected void onDestroy() {
    main.removeCallbacksAndMessages(null);
    super.onDestroy();
  }
  private WebView find(View v) {
    if(v instanceof WebView) return (WebView)v;
    if(v instanceof ViewGroup) {
      ViewGroup g=(ViewGroup)v;
      for(int i=0;i<g.getChildCount();i++){
        WebView w=find(g.getChildAt(i));
        if(w!=null)return w;
      }
    }
    return null;
  }
  private void diag(String s) {
    try {
      SharedPreferences.Editor e=MoaMomentCaptureService.prefs(this).edit();
      e.putString("bridgeDiagnostic",s).putLong("bridgeDiagnosticAt",System.currentTimeMillis()).apply();
    }catch(Exception ignored){}
  }
  private void ensure(){
    if(isFinishing()||isDestroyed()||verified)return;
    WebView candidate=null;
    // Verified from the original R38 classes2.dex field table: HostActivity
    // owns a private android.webkit.WebView field named "web". Reading this
    // actual field avoids relying only on view-tree timing.
    try {
      java.lang.reflect.Field f=HostActivity.class.getDeclaredField("web");
      f.setAccessible(true);
      Object value=f.get(this);
      if(value instanceof WebView) candidate=(WebView)value;
    } catch(Throwable reflectionError) {
      diag("R50 field lookup web failed: "+reflectionError);
    }
    if(candidate==null)candidate=find(getWindow().getDecorView());
    if(candidate==null){retry("R50 HostActivity.web and view-tree WebView both absent");return;}
    final WebView w=candidate;
    String url=w.getUrl();
    if(url!=null && !(url.startsWith("https://familyjourney.local/")||url.equals("https://familyjourney.local"))){
      retry("R50 unexpected WebView URL (no JS bridge injected): "+url);
      return;
    }
    if(attached!=w){
      try{
        w.addJavascriptInterface(new MoaMomentApplication.CaptureBridge(getApplicationContext()),"MoaMomentNative");
        attached=w;reloadIssued=false;attempts=0;
        diag("R50 addJavascriptInterface registered; url="+url);
      }catch(Throwable e){retry("R50 addJavascriptInterface threw "+e);return;}
    }
    // An interface is visible to JS on the NEXT navigation only. For a page
    // already loaded, reload exactly once. Never loop-reload while composing.
    if(!reloadIssued && url!=null && url.startsWith("https://familyjourney.local")){
      reloadIssued=true;
      w.reload();
    }
    // Wait for the JS-ready callback; do not confuse call attempt with success.
    if(url!=null && url.startsWith("https://familyjourney.local")) {
      try{
        w.evaluateJavascript(
          "(function(){return (typeof window.MoaMomentNative==='object'&&typeof window.MoaMomentNative.enabled==='function')?'READY':'ABSENT'})()",
          value->{
            if("\"READY\"".equals(value)){
              verified=true;
              diag("R50 VERIFIED JS bridge READY on actual HostActivity WebView");
            }else retry("R50 JS bridge is "+value+"; url="+w.getUrl());
          });
      }catch(Throwable e){retry("R50 evaluateJavascript failed: "+e);}
    }else retry("R50 waiting for first WebView navigation");
  }
  private void retry(String reason){
    diag(reason);
    if(++attempts<80) main.postDelayed(this::ensure,850);
    else diag(reason+"; 80 attempts exhausted");
  }
}
