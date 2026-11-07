package com.juhyeon.familyjourney;

import android.Manifest;
import android.app.Activity;
import android.content.pm.PackageManager;
import android.media.MediaPlayer;
import android.media.MediaRecorder;
import android.net.Uri;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.speech.RecognitionListener;
import android.speech.RecognizerIntent;
import android.speech.SpeechRecognizer;
import android.content.Intent;
import android.webkit.JavascriptInterface;
import android.webkit.WebView;
import android.view.View;
import android.view.ViewGroup;
import org.json.JSONArray;
import org.json.JSONObject;
import java.io.File;
import java.util.ArrayList;
import java.util.UUID;

/** R149: Legacy host remains intact. No WebChromeClient replacement.
 * Original STT UI calls a separate native SpeechRecognizer; original audio is
 * recorded with Android MediaRecorder, not WebView getUserMedia.
 */
public class MoaMomentAudioHostActivity extends MoaMomentVoiceHostActivity {
 private static final int MIC_REQUEST=4949;
 private final Handler main=new Handler(Looper.getMainLooper());
 private WebView web; private boolean interfaceAdded=false, reloadIssued=false; private volatile boolean trustedPage=false;
 private MediaRecorder recorder; private MediaPlayer player; private File currentFile;
 private long recordStart=0; private String recordDay="",pendingDay="",pendingSpeech="";
 private SpeechRecognizer recognizer; private String recognitionToken="";
 private static boolean validDay(String s){return s!=null&&s.matches("[0-9]{4}-(0[1-9]|1[0-2])-([0-2][0-9]|3[01])");}
 private static boolean validId(String s){return s!=null&&s.matches("[0-9a-zA-Z_-]{8,90}\\.m4a");}
 @Override protected void onCreate(Bundle b){super.onCreate(b);schedule();}
 @Override protected void onResume(){super.onResume();schedule();}
 private void schedule(){main.postDelayed(this::attach,60);main.postDelayed(this::attach,300);main.postDelayed(this::attach,1000);}
 private static WebView find(View v){if(v instanceof WebView)return(WebView)v;
  if(v instanceof ViewGroup){ViewGroup g=(ViewGroup)v;for(int i=0;i<g.getChildCount();i++){WebView w=find(g.getChildAt(i));if(w!=null)return w;}}
  return null;
 }
 private boolean trusted(){try{
   if(web==null)return false;Uri u=Uri.parse(web.getUrl());
   return u!=null && "https".equalsIgnoreCase(u.getScheme()) &&
     "familyjourney.local".equalsIgnoreCase(u.getHost()) && (u.getPort()==-1||u.getPort()==443);
  }catch(Exception e){return false;}}
 private void attach(){
  if(isFinishing()||isDestroyed())return;
  WebView w=find(getWindow().getDecorView());if(w==null)return;
  if(w!=web){web=w;interfaceAdded=false;reloadIssued=false;} trustedPage=trusted();
  if(!interfaceAdded){w.addJavascriptInterface(new LocalBridge(),"MoaLocalAudio");interfaceAdded=true;}
  // Android addJavascriptInterface normally becomes visible after navigation.
  main.postDelayed(()->{
   if(web!=w||reloadIssued||!trusted())return;
   w.evaluateJavascript("!!window.MoaLocalAudio",result->{
    if(web==w&&!reloadIssued&&"false".equals(result)&&trusted()){
      reloadIssued=true;w.reload();
    }
   });
  },400);
 }
 private void send(String event,String message){try{
  JSONObject o=new JSONObject().put("event",event).put("message",message==null?"":message);
  String code="window.__moaNativeAudioEvent&&window.__moaNativeAudioEvent("+o.toString()+")";
  if(web!=null)web.evaluateJavascript(code,null);
 }catch(Exception ignored){}}
 private void speechEvent(String token,String payload,String phase){
  if(web==null)return;
  String code="window.__moaVoiceNativeResult&&window.__moaVoiceNativeResult("+JSONObject.quote(token)+","+JSONObject.quote(payload==null?"":payload)+","+JSONObject.quote(phase)+")";
  web.evaluateJavascript(code,null);
 }
 private File dayDir(String day){File d=new File(getFilesDir(),"moa-original-audio/"+day);if(!d.exists())d.mkdirs();return d;}
 private void record(String day){
  if(!trusted()||!validDay(day)){send("record_error","내부 일기 날짜가 유효하지 않습니다.");return;}
  if(recorder!=null){send("record_error","이미 녹음 중입니다.");return;}
  cancelSpeech();
  File f=new File(dayDir(day),System.currentTimeMillis()+"-"+UUID.randomUUID().toString().replace("-","")+".m4a");
  MediaRecorder r=null;
  try{
   r=new MediaRecorder();r.setAudioSource(MediaRecorder.AudioSource.MIC);
   r.setOutputFormat(MediaRecorder.OutputFormat.MPEG_4);r.setAudioEncoder(MediaRecorder.AudioEncoder.AAC);
   r.setAudioEncodingBitRate(96000);r.setAudioSamplingRate(44100);r.setOutputFile(f.getAbsolutePath());
   r.prepare();r.start();recorder=r;currentFile=f;recordStart=System.currentTimeMillis();recordDay=day;
   send("record_started","녹음 중입니다. 종료·저장을 눌러 주세요.");
  }catch(Exception e){
   try{if(r!=null)r.release();}catch(Exception ignored){}
   if(f.exists())f.delete();
   recorder=null;currentFile=null;send("record_error","Android 녹음 시작 실패: "+e.getClass().getSimpleName()+": "+e.getMessage());
  }
 }
 private void stopRecord(){
  MediaRecorder r=recorder;File f=currentFile;
  recorder=null;currentFile=null;
  if(r==null){send("record_error","진행 중인 녹음이 없습니다.");return;}
  boolean valid=false;try{r.stop();valid=f!=null&&f.exists()&&f.length()>0;}catch(RuntimeException e){send("record_error","녹음 종료 실패: "+e.getMessage());}
  finally{try{r.reset();r.release();}catch(Exception ignored){}}
  if(!valid){if(f!=null)f.delete();send("record_error","음성파일이 비어 저장하지 못했습니다.");return;}
  send("record_saved","날짜별 음성파일 저장 완료 · "+((System.currentTimeMillis()-recordStart)/1000)+"초");
 }
 private void play(String day,String id){
  if(!validDay(day)||!validId(id)||!trusted())return;
  File f=new File(dayDir(day),id);if(!f.exists())return;
  try{
   if(player!=null){player.stop();player.release();player=null;}
   MediaPlayer p=new MediaPlayer();p.setDataSource(f.getAbsolutePath());
   p.setOnCompletionListener(mp->{mp.release();if(player==mp)player=null;send("play_finished","재생 완료");});
   p.prepare();p.start();player=p;send("play_started","녹음 재생 중");
  }catch(Exception e){send("play_error","재생 실패: "+e.getMessage());}
 }
 private void startSpeech(String token){
  if(!trusted()||token==null||token.length()>128)return;
  cancelSpeech();recognitionToken=token;
  if(!SpeechRecognizer.isRecognitionAvailable(this)){speechEvent(token,"기기 음성인식 서비스가 없습니다.","error");speechEvent(token,"","finished");return;}
  try{
   recognizer=SpeechRecognizer.createSpeechRecognizer(this);
   recognizer.setRecognitionListener(new RecognitionListener(){
    public void onReadyForSpeech(Bundle params){speechEvent(token,"","listening");}
    public void onBeginningOfSpeech(){}
    public void onRmsChanged(float rms){}
    public void onBufferReceived(byte[] buf){}
    public void onEndOfSpeech(){}
    public void onError(int error){speechEvent(token,"음성 인식 오류 "+error,"error");speechEvent(token,"","finished");cancelSpeech();}
    private void publish(Bundle b,String phase){
     ArrayList<String> a=b==null?null:b.getStringArrayList(SpeechRecognizer.RESULTS_RECOGNITION);
     if(a!=null&&!a.isEmpty())speechEvent(token,a.get(0),phase);
    }
    public void onResults(Bundle results){publish(results,"success");speechEvent(token,"","finished");cancelSpeech();}
    public void onPartialResults(Bundle partial){publish(partial,"partial");}
    public void onEvent(int event,Bundle b){}
   });
   Intent i=new Intent(RecognizerIntent.ACTION_RECOGNIZE_SPEECH);
   i.putExtra(RecognizerIntent.EXTRA_LANGUAGE_MODEL,RecognizerIntent.LANGUAGE_MODEL_FREE_FORM);
   i.putExtra(RecognizerIntent.EXTRA_LANGUAGE,"ko-KR");i.putExtra(RecognizerIntent.EXTRA_PARTIAL_RESULTS,true);
   recognizer.startListening(i);
  }catch(Exception e){speechEvent(token,"음성 인식 시작 실패: "+e.getMessage(),"error");speechEvent(token,"","finished");cancelSpeech();}
 }
 private void cancelSpeech(){if(recognizer!=null){try{recognizer.cancel();recognizer.destroy();}catch(Exception ignored){}recognizer=null;}recognitionToken="";}
 @Override public void onRequestPermissionsResult(int code,String[] permissions,int[] results){
  super.onRequestPermissionsResult(code,permissions,results);
  if(code==MIC_REQUEST){
   boolean ok=results.length>0&&results[0]==PackageManager.PERMISSION_GRANTED;
   String d=pendingDay,t=pendingSpeech;pendingDay="";pendingSpeech="";
   if(ok){if(!d.isEmpty())record(d);else if(!t.isEmpty())startSpeech(t);}
   else{if(!d.isEmpty())send("record_error","마이크 권한이 거부되었습니다.");
        if(!t.isEmpty()){speechEvent(t,"마이크 권한이 거부되었습니다.","permission");speechEvent(t,"","finished");}}
  }
 }
 @Override protected void onPause(){if(recorder!=null)stopRecord();cancelSpeech();super.onPause();}
 @Override protected void onDestroy(){if(recorder!=null)stopRecord();cancelSpeech();if(player!=null){try{player.release();}catch(Exception ignored){}player=null;}super.onDestroy();}
 public final class LocalBridge {
  @JavascriptInterface public void recordStart(String day){runOnUiThread(()->{
   if(!trusted()||!validDay(day))return;
   if(checkSelfPermission(Manifest.permission.RECORD_AUDIO)!=PackageManager.PERMISSION_GRANTED){pendingDay=day;requestPermissions(new String[]{Manifest.permission.RECORD_AUDIO},MIC_REQUEST);}
   else record(day);
  });}
  @JavascriptInterface public void recordStop(){runOnUiThread(()->{if(trusted())stopRecord();});}
  @JavascriptInterface public void speechStart(String token){runOnUiThread(()->{
   if(!trusted())return;
   if(checkSelfPermission(Manifest.permission.RECORD_AUDIO)!=PackageManager.PERMISSION_GRANTED){pendingSpeech=token;requestPermissions(new String[]{Manifest.permission.RECORD_AUDIO},MIC_REQUEST);}
   else startSpeech(token);
  });}
  @JavascriptInterface public void speechStop(String token){runOnUiThread(()->{if(recognizer!=null)recognizer.stopListening();});}
  @JavascriptInterface public void speechCancel(){runOnUiThread(()->cancelSpeech());}
  @JavascriptInterface public String list(String day){
   JSONArray a=new JSONArray();if(!trustedPage||!validDay(day))return a.toString();
   File[] files=dayDir(day).listFiles();if(files==null)return a.toString();
   java.util.Arrays.sort(files,(l,r)->Long.compare(r.lastModified(),l.lastModified()));
   for(File f:files)if(f.isFile()&&validId(f.getName())){
    try{a.put(new JSONObject().put("id",f.getName()).put("bytes",f.length()).put("time",f.lastModified()).put("day",day));}catch(Exception ignored){}
   }
   return a.toString();
  }
  @JavascriptInterface public void play(String day,String id){runOnUiThread(()->MoaMomentAudioHostActivity.this.play(day,id));}
  @JavascriptInterface public void delete(String day,String id){runOnUiThread(()->{if(!trusted()||!validDay(day)||!validId(id))return;
    File f=new File(dayDir(day),id);send("delete",f.delete()?"삭제되었습니다.":"삭제하지 못했습니다.");});}
 }
}
