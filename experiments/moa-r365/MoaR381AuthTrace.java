package com.juhyeon.familyjourney;

import android.app.Activity;
import android.content.Context;
import android.content.SharedPreferences;
import android.graphics.Bitmap;
import android.net.Uri;
import android.os.Handler;
import android.os.Looper;
import android.os.SystemClock;
import android.util.Log;
import android.view.KeyEvent;
import android.webkit.ClientCertRequest;
import android.webkit.HttpAuthHandler;
import android.webkit.RenderProcessGoneDetail;
import android.webkit.SafeBrowsingResponse;
import android.webkit.SslErrorHandler;
import android.net.http.SslError;
import android.webkit.WebResourceError;
import android.webkit.WebResourceRequest;
import android.webkit.WebResourceResponse;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import org.json.JSONArray;
import org.json.JSONObject;
import java.lang.reflect.Method;
import java.util.Locale;

/**
 * R381 read-only direct native NAVER WebView navigation trace.
 *
 * The R283 desktop-to-Android login UA handling is in the ORIGINAL
 * MoaNaverWebProbeHost$1 WebViewClient, which this class only delegates to.
 * No credentials, cookies, tokens, URL paths, queries, DOM inputs or HTML
 * are collected. All events use domain/page classification only.
 */
public final class MoaR381AuthTrace {
  private static final Handler MAIN=new Handler(Looper.getMainLooper());
  private static final String STORE="moa_r381_auth_events_private";
  private static final String TAG="MOA_R381_AUTH";
  private static Activity host;
  private static WebView browser;
  private static int instanceSerial=0;
  private static int epoch=0;
  private static boolean challengeOpen=false;
  private static long lastChallengeElapsed=0;
  private static String previousUa="";
  private static int consecutivePolls=0;

  private MoaR381AuthTrace(){}

  private static boolean isNaver(String host){
    return host!=null&&(host.equals("naver.com")||host.endsWith(".naver.com"));
  }
  private static String domain(String url){
    if(url==null)return "none";
    try {
      Uri u=Uri.parse(url);
      if("about".equalsIgnoreCase(u.getScheme()))return "about";
      String h=u.getHost();
      if(h==null)return "none";
      h=h.toLowerCase(Locale.ROOT);
      return isNaver(h)?h:"other";
    } catch(Throwable ignored){return "invalid";}
  }
  private static String page(String url){
    String d=domain(url);
    if("nid.naver.com".equals(d))return "NAVER_AUTH";
    if("map.naver.com".equals(d)||"pcmap.place.naver.com".equals(d)||
        "pages.map.naver.com".equals(d))return "NAVER_MAP";
    if("about".equals(d))return "BLANK";
    return "OTHER";
  }
  private static String ua(WebView w){
    try{
      WebSettings s=w.getSettings();
      String value=s.getUserAgentString();
      if(value==null)return "UNKNOWN";
      String x=value.toLowerCase(Locale.ROOT);
      if(x.contains("android")&&x.contains("mobile"))return "ANDROID_MOBILE";
      if(x.contains("windows nt")&&!x.contains("mobile"))return "DESKTOP_WINDOWS";
      return "OTHER";
    }catch(Throwable ignored){return "UNKNOWN";}
  }
  private static void event(String kind, String url, String extra, WebView w){
    try {
      String cleanDomain=domain(url);
      JSONObject o=new JSONObject();
      o.put("at",System.currentTimeMillis());
      o.put("event",kind);
      o.put("webViewId",instanceSerial);
      o.put("domain",cleanDomain);
      o.put("page",page(url));
      o.put("ua",w==null?"UNKNOWN":ua(w));
      if(extra!=null&&!extra.isEmpty())o.put("detail",extra);
      String raw=o.toString();
      Log.i(TAG,raw);
      Activity a=host;
      if(a!=null){
        SharedPreferences p=a.getSharedPreferences(STORE,Context.MODE_PRIVATE);
        JSONArray old;
        try{old=new JSONArray(p.getString("events","[]"));}
        catch(Throwable ignored){old=new JSONArray();}
        JSONArray bounded=new JSONArray();
        for(int i=Math.max(0,old.length()-179);i<old.length();i++)bounded.put(old.opt(i));
        bounded.put(o);
        p.edit().putString("events",bounded.toString()).putString("lastEvent",raw).apply();
      }
    }catch(Throwable ignored){}
  }
  private static void stage(WebView view,String url){
    String p=page(url);
    if("NAVER_AUTH".equals(p)){
      challengeOpen=true;lastChallengeElapsed=SystemClock.elapsedRealtime();
    }else if("NAVER_MAP".equals(p))challengeOpen=false;
    String now=ua(view);
    if(!now.equals(previousUa)){
      event("USER_AGENT_CLASS_CHANGED",url,previousUa+"->"+now,view);
      previousUa=now;
    }
  }
  /**
   * Only prevents a NEW hidden WebView bootstrap during a still active
   * authentication session; does not intercept login requests or redirects.
   */
  static boolean authBusy(){
    if(Looper.myLooper()!=Looper.getMainLooper())return false;
    // Unlike the old 120-second-only timer, a currently attached official
    // NAVER login remains protected for as long as the user needs to finish
    // its genuine second factor / visual challenge.
    WebView live=browser;
    if(live!=null){
      try{
        String current=page(live.getUrl());
        if("NAVER_AUTH".equals(current))return true;
        if("NAVER_MAP".equals(current)){
          challengeOpen=false;
          return false;
        }
      }catch(Throwable ignored){}
    }
    if(!challengeOpen)return false;
    // When there is no attached browser, allow bounded handoff protection,
    // not an indefinite stale login latch after the page was destroyed.
    long dt=SystemClock.elapsedRealtime()-lastChallengeElapsed;
    return dt>=0 && dt<120000L;
  }
  static void start(Activity activity){
    if(Looper.myLooper()!=Looper.getMainLooper()){MAIN.post(()->start(activity));return;}
    if(activity==null||activity.isFinishing()||activity.isDestroyed())return;
    host=activity;
    int token=++epoch;
    consecutivePolls=0;
    MAIN.post(new Runnable(){
      @Override public void run(){
        if(token!=epoch || host!=activity || activity.isFinishing() || activity.isDestroyed())return;
        sample();
        if(token==epoch && host==activity){
          consecutivePolls++;
          MAIN.postDelayed(this,consecutivePolls<30?350L:1200L);
        }
      }
    });
  }
  static void stop(Activity activity){
    if(Looper.myLooper()!=Looper.getMainLooper()){MAIN.post(()->stop(activity));return;}
    if(host!=activity)return;
    epoch++;
    if(browser!=null)event("WEBVIEW_UNOBSERVED",browser.getUrl(),"host_pause",browser);
    browser=null;host=null;
    // Do not reset challengeOpen while a login navigation is in flight.
  }
  private static void sample(){
    WebView found=null;
    try {
      Class<?> controller=Class.forName("com.juhyeon.familyjourney.MoaNaverWebProbeController");
      Method method=controller.getMethod("browserForPhone");
      Object o=method.invoke(null);
      if(o instanceof WebView)found=(WebView)o;
    }catch(Throwable ignored){}
    if(found==null){
      if(browser!=null){
        event("WEBVIEW_DISAPPEARED",browser.getUrl(),"native_probe_missing",browser);
        browser=null;
      }
      return;
    }
    if(found==browser){
      stage(found,found.getUrl());
      return;
    }
    if(browser!=null)event("WEBVIEW_REPLACED",browser.getUrl(),"native_instance_changed",browser);
    browser=found;instanceSerial++;
    previousUa="";
    event("WEBVIEW_CREATED_OR_ATTACHED",found.getUrl(),"direct_native_webview",found);
    try {
      WebViewClient old=found.getWebViewClient();
      if(old==null){event("WEBVIEW_CLIENT_UNAVAILABLE",found.getUrl(),"skip_wrap",found);return;}
      if(old instanceof TraceClient)return;
      found.setWebViewClient(new TraceClient(old));
      event("NATIVE_WEBVIEW_CLIENT_WRAPPED",found.getUrl(),"original_callbacks_preserved",found);
      stage(found,found.getUrl());
    }catch(Throwable error){
      event("WEBVIEW_WRAP_FAILED",found.getUrl(),error.getClass().getSimpleName(),found);
    }
  }
  private static final class TraceClient extends WebViewClient {
    private final WebViewClient original;
    TraceClient(WebViewClient delegate){original=delegate;}
    @Override public void onPageStarted(WebView view,String url,Bitmap favicon){
      stage(view,url);event("ON_PAGE_STARTED",url,"native_client_before",view);
      original.onPageStarted(view,url,favicon);
      stage(view,url);event("ON_PAGE_STARTED_DELEGATED",url,"native_client_after",view);
    }
    @Override public void onPageFinished(WebView view,String url){
      stage(view,url);event("ON_PAGE_FINISHED",url,"native_client_before",view);
      original.onPageFinished(view,url);
      stage(view,url);event("ON_PAGE_FINISHED_DELEGATED",url,"native_client_after",view);
    }
    @Override public boolean shouldOverrideUrlLoading(WebView view,WebResourceRequest request){
      String url=request.getUrl().toString();
      String meta="mainFrame="+request.isForMainFrame()+",redirect="+request.isRedirect();
      stage(view,url);event("SHOULD_OVERRIDE_ENTER",url,meta,view);
      boolean result=original.shouldOverrideUrlLoading(view,request);
      stage(view,url);event("SHOULD_OVERRIDE_EXIT",url,meta+",handled="+result,view);
      return result;
    }
    @Override public boolean shouldOverrideUrlLoading(WebView view,String url){
      stage(view,url);event("SHOULD_OVERRIDE_LEGACY_ENTER",url,"",view);
      boolean result=original.shouldOverrideUrlLoading(view,url);
      stage(view,url);event("SHOULD_OVERRIDE_LEGACY_EXIT",url,"handled="+result,view);
      return result;
    }
    @Override public void doUpdateVisitedHistory(WebView view,String url,boolean reload){
      event("VISITED_HISTORY",url,"reload="+reload,view);
      original.doUpdateVisitedHistory(view,url,reload);
    }
    @Override public void onPageCommitVisible(WebView view,String url){
      event("PAGE_COMMIT_VISIBLE",url,"",view);
      original.onPageCommitVisible(view,url);
    }
    @Override public boolean onRenderProcessGone(WebView view,RenderProcessGoneDetail detail){
      event("WEBVIEW_RENDERER_GONE",view.getUrl(),"didCrash="+detail.didCrash(),view);
      browser=null;
      return original.onRenderProcessGone(view,detail);
    }
    @Override public void onReceivedError(WebView view,WebResourceRequest request,WebResourceError error){
      if(request.isForMainFrame())event("MAIN_FRAME_ERROR",request.getUrl().toString(),"code="+error.getErrorCode(),view);
      original.onReceivedError(view,request,error);
    }
    @Override public void onReceivedError(WebView view,int errorCode,String description,String failingUrl){
      event("LEGACY_ERROR",failingUrl,"code="+errorCode,view);
      original.onReceivedError(view,errorCode,description,failingUrl);
    }
    @Override public void onReceivedHttpError(WebView view,WebResourceRequest request,WebResourceResponse response){
      if(request.isForMainFrame())event("MAIN_FRAME_HTTP",request.getUrl().toString(),"status="+response.getStatusCode(),view);
      original.onReceivedHttpError(view,request,response);
    }
    @Override public WebResourceResponse shouldInterceptRequest(WebView view,WebResourceRequest request){
      return original.shouldInterceptRequest(view,request);
    }
    @Override public WebResourceResponse shouldInterceptRequest(WebView view,String url){
      return original.shouldInterceptRequest(view,url);
    }
    @Override public void onReceivedSslError(WebView view,SslErrorHandler handler,SslError error){
      original.onReceivedSslError(view,handler,error);
    }
    @Override public void onReceivedHttpAuthRequest(WebView view,HttpAuthHandler handler,String host,String realm){
      original.onReceivedHttpAuthRequest(view,handler,host,realm);
    }
    @Override public void onReceivedClientCertRequest(WebView view,ClientCertRequest request){
      original.onReceivedClientCertRequest(view,request);
    }
    @Override public void onReceivedLoginRequest(WebView view,String realm,String account,String args){
      original.onReceivedLoginRequest(view,realm,account,args);
    }
    @Override public void onFormResubmission(WebView view,android.os.Message dontResend,android.os.Message resend){
      event("FORM_RESUBMISSION",view.getUrl(),"",view);
      original.onFormResubmission(view,dontResend,resend);
    }
    @Override public void onTooManyRedirects(WebView view,android.os.Message cancelMsg,android.os.Message continueMsg){
      event("TOO_MANY_REDIRECTS",view.getUrl(),"",view);
      original.onTooManyRedirects(view,cancelMsg,continueMsg);
    }
    @Override public void onLoadResource(WebView view,String url){
      original.onLoadResource(view,url);
    }
    @Override public boolean shouldOverrideKeyEvent(WebView view,KeyEvent event){
      return original.shouldOverrideKeyEvent(view,event);
    }
    @Override public void onUnhandledKeyEvent(WebView view,KeyEvent event){
      original.onUnhandledKeyEvent(view,event);
    }
    @Override public void onScaleChanged(WebView view,float oldScale,float newScale){
      original.onScaleChanged(view,oldScale,newScale);
    }
    @Override public void onSafeBrowsingHit(WebView view,WebResourceRequest request,int threatType,SafeBrowsingResponse callback){
      original.onSafeBrowsingHit(view,request,threatType,callback);
    }
  }
}
