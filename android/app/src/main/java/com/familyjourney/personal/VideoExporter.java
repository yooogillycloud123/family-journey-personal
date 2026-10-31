package com.familyjourney.personal;

import android.content.ContentValues;
import android.content.Context;
import android.media.MediaCodec;
import android.media.MediaCodecInfo;
import android.media.MediaFormat;
import android.media.MediaMuxer;
import android.os.Environment;
import android.provider.MediaStore;
import android.net.Uri;
import android.graphics.Canvas;
import android.view.Surface;
import java.io.File;
import java.io.FileInputStream;
import java.io.OutputStream;
import java.util.List;

public final class VideoExporter {
  private VideoExporter(){}
  public static Uri save(Context ctx,List<TripEngine.Trip> trips) throws Exception {
    final int width=720,height=1280,frames=90,fps=15;
    File tmp=File.createTempFile("familyjourney_",".mp4",ctx.getCacheDir());
    MediaCodec encoder=null;MediaMuxer muxer=null;Surface surface=null;boolean muxerStarted=false;
    try{
      MediaFormat format=MediaFormat.createVideoFormat("video/avc",width,height);
      format.setInteger(MediaFormat.KEY_COLOR_FORMAT,MediaCodecInfo.CodecCapabilities.COLOR_FormatSurface);
      format.setInteger(MediaFormat.KEY_BIT_RATE,2700000);
      format.setInteger(MediaFormat.KEY_FRAME_RATE,fps);
      format.setInteger(MediaFormat.KEY_I_FRAME_INTERVAL,1);
      encoder=MediaCodec.createEncoderByType("video/avc");
      encoder.configure(format,null,null,MediaCodec.CONFIGURE_FLAG_ENCODE);
      surface=encoder.createInputSurface();
      muxer=new MediaMuxer(tmp.getAbsolutePath(),MediaMuxer.OutputFormat.MUXER_OUTPUT_MPEG_4);
      encoder.start();
      MediaCodec.BufferInfo info=new MediaCodec.BufferInfo();
      int track=-1;long start=System.nanoTime();
      for(int i=0;i<frames;i++){
        Canvas canvas=surface.lockHardwareCanvas();
        try{RoutePainter.drawRoute(canvas,width,height,trips,(i+1d)/frames);}
        finally{surface.unlockCanvasAndPost(canvas);}
        long deadline=start+(i+1L)*1000000000L/fps;
        long wait=deadline-System.nanoTime();
        if(wait>0)Thread.sleep(wait/1000000L,(int)(wait%1000000L));
        for(int round=0;round<4;round++){
          int code=encoder.dequeueOutputBuffer(info,1000);
          if(code==MediaCodec.INFO_OUTPUT_FORMAT_CHANGED){
            if(!muxerStarted){track=muxer.addTrack(encoder.getOutputFormat());muxer.start();muxerStarted=true;}
          }else if(code>=0){
            if(muxerStarted&&info.size>0){
              java.nio.ByteBuffer buf=encoder.getOutputBuffer(code);
              if(buf!=null){buf.position(info.offset);buf.limit(info.offset+info.size);muxer.writeSampleData(track,buf,info);}
            }
            encoder.releaseOutputBuffer(code,false);
          }else break;
        }
      }
      encoder.signalEndOfInputStream();
      boolean eos=false;long timeout=System.currentTimeMillis()+25000;
      while(!eos&&System.currentTimeMillis()<timeout){
        int code=encoder.dequeueOutputBuffer(info,10000);
        if(code==MediaCodec.INFO_OUTPUT_FORMAT_CHANGED){
          if(!muxerStarted){track=muxer.addTrack(encoder.getOutputFormat());muxer.start();muxerStarted=true;}
        }else if(code>=0){
          if(muxerStarted&&info.size>0){
            java.nio.ByteBuffer buf=encoder.getOutputBuffer(code);
            if(buf!=null){buf.position(info.offset);buf.limit(info.offset+info.size);muxer.writeSampleData(track,buf,info);}
          }
          eos=(info.flags&MediaCodec.BUFFER_FLAG_END_OF_STREAM)!=0;
          encoder.releaseOutputBuffer(code,false);
        }
      }
      if(!muxerStarted||!eos)throw new IllegalStateException("영상 인코더가 완성되지 않았습니다");
      muxer.stop();muxerStarted=false;
      muxer.release();muxer=null;
      encoder.stop();encoder.release();encoder=null;
      if(surface!=null){surface.release();surface=null;}
      ContentValues values=new ContentValues();
      values.put(MediaStore.MediaColumns.DISPLAY_NAME,"FamilyJourney_"+System.currentTimeMillis()+".mp4");
      values.put(MediaStore.MediaColumns.MIME_TYPE,"video/mp4");
      values.put(MediaStore.MediaColumns.RELATIVE_PATH,Environment.DIRECTORY_MOVIES+"/FamilyJourney");
      Uri dest=ctx.getContentResolver().insert(MediaStore.Video.Media.EXTERNAL_CONTENT_URI,values);
      if(dest==null)throw new IllegalStateException("영상 저장 위치가 없습니다");
      try(FileInputStream in=new FileInputStream(tmp);OutputStream out=ctx.getContentResolver().openOutputStream(dest)){
        if(out==null)throw new IllegalStateException("영상 저장 스트림을 열 수 없습니다");
        byte[] buffer=new byte[65536];int n;
        while((n=in.read(buffer))>=0)out.write(buffer,0,n);
      }catch(Exception e){ctx.getContentResolver().delete(dest,null,null);throw e;}
      return dest;
    }finally{
      if(surface!=null)try{surface.release();}catch(Exception ignored){}
      if(encoder!=null)try{encoder.stop();encoder.release();}catch(Exception ignored){}
      if(muxer!=null)try{if(muxerStarted)muxer.stop();muxer.release();}catch(Exception ignored){}
      tmp.delete();
    }
  }
}
