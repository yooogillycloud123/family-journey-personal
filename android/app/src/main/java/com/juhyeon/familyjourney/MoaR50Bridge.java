package com.juhyeon.familyjourney;

import android.webkit.WebView;

/**
 * R50 direct HostActivity/WebView bridge, shipped as classes6.dex.
 *
 * R49 classes2.dex must be patched first:
 * HostActivity ACC_FINAL 0x11 -> 0x01,
 * HostActivity.web ACC_PRIVATE 0x02 -> ACC_PROTECTED 0x04.
 * The original HostActivity methods are byte-for-byte unchanged.
 */
public final class MoaR50Bridge extends HostActivity {
  private boolean bridgeAttached;
  private void ensureBridge() {
    WebView w=web;
    if(w==null||bridgeAttached) return;
    w.addJavascriptInterface(new MoaMomentApplication.CaptureBridge(this),"MoaMomentNative");
    bridgeAttached=true;
    w.reload();
  }
  @Override protected void onResume() {
    super.onResume();
    ensureBridge();
  }
  @Override public void onWindowFocusChanged(boolean focused) {
    super.onWindowFocusChanged(focused);
    if(focused)ensureBridge();
  }
}
