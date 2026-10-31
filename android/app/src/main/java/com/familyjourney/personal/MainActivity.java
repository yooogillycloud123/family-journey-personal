package com.familyjourney.personal;

import android.Manifest;
import android.app.Activity;
import android.os.Build;
import android.os.Bundle;
import android.os.Environment;
import android.content.Intent;
import android.content.ContentValues;
import android.content.pm.PackageManager;
import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.net.Uri;
import android.provider.MediaStore;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.ScrollView;
import android.widget.TextView;
import android.widget.Toast;
import android.graphics.Color;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

public final class MainActivity extends Activity {
  private static final int PICK=70,LOCATION_PERMISSION=71;
  private final ExecutorService work=Executors.newSingleThreadExecutor();
  private final List<TripEngine.Photo> photos=new ArrayList<>();
  private List<TripEngine.Trip> trips=new ArrayList<>();
  private RoutePainter preview;
  private TextView status;
  private EditText homeLat,homeLon;
  private boolean demo=false;
  private int dp(float n){return (int)(n*getResources().getDisplayMetrics().density+.5f);}
  @Override public void onCreate(Bundle state){
    super.onCreate(state);
    ScrollView scroll=new ScrollView(this);
    LinearLayout box=new LinearLayout(this);box.setOrientation(LinearLayout.VERTICAL);box.setPadding(dp(18),dp(22),dp(18),dp(22));box.setBackgroundColor(0xfff6fafb);
    scroll.addView(box);setContentView(scroll);
    TextView title=new TextView(this);title.setText("우리 가족 여행");title.setTextSize(27);title.setTextColor(0xff15495d);box.addView(title);
    TextView caption=new TextView(this);caption.setText("사진은 기기 밖으로 보내지 않고 GPS·촬영 시간만 분석합니다.\n현재 지도는 실제 도로가 아닌 좌표 이동 경로입니다.");caption.setPadding(0,dp(7),0,dp(14));box.addView(caption);
    Button select=button("내 사진 선택 (여러 장)",box);select.setOnClickListener(v->pick());
    Button demoBtn=button("샘플 여행 보기 (실제 기록 아님)",box);demoBtn.setOnClickListener(v->{photos.clear();photos.addAll(TripEngine.demo());demo=true;regroup();});
    TextView lbl=new TextView(this);lbl.setText("자택 주변 제외 (선택사항 · 직접 입력한 경우만 적용)");lbl.setPadding(0,dp(15),0,0);box.addView(lbl);
    LinearLayout row=new LinearLayout(this);box.addView(row);
    homeLat=new EditText(this);homeLat.setHint("위도");homeLat.setSingleLine(true);homeLat.setInputType(8194);row.addView(homeLat,new LinearLayout.LayoutParams(0,dp(48),1));
    homeLon=new EditText(this);homeLon.setHint("경도");homeLon.setSingleLine(true);homeLon.setInputType(8194);row.addView(homeLon,new LinearLayout.LayoutParams(0,dp(48),1));
    Button refresh=button("선택한 자택 반경 1.5km 제외 후 다시 분석",box);refresh.setOnClickListener(v->regroup());
    status=new TextView(this);status.setText("아직 사진을 선택하지 않았습니다.");status.setTextColor(0xff315262);status.setPadding(0,dp(16),0,dp(14));box.addView(status);
    preview=new RoutePainter(this);box.addView(preview,new LinearLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT,dp(420)));
    Button png=button("여행 지도 PNG 저장 (사진첩)",box);png.setOnClickListener(v->exportPng());
    Button mp4=button("여행 경로 MP4 저장 (720p 샘플 엔진)",box);mp4.setOnClickListener(v->exportVideo());
    TextView foot=new TextView(this);foot.setText("v0.1 · 사진 접근은 파일 선택 시에만 사용 · 저장은 이 기기 내부\n영상은 6초 직선 경로 샘플이며 실제 지도 타일/프리미엄 효과는 아직 구현 중입니다.");foot.setTextColor(0xff70848c);box.addView(foot);
    if(Build.VERSION.SDK_INT>=29&&checkSelfPermission(Manifest.permission.ACCESS_MEDIA_LOCATION)!=PackageManager.PERMISSION_GRANTED){
      requestPermissions(new String[]{Manifest.permission.ACCESS_MEDIA_LOCATION},LOCATION_PERMISSION);
    }
  }
  private Button button(String label,LinearLayout box){
    Button b=new Button(this);b.setText(label);box.addView(b,new LinearLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT,dp(52)));return b;
  }
  private void pick(){
    Intent intent=new Intent(Intent.ACTION_OPEN_DOCUMENT);
    intent.setType("image/*");intent.addCategory(Intent.CATEGORY_OPENABLE);
    intent.putExtra(Intent.EXTRA_ALLOW_MULTIPLE,true);
    intent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION|Intent.FLAG_GRANT_PERSISTABLE_URI_PERMISSION);
    startActivityForResult(intent,PICK);
  }
  @Override protected void onActivityResult(int request,int result,Intent data){
    super.onActivityResult(request,result,data);
    if(request!=PICK||result!=RESULT_OK||data==null)return;
    ArrayList<Uri> uris=new ArrayList<>();
    if(data.getClipData()!=null){
      for(int i=0;i<data.getClipData().getItemCount();i++) uris.add(data.getClipData().getItemAt(i).getUri());
    }else if(data.getData()!=null)uris.add(data.getData());
    status.setText("선택한 사진 "+uris.size()+"장 분석 중…");
    work.execute(()->{
      ArrayList<TripEngine.Photo> loaded=new ArrayList<>();int errors=0,missing=0;
      for(Uri uri:uris){
        try{
          Uri original=uri;
          if(Build.VERSION.SDK_INT>=29){try{original=MediaStore.setRequireOriginal(uri);}catch(Exception ignored){}}
          try(InputStream in=getContentResolver().openInputStream(original)){
            if(in==null){errors++;continue;}
            TripEngine.Photo p=TripEngine.read(uri,in);
            if(p!=null) loaded.add(p);else missing++;
          }
        }catch(Exception e){errors++;}
      }
      int err=errors,miss=missing;
      runOnUiThread(()->{
        photos.clear();photos.addAll(loaded);demo=false;regroup();
        status.append("\nGPS/촬영시각 없음: "+miss+"장 · 읽기 오류: "+err+"장");
      });
    });
  }
  private void regroup(){
    Double lat=null,lon=null;
    try{
      if(!homeLat.getText().toString().trim().isEmpty()&&!homeLon.getText().toString().trim().isEmpty()){
        lat=Double.parseDouble(homeLat.getText().toString().trim());
        lon=Double.parseDouble(homeLon.getText().toString().trim());
        if(Math.abs(lat)>90||Math.abs(lon)>180)throw new NumberFormatException();
      }
    }catch(NumberFormatException e){status.setText("자택 위도·경도를 확인해 주세요.");return;}
    trips=TripEngine.group(photos,lat,lon,1.5);
    preview.setTrips(trips);
    int stops=0,count=0;
    for(TripEngine.Trip t:trips){stops+=t.stops.size();count+=t.count();}
    status.setText((demo?"[샘플 데이터] ":"")+"유효 GPS 사진 "+count+"장 · 여행 "+trips.size()+"회 · 방문지 "+stops+"곳");
  }
  private void exportPng(){
    if(trips.isEmpty()){toast("먼저 GPS 사진이나 샘플을 선택하세요.");return;}
    List<TripEngine.Trip> copy=new ArrayList<>(trips);
    work.execute(()->{
      try{
        Bitmap bitmap=Bitmap.createBitmap(1080,1920,Bitmap.Config.ARGB_8888);
        RoutePainter.drawRoute(new Canvas(bitmap),1080,1920,copy,1);
        ContentValues values=new ContentValues();
        values.put(MediaStore.MediaColumns.DISPLAY_NAME,"FamilyJourney_"+System.currentTimeMillis()+".png");
        values.put(MediaStore.MediaColumns.MIME_TYPE,"image/png");
        if(Build.VERSION.SDK_INT>=29) values.put(MediaStore.MediaColumns.RELATIVE_PATH,Environment.DIRECTORY_PICTURES+"/FamilyJourney");
        Uri uri=getContentResolver().insert(MediaStore.Images.Media.EXTERNAL_CONTENT_URI,values);
        if(uri==null)throw new Exception("저장 위치가 없습니다");
        try(OutputStream out=getContentResolver().openOutputStream(uri)){
          if(out==null||!bitmap.compress(Bitmap.CompressFormat.PNG,100,out))throw new Exception("PNG 저장 실패");
        }
        bitmap.recycle();runOnUiThread(()->toast("사진첩에 여행 지도 저장 완료"));
      }catch(Exception e){runOnUiThread(()->toast("지도 저장 실패: "+e.getMessage()));}
    });
  }
  private void exportVideo(){
    if(trips.isEmpty()){toast("먼저 GPS 사진이나 샘플을 선택하세요.");return;}
    List<TripEngine.Trip> copy=new ArrayList<>(trips);
    status.setText("MP4 영상 제작 중… 앱을 종료하지 마세요.");
    work.execute(()->{
      try{
        Uri uri=VideoExporter.save(this,copy);
        runOnUiThread(()->{regroup();toast("영상 저장 완료: 사진앱/영화/FamilyJourney");});
      }catch(Exception e){runOnUiThread(()->{regroup();toast("영상 제작 실패: "+e.getClass().getSimpleName()+" "+e.getMessage());});}
    });
  }
  private void toast(String message){Toast.makeText(this,message,Toast.LENGTH_LONG).show();}
  @Override protected void onDestroy(){super.onDestroy();work.shutdown();}
}
