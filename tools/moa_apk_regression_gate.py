#!/usr/bin/env python3
"""MOA R42 preservation regression preflight; NOT an Android install/device test.

python tools/moa_apk_regression_gate.py --baseline R42.apk --candidate proposed.apk
Exit 0: all static checks pass; exit 1: regression detected; exit 2: bad input.
The user's *currently installed* original MOA package/signer must be checked
separately. R42 is the functional fallback reference, not device-data owner.
"""
import argparse
import hashlib
import struct
import sys
from pathlib import Path
from zipfile import ZipFile


def u16(b,p): return struct.unpack_from('<H',b,p)[0]
def u32(b,p): return struct.unpack_from('<I',b,p)[0]
def u64(b,p): return struct.unpack_from('<Q',b,p)[0]


def get_package(b):
    p=8
    strings=[]
    while p+8<=len(b):
        kind,head,size=struct.unpack_from('<HHI',b,p)
        if size<8 or p+size>len(b): raise ValueError('Malformed AndroidManifest.xml')
        if kind==1:
            count=u32(b,p+8);flags=u32(b,p+16);start=u32(b,p+20)
            strings=[]
            for i in range(count):
                q=p+start+u32(b,p+head+i*4)
                if flags & 0x100:
                    def ln(q):
                        t=b[q]
                        return (t,q+1) if t<128 else (((t&127)<<8)|b[q+1],q+2)
                    _,q=ln(q);count_utf8,q=ln(q)
                    strings.append(b[q:q+count_utf8].decode('utf-8'))
                else:
                    n=u16(b,q);q+=2
                    if n&0x8000:n=((n&0x7fff)<<16)|u16(b,q);q+=2
                    strings.append(b[q:q+n*2].decode('utf-16le'))
        if kind==0x102 and strings and strings[u32(b,p+20)]=='manifest':
            st,ss,n=struct.unpack_from('<HHH',b,p+24)
            for i in range(n):
                q=p+16+st+i*ss
                if strings[u32(b,q+4)]=='package':
                    raw=u32(b,q+8)
                    return strings[raw if raw!=0xffffffff else u32(b,q+16)]
        p+=size
    raise ValueError('Manifest package not found')


def get_cert_sha256(apk_bytes):
    b=apk_bytes;end=b.rfind(b'PK\x05\x06')
    if end<0:raise ValueError('ZIP EOCD missing')
    cd=u32(b,end+16)
    if b[cd-16:cd]!=b'APK Sig Block 42':raise ValueError('APK v2 signature block missing')
    start=cd-u64(b,cd-24)-8
    q=start+8
    if u32(b,q+8)!=0x7109871a:raise ValueError('APK v2 first ID differs')
    v2=b[q+12:q+8+u64(b,q)]
    def lp(s,p):
        n=u32(s,p)
        return s[p+4:p+4+n],p+4+n
    signers,_=lp(v2,0);signer,_=lp(signers,0)
    signed,_=lp(signer,0);_,pos=lp(signed,0)
    certs,_=lp(signed,pos);der,_=lp(certs,0)
    if len(der)<100:raise ValueError('Signing certificate truncated')
    return hashlib.sha256(der).hexdigest()


def examine(path):
    data=path.read_bytes()
    with ZipFile(path) as z:
        bad=z.testzip()
        if bad:raise ValueError('ZIP CRC failure: '+bad)
        j=z.read('assets/web/family-diary.js').decode('utf-8')
        a=z.read('assets/web/app.js')
        i=z.read('assets/web/index.html')
        manifest=z.read('AndroidManifest.xml')
    return dict(package=get_package(manifest),signer=get_cert_sha256(data),
                js=j,app=a,index=i,sha256=hashlib.sha256(data).hexdigest())


def main():
    p=argparse.ArgumentParser()
    p.add_argument('--baseline',required=True,type=Path)
    p.add_argument('--candidate',required=True,type=Path)
    p.add_argument('--allow-ui-change',action='store_true')
    a=p.parse_args()
    b=examine(a.baseline);c=examine(a.candidate)
    t=c['js']
    checks={
      'same_package':b['package']==c['package'],
      'same_signer':b['signer']==c['signer'],
      'diary_schema':all(x in t for x in ('familyjourney-diary-v1','curated','photoIds')),
      'return_capture_fallback':all(x in t for x in ('mmHandleIndex','mmFlush','mmPersist','[...nextPhotos,...nextVideos]')),
      'timeline_memo':'mmGroupNotes(entry,g,section)' in t,
      'user_on_off_still_available':'mmEnabled=!mmEnabled' in t,
      'R44_hard_disable_not_reintroduced':
        'mmEnabled=false;mmArmedAt=0; // R44' not in t and
        '모아 기록은 휴대폰 빠른 설정창에서 켜거나 끌 수 있습니다.' not in t,
    }
    if not a.allow_ui_change:
        checks['index_html_unchanged']=b['index']==c['index']
        checks['app_js_unchanged']=b['app']==c['app']
    print('BASELINE',a.baseline,b['sha256'])
    print('CANDIDATE',a.candidate,c['sha256'])
    print('PACKAGE',b['package'],'=>',c['package'])
    print('SIGNER',b['signer'],'=>',c['signer'])
    for key,ok in checks.items():print('PASS' if ok else 'FAIL',key)
    print('STATIC CHECKS ONLY — NOT APP INSTALL, GALAXY CAMERA OR DIARY SAVE PASS.')
    return 0 if all(checks.values()) else 1


if __name__=='__main__':
    try:sys.exit(main())
    except Exception as e:
        print('ERROR',type(e).__name__,str(e),file=sys.stderr)
        sys.exit(2)
