package com.juhyeon.familyjourney;

import android.app.Presentation;
import android.content.Context;
import android.hardware.display.DisplayManager;
import android.hardware.display.VirtualDisplay;
import android.graphics.PixelFormat;
import android.media.Image;
import android.media.ImageReader;
import android.net.Uri;
import android.os.Handler;
import android.os.Looper;
import android.view.Display;
import android.webkit.WebResourceRequest;
import android.webkit.WebView;
import android.webkit.WebViewClient;

/**
 * R91 EXPERIMENT — a normal unprivileged Android app's OWN Presentation
 * rendered onto its OWN private virtual display. Shizuku/root/ADB are absent.
 *
 * IMPORTANT: This is WEB NAVER in OUR WebView, NOT the NAVER Maps APK.
 * It does not attempt a bookmark write or harvest login/cookies. In the
 * upstream SDK, launching another company's Activity requires elevated
 * privilege; a Presentation containing our own WebView does not.
 *
 * For final integration, the host must own the lifecycle and call close().
 * State must not be interpreted as a successful NAVER account save.
 */
public final class MoaNaverHiddenWebProbe implements AutoCloseable {
  public interface Listener { void onStatus(String code, String detail); }

  private final Context context;
  private final Listener listener;
  private final Handler main = new Handler(Looper.getMainLooper());
  private VirtualDisplay virtual;
  private ImageReader frames;
  private Presentation presentation;
  private WebView web;
  private long sessionStarted = 0L;

  public MoaNaverHiddenWebProbe(Context context, Listener listener) {
    this.context = context;
    this.listener = listener;
  }

  public void startReadOnly() {
    if(Looper.myLooper()!=Looper.getMainLooper()) {
      main.post(this::startReadOnly);
      return;
    }
    close();
    try {
      final int width = 720, height = 1280, density = 320;
      // Drain and discard frames: no screenshot, family photo or web pixel
      // gets saved. This prevents ImageReader's maxImages queue from stalling.
      frames = ImageReader.newInstance(width,height,PixelFormat.RGBA_8888,2);
      frames.setOnImageAvailableListener(reader -> {
        Image last = null;
        try { last = reader.acquireLatestImage(); } catch(Exception ignored) {}
        finally { if(last!=null) last.close(); }
      },main);
      DisplayManager dm=(DisplayManager)context.getSystemService(Context.DISPLAY_SERVICE);
      virtual=dm.createVirtualDisplay("MOA-hidden-NAVER-WEB-READONLY",
        width,height,density,frames.getSurface(),
        DisplayManager.VIRTUAL_DISPLAY_FLAG_OWN_CONTENT_ONLY);
      if(virtual==null || virtual.getDisplay()==null ||
        virtual.getDisplay().getDisplayId()==Display.DEFAULT_DISPLAY) {
        status("VIRTUAL_DISPLAY_NOT_AVAILABLE","");
        close();
        return;
      }
      sessionStarted=System.currentTimeMillis();
      presentation=new Presentation(context,virtual.getDisplay());
      web=new WebView(presentation.getContext());
      web.getSettings().setJavaScriptEnabled(true);
      web.getSettings().setDomStorageEnabled(true);
      web.getSettings().setAllowFileAccess(false);
      web.getSettings().setAllowContentAccess(false);
      web.getSettings().setMixedContentMode(android.webkit.WebSettings.MIXED_CONTENT_NEVER_ALLOW);
      web.setWebViewClient(new WebViewClient(){
        @Override public boolean shouldOverrideUrlLoading(WebView view,WebResourceRequest request) {
          Uri u=request.getUrl();
          String host=u.getHost()==null?"":u.getHost().toLowerCase(java.util.Locale.ROOT);
          // This read-only proof stays in NAVER map pages. Login needs
          // separate user-approved visible first-party session bootstrap.
          if(!"https".equalsIgnoreCase(u.getScheme()) ||
            !(host.equals("m.map.naver.com") || host.equals("map.naver.com"))) {
            status("EXTERNAL_OR_LOGIN_URL_STOPPED",host);
            return true;
          }
          return false;
        }
        @Override public void onPageFinished(WebView view,String url) {
          status("HIDDEN_WEB_PAGE_LOADED",Uri.parse(url).getHost());
        }
        @Override public void onReceivedError(WebView view,WebResourceRequest request,
          android.webkit.WebResourceError error) {
          if(request.isForMainFrame())status("WEB_LOAD_ERROR",
             error.getDescription()==null?"":error.getDescription().toString());
        }
      });
      presentation.setContentView(web);
      presentation.show();
      web.loadUrl("https://m.map.naver.com/");
      status("VIRTUAL_PRESENTATION_OPEN","display="+virtual.getDisplay().getDisplayId());
      main.postDelayed(()->{
        if(sessionStarted>0 && System.currentTimeMillis()-sessionStarted>=30000L) {
          status("TIMEOUT_AUTOCLOSE","");
          close();
        }
      },31000L);
    }catch(Throwable e){
      status("HIDDEN_WEB_FAIL",e.getClass().getSimpleName());
      close();
    }
  }

  private void status(String code,String detail) {
    if(listener!=null)listener.onStatus(code,detail==null?"":detail);
  }

  @Override public void close() {
    if(Looper.myLooper()!=Looper.getMainLooper()){main.post(this::close);return;}
    sessionStarted=0;
    try{if(web!=null){web.stopLoading();web.destroy();}}catch(Throwable ignored){}
    web=null;
    try{if(presentation!=null)presentation.dismiss();}catch(Throwable ignored){}
    presentation=null;
    try{if(virtual!=null)virtual.release();}catch(Throwable ignored){}
    virtual=null;
    try{if(frames!=null)frames.close();}catch(Throwable ignored){}
    frames=null;
  }
}
