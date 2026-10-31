package com.familyjourney.personal;

import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.graphics.Path;
import android.graphics.RectF;
import android.view.View;
import android.content.Context;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Locale;

public final class RoutePainter extends View {
  private List<TripEngine.Trip> trips=new ArrayList<>();
  private final Paint paint=new Paint(3);
  private static final int[] COLORS={0xff008eab,0xffde714b,0xff926dcc,0xff45a36d};
  public RoutePainter(Context context){super(context);}
  public void setTrips(List<TripEngine.Trip> data){trips=new ArrayList<>(data);invalidate();}
  @Override protected void onDraw(Canvas canvas){super.onDraw(canvas);drawRoute(canvas,getWidth(),getHeight(),trips,1);}
  public static void drawRoute(Canvas canvas,int w,int h,List<TripEngine.Trip> trips,double progress){
    Paint p=new Paint(3);canvas.drawColor(0xffeef5f7);
    float side=Math.min(w,h)*0.07f;
    float top=h*0.17f, bottom=h*0.79f;
    p.setColor(0xff1b3c4b);p.setTextSize(Math.min(w,h)*0.064f);p.setFakeBoldText(true);
    canvas.drawText("FAMILY JOURNEY",side,h*0.085f,p);
    p.setTextSize(Math.min(w,h)*0.035f);p.setFakeBoldText(false);
    canvas.drawText("우리 가족 여행 · 좌표 기반 경로",side,h*0.12f,p);
    p.setColor(0xffd6e4e7);p.setStrokeWidth(2);
    for(int i=0;i<7;i++){float y=top+(bottom-top)*i/6f;canvas.drawLine(side,y,w-side,y,p);}
    for(int i=0;i<6;i++){float x=side+(w-2*side)*i/5f;canvas.drawLine(x,top,x,bottom,p);}
    List<TripEngine.Stop> all=new ArrayList<>();
    for(TripEngine.Trip trip:trips) all.addAll(trip.stops);
    if(all.isEmpty()){
      p.setColor(0xff47606b);p.setTextSize(Math.min(w,h)*0.043f);
      canvas.drawText("사진을 선택하여 여행을 만들어 보세요.",side,h/2f,p);return;
    }
    double minLat=90,maxLat=-90,minLon=180,maxLon=-180;
    for(TripEngine.Stop s:all){minLat=Math.min(minLat,s.latitude);maxLat=Math.max(maxLat,s.latitude);minLon=Math.min(minLon,s.longitude);maxLon=Math.max(maxLon,s.longitude);}
    double latRange=Math.max(.06,maxLat-minLat),lonRange=Math.max(.08,maxLon-minLon);
    minLat-=latRange*.18;maxLat+=latRange*.18;minLon-=lonRange*.18;maxLon+=lonRange*.18;
    int totalSegments=0;
    for(TripEngine.Trip trip:trips)totalSegments+=Math.max(0,trip.stops.size()-1);
    double allowed=Math.max(0,Math.min(1,progress))*Math.max(1,totalSegments),seen=0;
    for(int index=0;index<trips.size();index++){
      TripEngine.Trip trip=trips.get(index);int color=COLORS[index%COLORS.length];
      p.setStrokeWidth(Math.max(4f,w*.007f));p.setStrokeCap(Paint.Cap.ROUND);p.setColor(color);
      for(int i=1;i<trip.stops.size();i++){
        if(seen>=allowed)break;
        TripEngine.Stop a=trip.stops.get(i-1),b=trip.stops.get(i);
        float ax=px(a.longitude,minLon,maxLon,side,w-side),ay=py(a.latitude,minLat,maxLat,top,bottom);
        float bx=px(b.longitude,minLon,maxLon,side,w-side),by=py(b.latitude,minLat,maxLat,top,bottom);
        float fraction=(float)Math.min(1,allowed-seen);
        canvas.drawLine(ax,ay,ax+(bx-ax)*fraction,ay+(by-ay)*fraction,p);seen++;
      }
      p.setStyle(Paint.Style.FILL);
      for(int i=0;i<trip.stops.size();i++){
        TripEngine.Stop s=trip.stops.get(i);
        float x=px(s.longitude,minLon,maxLon,side,w-side),y=py(s.latitude,minLat,maxLat,top,bottom);
        p.setColor(Color.WHITE);canvas.drawCircle(x,y,Math.max(7,w*.012f),p);
        p.setColor(color);canvas.drawCircle(x,y,Math.max(4,w*.008f),p);
        p.setTextSize(Math.min(w,h)*.025f);canvas.drawText(""+(i+1),x+9,y-10,p);
      }
    }
    p.setColor(0xff244554);p.setTextSize(Math.min(w,h)*.037f);
    canvas.drawText("여행 "+trips.size()+"회  ·  방문 장소 "+all.size()+"곳",side,h*.875f,p);
    p.setTextSize(Math.min(w,h)*.026f);
    canvas.drawText("※ 사진 좌표 간 직선 표시 · 실제 도로 경로가 아닙니다",side,h*.925f,p);
  }
  private static float px(double v,double lo,double hi,float a,float b){return (float)(a+(v-lo)/(hi-lo)*(b-a));}
  private static float py(double v,double lo,double hi,float a,float b){return (float)(b-(v-lo)/(hi-lo)*(b-a));}
}
