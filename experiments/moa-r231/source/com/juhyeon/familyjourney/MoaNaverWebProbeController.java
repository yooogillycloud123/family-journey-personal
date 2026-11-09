package com.juhyeon.familyjourney;

import android.app.Activity;
import android.content.Context;
import android.graphics.Color;
import android.graphics.Typeface;
import android.os.Handler;
import android.os.Looper;
import android.os.SystemClock;
import android.view.Gravity;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.FrameLayout;
import android.widget.LinearLayout;
import android.widget.TextView;
import java.io.InputStream;
import java.io.ByteArrayOutputStream;
import java.lang.ref.WeakReference;
import org.json.JSONObject;

/**
 * R231 foreground opt-in NAVER browser capability study.
 * Not a favorites writer: never clicks NAVER, never reads login cookies,
 * usernames, passwords, DOM text or family photos. Starts only on Settings click.
 * A clipped-but-attached WebView can continue rendering while MOA is visible,
 * but this is an UNVERIFIED Android/NAVER behavior until real-device testing.
 */
public final class MoaNaverWebProbeController {
  private static final Handler MAIN=new Handler(Looper.getMainLooper());
  private static WeakReference<Activity> owner=new WeakReference<>(null);
  private static FrameLayout shell,webArea;
  private static MoaNaverWebProbeHost probe;
  private static TextView stateLabel;
  private static String state="NOT_STARTED",lastCounts="{}";
  private static boolean hidden=false;
  private static long startedAt=0;
  private static Runnable expiry;
  private MoaNaverWebProbeController(){}
  private static int dp(Activity a,float v){return Math.round(v*a.getResources().getDisplayMetrics().density);}
  public static void onHostResumed(Activity a){owner=new WeakReference<>(a);}
  public static String statusJson(){
    JSONObject j=new JSONObject();
    try{j.put("state",state);j.put("running",probe!=null);j.put("hidden",hidden);
      j.put("elapsedSec",startedAt>0?Math.max(0,(SystemClock.elapsedRealtime()-startedAt)/1000L):0);
      j.put("counts",new JSONObject(lastCounts));}catch(Exception ignored){}
    return j.toString();
  }
  public static String control(Context context,String action){
    if(!("visible".equals(action)||"hidden".equals(action)||"stop".equals(action)))return "INVALID_ACTION";
    MAIN.post(()->{
      if("stop".equals(action)){dispose();return;}
      Activity a=owner.get();
      if(a==null||a.isFinishing()||a.isDestroyed()) {state="NO_ACTIVE_MOA_HOST";return;}
      if("visible".equals(action)){if(probe==null)start(a);else setHidden(a,false);}
      else if(probe==null){state="VISIBLE_LOGIN_REQUIRED_FIRST";}
      else setHidden(a,true);
    });
    return "QUEUED_"+action.toUpperCase(java.util.Locale.ROOT);
  }
  private static TextView text(Activity a,String content,int size,int color){
    TextView t=new TextView(a);t.setText(content);t.setTextColor(color);t.setTextSize(size);
    t.setGravity(Gravity.CENTER_VERTICAL);return t;
  }
  private static void start(Activity a){
    dispose();
    View content=a.findViewById(android.R.id.content);
    if(!(content instanceof FrameLayout)){state="MOA_ROOT_NOT_FRAME";return;}
    final FrameLayout root=(FrameLayout)content;
    shell=new FrameLayout(a);shell.setBackgroundColor(0xfffaf8fc);shell.setClipChildren(true);shell.setClipToPadding(true);
    root.addView(shell,new FrameLayout.LayoutParams(-1,-1));
    LinearLayout column=new LinearLayout(a);column.setOrientation(LinearLayout.VERTICAL);
    shell.addView(column,new FrameLayout.LayoutParams(-1,-1));
    LinearLayout header=new LinearLayout(a);header.setGravity(Gravity.CENTER_VERTICAL);header.setPadding(dp(a,12),dp(a,8),dp(a,10),dp(a,8));
    header.setBackgroundColor(0xff252830);
    TextView title=text(a,"네이버 웹 연결 실험 · 읽기 전용",15,Color.WHITE);
    title.setTypeface(Typeface.DEFAULT,Typeface.BOLD);
    header.addView(title,new LinearLayout.LayoutParams(0,dp(a,48),1f));
    Button hide=new Button(a);hide.setText("모아로");hide.setAllCaps(false);
    hide.setOnClickListener(v->setHidden(a,true));
    header.addView(hide,new LinearLayout.LayoutParams(dp(a,82),dp(a,48)));
    Button stop=new Button(a);stop.setText("종료");stop.setAllCaps(false);
    stop.setOnClickListener(v->dispose());
    header.addView(stop,new LinearLayout.LayoutParams(dp(a,70),dp(a,48)));
    column.addView(header,new LinearLayout.LayoutParams(-1,dp(a,64)));
    stateLabel=text(a,"네이버에서 직접 로그인 후 '모아로'를 눌러 숨김 진단",12,0xff46424c);
    stateLabel.setPadding(dp(a,12),dp(a,5),dp(a,12),dp(a,5));
    column.addView(stateLabel,new LinearLayout.LayoutParams(-1,dp(a,46)));
    webArea=new FrameLayout(a);
    column.addView(webArea,new LinearLayout.LayoutParams(-1,0,1));
    final String script;
    try(InputStream in=a.getAssets().open("web/moa-r231-naver-frame-probe.js");ByteArrayOutputStream output=new ByteArrayOutputStream()){
      byte[] chunk=new byte[4096];int n;while((n=in.read(chunk))!=-1)output.write(chunk,0,n);
      script=output.toString("UTF-8");
    }catch(Exception e){state="SCRIPT_LOAD_FAILED";dispose();return;}
    final Activity activity=a;
    probe=new MoaNaverWebProbeHost(activity,webArea,new MoaNaverWebProbeHost.Reporter(){
      @Override public void status(String status){MAIN.post(()->{
        state=status;if(stateLabel!=null)stateLabel.setText("진단 상태: "+status);
      });}
      @Override public void counts(JSONObject counts){MAIN.post(()->{
        lastCounts=counts.toString();state="FRAME_ELEMENTS_OBSERVED_READ_ONLY";
        if(stateLabel!=null)stateLabel.setText("읽기 전용 요소 감지 · 설정에서 상세 상태 확인");
      });}
    });
    startedAt=SystemClock.elapsedRealtime();hidden=false;
    if(!probe.start(false,script)){state="WEBVIEW_INIT_FAILED";dispose();return;}
    state="VISIBLE_NAVER_WEB_LOADING";
    scheduleExpiry();
  }
  private static void scheduleExpiry(){
    if(expiry!=null)MAIN.removeCallbacks(expiry);
    // bounded experiment: one 4-minute user-consented session, not a permanent hidden browser
    expiry=()->{state="SESSION_TIME_LIMIT";dispose();};MAIN.postDelayed(expiry,4*60*1000L);
  }
  private static void setHidden(Activity a,boolean hide){
    if(shell==null||probe==null)return;
    FrameLayout.LayoutParams lp=new FrameLayout.LayoutParams(hide?dp(a,1):-1,hide?dp(a,1):-1);
    shell.setLayoutParams(lp);shell.setFocusable(!hide);shell.setClickable(!hide);
    if(hide) shell.setImportantForAccessibility(View.IMPORTANT_FOR_ACCESSIBILITY_NO_HIDE_DESCENDANTS);
    else shell.setImportantForAccessibility(View.IMPORTANT_FOR_ACCESSIBILITY_AUTO);
    probe.setHidden(hide);
    hidden=hide;state=hide?"HIDDEN_ATTACHED_PROBE_UNVERIFIED":"VISIBLE_NAVER_BROWSER";
  }
  public static void dispose(){
    if(Looper.myLooper()!=Looper.getMainLooper()){MAIN.post(MoaNaverWebProbeController::dispose);return;}
    if(expiry!=null){MAIN.removeCallbacks(expiry);expiry=null;}
    if(probe!=null){try{probe.dispose();}catch(Exception ignored){}probe=null;}
    if(shell!=null){try{ViewGroup parent=(ViewGroup)shell.getParent();if(parent!=null)parent.removeView(shell);}catch(Exception ignored){}shell=null;}
    webArea=null;stateLabel=null;hidden=false;startedAt=0;state="STOPPED";
  }
}