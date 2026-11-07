package com.juhyeon.familyjourney;

import android.Manifest;
import android.app.Activity;
import android.app.AlertDialog;
import android.app.NotificationManager;
import android.content.pm.PackageManager;
import android.graphics.Color;
import android.graphics.Typeface;
import android.media.AudioFormat;
import android.media.MediaCodec;
import android.media.MediaExtractor;
import android.media.MediaFormat;
import android.media.MediaPlayer;
import android.media.MediaRecorder;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.os.ParcelFileDescriptor;
import android.os.SystemClock;
import android.speech.RecognitionListener;
import android.speech.RecognizerIntent;
import android.speech.SpeechRecognizer;
import android.content.Intent;
import android.content.ContentResolver;
import android.content.SharedPreferences;
import android.database.Cursor;
import android.net.Uri;
import android.provider.DocumentsContract;
import android.provider.OpenableColumns;
import java.io.InputStream;
import java.io.IOException;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.util.Arrays;
import java.util.Comparator;
import java.util.Iterator;
import java.security.MessageDigest;
import java.util.concurrent.atomic.AtomicBoolean;
import android.view.View;
import android.view.WindowInsets;
import android.content.res.ColorStateList;
import android.view.WindowManager;
import android.view.inputmethod.InputMethodManager;
import android.widget.Button;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.ScrollView;
import android.widget.TextView;
import android.widget.Toast;
import org.json.JSONObject;
import org.json.JSONArray;
import java.io.File;
import java.io.OutputStream;
import java.nio.ByteBuffer;
import java.nio.ByteOrder;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.Locale;
import java.util.UUID;

/**
 * R161 feature-only native capture memo activity.
 * Manifest activity-alias keeps the original explicit notification component name
 * while R159's existing M4A recorder, classes4.dex, classes6.dex and diary JS
 * remain byte-identical. This activity writes M4A in the exact R159 day folder.
 *
 * Separate capture paths:
 *  - "음성으로 말하기": original MoaMomentVoice, text only.
 *  - "음성 녹음": MediaRecorder -> M4A -> source-file SpeechRecognizer -> note.
 * The recognizer MAY ignore EXTRA_AUDIO_SOURCE; show reviewable draft only.
 */
public final class MoaMomentMemoRecorderActivity extends Activity {
  private static final int MIC=7801, RECORD_MIC=7802, ARCHIVE_EXPORT=7865, ARCHIVE_IMPORT=7866;
  private final Handler main=new Handler(Looper.getMainLooper());
  private String id,day,voiceId="";
  private EditText text;
  private TextView status;
  private Button micButton,recButton,playButton,saveButton;
  private MoaMomentVoice speech;
  private MediaRecorder recorder;
  private MediaPlayer player;
  private File recordingFile;
  private long recordStarted;
  private SpeechRecognizer fileRecognizer;
  private ParcelFileDescriptor readPipe,writePipe;
  private volatile boolean fileBusy=false;
  private String fileToken="";
  private final ArrayList<String> segments=new ArrayList<>();
  private boolean finishing=false, recognitionDelivered=false, windowOpened=false;
  private String previewBase="",previewShown="";
  private String playingVoice="";
  private final Runnable recordTicker=new Runnable(){
    @Override public void run(){
      if(recorder==null)return;
      long seconds=Math.max(0,(SystemClock.elapsedRealtime()-recordStarted)/1000);
      recButton.setText("■ 녹음 종료  "+clock(seconds));
      main.postDelayed(this,300);
    }
  };
  private final Runnable playTicker=new Runnable(){
    @Override public void run(){
      if(player==null||playButton==null)return;
      try{
        int pos=Math.max(0,player.getCurrentPosition()/1000),dur=Math.max(0,player.getDuration()/1000);
        if(player.isPlaying()){
          playButton.setText("Ⅱ 일시정지  "+clock(pos)+"/"+clock(dur));
          main.postDelayed(this,350);
        }else playButton.setText("▶ 이어듣기  "+clock(pos)+"/"+clock(dur));
      }catch(Exception ignored){}
    }
  };
  private static String clock(long sec){return String.format(Locale.US,"%02d:%02d",sec/60,sec%60);}
  private static String joined(String prefix,String value){return prefix==null||prefix.isEmpty()?value:prefix+" "+value;}
  private void recordStyle(boolean active){
    if(recButton==null)return;
    recButton.setAllCaps(false);
    recButton.setBackgroundTintList(ColorStateList.valueOf(active?0xffb3263c:0xfff4e6e9));
    recButton.setTextColor(active?Color.WHITE:0xff8f2138);
  }
  private void playStyle(boolean active){
    if(playButton==null)return;
    playButton.setAllCaps(false);
    playButton.setBackgroundTintList(ColorStateList.valueOf(active?0xff244d61:0xffebf0f3));
    playButton.setTextColor(active?Color.WHITE:0xff183749);
  }
  private void discardPreview(){
    if(!previewShown.isEmpty()&&text!=null){
      String shown=joined(previewBase,previewShown);
      if(text.getText().toString().trim().equals(shown))text.setText(previewBase);
    }
    previewShown="";
  }
  private void showPreview(String partial){
    if(partial==null||partial.trim().length()<2||text==null)return;
    String v=partial.trim(),now=text.getText().toString().trim();
    if((previewShown.isEmpty()&&now.equals(previewBase)) ||
       (!previewShown.isEmpty()&&now.equals(joined(previewBase,previewShown)))){
      previewShown=v;
      text.setText(joined(previewBase,v));
      text.setSelection(text.length());
      status("녹음 텍스트 인식 중… 임시 미리보기, 완료되면 자동 저장돼요.");
    }
  }
  private final Runnable timeout=()->{if(fileBusy){discardPreview();status("자동 텍스트 변환 시간이 초과됐어. 녹음 원본은 보존됐어.");cancelFileRecognition();}};

  private int dp(int n){return (int)(getResources().getDisplayMetrics().density*n+0.5f);}
  private void status(String s){if(status!=null)status.setText(s);}
  private JSONObject current(){
    try{return new JSONObject(MoaMomentCaptureService.prefs(this).getString("m:"+id,"{}"));}
    catch(Exception ex){return new JSONObject();}
  }
  private boolean saveNote(boolean automated){
    try{
      String prior=MoaMomentCaptureService.prefs(this).getString("m:"+id,"");
      if(prior.isEmpty()){status("촬영 기록을 찾지 못했어.");return false;}
      JSONObject data=new JSONObject(prior),values=current();
      String note=text.getText().toString().trim();
      if(note.isEmpty()){if(!automated)Toast.makeText(this,"입력한 메모가 없어요.",Toast.LENGTH_SHORT).show();return false;}
      data.put("note",note).put("memoSaved",true).put("updatedAt",System.currentTimeMillis());
      if(!voiceId.isEmpty()){
        data.put("voiceFileId",voiceId).put("voiceDay",day);
        data.put("voiceAutoTranscript",values.optString("voiceAutoTranscript",""));
      }
      if(!MoaMomentCaptureService.prefs(this).edit().putString("m:"+id,data.toString()).commit())
        throw new IllegalStateException("메모 저장 실패");
      MoaMomentDirectDiaryStore.requestSync(this);
      if(!automated){
        try{NotificationManager nm=getSystemService(NotificationManager.class);
          if(nm!=null)nm.cancel(43000+(id.hashCode()&0x7fff));}catch(Exception ignored){}
        Toast.makeText(this,"메모 저장 완료 · 모아 일기 동기화 대기",Toast.LENGTH_SHORT).show();
        finishing=true;finish();
      }
      return true;
    }catch(Exception ex){status("메모 저장 실패: "+ex.getMessage());return false;}
  }
  private void rememberVoice(String name,long size){
    try{
      String prev=MoaMomentCaptureService.prefs(this).getString("m:"+id,"");
      if(prev.isEmpty())throw new IllegalStateException("촬영 기록 없음");
      JSONObject j=new JSONObject(prev);
      JSONArray arr=j.optJSONArray("voiceRecords");
      if(arr==null)arr=new JSONArray();
      JSONObject link=new JSONObject().put("id",name).put("day",day)
        .put("photoId",id).put("bytes",size).put("recordedAt",System.currentTimeMillis())
        .put("status","transcript_pending");
      arr.put(link);
      j.put("voiceRecords",arr).put("voiceFileId",name).put("voiceDay",day)
        .put("voiceAutoStatus","pending");
      if(!MoaMomentCaptureService.prefs(this).edit().putString("m:"+id,j.toString()).commit())
        throw new IllegalStateException("음성 연결 메타데이터 저장 실패");
    }catch(Exception ex){status("원본 음성은 저장됐지만 사진 연결 정보 저장 실패: "+ex.getMessage());}
  }
  @Override protected void onCreate(Bundle saved){
    super.onCreate(saved);
    id=getIntent()==null?null:getIntent().getStringExtra("id");
    if(id==null||!id.matches("v?\\d{1,19}")){finish();return;}
    JSONObject meta=current();
    long at=meta.optLong("at",meta.optLong("capturedAt",System.currentTimeMillis()));
    day=new SimpleDateFormat("yyyy-MM-dd",Locale.US).format(new Date(at));
    voiceId=meta.optString("voiceFileId","");
    android.app.KeyguardManager kg=getSystemService(android.app.KeyguardManager.class);
    if(kg!=null&&kg.isKeyguardLocked())setShowWhenLocked(true);
    LinearLayout body=new LinearLayout(this);
    body.setPadding(dp(16),dp(14),dp(16),dp(12));
    body.setOrientation(LinearLayout.VERTICAL);body.setBackgroundColor(Color.WHITE);
    TextView title=new TextView(this);
    title.setText("방금 찍은 사진·영상 · 모아 시간대별 메모");
    title.setTextColor(0xff243140);title.setTextSize(20);title.setTypeface(null,Typeface.BOLD);body.addView(title);
    TextView explain=new TextView(this);
    explain.setText("기억나는 말을 적거나 음성으로 말해 주세요. 모아를 다시 열면 해당 촬영 시간대에 동기화됩니다.");
    explain.setTextColor(0xff39495a);explain.setTextSize(14);
    explain.setPadding(0,dp(12),0,dp(10));body.addView(explain);
    text=new EditText(this);text.setMinLines(4);text.setGravity(48);
    text.setHint("지금 무슨 일이 있었나요?");text.setTextSize(17);
    text.setText(meta.optString("note",""));body.addView(text);
    status=new TextView(this);status.setTextColor(0xff395a58);status.setTextSize(13);
    status.setPadding(0,dp(10),0,0);body.addView(status);
    status(voiceId.isEmpty()?"음성 녹음은 원본 파일과 글을 함께 남겨요.":"이 사진에 연결된 녹음이 있어요.");
    Button archiveButton=new Button(this);
    archiveButton.setText("녹음 원본 외부 보관 · 복원");
    archiveButton.setTextSize(13);archiveButton.setAllCaps(false);
    archiveButton.setOnClickListener(v->showVoiceArchiveMenu());
    body.addView(archiveButton,new LinearLayout.LayoutParams(-1,dp(44)));

    LinearLayout root=new LinearLayout(this);root.setOrientation(LinearLayout.VERTICAL);
    root.setBackgroundColor(Color.WHITE);
    ScrollView scroll=new ScrollView(this);scroll.setFillViewport(true);
    scroll.addView(body);root.addView(scroll,new LinearLayout.LayoutParams(-1,0,1));
    LinearLayout footer=new LinearLayout(this);footer.setOrientation(LinearLayout.VERTICAL);
    footer.setBackgroundColor(0xfffaf8f7);
    footer.setPadding(dp(12),dp(6),dp(12),dp(9));
    LinearLayout row1=new LinearLayout(this);
    micButton=new Button(this);micButton.setText("🎙 음성으로 말하기");
    micButton.setOnClickListener(v->startDictation());
    Button clear=new Button(this);clear.setText("내용 전체 지우기");
    clear.setOnClickListener(v->new AlertDialog.Builder(this)
      .setTitle("현재 메모 글자 모두 지우기")
      .setMessage("지금 입력된 글자만 지울까요? 원본 사진과 기존 녹음 파일은 삭제하지 않아요.")
      .setNegativeButton("취소",null)
      .setPositiveButton("모두 지우기",(a,b)->{text.setText("");text.requestFocus();}).show());
    row1.addView(micButton,new LinearLayout.LayoutParams(0,dp(54),1));
    row1.addView(clear,new LinearLayout.LayoutParams(0,dp(54),1));
    footer.addView(row1);
    LinearLayout row2=new LinearLayout(this);
    recButton=new Button(this);recButton.setText("● 음성 녹음");
    recordStyle(false);
    recButton.setOnClickListener(v->{if(recorder==null)startRecording();else stopRecording();});
    playButton=new Button(this);playButton.setText("▶ 녹음 듣기");
    playStyle(false);
    playButton.setEnabled(!voiceId.isEmpty());
    playButton.setOnClickListener(v->playVoice());
    row2.addView(recButton,new LinearLayout.LayoutParams(0,dp(54),1));
    row2.addView(playButton,new LinearLayout.LayoutParams(0,dp(54),1));
    footer.addView(row2);
    saveButton=new Button(this);saveButton.setText("모아 일기에 메모 저장");
    saveButton.setOnClickListener(v->{
      if(recorder!=null){
        stopRecording();
        status("녹음 원본을 저장했어. 자동 글 변환을 확인한 뒤 메모 저장을 눌러줘.");
        return;
      }
      if(fileBusy){status("녹음 텍스트 변환이 진행 중이야. 원본은 이미 저장됐어.");return;}
      saveNote(false);
    });
    footer.addView(saveButton,new LinearLayout.LayoutParams(-1,dp(54)));
    root.addView(footer,new LinearLayout.LayoutParams(-1,-2));
    setContentView(root);
    // Android 17/One UI edge-to-edge may not resize a bottom-aligned footer
    // for the Samsung IME. Apply the IME inset to the WHOLE weighted layout
    // instead, keeping both rows and Save above the keyboard.
    if(android.os.Build.VERSION.SDK_INT>=30){
      getWindow().setDecorFitsSystemWindows(false);
      root.setOnApplyWindowInsetsListener((v,insets)->{
        int top=insets.getInsets(WindowInsets.Type.statusBars()).top;
        int nav=insets.getInsets(WindowInsets.Type.navigationBars()).bottom;
        int ime=insets.getInsets(WindowInsets.Type.ime()).bottom;
        v.setPadding(0,top,0,Math.max(nav,ime));
        return insets;
      });
      root.requestApplyInsets();
    }
    getWindow().setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_ADJUST_RESIZE|
      WindowManager.LayoutParams.SOFT_INPUT_STATE_ALWAYS_VISIBLE);
    text.requestFocus();
  }

  @Override public void onWindowFocusChanged(boolean focused){
    super.onWindowFocusChanged(focused);
    if(focused&&!windowOpened&&text!=null){
      windowOpened=true;
      main.postDelayed(()->{if(!isFinishing()&&text!=null){
        InputMethodManager imm=getSystemService(InputMethodManager.class);
        if(imm!=null)imm.showSoftInput(text,InputMethodManager.SHOW_IMPLICIT);
      }},180);
    }
  }
  private void startDictation(){
    if(recorder!=null){status("먼저 음성 녹음을 종료해 줘.");return;}
    if(fileBusy){status("저장된 파일의 텍스트 변환을 먼저 완료해 줘.");return;}
    if(!MoaMomentVoice.hasPermission(this)){
      requestPermissions(new String[]{Manifest.permission.RECORD_AUDIO},MIC);return;
    }
    if(speech!=null){speech.stop();speech=null;}
    speech=new MoaMomentVoice(this,new MoaMomentVoice.Listener(){
      @Override public void onListening(){micButton.setText("듣는 중…");micButton.setEnabled(false);}
      @Override public void onText(String value){appendText(value,false);}
      @Override public void onFailure(String msg){status(msg);}
      @Override public void onFinished(){micButton.setText("🎙 음성으로 말하기");micButton.setEnabled(true);}
    });
    speech.start();
  }
  private File voiceFile(String file){return new File(new File(getFilesDir(),"moa-original-audio/"+day),file);}
  private void startRecording(){
    if(fileBusy){status("이전 녹음 텍스트 변환을 완료하고 다시 녹음해 줘.");return;}
    if(checkSelfPermission(Manifest.permission.RECORD_AUDIO)!=PackageManager.PERMISSION_GRANTED){
      requestPermissions(new String[]{Manifest.permission.RECORD_AUDIO},RECORD_MIC);return;
    }
    if(speech!=null){speech.stop();speech=null;micButton.setText("🎙 음성으로 말하기");micButton.setEnabled(true);}
    File dir=new File(getFilesDir(),"moa-original-audio/"+day);if(!dir.exists()&&!dir.mkdirs()){status("음성 저장 폴더 생성 실패");return;}
    File f=new File(dir,System.currentTimeMillis()+"-"+UUID.randomUUID().toString().replace("-","")+".m4a");
    MediaRecorder r=null;
    try{
      r=new MediaRecorder();r.setAudioSource(MediaRecorder.AudioSource.MIC);
      r.setOutputFormat(MediaRecorder.OutputFormat.MPEG_4);
      r.setAudioEncoder(MediaRecorder.AudioEncoder.AAC);
      r.setAudioEncodingBitRate(96000);r.setAudioSamplingRate(44100);
      r.setOutputFile(f.getAbsolutePath());r.prepare();r.start();
      recorder=r;recordingFile=f;recordStarted=SystemClock.elapsedRealtime();
      recordStyle(true);recButton.setText("■ 녹음 종료  00:00");
      main.removeCallbacks(recordTicker);main.postDelayed(recordTicker,300);
      micButton.setEnabled(false);playButton.setEnabled(false);
      status("● 녹음 중  ·  원본 M4A 저장 후 자동으로 텍스트를 인식해요.");
    }catch(Exception ex){
      try{if(r!=null)r.release();}catch(Exception ignored){}
      if(f.exists())f.delete();
      recorder=null;recordingFile=null;
      main.removeCallbacks(recordTicker);recordStyle(false);
      recButton.setText("● 음성 녹음");playButton.setEnabled(!voiceId.isEmpty());
      status("음성 녹음 시작 실패: "+ex.getMessage());
    }
  }
  private void stopRecording(){
    MediaRecorder r=recorder;File f=recordingFile;
    recorder=null;recordingFile=null;
    main.removeCallbacks(recordTicker);recordStyle(false);
    recButton.setText("● 새 녹음");micButton.setEnabled(true);playButton.setEnabled(!voiceId.isEmpty());
    if(r==null)return;
    boolean good=false;
    try{r.stop();good=f!=null&&f.isFile()&&f.length()>0;}catch(Exception ex){status("녹음 종료 실패: "+ex.getMessage());}
    finally{try{r.reset();r.release();}catch(Exception ignored){}}
    if(!good){if(f!=null)f.delete();status("녹음 파일이 비어 있어 저장하지 않았어.");return;}
    voiceId=f.getName();
    rememberVoice(voiceId,f.length());
    playButton.setEnabled(true);
    playButton.setText("▶ 원본 듣기");playStyle(false);
    status("녹음 원본 저장 완료 · "+Math.max(1,(SystemClock.elapsedRealtime()-recordStarted)/1000)+"초. 녹음 텍스트 자동 변환 중…");
    startFileSpeech(f);
  }
  private void playVoice(){
    File f=voiceFile(voiceId);
    if(!f.isFile()){status("녹음 파일을 찾지 못했어.");return;}
    try{
      if(player!=null&&voiceId.equals(playingVoice)){
        if(player.isPlaying()){
          player.pause();main.removeCallbacks(playTicker);
          playStyle(false);
          playButton.setText("▶ 이어듣기  "+clock(player.getCurrentPosition()/1000)+"/"+clock(player.getDuration()/1000));
          status("원본 녹음 일시정지 · 다시 누르면 이어 재생돼요.");
        }else{
          player.start();playStyle(true);
          main.removeCallbacks(playTicker);main.post(playTicker);
          status("원본 녹음 재생 중");
        }
        return;
      }
      main.removeCallbacks(playTicker);
      if(player!=null){player.release();player=null;}
      MediaPlayer p=new MediaPlayer();
      p.setDataSource(f.getAbsolutePath());
      p.setOnCompletionListener(mp->{
        main.removeCallbacks(playTicker);
        try{mp.release();}catch(Exception ignored){}
        if(player==mp)player=null;
        playingVoice="";playStyle(false);
        if(playButton!=null)playButton.setText("▶ 다시 듣기");
        status("원본 녹음 재생 완료");
      });
      p.prepare();player=p;playingVoice=voiceId;p.start();
      playStyle(true);main.post(playTicker);status("원본 녹음 재생 중");
    }catch(Exception ex){
      main.removeCallbacks(playTicker);playStyle(false);
      status("재생 실패: "+ex.getMessage());
    }
  }
  private void appendText(String recognized,boolean fromRecording){
    if(recognized==null||recognized.trim().isEmpty())return;
    String previous=text.getText().toString().trim();
    // A partial result may already be displayed. Replace only our own
    // unedited provisional suffix, never overwrite user-typed content.
    if(fromRecording&&!previewShown.isEmpty()&&previous.equals(joined(previewBase,previewShown)))previous=previewBase;
    String next=joined(previous,recognized.trim());
    text.setText(next);text.setSelection(text.length());
    previewShown="";
    if(fromRecording){
      try{
        String prior=MoaMomentCaptureService.prefs(this).getString("m:"+id,"");
        if(!prior.isEmpty()){
          JSONObject j=new JSONObject(prior);
          j.put("voiceAutoTranscript",recognized.trim())
            .put("voiceAutoStatus","review").put("voiceFileId",voiceId)
            .put("voiceDay",day);
          JSONArray records=j.optJSONArray("voiceRecords");
          if(records!=null)for(int k=0;k<records.length();k++){
            JSONObject item=records.optJSONObject(k);
            if(item!=null&&voiceId.equals(item.optString("id"))&&day.equals(item.optString("day"))){
              item.put("autoTranscript",recognized.trim()).put("autoStatus","review")
                .put("recognizedAt",System.currentTimeMillis());
            }
          }
          MoaMomentCaptureService.prefs(this).edit().putString("m:"+id,j.toString()).commit();
        }
      }catch(Exception ignored){}
      saveNote(true);
      status("녹음 글 변환 초안을 메모에 추가·저장했어. 원본을 들으며 내용을 확인해 줘.");
    }
  }
  private void startFileSpeech(File source){
    if(fileBusy){status("다른 녹음의 자동 텍스트 변환이 진행 중이야.");return;}
    if(android.os.Build.VERSION.SDK_INT<33||!SpeechRecognizer.isRecognitionAvailable(this)){
      status("원본 M4A는 저장됐어. 기기의 파일 음성인식이 지원되지 않아 글은 직접 입력할 수 있어.");return;
    }
    fileBusy=true;recognitionDelivered=false;segments.clear();
    previewBase=text.getText().toString().trim();previewShown="";
    recButton.setEnabled(false);saveButton.setEnabled(false);
    status("녹음 원본 저장 완료 · 텍스트 인식 시작 중…");
    final String token=source.getName();fileToken=token;
    try{
      ParcelFileDescriptor[] pair=ParcelFileDescriptor.createPipe();
      readPipe=pair[0];writePipe=pair[1];
      fileRecognizer=SpeechRecognizer.createSpeechRecognizer(this);
      fileRecognizer.setRecognitionListener(new RecognitionListener(){
        @Override public void onReadyForSpeech(Bundle b){}
        @Override public void onBeginningOfSpeech(){}
        @Override public void onRmsChanged(float v){}
        @Override public void onBufferReceived(byte[] b){}
        @Override public void onEndOfSpeech(){}
        @Override public void onPartialResults(Bundle b){
          if(!token.equals(fileToken)||recognitionDelivered)return;
          ArrayList<String> list=b==null?null:b.getStringArrayList(SpeechRecognizer.RESULTS_RECOGNITION);
          if(list!=null&&!list.isEmpty())showPreview(list.get(0));
        }
        @Override public void onEvent(int type,Bundle b){}
        @Override public void onError(int err){
          if(!token.equals(fileToken))return;
          discardPreview();
          status("M4A 원본은 저장했어. 음성 텍스트 인식 오류("+err+") · 다시 들으며 입력할 수 있어.");
          cancelFileRecognition();
        }
        @Override public void onResults(Bundle b){
          if(!token.equals(fileToken)||recognitionDelivered)return;
          ArrayList<String> list=b==null?null:b.getStringArrayList(SpeechRecognizer.RESULTS_RECOGNITION);
          String s=list!=null&&!list.isEmpty()?list.get(0):String.join(" ",segments);
          finishTranscript(token,s);
        }
        @Override public void onSegmentResults(Bundle b){
          if(!token.equals(fileToken))return;
          ArrayList<String> list=b==null?null:b.getStringArrayList(SpeechRecognizer.RESULTS_RECOGNITION);
          if(list!=null&&!list.isEmpty()){segments.add(list.get(0));showPreview(String.join(" ",segments));}
        }
        @Override public void onEndOfSegmentedSession(){
          if(token.equals(fileToken))finishTranscript(token,String.join(" ",segments));
        }
      });
      Intent intent=new Intent(RecognizerIntent.ACTION_RECOGNIZE_SPEECH);
      intent.putExtra(RecognizerIntent.EXTRA_LANGUAGE_MODEL,RecognizerIntent.LANGUAGE_MODEL_FREE_FORM);
      intent.putExtra(RecognizerIntent.EXTRA_LANGUAGE,"ko-KR");
      intent.putExtra(RecognizerIntent.EXTRA_PARTIAL_RESULTS,true);
      intent.putExtra(RecognizerIntent.EXTRA_AUDIO_SOURCE,readPipe);
      intent.putExtra(RecognizerIntent.EXTRA_AUDIO_SOURCE_CHANNEL_COUNT,1);
      intent.putExtra(RecognizerIntent.EXTRA_AUDIO_SOURCE_ENCODING,AudioFormat.ENCODING_PCM_16BIT);
      intent.putExtra(RecognizerIntent.EXTRA_AUDIO_SOURCE_SAMPLING_RATE,16000);
      intent.putExtra(RecognizerIntent.EXTRA_SEGMENTED_SESSION,RecognizerIntent.EXTRA_AUDIO_SOURCE);
      fileRecognizer.startListening(intent);
      main.postDelayed(timeout,180000);
      final ParcelFileDescriptor output=writePipe;
      new Thread(()->{
        try{streamPcm16k(source,output,token);}
        catch(Exception ex){runOnUiThread(()->{
          if(token.equals(fileToken)){status("원본은 저장됐지만 음성 디코딩 실패: "+ex.getMessage());cancelFileRecognition();}
        });}
      },"moa-r161-file-to-text").start();
    }catch(Exception ex){status("원본은 저장됐지만 텍스트 변환 시작 실패: "+ex.getMessage());cancelFileRecognition();}
  }
  private void finishTranscript(String token,String content){
    if(!token.equals(fileToken)||recognitionDelivered)return;
    recognitionDelivered=true;
    String recognized=content==null?"":content.trim();
    if(recognized.isEmpty()){
      discardPreview();status("원본 녹음은 저장됐어. 인식된 텍스트는 없어.");
    }else appendText(recognized,true);
    cancelFileRecognition();
  }
  private void cancelFileRecognition(){
    main.removeCallbacks(timeout);fileBusy=false;fileToken="";
    if(recButton!=null)recButton.setEnabled(true);
    if(saveButton!=null)saveButton.setEnabled(true);
    try{if(fileRecognizer!=null){fileRecognizer.cancel();fileRecognizer.destroy();}}catch(Exception ignored){}
    fileRecognizer=null;
    try{if(readPipe!=null)readPipe.close();}catch(Exception ignored){}
    try{if(writePipe!=null)writePipe.close();}catch(Exception ignored){}
    readPipe=null;writePipe=null;segments.clear();
  }
  private void streamPcm16k(File source,ParcelFileDescriptor fd,String token)throws Exception{
    MediaExtractor extractor=new MediaExtractor();MediaCodec decoder=null;
    try(OutputStream out=new ParcelFileDescriptor.AutoCloseOutputStream(fd)){
      extractor.setDataSource(source.getAbsolutePath());
      int track=-1;MediaFormat format=null;
      for(int i=0;i<extractor.getTrackCount();i++){
        MediaFormat m=extractor.getTrackFormat(i);String mime=m.getString(MediaFormat.KEY_MIME);
        if(mime!=null&&mime.startsWith("audio/")){track=i;format=m;break;}
      }
      if(track<0||format==null)throw new java.io.IOException("M4A 오디오 트랙 없음");
      extractor.selectTrack(track);
      decoder=MediaCodec.createDecoderByType(format.getString(MediaFormat.KEY_MIME));
      decoder.configure(format,null,null,0);decoder.start();
      MediaCodec.BufferInfo info=new MediaCodec.BufferInfo();
      boolean inputDone=false,outputDone=false;
      int rate=format.containsKey(MediaFormat.KEY_SAMPLE_RATE)?format.getInteger(MediaFormat.KEY_SAMPLE_RATE):44100;
      int channels=format.containsKey(MediaFormat.KEY_CHANNEL_COUNT)?format.getInteger(MediaFormat.KEY_CHANNEL_COUNT):1;
      long accumulator=0,samples=0,begin=SystemClock.elapsedRealtime();
      while(!outputDone&&fileBusy&&token.equals(fileToken)){
        if(!inputDone){
          int idx=decoder.dequeueInputBuffer(12000);
          if(idx>=0){
            ByteBuffer input=decoder.getInputBuffer(idx);input.clear();
            int bytes=extractor.readSampleData(input,0);
            if(bytes<0){decoder.queueInputBuffer(idx,0,0,0,MediaCodec.BUFFER_FLAG_END_OF_STREAM);inputDone=true;}
            else{decoder.queueInputBuffer(idx,0,bytes,extractor.getSampleTime(),0);extractor.advance();}
          }
        }
        int idx=decoder.dequeueOutputBuffer(info,12000);
        if(idx==MediaCodec.INFO_OUTPUT_FORMAT_CHANGED){
          MediaFormat f=decoder.getOutputFormat();
          rate=f.containsKey(MediaFormat.KEY_SAMPLE_RATE)?f.getInteger(MediaFormat.KEY_SAMPLE_RATE):rate;
          channels=f.containsKey(MediaFormat.KEY_CHANNEL_COUNT)?f.getInteger(MediaFormat.KEY_CHANNEL_COUNT):channels;
          int encoding=f.containsKey(MediaFormat.KEY_PCM_ENCODING)?f.getInteger(MediaFormat.KEY_PCM_ENCODING):AudioFormat.ENCODING_PCM_16BIT;
          if(encoding!=AudioFormat.ENCODING_PCM_16BIT)throw new java.io.IOException("PCM 16비트 인코딩 아님");
        }else if(idx>=0){
          ByteBuffer audio=decoder.getOutputBuffer(idx);
          if(audio!=null&&info.size>0){
            audio.position(info.offset);audio.limit(info.offset+info.size);
            audio.order(ByteOrder.LITTLE_ENDIAN);
            int frames=info.size/Math.max(2,channels*2);
            java.io.ByteArrayOutputStream pcm=new java.io.ByteArrayOutputStream(frames*2);
            for(int i=0;i<frames;i++){
              int total=0;for(int ch=0;ch<channels;ch++)total+=audio.getShort();
              short sample=(short)(total/channels);
              accumulator+=16000;
              if(accumulator>=rate){
                accumulator-=rate;pcm.write(sample&255);pcm.write((sample>>>8)&255);samples++;
              }
            }
            byte[] block=pcm.toByteArray();
            if(block.length>0){out.write(block);out.flush();}
            // File input is not a microphone stream: feed buffered PCM up to
            // ~3x real time. The pipe still applies decoder/provider backpressure.
            // Samsung recognition accuracy remains subject to device QA.
            long delay=(samples*1000/16000)/3-(SystemClock.elapsedRealtime()-begin);
            if(delay>15)Thread.sleep(Math.min(delay,160));
          }
          outputDone=(info.flags&MediaCodec.BUFFER_FLAG_END_OF_STREAM)!=0;
          decoder.releaseOutputBuffer(idx,false);
        }
      }
    }finally{
      extractor.release();
      try{if(decoder!=null){decoder.stop();decoder.release();}}catch(Exception ignored){}
    }
  }

  // R165: explicit opt-in and copy-only backup, not a replacement for any R163
  // recorder, transcript, list, player or photo-to-Diary data writer.
  // SAF user-selected documents survive app removal, while app-private M4A stays
  // authoritative until a separately device-verified external-primary migration.
  private static final AtomicBoolean archiveBusy=new AtomicBoolean(false);
  private boolean restoreArchiveRequested=false;
  private void showVoiceArchiveMenu(){
    if(recorder!=null||fileBusy){status("녹음·글 변환 완료 후 음성 보관을 실행해 주세요.");return;}
    new AlertDialog.Builder(this).setTitle("모아 녹음 안전 보관")
      .setMessage("앱 내부 원본은 삭제하지 않고 선택한 외부 폴더로 복사·SHA-256 검증합니다. 녹음 원본과 촬영 메모 연결정보를 백업하며, 앱 내부의 일기·음성 제목 전체 데이터 백업은 아직 별도입니다.\n\n백업에는 원본 용량만큼 추가 공간이 필요합니다.")
      .setPositiveButton("외부 폴더에 백업",(d,w)->chooseVoiceArchive(false))
      .setNeutralButton("녹음 파일 복원",(d,w)->chooseVoiceArchive(true))
      .setNegativeButton("취소",null).show();
  }
  private void chooseVoiceArchive(boolean restore){
    restoreArchiveRequested=restore;
    Intent i=new Intent(Intent.ACTION_OPEN_DOCUMENT_TREE);
    i.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION|
        Intent.FLAG_GRANT_WRITE_URI_PERMISSION|
        Intent.FLAG_GRANT_PERSISTABLE_URI_PERMISSION|
        Intent.FLAG_GRANT_PREFIX_URI_PERMISSION);
    try{startActivityForResult(i,restore?ARCHIVE_IMPORT:ARCHIVE_EXPORT);}
    catch(Exception e){status("폴더 선택 불가: "+e.getMessage());}
  }
  private static final class ArchiveDoc {
    final String name;
    final Uri uri;
    final String type;
    ArchiveDoc(String name,Uri uri,String type){this.name=name;this.uri=uri;this.type=type;}
  }
  private Uri archiveRoot(Uri tree){
    return DocumentsContract.buildDocumentUriUsingTree(tree,DocumentsContract.getTreeDocumentId(tree));
  }
  private ArchiveDoc findArchiveChild(Uri tree,Uri parent,String name)throws Exception{
    Uri childList=DocumentsContract.buildChildDocumentsUriUsingTree(tree,DocumentsContract.getDocumentId(parent));
    String[] cols={DocumentsContract.Document.COLUMN_DOCUMENT_ID,
      DocumentsContract.Document.COLUMN_DISPLAY_NAME,DocumentsContract.Document.COLUMN_MIME_TYPE};
    try(Cursor c=getContentResolver().query(childList,cols,null,null,null)){
      if(c==null)throw new IOException("선택한 폴더를 조회할 수 없습니다");
      while(c.moveToNext()){
        if(name.equals(c.getString(1))){
          return new ArchiveDoc(name,DocumentsContract.buildDocumentUriUsingTree(tree,c.getString(0)),c.getString(2));
        }
      }
    }
    return null;
  }
  private static String sha256(File f)throws Exception{
    MessageDigest md=MessageDigest.getInstance("SHA-256");
    try(InputStream in=new FileInputStream(f)){
      byte[] b=new byte[65536];int n;
      while((n=in.read(b))!=-1)md.update(b,0,n);
    }
    return hex(md.digest());
  }
  private static String hex(byte[] bytes){
    StringBuilder sb=new StringBuilder(bytes.length*2);
    for(byte b:bytes)sb.append(String.format(Locale.US,"%02x",b&255));
    return sb.toString();
  }
  private String hashDocument(Uri uri)throws Exception{
    MessageDigest md=MessageDigest.getInstance("SHA-256");
    try(InputStream in=getContentResolver().openInputStream(uri)){
      if(in==null)throw new IOException("문서를 읽을 수 없습니다");
      byte[] b=new byte[65536];int n;
      while((n=in.read(b))!=-1)md.update(b,0,n);
    }
    return hex(md.digest());
  }
  private byte[] readDocument(Uri doc,int maxBytes)throws Exception{
    try(InputStream in=getContentResolver().openInputStream(doc)){
      if(in==null)throw new IOException("원본 파일 열기 실패");
      java.io.ByteArrayOutputStream buffer=new java.io.ByteArrayOutputStream();
      byte[] b=new byte[32768];int n;long size=0;
      while((n=in.read(b))!=-1){
        size+=n;if(size>maxBytes)throw new IOException("백업 목록 크기 초과");
        buffer.write(b,0,n);
      }
      return buffer.toByteArray();
    }
  }
  private void copy(File src,Uri dest)throws Exception{
    try(InputStream in=new FileInputStream(src);
        OutputStream out=getContentResolver().openOutputStream(dest,"wt")){
      if(out==null)throw new IOException("외부 폴더 쓰기 실패");
      byte[] b=new byte[65536];int n;
      while((n=in.read(b))!=-1)out.write(b,0,n);
      out.flush();
    }
  }
  private void writeDoc(Uri dest,byte[] content)throws Exception{
    try(OutputStream out=getContentResolver().openOutputStream(dest,"wt")){
      if(out==null)throw new IOException("외부 메타데이터 쓰기 실패");
      out.write(content);out.flush();
    }
  }
  private static boolean validArchiveDay(String day){return day!=null&&day.matches("\\d{4}-\\d{2}-\\d{2}");}
  private static boolean validArchiveName(String name){return name!=null&&name.matches("[0-9a-zA-Z_-]{8,90}\\.m4a");}
  private static final String DIR_MIME=DocumentsContract.Document.MIME_TYPE_DIR;
  private static final String FILE_MIME="audio/mp4";
  private void backupVoiceArchive(Uri tree)throws Exception{
    Uri root=archiveRoot(tree);
    File base=new File(getFilesDir(),"moa-original-audio");
    File[] days=base.listFiles();
    if(days==null)days=new File[0];
    Arrays.sort(days,Comparator.comparing(File::getName));
    JSONArray entries=new JSONArray();
    long total=0;int count=0,skipped=0;
    for(File dayDir:days){
      if(!dayDir.isDirectory()||!validArchiveDay(dayDir.getName()))continue;
      File[] clips=dayDir.listFiles();
      if(clips==null)continue;
      Arrays.sort(clips,Comparator.comparing(File::getName));
      Uri folder=null;
      for(File file:clips){
        if(!file.isFile()||!validArchiveName(file.getName()))continue;
        String sha=sha256(file);
        if(folder==null){
          ArchiveDoc found=findArchiveChild(tree,root,dayDir.getName());
          folder=found!=null?found.uri:DocumentsContract.createDocument(getContentResolver(),root,DIR_MIME,dayDir.getName());
          if(folder==null)throw new IOException("날짜 폴더 생성 실패");
        }
        ArchiveDoc existing=findArchiveChild(tree,folder,file.getName());
        Uri dest;
        if(existing!=null){
          dest=existing.uri;
          if(!sha.equals(hashDocument(dest)))
            throw new IOException("외부 폴더 이름 충돌·해시 불일치: "+dayDir.getName()+"/"+file.getName());
          skipped++;
        }else{
          dest=DocumentsContract.createDocument(getContentResolver(),folder,FILE_MIME,file.getName());
          if(dest==null)throw new IOException("녹음 문서 생성 실패");
          try{
            copy(file,dest);
            if(!sha.equals(hashDocument(dest)))throw new IOException("복사 후 해시 불일치");
          }catch(Exception ex){
            try{DocumentsContract.deleteDocument(getContentResolver(),dest);}catch(Exception ignored){}
            throw ex;
          }
        }
        JSONObject x=new JSONObject().put("day",dayDir.getName()).put("id",file.getName())
          .put("bytes",file.length()).put("sha256",sha);
        entries.put(x);count++;total+=file.length();
      }
    }
    JSONObject links=new JSONObject();
    for(java.util.Map.Entry<String,?> kv:MoaMomentCaptureService.prefs(this).getAll().entrySet()){
      if(kv.getKey().matches("m:v?\\d{1,19}")&&kv.getValue() instanceof String){
        JSONObject meta=new JSONObject((String)kv.getValue());
        if(meta.has("voiceFileId")||meta.has("voiceRecords"))links.put(kv.getKey(),kv.getValue());
      }
    }
    JSONObject manifest=new JSONObject().put("schema",1)
      .put("kind","moa-voice-safety-copy")
      .put("createdAt",System.currentTimeMillis())
      .put("clips",entries).put("captureLinks",links)
      .put("note","App-private original recordings are still preserved. No gallery or voice WebView localStorage backup.");
    byte[] m=manifest.toString(2).getBytes(java.nio.charset.StandardCharsets.UTF_8);
    String stamp=new SimpleDateFormat("yyyyMMdd_HHmmss_SSS",Locale.US).format(new Date());
    String name="MOA_voice_manifest_"+stamp+".json";
    Uri dest=DocumentsContract.createDocument(getContentResolver(),root,"application/json",name);
    if(dest==null)throw new IOException("백업 목록 저장 실패");
    try{
      writeDoc(dest,m);
      if(!java.util.Arrays.equals(m,readDocument(dest,100000000)))
        throw new IOException("백업 목록 읽기 검증 실패");
    }catch(Exception ex){
      try{DocumentsContract.deleteDocument(getContentResolver(),dest);}catch(Exception ignored){}
      throw ex;
    }
    final int done=count,already=skipped;final long bytes=total;
    runOnUiThread(()->status("외부 백업 검증 완료: "+done+"개 · "+
      String.format(Locale.US,"%.1f",bytes/1048576.0)+"MB · 기존 검증 "+already+"개. 내부 원본 보존."));
  }
  private void restoreVoiceArchive(Uri tree)throws Exception{
    Uri root=archiveRoot(tree);
    ArchiveDoc manifestDoc=null;
    Uri listing=DocumentsContract.buildChildDocumentsUriUsingTree(tree,DocumentsContract.getDocumentId(root));
    String[] cols={DocumentsContract.Document.COLUMN_DOCUMENT_ID,DocumentsContract.Document.COLUMN_DISPLAY_NAME};
    try(Cursor c=getContentResolver().query(listing,cols,null,null,null)){
      if(c==null)throw new IOException("외부 폴더 목록을 읽을 수 없습니다");
      while(c.moveToNext()){
        String name=c.getString(1);
        if(name.matches("MOA_voice_manifest_\\d{8}_\\d{6}_\\d{3}\\.json") &&
           (manifestDoc==null||name.compareTo(manifestDoc.name)>0))
          manifestDoc=new ArchiveDoc(name,
            DocumentsContract.buildDocumentUriUsingTree(tree,c.getString(0)),"application/json");
      }
    }
    if(manifestDoc==null)throw new IOException("모아 녹음 백업 목록을 찾지 못했습니다");
    JSONObject manifest=new JSONObject(new String(readDocument(manifestDoc.uri,100000000),
       java.nio.charset.StandardCharsets.UTF_8));
    if(manifest.optInt("schema")!=1||!"moa-voice-safety-copy".equals(manifest.optString("kind")))
      throw new IOException("지원하지 않는 백업 파일");
    JSONArray clips=manifest.optJSONArray("clips");
    if(clips==null||clips.length()>100000)throw new IOException("녹음 목록이 없거나 너무 많습니다");
    int restored=0,kept=0;
    File base=new File(getFilesDir(),"moa-original-audio");
    for(int n=0;n<clips.length();n++){
      JSONObject c=clips.getJSONObject(n);
      String date=c.getString("day"),name=c.getString("id"),sha=c.getString("sha256");
      if(!validArchiveDay(date)||!validArchiveName(name)||!sha.matches("[a-f0-9]{64}"))
        throw new IOException("백업에 잘못된 날짜·파일명이 있습니다");
      ArchiveDoc dayDoc=findArchiveChild(tree,root,date);
      if(dayDoc==null)throw new IOException("백업 날짜 폴더 없음: "+date);
      ArchiveDoc fileDoc=findArchiveChild(tree,dayDoc.uri,name);
      if(fileDoc==null||!sha.equals(hashDocument(fileDoc.uri)))
        throw new IOException("외부 녹음 원본 해시 불일치: "+name);
      File folder=new File(base,date),existing=new File(folder,name);
      if(existing.isFile()){
        if(!sha.equals(sha256(existing)))throw new IOException("내부 파일 이름 충돌(덮어쓰기 금지): "+name);
        kept++;continue;
      }
      if(!folder.isDirectory()&&!folder.mkdirs())throw new IOException("복원 폴더 생성 실패");
      File tmp=new File(folder,name+".restore-part");
      if(tmp.exists()&&!tmp.delete())throw new IOException("이전 미완성 임시파일 삭제 실패");
      try(InputStream in=getContentResolver().openInputStream(fileDoc.uri);
          OutputStream out=new FileOutputStream(tmp)){
        if(in==null)throw new IOException("외부 원본 읽기 실패");
        byte[] buf=new byte[65536];int len;
        while((len=in.read(buf))!=-1)out.write(buf,0,len);
        out.flush();
      }
      if(!sha.equals(sha256(tmp))||!tmp.renameTo(existing)){
        tmp.delete();throw new IOException("복원 검증/확정 실패: "+name);
      }
      restored++;
    }
    JSONObject links=manifest.optJSONObject("captureLinks");
    int merged=0;
    if(links!=null){
      SharedPreferences prefs=MoaMomentCaptureService.prefs(this);
      SharedPreferences.Editor editor=prefs.edit();
      Iterator<String> keys=links.keys();
      while(keys.hasNext()){
        String key=keys.next();
        if(!key.matches("m:v?\\d{1,19}")||prefs.contains(key))continue;
        editor.putString(key,links.optString(key));merged++;
      }
      if(merged>0&&!editor.commit())throw new IOException("촬영 연결정보 복원 저장 실패");
    }
    final int a=restored,b=kept,d=merged;
    runOnUiThread(()->status("음성 복원 완료: 새 파일 "+a+"개 · 기존 확인 "+b+
      "개 · 촬영 연결정보 "+d+"개. 일기 전체/제목 DB는 별도 복원이 필요합니다."));
  }
  private void startVoiceArchive(final Uri tree,final boolean restore){
    if(!archiveBusy.compareAndSet(false,true)){status("다른 음성 보관 작업이 진행 중입니다");return;}
    status(restore?"녹음 복원 및 SHA-256 검증 중…":"녹음 원본을 외부에 복사·검증 중…");
    new Thread(()->{
      try{
        if(restore)restoreVoiceArchive(tree);else backupVoiceArchive(tree);
      }catch(Exception ex){
        String msg=ex.getClass().getSimpleName()+": "+ex.getMessage();
        runOnUiThread(()->status("음성 "+(restore?"복원":"백업")+" 중단: "+msg+
          " · 내부 원본은 삭제하지 않았습니다."));
      }finally{archiveBusy.set(false);}
    },"moa-r165-voice-archive").start();
  }
  @Override protected void onActivityResult(int request,int result,Intent data){
    super.onActivityResult(request,result,data);
    if((request!=ARCHIVE_EXPORT&&request!=ARCHIVE_IMPORT)||result!=RESULT_OK||data==null)return;
    Uri tree=data.getData();if(tree==null){status("폴더 선택이 취소됐습니다");return;}
    try{
      int flags=data.getFlags()&(Intent.FLAG_GRANT_READ_URI_PERMISSION|Intent.FLAG_GRANT_WRITE_URI_PERMISSION);
      getContentResolver().takePersistableUriPermission(tree,flags);
      new AlertDialog.Builder(this)
        .setTitle(request==ARCHIVE_IMPORT?"녹음 원본 복원 확인":"녹음 외부 복사 확인")
        .setMessage(request==ARCHIVE_IMPORT?
          "선택한 폴더의 최신 모아 백업 목록을 검사한 뒤, 내부에 없는 녹음만 복구합니다. 기존 파일은 절대 덮어쓰지 않습니다.":
          "날짜별 M4A 원본을 선택한 폴더에 추가 복사하고 SHA-256으로 다시 확인합니다. 앱 내부 원본과 기존 기록은 그대로 유지됩니다.")
        .setPositiveButton("실행",(d,w)->startVoiceArchive(tree,request==ARCHIVE_IMPORT))
        .setNegativeButton("취소",null).show();
    }catch(Exception ex){status("외부 폴더 접근권한 저장 실패: "+ex.getMessage());}
  }

  @Override public void onRequestPermissionsResult(int code,String[] p,int[] results){
    super.onRequestPermissionsResult(code,p,results);
    if(code==MIC||code==RECORD_MIC){
      if(results.length>0&&results[0]==PackageManager.PERMISSION_GRANTED){
        if(code==MIC)startDictation();else startRecording();
      }else status("마이크 권한이 없어 음성 기능을 시작하지 못했어.");
    }
  }
  @Override protected void onPause(){
    if(recorder!=null)stopRecording();
    if(player!=null&&player.isPlaying()){
      player.pause();main.removeCallbacks(playTicker);playStyle(false);
      if(playButton!=null)playButton.setText("▶ 이어듣기");
    }
    super.onPause();
  }
  @Override protected void onDestroy(){
    if(speech!=null){speech.stop();speech=null;}
    if(recorder!=null)stopRecording();
    cancelFileRecognition();
    main.removeCallbacks(recordTicker);main.removeCallbacks(playTicker);
    try{if(player!=null){player.release();player=null;}}catch(Exception ignored){}
    super.onDestroy();
  }
}