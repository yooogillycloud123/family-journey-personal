package com.juhyeon.familyjourney;

import android.Manifest;
import android.app.Activity;
import android.os.Bundle;
import android.content.Context;
import android.content.pm.PackageManager;
import android.os.Handler;
import android.os.Looper;
import android.view.View;
import android.view.ViewGroup;
import android.webkit.JavascriptInterface;
import android.webkit.WebView;
import org.json.JSONArray;
import org.json.JSONObject;
import java.util.Map;

/** Existing MOA HostActivity remains the actual UI and app logic. This subclass
    adds only a private, same-application camera-event bridge. */
public final class MoaMomentHostActivity extends HostActivity {
  private WebView injected; private final Handler h=new Handler(Looper.getMainLooper());
  @Override protected void onCreate(Bundle saved){
    super.onCreate(saved);
    h.postDelayed(()->install(false),400);
    h.postDelayed(()->install(true),1300);
  }
  @Override protected void onResume(){
    super.onResume();h.postDelayed(()->install(false),350);
  }
  private WebView find(View v){
    if(v instanceof WebView)return (WebView)v;
    if(v instanceof ViewGroup){ViewGroup g=(ViewGroup)v;for(int i=0;i<g.getChildCount();i++){WebView w=find(g.getChildAt(i));if(w!=null)return w;}}
    return null;
  }
  private void install(boolean reload){
    WebView web=find(getWindow().getDecorView());
    if(web==null)return;
    String u=web.getUrl();
    if(u!=null&&!u.startsWith("https://familyjourney.local/"))return;
    if(injected==web)return;
    web.addJavascriptInterface(new CaptureBridge(getApplicationContext()),"MoaMomentNative");
    injected=web;
    // addJavascriptInterface is exposed on the NEXT load only. The old version
    // marked the WebView injected without ever reloading if install(false) won.
    // Reload once when the MOA web app has already loaded; no reload loop.
    if(u!=null && u.startsWith("https://familyjourney.local/")) web.reload();
    if(checkSelfPermission(Manifest.permission.READ_MEDIA_IMAGES)!=PackageManager.PERMISSION_GRANTED ||
       checkSelfPermission(Manifest.permission.READ_MEDIA_VIDEO)!=PackageManager.PERMISSION_GRANTED ||
       checkSelfPermission(Manifest.permission.POST_NOTIFICATIONS)!=PackageManager.PERMISSION_GRANTED){
      requestPermissions(new String[]{Manifest.permission.READ_MEDIA_IMAGES,Manifest.permission.READ_MEDIA_VIDEO,Manifest.permission.POST_NOTIFICATIONS},482);
    }
  }
  public static final class CaptureBridge {
    private final Context c;
    public CaptureBridge(Context c){this.c=c;}
    @JavascriptInterface public boolean enabled(){return MoaMomentCaptureService.enabled(c);}
    @JavascriptInterface public void setEnabled(boolean on){MoaMomentCaptureService.switchTo(c,on);MoaMomentCaptureService.updateTile(c);}
    @JavascriptInterface public String error(){return MoaMomentCaptureService.prefs(c).getString("lastError","");}
    @JavascriptInterface public String drafts(){
      JSONArray a=new JSONArray();
      for(Map.Entry<String,?> e:MoaMomentCaptureService.prefs(c).getAll().entrySet())
        if(e.getKey().startsWith("m:")&&e.getValue() instanceof String)try{
          a.put(new JSONObject((String)e.getValue()));
        }catch(Exception ignored){}
      return a.toString();
    }
    @JavascriptInterface public void ack(String key){
      if(key!=null&&key.matches("v?\\d{1,19}"))
        MoaMomentCaptureService.prefs(c).edit().remove("m:"+key).apply();
    }
  }
}
