package com.juhyeon.familyjournea;
import java.io.*;
import java.util.*;
import java.util.concurrent.*;
import java.util.concurrent.atomic.AtomicInteger;

/** App-private, bounded, original-byte range spool. No MediaStore writes. */
public final class MoaDiskCache737 implements AutoCloseable {
 public static final int BLOCK=1024*1024; public static final long LIMIT=384L*BLOCK, TTL=300000L;
 public interface Fetch { byte[] fetch(long first,long last)throws Exception; }
 public interface Guard { boolean allowed(); }
 private static final class Entry { final File file; final int size; long at; Entry(File f,int n){file=f;size=n;at=System.currentTimeMillis();} }
 private final File dir; private final long limit,ttl; private long used,epoch,serial; private boolean closed;
 private final LinkedHashMap<String,Entry> entries=new LinkedHashMap<>(64,.75f,true);
 private final ConcurrentHashMap<String,FutureTask<byte[]>> pending=new ConcurrentHashMap<>();
 private final AtomicInteger foreground=new AtomicInteger();
 public MoaDiskCache737(File dir,long limit,long ttl)throws IOException{if(limit<BLOCK||ttl<=0)throw new IllegalArgumentException();this.dir=dir;this.limit=limit;this.ttl=ttl;if(!dir.isDirectory()&&!dir.mkdirs())throw new IOException("cache directory");File[] old=dir.listFiles();if(old!=null)for(File f:old)if(f.isFile()&&f.getName().startsWith("moa737-"))f.delete();}
 private void check(Guard g)throws IOException{if(!g.allowed())throw new IOException("Remote revoked");synchronized(this){if(closed)throw new IOException("Cache closed");}}
 private synchronized void evict(String key){Entry e=entries.remove(key);if(e!=null){used-=e.size;e.file.delete();}}
 public synchronized void prune(){long now=System.currentTimeMillis();for(String k:new ArrayList<>(entries.keySet())){Entry e=entries.get(k);if(e!=null&&now-e.at>ttl)evict(k);}}
 private synchronized byte[] hit(String key,int size)throws IOException{Entry e=entries.get(key);if(e==null)return null;if(System.currentTimeMillis()-e.at>ttl||e.size!=size||e.file.length()!=size){evict(key);return null;}try(DataInputStream in=new DataInputStream(new FileInputStream(e.file))){byte[] b=new byte[size];in.readFully(b);if(in.read()!=-1)throw new IOException("cache length");e.at=System.currentTimeMillis();return b;}catch(IOException err){evict(key);return null;}}
 private synchronized void put(String key,byte[] bytes,long gen){if(closed||epoch!=gen||bytes.length>limit)return;evict(key);while(used+bytes.length>limit&&!entries.isEmpty())evict(entries.keySet().iterator().next());File tmp=new File(dir,"moa737-"+(++serial)+".block");try(FileOutputStream out=new FileOutputStream(tmp)){out.write(bytes);}catch(IOException e){tmp.delete();return;}if(tmp.length()!=bytes.length){tmp.delete();return;}entries.put(key,new Entry(tmp,bytes.length));used+=bytes.length;}
 public byte[] get(String media,long length,long first,long last,Fetch fetch,Guard guard,boolean urgent)throws Exception{
  check(guard);if(first<0||first%BLOCK!=0||last<first||last>=length||last-first+1!=Math.min((long)BLOCK,length-first))throw new IOException("Invalid block");if(urgent)foreground.incrementAndGet();try{
   final int n=(int)(last-first+1);final long gen; synchronized(this){gen=epoch;}String key=gen+":"+media+":"+first;byte[] h=hit(key,n);if(h!=null){check(guard);return h;}
   FutureTask<byte[]> task=new FutureTask<>(()->{check(guard);byte[] b=hit(key,n);if(b==null){b=fetch.fetch(first,last);if(b==null||b.length!=n)throw new IOException("range length mismatch");check(guard);put(key,b,gen);}return b;});FutureTask<byte[]> use=pending.putIfAbsent(key,task);if(use==null){use=task;use.run();}try{byte[] b=use.get();check(guard);synchronized(this){if(epoch!=gen)throw new IOException("Cache reset");}return b;}catch(ExecutionException e){Throwable t=e.getCause();if(t instanceof Exception)throw (Exception)t;throw new IOException(t);}finally{if(use.isDone())pending.remove(key,use);}
  }finally{if(urgent)foreground.decrementAndGet();}}
 public boolean busy(){return foreground.get()>0;}
 public synchronized long bytes(){return used;}
 public synchronized void reset(){epoch++;for(String k:new ArrayList<>(entries.keySet()))evict(k);}
 public synchronized void close(){closed=true;reset();}
}