package com.juhyeon.familyjourney;

import android.app.Activity;
import android.app.Application;
import android.content.ContentProvider;
import android.content.ContentValues;
import android.content.res.ColorStateList;
import android.database.Cursor;
import android.graphics.Color;
import android.graphics.drawable.GradientDrawable;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.view.Gravity;
import android.view.View;
import android.view.ViewGroup;
import android.webkit.WebView;
import android.widget.FrameLayout;
import android.widget.TextView;
import org.json.JSONObject;
import org.json.JSONTokener;
import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.util.List;

/**
 * R507 experimental native-gallery PHOTO-CARD bridge.
 * Instantiates NO replacement media renderer. Reuses the *existing* R463
 * MoaNativeGallery instance, TextureView/MediaPlayer, rail and 4-action chrome.
 * Only when a trusted in-app diary photo card explicitly opts in, positions
 * the existing native host over that WebView card; outside it the legacy
 * fullscreen native gallery is strictly untouched. Fail-closed on reflection
 * or View hierarchy mismatch. No external permissions or exported provider.
 *
 * This source is compiled into NEW classes18.dex. All R463 original 17 DEX
 * remain byte-for-byte unchanged. This is an experimental integration requiring
 * Galaxy device and Galaxy hardware-back/Naver/video testing.
 */
public final class MoaR507InlineGalleryProvider extends ContentProvider
    implements Application.ActivityLifecycleCallbacks {
  private final Handler main = new Handler(Looper.getMainLooper());
  private Activity foreground;
  private boolean resumed;
  private boolean ownsGallery;
  private boolean processing;
  private long lastHello;
  private long lastPosition;
  private int lastIndex = -1;
  private int lastX = Integer.MIN_VALUE, lastY = Integer.MIN_VALUE;
  private int lastW = -1, lastH = -1;
  private FrameLayout nativeHost;
  private TextView coverStar;
  private Object galleryRef;

  private static final String SNAPSHOT =
      "(function(){try{" +
      "var d=window.MoaR469SimpleDiary,s=d&&d.readOnlyStatus&&d.readOnlyStatus();"+
      "var e=document.querySelector('#moa-r469-root .moa-r469-stage');"+
      "if(!s||!s.active||s.page!=='day'||window.__moaR507NativePending!==true||!e) return JSON.stringify({active:false});"+
      "var r=e.getBoundingClientRect();"+
      "return JSON.stringify({active:true,x:r.left,y:r.top,w:r.width,h:r.height,vw:innerWidth,vh:innerHeight,cover:(window.__moaR507CoverId||'')});"+
      "}catch(e){return JSON.stringify({active:false});}})()";

  @Override public boolean onCreate() {
    try {
      Application app=(Application)getContext().getApplicationContext();
      app.registerActivityLifecycleCallbacks(this);
      main.post(ticker);
      return true;
    } catch (Throwable ex) {return false;}
  }
  private final Runnable ticker=new Runnable(){
    @Override public void run(){
      try {tick();} catch(Throwable ignored) {
        // No change to the working R463 native Gallery on unexpected reflection failure.
        clearCardMark();
      } finally {main.postDelayed(this, ownsGallery?95:resumed?350:850);}
    }
  };
  private static Field field(Class<?> cls,String name){
    for(Class<?> c=cls;c!=null;c=c.getSuperclass())try {
      Field f=c.getDeclaredField(name);f.setAccessible(true);return f;
    } catch(NoSuchFieldException ignored){}catch(Throwable err){return null;}
    return null;
  }
  private static Object readField(Object owner,String name){
    if(owner==null)return null;
    try{Field f=field(owner.getClass(),name);return f==null?null:f.get(owner);}
    catch(Throwable e){return null;}
  }
  private static boolean galleryOpen(Object owner){
    if(owner==null)return false;
    try {return Boolean.TRUE.equals(owner.getClass().getMethod("isOpen").invoke(owner));}
    catch(Throwable e){return false;}
  }
  private WebView findWeb(Activity a){
    Object existing=readField(a,"web");
    if(existing instanceof WebView)return (WebView)existing;
    return findWebRecursive(a.findViewById(android.R.id.content));
  }
  private static WebView findWebRecursive(View v){
    if(v instanceof WebView)return (WebView)v;
    if(v instanceof ViewGroup){ViewGroup g=(ViewGroup)v;
      for(int i=0;i<g.getChildCount();i++){
        WebView w=findWebRecursive(g.getChildAt(i));if(w!=null)return w;
      }
    }
    return null;
  }
  private void tick(){
    Activity a=foreground;
    if(!resumed||a==null||a.isFinishing()||a.isDestroyed())return;
    WebView web=findWeb(a);if(web==null)return;
    Object gallery=readField(a,"unifiedGallery");
    if(!galleryOpen(gallery)){
      if(ownsGallery) {clearCardMark();web.evaluateJavascript("window.__moaR507NativeMounted&&window.__moaR507NativeMounted(false);",null);}
      if(android.os.SystemClock.uptimeMillis()-lastHello>1000){
        lastHello=android.os.SystemClock.uptimeMillis();
        // Signal only on the trusted host WebView; no browser injection and no page mutation.
        web.evaluateJavascript("window.__moaR507BridgeReady=true;",null);
      }
      return;
    }
    if(processing)return;
    processing=true;
    final Activity target=a;
    try{web.evaluateJavascript(SNAPSHOT, raw->{
      processing=false;
      if(!resumed||foreground!=target||!galleryOpen(gallery))return;
      try{
        Object value=new JSONTokener(raw).nextValue();
        if(!(value instanceof String))return;
        JSONObject state=new JSONObject((String)value);
        if(!state.optBoolean("active")){
          // Only a Gallery session *we* had owned is auto-closed; unrelated native
          // fullscreen Gallery sessions and all existing map-return behavior stay intact.
          if(ownsGallery){
            invokeClose(gallery);clearCardMark();
            web.evaluateJavascript("window.__moaR507NativeMounted&&window.__moaR507NativeMounted(false);",null);
          }
          return;
        }
        if(state.optDouble("w")<50||state.optDouble("h")<100)return;
        attachCard(target,web,gallery,state);
      }catch(Throwable e){if(ownsGallery){invokeClose(gallery);clearCardMark();}}
    });}catch(Throwable e){processing=false;}
  }
  private static void invokeClose(Object gallery){
    try{gallery.getClass().getMethod("close").invoke(gallery);}catch(Throwable ignored){}
  }
  private void clearCardMark(){
    if(coverStar!=null && coverStar.getParent() instanceof ViewGroup)
      ((ViewGroup)coverStar.getParent()).removeView(coverStar);
    coverStar=null;nativeHost=null;galleryRef=null;
    ownsGallery=false;lastIndex=-1;lastW=lastH=-1;
    lastX=lastY=Integer.MIN_VALUE;
  }
  private static int rounded(double x){return (int)Math.round(x);}
  private void attachCard(Activity a,WebView web,Object gallery,JSONObject s){
    Object hostObj=readField(gallery,"host");
    Object stageObj=readField(gallery,"stage");
    if(!(hostObj instanceof FrameLayout)||!(stageObj instanceof FrameLayout))return;
    FrameLayout host=(FrameLayout)hostObj,stage=(FrameLayout)stageObj;
    FrameLayout root=a.findViewById(android.R.id.content);
    if(root==null||host.getParent()!=root||stage.getParent()!=host)return;
    double vw=s.optDouble("vw"),vh=s.optDouble("vh");
    if(vw<100||vh<100)return;
    double sx=(double)web.getWidth()/vw,sy=(double)web.getHeight()/vh;
    if(sx<.2||sx>10||sy<.2||sy>10)return;
    int[] webPos=new int[2],rootPos=new int[2];
    web.getLocationInWindow(webPos);root.getLocationInWindow(rootPos);
    int x=rounded(webPos[0]-rootPos[0]+s.optDouble("x")*sx);
    int y=rounded(webPos[1]-rootPos[1]+s.optDouble("y")*sy);
    int w=rounded(s.optDouble("w")*sx),h=rounded(s.optDouble("h")*sy);
    if(w<150||h<180)return;
    if(w>root.getWidth()+3||h>root.getHeight()+3)return;
    if(host!=nativeHost){
      clearCardMark();nativeHost=host;galleryRef=gallery;ownsGallery=true;
      installCoverStar(a,web,host,gallery);
      web.evaluateJavascript("window.__moaR507NativeMounted&&window.__moaR507NativeMounted(true);",null);
    }
    if(x!=lastX||y!=lastY||w!=lastW||h!=lastH){
      FrameLayout.LayoutParams lp=new FrameLayout.LayoutParams(w,h,Gravity.TOP|Gravity.LEFT);
      lp.leftMargin=x;lp.topMargin=y;
      host.setLayoutParams(lp);
      // Preserve original Layout/TextureView/gallery owner and R463 footer intact.
      host.setClipChildren(true);host.setClipToPadding(true);
      lastX=x;lastY=y;lastW=w;lastH=h;
    }
    if(y+h<0||y>root.getHeight())host.setVisibility(View.INVISIBLE);
    else host.setVisibility(View.VISIBLE);
    syncIndex(web,gallery,s.optString("cover",""));
  }
  private void installCoverStar(Activity a,WebView web,FrameLayout host,Object gallery){
    TextView star=new TextView(a);star.setText("☆");star.setTextSize(20);
    star.setTextColor(0xffffd7a4);star.setGravity(Gravity.CENTER);
    star.setContentDescription("현재 사진을 달력 대표사진으로 지정");
    star.setClickable(true);star.setFocusable(true);
    GradientDrawable bg=new GradientDrawable();bg.setColor(0xc923252d);bg.setCornerRadius(dp(a,21));
    bg.setStroke(dp(a,1),0x88ffffff);star.setBackground(bg);
    FrameLayout.LayoutParams lp=new FrameLayout.LayoutParams(dp(a,42),dp(a,42),Gravity.TOP|Gravity.RIGHT);
    lp.topMargin=dp(a,8);lp.rightMargin=dp(a,9);
    host.addView(star,lp);
    star.setOnClickListener(v->{
      String id=currentId(gallery);if(id.length()==0)return;
      String quoted=JSONObject.quote(id);
      web.evaluateJavascript("window.MoaR469SimpleDiary&&window.MoaR469SimpleDiary.setCoverNative&&window.MoaR469SimpleDiary.setCoverNative("+quoted+");",null);
    });
    coverStar=star;
  }
  private static String currentId(Object gallery){
    try {
      Object v=readField(gallery,"ids");Object rawIndex=readField(gallery,"index");
      if(!(v instanceof List)||!(rawIndex instanceof Integer))return "";
      List<?> ids=(List<?>)v;int i=(Integer)rawIndex;
      return i>=0&&i<ids.size()?String.valueOf(ids.get(i)):"";
    }catch(Throwable ignored){return "";}
  }
  private void syncIndex(WebView web,Object gallery,String cover){
    Object idx=readField(gallery,"index");
    if(!(idx instanceof Integer))return;
    int i=(Integer)idx;
    String id=currentId(gallery);
    if(coverStar!=null){coverStar.setText(id.equals(cover)?"★":"☆");}
    if(i!=lastIndex){
      lastIndex=i;
      web.evaluateJavascript("window.__moaR507NativeSelected&&window.__moaR507NativeSelected("+i+");",null);
    }
  }
  private static int dp(Activity a,float n){return (int)(n*a.getResources().getDisplayMetrics().density+.5f);}

  @Override public void onActivityResumed(Activity a){foreground=a;resumed=true;}
  @Override public void onActivityPaused(Activity a){if(foreground==a)resumed=false;}
  @Override public void onActivityDestroyed(Activity a){if(foreground==a){foreground=null;resumed=false;clearCardMark();}}
  @Override public void onActivityCreated(Activity a,Bundle b){}
  @Override public void onActivityStarted(Activity a){}
  @Override public void onActivityStopped(Activity a){}
  @Override public void onActivitySaveInstanceState(Activity a,Bundle b){}
  @Override public Cursor query(Uri u,String[] p,String s,String[] a,String order){return null;}
  @Override public String getType(Uri u){return null;}
  @Override public Uri insert(Uri u,ContentValues v){return null;}
  @Override public int delete(Uri u,String s,String[] a){return 0;}
  @Override public int update(Uri u,ContentValues v,String s,String[] a){return 0;}
}
