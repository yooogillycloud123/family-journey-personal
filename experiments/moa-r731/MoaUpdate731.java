package com.juhyeon.familyjournea;
import android.app.Activity;
import android.app.AlertDialog;
import android.content.pm.PackageInfo;
import android.os.Build;
import java.io.*;
import java.net.*;
import java.nio.charset.StandardCharsets;
import java.text.SimpleDateFormat;
import java.util.*;
import java.lang.reflect.*;
import org.json.*;

/** Only manifest retrieval and presentation are changed. R729 download, cert, hash and installer stay authoritative. */
public final class MoaUpdate731 {
  private static final String URL0="https://raw.githubusercontent.com/yooogillycloud123/family-journey-personal/moa-update-channel/android/latest.json";
  private static final String PKG="com.juhyeon.familyjournea", CERT="5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15";
  private static Method original(String method,Class<?>...types)throws Exception{Method m=Class.forName("com.juhyeon.familyjournea.MoaUpdate723").getDeclaredMethod(method,types);m.setAccessible(true);return m;}
  private static long installed(Activity a)throws Exception{PackageInfo i=a.getPackageManager().getPackageInfo(a.getPackageName(),0);return Build.VERSION.SDK_INT>=28?i.getLongVersionCode():i.versionCode;}
  private static String time(){return new SimpleDateFormat("yyyy-MM-dd HH:mm:ss",Locale.KOREA).format(new Date());}
  private static void dialog(Activity a,String title,String s){a.runOnUiThread(()->{if(!a.isFinishing()&&!a.isDestroyed())new AlertDialog.Builder(a).setTitle(title).setMessage(s).setPositiveButton("확인",null).show();});}
  private static JSONObject read()throws Exception{HttpURLConnection c=(HttpURLConnection)new URL(URL0+"?moa_check="+UUID.randomUUID()).openConnection();c.setConnectTimeout(12000);c.setReadTimeout(15000);c.setUseCaches(false);c.setInstanceFollowRedirects(false);c.setRequestProperty("Cache-Control","no-cache, max-age=0");c.setRequestProperty("Pragma","no-cache");c.setRequestProperty("Accept-Encoding","identity");try{int status=c.getResponseCode();if(status!=200)throw new IOException("HTTP "+status);try(InputStream in=c.getInputStream();ByteArrayOutputStream out=new ByteArrayOutputStream()){byte[] b=new byte[4096];int n;while((n=in.read(b))!=-1){if(out.size()+n>131072)throw new IOException("Manifest too large");out.write(b,0,n);}return new JSONObject(new String(out.toByteArray(),StandardCharsets.UTF_8));}}finally{c.disconnect();}}
  public static void open(Activity a){if(a==null)return;new Thread(()->{long local=-1;try{local=installed(a);JSONObject j=read();long server=j.getLong("versionCode");if(!PKG.equals(j.getString("packageName"))||!CERT.equals(j.getString("signerSha256"))||server<=0)throw new IOException("배포 대상 검증 실패");String info="설치 R"+local+" · 서버 응답 R"+server+"\n조회 "+time();if(!j.getBoolean("published")){dialog(a,"모아 업데이트",info+"\n서버 배포 미활성");return;}original("validate",JSONObject.class,long.class).invoke(null,j,-1L);if(server<local){dialog(a,"모아 업데이트",info+"\n서버에 이전 버전이 응답했습니다. 새 배포 여부를 확정할 수 없습니다.");return;}if(server==local){dialog(a,"모아 업데이트",info+"\n조회 응답은 설치 버전과 동일합니다.");return;}a.runOnUiThread(()->{if(a.isFinishing()||a.isDestroyed())return;new AlertDialog.Builder(a).setTitle("모아 새 업데이트 R"+server).setMessage(info+"\n\n"+j.optString("notes","")+"\n기존 기록을 유지합니다.").setPositiveButton("다운로드 및 설치",(d,k)->{try{original("download",Activity.class,JSONObject.class).invoke(null,a,j);}catch(Exception e){dialog(a,"업데이트 실패","설치 진입 실패 · "+e.getClass().getSimpleName());}}).setNegativeButton("취소",null).show();});}catch(Exception e){dialog(a,"모아 업데이트 조회 실패","설치 R"+local+"\n조회 "+time()+"\n"+e.getClass().getSimpleName()+": "+String.valueOf(e.getMessage()));}},"MOA-R731-update").start();}
}
