package com.juhyeon.familyjournea;

import android.app.Activity;
import android.content.ContentProvider;
import android.content.ContentUris;
import android.content.Context;
import android.content.res.AssetFileDescriptor;
import android.database.Cursor;
import android.database.MatrixCursor;
import android.media.MediaDataSource;
import android.net.Uri;
import android.os.Binder;
import android.os.Handler;
import android.os.HandlerThread;
import android.os.ParcelFileDescriptor;
import android.os.Process;
import android.os.ProxyFileDescriptorCallback;
import android.os.storage.StorageManager;
import android.provider.MediaStore;
import android.system.ErrnoException;
import android.system.OsConstants;
import android.util.Base64;
import android.webkit.WebView;
import java.io.*;
import java.lang.reflect.*;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.util.*;
import java.util.concurrent.*;
import org.json.*;

/** Read-only remote timeline adapter. Existing R729 pinned TLS client and range source are reused.
 * Virtual IDs are transient UI handles, never written into local diary or MediaStore. */
public final class MoaRemoteTimeline731 {
    private static final String AUTH="com.juhyeon.familyjournea.moa_r717_peer";
    private static final String PREFIX="timeline731:";
    private static final String ROOT="com.juhyeon.familyjournea.MoaRemote721";
    private static final long ID_BASE=880000000000000000L, ID_LIMIT=890000000000000000L;
    private static final int MAX_LIST=2*1024*1024, MAX_THUMB=1024*1024;
    private static final ExecutorService WORK=Executors.newSingleThreadExecutor();
    private static volatile Object owner;
    private static volatile String activePin="";
    private static volatile Map<String,Row> active=Collections.emptyMap();
    private static final Map<String,Row> staged=new LinkedHashMap<>();
    private static volatile long generation=0;
    private static Handler ioHandler;
    private static synchronized Handler ioHandler(){if(ioHandler==null){HandlerThread t=new HandlerThread("MoaRemote731-read");t.start();ioHandler=new Handler(t.getLooper());}return ioHandler;}
    private static Object call(Object target,String name,Class<?>[] types,Object...args)throws Exception{Method m=target.getClass().getDeclaredMethod(name,types);m.setAccessible(true);return m.invoke(target,args);}
    private static Object field(Object target,String name)throws Exception{Field f=target.getClass().getDeclaredField(name);f.setAccessible(true);return f.get(target);}
    private static JSONObject config(Object p)throws Exception{Object provider=call(p,"provider",new Class<?>[0]);JSONObject cfg=(JSONObject)call(p,"current",new Class<?>[]{Object.class},provider);if(cfg==null||!cfg.optString("pin").matches("[a-f0-9]{64}"))throw new IOException("등록된 직접 연결 없음");return cfg;}
    private static boolean allowed(Object p,String pin){try{return p!=null&&!"off".equals(field(p,"mode"))&&pin.equals(config(p).optString("pin"));}catch(Exception e){return false;}}
    private static void finish(Object p,WebView w,int id,boolean ok,String result){w.post(()->{try{if(field(p,"view")==w)call(p,"finish",new Class<?>[]{WebView.class,int.class,boolean.class,String.class},w,id,ok,result);}catch(Exception ignored){}});}
    private static Class<?> clientClass()throws Exception{return Class.forName(ROOT+"$Client");}
    private static Object client(JSONObject c)throws Exception{Constructor<?> k=clientClass().getDeclaredConstructor(JSONObject.class);k.setAccessible(true);return k.newInstance(c);}
    private static byte[] bytes(Object c,String path,int max)throws Exception{return (byte[])call(c,"get",new Class<?>[]{String.class,int.class,long.class,long.class,long.class},path,max,-1L,-1L,-1L);}
    private static MediaDataSource source(Row row)throws Exception{JSONObject cfg=config(owner);if(!allowed(owner,row.pin))throw new IOException("연결 중지");Class<?> cl=Class.forName(ROOT+"$Source");Constructor<?> k=cl.getDeclaredConstructor(clientClass(),String.class,long.class);k.setAccessible(true);return (MediaDataSource)k.newInstance(client(cfg),row.original,row.size);}
    private static final class Row{
        final String pin,original,id,day,name,mime;final long size,t,duration;final Double lat,lon;
        Row(String pin,JSONObject j)throws Exception{this.pin=pin;original=j.getString("id");day=j.getString("day");name=j.optString("name","");mime=j.getString("mime");size=j.getLong("size");if(!day.matches("\\d{4}-\\d{2}-\\d{2}")||size<=0||size>Long.MAX_VALUE/2)throw new IOException("catalog record invalid");boolean audio=mime.startsWith("audio/");if(audio?!original.matches("a:[A-Za-z0-9_.-]{1,200}"):!original.matches("(?:v[0-9]{1,18}|[0-9]{1,19})"))throw new IOException("catalog id invalid");if(!(mime.startsWith("image/")||mime.startsWith("video/")||audio))throw new IOException("catalog mime invalid");byte[] h=MessageDigest.getInstance("SHA-256").digest((pin+"\u0000"+original).getBytes(StandardCharsets.UTF_8));long x=0;for(int i=0;i<7;i++)x=(x<<8)|(h[i]&255);String v=Long.toString(ID_BASE+x%(ID_LIMIT-ID_BASE));id=audio?"a:"+v:mime.startsWith("video/")?"v"+v:v;t=j.optLong("t",0);duration=j.optLong("duration",0);lat=coord(j,"lat",90);lon=coord(j,"lon",180);}
        JSONObject json()throws Exception{return new JSONObject().put("id",id).put("day",day).put("name",name).put("mime",mime).put("size",size).put("t",t).put("duration",duration).put("lat",lat==null?JSONObject.NULL:lat).put("lon",lon==null?JSONObject.NULL:lon);}
    }
    private static Double coord(JSONObject j,String k,int bound){double v=j.optDouble(k,Double.NaN);return Double.isFinite(v)&&Math.abs(v)<=bound?v:null;}
    public static boolean virtual(String id){try{String s=id.startsWith("v")?id.substring(1):id.startsWith("a:")?id.substring(2):id;long n=Long.parseLong(s);return n>=ID_BASE&&n<ID_LIMIT;}catch(Exception e){return false;}}
    private static Row row(String id)throws FileNotFoundException{Row r=active.get(id);if(r==null||!allowed(owner,r.pin))throw new FileNotFoundException("Remote item unavailable");return r;}
    public static Uri uri(String id){if(!virtual(id))return null;return new Uri.Builder().scheme("content").authority(AUTH).appendPath("remote731").appendPath(id).build();}
    public static Uri withAppendedId(Uri local,long id){String s=Long.toString(id);if(!virtual(s))return ContentUris.withAppendedId(local,id);return uri(local.toString().contains("/video/")?"v"+s:s);}
    private static boolean stillSame(Row r){Row n=active.get(r.id);return n!=null&&r.pin.equals(n.pin)&&r.original.equals(n.original)&&r.size==n.size;}
    /** Called only for original R729 server-authorized items. */
    public static JSONObject augment(JSONObject j){try{String id=j.getString("id");if(id.startsWith("a:"))return j;Class<?> cl=Class.forName(ROOT);Field f=cl.getDeclaredField("ctx");f.setAccessible(true);Context c=(Context)f.get(null);Method m=cl.getDeclaredMethod("uri",String.class);m.setAccessible(true);Uri u=(Uri)m.invoke(null,id);if(c==null||u==null)return j;long t=0,d=0;String[] cols=id.startsWith("v")?new String[]{"datetaken","date_added","duration"}:new String[]{"datetaken","date_added"};try(Cursor q=c.getContentResolver().query(u,cols,null,null,null)){if(q!=null&&q.moveToFirst()){t=q.getLong(0);if(t<=0)t=q.getLong(1)*1000;if(cols.length==3)d=q.getLong(2);}}j.put("t",t).put("duration",d);double lat=Double.NaN,lon=Double.NaN;if(id.startsWith("v")){android.media.MediaMetadataRetriever mm=new android.media.MediaMetadataRetriever();try{mm.setDataSource(c,u);String loc=mm.extractMetadata(android.media.MediaMetadataRetriever.METADATA_KEY_LOCATION);if(loc!=null){java.util.regex.Matcher r=java.util.regex.Pattern.compile("^([+-]\\d+(?:\\.\\d+)?)([+-]\\d+(?:\\.\\d+)?)/*$").matcher(loc);if(r.matches()){lat=Double.parseDouble(r.group(1));lon=Double.parseDouble(r.group(2));}}}finally{mm.release();}}else{Uri orig=u;try{orig=MediaStore.setRequireOriginal(u);}catch(Exception ignored){}try(InputStream in=c.getContentResolver().openInputStream(orig)){if(in!=null){float[] ll=new float[2];android.media.ExifInterface ex=new android.media.ExifInterface(in);if(ex.getLatLong(ll)){lat=ll[0];lon=ll[1];}}}}if(Double.isFinite(lat)&&Double.isFinite(lon)&&Math.abs(lat)<=90&&Math.abs(lon)<=180&&(lat!=0||lon!=0))j.put("lat",lat).put("lon",lon);}catch(Exception ignored){}return j;}
    private static Row fromUri(Uri u)throws FileNotFoundException{if(!AUTH.equals(u.getAuthority())||u.getPathSegments().size()!=2||!"remote731".equals(u.getPathSegments().get(0)))throw new FileNotFoundException("Unknown remote URI");return row(u.getLastPathSegment());}
    public static boolean handle(Object p,WebView w,int id,String cmd){if(!cmd.startsWith(PREFIX))return false;WORK.execute(()->{try{JSONObject cfg=config(p);String pin=cfg.getString("pin");if(!allowed(p,pin))throw new IOException("동기화 중지");owner=p;String op=cmd.substring(PREFIX.length());if(op.startsWith("list:")){int offset=Integer.parseInt(op.substring(5));if(offset<0||offset>100000)throw new IOException("목록 범위 오류");if(offset==0){staged.clear();generation++;}else if(!pin.equals(activePin))throw new IOException("등록 기기 변경");activePin=pin;JSONObject data=new JSONObject(new String(bytes(client(cfg),"/v3/view/list?offset="+offset,MAX_LIST),StandardCharsets.UTF_8));JSONArray result=new JSONArray(),items=data.getJSONArray("items");for(int i=0;i<items.length();i++){Row r=new Row(pin,items.getJSONObject(i));Row prev=staged.put(r.id,r);if(prev!=null&&!prev.original.equals(r.original))throw new IOException("원격 ID 충돌");result.put(r.json());}int next=data.getInt("next");boolean more=data.getBoolean("more");if(more&&next<=offset)throw new IOException("목록 순서 오류");if(!allowed(p,pin))throw new IOException("동기화 중지");if(!more)active=Collections.unmodifiableMap(new LinkedHashMap<>(staged));finish(p,w,id,true,new JSONObject().put("items",result).put("next",next).put("more",more).put("generation",generation).toString());}else if(op.startsWith("thumb:")){Row r=row(op.substring(6));if(r.mime.startsWith("audio/"))throw new IOException("음성 썸네일 없음");byte[] b=bytes(client(cfg),"/v3/view/thumb/"+r.original,MAX_THUMB);if(!allowed(p,pin))throw new IOException("동기화 중지");finish(p,w,id,true,"data:image/jpeg;base64,"+Base64.encodeToString(b,Base64.NO_WRAP));}else if(op.startsWith("voice:")){Row r=row(op.substring(6));if(!r.mime.startsWith("audio/"))throw new IOException("음성 ID 오류");Class<?> cl=Class.forName(ROOT);Method m=cl.getDeclaredMethod("player",Activity.class,clientClass(),String.class,long.class,boolean.class);m.setAccessible(true);Object c=client(cfg);Activity a=(Activity)field(p,"active");w.post(()->{try{if(!allowed(p,pin))throw new IOException("동기화 중지");m.invoke(null,a,c,r.original,r.size,false);finish(p,w,id,true,"원격 음성 재생");}catch(Exception e){finish(p,w,id,false,"원격 음성 열기 실패");}});}else throw new IOException("Unknown remote command");}catch(Exception e){finish(p,w,id,false,"원격 기록 조회 실패 · "+e.getClass().getSimpleName());}});return true;}
    private static void sameUid(){if(Binder.getCallingUid()!=Process.myUid())throw new SecurityException("MOA private remote media");}
    public static ParcelFileDescriptor openFile(ContentProvider p,Uri u,String mode)throws FileNotFoundException{sameUid();if(!"r".equals(mode))throw new FileNotFoundException("Read only");try{Row r=fromUri(u);MediaDataSource s=source(r);StorageManager sm=p.getContext().getSystemService(StorageManager.class);if(sm==null){s.close();throw new IOException("Storage manager unavailable");}try{return sm.openProxyFileDescriptor(ParcelFileDescriptor.MODE_READ_ONLY,new ProxyFileDescriptorCallback(){@Override public long onGetSize()throws ErrnoException{check();return r.size;}private void check()throws ErrnoException{if(!allowed(owner,r.pin)||!stillSame(r))throw new ErrnoException("remote revoked",OsConstants.EACCES);}@Override public int onRead(long off,int size,byte[] out)throws ErrnoException{check();try{if(off>=r.size)return 0;int n=s.readAt(off,out,0,(int)Math.min(size,r.size-off));return Math.max(0,n);}catch(IOException ex){throw new ErrnoException("remote read",OsConstants.EIO);}}@Override public void onRelease(){try{s.close();}catch(IOException ignored){}}},ioHandler());}catch(Exception ex){s.close();throw ex;}}catch(Exception e){throw new FileNotFoundException("Remote media not accessible");}}
    public static AssetFileDescriptor typed(ContentProvider p,Uri u,String mime,android.os.Bundle opts)throws FileNotFoundException{sameUid();if(opts==null||!opts.containsKey(ContentResolverExtra.SIZE))return new AssetFileDescriptor(openFile(p,u,"r"),0,AssetFileDescriptor.UNKNOWN_LENGTH);try{Row r=fromUri(u);byte[] b=bytes(client(config(owner)),"/v3/view/thumb/"+r.original,MAX_THUMB);if(!allowed(owner,r.pin))throw new IOException("Remote revoked");ParcelFileDescriptor[] pipe=ParcelFileDescriptor.createPipe();new Thread(()->{try(OutputStream o=new ParcelFileDescriptor.AutoCloseOutputStream(pipe[1])){o.write(b);}catch(IOException ignored){}},"MoaRemote731-thumb").start();return new AssetFileDescriptor(pipe[0],0,b.length);}catch(Exception e){throw new FileNotFoundException("Thumbnail unavailable");}}
    private static class ContentResolverExtra {static final String SIZE="android.content.extra.SIZE";}
    public static String type(Uri u){sameUid();try{return fromUri(u).mime;}catch(Exception e){return null;}}
    public static Cursor query(Uri u,String[] cols){sameUid();try{Row r=fromUri(u);if(cols==null)cols=new String[]{"_id","_display_name","mime_type","_size","datetaken","duration"};MatrixCursor c=new MatrixCursor(cols,1);Object[] vals=new Object[cols.length];for(int i=0;i<cols.length;i++){switch(cols[i]){case "_id":vals[i]=Long.parseLong(r.id.replaceFirst("^(v|a:)",""));break;case "_display_name":case "title":vals[i]=r.name;break;case "mime_type":vals[i]=r.mime;break;case "_size":vals[i]=r.size;break;case "datetaken":vals[i]=r.t;break;case "date_added":case "date_modified":vals[i]=r.t/1000;break;case "duration":vals[i]=r.duration;break;case "latitude":vals[i]=r.lat;break;case "longitude":vals[i]=r.lon;break;default:vals[i]=null;}}c.addRow(vals);return c;}catch(Exception e){return null;}}
}
