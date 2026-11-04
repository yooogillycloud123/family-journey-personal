package com.juhyeon.familyjourney;

import android.Manifest;
import android.app.*;
import android.content.*;
import android.database.ContentObserver;
import android.database.Cursor;
import android.net.Uri;
import android.os.*;
import android.provider.MediaStore;
import android.service.quicksettings.Tile;
import android.service.quicksettings.TileService;
import android.content.pm.PackageManager;
import android.graphics.drawable.Icon;
import android.app.RemoteInput;
import android.provider.Settings;
import android.graphics.Color;
import android.graphics.PixelFormat;
import android.graphics.drawable.GradientDrawable;
import android.view.*;
import android.widget.*;
import org.json.JSONObject;
import java.util.*;
// All state is persisted before sending notifications.

/**
 * User-armed, on-device camera-photo and video monitor for MOA.
 * No AccessibilityService. Only public MediaStore rows; never reads private camera data.
 * Native drafts survive process loss and are acknowledged only after WebView IndexedDB commits.
 */
public class MoaMomentCaptureService extends Service {
  public static final String PREF="moa_camera_native_v1", CH="moa_moment_monitor", CH_EVENT="moa_moment_capture_alerts_v2", CH_EVENT_QUIET="moa_moment_capture_quiet_thumb_v1", ACT="com.juhyeon.familyjournea.MOMENT";
  public static final String NOTESTOP="com.juhyeon.familyjournea.MOMENT_STOP";
  private Handler h; private final Handler ui=new Handler(Looper.getMainLooper());
  private WindowManager overlayManager; private View overlayView;
  private BroadcastReceiver newPictureHint; private boolean hintRegistered;
  private HandlerThread worker; private ContentObserver observer; private boolean scanning,stopRequested,observerRegistered;
  static SharedPreferences prefs(Context c){return c.getSharedPreferences(PREF,MODE_PRIVATE);}
  static boolean enabled(Context c){return prefs(c).getBoolean("enabled",false);}
  static boolean isRunning(Context c){return enabled(c)&&System.currentTimeMillis()-prefs(c).getLong("heartbeat",0)<12000L;}
  static void switchTo(Context c, boolean on) {
    if(on && (c.checkSelfPermission(Manifest.permission.READ_MEDIA_IMAGES)!=PackageManager.PERMISSION_GRANTED || c.checkSelfPermission(Manifest.permission.READ_MEDIA_VIDEO)!=PackageManager.PERMISSION_GRANTED || c.checkSelfPermission(Manifest.permission.POST_NOTIFICATIONS)!=PackageManager.PERMISSION_GRANTED)) {
      prefs(c).edit().putString("lastError","모아 설정에서 사진·영상 전체 접근과 알림 권한이 필요합니다.").apply();return;
    }
    prefs(c).edit().putBoolean("enabled",on).putLong("armedAt",on?System.currentTimeMillis():0).apply();
    Intent i=new Intent(c,MoaMomentCaptureService.class).setAction(on?"START":"STOP");
    if(on) {try{c.startForegroundService(i);}catch(Exception x){prefs(c).edit().putBoolean("enabled",false).putLong("heartbeat",0).putString("lastError","시작 실패: "+x).apply();}}
    else {try{c.stopService(i);}catch(Exception ignored){}}
  }
  @Override public void onCreate(){super.onCreate();worker=new HandlerThread("MOA-Camera-Observer");worker.start();h=new Handler(worker.getLooper());
    NotificationManager n=getSystemService(NotificationManager.class);
    n.createNotificationChannel(new NotificationChannel(CH,"모아 기록 감시 상태",NotificationManager.IMPORTANCE_LOW));
    n.createNotificationChannel(new NotificationChannel(CH_EVENT,"모아 촬영 즉시 기록",NotificationManager.IMPORTANCE_HIGH));
    // The thumb-zone overlay is the visible action; leave a silent tray backup.
    n.createNotificationChannel(new NotificationChannel(CH_EVENT_QUIET,"모아 촬영 기록 보관 알림",NotificationManager.IMPORTANCE_LOW));
    observer=new ContentObserver(h){@Override public void onChange(boolean self,Uri uri){schedule();}@Override public void onChange(boolean self){schedule();}};
  }
  @Override public int onStartCommand(Intent intent,int flags,int startId){
    if(!enabled(this)||intent!=null&&"STOP".equals(intent.getAction())) {stopRequested=true;stopSelf();return START_NOT_STICKY;}
    try{
      Intent stop=new Intent(this,Commands.class).setAction(NOTESTOP);
      PendingIntent stopPi=PendingIntent.getBroadcast(this,24,stop,PendingIntent.FLAG_UPDATE_CURRENT|PendingIntent.FLAG_IMMUTABLE);
      Notification live=new Notification.Builder(this,CH).setSmallIcon(android.R.drawable.ic_menu_camera)
        .setContentTitle("모아 순간 기록 ON").setContentText("삼성 카메라로 찍으면 바로 기록 알림이 나옵니다.")
        .setOngoing(true).addAction(new Notification.Action.Builder(null,"끄기",stopPi).build()).build();
      startForeground(42101,live);
      prefs(this).edit().putLong("heartbeat",System.currentTimeMillis()).remove("lastError").apply();
    }catch(Exception x){prefs(this).edit().putBoolean("enabled",false).putLong("heartbeat",0).putString("lastError","Foreground: "+x).apply();stopSelf();return START_NOT_STICKY;}
    try {
      if(!observerRegistered){
        getContentResolver().registerContentObserver(MediaStore.Images.Media.EXTERNAL_CONTENT_URI,true,observer);
        getContentResolver().registerContentObserver(MediaStore.Video.Media.EXTERNAL_CONTENT_URI,true,observer);
        observerRegistered=true;
      }
      schedule();
    }catch(Exception x){prefs(this).edit().putString("lastError","Observer: "+x).apply();}
    // ACTION_NEW_PICTURE is an optional early signal for already-running apps.
    // Some Samsung/Android builds don't emit it; MediaStore observer is authoritative.
    if(!hintRegistered)try {
      newPictureHint=new BroadcastReceiver(){@Override public void onReceive(Context ctx,Intent in){schedule();}};
      registerReceiver(newPictureHint,new IntentFilter("android.hardware.action.NEW_PICTURE"),Context.RECEIVER_EXPORTED);
      hintRegistered=true;
    }catch(Exception e){prefs(this).edit().putString("hintError",e.toString()).apply();}
    updateTile(this);
    return START_STICKY;
  }
  private final Runnable scan=()->{
    if(!enabled(this)||stopRequested)return;
    if(scanning){h.postDelayed(this::schedule,1000);return;}
    scanning=true;try{poll(MediaStore.Images.Media.EXTERNAL_CONTENT_URI,false);poll(MediaStore.Video.Media.EXTERNAL_CONTENT_URI,true);}
    catch(Exception x){prefs(this).edit().putString("lastError","Scan: "+x).apply();}
    finally{scanning=false;
      if(enabled(this)&&!stopRequested){prefs(this).edit().putLong("heartbeat",System.currentTimeMillis()).apply();
        // Reconcile existing saved memos even if MOA's WebView bridge never initialized.
        MoaMomentDirectDiaryStore.requestSync(getApplicationContext());
        h.postDelayed(this::schedule,6000L);}
    }
  };
  // Coalesce rapid Samsung MediaStore notifications WITHOUT restarting the timer.
  // R71 used removeCallbacks()+1100ms debounce; repeated camera writes could
  // postpone the thumb overlay for several seconds. Preserve pending/size
  // safety checks and the existing 6s missed-observer fallback.
  private void schedule(){if(h==null)return;if(!h.hasCallbacks(scan))h.postDelayed(scan,300L);}
  private void poll(Uri uri,boolean video){
    if(checkSelfPermission(video?Manifest.permission.READ_MEDIA_VIDEO:Manifest.permission.READ_MEDIA_IMAGES)!=PackageManager.PERMISSION_GRANTED)return;
    String[] projection={"_id","datetaken","date_added","relative_path","is_pending","_size"};
    Bundle args=new Bundle();
    args.putString(ContentResolver.QUERY_ARG_SQL_SORT_ORDER,MediaStore.MediaColumns._ID+" DESC");
    args.putString(ContentResolver.QUERY_ARG_SQL_LIMIT,"80");
    try(Cursor c=getContentResolver().query(uri,projection,args,null)){
      if(c==null)return;
      long armed=prefs(this).getLong("armedAt",0L);
      while(c.moveToNext()){
        long id=c.getLong(0),time=c.getLong(1),added=c.getLong(2)*1000L;
        String path=c.getString(3);int pending=c.getInt(4);long size=c.getLong(5);
        if(path==null||!path.toLowerCase(Locale.ROOT).contains("dcim/camera"))continue;
        if(pending!=0||size<=0)continue;
        if(Math.max(time,added)<armed-1500L||added>System.currentTimeMillis()+60000L)continue;
        String key=(video?"v":"")+id;
        if(prefs(this).contains("m:"+key)||prefs(this).getBoolean("seen:"+key,false))continue;
        try {
          JSONObject obj=new JSONObject();obj.put("id",key);obj.put("at",time>0?time:added);
          obj.put("video",video);obj.put("note","");obj.put("memoSaved",false);obj.put("capturedAt",System.currentTimeMillis());
          if(!prefs(this).edit().putString("m:"+key,obj.toString()).putBoolean("seen:"+key,true).commit())continue;
          showCapture(key,obj.optLong("at"));
        }catch(Exception ignored){}
      }
    }catch(Exception ex){prefs(this).edit().putString("lastError","Query: "+ex).apply();}
  }
  private void showCapture(String key,long at){
    Intent open=new Intent(this,MoaMomentMemoActivity.class).putExtra("id",key);
    PendingIntent tap=PendingIntent.getActivity(this,key.hashCode(),open,PendingIntent.FLAG_UPDATE_CURRENT|PendingIntent.FLAG_IMMUTABLE);
    Intent reply=new Intent(this,Commands.class).setAction(ACT).putExtra("id",key);
    PendingIntent pi=PendingIntent.getBroadcast(this,key.hashCode(),reply,PendingIntent.FLAG_UPDATE_CURRENT|PendingIntent.FLAG_MUTABLE);
    RemoteInput input=new RemoteInput.Builder("note").setLabel("지금 기억나는 상황을 입력하거나 키보드 마이크로 말하세요").build();
    Notification.Action action=new Notification.Action.Builder(null,"바로 메모",pi).addRemoteInput(input).build();
    // A system heads-up always appears near the TOP and cannot be repositioned by an app.
    // Show only ONE immediately visible capture UI when the thumb overlay is allowed.
    boolean thumbOverlay=Settings.canDrawOverlays(this);
    Notification n=new Notification.Builder(this,thumbOverlay?CH_EVENT_QUIET:CH_EVENT)
      .setSmallIcon(android.R.drawable.ic_menu_edit).setContentTitle("방금 촬영한 사진·영상 · 모아 기록")
      .setContentText("여기를 눌러 즉시 기록하거나, 바로 메모에서 입력하세요.")
      .setAutoCancel(true).setContentIntent(tap).addAction(action).setCategory(Notification.CATEGORY_REMINDER)
      .setPriority(thumbOverlay?Notification.PRIORITY_LOW:Notification.PRIORITY_HIGH).build();
    getSystemService(NotificationManager.class).notify(43000+(key.hashCode()&0x7fff),n);
    showOptionalCameraOverlay(tap,43000+(key.hashCode()&0x7fff));
  }
  /** Optional explicit overlay: a small non-focusable banner over Samsung Camera.
   *  Requires user-granted Draw over other apps; no automatic permission grant.
   *  No fake 'camera callback': displayed only after an actual new MediaStore row.
   */
  private int dp(float value){return (int)(getResources().getDisplayMetrics().density*value+0.5f);}
  private void showOptionalCameraOverlay(PendingIntent target,int notificationId){
    if(!Settings.canDrawOverlays(this))return;
    ui.post(()->{
      try{
        removeOptionalCameraOverlay();
        overlayManager=(WindowManager)getSystemService(WINDOW_SERVICE);
        LinearLayout card=new LinearLayout(this);
        card.setOrientation(LinearLayout.HORIZONTAL);
        card.setGravity(Gravity.CENTER_VERTICAL);
        card.setPadding(dp(9),dp(3),dp(8),dp(3));
        GradientDrawable pill=new GradientDrawable();
        pill.setColor(0xfaf9f6f1);
        pill.setCornerRadius(dp(30));
        pill.setStroke(dp(1),0xffd8cdc6);
        card.setBackground(pill);
        card.setElevation(dp(8));

        TextView handle=new TextView(this);
        handle.setText("모아");
        handle.setTextSize(14);
        handle.setTextColor(0xff21303f);
        handle.setPadding(dp(6),dp(8),dp(4),dp(8));
        card.addView(handle);
        Button note=new Button(this);
        note.setText("바로 기록");
        note.setAllCaps(false);
        note.setTextSize(14);
        note.setMinimumWidth(dp(92));
        note.setMinHeight(dp(45));
        card.addView(note);
        // R74: dismiss ONLY this photo's floating prompt. No global
        // monitoring toggle, no deletion of the captured file or saved memo.
        TextView dismiss=new TextView(this);
        dismiss.setText("×");
        dismiss.setContentDescription("이번 촬영 바로 기록 알림 닫기");
        dismiss.setTextSize(22);
        dismiss.setTextColor(0xff657080);
        dismiss.setGravity(Gravity.CENTER);
        dismiss.setMinWidth(dp(42));
        dismiss.setMinHeight(dp(46));
        dismiss.setOnClickListener(v->{
          if(overlayView==card)removeOptionalCameraOverlay();
          // This specific capture's quiet notification is optional as well.
          try{getSystemService(NotificationManager.class).cancel(notificationId);}
          catch(Exception ignored){}
        });
        card.addView(dismiss);
        note.setOnClickListener(v->{
          removeOptionalCameraOverlay();
          try{target.send();}catch(PendingIntent.CanceledException e){
            prefs(this).edit().putString("lastError","사진 기록 팝업 열기 실패: "+e).apply();
          }
        });

        int side=prefs(this).getInt("thumbOverlaySide",1); // 0:left 1:right
        int distance=prefs(this).getInt("thumbOverlayBottomDp",310);
        WindowManager.LayoutParams p=new WindowManager.LayoutParams(
          WindowManager.LayoutParams.WRAP_CONTENT,WindowManager.LayoutParams.WRAP_CONTENT,
          WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY,
          WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE|WindowManager.LayoutParams.FLAG_NOT_TOUCH_MODAL,
          PixelFormat.TRANSLUCENT);
        p.gravity=(side==0?Gravity.START:Gravity.END)|Gravity.BOTTOM;
        p.x=dp(12);
        p.y=dp(Math.max(180,Math.min(530,distance)));
        // Drag the MOA handle up/down; tap the handle to move the pill to other thumb.
        final float[] startY={0f};
        final int[] startBottom={0};
        handle.setOnTouchListener((v,e)->{
          if(e.getAction()==MotionEvent.ACTION_DOWN){
            startY[0]=e.getRawY(); startBottom[0]=p.y; return true;
          }
          if(e.getAction()==MotionEvent.ACTION_MOVE){
            p.y=Math.max(dp(180),Math.min(dp(530),
              startBottom[0]-(int)(e.getRawY()-startY[0])));
            try{if(overlayView==card)overlayManager.updateViewLayout(card,p);}catch(Exception ignored){}
            return true;
          }
          if(e.getAction()==MotionEvent.ACTION_UP){
            float delta=Math.abs(e.getRawY()-startY[0]);
            if(delta<dp(12)){
              int next=prefs(this).getInt("thumbOverlaySide",1)==0?1:0;
              prefs(this).edit().putInt("thumbOverlaySide",next).apply();
              p.gravity=(next==0?Gravity.START:Gravity.END)|Gravity.BOTTOM;
            }else{
              prefs(this).edit().putInt("thumbOverlayBottomDp",
                Math.round(p.y/getResources().getDisplayMetrics().density)).apply();
            }
            try{if(overlayView==card)overlayManager.updateViewLayout(card,p);}catch(Exception ignored){}
            return true;
          }
          return true;
        });
        overlayManager.addView(card,p);overlayView=card;
        ui.postDelayed(()->{if(overlayView==card)removeOptionalCameraOverlay();},8500L);
      }catch(Exception e){
        prefs(this).edit().putString("lastError","Overlay: "+e).apply();
        // Fail open: retain standard top heads-up if an overlay was blocked unexpectedly.
        try{
          Notification fallback=new Notification.Builder(this,CH_EVENT)
            .setSmallIcon(android.R.drawable.ic_menu_edit)
            .setContentTitle("방금 촬영한 사진·영상 · 모아 기록")
            .setContentText("여기를 눌러 바로 기록하세요.")
            .setAutoCancel(true).setContentIntent(target)
            .setPriority(Notification.PRIORITY_HIGH).build();
          getSystemService(NotificationManager.class)
            .notify(notificationId,fallback);
        }catch(Exception ignored){}
      }
    });
  }
  private void removeOptionalCameraOverlay(){
    if(overlayManager!=null && overlayView!=null)
      try{overlayManager.removeView(overlayView);}catch(Exception ignored){}
    overlayView=null;
  }
  @Override public android.os.IBinder onBind(Intent intent){return null;}
  @Override public void onDestroy(){
    stopRequested=true;if(h!=null)h.removeCallbacksAndMessages(null);
    if(observerRegistered)try{getContentResolver().unregisterContentObserver(observer);}catch(Exception ignored){}
    ui.post(this::removeOptionalCameraOverlay);
    if(hintRegistered)try{unregisterReceiver(newPictureHint);}catch(Exception ignored){}
    if(worker!=null)worker.quitSafely();
    prefs(this).edit().putLong("heartbeat",0L).apply();
    updateTile(this);
    super.onDestroy();
  }
  public static void updateTile(Context c){
    try{TileService.requestListeningState(c,new ComponentName(c,QuickTile.class));}catch(Exception ignored){}
  }
  public static final class QuickTile extends TileService {
    @Override public void onStartListening(){super.onStartListening();Tile t=getQsTile();if(t!=null){t.setLabel("모아 기록");t.setState(isRunning(this)?Tile.STATE_ACTIVE:Tile.STATE_INACTIVE);t.updateTile();}}
    @Override public void onClick(){
      super.onClick();
      if(enabled(this)) switchTo(this,false);
      else {
        boolean allowed=checkSelfPermission(Manifest.permission.READ_MEDIA_IMAGES)==PackageManager.PERMISSION_GRANTED
          && checkSelfPermission(Manifest.permission.READ_MEDIA_VIDEO)==PackageManager.PERMISSION_GRANTED
          && checkSelfPermission(Manifest.permission.POST_NOTIFICATIONS)==PackageManager.PERMISSION_GRANTED;
        if(!allowed) {
          Intent setup=new Intent(this,MoaMomentSetupActivity.class);
          setup.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
          if(Build.VERSION.SDK_INT>=34){
            PendingIntent p=PendingIntent.getActivity(this,451,setup,PendingIntent.FLAG_UPDATE_CURRENT|PendingIntent.FLAG_IMMUTABLE);
            startActivityAndCollapse(p);
          } else startActivityAndCollapse(setup);
        } else switchTo(this,true);
      }
      Tile t=getQsTile();if(t!=null){t.setState(enabled(this)?Tile.STATE_ACTIVE:Tile.STATE_INACTIVE);t.updateTile();}
    }
  }
  public static final class Commands extends BroadcastReceiver{
    @Override public void onReceive(Context c,Intent i){
      if(NOTESTOP.equals(i.getAction())){switchTo(c,false);updateTile(c);return;}
      if(!ACT.equals(i.getAction()))return;
      String key=i.getStringExtra("id");
      Bundle b=RemoteInput.getResultsFromIntent(i);
      if(key==null||!key.matches("v?\\d{1,19}")||b==null)return;
      CharSequence q=b.getCharSequence("note");
      if(q==null)return;
      try {
        String prev=prefs(c).getString("m:"+key,"");if(prev.isEmpty())return;
        JSONObject data=new JSONObject(prev);data.put("note",q.toString().trim());data.put("memoSaved",true);data.put("updatedAt",System.currentTimeMillis());
        prefs(c).edit().putString("m:"+key,data.toString()).commit();
        getManager(c).cancel(43000+(key.hashCode()&0x7fff));
      }catch(Exception ignored){}
    }
    private NotificationManager getManager(Context c){return c.getSystemService(NotificationManager.class);}
  }
}
