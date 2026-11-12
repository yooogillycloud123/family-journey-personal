package com.juhyeon.familyjourney;

import android.app.Activity;
import android.app.Application;
import android.content.ComponentName;
import android.content.pm.PackageManager;
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
import android.view.WindowManager;
import android.graphics.PixelFormat;
import android.webkit.WebView;
import android.view.ViewTreeObserver;
import android.widget.FrameLayout;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.webkit.CookieManager;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Canvas;
import android.graphics.LinearGradient;
import android.graphics.Paint;
import android.graphics.Rect;
import android.graphics.RectF;
import android.graphics.Shader;
import android.os.Build;
import android.view.PixelCopy;
import java.lang.reflect.Field;
import android.graphics.Typeface;
import android.graphics.drawable.GradientDrawable;
import org.json.JSONObject;
import java.lang.reflect.Method;
import java.util.WeakHashMap;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.ThreadFactory;

/**
 * R407, fixes R403 REAL launcher class mismatch while reproducing the proven user sequence:
 * 1. STOP existing NAVER PC web controller (as the original Web window close button).
 * 2. START the exact original full-sized, visible PC map controller.
 * 3. Allow at least two real Android draw frames and ~0.46s visible-layout time.
 * 4. HIDE via the exact original "모아로" button's setHidden(Activity,true).
 * Throughout, an opaque MOA-style cover is kept above the browser view.
 * No cookies/credentials inspection or forced login. No changes to original account-save code.
 */
public final class MoaR391SessionPersistProvider extends ContentProvider {
  private static final String HOST="com.juhyeon.familyjourney.HostActivity";
  // Actual launcher alias targets MoaIconHost (DEX: subclasses AudioHost -> VoiceHost -> HostActivity).
  private static final String LAUNCHER_HOST="com.juhyeon.familyjourney.MoaIconHost";
  private static final String CTRL="com.juhyeon.familyjourney.MoaNaverWebProbeController";
  private static final String TAG="MOA_R431_NAV_CONTROLS";
  private static final Handler UI=new Handler(Looper.getMainLooper());
  private static final long VISIBLE_LAYOUT_MS=460L;
  private static final long REARM_COOLDOWN_MS=18000L;
  private static long lastExpiryRefreshMs=0L;
  private static final WeakHashMap<Activity, Long> REARM_AT=new WeakHashMap<>();
  private static final WeakHashMap<Activity, Integer> MONITORS=new WeakHashMap<>();
  private static final WeakHashMap<Activity, Boolean> LIVE_HOSTS=new WeakHashMap<>();
  private static int nextMonitorId=0;
  private static boolean keepaliveScheduled=false;
  private static final WeakHashMap<Activity, Long> GALLERY_REPAIR_AT=new WeakHashMap<>();
  private static final WeakHashMap<Activity, Run> RUNS=new WeakHashMap<>();
  // R427: only native MOA controller chrome, never the remote NAVER WebView DOM.
  // Retain the controller's original MOA/Stop button instances and click listeners.
  private static final WeakHashMap<Activity, Chrome> CHROME=new WeakHashMap<>();
  private static final WeakHashMap<Activity, ViewTreeObserver.OnGlobalLayoutListener> CHROME_OBSERVERS=new WeakHashMap<>();
  private static final class Chrome {
    final FrameLayout shell;
    final LinearLayout header;
    final View state;
    final View title;
    final TextView chevron;
    final TextView home;
    boolean expanded=false;
    Chrome(FrameLayout sh,LinearLayout h,View st,View ti,TextView cv,TextView hv){
      shell=sh;header=h;state=st;title=ti;chevron=cv;home=hv;
    }
  }
  private static void showChrome(Chrome c,boolean expanded){
    if(c==null)return;
    c.expanded=expanded;
    // Collapsed means map canvas begins at y=0: no 64dp dark header,
    // no 46dp diagnostic line, no transparent-but-still-occupying bar.
    c.header.setVisibility(expanded?View.VISIBLE:View.GONE);
    c.state.setVisibility(View.GONE);
    c.title.setVisibility(View.GONE); // user never needs the experiment title
    c.chevron.setText(expanded?"‹":"›");
    // The hit rectangle is larger than the visible tiny chevron.
    c.chevron.setTextColor(expanded?0xffa4326a:0xff9c6b82);
    c.chevron.setAlpha(expanded?0.95f:0.64f);
    c.home.bringToFront();
    c.chevron.bringToFront();
  }
  private static void compactNaverChrome(Activity a){
    if(!valid(a))return;
    Run ongoing=RUNS.get(a);
    // Once the opaque app mask has drawn, conceal only the controller chrome
    // even during the 460ms visible NAVER WebView warmup. The WebView itself
    // remains full-size and the user-proven start/hide sequence is untouched.
    if(ongoing!=null&&!ongoing.finished&&!ongoing.maskDrawn)return;
    try{
      Class<?> controller=Class.forName(CTRL);
      Field f=controller.getDeclaredField("shell");f.setAccessible(true);
      Object value=f.get(null);
      if(!(value instanceof FrameLayout))return;
      FrameLayout shell=(FrameLayout)value;
      if(shell.getContext()!=a||shell.getParent()==null)return;
      Chrome existing=CHROME.get(a);
      if(existing!=null&&existing.shell==shell)return;
      if(shell.getChildCount()<1||!(shell.getChildAt(0) instanceof LinearLayout))return;
      LinearLayout column=(LinearLayout)shell.getChildAt(0);
      if(column.getChildCount()<3||!(column.getChildAt(0) instanceof LinearLayout))return;
      LinearLayout header=(LinearLayout)column.getChildAt(0);
      if(header.getChildCount()<3||!(header.getChildAt(0) instanceof TextView))return;
      TextView title=(TextView)header.getChildAt(0);
      String titleText=String.valueOf(title.getText());
      if(!titleText.contains("네이버 웹 연결 실험"))return;
      View state=column.getChildAt(1);
      // R431: the old top-right 28x30dp tap target overlapped NAVER's search
      // box/voice control, and also overlapped the original Stop button when
      // expanded. Move it to the right *middle* with a full 48x54dp hit area.
      // No remote NAVER DOM or original controller native button is modified.
      TextView chevron=new TextView(a);
      chevron.setTextSize(15f); // glyph only; invisible hit area is 48x54dp
      chevron.setGravity(Gravity.CENTER);
      chevron.setBackgroundColor(0x00000000);
      chevron.setPadding(0,0,0,0);
      chevron.setClickable(true);
      chevron.setImportantForAccessibility(View.IMPORTANT_FOR_ACCESSIBILITY_YES);
      chevron.setContentDescription("네이버 웹창 메뉴 펼치기");
      FrameLayout.LayoutParams lp=new FrameLayout.LayoutParams(dp(a,48f),dp(a,54f),Gravity.CENTER_VERTICAL|Gravity.END);
      lp.rightMargin=dp(a,2f);
      shell.addView(chevron,lp);
      chevron.setElevation(dp(a,16f));

      // An independent one-tap MOA return button, styled like the already
      // proven pink floating diary Home dot. It calls the ORIGINAL native
      // setHidden(Activity,true), preserving the logged-in WebView and all
      // subsequent offscreen NAVER account-saving behavior.
      TextView home=new TextView(a);
      home.setText("⌂");
      home.setTextSize(22f);
      home.setGravity(Gravity.CENTER);
      home.setTextColor(0xffffffff);
      GradientDrawable pink=new GradientDrawable();
      pink.setShape(GradientDrawable.OVAL);
      pink.setColor(0xffcf739f);
      pink.setStroke(dp(a,1f),0xffe8b3ca);
      home.setBackground(pink);
      home.setAlpha(0.80f);
      home.setElevation(dp(a,16f));
      home.setClickable(true);
      home.setImportantForAccessibility(View.IMPORTANT_FOR_ACCESSIBILITY_YES);
      home.setContentDescription("모아로 돌아가기");
      FrameLayout.LayoutParams hp=new FrameLayout.LayoutParams(dp(a,44f),dp(a,44f),Gravity.END|Gravity.BOTTOM);
      hp.rightMargin=dp(a,12f);
      hp.bottomMargin=dp(a,92f);
      shell.addView(home,hp);
      home.setOnClickListener(v->{
        try{
          Class<?> nativeController=Class.forName(CTRL);
          JSONObject st=status(nativeController);
          if(st.optBoolean("running",false)&&!st.optBoolean("hidden",false)){
            hide(nativeController,a); // exactly original "모아로" action; never dispose()
            Log.i(TAG,"PINK_HOME_NATIVE_HIDE");
          }
        }catch(Throwable t){Log.w(TAG,"PINK_HOME_HIDE_FAILED_"+t.getClass().getSimpleName());}
      });

      Chrome chrome=new Chrome(shell,header,state,title,chevron,home);
      chevron.setOnClickListener(v->{
        showChrome(chrome,!chrome.expanded);
        chevron.setContentDescription(chrome.expanded?"네이버 웹창 메뉴 접기":"네이버 웹창 메뉴 펼치기");
        Log.i(TAG,chrome.expanded?"NAVER_MENU_EXPANDED":"NAVER_MENU_COLLAPSED");
      });
      CHROME.put(a,chrome);
      showChrome(chrome,false);
      Log.i(TAG,"NAVER_CHROME_SIDE_CONTROLS_READY");
    }catch(Throwable t){Log.w(TAG,"NAVER_CHROME_CHECK_"+t.getClass().getSimpleName());}
  }
  private static void attachChromeObserver(Activity a){
    if(!valid(a)||CHROME_OBSERVERS.containsKey(a))return;
    View decor=a.getWindow().getDecorView();
    ViewTreeObserver.OnGlobalLayoutListener observer=()->compactNaverChrome(a);
    CHROME_OBSERVERS.put(a,observer);
    try{decor.getViewTreeObserver().addOnGlobalLayoutListener(observer);}
    catch(Throwable t){CHROME_OBSERVERS.remove(a);}
  }
  private static void detachChromeObserver(Activity a){
    ViewTreeObserver.OnGlobalLayoutListener observer=CHROME_OBSERVERS.remove(a);
    if(observer==null)return;
    try{ViewTreeObserver v=a.getWindow().getDecorView().getViewTreeObserver();
      if(v.isAlive())v.removeOnGlobalLayoutListener(observer);
    }catch(Throwable ignored){}
  }

  private static final ExecutorService FLUSH=Executors.newSingleThreadExecutor(new ThreadFactory(){
    @Override public Thread newThread(Runnable r){Thread t=new Thread(r,"moa-r419-cookie-flush");t.setDaemon(true);return t;}
  });
  private static long lastFlush=-10000L;
  private static final class Run {
    final Activity activity;
    View cover, windowCover;
    boolean fromRearm=false;
    Bitmap frozenUi=null;
    WindowManager windowManager;
    boolean maskDrawn=false, openStarted=false;
    boolean attempted=false, finished=false, ownedBrowser=false;
    long startedAt;
    int observedFrames;
    int epoch;
    Run(Activity activity){this.activity=activity;}
  }
  private static boolean valid(Activity a){
    return a!=null && (HOST.equals(a.getClass().getName()) || LAUNCHER_HOST.equals(a.getClass().getName()))
      && !a.isFinishing() && !a.isDestroyed();
  }
  private static synchronized void persist(){
    long now=SystemClock.elapsedRealtime();
    if(now-lastFlush<2500L)return;
    lastFlush=now;
    FLUSH.execute(()->{try{CookieManager.getInstance().flush();}catch(Throwable t){Log.w(TAG,"COOKIE_FLUSH_FAILED");}});
  }
  private static float dp(Activity a,float value){return a.getResources().getDisplayMetrics().density*value;}
  // The existing icon settings bridge changes these real launcher aliases via
  // PackageManager; read that applied OS state instead of guessing from a
  // hardcoded pink PNG or reading private WebView cookies/localStorage.
  private static final String[] ICON_THEME_IDS={
    "A_modern_bold_pink","A_modern_bold_black","A_modern_bold_white",
    "B_slim_premium_pink","B_slim_premium_black","B_slim_premium_white",
    "Slim_minimal_glass_pink","Slim_minimal_glass_black","Slim_minimal_glass_white"
  };
  private static String appliedIconTheme(Activity a){
    try{
      PackageManager pm=a.getPackageManager();
      for(String id:ICON_THEME_IDS){
        ComponentName alias=new ComponentName(a.getPackageName(),
          "com.juhyeon.familyjourney.MoaIcon_"+id);
        if(pm.getComponentEnabledSetting(alias)==PackageManager.COMPONENT_ENABLED_STATE_ENABLED)
          return id;
      }
    }catch(Throwable t){Log.w(TAG,"THEME_ALIAS_READ_FAILED");}
    // Manifest's initially enabled launcher icon when no override was applied.
    return "A_modern_bold_pink";
  }
  private static View newCover(Activity a,Bitmap frozen){
    return new View(a){
      private final Paint p=new Paint(3);
      private final String themeId=appliedIconTheme(a);
      private final Bitmap logo=load();
      private Bitmap load(){
        try(java.io.InputStream in=a.getAssets().open("web/moa-icon-themes/"+themeId+".png")){
          return BitmapFactory.decodeStream(in);
        }catch(Throwable t){return null;}
      }
      @Override protected void onDraw(Canvas canvas){
        super.onDraw(canvas);
        float w=getWidth(),h=getHeight();if(w<=0||h<=0)return;
        p.reset();p.setAntiAlias(true);
        if(frozen!=null&&!frozen.isRecycled()){
          // PixelCopy's bitmap is in Activity-window pixel coordinates. Never scale it
          // to a separate application-panel window that may include extra system insets.
          // Draw it at the precise on-screen coordinate of the real Activity decor.
          int[] ownXY=new int[2],maskXY=new int[2];
          try{
            a.getWindow().getDecorView().getLocationOnScreen(ownXY);
            getLocationOnScreen(maskXY);
          }catch(Throwable ignored){}
          canvas.drawColor(frozen.getPixel(0,Math.min(2,frozen.getHeight()-1)));
          p.setFilterBitmap(false);
          canvas.drawBitmap(frozen,(float)(ownXY[0]-maskXY[0]),
            (float)(ownXY[1]-maskXY[1]),p);
          return;
        }
        // Match the EXISTING first-party HTML #moa-launch flex-center layout.
        // R415 used cy=0.36*h and a 180dp icon, while HTML centers the
        // 180px icon + title block at viewport center: that visibly jumped.
        int[] ownXY=new int[2],maskXY=new int[2];
        View decor=a.getWindow().getDecorView();
        try{decor.getLocationOnScreen(ownXY);getLocationOnScreen(maskXY);}
        catch(Throwable ignored){}
        float left=(float)ownXY[0]-maskXY[0];
        float top=(float)ownXY[1]-maskXY[1];
        float vw=Math.max(1f,decor.getWidth());
        float vh=Math.max(1f,decor.getHeight());
        // Match the selected first-party icon color theme, including the
        // splash background/title tones declared in moa-icon-theme-settings.css.
        boolean dark=themeId.endsWith("_black");
        boolean white=themeId.endsWith("_white");
        int[] bg=dark ? new int[]{0xff191820,0xff25212c,0xff352431} :
          white ? new int[]{0xffffffff,0xfff8f7f8,0xffefedf1} :
          new int[]{0xfffff9f5,0xfffff1eb,0xfffbd8d0};
        p.setShader(new LinearGradient(0,top,0,top+vh,bg,
          new float[]{0f,.60f,1f},Shader.TileMode.CLAMP));
        canvas.drawRect(0,0,w,h,p);p.setShader(null);
        // Preserve the native decorative wave at precisely the same position.
        p.setColor(dark?0x13ff8abc:(white?0x22dad6e3:0x19f2b0a3));
        RectF wave=new RectF(left-vw*.28f,top+vh*.81f,
                             left+vw*1.13f,top+vh*1.30f);
        canvas.drawOval(wave,p);
        float side=dp(a,180);
        float titleLine=dp(a,48);
        float total=side+dp(a,12)+dp(a,8)+titleLine;
        float startY=top+(vh-total)*.5f;
        float cx=left+vw*.5f;
        if(logo!=null){
          // IMPORTANT: preceding wave used alpha=0x19 (~10%).  Android Paint
          // retains its color/alpha for drawBitmap! R419 unintentionally made
          // the existing icon ~90% transparent. Reset to fully opaque white.
          p.setShader(null);p.setColor(0xffffffff);p.setAlpha(255);
          p.setFilterBitmap(true);
          canvas.drawBitmap(logo,new Rect(0,0,logo.getWidth(),logo.getHeight()),
             new RectF(cx-side*.5f,startY,cx+side*.5f,startY+side),p);
        }else{
          p.setColor(dark?0xff15131e:(white?0xfff2f2f2:0xfff40068));
          canvas.drawRoundRect(new RectF(cx-side*.5f,startY,cx+side*.5f,startY+side),dp(a,32),dp(a,32),p);
          p.setColor(white?0xff191820:0xffffffff);p.setTextSize(dp(a,46));p.setTypeface(Typeface.DEFAULT_BOLD);
          p.setTextAlign(Paint.Align.CENTER);canvas.drawText("MOA",cx,startY+side*.61f,p);
        }
        p.setShader(null);p.setColor(dark?0xfff8f7f8:(white?0xff181923:0xff122938));
        p.setTypeface(Typeface.create("sans-serif",Typeface.BOLD));
        p.setTextAlign(Paint.Align.CENTER);p.setTextSize(dp(a,38));
        canvas.drawText("모아",cx,startY+side+dp(a,12)+dp(a,8)+dp(a,39),p);
        p.setTypeface(Typeface.DEFAULT);p.setTextSize(dp(a,14));p.setColor(dark?0xffdbcbdb:(white?0xff575563:0xff495968));
        canvas.drawText("우리 가족의 모든 기억, 모아",cx,top+vh*.89f,p);
      }
    };
  }
  private static void attach(Run r){
    try{
      View content=r.activity.findViewById(android.R.id.content);
      if(!(content instanceof FrameLayout)){stage(r,"NO_FRAME_CONTENT");return;}
      FrameLayout root=(FrameLayout)content;
      View cover=newCover(r.activity,r.frozenUi);
      cover.setClickable(true);cover.setFocusable(false);
      cover.setElevation(dp(r.activity,1000));
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
  // A separate same-application PANEL window is above the WebView's content tree.
  // Do not start a foreground-sized NAVER renderer until this mask has been drawn.
  private static boolean attachWindowMask(Run r){
    try{
      Activity a=r.activity;
      View decor=a.getWindow().getDecorView();
      if(decor.getWindowToken()==null){stage(r,"MASK_WINDOW_NO_TOKEN");return false;}
      WindowManager wm=(WindowManager)a.getSystemService(Activity.WINDOW_SERVICE);
      View windowMask=newCover(a,r.frozenUi);windowMask.setClickable(false);
      WindowManager.LayoutParams p=new WindowManager.LayoutParams(
        -1,-1,WindowManager.LayoutParams.TYPE_APPLICATION_PANEL,
        WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE|
        WindowManager.LayoutParams.FLAG_NOT_TOUCHABLE|
        WindowManager.LayoutParams.FLAG_LAYOUT_IN_SCREEN|
        WindowManager.LayoutParams.FLAG_LAYOUT_NO_LIMITS,
        PixelFormat.OPAQUE);
      p.token=decor.getWindowToken();p.gravity=Gravity.TOP|Gravity.START;
      p.windowAnimations=0;p.setTitle(r.fromRearm?"MOA R419 exact screen freeze":"MOA R419 splash-aligned mask");
      wm.addView(windowMask,p);
      r.windowCover=windowMask;r.windowManager=wm;
      stage(r,"MASK_PANEL_ADDED");
      final ViewTreeObserver.OnPreDrawListener[] holder=new ViewTreeObserver.OnPreDrawListener[1];
      holder[0]=()->{
        try{if(windowMask.getViewTreeObserver().isAlive())windowMask.getViewTreeObserver().removeOnPreDrawListener(holder[0]);}
        catch(Throwable ignored){}
        if(!r.finished&&!r.openStarted){
          r.maskDrawn=true;
          stage(r,"MASK_DRAWN");
          UI.postDelayed(()->openOriginalBehindMask(r),40L);
        }
        return true;
      };
      windowMask.getViewTreeObserver().addOnPreDrawListener(holder[0]);
      // Fail closed rather than risking a bare NAVER window while launcher animates.
      UI.postDelayed(()->{
        if(!r.finished&&!r.maskDrawn){stage(r,"MASK_DRAW_TIMEOUT");finish(r,false);}
      },850L);
      return true;
    }catch(Throwable t){stage(r,"MASK_WINDOW_ERROR_"+t.getClass().getSimpleName());return false;}
  }
  private static void removeWindowMask(Run r){
    View mask=r.windowCover;WindowManager wm=r.windowManager;
    r.windowCover=null;r.windowManager=null;
    if(mask!=null&&wm!=null){
      try{wm.removeViewImmediate(mask);}catch(Throwable t){Log.w(TAG,"MASK_REMOVE_FAILED");}
    }
  }
  private static boolean ownAppWeb(WebView w){
    if(w==null)return false;
    String u=w.getUrl();if(u==null)return false;
    return u.startsWith("https://familyjourney.local/")||
      u.startsWith("https://appassets.androidplatform.net/")||
      u.startsWith("file:///android_asset/");
  }
  private static WebView findOwnWeb(View v){
    if(v instanceof WebView)return ownAppWeb((WebView)v)?(WebView)v:null;
    if(v instanceof ViewGroup){ViewGroup parent=(ViewGroup)v;
      for(int i=0;i<parent.getChildCount();i++){
        WebView w=findOwnWeb(parent.getChildAt(i));if(w!=null)return w;
      }
    }return null;
  }
  private static void refreshExpiryIfLive(){
    try{
      if(LIVE_HOSTS.isEmpty())return;
      Class<?> c=Class.forName(CTRL);
      JSONObject st=status(c);
      long now=SystemClock.elapsedRealtime();
      if(st.optBoolean("running",false)&&st.optBoolean("hidden",false)&&now-lastExpiryRefreshMs>60000L){
        Method m=c.getDeclaredMethod("scheduleExpiry");m.setAccessible(true);m.invoke(null);
        lastExpiryRefreshMs=now;Log.i(TAG,"SESSION_LIVE_RENEWED");
      }
    }catch(Throwable ignored){Log.w(TAG,"RENEWAL_FAILED");}
  }
  private static void keepalive(){
    if(LIVE_HOSTS.isEmpty()){keepaliveScheduled=false;return;}
    refreshExpiryIfLive();
    UI.postDelayed(()->keepalive(),65000L);
  }
  private static void startRearmWithFrozenScreen(Activity a,Run r){
    r.fromRearm=true;
    try{
      View decor=a.getWindow().getDecorView();
      final int width=decor.getWidth(),height=decor.getHeight();
      if(width<30||height<30){stage(r,"FREEZE_BAD_VIEWPORT");finish(r,false);return;}
      Bitmap snap=Bitmap.createBitmap(width,height,Bitmap.Config.ARGB_8888);
      if(Build.VERSION.SDK_INT>=26){
        PixelCopy.request(a.getWindow(),snap,result->{
          if(r.finished){snap.recycle();return;}
          if(result==PixelCopy.SUCCESS){
            r.frozenUi=snap;stage(r,"FROZEN_CURRENT_WINDOW");begin(r);
          }else{
            try{Canvas c=new Canvas(snap);decor.draw(c);r.frozenUi=snap;
              stage(r,"FROZEN_VIEW_FALLBACK");begin(r);}
            catch(Throwable t){snap.recycle();stage(r,"FREEZE_FAILED");finish(r,false);}
          }
        },UI);
        UI.postDelayed(()->{if(!r.finished&&!r.attempted&&r.frozenUi==null){
          stage(r,"FREEZE_TIMEOUT");finish(r,false);
        }},700L);
      }else{
        Canvas c=new Canvas(snap);decor.draw(c);r.frozenUi=snap;
        stage(r,"FROZEN_LEGACY_VIEW");begin(r);
      }
    }catch(Throwable t){stage(r,"FREEZE_EXCEPTION_"+t.getClass().getSimpleName());finish(r,false);}
  }
  // Preserve the advanced R227 native gallery DEX. NAVER's sibling WebView must
  // never become the MOA LocalAudio host or demote its origin trust bit.
  private static void repairGalleryOwner(Activity a){
    if(!valid(a))return;
    long now=SystemClock.elapsedRealtime();
    Long oldAt=GALLERY_REPAIR_AT.get(a);
    if(oldAt!=null&&now-oldAt<900L)return;
    GALLERY_REPAIR_AT.put(a,now);
    try{
      WebView own=findOwnWeb(a.getWindow().getDecorView());
      if(own==null||own.getUrl()==null||!own.getUrl().startsWith("https://familyjourney.local/"))return;
      Class<?> c=Class.forName("com.juhyeon.familyjourney.MoaMomentAudioHostActivity");
      if(!c.isInstance(a))return;
      Field host=c.getDeclaredField("web");host.setAccessible(true);
      Field trusted=c.getDeclaredField("trustedPage");trusted.setAccessible(true);
      Object previous=host.get(a);
      boolean wasTrusted=trusted.getBoolean(a);
      if(previous!=own||!wasTrusted){
        host.set(a,own);trusted.setBoolean(a,true);
        Log.i(TAG,previous!=own?"GALLERY_WEBVIEW_OWNER_REPAIRED":"GALLERY_OWN_ORIGIN_TRUST_REFRESHED");
      }
    }catch(Throwable t){Log.w(TAG,"GALLERY_OWNER_REPAIR_CHECK_"+t.getClass().getSimpleName());}
  }
  private static void monitor(Activity a,int id){
    if(!valid(a) || MONITORS.get(a)==null || MONITORS.get(a)!=id)return;
    Run r=RUNS.get(a);
    compactNaverChrome(a);
    repairGalleryOwner(a);
    try{
      // A living foreground/background HostActivity shares one no-network
      // heartbeat that only refreshes the existing controller expiry.
      if(r==null || r.finished){
        WebView own=findOwnWeb(a.getWindow().getDecorView());
        if(own!=null){
          own.evaluateJavascript("(function(){try{return window.__moaR411Rearm&&window.__moaR411Rearm.pending===true?'YES':'NO'}catch(e){return 'NO'}})()",value->{
            if(!valid(a)||!String.valueOf(value).contains("YES"))return;
            Run old=RUNS.get(a);
            if(old!=null&&!old.finished)return;
            long at=REARM_AT.containsKey(a)?REARM_AT.get(a):0L;
            long tick=SystemClock.elapsedRealtime();
            if(tick-at<REARM_COOLDOWN_MS)return;
            REARM_AT.put(a,tick);
            Run nr=new Run(a);RUNS.put(a,nr);
            UI.post(()->startRearmWithFrozenScreen(a,nr));
          });
        }
      }
    }catch(Throwable t){Log.w(TAG,"MONITOR_NO_STATE_"+t.getClass().getSimpleName());}
    UI.postDelayed(()->monitor(a,id),400L);
  }
  private static void stage(Run r,String value){
    Log.i(TAG,value);
    try{r.activity.getSharedPreferences("moa_r419_visual_stage",0).edit()
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
    if(good)compactNaverChrome(r.activity); // keep first visible render untouched
    removeWindowMask(r);
    removeCover(r);
    if(r.frozenUi!=null){try{r.frozenUi.recycle();}catch(Throwable ignored){}r.frozenUi=null;}
    stage(r,good?"STOP_VISIBLE_HIDE_COMPLETE":"STOP_VISIBLE_HIDE_FAILED");
  }
  private static void releaseWhenAppReady(Run r,int epoch,int attempt){
    if(r.finished||r.epoch!=epoch)return;
    if(!valid(r.activity)){finish(r,false);return;}
    if(attempt>=30){stage(r,"SPLASH_WAIT_TIMEOUT");finish(r,true);return;}
    WebView w=findOwnWeb(r.activity.getWindow().getDecorView());
    if(w==null){UI.postDelayed(()->releaseWhenAppReady(r,epoch,attempt+1),140L);return;}
    try{
      w.evaluateJavascript("(function(){try{return document.readyState==='complete'&&document.getElementById('app')&&!document.getElementById('moa-launch')?'READY':'WAIT'}catch(e){return 'WAIT'}})()",value->{
        if(r.finished||r.epoch!=epoch)return;
        if(value!=null&&value.contains("READY")){
          stage(r,"FIRST_PARTY_SPLASH_FINISHED");
          UI.postDelayed(()->finish(r,true),60L);
        }else UI.postDelayed(()->releaseWhenAppReady(r,epoch,attempt+1),140L);
      });
    }catch(Throwable t){UI.postDelayed(()->releaseWhenAppReady(r,epoch,attempt+1),140L);}
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
        // For cold launch wait until the *actual* HTML splash (#moa-launch)
        // is gone. Otherwise R415 flips between two differently aligned logos.
        // For explicit rearm, the frozen exact pixels must be released promptly.
        if(r.fromRearm)UI.postDelayed(()->finish(r,true),60L);
        else UI.postDelayed(()->releaseWhenAppReady(r,epoch,0),90L);
      }else{
        stage(r,"HIDE_NOT_CONFIRMED");finish(r,false);
      }
    }catch(Throwable t){stage(r,"HIDE_EXCEPTION_"+t.getClass().getSimpleName());finish(r,false);}
  }
  private static void begin(Run r){
    if(r.attempted||r.finished||!valid(r.activity))return;
    r.attempted=true;
    // A single top application-panel mask: no second in-content root overlay to
    // produce vertical jumping during the splash-to-app content layout.
    if(!attachWindowMask(r)){
      stage(r,"MASK_UNAVAILABLE_ABORT");finish(r,false);
    }
  }
  private static void openOriginalBehindMask(Run r){
    if(r.finished||r.openStarted||!r.maskDrawn||!valid(r.activity))return;
    r.openStarted=true;
    try{
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
      compactNaverChrome(r.activity); // fold dark header before the first visible browser frame
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
          if(valid(a)){
            LIVE_HOSTS.put(a,Boolean.TRUE);
            if(!keepaliveScheduled){keepaliveScheduled=true;UI.postDelayed(()->keepalive(),1200L);}
            Run r=new Run(a);RUNS.put(a,r);
          }
        }
        @Override public void onActivityStarted(Activity a){}
        @Override public void onActivityResumed(Activity a){
          Run r=RUNS.get(a);
          if(r!=null&&!r.attempted&&!r.finished)UI.postDelayed(()->begin(r),55L);
          if(valid(a)){
            attachChromeObserver(a);
            UI.postDelayed(()->compactNaverChrome(a),140L);
            UI.postDelayed(()->repairGalleryOwner(a),1200L);
            int next=++nextMonitorId;
            MONITORS.put(a,next);UI.postDelayed(()->monitor(a,next),650L);
          }
        }
        @Override public void onActivityPaused(Activity a){
          detachChromeObserver(a);
          MONITORS.remove(a);
          Run r=RUNS.get(a);
          if(r!=null&&!r.finished)finish(r,false);
          persist();
        }
        @Override public void onActivityStopped(Activity a){persist();}
        @Override public void onActivitySaveInstanceState(Activity a,Bundle b){}
        @Override public void onActivityDestroyed(Activity a){
          detachChromeObserver(a);CHROME.remove(a);
          MONITORS.remove(a);REARM_AT.remove(a);GALLERY_REPAIR_AT.remove(a);LIVE_HOSTS.remove(a);
          Run r=RUNS.remove(a);
          if(r!=null&&!r.finished)finish(r,false);
          // Never leave a WebView tied to a destroyed Activity; keep cookies only.
          try{Class.forName(CTRL).getMethod("dispose").invoke(null);}catch(Throwable ignored){}
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