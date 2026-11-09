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
   j.put("xStyle",xStyle(p.getString("xStyle","basic")));
   j.put("text",p.getBoolean("text",false));
   j.put("move",p.getBoolean("move",true));
   j.put("resize",p.getBoolean("resize",true));
   j.put("snap",p.getBoolean("snap",false));
   j.put("opacity",clamp(p.getInt("opacity",85),40,100));
   j.put("hideSec",clamp(p.getInt("hideSec",5),0,60));
   j.put("sizePct",clamp(p.getInt(sizeKey(c),p.getInt("sizePct",85)),55,200));
   j.put("widthDp",p.getInt(panelKey(c,"width"),0));
   j.put("heightDp",p.getInt(panelKey(c,"height"),0));
   j.put("hasCustomDimensions",p.contains(panelKey(c,"width"))&&p.contains(panelKey(c,"height")));
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
    int v=clamp(j.optInt("sizePct",85),55,200);e.putInt(sizeKey(c),v);e.putInt("sizePct",v);
    e.remove(panelKey(c,"width")).remove(panelKey(c,"height"));
   }
   if(j.optBoolean("resetPosition",false)){
    e.remove("position_portrait_x").remove("position_portrait_y").remove("position_landscape_x").remove("position_landscape_y");
   }
   if(j.optBoolean("resetSize",false)){
    e.remove("size_portrait").remove("size_landscape").remove("sizePct");
    e.remove("panel_width_portrait").remove("panel_height_portrait");
    e.remove("panel_width_landscape").remove("panel_height_landscape");
   }
   e.apply();
   MAIN.post(()->{if(current!=null&&current.ctx.getPackageName().equals(c.getPackageName()))current.applyPreferences();});
  }catch(Exception ignored){}
 }
 private static String orientation(Context c){return c.getResources().getConfiguration().orientation==Configuration.ORIENTATION_LANDSCAPE?"landscape":"portrait";}
 private static String sizeKey(Context c){return "size_"+orientation(c);}
 private static String panelKey(Context c,String dim){return "panel_"+dim+"_"+orientation(c);}
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
  IconView record,close;TextView text;View divider;
  final View[] resizeHandles=new View[8];
  static final int EDGE_L=1,EDGE_R=2,EDGE_T=4,EDGE_B=8;
  static final int[] HANDLE_MASKS={EDGE_L,EDGE_R,EDGE_T,EDGE_B,EDGE_L|EDGE_T,EDGE_R|EDGE_T,EDGE_L|EDGE_B,EDGE_R|EDGE_B};
  Runnable expiration,longPress;
  boolean editing=false,downEditing=false,gestureMoved=false,longTriggered=false,resizing=false;
  float downRawX,downRawY;int beginX,beginY,beginWidth,beginHeight;int sizePct;
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
   bounds();sizePct=clamp(p.getInt(sizeKey(ctx),p.getInt("sizePct",85)),55,200);
   root=new FrameLayout(ctx);root.setClipChildren(false);root.setClipToPadding(false);
   row=new LinearLayout(ctx);row.setOrientation(LinearLayout.HORIZONTAL);row.setGravity(Gravity.CENTER_VERTICAL);
   root.addView(row,new FrameLayout.LayoutParams(-1,-1));
   record=new IconView(ctx,true);close=new IconView(ctx,false);
   record.setContentDescription("모아 바로기록");close.setContentDescription("바로기록 팝업 닫기");
   divider=new View(ctx);divider.setBackgroundColor(0x668f919b);
   installTouch(root,0);installTouch(record,1);installTouch(close,2);
   addResizeHandles();
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
  int minWidth(){return dp(132);} // only the accessible X target & tiny record hit target, NOT old forced 178dp
  int minHeight(){return dp(44);}
  int maxWidth(){return Math.max(minWidth(),Math.min(dp(470),safeRight-safeLeft));}
  int maxHeight(){return Math.max(minHeight(),Math.min(dp(130),safeBottom-safeTop));}
  int defaultWidth(){return dp((p.getBoolean("text",false)||style(p.getString("style","A")).equals("B")?197:176)*sizePct/100f);}
  int defaultHeight(){return dp(51*sizePct/100f);}
  void readDimensions(){
   int wDp=p.getInt(panelKey(ctx,"width"),0),hDp=p.getInt(panelKey(ctx,"height"),0);
   width=clamp(wDp>0?dp(wDp):defaultWidth(),minWidth(),maxWidth());
   height=clamp(hDp>0?dp(hDp):defaultHeight(),minHeight(),maxHeight());
  }
  void addResizeHandles(){
   for(int i=0;i<HANDLE_MASKS.length;i++){
    View v=new View(ctx);resizeHandles[i]=v;
    int mask=HANDLE_MASKS[i];
    boolean corner=(mask&(EDGE_L|EDGE_R))!=0&&(mask&(EDGE_T|EDGE_B))!=0;
    int gripSize=corner?dp(22):dp(22), shortSide=dp(15);
    FrameLayout.LayoutParams lp=new FrameLayout.LayoutParams(
      (mask&(EDGE_T|EDGE_B))==0?shortSide:gripSize,
      (mask&(EDGE_L|EDGE_R))==0?shortSide:gripSize);
    // Edge-only handles sit at the center of the corresponding side.
    if(mask==EDGE_L)lp.gravity=Gravity.LEFT|Gravity.CENTER_VERTICAL;
    else if(mask==EDGE_R)lp.gravity=Gravity.RIGHT|Gravity.CENTER_VERTICAL;
    else if(mask==EDGE_T)lp.gravity=Gravity.TOP|Gravity.CENTER_HORIZONTAL;
    else if(mask==EDGE_B)lp.gravity=Gravity.BOTTOM|Gravity.CENTER_HORIZONTAL;
    else if(mask==(EDGE_L|EDGE_T))lp.gravity=Gravity.LEFT|Gravity.TOP;
    else if(mask==(EDGE_R|EDGE_T))lp.gravity=Gravity.RIGHT|Gravity.TOP;
    else if(mask==(EDGE_L|EDGE_B))lp.gravity=Gravity.LEFT|Gravity.BOTTOM;
    else lp.gravity=Gravity.RIGHT|Gravity.BOTTOM;
    GradientDrawable d=new GradientDrawable();d.setColor(corner?0xfffa8a9d:0xffe4e8ef);
    d.setCornerRadius(dp(10));d.setStroke(Math.max(1,dp(.8f)),0xff5c6476);
    v.setBackground(d);v.setContentDescription("팝업 "+new String[]{"왼쪽","오른쪽","위쪽","아래쪽","왼쪽 위","오른쪽 위","왼쪽 아래","오른쪽 아래"}[i]+" 크기 조절");
    v.setVisibility(View.GONE);installTouch(v,10+mask);root.addView(v,lp);
   }
  }
  void rebuild(){
   if(root==null||row==null)return;
   row.removeAllViews();
   float scale=clampf(height/(float)dp(51),.55f,2.2f);
   int opacity=clamp(p.getInt("opacity",85),40,100);
   root.setAlpha(opacity/100f);
   GradientDrawable bg=new GradientDrawable();bg.setColor(0xe5252830);
   bg.setCornerRadius(Math.min(width,height)*.5f);
   bg.setStroke(Math.max(1,dp(editing?1.5f:.85f)),editing?0xffff6c8a:0x9dd2d7df);
   root.setBackground(bg);
   int pad=dp(Math.max(3f,4f*scale));
   int dividerW=dp(1),margin=dp(Math.max(2f,3f*scale));
   int rightHit=Math.max(dp(44),Math.min(dp(58),Math.round(width*.27f)));
   // Allocate ~75% of the usable hit surface to Record; the glyph itself stays small.
   int primaryW=Math.max(dp(65),width-rightHit-pad*2-dividerW-margin*2);
   row.setPadding(pad,0,pad,0);
   row.addView(record,new LinearLayout.LayoutParams(primaryW,Math.max(minHeight(),height-dp(4))));
   LinearLayout.LayoutParams sep=new LinearLayout.LayoutParams(dividerW,Math.max(dp(19),Math.round(height*.50f)));
   sep.leftMargin=margin;sep.rightMargin=margin;
   row.addView(divider,sep);
   row.addView(close,new LinearLayout.LayoutParams(rightHit,Math.max(minHeight(),height-dp(4))));
   for(View h:resizeHandles)if(h!=null)h.setVisibility(editing&&p.getBoolean("resize",true)?View.VISIBLE:View.GONE);
   record.invalidate();close.invalidate();
  }
  void applySize(){
   bounds();readDimensions();
   if(wp!=null){wp.width=width;wp.height=height;}
   rebuild();
   if(wm!=null&&root!=null&&root.getWindowToken()!=null){constrain();wm.updateViewLayout(root,wp);}
  }
  void applyPreferences(){
   if(root==null)return;
   sizePct=clamp(p.getInt(sizeKey(ctx),p.getInt("sizePct",85)),55,200);
   applySize();
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
    .putInt(sizeKey(ctx),sizePct)
    .putInt(panelKey(ctx,"width"),Math.round(width/ctx.getResources().getDisplayMetrics().density))
    .putInt(panelKey(ctx,"height"),Math.round(height/ctx.getResources().getDisplayMetrics().density)).apply();
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
  void resizeEdges(int mask,float dx,float dy){
   // Every side is independent; opposite edge is fixed unless both axes requested at a corner.
   bounds();int x=beginX,y=beginY,right=beginX+beginWidth,bottom=beginY+beginHeight;
   int dw=Math.round(dx),dh=Math.round(dy);
   if((mask&EDGE_L)!=0)x=clamp(beginX+dw,safeLeft,right-minWidth());
   if((mask&EDGE_R)!=0)right=clamp(beginX+beginWidth+dw,x+minWidth(),safeRight);
   if((mask&EDGE_T)!=0)y=clamp(beginY+dh,safeTop,bottom-minHeight());
   if((mask&EDGE_B)!=0)bottom=clamp(beginY+beginHeight+dh,y+minHeight(),safeBottom);
   if(right-x>maxWidth()){
    if((mask&EDGE_L)!=0)x=right-maxWidth();else right=x+maxWidth();
   }
   if(bottom-y>maxHeight()){
    if((mask&EDGE_T)!=0)y=bottom-maxHeight();else bottom=y+maxHeight();
   }
   width=Math.max(minWidth(),right-x);height=Math.max(minHeight(),bottom-y);
   wp.x=x;wp.y=y;wp.width=width;wp.height=height;
   rebuild();
   wm.updateViewLayout(root,wp);
  }
  void installTouch(View node,int code){
   node.setOnTouchListener((v,e)->{
    final int act=e.getActionMasked();
    if(act==MotionEvent.ACTION_DOWN){
     cancelLong();cancelTimer();
     downRawX=e.getRawX();downRawY=e.getRawY();
     beginX=wp==null?0:wp.x;beginY=wp==null?0:wp.y;beginWidth=width;beginHeight=height;
     gestureMoved=false;longTriggered=false;downEditing=editing;resizing=editing&&code>=10;
     if(!editing&&(p.getBoolean("move",true)||p.getBoolean("resize",true))){
      longPress=()->enterEdit();h.postDelayed(longPress,ViewConfiguration.getLongPressTimeout());
     }
     return true;
    }
    if(act==MotionEvent.ACTION_MOVE){
     float dx=e.getRawX()-downRawX,dy=e.getRawY()-downRawY;
     if(Math.abs(dx)+Math.abs(dy)>touchSlop)gestureMoved=true;
     if(!editing){if(gestureMoved)cancelLong();return true;}
     if(code>=10&&p.getBoolean("resize",true)){
      resizeEdges(code-10,dx,dy);
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
    String st=style(p.getString("style","A"));
    if(primary){
     boolean label=p.getBoolean("text",false)||st.equals("B");
     if(getWidth()<dp(102))label=false; // Never force a huge panel just to fit text.
     float dotRadius=clampf(base*.30f,dp(7.5f),dp(16));
     float iconCx=label?Math.max(dp(20),Math.min(dp(29),getWidth()*.26f)):cx;
     int shade=st.equals("F")?0xffff5069:0xffef3157;
     set(shade,Paint.Style.FILL,0);c.drawCircle(iconCx,cy,dotRadius,paint);
     if(st.equals("E")){
      set(0xfffce0e6,Paint.Style.STROKE,dp(1.2f));c.drawCircle(iconCx,cy,dotRadius*.82f,paint);
     }else if(st.equals("C")||st.equals("F")){
      set(Color.WHITE,Paint.Style.STROKE,dp(1.8f));
      float q=dotRadius*.38f;c.drawRoundRect(iconCx-q,cy-q,iconCx+q,cy+q,dp(1.5f),dp(1.5f),paint);
     }else if(st.equals("D")){
      set(Color.WHITE,Paint.Style.FILL,0);float q=dotRadius*.38f;
      c.drawRoundRect(iconCx-q,cy-q*.8f,iconCx+q,cy+q*.8f,dp(1.4f),dp(1.4f),paint);
     }else{
      set(Color.WHITE,Paint.Style.FILL,0);c.drawCircle(iconCx,cy,dotRadius*.40f,paint);
     }
     if(label){
      set(0xfff6f7fb,Paint.Style.FILL,0);paint.setTypeface(android.graphics.Typeface.DEFAULT_BOLD);
      paint.setTextSize(clampf(base*.28f,dp(9),dp(14)));
      float x=iconCx+dotRadius+dp(7);
      if(x+paint.measureText("기록")<getWidth()-dp(3))
       c.drawText("기록",x,cy-(paint.ascent()+paint.descent())*.5f,paint);
     }
    }else{
     String xs=xStyle(p.getString("xStyle","basic"));
     set(Color.WHITE,Paint.Style.STROKE,xs.equals("bold")?dp(2.6f):dp(1.9f));
     float d=clampf(base*.15f,dp(4.5f),dp(8));
     if(editing){c.drawLine(cx-d,cy,cx-d*.16f,cy+d,paint);c.drawLine(cx-d*.16f,cy+d,cx+d,cy-d,paint);return;}
     c.drawLine(cx-d,cy-d,cx+d,cy+d,paint);c.drawLine(cx+d,cy-d,cx-d,cy+d,paint);
     // No extra badge/circle behind X; its INVISIBLE hit area is still >=44dp.
    }
   }
  }
 }
}
