package com.juhyeon.familyjournea;

import java.io.IOException;
import java.util.*;
import java.util.concurrent.*;

/** Original byte ranges only. No disk writes; bounded per-source and shared LRU. */
public final class MoaRangeCache735 implements AutoCloseable {
    public static final int BLOCK=1024*1024, PER_SOURCE=8, GLOBAL=32, AHEAD=3;
    public interface Fetch { byte[] get(long first,long last) throws Exception; }
    public interface Guard { boolean allowed(); }
    private static final ThreadPoolExecutor PREFETCH=new ThreadPoolExecutor(2,2,20,TimeUnit.SECONDS,new ArrayBlockingQueue<Runnable>(8),r->{Thread t=new Thread(r,"MOA-range-ahead");t.setDaemon(true);return t;});
    static {PREFETCH.allowCoreThreadTimeOut(true);}
    private static final Object CACHE_LOCK=new Object();
    private static final LinkedHashMap<Key,byte[]> CACHE=new LinkedHashMap<>(40,.75f,true);
    private static final class Key {
        final MoaRangeCache735 source;final long block;
        Key(MoaRangeCache735 s,long b){source=s;block=b;}
        public int hashCode(){return System.identityHashCode(source)*31+Long.hashCode(block);}
        public boolean equals(Object o){return o instanceof Key&&((Key)o).source==source&&((Key)o).block==block;}
    }
    private final long length;private final Fetch fetch;private final Guard guard;
    private final ConcurrentHashMap<Long,FutureTask<byte[]>> pending=new ConcurrentHashMap<>();
    private final Object state=new Object();private volatile boolean closed;private volatile long epoch;
    private long lastBlock=-1;private FutureTask<Void> job;
    public MoaRangeCache735(long size,Fetch f,Guard g){if(size<=0||f==null||g==null)throw new IllegalArgumentException();length=size;fetch=f;guard=g;}
    public long size(){return length;}
    private void check() throws IOException {if(closed||!guard.allowed())throw new IOException("Remote closed or revoked");}
    private byte[] hit(long b){synchronized(CACHE_LOCK){return CACHE.get(new Key(this,b));}}
    private void put(long b,byte[] data){synchronized(CACHE_LOCK){if(closed)return;CACHE.put(new Key(this,b),data);int count=0;for(Key k:CACHE.keySet())if(k.source==this)count++;
        for(Iterator<Key> it=CACHE.keySet().iterator();count>PER_SOURCE&&it.hasNext();){if(it.next().source==this){it.remove();count--;}}
        while(CACHE.size()>GLOBAL){Iterator<Key> i=CACHE.keySet().iterator();i.next();i.remove();}}}
    private byte[] block(long b)throws IOException{
        check();byte[] existing=hit(b);if(existing!=null){check();return existing;}
        FutureTask<byte[]> created=new FutureTask<>(()->{check();byte[] h=hit(b);if(h!=null)return h;long start=b*BLOCK;long end=start+Math.min((long)BLOCK,length-start)-1;byte[] bytes=fetch.get(start,end);if(bytes==null||bytes.length!=end-start+1)throw new IOException("Remote range length mismatch");check();put(b,bytes);return bytes;});
        FutureTask<byte[]> use=pending.putIfAbsent(b,created);boolean leader=use==null;if(leader){use=created;use.run();}
        try{byte[] out=use.get();check();return out;}catch(InterruptedException e){Thread.currentThread().interrupt();throw new IOException("Remote read interrupted",e);}catch(ExecutionException e){Throwable t=e.getCause();if(t instanceof IOException)throw (IOException)t;throw new IOException("Remote range request failed",t);}finally{if(use.isDone())pending.remove(b,use);}
    }
    private void cancelLocked(){epoch++;if(job!=null){job.cancel(false);PREFETCH.remove(job);job=null;}}
    private void ahead(long block){synchronized(state){if(closed)return;if(job!=null&&!job.isDone())return;long gen=epoch;
        FutureTask<Void> task=new FutureTask<>(()->{for(int i=1;i<=AHEAD;i++){long b=block+i;if(closed||epoch!=gen||b>(length-1)/BLOCK||!guard.allowed())break;try{block(b);}catch(IOException e){break;}}return null;});
        job=task;try{PREFETCH.execute(task);}catch(RejectedExecutionException ignored){job=null;}}}
    public int read(long pos,byte[] out,int offset,int count)throws IOException{
        check();if(pos<0||out==null||offset<0||count<0||offset>out.length-count)throw new IOException("Invalid remote read");if(count==0)return 0;if(pos>=length)return -1;
        long first=pos/BLOCK;synchronized(state){if(lastBlock>=0&&(first<lastBlock||first>lastBlock+1))cancelLocked();lastBlock=first;}
        int total=(int)Math.min((long)count,length-pos),done=0;while(done<total){long p=pos+done,b=p/BLOCK;byte[] data=block(b);int at=(int)(p%BLOCK),n=Math.min(total-done,data.length-at);if(n<=0)throw new IOException("Invalid remote range");check();System.arraycopy(data,at,out,offset+done,n);done+=n;}
        long last=(pos+done-1)/BLOCK;synchronized(state){lastBlock=last;}ahead(last);return done;
    }
    public void close(){synchronized(state){closed=true;cancelLocked();}synchronized(CACHE_LOCK){CACHE.keySet().removeIf(k->k.source==this);}pending.clear();}
    static int cacheCount(){synchronized(CACHE_LOCK){return CACHE.size();}}
    static int cacheCount(MoaRangeCache735 s){synchronized(CACHE_LOCK){int n=0;for(Key k:CACHE.keySet())if(k.source==s)n++;return n;}}
}