#!/usr/bin/env python3
"""R80 minimum native STT patch. Apply to R79 GitHub source checkout; fail closed.
No private keys, no user media, no app data changes. Keeps R77 camera code untouched.
"""
from pathlib import Path
ROOT=Path('android/app/src/main/java/com/juhyeon/familyjourney')

def patch(name,pairs):
    path=ROOT/name
    s=path.read_text(encoding='utf-8');before=s
    for old,new in pairs:
        n=s.count(old)
        if n!=1:raise AssertionError(f'{name}: expected one source anchor ({n}), got {old[:65]!r}')
        s=s.replace(old,new)
    path.write_text(s,encoding='utf-8')
    print('R80_PATCH',name,'old chars',len(before),'new chars',len(s))

# Android recognition provider MUST be asked for partials, not just get a
# listener whose onPartialResults is empty (actual R79 source did both).
patch('MoaMomentVoice.java',[
('    void onText(String text);\n    void onFailure(String description);',
 '    void onText(String text);\n    default void onPartial(String text){}\n    void onFailure(String description);'),
('  private boolean retryingSystem=false,completed=false;',
 '  private boolean retryingSystem=false,completed=false;\n  private String lastPartial="";\n  private final android.os.Handler finalWait=new android.os.Handler(android.os.Looper.getMainLooper());'),
('    completed=false;retryingSystem=false;\n    startEngine(true);',
 '    completed=false;retryingSystem=false;lastPartial="";\n    startEngine(true);'),
('    cleanup();\n    try{\n      boolean onDevice=',
 '    cleanup();lastPartial="";\n    try{\n      boolean onDevice='),
('        @Override public void onPartialResults(Bundle partial){}',
 '''        @Override public void onPartialResults(Bundle partial){
          if(completed||partial==null)return;
          ArrayList<String> guesses=partial.getStringArrayList(SpeechRecognizer.RESULTS_RECOGNITION);
          if(guesses!=null&&!guesses.isEmpty()&&guesses.get(0)!=null){
            String interim=guesses.get(0).trim();
            if(!interim.isEmpty()&&!interim.equals(lastPartial)){
              lastPartial=interim;listener.onPartial(interim);
            }
          }
        }'''),
('          if(list!=null&&!list.isEmpty()&&!list.get(0).trim().isEmpty())listener.onText(list.get(0).trim());\n          else listener.onFailure("목소리를 인식하지 못했습니다. 다시 눌러 주세요.");',
 '''          String words=list!=null&&!list.isEmpty()&&list.get(0)!=null?list.get(0).trim():"";
          if(words.isEmpty())words=lastPartial;
          if(!words.isEmpty())listener.onText(words);
          else listener.onFailure("목소리를 인식하지 못했습니다. 다시 눌러 주세요.");'''),
('          completed=true;\n          String detail;',
 '''          completed=true;
          if(!lastPartial.isEmpty()){
            listener.onText(lastPartial);listener.onFinished();cleanup();return;
          }
          String detail;'''),
('      i.putExtra(RecognizerIntent.EXTRA_MAX_RESULTS,1);',
 '      i.putExtra(RecognizerIntent.EXTRA_MAX_RESULTS,1);\n      i.putExtra(RecognizerIntent.EXTRA_PARTIAL_RESULTS,true);'),
('  public void stop(){completed=true;cleanup();listener.onFinished();}',
 '''  public void finish(){
    if(completed)return;
    try{if(recognizer!=null)recognizer.stopListening();}catch(Exception ignored){}
    finalWait.postDelayed(()->{
      if(completed)return;
      completed=true;
      if(!lastPartial.isEmpty())listener.onText(lastPartial);
      else listener.onFailure("최종 음성 결과가 없습니다. 다시 눌러 주세요.");
      listener.onFinished();cleanup();
    },2400L);
  }
  public void stop(){if(completed)return;completed=true;cleanup();listener.onFinished();}''')
])

# Keep token response idempotent. When the user selects a new field, finish
# the prior field's pending UI and do not leak its later native callbacks.
patch('MoaMomentVoiceBridge.java',[
('  private String active;',
 '  private String active;\n  private String awaitingPermission; private int permissionChecks;'),
('  @JavascriptInterface public void cancel(){main.post(()->{\n    if(recognizer!=null){recognizer.stop();recognizer=null;active=null;}\n  });}',
 '''  @JavascriptInterface public void cancel(){main.post(()->{
    String previous=active;active=null;awaitingPermission=null;
    if(recognizer!=null){recognizer.stop();recognizer=null;}
    if(previous!=null)result(previous,"","finished");
  });}
  @JavascriptInterface public void finish(String token){main.post(()->{
    if(token!=null&&token.equals(active)&&recognizer!=null)recognizer.finish();
  });}'''),
('  private void begin(String token){',
 '''  private void checkPermissionResult(String token){
    main.postDelayed(()->{
      if(!token.equals(awaitingPermission)||!token.equals(active)||!trusted())return;
      Activity a=activity.get();
      if(a!=null&&a.checkSelfPermission(Manifest.permission.RECORD_AUDIO)==PackageManager.PERMISSION_GRANTED){
        awaitingPermission=null;begin(token);return;
      }
      if(++permissionChecks>=36){
        awaitingPermission=null;
        result(token,"마이크 권한을 허용한 후 다시 눌러 주세요.","permission");
        result(token,"","finished");active=null;
      }else checkPermissionResult(token);
    },350L);
  }
  private void begin(String token){'''),
('    if(recognizer!=null){recognizer.stop();recognizer=null;}\n    active=token;',
 '''    if(recognizer!=null){
      String previous=active;active=null;
      recognizer.stop();recognizer=null;
      if(previous!=null)result(previous,"","finished");
    }
    active=token;'''),
('      result(token,"첫 사용 시 마이크 권한을 허용한 후 버튼을 다시 눌러 주세요.","permission");\n      try{a.requestPermissions(new String[]{Manifest.permission.RECORD_AUDIO},7802);}\n      catch(Exception e){result(token,"마이크 권한을 설정에서 허용해 주세요.","error");}\n      return;',
 '''      awaitingPermission=token;permissionChecks=0;
      result(token,"마이크 권한 승인 대기 중…","permission_wait");
      try{a.requestPermissions(new String[]{Manifest.permission.RECORD_AUDIO},7802);checkPermissionResult(token);}
      catch(Exception e){
        awaitingPermission=null;
        result(token,"마이크 권한을 설정에서 허용해 주세요.","error");
        result(token,"","finished");
      }
      return;'''),
('      @Override public void onText(String transcript){if(token.equals(active))result(token,transcript,"success");}',
 '      @Override public void onText(String transcript){if(token.equals(active))result(token,transcript,"success");}\n      @Override public void onPartial(String draft){if(token.equals(active))result(token,draft,"partial");}')
])

# Existing native memo is physically tested. Show tentative text in the SAME
# EditText, replacing earlier interim rather than appending N duplicates.
path=ROOT/'MoaMomentMemoActivity.java'
s=path.read_text(encoding='utf-8')
old='  private String id; private EditText text; private MoaMomentVoice speech; private Button micButton;'
assert s.count(old)==1
s=s.replace(old,old+'\n  private String speechBase=null,speechRendered=null; private int speechCursor=0;')
old='    mic.setOnClickListener(v->beginInlineVoice());'
assert s.count(old)==1
s=s.replace(old,'''    mic.setOnClickListener(v->{
      if(speech!=null){micButton.setText("음성 마무리 중…");speech.finish();}
      else beginInlineVoice();
    });''')
a=s.index('  // R78: microphone stays INSIDE this Activity')
b=s.index('  @Override public void onRequestPermissionsResult(',a)
replacement='''  private void paintVoice(String words,boolean finalText){
    if(words==null||words.trim().isEmpty())return;
    if(speechBase==null){
      speechBase=text.getText().toString();
      speechCursor=Math.max(0,Math.min(text.getSelectionStart(),speechBase.length()));
      speechRendered=speechBase;
    }
    String current=text.getText().toString();
    if(speechRendered!=null&&!current.equals(speechRendered)){
      // If user also typed, never overwrite their manual edit.
      speechBase=current;
      speechCursor=Math.max(0,Math.min(text.getSelectionStart(),speechBase.length()));
    }
    String left=speechBase.substring(0,speechCursor),right=speechBase.substring(speechCursor);
    String gap=!left.isEmpty()&&!Character.isWhitespace(left.charAt(left.length()-1))?" ":"";
    String out=left+gap+words.trim()+right;
    text.setText(out);text.setSelection(Math.min(out.length(),left.length()+gap.length()+words.trim().length()));
    speechRendered=out;
    if(finalText){speechBase=null;speechRendered=null;}
  }
  private void beginInlineVoice(){
    if(!MoaMomentVoice.hasPermission(this)){
      requestPermissions(new String[]{android.Manifest.permission.RECORD_AUDIO},7801);
      return;
    }
    speechBase=null;speechRendered=null;
    speech=new MoaMomentVoice(this,new MoaMomentVoice.Listener(){
      @Override public void onListening(){micButton.setText("⏹ 음성 종료");micButton.setEnabled(true);}
      @Override public void onPartial(String words){paintVoice(words,false);}
      @Override public void onText(String words){paintVoice(words,true);}
      @Override public void onFailure(String message){
        Toast.makeText(MoaMomentMemoActivity.this,message,Toast.LENGTH_LONG).show();
      }
      @Override public void onFinished(){
        micButton.setText("🎙 음성으로 말하기");micButton.setEnabled(true);
        speech=null;speechBase=null;speechRendered=null;
      }
    });
    speech.start();
  }
'''
s=s[:a]+replacement+s[b:]
path.write_text(s,encoding='utf-8')
print('R80_PATCH',path.name,'new chars',len(s))

# The R79 WebChromeClient prompt-ready signal is set only once after install.
# HostActivity can assign its own Chrome client later: rearm safely at resume,
# without navigating/reloading the WebView or losing unsaved text.
path=ROOT/'MoaMomentApplication.java';s=path.read_text(encoding='utf-8')
old='  private final WeakHashMap<WebView,Boolean> retried=new WeakHashMap<>();'
assert s.count(old)==1
s=s.replace(old,old+'\n  private final WeakHashMap<WebView,MoaMomentVoiceBridge> voices=new WeakHashMap<>();')
old='      MoaMomentVoiceBridge voice=new MoaMomentVoiceBridge(a,web);\n      web.addJavascriptInterface(voice,"MoaVoiceNative");'
assert s.count(old)==1
s=s.replace(old,old+'\n      voices.put(web,voice);')
old='    ensureBridge(a);\n    // R59:'
assert s.count(old)==1
s=s.replace(old,'''    ensureBridge(a);
    if("com.juhyeon.familyjourney.HostActivity".equals(a.getClass().getName())){
      // A late HostActivity setWebChromeClient can replace the R79 adapter.
      // Repeat only foreground registration (NO WebView reload or DB edit).
      rearmVoiceChrome(a);
      main.postDelayed(()->rearmVoiceChrome(a),350L);
      main.postDelayed(()->rearmVoiceChrome(a),1350L);
    }
    // R59:''')
old='  @Override public void onActivityStarted(Activity a){}'
assert s.count(old)==1
s=s.replace(old,'''  private void rearmVoiceChrome(Activity a){
    if(a==null||a.isFinishing()||a.isDestroyed())return;
    if(!"com.juhyeon.familyjourney.HostActivity".equals(a.getClass().getName()))return;
    WebView web=findWebView(a.getWindow().getDecorView());
    if(web==null)return;
    MoaMomentVoiceBridge voice=voices.get(web);
    if(voice==null){install(a);voice=voices.get(web);}
    if(voice==null)return;
    try{
      if(!(web.getWebChromeClient() instanceof MoaMomentVoiceChrome))
        web.setWebChromeClient(new MoaMomentVoiceChrome(web.getWebChromeClient(),voice));
      final String url=web.getUrl();
      if(url!=null&&url.startsWith("https://familyjourney.local/"))
        web.evaluateJavascript("window.__moaR79VoicePromptReady=true;window.__moaR80VoiceChromeLive=true;",null);
    }catch(Throwable t){
      MoaMomentCaptureService.prefs(this).edit().putString("r80VoiceRearmError",t.getClass().getSimpleName()).apply();
    }
  }
  @Override public void onActivityStarted(Activity a){}''')
path.write_text(s,encoding='utf-8')
print('R80_PATCH',path.name,'new chars',len(s))

# Allow explicit End from editor to ask Android for final text; return result
# to the existing callback without creating a second voice UI.
path=ROOT/'MoaMomentVoiceChrome.java';s=path.read_text(encoding='utf-8')
old='    if(PROMPT.equals(message)){'
assert s.count(old)==1
s=s.replace(old,'''    if("MOA_R80_NATIVE_VOICE_END".equals(message)){
      if(!trusted(view,url)||defaultValue==null||!defaultValue.matches("v[0-9]{1,18}")){
        result.cancel();return true;
      }
      result.confirm(ACCEPT);voice.finish(defaultValue);return true;
    }
    if(PROMPT.equals(message)){''')
path.write_text(s,encoding='utf-8')
print('R80_PATCH',path.name,'new chars',len(s))

# Prove Golden camera code is not touched by this patch script.
assert (ROOT/'MoaMomentCaptureService.java').is_file()
print('R80_PATCH_NATIVE_SOURCES=PASS')