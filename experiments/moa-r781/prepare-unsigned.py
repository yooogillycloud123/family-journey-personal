#!/usr/bin/env python3
"""Prepare unsigned APKs from exact immutable baselines. Never publish these."""
import hashlib, pathlib, struct, sys, zipfile, json, copy
from pathlib import Path
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def u16(b,p):return struct.unpack_from('<H',b,p)[0]
def u32(b,p):return struct.unpack_from('<I',b,p)[0]
def patch_manifest(data,old,new):
 b=bytearray(data); assert u16(b,0)==3 and u32(b,4)==len(b)
 # versionName strings are same length; change only the exact versionName string from the original string pool.
 p=u16(b,2); pool=None; names=[]; resource_ids=[]; edits=0
 while p<len(b):
  typ,hs,size=struct.unpack_from('<HHI',b,p); assert hs>=8 and size>=hs and p+size<=len(b)
  if typ==1:
   count,styles,flags,start,style_start=struct.unpack_from('<IIIII',b,p+8)
   pool=(p,hs,count,flags,start)
   for i in range(count):
    off=p+start+u32(b,p+hs+4*i);q=off
    if flags&0x100:
     n=b[q];q+=1
     if n&128:q+=1
     n=b[q];q+=1
     if n&128:n=((n&127)<<8)|b[q];q+=1
     names.append((bytes(b[q:q+n]).decode('utf8'),q,n,'utf8'))
    else:
     n=u16(b,q);q+=2
     if n&0x8000:n=((n&0x7fff)<<16)|u16(b,q);q+=2
     names.append((bytes(b[q:q+n*2]).decode('utf-16le'),q,n*2,'utf-16le'))
  elif typ==0x180:
   resource_ids=[u32(b,i) for i in range(p+hs,p+size,4)]
  elif typ==0x102 and names:
   ext=p+hs; tag=u32(b,ext+4)
   if names[tag][0]=='manifest':
    ast,asz,ac=struct.unpack_from('<HHH',b,ext+8)
    assert asz>=20
    for i in range(ac):
     a=ext+ast+i*asz; name=u32(b,a+4); raw=u32(b,a+8); dt=b[a+15]; v=u32(b,a+16)
     rid=resource_ids[name] if name<len(resource_ids) else 0
     if rid==0x0101021b: # android:versionCode
      assert names[name][0]=='versionCode' and dt in (0x10,0x11) and v==old
      struct.pack_into('<I',b,a+16,new);edits+=1
      if raw!=0xffffffff:
       t,q,n,enc=names[raw];assert t==str(old)
       val=str(new).encode(enc);assert len(val)==n;b[q:q+n]=val
     elif rid==0x0101021c: # android:versionName
      assert names[name][0]=='versionName' and dt==3
      for idx in {v,raw}-{0xffffffff}:
       t,q,n,enc=names[idx];assert t.endswith(str(old)),t
       val=(t[:-len(str(old))]+str(new)).encode(enc);assert len(val)==n;b[q:q+n]=val
      edits+=1
  p+=size
 assert edits==2,edits
 return bytes(b)
def prepare(base,dest,old,new,changes,expect):
 assert sha(base)==expect
 with zipfile.ZipFile(base) as z, zipfile.ZipFile(dest,'w') as out:
  assert z.testzip() is None
  assert len(set(z.namelist()))==len(z.namelist())
  assert not any(n.upper().startswith('META-INF/') and n.upper().endswith(('.RSA','.DSA','.EC','.SF')) for n in z.namelist()),'unexpected v1 signer'
  assert set(changes)<=set(z.namelist())
  for info in z.infolist():
   data=z.read(info)
   if info.filename=='AndroidManifest.xml':data=patch_manifest(data,old,new)
   elif info.filename in changes:data=changes[info.filename].read_bytes()
   zi=copy.copy(info);zi.extra=b''
   out.writestr(zi,data)
 with zipfile.ZipFile(base) as z,zipfile.ZipFile(dest) as y:
  assert y.testzip() is None and z.namelist()==y.namelist()
  diff={n for n in z.namelist() if z.read(n)!=y.read(n)}
  assert diff==set(changes)|{'AndroidManifest.xml'},diff
  for n in y.namelist():
   if n.endswith('.dex'):assert y.read(n).startswith(b'dex\n')
  print(json.dumps({'file':str(dest),'sha256':sha(dest),'entries':len(y.namelist()),'changed':sorted(diff),'signed':False}))
root=Path(sys.argv[1]); compiled=Path(sys.argv[2]);out=Path(sys.argv[3]);out.mkdir(parents=True,exist_ok=True)
changes={'classes27.dex':compiled/'classes27.dex'}
for name in ['family-diary.js','moa-r697-vertical-calendar.js','moa-r755-inline-ai.js']:
 changes['assets/web/'+name]=compiled/name
prepare(root/'moa-r779.apk',out/'R781_UNSIGNABLE_UNTIL_ORIGINAL_KEY.apk',779,781,changes,'5e10d4428fded0d0c74e188c4dcf9e92e852f6ba7f6af2ebcbc26ff84c867e61')
prepare(root/'moa-r771.apk',out/'R782_RECOVERY_UNSIGNED.apk',771,782,{},'2c045980073c93e08cdc8f09f41f2d749a54d1767f4f59884ec773bf7cc3c92d')
