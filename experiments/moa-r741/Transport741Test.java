package com.juhyeon.familyjournea;
import java.io.*;import java.net.*;import java.util.*;import java.util.concurrent.atomic.*;
public class Transport741Test{
 static byte[] data(long a,long z){byte[] b=new byte[(int)(z-a+1)];for(int i=0;i<b.length;i++)b[i]=(byte)((a+i)*31+(a+i)/1024);return b;}
 static void eq(boolean x){if(!x)throw new AssertionError();}
 public static void main(String[] args)throws Exception{
  int B=MoaTransport741.B;AtomicInteger calls=new AtomicInteger();AtomicBoolean allow=new AtomicBoolean(true);
  MoaTransport741 t=new MoaTransport741(10L*B+5,(a,z,m)->{calls.incrementAndGet();eq(m==z-a+1);return data(a,z);},allow::get,()->true);
  for(int n=0;n<10;n++)eq(Arrays.equals(t.read((long)n*B,(long)(n+1)*B-1),data((long)n*B,(long)(n+1)*B-1)));
  eq(calls.get()==4);eq(t.read(10L*B,10L*B+4).length==5);eq(MoaTransport741.bytes()<=12*B);
  allow.set(false);try{t.read(0,B-1);throw new AssertionError();}catch(IOException expected){}
  AtomicInteger large=new AtomicInteger();MoaTransport741 old=new MoaTransport741(5L*B,(a,z,m)->{if(m>B){large.incrementAndGet();throw new IOException("허브 응답 HTTP 416");}return data(a,z);},()->true,()->true);
  for(int n=0;n<5;n++)old.read((long)n*B,(long)(n+1)*B-1);eq(large.get()==1);
  AtomicInteger retry=new AtomicInteger();MoaTransport741 unstable=new MoaTransport741(B,(a,z,m)->{if(retry.incrementAndGet()==1)throw new SocketTimeoutException();return data(a,z);},()->true,()->false);eq(unstable.read(0,B-1).length==B&&retry.get()==2);
  AtomicInteger denied=new AtomicInteger();MoaTransport741 bad=new MoaTransport741(B,(a,z,m)->{denied.incrementAndGet();throw new IOException("허브 응답 HTTP 403");},()->true,()->true);try{bad.read(0,B-1);throw new AssertionError();}catch(IOException e){eq(denied.get()==1);}
  MoaTransport741.clear();eq(MoaTransport741.bytes()==0);
  MoaFeedback741 f=new MoaFeedback741();f.sample(100,0,100);f.sample(130,5,1000);eq(f.pressure(2000));eq(!f.pressure(7000));f.reset();eq(!f.pressure(1000));
  System.out.println("PASS original bytes, 4MiB batching, legacy fallback, transient retry, denied no retry, revoked cache and decoder pressure");
 }
}
