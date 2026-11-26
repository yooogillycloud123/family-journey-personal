package com.juhyeon.familyjournea;
import java.io.*;import java.nio.file.*;import java.util.*;import java.util.concurrent.atomic.*;import java.util.concurrent.*;
public class Disk737Test{
 static final int B=MoaDiskCache737.BLOCK; static byte[] data(long a,long b){byte[] x=new byte[(int)(b-a+1)];for(int i=0;i<x.length;i++)x[i]=(byte)((a+i)*31+(a+i)/B);return x;}
 static void ok(boolean x){if(!x)throw new AssertionError();}
 public static void main(String[] x)throws Exception{File dir=Files.createTempDirectory("moa737-test").toFile();AtomicInteger requests=new AtomicInteger();AtomicBoolean allowed=new AtomicBoolean(true);MoaDiskCache737.Fetch f=(a,b)->{requests.incrementAndGet();return data(a,b);};MoaDiskCache737.Guard g=allowed::get;try(MoaDiskCache737 s=new MoaDiskCache737(dir,3L*B,10000)){
 long length=4L*B+17;for(int i=0;i<3;i++){long a=(long)i*B;ok(Arrays.equals(s.get("peerA:video",length,a,a+B-1,f,g,false),data(a,a+B-1)));}ok(requests.get()==3);ok(Arrays.equals(s.get("peerA:video",length,B,2L*B-1,f,g,true),data(B,2L*B-1)));ok(requests.get()==3);ok(s.bytes()==3L*B);
 ok(Arrays.equals(s.get("peerA:video",length,4L*B,length-1,f,g,true),data(4L*B,length-1)));ok(s.bytes()<=3L*B);int n=requests.get();s.get("peerB:video",length,B,2L*B-1,f,g,true);ok(requests.get()==n+1);
 allowed.set(false);try{s.get("peerA:video",length,B,2L*B-1,f,g,true);throw new AssertionError();}catch(IOException expected){}allowed.set(true);
 try{s.get("broken",length,0,B-1,(a,b)->new byte[3],g,true);throw new AssertionError();}catch(IOException expected){}ok(Arrays.equals(s.get("broken",length,0,B-1,f,g,true),data(0,B-1)));
 AtomicBoolean prefetchAllowed=new AtomicBoolean(true);CountDownLatch started=new CountDownLatch(1),release=new CountDownLatch(1);ExecutorService pool=Executors.newFixedThreadPool(2);
 try{Future<?> warm=pool.submit(()->{try{s.get("warm-cancel",length,0,B-1,(a,b)->{started.countDown();release.await();return data(a,b);},prefetchAllowed::get,false);throw new AssertionError("warm should fail");}catch(Exception expected){}});ok(started.await(2,TimeUnit.SECONDS));Future<byte[]> live=pool.submit(()->s.get("warm-cancel",length,0,B-1,f,g,true));Thread.sleep(50);prefetchAllowed.set(false);release.countDown();warm.get(2,TimeUnit.SECONDS);ok(Arrays.equals(live.get(2,TimeUnit.SECONDS),data(0,B-1)));}finally{release.countDown();pool.shutdownNow();}
 s.reset();ok(s.bytes()==0&&dir.list().length==0);}
 ok(dir.list().length==0);dir.delete();System.out.println("PASS: original byte equality, shared warm-to-open cache, bounds/LRU, peer isolation, revoke, failed range, cancelled speculative transfer recovery, cleanup");}
}