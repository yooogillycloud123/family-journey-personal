package com.juhyeon.familyjourney;

import android.Manifest;
import android.app.Activity;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.os.Bundle;
import android.os.SystemClock;
import android.widget.Toast;

/**
 * Dedicated same-APK One Hand Operation+ entry point.
 *
 * The old static shortcut targeted HostActivity; Samsung launched the full MOA
 * UI instead of executing its optional Application lifecycle toggle callback.
 * This activity does NOT start HostActivity, a WebView or the diary.
 * It only calls the same switchTo/updateTile implementation as the QS tile.
 */
public final class MoaMomentToggleActivity extends Activity {
  public static final String ACTION_TOGGLE =
      "com.juhyeon.familyjournea.TOGGLE_MOMENT_MONITOR";
  private static final String STATE = "moa_camera_native_v1";
  private static final long DEBOUNCE_MS = 750L;
  private boolean handled;

  @Override protected void onCreate(Bundle state) {
    super.onCreate(state);
    getWindow().addFlags(android.view.WindowManager.LayoutParams.FLAG_NOT_TOUCH_MODAL);
  }

  @Override protected void onResume() {
    super.onResume();
    if(handled) return;
    handled=true;
    Intent in=getIntent();
    if(in==null || !ACTION_TOGGLE.equals(in.getAction())) {
      finish();
      overridePendingTransition(0,0);
      return;
    }

    // RUN ONLY ONCE per shortcut invocation, even if Samsung sends an
    // accidental duplicate launch event while a gesture completes.
    final android.content.SharedPreferences prefs=
      getSharedPreferences(STATE,MODE_PRIVATE);
    final long now=SystemClock.elapsedRealtime();
    final long previous=prefs.getLong("shortcutToggleElapsed",0L);
    if(previous>0 && now>=previous && now-previous<DEBOUNCE_MS) {
      finish();
      overridePendingTransition(0,0);
      return;
    }
    prefs.edit().putLong("shortcutToggleElapsed",now).commit();

    boolean before=MoaMomentCaptureService.enabled(this);
    boolean want=!before;
    String outcome;
    try {
      if(want && (checkSelfPermission(Manifest.permission.READ_MEDIA_IMAGES)!=PackageManager.PERMISSION_GRANTED
        || checkSelfPermission(Manifest.permission.READ_MEDIA_VIDEO)!=PackageManager.PERMISSION_GRANTED
        || checkSelfPermission(Manifest.permission.POST_NOTIFICATIONS)!=PackageManager.PERMISSION_GRANTED)) {
        outcome="권한 없음 · 모아 설정에서 사진·영상·알림 권한을 허용하세요";
      } else {
        MoaMomentCaptureService.switchTo(this,want);
        MoaMomentCaptureService.updateTile(this);
        boolean after=MoaMomentCaptureService.enabled(this);
        outcome=after==want ? (after?"모아 기록 켜짐":"모아 기록 꺼짐")
          : "모아 기록 전환 실패 · "+prefs.getString("lastError","설정 확인 필요");
      }
    } catch(Throwable error) {
      outcome="모아 기록 전환 오류 · "+error.getClass().getSimpleName();
    }
    prefs.edit().putString("shortcutToggleDiagnostic",outcome)
      .putLong("shortcutToggleAt",System.currentTimeMillis()).apply();
    Toast.makeText(this,outcome,Toast.LENGTH_SHORT).show();
    finish();
    overridePendingTransition(0,0);
  }
}
