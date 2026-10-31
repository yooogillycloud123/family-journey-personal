package com.juhyeon.familyjourney;

import android.Manifest;
import android.app.Activity;
import android.app.AlertDialog;
import android.content.ContentUris;
import android.content.ContentValues;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.pm.PackageManager;
import android.database.Cursor;
import android.graphics.Bitmap;
import android.media.ExifInterface;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.os.Environment;
import android.os.Handler;
import android.os.Looper;
import android.provider.MediaStore;
import android.provider.Settings;
import android.util.Base64;
import android.util.Log;
import android.util.Size;
import android.webkit.JavascriptInterface;
import android.webkit.WebResourceRequest;
import android.webkit.WebResourceResponse;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.Toast;

import org.json.JSONArray;
import org.json.JSONObject;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.FileInputStream;
import java.io.InputStream;
import java.io.OutputStream;
import java.nio.charset.StandardCharsets;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;
import java.util.TimeZone;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.List;
import java.util.ArrayList;
import java.util.Map;
import java.util.HashMap;
import java.util.concurrent.atomic.AtomicBoolean;

public final class HostActivity extends Activity {
  private static final String HOST="familyjourney.local";
  private static final int REQ=2502;
  private final Handler ui=new Handler(Looper.getMainLooper());
  private final ExecutorService bg=Executors.newSingleThreadExecutor();
  private final AtomicBoolean loading=new AtomicBoolean(false);
  private final Map<String,Uri> mediaUris=new HashMap<>();
  private WebView web;
  private File videoTemp;
  private OutputStream videoStream;
  private int rejected=0;
  private volatile String currentFingerprint="";
  private volatile boolean forcePhotoRescan=false;
  private static final String PHOTO_CACHE="fj-private-exif-meta-v1.json";
  private static final String CACHE_PREF="fj-private-exif-cache";
  private void dispatchPhotos(String serialized) {
    js("window.__nativePhotosBegin&&window.__nativePhotosBegin()");
    for(int offset=0;offset<serialized.length();offset+=16000) {
      String piece=serialized.substring(offset,Math.min(serialized.length(),offset+16000));
      jsInvoke("__nativePhotosChunk",quote(piece));
    }
    js("window.__nativePhotosEnd&&window.__nativePhotosEnd()");
  }
  private String privatePhotoCache() {
    try {
      java.io.File file=new java.io.File(getFilesDir(),PHOTO_CACHE);
      if(!file.isFile()||file.length()>15_000_000)return null;
      byte[] bytes=java.nio.file.Files.readAllBytes(file.toPath());
      return new String(bytes,java.nio.charset.StandardCharsets.UTF_8);
    }catch(Exception ignored){return null;}
  }
  private void savePrivatePhotoCache(String serialized,String fingerprint) {
    try {
      java.io.File tmp=new java.io.File(getFilesDir(),PHOTO_CACHE+".pending");
      java.io.File dest=new java.io.File(getFilesDir(),PHOTO_CACHE);
      java.nio.file.Files.write(tmp.toPath(),serialized.getBytes(java.nio.charset.StandardCharsets.UTF_8));
      java.nio.file.Files.move(tmp.toPath(),dest.toPath(),
         java.nio.file.StandardCopyOption.REPLACE_EXISTING);
      getSharedPreferences(CACHE_PREF,MODE_PRIVATE).edit().putString("fingerprint",fingerprint).apply();
    }catch(Exception e){Log.w("FamilyJourney","unable to cache EXIF metadata",e);}
  }
  private final AtomicBoolean readyReceived=new AtomicBoolean(false);
  private volatile String phase="HTML 로딩 대기";
  private volatile String lastWebError="";
  private volatile boolean mapBooted=false;
  private void statusNative(String text) { phase=text; Log.i("FamilyJourney",text); }
  private void diagnostics(String source){
    ui.post(()->{
      if(isFinishing()||web==null)return;
      web.evaluateJavascript("(function(){return {boot:!!window.__photoMap,ready:!!window.__nativeFingerprint,photos:!!window.__nativePhotosEnd};})()",reply->{
        String data=reply==null?"":reply;
        boolean hasBoot=false,hasBridge=false;
        try{
          JSONObject state=new JSONObject(data);
          hasBoot=state.optBoolean("boot",false);
          hasBridge=state.optBoolean("ready",false)||state.optBoolean("photos",false);
        }catch(Exception ignored){}
        if(hasBoot){mapBooted=true;return;}
        if(!readyReceived.get()&&hasBridge){
          readyReceived.set(true);
          grantOrScan();
          return;
        }
        if(!readyReceived.get()||phase.startsWith("권한")){
          new AlertDialog.Builder(HostActivity.this)
           .setTitle("사진첩 자동 분석을 시작하지 못했습니다")
           .setMessage("진행 단계: "+phase+"\\n웹 상태: "+data+"\\n"+
             (lastWebError.isEmpty()?"":"오류: "+lastWebError))
           .setPositiveButton("사진첩 다시 분석",(d,w)->{readyReceived.set(true);grantOrScan();})
           .setNeutralButton("앱 권한 확인",(d,w)->handle("openSettings",new JSONObject()))
           .setNegativeButton("닫기",null).show();
        }else{statusNative("진행 확인: "+phase);}
      });
    });
  }

  private void js(String code){ui.post(()->{if(web!=null)web.evaluateJavascript(code,null);});}
  private void jsInvoke(String name,String payload){js("window."+name+"&&window."+name+"("+payload+");");}
  private static String quote(String value){return JSONObject.quote(value);}
  @Override public void onCreate(Bundle state){
    super.onCreate(state);
    web=new WebView(this);
    WebSettings s=web.getSettings();
    s.setJavaScriptEnabled(true);s.setDomStorageEnabled(true);
    s.setAllowFileAccess(false);s.setAllowContentAccess(false);
    s.setMixedContentMode(WebSettings.MIXED_CONTENT_NEVER_ALLOW);
    web.addJavascriptInterface(new NativeInterface(),"NativeHost");
    web.setWebChromeClient(new android.webkit.WebChromeClient(){
      @Override public boolean onConsoleMessage(android.webkit.ConsoleMessage m){
        if(m.messageLevel()==android.webkit.ConsoleMessage.MessageLevel.ERROR){
          lastWebError=m.message()+" @"+m.sourceId()+":"+m.lineNumber();
          Log.e("FamilyJourneyWeb",lastWebError);
        }
        return true;
      }
    });
    web.setWebViewClient(new WebViewClient(){
      @Override public WebResourceResponse shouldInterceptRequest(WebView view,WebResourceRequest req){
        Uri uri=req.getUrl();
        // All WebView document/fetch/image requests are checked here; do not leak family travel telemetry
        // to the commercial publisher or any other unapproved endpoint.
        if(!NetworkPolicy.permitted(uri)){
          Log.w("FamilyJourneyPrivacy","Blocked network host: "+(uri.getHost()==null?"unknown":uri.getHost()));
          return NetworkPolicy.denied();
        }
        if(!HOST.equals(uri.getHost()))return super.shouldInterceptRequest(view,req);
        String path=uri.getPath();
        // Never launch an external viewer for a family's private gallery.
        // Serve a single permission-checked, resized image to our own local WebView.
        if(path!=null && path.startsWith("/fj-photo/")){
          String mediaId=path.substring("/fj-photo/".length()).replace(".jpg","");
          if(!mediaId.matches("[0-9]{1,18}"))
            return new WebResourceResponse("text/plain","UTF-8",
                new java.io.ByteArrayInputStream(new byte[0]));
          android.net.Uri imageUri=ContentUris.withAppendedId(
              MediaStore.Images.Media.EXTERNAL_CONTENT_URI,Long.parseLong(mediaId));
          try{
            android.graphics.ImageDecoder.Source photoSource=
                android.graphics.ImageDecoder.createSource(getContentResolver(),imageUri);
            Bitmap bitmap=android.graphics.ImageDecoder.decodeBitmap(photoSource,(decoder,info,source)->{
              android.util.Size bounds=info.getSize();
              double scale=Math.min(1.0,2300.0/Math.max(bounds.getWidth(),bounds.getHeight()));
              decoder.setTargetSize(Math.max(1,(int)(bounds.getWidth()*scale)),
                                    Math.max(1,(int)(bounds.getHeight()*scale)));
              decoder.setAllocator(android.graphics.ImageDecoder.ALLOCATOR_SOFTWARE);
            });
            ByteArrayOutputStream bytes=new ByteArrayOutputStream();
            bitmap.compress(Bitmap.CompressFormat.JPEG,86,bytes);
            bitmap.recycle();
            return new WebResourceResponse("image/jpeg",null,
                new java.io.ByteArrayInputStream(bytes.toByteArray()));
          }catch(Exception imageError){
            Log.w("FamilyJourney","private photo viewer image decode failed",imageError);
            return new WebResourceResponse("text/plain","UTF-8",
                new java.io.ByteArrayInputStream(new byte[0]));
          }
        }
        if(path==null||path.equals("/"))path="/web/index.html";
        if(path.startsWith("/"))path=path.substring(1);
        if(path.contains("..")||path.contains("\\"))return new WebResourceResponse("text/plain","utf-8",new java.io.ByteArrayInputStream(new byte[0]));
        try{
          String mime=path.endsWith(".js")?"application/javascript":path.endsWith(".css")?"text/css":path.endsWith(".html")?"text/html":path.endsWith(".json")?"application/json":path.endsWith(".svg")?"image/svg+xml":path.endsWith(".png")?"image/png":"application/octet-stream";
          return new WebResourceResponse(mime,"utf-8",getAssets().open(path));
        }catch(Exception e){Log.e("FamilyJourney","ASSET "+path,e);return new WebResourceResponse("text/plain","utf-8",new java.io.ByteArrayInputStream(new byte[0]));}
      }
      @Override public void onPageStarted(WebView view,String url,android.graphics.Bitmap favicon){
        // The photo reindex flow can legitimately reload the same local page.
        // The one-shot readiness latch must be rearmed per navigation, or
        // subsequent reloads stay blank without native photo handshake.
        readyReceived.set(false);
        mapBooted=false;
        super.onPageStarted(view,url,favicon);
      }
      @Override public void onPageFinished(WebView view,String url){
        super.onPageFinished(view,url);
        statusNative("HTML 완료");
        ui.postDelayed(()->{if(!mapBooted)diagnostics("page-finished");},12000);
      }
      @Override public boolean shouldOverrideUrlLoading(WebView v,WebResourceRequest r){
        Uri uri=r.getUrl();
        if(HOST.equals(uri.getHost()))return false;
        if(!NetworkPolicy.permitted(uri)){message("개인정보 보호 정책에 따라 외부 링크를 차단했습니다.");return true;}
        try{startActivity(new Intent(Intent.ACTION_VIEW,uri));}catch(Exception ignored){}
        return true;
      }
    });
    setContentView(web);
    web.loadUrl("https://"+HOST+"/web/index.html");
    // Source-proven original bridge handoff: the static "시작하기" CTA remains
    // until __nativeFingerprint -> __nativePhotos -> geocode -> __bootPhotoMap.
    // Do not depend exclusively on JS 'ready': WebView may lose that IPC.
    ui.postDelayed(()->{
      if(!readyReceived.get() && web!=null){
        web.evaluateJavascript("typeof window.__nativeFingerprint === 'function'",value->{
          if("true".equals(value)&&readyReceived.compareAndSet(false,true)){
            statusNative("웹 ready 신호 누락 → 사진첩 자동 시작");
            grantOrScan();
          }
        });
      }
    },3000);
    ui.postDelayed(()->{
      if(!mapBooted && web!=null){
        statusNative("앱 지도 부팅 미완료; 실제 단계 확인");
        diagnostics("native-18s-watchdog");
      }
    },18000);
  }
  private boolean permitted(){
    if(Build.VERSION.SDK_INT>=33)return checkSelfPermission(Manifest.permission.READ_MEDIA_IMAGES)==PackageManager.PERMISSION_GRANTED;
    return checkSelfPermission(Manifest.permission.READ_EXTERNAL_STORAGE)==PackageManager.PERMISSION_GRANTED;
  }
  private void grantOrScan(){
    statusNative("권한 확인");
    if(permitted()){statusNative("사진첩 지문 확인");fingerprint();return;}
    ArrayList<String> permissions=new ArrayList<>();
    if(Build.VERSION.SDK_INT>=33)permissions.add(Manifest.permission.READ_MEDIA_IMAGES);
    else permissions.add(Manifest.permission.READ_EXTERNAL_STORAGE);
    if(Build.VERSION.SDK_INT>=34)permissions.add("android.permission.READ_MEDIA_VISUAL_USER_SELECTED");
    if(Build.VERSION.SDK_INT>=29)permissions.add(Manifest.permission.ACCESS_MEDIA_LOCATION);
    statusNative("권한 요청");
    requestPermissions(permissions.toArray(new String[0]),REQ);
  }
  @Override public void onRequestPermissionsResult(int rc,String[] permissions,int[] results){
    super.onRequestPermissionsResult(rc,permissions,results);
    if(rc==REQ&&permitted()){statusNative("사진 접근 승인");fingerprint();}
    else if(rc==REQ){
      statusNative("권한 부족: 모든 사진 접근 필요");
      diagnostics("permission-denied");
    }
  }
  private void message(String text){ui.post(()->Toast.makeText(this,text,Toast.LENGTH_LONG).show());}
  private static long photoTime(ExifInterface exif,long fallback){
    try{
      String date=exif.getAttribute(ExifInterface.TAG_DATETIME_ORIGINAL);
      if(date==null||date.length()<19) date=exif.getAttribute(ExifInterface.TAG_DATETIME);
      if(date==null||date.length()<19)return fallback;
      SimpleDateFormat f=new SimpleDateFormat("yyyy:MM:dd HH:mm:ss",Locale.US);
      f.setLenient(false);
      String offset=exif.getAttribute("OffsetTimeOriginal");
      if(offset!=null && offset.matches("[+-][0-9]{2}:[0-9]{2}"))
        f.setTimeZone(TimeZone.getTimeZone("GMT"+offset));
      Date d=f.parse(date.substring(0,19));
      return d==null?fallback:d.getTime()/1000L;
    }catch(Exception e){return fallback;}
  }
  private void fingerprint(){
    statusNative("사진첩 상태 확인 중");
    bg.execute(()->{
      try{
        Cursor cursor=getContentResolver().query(
          MediaStore.Images.Media.EXTERNAL_CONTENT_URI,
          new String[]{MediaStore.Images.Media._ID,MediaStore.Images.Media.DATE_MODIFIED},
          null,null,MediaStore.Images.Media.DATE_MODIFIED+" DESC");
        int count=0;long mostRecent=0;
        if(cursor!=null){try{count=cursor.getCount();if(cursor.moveToFirst())mostRecent=cursor.getLong(1);}finally{cursor.close();}}
        currentFingerprint=count+"|"+mostRecent;
        statusNative("사진첩 지문 "+count+"장");
        jsInvoke("__nativeFingerprint",quote(currentFingerprint));
      }catch(Exception e){Log.e("FamilyJourney","fingerprint",e);message("사진첩 메타데이터를 읽지 못했습니다.");}
    });
  }
  private void scan(){
    if(!loading.compareAndSet(false,true))return;
    statusNative("EXIF GPS 자동 분석 중");
    bg.execute(()->{
      JSONArray photos=new JSONArray();
      boolean forced=forcePhotoRescan;
      forcePhotoRescan=false;
      String existingFp=getSharedPreferences(CACHE_PREF,MODE_PRIVATE).getString("fingerprint","");
      if(!forced && !currentFingerprint.isEmpty() && currentFingerprint.equals(existingFp)) {
        String cached=privatePhotoCache();
        if(cached!=null && cached.startsWith("[") && cached.endsWith("]")) {
          statusNative("EXIF 사진 메타데이터 디스크 캐시 사용");
          dispatchPhotos(cached);
          loading.set(false);
          return;
        }
      }
      int scanned=0,geo=0;
      try{
        Uri collection=MediaStore.Images.Media.EXTERNAL_CONTENT_URI;
        String[] cols={MediaStore.Images.Media._ID,MediaStore.Images.Media.DATE_TAKEN};
        Cursor cursor=getContentResolver().query(collection,cols,null,null,MediaStore.Images.Media.DATE_TAKEN+" ASC");
        if(cursor!=null){try{
          while(cursor.moveToNext()){
            long id=cursor.getLong(0);
            long fallback=cursor.isNull(1)?System.currentTimeMillis()/1000L:cursor.getLong(1)/1000L;
            scanned++;
            Uri uri=ContentUris.withAppendedId(collection,id);
            try{
              Uri exifUri=uri;
              if(Build.VERSION.SDK_INT>=29&&checkSelfPermission(Manifest.permission.ACCESS_MEDIA_LOCATION)==PackageManager.PERMISSION_GRANTED){
                try{exifUri=MediaStore.setRequireOriginal(uri);}catch(Exception ignored){}
              }
              try(InputStream in=getContentResolver().openInputStream(exifUri)){
                if(in==null)continue;
                ExifInterface exif=new ExifInterface(in);
                float[] point=new float[2];
                if(!exif.getLatLong(point))continue;
                if(!Float.isFinite(point[0])||!Float.isFinite(point[1]))continue;
                JSONObject photo=new JSONObject();
                photo.put("id",String.valueOf(id));
                photo.put("lat",point[0]);photo.put("lon",point[1]);
                photo.put("t",photoTime(exif,fallback));
                photo.put("kind","photo");
                photos.put(photo);geo++;
              }
            }catch(Exception e){rejected++;}
            if(scanned%500==0) {
              final int fscanned=scanned, fgeo=geo;
              ui.post(()->Log.i("FamilyJourney","scan "+fscanned+" GPS "+fgeo));
            }
          }
        }finally{cursor.close();}}
        String serialized=photos.toString();
        savePrivatePhotoCache(serialized,currentFingerprint);
        dispatchPhotos(serialized);
      }catch(Exception e){Log.e("FamilyJourney","scan failed",e);message("사진 자동 분석 실패: "+e.getMessage());}
      finally{loading.set(false);}
    });
  }
  private void fingerprints(){
    // The original cache checks the count/fingerprint. Scan once and send all data;
    // on future launch the original indexDB cache performs fast boot.
    grantOrScan();
  }
  private void thumbnails(JSONObject payload){
    bg.execute(()->{
      int request=payload.optInt("id");
      JSONArray ids=payload.optJSONArray("ids");
      if(ids==null)ids=new JSONArray();
      int target=Math.min(400,Math.max(80,payload.optInt("size",200)));
      int n=ids.length();
      for(int first=0;first<n;first+=12){
        JSONArray out=new JSONArray();
        for(int k=first;k<Math.min(n,first+12);k++){
          String key=ids.optString(k);
          try{
            Uri uri=ContentUris.withAppendedId(MediaStore.Images.Media.EXTERNAL_CONTENT_URI,Long.parseLong(key));
            Bitmap thumb;
            if(Build.VERSION.SDK_INT>=29)
              thumb=getContentResolver().loadThumbnail(uri,new Size(target,target),null);
            else {
              try(InputStream in=getContentResolver().openInputStream(uri)){
                if(in==null)continue;
                Bitmap bitmap=android.graphics.BitmapFactory.decodeStream(in);
                if(bitmap==null)continue;
                thumb=Bitmap.createScaledBitmap(bitmap,Math.min(target,bitmap.getWidth()),Math.min(target,bitmap.getHeight()),true);
                if(thumb!=bitmap)bitmap.recycle();
              }
            }
            if(thumb==null)continue;
            ByteArrayOutputStream outBytes=new ByteArrayOutputStream();
            thumb.compress(Bitmap.CompressFormat.JPEG,72,outBytes);thumb.recycle();
            JSONObject item=new JSONObject();
            item.put("id",key);item.put("data","data:image/jpeg;base64,"+Base64.encodeToString(outBytes.toByteArray(),Base64.NO_WRAP));out.put(item);
          }catch(Exception ignored){}
        }
        boolean done=first+12>=n;
        jsInvoke("__thumbsResult",request+","+out.toString()+","+(done?"true":"false"));
      }
      if(n==0)jsInvoke("__thumbsResult",request+",[],true");
    });
  }
  private void startVideo(){
    try{
      if(videoStream!=null)videoStream.close();
      videoTemp=new File(getCacheDir(),"video-"+System.nanoTime()+".mp4");
      videoStream=new FileOutputStream(videoTemp);
    }catch(Exception e){Log.e("FamilyJourney","video start",e);}
  }
  private void saveVideo(JSONObject p){
    bg.execute(()->{
      Uri dest=null;
      try{
        if(videoStream!=null){videoStream.close();videoStream=null;}
        if(videoTemp==null||videoTemp.length()==0)throw new Exception("empty media");
        String suggested=p.optString("name","FamilyJourney.mp4");
        String lower=suggested.toLowerCase(java.util.Locale.ROOT);
        boolean isPng=lower.endsWith(".png");
        boolean isJpeg=lower.endsWith(".jpeg")||lower.endsWith(".jpg");
        boolean isWebp=lower.endsWith(".webp");
        boolean isImage=isPng||isJpeg||isWebp;
        boolean isWebm=lower.endsWith(".webm");
        if(!isImage&&!isWebm&&!lower.endsWith(".mp4"))suggested="FamilyJourney.mp4";
        String name=suggested.replaceAll("[^a-zA-Z0-9_.-]","_");
        String mime=isPng?"image/png":isJpeg?"image/jpeg":isWebp?"image/webp":isWebm?"video/webm":"video/mp4";
        ContentValues row=new ContentValues();
        row.put(MediaStore.MediaColumns.DISPLAY_NAME,name);
        row.put(MediaStore.MediaColumns.MIME_TYPE,mime);
        row.put(MediaStore.MediaColumns.RELATIVE_PATH,
          (isImage?Environment.DIRECTORY_PICTURES:Environment.DIRECTORY_MOVIES)+"/FamilyJourney");
        Uri collection=isImage?MediaStore.Images.Media.EXTERNAL_CONTENT_URI:MediaStore.Video.Media.EXTERNAL_CONTENT_URI;
        dest=getContentResolver().insert(collection,row);
        if(dest==null)throw new Exception("MediaStore insertion failed");
        try(InputStream source=new FileInputStream(videoTemp);OutputStream target=getContentResolver().openOutputStream(dest)){
          if(target==null)throw new Exception("MediaStore write stream failed");
          byte[] bytes=new byte[65536];int count;
          while((count=source.read(bytes))!=-1)target.write(bytes,0,count);
        }
        videoTemp.delete();videoTemp=null;
        message(isImage?"가족여행 지도 이미지 저장 완료":"가족여행 영상 저장 완료");
      }catch(Exception e){
        if(dest!=null)try{getContentResolver().delete(dest,null,null);}catch(Exception ignored){}
        Log.e("FamilyJourney","media saving failed",e);
        message("저장 실패: "+e.getMessage());
      }
    });
  }
  private void openExternal(String url){
    Uri target;
    try{target=Uri.parse(url);}catch(Exception e){return;}
    if(!NetworkPolicy.permitted(target)){
      message("등록되지 않은 외부 서비스 연결은 차단됩니다.");
      return;
    }
    ui.post(()->{try{startActivity(new Intent(Intent.ACTION_VIEW,target));}catch(Exception e){message("링크를 열 수 없습니다.");}});
  }
  private void handle(String name,JSONObject p){
    switch(name){
      case "ready":
        if(readyReceived.compareAndSet(false,true)){statusNative("웹 준비됨");grantOrScan();}
        break;
      case "watchdog":diagnostics("web-watchdog");break;
      case "forceScan":
        forcePhotoRescan=true;
        if(permitted())scan();else grantOrScan();
        break;
      case "mapBooted":mapBooted=true;statusNative("여행 지도 표시 완료");break;
      case "needPhotos":if(p.optBoolean("need",true))scan();break;
      case "rescan":
        forcePhotoRescan=true;
        js("location.reload()");
        break;
      case "thumbs":thumbnails(p);break;
      case "geocode":{
        int id=p.optInt("id");
        // Offline place naming falls back to original bundled CITIES; no GPS to server.
        jsInvoke("__geocodeResult",id+",[]");
        break;
      }
      case "videoChunk":{
        String value=p.optString("data","");
        if(value.length()>750000)return;
        byte[] bytes;
        try{bytes=Base64.decode(value,Base64.DEFAULT);}catch(Exception e){return;}
        boolean first=p.optBoolean("first");
        bg.execute(()->{try{if(first||videoStream==null)startVideo();if(videoStream!=null)videoStream.write(bytes);}
          catch(Exception e){Log.e("FamilyJourney","video chunk failed",e);}});
        break;
      }
      case "videoDone":saveVideo(p);break;
      case "reverseAddress":{
        // Explicit user action only: a coordinate may be provided to Android's
        // Geocoder backend. Never do this for every photo or in the background.
        final int lookup=p.optInt("id");
        final double lat=p.optDouble("lat",Double.NaN),lon=p.optDouble("lon",Double.NaN);
        if(!Double.isFinite(lat)||!Double.isFinite(lon)||lat<33||lat>39||lon<124||lon>132){
          jsInvoke("__fjNaverAddressResult",lookup+",{error:"+quote("invalid_point")+"}");
          break;
        }
        bg.execute(()->{
          JSONObject value=new JSONObject();
          try{
            android.location.Geocoder decoder=new android.location.Geocoder(this,java.util.Locale.KOREA);
            java.util.List<android.location.Address> found=decoder.getFromLocation(lat,lon,1);
            if(found!=null&&!found.isEmpty()){
              android.location.Address a=found.get(0);
              value.put("address",a.getAddressLine(0)==null?"":a.getAddressLine(0));
              value.put("locality",a.getLocality()==null?"":a.getLocality());
              value.put("subLocality",a.getSubLocality()==null?"":a.getSubLocality());
              value.put("thoroughfare",a.getThoroughfare()==null?"":a.getThoroughfare());
              value.put("feature",a.getFeatureName()==null?"":a.getFeatureName());
            }else value.put("error","no_result");
          }catch(Exception e){try{value.put("error",e.getClass().getSimpleName());}catch(Exception ignored){}}
          jsInvoke("__fjNaverAddressResult",lookup+","+value.toString());
        });
        break;
      }
      case "naverArm":{
        // Address is the Naver search target. The user's nickname/memo must NEVER
        // be used as the query: "고창 차 안" is not a registered POI.
        final String address=p.optString("address","").trim();
        final String alias=p.optString("alias","").trim();
        final String memo=p.optString("memo","").trim();
        final String key=p.optString("key","").trim();
        final String list=p.optString("list","내 장소").trim();
        if(key.length()<3||key.length()>90||address.length()<8||address.length()>180||
           alias.length()>100||memo.length()>400||list.length()>70) {
          jsInvoke("__fjNaverSaveStatus","{\"ok\":false,\"state\":\"ADDRESS_REQUIRED\"}");
          break;
        }
        String enabled=Settings.Secure.getString(getContentResolver(),
          Settings.Secure.ENABLED_ACCESSIBILITY_SERVICES);
        boolean serviceEnabled=enabled!=null&&enabled.contains(getPackageName())&&enabled.contains("NaverSaveService");
        if(!serviceEnabled){
          jsInvoke("__fjNaverSaveStatus","{\"ok\":false,\"state\":\"NEEDS_ACCESSIBILITY_CONSENT\"}");
          ui.post(()->new AlertDialog.Builder(this)
            .setTitle("네이버지도 저장 보조 권한")
            .setMessage("선택한 한 곳의 주소와 메모를 네이버지도에 저장하도록 보조합니다. 사용자가 실제 주소 결과를 선택하고 접근성을 직접 켜야 합니다. 앱이 다른 앱이나 비밀번호를 읽지 않도록 네이버지도 화면만 검사합니다.")
            .setPositiveButton("접근성 설정",(d,w)->{try{startActivity(new Intent(Settings.ACTION_ACCESSIBILITY_SETTINGS));}catch(Exception ignored){}})
            .setNegativeButton("취소",null).show());
          break;
        }
        SharedPreferences prefs=getSharedPreferences(NaverSaveService.STORE,MODE_PRIVATE);
        String job=java.util.UUID.randomUUID().toString();
        prefs.edit().putString("job",job).putString("key",key)
          .putString("expectedAddress",address).putString("expectedPoi",address)
          .putString("alias",alias).putString("memo",memo).putString("list",list)
          .putLong("started",System.currentTimeMillis()).putBoolean("armed",true)
          .putString("state","WAITING_ADDRESS_RESULT").apply();
        JSONObject started=new JSONObject();
        try{started.put("ok",true);started.put("key",key);started.put("name",alias);
          started.put("state","WAITING_ADDRESS_RESULT");}catch(Exception ignored){}
        jsInvoke("__fjNaverSaveStatus",started.toString());
        final String search="nmap://search?query="+Uri.encode(address)+"&appname="+Uri.encode(getPackageName());
        ui.post(()->{try{
          Intent intent=new Intent(Intent.ACTION_VIEW,Uri.parse(search));
          intent.setPackage(NaverSaveService.NAVER);
          intent.addCategory(Intent.CATEGORY_BROWSABLE);
          startActivity(intent);
        }catch(Exception e){
          prefs.edit().putBoolean("armed",false).putString("state","NAVER_APP_NOT_AVAILABLE").apply();
          jsInvoke("__fjNaverSaveStatus","{\"ok\":false,\"state\":\"NAVER_APP_NOT_AVAILABLE\"}");
        }});
        break;
      }
      case "naverStatus":{
        SharedPreferences preference=getSharedPreferences(NaverSaveService.STORE,MODE_PRIVATE);
        JSONObject current=new JSONObject();
        try{
          current.put("ok",true);
          current.put("state",preference.getString("state","IDLE"));
          current.put("key",preference.getString("key",""));
          current.put("name",preference.getString("expectedPoi",""));
        }catch(Exception ignored){}
        jsInvoke("__fjNaverSaveStatus",current.toString());
        break;
      }
      case "naverCancel":{
        getSharedPreferences(NaverSaveService.STORE,MODE_PRIVATE).edit()
          .putBoolean("armed",false).putString("state","CANCELLED").apply();
        jsInvoke("__fjNaverSaveStatus","{\"ok\":true,\"state\":\"CANCELLED\"}");
        break;
      }
      case "openPhoto":{
        String id=p.optString("id","");
        if(!id.matches("[0-9]{1,18}")){message("사진 ID가 올바르지 않습니다.");break;}
        try{
          Uri photo=ContentUris.withAppendedId(MediaStore.Images.Media.EXTERNAL_CONTENT_URI,Long.parseLong(id));
          Intent openImage=new Intent(Intent.ACTION_VIEW);
          openImage.setDataAndType(photo,"image/*");
          openImage.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION);
          ui.post(()->{try{startActivity(openImage);}catch(Exception e){message("원본 사진을 열 수 없습니다.");}});
        }catch(Exception e){message("원본 사진 열기 실패");}
        break;
      }
      case "openUrl":openExternal(p.optString("url",""));break;
      case "openSettings":
        ui.post(()->{Intent i=new Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS,Uri.parse("package:"+getPackageName()));startActivity(i);});break;
      case "log":Log.d("FamilyJourney",p.optString("text",""));break;
      case "status":
        statusNative("웹: "+p.optString("text",""));
        break;
      case "premiumInfo":
        // Another app's Play billing purchase cannot be queried from this package.
        break;
      case "purchase":
      case "restore":
        jsInvoke("__nativeEvent",quote(name)+",{ok:false,available:false,message:"+quote("구매한 원본 여행여권의 프리미엄 권한은 별도 서명 앱으로 자동 이전되지 않습니다.")+"}");
        break;
      case "rewardedAd":
        // Independent host never requests or shows a paid-ad SDK.
        jsInvoke("__nativeEvent",quote(name)+",{ok:false,available:false,rewarded:false}");
        break;
      case "adPrivacy":
        jsInvoke("__nativeEvent",quote(name)+",{ok:true,message:"+quote("이 앱은 광고 SDK를 포함하지 않습니다.")+"}");
        break;
      case "share":{
        Intent send=new Intent(Intent.ACTION_SEND);
        send.setType("text/plain");send.putExtra(Intent.EXTRA_TEXT,p.optString("text",""));
        ui.post(()->startActivity(Intent.createChooser(send,"공유")));break;
      }
      default:Log.d("FamilyJourney","Unsupported original bridge operation: "+name);
    }
  }
  public final class NativeInterface {
    @JavascriptInterface public void post(String name,String json){
      if(name==null||name.length()>40||json==null||json.length()>1100000)return;
      try{handle(name,new JSONObject(json));}catch(Exception e){Log.w("FamilyJourney","message "+name,e);}
    }
  }
  @Override public void onBackPressed(){
    if(web==null){super.onBackPressed();return;}
    web.evaluateJavascript("(function(){try{" +
      "if(window.__fjBackOverlay&&window.__fjBackOverlay())return true;" +
      "if(window.__photoMapBack&&window.__photoMapBack())return true;" +
      "if(window.__photoMap){if(window.__photoMap.tab!=='home'){" +
      "window.__photoMap.showTab('home');return true;}}}catch(e){}return false;})()",
      value->{
        if("true".equals(value))return;
        new AlertDialog.Builder(HostActivity.this)
          .setMessage("가족여행 앱을 종료할까요?")
          .setPositiveButton("종료",(dialog,which)->HostActivity.super.onBackPressed())
          .setNegativeButton("취소",null).show();
      });
  }
  @Override public void onDestroy(){
    if(web!=null){web.removeJavascriptInterface("NativeHost");web.destroy();web=null;}
    bg.shutdown();super.onDestroy();
  }
}
