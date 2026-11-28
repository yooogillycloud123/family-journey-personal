package com.juhyeon.familyjournea.ai;

import android.app.job.JobInfo;
import android.app.job.JobParameters;
import android.app.job.JobScheduler;
import android.app.job.JobService;
import android.content.ComponentName;
import android.content.Context;
import android.content.SharedPreferences;
import android.net.NetworkCapabilities;
import android.net.NetworkRequest;
import android.os.Handler;
import android.os.Looper;
import android.os.SystemClock;
import android.webkit.*;
import java.io.*;
import java.util.Locale;
import org.json.*;

/** OS-owned persistent automatic study runner. No Activity or external UI is opened.
 * Only a local, fixed-origin storage worker may reach the existing authenticated AI engine. */
public final class MoaStudyJob785 extends JobService {
    private static final int JOB = 785071;
    private static final String PREF="moa.study.scheduler.v785";
    private static final String PAGE="https://familyjourney.local/__moa_study785/index.html";
    private static final String SCRIPT="https://familyjourney.local/__moa_study785/inline.js";
    private static final long MAX=8*60*1000L;
    private static final Handler MAIN=new Handler(Looper.getMainLooper());
    private static MoaStudyJob785 live;
    private WebView web;
    private JobParameters params;
    private long started;
    private int epoch;
    private boolean ticking=false;

    static SharedPreferences pref(Context c){return c.getSharedPreferences(PREF,Context.MODE_PRIVATE);}
    static boolean enabled(Context c){return pref(c).getBoolean("enabled",false);}
    static boolean ownsWorker(){return live!=null;}
    static JSONObject status(Context c)throws JSONException{JobScheduler j=c.getSystemService(JobScheduler.class);return new JSONObject().put("enabled",enabled(c)).put("running",live!=null).put("scheduled",j!=null&&j.getPendingJob(JOB)!=null).put("error",pref(c).getString("lastError",""));}
    static void configure(Context c,JSONObject j)throws IOException{
        Context ctx=c.getApplicationContext();
        boolean on=j.optBoolean("enabled"),wifi=j.optBoolean("wifi"),charge=j.optBoolean("charge");
        SharedPreferences p=pref(ctx);
        boolean changed=on!=p.getBoolean("enabled",false)||wifi!=p.getBoolean("wifi",false)||charge!=p.getBoolean("charge",false);
        if(!p.edit().putBoolean("enabled",on).putBoolean("wifi",wifi).putBoolean("charge",charge).commit())
            throw new IOException("자동 학습 설정 저장 실패");
        JobScheduler s=ctx.getSystemService(JobScheduler.class);
        if(s==null)throw new IOException("Android 작업 예약 서비스 없음");
        if(!on){s.cancel(JOB);if(live!=null)live.finish(-1);return;}
        if(changed){s.cancel(JOB);if(live!=null)live.finish(-1);}
        schedule(ctx,1000,changed||j.optBoolean("retry"));
    }
    static void invalidate(Context c,String day){
        Context ctx=c.getApplicationContext();
        if(!enabled(ctx))return;
        // A committed removal/edit to the current day stops any in-flight generation.
        // Future work re-reads the authoritative store rather than trusting the old snapshot.
        if(live!=null&&live.web!=null&&MoaInline755.backgroundDay785(live.web).equals(day)){
            live.finish(3000);
        }else schedule(ctx,1000,false);
    }
    private static void schedule(Context ctx,long delay,boolean replace){
        if(!enabled(ctx)||live!=null)return;
        try{
            JobScheduler js=ctx.getSystemService(JobScheduler.class);
            if(js==null||(!replace&&js.getPendingJob(JOB)!=null))return;
            SharedPreferences p=pref(ctx);
            JobInfo.Builder b=new JobInfo.Builder(JOB,new ComponentName(ctx,MoaStudyJob785.class))
                .setPersisted(true).setMinimumLatency(Math.max(1000,Math.min(delay,21600000L)))
                .setRequiresCharging(p.getBoolean("charge",false));
            if(p.getBoolean("wifi",false)){
                b.setRequiredNetwork(new NetworkRequest.Builder().addTransportType(NetworkCapabilities.TRANSPORT_WIFI)
                    .addCapability(NetworkCapabilities.NET_CAPABILITY_INTERNET).build());
            }else b.setRequiredNetworkType(JobInfo.NETWORK_TYPE_ANY);
            if(js.schedule(b.build())!=JobScheduler.RESULT_SUCCESS)
                pref(ctx).edit().putString("lastError","OS 작업 예약 거부").apply();
            else pref(ctx).edit().remove("lastError").apply();
        }catch(Exception e){pref(ctx).edit().putString("lastError","OS 작업 예약 실패 "+e.getClass().getSimpleName()).apply();}
    }
    @Override public boolean onStartJob(JobParameters p){
        if(!enabled(this)||live!=null)return false;
        live=this;params=p;started=SystemClock.elapsedRealtime();int run=++epoch;
        MAIN.post(()->{
            if(params!=p||epoch!=run)return;
            if(MoaInline755.aiBusy785()){finish(30000);return;}
            try{openWorker();poll(run);}catch(Exception e){finish(900000);}
        });
        return true;
    }
    private WebResourceResponse asset(String name,String type){
        try{return new WebResourceResponse(type,"UTF-8",getAssets().open("web/"+name));}
        catch(IOException e){return denied();}
    }
    private static WebResourceResponse denied(){return new WebResourceResponse("text/plain","UTF-8",403,"Forbidden",java.util.Collections.emptyMap(),new ByteArrayInputStream(new byte[0]));}
    private void openWorker(){
        web=new WebView(getApplicationContext());
        WebSettings s=web.getSettings();
        s.setJavaScriptEnabled(true);s.setDomStorageEnabled(true);
        s.setAllowFileAccess(false);s.setAllowContentAccess(false);
        s.setJavaScriptCanOpenWindowsAutomatically(false);s.setSupportMultipleWindows(false);
        s.setMixedContentMode(WebSettings.MIXED_CONTENT_NEVER_ALLOW);
        s.setCacheMode(WebSettings.LOAD_NO_CACHE);
        web.setWebViewClient(new WebViewClient(){
            @Override public WebResourceResponse shouldInterceptRequest(WebView v,WebResourceRequest r){
                String u=r.getUrl().toString();
                if(PAGE.equals(u)&&r.isForMainFrame())return asset("moa-r785-worker.html","text/html");
                if(SCRIPT.equals(u)&&!r.isForMainFrame())return asset("moa-r755-inline-ai.js","application/javascript");
                return denied();
            }
            @Override public boolean shouldOverrideUrlLoading(WebView v,WebResourceRequest r){return !PAGE.equals(r.getUrl().toString());}
            @Override public void onReceivedError(WebView v,WebResourceRequest r,WebResourceError e){if(r.isForMainFrame())MAIN.post(()->{if(v==web)finish(900000);});}
            @Override public boolean onRenderProcessGone(WebView v,RenderProcessGoneDetail detail){MAIN.post(()->{if(v==web)finish(900000);});return true;}
        });
        final WebView owner=web;
        web.addJavascriptInterface(new Object(){
            @JavascriptInterface public boolean send(String encoded){
                if(encoded==null||encoded.length()>65000)return false;
                MAIN.post(()->{
                    if(web==owner&&params!=null&&PAGE.equals(owner.getUrl())&&enabled(MoaStudyJob785.this))
                        MoaInline755.dispatchBackground785(owner,encoded);
                });
                return true;
            }
        },"MoaBackgroundNative785");
        web.loadUrl(PAGE);
    }
    private void poll(int run){
        if(params==null||run!=epoch)return;
        if(!enabled(this)){finish(-1);return;}
        if(SystemClock.elapsedRealtime()-started>MAX){finish(30000);return;}
        if(web==null){finish(900000);return;}
        if(!ticking){
            ticking=true;
            web.evaluateJavascript("(window.MoaInline755&&window.MoaInline755.backgroundTick785)?window.MoaInline755.backgroundTick785():'loading'",value->{
                ticking=false;if(params==null||epoch!=run)return;
                try{
                    Object x=new JSONTokener(value).nextValue();String a=String.valueOf(x);
                    if(a.equals("stop")){finish(-1);return;}
                    if(a.startsWith("done:")){finish(Long.parseLong(a.substring(5)));return;}
                }catch(Exception ignored){}
            });
        }
        MAIN.postDelayed(()->poll(run),2000);
    }
    private void cleanup(){
        ++epoch;params=null;ticking=false;
        WebView w=web;web=null;
        if(w!=null){MoaInline755.closeBackground785(w);try{w.removeJavascriptInterface("MoaBackgroundNative785");w.stopLoading();w.destroy();}catch(Exception ignored){}}
        if(live==this)live=null;
    }
    private void finish(long next){
        JobParameters p=params;if(p==null)return;
        cleanup();
        jobFinished(p,false);
        if(next>=0&&enabled(this)){Context c=getApplicationContext();MAIN.postDelayed(()->schedule(c,next,true),1000);}
    }
    @Override public boolean onStopJob(JobParameters p){if(params==null)return false;cleanup();return enabled(this);}
    @Override public void onDestroy(){cleanup();super.onDestroy();}
}
