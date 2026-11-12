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
import android.util.Log;
import android.view.Gravity;
import android.view.View;
import android.view.ViewGroup;
import android.widget.FrameLayout;
import android.webkit.CookieManager;
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
 * R403, deliberately reproducing the proven user sequence:
 * 1. STOP existing NAVER PC web controller (as the original Web window close button).
 * 2. START the exact original full-sized, visible PC map controller.
 * 3. Allow at least two real Android draw frames and ~0.46s visible-layout time.
 * 4. HIDE via the exact original "모아로" button's setHidden(Activity,true).
 * Throughout, an opaque MOA-style cover is kept above the browser view.
 * No cookies/credentials inspection or forced login. No changes to original account-save code.
 */
public final class MoaR391SessionPersistProvider extends ContentProvider {
  private static final String HOST="com.juhyeon.familyjourney.HostActivity";
  private static final String CTRL="com.juhyeon.familyjourney.MoaNaverWebProbeController";
  private static final String TAG="MOA_R403_BOOT";
  private static final Handler UI=new Handler(Looper.getMainLooper());
  private static final long VISIBLE_LAYOUT_MS=460L;
  private static final WeakHashMap<Activity, Run> RUNS=new WeakHashMap<>();
  private static final ExecutorService FLUSH=Executors.newSingleThreadExecutor(new ThreadFactory(){
    @Override public Thread newThread(Runnable r){Thread t=new Thread(r,"moa-r403-cookie-flush");t.setDaemon(true);return t;}
  });
  private static long lastFlush=-10000L;
  private static final class Run {
    final Activity activity;
    View cover;
    boolean attempted=false, finished=false, ownedBrowser=false;
    long startedAt;
    int observedFrames;
    int epoch;
    Run(Activity activity){this.activity=activity;}
  }
  private static boolean valid(Activity a){
    return a!=null && HOST.equals(a.getClass().getName()) && !a.isFinishing() && !a.isDestroyed();
  }
  private static synchronized void persist(){
    long now=SystemClock.elapsedRealtime();
    if(now-lastFlush<2500L)return;
    lastFlush=now;
    FLUSH.execute(()->{try{CookieManager.getInstance().flush();}catch(Throwable t){Log.w(TAG,"COOKIE_FLUSH_FAILED");}});
  }
  private static float dp(Activity a,float value){return a.getResources().getDisplayMetrics().density*value;}
  private static View newCover(Activity a){
    return new View(a){
      private final Paint p=new Paint(3);
      private final Bitmap logo=load();
      private Bitmap load(){
        try(java.io.InputStream in=a.getAssets().open("web/moa-icon-themes/A_modern_bold_pink.png")){
          return BitmapFactory.decodeStream(in);
        }catch(Throwable t){return null;}
      }
      @Override protected void onDraw(Canvas canvas){
        super.onDraw(canvas);
        float w=getWidth(),h=getHeight();if(w<=0||h<=0)return;
        p.reset();p.setAntiAlias(true);
        p.setShader(new LinearGradient(0,0,0,h,new int[]{0xfffffaf6,0xfffff5ef,0xfffbdcd7},null,Shader.TileMode.CLAMP));
        canvas.drawRect(0,0,w,h,p);p.setShader(null);
        float side=Math.min(dp(a,180),w*0.51f),cy=h*0.36f;
        if(logo!=null){
          p.setFilterBitmap(true);
          canvas.drawBitmap(logo,new Rect(0,0,logo.getWidth(),logo.getHeight()),
            new RectF((w-side)/2,cy-side/2,(w+side)/2,cy+side/2),p);
        }else{
          p.setColor(0xfff40068);
          canvas.drawRoundRect(new RectF((w-side)/2,cy-side/2,(w+side)/2,cy+side/2),dp(a,32),dp(a,32),p);
          p.setColor(-1);p.setTextSize(dp(a,46));p.setTypeface(Typeface.DEFAULT_BOLD);
          p.setTextAlign(Paint.Align.CENTER);canvas.drawText("MOA",w/2,cy+dp(a,15),p);
        }
        p.setShader(null);p.setColor(0xff122938);
        p.setTypeface(Typeface.create("sans-serif",Typeface.BOLD));
        p.setTextAlign(Paint.Align.CENTER);p.setTextSize(dp(a,34));
        canvas.drawText("모아",w/2,cy+side/2+dp(a,65),p);
        p.setTypeface(Typeface.DEFAULT);p.setTextSize(dp(a,15));p.setColor(0xff5b5b66);
        canvas.drawText("우리 가족의 모든 기억, 모아",w/2,h*0.86f,p);
      }
    };
  }
  private static void attach(Run r){
    try{
      View content=r.activity.findViewById(android.R.id.content);
      if(!(content instanceof FrameLayout)){stage(r,"NO_FRAME_CONTENT");return;}
      FrameLayout root=(FrameLayout)content;
      View cover=newCover(r.activity);
      cover.setClickable(true);cover.setFocusable(false);
      cover.setImportantForAccessibility(View.IMPORTANT_FOR_ACCESSIBILITY_NO);
      root.addView(cover,new FrameLayout.LayoutParams(-1,-1,Gravity.FILL));
      cover.bringToFront();
      r.cover=cover;
      stage(r,"COVER_ATTACHED");
    }catch(Throwable t){stage(r,"COVER_ATTACH_FAILED");}
  }
  private static void removeCover(Run r){
    View cover=r.cover;r.cover=null;
    if(cover==null)return;
    try{if(cover.getParent() instanceof ViewGroup)((ViewGroup)cover.getParent()).removeView(cover);}
    catch(Throwable t){stage(r,"COVER_REMOVE_FAILED");}
  }
  private static void stage(Run r,String value){
    Log.i(TAG,value);
    try{r.activity.getSharedPreferences("moa_r403_bootstrap_stage",0).edit()
      .putString("last",value).putLong("at_elapsed_ms",SystemClock.elapsedRealtime()).apply();}
    catch(Throwable ignored){}
  }
  private static JSONObject status(Class<?> controller) throws Exception {
    return new JSONObject(String.valueOf(controller.getMethod("statusJson").invoke(null)));
  }
  private static void invoke(Class<?> controller,String name,Activity a) throws Exception {
    Method method=controller.getDeclaredMethod(name,Activity.class);
    method.setAccessible(true);method.invoke(null,a);
  }
  private static void hide(Class<?> controller,Activity a) throws Exception {
    Method method=controller.getDeclaredMethod("setHidden",Activity.class,boolean.class);
    method.setAccessible(true);method.invoke(null,a,Boolean.TRUE);
  }
  private static void closeOnlyOurBrowser(Run r){
    if(!r.ownedBrowser)return;
    try{Class.forName(CTRL).getMethod("dispose").invoke(null);}
    catch(Throwable ignored){}
    r.ownedBrowser=false;
  }
  private static void finish(Run r,boolean good){
    if(r.finished)return;
    r.finished=true;++r.epoch;
    if(!good)closeOnlyOurBrowser(r); // no stray unmasked WebView
    removeCover(r);
    stage(r,good?"STOP_VISIBLE_HIDE_COMPLETE":"STOP_VISIBLE_HIDE_FAILED");
  }
  private static void stepHide(Run r,int epoch){
    if(r.finished||r.epoch!=epoch)return;
    if(!valid(r.activity)){finish(r,false);return;}
    long elapsed=SystemClock.elapsedRealtime()-r.startedAt;
    if(elapsed<VISIBLE_LAYOUT_MS){UI.postDelayed(()->stepHide(r,epoch),VISIBLE_LAYOUT_MS-elapsed);return;}
    try{
      Class<?> c=Class.forName(CTRL);
      JSONObject before=status(c);
      if(!before.optBoolean("running",false)){stage(r,"HIDE_ABORT_NOT_RUNNING");finish(r,false);return;}
      // Exactly the user-proven PC map visible -> '모아로' path. Never wait for DOM readiness.
      hide(c,r.activity);
      JSONObject after=status(c);
      if(after.optBoolean("running",false)&&after.optBoolean("hidden",false)){
        stage(r,"HIDE_CONFIRMED");
        // Keep cover during one more layout opportunity, then restore MOA UI.
        UI.postDelayed(()->finish(r,true),60L);
      }else{
        stage(r,"HIDE_NOT_CONFIRMED");finish(r,false);
      }
    }catch(Throwable t){stage(r,"HIDE_EXCEPTION_"+t.getClass().getSimpleName());finish(r,false);}
  }
  private static void begin(Run r){
    if(r.attempted||r.finished||!valid(r.activity))return;
    r.attempted=true;
    try{
      if(r.cover==null)attach(r);
      if(r.cover==null){stage(r,"NO_COVER_ABORT");finish(r,false);return;}
      Class<?> c=Class.forName(CTRL);
      stage(r,"CLOSE_REQUESTED");
      // Same implementation as pressing '웹창 종료' (control('stop') calls dispose()).
      c.getMethod("dispose").invoke(null);
      stage(r,"CLOSE_FINISHED");
      c.getMethod("onHostResumed",Activity.class).invoke(null,r.activity);
      // Same implementation as pressing '네이버 PC 지도 열기' from a stopped controller.
      invoke(c,"start",r.activity);
      JSONObject after=status(c);
      if(!after.optBoolean("running",false)){
        stage(r,"VISIBLE_START_NOT_RUNNING_"+after.optString("state","unknown"));
        finish(r,false);return;
      }
      r.ownedBrowser=true;
      r.startedAt=SystemClock.elapsedRealtime();
      if(r.cover!=null){r.cover.bringToFront();r.cover.invalidate();}
      stage(r,"VISIBLE_STARTED_MASKED");
      // No fragile URL/DOM/mode preference gates: short manual visible period alone worked on the user's phone.
      final int epoch=++r.epoch;
      UI.postDelayed(()->stepHide(r,epoch),VISIBLE_LAYOUT_MS);
    }catch(Throwable t){stage(r,"BEGIN_EXCEPTION_"+t.getClass().getSimpleName());finish(r,false);}
  }
  @Override public boolean onCreate(){
    try{
      Application app=(Application)getContext().getApplicationContext();
      app.registerActivityLifecycleCallbacks(new Application.ActivityLifecycleCallbacks(){
        @Override public void onActivityCreated(Activity a,Bundle b){
          if(valid(a)){Run r=new Run(a);RUNS.put(a,r);attach(r);}
        }
        @Override public void onActivityStarted(Activity a){}
        @Override public void onActivityResumed(Activity a){
          Run r=RUNS.get(a);
          if(r!=null&&!r.attempted&&!r.finished)UI.postDelayed(()->begin(r),55L);
        }
        @Override public void onActivityPaused(Activity a){
          Run r=RUNS.get(a);
          if(r!=null&&!r.finished)finish(r,false);
          persist();
        }
        @Override public void onActivityStopped(Activity a){persist();}
        @Override public void onActivitySaveInstanceState(Activity a,Bundle b){}
        @Override public void onActivityDestroyed(Activity a){
          Run r=RUNS.remove(a);
          if(r!=null&&!r.finished)finish(r,false);
        }
      });
    }catch(Throwable t){Log.e(TAG,"CALLBACK_REGISTER_FAILED");}
    return true;
  }
  @Override public Cursor query(Uri u,String[] projection,String selection,String[] args,String sort){return null;}
  @Override public String getType(Uri u){return null;}
  @Override public Uri insert(Uri u,ContentValues values){return null;}
  @Override public int delete(Uri u,String selection,String[] args){return 0;}
  @Override public int update(Uri u,ContentValues values,String selection,String[] args){return 0;}
}