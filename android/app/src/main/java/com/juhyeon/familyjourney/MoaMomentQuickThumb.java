package com.juhyeon.familyjourney;

import android.Manifest;
import android.content.Context;
import android.content.pm.PackageManager;
import android.content.ContentUris;
import android.graphics.Bitmap;
import android.net.Uri;
import android.os.Handler;
import android.os.Looper;
import android.provider.MediaStore;
import android.util.Base64;
import android.util.Size;
import android.webkit.JavascriptInterface;
import android.webkit.WebView;
import java.io.ByteArrayOutputStream;
import java.lang.ref.WeakReference;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import org.json.JSONArray;
import org.json.JSONObject;

/** R75: optional, independent PRIORITY thumbnail reader for selected diary.
 * Never changes the R63 IndexedDB writer or the original NativeHost bridge.
 * All results remain in the trusted local WebView and in-memory JS.
 */
public final class MoaMomentQuickThumb {
  private static final ExecutorService IO=Executors.newFixedThreadPool(2);
  private static final Set<String> WORKING=ConcurrentHashMap.newKeySet();
  private final WeakReference<WebView> view;
  private final Context app;
  private final Handler main=new Handler(Looper.getMainLooper());

  public MoaMomentQuickThumb(Context c,WebView w){
    app=c.getApplicationContext();
    view=new WeakReference<>(w);
  }

  @JavascriptInterface public void request(String idsJson,int size){
    if(size!=130&&size!=250&&size!=400)return;
    if(idsJson==null||idsJson.length()>1000)return;
    final JSONArray arr;
    try{arr=new JSONArray(idsJson);}catch(Exception e){return;}
    if(arr.length()>12)return;
    // Do not process photo IDs from any non-MOA WebView page.
    main.post(()->{
      WebView w=view.get();
      if(w==null||w.getUrl()==null||
        !w.getUrl().startsWith("https://familyjourney.local/"))return;
      for(int i=0;i<arr.length();i++){
        final String id=arr.optString(i,"");
        if(!id.matches("(?:[0-9]{1,19}|v[0-9]{1,18})"))continue;
        final String key=id+":"+size;
        if(!WORKING.add(key))continue;
        IO.execute(()->{
          try{
            boolean video=id.startsWith("v");
            if(app.checkSelfPermission(video?Manifest.permission.READ_MEDIA_VIDEO:
              Manifest.permission.READ_MEDIA_IMAGES)!=PackageManager.PERMISSION_GRANTED)return;
            long mediaId=Long.parseLong(video?id.substring(1):id);
            Uri uri=ContentUris.withAppendedId(video?
              MediaStore.Video.Media.EXTERNAL_CONTENT_URI:
              MediaStore.Images.Media.EXTERNAL_CONTENT_URI,mediaId);
            Bitmap bitmap=app.getContentResolver().loadThumbnail(
              uri,new Size(size,size),null);
            if(bitmap==null)return;
            ByteArrayOutputStream bytes=new ByteArrayOutputStream();
            bitmap.compress(Bitmap.CompressFormat.JPEG,74,bytes);
            bitmap.recycle();
            if(bytes.size()<20||bytes.size()>360000)return;
            String data="data:image/jpeg;base64,"+
              Base64.encodeToString(bytes.toByteArray(),Base64.NO_WRAP);
            final String js="window.__moaQuickThumbResult&&window.__moaQuickThumbResult("+
              JSONObject.quote(id)+","+size+","+JSONObject.quote(data)+")";
            main.post(()->{
              WebView current=view.get();
              if(current!=null&&current.getUrl()!=null&&
                current.getUrl().startsWith("https://familyjourney.local/"))
                try{current.evaluateJavascript(js,null);}
                catch(Exception ignored){}
            });
          }catch(Exception ignored){}
          finally{WORKING.remove(key);}
        });
      }
    });
  }
}
