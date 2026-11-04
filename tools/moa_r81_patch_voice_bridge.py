#!/usr/bin/env python3
"""R81: make the existing R80 native speech bridge persist across WebChromeClient replacement.
Runs ONLY after tools/moa_r80_patch_native.py in the isolated Java build.
Does not touch any media, camera, diary-store or lockscreen code.
"""
from pathlib import Path
root=Path("android/app/src/main/java/com/juhyeon/familyjourney")
def replace(name, old, new):
 p=root/name; s=p.read_text(encoding="utf-8")
 assert s.count(old)==1, f"{name}: expected exactly 1 anchor, found {s.count(old)}: {old[:100]}"
 p.write_text(s.replace(old,new),encoding="utf-8")
 print("R81_PATCH",name,len(s),"->",len(s.replace(old,new)))
replace("MoaMomentVoiceChrome.java",
  '    return url!=null && url.startsWith("https://familyjourney.local/")\n      && view!=null && view.getUrl()!=null\n      && view.getUrl().startsWith("https://familyjourney.local/");',
  '''    return sameTrustedOrigin(url) && view!=null && sameTrustedOrigin(view.getUrl());
  }
  private static boolean sameTrustedOrigin(String value){
    if(value==null)return false;
    try{
      android.net.Uri u=android.net.Uri.parse(value);
      return "https".equalsIgnoreCase(u.getScheme())
        && "familyjourney.local".equalsIgnoreCase(u.getHost())
        && (u.getPort()==-1 || u.getPort()==443)
        && u.getUserInfo()==null;
    }catch(Exception invalid){return false;}''')
# Foreground watchdog uses a generation number: no stale loops after pause/resume.
# R80's two delayed re-arm attempts lose against HostActivity's later Chrome
# replacements; R81 repairs whichever client is CURRENT, not the cached state.
replace("MoaMomentApplication.java",
 '  private final WeakHashMap<WebView,MoaMomentVoiceBridge> voices=new WeakHashMap<>();',
 '''  private final WeakHashMap<WebView,MoaMomentVoiceBridge> voices=new WeakHashMap<>();
  private final WeakHashMap<Activity,Integer> voiceWatchGenerations=new WeakHashMap<>();
  private int voiceWatchNext=0;''')
replace("MoaMomentApplication.java",
 '''    if("com.juhyeon.familyjourney.HostActivity".equals(a.getClass().getName())){
      // A late HostActivity setWebChromeClient can replace the R79 adapter.
      // Repeat only foreground registration (NO WebView reload or DB edit).
      rearmVoiceChrome(a);
      main.postDelayed(()->rearmVoiceChrome(a),350L);
      main.postDelayed(()->rearmVoiceChrome(a),1350L);
    }''',
 '''    if("com.juhyeon.familyjourney.HostActivity".equals(a.getClass().getName()))
      watchVoiceChrome(a);''')
replace("MoaMomentApplication.java",
 '  private void rearmVoiceChrome(Activity a){',
 '''  private void watchVoiceChrome(Activity a){
    if(a==null||a.isDestroyed()||a.isFinishing())return;
    final int gen=++voiceWatchNext;
    voiceWatchGenerations.put(a,gen);
    final Runnable[] tick=new Runnable[1];
    tick[0]=()->{
      Integer live=voiceWatchGenerations.get(a);
      if(live==null||live!=gen||a.isDestroyed()||a.isFinishing())return;
      rearmVoiceChrome(a);
      // A previous release is sometimes overwritten after >1.35s.
      // Only check the current Chrome; no WebView reload, no new SpeechRecognizer.
      main.postDelayed(tick[0],350L);
    };
    main.post(tick[0]);
  }
  private void rearmVoiceChrome(Activity a){''')
replace("MoaMomentApplication.java",
 '''  @Override public void onActivityPaused(Activity a){}''',
 '''  @Override public void onActivityPaused(Activity a){voiceWatchGenerations.remove(a);}''')
replace("MoaMomentApplication.java",
 '''  @Override public void onActivityDestroyed(Activity a){}''',
 '''  @Override public void onActivityDestroyed(Activity a){voiceWatchGenerations.remove(a);}''')
replace("MoaMomentApplication.java",
 '        web.evaluateJavascript("window.__moaR79VoicePromptReady=true;window.__moaR80VoiceChromeLive=true;",null);',
 '        web.evaluateJavascript("window.__moaR79VoicePromptReady=true;window.__moaR80VoiceChromeLive=true;window.__moaR81VoiceChromeLiveAt=Date.now();",null);')
# Never reload an editor in progress, even on the first native interface install.
replace("MoaMomentApplication.java",
 '''            try{web.reload();}
            catch(Exception e){MoaMomentCaptureService.prefs(this).edit()
              .putString("bridgeDiagnostic","R49 reload failed: "+e).apply();}''',
 '''            try{
              web.evaluateJavascript("(function(){try{return !!(window.FamilyJourneyDiary&&window.FamilyJourneyDiary.state&&window.FamilyJourneyDiary.state.editing)}catch(e){return true}})()",
                editing->{
                  if(!"false".equals(editing))return;
                  try{web.reload();}catch(Exception ignored){}
                });
            }catch(Exception e){MoaMomentCaptureService.prefs(this).edit()
              .putString("bridgeDiagnostic","R81 safe-reload check failed: "+e).apply();}''')
print("R81_WATCHDOG_PATCH=PASS")
