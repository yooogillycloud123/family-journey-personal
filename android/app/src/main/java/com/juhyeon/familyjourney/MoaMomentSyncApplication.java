package com.juhyeon.familyjourney;
import android.app.Activity;
import android.app.Application;
import android.os.Bundle;
/** R42 fall-back safe: only forward the original Activity resume event to durable inbox sync. */
public final class MoaMomentSyncApplication extends Application implements Application.ActivityLifecycleCallbacks {
  @Override public void onCreate(){super.onCreate();registerActivityLifecycleCallbacks(this);}
  @Override public void onActivityResumed(Activity a){MoaMomentInboxSync.onResume(a);}
  @Override public void onActivityCreated(Activity a,Bundle b){}
  @Override public void onActivityStarted(Activity a){}
  @Override public void onActivityPaused(Activity a){}
  @Override public void onActivityStopped(Activity a){}
  @Override public void onActivitySaveInstanceState(Activity a,Bundle b){}
  @Override public void onActivityDestroyed(Activity a){}
}
