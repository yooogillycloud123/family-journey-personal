#!/usr/bin/env python3
from pathlib import Path
import sys,zipfile,copy,struct,json
old=Path('experiments/moa-r783/prepare-unsigned.py').read_text().split('root=Path(sys.argv[1])')[0]
exec(compile(old,'old-prepare','exec'))
def manifest(data):
 b=bytearray(patch_manifest(data,787,789));p=8;chunks=[];names=[];ids=[];poolidx=-1
 while p<len(b):
  typ,hs,size=struct.unpack_from('<HHI',b,p);assert hs>=8 and size>=hs and p+size<=len(b)
  x=bytes(b[p:p+size]);chunks.append((typ,hs,x))
  if typ==1:
   poolidx=len(chunks)-1;count,styles,flags,start,st=struct.unpack_from('<IIIII',x,8)
   assert hs==28 and styles==0 and flags==0 and st==0
   offsets=[u32(x,hs+i*4) for i in range(count)];raw=bytearray(x[start:])
   for off in offsets:
    n=u16(raw,off);assert n<32768;names.append(bytes(raw[off+2:off+2+2*n]).decode('utf-16le'))
  elif typ==0x180:ids=[u32(x,i) for i in range(hs,size,4)]
  p+=size
 assert p==len(b) and poolidx>=0
 def index(s):
  if s in names:return names.index(s)
  names.append(s);offsets.append(len(raw));a=s.encode('utf-16le');raw.extend(struct.pack('<H',len(a)//2)+a+b'\0\0');return len(names)-1
 ns=index('http://schemas.android.com/apk/res/android');name=ids.index(0x01010003);ft=ids.index(0x01010599)
 assert names[name]=='name' and names[ft]=='foregroundServiceType'
 def permission(s):
  tag=index('uses-permission');v=index(s);a=struct.pack('<IIIHBBI',ns,name,v,8,0,3,v)
  return struct.pack('<HHIII',0x102,16,56,1,0xffffffff)+struct.pack('<IIHHHHHH',0xffffffff,tag,20,20,1,0,0,0)+a+struct.pack('<HHIIIII',0x103,16,24,1,0xffffffff,0xffffffff,tag)
 addWake='android.permission.WAKE_LOCK' not in names
 permit=permission('android.permission.WAKE_LOCK') if addWake else b''
 raw.extend(b'\0'*((-len(raw))%4));start=28+4*len(offsets)
 newpool=struct.pack('<HHIIIIII',1,28,start+len(raw),len(offsets),0,0,start,0)+b''.join(struct.pack('<I',x) for x in offsets)+raw
 result=[];changes=0
 for i,(typ,hs,x) in enumerate(chunks):
  if i==poolidx:result.append(newpool);continue
  if typ==0x102:
   tag=names[u32(x,hs+4)]
   if tag=='application' and permit:result.append(permit)
   if tag=='service':
    ext=hs;ast,asz,ac=struct.unpack_from('<HHH',x,ext+8);assert asz==20
    attrs=[x[ext+ast+j*asz:ext+ast+(j+1)*asz] for j in range(ac)]
    target=any(u32(a,4)==name and a[15]==3 and names[u32(a,16)]=='com.juhyeon.familyjournea.ai.MoaStudyJob785' for a in attrs)
    if target:
     assert all(u32(a,4)!=ft for a in attrs)
     attrs.append(struct.pack('<IIIHBBI',ns,ft,0xffffffff,8,0,0x11,1));attrs.sort(key=lambda a:ids[u32(a,4)])
     y=bytearray(x[:ext+ast]);struct.pack_into('<I',y,4,len(x)+20);struct.pack_into('<H',y,ext+12,ac+1);x=bytes(y)+b''.join(attrs);changes+=1
  result.append(x)
 assert changes==1
 return struct.pack('<HHI',3,8,8+sum(map(len,result)))+b''.join(result)
r=Path(sys.argv[1]);base=r/'moa-r787.apk';pin='2b64ceac823bcb4ea587fc4482b2c0600670d697bbf33b88011059fafe089c91'
assert sha(base)==pin
changes={'assets/web/'+n:r/'web'/n for n in ('moa-r755-inline-ai.js','moa-r117-ui.js')}
changes['classes27.dex']=r/'dex/classes.dex'
out=r/'r789-unaligned.apk'
with zipfile.ZipFile(base) as z,zipfile.ZipFile(out,'w') as w:
 assert z.testzip() is None and set(changes)<=set(z.namelist())
 for info in z.infolist():
  data=z.read(info)
  if info.filename=='AndroidManifest.xml':data=manifest(data)
  elif info.filename in changes:data=changes[info.filename].read_bytes()
  zi=copy.copy(info);zi.extra=b'';w.writestr(zi,data)
with zipfile.ZipFile(base) as z,zipfile.ZipFile(out) as w:
 assert w.testzip() is None and z.namelist()==w.namelist()
 diff={n for n in z.namelist() if z.read(n)!=w.read(n)}
 assert diff==set(changes)|{'AndroidManifest.xml'},diff
 print(json.dumps({'version':789,'same':len(z.namelist())-len(diff),'changed':sorted(diff),'unsigned':True}))
prepare(base,r/'r790-unaligned.apk',787,790,{},pin)
