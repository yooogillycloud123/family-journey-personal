package com.familyjourney.personal;

import android.Manifest;
import android.app.Activity;
import android.os.Bundle;
import android.os.Build;
import android.content.Intent;
import android.content.ContentValues;
import android.content.pm.PackageManager;
import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.BitmapFactory;
import android.net.Uri;
import android.provider.MediaStore;
import android.os.Environment;
import android.webkit.JavascriptInterface;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.webkit.WebSettings;
import android.widget.Toast;
import android.util.Base64;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.ByteArrayOutputStream;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.Executors;
import java.util.concurrent.ExecutorService;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;
import org.json.JSONArray;
import org.json.JSONObject;

public final class JourneyActivity extends Activity {
  private static final int PICK=80,MEDIA_PERMISSION=81;
  private WebView web;
  private final ExecutorService work=Executors.newSingleThreadExecutor();
  private final List<TripEngine.Photo> photos=new ArrayList<>();
  private List<TripEngine.Trip> trips=new ArrayList<>();
  private volatile boolean ready=false;
  private final SimpleDateFormat shortDate=new SimpleDateFormat("yyyy.MM.dd",Locale.KOREA);
  private static final String[] NAMES={"서울","인천","수원","용인","고양","평택","안성","춘천","강릉","원주","대전","청주","천안","세종","전주","군산","익산","고창","정읍","남원","광주","담양","장성","장흥","목포","진도","무안","나주","여수","순천","부산","울산","대구","포항","경주","제주"};
  private static final double[][] COORDS={
    {37.5665,126.9780},{37.4563,126.7052},{37.2636,127.0286},{37.2411,127.1776},{37.6584,126.8319},{36.9921,127.1129},{37.0081,127.2798},{37.8813,127.7298},{37.7519,128.8761},{37.3422,127.9202},{36.3504,127.3845},{36.6424,127.4890},{36.8151,127.1139},{36.4801,127.2891},{35.8242,127.1479},{35.9677,126.7366},{35.9483,126.9577},{35.4357,126.7018},{35.5699,126.8558},{35.4164,127.3904},{35.1595,126.8526},{35.3210,126.9883},{35.3018,126.7841},{34.6814,126.9069},{34.8118,126.3922},{34.4868,126.2632},{34.9904,126.4816},{35.0158,126.7107},{34.7604,127.6622},{34.9506,127.4872},{35.1796,129.0756},{35.5384,129.3114},{35.8714,128.6014},{36.019,129.3435},{35.8562,129.2247},{33.4996,126.5312}};
  private String where(double lat,double lon){
    double best=1e9;String name="여행지";
    for(int i=0;i<NAMES.length;i++){double dist=TripEngine.km(lat,lon,COORDS[i][0],COORDS[i][1]);if(dist<best){best=dist;name=NAMES[i];}}
    return best<32?name:"여행지";
  }
  private void notifyJs(String event,Object payload){
    String data=(payload instanceof String)?JSONObject.quote((String)payload):String.valueOf(payload);
    runOnUiThread(()->{if(ready&&web!=null)web.evaluateJavascript("window.onNative("+JSONObject.quote(event)+","+data+");",null);});
  }
  @Override public void onCreate(Bundle saved){
    super.onCreate(saved);
    web=new WebView(this);web.setBackgroundColor(0xfff8fafb);
    WebSettings settings=web.getSettings();settings.setJavaScriptEnabled(true);settings.setDomStorageEnabled(true);
    settings.setAllowFileAccess(true);settings.setAllowContentAccess(true);
    settings.setMixedContentMode(WebSettings.MIXED_CONTENT_NEVER_ALLOW);
    web.addJavascriptInterface(new Bridge(),"Family");
    web.setWebViewClient(new WebViewClient(){
      @Override public void onPageFinished(WebView view,String url){
        ready=true;web.evaluateJavascript("window.onNative('ready',{})",null);sendTrips();
      }
    });
    setContentView(web);
    web.loadUrl("file:///android_asset/journey/index.html");
  }
  @Override public void onBackPressed(){
    if(ready)web.evaluateJavascript("window.onNative('back',{})",null);
    else super.onBackPressed();
  }
  private void sendTrips(){
    JSONArray groups=new JSONArray();
    int total=0;
    try{
      for(int k=0;k<trips.size();k++){
        TripEngine.Trip t=trips.get(k);JSONObject j=new JSONObject();
        j.put("id",k);j.put("start",shortDate.format(new Date(t.start)));j.put("end",shortDate.format(new Date(t.end)));j.put("photos",t.count());
        JSONArray stops=new JSONArray();
        StringBuilder names=new StringBuilder();
        for(TripEngine.Stop s:t.stops){
          JSONObject o=new JSONObject();String city=where(s.latitude,s.longitude);
          o.put("lat",s.latitude);o.put("lon",s.longitude);o.put("name",city);o.put("photos",s.count);
          stops.put(o);
          if(names.indexOf(city)<0){if(names.length()>0)names.append(" · ");names.append(city);}
        }
        j.put("title",names.length()>0?names.toString():"가족여행 "+(k+1));
        j.put("stops",stops);groups.put(j);total+=t.count();
      }
      JSONObject all=new JSONObject();all.put("trips",groups);all.put("photos",total);all.put("places",countPlaces());
      notifyJs("trips",all);
    }catch(Exception e){notifyJs("error","여행 분석 결과를 표시하지 못했습니다.");}
  }
  private int countPlaces(){
    java.util.HashSet<String> set=new java.util.HashSet<>();
    for(TripEngine.Trip t:trips)for(TripEngine.Stop s:t.stops)set.add(where(s.latitude,s.longitude));
    return set.size();
  }
  private void regroup(){
    trips=TripEngine.group(photos,null,null,0);
    sendTrips();
  }
  private void selectPhotos(){
    Intent intent=new Intent(Intent.ACTION_OPEN_DOCUMENT);
    intent.addCategory(Intent.CATEGORY_OPENABLE);intent.setType("image/*");
    intent.putExtra(Intent.EXTRA_ALLOW_MULTIPLE,true);
    intent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION|Intent.FLAG_GRANT_PERSISTABLE_URI_PERMISSION);
    startActivityForResult(intent,PICK);
  }
  private void askGallery(){
    if(Build.VERSION.SDK_INT>=33 && checkSelfPermission(Manifest.permission.READ_MEDIA_IMAGES)!=PackageManager.PERMISSION_GRANTED){
      if(Build.VERSION.SDK_INT>=34)requestPermissions(new String[]{Manifest.permission.READ_MEDIA_IMAGES,Manifest.permission.READ_MEDIA_VISUAL_USER_SELECTED,Manifest.permission.ACCESS_MEDIA_LOCATION},MEDIA_PERMISSION);
      else requestPermissions(new String[]{Manifest.permission.READ_MEDIA_IMAGES,Manifest.permission.ACCESS_MEDIA_LOCATION},MEDIA_PERMISSION);
    }else if(Build.VERSION.SDK_INT<33 && checkSelfPermission(Manifest.permission.READ_EXTERNAL_STORAGE)!=PackageManager.PERMISSION_GRANTED){
      requestPermissions(new String[]{Manifest.permission.READ_EXTERNAL_STORAGE,Manifest.permission.ACCESS_MEDIA_LOCATION},MEDIA_PERMISSION);
    }else scanGallery();
  }
  @Override public void onRequestPermissionsResult(int request,String[] permissions,int[] results){
    super.onRequestPermissionsResult(request,permissions,results);
    if(request==MEDIA_PERMISSION){
      if(Build.VERSION.SDK_INT>=33 && checkSelfPermission(Manifest.permission.READ_MEDIA_IMAGES)==PackageManager.PERMISSION_GRANTED)scanGallery();
      else if(Build.VERSION.SDK_INT>=34 && checkSelfPermission(Manifest.permission.READ_MEDIA_VISUAL_USER_SELECTED)==PackageManager.PERMISSION_GRANTED)scanGallery();
      else if(Build.VERSION.SDK_INT<33 && checkSelfPermission(Manifest.permission.READ_EXTERNAL_STORAGE)==PackageManager.PERMISSION_GRANTED)scanGallery();
      else notifyJs("error","사진첩 접근 권한이 필요합니다. 또는 사진을 직접 선택하세요.");
    }
  }
  private void scanGallery(){
    notifyJs("progress","사진첩에서 위치·촬영시간 분석을 시작합니다.");
    work.execute(()->{
      ArrayList<TripEngine.Photo> loaded=new ArrayList<>();
      android.database.Cursor cursor=null;int seen=0;int missing=0;
      try{
        String[] cols={MediaStore.Images.Media._ID};
        cursor=getContentResolver().query(MediaStore.Images.Media.EXTERNAL_CONTENT_URI,cols,null,null,MediaStore.Images.Media.DATE_ADDED+" DESC");
        if(cursor!=null)while(cursor.moveToNext()){
          long id=cursor.getLong(0);Uri uri=android.content.ContentUris.withAppendedId(MediaStore.Images.Media.EXTERNAL_CONTENT_URI,id);
          try{TripEngine.Photo p=readOne(uri);if(p!=null)loaded.add(p);else missing++;}catch(Exception ignored){missing++;}
          if(++seen%150==0){int n=seen;notifyJs("progress","사진 "+n+"장 확인 중 · GPS "+loaded.size()+"장");}
        }
        int skipped=missing;
        runOnUiThread(()->{photos.clear();photos.addAll(loaded);regroup();notifyJs("progress","분석 완료 · GPS 사진 "+loaded.size()+"장 · 제외 "+skipped+"장");});
      }catch(Exception e){notifyJs("error","사진첩 읽기 오류: "+e.getClass().getSimpleName());}
      finally{if(cursor!=null)cursor.close();}
    });
  }
  private TripEngine.Photo readOne(Uri uri)throws Exception{
    Uri original=uri;
    if(Build.VERSION.SDK_INT>=29 && checkSelfPermission(Manifest.permission.ACCESS_MEDIA_LOCATION)==PackageManager.PERMISSION_GRANTED){
      try{original=MediaStore.setRequireOriginal(uri);}catch(Exception ignored){}
    }
    try(InputStream in=getContentResolver().openInputStream(original)){return in==null?null:TripEngine.read(uri,in);}
  }
  @Override protected void onActivityResult(int request,int result,Intent data){
    super.onActivityResult(request,result,data);
    if(request!=PICK||result!=RESULT_OK||data==null)return;
    ArrayList<Uri> picked=new ArrayList<>();
    if(data.getClipData()!=null){
      for(int i=0;i<data.getClipData().getItemCount();i++)picked.add(data.getClipData().getItemAt(i).getUri());
    }else if(data.getData()!=null)picked.add(data.getData());
    notifyJs("progress","선택 사진 "+picked.size()+"장 분석 중…");
    work.execute(()->{
      ArrayList<TripEngine.Photo> loaded=new ArrayList<>();int errors=0;
      for(Uri uri:picked){
        try{
          try{getContentResolver().takePersistableUriPermission(uri,Intent.FLAG_GRANT_READ_URI_PERMISSION);}catch(Exception ignored){}
          TripEngine.Photo p=readOne(uri);if(p!=null)loaded.add(p);else errors++;
        }catch(Exception e){errors++;}
      }
      int missed=errors;
      runOnUiThread(()->{photos.clear();photos.addAll(loaded);regroup();notifyJs("progress","선택 사진 중 GPS "+loaded.size()+"장 · 제외 "+missed+"장");});
    });
  }
  private void exportVideo(){
    if(trips.isEmpty()){notifyJs("error","GPS 사진을 먼저 분석해 주세요.");return;}
    notifyJs("progress","영상 저장 중입니다. 6초 좌표 기반 버전으로 제작합니다.");
    List<TripEngine.Trip> copy=new ArrayList<>(trips);
    work.execute(()->{
      try{Uri uri=VideoExporter.save(this,copy);notifyJs("saved","MP4를 영화/FamilyJourney에 저장했습니다.");}
      catch(Exception e){notifyJs("error","MP4 제작 실패: "+e.getMessage());}
    });
  }
  private void exportImage(){
    runOnUiThread(()->{
      try{
        Bitmap bitmap=Bitmap.createBitmap(web.getWidth(),web.getHeight(),Bitmap.Config.ARGB_8888);
        web.draw(new Canvas(bitmap));
        ContentValues values=new ContentValues();
        values.put(MediaStore.MediaColumns.DISPLAY_NAME,"FamilyJourney_"+System.currentTimeMillis()+".png");
        values.put(MediaStore.MediaColumns.MIME_TYPE,"image/png");
        if(Build.VERSION.SDK_INT>=29)values.put(MediaStore.MediaColumns.RELATIVE_PATH,Environment.DIRECTORY_PICTURES+"/FamilyJourney");
        Uri uri=getContentResolver().insert(MediaStore.Images.Media.EXTERNAL_CONTENT_URI,values);
        if(uri==null)throw new Exception("저장 위치 오류");
        try(OutputStream out=getContentResolver().openOutputStream(uri)){
          if(out==null||!bitmap.compress(Bitmap.CompressFormat.PNG,100,out))throw new Exception("이미지 저장 오류");
        }
        bitmap.recycle();notifyJs("saved","현재 화면을 사진첩에 저장했습니다.");
      }catch(Exception e){notifyJs("error","이미지 저장 실패: "+e.getMessage());}
    });
  }
  public final class Bridge{
    @JavascriptInterface public void select(){runOnUiThread(()->selectPhotos());}
    @JavascriptInterface public void scan(){runOnUiThread(()->askGallery());}
    @JavascriptInterface public void sample(){
      runOnUiThread(()->{photos.clear();photos.addAll(TripEngine.demo());regroup();notifyJs("progress","샘플 데이터입니다. 실제 방문 기록이 아닙니다.");});
    }
    @JavascriptInterface public void video(){exportVideo();}
    @JavascriptInterface public void image(){exportImage();}
    @JavascriptInterface public void toast(String message){runOnUiThread(()->Toast.makeText(JourneyActivity.this,message,Toast.LENGTH_SHORT).show());}
    @JavascriptInterface public void naver(double lat,double lon){
      Intent intent=new Intent(Intent.ACTION_VIEW,Uri.parse("https://map.naver.com/p/search/"+lat+","+lon));
      runOnUiThread(()->{try{startActivity(intent);}catch(Exception ignored){notifyJs("error","지도 앱을 열지 못했습니다.");}});
    }
  }
  @Override protected void onDestroy(){super.onDestroy();ready=false;web.removeJavascriptInterface("Family");web.destroy();work.shutdown();}
}
