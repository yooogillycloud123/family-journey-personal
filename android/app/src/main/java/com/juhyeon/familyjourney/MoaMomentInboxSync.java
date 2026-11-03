package com.juhyeon.familyjourney;

import android.app.Activity;
import android.content.Context;
import android.content.SharedPreferences;
import android.os.Handler;
import android.os.Looper;
import android.view.View;
import android.view.ViewGroup;
import android.webkit.WebView;
import org.json.JSONArray;
import org.json.JSONObject;
import org.json.JSONTokener;
import java.lang.reflect.Field;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

/**
 * Deliver already-persisted MediaStore capture drafts to the original R42
 * diary only after the native Activity has resumed. Does not replace the
 * HostActivity, trigger WebView reloads or require addJavascriptInterface.
 *
 * Never delete a native draft until the receiving JS has committed it to
 * IndexedDB, returned an exact token acknowledgment and the original native
 * draft bytes have not changed.
 */
public final class MoaMomentInboxSync {
  private static final Handler MAIN=new Handler(Looper.getMainLooper());
  private static final String HOST="com.juhyeon.familyjourney.HostActivity";
  private static final String ORIGIN="https://familyjourney.local/";
  private static final long MAX_WAIT_MS=60000L;
  private MoaMomentInboxSync(){}

  private static boolean host(Activity a){
    return a!=null&&HOST.equals(a.getClass().getName())&&!a.isFinishing()&&!a.isDestroyed();
  }
  private static WebView find(View v){
    if(v instanceof WebView)return (WebView)v;
    if(v instanceof ViewGroup){
      ViewGroup g=(ViewGroup)v;
      for(int i=0;i<g.getChildCount();i++){
        WebView w=find(g.getChildAt(i));
        if(w!=null)return w;
      }
    }
    return null;
  }
  private static WebView web(Activity a){
    try{
      Field f=a.getClass().getDeclaredField("web"); f.setAccessible(true);
      Object value=f.get(a);
      if(value instanceof WebView)return (WebView)value;
    }catch(Exception ignored){}
    return find(a.getWindow().getDecorView());
  }
  private static void diagnostic(Context c,String message){
    MoaMomentCaptureService.prefs(c).edit()
      .putString("inboxSyncDiagnostic",message)
      .putLong("inboxSyncDiagnosticAt",System.currentTimeMillis()).apply();
  }
  public static void onResume(Activity a){
    if(!host(a))return;
    final long start=System.currentTimeMillis();
    MAIN.postDelayed(()->attempt(a,start),200L);
  }
  private static void attempt(Activity a,long start){
    if(!host(a))return;
    if(System.currentTimeMillis()-start>MAX_WAIT_MS){
      diagnostic(a,"INBOX_WAIT_TIMEOUT");return;
    }
    final WebView w=web(a);
    final String url=w==null?null:w.getUrl();
    if(w==null||url==null||!url.startsWith(ORIGIN)){
      MAIN.postDelayed(()->attempt(a,start),700L);return;
    }
    try{
      w.evaluateJavascript("(function(){return typeof window.__moaNativeSync==='function'?'READY':'NOT_READY'})()",ready->{
        if(!host(a))return;
        if("\"READY\"".equals(ready))deliver(a,w);
        else MAIN.postDelayed(()->attempt(a,start),850L);
      });
    }catch(Exception e){diagnostic(a,"INBOX_JS_READY_ERROR "+e);}
  }
  private static void deliver(Activity a,WebView w){
    SharedPreferences p=MoaMomentCaptureService.prefs(a);
    JSONArray drafts=new JSONArray();
    Map<String,String> snapshot=new HashMap<>();
    try{
      for(Map.Entry<String,?> row:p.getAll().entrySet()){
        if(drafts.length()>=40)break;
        if(!row.getKey().startsWith("m:")||!(row.getValue() instanceof String))continue;
        JSONObject item=new JSONObject((String)row.getValue());
        String id=item.optString("id","");
        if(!id.matches("v?[0-9]{1,19}"))continue;
        drafts.put(item);snapshot.put(id,(String)row.getValue());
      }
      if(drafts.length()==0){diagnostic(a,"INBOX_EMPTY");return;}
      String token=UUID.randomUUID().toString().replace("-","");
      JSONObject packet=new JSONObject().put("token",token).put("drafts",drafts);
      diagnostic(a,"INBOX_DELIVERY_ATTEMPT "+drafts.length());
      w.evaluateJavascript("window.__moaNativeSync("+JSONObject.quote(packet.toString())+")",answer->{
        if(!host(a))return;
        if(!"\"ACCEPTED\"".equals(answer)){
          diagnostic(a,"INBOX_JS_REJECTED "+answer);return;
        }
        awaitAck(a,w,token,snapshot,0);
      });
    }catch(Exception e){diagnostic(a,"INBOX_SEND_ERROR "+e);}
  }
  private static void awaitAck(Activity a,WebView w,String token,Map<String,String> snapshot,int tries){
    if(!host(a))return;
    if(tries>20){diagnostic(a,"INBOX_NO_ACK");return;}
    String encoded=JSONObject.quote(token);
    String js="(function(){var a=window.__moaNativeAckByToken;"
      +"return a&&a["+encoded+"]?JSON.stringify(a["+encoded+"]):''})()";
    MAIN.postDelayed(()->{
      try{
        w.evaluateJavascript(js,v->{
          try{
            Object payload=new JSONTokener(v).nextValue();
            if(!(payload instanceof String)||((String)payload).isEmpty()){
              awaitAck(a,w,token,snapshot,tries+1);return;
            }
            JSONObject response=new JSONObject((String)payload);
            if(!token.equals(response.optString("token")))throw new IllegalArgumentException("token mismatch");
            JSONArray acks=response.optJSONArray("acked");
            int saved=0;
            if(acks!=null)for(int i=0;i<acks.length();i++){
              String id=acks.optString(i,"");
              String sent=snapshot.get(id);
              if(sent==null)continue;
              SharedPreferences state=MoaMomentCaptureService.prefs(a);
              if(sent.equals(state.getString("m:"+id,null))&&state.edit().remove("m:"+id).commit())saved++;
            }
            diagnostic(a,"INBOX_ACK_COMMITTED "+saved);
          }catch(Exception e){diagnostic(a,"INBOX_ACK_ERROR "+e);}
        });
      }catch(Exception e){diagnostic(a,"INBOX_EVALUATE_ERROR "+e);}
    },400L);
  }
}
