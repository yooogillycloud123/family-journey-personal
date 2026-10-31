package com.familyjourney.personal;

import android.media.ExifInterface;
import android.net.Uri;
import java.io.InputStream;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.Date;
import java.util.List;
import java.util.Locale;

public final class TripEngine {
  private TripEngine() {}

  public static final class Photo {
    final Uri uri;
    final long time;
    final double latitude, longitude;
    public Photo(Uri uri, long time, double latitude, double longitude) {
      this.uri=uri; this.time=time; this.latitude=latitude; this.longitude=longitude;
    }
  }
  public static final class Stop {
    double latitude, longitude;
    long start, end;
    int count;
    Stop(Photo p) { latitude=p.latitude; longitude=p.longitude; start=p.time; end=p.time; count=1; }
    void add(Photo p) {
      latitude=(latitude*count+p.latitude)/(count+1);
      longitude=(longitude*count+p.longitude)/(count+1);
      start=Math.min(start,p.time); end=Math.max(end,p.time); count++;
    }
  }
  public static final class Trip {
    final List<Stop> stops=new ArrayList<>();
    long start,end;
    void add(Stop s){ if(stops.isEmpty()) start=s.start; stops.add(s); end=s.end; }
    int count(){int n=0;for(Stop s:stops)n+=s.count;return n;}
  }
  public static Photo read(Uri uri, InputStream stream) throws Exception {
    ExifInterface exif=new ExifInterface(stream);
    float[] coords=new float[2];
    if (!exif.getLatLong(coords)) return null;
    double lat=coords[0],lon=coords[1];
    if (!Double.isFinite(lat)||!Double.isFinite(lon)||Math.abs(lat)>90||Math.abs(lon)>180) return null;
    String stamp=exif.getAttribute(ExifInterface.TAG_DATETIME_ORIGINAL);
    if (stamp==null) stamp=exif.getAttribute(ExifInterface.TAG_DATETIME);
    if (stamp==null||stamp.length()<19) return null;
    SimpleDateFormat df=new SimpleDateFormat("yyyy:MM:dd HH:mm:ss",Locale.US);
    df.setLenient(false);
    Date when=df.parse(stamp.substring(0,19));
    if(when==null) return null;
    return new Photo(uri,when.getTime(),lat,lon);
  }
  public static double km(double a,double b,double c,double d) {
    double p=Math.toRadians(c-a),q=Math.toRadians(d-b);
    double x=Math.pow(Math.sin(p/2),2)+Math.cos(Math.toRadians(a))*Math.cos(Math.toRadians(c))*Math.pow(Math.sin(q/2),2);
    return 12742.0176*Math.asin(Math.min(1,Math.sqrt(Math.max(0,x))));
  }
  public static List<Trip> group(List<Photo> photos, Double homeLat, Double homeLon, double homeRadiusKm) {
    ArrayList<Photo> sorted=new ArrayList<>(photos);
    sorted.sort(Comparator.comparingLong(p->p.time));
    ArrayList<Stop> stops=new ArrayList<>();
    for(Photo p:sorted){
      if(homeLat!=null&&homeLon!=null&&km(p.latitude,p.longitude,homeLat,homeLon)<=homeRadiusKm) continue;
      Stop prev=stops.isEmpty()?null:stops.get(stops.size()-1);
      if(prev!=null&&p.time-prev.end<=24L*3600*1000&&km(prev.latitude,prev.longitude,p.latitude,p.longitude)<=0.6) prev.add(p);
      else stops.add(new Stop(p));
    }
    ArrayList<Trip> trips=new ArrayList<>();
    for(Stop s:stops){
      Trip prev=trips.isEmpty()?null:trips.get(trips.size()-1);
      if(prev==null||s.start-prev.end>48L*3600*1000) {prev=new Trip();trips.add(prev);}
      prev.add(s);
    }
    return trips;
  }
  public static List<Photo> demo(){
    ArrayList<Photo> a=new ArrayList<>();long t=1788172800000L;
    a.add(new Photo(Uri.EMPTY,t,35.8242,127.1479));
    a.add(new Photo(Uri.EMPTY,t+7200000,35.4346,126.7019));
    a.add(new Photo(Uri.EMPTY,t+8400000,35.4349,126.7021));
    a.add(new Photo(Uri.EMPTY,t+14400000,35.0127,126.7113));
    a.add(new Photo(Uri.EMPTY,t+86400000,34.6815,126.9068));
    return a;
  }
}
