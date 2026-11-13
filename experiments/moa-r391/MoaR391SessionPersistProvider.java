package com.juhyeon.familyjourney;

import android.app.Activity;
import android.app.Application;
import android.content.ComponentName;
import android.content.pm.PackageManager;
import android.content.ContentProvider;
import android.content.SharedPreferences;
import android.content.ContentValues;
import android.database.Cursor;
import android.net.Uri;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.os.SystemClock;
import android.util.Log;
import android.util.TypedValue;
import android.text.TextUtils;
import android.view.Gravity;
import android.view.View;
import android.view.ViewGroup;
import android.view.MotionEvent;
import android.view.ViewConfiguration;
import android.view.WindowManager;
import android.graphics.PixelFormat;
import android.webkit.WebView;
import android.view.ViewTreeObserver;
import android.widget.FrameLayout;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.widget.CheckBox;
import android.widget.Button;
import android.media.MediaPlayer;
import android.graphics.drawable.GradientDrawable;
import android.view.WindowInsets;
import android.webkit.CookieManager;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Canvas;
import android.graphics.LinearGradient;
import android.graphics.Paint;
import android.graphics.Rect;
import android.graphics.RectF;
import android.graphics.Shader;
import android.graphics.Path;
import android.content.res.ColorStateList;
import android.graphics.drawable.RippleDrawable;
import android.os.Build;
import android.view.PixelCopy;
import java.lang.reflect.Field;
import android.graphics.Typeface;
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
  private static final String TAG="MOA_R451_FOLD_MAP_INFO";
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
  private static int dpx(Activity a,float units){return Math.round(dp(a,units));}
  private static final class Chrome {
    final Activity activity;
    final FrameLayout shell;
    final LinearLayout header;
    final View state;
    final View title;
    final TextView chevron;
    final TextView homeDot;
    boolean expanded=false;
    int homeX=Integer.MIN_VALUE, homeY=Integer.MIN_VALUE;
    Chrome(Activity a,FrameLayout sh,LinearLayout h,View st,View ti,TextView cv,TextView home){
      activity=a;shell=sh;header=h;state=st;title=ti;chevron=cv;homeDot=home;
    }
  }
  private static int safeMenuTop(Chrome c){
    int inset=0;
    try{
      WindowInsets w=c.shell.getRootWindowInsets();
      if(w!=null){
        if(Build.VERSION.SDK_INT>=30)inset=w.getInsets(WindowInsets.Type.statusBars()).top;
        else inset=w.getSystemWindowInsetTop();
      }
    }catch(Throwable ignored){}
    // R427 placed the clickable chevron in the Android top-gesture area.
    // A transparent 48dp HIT BOX is now entirely below the status bar and search strip.
    return Math.max(dpx(c.activity,70f),inset+dpx(c.activity,32f));
  }
  private static void positionChromeControls(Chrome c){
    if(c==null||c.shell.getHeight()<dpx(c.activity,150f))return;
    FrameLayout.LayoutParams arrow=(FrameLayout.LayoutParams)c.chevron.getLayoutParams();
    int top=safeMenuTop(c);
    if(arrow.topMargin!=top){arrow.topMargin=top;c.chevron.setLayoutParams(arrow);}
    // R435: never reset a manually dragged/persisted native MOA Home position
    // from the global-layout observer, which fires after almost every drag.
    positionHomeDot(c);
  }
  private static final String NAVER_HOME_PREFS="moa_r435_naver_home_position_v1";
  private static int clampInt(int value,int lo,int hi){return Math.max(lo,Math.min(hi,value));}
  private static int homeMinX(Chrome c){return dpx(c.activity,6f);}
  private static int homeMaxX(Chrome c){return Math.max(homeMinX(c),c.shell.getWidth()-dpx(c.activity,60f));}
  private static int homeMinY(Chrome c){return safeMenuTop(c)+dpx(c.activity,10f);}
  private static int homeMaxY(Chrome c){return Math.max(homeMinY(c),c.shell.getHeight()-dpx(c.activity,72f));}
  private static void positionHomeDot(Chrome c){
    if(c.homeDot==null||c.shell.getWidth()<dpx(c.activity,90f)||c.shell.getHeight()<dpx(c.activity,150f))return;
    int minX=homeMinX(c),maxX=homeMaxX(c),minY=homeMinY(c),maxY=homeMaxY(c);
    if(c.homeX==Integer.MIN_VALUE||c.homeY==Integer.MIN_VALUE){
      SharedPreferences prefs=c.activity.getSharedPreferences(NAVER_HOME_PREFS,0);
      float x=prefs.getFloat("x_ratio",-1f), y=prefs.getFloat("y_ratio",-1f);
      if(Float.isFinite(x)&&x>=0f&&x<=1f&&Float.isFinite(y)&&y>=0f&&y<=1f){
        c.homeX=minX+Math.round(x*(maxX-minX));
        c.homeY=minY+Math.round(y*(maxY-minY));
      }else{
        // Preserve original R431 home position for first-time users.
        c.homeX=dpx(c.activity,12f);
        c.homeY=Math.round(c.shell.getHeight()*0.71f);
      }
    }
    c.homeX=clampInt(c.homeX,minX,maxX);
    c.homeY=clampInt(c.homeY,minY,maxY);
    FrameLayout.LayoutParams lp=(FrameLayout.LayoutParams)c.homeDot.getLayoutParams();
    if(lp.leftMargin!=c.homeX||lp.topMargin!=c.homeY){
      lp.leftMargin=c.homeX;lp.topMargin=c.homeY;
      c.homeDot.setLayoutParams(lp);
    }
  }
  private static void rememberHomeDot(Chrome c){
    if(c.homeX==Integer.MIN_VALUE||c.shell.getWidth()<dpx(c.activity,90f))return;
    int xSpan=Math.max(1,homeMaxX(c)-homeMinX(c));
    int ySpan=Math.max(1,homeMaxY(c)-homeMinY(c));
    float x=(float)(c.homeX-homeMinX(c))/xSpan;
    float y=(float)(c.homeY-homeMinY(c))/ySpan;
    c.activity.getSharedPreferences(NAVER_HOME_PREFS,0).edit()
      .putFloat("x_ratio",Math.max(0f,Math.min(1f,x)))
      .putFloat("y_ratio",Math.max(0f,Math.min(1f,y)))
      .apply();
    Log.i(TAG,"NAVER_PINK_HOME_DRAG_SAVED");
  }
  private static void enableHomeDrag(Chrome c){
    if(c.homeDot==null)return;
    final View dot=c.homeDot;
    final float[] start={0f,0f};
    final int[] original={0,0};
    final boolean[] dragging={false};
    final int slop=ViewConfiguration.get(c.activity).getScaledTouchSlop();
    dot.setOnTouchListener((v,event)->{
      switch(event.getActionMasked()){
        case MotionEvent.ACTION_DOWN:
          positionHomeDot(c);
          if(c.homeX==Integer.MIN_VALUE)return false;
          start[0]=event.getRawX();start[1]=event.getRawY();
          original[0]=c.homeX;original[1]=c.homeY;
          dragging[0]=false;
          if(v.getParent()!=null)v.getParent().requestDisallowInterceptTouchEvent(true);
          return true;
        case MotionEvent.ACTION_MOVE:
          float dx=event.getRawX()-start[0],dy=event.getRawY()-start[1];
          if(!dragging[0]&&Math.hypot(dx,dy)>slop)dragging[0]=true;
          if(dragging[0]){
            c.homeX=clampInt(original[0]+Math.round(dx),homeMinX(c),homeMaxX(c));
            c.homeY=clampInt(original[1]+Math.round(dy),homeMinY(c),homeMaxY(c));
            positionHomeDot(c);
          }
          return true;
        case MotionEvent.ACTION_UP:
          if(dragging[0])rememberHomeDot(c);
          else v.performClick(); // short tap still hides NAVER and returns to MOA
          if(v.getParent()!=null)v.getParent().requestDisallowInterceptTouchEvent(false);
          return true;
        case MotionEvent.ACTION_CANCEL:
          if(dragging[0])rememberHomeDot(c);
          if(v.getParent()!=null)v.getParent().requestDisallowInterceptTouchEvent(false);
          return true;
        default:return true;
      }
    });
  }
  private static void showChrome(Chrome c,boolean expanded){
    if(c==null)return;
    c.expanded=expanded;
    c.state.setVisibility(View.GONE);
    c.title.setVisibility(View.GONE); // no technical header copy is shown
    c.header.setVisibility(expanded?View.VISIBLE:View.GONE);
    if(expanded){
      // Extend the original header *below* the OS system gesture/notification region.
      // Original button instances and their click listeners remain unchanged.
      LinearLayout.LayoutParams hp=(LinearLayout.LayoutParams)c.header.getLayoutParams();
      hp.height=dpx(c.activity,122f);
      c.header.setLayoutParams(hp);
      c.header.setPadding(dpx(c.activity,12f),dpx(c.activity,64f),dpx(c.activity,10f),dpx(c.activity,8f));
    }
    c.chevron.setText(expanded?"‹":"›");
    c.chevron.setTextColor(expanded?0xffc94c86:0xaa81717f);
    c.chevron.setAlpha(expanded?1f:0.66f);
    positionChromeControls(c);
    c.chevron.bringToFront();
    if(c.homeDot!=null)c.homeDot.bringToFront();
  }
  private static GradientDrawable pinkCircle(Activity a){
    GradientDrawable d=new GradientDrawable();d.setShape(GradientDrawable.OVAL);
    d.setColor(0xffcf739f);d.setStroke(Math.max(1,dpx(a,1.5f)),0xffe8b3ca);
    return d;
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
      if(existing!=null&&existing.shell==shell){positionChromeControls(existing);return;}
      if(shell.getChildCount()<1||!(shell.getChildAt(0) instanceof LinearLayout))return;
      LinearLayout column=(LinearLayout)shell.getChildAt(0);
      if(column.getChildCount()<3||!(column.getChildAt(0) instanceof LinearLayout))return;
      LinearLayout header=(LinearLayout)column.getChildAt(0);
      if(header.getChildCount()<3||!(header.getChildAt(0) instanceof TextView))return;
      TextView title=(TextView)header.getChildAt(0);
      String titleText=String.valueOf(title.getText());
      if(!titleText.contains("네이버 웹 연결 실험"))return;
      View state=column.getChildAt(1);
      TextView chevron=new TextView(a);
      chevron.setTextSize(17f);
      chevron.setGravity(Gravity.CENTER);
      chevron.setBackgroundColor(0x00000000);
      chevron.setPadding(0,0,0,0);
      chevron.setClickable(true);chevron.setFocusable(true);
      chevron.setImportantForAccessibility(View.IMPORTANT_FOR_ACCESSIBILITY_YES);
      chevron.setContentDescription("네이버 웹창 메뉴 펼치기");
      FrameLayout.LayoutParams lp=new FrameLayout.LayoutParams(dpx(a,48f),dpx(a,48f),Gravity.TOP|Gravity.END);
      lp.rightMargin=dpx(a,5f);lp.topMargin=dpx(a,70f);
      shell.addView(chevron,lp);
      chevron.setElevation(dpx(a,12f));
      // Same subdued pink home-dot visual as the first-party MOA Diary home button.
      // This lives in the app's native shell, never in NAVER page JavaScript.
      TextView home=new TextView(a);
      home.setText("");home.setGravity(Gravity.CENTER);
      home.setBackground(pinkCircle(a));home.setAlpha(0.90f);
      home.setClickable(true);home.setFocusable(true);
      home.setContentDescription("모아로 돌아가기. 네이버 지도 로그인과 세션 유지");
      FrameLayout.LayoutParams homeLp=new FrameLayout.LayoutParams(dpx(a,54f),dpx(a,54f),Gravity.TOP|Gravity.START);
      homeLp.leftMargin=dpx(a,12f);homeLp.topMargin=(int)(a.getResources().getDisplayMetrics().heightPixels*0.71f);
      shell.addView(home,homeLp);home.setElevation(dpx(a,11f));
      home.setOnClickListener(v->{
        try{hide(controller,a);Log.i(TAG,"NAVER_PINK_HOME_HIDDEN_RETURN");}
        catch(Throwable t){Log.w(TAG,"NAVER_PINK_HOME_FAILED_"+t.getClass().getSimpleName());}
      });
      Chrome chrome=new Chrome(a,shell,header,state,title,chevron,home);
      enableHomeDrag(chrome);
      home.setContentDescription("모아로 돌아가기. 드래그하여 위치 이동 가능. 탭하면 네이버 지도 숨김");
      chevron.setOnClickListener(v->{
        showChrome(chrome,!chrome.expanded);
        chevron.setContentDescription(chrome.expanded?"네이버 웹창 메뉴 접기":"네이버 웹창 메뉴 펼치기");
      });
      CHROME.put(a,chrome);
      showChrome(chrome,false); // DEFAULT: faint arrow below status bar + MOA pink home dot
      Log.i(TAG,"NAVER_CHROME_COLLAPSED_DEFAULT");
    }catch(Throwable t){Log.w(TAG,"NAVER_CHROME_CHECK_"+t.getClass().getSimpleName());}
  }
  private static void attachChromeObserver(Activity a){
    if(!valid(a)||CHROME_OBSERVERS.containsKey(a))return;
    View decor=a.getWindow().getDecorView();
    ViewTreeObserver.OnGlobalLayoutListener observer=()->{compactNaverChrome(a);ensureGalleryBottomBar(a);};
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

  // R443: Gallery-only bottom action deck and top collapsible metadata. Attach to the ACTUAL existing native
  // R435 Gallery FrameLayout. Do not replace, recompile, move or resize the
  // protected classes6.dex GalleryRail, TextureView or MediaPlayer implementation.
  // Additional actions later belong ONLY in action specs, never in lowerControls.
  private static final String GALLERY_CLASS="com.juhyeon.familyjourney.MoaNativeGallery";
  private static final int GALLERY_BAR_DP=50;
  private static final String GALLERY_INFO_PREFS="moa_r443_gallery_top_info_v1";
  private static final WeakHashMap<Activity, GalleryActions> GALLERY_BARS=new WeakHashMap<>();
  private static long galleryLastLogAt=0L;
  private static final class GalleryActions {
    final Object gallery;
    final FrameLayout host;
    final LinearLayout lower;
    final FrameLayout root;
    final View mapButton;
    final View mapGlyph;
    final LinearLayout info;
    final LinearLayout compact;
    final TextView compactTime;
    final TextView compactAddress;
    final View toggle;
    final CheckBox autoShow;
    final int originalInfoTop;
    final int oldBottomMargin;
    final int reservedHeight;
    boolean mapEnabled=false;
    boolean infoExpanded=false;
    GalleryActions(Object g,FrameLayout h,LinearLayout l,FrameLayout r,View mb,View mi,
        LinearLayout info,LinearLayout compact,TextView time,TextView address,
        View toggle,CheckBox autoShow,int infoTop,int old,int reserve){
      gallery=g;host=h;lower=l;root=r;mapButton=mb;mapGlyph=mi;
      this.info=info;this.compact=compact;this.compactTime=time;
      this.compactAddress=address;this.toggle=toggle;this.autoShow=autoShow;
      originalInfoTop=infoTop;oldBottomMargin=old;reservedHeight=reserve;
    }
  }
  // Reflection is strictly limited to known R435 original private Gallery
  // member names and methods. No MediaStore enumeration, no new GPS/URI logic.
  private static Field r439Field(Class<?> type,String name) throws Exception{
    Field field=type.getDeclaredField(name);field.setAccessible(true);return field;
  }
  private static Object r439Gallery(Activity a) throws Exception{
    for(Class<?> c=a.getClass();c!=null;c=c.getSuperclass()){
      try{Field f=c.getDeclaredField("unifiedGallery");f.setAccessible(true);
        Object g=f.get(a);
        if(g!=null&&GALLERY_CLASS.equals(g.getClass().getName()))return g;
      }catch(NoSuchFieldException ignored){}
    }
    return null;
  }
  private static void r439Call(Object gallery,String methodName){
    if(gallery==null)return;
    try{
      Method m=gallery.getClass().getDeclaredMethod(methodName);
      m.setAccessible(true);m.invoke(gallery);
    }catch(Throwable error){Log.w(TAG,"GALLERY_ACTION_"+methodName+"_"+error.getClass().getSimpleName());}
  }
  // R443: original HostActivity.onPause() closes Gallery unless
  // r227RetainForExternalMap()==true. Android Sharesheet is another Activity
  // just like the approved Naver Maps handoff; use the existing retention path.
  // No custom media transfer, no duplicate chooser, no changing Gallery DEX.
  private static void r443ShareKeepGallery(Activity a,Object g){
    try{
      Class<?> c=g.getClass();
      if(!r439Field(c,"open").getBoolean(g))return;
      Field pending=r439Field(c,"r227ExternalMapPending");
      Field wasPlaying=r439Field(c,"r227VideoWasPlaying");
      boolean playing=false;
      try{
        Object player=r439Field(c,"media").get(g);
        boolean prepared=r439Field(c,"prepared").getBoolean(g);
        if(prepared&&player instanceof MediaPlayer){
          playing=((MediaPlayer)player).isPlaying();
          if(playing)((MediaPlayer)player).pause();
        }
      }catch(Throwable mediaError){Log.w(TAG,"SHARE_PLAYER_STATE_"+mediaError.getClass().getSimpleName());}
      wasPlaying.setBoolean(g,playing);
      pending.setBoolean(g,true);
      Method shouldRetain=c.getDeclaredMethod("r227RetainForExternalMap");shouldRetain.setAccessible(true);
      if(!Boolean.TRUE.equals(shouldRetain.invoke(g))){
        pending.setBoolean(g,false);wasPlaying.setBoolean(g,false);
        Log.w(TAG,"SHARE_RETENTION_UNAVAILABLE");return;
      }
      r439Call(g,"shareOriginal");
      // If chooser did not open, clear the temporary flag while our Activity
      // remains foreground. When chooser opened, original onResume() restores it.
      UI.postDelayed(()->{
        try{
          if(a.hasWindowFocus()&&r439Field(c,"r227ExternalMapPending").getBoolean(g)){
            Method resume=c.getDeclaredMethod("r227ResumeFromExternalMap");
            resume.setAccessible(true);resume.invoke(g);
          }
        }catch(Throwable ignored){}
      },1800L);
      Log.i(TAG,"GALLERY_SHARE_CHOOSER_RETAINED");
    }catch(Throwable error){Log.w(TAG,"GALLERY_SHARE_RETAIN_FAILED_"+error.getClass().getSimpleName());}
  }

  // R447: unlike R443's TOP+4dp, keep the collapsed toggle BELOW the
  // system status bar even on fullscreen/inset-drawing Samsung devices.
  // All coordinates below are native pixels; the Gallery host can start
  // at screen y=0 or below status bar depending on Android window flags.
  private static int r447TopToggleY(Activity a,FrameLayout host){
    int hostScreenY=0;
    try{int[] p=new int[2];host.getLocationOnScreen(p);hostScreenY=p[1];}
    catch(Throwable ignored){}
    int sysTop=0;
    try{
      WindowInsets in=a.getWindow().getDecorView().getRootWindowInsets();
      if(in!=null){
        if(Build.VERSION.SDK_INT>=30)sysTop=in.getInsets(WindowInsets.Type.statusBars()).top;
        else sysTop=in.getStableInsetTop();
      }
    }catch(Throwable ignored){}
    int safe=Math.max(dpx(a,10),sysTop-hostScreenY+dpx(a,8));
    return Math.min(safe,Math.max(dpx(a,12),host.getHeight()-dpx(a,72)));
  }
  // R451: Three-fold MAP SYMBOL ONLY. No Korean '정보', chevron or capsule.
  // 44dp transparent touch zone, 28dp solid map glyph; no image asset/license.
  private static final class GalleryFoldMapIcon extends View {
    private final Paint ink=new Paint(Paint.ANTI_ALIAS_FLAG);
    GalleryFoldMapIcon(Activity a){super(a);setWillNotDraw(false);setLayerType(View.LAYER_TYPE_SOFTWARE,null);}
    @Override protected void onDraw(Canvas c){
      super.onDraw(c);
      float s=Math.min(getWidth(),getHeight())/45f;
      c.save();c.translate((getWidth()-30*s)/2f,(getHeight()-28*s)/2f);c.scale(s,s);
      ink.setStyle(Paint.Style.FILL);ink.setColor(0xfff7f7f8);
      ink.setShadowLayer(2.0f,0f,1f,0x99000000);
      Path left=new Path();
      left.moveTo(9.7f,1f);left.lineTo(9.7f,23.6f);left.lineTo(2.9f,27f);
      left.quadTo(.8f,28f,.8f,25.7f);left.lineTo(.8f,7.9f);
      left.quadTo(.8f,6.9f,1.8f,6.1f);left.close();c.drawPath(left,ink);
      Path mid=new Path();mid.moveTo(12.1f,1f);mid.lineTo(18.5f,5.2f);
      mid.lineTo(18.5f,27f);mid.lineTo(12.1f,23.1f);mid.close();c.drawPath(mid,ink);
      Path right=new Path();right.moveTo(20.9f,5.4f);right.lineTo(27.2f,.8f);
      right.quadTo(29.2f,-.6f,29.2f,2f);right.lineTo(29.2f,21.3f);
      right.quadTo(29.2f,22.6f,28f,23.5f);right.lineTo(20.9f,27f);
      right.close();c.drawPath(right,ink);c.restore();
    }
  }
  // Read existing native Gallery TextViews. Never invent an EXIF timestamp,
  // geocode an address, or change the Gallery/MediaStore/Map implementation.
  private static void r451CollectInfoText(View v,java.util.ArrayList<String> texts){
    if(v==null)return;
    if(v instanceof TextView && !(v instanceof CheckBox)){
      String t=String.valueOf(((TextView)v).getText()).trim();
      if(!t.isEmpty() && !t.equals("null") && !texts.contains(t))texts.add(t);
    }
    if(v instanceof ViewGroup){
      ViewGroup g=(ViewGroup)v;
      for(int k=0;k<g.getChildCount();k++)r451CollectInfoText(g.getChildAt(k),texts);
    }
  }
  private static void r451RefreshCompactText(GalleryActions e){
    if(e.info==null)return;
    java.util.ArrayList<String> all=new java.util.ArrayList<>();
    r451CollectInfoText(e.info,all);
    String date="",address="";
    for(String s:all){
      String t=s.replace("\n"," ").trim();
      if(t.equals("기본 표시")||t.contains("네이버지도")||t.equals("지도")||t.equals("NAVER"))continue;
      if(date.isEmpty()&&(t.contains("촬영")||t.matches(".*[12][0-9]{3}[.\\-/][01]?[0-9].*"))){date=t;continue;}
      if(address.isEmpty()&&(t.contains("대한민국")||t.contains("주소")||t.contains("위치")||t.matches(".*[가-힣]+(시|군|구|동|읍|면|로|길)\\s.*"))){address=t;continue;}
    }
    // Some Gallery builds expose just the two top-level TextViews with no label.
    for(String s:all){
      if(date.isEmpty()){date=s;continue;}
      if(address.isEmpty()&&!s.equals(date)&&!s.contains("네이버")&&!s.equals("지도")){address=s;break;}
    }
    if(!date.contentEquals(e.compactTime.getText()))e.compactTime.setText(date);
    if(!address.contentEquals(e.compactAddress.getText()))e.compactAddress.setText(address);
    // Omit address row rather than an invented location when GPS is unavailable.
    e.compactAddress.setVisibility(address.isEmpty()?View.GONE:View.VISIBLE);
  }
  private static void r443UpdateTopInfo(Activity a,GalleryActions entry,boolean galleryChrome){
    if(entry.toggle==null||entry.toggle.getParent()!=entry.host)return;
    final int toggleTop=r447TopToggleY(a,entry.host);
    if(entry.toggle.getLayoutParams() instanceof FrameLayout.LayoutParams){
      FrameLayout.LayoutParams lp=(FrameLayout.LayoutParams)entry.toggle.getLayoutParams();
      if(lp.topMargin!=toggleTop){lp.topMargin=toggleTop;entry.toggle.setLayoutParams(lp);}
    }
    // Original metadata remains readable by Android and retains its NAVER
    // location state, but its oversized card and original pin are NOT drawn.
    if(entry.info!=null&&entry.info.getVisibility()!=View.GONE)entry.info.setVisibility(View.GONE);
    if(entry.compact!=null){
      int desired=galleryChrome&&entry.infoExpanded?View.VISIBLE:View.GONE;
      FrameLayout.LayoutParams p=(FrameLayout.LayoutParams)entry.compact.getLayoutParams();
      int y=toggleTop+dpx(a,43);
      int width=Math.min(dpx(a,340),Math.max(dpx(a,170),entry.host.getWidth()-dpx(a,24)));
      if(p.topMargin!=y||p.width!=width){p.topMargin=y;p.width=width;entry.compact.setLayoutParams(p);}
      if(entry.compact.getVisibility()!=desired)entry.compact.setVisibility(desired);
      if(desired==View.VISIBLE){r451RefreshCompactText(entry);entry.compact.setElevation(dpx(a,23));entry.compact.bringToFront();}
    }
    int show=galleryChrome?View.VISIBLE:View.GONE;
    if(entry.toggle.getVisibility()!=show)entry.toggle.setVisibility(show);
    entry.toggle.setContentDescription(entry.infoExpanded?"촬영 시간 및 위치 정보 접기":"촬영 시간 및 위치 정보 펼치기");
    if(galleryChrome){entry.toggle.setElevation(dpx(a,24));entry.toggle.bringToFront();}
  }
  // Simple canvas strokes avoid device-font-dependent emoji/icon spacing.
  private static final class GalleryGlyph extends View {
    private final boolean map;
    private final Paint pen=new Paint(Paint.ANTI_ALIAS_FLAG);
    GalleryGlyph(Activity a,boolean isMap){super(a);map=isMap;setWillNotDraw(false);}
    @Override protected void onDraw(Canvas canvas){
      super.onDraw(canvas);
      float width=getWidth(),height=getHeight(),scale=Math.min(width,height)/26f;
      canvas.save();canvas.translate((width-26*scale)*.5f,(height-26*scale)*.5f);canvas.scale(scale,scale);
      pen.setColor(isEnabled()?0xfff4f4f5:0xff797b82);pen.setStrokeWidth(1.9f);pen.setStyle(Paint.Style.STROKE);
      pen.setStrokeCap(Paint.Cap.ROUND);pen.setStrokeJoin(Paint.Join.ROUND);
      if(map){
        Path pin=new Path();pin.moveTo(13,23.1f);pin.cubicTo(10,19.7f,5.6f,14.4f,5.6f,10.3f);
        pin.cubicTo(5.6f,6.2f,8.9f,3.1f,13,3.1f);pin.cubicTo(17.1f,3.1f,20.4f,6.2f,20.4f,10.3f);
        pin.cubicTo(20.4f,14.4f,16,19.7f,13,23.1f);pin.close();canvas.drawPath(pin,pen);
        canvas.drawCircle(13,10.3f,2.7f,pen);
      }else{
        canvas.drawLine(7.2f,13,18.5f,6,pen);canvas.drawLine(7.2f,13,18.5f,20,pen);
        pen.setStyle(Paint.Style.FILL);
        canvas.drawCircle(6.5f,13,3.0f,pen);canvas.drawCircle(19.1f,5.6f,3.0f,pen);
        canvas.drawCircle(19.1f,20.4f,3.0f,pen);
      }
      canvas.restore();
    }
  }
  private static final class GalleryActionButton {
    final LinearLayout touch;final GalleryGlyph glyph;
    GalleryActionButton(LinearLayout t,GalleryGlyph g){touch=t;glyph=g;}
  }
  private static GalleryActionButton r439Action(Activity a,String id,String label,boolean isMap,Runnable callback){
    LinearLayout button=new LinearLayout(a);button.setOrientation(LinearLayout.VERTICAL);
    button.setGravity(Gravity.CENTER);button.setPadding(0,0,0,0);
    button.setMinimumHeight(dpx(a,42));button.setClickable(true);button.setFocusable(true);
    button.setContentDescription(label);button.setTag("moa.gallery.action."+id);
    GradientDrawable rippleMask=new GradientDrawable();rippleMask.setColor(0xffffffff);rippleMask.setCornerRadius(dpx(a,18));
    button.setBackground(new RippleDrawable(ColorStateList.valueOf(0x44ffffff),null,rippleMask));
    GalleryGlyph glyph=new GalleryGlyph(a,isMap);
    button.addView(glyph,new LinearLayout.LayoutParams(dpx(a,21),dpx(a,21)));
    button.setOnClickListener(v->{if(button.isEnabled())callback.run();});
    return new GalleryActionButton(button,glyph);
  }
  private static void r439RemoveBar(Activity a){
    GalleryActions entry=GALLERY_BARS.remove(a);
    if(entry==null)return;
    try{
      if(entry.lower.getParent()==entry.host&&entry.lower.getLayoutParams() instanceof FrameLayout.LayoutParams){
        FrameLayout.LayoutParams lp=(FrameLayout.LayoutParams)entry.lower.getLayoutParams();
        if(lp.bottomMargin==entry.oldBottomMargin+entry.reservedHeight){
          lp.bottomMargin=entry.oldBottomMargin;entry.lower.setLayoutParams(lp);
        }
      }
      if(entry.compact!=null&&entry.compact.getParent() instanceof ViewGroup)
         ((ViewGroup)entry.compact.getParent()).removeView(entry.compact);
      if(entry.info!=null&&entry.info.getLayoutParams() instanceof FrameLayout.LayoutParams){
        FrameLayout.LayoutParams infoLp=(FrameLayout.LayoutParams)entry.info.getLayoutParams();
        if(infoLp.topMargin!=entry.originalInfoTop){infoLp.topMargin=entry.originalInfoTop;entry.info.setLayoutParams(infoLp);}
        entry.info.setVisibility(View.VISIBLE); // restore untouched original metadata behavior
      }
      if(entry.toggle.getParent() instanceof ViewGroup)((ViewGroup)entry.toggle.getParent()).removeView(entry.toggle);
      if(entry.root.getParent() instanceof ViewGroup)((ViewGroup)entry.root.getParent()).removeView(entry.root);
    }catch(Throwable ignored){}
  }
  private static void r439UpdateGalleryBar(Activity a,GalleryActions entry){
    if(entry==null)return;
    try{
      if(entry.host.getParent()==null||entry.root.getParent()!=entry.host){r439RemoveBar(a);return;}
      Object open=r439Field(entry.gallery.getClass(),"open").get(entry.gallery);
      if(!Boolean.TRUE.equals(open)){r439RemoveBar(a);return;}
      boolean chrome=r439Field(entry.gallery.getClass(),"chromeVisible").getBoolean(entry.gallery);
      boolean visible=chrome&&entry.lower.getVisibility()==View.VISIBLE;
      if(entry.root.getVisibility()!=(visible?View.VISIBLE:View.GONE))
        entry.root.setVisibility(visible?View.VISIBLE:View.GONE);
      Object pinObj=r439Field(entry.gallery.getClass(),"r225Naver").get(entry.gallery);
      boolean mapActive=pinObj instanceof View&&((View)pinObj).getVisibility()==View.VISIBLE;
      if(entry.mapEnabled!=mapActive){
        entry.mapEnabled=mapActive;entry.mapButton.setEnabled(mapActive);entry.mapGlyph.setEnabled(mapActive);
        entry.mapGlyph.invalidate();
        entry.mapButton.setContentDescription(mapActive?"촬영 장소 네이버 지도 열기":"GPS 위치가 없는 사진 · 지도 이용 불가");
      }
      r443UpdateTopInfo(a,entry,chrome);
      FrameLayout.LayoutParams lower=(FrameLayout.LayoutParams)entry.lower.getLayoutParams();
      int want=entry.oldBottomMargin+entry.reservedHeight;
      if(lower.bottomMargin!=want){lower.bottomMargin=want;entry.lower.setLayoutParams(lower);}
    }catch(Throwable t){Log.w(TAG,"GALLERY_BAR_REFRESH_"+t.getClass().getSimpleName());}
  }
  private static void ensureGalleryBottomBar(Activity a){
    if(!valid(a))return;
    try{
      Object g=r439Gallery(a);
      GalleryActions old=GALLERY_BARS.get(a);
      if(g==null){if(old!=null)r439RemoveBar(a);return;}
      Object opened=r439Field(g.getClass(),"open").get(g);
      if(!Boolean.TRUE.equals(opened)){if(old!=null)r439RemoveBar(a);return;}
      Object hostObj=r439Field(g.getClass(),"host").get(g);
      Object lowerObj=r439Field(g.getClass(),"lowerControls").get(g);
      if(!(hostObj instanceof FrameLayout)||!(lowerObj instanceof LinearLayout))return;
      FrameLayout host=(FrameLayout)hostObj;LinearLayout lower=(LinearLayout)lowerObj;
      if(host.getParent()==null||lower.getParent()!=host||host.getContext()!=a)return;
      if(old!=null){
        if(old.gallery==g&&old.host==host&&old.lower==lower){r439UpdateGalleryBar(a,old);return;}
        r439RemoveBar(a);
      }
      if(!(lower.getLayoutParams() instanceof FrameLayout.LayoutParams))return;
      int reserved=dpx(a,GALLERY_BAR_DP);
      FrameLayout.LayoutParams lowerLp=(FrameLayout.LayoutParams)lower.getLayoutParams();
      int initial=lowerLp.bottomMargin;
      FrameLayout overlay=new FrameLayout(a);overlay.setTag("moa.gallery.action.deck.r443");
      overlay.setBackgroundColor(0x00000000);overlay.setClipChildren(false);
      LinearLayout capsule=new LinearLayout(a);capsule.setGravity(Gravity.CENTER);capsule.setOrientation(LinearLayout.HORIZONTAL);
      GradientDrawable bg=new GradientDrawable();bg.setColor(0xf5222326);bg.setCornerRadius(dpx(a,22));
      bg.setStroke(dpx(a,.6f),0x66494a4d);capsule.setBackground(bg);
      // Extensibility: new action specs can be appended to THIS row only.
      // Existing thumbnail rail/video seek/play/mute/capture layouts stay untouched.
      GalleryActionButton share=r439Action(a,"share","공유",false,()->r443ShareKeepGallery(a,g));
      GalleryActionButton map=r439Action(a,"map","지도",true,()->r439Call(g,"r225OpenNaver"));
      // Flexible capsule width based on number of registered actions: when future
      // actions are added, widen this capsule only; the protected filmstrip is untouched.
      capsule.addView(share.touch,new LinearLayout.LayoutParams(0,dpx(a,42),1f));
      capsule.addView(map.touch,new LinearLayout.LayoutParams(0,dpx(a,42),1f));
      int count=2, width=Math.min(Math.max(dpx(a,120),host.getWidth()-dpx(a,30)),dpx(a,20+count*65));
      FrameLayout.LayoutParams capParams=new FrameLayout.LayoutParams(width,dpx(a,42),Gravity.BOTTOM|Gravity.CENTER_HORIZONTAL);
      capParams.bottomMargin=dpx(a,3);
      overlay.addView(capsule,capParams);
      FrameLayout.LayoutParams deckParams=new FrameLayout.LayoutParams(-1,reserved,Gravity.BOTTOM);
      host.addView(overlay,deckParams);
      lowerLp.bottomMargin=initial+reserved;lower.setLayoutParams(lowerLp);
      // R451: preserve original dynamic metadata as the single source of
      // truth; paint only a small independent card when the fold-map is tapped.
      LinearLayout info=null;int infoOldTop=0;
      Object infoObj=r439Field(g.getClass(),"r225Info").get(g);
      if(infoObj instanceof LinearLayout && ((View)infoObj).getParent()==host){
        info=(LinearLayout)infoObj;
        if(info.getLayoutParams() instanceof FrameLayout.LayoutParams){
          FrameLayout.LayoutParams ilp=(FrameLayout.LayoutParams)info.getLayoutParams();
          infoOldTop=ilp.topMargin;
        }
      }
      GalleryFoldMapIcon toggle=new GalleryFoldMapIcon(a);
      toggle.setClickable(true);toggle.setFocusable(true);
      toggle.setContentDescription("촬영 시간 및 위치 정보 펼치기");
      toggle.setTag("moa.gallery.top.fold.map.r451");
      FrameLayout.LayoutParams topLp=new FrameLayout.LayoutParams(dpx(a,44),dpx(a,44),Gravity.TOP|Gravity.CENTER_HORIZONTAL);
      topLp.topMargin=r447TopToggleY(a,host);
      host.addView(toggle,topLp);toggle.setElevation(dpx(a,24));
      LinearLayout compact=new LinearLayout(a);
      compact.setOrientation(LinearLayout.VERTICAL);compact.setGravity(Gravity.CENTER_VERTICAL);
      compact.setPadding(dpx(a,12),dpx(a,7),dpx(a,12),dpx(a,8));
      compact.setTag("moa.gallery.top.compact.info.r451");
      GradientDrawable card=new GradientDrawable();
      card.setColor(0xdc1d1f23);card.setCornerRadius(dpx(a,13));
      card.setStroke(dpx(a,.5f),0x556a6b72);compact.setBackground(card);
      LinearLayout row=new LinearLayout(a);row.setOrientation(LinearLayout.HORIZONTAL);
      row.setGravity(Gravity.CENTER_VERTICAL);
      TextView time=new TextView(a);time.setTextSize(12f);time.setTextColor(0xfff3f3f5);
      time.setSingleLine(true);time.setEllipsize(TextUtils.TruncateAt.END);
      if(Build.VERSION.SDK_INT>=26)time.setAutoSizeTextTypeUniformWithConfiguration(9,12,1,TypedValue.COMPLEX_UNIT_SP);
      row.addView(time,new LinearLayout.LayoutParams(0,-2,1f));
      CheckBox always=new CheckBox(a);
      always.setText("기본 표시");always.setTextSize(10f);always.setTextColor(0xffe2d7de);
      always.setButtonTintList(ColorStateList.valueOf(0xffcda7bf));
      always.setPadding(dpx(a,2),0,0,0);always.setMinWidth(0);always.setMinimumWidth(0);
      always.setContentDescription("다음 갤러리 열 때 촬영 정보를 기본 표시");
      row.addView(always,new LinearLayout.LayoutParams(-2,dpx(a,29)));
      compact.addView(row,new LinearLayout.LayoutParams(-1,-2));
      TextView address=new TextView(a);address.setTextSize(11f);
      address.setTextColor(0xffdedee2);address.setMaxLines(2);
      address.setEllipsize(TextUtils.TruncateAt.END);
      if(Build.VERSION.SDK_INT>=26)address.setAutoSizeTextTypeUniformWithConfiguration(9,11,1,TypedValue.COMPLEX_UNIT_SP);
      compact.addView(address,new LinearLayout.LayoutParams(-1,-2));
      FrameLayout.LayoutParams cardLp=new FrameLayout.LayoutParams(dpx(a,340),-2,Gravity.TOP|Gravity.CENTER_HORIZONTAL);
      cardLp.topMargin=topLp.topMargin+dpx(a,43);
      host.addView(compact,cardLp);compact.setElevation(dpx(a,23));
      boolean auto=a.getSharedPreferences(GALLERY_INFO_PREFS,0).getBoolean("show_on_open",false);
      always.setChecked(auto);
      GalleryActions entry=new GalleryActions(g,host,lower,overlay,map.touch,map.glyph,
          info,compact,time,address,toggle,always,infoOldTop,initial,reserved);
      entry.infoExpanded=auto;
      toggle.setOnClickListener(v->{entry.infoExpanded=!entry.infoExpanded;r443UpdateTopInfo(a,entry,true);});
      // When NOT pinned, tapping the contents itself also collapses it.
      // When pinned, content taps do nothing; the checkbox remains interactive.
      compact.setClickable(true);
      compact.setOnClickListener(v->{if(!always.isChecked()){entry.infoExpanded=false;r443UpdateTopInfo(a,entry,true);}});
      always.setOnCheckedChangeListener((buttonView,checked)->{
        a.getSharedPreferences(GALLERY_INFO_PREFS,0).edit().putBoolean("show_on_open",checked).apply();
      });

      GALLERY_BARS.put(a,entry);
      r439UpdateGalleryBar(a,entry);
      // Re-anchor the existing video volume bubble to its original mute button
      // after moving the entire ORIGINAL lowerControls block up, not its children.
      host.post(()->{try{Method m=g.getClass().getDeclaredMethod("anchorVolumeBubble");m.setAccessible(true);m.invoke(g);}catch(Throwable ignored){}});
      Log.i(TAG,"GALLERY_ACTION_DECK_ATTACHED");
    }catch(Throwable t){
      long now=SystemClock.elapsedRealtime();
      if(now-galleryLastLogAt>3500L){galleryLastLogAt=now;
        Log.w(TAG,"GALLERY_BAR_ATTACH_"+t.getClass().getSimpleName());}
    }
  }

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
    ensureGalleryBottomBar(a);
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
            UI.postDelayed(()->ensureGalleryBottomBar(a),200L);
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
          detachChromeObserver(a);CHROME.remove(a);r439RemoveBar(a);
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