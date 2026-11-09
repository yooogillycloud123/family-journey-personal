package com.juhyeon.familyjourney;

import android.app.Activity;
import android.app.ActivityManager;
import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.res.Configuration;
import android.graphics.PixelFormat;
import android.graphics.Rect;
import android.graphics.drawable.GradientDrawable;
import android.os.Handler;
import android.os.Looper;
import android.provider.Settings;
import android.view.Gravity;
import android.view.HapticFeedbackConstants;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewConfiguration;
import android.view.WindowInsets;
import android.view.WindowManager;
import android.widget.FrameLayout;
import android.widget.LinearLayout;
import android.widget.TextView;
import org.json.JSONObject;

/**
 * User-initiated return to the existing MOA task from an external NAVER Maps visit.
 * Independent of camera Quick Record overlay: never modifies its preferences, state,
 * notifications, pending intents, capture services, original gallery or diary.
 * No Accessibility, Shizuku, root, ADB, login, GPS or network access.
 *
 * Preconditions: user's SYSTEM_ALERT_WINDOW grant AND explicit gallery-origin launch.
 * The window is added while MOA is still foreground, prior to launching NAVER.
 * A tap returns the EXISTING task, preserving the R227 gallery instance. We do not
 * close NAVER or manipulate the third-party app's navigation backstack.
 */
public final class MoaNaverReturnOverlay {
  private static final String PREF="moa_naver_return_overlay_v1";
  private static final Handler MAIN=new Handler(Looper.getMainLooper());
  private static Panel active;
  private MoaNaverReturnOverlay(){}
  private static SharedPreferences prefs(Context ctx){return ctx.getSharedPreferences(PREF,Context.MODE_PRIVATE);}
  private static int clamp(int n,int min,int max){return Math.max(min,Math.min(max,n));}
  private static float clampf(float n,float min,float max){return Math.max(min,Math.min(max,n));}
  private static String orientation(Context ctx){return ctx.getResources().getConfiguration().orientation==Configuration.ORIENTATION_LANDSCAPE?"landscape":"portrait";}
  private static String key(Context ctx,String name){return name+"_"+orientation(ctx);}

  public static boolean permitted(Context ctx){return Settings.canDrawOverlays(ctx);}
  public static String settingsJson(Context ctx){
    SharedPreferences p=prefs(ctx);JSONObject j=new JSONObject();
    try{
      j.put("enabled",p.getBoolean("enabled",true));j.put("allowed",permitted(ctx));
      j.put("move",p.getBoolean("move",true));j.put("resize",p.getBoolean("resize",true));
      j.put("snap",p.getBoolean("snap",false));j.put("opacity",clamp(p.getInt("opacity",92),45,100));
      j.put("style",p.getString("style","glass"));
      j.put("text",p.getBoolean("text",true));
      j.put("xStyle",p.getString("xStyle","round"));
      j.put("hideSec",clamp(p.getInt("hideSec",0),0,60));
      j.put("sizePct",clamp(p.getInt(key(ctx,"sizePct"),100),70,180));
      j.put("hasCustomDimensions",p.contains(key(ctx,"width")) && p.contains(key(ctx,"height")));
      j.put("hasPosition",p.contains(key(ctx,"x")) && p.contains(key(ctx,"y")));
      j.put("sizeWidthDp",p.getInt(key(ctx,"width"),Math.round(154*p.getInt(key(ctx,"sizePct"),100)/100f)));
      j.put("sizeHeightDp",p.getInt(key(ctx,"height"),Math.round(48*p.getInt(key(ctx,"sizePct"),100)/100f)));
      j.put("orientation",orientation(ctx));
      j.put("sessionActive",active!=null);
    }catch(Exception ignored){}
    return j.toString();
  }
  public static void updateSettings(Context ctx,String raw){
    if(raw==null||raw.length()>2048)return;
    try{
      JSONObject j=new JSONObject(raw);SharedPreferences.Editor e=prefs(ctx).edit();
      for(String n:new String[]{"enabled","move","resize","snap"})if(j.has(n))e.putBoolean(n,j.optBoolean(n,false));
      if(j.has("opacity"))e.putInt("opacity",clamp(j.optInt("opacity",92),45,100));
      if(j.has("style")){
        String st=j.optString("style","glass");e.putString("style",("glass".equals(st)||"dark".equals(st)||"light".equals(st)||"outline".equals(st))?st:"glass");
      }
      if(j.has("text"))e.putBoolean("text",j.optBoolean("text",true));
      if(j.has("xStyle")){
        String xs=j.optString("xStyle","round");e.putString("xStyle",("round".equals(xs)||"bold".equals(xs)||"plain".equals(xs))?xs:"round");
      }
      if(j.has("hideSec"))e.putInt("hideSec",clamp(j.optInt("hideSec",0),0,60));
      if(j.has("sizePct")){
        int size=clamp(j.optInt("sizePct",100),70,180);
        e.putInt(key(ctx,"sizePct"),size);
        e.remove(key(ctx,"width"));e.remove(key(ctx,"height"));
      }
      if(j.optBoolean("resetPosition",false)){
        for(String or:new String[]{"portrait","landscape"}){
          e.remove("x_"+or);e.remove("y_"+or);
        }
      }
      if(j.optBoolean("resetSize",false))for(String or:new String[]{"portrait","landscape"}){e.remove("width_"+or);e.remove("height_"+or);}
      e.apply();
      MAIN.post(()->{if(active!=null){if(!prefs(ctx).getBoolean("enabled",true))hide();else active.refresh();}});
    }catch(Exception ignored){}
  }
  public static boolean show(Activity host){
    if(Looper.myLooper()!=Looper.getMainLooper())return false; // callers on UI thread only
    hide();
    if(!permitted(host)||!prefs(host).getBoolean("enabled",true))return false;
    try{
      Panel next=new Panel(host);
      next.mount();active=next;return true;
    }catch(Exception err){hide();return false;}
  }
  public static void hide(){
    if(Looper.myLooper()!=Looper.getMainLooper()){MAIN.post(MoaNaverReturnOverlay::hide);return;}
    Panel old=active;active=null;if(old!=null)old.remove();
  }

  private static final class Panel {
    private static final int LEFT=1,RIGHT=2,TOP=4,BOTTOM=8;
    private static final int[] HANDLES={LEFT,RIGHT,TOP,BOTTOM,LEFT|TOP,RIGHT|TOP,LEFT|BOTTOM,RIGHT|BOTTOM};
    final Context ctx;final WindowManager wm;final SharedPreferences p;
    final int taskId;final PendingIntent restoreIntent;final int slop;
    FrameLayout root;LinearLayout row;TextView returnButton,closeButton;
    WindowManager.LayoutParams lp;
    final View[] grips=new View[8];
    int safeL,safeR,safeT,safeB,width,height;
    int startX,startY,startW,startH;float downX,downY;
    boolean editing=false,moved=false,longTriggered=false;
    Runnable longPress,expiry;
    void cancelExpiry(){if(expiry!=null){MAIN.removeCallbacks(expiry);expiry=null;}}
    void restartExpiry(){cancelExpiry();if(editing)return;int sec=clamp(p.getInt("hideSec",0),0,60);
      if(sec>0){expiry=()->{if(active==this&&!editing)hide();};MAIN.postDelayed(expiry,sec*1000L);}}


    Panel(Activity host){
      ctx=host.getApplicationContext();wm=(WindowManager)ctx.getSystemService(Context.WINDOW_SERVICE);
      p=prefs(ctx);taskId=host.getTaskId();slop=ViewConfiguration.get(ctx).getScaledTouchSlop();
      Intent target=new Intent(ctx,host.getClass());
      target.addFlags(Intent.FLAG_ACTIVITY_REORDER_TO_FRONT|Intent.FLAG_ACTIVITY_SINGLE_TOP|Intent.FLAG_ACTIVITY_CLEAR_TOP);
      restoreIntent=PendingIntent.getActivity(ctx,229,target,PendingIntent.FLAG_UPDATE_CURRENT|PendingIntent.FLAG_IMMUTABLE);
    }
    int dp(float x){return Math.round(x*ctx.getResources().getDisplayMetrics().density);}
    void safeBounds(){
      Rect bounds=wm.getCurrentWindowMetrics().getBounds();
      WindowInsets insets=wm.getCurrentWindowMetrics().getWindowInsets();
      android.graphics.Insets in=insets.getInsetsIgnoringVisibility(WindowInsets.Type.systemBars());
      safeL=in.left+dp(8);safeR=bounds.width()-in.right-dp(8);
      safeT=in.top+dp(8);safeB=bounds.height()-in.bottom-dp(8);
    }
    int minW(){return dp(130);}int minH(){return dp(44);}
    int maxW(){return Math.max(minW(),Math.min(dp(300),safeR-safeL));}
    int maxH(){return Math.max(minH(),Math.min(dp(108),safeB-safeT));}
    void mount(){
      safeBounds();int size=clamp(p.getInt(key(ctx,"sizePct"),100),70,180);
      width=clamp(dp(p.getInt(key(ctx,"width"),Math.round(154f*size/100f))),minW(),maxW());
      height=clamp(dp(p.getInt(key(ctx,"height"),Math.round(48f*size/100f))),minH(),maxH());
      root=new FrameLayout(ctx);root.setClipChildren(false);root.setClipToPadding(false);
      row=new LinearLayout(ctx);row.setGravity(Gravity.CENTER_VERTICAL);row.setOrientation(LinearLayout.HORIZONTAL);
      root.addView(row,new FrameLayout.LayoutParams(-1,-1));
      returnButton=new TextView(ctx);returnButton.setText("↶  MOA");returnButton.setGravity(Gravity.CENTER);
      returnButton.setTextColor(0xfff9f9fb);returnButton.setTextSize(14);returnButton.setTypeface(android.graphics.Typeface.DEFAULT,1);
      returnButton.setContentDescription("모아에서 보던 사진으로 돌아가기");
      closeButton=new TextView(ctx);closeButton.setText("×");closeButton.setGravity(Gravity.CENTER);
      closeButton.setTextColor(0xffc9cbd5);closeButton.setTextSize(19);
      closeButton.setContentDescription("모아 복귀 버튼 숨기기");
      setupTouches(root,0);setupTouches(returnButton,1);setupTouches(closeButton,2);
      addGrips();
      lp=new WindowManager.LayoutParams(width,height,WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY,
       WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE|WindowManager.LayoutParams.FLAG_NOT_TOUCH_MODAL,PixelFormat.TRANSLUCENT);
      lp.gravity=Gravity.TOP|Gravity.LEFT;
      int spanX=Math.max(1,safeR-safeL-width),spanY=Math.max(1,safeB-safeT-height);
      lp.x=safeL+Math.round(clampf(p.getFloat(key(ctx,"x"),0.05f),0,1)*spanX);
      lp.y=safeT+Math.round(clampf(p.getFloat(key(ctx,"y"),0.73f),0,1)*spanY);
      constrain();rebuild();wm.addView(root,lp);restartExpiry();
    }
    GradientDrawable background(int color,int border,int r){
      GradientDrawable d=new GradientDrawable();d.setColor(color);d.setCornerRadius(dp(r));
      d.setStroke(dp(1),border);return d;
    }
    void rebuild(){
      if(root==null)return;
      root.setAlpha(clamp(p.getInt("opacity",92),45,100)/100f);
      String style=p.getString("style","glass");
      int fill="light".equals(style)?0xf6fcfafd:("outline".equals(style)?0xbb22252e:("dark".equals(style)?0xf9131419:0xf5252830));
      int line=editing?0xffed5573:("light".equals(style)?0xffbdafbd:0x99d2d7df);
      root.setBackground(background(fill,line,25));
      boolean light="light".equals(style);
      returnButton.setText(p.getBoolean("text",true)?"↶  MOA":"↶");
      returnButton.setTextColor(light?0xff2a2530:0xfff9f9fb);
      String xs=p.getString("xStyle","round");
      closeButton.setTextColor(light?0xff605968:0xffc9cbd5);
      closeButton.setTypeface(android.graphics.Typeface.DEFAULT,"bold".equals(xs)?1:0);
      closeButton.setBackground("round".equals(xs)?background(light?0xffeae4eb:0x335e6676,0x00ffffff,18):null);
      row.removeAllViews();int xHit=dp(44);int pad=dp(5);int divider=dp(1);
      row.setPadding(pad,0,pad,0);
      int main=Math.max(dp(76),width-xHit-divider-pad*2-dp(4));
      row.addView(returnButton,new LinearLayout.LayoutParams(main,-1));
      View separator=new View(ctx);separator.setBackgroundColor(light?0x77888099:0x66bdc1cc);
      LinearLayout.LayoutParams sp=new LinearLayout.LayoutParams(divider,dp(24));sp.leftMargin=dp(2);sp.rightMargin=dp(2);row.addView(separator,sp);
      row.addView(closeButton,new LinearLayout.LayoutParams(xHit,-1));
      for(View grip:grips)grip.setVisibility(editing&&p.getBoolean("resize",true)?View.VISIBLE:View.GONE);
    }
    void addGrips(){
      for(int i=0;i<HANDLES.length;i++){
        int mask=HANDLES[i];boolean corner=Integer.bitCount(mask)==2;
        View v=new View(ctx);grips[i]=v;v.setVisibility(View.GONE);
        v.setBackground(background(corner?0xffef6a86:0xffe6e7ed,0xff51596b,9));
        FrameLayout.LayoutParams g=new FrameLayout.LayoutParams(dp(18),dp(18));
        if((mask&LEFT)!=0)g.gravity=Gravity.LEFT;else if((mask&RIGHT)!=0)g.gravity=Gravity.RIGHT;else g.gravity=Gravity.CENTER_HORIZONTAL;
        if((mask&TOP)!=0)g.gravity|=Gravity.TOP;else if((mask&BOTTOM)!=0)g.gravity|=Gravity.BOTTOM;else g.gravity|=Gravity.CENTER_VERTICAL;
        if((mask&(LEFT|RIGHT))==0)g.width=dp(22);if((mask&(TOP|BOTTOM))==0)g.height=dp(22);
        v.setContentDescription("모아 복귀 버튼 크기 조절");setupTouches(v,10+mask);root.addView(v,g);
      }
    }
    void refresh(){safeBounds();constrain();rebuild();restartExpiry();if(lp!=null&&root!=null&&root.getWindowToken()!=null)wm.updateViewLayout(root,lp);}
    void constrain(){if(lp==null)return;lp.x=clamp(lp.x,safeL,Math.max(safeL,safeR-width));lp.y=clamp(lp.y,safeT,Math.max(safeT,safeB-height));}
    void persist(){
      if(lp==null)return;constrain();
      if(p.getBoolean("snap",false))lp.x=(lp.x+width/2>(safeL+safeR)/2)?safeR-width:safeL;
      float fx=clampf((lp.x-safeL)/(float)Math.max(1,safeR-safeL-width),0,1);
      float fy=clampf((lp.y-safeT)/(float)Math.max(1,safeB-safeT-height),0,1);
      p.edit().putFloat(key(ctx,"x"),fx).putFloat(key(ctx,"y"),fy)
       .putInt(key(ctx,"width"),Math.round(width/ctx.getResources().getDisplayMetrics().density))
       .putInt(key(ctx,"height"),Math.round(height/ctx.getResources().getDisplayMetrics().density)).apply();
      if(root!=null&&root.getWindowToken()!=null)wm.updateViewLayout(root,lp);
    }
    void cancelLong(){if(longPress!=null){MAIN.removeCallbacks(longPress);longPress=null;}}
    void enterEdit(){if(editing)return;cancelExpiry();editing=true;longTriggered=true;root.performHapticFeedback(HapticFeedbackConstants.LONG_PRESS);rebuild();}
    void exitEdit(){editing=false;persist();rebuild();restartExpiry();}
    void move(int x,int y){lp.x=x;lp.y=y;constrain();wm.updateViewLayout(root,lp);}
    void resize(int mask,float dx,float dy){
      safeBounds();int x=startX,y=startY,r=startX+startW,b=startY+startH;
      int w=Math.round(dx),h=Math.round(dy);
      if((mask&LEFT)!=0)x=clamp(startX+w,safeL,r-minW());
      if((mask&RIGHT)!=0)r=clamp(startX+startW+w,x+minW(),safeR);
      if((mask&TOP)!=0)y=clamp(startY+h,safeT,b-minH());
      if((mask&BOTTOM)!=0)b=clamp(startY+startH+h,y+minH(),safeB);
      if(r-x>maxW()){if((mask&LEFT)!=0)x=r-maxW();else r=x+maxW();}
      if(b-y>maxH()){if((mask&TOP)!=0)y=b-maxH();else b=y+maxH();}
      width=r-x;height=b-y;lp.x=x;lp.y=y;lp.width=width;lp.height=height;
      rebuild();wm.updateViewLayout(root,lp);
    }
    void setupTouches(View view,int action){
      view.setOnTouchListener((v,e)->{
        int a=e.getActionMasked();
        if(a==MotionEvent.ACTION_DOWN){
          cancelLong();cancelExpiry();moved=false;longTriggered=false;downX=e.getRawX();downY=e.getRawY();
          startX=lp==null?0:lp.x;startY=lp==null?0:lp.y;startW=width;startH=height;
          if(!editing&&(p.getBoolean("move",true)||p.getBoolean("resize",true))){
            longPress=this::enterEdit;MAIN.postDelayed(longPress,ViewConfiguration.getLongPressTimeout());
          }
          return true;
        }
        if(a==MotionEvent.ACTION_MOVE){
          float dx=e.getRawX()-downX,dy=e.getRawY()-downY;
          if(Math.abs(dx)+Math.abs(dy)>slop){moved=true;cancelLong();}
          if(editing&&action>=10&&p.getBoolean("resize",true))resize(action-10,dx,dy);
          else if(editing&&p.getBoolean("move",true))move(startX+Math.round(dx),startY+Math.round(dy));
          return true;
        }
        if(a==MotionEvent.ACTION_CANCEL){cancelLong();return true;}
        if(a==MotionEvent.ACTION_UP){
          cancelLong();if(editing){if(action==2&&!moved)exitEdit();else if(moved)persist();return true;}
          if(!moved&&!longTriggered){
            if(action==1){hide();returnToOriginalTask();}
            else if(action==2)hide();
            else restartExpiry();
          }else restartExpiry();
          return true;
        }
        return true;
      });
    }
    void returnToOriginalTask(){
      // First bring original MOA task forward, not a new gallery Activity instance.
      try{
        ActivityManager am=(ActivityManager)ctx.getSystemService(Context.ACTIVITY_SERVICE);
        if(am!=null){for(ActivityManager.AppTask t:am.getAppTasks()){
          ActivityManager.RecentTaskInfo info=t.getTaskInfo();
          if(info!=null&&info.id==taskId){t.moveToFront();return;}
        }}
      }catch(Exception ignored){}
      try{restoreIntent.send();}catch(PendingIntent.CanceledException ignored){}
    }
    void remove(){cancelLong();cancelExpiry();if(root!=null)try{wm.removeView(root);}catch(Exception ignored){}root=null;}
  }
}