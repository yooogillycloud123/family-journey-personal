package com.juhyeon.familyjourney;

import java.net.URI;
import java.util.Locale;

/**
 * Narrow, read-only NAVER authentication navigation classifier.
 *
 * A visible official login page belongs to the user. The companion provider
 * must not start an offscreen session or dispatch favorite writes while it is
 * present. No bypass, JavaScript injection, cookie access, credentials, or
 * account mutation is performed here.
 */
public final class MoaNaverAuthUrl {
  private MoaNaverAuthUrl(){}
  public static boolean isOfficialLogin(String raw){
    if(raw==null||raw.length()>4096)return false;
    try{
      URI uri=new URI(raw);
      if(!"https".equalsIgnoreCase(uri.getScheme()))return false;
      String host=uri.getHost();
      if(host==null)return false;
      host=host.toLowerCase(Locale.ROOT);
      return host.equals("nid.naver.com")
        || host.equals("nidlogin.naver.com")
        || host.equals("account.naver.com")
        || host.equals("accounts.naver.com");
    }catch(Exception ignored){return false;}
  }
}
