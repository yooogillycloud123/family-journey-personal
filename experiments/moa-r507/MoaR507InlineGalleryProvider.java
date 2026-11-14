package com.juhyeon.familyjourney;

import android.app.Activity;
import android.app.AlertDialog;
import android.app.Application;
import android.content.ContentProvider;
import android.content.ContentValues;
import android.content.res.ColorStateList;
import android.database.Cursor;
import android.graphics.Color;
import android.graphics.Matrix;
import android.media.MediaPlayer;
import android.graphics.RectF;
import android.widget.ImageView;
import android.widget.EditText;
import android.widget.Toast;
import android.view.TextureView;
import android.graphics.drawable.GradientDrawable;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.view.Gravity;
import android.view.View;
import android.view.ViewGroup;
import android.view.WindowInsets;
import android.view.ViewTreeObserver;
import android.view.animation.LinearInterpolator;
import android.widget.LinearLayout;
import android.window.OnBackInvokedCallback;
import android.window.OnBackInvokedDispatcher;
import android.webkit.WebView;
import android.webkit.WebMessage;
import android.webkit.WebMessagePort;
import android.widget.FrameLayout;
import android.widget.TextView;
import org.json.JSONObject;
import org.json.JSONTokener;
import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.util.List;
import java.util.LinkedHashMap;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;

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
  // R547: the native R463 host belongs to its ORIGINAL Activity. An external NAVER
  // Activity must never be mistaken for the Gallery owner by the global ticker.
  private Activity nativeOwnerActivity;
  private Activity fullscreenOwnerActivity;
  private long returnCloseGuardUntil=0L;
  private boolean resumed;
  private boolean ownsGallery;
  private boolean processing;
  private long lastHello;
  private long lastPosition;
  // R519 avoids reapplying image/video transforms every native layout tick.
  private long lastFillAt;
  private String lastFillId="";
  private int lastIndex = -1;
  private int lastX = Integer.MIN_VALUE, lastY = Integer.MIN_VALUE;
  private int lastW = -1, lastH = -1;
  private FrameLayout nativeHost;
  private UnifiedGlyph coverStar;
  private UnifiedGlyph railToggle;
  private UnifiedGlyph advancedButton;
  // R570 additive photo-only commands; existing R463 Gallery DEX and listeners remain untouched.
  private UnifiedGlyph favoriteButton;
  private final LinkedHashMap<String,View> r570Actions=new LinkedHashMap<>();
  private AlertDialog r570SaveDialog,r570OrderDialog;
  private static final String[] R570_ROLES={"cover","share","naver","info","fast","favorite","rail","expand"};
  private boolean initialCardChromeHidden=false;
  private boolean fullNativeOpen=false,fullNativeSeenOpen=false;
  private long fullNativeStartedAt=0L;
  private ImageView ambientPoster;
  private ViewGroup ambientParent;
  private String ambientMediaId="";
  private View railView;
  private boolean railExpanded=true;
  private boolean railToggleInstalled;
  private long lastValidSnapshot;
  private int snapshotFailures;
  private Object galleryRef;
  // R511: pre-draw armed rehost prevents a fullscreen black/white first frame.
  private FrameLayout armRoot;
  private ViewTreeObserver.OnPreDrawListener armGuard;
  private JSONObject armedState;
  private boolean inlineArmed;
  private long armDeadline, inactiveAt;
  // Translation-only position changes avoid relayout of R463 TextureView on every scroll tick.
  private int baseX,baseY;
  private boolean compactDone;
  private LinearLayout nativeLower,actionCapsule;
  private FrameLayout actionDeck;
  // R523: one Back gesture must never trigger an automatic native reopen.
  private OnBackInvokedCallback inlineBack;
  private boolean exitInFlight;
  private long lastNativeBackAt;
  private long nativeCloseDetectedAt;
  private String lastVideoGeometryId="";
  private int fillPrepareAttempts;
  private long lastGeometrySnapshotAt;
  private int lastGeometrySnapshotY;
  private Activity backOwner;
  // R527: origin-scoped HTML5 WebMessageChannel, one-way geometry PUSH from
  // the actual DOM scroll animation; avoid evaluateJavascript round trip per
  // Native View frame. Only numeric coordinates, no user data/URI.
  private WebView positionWeb;
  private WebMessagePort positionPort;
  private long lastPositionMessageAt, lastPortInitAttempt;
  private int ownedDayToken;
  private boolean positionPortSettingUp;
  private long suppressArmUntil;
  // R535: one guarded same-day native surface rebuild after leaving and returning
  // to the Activity. Android may discard the Gallery TextureView compositor.
  private boolean returnFromBackground=false;
  private long backgroundStartedAt=0L;
  private int foregroundEpoch=0;
  private boolean hadMountedOnPause=false;
  private long lastRebindAt=0L;
  private long lastMediaRefreshAt=0L;
  // R555: native original R227 onPause closes Gallery when its retention flag
  // is absent. A regular onActivityPaused callback runs TOO LATE to prevent it.
  private Object prePausedRetainedGallery;
  private Activity prePausedOwnerActivity;
  private long prePauseRetainAt=0L;
  // R567: the host may be physically detached by ORIGINAL Gallery.close() while
  // a saved returnFromBackground gate still says true. A user Back after resume
  // must not be lost behind a polling/guard window.
  private boolean lifecyclePauseInProgress=false;
  private FrameLayout monitoredHost;
  private View.OnAttachStateChangeListener monitoredHostListener;
  private long lastResumeAt=0L;
  private boolean controlledRebuildInProgress=false;
  private String ownerDayAtPause="";
  private int fullNativeLastIndex=-1;
  private String fullNativeLastId="";


  private static final String SNAPSHOT =
      "(function(){try{" +
      "var d=window.MoaR469SimpleDiary,s=d&&d.readOnlyStatus&&d.readOnlyStatus();"+
      "var e=document.querySelector('#moa-r469-root .moa-r469-stage');"+
      "if(!s||!s.active||s.page!=='day'||!(window.__moaR507NativePending===true||window.__moaR511InlineArm===true)||!e) return JSON.stringify({active:false});"+
      "var r=e.getBoundingClientRect();"+
      "return JSON.stringify({active:true,x:r.left,y:r.top,w:r.width,h:r.height,vw:innerWidth,vh:innerHeight,cover:(window.__moaR507CoverId||''),token:(window.__moaR527DayToken||0)});"+
      "}catch(e){return JSON.stringify({active:false});}})()";

  private static final String ARM_SNAPSHOT =
      "(function(){try{"+
      "var d=window.MoaR469SimpleDiary,s=d&&d.readOnlyStatus&&d.readOnlyStatus();"+
      "var e=document.querySelector('#moa-r469-root .moa-r469-stage');"+
      "if(!window.__moaR511InlineArm||!s||!s.active||s.page!=='day'||!e)return JSON.stringify({active:false});"+
      "var r=e.getBoundingClientRect();"+
      "return JSON.stringify({active:true,x:r.left,y:r.top,w:r.width,h:r.height,vw:innerWidth,vh:innerHeight,cover:(window.__moaR507CoverId||''),token:(window.__moaR527DayToken||0)});"+
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
        // R551: transient View/WebView reflection failures are not permission
        // to discard a playing and already mounted original R463 Gallery.
        // Next tick rechecks; the verified native owner stays intact.
      } finally {main.postDelayed(this, ownsGallery?155:resumed?160:850);}
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
  private static boolean isTrustedWeb(WebView web){
    if(web==null)return false;
    String url=web.getUrl();
    return url!=null && (url.startsWith("https://familyjourney.local/web/")||
      url.startsWith("https://familyjourney.local/"));
  }
  private void closePositionPort(){
    try{if(positionPort!=null)positionPort.close();}catch(Throwable ignored){}
    positionPort=null;positionWeb=null;positionPortSettingUp=false;lastPositionMessageAt=0;
  }
  private void ensurePositionChannel(WebView web){
    if(Build.VERSION.SDK_INT<23||!isTrustedWeb(web))return;
    if(positionWeb!=null&&positionWeb!=web)closePositionPort();
    if(positionPort!=null||positionPortSettingUp)return;
    long now=android.os.SystemClock.uptimeMillis();
    if(now-lastPortInitAttempt<1200L)return;
    lastPortInitAttempt=now;positionPortSettingUp=true;
    try{web.evaluateJavascript("window.__moaR527BridgeListenReady===true",result->{
      positionPortSettingUp=false;
      if(foreground==null||web!=findWeb(foreground)||!isTrustedWeb(web)||!"true".equals(result))return;
      try{
        WebMessagePort[] pair=web.createWebMessageChannel();
        if(pair==null||pair.length!=2)return;
        WebMessagePort receive=pair[0];
        receive.setWebMessageCallback(new WebMessagePort.WebMessageCallback(){
          @Override public void onMessage(WebMessagePort p,WebMessage m){
            // Callback is already on the Android UI thread.
            if(positionPort!=p||positionWeb!=web||!isTrustedWeb(web)||
                !ownsGallery||nativeHost==null||!galleryOpen(galleryRef))return;
            onPositionMessage(web,m.getData());
          }
        });
        positionPort=receive;positionWeb=web;
        web.postWebMessage(new WebMessage("MOA_R527_POSITION_CHANNEL",
          new WebMessagePort[]{pair[1]}),Uri.parse("https://familyjourney.local"));
      }catch(Throwable ignored){closePositionPort();}
    });}catch(Throwable ignored){positionPortSettingUp=false;}
  }
  private void onPositionMessage(WebView web,String data){
    if(data==null||data.length()>180)return;
    try{
      String[] x=data.split(",",-1);if(x.length!=7)return;
      int token=(int)Double.parseDouble(x[0]);
      if(token!=ownedDayToken||token<=0)return;
      double dx=Double.parseDouble(x[1]),dy=Double.parseDouble(x[2]);
      double dw=Double.parseDouble(x[3]),dh=Double.parseDouble(x[4]);
      double vw=Double.parseDouble(x[5]),vh=Double.parseDouble(x[6]);
      if(!Double.isFinite(dx)||!Double.isFinite(dy)||!Double.isFinite(dw)||
          !Double.isFinite(dh)||!Double.isFinite(vw)||!Double.isFinite(vh)||
          vw<100||vh<100||dw<100||dh<100||Math.abs(dy)>20000)return;
      FrameLayout root=foreground.findViewById(android.R.id.content);
      if(root==null||nativeHost.getParent()!=root)return;
      int[] wpos=new int[2],rpos=new int[2];
      web.getLocationInWindow(wpos);root.getLocationInWindow(rpos);
      double sx=(double)web.getWidth()/vw,sy=(double)web.getHeight()/vh;
      if(sx<.2||sx>10||sy<.2||sy>10)return;
      // R559: EXACT R535 success-lineage pixel snap; R555 fractional translations
      // regressed real 120Hz scroll by oscillating across compositor sampling.
      int ix=rounded(wpos[0]-rpos[0]+dx*sx),iy=rounded(wpos[1]-rpos[1]+dy*sy);
      int iw=rounded(dw*sx),ih=rounded(dh*sy);
      // Do not trigger MediaPlayer/TextureView re-layout in a position frame.
      if(lastW<0||Math.abs(iw-lastW)>dp(foreground,8)||
          Math.abs(ih-lastH)>dp(foreground,8))return;
      // R535 original single geometry owner: exact integer target, no overshoot.
      nativeHost.setTranslationX(ix-baseX);
      nativeHost.setTranslationY(iy-baseY);
      nativeHost.setVisibility(iy+ih<0||iy>root.getHeight()?View.INVISIBLE:View.VISIBLE);
      lastPositionMessageAt=android.os.SystemClock.uptimeMillis();
      lastX=ix;lastY=iy;
    }catch(Throwable ignored){}
  }
  private void tick(){
    Activity a=foreground;
    if(!resumed||a==null||a.isFinishing()||a.isDestroyed())return;
    // R547: ActivityLifecycleCallbacks observe ALL activities, not just MOA's
    // Activity. Reading `unifiedGallery` on NAVER/Share produces null, which
    // R543 mistakenly classified as a genuine Gallery Back/close. Never do it.
    if(ownsGallery && nativeOwnerActivity!=null && a!=nativeOwnerActivity)return;
    if(fullNativeOpen && fullscreenOwnerActivity!=null && a!=fullscreenOwnerActivity)return;
    WebView web=findWeb(a);if(web==null)return;
    Object gallery=readField(a,"unifiedGallery");
    // R531: intentionally opened ORIGINAL fullscreen Gallery is NOT an in-card
    // renderer. Return to the same photo-day only after native Gallery closes.
    if(fullNativeOpen){
      final long now=android.os.SystemClock.uptimeMillis();
      if(galleryOpen(gallery)){
        fullNativeSeenOpen=true;
        Object index=readField(gallery,"index");
        if(index instanceof Integer)fullNativeLastIndex=(Integer)index;
        String id=currentId(gallery);if(!id.isEmpty())fullNativeLastId=id;
      }else if(fullNativeSeenOpen||now-fullNativeStartedAt>2900L){
        final int index=fullNativeLastIndex;
        final String id=JSONObject.quote(fullNativeLastId);
        fullNativeOpen=false;fullNativeSeenOpen=false;fullscreenOwnerActivity=null;
        fullNativeLastIndex=-1;fullNativeLastId="";
        // Do not let native Gallery.close() reset the selection to the old image.
        web.evaluateJavascript("window.__moaR539AdvancedSelection&&window.__moaR539AdvancedSelection("+
            index+","+id+");window.__moaR531AdvancedClosed&&window.__moaR531AdvancedClosed();",null);
      }
      return;
    }
    if(!galleryOpen(gallery)){
      // R563 restores the R535 physically successful rule: in the SAME
      // foreground MOA photo-day, original R463 Gallery.close() means a Back.
      // A real background/resume is handled independently; do not exit day
      // when Activity was paused or is within the SurfaceTexture return guard.
      final long now=android.os.SystemClock.uptimeMillis();
      if(ownsGallery && !fullNativeOpen &&
          (returnFromBackground || now<returnCloseGuardUntil ||
           nativeOwnerActivity!=a || !a.hasWindowFocus()))return;
      ensurePositionChannel(web);
      if(!ownsGallery)retireDayBackIfInactive(a,web);
      if(ownsGallery){
        if(nativeCloseDetectedAt==0L){nativeCloseDetectedAt=now;return;}
        if(now-nativeCloseDetectedAt<180L)return;
        final Activity owner=a;
        final Object oldGallery=galleryRef;
        final String nativeDay=String.valueOf(readField(gallery,"currentDay"));
        // Never call R551 NativeLost() here: it reopened a deliberately closed
        // Gallery and left gray/legacy states after the user's first Back.
        if(resumed && foreground==owner && owner.hasWindowFocus() &&
            galleryRef==oldGallery && !galleryOpen(gallery)){
          exitForegroundClosedGallery(owner,web,oldGallery,
              "null".equals(nativeDay)?"":nativeDay);
        }
        return;
      }
      if(now-lastHello>1000){
        lastHello=now;
        web.evaluateJavascript("window.__moaR507BridgeReady=true;",null);
      }
      maybeArm(a,web);
      return;
    }
    nativeCloseDetectedAt=0L;
    ensurePositionChannel(web);
    // R551: when the original Gallery exists but wasn't yet projected over the
    // newly recreated photo-day card, arm even though isOpen()==true. Previous
    // versions only called maybeArm in the !isOpen branch and could deadlock.
    if(!ownsGallery && !inlineArmed && !processing)maybeArm(a,web);
    // R535: WebMessagePort's fast path bypasses attachCard. Even when geometry
    // keeps streaming, the old video ambient MUST be hidden immediately when
    // a different PHOTO is selected; do not leave a blurred video layer on top.
    if(ownsGallery && gallery==galleryRef){
      final String selected=currentId(gallery);
      if(!selected.equals(lastFillId)){
        lastFillId=selected;fillPrepareAttempts=0;lastFillAt=0L;
        updateAmbientForSelection(a,gallery,selected);
      }
    }
    // The DOM compositor pushes exact card positions during scrolling. Do NOT
    // fight its order with another delayed evaluateJavascript snapshot/Matrix.
    if(positionWeb==web && positionPort!=null && ownsGallery &&
        android.os.SystemClock.uptimeMillis()-lastPositionMessageAt<550L)return;
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
          // Scroll/DOM transitions briefly detach the Web stage. Do not close
          // the working native renderer for a single missed JS evaluation.
          long now=android.os.SystemClock.uptimeMillis();
          if(inactiveAt==0)inactiveAt=now;
          // R515: an inactive snapshot can be a WebView traversal, interim
          // layout detach, or NAVER transition, not permission to drop the
          // native Gallery after only one second. Only an explicit day/page
          // exit (JS closeNativeGallery) closes the active native host.
          // Preserve the last rendered frame during transient WebView updates.
          if(ownsGallery && now-inactiveAt>10000L){
            web.evaluateJavascript("(function(){var d=window.MoaR469SimpleDiary,s=d&&d.readOnlyStatus&&d.readOnlyStatus();return JSON.stringify({day:!!(s&&s.active&&s.page==='day'),pending:!!window.__moaR507NativePending});})()",verify->{
              try{Object x=new JSONTokener(verify).nextValue();if(!(x instanceof String))return;JSONObject st=new JSONObject((String)x);
                if(!st.optBoolean("day")&&!galleryOpen(gallery))clearCardMark();
              }catch(Throwable ignored){}
            });
            inactiveAt=now-8000L;
          }
          return;
        }
        inactiveAt=0;lastValidSnapshot=android.os.SystemClock.uptimeMillis();snapshotFailures=0;
        if(state.optDouble("w")<50||state.optDouble("h")<100)return;
        attachCard(target,web,gallery,state);
      }catch(Throwable e){
        // A malformed async WebView result must not close active video playback.
        snapshotFailures++;
        if(snapshotFailures>15 && ownsGallery){
          // Invalid JS snapshots are a transient WebView condition, not a reason
          // to restart a playing native video or to resurrect the old UI.
          snapshotFailures=0;
        }
      }
    });}catch(Throwable e){processing=false;}
  }
  private void maybeArm(Activity a,WebView web){
    if(ownsGallery||inlineArmed||processing||
        android.os.SystemClock.uptimeMillis()<suppressArmUntil)return;
    processing=true;
    web.evaluateJavascript(ARM_SNAPSHOT,raw->{
      processing=false;
      if(!resumed||a!=foreground||inlineArmed)return;
      try{
        Object v=new JSONTokener(raw).nextValue();
        if(!(v instanceof String))return;
        JSONObject state=new JSONObject((String)v);
        if(!state.optBoolean("active")||state.optDouble("w")<150||state.optDouble("h")<180)return;
        FrameLayout root=a.findViewById(android.R.id.content);
        if(root==null)return;
        armRoot=root;armedState=state;ownedDayToken=state.optInt("token",0);inlineArmed=true;
        armDeadline=android.os.SystemClock.uptimeMillis()+5000;
        // R559: install the photo-day Back owner while arming, NOT only after
        // video/photo host becomes visible. A lost host must not swallow Back.
        installInlineBack(a,web);
        installPreDrawGuard(a,web,root);
        web.evaluateJavascript("window.__moaR511NativeArmed=true;",null);
      }catch(Throwable ignored){}
    });
  }
  private void disarm(){
    if(armRoot!=null&&armGuard!=null)try{
      ViewTreeObserver obs=armRoot.getViewTreeObserver();
      if(obs.isAlive())obs.removeOnPreDrawListener(armGuard);
    }catch(Throwable ignored){}
    armRoot=null;armGuard=null;armedState=null;inlineArmed=false;
  }
  private void installPreDrawGuard(Activity a,WebView web,FrameLayout root){
    final ViewTreeObserver.OnPreDrawListener watcher=new ViewTreeObserver.OnPreDrawListener(){
      @Override public boolean onPreDraw(){
        if(!inlineArmed||armRoot!=root)return true;
        if(!resumed||foreground!=a||android.os.SystemClock.uptimeMillis()>armDeadline){disarm();return true;}
        Object gallery=readField(a,"unifiedGallery");
        Object hostObject=readField(gallery,"host");
        if(!(hostObject instanceof FrameLayout))return true;
        FrameLayout host=(FrameLayout)hostObject;
        if(host.getParent()!=root||armedState==null)return true;
        // R551: attach BEFORE drawing; never leave an unmounted R463 host
        // alpha=0. Earlier code hid it first and could disarm even if attach
        // rejected a stale geometry snapshot, making it gray indefinitely.
        if(!galleryOpen(gallery))return true;
        try{attachCard(a,web,gallery,armedState);}catch(Throwable ignored){}
        if(nativeHost==host&&ownsGallery){
          host.setAlpha(1f);
          disarm();
        }else{
          host.setAlpha(1f);
          // Keep the guard armed for a later valid layout; the tick's direct
          // SNAPSHOT path can independently attach once geometry has settled.
        }
        return true;
      }
    };
    armGuard=watcher;
    root.getViewTreeObserver().addOnPreDrawListener(watcher);
  }
  private static void invokeClose(Object gallery){
    try{gallery.getClass().getMethod("close").invoke(gallery);}catch(Throwable ignored){}
  }
  // R567: original Gallery.close() sets open=false BEFORE removing its host.
  // Listen to that actual detach, not a 155ms polling tick. This also handles
  // the original R463 system-Back callback winning over our day Back callback.
  // The callback NEVER treats Activity.onPause as a user Back.
  private void stopMonitoringNativeHost(){
    if(monitoredHost!=null&&monitoredHostListener!=null)try{
      monitoredHost.removeOnAttachStateChangeListener(monitoredHostListener);
    }catch(Throwable ignored){}
    monitoredHost=null;monitoredHostListener=null;
  }
  private void monitorNativeHost(Activity a,WebView web,Object gallery,FrameLayout host){
    if(monitoredHost==host&&monitoredHostListener!=null)return;
    stopMonitoringNativeHost();
    monitoredHost=host;
    final String day=String.valueOf(readField(gallery,"currentDay"));
    monitoredHostListener=new View.OnAttachStateChangeListener(){
      @Override public void onViewAttachedToWindow(View v){}
      @Override public void onViewDetachedFromWindow(View v){
        if(monitoredHost!=v||galleryOpen(gallery)||lifecyclePauseInProgress||controlledRebuildInProgress)return;
        main.post(()->{
          if(!resumed||foreground!=a||!a.hasWindowFocus()||
             lifecyclePauseInProgress||controlledRebuildInProgress||fullNativeOpen||galleryOpen(gallery)||
             galleryRef!=gallery||nativeOwnerActivity!=a)return;
          android.util.Log.i("MOA_R567","ORIGINAL_GALLERY_HOST_DETACHED_FOREGROUND_BACK");
          exitForegroundClosedGallery(a,web,gallery,"null".equals(day)?"":day);
        });
      }
    };
    host.addOnAttachStateChangeListener(monitoredHostListener);
  }
  private void exitForegroundClosedGallery(Activity a,WebView web,Object gallery,String day){
    if(!resumed||a!=foreground||!a.hasWindowFocus()||
       lifecyclePauseInProgress||controlledRebuildInProgress||fullNativeOpen||galleryOpen(gallery)||
       galleryRef!=gallery||nativeOwnerActivity!=a)return;
    // A foreground close means one user Back -> calendar. Do NOT auto-reopen.
    web.evaluateJavascript("window.__moaR563ForegroundNativeClosed&&"+
      "window.__moaR563ForegroundNativeClosed("+JSONObject.quote(day)+");",answer->{
      if(galleryRef!=gallery||nativeOwnerActivity!=a)return;
      final boolean exit="\"exit\"".equals(String.valueOf(answer))||
          "\"not-open\"".equals(String.valueOf(answer));
      // Even an intentional JS-triggered close releases the OLD host, but
      // must never exit the photo day or kill its replacement Gallery.
      closePositionPort();clearCardMark();
      if(exit){returnFromBackground=false;hadMountedOnPause=false;
        returnCloseGuardUntil=0L;dropDayBack();}
      else android.util.Log.i("MOA_R567","NATIVE_CLOSE_INTENTIONAL_OR_NEW_DATE");
      suppressArmUntil=android.os.SystemClock.uptimeMillis()+190L;
    });
  }
  private void clearCardMark(){
    stopMonitoringNativeHost();
    disarm();
    if(advancedButton!=null && advancedButton.getParent() instanceof ViewGroup)
      ((ViewGroup)advancedButton.getParent()).removeView(advancedButton);
    if(ambientPoster!=null&&ambientPoster.getParent() instanceof ViewGroup){
      ambientPoster.setVisibility(View.GONE);
      ((ViewGroup)ambientPoster.getParent()).removeView(ambientPoster);
    }
    if(galleryRef!=null){Object tx=readField(galleryRef,"texture");if(tx instanceof TextureView)try{((TextureView)tx).setOpaque(true);}catch(Throwable ignored){}}
    if(railToggle!=null && railToggle.getParent() instanceof ViewGroup)
      ((ViewGroup)railToggle.getParent()).removeView(railToggle);
    if(coverStar!=null && coverStar.getParent() instanceof ViewGroup)
      ((ViewGroup)coverStar.getParent()).removeView(coverStar);
    // R559: native host disposal is NOT photo-day disposal. The original Gallery
    // can briefly lose its SurfaceTexture while the same photo-day is still up.
    // Keep our single-Back handler until an explicit day exit/fullscreen handoff
    // or until the trusted JS page is verified to have switched away.

    if(nativeHost!=null)try{nativeHost.animate().cancel();nativeHost.setTranslationX(0);nativeHost.setTranslationY(0);nativeHost.setAlpha(1f);}catch(Throwable ignored){}
    if(r570SaveDialog!=null&&r570SaveDialog.isShowing())r570SaveDialog.dismiss();
    if(r570OrderDialog!=null&&r570OrderDialog.isShowing())r570OrderDialog.dismiss();
    r570SaveDialog=null;r570OrderDialog=null;
    nativeOwnerActivity=null;
    coverStar=null;railToggle=null;advancedButton=null;favoriteButton=null;r570Actions.clear();railView=null;railToggleInstalled=false;nativeHost=null;galleryRef=null;nativeLower=null;actionCapsule=null;actionDeck=null;ambientPoster=null;ambientParent=null;ambientMediaId="";initialCardChromeHidden=false;
    compactDone=false;ownsGallery=false;lastIndex=-1;lastW=lastH=-1;inactiveAt=0;lastFillAt=0;lastFillId="";
    exitInFlight=false;ownedDayToken=0;nativeCloseDetectedAt=0L;lastGeometrySnapshotAt=0;lastVideoGeometryId="";fillPrepareAttempts=0;
    lastX=lastY=Integer.MIN_VALUE;
  }
  private void dropDayBack(){
    if(inlineBack!=null&&backOwner!=null&&Build.VERSION.SDK_INT>=33)try{
      backOwner.getOnBackInvokedDispatcher().unregisterOnBackInvokedCallback(inlineBack);
    }catch(Throwable ignored){}
    inlineBack=null;backOwner=null;exitInFlight=false;
  }
  private void retireDayBackIfInactive(Activity a,WebView web){
    if(inlineBack==null||backOwner!=a||web==null)return;
    try{web.evaluateJavascript("(function(){var d=window.MoaR469SimpleDiary,s=d&&d.readOnlyStatus&&d.readOnlyStatus();"+
      "return !!(s&&s.active&&s.page==='day'&&!window.__moaR539AdvancedActive?.());})()",v->{
      if(backOwner==a&&inlineBack!=null&&!"true".equals(v))dropDayBack();
    });}catch(Throwable ignored){}
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
    // R559: R535 fallback geometry matches WebMessagePort integer snap.
    int x=rounded(webPos[0]-rootPos[0]+s.optDouble("x")*sx);
    int y=rounded(webPos[1]-rootPos[1]+s.optDouble("y")*sy);
    int w=rounded(s.optDouble("w")*sx),h=rounded(s.optDouble("h")*sy);
    if(w<150||h<180)return;
    if(w>root.getWidth()+3||h>root.getHeight()+3)return;
    if(host!=nativeHost){
      final int newToken=s.optInt("token",ownedDayToken);
      clearCardMark();nativeHost=host;galleryRef=gallery;nativeOwnerActivity=a;ownsGallery=true;ownedDayToken=newToken;lastPositionMessageAt=0;
      GradientDrawable round=new GradientDrawable();round.setColor(Color.BLACK);round.setCornerRadius(dp(a,23));
      host.setBackground(round);host.setClipToOutline(true);host.setClipChildren(true);host.setClipToPadding(true);
      installInlineBack(a,web);
      monitorNativeHost(a,web,gallery,host);
      web.evaluateJavascript("window.__moaR507NativeMounted&&window.__moaR507NativeMounted(true);",null);
    }
    // Preserve TextureView dimensions during video/controls updates. The prior
    // version relaid out the native host for every tiny WebView viewport wobble,
    // while R463 also recomputed its video matrix: the visible zoom yo-yo.
    boolean significantResize=(lastW<0||lastH<0||Math.abs(w-lastW)>dp(a,9)||Math.abs(h-lastH)>dp(a,9));
    if(significantResize){
      // Only real size changes relayout the native host; motion is translation.
      FrameLayout.LayoutParams lp=new FrameLayout.LayoutParams(w,h,Gravity.TOP|Gravity.LEFT);
      lp.leftMargin=x;lp.topMargin=y;
      host.animate().cancel();host.setTranslationX(0f);host.setTranslationY(0f);
      host.setLayoutParams(lp);baseX=x;baseY=y;
    }else if(x!=lastX||y!=lastY){
      // R531: never intentionally overshoot the real WebView card position.
      // The 18dp velocity lead made opposite-direction corrections visible
      // when the WebMessagePort stream resumed after a fallback snapshot.
      // Both paths now use the same integer-pixel target, with no animation.
      host.setTranslationX(x-baseX);host.setTranslationY(y-baseY);
      lastGeometrySnapshotAt=android.os.SystemClock.uptimeMillis();
      lastGeometrySnapshotY=y;
    }
    lastX=x;lastY=y;lastW=w;lastH=h;
    if(y+h<0||y>root.getHeight())host.setVisibility(View.INVISIBLE);
    else host.setVisibility(View.VISIBLE);
    compactNativeCard(a,web,host,gallery);
    syncAdvancedButton(gallery);
    final String mediaId=currentId(gallery);
    final long now=android.os.SystemClock.uptimeMillis();
    // Large Matrix/MediaPlayer queries belong to media changes, not every
    // scroll poll. Throttled retry covers a newly prepared video stream.
    if(!mediaId.equals(lastFillId)){
      // New media: reset exactly-once + bounded delayed-prepare fill.
      lastFillId=mediaId;fillPrepareAttempts=0;lastFillAt=0;
    }
    // The R519 420ms infinite video Matrix loop competed with R463's own
    // updateVideoGeometry() on every playback/chrome tick and caused flicker.
    // Try once immediately and at most twice while MediaPlayer is preparing;
    // then leave the playback pipeline's transforms alone until media changes.
    if(fillPrepareAttempts<3 && now-lastFillAt>700L){
      fillNativeMediaCard(a,gallery);lastFillAt=now;fillPrepareAttempts++;
    }
    syncIndex(web,gallery,s.optString("cover",""));
  }
  private void installInlineBack(Activity a,WebView web){
    if(Build.VERSION.SDK_INT<33)return;
    if(inlineBack!=null&&backOwner==a)return;
    if(inlineBack!=null)dropDayBack();
    try{
      // Overlay priority only during this photo-card session. Unrelated original
      // R463 fullscreen Gallery retains its own Android Back callback and behavior.
      inlineBack=()->{
        // A photo-only native settings dialog must close BEFORE the photo-day Back.
        // Native Back may be delivered multiple times by Samsung predictive-
        // gesture/legacy callback dispatch; one logical day-exit only.
        long now=android.os.SystemClock.uptimeMillis();
        if(exitInFlight && now-lastNativeBackAt<1800L)return;
        // An open diary keyboard owns the first Back gesture. Hide IME without
        // changing text/recording state; second Back exits the Photo day.
        try{
          View decor=a.getWindow().getDecorView();
          WindowInsets insets=decor.getRootWindowInsets();
          if(insets!=null && insets.isVisible(WindowInsets.Type.ime())){
            if(decor.getWindowInsetsController()!=null)
              decor.getWindowInsetsController().hide(WindowInsets.Type.ime());
            return;
          }
        }catch(Throwable ignored){}
        if(r570SaveDialog!=null&&r570SaveDialog.isShowing()){r570SaveDialog.dismiss();return;}
        if(r570OrderDialog!=null&&r570OrderDialog.isShowing()){r570OrderDialog.dismiss();return;}
        // Native Back must exit the PHOTO DAY, not merely Gallery.close() which
        // exposes the abandoned legacy web photo editor underneath.
        exitInFlight=true;lastNativeBackAt=now;
        // A real user Back is an immediate foreground action, NOT a delayed
        // async closed-host callback. Never reject because the native token is
        // older than the current JS day after photo/detail re-entry.
        web.evaluateJavascript("window.__moaR559ForegroundDayBack?window.__moaR559ForegroundDayBack():\"not-open\"",result->{
          if("\"exit\"".equals(result)||"\"not-open\"".equals(result)){
            dropDayBack();
          }else exitInFlight=false;
        });
      };
      a.getOnBackInvokedDispatcher().registerOnBackInvokedCallback(OnBackInvokedDispatcher.PRIORITY_OVERLAY+50,inlineBack);
      backOwner=a;
    }catch(Throwable e){inlineBack=null;backOwner=null;}
  }
  private void compactNativeCard(Activity a,WebView web,FrameLayout host,Object gallery){
    View found=host.findViewWithTag("moa.gallery.action.deck.r443");
    if(!(found instanceof FrameLayout))return; // R391 adds native actions asynchronously
    FrameLayout deck=(FrameLayout)found;
    if(deck.getChildCount()!=1||!(deck.getChildAt(0) instanceof LinearLayout))return;
    LinearLayout capsule=(LinearLayout)deck.getChildAt(0);
    if(capsule.getChildCount()<4)return;
    if(compactDone&&deck==actionDeck){
      // Do not fight R463's internal video/chrome layout every 48ms. Compaction
      // occurs ONCE when the in-card host mounts or the user toggles the rail.
      return;
    }
    // Stable references to the ORIGINAL four R463 native actions, before inserts.
    final View r570Share=capsule.getChildAt(0),r570Naver=capsule.getChildAt(1);
    final View r570Info=capsule.getChildAt(2),r570Fast=capsule.getChildAt(3);
    actionDeck=deck;actionCapsule=capsule;
    if(deck.getLayoutParams() instanceof FrameLayout.LayoutParams){
      FrameLayout.LayoutParams p=(FrameLayout.LayoutParams)deck.getLayoutParams();
      p.height=dp(a,40);deck.setLayoutParams(p);
    }
    if(capsule.getLayoutParams() instanceof FrameLayout.LayoutParams){
      FrameLayout.LayoutParams p=(FrameLayout.LayoutParams)capsule.getLayoutParams();
      p.height=dp(a,34);p.width=Math.min(Math.max(dp(a,260),host.getWidth()-dp(a,18)),dp(a,306));
      p.bottomMargin=dp(a,1);capsule.setLayoutParams(p);
    }
    GradientDrawable bg=new GradientDrawable();bg.setColor(0xe5212229);bg.setCornerRadius(dp(a,19));
    bg.setStroke(dp(a,.5f),0x447d828c);capsule.setBackground(bg);
    for(int i=0;i<capsule.getChildCount();i++){
      View action=capsule.getChildAt(i);action.setMinimumHeight(dp(a,34));
      if(action.getLayoutParams() instanceof LinearLayout.LayoutParams){
        LinearLayout.LayoutParams p=(LinearLayout.LayoutParams)action.getLayoutParams();
        p.height=dp(a,34);action.setLayoutParams(p);
      }
      if(action instanceof ViewGroup){ViewGroup group=(ViewGroup)action;
        // R531 reduced the already compact R463 icons to 74%, making the four
        // original symbols visibly smaller than star/filmstrip/expand. Keep
        // their original click listeners and 34dp hit boxes; normalize artwork.
        for(int k=0;k<group.getChildCount();k++){
          View glyph=group.getChildAt(k);glyph.setScaleX(.96f);glyph.setScaleY(.96f);
        }
      }
    }
    UnifiedGlyph star=new UnifiedGlyph(a,UnifiedGlyph.STAR);
    star.setContentDescription("현재 사진을 달력 대표사진으로 지정");
    star.setTag("moa.gallery.inline.cover.r511");star.setClickable(true);star.setFocusable(true);
    star.setOnClickListener(v->{
      String id=currentId(gallery);if(id.length()==0)return;
      web.evaluateJavascript("window.MoaR469SimpleDiary&&window.MoaR469SimpleDiary.setCoverNative&&window.MoaR469SimpleDiary.setCoverNative("+JSONObject.quote(id)+");",null);
      star.setSelected(true);star.invalidate();
    });
    capsule.addView(star,0,new LinearLayout.LayoutParams(0,dp(a,34),1f));
    coverStar=star;
    // Adapt ONLY this owned in-card instance. Original Gallery next opens from
    // fresh host+controls and retains its exact R463 sizes and positions.
    Object lowerObject=readField(gallery,"lowerControls");
    if(lowerObject instanceof LinearLayout){
      LinearLayout lower=(LinearLayout)lowerObject;nativeLower=lower;
      if(lower.getLayoutParams() instanceof FrameLayout.LayoutParams){
        FrameLayout.LayoutParams p=(FrameLayout.LayoutParams)lower.getLayoutParams();
        p.height=dp(a,137);lower.setLayoutParams(p);
      }
      Object rail=readField(gallery,"rail");
      if(rail instanceof View && ((View)rail).getLayoutParams() instanceof LinearLayout.LayoutParams){
        LinearLayout.LayoutParams p=(LinearLayout.LayoutParams)((View)rail).getLayoutParams();
        // Original native Gallery draws the selected thumbnail 8dp higher.
        // A 54dp clip was too short for its 46dp drawing; reserve 64dp,
        // then scale the artwork visually without clipping the selected tile.
        p.height=dp(a,64);((View)rail).setLayoutParams(p);
        ((View)rail).setPivotY(dp(a,32));((View)rail).setScaleY(.79f);
        railView=(View)rail;
      }
      Object video=readField(gallery,"videoControls");
      if(video instanceof LinearLayout && ((View)video).getLayoutParams() instanceof LinearLayout.LayoutParams){
        LinearLayout.LayoutParams p=(LinearLayout.LayoutParams)((View)video).getLayoutParams();
        p.height=dp(a,34);((View)video).setLayoutParams(p);
        // Keep the ORIGINAL pause/mute/capture listeners and 32dp hit regions.
        // Only the in-card view geometry and icon artwork are compressed.
        LinearLayout videoRow=(LinearLayout)video;
        for(int i=0;i<videoRow.getChildCount();i++){
          View slot=videoRow.getChildAt(i);
          if(slot.getLayoutParams() instanceof LinearLayout.LayoutParams){
            LinearLayout.LayoutParams sp=(LinearLayout.LayoutParams)slot.getLayoutParams();
            sp.height=dp(a,i==1?31:33);slot.setLayoutParams(sp);
          }
          if(slot instanceof ViewGroup){
            ViewGroup vg=(ViewGroup)slot;
            for(int k=0;k<vg.getChildCount();k++){
              View glyph=vg.getChildAt(k);
              if(i!=1){glyph.setScaleX(.82f);glyph.setScaleY(.82f);}
              else if(k==0){glyph.setScaleX(.83f);glyph.setScaleY(.83f);}
              else if(glyph instanceof TextView)((TextView)glyph).setTextSize(10f);
            }
          }
        }
      }
      Object seek=readField(gallery,"seekRow");
      if(seek instanceof View && ((View)seek).getLayoutParams() instanceof LinearLayout.LayoutParams){
        LinearLayout.LayoutParams p=(LinearLayout.LayoutParams)((View)seek).getLayoutParams();
        p.height=dp(a,27);((View)seek).setLayoutParams(p);
      }
    }
    if(railView!=null && !railToggleInstalled){
      railExpanded=a.getSharedPreferences("moa.r515.card_ui",0).getBoolean("rail_expanded",true);
      installRailToggle(a,capsule);
      setRailExpanded(a,railExpanded);
    }
    // Hide the original R463 chrome ONCE per deliberate photo-day entry.
    // The native Gallery's existing tap gesture still toggles chromeVisible;
    // do not install a competing touch listener on its stage.
    if(!initialCardChromeHidden){
      initialCardChromeHidden=true;
      try{Field f=field(gallery.getClass(),"chromeVisible");if(f!=null)f.setBoolean(gallery,false);}catch(Throwable ignored){}
      if(nativeLower!=null)nativeLower.setVisibility(View.GONE);
      deck.setVisibility(View.GONE);
    }
    if(favoriteButton==null){
      // Keep Save separate from the compact capture-address/default-display card.
      UnifiedGlyph favorite=new UnifiedGlyph(a,UnifiedGlyph.FAVORITE);
      favorite.setContentDescription("현재 사진 네이버 즐겨찾기 저장");
      favorite.setTag("moa.gallery.inline.favorite.r570");favorite.setClickable(true);favorite.setFocusable(true);
      favorite.setOnClickListener(v->r570OpenFavorite(a,web,gallery));
      capsule.addView(favorite,new LinearLayout.LayoutParams(0,dp(a,34),1f));favoriteButton=favorite;
    }
    if(advancedButton==null){
      // R535: seventh symbol inside the SAME bottom action capsule, never a
      // floating top-right overlay. Original four R463 listeners remain intact.
      UnifiedGlyph advanced=new UnifiedGlyph(a,UnifiedGlyph.EXPAND);
      advanced.setContentDescription("원래 고급 갤러리 전체 화면으로 열기");
      advanced.setTag("moa.gallery.card.advanced.r535");advanced.setClickable(true);advanced.setFocusable(true);
      capsule.addView(advanced,new LinearLayout.LayoutParams(0,dp(a,34),1f));
      advanced.setOnClickListener(v->enterOriginalFullscreen(web,gallery));
      advancedButton=advanced;
    }
    // Move *existing View objects* only: ORIGINAL OnClickListeners never change.
    r570InitActionOrder(a,capsule,r570Share,r570Naver,r570Info,r570Fast);
    compactDone=true;
  }
  private void syncAdvancedButton(Object gallery){
    // Parent R463 action deck itself owns show/hide on the media tap.
    if(advancedButton!=null && advancedButton.getVisibility()!=View.VISIBLE)
      advancedButton.setVisibility(View.VISIBLE);
  }
  // R570: original R463 actions retain their own listeners and distinct identity.
  // Reordering only reparents the same views inside the photo-only action capsule.
  private void r570InitActionOrder(Activity a,LinearLayout capsule,
         View share,View naver,View info,View fast){
    if(capsule==null||coverStar==null||favoriteButton==null||railToggle==null||advancedButton==null)return;
    r570Actions.clear();
    r570Actions.put("cover",coverStar);r570Actions.put("share",share);
    r570Actions.put("naver",naver);r570Actions.put("info",info);
    r570Actions.put("fast",fast);r570Actions.put("favorite",favoriteButton);
    r570Actions.put("rail",railToggle);r570Actions.put("expand",advancedButton);
    if(r570Actions.size()!=8)return;
    for(final View v:r570Actions.values()){
      // Do NOT replace OnClickListener or intercept original media gestures.
      v.setOnLongClickListener(target->{r570OpenOrder(a,capsule);return true;});
    }
    // Native art has different intrinsic bounds; normalize visual footprints
    // while retaining 34dp per-action touch areas.
    float[] ratios={.94f,.92f,.92f,1.02f,.96f,1f,1f,1f};
    for(int i=0;i<R570_ROLES.length;i++){
      View role=r570Actions.get(R570_ROLES[i]);if(role==null)continue;
      View glyph=role instanceof ViewGroup&&((ViewGroup)role).getChildCount()>0?
         ((ViewGroup)role).getChildAt(0):role;
      if(glyph instanceof UnifiedGlyph)continue; // fixed 19dp custom canvas
      glyph.setScaleX(ratios[i]);glyph.setScaleY(ratios[i]);
    }
    r570ApplyOrder(a,capsule);
  }
  private ArrayList<String> r570SavedRoles(Activity a){
    final String value=a.getSharedPreferences("moa.r570.photo.actions",0).getString("order","");
    ArrayList<String> order=new ArrayList<>();
    if(value.length()>0){for(String role:value.split(",")){if(r570Actions.containsKey(role)&&!order.contains(role))order.add(role);}}
    // Fail closed: corrupt preference cannot remove any original action.
    if(order.size()!=R570_ROLES.length){order.clear();order.addAll(Arrays.asList(R570_ROLES));}
    return order;
  }
  private void r570ApplyOrder(Activity a,LinearLayout capsule){
    if(capsule==null||r570Actions.size()!=8)return;
    ArrayList<String> order=r570SavedRoles(a);
    for(String role:order){View v=r570Actions.get(role);
      if(v==null)return;
    }
    // Never re-create actions or listeners. No Gallery replacement.
    for(String role:order){View v=r570Actions.get(role);
      if(v.getParent()==capsule)capsule.removeView(v);
    }
    for(String role:order){View v=r570Actions.get(role);
      capsule.addView(v,new LinearLayout.LayoutParams(0,dp(a,34),1f));
    }
  }
  private static String r570RoleLabel(String role){
    switch(role){case "cover":return "대표 사진";case "share":return "공유";
      case "naver":return "네이버 지도";case "info":return "촬영 정보";
      case "fast":return "연속 넘기기";case "favorite":return "네이버 저장";
      case "rail":return "사진 목록";case "expand":return "전체 화면";default:return role;}
  }
  private void r570OpenOrder(Activity a,LinearLayout capsule){
    if(a==null||a.isFinishing()||capsule!=actionCapsule||r570Actions.size()!=8)return;
    if(r570OrderDialog!=null&&r570OrderDialog.isShowing())return;
    ArrayList<String> ids=r570SavedRoles(a);
    final int[] pos={0};
    String[] labels=new String[ids.size()];
    for(int i=0;i<ids.size();i++)labels[i]=(i+1)+". "+r570RoleLabel(ids.get(i));
    AlertDialog dialog=new AlertDialog.Builder(a)
      .setTitle("사진형 아이콘 순서")
      .setSingleChoiceItems(labels,0,(d,which)->pos[0]=which)
      .setPositiveButton("왼쪽으로",(d,which)->r570MoveOrder(a,capsule,ids,pos[0],-1))
      .setNeutralButton("오른쪽으로",(d,which)->r570MoveOrder(a,capsule,ids,pos[0],1))
      .setNegativeButton("닫기",(d,which)->{})
      .create();r570OrderDialog=dialog;
    dialog.show();
  }
  private void r570MoveOrder(Activity a,LinearLayout capsule,ArrayList<String> order,int pos,int delta){
    if(pos<0||pos>=order.size()||pos+delta<0||pos+delta>=order.size())return;
    Collections.swap(order,pos,pos+delta);
    a.getSharedPreferences("moa.r570.photo.actions",0).edit()
      .putString("order",android.text.TextUtils.join(",",order)).apply();
    r570ApplyOrder(a,capsule);
    Toast.makeText(a,"아이콘 순서가 저장됐습니다",Toast.LENGTH_SHORT).show();
  }
  // A native modal sits ABOVE the real R463 TextureView. Do not push/resize
  // the original capture-info card or create another WebView session.
  private void r570OpenFavorite(Activity a,WebView web,Object gallery){
    if(a==null||web==null||gallery==null||!ownsGallery||gallery!=galleryRef||fullNativeOpen||!isTrustedWeb(web))return;
    final String id=currentId(gallery);
    if(!id.matches("(?:v)?[0-9]{1,18}")){
      Toast.makeText(a,"현재 사진의 위치를 확인할 수 없습니다",Toast.LENGTH_SHORT).show();return;
    }
    if(r570SaveDialog!=null&&r570SaveDialog.isShowing())return;
    LinearLayout body=new LinearLayout(a);body.setOrientation(LinearLayout.VERTICAL);
    int edge=dp(a,18);body.setPadding(edge,dp(a,5),edge,0);
    TextView help=new TextView(a);help.setText("현재 사진의 원본 촬영 GPS 사용 · 정확한 주소 확인 후 저장");
    help.setTextSize(12);help.setTextColor(0xff69717a);body.addView(help);
    EditText alias=new EditText(a);alias.setSingleLine(true);alias.setHint("장소 별명 (선택)");alias.setMaxLines(1);
    EditText memo=new EditText(a);memo.setHint("네이버 즐겨찾기 메모 (선택)");memo.setMinLines(2);memo.setMaxLines(3);
    EditText list=new EditText(a);list.setSingleLine(true);list.setHint("저장할 리스트 이름");
    list.setText(a.getSharedPreferences("moa.r570.photo.actions",0).getString("last_save_list","내 장소"));
    body.addView(alias);body.addView(memo);body.addView(list);
    AlertDialog dialog=new AlertDialog.Builder(a).setTitle("네이버 즐겨찾기 저장")
      .setView(body).setPositiveButton("비점유 저장",(d,w)->r570DispatchSave(a,web,gallery,id,alias,memo,list,"web"))
      .setNeutralButton("기존 저장",(d,w)->r570DispatchSave(a,web,gallery,id,alias,memo,list,"native"))
      .setNegativeButton("취소",(d,w)->{}).create();r570SaveDialog=dialog;
    dialog.show();
  }
  private void r570DispatchSave(Activity a,WebView web,Object gallery,String id,
                 EditText alias,EditText memo,EditText list,String mode){
    if(!ownsGallery||gallery!=galleryRef||!id.equals(currentId(gallery))||!isTrustedWeb(web)){
      Toast.makeText(a,"사진이 변경되어 저장 요청을 취소했습니다",Toast.LENGTH_SHORT).show();return;
    }
    // Native Dialog is input-only. The existing first-party JS GPS/Naver writer
    // stays the sole saving authority, including confirmation / auth / outbox.
    // Only the destination list is remembered; never leak another photo's
    // alias/memo into the current media record.
    a.getSharedPreferences("moa.r570.photo.actions",0).edit()
      .putString("last_save_list",list.getText().toString().trim()).apply();
    String script="(function(){return window.MoaR570PhotoFavorites&&"+
       "window.MoaR570PhotoFavorites.save("+JSONObject.quote(id)+","+
        JSONObject.quote(alias.getText().toString())+","+
        JSONObject.quote(memo.getText().toString())+","+
        JSONObject.quote(list.getText().toString())+","+JSONObject.quote(mode)+");})()";
    web.evaluateJavascript(script,value->{
      if(!"true".equals(value))Toast.makeText(a,"저장 엔진 확인 실패 · 다시 시도해 주세요",Toast.LENGTH_LONG).show();
      else Toast.makeText(a,"저장 요청을 전달했습니다 · 네이버 저장 결과 확인 필요",Toast.LENGTH_LONG).show();
    });
  }
  private void enterOriginalFullscreen(WebView web,Object gallery){
    if(!ownsGallery||fullNativeOpen||gallery!=galleryRef||!isTrustedWeb(web))return;
    fullNativeOpen=true;fullNativeSeenOpen=false;fullscreenOwnerActivity=foreground;
    fullNativeLastIndex=lastIndex;fullNativeLastId=currentId(gallery);
    fullNativeStartedAt=android.os.SystemClock.uptimeMillis();
    // Standalone original fullscreen Gallery owns its OWN Back handler.
    dropDayBack();
    clearCardMark();invokeClose(gallery);
    web.evaluateJavascript("window.__moaR531ShowAdvanced&&window.__moaR531ShowAdvanced();",null);
  }
  // R515 keeps the original rail/OverScroller intact. Only the visibility and
  // viewer-scoped LinearLayout heights are changed; original fullscreen Gallery
  // is never entered through this code path.
  // R535: consistent 19dp outlined assets in 34dp hit slots. No font glyphs.
  private static final class UnifiedGlyph extends View{
    static final int STAR=0,RAIL=1,EXPAND=2,FAVORITE=3;
    private final int kind;
    private final android.graphics.Paint paint=new android.graphics.Paint(android.graphics.Paint.ANTI_ALIAS_FLAG);
    UnifiedGlyph(Activity a,int kind){super(a);this.kind=kind;
      paint.setColor(Color.WHITE);paint.setStyle(android.graphics.Paint.Style.STROKE);
      paint.setStrokeWidth(1.65f*a.getResources().getDisplayMetrics().density);
      paint.setStrokeJoin(android.graphics.Paint.Join.ROUND);
      paint.setStrokeCap(android.graphics.Paint.Cap.ROUND);
    }
    @Override protected void onDraw(android.graphics.Canvas canvas){
      super.onDraw(canvas);float d=getResources().getDisplayMetrics().density;
      float cx=getWidth()/2f,cy=getHeight()/2f;
      if(kind==STAR){
        android.graphics.Path path=new android.graphics.Path();
        for(int i=0;i<10;i++){
          double th=Math.PI*(-.5+i/5.0);float r=(i%2==0?9.2f:4.0f)*d;
          float x=cx+(float)Math.cos(th)*r,y=cy+(float)Math.sin(th)*r;
          if(i==0)path.moveTo(x,y);else path.lineTo(x,y);
        }
        path.close();paint.setStyle(isSelected()?android.graphics.Paint.Style.FILL:android.graphics.Paint.Style.STROKE);
        canvas.drawPath(path,paint);paint.setStyle(android.graphics.Paint.Style.STROKE);
      }else if(kind==FAVORITE){
        float x=7.6f*d,y=8.8f*d;
        android.graphics.Path p=new android.graphics.Path();
        p.moveTo(cx-x,cy-y);p.lineTo(cx+x,cy-y);p.lineTo(cx+x,cy+y);
        p.lineTo(cx,cy+3.5f*d);p.lineTo(cx-x,cy+y);p.close();canvas.drawPath(p,paint);
        canvas.drawLine(cx-3.1f*d,cy-2.1f*d,cx+3.1f*d,cy-2.1f*d,paint);
        canvas.drawLine(cx,cy-5.2f*d,cx,cy+1.0f*d,paint);
      }else if(kind==RAIL){
        for(int i=0;i<3;i++){
          float x=cx+(i-1)*6.8f*d;
          canvas.drawRoundRect(x-3.05f*d,cy-7.7f*d,x+3.05f*d,cy+7.7f*d,1.1f*d,1.1f*d,paint);
        }
      }else{
        // Four corners: visual footprint exactly 19x19dp like other actions.
        float a=9.5f*d,b=4.0f*d;
        canvas.drawLine(cx-a,cy-b,cx-a,cy-a,paint);canvas.drawLine(cx-a,cy-a,cx-b,cy-a,paint);
        canvas.drawLine(cx+b,cy-a,cx+a,cy-a,paint);canvas.drawLine(cx+a,cy-a,cx+a,cy-b,paint);
        canvas.drawLine(cx-a,cy+b,cx-a,cy+a,paint);canvas.drawLine(cx-a,cy+a,cx-b,cy+a,paint);
        canvas.drawLine(cx+b,cy+a,cx+a,cy+a,paint);canvas.drawLine(cx+a,cy+a,cx+a,cy+b,paint);
      }
    }
  }
  private void installRailToggle(Activity a,LinearLayout capsule){
    if(railToggleInstalled || railView==null)return;
    // In-card ONLY: sixth icon in the existing native action deck.
    // Do not create another free-floating button covering video controls.
    UnifiedGlyph control=new UnifiedGlyph(a,UnifiedGlyph.RAIL);
    control.setClickable(true);control.setFocusable(true);
    control.setContentDescription("사진 목록 접기");
    control.setTag("moa.gallery.inline.rail.toggle.r519");
    control.setBackgroundColor(Color.TRANSPARENT);
    capsule.addView(control,new LinearLayout.LayoutParams(0,dp(a,34),1f));
    control.setOnClickListener(v->{
      setRailExpanded(a,!railExpanded);
      a.getSharedPreferences("moa.r515.card_ui",0).edit().putBoolean("rail_expanded",railExpanded).apply();
    });
    railToggle=control;railToggleInstalled=true;
  }
  private void setRailExpanded(Activity a,boolean expanded){
    railExpanded=expanded;
    if(railView!=null)railView.setVisibility(expanded?View.VISIBLE:View.GONE);
    if(nativeLower!=null && nativeLower.getLayoutParams() instanceof FrameLayout.LayoutParams){
      FrameLayout.LayoutParams lp=(FrameLayout.LayoutParams)nativeLower.getLayoutParams();
      lp.height=dp(a,expanded?137:82);nativeLower.setLayoutParams(lp);
    }
    if(railToggle!=null){
      railToggle.invalidate();
      railToggle.setContentDescription(expanded?"사진 목록 접기":"사진 목록 펼치기");
      railToggle.setSelected(!expanded);
    }
  }
  // Only the in-card Gallery opts into center-crop. Never upscale the bitmap
  // beyond what the original image decoder provides and never change fullscreen.
  // Full bleed necessarily trims edges when image/video and stage ratios differ.
  private void updateAmbientForSelection(Activity a,Object gallery,String id){
    Object raw=readField(gallery,"texture");
    if(raw instanceof TextureView)updateVideoAmbient(a,(TextureView)raw,id);
    else if(ambientPoster!=null)ambientPoster.setVisibility(View.GONE);
  }
  private void fillNativeMediaCard(Activity a,Object gallery){
    Object pictures=readField(gallery,"images");
    if(pictures instanceof ImageView[]){
      for(ImageView im:(ImageView[])pictures)if(im!=null && im.getScaleType()!=ImageView.ScaleType.CENTER_CROP)
        im.setScaleType(ImageView.ScaleType.CENTER_CROP);
    }
    // R531: photos retain cover; VIDEO must preserve EVERY edge of the frame.
    // Leave the original R463 TextureView FIT transform untouched. Its old
    // in-card max-scale replacement cut away content and caused geometry fights.
    Object rawTexture=readField(gallery,"texture");
    if(rawTexture instanceof TextureView){
      TextureView texture=(TextureView)rawTexture;
      String id=currentId(gallery);
      updateVideoAmbient(a,texture,id);
    }
  }
  private void updateVideoAmbient(Activity a,TextureView texture,String id){
    if(!id.startsWith("v")||!id.substring(1).matches("[0-9]{1,18}")){
      if(ambientPoster!=null)ambientPoster.setVisibility(View.GONE);
      texture.setOpaque(true);return;
    }
    ViewGroup parent=texture.getParent() instanceof ViewGroup?(ViewGroup)texture.getParent():null;
    if(!(parent instanceof FrameLayout))return;
    if(ambientPoster==null||ambientParent!=parent){
      if(ambientPoster!=null&&ambientPoster.getParent() instanceof ViewGroup)
        ((ViewGroup)ambientPoster.getParent()).removeView(ambientPoster);
      ImageView poster=new ImageView(a);poster.setScaleType(ImageView.ScaleType.CENTER_CROP);
      poster.setBackgroundColor(0xff28272c);poster.setAlpha(1f);
      // Absolute bottom of the native stage. Photos must ALWAYS paint above
      // video ambient, even in the brief interval before selection callbacks.
      parent.addView(poster,0,new FrameLayout.LayoutParams(-1,-1));
      ambientPoster=poster;ambientParent=parent;ambientMediaId="";
    }
    ambientPoster.setVisibility(View.VISIBLE);texture.setOpaque(false);
    if(id.equals(ambientMediaId))return;
    ambientMediaId=id;ambientPoster.setImageDrawable(null);
    final ImageView target=ambientPoster;
    // R570: fixed neutral backdrop for in-card VIDEO only. The historical
    // asynchronous blurred poster flashed/recomposited behind each TextureView
    // mount. No MediaPlayer, TextureView transform or R463 callback is changed.
    target.setImageDrawable(null);
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
    if(coverStar!=null){coverStar.setSelected(id.equals(cover));coverStar.invalidate();}
    if(i!=lastIndex){
      lastIndex=i;
      web.evaluateJavascript("window.__moaR507NativeSelected&&window.__moaR507NativeSelected("+i+");",null);
    }
  }
  private static int dp(Activity a,float n){return (int)(n*a.getResources().getDisplayMetrics().density+.5f);}

  // R547: React to a confirmed LOST native host, not merely an Activity pause.
  // R543 indiscriminately invoked Gallery.close() on every NAVER return even if
  // isOpen==true and its host was attached. That closed working media and
  // triggered the R543 JS timeout -> legacy Web fallback -> repeated rebuild.
  // R563: isOpen + host parent is NOT a proof that photos/video have been
  // rendered after Android temporarily suspends the activity. The R463
  // Gallery has its own refreshPages() routine; prefer that without closing
  // its host, changing current index or swapping players to a web fallback.
  private boolean actualMediaReady(Object gallery){
    if(!galleryOpen(gallery))return false;
    final String id=currentId(gallery);
    if(id.isEmpty())return false;
    if(id.startsWith("v")){
      Object raw=readField(gallery,"texture");
      return raw instanceof TextureView && ((TextureView)raw).isAvailable() &&
          Boolean.TRUE.equals(readField(gallery,"prepared")) &&
          readField(gallery,"media") instanceof MediaPlayer;
    }
    Object arr=readField(gallery,"images");
    if(arr instanceof ImageView[]){
      ImageView[] imgs=(ImageView[])arr;
      return imgs.length>1 && imgs[1]!=null && imgs[1].getDrawable()!=null;
    }
    return false;
  }
  private void refreshOriginalMediaIfBlank(Object gallery){
    if(!galleryOpen(gallery)||actualMediaReady(gallery))return;
    final long now=android.os.SystemClock.uptimeMillis();
    if(now-lastMediaRefreshAt<1800L)return;
    lastMediaRefreshAt=now;
    final String id=currentId(gallery);
    if(id.startsWith("v")){
      // R227 refreshPages() only reloads ImageView posters. It does NOT
      // recreate the TextureView/MediaPlayer after Android discards the video
      // SurfaceTexture. The original R227 Gallery itself owns this pipeline.
      // Validate again after a brief foreground settle to avoid interrupting
      // a legitimate asynchronous prepare. Never restart a healthy video.
      final int resumeDayToken=ownedDayToken;
      final FrameLayout originalHost=nativeHost;
      main.postDelayed(()->{
        // Do not touch a newer detailed/fullscreen Gallery or another date.
        if(!resumed||foreground!=nativeOwnerActivity||fullNativeOpen||
           !ownsGallery||galleryRef!=gallery||originalHost==null||
           originalHost!=nativeHost||readField(gallery,"host")!=originalHost||
           ownedDayToken!=resumeDayToken||!galleryOpen(gallery)||
           !id.equals(currentId(gallery))||actualMediaReady(gallery))return;
        try{
          Object texture=readField(gallery,"texture");
          Object player=readField(gallery,"media");
          boolean oldSurfaceValid=texture instanceof TextureView &&
              ((TextureView)texture).isAvailable();
          if(oldSurfaceValid && player instanceof MediaPlayer &&
              Boolean.TRUE.equals(readField(gallery,"prepared")))return;
          Method teardown=gallery.getClass().getDeclaredMethod("teardownPlayer");
          Method refresh=gallery.getClass().getDeclaredMethod("refreshPages");
          Method prepare=gallery.getClass().getDeclaredMethod("prepareCurrentVideo");
          teardown.setAccessible(true);refresh.setAccessible(true);prepare.setAccessible(true);
          // Use precisely the ORIGINAL Gallery video player, at same media ID.
          teardown.invoke(gallery);refresh.invoke(gallery);prepare.invoke(gallery);
          android.util.Log.i("MOA_R563","ORIGINAL_VIDEO_SURFACE_REPAIR id_preserved");
        }catch(Throwable ex){
          android.util.Log.w("MOA_R563","ORIGINAL_VIDEO_SURFACE_REPAIR_FAILED_"+
              ex.getClass().getSimpleName());
        }
      },820L);
      return;
    }
    try{
      Method m=gallery.getClass().getDeclaredMethod("refreshPages");
      m.setAccessible(true);m.invoke(gallery);
      android.util.Log.i("MOA_R563","ORIGINAL_PHOTO_PAGE_REFRESH index="+readField(gallery,"index"));
    }catch(Throwable ex){
      android.util.Log.w("MOA_R563","ORIGINAL_PHOTO_PAGE_REFRESH_FAILED_"+ex.getClass().getSimpleName());
    }
  }
  private void rebindAfterReturn(Activity a,int epoch){
    if(!resumed||a==null||foreground!=a||epoch!=foregroundEpoch||
       !returnFromBackground||fullNativeOpen||a.isFinishing()||a.isDestroyed()||
       nativeOwnerActivity!=a)return;
    final WebView web=findWeb(a);if(web==null||!isTrustedWeb(web))return;
    final Object gallery=readField(a,"unifiedGallery");
    final FrameLayout root=a.findViewById(android.R.id.content);
    final Object rawHost=readField(gallery,"host");
    final boolean healthy=galleryOpen(gallery)&&gallery==galleryRef&&
        rawHost==nativeHost&&nativeHost!=null&&nativeHost.getParent()==root;
    if(healthy){
      // R559: the Gallery is attached and OPEN. Reassert actual Z ordering on
      // resume (external overlays can be inserted above it while MOA is paused).
      // Do not close/reopen a healthy original Gallery, ever.
      // The WebView can already be trusted while its photo-day JS has not
      // restored yet. DO NOT clear returnFromBackground until JS ACKs that
      // the same date/session is actually mounted; otherwise one early check
      // repeats the exact R563 permanent gray-card deadlock.
      final String date=String.valueOf(readField(gallery,"currentDay"));
      web.evaluateJavascript("(function(){try{var ok=window.__moaR567RestoreLiveCard&&"+
          "window.__moaR567RestoreLiveCard("+JSONObject.quote(date)+");"+
          "return ok?(window.__moaR527DayToken||0):0}catch(e){return 0}})()",answer->{
        if(!resumed||foreground!=a||epoch!=foregroundEpoch||!returnFromBackground||
           galleryRef!=gallery||nativeHost==null||!galleryOpen(gallery))return;
        int token=0;
        try{token=Integer.parseInt(String.valueOf(answer).replace("\"",""));}catch(Throwable ignored){}
        if(token<=0){android.util.Log.i("MOA_R567","RETURN_JS_NOT_READY_RETRY");return;}
        ownedDayToken=token;
        returnFromBackground=false;hadMountedOnPause=false;nativeCloseDetectedAt=0L;
        returnCloseGuardUntil=android.os.SystemClock.uptimeMillis()+320L;
        nativeHost.setAlpha(1f);
        nativeHost.setVisibility(View.VISIBLE);
        nativeHost.bringToFront();
        nativeHost.requestLayout();nativeHost.invalidate();
        installInlineBack(a,web);monitorNativeHost(a,web,gallery,nativeHost);
        ensurePositionChannel(web);
        refreshOriginalMediaIfBlank(gallery);
        web.evaluateJavascript("window.__moaR559RepositionNative&&"+
            "window.__moaR559RepositionNative();",null);
        android.util.Log.i("MOA_R567","RETURN_ORIGINAL_NATIVE_RETAINED_VISIBLE token="+token);
      });
      return;
    }
    final long now=android.os.SystemClock.uptimeMillis();
    if(now-lastRebindAt<2600L)return;
    // A genuinely closed or detached host may be rebuilt, after validating
    // the SAME active photo day and session. Never do this on NAVER's WebView.
    final String check="(function(){try{var d=window.MoaR469SimpleDiary,"+
      "s=d&&d.readOnlyStatus&&d.readOnlyStatus();return JSON.stringify({day:!!("+
      "s&&s.active&&s.page==='day'),date:String(s&&s.date||''),"+
      "token:window.__moaR527DayToken||0,full:!!("+
      "window.__moaR539AdvancedActive&&window.__moaR539AdvancedActive())});"+
      "}catch(e){return '{}'}})()";
    try{web.evaluateJavascript(check,result->{
      if(!resumed||foreground!=a||epoch!=foregroundEpoch||fullNativeOpen||nativeOwnerActivity!=a)return;
      try{
        Object parsed=new JSONTokener(result).nextValue();
        if(!(parsed instanceof String))return;
        JSONObject st=new JSONObject((String)parsed);
        if(!st.optBoolean("day")||st.optBoolean("full"))return;
        int token=st.optInt("token",0);
        // The WebView can start a newer token while the SAME DAY original
        // Gallery still exists; old R563 equality check permanently deadlocked.
        String day=st.optString("date","");
        String originalDay=String.valueOf(readField(galleryRef,"currentDay"));
        if("null".equals(originalDay)||originalDay.isEmpty())originalDay=ownerDayAtPause;
        if(token<=0||day.isEmpty()||!day.equals(originalDay))return;
        // A healthy host can recover while the async WebView check is running.
        Object live=readField(a,"unifiedGallery");
        FrameLayout rr=a.findViewById(android.R.id.content);
        if(galleryOpen(live)&&live==galleryRef&&nativeHost!=null&&
           readField(live,"host")==nativeHost&&nativeHost.getParent()==rr){
          // A healthy original host raced our async status check: perform the
          // SAME JS-acknowledged rebind as the primary healthy path, never close.
          rebindAfterReturn(a,epoch);return;}
        // Do not destroy the old host until the restored WebView actively
        // ACKs that the same-day Gallery can be reopened. An early rejected
        // JS request must leave returnFromBackground alive for later retries.
        controlledRebuildInProgress=true;
        web.evaluateJavascript("window.__moaR567ReopenLostCard&&"+
          "window.__moaR567ReopenLostCard("+JSONObject.quote(day)+");",ack->{
          if(!resumed||foreground!=a||epoch!=foregroundEpoch||!returnFromBackground){
            controlledRebuildInProgress=false;return;}
          if(!"true".equals(String.valueOf(ack))){
            controlledRebuildInProgress=false;
            android.util.Log.i("MOA_R567","RETURN_REOPEN_JS_NOT_READY_RETRY");return;
          }
          returnFromBackground=false;hadMountedOnPause=false;
          lastRebindAt=android.os.SystemClock.uptimeMillis();
          returnCloseGuardUntil=lastRebindAt+320L;
          suppressArmUntil=lastRebindAt+190L;
          closePositionPort();
          // This branch is ONLY for a confirmed unusable Gallery, never a
          // still-open attached healthy host.
          clearCardMark();
          if(live!=null && galleryOpen(live))invokeClose(live);
          controlledRebuildInProgress=false;
          android.util.Log.i("MOA_R567","RETURN_LOST_NATIVE_REOPEN_SAME_DAY");
        });
      }catch(Throwable ignored){}
    });}catch(Throwable ignored){}
  }
  // R555: fires BEFORE the original Activity.onPause (API29+, app minSdk29).
  // R227 host checks r227RetainForExternalMap() during onPause and CLOSES the
  // existing native Gallery unless r227ExternalMapPending is already true.
  // Unlike previous R535-R551 callbacks, this runs early enough to retain it.
  @Override public void onActivityPrePaused(Activity a){
    if(a==nativeOwnerActivity && ownsGallery){
      lifecyclePauseInProgress=true;
      hadMountedOnPause=nativeHost!=null&&galleryRef!=null;
      returnFromBackground=hadMountedOnPause;
      String day=String.valueOf(readField(galleryRef,"currentDay"));
      ownerDayAtPause="null".equals(day)?"":day;
      backgroundStartedAt=android.os.SystemClock.uptimeMillis();
    }
    // Covers card, detailed Diary, and original fullscreen Gallery. They all
    // share the same original R227 onPause->Gallery.close host invariant.
    if(a==null||a!=foreground||a.isFinishing()||a.isDestroyed()||
       !isTrustedWeb(findWeb(a)))return;
    Object g=readField(a,"unifiedGallery");
    if(g==null||!galleryOpen(g)||
       !"com.juhyeon.familyjourney.MoaNativeGallery".equals(g.getClass().getName()))return;
    try{
      Field pending=field(g.getClass(),"r227ExternalMapPending");
      Field wasPlaying=field(g.getClass(),"r227VideoWasPlaying");
      if(pending==null||wasPlaying==null)return;
      boolean already=pending.getBoolean(g);
      if(!already){
        boolean playing=false;
        Object mp=readField(g,"media");
        if(Boolean.TRUE.equals(readField(g,"prepared"))&&mp instanceof MediaPlayer){
          try{playing=((MediaPlayer)mp).isPlaying();
            if(playing)((MediaPlayer)mp).pause();}catch(Throwable ignored){}
        }
        wasPlaying.setBoolean(g,playing);
        pending.setBoolean(g,true);
      }
      Method retain=g.getClass().getMethod("r227RetainForExternalMap");
      boolean ok=Boolean.TRUE.equals(retain.invoke(g));
      if(ok){
        prePausedRetainedGallery=g;
        prePausedOwnerActivity=a;
        prePauseRetainAt=android.os.SystemClock.uptimeMillis();
        android.util.Log.i("MOA_R555","PRE_PAUSE_RETAIN_PASS");
      }else if(!already){
        pending.setBoolean(g,false);
        wasPlaying.setBoolean(g,false);
        android.util.Log.w("MOA_R555","PRE_PAUSE_RETAIN_UNAVAILABLE");
      }
    }catch(Throwable error){
      android.util.Log.w("MOA_R555","PRE_PAUSE_RETAIN_FAILED_"+error.getClass().getSimpleName());
    }
  }
  // R227 original Activity.onResume normally invokes this itself. Only run
  // its idempotent completion if the original host still has a pending flag.
  @Override public void onActivityPostResumed(Activity a){
    if(a!=prePausedOwnerActivity||prePausedRetainedGallery==null)return;
    final Object g=prePausedRetainedGallery;
    prePausedRetainedGallery=null;
    prePausedOwnerActivity=null;
    if(g!=readField(a,"unifiedGallery")||!galleryOpen(g))return;
    try{
      if(Boolean.TRUE.equals(readField(g,"r227ExternalMapPending"))){
        g.getClass().getMethod("r227ResumeFromExternalMap").invoke(g);
      }
    }catch(Throwable error){
      android.util.Log.w("MOA_R555","POST_RESUME_RETAIN_FAILED_"+error.getClass().getSimpleName());
    }
  }
  @Override public void onActivityResumed(Activity a){
    foreground=a;resumed=true;final int epoch=++foregroundEpoch;
    // Other activities (NAVER, share sheet, etc.) are not the Gallery owner.
    // Keep the owner's pending health check until THAT Activity resumes.
    if(a==nativeOwnerActivity)lifecyclePauseInProgress=false;
    if(returnFromBackground && hadMountedOnPause && a==nativeOwnerActivity){
      lastResumeAt=android.os.SystemClock.uptimeMillis();
      returnCloseGuardUntil=lastResumeAt+1250L;
      // R563 performed ONE check at 580ms. If WebView was not yet trusted/ready,
      // returnFromBackground stayed true FOREVER and both Back and re-entry froze.
      // Repeat only READ/repair checks until valid, never reopen a live Gallery.
      for(long delay:new long[]{150L,480L,950L,1700L,2750L,3950L}){
        main.postDelayed(()->rebindAfterReturn(a,epoch),delay);
      }
      android.util.Log.i("MOA_R567","RETURN_RECHECK_SCHEDULED");
    }
  }
  @Override public void onActivityPaused(Activity a){
    if(foreground==a){resumed=false;++foregroundEpoch;}
    if(a==nativeOwnerActivity && ownsGallery && !fullNativeOpen){
      hadMountedOnPause=nativeHost!=null&&galleryRef!=null;
      returnFromBackground=hadMountedOnPause;
      backgroundStartedAt=android.os.SystemClock.uptimeMillis();
    }
  }
  @Override public void onActivityDestroyed(Activity a){
    if(foreground==a){foreground=null;resumed=false;}
    if(nativeOwnerActivity==a||fullscreenOwnerActivity==a||prePausedOwnerActivity==a||backOwner==a){
      dropDayBack();
      prePausedRetainedGallery=null;
      prePausedOwnerActivity=null;
      closePositionPort();clearCardMark();fullscreenOwnerActivity=null;
      returnFromBackground=false;hadMountedOnPause=false;
      lifecyclePauseInProgress=false;controlledRebuildInProgress=false;ownerDayAtPause="";
    }
  }
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