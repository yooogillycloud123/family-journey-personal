package com.juhyeon.familyjourney;

import android.app.Activity;
import android.app.DatePickerDialog;
import android.app.Dialog;
import android.content.ContentUris;
import android.content.res.Configuration;
import android.database.Cursor;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Color;
import android.graphics.drawable.GradientDrawable;
import android.media.MediaPlayer;
import android.net.Uri;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.provider.MediaStore;
import android.util.LruCache;
import android.util.Size;
import android.view.Gravity;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup;
import android.view.Window;
import android.widget.BaseAdapter;
import android.widget.Button;
import android.widget.FrameLayout;
import android.widget.GridView;
import android.widget.HorizontalScrollView;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.SeekBar;
import android.widget.TextView;
import android.widget.Toast;
import android.widget.VideoView;
import org.json.JSONArray;
import org.json.JSONObject;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.LinkedHashSet;
import java.util.Locale;
import java.util.List;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.text.SimpleDateFormat;

/** Separate Activity: no MoaNativeGallery, r507StopInline, rearm, original Gallery host or owner. */
public final class MoaR651PhotoPickerActivity extends Activity {
  private static final String PREF="moa_r651_picker_result";
  private final ExecutorService images=Executors.newFixedThreadPool(3);
  private final Handler ui=new Handler(Looper.getMainLooper());
  private final LruCache<String,Bitmap> cache=new LruCache<String,Bitmap>(48*1024){
    @Override protected int sizeOf(String key,Bitmap b){return b.getByteCount()/1024;}
  };
  private final ArrayList<Item> all=new ArrayList<>(),visible=new ArrayList<>();
  private final LinkedHashSet<String> chosen=new LinkedHashSet<>();
  private String day;
  private boolean allPeriod=false,fast=false,railExpanded=true,dragSelect=false;
  private GridView grid;
  private TextView status,subtitle;
  private Button save,scope;
  private PickerAdapter adapter;
  private Dialog preview;
  private LinearLayout rail;
  private ImageView large;
  private VideoView movie;
  private TextView previewTitle,mediaStatus;
  private SeekBar progress;
  private int current=0;
  private long touchAt,gestureAt;
  private float touchX,touchY;
  private MediaPlayer currentPlayer;
  private boolean muted=false;
  private Runnable videoClock;
  private final SimpleDateFormat dayFormat=new SimpleDateFormat("yyyy-MM-dd",Locale.KOREA);
  private static final class Item {
    long numeric,time; boolean video;Uri uri;String id,day;
    Item(long n,long t,boolean v,String d){numeric=n;time=t;video=v;id=v?"v"+n:String.valueOf(n);day=d;
      uri=ContentUris.withAppendedId(v?MediaStore.Video.Media.EXTERNAL_CONTENT_URI:MediaStore.Images.Media.EXTERNAL_CONTENT_URI,n);
    }
  }
  private int dp(float v){return Math.round(getResources().getDisplayMetrics().density*v);}
  private GradientDrawable bg(int fill,int stroke,int radius){
    GradientDrawable d=new GradientDrawable();d.setColor(fill);d.setCornerRadius(dp(radius));
    if(stroke!=0)d.setStroke(dp(1),stroke);return d;
  }
  private TextView label(String t,int sp,int color){TextView v=new TextView(this);v.setText(t);v.setTextColor(color);v.setTextSize(sp);v.setGravity(Gravity.CENTER_VERTICAL);return v;}
  private Button button(String t){Button b=new Button(this);b.setAllCaps(false);b.setText(t);b.setTextSize(13);b.setMinHeight(0);b.setMinimumHeight(0);b.setPadding(dp(7),0,dp(7),0);return b;}
  private LinearLayout.LayoutParams row(int w,int h){return new LinearLayout.LayoutParams(w<0?w:dp(w),h<0?h:dp(h));}
  private String date(long millis){synchronized(dayFormat){return dayFormat.format(new Date(millis));}}
  @Override public void onCreate(Bundle state){super.onCreate(state);
    getWindow().setStatusBarColor(Color.rgb(17,19,24));getWindow().setNavigationBarColor(Color.rgb(17,19,24));
    day=getIntent().getStringExtra("moa_day");if(day==null||!day.matches("\\d{4}-\\d{2}-\\d{2}"))day=date(System.currentTimeMillis());
    draw();loadMedia();android.util.Log.i("MOA_R651","PICKER_ACTIVITY_CREATED");
  }
  private void draw(){
    LinearLayout screen=new LinearLayout(this);screen.setOrientation(LinearLayout.VERTICAL);screen.setBackgroundColor(Color.rgb(17,19,24));
    LinearLayout bar=new LinearLayout(this);bar.setGravity(Gravity.CENTER_VERTICAL);bar.setPadding(dp(8),dp(6),dp(8),dp(6));
    Button back=button("‹");back.setOnClickListener(v->finish());bar.addView(back,row(42,43));
    status=label("선택 0개",16,Color.WHITE);status.setTypeface(null,1);bar.addView(status,new LinearLayout.LayoutParams(0,dp(43),1));
    save=button("일기에 추가");save.setEnabled(false);save.setOnClickListener(v->save());bar.addView(save,row(109,43));screen.addView(bar,row(-1,56));
    LinearLayout head=new LinearLayout(this);head.setGravity(Gravity.CENTER_VERTICAL);head.setPadding(dp(12),0,dp(12),dp(5));
    subtitle=label(day,14,Color.LTGRAY);subtitle.setOnClickListener(v->chooseDay());head.addView(subtitle,new LinearLayout.LayoutParams(0,dp(42),1));
    scope=button("전체 기간");scope.setOnClickListener(v->{allPeriod=!allPeriod;scope.setText(allPeriod?"선택 날짜":"전체 기간");refresh();});head.addView(scope,row(96,42));screen.addView(head,row(-1,47));
    TextView hint=label("사진 터치: 선택  ·  좌하단 돋보기: 확대  ·  길게 눌러 드래그: 연속 선택",11,Color.LTGRAY);
    hint.setPadding(dp(13),0,0,0);screen.addView(hint,row(-1,29));
    grid=new GridView(this);grid.setNumColumns(3);grid.setVerticalSpacing(dp(3));grid.setHorizontalSpacing(dp(3));
    grid.setPadding(dp(3),dp(4),dp(3),dp(4));grid.setClipToPadding(false);grid.setBackgroundColor(Color.rgb(12,13,18));
    adapter=new PickerAdapter();grid.setAdapter(adapter);
    grid.setOnItemClickListener((parent,view,pos,id)->{if(pos>=0&&pos<visible.size())toggle(visible.get(pos).id);});
    grid.setOnItemLongClickListener((parent,view,pos,id)->{dragSelect=true;touchAt=System.currentTimeMillis();if(pos>=0&&pos<visible.size())toggle(visible.get(pos).id);return true;});
    grid.setOnTouchListener((v,e)->{if(e.getActionMasked()==MotionEvent.ACTION_DOWN){dragSelect=false;}
      if(dragSelect&&e.getActionMasked()==MotionEvent.ACTION_MOVE){int p=grid.pointToPosition((int)e.getX(),(int)e.getY());
        if(p>=0&&p<visible.size()){String id=visible.get(p).id;if(!chosen.contains(id)){chosen.add(id);changeCount();adapter.notifyDataSetChanged();}}
        if(e.getY()>grid.getHeight()-dp(55))grid.smoothScrollBy(dp(55),190);
        if(e.getY()<dp(55))grid.smoothScrollBy(-dp(55),190);
        return true;
      }
      if(e.getActionMasked()==MotionEvent.ACTION_UP||e.getActionMasked()==MotionEvent.ACTION_CANCEL)dragSelect=false;
      return false;});
    screen.addView(grid,new LinearLayout.LayoutParams(-1,0,1));setContentView(screen);
  }
  private void chooseDay(){
    try{String[] d=day.split("-");int y=Integer.parseInt(d[0]),m=Integer.parseInt(d[1]),n=Integer.parseInt(d[2]);
      new DatePickerDialog(this,(v,yy,mm,dd)->{day=String.format(Locale.US,"%04d-%02d-%02d",yy,mm+1,dd);refresh();},y,m-1,n).show();
    }catch(Exception ex){Toast.makeText(this,"날짜 선택을 열 수 없습니다",Toast.LENGTH_SHORT).show();}
  }
  private void loadMedia(){
    images.execute(()->{
      ArrayList<Item> fresh=new ArrayList<>();
      String[] cols={MediaStore.Files.FileColumns._ID,MediaStore.MediaColumns.DATE_TAKEN,
        MediaStore.MediaColumns.DATE_ADDED,MediaStore.Files.FileColumns.MEDIA_TYPE};
      String where=MediaStore.Files.FileColumns.MEDIA_TYPE+"=? OR "+MediaStore.Files.FileColumns.MEDIA_TYPE+"=?";
      String[] args={String.valueOf(MediaStore.Files.FileColumns.MEDIA_TYPE_IMAGE),String.valueOf(MediaStore.Files.FileColumns.MEDIA_TYPE_VIDEO)};
      try(Cursor c=getContentResolver().query(MediaStore.Files.getContentUri("external"),cols,where,args,MediaStore.MediaColumns.DATE_ADDED+" DESC")){
        if(c!=null)while(c.moveToNext()){
          long id=c.getLong(0),t=c.getLong(1),added=c.getLong(2);
          if(t<1000000L)t=added*1000L;int ty=c.getInt(3);
          if(id>0&&fresh.size()<35000)fresh.add(new Item(id,t,ty==MediaStore.Files.FileColumns.MEDIA_TYPE_VIDEO,date(t)));
        }
      }catch(Exception e){android.util.Log.w("MOA_R651","MEDIA_QUERY_FAILED:"+e.getClass().getSimpleName());
        ui.post(()->Toast.makeText(this,"사진·영상 접근 권한을 확인해 주세요",Toast.LENGTH_LONG).show());
      }
      ui.post(()->{if(isFinishing()||isDestroyed())return;all.clear();all.addAll(fresh);refresh();});
    });
  }
  private void refresh(){
    visible.clear();for(Item item:all)if(allPeriod||item.day.equals(day))visible.add(item);
    subtitle.setText(allPeriod?"전체 기간 · "+visible.size()+"개":day+" · "+visible.size()+"개");
    changeCount();adapter.notifyDataSetChanged();
  }
  private void changeCount(){status.setText("선택 "+chosen.size()+"개");save.setEnabled(!chosen.isEmpty());}
  private void toggle(String id){if(chosen.contains(id))chosen.remove(id);else chosen.add(id);changeCount();adapter.notifyDataSetChanged();}
  private Bitmap bitmap(Uri uri,int px){
    String key=uri.toString()+"@"+px;Bitmap cached=cache.get(key);if(cached!=null&&!cached.isRecycled())return cached;
    Bitmap result=null;
    try{result=getContentResolver().loadThumbnail(uri,new Size(px,px),null);}catch(Throwable ignored){}
    if(result==null){try(InputStream in=getContentResolver().openInputStream(uri)){
      if(in!=null){BitmapFactory.Options o=new BitmapFactory.Options();o.inJustDecodeBounds=true;
        byte[] raw=readBounded(in,28*1024*1024);BitmapFactory.decodeByteArray(raw,0,raw.length,o);
        o.inJustDecodeBounds=false;o.inSampleSize=1;
        while(o.outWidth/o.inSampleSize>px*2||o.outHeight/o.inSampleSize>px*2)o.inSampleSize*=2;
        result=BitmapFactory.decodeByteArray(raw,0,raw.length,o);
      }}catch(Throwable ignored){}
    }
    if(result!=null)cache.put(key,result);return result;
  }
  private static byte[] readBounded(InputStream stream,int cap)throws java.io.IOException{
    java.io.ByteArrayOutputStream out=new java.io.ByteArrayOutputStream();byte[] buf=new byte[32768];int count;
    while((count=stream.read(buf))!=-1){if(out.size()+count>cap)throw new java.io.IOException("PHOTO_TOO_LARGE_FOR_FALLBACK");out.write(buf,0,count);}return out.toByteArray();
  }
  private void loadImage(ImageView image,Item item,int size){
    String key=item.id+"/"+size;image.setTag(key);Bitmap cached=cache.get(item.uri+"@"+size);
    if(cached!=null){image.setImageBitmap(cached);return;}
    image.setImageDrawable(null);
    images.execute(()->{Bitmap decoded=bitmap(item.uri,size);ui.post(()->{if(key.equals(image.getTag())&&!isDestroyed()){
      if(decoded!=null)image.setImageBitmap(decoded);else image.setBackgroundColor(Color.rgb(51,54,63));
    }});});
  }
  private final class PickerAdapter extends BaseAdapter {
    @Override public int getCount(){return visible.size();}
    @Override public Object getItem(int p){return visible.get(p);}
    @Override public long getItemId(int p){return visible.get(p).numeric;}
    @Override public View getView(int position,View recycled,ViewGroup parent){
      final Item item=visible.get(position);
      FrameLayout tile=new FrameLayout(MoaR651PhotoPickerActivity.this);
      int width=(getResources().getDisplayMetrics().widthPixels-dp(14))/3;
      GridView.LayoutParams lp=new GridView.LayoutParams(width,width);tile.setLayoutParams(lp);tile.setBackgroundColor(Color.rgb(44,45,50));
      ImageView image=new ImageView(MoaR651PhotoPickerActivity.this);image.setScaleType(ImageView.ScaleType.CENTER_CROP);
      tile.addView(image,new FrameLayout.LayoutParams(-1,-1));loadImage(image,item,Math.max(220,width));
      int seq=0;for(String id:chosen){seq++;if(id.equals(item.id))break;}
      boolean selected=chosen.contains(item.id);
      TextView bubble=label(selected?String.valueOf(seq):"○",14,Color.WHITE);bubble.setGravity(Gravity.CENTER);
      bubble.setBackground(bg(selected?Color.rgb(211,68,105):0x99000000,Color.WHITE,25));
      FrameLayout.LayoutParams badge=new FrameLayout.LayoutParams(dp(28),dp(28),Gravity.TOP|Gravity.RIGHT);badge.setMargins(0,dp(6),dp(6),0);tile.addView(bubble,badge);
      TextView zoom=label("⌕",21,Color.WHITE);zoom.setGravity(Gravity.CENTER);zoom.setBackground(bg(0xAA121212,0,9));
      FrameLayout.LayoutParams zlp=new FrameLayout.LayoutParams(dp(29),dp(29),Gravity.LEFT|Gravity.BOTTOM);zlp.setMargins(dp(5),0,0,dp(5));tile.addView(zoom,zlp);
      zoom.setOnClickListener(v->preview(position));
      if(item.video){TextView play=label("▶",16,Color.WHITE);play.setGravity(Gravity.CENTER);
        tile.addView(play,new FrameLayout.LayoutParams(dp(26),dp(26),Gravity.CENTER));}
      boolean first=position==0||!visible.get(position-1).day.equals(item.day);
      if(allPeriod&&first){TextView date=label(item.day,10,Color.WHITE);date.setPadding(dp(3),0,dp(3),0);date.setBackgroundColor(0x99000000);
        tile.addView(date,new FrameLayout.LayoutParams(-2,dp(20),Gravity.TOP|Gravity.LEFT));}
      return tile;
    }
  }
  private void preview(int at){if(at<0||at>=visible.size())return;current=at;
    preview=new Dialog(this,android.R.style.Theme_Black_NoTitleBar_Fullscreen);
    LinearLayout screen=new LinearLayout(this);screen.setOrientation(LinearLayout.VERTICAL);screen.setBackgroundColor(Color.BLACK);
    LinearLayout header=new LinearLayout(this);header.setGravity(Gravity.CENTER_VERTICAL);
    Button back=button("‹");back.setOnClickListener(v->preview.dismiss());header.addView(back,row(45,47));
    previewTitle=label("",14,Color.WHITE);header.addView(previewTitle,new LinearLayout.LayoutParams(0,dp(47),1));
    Button select=button("선택");select.setOnClickListener(v->{toggle(visible.get(current).id);refreshPreviewHeader();});header.addView(select,row(72,47));
    screen.addView(header,row(-1,52));
    FrameLayout media=new FrameLayout(this);large=new ImageView(this);large.setScaleType(ImageView.ScaleType.FIT_CENTER);
    media.addView(large,new FrameLayout.LayoutParams(-1,-1));
    movie=new VideoView(this);movie.setVisibility(View.GONE);media.addView(movie,new FrameLayout.LayoutParams(-1,-1));
    media.setOnTouchListener((v,event)->{if(event.getActionMasked()==MotionEvent.ACTION_DOWN){touchX=event.getX();touchY=event.getY();gestureAt=System.currentTimeMillis();return true;}
      if(event.getActionMasked()==MotionEvent.ACTION_UP){float dx=event.getX()-touchX,dy=event.getY()-touchY;long dt=Math.max(1,System.currentTimeMillis()-gestureAt);
        if(Math.abs(dx)>dp(38)&&Math.abs(dx)>Math.abs(dy)*1.2){int shift=fast?Math.max(1,Math.min(9,Math.round(Math.abs(dx)/dp(125)+(Math.abs(dx)/dt)*2))):1;
          setIndex(current+(dx<0?shift:-shift));return true;}}
      return true;});
    screen.addView(media,new LinearLayout.LayoutParams(-1,0,1));
    LinearLayout controls=new LinearLayout(this);controls.setGravity(Gravity.CENTER_VERTICAL);
    Button before=button("‹");before.setOnClickListener(v->setIndex(current-1));controls.addView(before,row(46,44));
    Button fastButton=button("FAST OFF");fastButton.setOnClickListener(v->{fast=!fast;fastButton.setText(fast?"FAST ON":"FAST OFF");});controls.addView(fastButton,row(96,44));
    Button railButton=button("▥");railButton.setOnClickListener(v->{railExpanded=!railExpanded;if(rail!=null)((View)rail.getParent()).setVisibility(railExpanded?View.VISIBLE:View.GONE);});controls.addView(railButton,row(48,44));
    Button after=button("›");after.setOnClickListener(v->setIndex(current+1));controls.addView(after,row(46,44));
    screen.addView(controls,row(-1,47));
    LinearLayout movieControls=new LinearLayout(this);movieControls.setGravity(Gravity.CENTER_VERTICAL);
    Button play=button("재생/일시정지");play.setOnClickListener(v->{if(movie.isPlaying())movie.pause();else movie.start();});
    movieControls.addView(play,row(110,41));
    progress=new SeekBar(this);movieControls.addView(progress,new LinearLayout.LayoutParams(0,dp(40),1));
    progress.setOnSeekBarChangeListener(new SeekBar.OnSeekBarChangeListener(){public void onProgressChanged(SeekBar b,int v,boolean from){if(from)movie.seekTo(v);}
      public void onStartTrackingTouch(SeekBar b){}public void onStopTrackingTouch(SeekBar b){}});
    Button mute=button("음소거");mute.setOnClickListener(v->{muted=!muted;if(currentPlayer!=null)currentPlayer.setVolume(muted?0:1,muted?0:1);mute.setText(muted?"소리 켜기":"음소거");});
    movieControls.addView(mute,row(86,41));screen.addView(movieControls,row(-1,45));mediaStatus=label("",12,Color.LTGRAY);screen.addView(mediaStatus,row(-1,24));
    HorizontalScrollView strip=new HorizontalScrollView(this);strip.setFillViewport(false);strip.setHorizontalScrollBarEnabled(false);
    rail=new LinearLayout(this);rail.setGravity(Gravity.CENTER_VERTICAL);strip.addView(rail);screen.addView(strip,row(-1,81));
    preview.setContentView(screen);preview.setOnDismissListener(d->{stopVideo();large.setImageDrawable(null);});
    preview.show();setIndex(current);
  }
  private void refreshPreviewHeader(){if(previewTitle==null||current>=visible.size())return;
    Item item=visible.get(current);previewTitle.setText((current+1)+" / "+visible.size()+"  ·  "+item.day+(chosen.contains(item.id)?"  ✓":""));
  }
  private void stopVideo(){if(movie!=null){try{movie.stopPlayback();}catch(Exception ignored){}movie.setVisibility(View.GONE);}currentPlayer=null;
    if(videoClock!=null)ui.removeCallbacks(videoClock);}
  private void setIndex(int desired){if(desired<0||desired>=visible.size()||preview==null||!preview.isShowing())return;
    current=desired;Item item=visible.get(current);stopVideo();refreshPreviewHeader();
    if(item.video){large.setVisibility(View.GONE);movie.setVisibility(View.VISIBLE);movie.setVideoURI(item.uri);
      movie.setOnPreparedListener(p->{currentPlayer=p;p.setVolume(muted?0:1,muted?0:1);progress.setMax(Math.max(1,p.getDuration()));movie.start();});
      movie.setOnErrorListener((mp,what,extra)->{mediaStatus.setText("이 영상은 기기 재생기에 접근할 수 없습니다");return true;});
      videoClock=new Runnable(){@Override public void run(){if(preview!=null&&preview.isShowing()&&movie!=null&&movie.getVisibility()==View.VISIBLE){
        if(!progress.isPressed())progress.setProgress(movie.getCurrentPosition());ui.postDelayed(this,250);}}};ui.post(videoClock);
      mediaStatus.setText("동영상 · 탐색 가능");
    }else{movie.setVisibility(View.GONE);large.setVisibility(View.VISIBLE);mediaStatus.setText("원본 사진을 불러오는 중…");
      loadImage(large,item,Math.max(2048,getResources().getDisplayMetrics().widthPixels*2));
      mediaStatus.setText("Android MediaStore 원본 미리보기");}
    rail.removeAllViews();int a=Math.max(0,current-50),b=Math.min(visible.size(),a+101);
    for(int i=a;i<b;i++){Item ri=visible.get(i);FrameLayout tile=new FrameLayout(this);
      LinearLayout.LayoutParams lp=row(62,68);lp.setMargins(dp(2),0,dp(2),0);rail.addView(tile,lp);
      ImageView img=new ImageView(this);img.setScaleType(ImageView.ScaleType.CENTER_CROP);
      FrameLayout.LayoutParams ilp=new FrameLayout.LayoutParams(-1,dp(59),Gravity.CENTER);tile.addView(img,ilp);loadImage(img,ri,120);
      if(i==current){tile.setBackground(bg(Color.TRANSPARENT,Color.WHITE,5));tile.setTranslationY(-dp(5));}
      final int index=i;tile.setOnClickListener(v->setIndex(index));
    }
  }
  private void save(){if(chosen.isEmpty())return;
    JSONArray ids=new JSONArray();for(String id:chosen)ids.put(id);
    try{JSONObject result=new JSONObject();result.put("type","picker_saved");result.put("day",day);
      result.put("ids",ids);result.put("token",java.util.UUID.randomUUID().toString());
      boolean ok=getSharedPreferences(PREF,0).edit().putString("result",result.toString()).commit();
      if(!ok)throw new IllegalStateException("PERSIST_FAILED");
      android.util.Log.i("MOA_R651","PHOTO_PICKER_SELECTION_COMMITTED_COUNT="+chosen.size());
      Toast.makeText(this,"일기에 추가를 처리하고 있어요",Toast.LENGTH_SHORT).show();finish();
    }catch(Exception e){Toast.makeText(this,"선택을 저장하지 못했습니다. 다시 시도해 주세요",Toast.LENGTH_LONG).show();}
  }
  @Override protected void onPause(){super.onPause();if(movie!=null)try{movie.pause();}catch(Throwable ignored){}}
  @Override protected void onDestroy(){stopVideo();images.shutdownNow();super.onDestroy();}
}