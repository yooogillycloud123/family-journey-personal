#!/usr/bin/env python3
"""Locally create original-R39-signed R709 preview and exact R707 R710 rescue.

Requires an original user-private PKCS12 and password via stdin; never stores
the key/password or ships it to CI/GitHub.  Protected APK records are copied
without recompression.  No on-device or installer claims are made here.
"""
from __future__ import annotations

import argparse
import hashlib
import json
import struct
import sys
import zipfile
import zlib
from pathlib import Path

from cryptography.hazmat.primitives import hashes, serialization
from cryptography.hazmat.primitives.asymmetric import padding
from cryptography.hazmat.primitives.serialization import pkcs12

EXPECTED_GOLDEN = "b72856150410491b87cd01c3ecbe1a3178e2d1a6488fdf4494d06afcf50fb200"
EXPECTED_CERT = "5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15"
PROVIDER_CLASS = "com.juhyeon.familyjourney.MoaR709PreviewProvider"
PROVIDER_AUTHORITY = "com.juhyeon.familyjournea.moa_r709_preview"
ANDROID_NS = "http://schemas.android.com/apk/res/android"
V2_ID = 0x7109871A
V2_ALG = 0x0103
SIG_MAGIC = b"APK Sig Block 42"

def u16(blob, p): return struct.unpack_from("<H", blob, p)[0]
def u32(blob, p): return struct.unpack_from("<I", blob, p)[0]
def u64(blob, p): return struct.unpack_from("<Q", blob, p)[0]
def p32(blob, p, value): struct.pack_into("<I", blob, p, value)
def lp(payload): return struct.pack("<I", len(payload)) + payload

def decode_pool(blob, start=8):
    assert u16(blob,start)==1 and u16(blob,start+2)==28
    assert u32(blob,start+12)==0, "Styled manifest pool unsupported"
    count=u32(blob,start+8)
    flags=u32(blob,start+16)
    assert flags==0, "Expected R707 UTF16 manifest string pool"
    data=start+u32(blob,start+20)
    out=[]
    for i in range(count):
        offset=data+u32(blob,start+28+i*4)
        n=u16(blob,offset)
        assert n<0x8000
        out.append(blob[offset+2:offset+2+2*n].decode("utf-16-le"))
    return out

def patch_manifest_version(blob, code):
    b=bytearray(blob)
    strings=decode_pool(b)
    pos=8
    while pos<len(b):
        kind,head,size=struct.unpack_from("<HHI",b,pos)
        if kind==0x0102:
            ext=pos+head
            name=strings[u32(b,ext+4)]
            if name=="manifest":
                first,stride,count=struct.unpack_from("<HHH",b,ext+8)
                for i in range(count):
                    at=ext+first+i*stride
                    index=u32(b,at+4)
                    if strings[index]=="versionCode":
                        assert b[at+15]==0x10
                        p32(b,at+16,code)
                        return bytes(b)
        pos+=size
    raise ValueError("R707 manifest versionCode not found")

def utf16_element(value):
    encoded=value.encode("utf-16-le")
    assert len(encoded)//2<0x8000
    return struct.pack("<H",len(encoded)//2)+encoded+b"\x00\x00"

def append_strings(blob, new_strings):
    assert u16(blob,8)==1
    old_size=u32(blob,12)
    old_count=u32(blob,16)
    old_start=u32(blob,28)
    assert old_start==28+old_count*4
    assert u32(blob,20)==0 and u32(blob,24)==0
    old_data=blob[8+old_start:8+old_size]
    new_offsets=[]
    new_data=bytearray(old_data)
    for s in new_strings:
        new_offsets.append(len(new_data))
        new_data.extend(utf16_element(s))
    while len(new_data)%4:new_data.append(0)
    out=bytearray(blob[8:8+28]);
    p32(out,4,28+4*(old_count+len(new_strings))+len(new_data))
    p32(out,8,old_count+len(new_strings))
    p32(out,20,28+4*(old_count+len(new_strings)))
    out.extend(blob[8+28:8+old_start])
    for offset in new_offsets:out.extend(struct.pack("<I",offset))
    out.extend(new_data)
    return bytes(out),old_count

def add_provider(blob):
    pool=decode_pool(blob)
    provider_template=None
    provider_end=None
    app_end=None
    pos=8
    while pos<len(blob):
        kind,head,size=struct.unpack_from("<HHI",blob,pos)
        if kind in (0x0102,0x0103):
            name=pool[u32(blob,pos+head+4)]
            if kind==0x0102 and name=="provider":
                provider_template=bytearray(blob[pos:pos+size])
            if kind==0x0103 and name=="provider":
                provider_end=bytes(blob[pos:pos+size])
            if kind==0x0103 and name=="application":app_end=pos
        pos+=size
    assert provider_template is not None and provider_end is not None and app_end is not None
    # Reuse existing boolean exported=false, and only change the name/authority.
    header=u16(provider_template,2)
    ext=header
    start,stride,count=struct.unpack_from("<HHH",provider_template,ext+8)
    values={"name":PROVIDER_CLASS,"authorities":PROVIDER_AUTHORITY}
    new_pool,idx=append_strings(blob,[PROVIDER_CLASS,PROVIDER_AUTHORITY])
    assert count==3
    touched=[]
    for i in range(count):
        at=ext+start+i*stride
        name=pool[u32(provider_template,at+4)]
        if name not in values:continue
        target=idx+(0 if name=="name" else 1)
        assert provider_template[at+15]==0x03
        if u32(provider_template,at+8)!=0xffffffff:p32(provider_template,at+8,target)
        p32(provider_template,at+16,target)
        touched.append(name)
    assert set(touched)=={"name","authorities"}
    add=bytes(provider_template)+provider_end
    old_pool_end=8+u32(blob,12)
    prefix=new_pool
    tail=blob[old_pool_end:]
    insertion=app_end-old_pool_end
    result=bytearray(blob[:8]+prefix+tail[:insertion]+add+tail[insertion:])
    p32(result,4,len(result))
    assert PROVIDER_CLASS in decode_pool(result)
    return bytes(result)

def get_signing_block_start(binary,cd_start):
    assert binary[cd_start-16:cd_start]==SIG_MAGIC
    size=u64(binary,cd_start-24)
    begin=cd_start-size-8
    assert begin>0 and u64(binary,begin)==size
    return begin

def compress_deflate(payload):
    c=zlib.compressobj(level=6,wbits=-15)
    return c.compress(payload)+c.flush()

def local_manifest_record(original_rec,new_blob):
    assert original_rec[:4]==b"PK\x03\x04"
    old=bytearray(original_rec)
    fnlen,elen=struct.unpack_from("<HH",old,26)
    names=bytes(old[30:30+fnlen]);extra=bytes(old[30+fnlen:30+fnlen+elen])
    assert names==b"AndroidManifest.xml"
    assert u16(old,8)==8 and not u16(old,6)&8
    compressed=compress_deflate(new_blob)
    crc=zlib.crc32(new_blob)&0xffffffff
    delta=len(compressed)-u32(old,18)
    # Local extra exists only to keep downstream original STORED records
    # 4-byte aligned, rather than rewriting any protected compressed bytes.
    addpad=(-delta)%4
    padding=struct.pack("<HH",0,addpad)+bytes(addpad)
    assert (delta+len(padding))%4==0
    hdr=old[:30]
    p32(hdr,14,crc);p32(hdr,18,len(compressed));p32(hdr,22,len(new_blob))
    struct.pack_into("<H",hdr,28,len(extra)+len(padding))
    return bytes(hdr)+names+extra+padding+compressed,(crc,len(compressed),len(new_blob))

def new_dex_local(dex, offset, template_local):
    name=b"classes20.dex"
    assert template_local[:4]==b"PK\x03\x04"
    crc=zlib.crc32(dex)&0xffffffff
    tm,dt=struct.unpack_from("<HH",template_local,10)
    pad=(-offset-30-len(name)-4)%4
    extra=struct.pack("<HH",0,pad)+bytes(pad)
    header=struct.pack("<IHHHHHIIIHH",0x04034b50,20,0,0,tm,dt,crc,len(dex),len(dex),len(name),len(extra))
    assert (offset+len(header)+len(name)+len(extra))%4==0
    return header+name+extra+dex,(crc,len(dex),len(dex))

def central_records(binary,start,end):
    pos=start;result=[]
    while pos<end:
        assert binary[pos:pos+4]==b"PK\x01\x02",(pos,end)
        n,e,c=struct.unpack_from("<HHH",binary,pos+28)
        total=46+n+e+c
        rec=bytearray(binary[pos:pos+total]);name=rec[46:46+n].decode("utf-8")
        result.append((name,rec));pos+=total
    assert pos==end
    return result

def original_zip_without_sig(apk,new_manifest,add_dex=None):
    with zipfile.ZipFile(__import__('io').BytesIO(apk)) as z:
        assert z.testzip() is None and len(z.infolist())==167
        infos=z.infolist()
        assert [i.header_offset for i in infos]==sorted(i.header_offset for i in infos)
        cd=z.start_dir
        eocd=apk.rfind(b"PK\x05\x06")
        assert eocd>cd
        old_sig=get_signing_block_start(apk,cd)
        records=central_records(apk,cd,eocd)
        assert [name for name,_ in records]==[i.filename for i in infos]
        assert len(records)==167
        all_local=bytearray(apk[:infos[0].header_offset]);offsets={}
        manifest_info=None
        template_local=None
        for i,info in enumerate(infos):
            old_end=infos[i+1].header_offset if i+1<len(infos) else old_sig
            rec=apk[info.header_offset:old_end]
            offsets[info.filename]=len(all_local)
            if info.filename=="AndroidManifest.xml":
                local,manifest_info=local_manifest_record(rec,new_manifest)
            else:
                local=rec
            if info.filename=="classes19.dex":template_local=rec
            all_local.extend(local)
        assert template_local is not None and manifest_info is not None
        dex_info=None
        if add_dex is not None:
            offsets["classes20.dex"]=len(all_local)
            local,dex_info=new_dex_local(add_dex,len(all_local),template_local)
            all_local.extend(local)
        central=bytearray()
        template_central=None
        for name,entry in records:
            if name=="AndroidManifest.xml":
                p32(entry,16,manifest_info[0]);p32(entry,20,manifest_info[1]);p32(entry,24,manifest_info[2])
            p32(entry,42,offsets[name]);central.extend(entry)
            if name=="classes19.dex":template_central=entry
        if add_dex is not None:
            assert template_central is not None and dex_info is not None
            extra=bytearray(template_central)
            namelen=u16(extra,28);assert namelen==len("classes19.dex")
            extra[46:46+namelen]=b"classes20.dex"
            p32(extra,16,dex_info[0]);p32(extra,20,dex_info[1]);p32(extra,24,dex_info[2]);p32(extra,42,offsets["classes20.dex"])
            central.extend(extra)
        eocd_bytes=bytearray(apk[eocd:]);assert len(eocd_bytes)>=22
        entries=len(records)+(add_dex is not None)
        struct.pack_into("<HH",eocd_bytes,8,entries,entries)
        p32(eocd_bytes,12,len(central))
        return bytes(all_local),bytes(central),bytes(eocd_bytes),offsets

def apk_v2_digest(local,cd,eocd):
    out=[]
    for item in (local,cd,eocd):
        for i in range(0,len(item),1024*1024):
            chunk=item[i:i+1024*1024]
            out.append(hashlib.sha256(b"\xa5"+struct.pack("<I",len(chunk))+chunk).digest())
    return hashlib.sha256(b"\x5a"+struct.pack("<I",len(out))+b"".join(out)).digest()

def apk_v2_sign(local,cd,eocd,key,cert):
    to_digest=bytearray(eocd);p32(to_digest,16,len(local))
    digest=apk_v2_digest(local,cd,bytes(to_digest))
    certificate=cert.public_bytes(serialization.Encoding.DER)
    sd=lp(lp(struct.pack("<I",V2_ALG)+lp(digest)))+lp(lp(certificate))+lp(b"")
    signature=key.sign(sd,padding.PKCS1v15(),hashes.SHA256())
    pub=cert.public_key().public_bytes(serialization.Encoding.DER,serialization.PublicFormat.SubjectPublicKeyInfo)
    one_signer=lp(sd)+lp(lp(struct.pack("<I",V2_ALG)+lp(signature)))+lp(pub)
    value=lp(lp(one_signer))
    pair=struct.pack("<QI",len(value)+4,V2_ID)+value
    size=len(pair)+24
    block=struct.pack("<Q",size)+pair+struct.pack("<Q",size)+SIG_MAGIC
    final_eocd=bytearray(eocd);p32(final_eocd,16,len(local)+len(block))
    return local+block+cd+bytes(final_eocd)

def main():
    parser=argparse.ArgumentParser()
    parser.add_argument("--golden",type=Path,required=True)
    parser.add_argument("--private-zip",type=Path,required=True)
    parser.add_argument("--dex20",type=Path,required=True)
    parser.add_argument("--output",type=Path,required=True)
    a=parser.parse_args()
    original=a.golden.read_bytes()
    assert hashlib.sha256(original).hexdigest()==EXPECTED_GOLDEN,"immutable R707 baseline SHA mismatch"
    raw_password=sys.stdin.buffer.readline().strip()
    assert raw_password,"No private PKCS12 password given on stdin"
    with zipfile.ZipFile(a.private_zip) as signer_zip:
        raw_p12=signer_zip.read(next(n for n in signer_zip.namelist() if n.lower().endswith(".p12")))
    key,cert,_=pkcs12.load_key_and_certificates(raw_p12,raw_password)
    assert key is not None and cert is not None
    assert hashlib.sha256(cert.public_bytes(serialization.Encoding.DER)).hexdigest()==EXPECTED_CERT
    del raw_password
    with zipfile.ZipFile(__import__('io').BytesIO(original)) as z:original_manifest=z.read("AndroidManifest.xml")
    assert len(original_manifest)>10000
    dex=a.dex20.read_bytes()
    assert dex[:4]==b"dex\n" and len(dex)>1000
    new709=patch_manifest_version(add_provider(original_manifest),709)
    new710=patch_manifest_version(original_manifest,710)
    a.output.mkdir(parents=True,exist_ok=True)
    files={
      709:("MOA_R709_EXACT_MEDIA_PREVIEW_ORIGINAL_SIGNED_BETA.apk",new709,dex),
      710:("MOA_R710_EXACT_R707_FUNCTIONAL_FORWARD_RECOVERY_ORIGINAL_SIGNED.apk",new710,None)
    }
    report={"source_r707":EXPECTED_GOLDEN,"signer_sha256":EXPECTED_CERT,"releases":{}}
    for code,(name,manifest,addon) in files.items():
        local,cd,eocd,_=original_zip_without_sig(original,manifest,addon)
        result=apk_v2_sign(local,cd,eocd,key,cert)
        target=a.output/name
        target.write_bytes(result)
        with zipfile.ZipFile(target) as z:
            assert z.testzip() is None
            expected=168 if code==709 else 167
            assert len(z.namelist())==expected
            assert z.read("AndroidManifest.xml")==manifest
            if addon is not None:assert z.read("classes20.dex")==addon
            with zipfile.ZipFile(__import__('io').BytesIO(original)) as gold:
                diff=[n for n in gold.namelist() if z.read(n)!=gold.read(n)]
                assert diff==["AndroidManifest.xml"],diff
        report["releases"][str(code)]={
          "file":name,"sha256":hashlib.sha256(result).hexdigest(),"bytes":len(result),
          "members":expected,"changed_existing_members":["AndroidManifest.xml"],
          "added_members":["classes20.dex"] if code==709 else [],
          "device_install":"NOT_TESTED"
        }
    (a.output/"MOA_R709_R710_SHA256_REPORT.json").write_text(json.dumps(report,indent=2,ensure_ascii=False)+"\n")
    for code,entry in report["releases"].items():
        print("BUILT",code,entry["file"],entry["sha256"],entry["bytes"],"BYTES")

if __name__=="__main__":main()
