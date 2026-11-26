package com.juhyeon.familyjournea;

/** Adaptive range window, measured on actual original network reads, not disk hits. */
public final class MoaAdaptive739 {
 public static final long MIB=1048576L, NORMAL=384*MIB, FULL=1024*MIB;
 private volatile double rate=0,latency=0; private volatile long samples=0;
 private int last=-1,dir=1; private double velocity=0; private long lastAt=0;
 public synchronized void observe(long bytes,long nanos){if(bytes<=0||nanos<=0)return;double s=nanos/1e9;double r=Math.min(200*MIB,bytes/Math.max(.001,s));rate=samples==0?r:rate*.75+r*.25;latency=samples==0?s:latency*.75+s*.25;samples++;}
 public synchronized void failure(){if(samples>0){rate*=.6;latency=Math.max(latency,.4);}}
 public synchronized void reset(){rate=0;latency=0;samples=0;last=-1;dir=1;velocity=0;lastAt=0;}
 public synchronized void motion(int index,long now){if(last>=0&&index!=last){int d=index-last;dir=d>0?1:-1;double v=Math.abs(d)*1000.0/Math.max(30,now-lastAt);velocity=Math.min(20,v);}else if(now-lastAt>1500)velocity=0;if(index!=last){last=index;lastAt=now;}}
 public synchronized int ahead(long size,long durationMs){double needed=durationMs>0?size*1000.0/durationMs:2*MIB;if(samples<2)return 3;if(rate<needed*1.2||latency>.65)return 1;if(rate<needed*2||latency>.3)return 3;return rate>needed*4&&latency<.15?7:5;}
 public synchronized int[] order(int i,int count,boolean moving){int n=samples<2?2:rate<3*MIB?1:rate<10*MIB?2:3;int forward=moving?Math.min(4,n+(velocity>5?1:0)):n;int back=velocity>5?1:Math.min(2,n);int[] tmp=new int[1+forward+back];int k=0;tmp[k++]=i;for(int j=1;j<=forward;j++){int x=i+dir*j;if(x>=0&&x<count)tmp[k++]=x;}for(int j=1;j<=back;j++){int x=i-dir*j;if(x>=0&&x<count)tmp[k++]=x;}return java.util.Arrays.copyOf(tmp,k);}
 public synchronized int head(boolean current,long size,long duration){return current?Math.max(4,ahead(size,duration)+1):samples>1&&rate<3*MIB?1:3;}
 public synchronized long fullLimit(boolean current,boolean full){if(current&&full)return 896;return samples<2?128:rate<3*MIB?16:rate<10*MIB?64:128;}
 public synchronized long prefix(boolean current,long size,long duration){return current?Math.max(16,ahead(size,duration)*4):8;}
 public synchronized long rateBytes(){return (long)rate;}
}