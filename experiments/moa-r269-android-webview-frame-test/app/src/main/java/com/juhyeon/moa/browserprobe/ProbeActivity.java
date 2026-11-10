package com.juhyeon.moa.browserprobe;
import android.app.Activity;
import android.net.Uri;
import android.graphics.Bitmap;
import android.os.Bundle;
import android.util.Log;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.webkit.WebResourceRequest;
import android.webkit.WebResourceError;
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
      "try{MoaProbe.postMessage(JSON.stringify({origin:location.origin,path:location.pathname,"+
      "ready:document.readyState,placeSaveCount:Array.prototype.filter.call(document.querySelectorAll('a[data-nlog-area]'),function(a){return a.getAttribute('data-nlog-area')==='map_btp.save';}).length,viewport:innerWidth}));}catch(e){}}"+
      "document.addEventListener('DOMContentLoaded',function(){setTimeout(send,2400)},{once:true});"+
      "[6000,12000,24000,42000,54000].forEach(function(t){setTimeout(send,t)});})();";
    WebViewCompat.addDocumentStartJavaScript(web,script,origins);
    web.setWebViewClient(new WebViewClient(){
       @Override public boolean shouldOverrideUrlLoading(WebView view,WebResourceRequest req){
         Uri u=req.getUrl();String host=u.getHost();
         if("https".equals(u.getScheme())&&host!=null&&(host.endsWith(".naver.com")||host.equals("naver.com")))return false;
         report("BLOCK_EXTERNAL",String.valueOf(host));return true;
       }
       @Override public void onPageStarted(WebView view,String url,Bitmap icon){
          report("NAVIGATE",url.split("[?]")[0]);
       }
       @Override public void onPageFinished(WebView view,String url){
          report("MAIN_FINISHED_NOT_PASS",url.split("[?]")[0]);
       }
       @Override public void onReceivedError(WebView view,WebResourceRequest req,WebResourceError error){
          if(req.isForMainFrame())report("MAIN_ERROR",String.valueOf(error.getErrorCode()));
       }
    });
    report("START","PC map root entry via Android WebView, no login, no saving");
    web.loadUrl("https://map.naver.com/p/entry/place/1628573942");
    // Check whether JS survives a non-interactive 2x2 in-app browser stage.
    web.postDelayed(()->{if(web!=null){tiny.width=2;tiny.height=2;web.setLayoutParams(tiny);report("SWITCH_TINY","2x2 after 35s full viewport, no user-screen takeover");}},35000);
  }
  @Override protected void onDestroy(){if(web!=null){web.destroy();web=null;}super.onDestroy();}
}
