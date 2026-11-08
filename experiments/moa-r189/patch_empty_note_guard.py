#!/usr/bin/env python3
"""MOA R189 no-text capture commit patch (NO KEY; NO PRIVATE MEDIA).
Input: exact user-owned signed R187 Golden APK extracted locally from private Library.
Output: classes7.dex patch payload; must be placed into newly signed APK along with
AndroidManifest.xml versionCode 189. Never repack/save the Golden in place.
"""
from pathlib import Path
import hashlib, zipfile, struct, zlib, json, sys

GOLDEN_SHA="4380ca0a421c3a12cfad0334e860e659112b116f6cc7099f8989475c646a97e9"
OLD_DEX_SHA="a48bc1728c8af8bf89e4682bab7195fd907b516f99dc572fcc87d739faaa4781"
NEW_DEX_SHA="65706f01ab0848ba36e806819ce546f6f50258173806fc4829c3f3057da3869c"
def patch(apk:Path,out:Path):
    assert hashlib.sha256(apk.read_bytes()).hexdigest()==GOLDEN_SHA,"wrong base Golden"
    with zipfile.ZipFile(apk) as z:
        assert z.testzip() is None and len(z.namelist())==128
        old=z.read("classes7.dex")
    assert hashlib.sha256(old).hexdigest()==OLD_DEX_SHA
    # Verified class: Lcom/juhyeon/familyjourney/MoaMomentMemoRecorderActivity;
    # Verified method: saveNote()V, code item at 15664, instructions at 15680.
    code_off=15664
    registers,ins,outs,tries,dbg,count=struct.unpack_from("<HHHHII",old,code_off)
    assert (registers,ins,outs,count)==(13,2,4,263)
    i=code_off+16+73*2
    assert old[i:i+4]==struct.pack("<HH",0x0738,0x000e)
    # if-eqz v7,+14 currently skips an empty-note toast only for NONEMPTY notes.
    # goto/16 +14 always reaches the preexisting persist/memoSaved=true path.
    patched=bytearray(old)
    struct.pack_into("<HH",patched,i,0x0029,0x000e)
    before="모아 일기에 메모 저장".encode()
    after="모아 일기에 기록 저장".encode()
    assert len(before)==len(after) and old.count(before)==1
    j=old.index(before);patched[j:j+len(before)]=after
    patched[12:32]=hashlib.sha1(patched[32:]).digest()
    struct.pack_into("<I",patched,8,zlib.adler32(patched[12:])&0xffffffff)
    allowed=set(range(8,32))|set(range(i,i+4))|set(range(j,j+len(before)))
    changed={k for k,(a,b) in enumerate(zip(old,patched)) if a!=b}
    assert len(patched)==len(old) and changed<=allowed
    assert hashlib.sha256(patched).hexdigest()==NEW_DEX_SHA
    assert hashlib.sha1(patched[32:]).digest()==patched[12:32]
    assert zlib.adler32(patched[12:])&0xffffffff==struct.unpack_from("<I",patched,8)[0]
    out.parent.mkdir(parents=True,exist_ok=True);out.write_bytes(patched)
    print(json.dumps({"dex_sha256":NEW_DEX_SHA,"bytes":len(patched),
                      "saveNote_guard":"bypassed only with existing capture",
                      "requires_new_signing":True},ensure_ascii=False))
if __name__=="__main__":
    if len(sys.argv)!=3:raise SystemExit("Usage: patch.py <PRIVATE_R187_GOLDEN_APK> <OUTPUT_CLASSES7_DEX>")
    patch(Path(sys.argv[1]),Path(sys.argv[2]))
