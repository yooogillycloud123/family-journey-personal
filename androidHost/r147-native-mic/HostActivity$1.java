package com.juhyeon.familyjourney;

import android.Manifest;
import android.content.pm.PackageManager;
import android.net.Uri;
import android.os.Handler;
import android.os.Looper;
import android.util.Log;
import android.webkit.ConsoleMessage;
import android.webkit.PermissionRequest;
import android.webkit.WebChromeClient;

/**
 * Exact class-descriptor shim for R145 HostActivity's preexisting anonymous
 * WebChromeClient. It only adds a scoped AUDIO_CAPTURE permission bridge.
 * The original legacy SpeechRecognizer, Diary code and data are untouched.
 * Source intentionally contains no signing material.
 */
final class HostActivity$1 extends WebChromeClient {
    private static final String TRUSTED_HOST = "familyjourney.local";
    private static final int MIC_REQUEST_CODE = 2597;
    private final HostActivity host;
    private final Handler handler = new Handler(Looper.getMainLooper());
    private PermissionRequest pending;
    private int attempts;
    private boolean canceled;

    HostActivity$1(HostActivity host) {
        this.host = host;
    }

    @Override public boolean onConsoleMessage(ConsoleMessage message) {
        if (message != null && message.messageLevel() == ConsoleMessage.MessageLevel.ERROR) {
            String text = message.message() + " @" + message.sourceId() + ":" + message.lineNumber();
            Log.e("FamilyJourneyWeb", text);
            try {
                java.lang.reflect.Field f = HostActivity.class.getDeclaredField("lastWebError");
                f.setAccessible(true);
                f.set(host, text);
            } catch (Exception ignored) {}
        }
        return true;
    }

    private boolean trusted(PermissionRequest request) {
        Uri origin = request.getOrigin();
        if (origin == null || !"https".equalsIgnoreCase(origin.getScheme())
                || !TRUSTED_HOST.equalsIgnoreCase(origin.getHost())) return false;
        String[] resources = request.getResources();
        return resources != null && resources.length == 1
                && PermissionRequest.RESOURCE_AUDIO_CAPTURE.equals(resources[0]);
    }

    @Override public void onPermissionRequest(PermissionRequest request) {
        host.runOnUiThread(() -> {
            if (!trusted(request)) { request.deny(); return; }
            if (pending != null && pending != request) {
                try { pending.deny(); } catch (Exception ignored) {}
            }
            pending = request;
            canceled = false;
            attempts = 0;
            if (host.checkSelfPermission(Manifest.permission.RECORD_AUDIO)
                    == PackageManager.PERMISSION_GRANTED) {
                finishRequest(true);
            } else {
                try {
                    host.requestPermissions(new String[]{Manifest.permission.RECORD_AUDIO}, MIC_REQUEST_CODE);
                    handler.postDelayed(this::checkPermission, 180);
                } catch (Exception e) {
                    Log.w("MoaNativeMic", "OS mic permission request failed", e);
                    finishRequest(false);
                }
            }
        });
    }

    private void checkPermission() {
        if (pending == null || canceled || host.isFinishing()) {
            finishRequest(false);
            return;
        }
        if (host.checkSelfPermission(Manifest.permission.RECORD_AUDIO)
                == PackageManager.PERMISSION_GRANTED) {
            finishRequest(true);
        } else if (++attempts < 120) {
            handler.postDelayed(this::checkPermission, 180);
        } else {
            finishRequest(false);
        }
    }

    private void finishRequest(boolean allowed) {
        PermissionRequest target = pending;
        pending = null;
        if (target == null) return;
        try {
            if (allowed && !canceled) target.grant(
                    new String[]{PermissionRequest.RESOURCE_AUDIO_CAPTURE});
            else target.deny();
        } catch (Exception e) {
            Log.w("MoaNativeMic", "WebView mic request ended", e);
        }
    }

    @Override public void onPermissionRequestCanceled(PermissionRequest request) {
        host.runOnUiThread(() -> {
            if (pending == request) {
                canceled = true;
                pending = null;
            }
        });
    }
}
