// Released DEX19 exact functional equivalence: host compares MoaIconHost, version bridge R683; no additional Java APIs.
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
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.graphics.Path;
import android.graphics.RectF;
import android.graphics.drawable.ColorDrawable;
import android.graphics.drawable.GradientDrawable;
import android.media.MediaPlayer;
import android.net.Uri;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.util.Size;
import android.util.LruCache;
import android.os.SystemClock;
import android.view.GestureDetector;
import android.view.Gravity;
import android.view.MotionEvent;
import android.view.ScaleGestureDetector;
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
import org.json.JSONArray;
import org.json.JSONObject;
import java.io.InputStream;
import java.lang.ref.WeakReference;
import java.text.DateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.LinkedHashSet;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

/** R671: PHOTO ADD-ONLY NATIVE, no references to original unifiedGallery/PHOTO owner. */
public final class MoaR667NativePickerProvider extends ContentProvider implements Application.ActivityLifecycleCallbacks {
  private static final Handler MAIN=new Handler(Looper.getMainLooper());
  private static String requestJson,resultJson;
  private static final java.util.concurrent.atomic.AtomicInteger PICKER_REQUEST=new java.util.concurrent.atomic.AtomicInteger();
  private static volatile Bitmap startupBitmap;
  private static volatile String startupId="";
  private static String requestedInitialId(String json){
    try{
      JSONObject request=new JSONObject(json);JSONArray items=request.optJSONArray("items");
      int idx=Math.max(0,Math.min(items.length()-1,request.optInt("index",0)));
      return items.optJSONObject(idx).optString("id","");
    }catch(Throwable e){return "";}
  }
  // Decode BEFORE leaving the existing photo-add grid, so the new native
  // Activity need not expose its black root during a 2300px decode.
  private static Bitmap originalQualityFirstFrame(Activity a,String id){
    try{
      if(a==null||id==null||!id.matches("v?[0-9]{1,18}"))return null;
      boolean video=id.startsWith("v");String numeric=video?id.substring(1):id;
      android.net.Uri target=android.content.ContentUris.withAppendedId(
        video?android.provider.MediaStore.Video.Media.EXTERNAL_CONTENT_URI:
          android.provider.MediaStore.Images.Media.EXTERNAL_CONTENT_URI,Long.parseLong(numeric));
      if(video)return a.getContentResolver().loadThumbnail(target,new Size(640,640),null);
      if(android.os.Build.VERSION.SDK_INT>=28){
        return android.graphics.ImageDecoder.decodeBitmap(
          android.graphics.ImageDecoder.createSource(a.getContentResolver(),target),
          (decoder,info,source)->{
            int width=Math.max(1,info.getSize().getWidth());
            int height=Math.max(1,info.getSize().getHeight());int sample=1;
            while(width/sample>2300||height/sample>2300)sample*=2;
            decoder.setTargetSampleSize(sample);
            decoder.setAllocator(android.graphics.ImageDecoder.ALLOCATOR_SOFTWARE);
          });
      }
    }catch(Throwable t){android.util.Log.w("MOA_R679_ORIGINAL","SOURCE_PRIME_"+t.getClass().getSimpleName());}
    return null;
  }
  private static final java.util.concurrent.ExecutorService PHOTO_WARMER=
    java.util.concurrent.Executors.newSingleThreadExecutor();
  // Only a bounded, advisory original-gallery image cache warm. No calls to
  // original gallery open/close/Back; no owner/lifecycle changes.
  private static void primeOriginalGallery(Activity a,String id){
    if(!host(a)||id==null||!id.matches("v?[0-9]{1,18}"))return;
    PHOTO_WARMER.execute(()->{
      try{
        boolean video=id.startsWith("v");
        String numeric=video?id.substring(1):id;
        long mediaId=Long.parseLong(numeric);
        Uri root=video?android.provider.MediaStore.Video.Media.EXTERNAL_CONTENT_URI:
          android.provider.MediaStore.Images.Media.EXTERNAL_CONTENT_URI;
        Uri uri=android.content.ContentUris.withAppendedId(root,mediaId);
        // Fast MediaStore poster only; the ORIGINAL Gallery asynchronously
        // replaces it with its full-resolution frame. Avoid duplicate full
        // ImageDecoder work on every photo-day entry (which can itself stall).
        Bitmap result=a.getContentResolver().loadThumbnail(uri,
          new android.util.Size(640,640),null);
        final Bitmap image=result;
        if(image==null)return;
        MAIN.post(()->{
          // Preload the per-instance LruCache of the EXISTING original Gallery
          // only when the actual owner already exists. Never create a competing
          // original Gallery instance, and never clear user media data.
          if(a.isFinishing()||a.isDestroyed())return;
          try{
            Object gallery=null;
            for(Class<?> c=a.getClass();c!=null;c=c.getSuperclass()){
              try{java.lang.reflect.Field f=c.getDeclaredField("unifiedGallery");
                f.setAccessible(true);gallery=f.get(a);if(gallery!=null)break;
              }catch(NoSuchFieldException ignored){}
            }
            if(gallery==null||!"com.juhyeon.familyjourney.MoaNativeGallery".equals(gallery.getClass().getName()))return;
            java.lang.reflect.Field cache=gallery.getClass().getDeclaredField("posters");
            cache.setAccessible(true);
            Object obj=cache.get(gallery);
            if(obj instanceof android.util.LruCache)
              ((android.util.LruCache)obj).put(id,image);
          }catch(Throwable ignored){}
        });
      }catch(Throwable ignored){/* all warm failures intentionally fail open */}
    });
  }

  private static WeakReference<Activity> sourceActivity=new WeakReference<>(null);
  private static WeakReference<WebView> sourceWeb=new WeakReference<>(null);
  private static WeakReference<WebView> bridgeInstalled=new WeakReference<>(null);
  private static boolean host(Activity a){return a!=null&&"com.juhyeon.familyjourney.MoaIconHost".equals(a.getClass().getName());}
  private static WebView findWeb(View v){
    if(v instanceof WebView)return(WebView)v;
    if(v instanceof ViewGroup){ViewGroup g=(ViewGroup)v;for(int i=0;i<g.getChildCount();i++){WebView w=findWeb(g.getChildAt(i));if(w!=null)return w;}}
    return null;
  }
  private static void attach(Activity a,int attempt){
    if(!host(a)||a.isFinishing()||a.isDestroyed())return;
    WebView w=findWeb(a.getWindow().getDecorView());
    if(w==null){
      // Bounded first-boot bridge setup only. Never reload WebView nor touch PHOTO native owner.
      if(attempt<48) MAIN.postDelayed(()->attach(a,attempt+1),125L);
      return;
    }
    // No repeated addJavascriptInterface or WebView reload while original native PHOTO stays live.
    if(bridgeInstalled.get()!=w){w.addJavascriptInterface(new Bridge(a,w),"MoaR667NativePicker");bridgeInstalled=new WeakReference<>(w);}
    sourceActivity=new WeakReference<>(a);sourceWeb=new WeakReference<>(w);
  }
  public static final class Bridge {
    final WeakReference<Activity> owner;final WeakReference<WebView> browser;
    Bridge(Activity a,WebView w){owner=new WeakReference<>(a);browser=new WeakReference<>(w);}
    @JavascriptInterface public String version(){
      Activity activity=owner.get();
      if(activity==null)return "";
      try{
        String pkg=activity.getPackageName();
        long code=activity.getPackageManager().getPackageInfo(pkg,0).getLongVersionCode();
        if(code<1)return "";
        return "R"+code+"-DISTINCT-NATIVE-ONE-SWIPE-CACHED-RAIL";
      }catch(android.content.pm.PackageManager.NameNotFoundException ex){return "";}
    }
    @JavascriptInterface public void primePhoto(String id){
      Activity a=owner.get();if(host(a))primeOriginalGallery(a,id);
    }
    @JavascriptInterface public boolean open(String json){
      if(json==null||json.length()>650000)return false;
      try{if(new JSONObject(json).optJSONArray("items")==null)return false;}catch(Exception e){return false;}
      Activity a=owner.get();WebView w=browser.get();if(!host(a)||w==null)return false;
      sourceActivity=new WeakReference<>(a);sourceWeb=new WeakReference<>(w);requestJson=json;resultJson=null;
      final int generation=PICKER_REQUEST.incrementAndGet();
      startupBitmap=null;startupId="";
      final String firstId=requestedInitialId(json);
      final java.util.concurrent.atomic.AtomicBoolean launched=new java.util.concurrent.atomic.AtomicBoolean();
      final Runnable launch=()->{
        if(generation!=PICKER_REQUEST.get()||!launched.compareAndSet(false,true))return;
        if(a.isFinishing()||a.isDestroyed())return;
        try{a.startActivity(new Intent(a,NativePickerActivity.class));a.overridePendingTransition(0,0);}
        catch(Exception ex){w.evaluateJavascript("window.__moaR667NativePickerError&&window.__moaR667NativePickerError('native activity error')",null);}
      };
      PHOTO_WARMER.execute(()->{
        Bitmap prime=originalQualityFirstFrame(a,firstId);
        if(generation==PICKER_REQUEST.get()&&prime!=null){
          startupId=firstId;startupBitmap=prime;
          android.util.Log.i("MOA_R679_ORIGINAL","SOURCE_PRIMED "+prime.getWidth()+"x"+prime.getHeight());
        }
        MAIN.post(launch);
      });
      MAIN.postDelayed(launch,1100L);
      return true;
    }
  }
  private static void finishWith(JSONObject result){resultJson=result.toString();}
  private static void deliver(Activity a){
    if(!host(a)||resultJson==null)return;
    WebView w=sourceWeb.get();if(w==null||w.getParent()==null)return;
    String v=resultJson;resultJson=null;
    MAIN.postDelayed(()->{if(host(a)&&!a.isFinishing()&&!a.isDestroyed()&&w.getParent()!=null)
      w.evaluateJavascript("window.__moaR667NativePickerResult&&window.__moaR667NativePickerResult("+JSONObject.quote(v)+");",null);},220);
  }
  @Override public boolean onCreate(){
    if(getContext()!=null&&getContext().getApplicationContext() instanceof Application)
      ((Application)getContext().getApplicationContext()).registerActivityLifecycleCallbacks(this);
    return true;
  }
  @Override public void onActivityCreated(Activity a,Bundle b){if(host(a))MAIN.post(()->attach(a,0));}
  @Override public void onActivityStarted(Activity a){if(host(a))MAIN.post(()->attach(a,0));}
  @Override public void onActivityResumed(Activity a){if(host(a)){MAIN.post(()->attach(a,0));MAIN.postDelayed(()->deliver(a),250);}}
  @Override public void onActivityPaused(Activity a){}
  @Override public void onActivityStopped(Activity a){}
  @Override public void onActivitySaveInstanceState(Activity a,Bundle b){}
  @Override public void onActivityDestroyed(Activity a){if(sourceActivity.get()==a){sourceActivity=new WeakReference<>(null);bridgeInstalled=new WeakReference<>(null);}}
  @Override public Cursor query(Uri u,String[] p,String s,String[] arg,String order){return null;}
  @Override public String getType(Uri u){return null;}
  @Override public Uri insert(Uri u,ContentValues v){return null;}
  @Override public int delete(Uri u,String w,String[] a){return 0;}
  @Override public int update(Uri u,ContentValues v,String w,String[] a){return 0;}

  /** R675: the ORIGINAL compiled MoaNativeGallery (classes6.dex), not a clone.
   *  R463 action deck is an exact copy of the source from user Golden R463,
   *  isolated to THIS Activity and not added to HostActivity. */
  public static final class NativePickerActivity extends Activity {
    private Object unifiedGallery; // the R463 deck's exact reflected owner contract
    private java.lang.reflect.Method nativeClose, nativeIsOpen;
    private java.lang.reflect.Field nativeIndex;
    private final Handler ui=new Handler(Looper.getMainLooper());
    private final java.util.ArrayList<String> ids=new java.util.ArrayList<>();
    private final java.util.LinkedHashSet<String> chosen=new java.util.LinkedHashSet<>();
    private boolean done=false, opened=false, nativeOpenInitiated=false;
    private int fallbackIndex=0;
    private android.widget.FrameLayout selectTouch;
    private SelectGlyph selectGlyph;
    private String coverId="",bookmarkId="",legacyDetails="";
    private String reason="NOT_STARTED";
    private final Runnable monitor=new Runnable(){@Override public void run(){
      if(done||isFinishing()||isDestroyed())return;
      try{
        if(nativeIsOpen!=null&&unifiedGallery!=null){
          if(!Boolean.TRUE.equals(nativeIsOpen.invoke(unifiedGallery))){
            if(opened){finishWithSelection();return;}
          }else{
            opened=true;
            // EXACT original R463 provider code; updates existing action deck
            // only in this isolated photo ADD Activity, not the live PHOTO host.
            // Original R463 bar computes its width from Gallery.host.getWidth();
            // don't freeze it at the wrong 120dp during a zero-width prelayout.
            Object stage=field(unifiedGallery,"host");
            if(stage instanceof FrameLayout && ((FrameLayout)stage).isAttachedToWindow()
              && ((FrameLayout)stage).getWidth()>=dp(240)){
              MoaR675PickerGalleryDeck.attachPicker(NativePickerActivity.this);
              ensureSelectAction();
            }
            if(selectGlyph!=null)selectGlyph.invalidate();
          }
        }
      }catch(Throwable e){android.util.Log.w("MOA_R675_EXACT_PICKER", "MONITOR_"+e.getClass().getSimpleName());}
      ui.postDelayed(this,190L);
    }};
    private int dp(float v){return Math.round(getResources().getDisplayMetrics().density*v);}
    // Cache on the exact ORIGINAL LruCache of the existing class6 gallery.
    private void originalOpenWithPrimedFrame(java.lang.reflect.Method open,String packed,String day){
      if(nativeOpenInitiated||done)return;
      nativeOpenInitiated=true;
      try{
        Bitmap ready=startupBitmap;String id=startupId;
        if(ready!=null&&id!=null&&id.equals(ids.get(fallbackIndex))){
          java.lang.reflect.Field cache=unifiedGallery.getClass().getDeclaredField(
            id.startsWith("v")?"posters":"full");cache.setAccessible(true);
          Object target=cache.get(unifiedGallery);
          if(target instanceof android.util.LruCache){
            ((android.util.LruCache)target).put(id,ready);
            android.util.Log.i("MOA_R679_ORIGINAL","INJECT_ORIGINAL_CACHE "+ready.getWidth()+"x"+ready.getHeight());
          }
        }else{android.util.Log.w("MOA_R679_ORIGINAL","SOURCE_NOT_READY_OPEN_ORIGINAL");}
        startupBitmap=null;startupId="";
        if(!Boolean.TRUE.equals(open.invoke(unifiedGallery,packed,fallbackIndex,day))){
          reason="ORIGINAL_GALLERY_OPEN_FALSE";
          Toast.makeText(this,"원본 갤러리가 사진을 열지 못했습니다",Toast.LENGTH_LONG).show();
          finishWithSelection();return;
        }
        opened=true;reason="ORIGINAL_CLASS6_GALLERY_OPEN_TRUE";
        ui.postDelayed(monitor,85L);
      }catch(Throwable e){
        reason="ORIGINAL_GALLERY_OPEN_EXCEPTION_"+e.getClass().getSimpleName();
        android.util.Log.e("MOA_R679_ORIGINAL",reason,e);
        finishWithSelection();
      }
    }
    private boolean validId(String s){return s!=null&&s.matches("v?[0-9]{1,18}");}
    private String currentId(){
      int idx=fallbackIndex;
      try{if(nativeIndex!=null&&unifiedGallery!=null)idx=nativeIndex.getInt(unifiedGallery);}catch(Throwable ignored){}
      return ids.isEmpty()?null:ids.get(Math.max(0,Math.min(idx,ids.size()-1)));
    }
    private static Object field(Object holder,String name)throws Exception {
      java.lang.reflect.Field f=holder.getClass().getDeclaredField(name);
      f.setAccessible(true);return f.get(holder);
    }
    @Override public void onCreate(Bundle saved){
      super.onCreate(saved);
      // R679: preserve full black native window across Activity transition; never
      // reveal clock/Wi-Fi/battery on entry, as actually recorded at 03:40.
      // Do not alter global app system-bar policy or original Gallery owner.
      getWindow().addFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN);
      getWindow().setStatusBarColor(android.graphics.Color.BLACK);
      getWindow().setNavigationBarColor(android.graphics.Color.BLACK);
      getWindow().getDecorView().setSystemUiVisibility(
        View.SYSTEM_UI_FLAG_FULLSCREEN | View.SYSTEM_UI_FLAG_HIDE_NAVIGATION |
        View.SYSTEM_UI_FLAG_IMMERSIVE_STICKY | View.SYSTEM_UI_FLAG_LAYOUT_STABLE |
        View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN | View.SYSTEM_UI_FLAG_LAYOUT_HIDE_NAVIGATION);
      android.widget.FrameLayout root=new android.widget.FrameLayout(this);
      root.setBackgroundColor(android.graphics.Color.BLACK);
      setContentView(root);
      try{
        JSONObject req=new JSONObject(requestJson==null?"{}":requestJson);
        JSONArray src=req.optJSONArray("items");
        if(src!=null)for(int i=0;i<src.length()&&i<10000;i++){
          JSONObject obj=src.optJSONObject(i);if(obj==null)continue;
          String id=obj.optString("id","");if(validId(id))ids.add(id);
        }
        JSONArray selected=req.optJSONArray("selected");
        if(selected!=null)for(int i=0;i<selected.length();i++){
          String s=selected.optString(i,"");if(validId(s))chosen.add(s);
        }
        fallbackIndex=Math.max(0,Math.min(ids.size()-1,req.optInt("index",0)));
      }catch(Exception err){reason="REQUEST_BAD_JSON";}
      if(ids.isEmpty()){
        android.widget.Toast.makeText(this,"사진 목록이 없습니다",android.widget.Toast.LENGTH_SHORT).show();
        finishWithSelection();return;
      }
      final JSONArray packed=new JSONArray();for(String id:ids)packed.put(id);
      // Original class6.dex is loaded by the existing APK ClassLoader.
      // Do NOT compile, rename, or replace that original Gallery engine.
      try{
        Class<?> type=Class.forName("com.juhyeon.familyjourney.MoaNativeGallery");
        java.lang.reflect.Constructor<?> ctor=type.getConstructor(Activity.class,java.util.function.Consumer.class);
        java.util.function.Consumer<String> legacy=(s)->{legacyDetails=s;ui.post(this::finishWithSelection);};
        unifiedGallery=ctor.newInstance(this,legacy);
        nativeClose=type.getMethod("close");
        nativeIsOpen=type.getMethod("isOpen");
        nativeIndex=type.getDeclaredField("index");nativeIndex.setAccessible(true);
        java.lang.reflect.Method open=type.getMethod("open",String.class,int.class,String.class);
        String day=reqDate();
        originalOpenWithPrimedFrame(open,packed.toString(),day);
      }catch(Throwable e){
        reason="ORIGINAL_GALLERY_REFLECTION_"+e.getClass().getSimpleName();
        android.util.Log.e("MOA_R675_EXACT_PICKER",reason,e);
        android.widget.Toast.makeText(this,"원본 갤러리 시작 실패",android.widget.Toast.LENGTH_SHORT).show();
        finishWithSelection();
      }
    }
    private String reqDate(){
      try{JSONObject req=new JSONObject(requestJson==null?"{}":requestJson);
        String raw=req.optString("day","");
        if(raw.matches("[0-9]{4}-[0-9]{2}-[0-9]{2}"))return raw;
      }catch(Exception ignored){}
      return new java.text.SimpleDateFormat("yyyy-MM-dd",java.util.Locale.KOREA).format(new java.util.Date());
    }
    private void ensureSelectAction()throws Exception {
      if(unifiedGallery==null)return;
      Object obj=field(unifiedGallery,"host");
      if(!(obj instanceof android.widget.FrameLayout))return;
      android.widget.FrameLayout host=(android.widget.FrameLayout)obj;
      android.widget.FrameLayout overlay=null;
      for(int i=0;i<host.getChildCount();i++){
        View child=host.getChildAt(i);
        if("moa.gallery.action.deck.r443".equals(child.getTag())&&child instanceof android.widget.FrameLayout){overlay=(android.widget.FrameLayout)child;break;}
      }
      if(overlay==null||overlay.getChildCount()==0||!(overlay.getChildAt(0)instanceof LinearLayout))return;
      LinearLayout capsule=(LinearLayout)overlay.getChildAt(0);
      if(selectTouch!=null&&selectTouch.getParent()==capsule)return;
      FrameLayout add=new FrameLayout(this);
      add.setContentDescription("현재 사진·영상 선택 또는 해제");
      add.setClickable(true);add.setFocusable(true);
      android.graphics.drawable.GradientDrawable mask=new android.graphics.drawable.GradientDrawable();
      mask.setColor(android.graphics.Color.WHITE);mask.setCornerRadius(dp(18));
      add.setBackground(new android.graphics.drawable.RippleDrawable(
        android.content.res.ColorStateList.valueOf(0x44ffffff),null,mask));
      SelectGlyph mark=new SelectGlyph(this);
      FrameLayout.LayoutParams glyphParams=new FrameLayout.LayoutParams(dp(21),dp(21),Gravity.CENTER);
      add.addView(mark,glyphParams);
      add.setOnClickListener(v->{
        String id=currentId();if(id==null)return;
        if(!chosen.remove(id))chosen.add(id);
        if(selectGlyph!=null)selectGlyph.invalidate();
        add.setContentDescription(chosen.contains(id)?"현재 사진 선택됨, 선택 해제":"현재 사진 선택");
        android.widget.Toast.makeText(this,"선택 "+chosen.size()+"개",android.widget.Toast.LENGTH_SHORT).show();
      });
      // Existing native controls from exact R463 deck remain the SAME objects.
      // Extend only its own capsule: 4 originals + the user-requested ADD icon.
      capsule.addView(add,new LinearLayout.LayoutParams(0,dp(42),1f));
      android.widget.FrameLayout.LayoutParams lp=(android.widget.FrameLayout.LayoutParams)capsule.getLayoutParams();
      int width=Math.min(Math.max(dp(120),host.getWidth()-dp(30)),dp(20+5*65));
      lp.width=width;capsule.setLayoutParams(lp);
      selectTouch=add;selectGlyph=mark;
    }
    private final class SelectGlyph extends View{
      final Paint paint=new Paint(Paint.ANTI_ALIAS_FLAG);
      SelectGlyph(Activity a){super(a);setWillNotDraw(false);}
      @Override protected void onDraw(Canvas c){super.onDraw(c);
        int cx=getWidth()/2,cy=getHeight()/2;String id=currentId();
        boolean on=id!=null&&chosen.contains(id);
        paint.setColor(android.graphics.Color.WHITE);paint.setStrokeWidth(dp(1.7f));
        paint.setStrokeCap(Paint.Cap.ROUND);paint.setStyle(Paint.Style.STROKE);
        float r=dp(9);
        c.drawRoundRect(cx-r,cy-r,cx+r,cy+r,dp(2),dp(2),paint);
        if(on){paint.setStyle(Paint.Style.FILL);paint.setColor(0xffcc86ac);
          c.drawRoundRect(cx-r+dp(2),cy-r+dp(2),cx+r-dp(2),cy+r-dp(2),dp(1),dp(1),paint);
          paint.setColor(android.graphics.Color.WHITE);paint.setStrokeWidth(dp(1.6f));
          c.drawLine(cx-dp(4),cy,cx-dp(1),cy+dp(3),paint);
          c.drawLine(cx-dp(1),cy+dp(3),cx+dp(5),cy-dp(4),paint);
        }else{
          c.drawLine(cx-dp(5),cy,cx+dp(5),cy,paint);
          c.drawLine(cx,cy-dp(5),cx,cy+dp(5),paint);
        }
      }
    }
    private void finishWithSelection(){
      if(done)return;done=true;ui.removeCallbacks(monitor);
      try{
        JSONObject result=new JSONObject();JSONArray list=new JSONArray();
        for(String s:chosen)list.put(s);
        result.put("selected",list);
        int idx=fallbackIndex;
        try{if(nativeIndex!=null&&unifiedGallery!=null)idx=nativeIndex.getInt(unifiedGallery);}catch(Throwable ignored){}
        result.put("index",idx);result.put("coverId",coverId);result.put("bookmarkId",bookmarkId);result.put("legacyDetails",legacyDetails);
        finishWith(result);
      }catch(Exception ignored){}
      try{MoaR675PickerGalleryDeck.detachPicker(this);}catch(Throwable ignored){}
      try{if(unifiedGallery!=null&&nativeClose!=null)nativeClose.invoke(unifiedGallery);}catch(Throwable ignored){}
      finish();overridePendingTransition(0,0);
    }
    @Override public void onBackPressed(){finishWithSelection();}
    @Override protected void onDestroy(){
      if(!done)finishWithSelection();
      ui.removeCallbacks(monitor);
      super.onDestroy();
    }
  }
}
