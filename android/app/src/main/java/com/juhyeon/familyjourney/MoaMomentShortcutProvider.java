package com.juhyeon.familyjourney;

import android.app.Activity;
import android.content.ComponentName;
import android.content.Intent;
import android.content.pm.ShortcutInfo;
import android.content.pm.ShortcutManager;
import android.os.Bundle;

/**
 * Real ACTION_CREATE_SHORTCUT provider for Samsung One Hand Operation+
 * Home screen shortcuts chooser. A dynamic or pinned-only shortcut does
 * NOT make an app appear in the legacy chooser on every One UI version.
 *
 * This Activity has no launcher icon, no app data writes, no camera changes.
 * It returns a shortcut to the EXISTING one-swipe monitor toggle action.
 */
public final class MoaMomentShortcutProvider extends Activity {
  private static final String TOGGLE =
    "com.juhyeon.familyjournea.TOGGLE_MOMENT_MONITOR";
  private static final String HOST =
    "com.juhyeon.familyjourney.MoaMomentToggleActivity";

  @Override protected void onCreate(Bundle state) {
    super.onCreate(state);
    if (!Intent.ACTION_CREATE_SHORTCUT.equals(getIntent().getAction())) {
      setResult(RESULT_CANCELED);
      finish();
      return;
    }
    Intent launch = new Intent(TOGGLE);
    launch.setComponent(new ComponentName(this, HOST));
    launch.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK
      | Intent.FLAG_ACTIVITY_MULTIPLE_TASK
      | Intent.FLAG_ACTIVITY_NO_ANIMATION);
    Intent out = null;
    try {
      ShortcutManager manager = getSystemService(ShortcutManager.class);
      if (manager != null) {
        int icon = getApplicationInfo().icon;
        ShortcutInfo.Builder builder =
          new ShortcutInfo.Builder(this, "moa-recording-toggle");
        builder.setShortLabel("모아 기록 전환")
          .setLongLabel("모아 순간 기록 켜기/끄기")
          .setActivity(new ComponentName(this,HOST))
          .setIntent(launch);
        if (icon != 0) builder.setIcon(
          android.graphics.drawable.Icon.createWithResource(this,icon));
        out = manager.createShortcutResultIntent(builder.build());
      }
    } catch(Throwable ignored) { }
    if (out == null) out = new Intent();
    // Some Samsung picker implementations still read the legacy result extras.
    out.putExtra(Intent.EXTRA_SHORTCUT_INTENT,launch);
    out.putExtra(Intent.EXTRA_SHORTCUT_NAME,"모아 기록 전환");
    try {
      int icon = getApplicationInfo().icon;
      if (icon != 0) out.putExtra(Intent.EXTRA_SHORTCUT_ICON_RESOURCE,
        Intent.ShortcutIconResource.fromContext(this,icon));
    } catch(Throwable ignored) { }
    setResult(RESULT_OK,out);
    finish();
    overridePendingTransition(0,0);
  }
}
