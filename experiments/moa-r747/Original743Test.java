package com.juhyeon.familyjournea;
import java.io.*;import java.util.*;import org.json.*;
public class Original743Test{
 public static void main(String[] args)throws Exception{
 byte[] b=new byte[3145729];new Random(743).nextBytes(b);ByteArrayOutputStream out=new ByteArrayOutputStream();
 MoaOriginal743.copy(b.length,(off,buf,n)->{int k=Math.min(n,12345);System.arraycopy(b,(int)off,buf,0,k);return k;},out,()->true);
 if(!Arrays.equals(b,out.toByteArray()))throw new AssertionError("original differs");
 try{MoaOriginal743.copy(100,(off,buf,n)->0,out,()->true);throw new AssertionError("EOF accepted");}catch(EOFException ok){}
 try{MoaOriginal743.copy(100,(off,buf,n)->n,out,()->false);throw new AssertionError("revoked accepted");}catch(IOException ok){}
 JSONObject j=new JSONObject().put("mode","auto").put("viewShare",true).put("viewEpoch",743).put("viewOffset",0).put("viewTotal",1).put("viewCatalog",new JSONArray().put(new JSONObject().put("day","2026-11-26").put("id","123").put("coverCurated",true)));
 MoaRemoteTimeline731.captureCovers(j);
 java.lang.reflect.Method mark=MoaRemoteTimeline731.class.getDeclaredMethod("markCover",JSONObject.class);mark.setAccessible(true);
 JSONObject row=new JSONObject().put("day","2026-11-26").put("id","123");mark.invoke(null,row);if(!row.optBoolean("coverCurated"))throw new AssertionError("cover missing");
 JSONObject other=new JSONObject().put("day","2026-11-26").put("id","124");mark.invoke(null,other);if(other.optBoolean("coverCurated"))throw new AssertionError("cover leaked");
 MoaRemoteTimeline731.captureCovers(new JSONObject().put("mode","off"));row=new JSONObject().put("day","2026-11-26").put("id","123");mark.invoke(null,row);if(row.optBoolean("coverCurated"))throw new AssertionError("cover retained after off");
 System.out.println("PASS: original byte equality, partial reads, EOF and revoked rejection, approved cover and OFF");
 }
}
