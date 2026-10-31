package com.juhyeon.familyjourney;

import android.net.Uri;
import android.webkit.WebResourceResponse;
import java.io.ByteArrayInputStream;
import java.nio.charset.StandardCharsets;
import java.util.Collections;
import java.util.Locale;

/**
 * All network requests from the independently signed app pass the local allowlist.
 * No original publisher server, OAuth bridge or analytics may receive requests.
 * Other services (OSM/Esri map tiles, independent wikipedia thumbnails) may still
 * observe tile coordinates/IP. Do NOT claim this is network-free.
 */
public final class NetworkPolicy {
  private NetworkPolicy() {}
  private static final String[] ALLOWED = {
    "familyjourney.local",
    "tile.openstreetmap.org",
    "server.arcgisonline.com",
    "upload.wikimedia.org",
    "commons.wikimedia.org",
    "ko.wikipedia.org",
    "en.wikipedia.org",
    "www.wikidata.org",
    "map.naver.com",
    "m.map.naver.com",
    "apis.data.go.kr",
    "korean.visitkorea.or.kr"
  };
  private static boolean hostEq(String host,String value) { return host.equals(value); }
  public static boolean isPublisher(Uri u) {
    String host=u==null||u.getHost()==null?"":u.getHost().toLowerCase(Locale.ROOT);
    return host.equals("hueeng.com")||host.endsWith(".hueeng.com")||
           host.equals("leehueeng.github.io");
  }
  public static boolean permitted(Uri u) {
    if(u==null)return false;
    String scheme=u.getScheme();
    if(!"https".equalsIgnoreCase(scheme))return false;
    if(isPublisher(u))return false;
    String host=u.getHost()==null?"":u.getHost().toLowerCase(Locale.ROOT);
    for(String allowed:ALLOWED) if(hostEq(host,allowed))return true;
    return false;
  }
  public static WebResourceResponse denied() {
    byte[] body="{\"error\":\"blocked_by_personal_app_privacy_policy\"}".getBytes(StandardCharsets.UTF_8);
    return new WebResourceResponse("application/json","UTF-8",403,"Forbidden",
      Collections.singletonMap("Access-Control-Allow-Origin","*"),
      new ByteArrayInputStream(body));
  }
}
