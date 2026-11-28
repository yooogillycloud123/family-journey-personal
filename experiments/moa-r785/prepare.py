#!/usr/bin/env python3
import hashlib,pathlib,struct,sys,zipfile,json,copy
from pathlib import Path
old=Path('experiments/moa-r783/prepare-unsigned.py').read_text().split('root=Path(sys.argv[1])')[0]
exec(compile(old,'old-prepare','exec'))
def add_scheduler(data):
 b=bytearray(patch_manifest(data,783,785));p=8;chunks=[];names=[];ids=[];poolidx=-1
 while p<len(b):
  typ,hs,size=struct.unpack_from('<HHI',b,p)
  assert hs>=8 and size>=hs and p+size<=len(b)
  x=bytes(b[p:p+size]);chunks.append((typ,hs,x))
  if typ==1:
   poolidx=len(chunks)-1
   count,styles,flags,start,st=struct.unpack_from('<IIIII',x,8)
   assert hs==28 and styles==0 and flags==0 and st==0
   offsets=[u32(x,hs+i*4) for i in range(count)]
   raw=bytearray(x[start:])
   for off in offsets:
    n=u16(raw,off);assert n<32768
    names.append(bytes(raw[off+2:off+2+2*n]).decode('utf-16le'))
  elif typ==0x180:ids=[u32(x,i) for i in range(hs,size,4)]
  p+=size
 assert p==len(b) and poolidx>=0
 def index(s):
  if s in names:return names.index(s)
  names.append(s);offsets.append(len(raw));a=s.encode('utf-16le');raw.extend(struct.pack('<H',len(a)//2)+a+b'\0\0');return len(names)-1
 ns=index('http://schemas.android.com/apk/res/android')
 name=ids.index(0x01010003);permission=ids.index(0x01010006);exported=ids.index(0x01010010)
 assert [names[i] for i in (name,permission,exported)]==['name','permission','exported']
 def nodes(tag,attrs):
  tag=index(tag);aa=[]
  for attr,val in sorted(attrs,key=lambda a:ids[a[0]]):
   if isinstance(val,bool):rawval=0xffffffff;typ=0x12;v=0xffffffff if val else 0
   else:rawval=index(val);typ=3;v=rawval
   aa.append(struct.pack('<IIIHBBI',ns,attr,rawval,8,0,typ,v))
  return (struct.pack('<HHIII',0x102,16,36+20*len(aa),1,0xffffffff)+struct.pack('<IIHHHHHH',0xffffffff,tag,20,20,len(aa),0,0,0)+b''.join(aa)+struct.pack('<HHIIIII',0x103,16,24,1,0xffffffff,0xffffffff,tag))
 permit=nodes('uses-permission',[(name,'android.permission.RECEIVE_BOOT_COMPLETED')])
 service=nodes('service',[(name,'com.juhyeon.familyjournea.ai.MoaStudyJob785'),(permission,'android.permission.BIND_JOB_SERVICE'),(exported,False)])
 raw.extend(b'\0'*((-len(raw))%4));start=28+4*len(offsets)
 newpool=struct.pack('<HHIIIIII',1,28,start+len(raw),len(offsets),0,0,start,0)+b''.join(struct.pack('<I',x) for x in offsets)+raw
 result=[];pc=sc=0
 for i,(typ,hs,x) in enumerate(chunks):
  if i==poolidx:result.append(newpool);continue
  if typ in (0x102,0x103):
   tag=names[u32(x,hs+4)]
   if typ==0x102 and tag=='application':result.append(permit);pc+=1
   if typ==0x103 and tag=='application':result.append(service);sc+=1
  result.append(x)
 assert pc==sc==1
 return struct.pack('<HHI',3,8,8+sum(map(len,result)))+b''.join(result)
root=Path(sys.argv[1]);web=root/'web';kit=root/'kit'
base=root/'moa-r783.apk';pin='a355ec1cf7dbce64ccef0775f78fc9aa5efe23f9034aacf18ea450635e678529'
assert sha(base)==pin
changes={'assets/web/family-diary.js':web/'family-diary.js','assets/web/moa-r755-inline-ai.js':web/'moa-r755-inline-ai.js','classes27.dex':root/'dex/classes.dex'}
extra='assets/web/moa-r785-worker.html'
out=root/'r785-unaligned.apk'
with zipfile.ZipFile(base) as z,zipfile.ZipFile(out,'w') as w:
 assert z.testzip() is None and extra not in z.namelist() and set(changes)<=set(z.namelist())
 for info in z.infolist():
  data=z.read(info)
  if info.filename=='AndroidManifest.xml':data=add_scheduler(data)
  elif info.filename in changes:data=changes[info.filename].read_bytes()
  zi=copy.copy(info);zi.extra=b'';w.writestr(zi,data)
 w.writestr(extra,Path('experiments/moa-r785/moa-r785-worker.html').read_bytes(),compress_type=zipfile.ZIP_DEFLATED)
with zipfile.ZipFile(base) as z,zipfile.ZipFile(out) as w:
 assert w.testzip() is None and set(w.namelist())==set(z.namelist())|{extra}
 diff={n for n in z.namelist() if z.read(n)!=w.read(n)}
 assert diff==set(changes)|{'AndroidManifest.xml'},diff
 print(json.dumps({'version':785,'same':len(z.namelist())-len(diff),'changed':sorted(diff),'added':[extra],'unsigned':True}))
prepare(base,root/'r786-unaligned.apk',783,786,{},pin)
