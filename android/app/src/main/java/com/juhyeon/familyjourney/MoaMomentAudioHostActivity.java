package com.juhyeon.familyjourney;
import android.Manifest;
import android.content.pm.PackageManager;
import android.net.Uri;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.view.View;
import android.view.ViewGroup;
import android.webkit.ConsoleMessage;
import android.webkit.JsPromptResult;
import android.webkit.JsResult;
import android.webkit.PermissionRequest;
import android.webkit.ValueCallback;
import android.webkit.WebChromeClient;
import android.webkit.WebView;
import java.lang.reflect.Field;

/** Original native speech delegate preserved, audio capture granted ONLY to the trusted MOA origin. */
public class MoaMomentAudioHostActivity extends MoaMomentVoiceHostActivity {
  private static final int REQUEST_MIC=4892;
  private final Handler handler=new Handler(Looper.getMainLooper());
  private PermissionRequest waiting;
  private WebView active;
  @Override protected void onCreate(Bundle state){super.onCreate(state);attachLater();}
  @Override protected void onResume(){super.onResume();attachLater();}
  private void attachLater(){
    handler.postDelayed(this::attach,50);
    handler.postDelayed(this::attach,420);
    handler.postDelayed(this::attach,1200);
  }
  private static WebView search(View root) {
    if(root instanceof WebView)return (WebView)root;
    if(root instanceof ViewGroup) {
      ViewGroup g=(ViewGroup)root;
      for(int i=0;i<g.getChildCount();i++){
        WebView found=search(g.getChildAt(i));
        if(found!=null)return found;
      }
    }
    return null;
  }
  private WebView originalWeb(){
    try{
      Class<?> owner=Class.forName("com.juhyeon.familyjourney.HostActivity");
      Field f=owner.getDeclaredField("ui");f.setAccessible(true);
      Object value=f.get(this);if(value instanceof WebView)return (WebView)value;
    }catch(Exception ignored){}
    return search(getWindow().getDecorView());
  }
  private void attach(){
    if(isFinishing()||isDestroyed())return;
    WebView w=originalWeb();if(w==null)return;
    WebChromeClient original=w.getWebChromeClient();
    if(original==null||original instanceof SafeChrome)return;
    active=w;
    w.setWebChromeClient(new SafeChrome(original));
  }
  private boolean trusted(PermissionRequest r){
    if(r==null||r.getOrigin()==null||active==null)return false;
    Uri origin=r.getOrigin();
    try{
      Uri current=Uri.parse(active.getUrl());
      return isAllowed(origin)&&isAllowed(current);
    }catch(Exception e){return false;}
  }
  private static boolean isAllowed(Uri u){
    return u!=null && "https".equalsIgnoreCase(u.getScheme())
      && "familyjourney.local".equalsIgnoreCase(u.getHost())
      && (u.getPort()==-1||u.getPort()==443) && u.getUserInfo()==null;
  }
  private static boolean audioOnly(PermissionRequest r){
    String[] res=r==null?null:r.getResources();
    return res!=null&&res.length==1&&PermissionRequest.RESOURCE_AUDIO_CAPTURE.equals(res[0]);
  }
  private void finishPermission(PermissionRequest r){
    if(r==null)return;
    if(trusted(r)&&audioOnly(r)&&checkSelfPermission(Manifest.permission.RECORD_AUDIO)==PackageManager.PERMISSION_GRANTED){
      r.grant(new String[]{PermissionRequest.RESOURCE_AUDIO_CAPTURE});
    }else r.deny();
  }
  @Override public void onRequestPermissionsResult(int request,String[] names,int[] results){
    super.onRequestPermissionsResult(request,names,results);
    if(request==REQUEST_MIC){PermissionRequest r=waiting;waiting=null;finishPermission(r);}
  }
  @Override protected void onPause(){
    if(waiting!=null){waiting.deny();waiting=null;}
    super.onPause();
  }
  @Override protected void onDestroy(){
    if(waiting!=null){waiting.deny();waiting=null;}
    handler.removeCallbacksAndMessages(null);
    super.onDestroy();
  }
  private final class SafeChrome extends WebChromeClient{
    private final WebChromeClient old;
    SafeChrome(WebChromeClient delegate){this.old=delegate;}
    @Override public void onPermissionRequest(PermissionRequest r){
      if(!trusted(r)||!audioOnly(r)){if(r!=null)r.deny();return;}
      if(checkSelfPermission(Manifest.permission.RECORD_AUDIO)==PackageManager.PERMISSION_GRANTED){
        finishPermission(r);
      }else{
        if(waiting!=null&&waiting!=r)waiting.deny();
        waiting=r;
        requestPermissions(new String[]{Manifest.permission.RECORD_AUDIO},REQUEST_MIC);
      }
    }
    @Override public void onPermissionRequestCanceled(PermissionRequest r){
      if(waiting==r)waiting=null;
      old.onPermissionRequestCanceled(r);
    }
    @Override public boolean onJsPrompt(WebView w,String url,String msg,String value,JsPromptResult result){
      return old.onJsPrompt(w,url,msg,value,result);
    }
    @Override public boolean onConsoleMessage(ConsoleMessage msg){return old.onConsoleMessage(msg);}
    @Override public void onProgressChanged(WebView w,int percent){old.onProgressChanged(w,percent);}
    @Override public boolean onJsAlert(WebView w,String url,String msg,JsResult result){return old.onJsAlert(w,url,msg,result);}
    @Override public boolean onJsConfirm(WebView w,String url,String msg,JsResult result){return old.onJsConfirm(w,url,msg,result);}
    @Override public boolean onShowFileChooser(WebView w,ValueCallback<Uri[]> file,FileChooserParams params){
      return old.onShowFileChooser(w,file,params);
    }
    @Override public void onReceivedTitle(WebView w,String title){old.onReceivedTitle(w,title);}
    @Override public void onReceivedIcon(WebView w,android.graphics.Bitmap icon){old.onReceivedIcon(w,icon);}
    @Override public void onHideCustomView(){old.onHideCustomView();}
    @Override public void onShowCustomView(View v,CustomViewCallback cb){old.onShowCustomView(v,cb);}
  }
}
