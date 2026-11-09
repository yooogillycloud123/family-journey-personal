package com.juhyeon.familyjourney;

import android.app.Activity;
import android.content.Context;
import android.graphics.Color;
import android.net.Uri;
import android.os.SystemClock;
import android.view.View;
import android.view.ViewGroup;
import android.webkit.CookieManager;
import android.webkit.RenderProcessGoneDetail;
import android.webkit.WebResourceRequest;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.FrameLayout;
import androidx.webkit.WebMessageCompat;
import androidx.webkit.WebViewCompat;
import androidx.webkit.WebViewFeature;
import androidx.webkit.JavaScriptReplyProxy;
import org.json.JSONObject;
import java.util.Arrays;
import java.util.HashSet;
import java.util.Locale;
import java.util.Set;

/**
 * R229 capability experiment, NO real NAVER writes, no password/cookie extraction.
 * This module is not attached to the production R227 WebView or existing diary DB.
 * It must be started by explicit user action in the future integration.
 *
 * Visible-first test MUST pass before trying the hidden-but-attached mode.
 * Hidden WebView rendering/timers and NAVER login are unverified, not a promise.
 */
public final class MoaNaverWebProbeHost {
  public interface Reporter {void status(String safeStatus);void counts(JSONObject safeCounts);}
  private static final Set<String> ORIGINS=new HashSet<>(Arrays.asList(
    "https://map.naver.com","https://pcmap.place.naver.com","https://pages.map.naver.com"));
  private final Activity activity;private final FrameLayout parent;private final Reporter reporter;
  private FrameLayout holder;private WebView web;
  private long started;private boolean disposed;private boolean hiddenMode;

  public MoaNaverWebProbeHost(Activity activity,FrameLayout parent,Reporter reporter){
    this.activity=activity;this.parent=parent;this.reporter=reporter;
  }
  public boolean start(boolean hidden, String javascript){
    if(web!=null){reporter.status("ALREADY_RUNNING");return false;}
    if(!WebViewFeature.isFeatureSupported(WebViewFeature.WEB_MESSAGE_LISTENER)||
      !WebViewFeature.isFeatureSupported(WebViewFeature.DOCUMENT_START_SCRIPT)){
      reporter.status("WEBKIT_FRAME_FEATURE_UNSUPPORTED");return false;
    }
    if(javascript==null||!javascript.contains("__MOA_NAVER_WEB_PROBE_V1__")||javascript.length()>24000){
      reporter.status("INVALID_READONLY_PROBE_SCRIPT");return false;
    }
    disposed=false;hiddenMode=hidden;started=SystemClock.elapsedRealtime();
    try{
      holder=new FrameLayout(activity);holder.setClipChildren(true);holder.setClipToPadding(true);
      int w=hidden?1:ViewGroup.LayoutParams.MATCH_PARENT;
      int h=hidden?1:ViewGroup.LayoutParams.MATCH_PARENT;
      FrameLayout.LayoutParams hlp=new FrameLayout.LayoutParams(w,h);
      parent.addView(holder,hlp);
      // Keep realistic inner layout width even when clipped; a 1x1 viewport
      // would force a broken NAVER responsive/mobile layout.
      web=new WebView(activity);
      web.setBackgroundColor(Color.TRANSPARENT);
      web.setFocusable(!hidden);web.setFocusableInTouchMode(!hidden);
      holder.addView(web,new FrameLayout.LayoutParams(hidden?dp(390):ViewGroup.LayoutParams.MATCH_PARENT,
         hidden?dp(820):ViewGroup.LayoutParams.MATCH_PARENT));
      WebSettings settings=web.getSettings();
      settings.setJavaScriptEnabled(true);settings.setDomStorageEnabled(true);
      settings.setAllowFileAccess(false);settings.setAllowContentAccess(false);
      settings.setJavaScriptCanOpenWindowsAutomatically(false);
      settings.setMixedContentMode(WebSettings.MIXED_CONTENT_NEVER_ALLOW);
      // R233: mobile WebView currently shows NAVER's install/open mobile-app landing.
      // Try the official desktop web-map layout in this opt-in diagnostic only.
      settings.setUserAgentString("Mozilla/5.0 (Windows NT 10.0; Win64; x64) " +
        "AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36");
      settings.setUseWideViewPort(true);
      settings.setLoadWithOverviewMode(true);
      settings.setSupportZoom(true);
      settings.setBuiltInZoomControls(true);
      settings.setDisplayZoomControls(false);
      CookieManager.getInstance().setAcceptCookie(true);
      // Test browser login is entered only directly at NAVER origin by the user.
      // We DO NOT import Naver native-app cookies, read cookies or inject credentials.
      CookieManager.getInstance().setAcceptThirdPartyCookies(web,true);
      web.setWebViewClient(new WebViewClient(){
        @Override public boolean shouldOverrideUrlLoading(WebView v,WebResourceRequest req){
          if(!req.isForMainFrame())return false;
          Uri u=req.getUrl();String scheme=u.getScheme(),host=u.getHost();
          if(scheme==null){reporter.status("UNKNOWN_NAVIGATION_BLOCKED");return true;}
          if(!"https".equalsIgnoreCase(scheme)){
            if("intent".equalsIgnoreCase(scheme)||"nmap".equalsIgnoreCase(scheme)||
               "market".equalsIgnoreCase(scheme))
              reporter.status("NAVER_APP_OPEN_REQUEST_SUPPRESSED_WEB_ONLY");
            else reporter.status("NON_HTTPS_NAVIGATION_BLOCKED");
            return true;
          }
          if(!isNaverDomain(host)){
            reporter.status("EXTERNAL_WEB_NAVIGATION_BLOCKED");return true;
          }
          return false;
        }
        @Override public boolean onRenderProcessGone(WebView v,RenderProcessGoneDetail d){
          reporter.status("WEBVIEW_RENDERER_GONE");dispose();return true;
        }
        @Override public void onPageFinished(WebView v,String url){
          if(disposed)return;
          // Report a boolean app-link detector, never inspect user data or credentials.
          v.evaluateJavascript("(function(){return !!document.querySelector('a[href*=\"com.nhn.android.nmap\"],a[href^=\"market://\"],a[href^=\"intent://\"]');})()",
            isInstallLanding->{
              if(disposed)return;
              if("true".equals(isInstallLanding))
                reporter.status("NAVER_APP_INSTALL_LANDING_DESKTOP_REQUEST_UNSUCCESSFUL");
              else reporter.status(hiddenMode?"HIDDEN_DESKTOP_PAGE_FINISHED_UNVERIFIED":
                "VISIBLE_DESKTOP_PAGE_FINISHED_UNVERIFIED");
            });
        }
      });
      WebViewCompat.addWebMessageListener(web,"MoaNaverProbeBridge",ORIGINS,
        (WebView view,WebMessageCompat msg,Uri sourceOrigin,boolean mainFrame,JavaScriptReplyProxy proxy)->{
          if(disposed||!ORIGINS.contains(sourceOrigin.toString()))return;
          String data=msg.getData();if(data==null||data.length()>2200)return;
          try{
            JSONObject src=new JSONObject(data);
            if(!"moa.naver.web.probe.v1".equals(src.optString("schema"))||
              !"ELEMENT_COUNTS".equals(src.optString("kind")))return;
            JSONObject raw=src.optJSONObject("counts");if(raw==null)return;
            JSONObject clean=new JSONObject();
            // Report only numerical selector presence/absence, NEVER text/values.
            for(String key:new String[]{"saveButton","saveDialogList","saveCommit","addMemo","createList","listTitle","saveListConfirm","resultRow"})
              clean.put(key,Math.max(-1,Math.min(99,raw.optInt(key,0))));
            clean.put("frameOrigin",sourceOrigin.toString());clean.put("isMainFrame",mainFrame);
            clean.put("elapsedMs",SystemClock.elapsedRealtime()-started);
            reporter.counts(clean);
          }catch(Exception ignored){}
        });
      WebViewCompat.addDocumentStartJavaScript(web,javascript,ORIGINS);
      reporter.status(hidden?"HIDDEN_PROBE_START":"VISIBLE_PROBE_START");
      web.loadUrl("https://map.naver.com/p/");
      return true;
    }catch(Exception ex){reporter.status("WEBVIEW_PROBE_CREATE_FAILED");dispose();return false;}
  }
  public void setHidden(boolean hidden){
    hiddenMode=hidden;
    if(holder==null||web==null||disposed)return;
    holder.setLayoutParams(new FrameLayout.LayoutParams(hidden?1:ViewGroup.LayoutParams.MATCH_PARENT,
      hidden?1:ViewGroup.LayoutParams.MATCH_PARENT));
    web.setFocusable(!hidden);web.setFocusableInTouchMode(!hidden);
    web.setLayoutParams(new FrameLayout.LayoutParams(hidden?dp(390):ViewGroup.LayoutParams.MATCH_PARENT,
      hidden?dp(820):ViewGroup.LayoutParams.MATCH_PARENT));
    reporter.status(hidden?"HIDDEN_ATTACHED_UNVERIFIED":"VISIBLE_NAVER_BROWSER");
  }
  private int dp(float v){return Math.round(activity.getResources().getDisplayMetrics().density*v);}
  private static boolean isNaverDomain(String host){
    if(host==null)return false;String h=host.toLowerCase(Locale.ROOT);
    return h.equals("naver.com")||h.endsWith(".naver.com");
  }
  public void dispose(){
    if(disposed)return;disposed=true;
    if(web!=null){
      // A subsequent MOA WebView can use persisted web cookies; native NAVER Maps
      // app account login is independent and never copied into the WebView.
      try{CookieManager.getInstance().flush();}catch(Exception ignored){}
      try{web.stopLoading();web.loadUrl("about:blank");}catch(Exception ignored){}
      if(holder!=null)holder.removeView(web);
      try{web.destroy();}catch(Exception ignored){}web=null;
    }
    if(holder!=null){parent.removeView(holder);holder=null;}
    reporter.status("PROBE_DISPOSED");
  }
}