package com.juhyeon.moa.geckoprobe;

import android.app.Activity;
import android.os.Bundle;
import android.util.Log;
import android.widget.LinearLayout;
import android.widget.TextView;
import org.mozilla.geckoview.GeckoRuntime;
import org.mozilla.geckoview.GeckoSession;
import org.mozilla.geckoview.GeckoSessionSettings;
import org.mozilla.geckoview.GeckoView;

public final class ProbeActivity extends Activity {
  private static final String TAG="MOA_GECKO_PROBE";
  private static GeckoRuntime runtime;
  private GeckoSession session;
  private TextView status;
  private void record(String value) {
    Log.i(TAG,value);
    runOnUiThread(() -> { if(status != null) status.setText("GeckoView Android Device\n"+value); });
  }
  @Override public void onCreate(Bundle saved) {
    super.onCreate(saved);
    LinearLayout root=new LinearLayout(this);
    root.setOrientation(LinearLayout.VERTICAL);
    status=new TextView(this);
    status.setText("DEVICE_PROBE_START");
    status.setTextSize(13f);
    root.addView(status,new LinearLayout.LayoutParams(-1,-2));
    GeckoView view=new GeckoView(this);
    root.addView(view,new LinearLayout.LayoutParams(-1,0,1f));
    setContentView(root);
    try {
      if(runtime==null) runtime=GeckoRuntime.create(this);
      session=new GeckoSession();
      session.getSettings().setUserAgentMode(GeckoSessionSettings.USER_AGENT_MODE_DESKTOP);
      session.getSettings().setViewportMode(GeckoSessionSettings.VIEWPORT_MODE_DESKTOP);
      session.setContentDelegate(new GeckoSession.ContentDelegate(){});
      session.setProgressDelegate(new GeckoSession.ProgressDelegate(){
        @Override public void onPageStart(GeckoSession s,String url) {record("NAVIGATE "+sanitize(url));}
        @Override public void onPageStop(GeckoSession s,boolean success) {record("PAGE_STOP "+success);}
      });
      session.open(runtime);
      view.setSession(session);
      record("START https://map.naver.com/p/");
      session.loadUri("https://map.naver.com/p/");
    }catch(Throwable e){record("ENGINE_ERROR "+e.getClass().getSimpleName());}
  }
  private static String sanitize(String url) {
    try {
      android.net.Uri u=android.net.Uri.parse(url);
      return (u.getScheme()==null?"":u.getScheme()+"://")+(u.getHost()==null?"":u.getHost())+(u.getPath()==null?"":u.getPath());
    }catch(Exception ex) {return "UNPARSEABLE";}
  }
  @Override protected void onDestroy() {
    if(session!=null) try{session.close();}catch(Throwable ignored){}
    super.onDestroy();
  }
}
