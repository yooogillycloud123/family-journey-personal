package com.juhyeon.familyjourney;

import android.app.KeyguardManager;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.Context;
import android.content.SharedPreferences;
import android.content.res.Configuration;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.graphics.Path;
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

/** R215 optional overlay replacement. Original MediaStore observer and capture drafts are unchanged.
 *  This class has NO Accessibility, network, permission grants, or capture detection code.
 */
public final class MoaR215QuickOverlay {
 private static final String PREF="moa_quick_overlay_v1";
 private static final Handler MAIN=new Handler(Looper.getMainLooper());
 private static Instance current;
 private MoaR215QuickOverlay(){}
 private static SharedPreferences prefs(Context c){return c.getSharedPreferences(PREF,Context.MODE_PRIVATE);}
 private static int clamp(int x,int a,int b){return Math.min(b,Math.max(a,x));}
 private static float clampf(float x,float a,float b){return Math.min(b,Math.max(a,x));}
 private static String style(String s){switch(s){case "A":case "B":case "C":case "D":case "E":case "F":return s;default:return "A";}}
 private static String xStyle(String s){switch(s){case "basic":case "bold":case "round":case "ring":case "badge":return s;default:return "round";}}
 public static String getSettings(Context c){
  SharedPreferences p=prefs(c);JSONObject j=new JSONObject();
  try{
   j.put("show",p.getBoolean("show",true));
   j.put("style",style(p.getString("style","A")));
   j.put("xStyle",xStyle(p.getString("xStyle","round")));
   j.put("text",p.getBoolean("text",false));
   j.put("move",p.getBoolean("move",true));
   j.put("resize",p.getBoolean("resize",true));
   j.put("snap",p.getBoolean("snap",false));
   j.put("opacity",clamp(p.getInt("opacity",85),40,100));
   j.put("hideSec",clamp(p.getInt("hideSec",5),0,60));
   j.put("sizePct",clamp(p.getInt(sizeKey(c),p.getInt("sizePct",100)),70,150));
   j.put("orientation",orientation(c));
   j.put("hasPosition",p.contains(positionKey(c,"x"))&&p.contains(positionKey(c,"y")));
  }catch(Exception ignored){}
  return j.toString();
 }
 public static void setSettings(Context c,String raw){
  if(raw==null||raw.length()>4096)return;
  try{
   JSONObject j=new JSONObject(raw);SharedPreferences p=prefs(c);SharedPreferences.Editor e=p.edit();
   if(j.has("show"))e.putBoolean("show",j.optBoolean("show",true));
   if(j.has("style"))e.putString("style",style(j.optString("style","A")));
   if(j.has("xStyle"))e.putString("xStyle",xStyle(j.optString("xStyle","round")));
   for(String key:new String[]{"text","move","resize","snap"})if(j.has(key))e.putBoolean(key,j.optBoolean(key,false));
   if(j.has("opacity"))e.putInt("opacity",clamp(j.optInt("opacity",85),40,100));
   if(j.has("hideSec"))e.putInt("hideSec",clamp(j.optInt("hideSec",5),0,60));
   if(j.has("sizePct")){
    int v=clamp(j.optInt("sizePct",100),70,150);e.putInt(sizeKey(c),v);e.putInt("sizePct",v);
   }
   if(j.optBoolean("resetPosition",false)){
    e.remove("position_portrait_x").remove("position_portrait_y").remove("position_landscape_x").remove("position_landscape_y");
   }
   if(j.optBoolean("resetSize",false)){
    e.remove("size_portrait").remove("size_landscape").remove("sizePct");
   }
   e.apply();
   MAIN.post(()->{if(current!=null&&current.ctx.getPackageName().equals(c.getPackageName()))current.applyPreferences();});
  }catch(Exception ignored){}
 }
 private static String orientation(Context c){return c.getResources().getConfiguration().orientation==Configuration.ORIENTATION_LANDSCAPE?"landscape":"portrait";}
 private static String sizeKey(Context c){return "size_"+orientation(c);}
 private static String positionKey(Context c,String axis){return "position_"+orientation(c)+"_"+axis;}
 public static void show(Context c,PendingIntent target,int notificationId){
  if(Looper.myLooper()!=Looper.getMainLooper()){
   MAIN.post(()->show(c,target,notificationId));return;
  }
  hide();
  if(!Settings.canDrawOverlays(c)||!prefs(c).getBoolean("show",true))return;
  try{current=new Instance(c,target,notificationId);current.mount();}
  catch(Throwable e){hide();c.getSharedPreferences("moa_camera_native_v1",Context.MODE_PRIVATE).edit().putString("lastError","QuickPopup: "+e).apply();}
 }
 public static void hide(){
  if(Looper.myLooper()!=Looper.getMainLooper()){MAIN.post(MoaR215QuickOverlay::hide);return;}
  Instance old=current;current=null;if(old!=null)old.remove();
 }
 private static final class Instance{
  final Context ctx;final PendingIntent action;final int notificationId;
  final WindowManager wm;final Handler h=MAIN;final SharedPreferences p;
  WindowManager.LayoutParams wp;FrameLayout root;LinearLayout row;
  IconView record,close;TextView text,done,grip;View divider;
  Runnable expiration,longPress;
  boolean editing=false,downEditing=false,gestureMoved=false,longTriggered=false,resizing=false;
  float downRawX,downRawY;int beginX,beginY,beginSize;int sizePct;
  int safeLeft,safeTop,safeRight,safeBottom;int width,height;
  int touchSlop;
  Instance(Context c,PendingIntent pi,int nid){ctx=c;action=pi;notificationId=nid;wm=(WindowManager)c.getSystemService(Context.WINDOW_SERVICE);p=prefs(c);touchSlop=ViewConfiguration.get(c).getScaledTouchSlop();}
  int dp(float v){return (int)(v*ctx.getResources().getDisplayMetrics().density+.5f);}
  void bounds(){
   Rect r=wm.getCurrentWindowMetrics().getBounds();
   WindowInsets wi=wm.getCurrentWindowMetrics().getWindowInsets();
   android.graphics.Insets inset=wi.getInsetsIgnoringVisibility(WindowInsets.Type.systemBars());
   safeLeft=inset.left+dp(8);safeRight=r.width()-inset.right-dp(8);
   safeTop=inset.top+dp(8);safeBottom=r.height()-inset.bottom-dp(8);
  }
  void mount(){
   bounds();sizePct=clamp(p.getInt(sizeKey(ctx),p.getInt("sizePct",100)),70,150);
   root=new FrameLayout(ctx);root.setClipChildren(false);root.setClipToPadding(false);
   row=new LinearLayout(ctx);row.setOrientation(LinearLayout.HORIZONTAL);row.setGravity(Gravity.CENTER_VERTICAL);
   root.addView(row,new FrameLayout.LayoutParams(-1,-1));
   record=new IconView(ctx,true);close=new IconView(ctx,false);
   record.setContentDescription("모아 바로기록");close.setContentDescription("바로기록 팝업 닫기");
   text=new TextView(ctx);text.setText("기록");text.setTextColor(Color.WHITE);text.setGravity(Gravity.CENTER_VERTICAL);
   divider=new View(ctx);divider.setBackgroundColor(0x668f919b);
   done=new TextView(ctx);done.setText("완료");done.setTextColor(Color.WHITE);done.setGravity(Gravity.CENTER);
   done.setBackground(makeBg(0xaabf2336,14,0x77ffffff));done.setOnClickListener(v->finishEdit());
   grip=new TextView(ctx);grip.setText("◢");grip.setTextColor(0xffffa3b1);grip.setGravity(Gravity.CENTER);
   grip.setContentDescription("드래그해서 팝업 크기 조절");
   root.addView(done,new FrameLayout.LayoutParams(dp(40),dp(22),Gravity.TOP|Gravity.RIGHT));
   root.addView(grip,new FrameLayout.LayoutParams(dp(27),dp(27),Gravity.BOTTOM|Gravity.RIGHT));
   installTouch(root,0);installTouch(record,1);installTouch(close,2);installTouch(grip,3);
   wp=new WindowManager.LayoutParams(0,0,WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY,
    WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE|WindowManager.LayoutParams.FLAG_NOT_TOUCH_MODAL,PixelFormat.TRANSLUCENT);
   KeyguardManager guard=(KeyguardManager)ctx.getSystemService(Context.KEYGUARD_SERVICE);
   boolean locked=guard!=null&&guard.isKeyguardLocked();
   if(locked)wp.flags|=0x80100; // identical lockscreen flags to previous popup
   ctx.getSharedPreferences("moa_camera_native_v1",Context.MODE_PRIVATE).edit()
    .putBoolean("r77LastOverlayKeyguard",locked)
    .putInt("r77LastOverlayFlags",wp.flags)
    .putLong("r77LastOverlayAttemptAt",System.currentTimeMillis()).apply();
   wp.gravity=Gravity.TOP|Gravity.LEFT;
   applySize();
   final String kx=positionKey(ctx,"x"),ky=positionKey(ctx,"y");
   int rangeX=Math.max(1,safeRight-safeLeft-width),rangeY=Math.max(1,safeBottom-safeTop-height);
   if(p.contains(kx)&&p.contains(ky)){
    float dx=clampf(p.getFloat(kx,1f),0f,1f),dy=clampf(p.getFloat(ky,.78f),0f,1f);
    wp.x=safeLeft+Math.round(dx*rangeX);wp.y=safeTop+Math.round(dy*rangeY);
   }else{
    // Preserve older R77/R209 location when a user upgrades to editable panel.
    SharedPreferences legacy=ctx.getSharedPreferences("moa_camera_native_v1",Context.MODE_PRIVATE);
    wp.x=legacy.getInt("thumbOverlaySide",1)==0?safeLeft:Math.max(safeLeft,safeRight-width);
    int legacyBottomDp=clamp(legacy.getInt("thumbOverlayBottomDp",310),180,530);
    wp.y=safeBottom-height-dp(legacyBottomDp);
   }
   constrain();wm.addView(root,wp);applyPreferences();
  }
  GradientDrawable makeBg(int color,int radius,int border){
   GradientDrawable g=new GradientDrawable();g.setColor(color);g.setCornerRadius(dp(radius));g.setStroke(Math.max(1,dp(.85f)),border);return g;
  }
  void rebuild(){
   if(root==null||row==null)return;
   row.removeAllViews();
   float factor=sizePct/100f;
   int opacity=clamp(p.getInt("opacity",85),40,100);
   int bg=((int)(opacity*2.55f)<<24)|0x242630;
   root.setBackground(makeBg(bg,34,editing?0xffff7189:0x88bcc2cf));
   int primaryW=dp(((p.getBoolean("text",false)||style(p.getString("style","A")).equals("B"))?116:82)*factor);
   int primaryH=dp(58*factor);
   primaryW=Math.max(dp(58),primaryW);primaryH=Math.max(dp(44),primaryH);
   record.setLayoutParams(new LinearLayout.LayoutParams(primaryW,primaryH));row.addView(record);
   if(p.getBoolean("text",false)||style(p.getString("style","A")).equals("B")){
    text.setTextSize(14*factor);row.addView(text,new LinearLayout.LayoutParams(0,-1,1));
   }
   LinearLayout.LayoutParams line=new LinearLayout.LayoutParams(dp(1),dp(29*factor));line.leftMargin=dp(4);line.rightMargin=dp(6);
   row.addView(divider,line);
   LinearLayout.LayoutParams x=new LinearLayout.LayoutParams(Math.max(dp(44),dp(50*factor)),Math.max(dp(44),dp(54*factor)));
   row.addView(close,x);
   row.setPadding(dp(9*factor),0,dp(9*factor),0);
   done.setVisibility(editing?View.VISIBLE:View.GONE);
   grip.setVisibility(editing&&p.getBoolean("resize",true)?View.VISIBLE:View.GONE);
   record.invalidate();close.invalidate();
  }
  void applySize(){
   boolean showText=p.getBoolean("text",false)||style(p.getString("style","A")).equals("B");
   float f=sizePct/100f;
   width=dp((showText?250:174)*f);height=dp(64*f);
   width=Math.max(dp(134),width);height=Math.max(dp(50),height);
   if(wp!=null){wp.width=width;wp.height=height;}
   rebuild();
   if(wm!=null&&root!=null&&root.getWindowToken()!=null){constrain();wm.updateViewLayout(root,wp);}
  }
  void applyPreferences(){
   if(root==null)return;
   int requested=clamp(p.getInt(sizeKey(ctx),p.getInt("sizePct",100)),70,150);
   if(!editing&&requested!=sizePct){sizePct=requested;applySize();}
   else rebuild();
   if(!p.getBoolean("show",true)){MoaR215QuickOverlay.hide();return;}
   restartTimer();
  }
  void constrain(){
   if(wp==null)return;bounds();
   wp.x=clamp(wp.x,safeLeft,Math.max(safeLeft,safeRight-width));
   wp.y=clamp(wp.y,safeTop,Math.max(safeTop,safeBottom-height));
  }
  void persist(){
   if(wp==null)return;constrain();
   if(p.getBoolean("snap",false)){
    wp.x=(wp.x+width/2>(safeLeft+safeRight)/2)?Math.max(safeLeft,safeRight-width):safeLeft;
    if(root!=null&&root.getWindowToken()!=null)wm.updateViewLayout(root,wp);
   }
   int rx=Math.max(1,safeRight-safeLeft-width),ry=Math.max(1,safeBottom-safeTop-height);
   p.edit().putFloat(positionKey(ctx,"x"),clampf((wp.x-safeLeft)/(float)rx,0f,1f))
    .putFloat(positionKey(ctx,"y"),clampf((wp.y-safeTop)/(float)ry,0f,1f))
    .putInt(sizeKey(ctx),sizePct).apply();
  }
  void cancelTimer(){if(expiration!=null){h.removeCallbacks(expiration);expiration=null;}}
  void restartTimer(){
   cancelTimer();if(editing)return;
   int seconds=clamp(p.getInt("hideSec",5),0,60);
   if(seconds>0){expiration=()->{if(current==this&&!editing)MoaR215QuickOverlay.hide();};h.postDelayed(expiration,1000L*seconds);}
  }
  void cancelLong(){if(longPress!=null){h.removeCallbacks(longPress);longPress=null;}}
  void enterEdit(){
   if(current!=this||editing)return;
   editing=true;longTriggered=true;cancelTimer();
   root.performHapticFeedback(HapticFeedbackConstants.LONG_PRESS);
   rebuild();
  }
  void finishEdit(){
   if(!editing)return;editing=false;persist();cancelLong();rebuild();restartTimer();
  }
  void move(int x,int y){
   wp.x=x;wp.y=y;constrain();wm.updateViewLayout(root,wp);
  }
  void resizeFrom(float dx,float dy){
   float change=(dx+dy*.6f)/dp(1f)*.55f;
   sizePct=clamp(Math.round(beginSize+change),70,150);
   applySize();constrain();
  }
  void installTouch(View node,int code){
   node.setOnTouchListener((v,e)->{
    final int act=e.getActionMasked();
    if(act==MotionEvent.ACTION_DOWN){
     cancelLong();cancelTimer();
     downRawX=e.getRawX();downRawY=e.getRawY();
     beginX=wp==null?0:wp.x;beginY=wp==null?0:wp.y;beginSize=sizePct;
     gestureMoved=false;longTriggered=false;downEditing=editing;resizing=editing&&code==3;
     if(!editing&&(p.getBoolean("move",true)||p.getBoolean("resize",true))){
      longPress=()->enterEdit();h.postDelayed(longPress,ViewConfiguration.getLongPressTimeout());
     }
     return true;
    }
    if(act==MotionEvent.ACTION_MOVE){
     float dx=e.getRawX()-downRawX,dy=e.getRawY()-downRawY;
     if(Math.abs(dx)+Math.abs(dy)>touchSlop)gestureMoved=true;
     if(!editing){if(gestureMoved)cancelLong();return true;}
     if(code==3&&p.getBoolean("resize",true)){
      resizeFrom(dx,dy);
     }else if(p.getBoolean("move",true)){
      move(beginX+Math.round(dx),beginY+Math.round(dy));
     }
     return true;
    }
    if(act==MotionEvent.ACTION_UP){
     cancelLong();
     if(editing){
      if(code==2&&downEditing&&!gestureMoved){finishEdit();return true;}
      if(gestureMoved)persist();
      return true;
     }
     if(!gestureMoved&&!longTriggered){
      if(code==1){MoaR215QuickOverlay.hide();try{action.send();}
       catch(PendingIntent.CanceledException err){ctx.getSharedPreferences("moa_camera_native_v1",0).edit().putString("lastError","QuickPopup action: "+err).apply();}}
      else if(code==2){MoaR215QuickOverlay.hide();NotificationManager n=(NotificationManager)ctx.getSystemService(Context.NOTIFICATION_SERVICE);if(n!=null)n.cancel(notificationId);}
      else restartTimer();
     }else restartTimer();
     return true;
    }
    if(act==MotionEvent.ACTION_CANCEL){cancelLong();if(!editing)restartTimer();return true;}
    return true;
   });
  }
  void remove(){
   cancelTimer();cancelLong();
   if(root!=null&&wm!=null){try{wm.removeView(root);}catch(Exception ignored){}}
   root=null;
  }
  final class IconView extends View{
   final boolean primary;final Paint paint=new Paint(Paint.ANTI_ALIAS_FLAG);
   IconView(Context c,boolean rec){super(c);primary=rec;setClickable(true);}
   void set(int col,Paint.Style st,float stroke){paint.setColor(col);paint.setStyle(st);paint.setStrokeWidth(stroke);paint.setStrokeCap(Paint.Cap.ROUND);paint.setStrokeJoin(Paint.Join.ROUND);}
   @Override protected void onDraw(Canvas c){
    super.onDraw(c);float cx=getWidth()/2f,cy=getHeight()/2f,base=Math.min(getWidth(),getHeight());
    float u=base/60f;String st=style(p.getString("style","A"));
    if(primary){
     int shade=st.equals("F")?0xaaec2236:0xfff0243d;
     set(shade,Paint.Style.FILL,0);float radius=base*(st.equals("C")?.37f:.42f);
     c.drawCircle(cx,cy,radius,paint);
     if(st.equals("E")){set(Color.WHITE,Paint.Style.STROKE,Math.max(dp(2),3*u));c.drawCircle(cx,cy,base*.25f,paint);}
     else if(st.equals("C")||st.equals("F")){
      set(Color.WHITE,Paint.Style.STROKE,Math.max(dp(2),3*u));
      c.drawRoundRect(cx-11*u,cy-13*u,cx+10*u,cy+13*u,2*u,2*u,paint);
      c.drawLine(cx-5*u,cy+5*u,cx+9*u,cy-9*u,paint);
     }else if(st.equals("D")){
      set(Color.WHITE,Paint.Style.FILL,0);c.drawRoundRect(cx-14*u,cy-11*u,cx+14*u,cy+11*u,3*u,3*u,paint);
      set(shade,Paint.Style.FILL,0);c.drawCircle(cx,cy,6*u,paint);
     }else{set(Color.WHITE,Paint.Style.FILL,0);c.drawCircle(cx,cy,base*.15f,paint);}
    }else{
     String xs=xStyle(p.getString("xStyle","round"));
     float rad=base*.35f;set(editing?0x99b52340:0x55434a56,Paint.Style.FILL,0);c.drawCircle(cx,cy,rad,paint);
     set(Color.WHITE,Paint.Style.STROKE,Math.max(dp(xs.equals("basic")?1.5f:2.4f),(xs.equals("bold")?4f:2.6f)*u));
     if(editing){c.drawLine(cx-9*u,cy,cx-2*u,cy+7*u,paint);c.drawLine(cx-2*u,cy+7*u,cx+11*u,cy-9*u,paint);return;}
     float d=xs.equals("badge")?9*u:11*u;
     c.drawLine(cx-d,cy-d,cx+d,cy+d,paint);c.drawLine(cx+d,cy-d,cx-d,cy+d,paint);
     if(xs.equals("ring")){set(0xaadce0e8,Paint.Style.STROKE,Math.max(1,dp(1.1f)));c.drawCircle(cx,cy,base*.37f,paint);}
    }
   }
  }
 }
}
