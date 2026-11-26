package com.juhyeon.familyjournea;
/** Actual decoder counters are a load signal, never a reason to lower original quality. */
public final class MoaFeedback741 {
 private long frames=-1,dropped=-1,until;
 public synchronized void reset(){frames=dropped=-1;until=0;}
 public synchronized void sample(long f,long d,long now){
  if(f<0||d<0)return;
  if(frames>=0&&f>=frames&&d>=dropped){long df=f-frames,dd=d-dropped;if(df+dd>=12&&dd>=3&&dd*100.0/(df+dd)>=5)until=now+5000;}
  frames=f;dropped=d;
 }
 public synchronized boolean pressure(long now){return now<until;}
}
