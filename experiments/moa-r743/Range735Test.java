package com.juhyeon.familyjournea;
import java.io.*;import java.util.*;import java.util.concurrent.*;import java.util.concurrent.atomic.*;
public final class Range735Test {
 static final int B=MoaRangeCache735.BLOCK;static final long SIZE=25L*B+123;
 static byte expected(long p){return (byte)((p*31+(p>>>20)*17)%251);}
 static byte[] bytes(long a,long b){byte[] v=new byte[(int)(b-a+1)];for(int i=0;i<v.length;i++)v[i]=expected(a+i);return v;}
 static void check(boolean x,String msg){if(!x)throw new AssertionError(msg);}
 static void read(MoaRangeCache735 c,long p,int n)throws Exception{byte[] b=new byte[n+8];int len=c.read(p,b,4,n);check(len==Math.min(n,SIZE-p),"length");for(int i=0;i<len;i++)check(b[i+4]==expected(p+i),"byte equality at "+(p+i));}
 public static void main(String[] args)throws Exception{
  AtomicBoolean allow=new AtomicBoolean(true);ConcurrentHashMap<Long,AtomicInteger> calls=new ConcurrentHashMap<>();CountDownLatch ahead=new CountDownLatch(3);AtomicInteger fail=new AtomicInteger(1);
  MoaRangeCache735 c=new MoaRangeCache735(SIZE,(a,b)->{long k=a/B;calls.computeIfAbsent(k,z->new AtomicInteger()).incrementAndGet();if(k>=1&&k<=3)ahead.countDown();if(k==19&&fail.getAndDecrement()>0)throw new IOException("simulated timeout");return bytes(a,b);},allow::get);
  read(c,0,100);check(ahead.await(4,TimeUnit.SECONDS),"next blocks prefetched");read(c,B+3,100);check(calls.get(1L).get()==1,"inflight range deduplicated");read(c,B-99,300);read(c,3L*B+100,4096);read(c,0,1024);check(calls.get(0L).get()==1,"backseek cached");
  try{read(c,19L*B+20,100);throw new AssertionError("expected failure");}catch(IOException ok){}read(c,19L*B+20,100);read(c,SIZE-123,500);check(c.read(SIZE,new byte[1],0,1)==-1,"EOF");check(MoaRangeCache735.cacheCount(c)<=8,"per source cap");allow.set(false);try{read(c,0,4);throw new AssertionError("revoked cache read");}catch(IOException ok){}c.close();check(MoaRangeCache735.cacheCount(c)==0,"closed cache purged");
  // Seek while an old prefetch request is in flight: new foreground read must not wait for it.
  CountDownLatch started=new CountDownLatch(1),release=new CountDownLatch(1);AtomicInteger stale=new AtomicInteger();
  MoaRangeCache735 d=new MoaRangeCache735(SIZE,(a,b)->{if(a/B==1){started.countDown();if(!release.await(5,TimeUnit.SECONDS))throw new IOException("timeout");}if(a/B==2||a/B==3)stale.incrementAndGet();return bytes(a,b);},()->true);
  read(d,0,64);check(started.await(3,TimeUnit.SECONDS),"prefetch started");ExecutorService ex=Executors.newSingleThreadExecutor();try{Future<?> f=ex.submit(()->{try{read(d,15L*B,128);}catch(Exception e){throw new RuntimeException(e);}});f.get(3,TimeUnit.SECONDS);release.countDown();Thread.sleep(100);check(stale.get()==0,"stale queued prefetch canceled");}finally{release.countDown();ex.shutdownNow();d.close();}
  // Multiple sources bounded together and never cross-read.
  ArrayList<MoaRangeCache735> all=new ArrayList<>();for(int i=0;i<6;i++){final byte marker=(byte)i;MoaRangeCache735 x=new MoaRangeCache735(SIZE,(a,b)->{byte[] v=new byte[(int)(b-a+1)];Arrays.fill(v,marker);return v;},()->true);all.add(x);for(int k=0;k<6;k++){byte[] v=new byte[20];x.read(k*B,v,0,20);check(v[0]==marker,"source isolation");}}check(MoaRangeCache735.cacheCount()<=32,"global cap");for(MoaRangeCache735 x:all)x.close();check(MoaRangeCache735.cacheCount()==0,"global purge");
  System.out.println("PASS original bytes, cross-block, EOF, read-ahead, dedup, backward seek, failure retry, revocation, seek preemption, stale cancellation, per-source/global cache bounds and isolation");
 }
}