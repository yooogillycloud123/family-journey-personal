package com.juhyeon.familyjourney;

import android.app.Activity;
import android.app.Application;
import android.content.ContentProvider;
import android.content.ContentProviderClient;
import android.content.ContentValues;
import android.database.Cursor;
import android.net.Uri;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.os.SystemClock;
import android.view.View;
import android.view.ViewGroup;
import android.webkit.WebView;
import org.json.JSONObject;
import org.json.JSONTokener;
import java.lang.ref.WeakReference;
import java.lang.reflect.Field;
import java.lang.reflect.Method;

/**
 * R653 DIAGNOSTIC ONLY.  No gallery open/close/retry, no writes to the R507
 * provider or its WebView.  Obtains the same-process R507 ContentProvider through
 * ContentProviderClient.getLocalContentProvider() and reads its own app fields.
 * Reads only boolean owner/host states, never media paths or user content.
 */
public final class MoaR653InlineOwnerDiagProvider extends ContentProvider implements Application.ActivityLifecycleCallbacks {
  private final Handler main=new Handler(Looper.getMainLooper());
  private WeakReference<Activity> current=new WeakReference<>(null);
  private ContentProvider baseProvider;
  private long lastBaseProbe=0L,lastEmitAt=0L,lastCheckAt=0L;
  private String lastReport="",lastReason="",pendingActivityEvent="APP_BOOT";
  private boolean busy=false;
  private int samples=0;
  private static final String AUTH="content://com.juhyeon.familyjournea.r507card";

  private static final String WEB_SNAPSHOT="(function(){try{"+
    "var s=window.MoaR469SimpleDiary&&window.MoaR469SimpleDiary.readOnlyStatus&&window.MoaR469SimpleDiary.readOnlyStatus();"+
    "var e=document.querySelector('#moa-r469-root .moa-r469-stage'),r=e&&e.getBoundingClientRect();"+
    "var d=window.__moaR602GalleryDiagnostic&&JSON.parse(window.__moaR602GalleryDiagnostic()||'{}');"+
    "var es=d&&d.events||[],last=es.length?es[es.length-1]:null;"+
    "return JSON.stringify({page:String(s&&s.page||'none'),active:!!(s&&s.active),"+
    "stage:!!(e&&e.isConnected),w:r?Math.round(r.width):0,h:r?Math.round(r.height):0,"+
    "jsArm:window.__moaR511InlineArm===true,javaArm:window.__moaR511NativeArmed===true,"+
    "jsPending:window.__moaR507NativePending===true,bridge:window.__moaR507BridgeReady===true,"+
    "last:d&&d.last||'none',lastAt:last&&last.at||0,opened:!!(d&&d.opened),mounted:!!(d&&d.mounted)});"+
    "}catch(e){return JSON.stringify({error:'JS_SNAPSHOT_FAILED'})}})()";

  @Override public boolean onCreate(){
    try{((Application)getContext().getApplicationContext()).registerActivityLifecycleCallbacks(this);
      main.postDelayed(ticker,900);return true;
    }catch(Throwable e){android.util.Log.w("MOA_R653","DIAG_INIT_FAILED",e);return false;}
  }
  private static Object field(Object o,String n){
    if(o==null)return null;
    for(Class<?> c=o.getClass();c!=null;c=c.getSuperclass())try{
      Field f=c.getDeclaredField(n);f.setAccessible(true);return f.get(o);
    }catch(Throwable ignored){}return null;
  }
  private static boolean bool(Object o,String n){return Boolean.TRUE.equals(field(o,n));}
  private static long num(Object o,String n){Object v=field(o,n);return v instanceof Number?((Number)v).longValue():0L;}
  private static boolean galleryOpen(Object g){
    if(g==null)return false;
    try{Method m=g.getClass().getDeclaredMethod("isOpen");m.setAccessible(true);return Boolean.TRUE.equals(m.invoke(g));}
    catch(Throwable ignored){Object v=field(g,"opened");return Boolean.TRUE.equals(v);}
  }
  private static WebView findWeb(View view){
    if(view instanceof WebView)return(WebView)view;
    if(view instanceof ViewGroup){ViewGroup g=(ViewGroup)view;for(int i=0;i<g.getChildCount();i++){
      WebView w=findWeb(g.getChildAt(i));if(w!=null)return w;
    }}return null;
  }
  private static String safe(String in){
    if(in==null)return"none";
    String s=in.replaceAll("[^A-Za-z0-9_:.=-]","_");return s.substring(0,Math.min(s.length(),70));
  }
  private void findBase(long now){
    if(baseProvider!=null||now-lastBaseProbe<1800L)return;
    lastBaseProbe=now;
    ContentProviderClient cli=null;
    try{cli=getContext().getContentResolver().acquireContentProviderClient(Uri.parse(AUTH));
      if(cli!=null){ContentProvider cp=cli.getLocalContentProvider();
        if(cp!=null && cp.getClass().getName().endsWith("MoaR507InlineGalleryProvider"))baseProvider=cp;}
    }catch(Throwable e){android.util.Log.w("MOA_R653","PROVIDER_ACCESS_FAILED",e);}
    finally{if(cli!=null)try{cli.close();}catch(Throwable ignored){}}
  }
  private JSONObject nativeSnap(Activity a,long now){
    JSONObject j=new JSONObject();
    try{
      ContentProvider cp=baseProvider;
      j.put("p",cp!=null?1:0);
      if(cp==null)return j;
      Object owner=field(cp,"nativeOwnerActivity");
      Object front=field(cp,"foreground");
      Object gr=field(cp,"galleryRef");
      Object currentGallery=field(a,"unifiedGallery");
      Object host=field(cp,"nativeHost");
      Object liveHost=field(currentGallery,"host");
      Object root=a.findViewById(android.R.id.content);
      j.put("fg",front==a?1:0).put("ow",owner==a?1:0).put("fgOw",front==owner?1:0);
      j.put("resume",bool(cp,"resumed")?1:0).put("focus",a.hasWindowFocus()?1:0);
      j.put("owns",bool(cp,"ownsGallery")?1:0).put("processing",bool(cp,"processing")?1:0);
      j.put("armed",bool(cp,"inlineArmed")?1:0).put("full",bool(cp,"fullNativeOpen")?1:0);
      j.put("back",bool(cp,"returnFromBackground")?1:0).put("exit",bool(cp,"exitInFlight")?1:0);
      j.put("suppMs",Math.max(0,num(cp,"suppressArmUntil")-now));
      j.put("deadlineMs",Math.max(0,num(cp,"armDeadline")-now));
      j.put("grOpen",galleryOpen(currentGallery)?1:0);
      j.put("grSame",gr==currentGallery&&gr!=null?1:0);
      j.put("host",host!=null?1:0).put("hostSame",host!=null&&host==liveHost?1:0);
      j.put("hostRoot",host instanceof View&&((View)host).getParent()==root?1:0);
      j.put("armRoot",field(cp,"armRoot")!=null?1:0);
      j.put("epoch",num(cp,"foregroundEpoch"));
      j.put("closeMs",Math.max(0,now-num(cp,"nativeCloseDetectedAt")));
      j.put("rootPresent",root!=null?1:0);
    }catch(Throwable e){try{j.put("inspectError",safe(e.getClass().getSimpleName()));}catch(Exception ignored){}}
    return j;
  }
  private String classify(JSONObject n,JSONObject w){
    if(n.optInt("p")==0)return"R507_PROVIDER_NOT_LOCAL";
    if(n.optInt("resume")==0)return"R507_NOT_RESUMED";
    if(n.optInt("fg")==0)return"R507_FOREGROUND_OTHER_ACTIVITY";
    if(n.optInt("owns")==1 && n.optInt("grOpen")==0)return"R507_OWNS_CLOSED_GALLERY";
    if(n.optInt("full")==1)return"R507_FULLSCREEN_OWNER_ACTIVE";
    if(n.optInt("processing")==1)return"R507_ASYNC_PROCESSING";
    if(n.optInt("armed")==1)return"R507_ALREADY_ARMED";
    if(n.optLong("suppMs")>0)return"R507_ARM_SUPPRESSED";
    if(!w.optBoolean("jsArm"))return"WEB_JS_ARM_FALSE";
    if(!w.optBoolean("active")||!"day".equals(w.optString("page")))return"WEB_PAGE_NOT_ACTIVE_DAY";
    if(!w.optBoolean("stage")||w.optInt("w")<150||w.optInt("h")<180)return"WEB_STAGE_INVALID_GEOMETRY";
    if(n.optInt("grOpen")==1&&n.optInt("owns")==1)return"R507_GALLERY_LIVE_NOT_REARMING";
    return"ARM_GATE_UNKNOWN_NEEDS_DIRECT_CALLBACK_TRACE";
  }
  private void emit(WebView web,String type,String reason,String code){
    try{
      String js="(function(){try{var t=window.MoaFullRunTraceR648;"+
        "if(t&&t.emit)t.emit("+JSONObject.quote(type)+",{reason:"+
        JSONObject.quote(reason)+",code:"+JSONObject.quote(code)+",source:'java-r653-observer'},true);"+
        "}catch(e){}})()";
      web.evaluateJavascript(js,null);
    }catch(Throwable err){android.util.Log.w("MOA_R653","TRACE_EXPORT_FAILED",err);}
  }
  private final Runnable ticker=new Runnable(){@Override public void run(){
    try{tick();}catch(Throwable e){android.util.Log.w("MOA_R653","TICK_EXCEPTION",e);}
    finally{main.postDelayed(this,640L);}
  }};
  private void tick(){
    Activity a=current.get();if(a==null||a.isFinishing()||a.isDestroyed())return;
    WebView web=findWeb(a.getWindow().getDecorView());
    if(web==null||web.getUrl()==null||!web.getUrl().startsWith("https://familyjourney.local/"))return;
    long now=SystemClock.uptimeMillis();findBase(now);
    if(busy)return;
    busy=true;
    final JSONObject n=nativeSnap(a,now);
    final String activityEvent=pendingActivityEvent;
    pendingActivityEvent="";
    try{web.evaluateJavascript(WEB_SNAPSHOT,raw->{
      busy=false;
      try{
        Object v=new JSONTokener(raw).nextValue();if(!(v instanceof String))return;
        JSONObject w=new JSONObject((String)v);
        boolean waiting=(w.optBoolean("jsArm")||w.optBoolean("jsPending"))&&!w.optBoolean("javaArm");
        long at=w.optLong("lastAt",0);long age=at>0?System.currentTimeMillis()-at:-1;
        String reason=classify(n,w);
        String state="p"+n.optInt("p")+"-fg"+n.optInt("fg")+"-ow"+n.optInt("ow")+
          "-re"+n.optInt("resume")+"-fo"+n.optInt("focus")+"-own"+n.optInt("owns")+
          "-proc"+n.optInt("processing")+"-arm"+n.optInt("armed")+"-sup"+n.optLong("suppMs")+
          "-gr"+n.optInt("grOpen")+"-host"+n.optInt("hostRoot")+
          "-wp"+safe(w.optString("page"))+"-act"+(w.optBoolean("active")?1:0)+
          "-s"+(w.optBoolean("stage")?1:0)+"-w"+w.optInt("w")+"-h"+w.optInt("h")+
          "-ja"+(w.optBoolean("jsArm")?1:0)+"-na"+(w.optBoolean("javaArm")?1:0);
        // A diagnostic arm deficit needs a high-signal one-line reason, not thousands of keepalives.
        boolean missing=waiting&&w.optBoolean("stage")&&age>=1200&&age<10000;
        String key=reason+"|"+state;
        long time=SystemClock.uptimeMillis();
        if(missing && (key.equals(lastReport)?time-lastCheckAt>=2500:true)){
          lastCheckAt=time;
          emit(web,"R653_JAVA_ARM_DENIAL_SNAPSHOT",reason,
            "age"+age+"_"+state);
        }else if(!key.equals(lastReport) && time-lastEmitAt>250){
          emit(web,"R653_JAVA_OWNER_TRANSITION",reason,state);
          lastEmitAt=time;
        }else if(time-lastEmitAt>12000){emit(web,"R653_JAVA_OWNER_HEARTBEAT",reason,state);lastEmitAt=time;}
        lastReport=key;lastReason=reason;
        if(!activityEvent.isEmpty())emit(web,"R653_NATIVE_ACTIVITY_STATE",activityEvent,reason);
      }catch(Throwable e){emit(web,"R653_JAVA_CALLBACK_ERROR",safe(e.getClass().getSimpleName()),"callback");}
    });}catch(Throwable e){busy=false;}
  }
  @Override public void onActivityCreated(Activity a,Bundle b){}
  @Override public void onActivityStarted(Activity a){}
  @Override public void onActivityResumed(Activity a){
    if(!(a.getClass().getName().contains("MoaR653"))){current=new WeakReference<>(a);pendingActivityEvent="RESUMED";}
  }
  @Override public void onActivityPaused(Activity a){if(current.get()==a)pendingActivityEvent="PAUSED";}
  @Override public void onActivityStopped(Activity a){if(current.get()==a)pendingActivityEvent="STOPPED";}
  @Override public void onActivitySaveInstanceState(Activity a,Bundle state){}
  @Override public void onActivityDestroyed(Activity a){if(current.get()==a){current.clear();pendingActivityEvent="DESTROYED";}}
  @Override public Cursor query(Uri uri,String[] proj,String sel,String[] args,String sort){return null;}
  @Override public String getType(Uri uri){return null;}
  @Override public Uri insert(Uri uri,ContentValues values){return null;}
  @Override public int delete(Uri uri,String where,String[] args){return 0;}
  @Override public int update(Uri uri,ContentValues values,String where,String[] args){return 0;}
}