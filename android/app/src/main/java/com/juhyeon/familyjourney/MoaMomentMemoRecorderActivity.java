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
import android.view.View;
import android.view.WindowInsets;
import android.content.res.ColorStateList;
import android.view.WindowManager;
import android.view.inputmethod.InputMethodManager;
import android.widget.Button;
import android.widget.CheckBox;
import android.widget.CompoundButton;
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
  private static final int MIC=7801, RECORD_MIC=7802;
  private final Handler main=new Handler(Looper.getMainLooper());
  private String id,day,voiceId="";
  private EditText text;
  private TextView status;
  private Button micButton,recButton,playButton,saveButton,backupButton;
  private CheckBox autoArchive;
  private volatile boolean archiving=false;
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
    // R165: opt-in public MediaStore backup. Not an automatic migration and
    // never deletes original M4A; legacy R163 recording/list/STT stay intact.
    TextView backupExplain=new TextView(this);
    backupExplain.setText("녹음 외부 보관 · Music/MOA-Recordings\n앱 삭제 후에도 외부 복사본을 남길 수 있어요. 원본과 일기 메모는 앱 내부에 그대로 유지됩니다.");
    backupExplain.setTextColor(0xff596b7b);backupExplain.setTextSize(12);
    backupExplain.setPadding(0,dp(15),0,dp(6));body.addView(backupExplain);
    autoArchive=new CheckBox(this);
    autoArchive.setText("앞으로 녹음한 음성도 외부에 자동 복사 (저장공간 두 곳 사용)");
    autoArchive.setTextSize(13);
    autoArchive.setChecked(MoaR165AudioExport.auto(this));
    autoArchive.setOnCheckedChangeListener((button,checked)->{
      if(!checked){MoaR165AudioExport.setAuto(this,false);status("새 녹음의 외부 자동 보관 OFF · 기존 녹음/백업은 유지됩니다.");return;}
      // Public media may be visible to other audio/media apps. Never enable
      // without a user-initiated confirmation.
      button.setChecked(false);
      new AlertDialog.Builder(this)
        .setTitle("외부 녹음 자동 보관 켜기")
        .setMessage("새 M4A를 Music/MOA-Recordings에도 별도 복사합니다. 다른 미디어 앱에서도 파일을 볼 수 있고, 당분간 내부+외부 두 곳의 용량을 사용합니다. 기존 원본은 삭제하지 않습니다.")
        .setNegativeButton("취소",null)
        .setPositiveButton("켜기",(dialog,which)->{
          MoaR165AudioExport.setAuto(this,true);
          autoArchive.setOnCheckedChangeListener(null);autoArchive.setChecked(true);
          autoArchive.setOnCheckedChangeListener((b,on)->{
            if(!on){MoaR165AudioExport.setAuto(this,false);status("외부 자동 보관 OFF");}
          });
          status("다음 녹음부터 원본 저장 후 외부 백업을 추가로 검증합니다.");
        }).show();
    });
    body.addView(autoArchive);
    backupButton=new Button(this);
    backupButton.setText("기존 음성 전체 외부 안전 보관");
    backupButton.setAllCaps(false);
    backupButton.setOnClickListener(v->confirmBackupAll());
    body.addView(backupButton,new LinearLayout.LayoutParams(-1,dp(48)));

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
    // Backup is asynchronous and opt-in. R163's original M4A, local list,
    // playback and source-file STT remain primary and unchanged.
    if(MoaR165AudioExport.auto(this))backupSingleAsync(f,day);
    playButton.setEnabled(true);
    playButton.setText("▶ 원본 듣기");playStyle(false);
    status("녹음 원본 저장 완료 · "+Math.max(1,(SystemClock.elapsedRealtime()-recordStarted)/1000)+"초. 녹음 텍스트 자동 변환 중…");
    startFileSpeech(f);
  }
  private void confirmBackupAll(){
    if(archiving){status("기존 녹음 외부 보관이 진행 중입니다.");return;}
    if(!MoaR165AudioExport.supported()){status("Android 10 이상에서 이용할 수 있습니다.");return;}
    new AlertDialog.Builder(this)
      .setTitle("녹음 원본을 별도 폴더에 보관할까요?")
      .setMessage("앱 내부의 날짜별 M4A 전체를 Music/MOA-Recordings/에 복사하고 파일별 SHA-256으로 검증합니다.\n\n기존 녹음·텍스트·사진 연결은 변경하지 않습니다. 앱 내부 공간이 즉시 줄어드는 방식은 아니고, 백업된 음성은 다른 미디어 앱에서도 보일 수 있습니다.")
      .setNegativeButton("취소",null)
      .setPositiveButton("원본 보관 시작",(dialog,which)->backupAllAsync())
      .show();
  }
  private void backupAllAsync(){
    if(archiving)return;
    archiving=true;
    backupButton.setEnabled(false);
    status("앱 내부 녹음 목록 확인 중… 원본은 절대 삭제하지 않습니다.");
    final android.content.Context app=getApplicationContext();
    new Thread(()->MoaR165AudioExport.exportAll(app,new MoaR165AudioExport.Listener(){
      @Override public void update(int done,int total,int copied,int existing,int failed,long bytes,String message){
        if(done==total||done%10==0){
          main.post(()->{if(!isFinishing()&&!isDestroyed())
            status("외부 안전 보관 "+done+"/"+total+" · 새 복사 "+copied+
              " · 기존 확인 "+existing+" · 실패 "+failed);});
        }
      }
      @Override public void complete(MoaR165AudioExport.Summary summary){
        main.post(()->{
          archiving=false;
          if(backupButton!=null)backupButton.setEnabled(true);
          if(!isFinishing()&&!isDestroyed()){
            status(summary.describe());
            new AlertDialog.Builder(MoaMomentMemoRecorderActivity.this)
              .setTitle("녹음 외부 보관 결과")
              .setMessage(summary.describe())
              .setPositiveButton("확인",null).show();
          }
        });
      }
    }),"moa-r165-audio-safe-backup").start();
  }
  private void backupSingleAsync(File original,String date){
    final android.content.Context app=getApplicationContext();
    new Thread(()->{
      try{
        MoaR165AudioExport.ExportResult result=MoaR165AudioExport.copy(app,original,date);
        main.post(()->{
          if(!isFinishing()&&!isDestroyed()){
            status("새 녹음 외부 보관 확인 · "+result.message+" (앱 내부 원본도 유지)");
          }
        });
      }catch(Exception error){
        main.post(()->{
          if(!isFinishing()&&!isDestroyed())
            status("외부 보관 실패 · 앱 내부 원본 및 녹음 텍스트는 유지됨: "+error.getMessage());
        });
      }
    },"moa-r165-audio-automatic-copy").start();
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