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
import org.json.JSONObject;
import java.util.*;
// All state is persisted before sending notifications.

/**
 * User-armed, on-device camera-photo and video monitor for MOA.
 * No AccessibilityService. Only public MediaStore rows; never reads private camera data.
 * Native drafts survive process loss and are acknowledged only after WebView IndexedDB commits.
 */
public class MoaMomentCaptureService extends Service {
  public static final String PREF="moa_camera_native_v1", CH="moa_moment_monitor", CH_EVENT="moa_moment_capture_alerts_v2", ACT="com.juhyeon.familyjournea.MOMENT";
  public static final String NOTESTOP="com.juhyeon.familyjournea.MOMENT_STOP";
  private Handler h; private HandlerThread worker; private ContentObserver observer; private boolean scanning,stopRequested,observerRegistered;
  static SharedPreferences prefs(Context c){return c.getSharedPreferences(PREF,MODE_PRIVATE);}
  static boolean enabled(Context c){return prefs(c).getBoolean("enabled",false);}
  static void switchTo(Context c, boolean on) {
    if(on && (c.checkSelfPermission(Manifest.permission.READ_MEDIA_IMAGES)!=PackageManager.PERMISSION_GRANTED || c.checkSelfPermission(Manifest.permission.READ_MEDIA_VIDEO)!=PackageManager.PERMISSION_GRANTED || c.checkSelfPermission(Manifest.permission.POST_NOTIFICATIONS)!=PackageManager.PERMISSION_GRANTED)) {
      prefs(c).edit().putString("lastError","모아 설정에서 사진·영상 전체 접근과 알림 권한이 필요합니다.").apply();return;
    }
    prefs(c).edit().putBoolean("enabled",on).putLong("armedAt",on?System.currentTimeMillis():0).apply();
    Intent i=new Intent(c,MoaMomentCaptureService.class).setAction(on?"START":"STOP");
    if(on) {try{c.startForegroundService(i);}catch(Exception x){prefs(c).edit().putString("lastError",x.toString()).apply();}}
    else {try{c.stopService(i);}catch(Exception ignored){}}
  }
  @Override public void onCreate(){super.onCreate();worker=new HandlerThread("MOA-Camera-Observer");worker.start();h=new Handler(worker.getLooper());
    NotificationManager n=getSystemService(NotificationManager.class);
    n.createNotificationChannel(new NotificationChannel(CH,"모아 기록 감시 상태",NotificationManager.IMPORTANCE_LOW));
    n.createNotificationChannel(new NotificationChannel(CH_EVENT,"모아 촬영 즉시 기록",NotificationManager.IMPORTANCE_HIGH));
    observer=new ContentObserver(h){@Override public void onChange(boolean self,Uri uri){schedule();}@Override public void onChange(boolean self){schedule();}};
  }
  @Override public int onStartCommand(Intent intent,int flags,int startId){
    if(!enabled(this)||intent!=null&&"STOP".equals(intent.getAction())) {stopRequested=true;stopSelf();return START_NOT_STICKY;}
    try{
      Intent stop=new Intent(this,Commands.class).setAction(NOTESTOP);
      PendingIntent stopPi=PendingIntent.getBroadcast(this,24,stop,PendingIntent.FLAG_UPDATE_CURRENT|PendingIntent.FLAG_IMMUTABLE);
      Notification live=new Notification.Builder(this,CH).setSmallIcon(android.R.drawable.ic_menu_camera)
        .setContentTitle("모아 순간 기록 ON").setContentText("삼성 카메라로 찍으면 바로 기록 알림이 나옵니다.")
        .setOngoing(true).setSilent(true).addAction(new Notification.Action.Builder(null,"끄기",stopPi).build()).build();
      startForeground(42101,live);
    }catch(Exception x){prefs(this).edit().putString("lastError","Foreground: "+x).apply();stopSelf();return START_NOT_STICKY;}
    try {
      if(!observerRegistered){
        getContentResolver().registerContentObserver(MediaStore.Images.Media.EXTERNAL_CONTENT_URI,true,observer);
        getContentResolver().registerContentObserver(MediaStore.Video.Media.EXTERNAL_CONTENT_URI,true,observer);
        observerRegistered=true;
      }
      schedule();
    }catch(Exception x){prefs(this).edit().putString("lastError","Observer: "+x).apply();}
    updateTile(this);
    return START_STICKY;
  }
  private final Runnable scan=()->{
    if(!enabled(this)||stopRequested)return;
    if(scanning){h.postDelayed(this::schedule,1000);return;}
    scanning=true;try{poll(MediaStore.Images.Media.EXTERNAL_CONTENT_URI,false);poll(MediaStore.Video.Media.EXTERNAL_CONTENT_URI,true);}
    catch(Exception x){prefs(this).edit().putString("lastError","Scan: "+x).apply();}
    finally{scanning=false;}
  };
  private void schedule(){if(h==null)return;h.removeCallbacks(scan);h.postDelayed(scan,1100);}
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
        if(prefs(this).contains("m:"+key))continue;
        try {
          JSONObject obj=new JSONObject();obj.put("id",key);obj.put("at",time>0?time:added);
          obj.put("video",video);obj.put("note","");obj.put("capturedAt",System.currentTimeMillis());
          if(!prefs(this).edit().putString("m:"+key,obj.toString()).commit())continue;
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
    Notification n=new Notification.Builder(this,CH_EVENT)
      .setSmallIcon(android.R.drawable.ic_menu_edit).setContentTitle("방금 촬영한 사진·영상 · 모아 기록")
      .setContentText("여기를 눌러 즉시 기록하거나, 바로 메모에서 입력하세요.")
      .setAutoCancel(true).setContentIntent(tap).addAction(action).setCategory(Notification.CATEGORY_REMINDER)
      .setPriority(Notification.PRIORITY_HIGH).build();
    getSystemService(NotificationManager.class).notify(43000+(key.hashCode()&0x7fff),n);
  }
  @Override public android.os.IBinder onBind(Intent intent){return null;}
  @Override public void onDestroy(){
    stopRequested=true;if(h!=null)h.removeCallbacksAndMessages(null);
    if(observerRegistered)try{getContentResolver().unregisterContentObserver(observer);}catch(Exception ignored){}
    if(worker!=null)worker.quitSafely();
    super.onDestroy();
  }
  public static void updateTile(Context c){
    try{TileService.requestListeningState(c,new ComponentName(c,QuickTile.class));}catch(Exception ignored){}
  }
  public static final class QuickTile extends TileService {
    @Override public void onStartListening(){super.onStartListening();Tile t=getQsTile();if(t!=null){t.setLabel("모아 기록");t.setState(enabled(this)?Tile.STATE_ACTIVE:Tile.STATE_INACTIVE);t.updateTile();}}
    @Override public void onClick(){super.onClick();switchTo(this,!enabled(this));Tile t=getQsTile();if(t!=null){t.setState(enabled(this)?Tile.STATE_ACTIVE:Tile.STATE_INACTIVE);t.updateTile();}}
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
        JSONObject data=new JSONObject(prev);data.put("note",q.toString().trim());data.put("updatedAt",System.currentTimeMillis());
        prefs(c).edit().putString("m:"+key,data.toString()).commit();
        getManager(c).cancel(43000+(key.hashCode()&0x7fff));
      }catch(Exception ignored){}
    }
    private NotificationManager getManager(Context c){return c.getSystemService(NotificationManager.class);}
  }
}
