"""Add an app-private passive R653 diagnostic ContentProvider to R648 binary AndroidManifest.xml.
Retains all original nodes, attrs and values; only adds one provider sibling and two string entries.
"""
import struct
from pathlib import Path
import sys
sys.path.insert(0,'/mnt/data/moa_r651_native/build')
from axml_add_components import parse_strings

def u32(x):return struct.pack('<I',x)
def add_diag(original):
    assert struct.unpack_from('<HHI',original,0)==(3,8,len(original))
    pool=parse_strings(original); a=pool['strings']; extras=['com.juhyeon.familyjourney.MoaR653InlineOwnerDiagProvider','com.juhyeon.familyjournea.r653diag']
    assert all(x not in a for x in extras)
    positions=[];o=8;provider=None;app_close=None
    while o<len(original):
        t,h,z=struct.unpack_from('<HHI',original,o);b=original[o:o+z]
        if t==0x102:
            ns,name,ast,asz,num,_,_,_=struct.unpack_from('<IIHHHHHH',b,16)
            vals=[]
            for i in range(num):
                p=16+ast+asz*i
                ans,n,raw,vs,r0,kind,val=struct.unpack_from('<IIIHBBI',b,p)
                if a[n]=='name' and kind==3:vals.append(a[val])
            if a[name]=='provider' and 'com.juhyeon.familyjourney.MoaR507InlineGalleryProvider' in vals:provider=b
        if t==0x103 and a[struct.unpack_from('<I',b,20)[0]]=='application':app_close=o
        positions.append((o,t,b));o+=z
    assert provider is not None and app_close is not None
    data=bytearray(pool['data']);offsets=pool['offsets'][:]
    for s in extras:
        offsets.append(len(data));b=s.encode('utf-16le');data+=struct.pack('<H',len(b)//2)+b+b'\x00\x00'
    while len(data)%4:data.append(0)
    n=len(a)+len(extras);start=28+4*n
    pooled=struct.pack('<HHI',1,28,start+len(data))+struct.pack('<IIIII',n,0,0,start,0)+b''.join(map(u32,offsets))+data
    p=bytearray(provider)
    ns,name,ast,asz,num,_,_,_=struct.unpack_from('<IIHHHHHH',p,16)
    for i in range(num):
        at=16+ast+asz*i
        an=struct.unpack_from('<I',p,at+4)[0]
        valindex=len(a) if a[an]=='name' else len(a)+1 if a[an]=='authorities' else None
        if valindex is not None:
            assert p[at+15]==3
            struct.pack_into('<I',p,at+8,valindex);struct.pack_into('<I',p,at+16,valindex)
    close=struct.pack('<HHIIIII',0x103,16,24,0xffffffff,0xffffffff,0xffffffff,a.index('provider'))
    chunks=[]
    for off,t,b in positions:
        if off==app_close: chunks.extend((p,close))
        chunks.append(pooled if t==1 else b)
    result=struct.pack('<HHI',3,8,8+sum(len(b) for b in chunks))+b''.join(chunks)
    assert len(result)==struct.unpack_from('<I',result,4)[0]
    orig_nodes=[t for _,t,_ in positions]
    out_nodes=[];o=8
    while o<len(result):
        t,h,z=struct.unpack_from('<HHI',result,o);out_nodes.append(t);o+=z
    assert len(out_nodes)==len(orig_nodes)+2
    assert out_nodes.count(0x102)==orig_nodes.count(0x102)+1
    return result

if __name__=='__main__':
    src=Path(sys.argv[1]);out=Path(sys.argv[2]);result=add_diag(src.read_bytes());out.write_bytes(result);print('DIAG_MANIFEST',len(src.read_bytes()),len(result))