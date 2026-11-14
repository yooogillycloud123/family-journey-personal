package com.juhyeon.familyjourney;

import android.app.Activity;
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
  // R555: native original R227 onPause closes Gallery when its retention flag
  // is absent. A regular onActivityPaused callback runs TOO LATE to prevent it.
  private Object prePausedRetainedGallery;
  private Activity prePausedOwnerActivity;
  private long prePauseRetainAt=0L;
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
      double exactX=wpos[0]-rpos[0]+dx*sx,exactY=wpos[1]-rpos[1]+dy*sy;
      int ix=rounded(exactX),iy=rounded(exactY);
      int iw=rounded(dw*sx),ih=rounded(dh*sy);
      // Do not trigger MediaPlayer/TextureView re-layout in a position frame.
      if(lastW<0||Math.abs(iw-lastW)>dp(foreground,8)||
          Math.abs(ih-lastH)>dp(foreground,8))return;
      // Float translations preserve CSS fractional scroll positions; the old
      // rounded integer displacement visibly toggled between adjacent pixels.
      nativeHost.setTranslationX((float)(exactX-baseX));
      nativeHost.setTranslationY((float)(exactY-baseY));
      nativeHost.setVisibility(exactY+ih<0||exactY>root.getHeight()?View.INVISIBLE:View.VISIBLE);
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
      // On activity return the original renderer can lose its SurfaceTexture
      // without a user Back. Let the guarded resume transaction restore it;
      // do not interpret this lifecycle gap as intentional day exit.
      if(ownsGallery && !fullNativeOpen &&
          (returnFromBackground || android.os.SystemClock.uptimeMillis()<returnCloseGuardUntil))return;
      ensurePositionChannel(web);
      if(ownsGallery) {
        // R551: an isOpen=false observation may be a media transition, external
        // Activity return, or an old host being retired. It is NOT evidence of
        // the user's Back gesture. The overlay Back callback explicitly exits.
        long now=android.os.SystemClock.uptimeMillis();
        if(nativeCloseDetectedAt==0L){nativeCloseDetectedAt=now;return;}
        if(now-nativeCloseDetectedAt<380L)return;
        final int closedToken=ownedDayToken;
        final Activity owner=a;
        final Object oldGallery=galleryRef;
        nativeCloseDetectedAt=now;
        web.evaluateJavascript("(function(){try{var d=window.MoaR469SimpleDiary,"+
          "s=d&&d.readOnlyStatus&&d.readOnlyStatus();return JSON.stringify({day:!!("+
          "s&&s.active&&s.page==='day'),pending:!!window.__moaR507NativePending,"+
          "token:window.__moaR527DayToken||0,full:!!(window.__moaR539AdvancedActive&&"+
          "window.__moaR539AdvancedActive())});}catch(e){return '{}'}})()",raw->{
            if(!resumed||foreground!=owner||!ownsGallery||galleryRef!=oldGallery||
                galleryOpen(readField(owner,"unifiedGallery")))return;
            try{
              Object data=new JSONTokener(raw).nextValue();
              if(!(data instanceof String))return;
              JSONObject state=new JSONObject((String)data);
              boolean sameDay=state.optBoolean("day")&&state.optBoolean("pending")&&
                  state.optInt("token",0)==closedToken&&!state.optBoolean("full");
              clearCardMark();
              if(sameDay){
                // A lost native renderer is repaired as a NATIVE renderer only.
                // It must never invoke the old Web Gallery or exit the day.
                web.evaluateJavascript("window.__moaR551NativeLost&&"+
                  "window.__moaR551NativeLost("+closedToken+");",null);
              }
            }catch(Throwable ignored){}
          });
        return;
      }
      if(android.os.SystemClock.uptimeMillis()-lastHello>1000){
        lastHello=android.os.SystemClock.uptimeMillis();
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
  private void clearCardMark(){
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
    if(inlineBack!=null && backOwner!=null && Build.VERSION.SDK_INT>=33)try{
      backOwner.getOnBackInvokedDispatcher().unregisterOnBackInvokedCallback(inlineBack);
    }catch(Throwable ignored){}
    inlineBack=null;backOwner=null;
    if(nativeHost!=null)try{nativeHost.animate().cancel();nativeHost.setTranslationX(0);nativeHost.setTranslationY(0);nativeHost.setAlpha(1f);}catch(Throwable ignored){}
    nativeOwnerActivity=null;
    coverStar=null;railToggle=null;advancedButton=null;railView=null;railToggleInstalled=false;nativeHost=null;galleryRef=null;nativeLower=null;actionCapsule=null;actionDeck=null;ambientPoster=null;ambientParent=null;ambientMediaId="";initialCardChromeHidden=false;
    compactDone=false;ownsGallery=false;lastIndex=-1;lastW=lastH=-1;inactiveAt=0;lastFillAt=0;lastFillId="";
    exitInFlight=false;ownedDayToken=0;nativeCloseDetectedAt=0L;lastGeometrySnapshotAt=0;lastVideoGeometryId="";fillPrepareAttempts=0;
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
    double exactX=webPos[0]-rootPos[0]+s.optDouble("x")*sx;
    double exactY=webPos[1]-rootPos[1]+s.optDouble("y")*sy;
    int x=rounded(exactX),y=rounded(exactY);
    int w=rounded(s.optDouble("w")*sx),h=rounded(s.optDouble("h")*sy);
    if(w<150||h<180)return;
    if(w>root.getWidth()+3||h>root.getHeight()+3)return;
    if(host!=nativeHost){
      final int newToken=s.optInt("token",ownedDayToken);
      clearCardMark();nativeHost=host;galleryRef=gallery;nativeOwnerActivity=a;ownsGallery=true;ownedDayToken=newToken;lastPositionMessageAt=0;
      GradientDrawable round=new GradientDrawable();round.setColor(Color.BLACK);round.setCornerRadius(dp(a,23));
      host.setBackground(round);host.setClipToOutline(true);host.setClipChildren(true);host.setClipToPadding(true);
      installInlineBack(a,web);
      web.evaluateJavascript("window.__moaR507NativeMounted&&window.__moaR507NativeMounted(true);",null);
    }
    // Preserve TextureView dimensions during video/controls updates. The prior
    // version relaid out the native host for every tiny WebView viewport wobble,
    // while R463 also recomputed its video matrix: the visible zoom yo-yo.
    boolean significantResize=(lastW<0||lastH<0||Math.abs(w-lastW)>dp(a,9)||Math.abs(h-lastH)>dp(a,9));
The requested file reference is not currently visible. Use files.search or files.list to rediscover the file, then retry with a returned ref_id or file_id.
