package com.juhyeon.moa.linklab;
import android.app.Activity;
import android.os.Bundle;
import android.content.pm.PackageManager;
import android.widget.*;
import android.view.View;
import android.graphics.Color;

public final class MainActivity extends Activity {
    private TextView info;
    private LabStore store;
    @Override public void onCreate(Bundle b){
        super.onCreate(b);store=StoreProvider.get(this);
        ScrollView scroll=new ScrollView(this);
        LinearLayout panel=new LinearLayout(this);panel.setOrientation(LinearLayout.VERTICAL);panel.setPadding(28,100,28,72);
        scroll.addView(panel);
        TextView title=new TextView(this);title.setText("MOA · Android 연동 실험");title.setTextSize(24);panel.addView(title);
        info=new TextView(this);info.setTextSize(16);info.setPadding(0,24,0,24);panel.addView(info);
        add(panel,"합성 학습 작업 1개 등록",()->store.arm());
        add(panel,"연동 상태 다시 읽기",()->{});
        add(panel,"실험 비활성화 및 결과 삭제",()->store.revoke());
        setContentView(scroll);refresh();
    }
    interface Action{void run()throws Exception;}
    private void add(LinearLayout p,String label,Action a){
        Button b=new Button(this);b.setText(label);p.addView(b);
        b.setOnClickListener(v->{try{a.run();refresh();}catch(Exception e){info.setText("ERROR "+e.getClass().getSimpleName());}});
    }
    @Override protected void onResume(){super.onResume();if(info!=null)refresh();}
    private void refresh(){
        try{
            String pkg="com.openai.chatgpt";PackageManager pm=getPackageManager();
            String version;
            try{version=pm.getPackageInfo(pkg,0).versionName;}catch(PackageManager.NameNotFoundException e){version="미설치 또는 조회 불가";}
            boolean system=getSystemService("app_function")!=null;
            boolean execute=pm.checkPermission("android.permission.EXECUTE_APP_FUNCTIONS",pkg)==PackageManager.PERMISSION_GRANTED;
            boolean systemExecute=pm.checkPermission("android.permission.EXECUTE_APP_FUNCTIONS_SYSTEM",pkg)==PackageManager.PERMISSION_GRANTED;
            info.setText("실험 전용 / 실제 모아 데이터 접근 없음\nAndroid API: "+android.os.Build.VERSION.SDK_INT+
             "\nAppFunctions 시스템 서비스: "+system+"\nChatGPT 앱 버전: "+version+
             "\nChatGPT EXECUTE 권한: "+execute+"\nChatGPT SYSTEM EXECUTE 권한: "+systemExecute+
             "\n권한 존재만으로 AI 연결을 증명하지 않음\nChatGPT 실제 실행: 미검증\n사용량: 미측정"+
             "\n합성 대기열: "+store.status()+"\n"+store.result());
        }catch(Exception e){info.setText("ERROR "+e.getClass().getSimpleName());}
    }
}
