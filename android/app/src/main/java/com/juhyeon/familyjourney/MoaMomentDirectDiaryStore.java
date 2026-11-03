package com.juhyeon.familyjourney;

import android.content.Context;
import android.content.SharedPreferences;
import android.os.Handler;
import android.os.Looper;
import android.os.SystemClock;
import android.view.ContextThemeWrapper;
import android.webkit.JavascriptInterface;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import org.json.JSONArray;
import org.json.JSONObject;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

/**
 * Direct diary persistence without requiring HostActivity lifecycle events
 * or a MoaMomentNative interface in the *visible* WebView.
 * Runs a private same-origin WebView against the exact existing R42 IndexedDB:
 * familyjourney-diary-v1 / curated, keyed by local capture day.
 *
 * A native saved note is considered synced ONLY after IDB transaction complete
 * and read-back from the same origin. Do not erase original m: drafts.
 */
public final class MoaMomentDirectDiaryStore {
  private static final Handler MAIN = new Handler(Looper.getMainLooper());
  private static final String PREF_DIAG="directDiaryDiagnostic";
  private static final String BASE="https://familyjourney.local/";
  private static final long TIMEOUT=25000L;
  private static boolean working=false;
  private static long retryAfter=0L;
  private static WebView current;
  private static String activeToken="";
  private MoaMomentDirectDiaryStore(){}

  public static void requestSync(Context context) {
    final Context app=context.getApplicationContext();
    MAIN.post(()->start(app));
  }
  private static void diag(Context c,String state) {
    MoaMomentCaptureService.prefs(c).edit().putString(PREF_DIAG,state)
      .putLong("directDiaryDiagnosticAt",System.currentTimeMillis()).apply();
  }
  private static String sha(String v) {
    try {
      byte[] hash=MessageDigest.getInstance("SHA-256").digest(v.getBytes(StandardCharsets.UTF_8));
      StringBuilder out=new StringBuilder();
      for(byte b:hash)out.append(String.format(java.util.Locale.ROOT,"%02x",b&0xff));
      return out.toString();
    } catch(Exception e) {return "";}
  }
  private static String asset(Context c) throws Exception {
    StringBuilder out=new StringBuilder();
    try(BufferedReader reader=new BufferedReader(new InputStreamReader(
      c.getAssets().open("web/moa-direct-diary-commit.html"),StandardCharsets.UTF_8))) {
      String line;
      while((line=reader.readLine())!=null)out.append(line).append('\n');
    }
    return out.toString();
  }
  private static void start(Context c) {
    if(working||SystemClock.elapsedRealtime()<retryAfter)return;
    SharedPreferences p=MoaMomentCaptureService.prefs(c);
    JSONArray drafts=new JSONArray();
    Map<String,String> snapshot=new HashMap<>();
    Map<String,String> fingerprints=new HashMap<>();
    long now=System.currentTimeMillis();
    for(Map.Entry<String,?> row:p.getAll().entrySet()) {
      if(drafts.length()>=40)break;
      if(!row.getKey().startsWith("m:")||!(row.getValue() instanceof String))continue;
      try {
        String raw=(String)row.getValue();
        JSONObject x=new JSONObject(raw);
        String id=x.optString("id","");
        if(!id.matches("(?:v[0-9]{1,18}|[0-9]{1,19})"))continue;
        if(!x.optBoolean("memoSaved",false)&&x.optString("note","").trim().isEmpty())continue;
        long at=x.optLong("at",0);
        if(at<946684800000L||at>now+86400000L)continue;
        String fingerprint=sha(raw);
        if(fingerprint.equals(p.getString("directDiaryAck:"+id,"")))continue;
        snapshot.put(id,raw);
        fingerprints.put(id,fingerprint);
        drafts.put(x);
      }catch(Exception ignored){}
    }
    if(drafts.length()==0)return;
    String token=UUID.randomUUID().toString().replace("-","");
    JSONObject packet=new JSONObject();
    try{packet.put("token",token);packet.put("drafts",drafts);}
    catch(Exception e){diag(c,"PACKET_ERROR");return;}
    final String json=packet.toString();
    working=true;activeToken=token;
    diag(c,"DIRECT_IDB_START "+drafts.length());
    try{
      WebView w=new WebView(new ContextThemeWrapper(c,android.R.style.Theme_Material_Light_NoActionBar));
      current=w;
      w.getSettings().setJavaScriptEnabled(true);
      w.getSettings().setDomStorageEnabled(true);
      w.getSettings().setAllowFileAccess(false);
      w.getSettings().setAllowContentAccess(false);
      w.getSettings().setJavaScriptCanOpenWindowsAutomatically(false);
      w.setWebViewClient(new WebViewClient());
      w.addJavascriptInterface(new NativeAck(c,token,json,snapshot,fingerprints),"MoaNativeDiary");
      String html=asset(c);
      w.loadDataWithBaseURL(BASE,html,"text/html","UTF-8",BASE);
      MAIN.postDelayed(()->{
        if(working&&token.equals(activeToken)){
          diag(c,"DIRECT_IDB_TIMEOUT_KEEP_PENDING");
          finish(w,false);
        }
      },TIMEOUT);
    }catch(Throwable e){
      diag(c,"DIRECT_IDB_START_ERROR "+e.getClass().getSimpleName());
      finish(current,false);
    }
  }
  private static void finish(WebView w,boolean success){
    if(w!=null)try{w.destroy();}catch(Throwable ignored){}
    if(current==w)current=null;
    working=false;activeToken="";
    retryAfter=SystemClock.elapsedRealtime()+(success?500L:18000L);
  }
  private static final class NativeAck {
    final Context ctx;
    final String token,packet;
    final Map<String,String> snapshot,fingerprints;
    NativeAck(Context c,String token,String packet,Map<String,String> snapshot,
              Map<String,String> fingerprints){
      this.ctx=c;this.token=token;this.packet=packet;
      this.snapshot=snapshot;this.fingerprints=fingerprints;
    }
    @JavascriptInterface public String pull(){return packet;}
    @JavascriptInterface public void done(String json){
      MAIN.post(()->{
        if(!working||!token.equals(activeToken))return;
        int saved=0,failed=0;
        boolean valid=false;
        try{
          JSONObject result=new JSONObject(json);
          if(result.optString("token").equals(token)
             &&"https://familyjourney.local".equals(result.optString("origin"))
             &&"familyjourney-diary-v1".equals(result.optString("store"))){
            valid=true;
            JSONArray ack=result.optJSONArray("acked");
            SharedPreferences p=MoaMomentCaptureService.prefs(ctx);
            if(ack!=null)for(int i=0;i<ack.length();i++){
              String id=ack.optString(i,"");
              String original=snapshot.get(id);
              if(original==null)continue;
              if(original.equals(p.getString("m:"+id,null))
                &&p.edit().putString("directDiaryAck:"+id,fingerprints.get(id)).commit())saved++;
            }
            JSONArray failures=result.optJSONArray("failed");
            failed=failures==null?0:failures.length();
          }else{diag(ctx,"DIRECT_IDB_REJECT "+result.optString("error","BAD_ACK"));}
        }catch(Exception e){diag(ctx,"DIRECT_IDB_ACK_ERROR");}
        if(valid)diag(ctx,"DIRECT_IDB_COMMITTED_READBACK "+saved+" FAILED "+failed);
        WebView doneWeb=current;
        finish(doneWeb,valid&&failed==0);
        if(valid&&failed==0&&saved>0)requestSync(ctx);
      });
    }
  }
}
