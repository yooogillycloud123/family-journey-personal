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
import android.webkit.CookieManager;
import android.webkit.WebView;
import org.json.JSONObject;
import java.lang.reflect.Method;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.ThreadFactory;

/**
 * R395: non-destructive, one-app hidden NAVER startup plus R391 cookie durability.
 * Calls only existing MOA controller on the same UI frame: start then hide.
 * Never touches NAVER credentials/cookie values, never opens a new browser identity,
 * never performs a place write or claims account saving success.
 */
public final class MoaR391SessionPersistProvider extends ContentProvider {
    private static final Handler MAIN = new Handler(Looper.getMainLooper());
    private static final ExecutorService WORKER = Executors.newSingleThreadExecutor(new ThreadFactory() {
        @Override public Thread newThread(Runnable r) { Thread t = new Thread(r,"moa-r391-cookie-flush");t.setDaemon(true);return t; }
    });
    private static long lastQueuedMs = -10000L;
    private static int hostEpoch = 0;
    private static final String HOST = "com.juhyeon.familyjourney.HostActivity";
    private static final String CONTROLLER = "com.juhyeon.familyjourney.MoaNaverWebProbeController";

    private static synchronized void persist() {
        long now = SystemClock.elapsedRealtime();
        if (now-lastQueuedMs < 2500L) return;
        lastQueuedMs = now;
        WORKER.execute(new Runnable() {
            @Override public void run() {
                try { CookieManager.getInstance().flush(); } catch (Throwable ignored) { }
            }
        });
    }
    private static boolean validHost(Activity a) {
        return a!=null&&!a.isFinishing()&&!a.isDestroyed()
          && (HOST.equals(a.getClass().getName()) || a.getClass().getName().endsWith("MoaMomentHostActivity"));
    }
    private static WebView ownView(View v,int depth) {
        if(depth>20)return null;
        if(v instanceof WebView) {
            WebView w=(WebView)v;
            String url=w.getUrl();
            if(url!=null && (url.startsWith("https://familyjourney.local/")
              ||url.startsWith("https://appassets.androidplatform.net/")
              ||url.startsWith("file:///android_asset/")))return w;
            return null;
        }
        if(v instanceof ViewGroup){ViewGroup g=(ViewGroup)v;
          for(int i=0;i<g.getChildCount();i++) {
            WebView w=ownView(g.getChildAt(i),depth+1);
            if(w!=null)return w;
          }
        }
        return null;
    }
    private static void hiddenWarm(Activity a) {
        if(!validHost(a))return;
        try {
            Class<?> c=Class.forName(CONTROLLER);
            Method status=c.getMethod("statusJson");
            JSONObject before=new JSONObject(String.valueOf(status.invoke(null)));
            if(before.optBoolean("running",false))return;
            // R365 reflection contract: no new app or external Naver Activity.
            c.getMethod("onHostResumed",Activity.class).invoke(null,a);
            Method start=c.getDeclaredMethod("start",Activity.class);
            Method hide=c.getDeclaredMethod("setHidden",Activity.class,boolean.class);
            start.setAccessible(true);hide.setAccessible(true);
            start.invoke(null,a);
            // Both invocations are on UI thread BEFORE another draw frame.
            hide.invoke(null,a,Boolean.TRUE);
        }catch(Throwable ignored) { /* original R391 and original user controls remain */ }
    }
    private static void scheduleWarm(final Activity a,final int epoch,final int tries){
        if(tries>15 || epoch!=hostEpoch || !validHost(a))return;
        MAIN.postDelayed(new Runnable(){@Override public void run(){
            if(epoch!=hostEpoch || !validHost(a))return;
            try{
                WebView w=ownView(a.getWindow().getDecorView(),0);
                if(w==null){scheduleWarm(a,epoch,tries+1);return;}
                // Only enabled by an actual MOA page, never by the NAVER login page.
                w.evaluateJavascript("(function(){try{return localStorage.getItem('moa.naver.offscreen.try.v1')!=='off'}catch(e){return false}})()",value->{
                    if(epoch==hostEpoch && validHost(a) && "true".equals(value))hiddenWarm(a);
                });
            }catch(Throwable ignored){scheduleWarm(a,epoch,tries+1);}
        }},tries==0?450L:500L);
    }
    @Override public boolean onCreate(){
        try{
            Application app=(Application)getContext().getApplicationContext();
            if(app==null)return true;
            app.registerActivityLifecycleCallbacks(new Application.ActivityLifecycleCallbacks(){
                @Override public void onActivityCreated(Activity a,Bundle b){}
                @Override public void onActivityStarted(Activity a){}
                @Override public void onActivityResumed(Activity a){
                    if(validHost(a))scheduleWarm(a,++hostEpoch,0);
                }
                @Override public void onActivityPaused(Activity a){
                    if(validHost(a))hostEpoch++;
                    persist();
                }
                @Override public void onActivityStopped(Activity a){persist();}
                @Override public void onActivitySaveInstanceState(Activity a,Bundle b){}
                @Override public void onActivityDestroyed(Activity a){}
            });
        }catch(Throwable ignored){}
        return true;
    }
    @Override public Cursor query(Uri uri,String[] p,String s,String[] sa,String sort){return null;}
    @Override public String getType(Uri uri){return null;}
    @Override public Uri insert(Uri uri,ContentValues v){return null;}
    @Override public int delete(Uri uri,String s,String[] args){return 0;}
    @Override public int update(Uri uri,ContentValues v,String s,String[] args){return 0;}
}