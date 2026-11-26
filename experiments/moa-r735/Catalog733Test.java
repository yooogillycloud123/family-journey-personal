package com.juhyeon.familyjournea;
import java.lang.reflect.*;
import org.json.JSONObject;
public class Catalog733Test {
 static Constructor<?> ctor;
 static Object make(String id,String day,String mime) throws Exception {
  JSONObject j=new JSONObject().put("id",id).put("day",day).put("name","sample").put("mime",mime).put("size",1000L);
  return ctor.newInstance("0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef",j);
 }
 static void reject(String id,String day,String mime)throws Exception{
  try{make(id,day,mime);throw new AssertionError("accepted invalid ID");}
  catch(InvocationTargetException e){if(!(e.getCause() instanceof java.io.IOException))throw e;}
 }
 public static void main(String[] args)throws Exception{
  Class<?> row=Class.forName("com.juhyeon.familyjournea.MoaRemoteTimeline731$Row");
  ctor=row.getDeclaredConstructor(String.class,JSONObject.class);ctor.setAccessible(true);
  Field f=row.getDeclaredField("id");f.setAccessible(true);
  Object a=make("a:2026-11-25:1795576029898-1234567890abcdef1234567890abcdef.m4a","2026-11-25","audio/mp4");
  Object b=make("v123456","2026-11-26","video/mp4"),c=make("98765","2026-11-26","image/jpeg");
  if(!f.get(a).toString().matches("a:88[0-9]{16}")||!f.get(b).toString().matches("v88[0-9]{16}")||!f.get(c).toString().matches("88[0-9]{16}"))throw new AssertionError();
  reject("a:2026-11-25:../../abcdabcd.m4a","2026-11-25","audio/mp4");
  reject("a:2026-11-24:12345678.m4a","2026-11-25","audio/mp4");
  reject("a:12345678.m4a","2026-11-25","audio/mp4");
  reject("a:2026-11-25:12345678.mp3","2026-11-25","audio/mp4");
  System.out.println("PASS: exact production voice ID + mixed photo/video/voice and 4 negative cases");
 }
}
