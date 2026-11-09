#!/usr/bin/env python3
"""Static source and privacy invariants; device functionality is NOT verified."""
from pathlib import Path
import hashlib, difflib, re, sys
root=Path(__file__).resolve().parents[1]
base=(root/'R227_MoaNativeGallery.java').read_text()
new=(root/'MoaNativeGallery.java').read_text()
java=(root/'src/com/juhyeon/familyjourney/MoaNaverReturnOverlay.java').read_text()
probe=(root/'src/com/juhyeon/familyjourney/MoaNaverWebProbeHost.java').read_text()
assert new.replace('  MoaNaverReturnOverlay.hide();\n  if(!r227ExternalMapPending)', '  if(!r227ExternalMapPending)') != base  # additional isolated changes
# Strictly expect the baseline with ONLY 4 additional lines (one show+two commentary+two hide).
reconstructed = new.replace('  MoaNaverReturnOverlay.hide();\n  if(!r227ExternalMapPending)', '  if(!r227ExternalMapPending)',1)
reconstructed = reconstructed.replace('  // One-action return to the R227 retained gallery, using existing user-granted overlay permission.\n  // If permission is absent, NAVER still opens normally and the app offers its original Back path.\n  MoaNaverReturnOverlay.show(activity);\n', '',1)
reconstructed = reconstructed.replace(' public void close(){\n  MoaNaverReturnOverlay.hide();',' public void close(){',1)
assert reconstructed==base, 'R227 Gallery unexpectedly altered beyond 3 overlay integration points'
assert new.count('MoaNaverReturnOverlay.show(activity)')==1
assert new.count('MoaNaverReturnOverlay.hide();')==2
assert 'r227ExternalMapPending' in new and 'r227VideoWasPlaying' in new
assert 'moa_naver_return_overlay_v1' in java and 'moa_quick_overlay_v1' not in java
assert java.count('TYPE_APPLICATION_OVERLAY')==1
assert 'Settings.canDrawOverlays(ctx)' in java
assert 'startActivity(nav)' in new
assert 'MoaNaverReturnOverlay.show(activity);\n  try{activity.startActivity(nav);}' in new
assert 'MoaNaverReturnOverlay.hide();\n  if(!r227ExternalMapPending)' in new
for banned in ['AccessibilityService','MediaProjection','Shizuku','getCookie(','javascript:','getAccounts(']:
 assert banned not in probe, f'Unsafe or unnecessary capability: {banned}'
assert 'setAllowFileAccess(false)' in probe and 'setAllowContentAccess(false)' in probe
assert 'setJavaScriptEnabled(true)' in probe and 'setDomStorageEnabled(true)' in probe
assert 'ORIGINS.contains(sourceOrigin.toString())' in probe
assert 'addDocumentStartJavaScript' in probe
assert 'read-only' in (root/'README_KO.md').read_text().lower() or '읽기 전용' in (root/'README_KO.md').read_text()
print('R229_STATIC_SOURCE_GUARD=PASS')
print('R227_GALLERY_BASE_SHA256='+hashlib.sha256(base.encode()).hexdigest())
print('R229_GALLERY_WORKING_SHA256='+hashlib.sha256(new.encode()).hexdigest())
print('OVERLAY_SOURCE_SHA256='+hashlib.sha256(java.encode()).hexdigest())
print('WEB_PROBE_SOURCE_SHA256='+hashlib.sha256(probe.encode()).hexdigest())
print('APP_APK_BUILT=NO')
print('GALAXY_DEVICE_QA=NOT_TESTED')