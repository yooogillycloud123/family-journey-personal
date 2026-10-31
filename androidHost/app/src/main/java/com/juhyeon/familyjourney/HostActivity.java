package com.juhyeon.familyjourney;

import android.Manifest;
import android.app.Activity;
import android.app.AlertDialog;
import android.content.ContentUris;
import android.content.ContentValues;
import android.content.Intent;
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
  private final AtomicBoolean readyReceived=new AtomicBoolean(false);
  private volatile String phase="HTML 로딩 대기";
  private volatile String lastWebError="";
  private volatile boolean mapBooted=false;
  private void statusNative(String text) { phase=text; Log.i("FamilyJourney",text); }
  private void diagnostics(String source){
    ui.post(()->{
      if(isFinishing()||web==null)return;
      web.evaluateJavascript("(function(){return JSON.stringify({boot:!!window.__photoMap,ready:typeof window.__nativeFingerprint==='function',photos:typeof window.__nativePhotosEnd==='function',app:!!window.PhotoMapEngine,js:typeof window.__bootPhotoMap,blank:!!document.querySelector('.page[data-page=\\\"0\\\"]:not([hidden])')});})()",reply->{
        String data=reply==null?"":reply;
        if(data.contains("\\"boot\\":true")){mapBooted=true;return;}
        if(!readyReceived.get()&&(data.contains("\\"ready\\":true")||data.contains("\\"photos\\":true"))){
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
        if(!HOST.equals(uri.getHost()))return super.shouldInterceptRequest(view,req);
        String path=uri.getPath();
        if(path==null||path.equals("/"))path="/web/index.html";
        if(path.startsWith("/"))path=path.substring(1);
        if(path.contains("..")||path.contains("\\"))return new WebResourceResponse("text/plain","utf-8",new java.io.ByteArrayInputStream(new byte[0]));
        try{
          String mime=path.endsWith(".js")?"application/javascript":path.endsWith(".css")?"text/css":path.endsWith(".html")?"text/html":path.endsWith(".json")?"application/json":path.endsWith(".svg")?"image/svg+xml":path.endsWith(".png")?"image/png":"application/octet-stream";
          return new WebResourceResponse(mime,"utf-8",getAssets().open(path));
        }catch(Exception e){Log.e("FamilyJourney","ASSET "+path,e);return new WebResourceResponse("text/plain","utf-8",new java.io.ByteArrayInputStream(new byte[0]));}
      }
      @Override public void onPageFinished(WebView view,String url){
        super.onPageFinished(view,url);
        statusNative("HTML 완료");
        ui.postDelayed(()->{if(!mapBooted)diagnostics("page-finished");},12000);
      }
      @Override public boolean shouldOverrideUrlLoading(WebView v,WebResourceRequest r){
        Uri uri=r.getUrl();
        if(HOST.equals(uri.getHost()))return false;
        try{startActivity(new Intent(Intent.ACTION_VIEW,uri));}catch(Exception ignored){}
        return true;
      }
    });
    setContentView(web);
    web.loadUrl("https://"+HOST+"/web/index.html");
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
        statusNative("사진첩 지문 "+count+"장");
        jsInvoke("__nativeFingerprint",quote(count+"|"+mostRecent));
      }catch(Exception e){Log.e("FamilyJourney","fingerprint",e);message("사진첩 메타데이터를 읽지 못했습니다.");}
    });
  }
  private void scan(){
    if(!loading.compareAndSet(false,true))return;
    statusNative("EXIF GPS 자동 분석 중");
    bg.execute(()->{
      JSONArray photos=new JSONArray();
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
        js("window.__nativePhotosBegin&&window.__nativePhotosBegin()");
        for(int offset=0;offset<serialized.length();offset+=16000){
          String part=serialized.substring(offset,Math.min(serialized.length(),offset+16000));
          jsInvoke("__nativePhotosChunk",quote(part));
        }
        js("window.__nativePhotosEnd&&window.__nativePhotosEnd()");
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
      try{
        if(videoStream!=null){videoStream.close();videoStream=null;}
        if(videoTemp==null||videoTemp.length()==0)throw new Exception("empty video");
        String name=p.optString("name","FamilyJourney.mp4");
        if(!name.endsWith(".mp4")&&!name.endsWith(".webm"))name="FamilyJourney.mp4";
        name=name.replaceAll("[^a-zA-Z0-9_.-]","_");
        ContentValues row=new ContentValues();
        row.put(MediaStore.MediaColumns.DISPLAY_NAME,name);
        row.put(MediaStore.MediaColumns.MIME_TYPE,name.endsWith(".webm")?"video/webm":"video/mp4");
        row.put(MediaStore.MediaColumns.RELATIVE_PATH,Environment.DIRECTORY_MOVIES+"/FamilyJourney");
        Uri dest=getContentResolver().insert(MediaStore.Video.Media.EXTERNAL_CONTENT_URI,row);
        if(dest==null)throw new Exception("MediaStore insertion failed");
        try(InputStream source=new FileInputStream(videoTemp);OutputStream target=getContentResolver().openOutputStream(dest)){
          if(target==null)throw new Exception("MediaStore write stream failed");
          byte[] bytes=new byte[65536];int count;
          while((count=source.read(bytes))!=-1)target.write(bytes,0,count);
        }catch(Exception e){getContentResolver().delete(dest,null,null);throw e;}
        videoTemp.delete();videoTemp=null;
        message("가족여행 영상 저장 완료");
      }catch(Exception e){Log.e("FamilyJourney","video saving failed",e);message("영상 저장 실패: "+e.getMessage());}
    });
  }
  private void openExternal(String url){
    if(!url.startsWith("https://")&&!url.startsWith("nmap://"))return;
    ui.post(()->{try{startActivity(new Intent(Intent.ACTION_VIEW,Uri.parse(url)));}catch(Exception e){message("링크를 열 수 없습니다.");}});
  }
  private void handle(String name,JSONObject p){
    switch(name){
      case "ready":
        if(readyReceived.compareAndSet(false,true)){statusNative("웹 준비됨");grantOrScan();}
        break;
      case "watchdog":diagnostics("web-watchdog");break;
      case "mapBooted":mapBooted=true;statusNative("여행 지도 표시 완료");break;
      case "needPhotos":if(p.optBoolean("need",true))scan();break;
      case "rescan":js("location.reload()");break;
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
  @Override public void onDestroy(){
    if(web!=null){web.removeJavascriptInterface("NativeHost");web.destroy();web=null;}
    bg.shutdown();super.onDestroy();
  }
}
