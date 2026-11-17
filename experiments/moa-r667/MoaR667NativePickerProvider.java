package com.juhyeon.familyjourney;

import android.app.Activity;
import android.app.AlertDialog;
import android.app.Application;
import android.content.ContentProvider;
import android.content.ContentValues;
import android.content.Intent;
import android.content.res.ColorStateList;
import android.database.Cursor;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Color;
import android.graphics.drawable.GradientDrawable;
import android.net.Uri;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.provider.MediaStore;
import android.util.Size;
import android.view.Gravity;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup;
import android.view.Window;
import android.view.WindowManager;
import android.webkit.JavascriptInterface;
import android.webkit.WebView;
import android.widget.FrameLayout;
import android.widget.HorizontalScrollView;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.SeekBar;
import android.widget.TextView;
import android.widget.Toast;
import android.widget.VideoView;
import java.io.InputStream;
import java.lang.ref.WeakReference;
import java.text.DateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import org.json.JSONArray;
import org.json.JSONObject;

/**
 * R667 isolated Native PHOTO-ADD preview.
 * A distinct Activity reads Android MediaStore via ContentResolver.
 * It NEVER refers to MoaR507InlineGalleryProvider, unifiedGallery or
 * MoaLocalAudio: the user-verified PHOTO day owner stays untouched.
 * Provider is process-created before the main activity. Bridge is injected
 * into the existing WebView, with NO reload, periodic polling or JS hot-path
 * evals. All output returns asynchronously on the original host's resume.
 */
public final class MoaR667NativePickerProvider extends ContentProvider
    implements Application.ActivityLifecycleCallbacks {
  private static final Handler MAIN = new Handler(Looper.getMainLooper());
  private static volatile String requestJson;
  private static volatile String resultJson;
  private static WeakReference<WebView> sourceWeb = new WeakReference<>(null);
  private static WeakReference<Activity> sourceActivity = new WeakReference<>(null);
  private static WeakReference<WebView> installedWeb = new WeakReference<>(null);
  private Application app;
  private boolean reloadCheckPending=false;

  private static WebView findWeb(View v) {
    if (v instanceof WebView) return (WebView) v;
    if (v instanceof ViewGroup) {
      ViewGroup g=(ViewGroup)v;
      for (int i=0;i<g.getChildCount();i++) {
        WebView found=findWeb(g.getChildAt(i));
        if (found!=null) return found;
      }
    }
    return null;
  }

  private static boolean isHost(Activity a) {
    return a!=null && "com.juhyeon.familyjourney.HostActivity".equals(a.getClass().getName());
  }
  private void attach(final Activity a, final int attempt) {
    if (!isHost(a)||a.isFinishing()||a.isDestroyed()) return;
    WebView web=findWeb(a.getWindow().getDecorView());
    if(web==null) {
      if(attempt<8) MAIN.postDelayed(()->attach(a,attempt+1),130L);
      return;
    }
    if(installedWeb.get()!=web) {
      web.addJavascriptInterface(new NativeBridge(a,web), "MoaR667NativePicker");
      installedWeb=new WeakReference<>(web);
      ensureBridgeAvailableBeforePicker(a,web);
    }
    sourceWeb=new WeakReference<>(web);
    sourceActivity=new WeakReference<>(a);
  }
  // addJavascriptInterface requires the NEXT page load, never a hot injection.
  // If this is the harmless CALENDAR (not native PHOTO day), do ONE bounded
  // automatic cache refresh on upgrade, preserving IndexedDB/cookies/user data.
  // Do not reload when the active original PHOTO Gallery could be mounted.
  private void ensureBridgeAvailableBeforePicker(Activity a,WebView web) {
    if(reloadCheckPending)return;
    android.content.SharedPreferences prefs=a.getSharedPreferences("moa_r667_bridge",0);
    if(prefs.getBoolean("safe_calendar_reload_done",false))return;
    reloadCheckPending=true;
    MAIN.postDelayed(()->{
      if(a.isFinishing()||a.isDestroyed()||web.getParent()==null){reloadCheckPending=false;return;}
      final String url=web.getUrl();
      if(url==null||!url.startsWith("https://familyjourney.local")){reloadCheckPending=false;return;}
      try{
        web.evaluateJavascript("(function(){var r=document.getElementById('moa-r469-root');return r&&!r.hidden?(r.dataset.page||''):'hidden';})()",state->{
          if("\"calendar\"".equals(state)&&!a.isFinishing()&&!a.isDestroyed()){
            prefs.edit().putBoolean("safe_calendar_reload_done",true).apply();
            web.clearCache(true); // WebView RESOURCE cache, NEVER app data or IndexedDB.
            web.reload(); // Only calendar, never PHOTO day or live native video.
          }
          reloadCheckPending=false;
        });
      }catch(Exception ignored){reloadCheckPending=false;}
    },880L);
  }
  @Override public boolean onCreate() {
    if(getContext()!=null && getContext().getApplicationContext() instanceof Application) {
      app=(Application)getContext().getApplicationContext();
      app.registerActivityLifecycleCallbacks(this);
    }
    return true;
  }
  private static final class NativeBridge {
    private final WeakReference<Activity> activity;
    private final WeakReference<WebView> web;
    NativeBridge(Activity a,WebView w) {activity=new WeakReference<>(a);web=new WeakReference<>(w);}
    @JavascriptInterface public boolean open(String raw) {
      if(raw==null||raw.length()>650000) return false;
      try{
        JSONObject json=new JSONObject(raw);
        JSONArray a=json.optJSONArray("items");
        if(a==null||a.length()==0)return false;
      }catch(Exception e){return false;}
      final Activity owner=activity.get();
      final WebView w=web.get();
      if(!isHost(owner)||w==null)return false;
      sourceWeb=new WeakReference<>(w);sourceActivity=new WeakReference<>(owner);
      requestJson=raw;resultJson=null;
      MAIN.post(()->{
        if(owner.isFinishing()||owner.isDestroyed())return;
        try{
          Intent i=new Intent(owner, NativePickerActivity.class);
          owner.startActivity(i);
        }catch(Exception e){
          try{w.evaluateJavascript("window.__moaR667NativePickerError&&window.__moaR667NativePickerError('native launch failed')",null);}catch(Exception ignored){}
        }
      });
      return true;
    }
    @JavascriptInterface public String version(){return "R667-NATIVE-ISOLATED";}
  }
  private static void complete(JSONObject result) {
    resultJson=result.toString();
  }
  private void deliver(Activity a) {
    if(!isHost(a))return;
    String result=resultJson;
    if(result==null)return;
    WebView web=sourceWeb.get();
    if(web==null)return;
    resultJson=null;
    final String payload=JSONObject.quote(result);
    MAIN.postDelayed(()->{
      if(!isHost(a)||a.isFinishing()||a.isDestroyed()||web.getParent()==null)return;
      web.evaluateJavascript("window.__moaR667NativePickerResult&&window.__moaR667NativePickerResult("+payload+");",null);
    },160);
  }
  @Override public void onActivityCreated(Activity a,Bundle b){if(isHost(a))MAIN.post(()->attach(a,0));}
  @Override public void onActivityStarted(Activity a){if(isHost(a))MAIN.post(()->attach(a,0));}
  @Override public void onActivityResumed(Activity a){if(isHost(a)){MAIN.post(()->attach(a,0));MAIN.postDelayed(()->deliver(a),170);}}
  @Override public void onActivityPaused(Activity a){}
  @Override public void onActivityStopped(Activity a){}
  @Override public void onActivitySaveInstanceState(Activity a,Bundle b){}
  @Override public void onActivityDestroyed(Activity a){
    if(sourceActivity.get()==a){sourceActivity=new WeakReference<>(null);installedWeb=new WeakReference<>(null);}
  }
  @Override public Cursor query(Uri u,String[] projection,String select,String[] args,String order){return null;}
  @Override public String getType(Uri u){return null;}
  @Override public Uri insert(Uri u,ContentValues values){return null;}
  @Override public int delete(Uri u,String where,String[] args){return 0;}
  @Override public int update(Uri u,ContentValues values,String where,String[] args){return 0;}

  public static final class NativePickerActivity extends Activity {
    private static final class Medium {
      String id;boolean video;long time;
      Medium(JSONObject o) {
        id=o.optString("id","");
        video=o.optBoolean("video",false)||id.startsWith("v");
        time=o.optLong("t",0);
      }
      Uri uri() {
        String numeric=id.startsWith("v")?id.substring(1):id;
        return Uri.parse("content://media/external/"+(video?"video":"images")+"/media/"+numeric);
      }
    }
    private final ArrayList<Medium> media=new ArrayList<>();
    private final LinkedHashSet<String> chosen=new LinkedHashSet<>();
    private final ExecutorService io=Executors.newFixedThreadPool(2);
    private final Handler handler=new Handler(Looper.getMainLooper());
    private int index=0,loadEpoch=0;
    private boolean fast=false,railShown=true,fill=false,done=false;
    private String coverId="",bookmarkId="";
    private LinearLayout column;
    private FrameLayout stage;
    private ImageView image;
    private VideoView video;
    private SeekBar videoSeek;
    private TextView title,playButton,chooseButton,fastButton,railButton,fitButton;
    private HorizontalScrollView thumbsScroll;
    private LinearLayout thumbsRow;
    private float downX,downY;
    private final Runnable progress=new Runnable(){
      @Override public void run(){
        if(video!=null&&video.getVisibility()==View.VISIBLE&&videoSeek!=null) {
          int dur=video.getDuration();
          if(dur>0)videoSeek.setProgress((int)(1000L*video.getCurrentPosition()/dur));
        }
        handler.postDelayed(this,220L);
      }
    };
    private int dp(float n){return (int)(n*getResources().getDisplayMetrics().density+.5f);}
    private GradientDrawable shape(int color,float radius) {
      GradientDrawable d=new GradientDrawable();d.setColor(color);d.setCornerRadius(dp(radius));return d;
    }
    private TextView t(String value,int size,int color){
      TextView v=new TextView(this);v.setText(value);v.setTextSize(size);v.setTextColor(color);
      v.setGravity(Gravity.CENTER);v.setIncludeFontPadding(false);return v;
    }
    private TextView button(String text,String label,int size,Runnable action) {
      TextView b=t(text,size,Color.WHITE);b.setContentDescription(label);b.setClickable(true);
      b.setBackground(shape(0x8827252c,12));b.setOnClickListener(v->action.run());return b;
    }
    private void tip(String text){Toast.makeText(this,text,Toast.LENGTH_SHORT).show();}
    @Override public void onCreate(Bundle state) {
      super.onCreate(state);
      requestWindowFeature(Window.FEATURE_NO_TITLE);
      getWindow().setStatusBarColor(Color.WHITE);
      getWindow().setNavigationBarColor(Color.WHITE);
      getWindow().getDecorView().setSystemUiVisibility(View.SYSTEM_UI_FLAG_LIGHT_STATUS_BAR|View.SYSTEM_UI_FLAG_LIGHT_NAVIGATION_BAR);
      try {
        JSONObject req=new JSONObject(requestJson==null?"{}":requestJson);
        JSONArray arr=req.optJSONArray("items");
        if(arr!=null)for(int i=0;i<arr.length()&&i<1400;i++){
          JSONObject o=arr.optJSONObject(i);if(o==null)continue;
          Medium m=new Medium(o);
          if(m.id.matches("v?[0-9]{1,19}"))media.add(m);
        }
        JSONArray selected=req.optJSONArray("selected");
        if(selected!=null)for(int i=0;i<selected.length();i++) {
          String id=selected.optString(i,"");
          if(id.matches("v?[0-9]{1,19}"))chosen.add(id);
        }
        index=Math.max(0,Math.min(media.size()-1,req.optInt("index",0)));
      }catch(Exception ignored){}
      if(media.isEmpty()){tip("사진을 불러오지 못했습니다");finish();return;}
      renderRoot();show(index);
      handler.postDelayed(progress,220);
    }
    private void renderRoot(){
      column=new LinearLayout(this);column.setOrientation(LinearLayout.VERTICAL);column.setBackgroundColor(Color.WHITE);
      setContentView(column);
      LinearLayout header=new LinearLayout(this);header.setGravity(Gravity.CENTER_VERTICAL);header.setPadding(dp(12),dp(6),dp(12),dp(6));header.setBackgroundColor(Color.WHITE);
      column.addView(header,new LinearLayout.LayoutParams(-1,dp(54)));
      TextView close=t("‹",32,0xff302c33);close.setContentDescription("사진 추가 목록으로 돌아가기");
      header.addView(close,new LinearLayout.LayoutParams(dp(38),-1));
      close.setOnClickListener(v->exit());
      title=t("",14,0xff25252a);title.setGravity(Gravity.CENTER_VERTICAL);
      header.addView(title,new LinearLayout.LayoutParams(0,-1,1));
      TextView more=t("⋮",21,0xff302c33);header.addView(more,new LinearLayout.LayoutParams(dp(35),-1));
      more.setContentDescription("사진 정보");more.setOnClickListener(v->info());

      stage=new FrameLayout(this);stage.setBackground(shape(Color.BLACK,23));
      stage.setClipToOutline(true);
      LinearLayout.LayoutParams stageParams=new LinearLayout.LayoutParams(-1,0,1);
      stageParams.setMargins(dp(10),0,dp(10),dp(12));column.addView(stage,stageParams);
      image=new ImageView(this);image.setBackgroundColor(Color.BLACK);image.setScaleType(ImageView.ScaleType.FIT_CENTER);
      image.setOnTouchListener((v,event)->swipe(event));
      stage.addView(image,new FrameLayout.LayoutParams(-1,-1));
      video=new VideoView(this);video.setVisibility(View.GONE);
      video.setOnTouchListener((v,event)->swipe(event));
      stage.addView(video,new FrameLayout.LayoutParams(-1,-1));
      video.setOnPreparedListener(mp->{mp.setLooping(false);mp.start();});
      video.setOnCompletionListener(mp->{if(playButton!=null)playButton.setText("▶");});
      // Native video seek + pause; never create an HTML video player.
      LinearLayout videoControls=new LinearLayout(this);videoControls.setGravity(Gravity.CENTER_VERTICAL);
      videoControls.setBackground(shape(0xAA17171B,13));
      videoControls.setPadding(dp(7),dp(3),dp(7),dp(3));
      FrameLayout.LayoutParams vcp=new FrameLayout.LayoutParams(-1,dp(43),Gravity.BOTTOM);
      vcp.setMargins(dp(18),0,dp(18),dp(162));stage.addView(videoControls,vcp);
      playButton=button("▶","동영상 재생 또는 정지",16,()->{
        if(video.getVisibility()!=View.VISIBLE)return;
        if(video.isPlaying()){video.pause();playButton.setText("▶");}
        else {video.start();playButton.setText("Ⅱ");}
      });
      videoControls.addView(playButton,new LinearLayout.LayoutParams(dp(37),dp(36)));
      videoSeek=new SeekBar(this);videoSeek.setMax(1000);videoSeek.setProgressTintList(ColorStateList.valueOf(Color.WHITE));
      videoControls.addView(videoSeek,new LinearLayout.LayoutParams(0,dp(37),1));
      videoSeek.setOnSeekBarChangeListener(new SeekBar.OnSeekBarChangeListener(){
        @Override public void onStartTrackingTouch(SeekBar b){}
        @Override public void onStopTrackingTouch(SeekBar b){}
        @Override public void onProgressChanged(SeekBar b,int n,boolean fromUser){
          if(fromUser&&video.getDuration()>0) video.seekTo((int)(video.getDuration()*(n/1000.0)));
        }
      });
      TextView mute=button("♬","동영상 음소거",15,()->{
        // VideoView has no direct stable public mute API; expose native stream controls.
        tip("음량은 휴대폰 미디어 볼륨으로 조절하세요");
      });
      videoControls.addView(mute,new LinearLayout.LayoutParams(dp(33),dp(34)));

      thumbsScroll=new HorizontalScrollView(this);thumbsScroll.setHorizontalScrollBarEnabled(false);
      thumbsScroll.setFillViewport(false);thumbsScroll.setBackground(shape(0x99141218,12));
      FrameLayout.LayoutParams trp=new FrameLayout.LayoutParams(-1,dp(80),Gravity.BOTTOM);
      trp.setMargins(dp(8),0,dp(8),dp(55));stage.addView(thumbsScroll,trp);
      thumbsRow=new LinearLayout(this);thumbsRow.setGravity(Gravity.CENTER_VERTICAL);
      thumbsScroll.addView(thumbsRow,new HorizontalScrollView.LayoutParams(-2,-1));

      LinearLayout bar=new LinearLayout(this);bar.setGravity(Gravity.CENTER);
      bar.setBackground(shape(0xC326252C,17));
      FrameLayout.LayoutParams bp=new FrameLayout.LayoutParams(-1,dp(49),Gravity.BOTTOM);
      bp.setMargins(dp(10),0,dp(10),dp(7));stage.addView(bar,bp);
      addTool(bar,"☆","대표 사진 지정",()->{coverId=media.get(index).id;tip("대표 사진은 목록으로 돌아가 적용됩니다");});
      fastButton=addTool(bar,"»","빠른 넘김",()->{fast=!fast;fastButton.setText(fast?"≫":"»");});
      addTool(bar,"↗","공유",this::share);
      addTool(bar,"⌖","촬영 시간과 위치",this::info);
      addTool(bar,"▧","지도 열기",this::openMap);
      addTool(bar,"♧","네이버 저장 요청",()->{bookmarkId=media.get(index).id;tip("돌아간 뒤 네이버 위치 저장을 연결합니다");});
      railButton=addTool(bar,"▥","필름스트립 펼치기 또는 접기",()->{
        railShown=!railShown;thumbsScroll.setVisibility(railShown?View.VISIBLE:View.GONE);
      });
      fitButton=addTool(bar,"⛶","사진 전체화면 또는 맞춤",()->{
        fill=!fill;image.setScaleType(fill?ImageView.ScaleType.CENTER_CROP:ImageView.ScaleType.FIT_CENTER);
      });
      chooseButton=addTool(bar,"⊕","현재 사진 선택 추가 또는 해제",this::toggle);
      // One independent native Activity handles the entire enlarged PHOTO-ADD UI.
    }
    private TextView addTool(LinearLayout row,String glyph,String description,Runnable action){
      TextView v=button(glyph,description,19,action);
      LinearLayout.LayoutParams lp=new LinearLayout.LayoutParams(0,dp(42),1);
      lp.setMargins(dp(1),0,dp(1),0);row.addView(v,lp);return v;
    }
    private boolean swipe(MotionEvent e){
      switch(e.getActionMasked()){
        case MotionEvent.ACTION_DOWN:downX=e.getX();downY=e.getY();return true;
        case MotionEvent.ACTION_UP:
          float dx=e.getX()-downX,dy=e.getY()-downY;
          if(Math.abs(dx)>dp(60)&&Math.abs(dx)>Math.abs(dy)*1.25){
            show(Math.max(0,Math.min(media.size()-1,index+(dx<0?1:-1))));
          }
          return true;
        default:return true;
      }
    }
    private Bitmap readBitmap(Uri uri,int max){
      try(InputStream a=getContentResolver().openInputStream(uri)){
        if(a==null)return null;
        BitmapFactory.Options bounds=new BitmapFactory.Options();bounds.inJustDecodeBounds=true;
        BitmapFactory.decodeStream(a,null,bounds);
        int sample=1,w=bounds.outWidth,h=bounds.outHeight;
        while((w/sample)>max*1.5||(h/sample)>max*2.4)sample*=2;
        BitmapFactory.Options opt=new BitmapFactory.Options();opt.inSampleSize=sample;
        try(InputStream b=getContentResolver().openInputStream(uri)){
          return b==null?null:BitmapFactory.decodeStream(b,null,opt);
        }
      }catch(Exception e){return null;}
    }
    private void show(int wanted){
      if(wanted<0||wanted>=media.size())return;
      index=wanted;Medium item=media.get(index);
      title.setText((index+1)+" / "+media.size()+"  ·  "+DateFormat.getDateInstance().format(new Date(item.time>0?item.time:System.currentTimeMillis())));
      boolean videoFile=item.video;int epoch=++loadEpoch;
      try{video.stopPlayback();}catch(Exception ignored){}
      image.setImageBitmap(null);
      video.setVisibility(videoFile?View.VISIBLE:View.GONE);
      image.setVisibility(videoFile?View.GONE:View.VISIBLE);
      videoSeek.setProgress(0);
      playButton.setText("▶");
      if(videoFile){
        try{video.setVideoURI(item.uri());video.requestFocus();}catch(Exception ex){tip("영상 원본을 열 수 없습니다");}
      } else {
        io.execute(()->{
          final Bitmap b=readBitmap(item.uri(),Math.max(1200,getResources().getDisplayMetrics().widthPixels));
          runOnUiThread(()->{if(!isFinishing()&&index==wanted&&epoch==loadEpoch){if(b!=null)image.setImageBitmap(b);else tip("원본 사진을 읽지 못했습니다");}});
        });
      }
      chooseButton.setText(chosen.contains(item.id)?"⊖":"⊕");
      if(!fast){stage.setAlpha(.87f);stage.animate().alpha(1f).setDuration(130).start();}
      renderRail();
    }
    private void renderRail(){
      thumbsRow.removeAllViews();if(!railShown)return;
      int first=Math.max(0,index-15),last=Math.min(media.size(),index+16);
      for(int n=first;n<last;n++){
        final int p=n;Medium item=media.get(p);
        ImageView thumb=new ImageView(this);thumb.setScaleType(ImageView.ScaleType.CENTER_CROP);
        GradientDrawable bg=shape(0xFF332C38,9);
        bg.setStroke(dp(p==index?3:1),p==index?Color.WHITE:0x66555555);
        thumb.setBackground(bg);thumb.setClipToOutline(true);
        LinearLayout.LayoutParams lp=new LinearLayout.LayoutParams(dp(62),dp(p==index?67:60));
        lp.setMargins(dp(3),dp(3),dp(3),dp(3));thumbsRow.addView(thumb,lp);
        thumb.setOnClickListener(v->show(p));
        io.execute(()->{
          Bitmap bit=null;
          try{bit=getContentResolver().loadThumbnail(item.uri(),new Size(dp(100),dp(100)),null);}catch(Exception ignored){}
          final Bitmap b=bit;
          runOnUiThread(()->{if(!isFinishing()&&thumb.getParent()!=null&&b!=null)thumb.setImageBitmap(b);});
        });
      }
      thumbsScroll.post(()->{
        View current=thumbsRow.getChildAt(index-first);
        if(current!=null)thumbsScroll.smoothScrollTo(Math.max(0,current.getLeft()-thumbsScroll.getWidth()/2+current.getWidth()/2),0);
      });
    }
    private void toggle(){
      String id=media.get(index).id;
      if(!chosen.remove(id))chosen.add(id);
      chooseButton.setText(chosen.contains(id)?"⊖":"⊕");
      tip("선택 "+chosen.size()+"개");
    }
    private void share(){
      Medium m=media.get(index);
      try{
        Intent i=new Intent(Intent.ACTION_SEND);i.setType(m.video?"video/*":"image/*");
        i.putExtra(Intent.EXTRA_STREAM,m.uri());i.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION);
        startActivity(Intent.createChooser(i,"사진·영상 공유"));
      }catch(Exception e){tip("공유할 수 없습니다");}
    }
    private void info(){
      Medium m=media.get(index);
      String message="촬영 날짜: "+DateFormat.getDateTimeInstance().format(new Date(m.time>0?m.time:System.currentTimeMillis()))+
      "\n형식: "+(m.video?"동영상":"사진")+"\n원본 미디어 ID: "+m.id;
      new AlertDialog.Builder(this).setTitle("사진 정보").setMessage(message).setPositiveButton("확인",null).show();
    }
    private void openMap(){
      // The original Naver bridge is not re-used or overridden.
      // Request original app's location action after returning to PHOTO-ADD.
      bookmarkId=media.get(index).id;tip("목록으로 돌아가 촬영 위치 정보를 확인합니다");
    }
    private void exit(){
      if(done)return;done=true;
      try{
        JSONObject result=new JSONObject();
        JSONArray selected=new JSONArray();
        for(String s:chosen)selected.put(s);
        result.put("selected",selected);result.put("index",index);
        result.put("coverId",coverId);result.put("bookmarkId",bookmarkId);
        complete(result);
      }catch(Exception ignored){}
      finish();
    }
    @Override public void onBackPressed(){exit();}
    @Override protected void onDestroy(){
      handler.removeCallbacks(progress);io.shutdownNow();
      if(video!=null)try{video.stopPlayback();}catch(Exception ignored){}
      if(!done)exit();
      super.onDestroy();
    }
  }
}
