package com.juhyeon.moa.browserprobe;
import android.app.Activity;
import android.net.Uri;
import android.graphics.Bitmap;
import android.graphics.Color;
import android.os.Message;
import android.view.MotionEvent;
import android.webkit.WebChromeClient;
import org.json.JSONArray;
import org.json.JSONObject;
import android.os.Bundle;
import android.util.Log;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.webkit.WebResourceRequest;
import android.webkit.WebResourceError;
import android.webkit.WebResourceResponse;
import android.webkit.WebSettings;
import android.widget.FrameLayout;
import android.widget.TextView;
import androidx.webkit.WebViewCompat;
import androidx.webkit.WebViewFeature;
import java.util.Arrays;
import java.util.HashSet;
import java.util.Set;

public final class ProbeActivity extends Activity {
  private static final String TAG="MOA_WEBFRAME_PROBE";
  private WebView web;
  private TextView status;
  private long navWindowStart;
  private int navCount;
  private void report(String state,String detail){
     String s=state+" "+detail.replaceAll("[\\r\\n]"," ").substring(0,Math.min(180,detail.replaceAll("[\\r\\n]"," ").length()));
     Log.i(TAG,s);
     runOnUiThread(()->{if(status!=null)status.setText(s);});
  }
  @Override public void onCreate(Bundle b){
    super.onCreate(b);
    FrameLayout root=new FrameLayout(this);
    status=new TextView(this);status.setText("INITIALIZING");
    root.addView(status,new FrameLayout.LayoutParams(-1,150));
    web=new WebView(this);
    FrameLayout.LayoutParams tiny=new FrameLayout.LayoutParams(-1,-1);
    tiny.leftMargin=0;tiny.topMargin=0; // Full viewport first: a 2x2 viewport may suppress the Place iframe entirely.
    root.addView(web,tiny);
    setContentView(root);
    WebSettings settings=web.getSettings();
    settings.setJavaScriptEnabled(true);
    settings.setDomStorageEnabled(true);
    settings.setUseWideViewPort(true);
    settings.setOffscreenPreRaster(true);
    settings.setSupportMultipleWindows(true);
    settings.setUserAgentString("Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36");
    Set<String> origins=new HashSet<>(Arrays.asList("https://map.naver.com","https://pcmap.place.naver.com","https://pages.map.naver.com"));
    if(!WebViewFeature.isFeatureSupported(WebViewFeature.WEB_MESSAGE_LISTENER) ||
       !WebViewFeature.isFeatureSupported(WebViewFeature.DOCUMENT_START_SCRIPT)){
      report("WEBKIT_UNSUPPORTED","MessageListener or DocumentStartScript unsupported");
      return;
    }
    WebViewCompat.addWebMessageListener(web,"MoaProbe",origins,
      (view,message,source,isMain,reply)->{
        final String msg=String.valueOf(message.getData());
        report("FRAME_"+(isMain?"TOP":"CHILD"),source.getHost()+" "+msg.substring(0,Math.min(msg.length(),110)));
      });
    String script="(function(){function send(){"+
      "try{var n=Array.prototype.filter.call(document.querySelectorAll('a[data-nlog-area]'),function(a){return a.getAttribute('data-nlog-area')==='map_btp.save';}).length;"+
      "var body=document.body?document.body.innerText:'';"+
      "var isError=/ERR_NAME_NOT_RESOLVED|ERR_CONNECTION|This site can't be reached|웹페이지를 사용할 수 없습니다|사이트에 연결할 수 없음/.test(body.slice(0,500));"+
      "MoaProbe.postMessage('saveCount='+n+';bodyLen='+body.length+';errorDocument='+isError+';ready='+document.readyState+';viewport='+innerWidth+';host='+location.hostname);}"+
      "catch(e){MoaProbe.postMessage('probeException='+e.name);}}"+
      "document.addEventListener('DOMContentLoaded',function(){setTimeout(send,2400)},{once:true});"+
      "[6000,12000,24000,42000,54000].forEach(function(t){setTimeout(send,t)});})();";
    WebViewCompat.addDocumentStartJavaScript(web,script,origins);
    web.setWebChromeClient(new WebChromeClient(){
      @Override public boolean onCreateWindow(WebView view, boolean isDialog, boolean isUserGesture, Message resultMsg) {
        report("AUTH_POPUP_REQUESTED","userGesture="+isUserGesture+";blocking anonymous popup for safety");
        return false;
      }
    });
    web.setWebViewClient(new WebViewClient(){
       @Override public boolean shouldOverrideUrlLoading(WebView view,WebResourceRequest req){
         Uri u=req.getUrl();String host=u.getHost();
         if("https".equals(u.getScheme())&&host!=null&&(host.endsWith(".naver.com")||host.equals("naver.com")))return false;
         report("BLOCK_EXTERNAL",String.valueOf(host));return true;
       }
       @Override public void onPageStarted(WebView view,String url,Bitmap icon){
          long now=android.os.SystemClock.elapsedRealtime();
          if(now-navWindowStart>25000L){navWindowStart=now;navCount=0;}
          navCount++;
          report("NAVIGATE",String.valueOf(Uri.parse(url).getHost())+" count25s="+navCount);
          if(navCount>10){view.stopLoading();report("REDIRECT_LOOP_ABORT","over 10 main-frame navigation events in 25s");}
       }
       @Override public void onPageFinished(WebView view,String url){
          report("MAIN_FINISHED_NOT_PASS",url.split("[?]")[0]);
       }
       @Override public void onReceivedError(WebView view,WebResourceRequest req,WebResourceError error){
          if(req.isForMainFrame())report("MAIN_ERROR",String.valueOf(error.getErrorCode()));
       }
       @Override public void onReceivedHttpError(WebView view,WebResourceRequest req,WebResourceResponse response){
          if(req.isForMainFrame())report("MAIN_HTTP_STATUS",String.valueOf(response.getStatusCode()));
       }
    });
    report("START","PC map root entry via Android WebView, no login, no saving");
    web.loadUrl("https://map.naver.com/p/entry/place/1628573942");
    // Check whether JS survives a non-interactive 2x2 in-app browser stage.
    web.postDelayed(()->{if(web!=null){tiny.width=2;tiny.height=2;web.setLayoutParams(tiny);report("SWITCH_TINY","2x2 after 35s full viewport, no user-screen takeover");}},35000);
    // Independent, evidence-based alternate: the real Place iframe as a top-level document.
    // This avoids blindly reloading the R241 looping map root and may avoid needing its parent.
    web.postDelayed(()->{if(web!=null){tiny.width=-1;tiny.height=-1;web.setLayoutParams(tiny);report("DIRECT_PLACE_START","full viewport pcmap.place.naver.com (anonymous/no click)");web.loadUrl("https://pcmap.place.naver.com/place/1628573942/home");}},65000);
    web.postDelayed(()->{if(web!=null){tiny.width=2;tiny.height=2;web.setLayoutParams(tiny);report("DIRECT_PLACE_TINY","direct Place page shrunk to 2x2 after 35s");}},100000);
    // ANONYMOUS, FRESH EMULATOR ONLY. Trigger one ordinary official Place Save control
    // while the WebView remains 2x2 to investigate whether login UI can be reached.
    // This cannot complete a real account write: the emulator has no NAVER login.
    web.postDelayed(()->{if(web!=null){
      String js="(function(){var a=document.querySelector('a[data-nlog-area=\\\"map_btp.save\\\"]');"+
        "if(!a)return 'NO_PLACE_SAVE_CONTROL';"+
        "if(a.getAttribute('aria-pressed')!=='false')return 'NOT_UNSAVED_SKIP';"+
        "a.click();return 'ANONYMOUS_CLICK_ATTEMPTED';})()";
      web.evaluateJavascript(js, result->report("ANON_SAVE_2X2",String.valueOf(result)));
    }},112000);
    web.postDelayed(()->{if(web!=null){
      String js="(function(){if(location.hostname!=='pcmap.place.naver.com')return 'LEFT_PLACE_ORIGIN';"+
        "var d=document.querySelectorAll('[role=dialog],dialog').length;"+
        "var t=document.body?document.body.innerText:'';"+
        "return 'dialogCount='+d+';loginTextVisible='+(/로그인/.test(t))+';saveControlCount='+"+
        "document.querySelectorAll('a[data-nlog-area]').length;})()";
      web.evaluateJavascript(js,result->report("ANON_POST_CLICK_UI",String.valueOf(result)));
    }},124000);
    // Simulate MOA on top of a FULL-SIZE in-app Naver WebView. Only the owner app
    // dispatches MotionEvent to its own child; never Accessibility/ADB/other apps.
    web.postDelayed(()->{if(web!=null){
      tiny.width=-1;tiny.height=-1;web.setLayoutParams(tiny);
      TextView cover=new TextView(this);cover.setBackgroundColor(Color.WHITE);
      cover.setTextColor(Color.BLACK);
      cover.setText("MOA foreground mock is interactive; NAVER runs behind it");
      cover.setOnClickListener(v->report("MOA_COVER_CLICK","foreground mock received actual Android input"));
      root.addView(cover,new FrameLayout.LayoutParams(-1,-1));
      report("MOA_COVER_ON","full-size Naver behind opaque MOA-owned foreground");
      web.postDelayed(this::attemptNativeTouchOnSave,5500);
    }},130000);
    web.postDelayed(()->{if(web!=null)report("POST_NATIVE_TOUCH_HOST",String.valueOf(Uri.parse(web.getUrl()).getHost()));},153000);
  }
  private void attemptNativeTouchOnSave() {
    if(web==null)return;
    // No site data or login fields are read; only Save control bounds and press flag.
    String js="(function(){var all=document.querySelectorAll('a[data-nlog-area]');var a=null;"+
      "for(var i=0;i<all.length;i++){if(all[i].getAttribute('data-nlog-area')==='map_btp.save'){a=all[i];break;}}"+
      "if(!a)return JSON.stringify({error:'NO_CONTROL'});var r=a.getBoundingClientRect();"+
      "var x=r.left+r.width/2,y=r.top+r.height/2;var el=document.elementFromPoint(x,y);"+
      "return JSON.stringify({x:x,y:y,w:r.width,h:r.height,vpW:innerWidth,vpH:innerHeight,"+
      "hit:!!el&&(el===a||a.contains(el)),pressed:a.getAttribute('aria-pressed')});})()";
    web.evaluateJavascript(js, raw->{
      try {
        String decoded=new JSONArray("["+raw+"]").getString(0);
        JSONObject o=new JSONObject(decoded);
        if(o.has("error")){report("NATIVE_TOUCH_SKIPPED",o.getString("error"));return;}
        if(!o.optBoolean("hit",false)||!"false".equals(o.optString("pressed"))||
           o.optDouble("w",0)<3||o.optDouble("h",0)<3){
          report("NATIVE_TOUCH_SKIPPED","Save control not hittable or already saved");return;
        }
        double vpW=o.optDouble("vpW",0),vpH=o.optDouble("vpH",0);
        if(vpW<10||vpH<10||web==null)return;
        float x=(float)(o.getDouble("x")*web.getWidth()/vpW);
        float y=(float)(o.getDouble("y")*web.getHeight()/vpH);
        if(x<0||y<0||x>web.getWidth()||y>web.getHeight()){
          report("NATIVE_TOUCH_SKIPPED","Outside WebView layout");return;
        }
        long down=android.os.SystemClock.uptimeMillis();
        MotionEvent press=MotionEvent.obtain(down,down,MotionEvent.ACTION_DOWN,x,y,0);
        MotionEvent release=MotionEvent.obtain(down,down+90,MotionEvent.ACTION_UP,x,y,0);
        web.dispatchTouchEvent(press);
        web.dispatchTouchEvent(release);
        press.recycle();release.recycle();
        report("NATIVE_TOUCH_SENT","own WebView;cover remains on top; no account sign-in");
        // Observe ONLY anonymous UI flags after a view-level touch. Never claim account write.
        web.postDelayed(()->{
          if(web==null)return;
          String followJs="(function(){var all=document.querySelectorAll('a[data-nlog-area]');var a=null;"+
            "for(var i=0;i<all.length;i++){if(all[i].getAttribute('data-nlog-area')==='map_btp.save'){a=all[i];break;}}"+
            "var t=document.body?document.body.innerText:'';return 'host='+location.hostname"+
            "+';dialogs='+document.querySelectorAll('[role=dialog],dialog').length"+
            "+';loginTextVisible='+(/로그인/.test(t))"+
            "+';pressed='+(a?a.getAttribute('aria-pressed'):'missing');})()";
          web.evaluateJavascript(followJs,result->report("NATIVE_TOUCH_POST_UI",String.valueOf(result)));
        },7000);
      }catch(Exception e){report("NATIVE_TOUCH_ERROR",e.getClass().getSimpleName());}
    });
  }
  @Override protected void onDestroy(){if(web!=null){web.destroy();web=null;}super.onDestroy();}
}
