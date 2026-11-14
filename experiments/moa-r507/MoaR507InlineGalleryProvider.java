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
import android.view.ViewTreeObserver;
import android.view.animation.LinearInterpolator;
import android.widget.LinearLayout;
import android.window.OnBackInvokedCallback;
import android.window.OnBackInvokedDispatcher;
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
  // R519 avoids reapplying image/video transforms every native layout tick.
  private long lastFillAt;
  private String lastFillId="";
  private int lastIndex = -1;
  private int lastX = Integer.MIN_VALUE, lastY = Integer.MIN_VALUE;
  private int lastW = -1, lastH = -1;
  private FrameLayout nativeHost;
  private TextView coverStar;
  private TextView railToggle;
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
  private OnBackInvokedCallback inlineBack;
  private Activity backOwner;

  private static final String SNAPSHOT =
      "(function(){try{" +
      "var d=window.MoaR469SimpleDiary,s=d&&d.readOnlyStatus&&d.readOnlyStatus();"+
      "var e=document.querySelector('#moa-r469-root .moa-r469-stage');"+
      "if(!s||!s.active||s.page!=='day'||window.__moaR507NativePending!==true||!e) return JSON.stringify({active:false});"+
      "var r=e.getBoundingClientRect();"+
      "return JSON.stringify({active:true,x:r.left,y:r.top,w:r.width,h:r.height,vw:innerWidth,vh:innerHeight,cover:(window.__moaR507CoverId||'')});"+
      "}catch(e){return JSON.stringify({active:false});}})()";

  private static final String ARM_SNAPSHOT =
      "(function(){try{"+
      "var d=window.MoaR469SimpleDiary,s=d&&d.readOnlyStatus&&d.readOnlyStatus();"+
      "var e=document.querySelector('#moa-r469-root .moa-r469-stage');"+
      "if(!window.__moaR511InlineArm||!s||!s.active||s.page!=='day'||!e)return JSON.stringify({active:false});"+
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
      } finally {main.postDelayed(this, ownsGallery?32:resumed?160:850);}
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
      if(ownsGallery) {
        // R515: unexpected native-close while the day is active gets one guarded
        // native re-open. Intentional JS close clears pending first, so never
        // revive a Gallery after the user navigates away.
        clearCardMark();
        web.evaluateJavascript("if(window.__moaR507NativePending&&window.__moaR515RecoverInline)window.__moaR515RecoverInline();else window.__moaR507NativeMounted&&window.__moaR507NativeMounted(false);",null);
      }
      if(android.os.SystemClock.uptimeMillis()-lastHello>1000){
        lastHello=android.os.SystemClock.uptimeMillis();
        web.evaluateJavascript("window.__moaR507BridgeReady=true;",null);
      }
      maybeArm(a,web);
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
                if(!st.optBoolean("day")||!st.optBoolean("pending")){invokeClose(gallery);clearCardMark();}
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
        if(snapshotFailures>15 && ownsGallery){snapshotFailures=0;
          web.evaluateJavascript("window.__moaR515RecoverInline&&window.__moaR515RecoverInline();",null);
        }
      }
    });}catch(Throwable e){processing=false;}
  }
  private void maybeArm(Activity a,WebView web){
    if(ownsGallery||inlineArmed||processing)return;
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
        armRoot=root;armedState=state;inlineArmed=true;
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
        // Hide the original fullscreen host before its FIRST draw, even if
        // Gallery.open() has not reached its final open=true assignment.
        host.setAlpha(0f);
        if(!galleryOpen(gallery))return true;
        // UI thread before the first completed frame: resize in-card first.
        try{attachCard(a,web,gallery,armedState);}catch(Throwable ignored){}
        disarm();
        host.postDelayed(()->{
          // Never leave a half-transparent TextureView when the user scrolls
          // during an entrance fade (position translation does not own alpha).
          if(host==nativeHost&&galleryOpen(gallery)&&ownsGallery)
            host.setAlpha(1f);
        },16);
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
    if(railToggle!=null && railToggle.getParent() instanceof ViewGroup)
      ((ViewGroup)railToggle.getParent()).removeView(railToggle);
    if(coverStar!=null && coverStar.getParent() instanceof ViewGroup)
      ((ViewGroup)coverStar.getParent()).removeView(coverStar);
    if(inlineBack!=null && backOwner!=null && Build.VERSION.SDK_INT>=33)try{
      backOwner.getOnBackInvokedDispatcher().unregisterOnBackInvokedCallback(inlineBack);
    }catch(Throwable ignored){}
    inlineBack=null;backOwner=null;
    if(nativeHost!=null)try{nativeHost.animate().cancel();nativeHost.setTranslationX(0);nativeHost.setTranslationY(0);nativeHost.setAlpha(1f);}catch(Throwable ignored){}
    coverStar=null;railToggle=null;railView=null;railToggleInstalled=false;nativeHost=null;galleryRef=null;nativeLower=null;actionCapsule=null;actionDeck=null;
    compactDone=false;ownsGallery=false;lastIndex=-1;lastW=lastH=-1;inactiveAt=0;lastFillAt=0;lastFillId="";
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
      GradientDrawable round=new GradientDrawable();round.setColor(Color.BLACK);round.setCornerRadius(dp(a,23));
      host.setBackground(round);host.setClipToOutline(true);host.setClipChildren(true);host.setClipToPadding(true);
      installInlineBack(a,web);
      web.evaluateJavascript("window.__moaR507NativeMounted&&window.__moaR507NativeMounted(true);",null);
    }
    if(w!=lastW||h!=lastH){
      // Size changes are infrequent. Never continuously relayout a live TextureView.
      FrameLayout.LayoutParams lp=new FrameLayout.LayoutParams(w,h,Gravity.TOP|Gravity.LEFT);
      lp.leftMargin=x;lp.topMargin=y;
      host.animate().cancel();host.setTranslationX(0f);host.setTranslationY(0f);
      host.setLayoutParams(lp);baseX=x;baseY=y;
    }else if(x!=lastX||y!=lastY){
      // R519: no lagging animator on a WebView-scrolling native sibling.
      // Move by GPU translation to the ACTUAL observed card position, without
      // 56ms easing that made Gallery feel dragged up/down behind the finger.
      float tx=x-baseX,ty=y-baseY;
      host.animate().cancel();
      host.setTranslationX(tx);host.setTranslationY(ty);
    }
    lastX=x;lastY=y;lastW=w;lastH=h;
    if(y+h<0||y>root.getHeight())host.setVisibility(View.INVISIBLE);
    else host.setVisibility(View.VISIBLE);
    compactNativeCard(a,web,host,gallery);
    final String mediaId=currentId(gallery);
    final long now=android.os.SystemClock.uptimeMillis();
    // Large Matrix/MediaPlayer queries belong to media changes, not every
    // scroll poll. Throttled retry covers a newly prepared video stream.
    if(!mediaId.equals(lastFillId)||now-lastFillAt>420L){
      fillNativeMediaCard(gallery);lastFillAt=now;lastFillId=mediaId;
    }
    syncIndex(web,gallery,s.optString("cover",""));
  }
  private void installInlineBack(Activity a,WebView web){
    if(Build.VERSION.SDK_INT<33||inlineBack!=null)return;
    try{
      // Overlay priority only during this photo-card session. Unrelated original
      // R463 fullscreen Gallery retains its own Android Back callback and behavior.
      inlineBack=()->{
        // Native Back must exit the PHOTO DAY, not merely Gallery.close() which
        // exposes the abandoned legacy web photo editor underneath.
        web.evaluateJavascript("if(window.__moaR519NativeBack)window.__moaR519NativeBack();else window.MoaR469SimpleDiary&&window.MoaR469SimpleDiary.home&&window.MoaR469SimpleDiary.home();",null);
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
      // Original R463 Gallery.updateChromeLayout() legitimately restores 208dp
      // when its own chrome toggles. Re-apply the SMALL card height only here;
      // never patch or alter the standalone Gallery's code.
      if(nativeLower!=null && nativeLower.getLayoutParams() instanceof FrameLayout.LayoutParams){
        FrameLayout.LayoutParams lp=(FrameLayout.LayoutParams)nativeLower.getLayoutParams();
        int expected=dp(a,railExpanded?137:82);
        if(lp.height!=expected){lp.height=expected;nativeLower.setLayoutParams(lp);}
      }
      return;
    }
    actionDeck=deck;actionCapsule=capsule;
    if(deck.getLayoutParams() instanceof FrameLayout.LayoutParams){
      FrameLayout.LayoutParams p=(FrameLayout.LayoutParams)deck.getLayoutParams();
      p.height=dp(a,40);deck.setLayoutParams(p);
    }
    if(capsule.getLayoutParams() instanceof FrameLayout.LayoutParams){
      FrameLayout.LayoutParams p=(FrameLayout.LayoutParams)capsule.getLayoutParams();
      p.height=dp(a,34);p.width=Math.min(Math.max(dp(a,215),host.getWidth()-dp(a,18)),dp(a,280));
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
        for(int k=0;k<group.getChildCount();k++){
          View glyph=group.getChildAt(k);glyph.setScaleX(.74f);glyph.setScaleY(.74f);
        }
      }
    }
    TextView star=new TextView(a);star.setText("☆");star.setTextSize(20);
    star.setTextColor(Color.WHITE);star.setGravity(Gravity.CENTER);
    star.setContentDescription("현재 사진을 달력 대표사진으로 지정");
    star.setTag("moa.gallery.inline.cover.r511");star.setClickable(true);star.setFocusable(true);
    star.setOnClickListener(v->{
      String id=currentId(gallery);if(id.length()==0)return;
      web.evaluateJavascript("window.MoaR469SimpleDiary&&window.MoaR469SimpleDiary.setCoverNative&&window.MoaR469SimpleDiary.setCoverNative("+JSONObject.quote(id)+");",null);
      star.setText("★");
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
    compactDone=true;
  }
  // R515 keeps the original rail/OverScroller intact. Only the visibility and
  // viewer-scoped LinearLayout heights are changed; original fullscreen Gallery
  // is never entered through this code path.
  private void installRailToggle(Activity a,LinearLayout capsule){
    if(railToggleInstalled || railView==null)return;
    // In-card ONLY: sixth icon in the existing native action deck.
    // Do not create another free-floating button covering video controls.
    TextView control=new TextView(a);
    control.setText("⌄");control.setTextSize(15f);control.setTextColor(Color.WHITE);
    control.setGravity(Gravity.CENTER);control.setClickable(true);control.setFocusable(true);
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
      railToggle.setText(expanded?"⌄":"⌃");
      railToggle.setContentDescription(expanded?"사진 목록 접기":"사진 목록 펼치기");
      railToggle.setSelected(!expanded);
    }
  }
  // Only the in-card Gallery opts into center-crop. Never upscale the bitmap
  // beyond what the original image decoder provides and never change fullscreen.
  // Full bleed necessarily trims edges when image/video and stage ratios differ.
  private void fillNativeMediaCard(Object gallery){
    Object pictures=readField(gallery,"images");
    if(pictures instanceof ImageView[]){
      for(ImageView im:(ImageView[])pictures)if(im!=null && im.getScaleType()!=ImageView.ScaleType.CENTER_CROP)
        im.setScaleType(ImageView.ScaleType.CENTER_CROP);
    }
    Object rawTexture=readField(gallery,"texture"),rawPlayer=readField(gallery,"media");
    if(!(rawTexture instanceof TextureView)||!(rawPlayer instanceof MediaPlayer))return;
    TextureView t=(TextureView)rawTexture;MediaPlayer player=(MediaPlayer)rawPlayer;
    int vw,vh;try{vw=player.getVideoWidth();vh=player.getVideoHeight();}catch(Throwable e){return;}
    if(vw<=0||vh<=0||t.getWidth()<30||t.getHeight()<30)return;
    final float width=t.getWidth(),height=t.getHeight();
    // Android R463 original FIT uses min. R515 owned card alone uses max.
    float cover=Math.max(width/vw,height/vh);
    Matrix expected=new Matrix();expected.setScale(vw*cover/width,vh*cover/height,width/2f,height/2f);
    Matrix before=new Matrix();t.getTransform(before);
    float[] x=new float[9],y=new float[9];before.getValues(x);expected.getValues(y);
    if(Math.abs(x[0]-y[0])>.003f||Math.abs(x[4]-y[4])>.003f||Math.abs(x[2]-y[2])>1f||Math.abs(x[5]-y[5])>1f)
      t.setTransform(expected);
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
