package com.juhyeon.familyjournea.ai;

import android.app.*;
import android.app.job.*;
import android.content.*;
import android.content.pm.ServiceInfo;
import android.net.*;
import android.os.*;
import android.webkit.*;
import java.io.*;
import java.util.Collections;
import org.json.*;

/** One worker, two legal Android execution modes. A visible user's enabled auto-study
 * starts a notification-backed dataSync service; persisted constrained jobs recover it
 * when the OS permits. No new account, media store, or external service. */
public final class MoaStudyJob785 extends JobService {
    private static final int JOB=785071, WATCH=785072, NOTICE=789071;
    private static final String PREF="moa.study.scheduler.v785", CHANNEL="moa.study.v789";
    private static final String PAGE="https://familyjourney.local/__moa_study785/index.html";
    private static final String SCRIPT="https://familyjourney.local/__moa_study785/inline.js";
    private static final long JOB_MAX=8*60*1000L, FG_MAX=45*60*1000L;
    private static final Handler MAIN=new Handler(Looper.getMainLooper());
    private static MoaStudyJob785 live;
    private static long startPending;
    private WebView web;
    private JobParameters params;
    private long started, lastNotice;
    private int epoch;
    private boolean active, foreground, ticking;
    private PowerManager.WakeLock wake;
    private String phase="작업 준비 중";
    static SharedPreferences pref(Context c){return c.getSharedPreferences(PREF,Context.MODE_PRIVATE);}
    static boolean enabled(Context c){return pref(c).getBoolean("enabled",false);}
    static boolean ownsWorker(){return live!=null;}
    static boolean yieldToManual(){
        if(live==null)return true;
        if(MoaInline755.aiBusy785())return false;
        live.finish(30000,"수동 AI 작업 우선");return true;
    }
    private static String constraint(Context c){
        try{
            SharedPreferences p=pref(c);
            ConnectivityManager cm=c.getSystemService(ConnectivityManager.class);
            NetworkCapabilities n=cm==null?null:cm.getNetworkCapabilities(cm.getActiveNetwork());
            if(n==null||!n.hasCapability(NetworkCapabilities.NET_CAPABILITY_INTERNET))return "인터넷 연결 대기";
            if(p.getBoolean("wifi",false)&&!n.hasTransport(NetworkCapabilities.TRANSPORT_WIFI))return "Wi-Fi 연결 대기";
            if(p.getBoolean("charge",false)){
                Intent b=c.registerReceiver(null,new IntentFilter(Intent.ACTION_BATTERY_CHANGED));
                if(b==null||b.getIntExtra(BatteryManager.EXTRA_PLUGGED,0)==0)return "충전 연결 대기";
            }
            return "";
        }catch(Exception e){return "연결 조건 확인 실패";}
    }
    static JSONObject status(Context c)throws JSONException{
        JobScheduler js=c.getSystemService(JobScheduler.class);SharedPreferences p=pref(c);
        return new JSONObject().put("enabled",enabled(c)).put("running",live!=null&&live.active)
            .put("foreground",live!=null&&live.foreground).put("scheduled",js!=null&&(js.getPendingJob(JOB)!=null||js.getPendingJob(WATCH)!=null))
            .put("starting",startPending>0&&SystemClock.elapsedRealtime()-startPending<15000)
            .put("error",p.getString("lastError","")).put("startError",p.getString("startError",""))
            .put("reason",constraint(c)).put("nextAt",p.getLong("nextDue789",0))
            .put("lastStop",p.getString("lastStop789","")).put("phase",live==null?"":live.phase);
    }
    static void configure(Context c,JSONObject j,Activity activity)throws IOException{
        Context ctx=c.getApplicationContext();SharedPreferences p=pref(ctx);
        boolean on=j.optBoolean("enabled"),wifi=j.optBoolean("wifi"),charge=j.optBoolean("charge");
        boolean changed=on!=p.getBoolean("enabled",false)||wifi!=p.getBoolean("wifi",false)||charge!=p.getBoolean("charge",false)||p.getInt("schema789",0)!=789;
        if(!p.edit().putBoolean("enabled",on).putBoolean("wifi",wifi).putBoolean("charge",charge).putInt("schema789",789).commit())
            throw new IOException("자동 학습 설정 저장 실패");
        JobScheduler js=ctx.getSystemService(JobScheduler.class);
        if(js==null)throw new IOException("Android 작업 예약 서비스 없음");
        if(!on){js.cancel(JOB);js.cancel(WATCH);startPending=0;if(live!=null)live.finish(-1,"자동 생성 OFF");return;}
        if(changed){js.cancel(JOB);js.cancel(WATCH);p.edit().putLong("nextDue789",0).remove("startError").apply();if(live!=null)live.finish(1000,"설정 변경");}
        scheduleWatch(ctx);
        boolean retry=j.optBoolean("retry");
        if(retry&&live==null)p.edit().putLong("nextDue789",0).apply();
        if(live==null)schedule(ctx,Math.max(1000,p.getLong("nextDue789",0)-System.currentTimeMillis()),changed||retry);
        // Only a visible Activity with prior explicit automatic-learning consent can request a foreground start.
        // A background JobScheduler callback or boot never starts a dataSync foreground service.
        boolean visible=j.optBoolean("interactive")&&activity!=null&&!activity.isFinishing()&&!activity.isDestroyed()&&activity.hasWindowFocus();
        boolean due=p.getLong("nextDue789",0)<=System.currentTimeMillis()+2500;
        boolean want=j.optBoolean("wantWork",true);
        if(visible&&want&&(retry||due||live!=null)&&constraint(ctx).isEmpty()
                &&(live==null||!live.foreground)&&!MoaInline755.aiBusy785()
                &&(startPending==0||SystemClock.elapsedRealtime()-startPending>15000)){
            startPending=SystemClock.elapsedRealtime();
            try{activity.startForegroundService(new Intent(activity,MoaStudyJob785.class).setAction("com.juhyeon.familyjournea.STUDY789"));p.edit().remove("startError").apply();}
            catch(Exception e){startPending=0;p.edit().putString("startError","즉시 시작 제한 · "+e.getClass().getSimpleName()).apply();}
        }
    }
    static void invalidate(Context c,String day){
        Context ctx=c.getApplicationContext();if(!enabled(ctx))return;
        if(live!=null&&live.web!=null&&MoaInline755.backgroundDay785(live.web).equals(day)){live.finish(3000,"등록 내용 변경 · 다시 확인");}
        else if(live!=null&&live.web!=null){live.web.evaluateJavascript("window.MoaInline755&&window.MoaInline755.invalidateScope789()",null);}
        else{pref(ctx).edit().putLong("nextDue789",0).apply();schedule(ctx,1000,true);}
    }
    private static JobInfo.Builder builder(Context c,int id){
        SharedPreferences p=pref(c);JobInfo.Builder b=new JobInfo.Builder(id,new ComponentName(c,MoaStudyJob785.class)).setPersisted(true).setRequiresCharging(p.getBoolean("charge",false));
        if(p.getBoolean("wifi",false))b.setRequiredNetwork(new NetworkRequest.Builder().addTransportType(NetworkCapabilities.TRANSPORT_WIFI).addCapability(NetworkCapabilities.NET_CAPABILITY_INTERNET).build());
        else b.setRequiredNetworkType(JobInfo.NETWORK_TYPE_ANY);return b;
    }
    private static void scheduleWatch(Context c){
        if(!enabled(c))return;
        try{JobScheduler js=c.getSystemService(JobScheduler.class);if(js!=null&&js.getPendingJob(WATCH)==null)js.schedule(builder(c,WATCH).setPeriodic(15*60*1000L).build());}catch(Exception ignored){}
    }
    private static void schedule(Context c,long delay,boolean replace){
        if(!enabled(c)||live!=null)return;
        try{JobScheduler js=c.getSystemService(JobScheduler.class);if(js==null||(!replace&&js.getPendingJob(JOB)!=null))return;
            delay=Math.max(1000,Math.min(delay,21600000L));
            if(js.schedule(builder(c,JOB).setMinimumLatency(delay).build())!=JobScheduler.RESULT_SUCCESS)pref(c).edit().putString("lastError","OS 작업 예약 거부").apply();
            else pref(c).edit().remove("lastError").putLong("nextDue789",System.currentTimeMillis()+delay).apply();
        }catch(Exception e){pref(c).edit().putString("lastError","OS 작업 예약 실패 · "+e.getClass().getSimpleName()).apply();}
    }
    private Notification notice(String message){
        NotificationManager nm=getSystemService(NotificationManager.class);
        nm.createNotificationChannel(new NotificationChannel(CHANNEL,"모아 자동 학습",NotificationManager.IMPORTANCE_LOW));
        Intent i=getPackageManager().getLaunchIntentForPackage(getPackageName());
        Notification.Builder b=new Notification.Builder(this,CHANNEL).setSmallIcon(android.R.drawable.stat_notify_sync)
            .setContentTitle("모아 자동 학습").setContentText(message).setStyle(new Notification.BigTextStyle().bigText(message))
            .setOnlyAlertOnce(true).setOngoing(true).setVisibility(Notification.VISIBILITY_PRIVATE);
        if(i!=null)b.setContentIntent(PendingIntent.getActivity(this,NOTICE,i,PendingIntent.FLAG_UPDATE_CURRENT|PendingIntent.FLAG_IMMUTABLE));
        if(Build.VERSION.SDK_INT>=31)b.setForegroundServiceBehavior(Notification.FOREGROUND_SERVICE_IMMEDIATE);
        return b.build();
    }
    private void acquireWake(){
        if(wake!=null)return;
        try{PowerManager pm=getSystemService(PowerManager.class);wake=pm.newWakeLock(PowerManager.PARTIAL_WAKE_LOCK,"MOA:study789");wake.setReferenceCounted(false);wake.acquire(FG_MAX+60000L);}catch(Exception e){wake=null;}
    }
    private void releaseWake(){if(wake!=null){try{if(wake.isHeld())wake.release();}catch(Exception ignored){}wake=null;}}
    @Override public int onStartCommand(Intent i,int flags,int startId){
        startPending=0;
        try{startForeground(NOTICE,notice("학습 저장소 확인 중"),ServiceInfo.FOREGROUND_SERVICE_TYPE_DATA_SYNC);foreground=true;}
        catch(Exception e){pref(this).edit().putString("startError","즉시 시작 실패 · "+e.getClass().getSimpleName()).apply();if(!active)stopSelf();return START_NOT_STICKY;}
        if(!enabled(this)||!constraint(this).isEmpty()){if(active)finish(30000,"실행 조건 대기");else{foreground=false;stopForeground(STOP_FOREGROUND_REMOVE);stopSelf();}return START_NOT_STICKY;}
        if(live!=null&&live!=this){foreground=false;stopForeground(STOP_FOREGROUND_REMOVE);stopSelf();return START_NOT_STICKY;}
        acquireWake();
        if(active){JobParameters old=params;params=null;if(old!=null)jobFinished(old,false);}
        else begin(null);
        scheduleWatch(getApplicationContext());return START_NOT_STICKY;
    }
    @Override public boolean onStartJob(JobParameters p){
        if(!enabled(this)||live!=null||!constraint(this).isEmpty()||pref(this).getLong("nextDue789",0)>System.currentTimeMillis()+2000)return false;
        begin(p);return true;
    }
    private void begin(JobParameters p){
        live=this;active=true;params=p;started=SystemClock.elapsedRealtime();phase="학습 저장소 준비 중";
        pref(this).edit().putLong("nextDue789",0).remove("lastError").apply();int run=++epoch;
        MAIN.post(()->openWhenReady(run));
    }
    private void openWhenReady(int run){
        if(!active||epoch!=run)return;
        if(MoaInline755.aiBusy785()){if(SystemClock.elapsedRealtime()-started>30000){finish(30000,"다른 AI 작업 실행 중");return;}MAIN.postDelayed(()->openWhenReady(run),1000);return;}
        try{openWorker();poll(run);}catch(Exception e){finish(60000,"작업 초기화 오류 · "+e.getClass().getSimpleName());}
    }
    private WebResourceResponse asset(String name,String type){try{return new WebResourceResponse(type,"UTF-8",getAssets().open("web/"+name));}catch(IOException e){return denied();}}
    private static WebResourceResponse denied(){return new WebResourceResponse("text/plain","UTF-8",403,"Forbidden",Collections.emptyMap(),new ByteArrayInputStream(new byte[0]));}
    private void openWorker(){
        web=new WebView(getApplicationContext());WebSettings s=web.getSettings();
        s.setJavaScriptEnabled(true);s.setDomStorageEnabled(true);s.setAllowFileAccess(false);s.setAllowContentAccess(false);
        s.setJavaScriptCanOpenWindowsAutomatically(false);s.setSupportMultipleWindows(false);s.setMixedContentMode(WebSettings.MIXED_CONTENT_NEVER_ALLOW);s.setCacheMode(WebSettings.LOAD_NO_CACHE);
        web.setWebViewClient(new WebViewClient(){
            @Override public WebResourceResponse shouldInterceptRequest(WebView v,WebResourceRequest r){String u=r.getUrl().toString();if(PAGE.equals(u)&&r.isForMainFrame())return asset("moa-r785-worker.html","text/html");if(SCRIPT.equals(u)&&!r.isForMainFrame())return asset("moa-r755-inline-ai.js","application/javascript");return denied();}
            @Override public boolean shouldOverrideUrlLoading(WebView v,WebResourceRequest r){return !PAGE.equals(r.getUrl().toString());}
            @Override public void onReceivedError(WebView v,WebResourceRequest r,WebResourceError e){if(r.isForMainFrame())MAIN.post(()->{if(v==web)finish(60000,"학습 저장소 화면 초기화 실패");});}
            @Override public boolean onRenderProcessGone(WebView v,RenderProcessGoneDetail d){MAIN.post(()->{if(v==web)finish(60000,"학습 저장소 프로세스 재시작 필요");});return true;}
        });
        final WebView owner=web;
        web.addJavascriptInterface(new Object(){@JavascriptInterface public boolean send(String encoded){
            if(encoded==null||encoded.length()>65000)return false;
            MAIN.post(()->{if(web==owner&&active&&PAGE.equals(owner.getUrl())&&enabled(MoaStudyJob785.this)&&constraint(MoaStudyJob785.this).isEmpty())MoaInline755.dispatchBackground785(owner,encoded);});
            return true;
        }},"MoaBackgroundNative785");web.loadUrl(PAGE);
    }
    private void poll(int run){
        if(!active||epoch!=run)return;
        if(!enabled(this)){finish(-1,"자동 생성 OFF");return;}
        String reason=constraint(this);if(!reason.isEmpty()){finish(30000,reason);return;}
        if(SystemClock.elapsedRealtime()-started>(foreground?FG_MAX:JOB_MAX)){finish(30000,"실행 시간 구간 종료 · 저장된 작업 이어서 처리");return;}
        if(web==null){finish(60000,"학습 저장소 연결 없음");return;}
        if(!ticking){
            ticking=true;
            web.evaluateJavascript("(window.MoaInline755&&window.MoaInline755.backgroundTick785)?window.MoaInline755.backgroundTick785():'loading'",value->{
                ticking=false;if(!active||epoch!=run)return;
                try{String a=String.valueOf(new JSONTokener(value).nextValue());
                    if(a.equals("stop")){finish(-1,"자동 생성 OFF");return;}
                    if(a.startsWith("done:")){String[] z=a.split(":",3);finish(Long.parseLong(z[1]),z.length>2?z[2]:"다음 작업 대기");return;}
                    phase=a.equals("loading")?"학습 저장소 준비 중":"등록 학습 작업 실행 중";
                }catch(Exception ignored){}
                if(foreground&&SystemClock.elapsedRealtime()-lastNotice>=5000){lastNotice=SystemClock.elapsedRealtime();web.evaluateJavascript("window.MoaInline755&&window.MoaInline755.backgroundNotice789?window.MoaInline755.backgroundNotice789():'학습 상태 확인 중'",v->{if(!active||!foreground||epoch!=run)return;try{String label=String.valueOf(new JSONTokener(v).nextValue());getSystemService(NotificationManager.class).notify(NOTICE,notice(label.substring(0,Math.min(180,label.length()))));}catch(Exception ignored){}});}
            });
        }
        MAIN.postDelayed(()->poll(run),1500);
    }
    private void cleanup(){
        ++epoch;active=false;params=null;ticking=false;releaseWake();WebView w=web;web=null;
        if(w!=null){MoaInline755.closeBackground785(w);try{w.removeJavascriptInterface("MoaBackgroundNative785");w.stopLoading();w.destroy();}catch(Exception ignored){}}
        if(live==this)live=null;
    }
    private void finish(long next,String reason){
        JobParameters p=params;boolean fg=foreground;if(!active&&!fg)return;
        cleanup();foreground=false;pref(this).edit().putString("lastStop789",reason==null?"":reason).putLong("nextDue789",next<0?0:System.currentTimeMillis()+Math.max(1000,next)).apply();
        if(p!=null)jobFinished(p,false);if(fg){stopForeground(STOP_FOREGROUND_REMOVE);stopSelf();}
        if(next>=0&&enabled(this)){Context c=getApplicationContext();scheduleWatch(c);MAIN.postDelayed(()->schedule(c,next,true),1000);}
    }
    @Override public boolean onStopJob(JobParameters p){if(params!=p)return false;cleanup();pref(this).edit().putString("lastStop789","Android 작업 중단 · 재예약").apply();return enabled(this);}
    @Override public void onTimeout(int startId,int fgsType){finish(1800000,"Android 포그라운드 서비스 시간 제한");stopSelf();}
    @Override public void onDestroy(){cleanup();foreground=false;super.onDestroy();}
}
