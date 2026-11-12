package com.juhyeon.familyjourney;

import android.app.Activity;
import android.app.Application;
import android.content.ContentProvider;
import android.content.ContentValues;
import android.database.Cursor;
import android.net.Uri;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.os.SystemClock;
import android.view.View;
import android.view.ViewGroup;
import android.view.Gravity;
import android.webkit.CookieManager;
import android.webkit.WebView;
import android.widget.FrameLayout;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Canvas;
import android.graphics.LinearGradient;
import android.graphics.Paint;
import android.graphics.Rect;
import android.graphics.RectF;
import android.graphics.Shader;
import android.graphics.Typeface;
import org.json.JSONObject;
import java.lang.reflect.Method;
import java.util.WeakHashMap;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.ThreadFactory;

/**
 * R399: preserve original R397/R391 NAVER login and first-party save handlers.
 * Show a temporary native MOA-style launch mask ABOVE the ORIGINAL visible NAVER WebView
 * so it gets full-size rendering for a bounded period before the original controller
 * transitions it to hidden. If genuine page/frame readiness is never observed,
 * dispose ONLY the experimental WebView and restore untouched R397 visible-first fallback.
 * No cookie inspection/clearing, login automation, independent WebView profile, or server API.
 */
public final class MoaR391SessionPersistProvider extends ContentProvider {
  private static final String HOST="com.juhyeon.familyjourney.HostActivity";
  private static final String CTRL="com.juhyeon.familyjourney.MoaNaverWebProbeController";
  private static final Handler UI=new Handler(Looper.getMainLooper());
  private static final long MAX_MASK_MS=3200L;
  private static final long MIN_DRAW_MS=450L;
  private static final WeakHashMap<Activity,Run> RUNS=new WeakHashMap<>();
  private static final ExecutorService FLUSH=Executors.newSingleThreadExecutor(new ThreadFactory(){
    @Override public Thread newThread(Runnable r){Thread t=new Thread(r,"moa-r399-cookie-flush");t.setDaemon(true);return t;}
  });
  private static long lastFlush=-10000L;
  private static final class Run {
    final Activity host;
    View mask;
    boolean attempted=false,finished=false,ownedProbe=false;
    long start=0L;
    int epoch=0;
    Run(Activity a){host=a;}
  }
  private static boolean host(Activity a){return a!=null&&HOST.equals(a.getClass().getName())&&!a.isFinishing()&&!a.isDestroyed();}
  private static synchronized void persist(){
    long now=SystemClock.elapsedRealtime();if(now-lastFlush<2500)return;lastFlush=now;
    FLUSH.execute(()->{try{CookieManager.getInstance().flush();}catch(Throwable ignored){}});
  }
  private static float dp(Activity a,float v){return a.getResources().getDisplayMetrics().density*v;}
  private static View mask(Activity a){
    return new View(a){
      private final Paint p=new Paint(3);
      private final Bitmap logo=load();
      private Bitmap load(){
        try(java.io.InputStream in=a.getAssets().open("web/moa-icon-themes/A_modern_bold_pink.png")){
          return BitmapFactory.decodeStream(in);
        }catch(Throwable err){return null;}
      }
      @Override protected void onDraw(Canvas canvas){
        super.onDraw(canvas);
        float w=getWidth(),h=getHeight();
        if(w<=0||h<=0)return;
        p.reset();p.setAntiAlias(true);
        p.setShader(new LinearGradient(0,0,0,h,new int[]{0xfffffaf6,0xfffff5ef,0xfffbdcd7},null,Shader.TileMode.CLAMP));
        canvas.drawRect(0,0,w,h,p);p.setShader(null);
        float side=Math.min(dp(a,180),w*0.51f);
        float cy=h*.36f;
        if(logo!=null){
          p.setFilterBitmap(true);
          Rect src=new Rect(0,0,logo.getWidth(),logo.getHeight());
          RectF dst=new RectF((w-side)/2,cy-side/2,(w+side)/2,cy+side/2);
          canvas.drawBitmap(logo,src,dst,p);
        }else{
          p.setColor(0xfff40068);canvas.drawRoundRect(new RectF((w-side)/2,cy-side/2,(w+side)/2,cy+side/2),dp(a,32),dp(a,32),p);
          p.setTextSize(dp(a,46));p.setTypeface(Typeface.DEFAULT_BOLD);p.setColor(-1);p.setTextAlign(Paint.Align.CENTER);
          canvas.drawText("MOA",w/2,cy+dp(a,15),p);
        }
        p.setShader(null);p.setColor(0xff122938);p.setTypeface(Typeface.create("sans-serif",Typeface.BOLD));
        p.setTextAlign(Paint.Align.CENTER);p.setTextSize(dp(a,34));
        canvas.drawText("모아",w/2,cy+side/2+dp(a,65),p);
        p.setTypeface(Typeface.create("sans-serif",Typeface.NORMAL));p.setTextSize(dp(a,15));p.setColor(0xff5b5b66);
        canvas.drawText("우리 가족의 모든 기억, 모아",w/2,h*.86f,p);
      }
    };
  }
  private static void attach(Run r){
    try{
      View v=r.host.findViewById(android.R.id.content);
      if(!(v instanceof FrameLayout))return;
      FrameLayout root=(FrameLayout)v;
      View overlay=mask(r.host);
      overlay.setClickable(true);overlay.setFocusable(false);
      overlay.setImportantForAccessibility(View.IMPORTANT_FOR_ACCESSIBILITY_NO);
      root.addView(overlay,new FrameLayout.LayoutParams(-1,-1,Gravity.FILL));
      overlay.bringToFront();r.mask=overlay;
    }catch(Throwable ignored){}
  }
  private static void unmask(Run r){
    View v=r.mask;r.mask=null;if(v==null)return;
    try{if(v.getParent() instanceof ViewGroup)((ViewGroup)v.getParent()).removeView(v);}catch(Throwable ignored){}
  }
  private static WebView own(View v,int d){
    if(d>24)return null;
    if(v instanceof WebView){
      WebView w=(WebView)v;String u=w.getUrl();
      if(u!=null&&(u.startsWith("https://familyjourney.local/")||u.startsWith("https://appassets.androidplatform.net/")||u.startsWith("file:///android_asset/")))return w;
      return null;
    }
    if(v instanceof ViewGroup){ViewGroup g=(ViewGroup)v;for(int i=0;i<g.getChildCount();i++){
      WebView match=own(g.getChildAt(i),d+1);if(match!=null)return match;
    }}return null;
  }
  private static JSONObject status(Class<?> c)throws Exception{
    return new JSONObject(String.valueOf(c.getMethod("statusJson").invoke(null)));
  }
  private static void invoke(Class<?> c,String name,Activity a)throws Exception{
    Method m=c.getDeclaredMethod(name,Activity.class);m.setAccessible(true);m.invoke(null,a);
  }
  private static void finish(Run r, boolean keep){
    if(r.finished)return;
    r.finished=true;r.epoch++;
    try{
      if(r.ownedProbe){
        Class<?> c=Class.forName(CTRL);
        if(keep){
          invokeHide(c,r.host);
          JSONObject after=status(c);
          if(!after.optBoolean("running",false)||!after.optBoolean("hidden",false))c.getMethod("dispose").invoke(null);
        }else c.getMethod("dispose").invoke(null);
      }
    }catch(Throwable ignored){}
    unmask(r);
  }
  private static void invokeHide(Class<?> c,Activity a)throws Exception{
    Method m=c.getDeclaredMethod("setHidden",Activity.class,boolean.class);m.setAccessible(true);m.invoke(null,a,Boolean.TRUE);
  }
  private static void poll(Run r,int generation){
    if(r.finished||r.epoch!=generation||!host(r.host))return;
    long elapsed=SystemClock.elapsedRealtime()-r.start;
    try{
      JSONObject s=status(Class.forName(CTRL));
      String state=s.optString("state","");
      boolean ready=state.contains("FRAME_ELEMENTS_OBSERVED")||state.contains("DESKTOP_PAGE_FINISHED");
      if(ready&&elapsed>=MIN_DRAW_MS&&s.optBoolean("running",false)){
        finish(r,true);return;
      }
    }catch(Throwable ignored){}
    if(elapsed>=MAX_MASK_MS){finish(r,false);return;}
    UI.postDelayed(()->poll(r,generation),130);
  }
  private static void begin(Run r){
    if(r.attempted||r.finished||!host(r.host))return;
    r.attempted=true;
    try{
      Class<?> c=Class.forName(CTRL);
      JSONObject prior=status(c);
      // When another user/controller session is already active, never disrupt it.
      if(prior.optBoolean("running",false)){
        // Only hide an existing probe if already attached to this host; do not close it.
        finish(r,false);return;
      }
      c.getMethod("onHostResumed",Activity.class).invoke(null,r.host);
      invoke(c,"start",r.host); // Full-size visible WebView, masked by our higher native layer.
      JSONObject after=status(c);
      if(!after.optBoolean("running",false)){finish(r,false);return;}
      r.ownedProbe=true;r.start=SystemClock.elapsedRealtime();
      if(r.mask!=null){r.mask.bringToFront();r.mask.invalidate();}
      int gen=++r.epoch;
      UI.postDelayed(()->poll(r,gen),130);
    }catch(Throwable ignored){finish(r,false);}
  }
  private static void findAndStart(Run r,int tries){
    if(r.finished||r.attempted||!host(r.host))return;
    try{
      WebView w=own(r.host.getWindow().getDecorView(),0);
      if(w!=null){
        w.evaluateJavascript("(function(){try{return localStorage.getItem('moa.naver.offscreen.try.v1')!=='off'}catch(e){return false}})()",val->{
          if(r.finished||r.attempted)return;
          if("true".equals(val))begin(r);else finish(r,false);
        });
        return;
      }
    }catch(Throwable ignored){}
    if(tries>14){finish(r,false);return;}
    UI.postDelayed(()->findAndStart(r,tries+1),145);
  }
  @Override public boolean onCreate(){
    try{
      Application app=(Application)getContext().getApplicationContext();
      app.registerActivityLifecycleCallbacks(new Application.ActivityLifecycleCallbacks(){
        @Override public void onActivityCreated(Activity a,Bundle b){
          if(host(a)){Run r=new Run(a);RUNS.put(a,r);attach(r);}
        }
        @Override public void onActivityStarted(Activity a){}
        @Override public void onActivityResumed(Activity a){
          Run r=RUNS.get(a);if(r!=null&&!r.attempted&&!r.finished)UI.postDelayed(()->findAndStart(r,0),130);
        }
        @Override public void onActivityPaused(Activity a){
          Run r=RUNS.get(a);if(r!=null&&!r.finished)finish(r,false);
          persist();
        }
        @Override public void onActivityStopped(Activity a){persist();}
        @Override public void onActivitySaveInstanceState(Activity a,Bundle b){}
        @Override public void onActivityDestroyed(Activity a){Run r=RUNS.remove(a);if(r!=null&&!r.finished)finish(r,false);}
      });
    }catch(Throwable ignored){}
    return true;
  }
  @Override public Cursor query(Uri u,String[] p,String s,String[] a,String sort){return null;}
  @Override public String getType(Uri u){return null;}
  @Override public Uri insert(Uri u,ContentValues v){return null;}
  @Override public int delete(Uri u,String s,String[] a){return 0;}
  @Override public int update(Uri u,ContentValues v,String s,String[] a){return 0;}
}