package com.juhyeon.familyjourney;

import android.webkit.ConsoleMessage;
import android.webkit.JsPromptResult;
import android.webkit.PermissionRequest;
import android.webkit.WebChromeClient;
import android.webkit.WebView;

/**
 * R79: same-origin, opt-in fallback to the existing in-app speech recognizer.
 * JS interfaces added after a document load may not be visible until reload.
 * The original MOA native MediaStore Host WebChromeClient is retained/delegated.
 * No permission is silently granted and the existing camera/memo is untouched.
 */
public final class MoaMomentVoiceChrome extends WebChromeClient {
  private final WebChromeClient original;
  private final MoaMomentVoiceBridge voice;
  private static final String PROMPT="MOA_R79_NATIVE_VOICE";
  private static final String ACCEPT="MOA_R79_ACCEPTED";
  public MoaMomentVoiceChrome(WebChromeClient original,MoaMomentVoiceBridge voice){
    this.original=original;
    this.voice=voice;
  }
  private boolean trusted(WebView view,String url){
    return url!=null && url.startsWith("https://familyjourney.local/")
      && view!=null && view.getUrl()!=null
      && view.getUrl().startsWith("https://familyjourney.local/");
  }
  @Override public boolean onJsPrompt(WebView view,String url,String message,
      String defaultValue,JsPromptResult result){
    if(PROMPT.equals(message)){
      if(!trusted(view,url)||defaultValue==null||
          !defaultValue.matches("v[0-9]{1,18}")){
        result.cancel();return true;
      }
      result.confirm(ACCEPT);
      voice.start(defaultValue); // Goes through original user-initiated native STT.
      return true;
    }
    return original!=null ? original.onJsPrompt(view,url,message,defaultValue,result)
      :super.onJsPrompt(view,url,message,defaultValue,result);
  }
  @Override public boolean onConsoleMessage(ConsoleMessage message){
    return original!=null ? original.onConsoleMessage(message)
      :super.onConsoleMessage(message);
  }
  @Override public void onProgressChanged(WebView view,int progress){
    if(progress==100&&trusted(view,view.getUrl())){
      view.post(()->{
        if(trusted(view,view.getUrl()))
          try{view.evaluateJavascript("window.__moaR79VoicePromptReady=true",null);}
          catch(Exception ignored){}
      });
    }
    if(original!=null)original.onProgressChanged(view,progress);
    else super.onProgressChanged(view,progress);
  }
  @Override public void onPermissionRequest(PermissionRequest request){
    // Do NOT silently grant microphone access to the Web Speech fallback.
    // We use native SpeechRecognizer with the user's Android permission.
    if(original!=null)original.onPermissionRequest(request);
    else super.onPermissionRequest(request);
  }
  @Override public void onPermissionRequestCanceled(PermissionRequest request){
    if(original!=null)original.onPermissionRequestCanceled(request);
    else super.onPermissionRequestCanceled(request);
  }
}