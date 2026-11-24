package com.juhyeon.familyjourney;

import android.app.Activity;
import android.app.Application;
import android.app.Dialog;
import android.app.Notification;
import android.app.NotificationManager;
import android.content.ContentProvider;
import android.content.ContentUris;
import android.content.ContentValues;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.pm.PackageManager;
import android.database.Cursor;
import android.graphics.Bitmap;
import android.graphics.Color;
import android.graphics.Typeface;
import android.graphics.drawable.GradientDrawable;
import android.net.Uri;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.provider.MediaStore;
import android.service.notification.StatusBarNotification;
import android.util.Size;
import android.view.Gravity;
import android.view.View;
import android.view.ViewGroup;
import android.view.WindowManager;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ScrollView;
import android.widget.TextView;
import org.json.JSONObject;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

/**
 * R709 preview-only sidecar. The R707 Golden recorder, its listeners,
 * camera watcher, native diary ACK, media originals and indexed diary are
 * completely untouched. This provider adds a view and decorates the exact
 * already-posted notification, keeping its original actions/PendingIntents.
 */
public final class MoaR709PreviewProvider extends ContentProvider {
  private static final String PREF="moa_camera_native_v1";
  private static final String CHANNEL="moa_moment_capture_alerts_v2";
  private static final String MEMO_ACTIVITY="com.juhyeon.familyjourney.MoaMomentMemoRecorderActivity";
  private static final String MARKER="moa-r709-exact-media-preview";
  private static final int PINK=0xffe92865;
  private static final Handler MAIN=new Handler(Looper.getMainLooper());
  private static final ExecutorService WORK=Executors.newSingleThreadExecutor(r->{
    Thread t=new Thread(r,"MOA-R709-Preview");t.setDaemon(true);return t;
  });
  private SharedPreferences prefs;
  private SharedPreferences.OnSharedPreferenceChangeListener listener;

  @Override public boolean onCreate(){
    final Context c=getContext();
    if(c==null)return true;
    prefs=c.getSharedPreferences(PREF,Context.MODE_PRIVATE);
    listener=(state,key)->{
      if(key==null||!key.startsWith("m:"))return;
      String id=key.substring(2);
      if(!valid(id))return;
      String raw=state.getString(key,null);
      if(raw==null)return;
      try{
        JSONObject d=new JSONObject(raw);
        if(!id.equals(d.optString("id"))||d.optBoolean("memoSaved",false))return;
        long age=System.currentTimeMillis()-d.optLong("capturedAt",0L);
        if(age<0||age>30000L)return;
        MAIN.postDelayed(()->decorateNotification(c.getApplicationContext(),id,0),1000L);
      }catch(Exception ignored){/* A malformed draft must not block saving. */}
    };
    prefs.registerOnSharedPreferenceChangeListener(listener);
    Context app=c.getApplicationContext();
    if(app instanceof Application)((Application)app).registerActivityLifecycleCallbacks(new Application.ActivityLifecycleCallbacks(){
      @Override public void onActivityResumed(Activity a){if(MEMO_ACTIVITY.equals(a.getClass().getName()))MAIN.post(()->installCard(a));}
      @Override public void onActivityCreated(Activity a,Bundle b){}
      @Override public void onActivityStarted(Activity a){}
      @Override public void onActivityPaused(Activity a){}
      @Override public void onActivityStopped(Activity a){}
      @Override public void onActivitySaveInstanceState(Activity a,Bundle b){}
      @Override public void onActivityDestroyed(Activity a){}
    });
    return true;
  }

  private static boolean valid(String id){return id!=null&&id.matches("(?:v[0-9]{1,18}|[0-9]{1,19})");}
  private static JSONObject draft(Context c,String id){
    if(!valid(id))return null;
    try{
      String raw=c.getSharedPreferences(PREF,Context.MODE_PRIVATE).getString("m:"+id,null);
      if(raw==null)return null;
      JSONObject j=new JSONObject(raw);
      if(!id.equals(j.optString("id")))return null;
      return j;
    }catch(Exception ignored){return null;}
  }
  private static Uri mediaUri(String id){
    long mediaId=Long.parseLong(id.startsWith("v")?id.substring(1):id);
    return ContentUris.withAppendedId(id.startsWith("v")?
        MediaStore.Video.Media.EXTERNAL_CONTENT_URI:MediaStore.Images.Media.EXTERNAL_CONTENT_URI,mediaId);
  }
  private static boolean available(Context c,Uri uri){
    try(Cursor q=c.getContentResolver().query(uri,new String[]{MediaStore.MediaColumns._ID},null,null,null)){
      return q!=null&&q.moveToFirst();
    }catch(Exception ignored){return false;}
  }
  private static Bitmap thumbnail(Context c,String id,int w,int h){
    try{
      Uri u=mediaUri(id);
      if(!available(c,u))return null;
      return c.getContentResolver().loadThumbnail(u,new Size(w,h),null);
    }catch(Exception ignored){return null;}
  }
  private static String stamp(JSONObject d){
    long at=d.optLong("at",0L);
    if(at<=0)return "촬영 시각 확인 중";
    return new SimpleDateFormat("M월 d일 a h:mm",Locale.KOREA).format(new Date(at));
  }
  private static GradientDrawable rounded(Context c,int color,int radius){
    GradientDrawable g=new GradientDrawable();g.setColor(color);
    g.setCornerRadius(dp(c,radius));return g;
  }
  private static int dp(Context c,int n){return (int)(n*c.getResources().getDisplayMetrics().density+.5f);}
  private static TextView text(Context c,String value,int sp,int color,boolean bold){
    TextView v=new TextView(c);v.setText(value);v.setTextSize(sp);v.setTextColor(color);
    if(bold)v.setTypeface(null,Typeface.BOLD);return v;
  }
  private static View findEdit(View root){
    if(root instanceof EditText)return root;
    if(root instanceof ViewGroup){
      ViewGroup g=(ViewGroup)root;
      for(int i=0;i<g.getChildCount();i++){
        View got=findEdit(g.getChildAt(i));if(got!=null)return got;
      }
    }
    return null;
  }
  private static void installCard(Activity a){
    if(a.isFinishing()||a.isDestroyed())return;
    try{
      String id=a.getIntent()==null?null:a.getIntent().getStringExtra("id");
      if(!valid(id))return;
      JSONObject d=draft(a,id);
      if(d==null)return;
      ViewGroup decor=a.findViewById(android.R.id.content);
      if(decor==null)return;
      View previous=decor.findViewWithTag(MARKER);
      if(previous!=null)return;
      View edit=findEdit(decor);
      if(edit==null||!(edit.getParent() instanceof LinearLayout))return;
      LinearLayout parent=(LinearLayout)edit.getParent();
      int position=parent.indexOfChild(edit);
      if(position<0)return;

      LinearLayout card=new LinearLayout(a);card.setTag(MARKER);
      card.setOrientation(LinearLayout.HORIZONTAL);card.setGravity(Gravity.CENTER_VERTICAL);
      card.setPadding(dp(a,10),dp(a,10),dp(a,10),dp(a,10));
      card.setBackground(rounded(a,0xfff7f3f6,15));
      LinearLayout.LayoutParams cp=new LinearLayout.LayoutParams(-1,-2);
      cp.bottomMargin=dp(a,12);
      parent.addView(card,position,cp);

      ImageView image=new ImageView(a);image.setScaleType(ImageView.ScaleType.CENTER_CROP);
      image.setBackground(rounded(a,0xffebe2e8,12));
      image.setClipToOutline(true);
      card.addView(image,new LinearLayout.LayoutParams(dp(a,100),dp(a,100)));
      LinearLayout labels=new LinearLayout(a);labels.setOrientation(LinearLayout.VERTICAL);
      labels.setPadding(dp(a,12),0,0,0);
      card.addView(labels,new LinearLayout.LayoutParams(0,-2,1f));
      labels.addView(text(a,(id.startsWith("v")?"▶ 영상":"▣ 사진")+" · 지금 기록할 원본",14,0xff29303c,true));
      labels.addView(text(a,stamp(d),13,0xff6e6771,false));
      TextView status=text(a,"미리보기를 불러오는 중…",12,0xff7b707b,false);
      labels.addView(status);
      card.setContentDescription("현재 메모 대상 "+(id.startsWith("v")?"영상 ":"사진 ")+stamp(d));
      card.setOnClickListener(v->showMedia(a,id));

      WORK.execute(()->{
        Bitmap bmp=thumbnail(a.getApplicationContext(),id,360,360);
        MAIN.post(()->{
          if(a.isDestroyed()||card.getParent()==null)return;
          if(bmp==null){status.setText("원본을 확인할 수 없음 · 다른 사진으로 바꾸지 않음");
            card.setOnClickListener(null);
          }else{
            image.setImageBitmap(bmp);
            status.setText(id.startsWith("v")?"눌러서 원본 영상 재생":"눌러서 사진 크게 확인");
          }
        });
      });
    }catch(Throwable ignored){/* Never block the native recorder or its Save listener. */}
  }
  private static void showMedia(Activity a,String id){
    try{
      Uri uri=mediaUri(id);
      if(id.startsWith("v")){
        Intent intent=new Intent(Intent.ACTION_VIEW).setDataAndType(uri,"video/*")
          .addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION);
        a.startActivity(intent);return;
      }
      Dialog dialog=new Dialog(a);
      ImageView view=new ImageView(a);
      view.setScaleType(ImageView.ScaleType.FIT_CENTER);
      view.setBackgroundColor(Color.BLACK);
      view.setOnClickListener(v->dialog.dismiss());
      dialog.setContentView(view);
      WindowManager.LayoutParams wp=dialog.getWindow().getAttributes();
      wp.width=WindowManager.LayoutParams.MATCH_PARENT;
      wp.height=WindowManager.LayoutParams.MATCH_PARENT;
      dialog.getWindow().setAttributes(wp);
      dialog.show();
      WORK.execute(()->{
        Bitmap bmp=thumbnail(a.getApplicationContext(),id,1080,1440);
        MAIN.post(()->{
          if(!dialog.isShowing())return;
          if(bmp!=null)view.setImageBitmap(bmp);
          else dialog.dismiss();
        });
      });
    }catch(Exception ignored){/* Return to intact text and voice editor. */}
  }

  private static void decorateNotification(Context c,String id,int retry){
    JSONObject d=draft(c,id);
    if(d==null||d.optBoolean("memoSaved",false))return;
    WORK.execute(()->{
      Bitmap bmp=thumbnail(c,id,400,340);
      if(bmp==null)return;
      MAIN.post(()->{
        try{
          NotificationManager nm=c.getSystemService(NotificationManager.class);
          if(nm==null)return;
          int expected=43000+(id.hashCode()&0x7fff);
          StatusBarNotification found=null;
          for(StatusBarNotification s:nm.getActiveNotifications()){
            if(s.getId()==expected && CHANNEL.equals(s.getNotification().getChannelId())){
              found=s;break;
            }
          }
          if(found==null){
            if(retry<2)MAIN.postDelayed(()->decorateNotification(c,id,retry+1),600L);
            return;
          }
          Notification original=found.getNotification();
          Notification.Builder builder=Notification.Builder.recoverBuilder(c,original);
          builder.setLargeIcon(bmp)
            .setStyle(new Notification.BigPictureStyle().bigPicture(bmp))
            .setContentText((id.startsWith("v")?"영상":"사진")+" · "+stamp(d)+" · 눌러서 확인")
            .setVisibility(Notification.VISIBILITY_PRIVATE);
          Notification publicOnly=new Notification.Builder(c,CHANNEL)
            .setSmallIcon(android.R.drawable.ic_menu_edit)
            .setContentTitle("모아 · 새로운 촬영 기록")
            .setContentText("잠금 해제 후 사진과 기록을 확인하세요")
            .build();
          builder.setPublicVersion(publicOnly);
          // Original contentIntent, RemoteInput actions and dismiss flags survive
          // recoverBuilder; never redirect or replace an in-progress draft.
          nm.notify(found.getTag(),found.getId(),builder.build());
        }catch(Exception ignored){/* Original notification remains functional. */}
      });
    });
  }

  @Override public Cursor query(Uri uri,String[] projection,String selection,String[] args,String sort){return null;}
  @Override public String getType(Uri uri){return null;}
  @Override public Uri insert(Uri uri,ContentValues values){return null;}
  @Override public int delete(Uri uri,String selection,String[] args){return 0;}
  @Override public int update(Uri uri,ContentValues values,String selection,String[] args){return 0;}
}
