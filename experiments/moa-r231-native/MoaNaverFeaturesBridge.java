package com.juhyeon.familyjourney;

import android.app.Activity;
import android.net.Uri;
import android.os.Handler;
import android.os.Looper;
import android.webkit.JavascriptInterface;
import android.webkit.WebView;
import java.lang.ref.WeakReference;
import java.util.Locale;

/**
 * MOA R231: separate, local-origin-only configuration and opt-in Naver WebView
 * feasibility bridge.  Never injects JavaScript interfaces into third-party pages.
 * No login credentials, cookies, photo bytes, or GPS sent through this bridge.
 */
public final class MoaNaverFeaturesBridge {
  private static WeakReference<WebView> attached=new WeakReference<>(null);
  private static WeakReference<MoaNaverFeaturesBridge> current=new WeakReference<>(null);
  private static final Handler MAIN=new Handler(Looper.getMainLooper());
  private final WeakReference<Activity> host;
  private final WeakReference<WebView> hostWeb;
  private volatile boolean trustedMainPage;

  private MoaNaverFeaturesBridge(Activity host,WebView hostWeb){
    this.host=new WeakReference<>(host);this.hostWeb=new WeakReference<>(hostWeb);
  }
  // Called on the existing MOA Activity UI thread; never query WebView methods
  // from Android's asynchronous @JavascriptInterface thread.
  public static void install(Activity a,WebView w){
    if(a==null||w==null)return;
    boolean local=localTopPage(w.getUrl());
    WebView prev=attached.get();MoaNaverFeaturesBridge existing=current.get();
    if(prev==w&&existing!=null){existing.trustedMainPage=local;return;}
    if(!local)return;
    MoaNaverFeaturesBridge bridge=new MoaNaverFeaturesBridge(a,w);
    bridge.trustedMainPage=true;
    w.addJavascriptInterface(bridge,"MoaNaverFeatures");
    attached=new WeakReference<>(w);current=new WeakReference<>(bridge);
  }
  private static boolean localTopPage(String url){
    if(url==null)return false;
    try{
      Uri u=Uri.parse(url);
      return "https".equalsIgnoreCase(u.getScheme())&&"familyjourney.local".equalsIgnoreCase(u.getHost())
        && (u.getPort()==-1||u.getPort()==443);
    }catch(Exception ignored){return false;}
  }
  private boolean isLocal(){return trustedMainPage && host.get()!=null && hostWeb.get()!=null;}
  @JavascriptInterface public String returnPopupSettings(){
    Activity a=host.get();return isLocal()&&a!=null?MoaNaverReturnOverlay.settingsJson(a):"{\"error\":\"UNTRUSTED_PAGE\"}";
  }
  @JavascriptInterface public void saveReturnPopupSettings(String raw){
    Activity a=host.get();if(isLocal()&&a!=null&&raw!=null&&raw.length()<2048)
      MoaNaverReturnOverlay.updateSettings(a,raw);
  }
  @JavascriptInterface public String webProbeStatus(){
    Activity a=host.get();return isLocal()&&a!=null?MoaNaverWebProbeDialog.statusJson():"{\"state\":\"UNTRUSTED_PAGE\"}";
  }
  @JavascriptInterface public void openWebProbe(){
    Activity a=host.get();if(!isLocal()||a==null)return;
    MAIN.post(()->{
      if(a.isFinishing()||a.isDestroyed())return;
      new android.app.AlertDialog.Builder(a)
        .setTitle("네이버 웹 연결 진단")
        .setMessage("별도 네이버 앱을 열지 않고 MOA 내부 웹뷰의 로그인·실행 가능성을 확인합니다. 네이버 계정에 장소를 저장하거나 리스트를 변경하지 않습니다. 웹 로그인이 필요하면 네이버 사이트에서 직접 입력합니다.")
        .setNegativeButton("취소",(d,w)->{})
        .setPositiveButton("진단 시작",(d,w)->MoaNaverWebProbeDialog.show(a))
        .show();
    });
  }
  @JavascriptInterface public void stopWebProbe(){
    Activity a=host.get();if(!isLocal()||a==null)return;
    MAIN.post(MoaNaverWebProbeDialog::stop);
  }
  public static void cleanup(){
    MoaNaverFeaturesBridge b=current.get();if(b!=null)b.trustedMainPage=false;
    MAIN.post(MoaNaverWebProbeDialog::stop);
  }
}