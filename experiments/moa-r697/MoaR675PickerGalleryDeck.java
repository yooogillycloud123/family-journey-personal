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
import android.view.Gravity;
import android.view.View;
import android.view.ViewGroup;
import android.view.MotionEvent;
import android.view.ViewConfiguration;
import android.view.VelocityTracker;
import android.animation.ValueAnimator;
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
import android.text.TextUtils;
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
public final class MoaR675PickerGalleryDeck extends ContentProvider {
  private static final String HOST="com.juhyeon.familyjourney.HostActivity";
  // Actual launcher alias targets MoaIconHost (DEX: subclasses AudioHost -> VoiceHost -> HostActivity).
  private static final String LAUNCHER_HOST="com.juhyeon.familyjourney.MoaIconHost";
  private static final String CTRL="com.juhyeon.familyjourney.MoaNaverWebProbeController";
  private static final String TAG="MOA_R459_BOTTOM_INFO";
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
  // Exact R463 deck components, activated ONLY for separate PHOTO-ADD Activity.
  // The original HostActivity remains excluded and its native owner untouched.
  private static boolean valid(Activity a){
    return a!=null&&a.getClass().getName().equals(
      "com.juhyeon.familyjourney.MoaR667NativePickerProvider$NativePickerActivity")
      && !a.isFinishing()&&!a.isDestroyed();
  }
  public static void attachPicker(Activity a){if(valid(a))ensureGalleryBottomBar(a);}
  public static void detachPicker(Activity a){r439RemoveBar(a);}

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
    final View toggle;
    final CheckBox autoShow;
    final View collapsedSymbol;
    final View infoAction;
    final View fastAction;
    final GalleryFastSwipeGlyph fastGlyph;
    LinearLayout r694Row;
    StageScrub stageScrub;
    boolean fastSwipeEnabled=false;
    final View compactCard;
    final TextView compactTime;
    final TextView compactAddress;
    final int originalInfoTop;
    final int oldBottomMargin;
    final int reservedHeight;
    boolean mapEnabled=false;
    boolean infoExpanded=false;
    GalleryActions(Object g,FrameLayout h,LinearLayout l,FrameLayout r,View mb,View mi,
       LinearLayout info,View toggle,CheckBox autoShow,View symbol,View infoAction,View card,
       TextView compactTime,TextView compactAddress,View fastAction,GalleryFastSwipeGlyph fastGlyph,int infoTop,int old,int reserve){
      gallery=g;host=h;lower=l;root=r;mapButton=mb;mapGlyph=mi;
      this.info=info;this.toggle=toggle;this.autoShow=autoShow;
      this.collapsedSymbol=symbol;this.infoAction=infoAction;this.compactCard=card;
      this.compactTime=compactTime;this.compactAddress=compactAddress;
      this.fastAction=fastAction;this.fastGlyph=fastGlyph;
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
  // R451: map-fold icon OR the in-place compact metadata panel occupies the
  // SAME top-center anchor. No independent text label, no second GPS/Nav icon.
  // The existing R435 metadata TextViews continue to receive async updates.
  private static void r451MirrorOriginalMetadata(GalleryActions entry){
    try{
      Class<?> c=entry.gallery.getClass();
      Object originalTime=r439Field(c,"r225CaptureTime").get(entry.gallery);
      Object originalAddress=r439Field(c,"r225Address").get(entry.gallery);
      if(originalTime instanceof TextView){
        CharSequence v=((TextView)originalTime).getText();
        if(!TextUtils.equals(entry.compactTime.getText(),v))entry.compactTime.setText(v);
      }
      if(originalAddress instanceof TextView){
        CharSequence v=((TextView)originalAddress).getText();
        if(!TextUtils.equals(entry.compactAddress.getText(),v))entry.compactAddress.setText(v);
      }
    }catch(Throwable t){Log.w(TAG,"GALLERY_INFO_MIRROR_"+t.getClass().getSimpleName());}
  }
  private static void r443UpdateTopInfo(Activity a,GalleryActions entry,boolean galleryChrome){
    if(entry.toggle==null||entry.toggle.getParent()!=entry.host)return;
    int y=r447TopToggleY(a,entry.host);
    int maxWidth=Math.max(dpx(a,180),entry.host.getWidth()-dpx(a,24));
    int desiredWidth=Math.min(dpx(a,322),maxWidth);
    if(entry.toggle.getLayoutParams() instanceof FrameLayout.LayoutParams){
      FrameLayout.LayoutParams lp=(FrameLayout.LayoutParams)entry.toggle.getLayoutParams();
      if(lp.topMargin!=y||lp.width!=desiredWidth||lp.height!=-2){
        lp.topMargin=y;lp.width=desiredWidth;lp.height=-2;
        entry.toggle.setLayoutParams(lp);
      }
    }
    // R459: the original metadata card stays alive but is rendered ONLY when
    // expanded, at the same R451/R455 TOP anchor. No upper folded-map button.
    if(entry.info!=null&&entry.info.getVisibility()!=View.GONE)entry.info.setVisibility(View.GONE);
    int cardVisible=galleryChrome&&entry.infoExpanded?View.VISIBLE:View.GONE;
    if(entry.compactCard.getVisibility()!=cardVisible)
      entry.compactCard.setVisibility(cardVisible);
    if(entry.infoExpanded)r451MirrorOriginalMetadata(entry);
    if(entry.toggle.getVisibility()!=cardVisible)entry.toggle.setVisibility(cardVisible);
    entry.toggle.setContentDescription("촬영 시간과 주소 정보 패널");
    // The folded map icon always remains IN THE LOWER ACTION ROW and denotes
    // the action. Checking '기본 표시' pins the visible card, so uncheck first
    // when the user wants to collapse it again.
    if(entry.collapsedSymbol!=null)entry.collapsedSymbol.setAlpha(entry.infoExpanded?1f:0.90f);
    if(entry.infoAction!=null){
      entry.infoAction.setSelected(entry.infoExpanded);
      entry.infoAction.setContentDescription(entry.infoExpanded?
        (entry.autoShow.isChecked()?"촬영정보 기본 표시 중. 접으려면 기본 표시를 해제하세요":"촬영 시간과 주소 접기"):
        "촬영 시간과 주소 펼치기");
    }
    if(cardVisible==View.VISIBLE){entry.toggle.setElevation(dpx(a,24));entry.toggle.bringToFront();}
  }
  // Folded map icon in the user-provided silhouette's simple three-panel style.
  // Drawn natively so no new image assets / package resources / license are needed.
  private static final class GalleryFoldMapGlyph extends View {
    final Paint pen=new Paint(Paint.ANTI_ALIAS_FLAG);
    GalleryFoldMapGlyph(Activity a){super(a);setImportantForAccessibility(View.IMPORTANT_FOR_ACCESSIBILITY_NO);setWillNotDraw(false);}
    @Override protected void onDraw(Canvas c){
      super.onDraw(c);
      // R455: keep the 42x36dp tap surface and same-anchor compact card,
      // but cap the DRAWN three-fold map glyph at ~20dp, matching the
      // R443/R451 bottom Share glyph (~21dp). Do not resize the hitbox.
      float maxGlyphPx=18f*getResources().getDisplayMetrics().density;
      float scale=Math.min(Math.min(getWidth(),getHeight()),maxGlyphPx)/35f;
      c.save();c.translate((getWidth()-35f*scale)*.5f,(getHeight()-35f*scale)*.5f);c.scale(scale,scale);
      pen.setColor(0xffe5e6e9);pen.setStyle(Paint.Style.FILL);
      Path p=new Path();p.moveTo(4,10);p.lineTo(13,4);p.lineTo(13,26);p.lineTo(4,32);p.close();c.drawPath(p,pen);
      p.reset();p.moveTo(15,4);p.lineTo(23,10);p.lineTo(23,32);p.lineTo(15,26);p.close();c.drawPath(p,pen);
      p.reset();p.moveTo(25,10);p.lineTo(32,4);p.lineTo(32,26);p.lineTo(25,32);p.close();c.drawPath(p,pen);
      c.restore();
    }
  }
  private static TextView r451CompactText(Activity a,float sp,int color,int maxLines){
    TextView v=new TextView(a);v.setTextSize(sp);v.setTextColor(color);
    v.setMaxLines(maxLines);v.setEllipsize(TextUtils.TruncateAt.END);
    v.setIncludeFontPadding(false);v.setGravity(Gravity.CENTER_VERTICAL);
    return v;
  }
  // R463: visual-only bidirectional double-chevron action. The icon is as
  // compact as the existing 21dp Share/Map controls, not a fourth large glyph.
  private static final class GalleryFastSwipeGlyph extends View {
    private final Paint paint=new Paint(Paint.ANTI_ALIAS_FLAG);
    private boolean active=false;
    GalleryFastSwipeGlyph(Activity a){super(a);setWillNotDraw(false);}
    void setActive(boolean enabled){active=enabled;invalidate();}
    @Override protected void onDraw(Canvas c){
      super.onDraw(c);
      float scale=Math.min(getWidth(),getHeight())/26f;
      c.save();c.translate((getWidth()-26f*scale)*.5f,(getHeight()-26f*scale)*.5f);
      c.scale(scale,scale);
      paint.setColor(active?0xfffaf4f9:0xffa0a3ad);
      paint.setStrokeWidth(2.35f);paint.setStyle(Paint.Style.STROKE);
      paint.setStrokeJoin(Paint.Join.ROUND);paint.setStrokeCap(Paint.Cap.ROUND);
      c.drawLine(5,6,12,13,paint);c.drawLine(12,13,5,20,paint);
      c.drawLine(14,6,21,13,paint);c.drawLine(21,13,14,20,paint);
      if(active){paint.setStyle(Paint.Style.FILL);c.drawCircle(13,24,1.35f,paint);}
      c.restore();
    }
  }

  // R463 uses the SAME R203 fractional media index and Android OverScroller
  // that already power the fast bottom filmstrip. It does not invent a second
  // gallery/navigation engine, and it never touches R435's classes6.dex.
  // The native original SwipeHandler remains installed on its original View.
  // We mount a distinct overlay ONLY in user-selected fast mode; OFF removes it.
  private static final class StageScrub implements View.OnTouchListener {
    final GalleryActions entry;
    final Object gallery;
    final Class<?> type;
    final FrameLayout stage;
    final View originalTouch;
    final View overlay;
    final Method present;
    final Method release;
    final Method cancelFling;
    final Method teardown;
    final Field indexField;
    final Field zoomField;
    final Field railBrowsingField;
    final Field motionField;
    final int slop;
    final float stride;
    float downX,downY,startIndex,currentIndex;
    long downTime;
    VelocityTracker velocity;
    boolean delegated=false,scrubbing=false;
    StageScrub(Activity a,GalleryActions e) throws Exception {
      entry=e;gallery=e.gallery;type=gallery.getClass();
      Object stageObj=r439Field(type,"stage").get(gallery);
      if(!(stageObj instanceof FrameLayout))throw new IllegalStateException("No native Gallery stage");
      stage=(FrameLayout)stageObj;
      if(stage.getChildCount()<4)throw new IllegalStateException("Gallery stage hierarchy changed");
      // R227/R435 Gallery stage is three media pages + final transparent
      // SwipeHandler View. Fail closed rather than intercept unrelated controls.
      View found=stage.getChildAt(stage.getChildCount()-1);
      if(found==null||found.getClass()!=View.class)throw new IllegalStateException("Native SwipeHandler target changed");
      originalTouch=found;
      present=type.getDeclaredMethod("r203Present",float.class);present.setAccessible(true);
      release=type.getDeclaredMethod("r203ReleaseWithVelocity",float.class,float.class,float.class);release.setAccessible(true);
      cancelFling=type.getDeclaredMethod("r203CancelFling");cancelFling.setAccessible(true);
      teardown=type.getDeclaredMethod("teardownPlayer");teardown.setAccessible(true);
      indexField=r439Field(type,"index");zoomField=r439Field(type,"photoZoom");
      railBrowsingField=r439Field(type,"browsingRail");motionField=r439Field(type,"motion");
      stride=Math.max(1f,dpx(a,44));
      slop=Math.max(dpx(a,7),ViewConfiguration.get(a).getScaledTouchSlop());
      overlay=new View(a);overlay.setBackgroundColor(0x00000000);
      overlay.setImportantForAccessibility(View.IMPORTANT_FOR_ACCESSIBILITY_NO);
      overlay.setOnTouchListener(this);
      stage.addView(overlay,new FrameLayout.LayoutParams(-1,-1));
      overlay.bringToFront();
    }
    boolean attached(){return overlay.getParent()==stage;}
    void destroy(){
      recycleVelocity();
      if(scrubbing)try{release.invoke(gallery,currentIndex,0f,1f);}catch(Throwable ignored){}
      if(overlay.getParent()==stage)stage.removeView(overlay);
      scrubbing=false;delegated=false;
    }
    void recycleVelocity(){if(velocity!=null){velocity.recycle();velocity=null;}}
    void deliverDown(){
      MotionEvent down=MotionEvent.obtain(downTime,downTime,MotionEvent.ACTION_DOWN,downX,downY,0);
      try{originalTouch.dispatchTouchEvent(down);}finally{down.recycle();}
      delegated=true;
    }
    void deliver(MotionEvent e){originalTouch.dispatchTouchEvent(e);}
    void beginScrub() throws Exception {
      cancelFling.invoke(gallery);
      Object motion=motionField.get(gallery);
      if(motion instanceof ValueAnimator){motionField.set(gallery,null);((ValueAnimator)motion).cancel();}
      // Same media/video lifecycle used by original bottom GalleryRail when
      // the user actually begins a multi-item horizontal drag.
      teardown.invoke(gallery);
      railBrowsingField.setBoolean(gallery,true);
      scrubbing=true;
    }
    void scrubTo(float x) throws Exception {
      currentIndex=startIndex-(x-downX)/stride;
      present.invoke(gallery,currentIndex);
    }
    void releaseScrub(float vx) throws Exception {
      // Original native OverScroller handles momentum, photo/video fractions,
      // thumbnail sync, prefetch and final video preparation.
      release.invoke(gallery,currentIndex,vx,1f);
      scrubbing=false;
    }
    @Override public boolean onTouch(View v,MotionEvent ev){
      if(!entry.fastSwipeEnabled||!attached())return false;
      try{
        if(!r439Field(type,"open").getBoolean(gallery))return false;
        switch(ev.getActionMasked()){
          case MotionEvent.ACTION_DOWN:
            recycleVelocity();velocity=VelocityTracker.obtain();velocity.addMovement(ev);
            downTime=ev.getDownTime();downX=ev.getX();downY=ev.getY();
            startIndex=indexField.getInt(gallery);currentIndex=startIndex;
            delegated=false;scrubbing=false;
            // Existing photo pinch/zoom retains its original handler.
            if(zoomField.getFloat(gallery)>1.01f)deliverDown();
            return true;
          case MotionEvent.ACTION_POINTER_DOWN:
            if(scrubbing){releaseScrub(0f);}
            if(!delegated)deliverDown();
            deliver(ev);return true;
          case MotionEvent.ACTION_MOVE:
            if(velocity!=null)velocity.addMovement(ev);
            if(delegated){deliver(ev);return true;}
            if(ev.getPointerCount()!=1){deliverDown();deliver(ev);return true;}
            float dx=ev.getX()-downX,dy=ev.getY()-downY;
            if(!scrubbing){
              if(Math.abs(dy)>slop&&Math.abs(dy)>Math.abs(dx)*1.12f){
                deliverDown();deliver(ev);return true;
              }
              if(Math.abs(dx)<slop||Math.abs(dx)<Math.abs(dy)*1.12f)return true;
              beginScrub();
            }
            scrubTo(ev.getX());return true;
          case MotionEvent.ACTION_UP:
            if(velocity!=null)velocity.addMovement(ev);
            if(delegated){deliver(ev);recycleVelocity();return true;}
            if(scrubbing){
              scrubTo(ev.getX());float vx=0f;
              if(velocity!=null){velocity.computeCurrentVelocity(1000,12000f);vx=velocity.getXVelocity();}
              releaseScrub(vx);
            }else{deliverDown();deliver(ev);} // taps, photo double-tap, video controls
            recycleVelocity();return true;
          case MotionEvent.ACTION_POINTER_UP:
            if(delegated)deliver(ev);
            return true;
          case MotionEvent.ACTION_CANCEL:
            if(delegated)deliver(ev);
            if(scrubbing)releaseScrub(0f);
            recycleVelocity();return true;
          default:
            if(delegated)deliver(ev);
            return true;
        }
      }catch(Throwable error){
        Log.w(TAG,"FAST_STAGE_TOUCH_"+error.getClass().getSimpleName());
        try{if(scrubbing)releaseScrub(0f);}catch(Throwable ignored){}
        recycleVelocity();return true;
      }
    }
  }
  private static boolean r463EnableFastSwipe(Activity a,GalleryActions entry){
    try{
      if(entry.stageScrub!=null&&entry.stageScrub.attached())return true;
      entry.stageScrub=new StageScrub(a,entry);
      return true;
    }catch(Throwable t){Log.w(TAG,"FAST_STAGE_ATTACH_"+t.getClass().getSimpleName());return false;}
  }
  private static void r463DisableFastSwipe(GalleryActions entry){
    if(entry.stageScrub!=null){entry.stageScrub.destroy();entry.stageScrub=null;}
    entry.fastSwipeEnabled=false;
    if(entry.fastAction!=null){entry.fastAction.setSelected(false);
      entry.fastAction.setContentDescription("상단 빠른 연속 넘기기 켜기");}
    if(entry.fastGlyph!=null)entry.fastGlyph.setActive(false);
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
