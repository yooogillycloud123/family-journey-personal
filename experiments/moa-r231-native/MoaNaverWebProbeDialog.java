package com.juhyeon.familyjourney;

import android.app.Activity;
import android.app.Dialog;
import android.graphics.Color;
import android.graphics.drawable.GradientDrawable;
import android.net.Uri;
import android.os.Handler;
import android.os.Looper;
import android.os.SystemClock;
import android.view.Gravity;
import android.view.View;
import android.view.ViewGroup;
import android.view.Window;
import android.view.WindowManager;
import android.webkit.CookieManager;
import android.webkit.WebChromeClient;
import android.webkit.WebResourceRequest;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.Button;
import android.widget.FrameLayout;
import android.widget.LinearLayout;
import android.widget.TextView;
import org.json.JSONObject;
import java.lang.ref.WeakReference;
import java.util.Locale;

/**
 * R231 opt-in real Android WebView experiment, no Naver favorites writes.
 * User signs in on real NAVER-hosted page if required. Never reads input,
 * password, cookies, tokens, HTML text, media, location or history.
 * Diagnostic collects only numeric DOM selector presence and frame counts.
 * Hidden mode keeps a clipped attached WebView for max 30 seconds, while
 * MOA's own WebView stays interactive. No helper APK, root or Shizuku.
 */
public final class MoaNaverWebProbeDialog {
  private static final Handler MAIN=new Handler(Looper.getMainLooper());
  private static Controller active;
  private static volatile String state="IDLE";
  private static volatile int frameCount=-1,saveCount=-1,listCount=-1;
  private static volatile boolean hidden=false;
  private MoaNaverWebProbeDialog(){}
  public static void show(Activity a){
    if(Looper.myLooper()!=Looper.getMainLooper()){MAIN.post(()->show(a));return;}
    stop();active=new Controller(a);active.show();
  }
  public static void stop(){
    if(Looper.myLooper()!=Looper.getMainLooper()){MAIN.post(MoaNaverWebProbeDialog::stop);return;}
    Controller old=active;active=null;if(old!=null)old.dispose();
    hidden=false;state="DISPOSED";
  }
  public static String statusJson(){
    JSONObject o=new JSONObject();
    try{o.put("state",state);o.put("hidden",hidden);o.put("frameCount",frameCount);
      o.put("saveCount",saveCount);o.put("listCount",listCount);
      o.put("actualFavoritesSaved",false);o.put("webviewWriteEnabled",false);}catch(Exception ignored){}
    return o.toString();
  }
  private static int dp(Activity a,float x){return Math.round(x*a.getResources().getDisplayMetrics().density);}
  private static boolean isNaver(Uri u){
    if(u==null||!"https".equalsIgnoreCase(u.getScheme()))return false;
    String host=u.getHost();if(host==null)return false;
    String h=host.toLowerCase(Locale.ROOT);
    return h.equals("naver.com")||h.endsWith(".naver.com");
  }
  private static boolean safeProbePage(String url){
    try{Uri uri=Uri.parse(url);String host=uri.getHost();
      return "https".equalsIgnoreCase(uri.getScheme())&&host!=null&&
         (host.equalsIgnoreCase("map.naver.com")||host.equalsIgnoreCase("pcmap.place.naver.com")||
          host.equalsIgnoreCase("pages.map.naver.com"));
    }catch(Exception ignored){return false;}
  }
  private static final class Controller{
    final WeakReference<Activity> ref;
    Dialog dialog;WebView web;FrameLayout hiddenHolder;LinearLayout panel;
    TextView info,origin;Runnable timeout;boolean disposed=false;
    final long start=SystemClock.elapsedRealtime();
    Controller(Activity a){ref=new WeakReference<>(a);}
    void show(){
      Activity a=ref.get();if(a==null||a.isFinishing())return;
      state="WEBVIEW_VISIBLE_LOADING";hidden=false;frameCount=saveCount=listCount=-1;
      dialog=new Dialog(a);dialog.requestWindowFeature(Window.FEATURE_NO_TITLE);
      panel=new LinearLayout(a);panel.setOrientation(LinearLayout.VERTICAL);
      panel.setPadding(dp(a,10),dp(a,10),dp(a,10),dp(a,9));panel.setBackgroundColor(0xfffaf9fb);
      TextView heading=new TextView(a);heading.setText("네이버 웹 연결 진단  ·  저장하지 않음");
      heading.setTextSize(17);heading.setTypeface(null,1);heading.setTextColor(0xff2b2832);
      panel.addView(heading,new LinearLayout.LayoutParams(-1,dp(a,40)));
      origin=new TextView(a);origin.setText("접속: map.naver.com");origin.setTextColor(0xff595861);origin.setTextSize(12);
      panel.addView(origin,new LinearLayout.LayoutParams(-1,dp(a,28)));
      info=new TextView(a);info.setText("현재는 페이지 접근과 숨김 실행만 테스트합니다. 장소 저장은 실행하지 않아요.");
      info.setTextSize(12);info.setTextColor(0xff675e67);panel.addView(info,new LinearLayout.LayoutParams(-1,dp(a,50)));
      web=new WebView(a);WebSettings cfg=web.getSettings();
      cfg.setJavaScriptEnabled(true);cfg.setDomStorageEnabled(true);
      cfg.setAllowFileAccess(false);cfg.setAllowContentAccess(false);
      cfg.setMixedContentMode(WebSettings.MIXED_CONTENT_NEVER_ALLOW);
      cfg.setJavaScriptCanOpenWindowsAutomatically(false);
      CookieManager.getInstance().setAcceptCookie(true);
      // Never add JavaScriptInterface to third-party NAVER pages.
      CookieManager.getInstance().setAcceptThirdPartyCookies(web,true);
      web.setWebChromeClient(new WebChromeClient());
      web.setWebViewClient(new WebViewClient(){
        @Override public boolean shouldOverrideUrlLoading(WebView w,WebResourceRequest request){
          if(isNaver(request.getUrl()))return false;
          state="NON_NAVER_REDIRECT_BLOCKED";showState("네이버 외부 사이트 이동을 차단했어요");return true;
        }
        @Override public void onPageFinished(WebView w,String url){
          if(disposed)return;
          Uri u=Uri.parse(url);String host=u.getHost();
          if(origin!=null)origin.setText("접속: "+(host==null?"확인 중":host));
          state=safeProbePage(url)?"NAVER_MAP_PAGE_LOADED":"NAVER_LOGIN_OR_OTHER_PAGE";
          showState("웹페이지가 로드됐어요. 네이버 로그인이 필요하면 이 화면에서 직접 입력하세요.");
          if(safeProbePage(url))sample();
        }
        @Override public void onReceivedError(WebView view,WebResourceRequest request,android.webkit.WebResourceError error){
          if(request.isForMainFrame()){state="MAIN_FRAME_LOAD_ERROR";showState("페이지 로드 실패: 네이버 웹뷰 지원 여부 확인 필요");}
        }
        @Override public boolean onRenderProcessGone(WebView w,android.webkit.RenderProcessGoneDetail detail){
          state="WEBVIEW_RENDERER_GONE";if(active==Controller.this)MoaNaverWebProbeDialog.stop();return true;
        }
      });
      panel.addView(web,new LinearLayout.LayoutParams(-1,0,1));
      LinearLayout buttons=new LinearLayout(a);buttons.setGravity(Gravity.CENTER_VERTICAL);
      Button test=new Button(a);test.setText("요소 진단");test.setOnClickListener(v->sample());
      Button hide=new Button(a);hide.setText("숨김 검증");hide.setOnClickListener(v->goHidden());
      Button close=new Button(a);close.setText("닫기");close.setOnClickListener(v->MoaNaverWebProbeDialog.stop());
      for(Button b:new Button[]{test,hide,close}){
        b.setTextSize(12);b.setAllCaps(false);
        buttons.addView(b,new LinearLayout.LayoutParams(0,dp(a,54),1));
      }
      panel.addView(buttons,new LinearLayout.LayoutParams(-1,dp(a,59)));
      dialog.setContentView(panel);dialog.setOnDismissListener(d->{if(!disposed&&!hidden&&active==Controller.this)MoaNaverWebProbeDialog.stop();});
      Window win=dialog.getWindow();if(win!=null){win.setBackgroundDrawableResource(android.R.color.transparent);
       win.setLayout(WindowManager.LayoutParams.MATCH_PARENT,WindowManager.LayoutParams.MATCH_PARENT);}
      dialog.show();if(dialog.getWindow()!=null)dialog.getWindow().setLayout(-1,-1);
      web.loadUrl("https://map.naver.com/p/");
    }
    void showState(String message){if(info!=null&&!hidden)info.setText(message);}
    void sample(){
      if(disposed||web==null)return;
      String url=web.getUrl();if(!safeProbePage(url)){
        state="WAITING_FOR_NAVER_MAP_OR_LOGIN";showState("네이버지도 화면에서만 요소 진단을 실행합니다.");return;}
      state=hidden?"HIDDEN_JS_EVALUATING":"VISIBLE_JS_EVALUATING";
      // Numeric-only counts, no fields, names, account identifiers, URLs or credentials.
      String script="(function(){try{return JSON.stringify({frames:document.querySelectorAll('iframe').length,"+
        "save:document.querySelectorAll('button[aria-label*=\\\"저장\\\"],button.btn_favorite,a.D_Xqt').length,"+
        "lists:document.querySelectorAll('button.swt-save-group-info,button[class*=\\\"_list_item_\\\"]').length});"+
        "}catch(e){return JSON.stringify({frames:-1,save:-1,lists:-1})}})()";
      web.evaluateJavascript(script,r->{
        if(disposed)return;
        try{String value=new org.json.JSONTokener(r).nextValue().toString();
          JSONObject result=new JSONObject(value);
          frameCount=result.optInt("frames",-1);saveCount=result.optInt("save",-1);
          listCount=result.optInt("lists",-1);
          state=hidden?"HIDDEN_TOP_FRAME_READ_PASS":"VISIBLE_TOP_FRAME_READ_PASS";
          showState("요소 조회 완료. iframe "+frameCount+"개 · 저장 컨트롤 "+saveCount+"개 · 리스트 "+listCount+"개. 저장 실행은 하지 않았어요.");
        }catch(Exception e){state=hidden?"HIDDEN_JS_READ_FAIL":"VISIBLE_JS_READ_FAIL";
          showState("요소 조회를 확인하지 못했어요. 네이버 웹 화면 구조 확인 필요");}
      });
    }
    void goHidden(){
      Activity a=ref.get();if(disposed||web==null||a==null)return;
      if(!safeProbePage(web.getUrl())){showState("네이버지도 페이지를 연 뒤 숨김 상태를 검사하세요.");return;}
      try{
        ViewGroup parent=(ViewGroup)web.getParent();if(parent!=null)parent.removeView(web);
        hiddenHolder=new FrameLayout(a);hiddenHolder.setClipChildren(true);hiddenHolder.setClipToPadding(true);
        FrameLayout content=a.findViewById(android.R.id.content);
        content.addView(hiddenHolder,new FrameLayout.LayoutParams(dp(a,1),dp(a,1),Gravity.TOP|Gravity.LEFT));
        hiddenHolder.addView(web,new FrameLayout.LayoutParams(dp(a,390),dp(a,820)));
        web.setFocusable(false);web.setFocusableInTouchMode(false);web.setAlpha(0f);
        hidden=true;state="HIDDEN_ATTACHED_ACTIVE";
        if(dialog!=null){Dialog was=dialog;dialog=null;was.dismiss();}
        MAIN.postDelayed(()->{if(!disposed)sample();},2500);
        timeout=()->{if(active==Controller.this){state="HIDDEN_PROBE_MAX_30S";MoaNaverWebProbeDialog.stop();}};
        MAIN.postDelayed(timeout,30000);
      }catch(Exception e){state="HIDDEN_ATTACH_FAILED";MoaNaverWebProbeDialog.stop();}
    }
    void dispose(){
      if(disposed)return;disposed=true;
      if(timeout!=null)MAIN.removeCallbacks(timeout);
      if(web!=null){try{web.stopLoading();web.loadUrl("about:blank");}catch(Exception ignored){}
        ViewGroup p=(ViewGroup)web.getParent();if(p!=null)p.removeView(web);
        try{web.destroy();}catch(Exception ignored){}web=null;}
      if(hiddenHolder!=null){ViewGroup p=(ViewGroup)hiddenHolder.getParent();if(p!=null)p.removeView(hiddenHolder);hiddenHolder=null;}
      if(dialog!=null){Dialog was=dialog;dialog=null;try{was.dismiss();}catch(Exception ignored){}}
      hidden=false;
    }
  }
}