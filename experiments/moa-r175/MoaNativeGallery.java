package com.juhyeon.familyjourney;

import android.app.Activity;
import android.content.ContentResolver;
import android.content.ContentUris;
import android.content.ContentValues;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.graphics.Rect;
import android.graphics.RectF;
import android.graphics.SurfaceTexture;
import android.media.MediaMetadataRetriever;
import android.media.MediaPlayer;
import android.net.Uri;
import android.os.Build;
import android.os.CancellationSignal;
import android.os.Environment;
import android.os.Handler;
import android.os.Looper;
import android.os.SystemClock;
import android.provider.MediaStore;
import android.util.LruCache;
import android.util.Size;
import android.view.Gravity;
import android.view.MotionEvent;
import android.view.Surface;
import android.view.TextureView;
import android.view.VelocityTracker;
import android.view.View;
import android.view.ViewGroup;
import android.view.animation.DecelerateInterpolator;
import android.animation.ValueAnimator;
import android.widget.Button;
import android.widget.FrameLayout;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.SeekBar;
import android.widget.TextView;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.ArrayList;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

/**
 * R175: gallery-owned single-native-compositor media browsing.
 * New opt-in presentation on top of the existing WebView; all original Diary
 * files, voice/ASR, public backups, map and photo indexes remain unchanged.
 *
 * The full-page swipe and the thumbnail rail share ONE floating position,
 * updated on native touch frames. Only three full-photo pages are instantiated;
 * only nearby media thumbnails are cached. Video uses the same stage with
 * TextureView+MediaPlayer, playing muted as soon as ready, not a new Activity.
 * Never imports or invokes Samsung's proprietary Gallery APK code.
 */
public final class MoaNativeGallery {
 private final Activity activity;
 private final Handler main=new Handler(Looper.getMainLooper());
 private final ExecutorService background=Executors.newFixedThreadPool(2);
 private final LruCache<String,Bitmap> posters=new LruCache<String,Bitmap>(20*1024*1024){
  @Override protected int sizeOf(String k,Bitmap b){return b==null?0:b.getByteCount();}
 };
 private final LruCache<String,Bitmap> full=new LruCache<String,Bitmap>(42*1024*1024){
  @Override protected int sizeOf(String k,Bitmap b){return b==null?0:b.getByteCount();}
 };
 private final ArrayList<String> ids=new ArrayList<>();
 private FrameLayout host,stage;private GalleryRail rail;
 private FrameLayout[] pages=new FrameLayout[3];
 private ImageView[] images=new ImageView[3];
 private TextView header,videoTime,videoStatus;
 private Button pause,mute,still;
 private LinearLayout videoControls;
 private SeekBar seek;
 private TextureView texture;
 private MediaPlayer media;
 private Surface mediaSurface;
 private boolean prepared,muted=true,seekInProgress,open,browsingRail;
 private int index,loadToken,videoToken;
 private float fingerOffset;
 private ValueAnimator motion;
 private String currentDay="";
 private Runnable ticker;
 private android.window.OnBackInvokedCallback backCallback;
 private boolean backRegistered;
 private int savedSystemUi;

 public MoaNativeGallery(Activity activity){this.activity=activity;}
 private int dp(float x){return (int)(x*activity.getResources().getDisplayMetrics().density+.5f);}
 private boolean video(String id){return id!=null&&id.startsWith("v");}
 private Uri uri(String id){
  if(id==null||!id.matches("v?[0-9]{1,18}"))return null;
  try{
   long n=Long.parseLong(video(id)?id.substring(1):id);
   Uri root=video(id)?MediaStore.Video.Media.EXTERNAL_CONTENT_URI:MediaStore.Images.Media.EXTERNAL_CONTENT_URI;
   return ContentUris.withAppendedId(root,n);
  }catch(Exception e){return null;}
 }
 public boolean isOpen(){return open;}
 public boolean open(String packed,int selected,String date){
  if(Looper.myLooper()!=Looper.getMainLooper())return false;
  org.json.JSONArray items;
  try{items=new org.json.JSONArray(packed);}catch(Exception e){return false;}
  if(items.length()<1||items.length()>10000)return false;
  ArrayList<String> validated=new ArrayList<>();
  for(int i=0;i<items.length();i++){
   String s=items.optString(i,"");if(uri(s)==null)return false;validated.add(s);
  }
  close();browsingRail=false;ids.addAll(validated);index=Math.max(0,Math.min(selected,ids.size()-1));
  currentDay=date==null?"":date.replaceAll("[^0-9-]","");
  FrameLayout container=activity.findViewById(android.R.id.content);
  if(container==null)return false;
  host=new FrameLayout(activity);host.setBackgroundColor(Color.BLACK);
  host.setClickable(true);host.setFocusableInTouchMode(true);
  container.addView(host,new FrameLayout.LayoutParams(-1,-1));
  stage=new FrameLayout(activity);stage.setBackgroundColor(Color.BLACK);
  FrameLayout.LayoutParams stagePos=new FrameLayout.LayoutParams(-1,-1);
  stagePos.topMargin=dp(48);stagePos.bottomMargin=dp(165);
  host.addView(stage,stagePos);
  for(int j=0;j<3;j++){
   FrameLayout card=new FrameLayout(activity);
   ImageView picture=new ImageView(activity);picture.setScaleType(ImageView.ScaleType.FIT_CENTER);
   picture.setBackgroundColor(Color.BLACK);picture.setClickable(false);
   card.addView(picture,new FrameLayout.LayoutParams(-1,-1));
   pages[j]=card;images[j]=picture;
   stage.addView(card,new FrameLayout.LayoutParams(-1,-1));
  }
  View touch=new View(activity);touch.setBackgroundColor(Color.TRANSPARENT);
  stage.addView(touch,new FrameLayout.LayoutParams(-1,-1));
  touch.setOnTouchListener(new SwipeHandler(false));
  header=new TextView(activity);header.setTextColor(Color.WHITE);header.setTextSize(15);
  header.setGravity(Gravity.CENTER_VERTICAL);header.setPadding(dp(17),0,0,0);
  FrameLayout.LayoutParams headPos=new FrameLayout.LayoutParams(-1,dp(48),Gravity.TOP);
  host.addView(header,headPos);
  Button back=button("‹  닫기",15);FrameLayout.LayoutParams bpos=new FrameLayout.LayoutParams(dp(78),dp(44),Gravity.TOP|Gravity.LEFT);
  host.addView(back,bpos);back.setOnClickListener(v->close());header.setPadding(dp(95),0,dp(7),0);
  LinearLayout lower=new LinearLayout(activity);lower.setOrientation(LinearLayout.VERTICAL);lower.setBackgroundColor(0xff0a0a0c);
  FrameLayout.LayoutParams lowerPos=new FrameLayout.LayoutParams(-1,dp(165),Gravity.BOTTOM);
  host.addView(lower,lowerPos);
  videoControls=new LinearLayout(activity);videoControls.setGravity(Gravity.CENTER_VERTICAL);
  pause=button("Ⅱ",18);mute=button("소리 켜기",12);still=button("장면 저장",12);
  pause.setOnClickListener(v->toggle());mute.setOnClickListener(v->toggleMute());
  still.setOnClickListener(v->capture());
  videoControls.addView(pause,new LinearLayout.LayoutParams(dp(52),dp(43)));
  videoControls.addView(mute,new LinearLayout.LayoutParams(dp(90),dp(43)));
  videoControls.addView(still,new LinearLayout.LayoutParams(dp(100),dp(43)));
  videoTime=new TextView(activity);videoTime.setTextColor(0xffdddddd);videoTime.setTextSize(11);videoTime.setText("00:00 / 00:00");
  videoTime.setGravity(Gravity.CENTER);
  videoControls.addView(videoTime,new LinearLayout.LayoutParams(0,dp(43),1));
  lower.addView(videoControls,new LinearLayout.LayoutParams(-1,dp(45)));
  seek=new SeekBar(activity);seek.setMax(1000);seek.setOnSeekBarChangeListener(new SeekBar.OnSeekBarChangeListener(){
   public void onStartTrackingTouch(SeekBar bar){seekInProgress=true;}
   public void onStopTrackingTouch(SeekBar bar){seekInProgress=false;try{if(media!=null&&prepared)media.seekTo(bar.getProgress());}catch(Exception ignored){}}
   public void onProgressChanged(SeekBar bar,int p,boolean from){}}
  );lower.addView(seek,new LinearLayout.LayoutParams(-1,dp(36)));
  rail=new GalleryRail();lower.addView(rail,new LinearLayout.LayoutParams(-1,dp(72)));
  open=true;registerBack();refreshPages();stage.post(()->{if(open)updatePosition(0);});prepareCurrentVideo();
  host.requestFocus();return true;
 }
 private Button button(String label,int size){Button b=new Button(activity);b.setAllCaps(false);b.setText(label);b.setTextSize(size);
  b.setTextColor(-1);b.setBackgroundTintList(android.content.res.ColorStateList.valueOf(0xff22242b));
  b.setMinHeight(0);b.setMinimumHeight(0);b.setMinWidth(0);b.setMinimumWidth(0);return b;}
 private void registerBack(){if(Build.VERSION.SDK_INT>=33){
  try{backCallback=()->close();activity.getOnBackInvokedDispatcher().registerOnBackInvokedCallback(
    android.window.OnBackInvokedDispatcher.PRIORITY_OVERLAY,backCallback);backRegistered=true;}catch(Exception ignored){}
 }}
 public void close(){
  if(Looper.myLooper()!=Looper.getMainLooper()){main.post(this::close);return;}
  open=false;loadToken++;videoToken++;
  if(motion!=null){motion.cancel();motion=null;}
  teardownPlayer();
  if(backRegistered&&Build.VERSION.SDK_INT>=33)try{activity.getOnBackInvokedDispatcher().unregisterOnBackInvokedCallback(backCallback);}catch(Exception ignored){}
  backRegistered=false;backCallback=null;
  if(host!=null&&host.getParent() instanceof ViewGroup)((ViewGroup)host.getParent()).removeView(host);
  host=null;stage=null;rail=null;ids.clear();
 }
 private void refreshPages(){
  if(!open)return;
  header.setText((currentDay.isEmpty()?"사진·영상":currentDay)+"   "+(index+1)+" / "+ids.size());
  for(int j=0;j<3;j++){
   final int p=index+j-1;images[j].setImageDrawable(null);
   pages[j].setVisibility(p>=0&&p<ids.size()?View.VISIBLE:View.INVISIBLE);
   if(p<0||p>=ids.size())continue;
   final String id=ids.get(p);Bitmap bitmap=full.get(id);
   if(bitmap==null)bitmap=posters.get(id);
   if(bitmap!=null)images[j].setImageBitmap(bitmap);
   final int generation=loadToken;final ImageView target=images[j];final int slot=j;
   // Only 3 full images. Neighbor photos load in the background with downsampling;
   // videos use their MediaStore thumbnail as poster until first decoder frame.
   if(browsingRail)continue;
   background.execute(()->{
    Bitmap result=getBitmap(id,!video(id));
    main.post(()->{if(open&&generation==loadToken&&p==index+slot-1&&target.isAttachedToWindow()&&result!=null){
      target.setImageBitmap(result);if(rail!=null)rail.invalidate();
    }});
   });
  }
  videoControls.setVisibility(video(ids.get(index))?View.VISIBLE:View.INVISIBLE);
  seek.setVisibility(video(ids.get(index))?View.VISIBLE:View.INVISIBLE);
  if(rail!=null){rail.center=index;rail.invalidate();if(!browsingRail)rail.prefetch();}
 }
 private Bitmap getBitmap(String id,boolean fullSize){
  Bitmap cached=(fullSize?full:posters).get(id);if(cached!=null)return cached;
  Uri u=uri(id);if(u==null)return null;
  try{
   Bitmap bmp;
   if(!fullSize){bmp=activity.getContentResolver().loadThumbnail(u,new Size(dp(160),dp(160)),null);}
   else{
    try(InputStream in=activity.getContentResolver().openInputStream(u)){
     if(in==null)return null;
     BitmapFactory.Options o=new BitmapFactory.Options();o.inJustDecodeBounds=true;
     BitmapFactory.decodeStream(in,null,o);
     o.inSampleSize=1;
     while(o.outWidth/o.inSampleSize>2300||o.outHeight/o.inSampleSize>2300)o.inSampleSize*=2;
     try(InputStream stream=activity.getContentResolver().openInputStream(u)){
      if(stream==null)return null;
      o.inJustDecodeBounds=false;bmp=BitmapFactory.decodeStream(stream,null,o);
     }
    }
   }
   if(bmp!=null)(fullSize?full:posters).put(id,bmp);
   return bmp;
  }catch(Exception ignored){return null;}
 }
 private void updatePosition(float offset){
  fingerOffset=offset;if(!open||stage==null)return;
  int width=Math.max(1,stage.getWidth());
  for(int j=0;j<3;j++)pages[j].setTranslationX((j-1)*width+offset);
  if(rail!=null){rail.center=index-offset/Math.max(1,width);rail.invalidate();}
 }
 private void settle(int direction,float initial){
  if(!open||stage==null)return;
  if(motion!=null){motion.cancel();motion=null;}
  int w=Math.max(1,stage.getWidth());
  float dest=direction==0?0:(direction<0?-w:w);
  ValueAnimator animator=ValueAnimator.ofFloat(initial,dest);
  motion=animator;animator.setDuration(180);animator.setInterpolator(new DecelerateInterpolator(1.65f));
  animator.addUpdateListener(a->updatePosition((float)a.getAnimatedValue()));
  animator.addListener(new android.animation.AnimatorListenerAdapter(){
   @Override public void onAnimationEnd(android.animation.Animator a){
    if(motion!=animator||!open)return;motion=null;
    if(direction!=0){index=Math.max(0,Math.min(index+(direction<0?1:-1),ids.size()-1));
      loadToken++;teardownPlayer();refreshPages();prepareCurrentVideo();}
    updatePosition(0);
   }
  });animator.start();
 }
 private void navigate(int next){
  if(!open||next<0||next>=ids.size()||next==index)return;
  if(motion!=null){motion.cancel();motion=null;}
  index=next;loadToken++;teardownPlayer();refreshPages();updatePosition(0);prepareCurrentVideo();
 }
 private final class SwipeHandler implements View.OnTouchListener{
  private final boolean thumb;private float startX,startY,lastX;private long startTime;
  SwipeHandler(boolean thumb){this.thumb=thumb;}
  @Override public boolean onTouch(View view,MotionEvent e){
   if(!open)return false;
   switch(e.getActionMasked()){
    case MotionEvent.ACTION_DOWN:
     if(motion!=null){motion.cancel();motion=null;}
     startX=e.getX();startY=e.getY();lastX=startX;startTime=SystemClock.uptimeMillis();return true;
    case MotionEvent.ACTION_MOVE:{
     float dx=e.getX()-startX;lastX=e.getX();
     if(Math.abs(dx)>dp(4)&&Math.abs(dx)>Math.abs(e.getY()-startY)*1.15f){
      float clamped=Math.max(-stage.getWidth(),Math.min(stage.getWidth(),dx));
      updatePosition(clamped);
     }return true;
    }
    case MotionEvent.ACTION_UP:{
     float dx=e.getX()-startX;long dt=Math.max(1,SystemClock.uptimeMillis()-startTime);
     if(Math.abs(dx)<dp(8)&&Math.abs(e.getY()-startY)<dp(9)){
      if(video(ids.get(index)))toggle();return true;
     }
     float velocity=Math.abs(dx)/dt;
     int toward=(Math.abs(dx)>stage.getWidth()*.23f||velocity>0.62f)?(dx<0?-1:1):0;
     if(index==0&&toward>0||index==ids.size()-1&&toward<0)toward=0;
     settle(toward,Math.max(-stage.getWidth(),Math.min(stage.getWidth(),dx)));return true;
    }
    case MotionEvent.ACTION_CANCEL:settle(0,fingerOffset);return true;
    default:return true;
   }
  }
 }
 private final class GalleryRail extends View{
  private final Paint paint=new Paint(3);
  private float center,indexAtDown,xAtDown;
  private long downAt;
  GalleryRail(){super(activity);setLayerType(View.LAYER_TYPE_HARDWARE,null);setOnTouchListener(this::touch);}
  @Override protected void onDraw(Canvas canvas){super.onDraw(canvas);
   float stride=dp(52),cw=getWidth()*.5f,ht=getHeight()*.5f;
   int lo=Math.max(0,(int)Math.floor(center)-12),hi=Math.min(ids.size()-1,(int)Math.ceil(center)+12);
   for(int i=lo;i<=hi;i++){
    float x=cw+(i-center)*stride;if(x<-stride||x>getWidth()+stride)continue;
    String id=ids.get(i);Bitmap bmp=posters.get(id);
    RectF box=new RectF(x-dp(23),ht-dp(26),x+dp(23),ht+dp(26));
    paint.setColor(0xff33363a);canvas.drawRoundRect(box,dp(5),dp(5),paint);
    if(bmp!=null){
     float ratio=Math.max((float)box.width()/bmp.getWidth(),(float)box.height()/bmp.getHeight());
     int bw=Math.min(bmp.getWidth(),Math.round(box.width()/ratio)),bh=Math.min(bmp.getHeight(),Math.round(box.height()/ratio));
     Rect src=new Rect((bmp.getWidth()-bw)/2,(bmp.getHeight()-bh)/2,(bmp.getWidth()+bw)/2,(bmp.getHeight()+bh)/2);
     canvas.drawBitmap(bmp,src,box,paint);
    }
    paint.setStyle(Paint.Style.STROKE);paint.setStrokeWidth(i==index?dp(3):dp(1));
    paint.setColor(i==index?0xfffff7f9:0x883d4350);canvas.drawRoundRect(box,dp(5),dp(5),paint);
    paint.setStyle(Paint.Style.FILL);
    if(video(id)){paint.setColor(0xbb111111);canvas.drawCircle(x,ht,dp(9),paint);paint.setColor(-1);paint.setTextSize(dp(11));canvas.drawText("▶",x-dp(4),ht+dp(4),paint);}
   }
   paint.setColor(0xfffff7f9);canvas.drawRoundRect(new RectF(cw-dp(1),0,cw+dp(1),getHeight()),dp(1),dp(1),paint);
  }
  void prefetch(){
   int lo=Math.max(0,index-13),hi=Math.min(ids.size()-1,index+13);
   for(int i=lo;i<=hi;i++){
    String id=ids.get(i);
    if(posters.get(id)!=null)continue;
    background.execute(()->{Bitmap b=getBitmap(id,false);if(b!=null)main.post(()->{if(open&&rail==GalleryRail.this)invalidate();});});
   }
  }
  private boolean touch(View v,MotionEvent e){
   if(!open)return false;
   switch(e.getActionMasked()){
    case MotionEvent.ACTION_DOWN:
     browsingRail=true;xAtDown=e.getX();indexAtDown=center;downAt=SystemClock.uptimeMillis();return true;
    case MotionEvent.ACTION_MOVE:{
     float next=Math.max(0,Math.min(ids.size()-1,indexAtDown+(xAtDown-e.getX())/dp(52)));
     center=next;invalidate();
     // Stage motion is always tied to the SAME fractional index as the rail.
     int near=Math.round(next);if(near!=index){index=near;loadToken++;teardownPlayer();refreshPages();}
     updatePosition((index-next)*Math.max(1,stage.getWidth()));return true;
    }
    case MotionEvent.ACTION_UP:{
     float next=Math.max(0,Math.min(ids.size()-1,indexAtDown+(xAtDown-e.getX())/dp(52)));
     if(Math.abs(e.getX()-xAtDown)<dp(5)&&ids.size()>1){next=index+Math.round((e.getX()-getWidth()*.5f)/dp(52));}
     browsingRail=false;int selected=Math.round(Math.max(0,Math.min(ids.size()-1,next)));
     if(selected==index){loadToken++;refreshPages();updatePosition(0);prepareCurrentVideo();}
     else navigate(selected);return true;
    }
    case MotionEvent.ACTION_CANCEL:browsingRail=false;loadToken++;refreshPages();updatePosition(0);prepareCurrentVideo();return true;
    default:return true;
   }
  }
 }
 private void prepareCurrentVideo(){
  if(!open||!video(ids.get(index)))return;
  final String id=ids.get(index);final int token=++videoToken;
  try{
   texture=new TextureView(activity);texture.setOpaque(false);
   pages[1].addView(texture,new FrameLayout.LayoutParams(-1,-1));
   texture.setSurfaceTextureListener(new TextureView.SurfaceTextureListener(){
    @Override public void onSurfaceTextureAvailable(SurfaceTexture st,int w,int h){if(!open||token!=videoToken)return;
     try{
      Surface surface=new Surface(st);mediaSurface=surface;
      MediaPlayer player=new MediaPlayer();media=player;player.setSurface(surface);
      player.setDataSource(activity,uri(id));
      player.setOnPreparedListener(p->{if(token!=videoToken||!open)return;
       prepared=true;p.setVolume(0,0);p.start();mute.setText("소리 켜기");pause.setText("Ⅱ");
       updateVideoGeometry(p.getVideoWidth(),p.getVideoHeight());startTicker();});
      player.setOnInfoListener((p,what,extra)->{if(what==MediaPlayer.MEDIA_INFO_VIDEO_RENDERING_START&&token==videoToken){
       images[1].setVisibility(View.INVISIBLE);return true;}return false;});
      player.setOnErrorListener((p,what,extra)->{if(token==videoToken&&open)videoFailure();return true;});
      player.setOnCompletionListener(p->{if(token==videoToken){pause.setText("▶");}});
      player.prepareAsync();
     }catch(Exception ex){videoFailure();}
    }
    @Override public void onSurfaceTextureSizeChanged(SurfaceTexture st,int w,int h){}
    @Override public boolean onSurfaceTextureDestroyed(SurfaceTexture st){teardownPlayer();return true;}
    @Override public void onSurfaceTextureUpdated(SurfaceTexture st){}
   });
  }catch(Exception e){videoFailure();}
 }
 private void updateVideoGeometry(int vw,int vh){
  if(vw<1||vh<1||texture==null)return;
  float width=texture.getWidth(),height=texture.getHeight();if(width<1||height<1)return;
  float scale=Math.min(width/vw,height/vh),sx=vw*scale/width,sy=vh*scale/height;
  android.graphics.Matrix m=new android.graphics.Matrix();m.setScale(sx,sy,width/2,height/2);texture.setTransform(m);
 }
 private void videoFailure(){prepared=false;if(host==null)return;
  TextView message=new TextView(activity);message.setText("동영상을 바로 재생하지 못했어요. 원본 갤러리에서 열기");
  message.setTextSize(14);message.setTextColor(Color.WHITE);message.setGravity(Gravity.CENTER);
  FrameLayout.LayoutParams p=new FrameLayout.LayoutParams(-1,dp(70),Gravity.CENTER);
  pages[1].addView(message,p);message.setOnClickListener(v->openOriginal());
 }
 private void openOriginal(){try{Uri original=uri(ids.get(index));if(original==null)return;
  android.content.Intent intent=new android.content.Intent(android.content.Intent.ACTION_VIEW);
  intent.setDataAndType(original,"video/*");intent.addFlags(android.content.Intent.FLAG_GRANT_READ_URI_PERMISSION);
  activity.startActivity(intent);
 }catch(Exception ignored){}}
 private void teardownPlayer(){
  if(ticker!=null){main.removeCallbacks(ticker);ticker=null;}prepared=false;
  if(media!=null){try{media.reset();media.release();}catch(Exception ignored){}media=null;}
  if(mediaSurface!=null){try{mediaSurface.release();}catch(Exception ignored){}mediaSurface=null;}
  if(texture!=null){TextureView old=texture;texture=null;old.setSurfaceTextureListener(null);if(old.getParent() instanceof ViewGroup)((ViewGroup)old.getParent()).removeView(old);}
  if(images[1]!=null)images[1].setVisibility(View.VISIBLE);
 }
 private void startTicker(){ticker=new Runnable(){public void run(){if(!open||media==null||!prepared)return;
  try{int t=media.getCurrentPosition(),d=Math.max(1,media.getDuration());
   if(!seekInProgress){seek.setMax(d);seek.setProgress(t);}videoTime.setText(clock(t)+" / "+clock(d));
   pause.setText(media.isPlaying()?"Ⅱ":"▶");
  }catch(Exception ignored){}
  main.postDelayed(this,300);
 }};main.post(ticker);}
 private String clock(long ms){long s=Math.max(0,ms)/1000;return String.format(java.util.Locale.US,"%02d:%02d",s/60,s%60);}
 private void toggle(){if(media==null||!prepared)return;try{if(media.isPlaying())media.pause();else media.start();
  pause.setText(media.isPlaying()?"Ⅱ":"▶");}catch(Exception ignored){}}
 private void toggleMute(){muted=!muted;try{if(media!=null)media.setVolume(muted?0:1,muted?0:1);}catch(Exception ignored){}
  mute.setText(muted?"소리 켜기":"음소거");}
 private void capture(){if(!open||!video(ids.get(index)))return;
  final Uri source=uri(ids.get(index));final int time=media!=null&&prepared?media.getCurrentPosition():0;
  background.execute(()->{Uri created=null;boolean done=false;
   try{
    MediaMetadataRetriever mr=new MediaMetadataRetriever();mr.setDataSource(activity,source);
    Bitmap stillFrame=mr.getFrameAtTime(time*1000L,MediaMetadataRetriever.OPTION_CLOSEST_SYNC);mr.release();
    if(stillFrame==null)throw new java.io.IOException("frame missing");
    ContentValues v=new ContentValues();v.put(MediaStore.Images.Media.DISPLAY_NAME,"MOA_"+System.currentTimeMillis()+".jpg");
    v.put(MediaStore.Images.Media.MIME_TYPE,"image/jpeg");
    if(Build.VERSION.SDK_INT>=29){v.put(MediaStore.Images.Media.RELATIVE_PATH,Environment.DIRECTORY_PICTURES+"/MOA-Video-Captures/");v.put(MediaStore.Images.Media.IS_PENDING,1);}
    created=activity.getContentResolver().insert(MediaStore.Images.Media.EXTERNAL_CONTENT_URI,v);
    if(created==null)throw new java.io.IOException("create failed");
    try(OutputStream out=activity.getContentResolver().openOutputStream(created,"w")){if(out==null||!stillFrame.compress(Bitmap.CompressFormat.JPEG,94,out))throw new java.io.IOException("write failed");}
    if(Build.VERSION.SDK_INT>=29){ContentValues ready=new ContentValues();ready.put(MediaStore.Images.Media.IS_PENDING,0);activity.getContentResolver().update(created,ready,null,null);}
    done=true;main.post(()->android.widget.Toast.makeText(activity,"장면을 사진으로 저장했어요",0).show());
   }catch(Exception e){main.post(()->android.widget.Toast.makeText(activity,"장면 저장 실패: "+e.getMessage(),0).show());}
   finally{if(!done&&created!=null)try{activity.getContentResolver().delete(created,null,null);}catch(Exception ignored){}}
  });
 }
}