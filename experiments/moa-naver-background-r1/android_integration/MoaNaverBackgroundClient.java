package com.juhyeon.familyjourney;

import android.content.Context;
import org.json.JSONObject;
import java.net.URL;
import java.security.MessageDigest;
import java.security.SecureRandom;
import java.security.cert.X509Certificate;
import java.nio.charset.StandardCharsets;
import javax.net.ssl.HttpsURLConnection;
import javax.net.ssl.SSLContext;
import javax.net.ssl.TrustManager;
import javax.net.ssl.X509TrustManager;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.ByteArrayOutputStream;

/** SOURCE-ONLY R&D bridge contract; NOT included in the R233 APK.
 * Caller must be on a worker thread. User pairs a PC server URL, private bearer token,
 * and SHA-256 of the PC-generated TLS certificate. Never persist credentials in logs,
 * GitHub or unencrypted exported diary data. Never mark save completed on 202 alone.
 */
public final class MoaNaverBackgroundClient {
  private MoaNaverBackgroundClient(){}
  public static String newRequestId(){return java.util.UUID.randomUUID().toString();}
  public static String submit(String pcHttpsBase,String tlsCertSha256,String privatePairToken,
      String uuid,String placeName,String address,String listName,String alias,String memo,
      String exactNaverPlaceId) throws Exception {
    JSONObject item=new JSONObject();
    item.put("job_id",uuid);
    item.put("place_name",placeName);
    item.put("address",address);
    item.put("list_name",listName);
    item.put("alias",alias==null?"":alias);
    item.put("memo",memo==null?"":memo);
    item.put("naver_place_id",exactNaverPlaceId==null?"":exactNaverPlaceId);
    // Do NOT infer a Naver POI ID from photo MediaStore ID, raw GPS, or text alone.
    return request("POST",pcHttpsBase,"/v1/favorites",tlsCertSha256,privatePairToken,item.toString());
  }
  public static String status(String pcHttpsBase,String tlsCertSha256,String privatePairToken,String jobId) throws Exception {
    if(!jobId.matches("[A-Fa-f0-9-]{36}"))throw new IllegalArgumentException("INVALID_JOB_ID");
    return request("GET",pcHttpsBase,"/v1/favorites/"+jobId,tlsCertSha256,privatePairToken,null);
  }
  private static String request(String method,String base,String path,String pin,String token,String body) throws Exception {
    URL root=new URL(base);
    if(!"https".equals(root.getProtocol()))throw new IllegalArgumentException("HTTPS_REQUIRED");
    if(root.getUserInfo()!=null||root.getQuery()!=null||root.getRef()!=null)throw new IllegalArgumentException("INVALID_SERVER_URL");
    if(!pin.matches("(?i)[0-9a-f]{64}"))throw new IllegalArgumentException("INVALID_TLS_PIN");
    if(token==null||token.length()<24)throw new IllegalArgumentException("PRIVATE_TOKEN_REQUIRED");
    TrustManager[] trust={new X509TrustManager(){
      @Override public X509Certificate[] getAcceptedIssuers(){return new X509Certificate[0];}
      @Override public void checkClientTrusted(X509Certificate[] c,String authType){throw new UnsupportedOperationException();}
      @Override public void checkServerTrusted(X509Certificate[] chain,String authType)
          throws java.security.cert.CertificateException {
        if(chain==null||chain.length==0)throw new java.security.cert.CertificateException("TLS_EMPTY_CHAIN");
        try{
          byte[] hash=MessageDigest.getInstance("SHA-256").digest(chain[0].getEncoded());
          StringBuilder hex=new StringBuilder();for(byte b:hash)hex.append(String.format(java.util.Locale.ROOT,"%02x",b&0xff));
          if(!hex.toString().equalsIgnoreCase(pin))throw new java.security.cert.CertificateException("TLS_PIN_MISMATCH");
          chain[0].checkValidity();
        }catch(java.security.cert.CertificateException e){throw e;}
        catch(Exception e){throw new java.security.cert.CertificateException("TLS_CHECK_FAILED",e);}
      }
    }};
    SSLContext ssl=SSLContext.getInstance("TLS");ssl.init(null,trust,new SecureRandom());
    HttpsURLConnection c=(HttpsURLConnection)new URL(root.toString().replaceAll("/+$","")+path).openConnection();
    c.setSSLSocketFactory(ssl.getSocketFactory());
    // The default hostname verifier remains enabled. PC cert SAN must match its LAN IP.
    c.setRequestMethod(method);c.setConnectTimeout(8000);c.setReadTimeout(12000);
    c.setRequestProperty("Authorization","Bearer "+token);
    c.setRequestProperty("Accept","application/json");
    c.setInstanceFollowRedirects(false);
    if("POST".equals(method)){
      c.setDoOutput(true);c.setRequestProperty("Content-Type","application/json; charset=utf-8");
      byte[] bytes=body.getBytes(StandardCharsets.UTF_8);
      if(bytes.length>4096)throw new IllegalArgumentException("REQUEST_TOO_LARGE");
      try(OutputStream out=c.getOutputStream()){out.write(bytes);}
    }
    try{
      int response=c.getResponseCode();
      if(response<200||response>=300)throw new java.io.IOException("MOA_BRIDGE_HTTP_"+response);
      try(InputStream in=c.getInputStream();ByteArrayOutputStream out=new ByteArrayOutputStream()){
        byte[] buf=new byte[1024];int n;
        while((n=in.read(buf))>=0){out.write(buf,0,n);if(out.size()>8192)throw new java.io.IOException("RESPONSE_TOO_LARGE");}
        return out.toString("UTF-8");
      }
    }finally{c.disconnect();}
  }
}
