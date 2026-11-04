package com.juhyeon.familyjourney;

import android.Manifest;
import android.app.Activity;
import android.content.pm.PackageManager;
import android.webkit.JavascriptInterface;
import android.webkit.WebView;
import android.os.Handler;
import android.os.Looper;
import org.json.JSONObject;
import java.lang.ref.WeakReference;

/** R78: only the trusted FamilyJourney host WebView can request native STT.
 * One user tap -> one result -> input field; the existing diary save is unchanged.
 */
public final class MoaMomentVoiceBridge {
  private final WeakReference<Activity> activity;
  private final WeakReference<WebView> web;
  private final Handler main=new Handler(Looper.getMainLooper());
  private MoaMomentVoice recognizer;
  private String active;
  public MoaMomentVoiceBridge(Activity activity,WebView web){
    this.activity=new WeakReference<>(activity);this.web=new WeakReference<>(web);
  }
  @JavascriptInterface public void start(String token){
    if(token==null||!token.matches("v[0-9]{1,18}"))return;
    main.post(()->begin(token));
  }
  @JavascriptInterface public void cancel(){main.post(()->{
    if(recognizer!=null){recognizer.stop();recognizer=null;active=null;}
  });}
  private boolean trusted(){
    WebView v=web.get();Activity a=activity.get();
    return v!=null&&a!=null&&!a.isDestroyed()&&!a.isFinishing()
      &&"com.juhyeon.familyjourney.HostActivity".equals(a.getClass().getName())
      &&v.getUrl()!=null&&v.getUrl().startsWith("https://familyjourney.local/");
  }
  private void result(String token,String text,String state){
    if(!trusted())return;
    WebView w=web.get();
    String js="window.__moaVoiceNativeResult&&window.__moaVoiceNativeResult("+
      JSONObject.quote(token)+","+JSONObject.quote(text)+","+JSONObject.quote(state)+")";
    try{w.evaluateJavascript(js,null);}catch(Exception ignored){}
  }
  private void begin(String token){
    if(!trusted())return;
    if(recognizer!=null){recognizer.stop();recognizer=null;}
    active=token;
    Activity a=activity.get();
    if(a.checkSelfPermission(Manifest.permission.RECORD_AUDIO)!=PackageManager.PERMISSION_GRANTED){
      result(token,"첫 사용 시 마이크 권한을 허용한 후 버튼을 다시 눌러 주세요.","permission");
      try{a.requestPermissions(new String[]{Manifest.permission.RECORD_AUDIO},7802);}
      catch(Exception e){result(token,"마이크 권한을 설정에서 허용해 주세요.","error");}
      return;
    }
    recognizer=new MoaMomentVoice(a,new MoaMomentVoice.Listener(){
      @Override public void onListening(){if(token.equals(active))result(token,"","listening");}
      @Override public void onText(String transcript){if(token.equals(active))result(token,transcript,"success");}
      @Override public void onFailure(String error){if(token.equals(active))result(token,error,"error");}
      @Override public void onFinished(){if(token.equals(active)){result(token,"","finished");recognizer=null;active=null;}}
    });
    recognizer.start();
  }
}