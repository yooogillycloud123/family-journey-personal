package com.juhyeon.familyjourney;

/** Standalone Java regression gates: no Android runtime or personal login. */
public final class MoaNaverAuthUrlTest {
  private static void expect(String url,boolean shouldPause){
    boolean actual=MoaNaverAuthUrl.isOfficialLogin(url);
    if(actual!=shouldPause)
      throw new AssertionError(url+" expected="+shouldPause+" actual="+actual);
  }
  public static void main(String[] args){
    expect("https://nid.naver.com/nidlogin.login",true);
    expect("https://NID.NAVER.COM/nidlogin.login",true);
    expect("https://nidlogin.naver.com/login",true);
    expect("https://account.naver.com/",true);
    expect("https://accounts.naver.com/",true);
    expect("https://map.naver.com/p/",false);
    expect("https://pcmap.place.naver.com/place/123/home",false);
    expect("https://evil-nid.naver.com/nidlogin.login",false);
    expect("https://nid.naver.com.attacker.example/",false);
    expect("http://nid.naver.com/nidlogin.login",false);
    expect("file:///android_asset/index.html",false);
    expect("https://familyjourney.local/",false);
    expect(null,false);
    expect("",false);
    System.out.println("R373_AUTH_HOST_CONTRACT_PASS");
  }
}
