package com.juhyeon.familyjourney;

import android.app.Activity;
import android.content.ContentResolver;
import android.content.ContentUris;
import android.content.ContentValues;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.ImageDecoder;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.graphics.Rect;
import android.graphics.RectF;
import android.graphics.SurfaceTexture;
import android.media.MediaMetadataRetriever;
import android.media.MediaPlayer;
import android.media.AudioManager;
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
import java.util.HashMap;
import java.util.HashSet;
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
 private final java.util.function.Consumer<String> legacyDetails;
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
 private Button backButton,menuButton,videoModeButton;
 private TextView videoModeHint;
 private LinearLayout seekRow;
 private boolean chromeVisible=true,videoScrubMode=false,scrubbingVideo=false,scrubWasPlaying=false;
 private boolean r187SeekInFlight=false,r187SeekReleased=false;
 private int r187SeekWanted=0,r187SeekIssued=0;
 private long r187LastSeekTime=0;
 private Runnable r187PendingDispatch;
 private int scrubMs=0;
 private long lastLiveSeek=0;
 private String scrubFrameClip="";
 private int scrubFrameCount=24,scrubFrameToken=0;
 private final HashMap<Integer,Bitmap> scrubFrames=new HashMap<>();
 private final String[] loadedPageIds=new String[3];
 private final java.util.HashSet<String> pendingPosters=new java.util.HashSet<>();
 private final ExecutorService frameWorker=Executors.newSingleThreadExecutor();
 private ImageView scrubPreview;
 private FrameLayout[] pages=new FrameLayout[3];
 private ImageView[] images=new ImageView[3];
 private TextView header,videoTime,videoStatus;
 private Button pause,mute,still;
 private LinearLayout videoControls, volumeRow, lowerControls;
 private SeekBar mediaVolumeSeek;
 private TextView mediaVolumeText;
 private SeekBar seek;
 private TextureView texture;
 private MediaPlayer media;
 private Surface mediaSurface;
 private boolean prepared,muted=true,seekInProgress,open,browsingRail;
 private float photoZoom=1f,photoPanX,photoPanY;
 private int index,loadToken,videoToken;
 private float fingerOffset;
 private ValueAnimator motion;
 private String currentDay="";
 private Runnable ticker;
 private android.window.OnBackInvokedCallback backCallback;
 private boolean backRegistered;
 private int savedSystemUi;

 public MoaNativeGallery(Activity activity,java.util.function.Consumer<String> legacyDetails){this.activity=activity;this.legacyDetails=legacyDetails;}
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
  // Readability check BEFORE removing the legacy Web viewer. Any denied or
  // stale MediaStore id leaves the working R173 viewer available as fallback.
  final int start=Math.max(0,Math.min(selected,validated.size()-1));
  Uri first=uri(validated.get(start));
  try(android.os.ParcelFileDescriptor fd=activity.getContentResolver().openFileDescriptor(first,"r")){
   if(fd==null)return false;
  }catch(Exception unavailable){return false;}
  close();browsingRail=false;ids.addAll(validated);index=start;
  chromeVisible=true;videoScrubMode=false;
  savedSystemUi=activity.getWindow().getDecorView().getSystemUiVisibility();
  currentDay=date==null?"":date.replaceAll("[^0-9-]","");
  FrameLayout container=activity.findViewById(android.R.id.content);
  if(container==null)return false;
  host=new FrameLayout(activity);host.setBackgroundColor(Color.BLACK);
  host.setClickable(true);host.setFocusableInTouchMode(true);
  container.addView(host,new FrameLayout.LayoutParams(-1,-1));
  stage=new FrameLayout(activity);stage.setBackgroundColor(Color.BLACK);
  FrameLayout.LayoutParams stagePos=new FrameLayout.LayoutParams(-1,-1);
  stagePos.topMargin=0;stagePos.bottomMargin=0; // stable viewer composition regardless of chrome
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
  touch.setOnTouchListener(new SwipeHandler());
  header=new TextView(activity);header.setTextColor(Color.WHITE);header.setTextSize(15);
  header.setGravity(Gravity.CENTER_VERTICAL);header.setPadding(dp(17),0,0,0);
  FrameLayout.LayoutParams headPos=new FrameLayout.LayoutParams(-1,dp(48),Gravity.TOP);
  host.addView(header,headPos);
  Button back=button("‹  닫기",15);FrameLayout.LayoutParams bpos=new FrameLayout.LayoutParams(dp(78),dp(44),Gravity.TOP|Gravity.LEFT);
  host.addView(back,bpos);backButton=back;back.setOnClickListener(v->close());
  Button menu=button("⋮",20);
  FrameLayout.LayoutParams menuPos=new FrameLayout.LayoutParams(dp(53),dp(44),Gravity.TOP|Gravity.RIGHT);
  host.addView(menu,menuPos);menuButton=menu;
  menu.setOnClickListener(v->{
   android.widget.PopupMenu popup=new android.widget.PopupMenu(activity,menu);
   popup.getMenu().add(0,1,0,"원본 갤러리에서 열기");
   popup.getMenu().add(0,2,1,"사진·영상 공유");
   popup.getMenu().add(0,3,2,"모아 기존 상세·GPS 보기");
   popup.setOnMenuItemClickListener(item->{
    if(item.getItemId()==1){openOriginal();return true;}
    if(item.getItemId()==2){shareOriginal();return true;}
    if(item.getItemId()==3){openLegacyDetails();return true;}
    return false;
   });popup.show();
  });
  header.setPadding(dp(95),0,dp(60),0);
  LinearLayout lower=new LinearLayout(activity);lowerControls=lower;lower.setOrientation(LinearLayout.VERTICAL);lower.setBackgroundColor(Color.TRANSPARENT); // R187 fixed overlay; rows have own translucent backgrounds
  activity.setVolumeControlStream(AudioManager.STREAM_MUSIC);
  FrameLayout.LayoutParams lowerPos=new FrameLayout.LayoutParams(-1,dp(208),Gravity.BOTTOM);
  host.addView(lower,lowerPos);
  lower.addView(new android.widget.Space(activity),new LinearLayout.LayoutParams(-1,0,1f));
  videoControls=new LinearLayout(activity);videoControls.setGravity(Gravity.CENTER_VERTICAL);
  videoControls.setBackgroundColor(0x99000000);
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
  );
  // R181: distinguish "other media" from "time within this video".
  // The video time-filmstrip is deliberately an alternative to the old seekbar,
  // not another unrelated horizontal media gallery.
  seekRow=new LinearLayout(activity);seekRow.setGravity(Gravity.CENTER_VERTICAL);
  seekRow.setBackgroundColor(0x99000000);
  videoModeButton=button("‹ 목록",12);videoModeButton.setVisibility(View.GONE);
  videoModeButton.setOnClickListener(v->setVideoScrubMode(!videoScrubMode));
  seekRow.addView(videoModeButton,new LinearLayout.LayoutParams(dp(94),dp(36)));
  seekRow.addView(seek,new LinearLayout.LayoutParams(0,dp(36),1));
  videoModeHint=new TextView(activity);videoModeHint.setTextColor(0xffeeeeee);
  videoModeHint.setTextSize(11);videoModeHint.setGravity(Gravity.CENTER_VERTICAL);
  videoModeHint.setText("영상 장면 좌우 이동 · 선택 영상 미리보기 누르면 탐색");
  videoModeHint.setVisibility(View.GONE);
  seekRow.addView(videoModeHint,new LinearLayout.LayoutParams(0,dp(36),1));
  lower.addView(seekRow,new LinearLayout.LayoutParams(-1,dp(36)));
  // R179: system MUSIC volume is independent of MediaPlayer's mute/unmute.
  // Show a slider only while sound is enabled; never raise device volume automatically.
  volumeRow=new LinearLayout(activity);volumeRow.setGravity(Gravity.CENTER_VERTICAL);
  volumeRow.setBackgroundColor(0x99000000);
  mediaVolumeText=new TextView(activity);mediaVolumeText.setTextSize(11);mediaVolumeText.setTextColor(Color.WHITE);
  mediaVolumeText.setGravity(Gravity.CENTER_VERTICAL);mediaVolumeText.setPadding(dp(9),0,0,0);
  volumeRow.addView(mediaVolumeText,new LinearLayout.LayoutParams(dp(104),dp(34)));
  mediaVolumeSeek=new SeekBar(activity);
  AudioManager volumeAudio=(AudioManager)activity.getSystemService(Activity.AUDIO_SERVICE);
  int maxAudio=volumeAudio==null?15:Math.max(1,volumeAudio.getStreamMaxVolume(AudioManager.STREAM_MUSIC));
  mediaVolumeSeek.setMax(maxAudio);
  mediaVolumeSeek.setOnSeekBarChangeListener(new SeekBar.OnSeekBarChangeListener(){
   @Override public void onStartTrackingTouch(SeekBar bar){}
   @Override public void onStopTrackingTouch(SeekBar bar){}
   @Override public void onProgressChanged(SeekBar bar,int progress,boolean fromUser){
    if(!fromUser)return;
    try{if(volumeAudio!=null&&!volumeAudio.isVolumeFixed())volumeAudio.setStreamVolume(AudioManager.STREAM_MUSIC,progress,0);}
    catch(SecurityException blocked){android.widget.Toast.makeText(activity,"기기에서 미디어 음량 변경을 허용하지 않았습니다.",0).show();}
    updateMediaVolume();
   }
  });
  volumeRow.addView(mediaVolumeSeek,new LinearLayout.LayoutParams(0,dp(34),1));
  volumeRow.setVisibility(View.GONE);
  lower.addView(volumeRow,new LinearLayout.LayoutParams(-1,dp(36)));
  rail=new GalleryRail();rail.setBackgroundColor(0xa8000000);
  lower.addView(rail,new LinearLayout.LayoutParams(-1,dp(72)));
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
  open=false;loadToken++;videoToken++;scrubFrameToken++;
  // Never leave Android system bars hidden after closing the gallery.
  if(host!=null)try{activity.getWindow().getDecorView().setSystemUiVisibility(savedSystemUi);}catch(Exception ignored){}
  chromeVisible=true;videoScrubMode=false;scrubFrames.clear();scrubFrameClip="";
  if(motion!=null){motion.cancel();motion=null;}
  teardownPlayer();
  if(backRegistered&&Build.VERSION.SDK_INT>=33)try{activity.getOnBackInvokedDispatcher().unregisterOnBackInvokedCallback(backCallback);}catch(Exception ignored){}
  backRegistered=false;backCallback=null;
  if(host!=null&&host.getParent() instanceof ViewGroup)((ViewGroup)host.getParent()).removeView(host);
  for(int i=0;i<loadedPageIds.length;i++)loadedPageIds[i]=null;
  pendingPosters.clear();scrubPreview=null;
  host=null;stage=null;rail=null;lowerControls=null;volumeRow=null;mediaVolumeSeek=null;mediaVolumeText=null;videoModeButton=null;videoModeHint=null;seekRow=null;backButton=null;menuButton=null;ids.clear();
 }
 private void refreshPages(){
  if(!open)return;
  header.setText((currentDay.isEmpty()?"사진·영상":currentDay)+"   "+(index+1)+" / "+ids.size());
  for(int j=0;j<3;j++){
   final int p=index+j-1;
   pages[j].setVisibility(p>=0&&p<ids.size()?View.VISIBLE:View.INVISIBLE);
   if(p<0||p>=ids.size()){loadedPageIds[j]=null;continue;}
   final String id=ids.get(p);boolean changedId=!id.equals(loadedPageIds[j]);
   if(changedId){loadedPageIds[j]=id;images[j].setImageDrawable(null);}
   Bitmap bitmap=full.get(id);if(bitmap==null)bitmap=posters.get(id);
   if(bitmap!=null&&changedId)images[j].setImageBitmap(bitmap);
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
  boolean selectedVideo=video(ids.get(index));
  if(!selectedVideo){videoScrubMode=false;scrubFrameClip="";scrubFrameToken++;scrubFrames.clear();hideScrubPreview();}
  videoControls.setVisibility(selectedVideo?View.VISIBLE:View.GONE);
  if(seekRow!=null)seekRow.setVisibility(selectedVideo?View.VISIBLE:View.GONE);
  if(videoModeButton!=null){videoModeButton.setText("‹ 목록");videoModeButton.setVisibility(selectedVideo&&videoScrubMode?View.VISIBLE:View.GONE);}
  if(seek!=null)seek.setVisibility(videoScrubMode?View.GONE:View.VISIBLE);
  if(videoModeHint!=null)videoModeHint.setVisibility(videoScrubMode?View.VISIBLE:View.GONE);
  if(rail!=null){rail.center=index;rail.invalidate();if(!browsingRail)rail.prefetch();}
  updateMediaVolume();
  if(videoScrubMode&&prepared)requestScrubFrames();
 }
 private Bitmap getBitmap(String id,boolean fullSize){
  Bitmap cached=(fullSize?full:posters).get(id);if(cached!=null)return cached;
  Uri u=uri(id);if(u==null)return null;
  try{
   Bitmap bmp;
   if(!fullSize){bmp=activity.getContentResolver().loadThumbnail(u,new Size(dp(160),dp(160)),null);}
   else{
    // R179: ImageDecoder honors encoded EXIF/HEIF rotation. BitmapFactory did not:
    // its raw raster sometimes appeared 90 degrees sideways in the full viewer.
    if(Build.VERSION.SDK_INT>=28){
     try{
      Bitmap corrected=ImageDecoder.decodeBitmap(
       ImageDecoder.createSource(activity.getContentResolver(),u),
       (decoder,info,source)->{
        int sw=Math.max(1,info.getSize().getWidth()),sh=Math.max(1,info.getSize().getHeight());
        int sample=1;while(sw/sample>2300||sh/sample>2300)sample*=2;
        decoder.setTargetSampleSize(sample);
        decoder.setAllocator(ImageDecoder.ALLOCATOR_SOFTWARE);
       });
      if(corrected!=null){full.put(id,corrected);return corrected;}
     }catch(Exception nativeDecoderUnavailable){ /* preserve original BitmapFactory fallback */ }
    }
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
 private void resetPhotoZoom(){photoZoom=1;photoPanX=0;photoPanY=0;
  if(images[1]!=null){images[1].setScaleX(1);images[1].setScaleY(1);images[1].setTranslationX(0);images[1].setTranslationY(0);}
 }
 private void applyPhotoZoom(){if(images[1]==null)return;
  ImageView target=images[1];float maxX=Math.max(0,(photoZoom-1)*stage.getWidth()*.5f);
  float maxY=Math.max(0,(photoZoom-1)*stage.getHeight()*.5f);
  photoPanX=Math.max(-maxX,Math.min(maxX,photoPanX));
  photoPanY=Math.max(-maxY,Math.min(maxY,photoPanY));
  target.setScaleX(photoZoom);target.setScaleY(photoZoom);target.setTranslationX(photoPanX);target.setTranslationY(photoPanY);
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
      loadToken++;resetPhotoZoom();teardownPlayer();refreshPages();prepareCurrentVideo();}
    updatePosition(0);
   }
  });animator.start();
 }
 private void navigate(int next){
  if(!open||next<0||next>=ids.size()||next==index)return;
  if(motion!=null){motion.cancel();motion=null;}
  index=next;loadToken++;resetPhotoZoom();teardownPlayer();refreshPages();updatePosition(0);prepareCurrentVideo();
 }
 private final class SwipeHandler implements View.OnTouchListener{
  private float startX,startY,lastX,lastY,initialDistance,initialZoom;
  private long startTime,lastTap;private boolean pinch;
  @Override public boolean onTouch(View view,MotionEvent e){
   if(!open)return false;
   boolean photo=!video(ids.get(index));
   switch(e.getActionMasked()){
    case MotionEvent.ACTION_DOWN:
     if(motion!=null){motion.cancel();motion=null;}
     pinch=false;startX=lastX=e.getX();startY=lastY=e.getY();startTime=SystemClock.uptimeMillis();return true;
    case MotionEvent.ACTION_POINTER_DOWN:
     if(photo&&e.getPointerCount()>1){
      initialDistance=(float)Math.hypot(e.getX(0)-e.getX(1),e.getY(0)-e.getY(1));
      initialZoom=photoZoom;pinch=true;return true;
     }return true;
    case MotionEvent.ACTION_MOVE:{
     if(photo&&pinch&&e.getPointerCount()>1){
      float dist=(float)Math.hypot(e.getX(0)-e.getX(1),e.getY(0)-e.getY(1));
      if(initialDistance>3){photoZoom=Math.max(1f,Math.min(4.5f,initialZoom*dist/initialDistance));applyPhotoZoom();}
      return true;
     }
     float dx=e.getX()-startX,dy=e.getY()-startY;
     if(photo&&photoZoom>1.01f){
      photoPanX+=e.getX()-lastX;photoPanY+=e.getY()-lastY;
      lastX=e.getX();lastY=e.getY();applyPhotoZoom();return true;
     }
     if(Math.abs(dx)>dp(4)&&Math.abs(dx)>Math.abs(dy)*1.12f)
      updatePosition(Math.max(-stage.getWidth(),Math.min(stage.getWidth(),dx)));
     return true;
    }
    case MotionEvent.ACTION_POINTER_UP:
     if(pinch){lastX=e.getX(0);lastY=e.getY(0);}return true;
    case MotionEvent.ACTION_UP:{
     if(pinch){pinch=false;if(photoZoom<1.03f)resetPhotoZoom();return true;}
     float dx=e.getX()-startX,dy=e.getY()-startY;
     if(photo&&photoZoom>1.01f){
      if(Math.abs(dx)<dp(12)&&Math.abs(dy)<dp(12)&&SystemClock.uptimeMillis()-lastTap<320){resetPhotoZoom();}
      lastTap=SystemClock.uptimeMillis();return true;
     }
     long dt=Math.max(1,SystemClock.uptimeMillis()-startTime);
     if(Math.abs(dx)<dp(8)&&Math.abs(dy)<dp(9)){
      if(photo&&SystemClock.uptimeMillis()-lastTap<290){
       photoZoom=photoZoom>1.01f?1f:2.2f;applyPhotoZoom();
      }else{
       toggleChrome();
      }
      lastTap=SystemClock.uptimeMillis();return true;
     }
     float velocity=Math.abs(dx)/dt;
     int toward=(Math.abs(dx)>stage.getWidth()*.23f||velocity>0.62f)?(dx<0?-1:1):0;
     if((index==0&&toward>0)||(index==ids.size()-1&&toward<0))toward=0;
     settle(toward,Math.max(-stage.getWidth(),Math.min(stage.getWidth(),dx)));return true;
    }
    case MotionEvent.ACTION_CANCEL:pinch=false;settle(0,fingerOffset);return true;
    default:return true;
   }
  }
 }
 private final class GalleryRail extends View{
  private final Paint paint=new Paint(3);
  private float center,indexAtDown,xAtDown;
   private void drawVideoFrames(Canvas canvas){MoaNativeGallery.this.drawVideoFrames(canvas,paint,this);}
  private long downAt;
  GalleryRail(){super(activity);setLayerType(View.LAYER_TYPE_HARDWARE,null);setOnTouchListener(this::touch);}
  @Override protected void onDraw(Canvas canvas){super.onDraw(canvas);
   if(videoScrubMode && open && !ids.isEmpty() && video(ids.get(index))){drawVideoFrames(canvas);return;}
   float stride=dp(44),cw=getWidth()*.5f,ht=getHeight()*.5f;
   int lo=Math.max(0,(int)Math.floor(center)-12),hi=Math.min(ids.size()-1,(int)Math.ceil(center)+12);
   for(int i=lo;i<=hi;i++){
    float x=cw+(i-center)*stride;if(x<-stride||x>getWidth()+stride)continue;
    String id=ids.get(i);Bitmap bmp=posters.get(id);
    RectF box=new RectF(x-dp(19),ht-dp(23),x+dp(19),ht+dp(23));
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
    if(video(id)){
     paint.setColor(0xbb111111);canvas.drawCircle(x,ht,dp(7),paint);
     paint.setColor(-1);paint.setTextSize(dp(9));canvas.drawText("▶",x-dp(3),ht+dp(3),paint);
     if(i==index&&prepared&&media!=null){
      // R195: playback position is visible even BEFORE opening the scene strip.
      float progress=0;
      try{progress=Math.max(0f,Math.min(1f,(float)media.getCurrentPosition()/Math.max(1,media.getDuration())));}catch(Exception ignored){}
      float cursor=box.left+progress*box.width();
      paint.setColor(0x99ffffff);canvas.drawRect(box.left,box.bottom-dp(3),cursor,box.bottom,paint);
      paint.setColor(Color.WHITE);canvas.drawRoundRect(new RectF(cursor-dp(1),box.top,cursor+dp(1),box.bottom),dp(1),dp(1),paint);
     }
    }
   }
   // R195: unlike the old immobile index marker, an actively playing video
   // has a visible timeline cursor travelling from start to end on the rail.
   float videoProgress=-1;
   if(!ids.isEmpty()&&video(ids.get(index))&&prepared&&media!=null){
    try{videoProgress=Math.max(0f,Math.min(1f,(float)media.getCurrentPosition()/Math.max(1,media.getDuration())));}catch(Exception ignored){}
   }
   if(videoProgress>=0){
    float cursor=getWidth()*videoProgress;
    paint.setColor(0x88ffffff);canvas.drawRect(0,getHeight()-dp(3),cursor,getHeight(),paint);
    paint.setColor(0xffffffff);
    canvas.drawRoundRect(new RectF(cursor-dp(1.2f),0,cursor+dp(1.2f),getHeight()),dp(1),dp(1),paint);
   }else{
    paint.setColor(0xfffff7f9);canvas.drawRoundRect(new RectF(cw-dp(1),0,cw+dp(1),getHeight()),dp(1),dp(1),paint);
   }
  }
  void prefetch(){
   int lo=Math.max(0,index-13),hi=Math.min(ids.size()-1,index+13);
   for(int i=lo;i<=hi;i++){
    String id=ids.get(i);
    if(posters.get(id)!=null)continue;
    if(!pendingPosters.add(id))continue;
    background.execute(()->{Bitmap b=getBitmap(id,false);
     main.post(()->{pendingPosters.remove(id);if(open&&rail==GalleryRail.this&&b!=null)invalidate();});
    });
   }
  }
  private boolean touch(View v,MotionEvent e){
   if(!open)return false;
   if(videoScrubMode && !ids.isEmpty() && video(ids.get(index)))return MoaNativeGallery.this.touchVideoFrames(e);
   switch(e.getActionMasked()){
    case MotionEvent.ACTION_DOWN:
     browsingRail=true;xAtDown=e.getX();indexAtDown=center;downAt=SystemClock.uptimeMillis();return true;
    case MotionEvent.ACTION_MOVE:{
     float next=Math.max(0,Math.min(ids.size()-1,indexAtDown+(xAtDown-e.getX())/dp(44)));
     center=next;invalidate();
     // Stage motion is always tied to the SAME fractional index as the rail.
     int near=Math.round(next);if(near!=index){index=near;loadToken++;resetPhotoZoom();teardownPlayer();refreshPages();}
     updatePosition((index-next)*Math.max(1,stage.getWidth()));return true;
    }
    case MotionEvent.ACTION_UP:{
     float next=Math.max(0,Math.min(ids.size()-1,indexAtDown+(xAtDown-e.getX())/dp(44)));
     if(Math.abs(e.getX()-xAtDown)<dp(5)&&ids.size()>1){next=index+Math.round((e.getX()-getWidth()*.5f)/dp(44));}
     browsingRail=false;int selected=Math.round(Math.max(0,Math.min(ids.size()-1,next)));
     if(Math.abs(e.getX()-xAtDown)<dp(8)&&selected>=0&&selected<ids.size()&&video(ids.get(selected))){
      if(selected!=index)navigate(selected);
      else if(media==null)prepareCurrentVideo();
      updatePosition(0);setVideoScrubMode(true);return true;
     }
     if(selected==index){refreshPages();updatePosition(0);if(video(ids.get(index))&&media==null)prepareCurrentVideo();}
     else navigate(selected);
     return true;
    }
    case MotionEvent.ACTION_CANCEL:browsingRail=false;refreshPages();updatePosition(0);if(video(ids.get(index))&&!prepared&&media==null)prepareCurrentVideo();return true;
    default:return true;
   }
  }
 }
 private void prepareCurrentVideo(){
  muted=true;updateMediaVolume();
  if(!open||!video(ids.get(index)))return;
  final String id=ids.get(index);final int token=++videoToken;
  try{
   texture=new TextureView(activity);texture.setOpaque(false);
   pages[1].addView(texture,new FrameLayout.LayoutParams(-1,-1));
   // Never scale tiny timeline thumbnails up to the full-resolution video stage.
   scrubPreview=null;
   texture.setSurfaceTextureListener(new TextureView.SurfaceTextureListener(){
    @Override public void onSurfaceTextureAvailable(SurfaceTexture st,int w,int h){if(!open||token!=videoToken)return;
     try{
      Surface surface=new Surface(st);mediaSurface=surface;
      MediaPlayer player=new MediaPlayer();media=player;player.setSurface(surface);
      player.setDataSource(activity,uri(id));
      player.setOnPreparedListener(p->{if(token!=videoToken||!open)return;
       prepared=true;p.setVolume(0,0);p.start();mute.setText("소리 켜기");pause.setText("Ⅱ");
       updateVideoGeometry(p.getVideoWidth(),p.getVideoHeight());startTicker();
       // Prefetch on video prepare, before the user taps the selected thumbnail.
       // It runs only on frameWorker and reveals a single completed batch.
       requestScrubFrames();});
      player.setOnInfoListener((p,what,extra)->{if(what==MediaPlayer.MEDIA_INFO_VIDEO_RENDERING_START&&token==videoToken){
       images[1].setVisibility(View.INVISIBLE);return true;}return false;});
      player.setOnErrorListener((p,what,extra)->{if(token==videoToken&&open)videoFailure();return true;});
      player.setOnCompletionListener(p->{if(token==videoToken){pause.setText("▶");}});
      player.prepareAsync();
     }catch(Exception ex){videoFailure();}
    }
    @Override public void onSurfaceTextureSizeChanged(SurfaceTexture st,int w,int h){
    try{if(token==videoToken&&media!=null)updateVideoGeometry(media.getVideoWidth(),media.getVideoHeight());}catch(Exception ignored){}
   }
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
 private void openLegacyDetails(){
  if(!open||ids.isEmpty()||legacyDetails==null)return;
  final String id=ids.get(index);
  final String scope=currentDay.length()>=10?"day":"month";
  close();
  legacyDetails.accept(scope+"|"+id);
 }
 private void openOriginal(){try{if(!open||ids.isEmpty())return;
  String id=ids.get(index);Uri original=uri(id);if(original==null)return;
  android.content.Intent intent=new android.content.Intent(android.content.Intent.ACTION_VIEW);
  intent.setDataAndType(original,video(id)?"video/*":"image/*");
  intent.addFlags(android.content.Intent.FLAG_GRANT_READ_URI_PERMISSION);activity.startActivity(intent);
 }catch(Exception ignored){}}
 private void shareOriginal(){try{if(!open||ids.isEmpty())return;
  String id=ids.get(index);Uri source=uri(id);if(source==null)return;
  android.content.Intent send=new android.content.Intent(android.content.Intent.ACTION_SEND);
  send.setType(video(id)?"video/*":"image/*");
  send.putExtra(android.content.Intent.EXTRA_STREAM,source);
  send.setClipData(android.content.ClipData.newUri(activity.getContentResolver(),"MOA original",source));
  send.addFlags(android.content.Intent.FLAG_GRANT_READ_URI_PERMISSION);
  activity.startActivity(android.content.Intent.createChooser(send,"사진·영상 공유"));
 }catch(Exception e){android.widget.Toast.makeText(activity,"공유 화면을 열지 못했어요",0).show();}}
 private void teardownPlayer(){
  if(ticker!=null){main.removeCallbacks(ticker);ticker=null;}
  if(r187PendingDispatch!=null){main.removeCallbacks(r187PendingDispatch);r187PendingDispatch=null;}
  r187SeekInFlight=false;r187SeekReleased=false;r187LastSeekTime=0;
  prepared=false;
  if(media!=null){try{media.reset();media.release();}catch(Exception ignored){}media=null;}
  if(mediaSurface!=null){try{mediaSurface.release();}catch(Exception ignored){}mediaSurface=null;}
  if(texture!=null){TextureView old=texture;texture=null;old.setSurfaceTextureListener(null);if(old.getParent() instanceof ViewGroup)((ViewGroup)old.getParent()).removeView(old);}
  if(scrubPreview!=null){ImageView old=scrubPreview;scrubPreview=null;old.setImageDrawable(null);if(old.getParent() instanceof ViewGroup)((ViewGroup)old.getParent()).removeView(old);}
  scrubbingVideo=false;
  if(images[1]!=null)images[1].setVisibility(View.VISIBLE);
 }
 private void startTicker(){ticker=new Runnable(){public void run(){if(!open||media==null||!prepared)return;
  try{int t=media.getCurrentPosition(),d=Math.max(1,media.getDuration());
   if(!seekInProgress&&!scrubbingVideo){seek.setMax(d);seek.setProgress(t);}
    if(!scrubbingVideo)videoTime.setText(clock(t)+" / "+clock(d));
    if(rail!=null&&!scrubbingVideo)rail.invalidate();
   pause.setText(media.isPlaying()?"Ⅱ":"▶");
  }catch(Exception ignored){}
  main.postDelayed(this,videoScrubMode||media.isPlaying()?32:250);
 }};main.post(ticker);}
 private String clock(long ms){long s=Math.max(0,ms)/1000;return String.format(java.util.Locale.US,"%02d:%02d",s/60,s%60);}
 private void toggle(){if(media==null||!prepared)return;try{if(media.isPlaying())media.pause();else media.start();
  pause.setText(media.isPlaying()?"Ⅱ":"▶");}catch(Exception ignored){}}
 private void updateMediaVolume(){
  if(volumeRow==null||lowerControls==null||stage==null||ids.isEmpty())return;
  boolean shown=open&&video(ids.get(index))&&!muted;
  if(volumeRow.getVisibility()!=(shown?View.VISIBLE:View.GONE)){
   volumeRow.setVisibility(shown?View.VISIBLE:View.GONE);
  }
  updateChromeLayout();
  if(shown&&mediaVolumeSeek!=null){
   try{
    AudioManager audio=(AudioManager)activity.getSystemService(Activity.AUDIO_SERVICE);
    if(audio!=null){
     int max=Math.max(1,audio.getStreamMaxVolume(AudioManager.STREAM_MUSIC));
     int current=audio.getStreamVolume(AudioManager.STREAM_MUSIC);
     mediaVolumeSeek.setMax(max);mediaVolumeSeek.setProgress(current);
     mediaVolumeText.setText(current<=0?"미디어 음량 0":"미디어 음량 "+Math.round(current*100f/max)+"%");
     mediaVolumeSeek.setEnabled(!audio.isVolumeFixed());
    }
   }catch(Exception ignored){}
  }
 }
 private void toggleMute(){muted=!muted;try{if(media!=null)media.setVolume(muted?0:1,muted?0:1);}catch(Exception ignored){}
  mute.setText(muted?"소리 켜기":"음소거");updateMediaVolume();}
 
 // R181: tap-to-immersive (without changing media-selection or video playback).
 private void toggleChrome(){
  if(!open)return;
  chromeVisible=!chromeVisible;
  if(header!=null)header.setVisibility(chromeVisible?View.VISIBLE:View.GONE);
  if(backButton!=null)backButton.setVisibility(chromeVisible?View.VISIBLE:View.GONE);
  if(menuButton!=null)menuButton.setVisibility(chromeVisible?View.VISIBLE:View.GONE);
  if(lowerControls!=null)lowerControls.setVisibility(chromeVisible?View.VISIBLE:View.GONE);
  // Do not toggle OS window insets; their Surface resize was changing image/video sizes.
  updateChromeLayout();
 }
 private void updateChromeLayout(){
  if(stage==null||lowerControls==null||ids.isEmpty())return;
  // R187: the 72dp rail is always bottom-aligned; spacer absorbs hidden rows.
  ViewGroup.LayoutParams lowerParams=lowerControls.getLayoutParams();
  if(lowerParams!=null&&lowerParams.height!=dp(208)){lowerParams.height=dp(208);lowerControls.setLayoutParams(lowerParams);}
  // ImageView / TextureView canvas is unchanged in all modes.
 }
 private void setVideoScrubMode(boolean enabled){
  if(!open||ids.isEmpty()||!video(ids.get(index)))return;
  videoScrubMode=enabled;
  if(videoModeButton!=null){videoModeButton.setText("‹ 목록");videoModeButton.setVisibility(enabled?View.VISIBLE:View.GONE);}
  if(videoModeHint!=null)videoModeHint.setVisibility(enabled?View.VISIBLE:View.GONE);
  if(seek!=null)seek.setVisibility(enabled?View.GONE:View.VISIBLE);
  if(enabled)requestScrubFrames();else hideScrubPreview();
  if(rail!=null)rail.invalidate();
 }
 private int videoLengthMs(){
  try{if(media!=null&&prepared)return Math.max(1000,media.getDuration());}catch(Exception ignored){}
  return 1000;
 }
 private int videoPositionMs(){
  if(scrubbingVideo)return scrubMs;
  try{if(media!=null&&prepared)return Math.max(0,media.getCurrentPosition());}catch(Exception ignored){}
  return 0;
 }
 private void requestScrubFrames(){
  if(!open||ids.isEmpty()||!video(ids.get(index))||!prepared)return;
  final String clip=ids.get(index);
  if(clip.equals(scrubFrameClip))return;
  scrubFrameClip=clip;scrubFrames.clear();
  final int token=++scrubFrameToken;
  final int total=videoLengthMs();
  // Limit independent random-seek decodes and reveal the strip in one batch,
  // rather than posting 20+ individual frames that visually climb in stair steps.
  scrubFrameCount=Math.max(8,Math.min(14, (int)Math.ceil(total/2200f)+1));
  final int count=scrubFrameCount;
  final int current=(int)((long)videoPositionMs()*(count-1)/Math.max(1,total));
  // Decode/scale only on the worker. Start near current playback, then expand out.
  frameWorker.execute(()->{
   MediaMetadataRetriever grabber=new MediaMetadataRetriever();
   try{
    grabber.setDataSource(activity,uri(clip));
    ArrayList<Integer> priority=new ArrayList<>();
    for(int i=0;i<count;i++)priority.add(i);
    priority.sort((a,b)->Integer.compare(Math.abs(a-current),Math.abs(b-current)));
    final HashMap<Integer,Bitmap> ready=new HashMap<>();
    for(int i:priority){
     if(token!=scrubFrameToken||!open)break;
     long micros=(long)total*1000L*i/Math.max(1,count-1);
     Bitmap frame=null;
     try{
      if(Build.VERSION.SDK_INT>=27)frame=grabber.getScaledFrameAtTime(micros,MediaMetadataRetriever.OPTION_CLOSEST_SYNC,dp(72),dp(72));
      else frame=grabber.getFrameAtTime(micros,MediaMetadataRetriever.OPTION_CLOSEST_SYNC);
     }catch(Exception ignored){}
     if(frame!=null)ready.put(i,frame);
    }
    // R193: precisely ONE UI invalidation. No asynchronous thumbnail staircase.
    main.post(()->{
     if(open&&token==scrubFrameToken&&clip.equals(ids.get(index))){scrubFrames.putAll(ready);if(videoScrubMode&&rail!=null)rail.invalidate();}
     else for(Bitmap bitmap:ready.values())try{bitmap.recycle();}catch(Exception ignored){}
    });
   }catch(Exception ignored){}
   finally{try{grabber.release();}catch(Exception ignored){}}
  });
 }
 private void drawVideoFrames(Canvas canvas,Paint paint,View railView){
  int count=Math.max(2,scrubFrameCount),duration=videoLengthMs();
  float step=dp(42),cx=railView.getWidth()/2f,cy=railView.getHeight()/2f;
  float fractional=(float)videoPositionMs()/Math.max(1,duration)*(count-1);
  int lo=Math.max(0,(int)Math.floor(fractional)-(int)(railView.getWidth()/step/2)-2);
  int hi=Math.min(count-1,(int)Math.ceil(fractional)+(int)(railView.getWidth()/step/2)+2);
  for(int i=lo;i<=hi;i++){
   float x=cx+(i-fractional)*step;
   RectF box=new RectF(x-dp(18),cy-dp(23),x+dp(18),cy+dp(23));
   paint.setColor(0xff30333a);canvas.drawRoundRect(box,dp(3),dp(3),paint);
   Bitmap frame=scrubFrames.get(i);
   if(frame!=null&&!frame.isRecycled()){
    float ratio=Math.max(box.width()/frame.getWidth(),box.height()/frame.getHeight());
    int sw=Math.min(frame.getWidth(),Math.round(box.width()/ratio)),sh=Math.min(frame.getHeight(),Math.round(box.height()/ratio));
    Rect crop=new Rect((frame.getWidth()-sw)/2,(frame.getHeight()-sh)/2,(frame.getWidth()+sw)/2,(frame.getHeight()+sh)/2);
    canvas.drawBitmap(frame,crop,box,paint);
   }
  }
  if(scrubFrames.isEmpty()){
   paint.setColor(0xffc6c7ce);paint.setTextSize(dp(11));paint.setTextAlign(Paint.Align.CENTER);
   canvas.drawText("장면 미리보기 준비 중",cx,cy+dp(6),paint);
   paint.setTextAlign(Paint.Align.LEFT);
  }
  paint.setColor(Color.WHITE);
  canvas.drawRoundRect(new RectF(cx-dp(1.5f),0,cx+dp(1.5f),railView.getHeight()),dp(1),dp(1),paint);
 }
 private boolean scrubTouch(MotionEvent e,float firstX,float firstTimeMs,int duration){
  if(media==null||!prepared)return true;
  int target=Math.round(firstTimeMs+(firstX-e.getX())/Math.max(1,dp(42))*
                  duration/Math.max(1f,scrubFrameCount-1f));
  scrubMs=Math.max(0,Math.min(duration,target));
  if(rail!=null)rail.invalidate();
  if(videoTime!=null)videoTime.setText(clock(scrubMs)+" / "+clock(duration));
  r187SeekWanted=scrubMs;
  return true;
 }
 private void showScrubPreview(int positionMs){
  if(scrubPreview==null||scrubFrames.isEmpty())return;
  int best=-1,distance=Integer.MAX_VALUE,at=Math.round((float)Math.max(0,positionMs)/
                   Math.max(1,videoLengthMs())*(Math.max(2,scrubFrameCount)-1));
  for(Integer k:scrubFrames.keySet()){int d=Math.abs(k-at);if(d<distance){distance=d;best=k;}}
  Bitmap frame=scrubFrames.get(best);
  if(frame!=null&&!frame.isRecycled()){
   scrubPreview.setImageBitmap(frame);
   scrubPreview.setVisibility(View.VISIBLE);
  }
 }
 private void hideScrubPreview(){
  if(scrubPreview!=null){scrubPreview.setVisibility(View.GONE);scrubPreview.setImageDrawable(null);}
 }
 // R187: coalesced real decoder seeks during finger motion.
 // Only one async seek may be active; the newest requested time wins.
 private void r187DispatchSeek(){
  if(media==null||!prepared||!open||r187SeekInFlight)return;
  final MediaPlayer player=media;final int token=videoToken;
  final int target=Math.max(0,Math.min(videoLengthMs(),r187SeekWanted));
  r187SeekIssued=target;r187SeekInFlight=true;r187LastSeekTime=SystemClock.uptimeMillis();
  try{
   player.setOnSeekCompleteListener(done->{
    if(done!=media||token!=videoToken||!open)return;
    r187SeekInFlight=false;
    if((scrubbingVideo||r187SeekReleased)&&Math.abs(r187SeekWanted-r187SeekIssued)>45){
     r187ScheduleSeek();return;
    }
    if(r187SeekReleased){
     r187SeekReleased=false;
     try{if(scrubWasPlaying)done.start();}catch(Exception ignored){}
    }
    try{if(videoTime!=null&&!scrubbingVideo)videoTime.setText(clock(done.getCurrentPosition())+" / "+clock(videoLengthMs()));}catch(Exception ignored){}
    if(rail!=null)rail.invalidate();
   });
   if(Build.VERSION.SDK_INT>=26)player.seekTo(target,MediaPlayer.SEEK_CLOSEST);
   else player.seekTo(target);
  }catch(Exception failure){
   r187SeekInFlight=false;
   if(r187SeekReleased){r187SeekReleased=false;try{if(scrubWasPlaying)player.start();}catch(Exception ignored){}}
  }
 }
 private void r187ScheduleSeek(){
  if(media==null||!prepared||!open||r187SeekInFlight)return;
  if(r187PendingDispatch!=null)main.removeCallbacks(r187PendingDispatch);
  long elapsed=SystemClock.uptimeMillis()-r187LastSeekTime;
  long delay=r187SeekReleased?0:Math.max(0,85-elapsed);
  final int token=videoToken;
  r187PendingDispatch=()->{
   r187PendingDispatch=null;
   if(open&&token==videoToken)r187DispatchSeek();
  };
  main.postDelayed(r187PendingDispatch,delay);
 }
 private float scrubDownX,scrubDownMs;
 private boolean touchVideoFrames(MotionEvent e){
  if(!prepared||media==null)return true;
  int duration=videoLengthMs();
  switch(e.getActionMasked()){
   case MotionEvent.ACTION_DOWN:
    if(r187PendingDispatch!=null){main.removeCallbacks(r187PendingDispatch);r187PendingDispatch=null;}
    r187SeekReleased=false;
    scrubDownX=e.getX();scrubDownMs=videoPositionMs();
    scrubMs=(int)scrubDownMs;r187SeekWanted=scrubMs;
    scrubbingVideo=true;
    try{scrubWasPlaying=media.isPlaying();if(scrubWasPlaying)media.pause();}catch(Exception ignored){scrubWasPlaying=false;}
    return true;
   case MotionEvent.ACTION_MOVE:
    scrubTouch(e,scrubDownX,scrubDownMs,duration);
    r187ScheduleSeek();
    return true;
   case MotionEvent.ACTION_UP:
    scrubTouch(e,scrubDownX,scrubDownMs,duration);
    if(Math.abs(e.getX()-scrubDownX)<dp(6)){
     scrubMs=Math.max(0,Math.min(duration,
      Math.round(scrubDownMs+(e.getX()-getWidthSafe(rail)/2f)/Math.max(1f,dp(42))*
      duration/Math.max(1f,scrubFrameCount-1f))));
    }
    r187SeekWanted=scrubMs;scrubbingVideo=false;r187SeekReleased=true;
    r187ScheduleSeek();
    if(rail!=null)rail.invalidate();
    return true;
   case MotionEvent.ACTION_CANCEL:
    r187SeekWanted=(int)scrubDownMs;
    scrubbingVideo=false;r187SeekReleased=true;
    r187ScheduleSeek();
    if(rail!=null)rail.invalidate();return true;
   default:return true;
  }
 }
 private int getWidthSafe(View v){return v==null?dp(300):Math.max(1,v.getWidth());}

 private void capture(){if(!open||!video(ids.get(index)))return;
  final Uri source=uri(ids.get(index));final int time=media!=null&&prepared?media.getCurrentPosition():0;
  // Snapshot on UI thread while TextureView still displays the selected frame.
  // Some HEVC/HDR clips play correctly but MediaMetadataRetriever returns null.
  Bitmap displayed=null;
  try{if(texture!=null&&texture.isAvailable()&&prepared)displayed=texture.getBitmap();}
  catch(RuntimeException unavailable){}
  final Bitmap visibleFrame=displayed;
  background.execute(()->{Uri created=null;boolean done=false;
   try{
    Bitmap stillFrame=visibleFrame;
    if(stillFrame==null){
     MediaMetadataRetriever mr=new MediaMetadataRetriever();
     try{
      mr.setDataSource(activity,source);
      stillFrame=mr.getFrameAtTime(time*1000L,MediaMetadataRetriever.OPTION_CLOSEST);
      if(stillFrame==null)stillFrame=mr.getFrameAtTime(time*1000L,MediaMetadataRetriever.OPTION_CLOSEST_SYNC);
      if(stillFrame==null)stillFrame=mr.getFrameAtTime(-1);
     }finally{try{mr.release();}catch(Exception ignored){}}
    }
    if(stillFrame==null)throw new java.io.IOException("화면 영상 프레임을 읽을 수 없습니다");
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