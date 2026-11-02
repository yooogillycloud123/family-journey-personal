package com.juhyeon.familyjourney;

import android.Manifest;
import android.app.Activity;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.os.Build;
import android.os.Bundle;
import android.provider.Settings;
import android.net.Uri;
import android.graphics.Color;
import android.graphics.Typeface;
import android.view.View;
import android.widget.*;

/** One-time, explicit setup for MOA native camera capture mode.
 * No account, camera replacement, Accessibility, root or ADB required. */
public final class MoaMomentSetupActivity extends Activity {
  private TextView message;
  private boolean userRequestedStart = false;
  private static final int RC_MEDIA = 701, RC_OVERLAY = 702;
  @Override protected void onCreate(Bundle state) {
    super.onCreate(state);
    LinearLayout box=new LinearLayout(this);box.setOrientation(LinearLayout.VERTICAL);
    box.setPadding(32,36,32,24);box.setBackgroundColor(Color.WHITE);
    TextView title=new TextView(this);title.setText("모아 · 순간 기록 설정");
    title.setTextColor(0xff243140);title.setTextSize(24);title.setTypeface(null,Typeface.BOLD);
    box.addView(title);
    message=new TextView(this);message.setTextColor(0xff39495a);message.setTextSize(15);
    message.setPadding(0,20,0,20);box.addView(message);
    Button grant=new Button(this);grant.setText("필요한 권한 허용");box.addView(grant);
    grant.setOnClickListener(v->checkPermissions(true));
    Button start=new Button(this);start.setText("모아 순간 기록 켜기");box.addView(start);
    start.setOnClickListener(v->{userRequestedStart=true;checkPermissions(true);});
    Button off=new Button(this);off.setText("순간 기록 끄기");box.addView(off);
    off.setOnClickListener(v->{MoaMomentCaptureService.switchTo(this,false);update();});
    TextView hint=new TextView(this);
    hint.setText("사진과 동영상이 DCIM/Camera에 저장되면 감지합니다. 삼성 카메라를 수정하지 않으며, 모드가 켜진 동안 알림이 표시됩니다. 촬영 직후 카메라 위 버튼은 '다른 앱 위에 표시' 허용 후 사용할 수 있습니다.");
    hint.setPadding(0,18,0,0);box.addView(hint);
    ScrollView scroll=new ScrollView(this);scroll.addView(box);setContentView(scroll);
    update();
  }
  private boolean mediaGranted(){
    boolean photo=checkSelfPermission(Manifest.permission.READ_MEDIA_IMAGES)==PackageManager.PERMISSION_GRANTED;
    boolean video=checkSelfPermission(Manifest.permission.READ_MEDIA_VIDEO)==PackageManager.PERMISSION_GRANTED;
    boolean notify=Build.VERSION.SDK_INT<33 || checkSelfPermission(Manifest.permission.POST_NOTIFICATIONS)==PackageManager.PERMISSION_GRANTED;
    return photo&&video&&notify;
  }
  private boolean overlayGranted(){return Settings.canDrawOverlays(this);}
  private void update(){
    String err=MoaMomentCaptureService.prefs(this).getString("lastError","");
    message.setText("사진·영상 전체 접근: "+(mediaGranted()?"허용":"확인 필요")+
      "\n카메라 위 작은 기록 버튼: "+(overlayGranted()?"허용":"허용 필요")+
      "\n현재 기록 모드: "+(MoaMomentCaptureService.enabled(this)?"ON":"OFF")+
      (err.isEmpty()?"":"\n진단: "+err));
  }
  private void checkPermissions(boolean requested){
    if(!mediaGranted()){
      if(Build.VERSION.SDK_INT>=33){
        requestPermissions(new String[]{Manifest.permission.READ_MEDIA_IMAGES,
         Manifest.permission.READ_MEDIA_VIDEO,Manifest.permission.POST_NOTIFICATIONS},RC_MEDIA);
      }
      update();return;
    }
    if(!overlayGranted()){
      Intent i=new Intent(Settings.ACTION_MANAGE_OVERLAY_PERMISSION,
       Uri.parse("package:"+getPackageName()));
      try{startActivityForResult(i,RC_OVERLAY);}catch(Exception e){
        Toast.makeText(this,"설정에서 '다른 앱 위에 표시'를 허용해 주세요",Toast.LENGTH_LONG).show();
      }
      update();return;
    }
    if(userRequestedStart){
      MoaMomentCaptureService.switchTo(this,true);
      userRequestedStart=false;
      MoaMomentCaptureService.updateTile(this);
      update();
    }
  }
  @Override public void onRequestPermissionsResult(int code,String[] perms,int[] grants){
    super.onRequestPermissionsResult(code,perms,grants);
    if(code==RC_MEDIA)checkPermissions(false);
  }
  @Override protected void onResume(){super.onResume();update();}
  @Override protected void onActivityResult(int request,int result,Intent data){
    super.onActivityResult(request,result,data);
    if(request==RC_OVERLAY&&overlayGranted())checkPermissions(false);
  }
}
