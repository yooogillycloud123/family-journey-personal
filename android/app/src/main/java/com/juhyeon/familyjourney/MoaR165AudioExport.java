package com.juhyeon.familyjourney;

import android.content.ContentResolver;
import android.content.ContentValues;
import android.content.Context;
import android.content.SharedPreferences;
import android.net.Uri;
import android.os.Build;
import android.os.Environment;
import android.provider.MediaStore;
import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.io.OutputStream;
import java.security.MessageDigest;
import java.util.Locale;
import java.util.ArrayList;

/**
 * R165 additive backup of app-private M4A to user-visible MediaStore.
 * NEVER deletes or moves any original. Every public copy must pass a SHA-256
 * read-back before becoming visible (IS_PENDING=0). A partial copy is removed
 * only if THIS operation created it; preexisting user files are never deleted.
 *
 * Intentional staged migration: original R163 list/play/STT/diary code remains
 * untouched and still reads the private M4A. Reducing duplicate space is
 * explicitly NOT part of this safety-first export phase.
 */
public final class MoaR165AudioExport {
  public static final String PREF="moa.r165.audio.backup.v1";
  public static final String AUTO="autoNew";
  public static final String FOLDER="Music/MOA-Recordings/";
  private MoaR165AudioExport(){}

  public interface Listener {
    void update(int done,int total,int copied,int existing,int failed,long copiedBytes,String lastMessage);
    void complete(Summary result);
  }
  public static final class Summary{
    public int total,copied,existing,failed;
    public long copiedBytes;
    public String errors="";
    public String describe(){
      return "녹음 외부 보관: 새 복사 "+copied+"건, 기존 확인 "+existing+
          "건, 실패 "+failed+"건 · "+formatBytes(copiedBytes)+
          (failed>0?" / "+errors:"")+"\n앱 내부 원본은 그대로 유지됩니다.";
    }
  }
  public static String formatBytes(long b){
    if(b<1024)return b+"B";
    if(b<1048576)return String.format(Locale.US,"%.1f KB",b/1024.0);
    if(b<1073741824L)return String.format(Locale.US,"%.1f MB",b/1048576.0);
    return String.format(Locale.US,"%.2f GB",b/1073741824.0);
  }
  public static boolean supported(){return Build.VERSION.SDK_INT>=29;}
  public static boolean auto(Context c){
    return c.getSharedPreferences(PREF,Context.MODE_PRIVATE).getBoolean(AUTO,false);
  }
  public static void setAuto(Context c,boolean enabled){
    c.getSharedPreferences(PREF,Context.MODE_PRIVATE).edit().putBoolean(AUTO,enabled).apply();
  }

  private static boolean validDay(String s){
    return s!=null&&s.matches("[0-9]{4}-[0-9]{2}-[0-9]{2}");
  }
  private static boolean validFile(String s){
    return s!=null&&s.matches("[0-9a-zA-Z_-]{8,90}\\.m4a");
  }
  private static byte[] digest(InputStream stream)throws Exception{
    MessageDigest d=MessageDigest.getInstance("SHA-256");
    byte[] b=new byte[65536];int n;
    while((n=stream.read(b))!=-1)if(n>0)d.update(b,0,n);
    return d.digest();
  }
  private static String hex(byte[] b){
    StringBuilder s=new StringBuilder(b.length*2);
    for(byte v:b)s.append(String.format(Locale.US,"%02x",v&255));
    return s.toString();
  }
  private static String fileHash(File f)throws Exception{
    try(InputStream in=new FileInputStream(f)){return hex(digest(in));}
  }
  private static boolean validBackup(Context ctx,Uri uri,long expectedBytes,String expectedHash){
    try(InputStream in=ctx.getContentResolver().openInputStream(uri)){
      if(in==null)return false;
      MessageDigest md=MessageDigest.getInstance("SHA-256");
      long count=0;byte[] buf=new byte[65536];int n;
      while((n=in.read(buf))!=-1){if(n>0){md.update(buf,0,n);count+=n;}}
      return count==expectedBytes&&hex(md.digest()).equals(expectedHash);
    }catch(Exception ignored){return false;}
  }
  private static Uri findExisting(Context ctx,String name,String relative,long bytes,String hash){
    ContentResolver cr=ctx.getContentResolver();
    try{
      Uri coll=MediaStore.Audio.Media.getContentUri(MediaStore.VOLUME_EXTERNAL_PRIMARY);
      String sel=MediaStore.MediaColumns.DISPLAY_NAME+"=? AND "+MediaStore.MediaColumns.RELATIVE_PATH+"=?";
      try(android.database.Cursor cur=cr.query(coll,
        new String[]{MediaStore.Audio.Media._ID},
        sel,new String[]{name,relative},null)){
        if(cur==null)return null;
        while(cur.moveToNext()){
          Uri test=android.content.ContentUris.withAppendedId(coll,cur.getLong(0));
          if(validBackup(ctx,test,bytes,hash))return test;
        }
      }
    }catch(Exception ignored){}
    return null;
  }
  public static final class ExportResult{
    public final boolean copied;
    public final boolean existing;
    public final long bytes;
    public final String message;
    ExportResult(boolean newCopy,boolean same,long size,String msg){
      copied=newCopy;existing=same;bytes=size;message=msg;
    }
  }

  public static ExportResult copy(Context app,File original,String day)throws Exception{
    if(!supported())throw new IllegalStateException("Android 10 이상에서만 외부 저장을 지원합니다.");
    if(!validDay(day)||original==null||!validFile(original.getName())
        ||!original.isFile()||original.length()==0)
      throw new IllegalArgumentException("원본 날짜 또는 녹음 파일이 유효하지 않습니다.");
    // Explicitly require this file to be inside the expected canonical folder.
    File canonicalRoot=new File(app.getFilesDir(),"moa-original-audio");
    File expected=new File(new File(canonicalRoot,day),original.getName());
    if(!original.getCanonicalPath().equals(expected.getCanonicalPath())||
       !original.getCanonicalPath().startsWith(canonicalRoot.getCanonicalPath()+File.separator))
      throw new SecurityException("앱 외부의 임의 파일은 자동 보관하지 않습니다.");

    final String hash=fileHash(original);
    final long size=original.length();
    final String relative=Environment.DIRECTORY_MUSIC+"/MOA-Recordings/"+day+"/";
    final String filename="MOA_"+day+"_"+original.getName();
    final String key=day+"/"+original.getName();
    SharedPreferences p=app.getSharedPreferences(PREF,Context.MODE_PRIVATE);
    String previous=p.getString("uri:"+key,"");
    if(!previous.isEmpty()){
      try{
        Uri uri=Uri.parse(previous);
        if(validBackup(app,uri,size,hash))
          return new ExportResult(false,true,size,"이미 안전 보관된 원본 확인");
      }catch(Exception ignored){}
    }
    Uri found=findExisting(app,filename,relative,size,hash);
    if(found!=null){
      if(!p.edit().putString("uri:"+key,found.toString())
          .putString("sha:"+key,hash).commit())
        throw new IllegalStateException("안전 보관 색인 저장 실패");
      return new ExportResult(false,true,size,"기존 외부 원본 검증 완료");
    }
    ContentResolver cr=app.getContentResolver();
    Uri collection=MediaStore.Audio.Media.getContentUri(MediaStore.VOLUME_EXTERNAL_PRIMARY);
    ContentValues values=new ContentValues();
    values.put(MediaStore.Audio.Media.DISPLAY_NAME,filename);
    values.put(MediaStore.Audio.Media.MIME_TYPE,"audio/mp4");
    values.put(MediaStore.Audio.Media.RELATIVE_PATH,relative);
    values.put(MediaStore.Audio.Media.IS_PENDING,1);
    Uri uri=cr.insert(collection,values);
    if(uri==null)throw new IllegalStateException("외부 녹음 저장 공간을 열지 못했습니다.");
    boolean complete=false;
    try{
      // Do not publish an unverified partial file. Leave the app-private
      // original byte-for-byte unchanged on all failure paths.
      try(InputStream from=new FileInputStream(original);
          OutputStream out=cr.openOutputStream(uri,"w")){
        if(out==null)throw new java.io.IOException("외부 녹음 쓰기 스트림 없음");
        byte[] buffer=new byte[65536];int read;
        while((read=from.read(buffer))!=-1)if(read>0)out.write(buffer,0,read);
        out.flush();
      }
      if(!validBackup(app,uri,size,hash))
        throw new java.io.IOException("백업 무결성 검증 실패(SHA-256/길이)");
      ContentValues publish=new ContentValues();
      publish.put(MediaStore.Audio.Media.IS_PENDING,0);
      if(cr.update(uri,publish,null,null)!=1)
        throw new java.io.IOException("완료된 녹음의 공개 처리 실패");
      complete=true;
      if(!p.edit().putString("uri:"+key,uri.toString())
          .putString("sha:"+key,hash).commit())
        throw new java.io.IOException("외부 녹음 연결정보 저장 실패");
      return new ExportResult(true,false,size,"원본 SHA-256 일치 · 외부 보관 완료");
    }finally{
      if(!complete){
        try{cr.delete(uri,null,null);}catch(Exception ignored){}
      }
    }
  }
  public static Summary exportAll(Context ctx,Listener listener){
    Summary sum=new Summary();
    File root=new File(ctx.getFilesDir(),"moa-original-audio");
    ArrayList<File> inputs=new ArrayList<>();
    File[] days=root.listFiles();
    if(days!=null)for(File d:days){
      if(!d.isDirectory()||!validDay(d.getName()))continue;
      File[] files=d.listFiles();
      if(files!=null)for(File f:files)if(f.isFile()&&validFile(f.getName()))inputs.add(f);
    }
    sum.total=inputs.size();
    int done=0;
    for(File f:inputs){
      String msg="";
      try{
        ExportResult x=copy(ctx,f,f.getParentFile().getName());
        if(x.copied){sum.copied++;sum.copiedBytes+=x.bytes;}
        if(x.existing)sum.existing++;
        msg=x.message;
      }catch(Exception e){
        sum.failed++;
        if(sum.errors.length()<240)sum.errors+=e.getClass().getSimpleName()+": "+e.getMessage()+"; ";
        msg="외부 보관 실패 · 앱 내부 원본 유지";
      }
      done++;
      if(listener!=null)listener.update(done,sum.total,sum.copied,sum.existing,sum.failed,sum.copiedBytes,msg);
    }
    if(listener!=null)listener.complete(sum);
    return sum;
  }
}
