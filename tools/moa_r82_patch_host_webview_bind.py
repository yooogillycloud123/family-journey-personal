#!/usr/bin/env python3
"""R82: bind STT to HostActivity's real private WebView field, not only its view tree.
Runs after R80 and R81 scripts in the isolated DEX compile. Golden classes2.dex untouched.
Confirmed ORIGINAL packed HostActivity dex field: Landroid/webkit/WebView; web.
"""
from pathlib import Path
root=Path("android/app/src/main/java/com/juhyeon/familyjourney")
def patch(name,old,new):
 p=root/name;s=p.read_text(encoding="utf8")
 assert s.count(old)==1,(name,s.count(old),old[:80])
 result=s.replace(old,new)
 p.write_text(result,encoding="utf8")
 print("R82_PATCH",name,len(s),"->",len(result))
patch("MoaMomentApplication.java",
'''  private boolean install(Activity a){''',
'''  // The original, signed HostActivity stores its actual WebView in private
  // field `web` (confirmed from original classes2.dex). It need not be a
  // descendant of the Activity decorView when this callback first runs.
  // Read-only reflection only; never touch HostActivity's source or DEX.
  private WebView hostWebView(Activity a){
    if(a==null)return null;
    try{
      Class<?> cls=a.getClass();
      while(cls!=null&&cls!=Activity.class){
        try{
          java.lang.reflect.Field f=cls.getDeclaredField("web");
          if(WebView.class.isAssignableFrom(f.getType())){
            f.setAccessible(true);
            Object value=f.get(a);
            if(value instanceof WebView)return (WebView)value;
          }
        }catch(NoSuchFieldException absent){}
        cls=cls.getSuperclass();
      }
    }catch(Throwable ex){
      MoaMomentCaptureService.prefs(this).edit().putString(
        "r82HostWebFieldError",ex.getClass().getSimpleName()).apply();
    }
    try{return findWebView(a.getWindow().getDecorView());}
    catch(Throwable ignored){return null;}
  }
  private boolean install(Activity a){''')
patch("MoaMomentApplication.java",
'    final WebView web=findWebView(a.getWindow().getDecorView());',
'    final WebView web=hostWebView(a);')
patch("MoaMomentApplication.java",
'    WebView web=findWebView(a.getWindow().getDecorView());',
'    WebView web=hostWebView(a);')
patch("MoaMomentVoiceChrome.java",
'  private static boolean sameTrustedOrigin(String value){',
'  public static boolean sameTrustedOrigin(String value){')
patch("MoaMomentVoiceBridge.java",
'      &&v.getUrl()!=null&&v.getUrl().startsWith("https://familyjourney.local/");',
'      &&MoaMomentVoiceChrome.sameTrustedOrigin(v.getUrl());')
patch("MoaMomentApplication.java",
'          &&web.getUrl()!=null&&web.getUrl().startsWith("https://familyjourney.local/")',
'          &&MoaMomentVoiceChrome.sameTrustedOrigin(web.getUrl())')
patch("MoaMomentApplication.java",
'      if(url!=null&&url.startsWith("https://familyjourney.local/"))',
'      if(MoaMomentVoiceChrome.sameTrustedOrigin(url))')
# R81 uses WebView's current Chrome to determine if bridge is attached; record
# errors and status without displaying private data or saving edited diary.
patch("MoaMomentApplication.java",
'''    if(voice==null)return;
    try{''',
'''    if(voice==null){
      MoaMomentCaptureService.prefs(this).edit().putString(
        "r82VoiceBind","NO_VOICE_OBJECT host.web="+(web!=null)).apply();
      return;
    }
    try{''')
patch("MoaMomentApplication.java",
'''      if(!(web.getWebChromeClient() instanceof MoaMomentVoiceChrome))
        web.setWebChromeClient(new MoaMomentVoiceChrome(web.getWebChromeClient(),voice));''',
'''      if(!(web.getWebChromeClient() instanceof MoaMomentVoiceChrome)){
        web.setWebChromeClient(new MoaMomentVoiceChrome(web.getWebChromeClient(),voice));
        MoaMomentCaptureService.prefs(this).edit().putString(
          "r82VoiceBind","CHROME_REWRAPPED").apply();
      }''')
print("R82_ORIGINAL_HOST_FIELD_BIND=PASS")
