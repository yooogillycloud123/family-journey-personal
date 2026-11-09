package com.juhyeon.familyjourney;

import android.app.Activity;
import android.content.Intent;
import android.database.Cursor;
import android.location.Geocoder;
import android.location.Address;
import android.webkit.WebView;
import android.text.TextUtils;
import java.util.Date;
import java.util.Locale;
import java.util.List;
import java.text.SimpleDateFormat;

import android.content.ContentResolver;
import android.content.ContentUris;
import android.content.ContentValues;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.ImageDecoder;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.graphics.Typeface;
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
 * R201: original native MediaPlayer pipeline retained; only UI controls and video-frame rail rendering changed.
 */
public final class MoaNativeGallery {
 private final Activity activity;
 private final java.util.function.Consumer<String> legacyDetails;
 private final Handler main=new Handler(Looper.getMainLooper());
 private final ExecutorService background=Executors.newFixedThreadPool(2);
 private final ExecutorService r225MetadataWorker=Executors.newFixedThreadPool(2);
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
 private float r197ScrubExpansion=0f;private ValueAnimator r197ScrubAnim;
 private boolean r197CenterTapPending=false;private float r197CenterDownX=0f;
 private boolean r199SideGesture=false;private float r199SideStartX=0f;
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
 // R225 fixed overlay restores formerly working photo capture time/GPS/Naver link.
 // Never change the stage's dimensions or position in response to metadata.
 private LinearLayout r225Info;
 private TextView r225CaptureTime,r225Address;
 private View r225Naver;
 private boolean r227ExternalMapPending=false,r227VideoWasPlaying=false;
 private float r227ScrubDownX=0f,r227ScrubDownY=0f;
 private boolean r227ScrubDragged=false;

 private Runnable r225PendingMeta;
 private int r225MetaSeq=0;
 private String r225MetaId="",r225ResolvedAddress="";
 private double r225Lat=Double.NaN,r225Lon=Double.NaN;
 private boolean r225HasTime=false;

 private Button pause,mute,still;
 private ImageView r205CapturePreview;private Runnable r205PreviewDismiss;
  private FrameLayout r207SavedPhotoViewer;
  private ImageView r207SavedPhotoImage;
  private boolean r207ResumeVideoAfterPhoto=false;
  private int r207SavedPhotoLoadGeneration=0;
 private LinearLayout videoControls, volumeRow, lowerControls;
 private View volumeBubble;
 private VerticalMediaVolume volumeRail;
 private SeekBar seek;
 private TextureView texture;
 private MediaPlayer media;
 private Surface mediaSurface;
 private boolean prepared,muted=true,seekInProgress,open,browsingRail;
 private float photoZoom=1f,photoPanX,photoPanY;
 private int index,loadToken,videoToken;
 private float fingerOffset;
 private ValueAnimator motion;
 // R203: native spline deceleration with fractional media index and final snap.
 private android.widget.OverScroller r203Scroller;
 private Runnable r203FlingFrame;
 private ValueAnimator r203Snap;
 private android.view.VelocityTracker r203StageVelocity;
 private float r203FloatIndex;
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
  // R227: user requested NO bogus upper Close / count / three-dot chrome.
  // Android hardware/gesture Back still closes the native viewer.
  header.setVisibility(View.GONE);backButton.setVisibility(View.GONE);menuButton.setVisibility(View.GONE);
  // A single adjustable-height metadata card. Do not change stage/rail bounds.
  r225Info=new LinearLayout(activity);r225Info.setOrientation(LinearLayout.VERTICAL);
  r225Info.setPadding(dp(14),dp(8),dp(10),dp(9));
  android.graphics.drawable.GradientDrawable infoBg=new android.graphics.drawable.GradientDrawable();
  infoBg.setColor(0xb51d1e23);infoBg.setCornerRadius(dp(12));
  infoBg.setStroke(dp(.7f),0x474f5562);
  r225Info.setBackground(infoBg);
  r225CaptureTime=new TextView(activity);r225CaptureTime.setTextColor(0xfff2f2f3);
  r225CaptureTime.setTextSize(12.5f);r225CaptureTime.setGravity(Gravity.CENTER_VERTICAL);
  r225CaptureTime.setSingleLine(true);
  r225CaptureTime.setText("촬영 시간 확인 중…");
  r225Info.addView(r225CaptureTime,new LinearLayout.LayoutParams(-1,dp(26)));
  LinearLayout infoLine=new LinearLayout(activity);infoLine.setGravity(Gravity.CENTER_VERTICAL);
  r225Address=new TextView(activity);r225Address.setTextColor(0xffe6e9ec);
  r225Address.setTextSize(11.5f);r225Address.setGravity(Gravity.CENTER_VERTICAL);
  r225Address.setSingleLine(false);r225Address.setMaxLines(6);
  r225Address.setBreakStrategy(android.text.Layout.BREAK_STRATEGY_HIGH_QUALITY);
  r225Address.setText("위치 확인 중…");
  LinearLayout.LayoutParams addressLp=new LinearLayout.LayoutParams(0,-2,1f);
  addressLp.rightMargin=dp(6);infoLine.addView(r225Address,addressLp);
  r225Naver=new R227NaverPin();r225Naver.setVisibility(View.GONE);
  r225Naver.setContentDescription("현재 사진 촬영 위치를 네이버 지도에서 보기");
  r225Naver.setOnClickListener(v->r225OpenNaver());
  infoLine.addView(r225Naver,new LinearLayout.LayoutParams(dp(44),dp(44)));
  r225Info.addView(infoLine,new LinearLayout.LayoutParams(-1,-2));
  FrameLayout.LayoutParams infoPos=new FrameLayout.LayoutParams(-1,-2,Gravity.TOP);
  infoPos.leftMargin=dp(9);infoPos.rightMargin=dp(9);infoPos.topMargin=dp(11);
  host.addView(r225Info,infoPos);
  // Long-press the information card to reach original Gallery/Share/Details actions
  // without rendering unwanted top controls; use a popup anchored to the card.
  r225Info.setOnLongClickListener(v->{
   android.widget.PopupMenu p=new android.widget.PopupMenu(activity,r225Info);
   p.getMenu().add(0,1,0,"원본 갤러리에서 열기");
   p.getMenu().add(0,2,1,"사진·영상 공유");
   p.getMenu().add(0,3,2,"모아 기존 상세·GPS 보기");
   p.setOnMenuItemClickListener(it->{if(it.getItemId()==1){openOriginal();return true;}
    if(it.getItemId()==2){shareOriginal();return true;}
    if(it.getItemId()==3){openLegacyDetails();return true;}return false;});
   p.show();return true;
  });
  LinearLayout lower=new LinearLayout(activity);lowerControls=lower;lower.setOrientation(LinearLayout.VERTICAL);lower.setBackgroundColor(Color.TRANSPARENT); // R187 fixed overlay; rows have own translucent backgrounds
  activity.setVolumeControlStream(AudioManager.STREAM_MUSIC);
  FrameLayout.LayoutParams lowerPos=new FrameLayout.LayoutParams(-1,dp(208),Gravity.BOTTOM);
  host.addView(lower,lowerPos);
  lower.addView(new android.widget.Space(activity),new LinearLayout.LayoutParams(-1,0,1f));
  // R201: Galaxy layout - capture left, central play+elapsed/total, mute right.
  videoControls=new LinearLayout(activity);videoControls.setGravity(Gravity.CENTER_VERTICAL);
  videoControls.setPadding(dp(3),0,dp(3),0);videoControls.setBackgroundColor(Color.TRANSPARENT);
  still=new R201VideoIconButton(activity,0);pause=new R201VideoIconButton(activity,1);
  mute=new R201VideoIconButton(activity,2);
  still.setContentDescription("현재 동영상 장면 저장");
  pause.setContentDescription("동영상 일시정지");
  mute.setContentDescription("동영상 소리 켜기");
  pause.setText("Ⅱ");mute.setText("♪");
  still.setOnClickListener(v->capture());pause.setOnClickListener(v->toggle());mute.setOnClickListener(v->toggleMute());
  LinearLayout leftIcon=new LinearLayout(activity);leftIcon.setGravity(Gravity.CENTER);
  leftIcon.addView(mute,new LinearLayout.LayoutParams(dp(32),dp(32)));
  videoControls.addView(leftIcon,new LinearLayout.LayoutParams(0,dp(45),1f));
  LinearLayout centerPill=new LinearLayout(activity);centerPill.setGravity(Gravity.CENTER_VERTICAL);
  android.graphics.drawable.GradientDrawable pillBg=new android.graphics.drawable.GradientDrawable();
  pillBg.setColor(0xc0191a1e);pillBg.setCornerRadius(dp(18));pillBg.setStroke(dp(1),0x9aa0a5aa);
  android.graphics.drawable.GradientDrawable pillMask=new android.graphics.drawable.GradientDrawable();
  pillMask.setColor(Color.WHITE);pillMask.setCornerRadius(dp(18));
  centerPill.setBackground(new android.graphics.drawable.RippleDrawable(
   android.content.res.ColorStateList.valueOf(0x55ffffff),pillBg,pillMask));
  centerPill.setPadding(dp(3),0,dp(5),0);
  // R203: the ENTIRE central capsule is the play/pause hit target.
  centerPill.setClickable(true);centerPill.setFocusable(true);
  centerPill.setContentDescription("동영상 재생·일시정지 및 재생시간");
  centerPill.setOnClickListener(v->toggle());
  centerPill.addView(pause,new LinearLayout.LayoutParams(dp(25),dp(30)));
  videoTime=new TextView(activity);videoTime.setTextColor(Color.WHITE);videoTime.setTextSize(11);
  videoTime.setSingleLine(true);videoTime.setGravity(Gravity.CENTER);
  videoTime.setTypeface(android.graphics.Typeface.MONOSPACE);videoTime.setText("00:00 / 00:00");
  videoTime.setClickable(true);videoTime.setContentDescription("동영상 재생·일시정지");
  videoTime.setOnClickListener(v->toggle());
  centerPill.addView(videoTime,new LinearLayout.LayoutParams(0,dp(30),1f));
  pause.setClickable(false);pause.setFocusable(false);pause.setLongClickable(false);
  videoTime.setClickable(false);videoTime.setFocusable(false);
  videoControls.addView(centerPill,new LinearLayout.LayoutParams(dp(136),dp(34)));
  r205PressFeedback(still);r205PressFeedback(centerPill);r205PressFeedback(mute);
  LinearLayout rightIcon=new LinearLayout(activity);rightIcon.setGravity(Gravity.CENTER);
  rightIcon.addView(still,new LinearLayout.LayoutParams(dp(32),dp(32)));
  videoControls.addView(rightIcon,new LinearLayout.LayoutParams(0,dp(45),1f));
  lower.addView(videoControls,new LinearLayout.LayoutParams(-1,dp(46)));
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
  // Time remains in the center playback pill.
  videoModeHint=new TextView(activity);videoModeHint.setTextColor(0xffeeeeee);
  videoModeHint.setTextSize(11);videoModeHint.setGravity(Gravity.CENTER_VERTICAL);
  videoModeHint.setText("영상 장면 좌우 이동 · 선택 영상 미리보기 누르면 탐색");
  videoModeHint.setVisibility(View.GONE);
  seekRow.addView(videoModeHint,new LinearLayout.LayoutParams(0,dp(36),1));
  seekRow.setVisibility(View.GONE);
  lower.addView(seekRow,new LinearLayout.LayoutParams(-1,dp(36)));
  // R219: a Samsung-like VERTICAL media-volume pill anchored ABOVE Mute.
  // Never add extra rows to lowerControls: playback/capture/mute must stay fixed.
  volumeRow=null;
  FrameLayout bubble=new FrameLayout(activity);volumeBubble=bubble;
  android.graphics.drawable.GradientDrawable bubbleBg=new android.graphics.drawable.GradientDrawable();
  bubbleBg.setColor(0xe525272d);bubbleBg.setCornerRadius(dp(29));
  bubbleBg.setStroke(dp(.8f),0x9dc7cbd3);bubble.setBackground(bubbleBg);
  bubble.setElevation(dp(9));bubble.setVisibility(View.GONE);
  volumeRail=new VerticalMediaVolume();
  bubble.addView(volumeRail,new FrameLayout.LayoutParams(-1,-1));
  host.addView(bubble,new FrameLayout.LayoutParams(dp(58),dp(187),Gravity.TOP|Gravity.LEFT));
  rail=new GalleryRail();rail.setBackgroundColor(0xa8000000);
  lower.addView(rail,new LinearLayout.LayoutParams(-1,dp(72)));
  open=true;registerBack();refreshPages();stage.post(()->{if(open)updatePosition(0);});prepareCurrentVideo();
  host.requestFocus();return true;
 }
 // R209: Transparent white icon silhouette isolated from user-supplied reference screenshot.
 // Contains NO private background photo/diary/video pixels.
 private static final String R209_MUTE_ICON_PNG="iVBORw0KGgoAAAANSUhEUgAAAEgAAABJCAYAAACesWDiAAAFJ0lEQVR42u2cf2iVVRjHP3dpdddSik2zgkE/7JelZZIRUoKrJCMK3f4oGTFMLFLJkrLSImdmYhFW0BIS/9BVKyTE1tAVFSTBAhErpdgfYyAFidoomfv2x3tu3tZ9z/tu933P+967+4XDuPc87znPvjvneZ/zPM9ZRhIV+KOqhHXPJEFQA7Da/Ewr6oGtQA/QBTwR62yScm25/otuSZPy+tPQFks6of/j+bjmzP/QW2DiA5KmpYScVfLH8bjmzeQZ6ePAxAKL7GdgGdCd0JYaD+wAmgLkaoA/47RBnT4y1wD7gXsSIOdSY2uaQsgOxG2km4B3LbKfA8sdkvMg0AdMC2tO4zbSudYqOzY6sDdPauSI3UgPV3DQosz2GMnZqtHBKUFIapH0u0WhjoiVqZW0V6OHc4KQ9ICkwxalPpGUjUCRuT5uRuoJQtIsSd9aFOuWdFURSqyU1KfikRhBueX/lUW5ryVdPwoFNksaUDRIlKAcSR0WBQ9JmhNyrKykdxQtEicISVWStlmU7Je0KMQ4CxQ9YiFopOGOIaAFeNWnf4pxNh8PGOcH4PuSCKoUwe5bAX/RlQHPVxvbVVZbbHjbImnIovSGEGPsLmeCkLQ6QPE2SecGjPFpOROEpLUByn8oqSZgjB2lStCagHNZWPRImhBirlQRlLFkNeYCe4BshO+E34A7gKMWmWbgg7QE8f1e83cC70dMDkCdecU/bJHZDtw7iujgOJcELQauiMmzuADYZLInfugEZgesNDdpoAL7bo6kY3KDpwNswE2SukKONd6VJ30jMMmRn/o60GrpPwgsAT5LU2a11rEOa4A3Lf29QKOxic5j0lWujF0AVgDtlv6/zEp6I+Cc6ISgpPL1jSaVPNUi8xSwMektlmRBwzxgCzDDIvMc8GySBJ1OOMBwn3EUb7PIvAa8UCCzOmbKX6YD24D7LTKtwELgb/P51FgiCOAGQ9KjFpkO4BHgp7iM9DjSjTrgbeASSxTzY+CwSxuUNmSBDcBmi8yYJiiHVcBHafCk04yFwKEKQcHGuzdJgoZKgKR6YBA4v7KC/HGOWUnXVQjyx2Rgn/G+KwT5YIpxGFvKOdxRLM4D2vBiSxUj7YOMOZ9tipuggRLfcs9gD74VTdAJ4EyJk9Ro7FJ1HATtB/rLwHg/BOw2B91ICTpiTsjlgHnATuN9j86w+aSeJwO7gLtKiIyTwIU+fUfxkqEHovKDjgFLge+I4YJITFgHfOnTdzWw1xx2I1lB+ZiPF/+dbt5wp/DivxPy3ng5onPx7Gq8FLNL1Bh92oFFPjJnzEraGXrUmO9crI+odGak5S9B5YEvuS6gsrVmRwQNr2JbFyDfnhaCctX6/Q5XUK4tDXimu5gCqqhxEfAFcGuMB+9Cv0wDXqh2os9zPcDMNJzm/wBmmUOlS3ThXc7zqzW6xbz+65Iw0n5tRQxbLBMw52WSDlqe/0XStUnZoELt7ggvsoQhCEkXS+oMIGlBWghC0u3mEowrgsLcNxmQNCMtBCHpckl7HBKUa21hblOmIeTah1ek8J7jeZcAL/r01eYyJmmJSQ+Zs9/LnK3WcIH1ePVGJ4d9vw+vqo00/V+OfM+7PyJHMWxrMMb7R3MtPpuEozgSzDfx5ZtHGJOOPtCd4n+wNBWv6n52SPnsv9si5qB9WnAE70pE2OjmYFznlzTjtIntvFIhyI61JgjvF938Jq6J02yDCmGmSefUD/v+SuDXCkFn0Qw8hld6tyyu7VXKBDlDVYUCO/4Bt8Q6slJaMUIAAAAASUVORK5CYII=";
 // R201: native vector icons rather than decorative Unicode glyphs.
 private final class R201VideoIconButton extends Button{
  private final int kind;private final Paint iconPaint=new Paint(Paint.ANTI_ALIAS_FLAG);
   private final Bitmap r209MuteBitmap;
  R201VideoIconButton(Activity owner,int which){
   super(owner);kind=which;setAllCaps(false);setTextSize(1);
    Bitmap exact=null;
    if(which==2)try{
     byte[] raw=android.util.Base64.decode(R209_MUTE_ICON_PNG,android.util.Base64.DEFAULT);
     exact=BitmapFactory.decodeByteArray(raw,0,raw.length);
    }catch(Exception ignored){}
    r209MuteBitmap=exact;
   setTextColor(Color.TRANSPARENT);setPadding(0,0,0,0);
   setMinWidth(0);setMinHeight(0);setMinimumWidth(0);setMinimumHeight(0);
   android.graphics.drawable.GradientDrawable bg=new android.graphics.drawable.GradientDrawable();
   bg.setColor(which==1?Color.TRANSPARENT:0xbb16181b);
   bg.setCornerRadius(dp(25));
   if(which!=1)bg.setStroke(dp(1),0x9c9fa6ad);
   android.graphics.drawable.GradientDrawable mask=new android.graphics.drawable.GradientDrawable();
   mask.setColor(Color.WHITE);mask.setCornerRadius(dp(18));
   setBackgroundTintList(null);
   setBackground(new android.graphics.drawable.RippleDrawable(
    android.content.res.ColorStateList.valueOf(0x66ffffff),bg,mask));
  }
  @Override protected void onDraw(Canvas canvas){
   super.onDraw(canvas);
   float cx=getWidth()/2f,cy=getHeight()/2f;
   if(kind==2&&String.valueOf(getText()).equals("♪")&&r209MuteBitmap!=null){
    float w=dp(19.5f),h=w*r209MuteBitmap.getHeight()/Math.max(1f,r209MuteBitmap.getWidth());
    canvas.drawBitmap(r209MuteBitmap,null,new RectF(cx-w*.5f,cy-h*.5f,cx+w*.5f,cy+h*.5f),iconPaint);
    return;
   }
   canvas.save();canvas.scale(.75f,.75f,cx,cy);
   iconPaint.setColor(Color.WHITE);iconPaint.setStrokeWidth(dp(2f));
   iconPaint.setStrokeCap(Paint.Cap.ROUND);iconPaint.setStrokeJoin(Paint.Join.ROUND);
   iconPaint.setStyle(Paint.Style.STROKE);
   if(kind==0){
    // Framed picture + landscape: matches gallery metaphor, not capture corner brackets.
    canvas.drawRoundRect(cx-dp(12),cy-dp(10),cx+dp(12),cy+dp(10),dp(2.7f),dp(2.7f),iconPaint);
    canvas.drawCircle(cx+dp(6),cy-dp(4),dp(1.7f),iconPaint);
    android.graphics.Path hill=new android.graphics.Path();
    hill.moveTo(cx-dp(10),cy+dp(6));hill.lineTo(cx-dp(3),cy-dp(2));
    hill.lineTo(cx+dp(1),cy+dp(2));hill.lineTo(cx+dp(5),cy-dp(1));
    hill.lineTo(cx+dp(10),cy+dp(6));canvas.drawPath(hill,iconPaint);
   }else if(kind==1){
    iconPaint.setStyle(Paint.Style.FILL);
    if(String.valueOf(getText()).contains("▶")){
     android.graphics.Path shape=new android.graphics.Path();
     shape.moveTo(cx-dp(6),cy-dp(10));shape.lineTo(cx+dp(10),cy);
     shape.lineTo(cx-dp(6),cy+dp(10));shape.close();canvas.drawPath(shape,iconPaint);
    }else{
     canvas.drawRoundRect(cx-dp(9),cy-dp(10),cx-dp(3),cy+dp(10),dp(2),dp(2),iconPaint);
     canvas.drawRoundRect(cx+dp(3),cy-dp(10),cx+dp(9),cy+dp(10),dp(2),dp(2),iconPaint);
    }
   }else{
    // Conventional speaker / muted-speaker visual, never a musical-note symbol.
    android.graphics.Path speaker=new android.graphics.Path();
    speaker.moveTo(cx-dp(11),cy-dp(5));speaker.lineTo(cx-dp(7),cy-dp(5));
    speaker.lineTo(cx-dp(2),cy-dp(10));speaker.lineTo(cx-dp(2),cy+dp(10));
    speaker.lineTo(cx-dp(7),cy+dp(5));speaker.lineTo(cx-dp(11),cy+dp(5));
    speaker.close();canvas.drawPath(speaker,iconPaint);
    if(String.valueOf(getText()).equals("♪")){
     // A single integrated slash crossing the actual speaker body (not separate x-side dash).
     iconPaint.setStrokeWidth(dp(2.6f));
     canvas.drawLine(cx-dp(8),cy-dp(11),cx+dp(11),cy+dp(11),iconPaint);
    }else{
     canvas.drawArc(cx-dp(5),cy-dp(8),cx+dp(9),cy+dp(8),-55,110,false,iconPaint);
     canvas.drawArc(cx-dp(2),cy-dp(12),cx+dp(14),cy+dp(12),-55,110,false,iconPaint);
    }
   }
   canvas.restore();
  }
 }
 private void r205PressFeedback(View control){
  control.setOnTouchListener((v,e)->{
   int action=e.getActionMasked();
   if(action==MotionEvent.ACTION_DOWN){
    v.animate().cancel();v.animate().scaleX(.91f).scaleY(.91f).setDuration(75).start();
   }else if(action==MotionEvent.ACTION_UP||action==MotionEvent.ACTION_CANCEL){
    v.animate().cancel();v.animate().scaleX(1f).scaleY(1f).setDuration(145)
      .setInterpolator(new android.view.animation.OvershootInterpolator(.85f)).start();
   }
   return false;
  });
 }
 // Map pin vector, consistent with the muted glass native Gallery controls.
 private final class R227NaverPin extends View{
  final Paint p=new Paint(Paint.ANTI_ALIAS_FLAG);
  R227NaverPin(){super(activity);setClickable(true);setFocusable(true);
   android.graphics.drawable.GradientDrawable base=new android.graphics.drawable.GradientDrawable();
   base.setColor(0xd1323741);base.setCornerRadius(dp(12));base.setStroke(dp(1),0x8e697382);
   android.graphics.drawable.GradientDrawable mask=new android.graphics.drawable.GradientDrawable();
   mask.setColor(Color.WHITE);mask.setCornerRadius(dp(12));
   setBackground(new android.graphics.drawable.RippleDrawable(
    android.content.res.ColorStateList.valueOf(0x44ffffff),base,mask));
  }
  @Override protected void onDraw(Canvas c){super.onDraw(c);
   float cx=getWidth()/2f,cy=getHeight()/2f;
   p.setColor(0xfff6f7fa);p.setStyle(Paint.Style.STROKE);p.setStrokeWidth(dp(1.9f));
   p.setStrokeCap(Paint.Cap.ROUND);p.setStrokeJoin(Paint.Join.ROUND);
   android.graphics.Path pin=new android.graphics.Path();
   pin.moveTo(cx,cy+dp(12));
   pin.cubicTo(cx-dp(4),cy+dp(6),cx-dp(10),cy+dp(1),cx-dp(9),cy-dp(5));
   pin.cubicTo(cx-dp(9),cy-dp(17),cx+dp(9),cy-dp(17),cx+dp(9),cy-dp(5));
   pin.cubicTo(cx+dp(10),cy+dp(1),cx+dp(4),cy+dp(6),cx,cy+dp(12));
   c.drawPath(pin,p);c.drawCircle(cx,cy-dp(5),dp(3),p);
  }
 }
 private Button button(String label,int size){Button b=new Button(activity);b.setAllCaps(false);b.setText(label);b.setTextSize(size);
  b.setTextColor(-1);b.setBackgroundTintList(android.content.res.ColorStateList.valueOf(0xff22242b));
  b.setMinHeight(0);b.setMinimumHeight(0);b.setMinWidth(0);b.setMinimumWidth(0);return b;}
 // R225: metadata overlays the photo with constant geometry: never resize the
 // stage, change ImageView scale, or add rows to the lower thumbnail filmstrip.
 private void r225ScheduleMeta(){
  if(!open||ids.isEmpty()||r225CaptureTime==null)return;
  final String mediaId=ids.get(index);
  if(mediaId.equals(r225MetaId))return;
  r225MetaId=mediaId;r225HasTime=false;r225Lat=Double.NaN;r225Lon=Double.NaN;r225ResolvedAddress="";
  r225CaptureTime.setText("촬영 날짜·시간 확인 중…");
  r225Address.setText("위치 확인 중…");r225Naver.setVisibility(View.GONE);
  final int serial=++r225MetaSeq;
  if(r225PendingMeta!=null)main.removeCallbacks(r225PendingMeta);
  r225PendingMeta=()->{
   r225PendingMeta=null;
   if(!r225MetadataCurrent(serial,mediaId))return;
   r225LoadWebIndex(serial,mediaId);
   r225MetadataWorker.execute(()->r225LoadMediaMetadata(serial,mediaId));
  };
  main.postDelayed(r225PendingMeta,browsingRail?170:65);
 }
 private boolean r225MetadataCurrent(int serial,String mediaId){
  return open&&r225CaptureTime!=null&&serial==r225MetaSeq&&mediaId.equals(r225MetaId);
 }
 private void r225SetTime(int serial,String mediaId,long ms,boolean precise){
  if(!r225MetadataCurrent(serial,mediaId)||ms<315532800000L||ms>4102444800000L)return;
  if(r225HasTime&&!precise)return;
  r225HasTime=true;
  String stamp=new SimpleDateFormat("yyyy.MM.dd HH:mm:ss",Locale.KOREA).format(new Date(ms));
  r225CaptureTime.setText((precise?"촬영 · ":"기록된 시간 · ")+stamp);
 }
 private static boolean r225GoodGps(double lat,double lon){
  return !Double.isNaN(lat)&&!Double.isNaN(lon)&&lat>=-90&&lat<=90&&lon>=-180&&lon<=180&&(lat!=0||lon!=0);
 }
 private void r225SetGps(int serial,String mediaId,double lat,double lon,String address){
  if(!r225MetadataCurrent(serial,mediaId)||!r225GoodGps(lat,lon))return;
  if(r225GoodGps(r225Lat,r225Lon))return;
  r225Lat=lat;r225Lon=lon;
  r225ResolvedAddress=address==null?"":address.trim();
  r225Address.setText(r225ResolvedAddress.isEmpty()?String.format(Locale.KOREA,
    "GPS %.6f, %.6f · 상세주소 확인 중",lat,lon):r225ResolvedAddress);
  boolean korean=lat>=31.43&&lat<=44.35&&lon>=122.37&&lon<=132.0;
  r225Naver.setVisibility(korean?View.VISIBLE:View.GONE);
  if(!r225ResolvedAddress.isEmpty())return;
  r225MetadataWorker.execute(()->{
   String addr="";
   try{
    Geocoder coder=new Geocoder(activity,Locale.KOREAN);
    List<Address> found=coder.getFromLocation(lat,lon,1);
    if(found!=null&&!found.isEmpty()&&found.get(0)!=null){
     Address first=found.get(0);
     String full=first.getAddressLine(0);
     if(full!=null)addr=full.trim();
    }
   }catch(Exception ignored){}
   final String shown=addr;
   main.post(()->{
    if(!r225MetadataCurrent(serial,mediaId)||r225Lat!=lat||r225Lon!=lon)return;
    if(!shown.isEmpty()){r225ResolvedAddress=shown;r225Address.setText(shown);}
    else r225Address.setText(String.format(Locale.KOREA,"GPS %.6f, %.6f · 상세주소 미확인",lat,lon));
   });
  });
 }
 private WebView r225FindWebView(View node){
  if(node instanceof WebView)return (WebView)node;
  if(node instanceof ViewGroup){ViewGroup group=(ViewGroup)node;
   for(int i=0;i<group.getChildCount();i++){
    WebView w=r225FindWebView(group.getChildAt(i));if(w!=null)return w;
   }
  }
  return null;
 }
 private void r225LoadWebIndex(int serial,String mediaId){
  // Reuse the preexisting indexed diary capture times + GPS map-index positions.
  // The old R121 browser-only metadata banner cannot appear over a NATIVE gallery.
  WebView web=r225FindWebView(activity.findViewById(android.R.id.content));
  if(web==null)return;
  String script="(function(){try{var id="+org.json.JSONObject.quote(mediaId)+";"+
   "var diary=window.FamilyJourneyDiary&&window.FamilyJourneyDiary.state;"+
   "var it=diary&&diary.byId&&diary.byId.get&&(diary.byId.get(id)||diary.byId.get(id.replace(/^v/,'')));"+
   "var data=window.FamilyJourneyExtension&&window.FamilyJourneyExtension.getData&&window.FamilyJourneyExtension.getData();"+
   "var rows=data&&Array.isArray(data.photos)?data.photos:[];var row=null;"+
   "for(var i=0;i<rows.length;i++){if(Array.isArray(rows[i])&&(String(rows[i][0])===id||String(rows[i][0])===id.replace(/^v/,''))){row=rows[i];break}}"+
   "var t=it&&Number(it.t)||0;"+
   "return JSON.stringify({t:t,lat:row?Number(row[1]):null,lon:row?Number(row[2]):null});"+
   "}catch(e){return '{}'}})();";
  try{web.evaluateJavascript(script,result->{
   if(!r225MetadataCurrent(serial,mediaId)||result==null)return;
   try{
    Object decoded=new org.json.JSONTokener(result).nextValue();
    org.json.JSONObject o=new org.json.JSONObject(String.valueOf(decoded));
    long t=o.optLong("t",0);
    if(t>0)r225SetTime(serial,mediaId,t,true);
    if(!o.isNull("lat")&&!o.isNull("lon")){
     double lat=o.optDouble("lat",Double.NaN),lon=o.optDouble("lon",Double.NaN);
     r225SetGps(serial,mediaId,lat,lon,"");
    }
   }catch(Exception ignored){}
  });}catch(Exception ignored){}
 }
 private void r225LoadMediaMetadata(int serial,String mediaId){
  Uri u=uri(mediaId);if(u==null)return;
  long taken=0,added=0;double lat=Double.NaN,lon=Double.NaN;
  // DATE_TAKEN is the shot's metadata, not file import date. Do not rename DATE_ADDED as shooting time.
  try(Cursor c=activity.getContentResolver().query(u,new String[]{
      MediaStore.MediaColumns.DATE_TAKEN,MediaStore.MediaColumns.DATE_ADDED},null,null,null)){
   if(c!=null&&c.moveToFirst()){
    int t=c.getColumnIndex(MediaStore.MediaColumns.DATE_TAKEN);
    int a=c.getColumnIndex(MediaStore.MediaColumns.DATE_ADDED);
    if(t>=0&&!c.isNull(t))taken=c.getLong(t);
    if(a>=0&&!c.isNull(a))added=c.getLong(a)*1000L;
   }
  }catch(Exception ignored){}
  try{
   if(!video(mediaId)){
    Uri originalUri=u;
    // MediaStore redacts EXIF GPS on Android 10+ without this exact original path.
    // HostActivity already uses this permission-aware original URI when indexing.
    if(Build.VERSION.SDK_INT>=29&&activity.checkSelfPermission(
      "android.permission.ACCESS_MEDIA_LOCATION")==android.content.pm.PackageManager.PERMISSION_GRANTED){
     try{originalUri=MediaStore.setRequireOriginal(u);}catch(Exception ignored){originalUri=u;}
    }
    InputStream stream=null;
    try{stream=activity.getContentResolver().openInputStream(originalUri);}
    catch(SecurityException permission){stream=activity.getContentResolver().openInputStream(u);}
    try(InputStream in=stream){
     if(in!=null){android.media.ExifInterface exif=new android.media.ExifInterface(in);
      float[] gps=new float[2];if(exif.getLatLong(gps)){lat=gps[0];lon=gps[1];}
      if(taken<315532800000L){
       String original=exif.getAttribute(android.media.ExifInterface.TAG_DATETIME_ORIGINAL);
       if(original!=null){try{
        java.text.SimpleDateFormat parser=new java.text.SimpleDateFormat("yyyy:MM:dd HH:mm:ss",Locale.US);
        parser.setLenient(false);Date d=parser.parse(original);if(d!=null)taken=d.getTime();
       }catch(Exception ignored){}}
      }
     }
    }
   }else{
    MediaMetadataRetriever m=new MediaMetadataRetriever();
    try{m.setDataSource(activity,u);
     String location=m.extractMetadata(MediaMetadataRetriever.METADATA_KEY_LOCATION);
     if(location!=null){java.util.regex.Matcher match=java.util.regex.Pattern.compile(
      "([+-][0-9]+(?:\\.[0-9]+)?)([+-][0-9]+(?:\\.[0-9]+)?)").matcher(location);
      if(match.find()){lat=Double.parseDouble(match.group(1));lon=Double.parseDouble(match.group(2));}
     }
    }finally{m.release();}
   }
  }catch(Exception ignored){}
  final long when=taken>315532800000L?taken:added;
  final boolean precise=taken>315532800000L;
  final double plat=lat,plon=lon;
  main.post(()->{
   if(!r225MetadataCurrent(serial,mediaId))return;
   if(when>0)r225SetTime(serial,mediaId,when,precise);
   else if(!r225HasTime)r225CaptureTime.setText("촬영 시간 정보 없음");
   if(r225GoodGps(plat,plon))r225SetGps(serial,mediaId,plat,plon,"");
   else if(!r225GoodGps(r225Lat,r225Lon)){
    boolean permission=Build.VERSION.SDK_INT>=29 && activity.checkSelfPermission(
       "android.permission.ACCESS_MEDIA_LOCATION")!=android.content.pm.PackageManager.PERMISSION_GRANTED;
    r225Address.setText(permission?"원본 위치정보 접근 권한 필요 · 지도 색인 확인 중":
       "원본 GPS 정보가 없는 사진 · 지도 색인 확인 중");
   }
  });
 }
 // R227: Android host onPause MUST NOT close a gallery while opening Naver Maps.
 public boolean r227RetainForExternalMap(){return open&&r227ExternalMapPending;}
 public void r227ResumeFromExternalMap(){
  if(!r227ExternalMapPending)return;
  r227ExternalMapPending=false;
  // Keep precisely the same media/index/filmstrip; resume if video was playing.
  if(open&&r227VideoWasPlaying&&media!=null&&prepared){
   try{media.start();if(pause!=null)pause.setText("Ⅱ");}catch(Exception ignored){}
  }
  r227VideoWasPlaying=false;
 }
 private void r225OpenNaver(){
  if(!r225GoodGps(r225Lat,r225Lon)||!open)return;
  if(!(r225Lat>=31.43&&r225Lat<=44.35&&r225Lon>=122.37&&r225Lon<=132))return;
  final String name=r225ResolvedAddress.isEmpty()?"사진 촬영 위치":r225ResolvedAddress;
  // Naver Maps official direct place scheme avoids HTTPS /search page stacks.
  String link=String.format(Locale.US,
    "nmap://place?lat=%.7f&lng=%.7f&name=%s&appname=%s",
    r225Lat,r225Lon,Uri.encode(name),Uri.encode(activity.getPackageName()));
  Intent nav=new Intent(Intent.ACTION_VIEW,Uri.parse(link));
  nav.addCategory(Intent.CATEGORY_BROWSABLE);nav.setPackage("com.nhn.android.nmap");
  r227ExternalMapPending=true;
  r227VideoWasPlaying=false;
  try{if(media!=null&&prepared&&media.isPlaying()){
   r227VideoWasPlaying=true;media.pause();if(pause!=null)pause.setText("▶");
  }}catch(Exception ignored){}
  try{activity.startActivity(nav);}
  catch(Exception unavailable){
   // If Naver Maps isn't installed, fall back to existing verified HTTPS link.
   String query=r225ResolvedAddress.isEmpty()?String.format(Locale.US,"%.6f, %.6f",r225Lat,r225Lon):r225ResolvedAddress;
   try{activity.startActivity(new Intent(Intent.ACTION_VIEW,
       Uri.parse("https://map.naver.com/p/search/"+Uri.encode(query))));}
   catch(Exception failed){r227ResumeFromExternalMap();
    android.widget.Toast.makeText(activity,"네이버 지도를 열 수 없어요",0).show();}
  }
 }
 private void registerBack(){if(Build.VERSION.SDK_INT>=33){
  try{backCallback=()->{if(r207SavedPhotoViewer!=null)r207CloseSavedPhoto();else close();};activity.getOnBackInvokedDispatcher().registerOnBackInvokedCallback(
    android.window.OnBackInvokedDispatcher.PRIORITY_OVERLAY,backCallback);backRegistered=true;}catch(Exception ignored){}
 }}
 public void close(){
  if(Looper.myLooper()!=Looper.getMainLooper()){main.post(this::close);return;}
  r203CancelFling();
  if(r203StageVelocity!=null){r203StageVelocity.recycle();r203StageVelocity=null;}
  if(r205PreviewDismiss!=null){main.removeCallbacks(r205PreviewDismiss);r205PreviewDismiss=null;}
  if(r205CapturePreview!=null){r205CapturePreview.setImageDrawable(null);r205CapturePreview=null;}
  r207SavedPhotoLoadGeneration++;
  if(r207SavedPhotoViewer!=null&&r207SavedPhotoViewer.getParent() instanceof ViewGroup)
   ((ViewGroup)r207SavedPhotoViewer.getParent()).removeView(r207SavedPhotoViewer);
  if(r207SavedPhotoImage!=null)r207SavedPhotoImage.setImageDrawable(null);
  r207SavedPhotoViewer=null;r207SavedPhotoImage=null;r207ResumeVideoAfterPhoto=false;
  open=false;r227ExternalMapPending=false;r227VideoWasPlaying=false;
  loadToken++;videoToken++;scrubFrameToken++;
  // Never leave Android system bars hidden after closing the gallery.
  if(host!=null)try{activity.getWindow().getDecorView().setSystemUiVisibility(savedSystemUi);}catch(Exception ignored){}
  chromeVisible=true;videoScrubMode=false;scrubFrames.clear();scrubFrameClip="";
  if(r197ScrubAnim!=null){r197ScrubAnim.cancel();r197ScrubAnim=null;}r197ScrubExpansion=0f;r197CenterTapPending=false;
  if(motion!=null){motion.cancel();motion=null;}
  teardownPlayer();
  if(backRegistered&&Build.VERSION.SDK_INT>=33)try{activity.getOnBackInvokedDispatcher().unregisterOnBackInvokedCallback(backCallback);}catch(Exception ignored){}
  backRegistered=false;backCallback=null;
  if(host!=null&&host.getParent() instanceof ViewGroup)((ViewGroup)host.getParent()).removeView(host);
  for(int i=0;i<loadedPageIds.length;i++)loadedPageIds[i]=null;
  pendingPosters.clear();scrubPreview=null;
  if(r225PendingMeta!=null){main.removeCallbacks(r225PendingMeta);r225PendingMeta=null;}
  r225MetaSeq++;r225MetaId="";r225Info=null;r225CaptureTime=null;r225Address=null;r225Naver=null;
  host=null;stage=null;rail=null;lowerControls=null;volumeRow=null;volumeBubble=null;volumeRail=null;videoModeButton=null;videoModeHint=null;seekRow=null;backButton=null;menuButton=null;ids.clear();
 }
 private void refreshPages(){
  if(!open)return;
  header.setText("사진·영상   "+(index+1)+" / "+ids.size());
  r225ScheduleMeta();
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
  if(!selectedVideo){videoScrubMode=false;r197ScrubExpansion=0f;
   if(r197ScrubAnim!=null){r197ScrubAnim.cancel();r197ScrubAnim=null;}
   scrubFrameClip="";scrubFrameToken++;scrubFrames.clear();hideScrubPreview();}
  videoControls.setVisibility(selectedVideo?View.VISIBLE:View.GONE);
  if(seekRow!=null)seekRow.setVisibility(View.GONE);
  if(videoModeButton!=null)videoModeButton.setVisibility(View.GONE);
  if(seek!=null)seek.setVisibility(videoScrubMode?View.GONE:View.VISIBLE);
  if(videoModeHint!=null)videoModeHint.setVisibility(View.GONE);
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
  if(rail!=null)rail.r205Track(index-offset/Math.max(1,width));
 }
 // R203: unlike R201's one-photo settle, native Android OverScroller keeps
 // momentum after finger release, updates the SAME fractional photo+thumbnail
 // index, slows continuously, and only prepares video at the final selection.
 private float r203Clamp(float position){
  if(ids.isEmpty())return 0;
  return Math.max(0f,Math.min(ids.size()-1f,position));
 }
 private void r203CancelFling(){
  if(r203FlingFrame!=null){main.removeCallbacks(r203FlingFrame);r203FlingFrame=null;}
  if(r203Scroller!=null){r203Scroller.forceFinished(true);r203Scroller=null;}
  if(r203Snap!=null){ValueAnimator old=r203Snap;r203Snap=null;old.cancel();}
 }
 private void r203Present(float fractional){
  if(!open||ids.isEmpty()||stage==null)return;
  final float position=r203Clamp(fractional);r203FloatIndex=position;
  final int near=Math.max(0,Math.min(ids.size()-1,Math.round(position)));
  if(near!=index){
   index=near;loadToken++;resetPhotoZoom();
   refreshPages(); // only 3 visible pages, no full-resolution decode mid-fling
   if(rail!=null)rail.prefetch();
  }
  updatePosition((index-position)*Math.max(1,stage.getWidth()));
 }
 private void r203CompleteFling(){
  if(!open||ids.isEmpty())return;
  browsingRail=false;
  int near=Math.max(0,Math.min(ids.size()-1,Math.round(r203FloatIndex)));
  if(index!=near){index=near;loadToken++;resetPhotoZoom();}
  refreshPages();updatePosition(0);
  prepareCurrentVideo();
 }
 private void r203SnapNearest(float initial){
  if(!open||ids.isEmpty())return;
  final float from=r203Clamp(initial);
  final float to=Math.round(from);
  if(Math.abs(from-to)<.001f){r203Present(to);r203CompleteFling();return;}
  ValueAnimator animator=ValueAnimator.ofFloat(from,to);
  r203Snap=animator;animator.setDuration(150);
  animator.setInterpolator(new DecelerateInterpolator(1.6f));
  animator.addUpdateListener(a->{if(r203Snap==animator&&open)r203Present((float)a.getAnimatedValue());});
  animator.addListener(new android.animation.AnimatorListenerAdapter(){
   @Override public void onAnimationEnd(android.animation.Animator ended){
    if(r203Snap!=animator||!open)return;
    r203Snap=null;r203Present(to);r203CompleteFling();
   }
  });animator.start();
 }
 private void r203ReleaseWithVelocity(float initial,float fingerVelocity,float gain){
  if(!open||ids.isEmpty())return;
  r203CancelFling();
  if(motion!=null){ValueAnimator old=motion;motion=null;old.cancel();}
  if(r197ScrubAnim!=null){r197ScrubAnim.cancel();r197ScrubAnim=null;}
  videoScrubMode=false;r197ScrubExpansion=0f;
  if(media!=null||texture!=null)teardownPlayer();
  browsingRail=true;
  float starting=r203Clamp(initial);
  r203Present(starting);
  if(Math.abs(fingerVelocity)<380f||ids.size()<2){
   r203SnapNearest(starting);return;  }
  int stride=Math.max(1,dp(44)),startPx=Math.round(starting*stride);
  int minPx=Math.max(0,Math.round((starting-45f)*stride));
  int maxPx=Math.min(Math.round((ids.size()-1f)*stride),Math.round((starting+45f)*stride));
  int speed=Math.round(Math.max(-14000f,Math.min(14000f,-fingerVelocity*gain)));
  r203Scroller=new android.widget.OverScroller(activity);
  r203Scroller.fling(startPx,0,speed,0,minPx,maxPx,0,0);
  final Runnable runner=new Runnable(){public void run(){
   if(r203FlingFrame!=this||!open||rail==null||r203Scroller==null)return;
   if(r203Scroller.computeScrollOffset()){
    r203Present(r203Scroller.getCurrX()/(float)stride);
    if(!r203Scroller.isFinished()){rail.postOnAnimation(this);return;}
   }
   r203FlingFrame=null;
   float at=r203FloatIndex;
   r203Scroller=null;
   r203SnapNearest(at);
  }};
  r203FlingFrame=runner;rail.postOnAnimation(runner);
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
  r203CancelFling();
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
     r203CancelFling();
     if(r203StageVelocity!=null)r203StageVelocity.recycle();
     r203StageVelocity=android.view.VelocityTracker.obtain();
     r203StageVelocity.addMovement(e);
     if(motion!=null){motion.cancel();motion=null;}
     pinch=false;startX=lastX=e.getX();startY=lastY=e.getY();startTime=SystemClock.uptimeMillis();return true;
    case MotionEvent.ACTION_POINTER_DOWN:
     if(photo&&e.getPointerCount()>1){
      initialDistance=(float)Math.hypot(e.getX(0)-e.getX(1),e.getY(0)-e.getY(1));
      initialZoom=photoZoom;pinch=true;return true;
     }return true;
    case MotionEvent.ACTION_MOVE:{
     if(r203StageVelocity!=null)r203StageVelocity.addMovement(e);
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
     float releaseVelocity=0f;
     if(r203StageVelocity!=null){
      r203StageVelocity.addMovement(e);
      r203StageVelocity.computeCurrentVelocity(1000,14000f);
      releaseVelocity=r203StageVelocity.getXVelocity();
      r203StageVelocity.recycle();r203StageVelocity=null;
     }
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
     // R213: full-size stage ALWAYS settles at most one neighboring image.
     // Momentum multi-item fling is intentionally reserved for the lower GalleryRail.
     // Its r203ReleaseWithVelocity() still calls r203Present() to move the upper
     // full-size photo/video in sync when the *lower rail* is flung.
     float velocity=Math.abs(dx)/dt;
     int toward=(Math.abs(dx)>stage.getWidth()*.23f||velocity>0.62f)?(dx<0?-1:1):0;
     if((index==0&&toward>0)||(index==ids.size()-1&&toward<0))toward=0;
     settle(toward,Math.max(-stage.getWidth(),Math.min(stage.getWidth(),dx)));return true;
    }
    case MotionEvent.ACTION_CANCEL:
     if(r203StageVelocity!=null){r203StageVelocity.recycle();r203StageVelocity=null;}
     pinch=false;settle(0,fingerOffset);return true;
    default:return true;
   }
  }
 }
 private final class GalleryRail extends View{
  private final Paint paint=new Paint(3);
  private float center,indexAtDown,xAtDown;
  // R207: selected-thumbnail-only rise; adjacent thumbnails stay vertically fixed.
  private android.view.VelocityTracker r203RailVelocity;
  private boolean r203RailMoved;
   // R201 scene painting only within selected thumbnail.
  private long downAt;
  GalleryRail(){super(activity);setLayerType(View.LAYER_TYPE_HARDWARE,null);setOnTouchListener(this::touch);}
  void r205Track(float target){
   // Keep exact R203 fractional OverScroller position; no adjacent wave oscillation.
   center=target;invalidate();
  }
  @Override protected void onDraw(Canvas canvas){super.onDraw(canvas);
   // R199: never replace the entire mixed-media rail with a video-only rail.
   float stride=dp(44),cw=getWidth()*.5f,ht=getHeight()*.5f;
   // Samsung-like effect: one selected thumbnail pops up, all other Y positions stay fixed.
   int lo=Math.max(0,(int)Math.floor(center)-12),hi=Math.min(ids.size()-1,(int)Math.ceil(center)+12);
   // R227: selected video timeline spreads across the RAIL to the right,
   // pushing earlier stills left and later photos right like Samsung Gallery.
   float expanded=Math.max(0f,Math.min(1f,r197ScrubExpansion));
   boolean activeScene=expanded>.001f&&video(ids.get(index));
   float leftVideo=(cw-dp(19))+(dp(52)-(cw-dp(19)))*expanded;
   float rightVideo=(cw+dp(19))+(getWidth()-dp(16)-(cw+dp(19)))*expanded;
   for(int i=lo;i<=hi;i++){
    float x=cw+(i-center)*stride;
     if(activeScene){
      if(i<index)x+=(leftVideo-(cw-dp(19)));
      if(i>index)x+=(rightVideo-(cw+dp(19)));
     }
     if(x<-stride-getWidth()||x>getWidth()*2f)continue;
     String id=ids.get(i);Bitmap bmp=posters.get(id);
     float localY=i==index?-dp(8)*Math.max(0f,1f-Math.abs(i-center)) : 0f;
     RectF box=(i==index&&activeScene)?new RectF(leftVideo,ht-dp(23)+localY,
       rightVideo,ht+dp(23)+localY):new RectF(x-dp(19),ht-dp(23)+localY,
       x+dp(19),ht+dp(23)+localY);
    paint.setColor(0xff33363a);canvas.drawRoundRect(box,dp(5),dp(5),paint);
    if(bmp!=null&&!(i==index&&r197ScrubExpansion>0.001f)){
     float ratio=Math.max((float)box.width()/bmp.getWidth(),(float)box.height()/bmp.getHeight());
     int bw=Math.min(bmp.getWidth(),Math.round(box.width()/ratio)),bh=Math.min(bmp.getHeight(),Math.round(box.height()/ratio));
     Rect src=new Rect((bmp.getWidth()-bw)/2,(bmp.getHeight()-bh)/2,(bmp.getWidth()+bw)/2,(bmp.getHeight()+bh)/2);
     canvas.drawBitmap(bmp,src,box,paint);
    }
    if(i==index&&r197ScrubExpansion>0.001f&&video(id)){
     canvas.save();canvas.clipRect(box);r201DrawSceneFrames(canvas,paint,box);canvas.restore();
    }
    paint.setStyle(Paint.Style.STROKE);paint.setStrokeWidth(i==index?dp(3):dp(1));
    paint.setColor(i==index?0xfffff7f9:0x883d4350);canvas.drawRoundRect(box,dp(5),dp(5),paint);
    paint.setStyle(Paint.Style.FILL);
    if(video(id)){
     paint.setColor(0xbb111111);canvas.drawCircle(x,ht+localY,dp(7),paint);
     paint.setColor(-1);paint.setTextSize(dp(9));canvas.drawText("▶",x-dp(3),ht+localY+dp(3),paint);
     if(i==index&&prepared&&media!=null&&r197ScrubExpansion<0.01f){
      // R195: playback position is visible even BEFORE opening the scene strip.
      float progress=0;
      try{progress=Math.max(0f,Math.min(1f,(float)media.getCurrentPosition()/Math.max(1,media.getDuration())));}catch(Exception ignored){}
      float cursor=box.left+progress*box.width();
      paint.setColor(0x99ffffff);canvas.drawRect(box.left,box.bottom-dp(3),cursor,box.bottom,paint);
      paint.setColor(Color.WHITE);canvas.drawRoundRect(new RectF(cursor-dp(1),box.top,cursor+dp(1),box.bottom),dp(1),dp(1),paint);
     }
    }
   }
   // Adjacent photo/video thumbnails remain present throughout transition.
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
   if(videoScrubMode && !ids.isEmpty() && video(ids.get(index))){
    final int action=e.getActionMasked();
    if(action==MotionEvent.ACTION_DOWN){
     r227ScrubDownX=e.getX();r227ScrubDownY=e.getY();r227ScrubDragged=false;
     return true;
    }
    if(action==MotionEvent.ACTION_MOVE){
     if(!r227ScrubDragged){
      if(Math.abs(e.getX()-r227ScrubDownX)<dp(7)&&
         Math.abs(e.getY()-r227ScrubDownY)<dp(10))return true;
      r227ScrubDragged=true;
      MotionEvent down=MotionEvent.obtain(e);down.setAction(MotionEvent.ACTION_DOWN);
      down.setLocation(r227ScrubDownX,r227ScrubDownY);
      MoaNativeGallery.this.touchVideoFrames(down);down.recycle();
     }
     return MoaNativeGallery.this.touchVideoFrames(e);
    }
    if(action==MotionEvent.ACTION_UP){
     if(!r227ScrubDragged){
      setVideoScrubMode(false);return true; // Tap ANY part of filmstrip to fold.
     }
     r227ScrubDragged=false;
     return MoaNativeGallery.this.touchVideoFrames(e);
    }
    if(action==MotionEvent.ACTION_CANCEL){
     if(r227ScrubDragged)MoaNativeGallery.this.touchVideoFrames(e);
     r227ScrubDragged=false;return true;
    }
    return true;
   }
   switch(e.getActionMasked()){
    case MotionEvent.ACTION_DOWN:{
     r203CancelFling();
     if(r203RailVelocity!=null)r203RailVelocity.recycle();
     r203RailVelocity=android.view.VelocityTracker.obtain();
     r203RailVelocity.addMovement(e);
     r203RailMoved=false;browsingRail=true;
     xAtDown=e.getX();indexAtDown=center;
     downAt=SystemClock.uptimeMillis();return true;
    }
    case MotionEvent.ACTION_MOVE:{
     if(r203RailVelocity!=null)r203RailVelocity.addMovement(e);
     float dx=e.getX()-xAtDown;
     if(!r203RailMoved&&Math.abs(dx)>=dp(4)){
      r203RailMoved=true;
      // The one video player is released only once when actual rail dragging begins.
      if(media!=null||texture!=null)teardownPlayer();
     }
     if(!r203RailMoved)return true;
     float next=r203Clamp(indexAtDown-dx/Math.max(1,dp(44)));
     r203Present(next);
     return true;
    }
    case MotionEvent.ACTION_UP:{
     if(r203RailVelocity!=null)r203RailVelocity.addMovement(e);
     float vx=0;
     if(r203RailVelocity!=null){
      r203RailVelocity.computeCurrentVelocity(1000,12000f);
      vx=r203RailVelocity.getXVelocity();
      r203RailVelocity.recycle();r203RailVelocity=null;
     }
     float dx=e.getX()-xAtDown;
     if(!r203RailMoved&&Math.abs(dx)<dp(8)){
      browsingRail=false;
      int tapped=Math.max(0,Math.min(ids.size()-1,
       Math.round(center+(e.getX()-getWidth()*.5f)/Math.max(1,dp(44)))));
      if(tapped!=index){
       navigate(tapped);
      }else{
       refreshPages();updatePosition(0);
       if(video(ids.get(index))&&media==null)prepareCurrentVideo();
      }
      if(video(ids.get(tapped)))setVideoScrubMode(true);
      return true;
     }
     float next=r203Clamp(indexAtDown-dx/Math.max(1,dp(44)));
     // Android physics, not one-image snap: flick velocity determines travel.
     r203ReleaseWithVelocity(next,vx,1f);
     return true;
    }
    case MotionEvent.ACTION_CANCEL:{
     if(r203RailVelocity!=null){r203RailVelocity.recycle();r203RailVelocity=null;}
     r203ReleaseWithVelocity(r203FloatIndex,0f,1f);
     return true;
    }
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
    // Keep the selected video poster visible until the first decoded frame.
    texture.setAlpha(0f);
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
       prepared=true;p.setVolume(0,0);p.start();mute.setText("♪");mute.setContentDescription("동영상 소리 켜기");pause.setText("Ⅱ");
       updateVideoGeometry(p.getVideoWidth(),p.getVideoHeight());startTicker();
       // Prefetch on video prepare, before the user taps the selected thumbnail.
       // It runs only on frameWorker and reveals a single completed batch.
       requestScrubFrames();});
      player.setOnInfoListener((p,what,extra)->{if(what==MediaPlayer.MEDIA_INFO_VIDEO_RENDERING_START&&token==videoToken){
       final TextureView firstFrame=texture;
        if(firstFrame!=null)firstFrame.animate().alpha(1f).setDuration(130).withEndAction(()->{
         if(token==videoToken&&open&&images[1]!=null)images[1].setVisibility(View.INVISIBLE);
        }).start();
        return true;}return false;});
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
  pause.setText(media.isPlaying()?"Ⅱ":"▶");pause.setContentDescription(media.isPlaying()?"동영상 일시정지":"동영상 재생");}catch(Exception ignored){}}
 private void anchorVolumeBubble(){
  if(host==null||mute==null||volumeBubble==null||volumeBubble.getParent()!=host)return;
  if(host.getWidth()==0||mute.getWidth()==0){volumeBubble.post(()->{if(open)anchorVolumeBubble();});return;}
  int[] a=new int[2],h=new int[2];mute.getLocationInWindow(a);host.getLocationInWindow(h);
  int w=dp(58),height=dp(187);
  FrameLayout.LayoutParams pos=(FrameLayout.LayoutParams)volumeBubble.getLayoutParams();
  pos.gravity=Gravity.TOP|Gravity.LEFT;
  pos.leftMargin=Math.max(dp(5),Math.min(Math.max(dp(5),host.getWidth()-w-dp(5)),
   a[0]-h[0]+mute.getWidth()/2-w/2));
  pos.topMargin=Math.max(dp(9),a[1]-h[1]-height-dp(11));
  volumeBubble.setLayoutParams(pos);
 }
 private final class VerticalMediaVolume extends View{
  final Paint p=new Paint(Paint.ANTI_ALIAS_FLAG);
  VerticalMediaVolume(){super(activity);setContentDescription("미디어 음량, 위아래로 밀어 조절");setClickable(true);}
  private int streamMax(){try{AudioManager a=(AudioManager)activity.getSystemService(Activity.AUDIO_SERVICE);return a==null?15:Math.max(1,a.getStreamMaxVolume(AudioManager.STREAM_MUSIC));}catch(Exception e){return 15;}}
  private int streamNow(){try{AudioManager a=(AudioManager)activity.getSystemService(Activity.AUDIO_SERVICE);return a==null?0:a.getStreamVolume(AudioManager.STREAM_MUSIC);}catch(Exception e){return 0;}}
  @Override protected void onDraw(Canvas c){
   super.onDraw(c);float cx=getWidth()/2f,top=dp(42),bottom=getHeight()-dp(23);
   int max=streamMax(),value=Math.max(0,Math.min(max,streamNow()));
   float level=value/(float)Math.max(1,max);
   p.setStyle(Paint.Style.FILL);
   p.setColor(0x666f7581);c.drawRoundRect(cx-dp(5),top,cx+dp(5),bottom,dp(5),dp(5),p);
   float y=bottom-(bottom-top)*level;
   p.setColor(0xfff1f3f7);c.drawRoundRect(cx-dp(5),y,cx+dp(5),bottom,dp(5),dp(5),p);
   p.setColor(Color.WHITE);c.drawCircle(cx,y,dp(10),p);
   p.setTextAlign(Paint.Align.CENTER);p.setTextSize(dp(12));p.setTypeface(Typeface.DEFAULT_BOLD);
   c.drawText(Math.round(100f*level)+"%",cx,dp(25),p);
  }
  @Override public boolean onTouchEvent(MotionEvent e){
   int action=e.getActionMasked();
   if(action==MotionEvent.ACTION_DOWN||action==MotionEvent.ACTION_MOVE){
    if(!open||muted)return true;
    float top=dp(42),bottom=getHeight()-dp(23);
    float frac=Math.max(0f,Math.min(1f,(bottom-e.getY())/Math.max(1f,bottom-top)));
    try{
     AudioManager a=(AudioManager)activity.getSystemService(Activity.AUDIO_SERVICE);
     if(a!=null&&!a.isVolumeFixed())a.setStreamVolume(AudioManager.STREAM_MUSIC,
      Math.round(frac*Math.max(1,a.getStreamMaxVolume(AudioManager.STREAM_MUSIC))),0);
    }catch(SecurityException ignored){}
    invalidate();return true;
   }
   return true;
  }
 }
 private void updateMediaVolume(){
  if(volumeBubble==null||host==null||ids.isEmpty())return;
  boolean shown=open&&chromeVisible&&video(ids.get(index))&&!muted;
  volumeBubble.setVisibility(shown?View.VISIBLE:View.GONE);
  if(shown){
   volumeBubble.post(()->{if(open&&volumeBubble!=null)anchorVolumeBubble();});
   if(volumeRail!=null)volumeRail.invalidate();
  }
  // Do not resize or reposition the main 3-button control strip.
 }
 private void toggleMute(){muted=!muted;try{if(media!=null)media.setVolume(muted?0:1,muted?0:1);}catch(Exception ignored){}
  mute.setText(muted?"♪":"♫");mute.setContentDescription(muted?"동영상 소리 켜기":"동영상 소리 끄기");updateMediaVolume();}
 
 // R181: tap-to-immersive (without changing media-selection or video playback).
 private void toggleChrome(){
  if(!open)return;
  chromeVisible=!chromeVisible;
   if(header!=null)header.setVisibility(View.GONE);
   if(r225Info!=null)r225Info.setVisibility(chromeVisible?View.VISIBLE:View.GONE);
   if(backButton!=null)backButton.setVisibility(View.GONE);
   if(menuButton!=null)menuButton.setVisibility(View.GONE);
  if(lowerControls!=null)lowerControls.setVisibility(chromeVisible?View.VISIBLE:View.GONE);
  // Hide/show the anchored popup with chrome; preserve all main-control positions.
  updateMediaVolume();
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
  if(r197ScrubAnim!=null){r197ScrubAnim.cancel();r197ScrubAnim=null;}
  videoScrubMode=enabled;
  ValueAnimator expand=ValueAnimator.ofFloat(r197ScrubExpansion,enabled?1f:0f);
  r197ScrubAnim=expand;expand.setDuration(175);
  expand.setInterpolator(new DecelerateInterpolator(1.35f));
  expand.addUpdateListener(anim->{
   r197ScrubExpansion=(float)anim.getAnimatedValue();if(rail!=null)rail.invalidate();
  });
  expand.addListener(new android.animation.AnimatorListenerAdapter(){
   @Override public void onAnimationEnd(android.animation.Animator done){
    if(r197ScrubAnim==expand)r197ScrubAnim=null;
   }
  });expand.start();
  if(videoModeButton!=null)videoModeButton.setVisibility(View.GONE);
  if(videoModeHint!=null)videoModeHint.setVisibility(View.GONE);
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
  scrubFrameCount=Math.max(10,Math.min(20, (int)Math.ceil(total/2500f)+1));
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
 // R201: scene thumbnails are drawn only inside the expanded active video.
 // Blank grey lead-ins are eliminated, even while frame extraction is pending.
 private void r201DrawSceneFrames(Canvas canvas,Paint paint,RectF slot){
  if(ids.isEmpty()||!video(ids.get(index)))return;
  final int count=Math.max(2,scrubFrameCount),duration=videoLengthMs();
  final float step=dp(38),visible=slot.width()/Math.max(1f,step);
  final float active=Math.max(0f,Math.min(count-1f,((float)videoPositionMs()/Math.max(1,duration))*(count-1)));
  final float origin=Math.max(0f,Math.min(Math.max(0f,count-visible),active-visible*.5f));
  final int first=Math.max(0,(int)Math.floor(origin));
  final int last=Math.min(count-1,(int)Math.ceil(origin+visible));
  final Bitmap poster=posters.get(ids.get(index));
  for(int i=first;i<=last;i++){
   float x=slot.left+(i-origin)*step;
   RectF box=new RectF(x,slot.top,x+step+dp(1),slot.bottom);
   paint.setColor(0xff1b1e24);canvas.drawRect(box,paint);
   Bitmap frame=scrubFrames.get(i);
   if(frame==null||frame.isRecycled())frame=poster;
   if(frame!=null&&!frame.isRecycled()&&frame.getWidth()>0&&frame.getHeight()>0){
    float scale=Math.max(box.width()/frame.getWidth(),box.height()/frame.getHeight());
    int sw=Math.max(1,Math.min(frame.getWidth(),Math.round(box.width()/scale)));
    int sh=Math.max(1,Math.min(frame.getHeight(),Math.round(box.height()/scale)));
    Rect crop=new Rect((frame.getWidth()-sw)/2,(frame.getHeight()-sh)/2,
                       (frame.getWidth()+sw)/2,(frame.getHeight()+sh)/2);
    canvas.drawBitmap(frame,crop,box,paint);
   }
   paint.setColor(0x55ffffff);paint.setStrokeWidth(dp(.5f));
   canvas.drawLine(box.right,box.top,box.right,box.bottom,paint);
  }
  float marker=Math.max(slot.left+dp(1),Math.min(slot.right-dp(1),slot.left+(active-origin)*step));
  paint.setColor(Color.WHITE);
  canvas.drawRoundRect(new RectF(marker-dp(1.4f),slot.top,marker+dp(1.4f),slot.bottom),
                       dp(1.4f),dp(1.4f),paint);
 }
 private boolean scrubTouch(MotionEvent e,float firstX,float firstTimeMs,int duration){
  if(media==null||!prepared)return true;
  float width=Math.max(dp(100),getWidthSafe(rail)-dp(72));
  int target=Math.round(firstTimeMs+(firstX-e.getX())/width*duration);
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

 
 // R207 captured image viewer lives above the same existing gallery host.
 // It does not navigate the media index, destroy the video player, or mutate the diary.
 private void r207OpenSavedPhoto(Uri saved){
  if(!open||host==null||saved==null||r207SavedPhotoViewer!=null)return;
  if(r205PreviewDismiss!=null){main.removeCallbacks(r205PreviewDismiss);r205PreviewDismiss=null;}
  if(r205CapturePreview!=null){
   r205CapturePreview.animate().cancel();
   if(r205CapturePreview.getParent() instanceof ViewGroup)
    ((ViewGroup)r205CapturePreview.getParent()).removeView(r205CapturePreview);
   r205CapturePreview.setImageDrawable(null);r205CapturePreview=null;
  }
  r207ResumeVideoAfterPhoto=false;
  try{if(media!=null&&prepared&&media.isPlaying()){
   r207ResumeVideoAfterPhoto=true;media.pause();
   if(pause!=null)pause.setText("▶");
  }}catch(Exception ignored){}
  FrameLayout overlay=new FrameLayout(activity);overlay.setBackgroundColor(Color.BLACK);
  overlay.setClickable(true);overlay.setFocusableInTouchMode(true);
  r207SavedPhotoViewer=overlay;
  ImageView image=new ImageView(activity);r207SavedPhotoImage=image;
  image.setBackgroundColor(Color.BLACK);image.setScaleType(ImageView.ScaleType.FIT_CENTER);
  overlay.addView(image,new FrameLayout.LayoutParams(-1,-1));
  TextView back=new TextView(activity);back.setText("‹  돌아가기");
  back.setTextColor(Color.WHITE);back.setTextSize(15);back.setGravity(Gravity.CENTER);
  android.graphics.drawable.GradientDrawable backBg=new android.graphics.drawable.GradientDrawable();
  backBg.setColor(0xd522242a);backBg.setCornerRadius(dp(22));
  back.setBackground(backBg);back.setClickable(true);
  back.setOnClickListener(v->r207CloseSavedPhoto());
  FrameLayout.LayoutParams backPos=new FrameLayout.LayoutParams(dp(112),dp(44),Gravity.TOP|Gravity.LEFT);
  backPos.leftMargin=dp(10);backPos.topMargin=dp(15);
  overlay.addView(back,backPos);
  overlay.setOnKeyListener((v,keyCode,event)->{
   if(keyCode==android.view.KeyEvent.KEYCODE_BACK&&event.getAction()==android.view.KeyEvent.ACTION_UP){
    r207CloseSavedPhoto();return true;
   }
   return false;
  });
  host.addView(overlay,new FrameLayout.LayoutParams(-1,-1));overlay.requestFocus();
  final int generation=++r207SavedPhotoLoadGeneration;
  background.execute(()->{
   Bitmap loaded=null;
   try{
    BitmapFactory.Options size=new BitmapFactory.Options();size.inJustDecodeBounds=true;
    try(InputStream input=activity.getContentResolver().openInputStream(saved)){
     if(input!=null)BitmapFactory.decodeStream(input,null,size);
    }
    int maxDim=Math.max(size.outWidth,size.outHeight),sampling=1;
    while(maxDim/sampling>4096)sampling*=2;
    BitmapFactory.Options opts=new BitmapFactory.Options();opts.inSampleSize=sampling;
    try(InputStream input=activity.getContentResolver().openInputStream(saved)){
     if(input!=null)loaded=BitmapFactory.decodeStream(input,null,opts);
    }
   }catch(Exception ignored){}
   final Bitmap ready=loaded;
   main.post(()->{
    if(generation!=r207SavedPhotoLoadGeneration||!open||r207SavedPhotoViewer!=overlay)return;
    if(ready!=null){image.setImageBitmap(ready);}
    else android.widget.Toast.makeText(activity,"저장한 사진을 열 수 없어요",0).show();
   });
  });
 }
 private void r207CloseSavedPhoto(){
  if(r207SavedPhotoViewer==null)return;
  ++r207SavedPhotoLoadGeneration;
  FrameLayout overlay=r207SavedPhotoViewer;
  r207SavedPhotoViewer=null;
  if(r207SavedPhotoImage!=null){r207SavedPhotoImage.setImageDrawable(null);r207SavedPhotoImage=null;}
  if(overlay.getParent() instanceof ViewGroup)((ViewGroup)overlay.getParent()).removeView(overlay);
  // Return to the identical gallery media, original playback position and audio policy.
  if(open&&r207ResumeVideoAfterPhoto&&prepared&&media!=null){
   try{media.start();if(pause!=null)pause.setText("Ⅱ");}catch(Exception ignored){}
  }
  r207ResumeVideoAfterPhoto=false;
  if(host!=null)host.requestFocus();
 }

 private void r205ShowCapturePreview(Bitmap thumb,Uri saved){
  if(thumb==null||host==null||!open)return;
  if(r205PreviewDismiss!=null){main.removeCallbacks(r205PreviewDismiss);r205PreviewDismiss=null;}
  if(r205CapturePreview!=null){
   if(r205CapturePreview.getParent() instanceof ViewGroup)
    ((ViewGroup)r205CapturePreview.getParent()).removeView(r205CapturePreview);
   r205CapturePreview.setImageDrawable(null);
  }
  ImageView preview=new ImageView(activity);r205CapturePreview=preview;
  preview.setImageBitmap(thumb);preview.setScaleType(ImageView.ScaleType.CENTER_CROP);
  preview.setPadding(dp(2),dp(2),dp(2),dp(2));
  android.graphics.drawable.GradientDrawable frame=new android.graphics.drawable.GradientDrawable();
  frame.setColor(0xe51b1c20);frame.setCornerRadius(dp(7));frame.setStroke(dp(1),0xbde3e5e8);
  preview.setBackground(frame);preview.setClipToOutline(true);preview.setElevation(dp(6));
  FrameLayout.LayoutParams p=new FrameLayout.LayoutParams(dp(56),dp(68),Gravity.RIGHT|Gravity.BOTTOM);
  p.rightMargin=dp(15);p.bottomMargin=dp(128);
  host.addView(preview,p);
  preview.setContentDescription("저장된 캡처 사진 크게 보기");
  preview.setClickable(true);
  preview.setOnClickListener(v->r207OpenSavedPhoto(saved));
  preview.setAlpha(0f);preview.setScaleX(.78f);preview.setScaleY(.78f);preview.setTranslationY(dp(10));
  preview.animate().alpha(1f).scaleX(1f).scaleY(1f).translationY(0f).setDuration(200).start();
  Runnable hide=()->{
   if(r205CapturePreview!=preview)return;
   preview.animate().alpha(0f).translationY(-dp(8)).setDuration(180).withEndAction(()->{
    if(r205CapturePreview==preview){r205CapturePreview=null;preview.setImageDrawable(null);
     if(preview.getParent() instanceof ViewGroup)((ViewGroup)preview.getParent()).removeView(preview);}
   }).start();
  };
  r205PreviewDismiss=hide;main.postDelayed(hide,1300);
 }
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
    Bitmap thumb=null;
    // Thumbnail is derived from the ACTUAL saved frame; memory bounded and only after commit.
    try{int h=dp(78),w=Math.max(1,Math.round(h*(float)stillFrame.getWidth()/Math.max(1,stillFrame.getHeight())));
     thumb=Bitmap.createScaledBitmap(stillFrame,Math.min(dp(98),w),h,true);}catch(Throwable ignored){}
    final Bitmap preview=thumb;
    final Uri savedUri=created;
    done=true;main.post(()->{if(open&&preview!=null)r205ShowCapturePreview(preview,savedUri);
     /* The captured-photo thumbnail is confirmation; no redundant success toast. */});
   }catch(Exception e){main.post(()->android.widget.Toast.makeText(activity,"장면 저장 실패: "+e.getMessage(),0).show());}
   finally{if(!done&&created!=null)try{activity.getContentResolver().delete(created,null,null);}catch(Exception ignored){}}
  });
 }
}