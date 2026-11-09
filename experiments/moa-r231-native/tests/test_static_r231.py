from pathlib import Path
import hashlib,zipfile,struct,zlib
ROOT=Path('/mnt/data')
a=ROOT/'MOA_R229_NAVER_ONE_TAP_RETURN_BETA.apk'
b=ROOT/'MOA_R231_NAVER_RETURN_SETTINGS_WEBVIEW_PROBE_BETA.apk'
assert hashlib.sha256(a.read_bytes()).hexdigest()=='823bed41210be28b971860c88879bbc43e934793cf9847d1f0cb7e3e4f1cef74'
with zipfile.ZipFile(a) as old,zipfile.ZipFile(b) as new:
 assert new.testzip() is None
 assert len(new.namelist())==133
 changes={x for x in old.namelist() if old.read(x)!=new.read(x)}
 assert changes=={'AndroidManifest.xml','classes6.dex','classes10.dex','assets/web/index.html'}
 assert set(new.namelist())-set(old.namelist())=={'assets/web/moa-r231-naver-ui.js','assets/web/moa-r231-naver-ui.css'}
 assert new.read('AndroidManifest.xml').count(bytes.fromhex('08000010e7000000'))==1
 assert b'MoaNaverFeaturesBridge' in new.read('classes6.dex')
 assert b'MoaNaverWebProbeDialog' in new.read('classes10.dex')
 assert b'moa_naver_return_overlay_v1' in new.read('classes10.dex')
 assert b'moa_quick_overlay_v1' not in new.read('classes10.dex')
 for i in range(1,11):
  name='classes'+(str(i) if i>1 else '')+'.dex';raw=new.read(name)
  assert hashlib.sha1(raw[32:]).digest()==raw[12:32]
  assert struct.unpack_from('<I',raw,8)[0]==zlib.adler32(raw[12:])&0xffffffff
 js=new.read('assets/web/moa-r231-naver-ui.js').decode();css=new.read('assets/web/moa-r231-naver-ui.css').decode()
 assert '네이버지도 복귀 팝업' in js
 assert '네이버 즐겨찾기 웹 연결' in js
 assert 'MoaNaverFeatures' in js
 assert 'moa-r215-quick-popup-settings' in js
 assert css.count('moa-r231')>15
 source=Path('/mnt/data/moa_r231_work/src/com/juhyeon/familyjourney/MoaNaverWebProbeDialog.java').read_text()
 assert 'CookieManager.getInstance().getCookie' not in source
 assert 'document.querySelectorAll' in source
 assert '30' in source
 print('R231_APP_STATIC_PRESERVATION_AND_READONLY_PROBE=PASS')