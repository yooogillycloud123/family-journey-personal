#!/usr/bin/env python3
"""Offline signing of the two exact R783/R784 payloads. Never uploads key or APK."""
from pathlib import Path
import argparse, getpass, hashlib, os, re, subprocess, sys, zipfile
root=Path(__file__).resolve().parent
cert="5a86862beacac780a83729f3c01584d6d0ea5be88cf51827cb0b257d9caa0f15"
def digest(p):
    return hashlib.sha256(p.read_bytes()).hexdigest()
def require(ok,msg):
    if not ok: raise RuntimeError(msg)
def payloads(p):
    with zipfile.ZipFile(p) as z:
        require(z.testzip() is None,"ZIP integrity failed")
        return {n:hashlib.sha256(z.read(n)).hexdigest() for n in z.namelist()}
def run(cmd,env=None):
    return subprocess.run(cmd,env=env,check=True,text=True,stdout=subprocess.PIPE,stderr=subprocess.PIPE).stdout
def main():
    p=argparse.ArgumentParser()
    p.add_argument("--check-only",action="store_true")
    p.add_argument("--keystore",type=Path)
    p.add_argument("--alias")
    p.add_argument("--java",default="java")
    a=p.parse_args()
    sums={}
    for line in (root/"SHA256SUMS.txt").read_text().splitlines():
        h,n=line.split(maxsplit=1);sums[n.strip().lstrip("*")]=h
    inputs=[root/f"MOA_R{v}_UNSIGNED_DO_NOT_INSTALL.apk" for v in (783,784)]
    for f in inputs:
        require(digest(f)==sums.get(f.name),"Unsigned input SHA mismatch: "+f.name)
        require(len(payloads(f))==184,"Unexpected APK entry count")
    jar=root/"apksigner.jar"
    require(digest(jar)==sums.get(jar.name),"SDK apksigner checksum mismatch")
    cmd=[a.java,"-jar",str(jar)]
    run(cmd+["version"])
    print("Verified exact bundle inputs; original key not needed for check-only.")
    if a.check_only:return
    require(a.keystore and a.keystore.is_file(),"Provide existing original PKCS12 with --keystore (never upload it)")
    secret=getpass.getpass("Original keystore password (hidden): ")
    env=os.environ.copy();env["MOA_LOCAL_KS_PASS"]=secret
    keyargs=["--ks",str(a.keystore.resolve()),"--ks-type","PKCS12","--ks-pass","env:MOA_LOCAL_KS_PASS","--key-pass","env:MOA_LOCAL_KS_PASS"]
    if a.alias:keyargs+=["--ks-key-alias",a.alias]
    output=root/"signed"
    output.mkdir(exist_ok=True)
    temps=[]
    try:
        for v,inp in zip((783,784),inputs):
            target=output/f"MOA_R{v}_ORIGINAL_SIGNED.apk"
            tmp=output/f".R{v}.verify-pending.apk";temps.append(tmp)
            require(not target.exists(),"Existing output will not be overwritten: "+target.name)
            run(cmd+["sign"]+keyargs+["--v1-signing-enabled","false","--v2-signing-enabled","true","--v3-signing-enabled","false","--v4-signing-enabled","false","--out",str(tmp),str(inp)],env)
            out=run(cmd+["verify","--verbose","--print-certs",str(tmp)])
            require(re.search(r"Verified using v2 scheme.*:\s*true",out,re.I),"APK v2 verification failed")
            found=re.findall(r"certificate SHA-256 digest:\s*([a-fA-F0-9]+)",out)
            require(len(found)==1 and found[0].lower()==cert,"Original certificate mismatch; no output published")
            require(payloads(tmp)==payloads(inp),"Signing changed APK payload")
        for v,tmp in zip((783,784),temps):
            dest=output/f"MOA_R{v}_ORIGINAL_SIGNED.apk"
            tmp.replace(dest)
            print(dest.name,dest.stat().st_size,digest(dest))
        print("Original signer and v2 verified. No publication performed. R784 emergency only.")
    finally:
        env.pop("MOA_LOCAL_KS_PASS",None)
        for tmp in temps:
            if tmp.exists():tmp.unlink()
if __name__=="__main__":
    try:main()
    except Exception as e:
        # Never echo signing command, subprocess stderr, key password or other private material.
        print("Signing stopped:",str(e) if not isinstance(e,subprocess.CalledProcessError) else "SDK command failed",file=sys.stderr)
        sys.exit(1)
