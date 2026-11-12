package com.juhyeon.familyjourney;

import android.app.Activity;
import android.app.Application;
import android.content.ContentProvider;
import android.content.ContentValues;
import android.database.Cursor;
import android.net.Uri;
import android.os.Bundle;
import android.os.SystemClock;
import android.webkit.CookieManager;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.ThreadFactory;

/** No cookie read/write/deletion: only persist existing WebView session data on pause/stop. */
public final class MoaR391SessionPersistProvider extends ContentProvider {
    private static final ExecutorService WORKER = Executors.newSingleThreadExecutor(new ThreadFactory() {
        @Override public Thread newThread(Runnable r) {
            Thread t = new Thread(r, "moa-r391-cookie-flush");
            t.setDaemon(true);
            return t;
        }
    });
    private static long lastQueuedMs = -10000L;

    private static synchronized void persist() {
        long now = SystemClock.elapsedRealtime();
        if (now - lastQueuedMs < 2500L) return;
        lastQueuedMs = now;
        WORKER.execute(new Runnable() {
            @Override public void run() {
                try { CookieManager.getInstance().flush(); }
                catch (Throwable ignored) { }
            }
        });
    }
    @Override public boolean onCreate() {
        try {
            Application app = (Application)getContext().getApplicationContext();
            if (app == null) return true;
            app.registerActivityLifecycleCallbacks(new Application.ActivityLifecycleCallbacks() {
                @Override public void onActivityCreated(Activity a, Bundle b) { }
                @Override public void onActivityStarted(Activity a) { }
                @Override public void onActivityResumed(Activity a) { }
                @Override public void onActivityPaused(Activity a) { persist(); }
                @Override public void onActivityStopped(Activity a) { persist(); }
                @Override public void onActivitySaveInstanceState(Activity a, Bundle b) { }
                @Override public void onActivityDestroyed(Activity a) { }
            });
        } catch (Throwable ignored) { }
        return true;
    }
    @Override public Cursor query(Uri uri, String[] p, String s, String[] sa, String sort) { return null; }
    @Override public String getType(Uri uri) { return null; }
    @Override public Uri insert(Uri uri, ContentValues v) { return null; }
    @Override public int delete(Uri uri, String s, String[] args) { return 0; }
    @Override public int update(Uri uri, ContentValues v, String s, String[] args) { return 0; }
}
