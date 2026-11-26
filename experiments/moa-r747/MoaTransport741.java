package com.juhyeon.familyjournea;
import java.io.*;
import java.net.*;
import java.util.*;
import java.util.concurrent.atomic.AtomicLong;
import java.util.function.BooleanSupplier;
import javax.net.ssl.SSLException;

/** Bounded original-range batching. No auth or TLS changes. A legacy hub can reject >1MiB. */
public final class MoaTransport741 {
 public static final int B=1048576,MAX=4*B;
 public interface Fetch{byte[] get(long a,long b,int max)throws Exception;}
 public interface Guard{boolean allowed();}
 private static final Object LOCK=new Object();
 private static final LinkedHashMap<MoaTransport741,Segment> CACHE=new LinkedHashMap<>(8,.75f,true);
 private static int used;private static long epoch;
 private static final class Segment{final long start,at;final byte[] data;Segment(long s,byte[] b){start=s;data=b;at=System.nanoTime();}}
 private final long length;private final Fetch fetch;private final Guard guard;private final BooleanSupplier batch;
 private final AtomicLong next=new AtomicLong(-1);private volatile boolean legacy;
 public MoaTransport741(long n,Fetch f,Guard g,BooleanSupplier b){if(n<=0||f==null||g==null||b==null)throw new IllegalArgumentException();length=n;fetch=f;guard=g;batch=b;}
 private void check()throws IOException{if(!guard.allowed())throw new IOException("Remote revoked");}
 public static void clear(){synchronized(LOCK){CACHE.clear();used=0;epoch++;}}
 private byte[] cached(long a,long b){synchronized(LOCK){Segment s=CACHE.get(this);if(s==null)return null;if(System.nanoTime()-s.at>5_000_000_000L){used-=s.data.length;CACHE.remove(this);return null;}if(a<s.start||b-s.start>=s.data.length)return null;return Arrays.copyOfRange(s.data,(int)(a-s.start),(int)(b-s.start+1));}}
 private void save(long a,byte[] b,long e){synchronized(LOCK){if(epoch!=e)return;Segment old=CACHE.remove(this);if(old!=null)used-=old.data.length;CACHE.put(this,new Segment(a,b));used+=b.length;while(used>12*B){Iterator<Segment> it=CACHE.values().iterator();used-=it.next().data.length;it.remove();}}}
 static int bytes(){synchronized(LOCK){return used;}}
 static boolean status(Throwable t,int status){for(int i=0;t!=null&&i<6;i++,t=t.getCause()){String m=t.getMessage();if(m!=null&&m.equals("허브 응답 HTTP "+status))return true;}return false;}
 static boolean transientFailure(Throwable t){for(Throwable q=t;q!=null;q=q.getCause())if(q instanceof SSLException||q instanceof SecurityException||q instanceof InterruptedException)return false;for(Throwable q=t;q!=null;q=q.getCause())if(q instanceof SocketTimeoutException||q instanceof ConnectException||q instanceof SocketException||q instanceof EOFException)return true;return status(t,502)||status(t,503)||status(t,504);}
 private byte[] exact(long a,long b)throws Exception{check();byte[] data=fetch.get(a,b,(int)(b-a+1));if(data==null||data.length!=b-a+1)throw new IOException("Remote range length mismatch");check();return data;}
 public byte[] read(long a,long b)throws Exception{
  check();if(a<0||a%B!=0||b<a||b>=length||b-a+1!=Math.min((long)B,length-a))throw new IOException("Invalid block");
  long prior=next.getAndSet(b+1);long gen;synchronized(LOCK){gen=epoch;}
  byte[] hit=cached(a,b);if(hit!=null){check();return hit;}
  long end=!legacy&&prior==a&&batch.getAsBoolean()?a+Math.min((long)MAX,length-a)-1:b;
  if(end>b){try{byte[] data=exact(a,end);save(a,data,gen);check();return Arrays.copyOf(data,(int)(b-a+1));}
   catch(Exception e){if(status(e,416))legacy=true;else if(!transientFailure(e))throw e;check();}}
  try{return exact(a,b);}catch(Exception e){if(!transientFailure(e))throw e;check();if(Thread.currentThread().isInterrupted())throw e;Thread.sleep(100);return exact(a,b);}
 }
}
