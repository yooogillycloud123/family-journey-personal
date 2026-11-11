#!/usr/bin/env python3
"""Byte-level guard for the user-accepted immutable MOA R345 Golden.
Use with a local copy of the original signed R345 APK. Never upload signing
keys, personal media or an authenticated NAVER profile to a public repo.
"""
import argparse
import hashlib
import json
import sys
from pathlib import Path
from zipfile import ZipFile

GOLDEN_SHA="fe2aaaac15d39a610268ee3d10361652a95537e0ce8ec9cde86e98edf3f8ceb1"
PROTECTED={
    "assets/web/fj-naver-favorites.js",
    "assets/web/moa-r231-naver-frame-probe.js",
    "assets/web/family-diary.js",
    "assets/web/moa-r231-settings.js",
}

def sha(buf):
    return hashlib.sha256(buf).hexdigest()

def check(golden, candidate, mode):
    if sha(golden.read_bytes()) != GOLDEN_SHA:
        raise ValueError("Not the immutable R345 Golden APK")
    with ZipFile(golden) as g, ZipFile(candidate) as c:
        if g.testzip() is not None or c.testzip() is not None:
            raise ValueError("Corrupted archive member/CRC")
        gs=set(g.namelist())
        cs=set(c.namelist())
        changed=sorted(x for x in gs|cs if x not in gs or x not in cs or g.read(x)!=c.read(x))
        protected=sorted(x for x in gs if x.endswith(".dex") or x in PROTECTED)
        protected_changed=sorted(set(changed)&set(protected))
        invalid=sorted(x for x in changed if x!="AndroidManifest.xml") if mode=="golden-restore" else protected_changed
        return {
            "candidate":candidate.name, "mode":mode, "changed":changed,
            "protected_changed":protected_changed, "unexpected":invalid,
            "pass":not invalid
        }

if __name__=="__main__":
    p=argparse.ArgumentParser(description=__doc__)
    p.add_argument("golden",type=Path)
    p.add_argument("candidate",type=Path)
    p.add_argument("--mode",choices=["safe-additive","golden-restore"],default="safe-additive")
    args=p.parse_args()
    try:
        result=check(args.golden,args.candidate,args.mode)
    except Exception as e:
        print(json.dumps({"pass":False,"error":str(e)}));sys.exit(2)
    print(json.dumps(result,ensure_ascii=False,indent=2))
    sys.exit(0 if result["pass"] else 1)
