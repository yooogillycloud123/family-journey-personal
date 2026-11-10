# Isolated Android WebView cross-origin frame test — NOT a MOA release APK
- Android WebView actual runtime on emulator, 2x2 attached & rendered. No login or server write.
- Desktop UA, map.naver.com/p/entry/place/1628573942 avoids R241 root ?app=Y&appmarket=N landing.
- WebViewCompat DOCUMENT_START_SCRIPT + WEB_MESSAGE_LISTENER allow only three first-party map hosts, detect main and child frames.
- Report redirect loop, page errors, and whether Place child frame is accessible. A desktop Chrome mock passing != Android embedded WebView passing.
- No JS click, no cookies exfiltration, no private API use, no changes to original signed R269.
