package com.juhyeon.familyjourney;

import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.app.Activity;
import android.webkit.WebView;
import android.webkit.WebChromeClient;
import java.lang.reflect.Field;

/**
 * R83: dedicated diary launcher that executes the EXACT ORIGINAL HostActivity
 * via super.onCreate(), then binds native voice to that Activity's real WebView.
 * This does not rely on Application.ActivityLifecycleCallbacks.
 *
 * The original HostActivity DEX remains unchanged except removing its FINAL
 * class access bit to permit inheritance. All original methods are inherited.
 * Original HostActivity stays separately declared for all existing explicit
 * shortcuts and internal app intents.
 */
public final class MoaMomentVoiceHostActivity extends HostActivity {
  private final Handler main = new Handler(Looper.getMainLooper());
  private WebView current;
  private MoaMomentVoiceBridge voice;
  private boolean foreground;
  private int generation=0;
  private boolean installed=false;

  @Override public void onCreate(Bundle state){
    super.onCreate(state);
    bindOriginalWebView();
  }
  @Override protected void onResume(){
    super.onResume();
    foreground=true;
    final int now=++generation;
    final Runnable[] tick=new Runnable[1];
    tick[0]=()->{
      if(generation!=now||!foreground||isFinishing()||isDestroyed())return;
      bindOriginalWebView();
      main.postDelayed(tick[0],320L);
    };
    main.post(tick[0]);
  }
  @Override protected void onPause(){
    foreground=false;
    ++generation;
    super.onPause();
  }
  @Override public void onDestroy(){
    foreground=false;++generation;
    super.onDestroy();
  }
  private WebView originalWeb(){
    try{
      Field f=HostActivity.class.getDeclaredField("web");
      f.setAccessible(true);
      Object v=f.get(this);
      return v instanceof WebView ? (WebView)v : null;
    }catch(Throwable e){
      getSharedPreferences("moa_r83_voice",MODE_PRIVATE).edit().putString(
        "hostWebFieldError",e.getClass().getSimpleName()).apply();
      return null;
    }
  }
  private void bindOriginalWebView(){
    final WebView web=originalWeb();
    if(web==null)return;
    try{
      if(web!=current){
        current=web;
        voice=new MoaMomentVoiceBridge(this,web);
        installed=false;
      }
      if(!installed){
        // A new JavascriptInterface appears after the next document load,
        // but our native onJsPrompt hook is available immediately.
        web.addJavascriptInterface(voice,"MoaVoiceNative");
        web.addJavascriptInterface(new MoaMomentApplication.CaptureBridge(getApplicationContext()),"MoaMomentNative");
        try{web.addJavascriptInterface(new MoaMomentQuickThumb(getApplicationContext(),web),"MoaQuickThumb");}
        catch(Throwable optionalThumb){}
        installed=true;
      }
      WebChromeClient previous=web.getWebChromeClient();
      if(!(previous instanceof MoaMomentVoiceChrome)){
        web.setWebChromeClient(new MoaMomentVoiceChrome(previous,voice));
      }
      if(MoaMomentVoiceChrome.sameTrustedOrigin(web.getUrl())){
        web.evaluateJavascript(
          "window.__moaR79VoicePromptReady=true;"
         +"window.__moaR80VoiceChromeLive=true;"
         +"window.__moaR81VoiceChromeLiveAt=Date.now();"
         +"window.__moaR83HostDirect=true;",null);
      }
      getSharedPreferences("moa_r83_voice",MODE_PRIVATE).edit().putString(
        "bind","hostField=1;chrome="+
        (web.getWebChromeClient() instanceof MoaMomentVoiceChrome)+
        ";urlTrusted="+MoaMomentVoiceChrome.sameTrustedOrigin(web.getUrl())
        ).apply();
    }catch(Throwable e){
      getSharedPreferences("moa_r83_voice",MODE_PRIVATE).edit().putString(
        "bindError",e.getClass().getSimpleName()+":"+e.getMessage()).apply();
    }
  }
}
