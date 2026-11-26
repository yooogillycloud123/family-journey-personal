package com.juhyeon.familyjournea;
import java.io.*;
public final class MoaOriginal743{
 public interface Reader{int read(long off,byte[] b,int n)throws IOException;}
 public interface Guard{boolean allowed();}
 public static void copy(long size,Reader r,OutputStream out,Guard g)throws IOException{
  if(size<=0)throw new IOException("Invalid original length");byte[] buf=new byte[1048576];long at=0;
  while(at<size){if(!g.allowed())throw new IOException("Remote revoked");int want=(int)Math.min(buf.length,size-at),n=r.read(at,buf,want);if(n<=0||n>want)throw new EOFException("Incomplete original photo");if(!g.allowed())throw new IOException("Remote revoked");out.write(buf,0,n);at+=n;}
  if(!g.allowed())throw new IOException("Remote revoked");
 }
}
