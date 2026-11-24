#!/usr/bin/env python3
"""Read-only regression report on original-signed R709 and R710 user APKs."""
import hashlib
import json
import struct
import sys
import zipfile
import zlib
from pathlib import Path

sys.path.insert(0,str(Path(__file__).resolve().parent.parent/'tools'))
from moa_apk_v2_signer_guard import guard

EXPECTED="b72856150410491b87cd01c3ecbe1a3178e2d1a6488fdf4494d06afcf50fb200"
CERT="5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15"

def dex_integrity(data):
    assert data.startswith(b'dex\n')
    assert struct.unpack_from('<I',data,32)[0]==len(data)
    assert hashlib.sha1(data[32:]).digest()==data[12:32]
    assert (zlib.adler32(data[12:])&0xffffffff)==struct.unpack_from('<I',data,8)[0]
    return True

def read_manifest(binary):
    import axml
    return axml.read_nodes(binary)

def run(base,release,out):
    assert hashlib.sha256(base.read_bytes()).hexdigest()==EXPECTED
    with zipfile.ZipFile(base) as z:
        golden={n:z.read(n) for n in z.namelist()}
    result={"golden_sha256":EXPECTED,"expected_original_cert":CERT,
       "physical_device_qa":"NOT_PERFORMED","apk_sign_scheme_2":"INDEPENDENT_RSA_AND_FULL_DIGEST", "apks":{}}
    for code,name in [(709,'MOA_R709_EXACT_MEDIA_PREVIEW_ORIGINAL_SIGNED_BETA.apk'),
                      (710,'MOA_R710_EXACT_R707_FUNCTIONAL_FORWARD_RECOVERY_ORIGINAL_SIGNED.apk')]:
        path=release/name
        proof=guard(path,CERT)
        with zipfile.ZipFile(path) as z:
            members=z.namelist()
            assert len(members)==(168 if code==709 else 167)
            assert len(members)==len(set(members))
            changed=[n for n,b in golden.items() if z.read(n)!=b]
            assert changed==['AndroidManifest.xml'],changed
            extras=sorted(set(members)-set(golden))
            assert extras==(['classes20.dex'] if code==709 else []),extras
            native_gallery=(z.read('classes6.dex')==golden['classes6.dex'])
            photo_host=(z.read('classes18.dex')==golden['classes18.dex'])
            diary_js=(z.read('assets/web/family-diary.js')==golden['assets/web/family-diary.js'])
            assert native_gallery and photo_host and diary_js
            dex=[n for n in members if n=='classes.dex' or n.startswith('classes') and n.endswith('.dex')]
            assert len(dex)==(20 if code==709 else 19)
            assert all(dex_integrity(z.read(n)) for n in dex)
            nodes=read_manifest(z.read('AndroidManifest.xml'))
            main=dict(nodes[0][1]);assert main['package']['value']=='com.juhyeon.familyjournea'
            assert main['versionCode']['value']==code
            providers=[a.get('name',{}).get('value') for n,a in nodes if n=='provider']
            if code==709:
                assert providers.count('com.juhyeon.familyjourney.MoaR709PreviewProvider')==1
                dex20=z.read('classes20.dex')
                assert b'Lcom/juhyeon/familyjourney/MoaR709PreviewProvider;' in dex20
                assert hashlib.sha256(dex20).hexdigest()=='9aa01f64d41ee708fe0de7c8b2de9579d2f52d1c69597d8a34a79c1bc12c4bf7'
            else:
                assert 'com.juhyeon.familyjourney.MoaR709PreviewProvider' not in providers
            result['apks'][str(code)]={**proof,
                'changed_original_members':changed,'added_members':extras,
                'dex_count':len(dex),'all_dex_header_integrity':'PASS',
                'protected_gallery_classes6_byte_exact':native_gallery,
                'protected_photo_host_classes18_byte_exact':photo_host,
                'protected_diary_storage_js_byte_exact':diary_js,
                'manifest_version_code':code,'manifest_package':'com.juhyeon.familyjournea',
                'provider_in_R709_only':'PASS',
                'original_167_member_payloads_except_manifest_unchanged':'PASS',
                'status':'STATIC_VERIFIED_DEVICE_PENDING'}
    out.write_text(json.dumps(result,ensure_ascii=False,indent=2)+'\n')
    print('STATIC_QA_PASS',*[f'R{v}={result["apks"][str(v)]["sha256"]}' for v in (709,710)])

if __name__=='__main__':
    run(Path(sys.argv[1]),Path(sys.argv[2]),Path(sys.argv[3]))
