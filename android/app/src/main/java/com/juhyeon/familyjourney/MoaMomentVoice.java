package com.juhyeon.familyjourney;

import android.Manifest;
import android.app.Activity;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.os.Build;
import android.os.Bundle;
import android.speech.RecognitionListener;
import android.speech.RecognizerIntent;
import android.speech.SpeechRecognizer;
import java.util.ArrayList;

/** R78: user-initiated SpeechRecognizer inside the currently visible MOA Activity.
 * No external speech-intent UI (which may be hidden behind Samsung secure keyguard).
 * No automatic recording or uploads of gallery photos. Transcript stays in editor.
 */
public final class MoaMomentVoice {
  public interface Listener {
    void onListening();
    void onText(String text);
    void onFailure(String description);
    void onFinished();
  }
  private SpeechRecognizer recognizer;
  private boolean retryingSystem=false,completed=false;
  private final Activity activity;
  private final Listener listener;

  public MoaMomentVoice(Activity activity, Listener listener){this.activity=activity;this.listener=listener;}
  public static boolean hasPermission(Activity a){
    return a.checkSelfPermission(Manifest.permission.RECORD_AUDIO)==PackageManager.PERMISSION_GRANTED;
  }
  public void start(){
    if(!hasPermission(activity)){
      listener.onFailure("마이크 권한이 필요합니다. 허용 후 다시 눌러 주세요.");
      return;
    }
    completed=false;retryingSystem=false;
    startEngine(true);
  }
  private void startEngine(boolean preferDevice){
    cleanup();
    try{
      boolean onDevice=preferDevice && Build.VERSION.SDK_INT>=31
        && SpeechRecognizer.isOnDeviceRecognitionAvailable(activity);
      recognizer=onDevice?SpeechRecognizer.createOnDeviceSpeechRecognizer(activity):
        SpeechRecognizer.createSpeechRecognizer(activity);
      final boolean local=onDevice;
      recognizer.setRecognitionListener(new RecognitionListener(){
        @Override public void onReadyForSpeech(Bundle params){listener.onListening();}
        @Override public void onBeginningOfSpeech(){}
        @Override public void onRmsChanged(float rms){}
        @Override public void onBufferReceived(byte[] buffer){}
        @Override public void onEndOfSpeech(){}
        @Override public void onPartialResults(Bundle partial){}
        @Override public void onEvent(int eventType,Bundle params){}
        @Override public void onResults(Bundle results){
          if(completed)return;
          completed=true;
          ArrayList<String> list=results.getStringArrayList(SpeechRecognizer.RESULTS_RECOGNITION);
          if(list!=null&&!list.isEmpty()&&!list.get(0).trim().isEmpty())listener.onText(list.get(0).trim());
          else listener.onFailure("목소리를 인식하지 못했습니다. 다시 눌러 주세요.");
          listener.onFinished();cleanup();
        }
        @Override public void onError(int error){
          if(completed)return;
          if(local&&!retryingSystem&&(error==SpeechRecognizer.ERROR_LANGUAGE_NOT_SUPPORTED
              ||error==SpeechRecognizer.ERROR_LANGUAGE_UNAVAILABLE
              ||error==SpeechRecognizer.ERROR_CLIENT
              ||error==SpeechRecognizer.ERROR_SERVER)){
            retryingSystem=true;
            startEngine(false);return;
          }
          completed=true;
          String detail;
          switch(error){
            case SpeechRecognizer.ERROR_NO_MATCH: detail="인식한 말이 없습니다. 조금 더 또렷하게 말해 주세요."; break;
            case SpeechRecognizer.ERROR_SPEECH_TIMEOUT: detail="음성이 감지되지 않았습니다. 다시 눌러 주세요."; break;
            case SpeechRecognizer.ERROR_INSUFFICIENT_PERMISSIONS: detail="마이크 권한이 없어 음성 인식을 시작하지 못했습니다."; break;
            case SpeechRecognizer.ERROR_RECOGNIZER_BUSY: detail="음성 인식이 사용 중입니다. 잠시 후 다시 눌러 주세요."; break;
            case SpeechRecognizer.ERROR_NETWORK: case SpeechRecognizer.ERROR_NETWORK_TIMEOUT: detail="음성 인식 서비스 연결에 실패했습니다. 네트워크 또는 오프라인 언어팩을 확인해 주세요."; break;
            default: detail="음성 인식 오류("+error+"). 화면 잠금 상태의 음성 서비스 사용 여부를 확인해 주세요.";
          }
          listener.onFailure(detail);listener.onFinished();cleanup();
        }
      });
      Intent i=new Intent(RecognizerIntent.ACTION_RECOGNIZE_SPEECH);
      i.putExtra(RecognizerIntent.EXTRA_LANGUAGE_MODEL,RecognizerIntent.LANGUAGE_MODEL_FREE_FORM);
      i.putExtra(RecognizerIntent.EXTRA_LANGUAGE,"ko-KR");
      i.putExtra(RecognizerIntent.EXTRA_MAX_RESULTS,1);
      if(onDevice)i.putExtra(RecognizerIntent.EXTRA_PREFER_OFFLINE,true);
      recognizer.startListening(i);
      listener.onListening();
    }catch(Exception e){
      completed=true;cleanup();
      listener.onFailure("음성 서비스 시작 실패("+e.getClass().getSimpleName()+"). 잠금을 해제한 뒤 마이크 권한과 음성 서비스 상태를 확인해 주세요.");
      listener.onFinished();
    }
  }
  public void stop(){completed=true;cleanup();listener.onFinished();}
  private void cleanup(){
    if(recognizer!=null){
      SpeechRecognizer old=recognizer;recognizer=null;
      try{old.cancel();}catch(Exception ignored){}
      try{old.destroy();}catch(Exception ignored){}
    }
  }
}