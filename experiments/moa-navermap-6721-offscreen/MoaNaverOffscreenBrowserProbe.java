package com.juhyeon.familyjourney;

import android.app.Activity;
import android.graphics.Bitmap;
import android.net.Uri;
import android.view.ViewGroup;
import android.webkit.CookieManager;
import android.webkit.WebResourceError;
import android.webkit.WebResourceRequest;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.FrameLayout;

/** Source-only first-party public-page probe. DOES NOT WRITE A NAVER BOOKMARK.
 * Requires user-consented first-party login and a separately verified
 * browser writer implementation before promotion into release APK.
 */
public final class MoaNaverOffscreenBrowserProbe {
  public interface Status { void onStatus(String phase, String detail); }
  private final Activity activity;
  private final FrameLayout root;
  private final Status callback;
  private WebView browser;
  private boolean closed;
  public MoaNaverOffscreenBrowserProbe(Activity activity,FrameLayout root,Status callback){
    this.activity=activity;this.root=root;this.callback=callback;
  }
  private void status(String phase,String detail) {
    if(callback!=null)callback.onStatus(phase,detail);
  }
  private static boolean firstParty(Uri uri) {
    String host=uri.getHost();
    return "https".equals(uri.getScheme()) && host!=null &&
      (host.equals("map.naver.com")||host.equals("pcmap.place.naver.com")||
       host.equals("pages.map.naver.com")||host.equals("nid.naver.com"));
  }
  public void startPublicPageProbe(String sid) {
    if(sid==null||!sid.matches("[0-9]{1,40}")){
      status("NEEDS_EXACT_PLACE_ID","Photo GPS alone does not identify a NAVER place");
      return;
    }
    activity.runOnUiThread(()->{
      if(closed)return;
      if(browser!=null){status("ALREADY_RUNNING","One session at a time");return;}
      browser=new WebView(activity);
      WebSettings s=browser.getSettings();
      s.setJavaScriptEnabled(true);
      s.setDomStorageEnabled(true);
      s.setUseWideViewPort(true);
      s.setLoadWithOverviewMode(true);
      s.setSupportMultipleWindows(false);
      s.setUserAgentString("Mozilla/5.0 (Windows NT 10.0; Win64; x64) "+
        "AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36");
      CookieManager.getInstance().setAcceptCookie(true);
      CookieManager.getInstance().setAcceptThirdPartyCookies(browser,false);
      browser.setWebViewClient(new WebViewClient(){
        @Override public boolean shouldOverrideUrlLoading(WebView view,WebResourceRequest request) {
          Uri u=request.getUrl();
          if(firstParty(u))return false;
          status("BLOCKED_NON_FIRST_PARTY",String.valueOf(u.getHost()));
          return true;
        }
        @Override public void onPageStarted(WebView view,String url,Bitmap favicon) {
          String h=Uri.parse(url).getHost();
          if("m.map.naver.com".equals(h))status("MOBILE_REDIRECT","Known app landing");
          else status("PAGE_STARTED",String.valueOf(h));
        }
        @Override public void onReceivedError(WebView view,WebResourceRequest req,WebResourceError e) {
          if(req.isForMainFrame())status("PAGE_ERROR",String.valueOf(e.getErrorCode()));
        }
        @Override public void onPageFinished(WebView view,String url) {
          if(!firstParty(Uri.parse(url))){status("UNTRUSTED_PAGE","No script");return;}
          view.evaluateJavascript(
            "(function(){return JSON.stringify({ready:document.readyState,hasBody:!!document.body,"+
            "saveCandidate:!!(document.body&&document.body.innerText.indexOf('저장')>=0)})})()",
            answer->status("PUBLIC_DOM_OBSERVED",String.valueOf(answer)));
        }
      });
      FrameLayout.LayoutParams size=new FrameLayout.LayoutParams(1,1);
      browser.setAlpha(0.01f);
      browser.setClickable(false);
      browser.setFocusable(false);
      root.addView(browser,size);
      status("PROBE_RUNNING_NOT_SAVING","Browser navigation only");
      browser.loadUrl("https://map.naver.com/p/entry/place/"+sid);
    });
  }
  public void close() {
    activity.runOnUiThread(()->{
      closed=true;
      if(browser!=null){
        browser.stopLoading();
        if(browser.getParent() instanceof ViewGroup)
          ((ViewGroup)browser.getParent()).removeView(browser);
        browser.destroy();
        browser=null;
      }
      status("PROBE_CLOSED","No bookmark write was made");
    });
  }
}
