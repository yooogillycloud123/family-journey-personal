from pathlib import Path
import struct, zipfile, hashlib,zlib
U=lambda b,o:struct.unpack_from('<I',b,o)[0]
H=lambda b,o:struct.unpack_from('<H',b,o)[0]
def leb(b,o):
 v=0;s=0
 while True:
  x=b[o];o+=1;v|=(x&127)<<s;s+=7
  if x<128:return v,o
class Dex:
 def __init__(self,b):
  self.b=b; ns,so,nt,to,np,po,nf,fo,nm,mo,nc,co=struct.unpack_from('<12I',b,56)
  self.strings=[]
  for i in range(ns):
   _,o=leb(b,U(b,so+4*i));self.strings.append(bytes(b[o:b.index(0,o)]).decode('utf8','replace'))
  self.types=[self.strings[U(b,to+4*i)] for i in range(nt)]
  self.methods=[(self.types[H(b,mo+8*i)],self.strings[U(b,mo+8*i+4)]) for i in range(nm)]
  self.fields=[(self.types[H(b,fo+8*i)],self.types[H(b,fo+8*i+2)],self.strings[U(b,fo+8*i+4)]) for i in range(nf)]
  self.codes={}
  for i in range(nc):
   o=U(b,co+32*i+24)
   if not o:continue
   counts=[]
   for _ in range(4):v,o=leb(b,o);counts.append(v)
   for _ in range(sum(counts[:2])):_,o=leb(b,o);_,o=leb(b,o)
   for n in counts[2:]:
    idx=0
    for _ in range(n):
     v,o=leb(b,o);idx+=v;_,o=leb(b,o);c,o=leb(b,o)
     if c:self.codes[idx]=c
 def method(self,cls,name):
  ids=[i for i,m in enumerate(self.methods) if m==(cls,name) and i in self.codes];assert len(ids)==1,ids
  c=self.codes[ids[0]];return c,list(struct.unpack_from('<%dH'%U(self.b,c+12),self.b,c+16))
cls='Lcom/juhyeon/familyjournea/MoaRemoteTimeline731;'
base=Path('/mnt/data/MOA_R743_ORIGINAL_PHOTO_CALENDAR_ORIGINAL_SIGNED_BETA.apk')
assert hashlib.sha256(base.read_bytes()).hexdigest()=='0b8cc1b3e6ea7484551559839bc76ba9e8058cb7bf47e51b942b2cdb05be53af'
b=bytearray(zipfile.ZipFile(base).read('classes24.dex'));d=Dex(b);off,code=d.method(cls,'typed')
print('typed registers/ins',H(b,off),H(b,off+2),'units',len(code))
for i,x in enumerate(code):print(i,f'{x:04x}', d.methods[code[i+1]] if x&255 in [0x6e,0x6f,0x70,0x71,0x72,0x74,0x75,0x76,0x77,0x78] and i+1<len(code) and code[i+1]<len(d.methods) else '')
# Exact R743 code, no reassembly or changes to native UI, photos, thumbnails, video or network.
assert code[95:101]==[0x1071,0x01fc,0x0008,0x070c,0x7453,0x010d]
assert d.methods[code[96]]==(cls,'fromUri')
assert d.fields[code[100]]==(cls[:-1]+'$Row;','J','size')
assert code[101:107]==[0x0216,0x0000,0x0676,0x0054,0x0000,0x0011]
assert d.methods[code[104]]==('Landroid/content/res/AssetFileDescriptor;','<init>')
# Android full file contract: declared length UNKNOWN_LENGTH (-1), real size is still available via ProxyFD.onGetSize.
replacement=[0x0416,0xffff,0,0,0,0]
struct.pack_into('<6H',b,off+16+95*2,*replacement)
b[12:32]=hashlib.sha1(b[32:]).digest();struct.pack_into('<I',b,8,zlib.adler32(b[12:])&0xffffffff)
a=Dex(b);_,after=a.method(cls,'typed');assert after[:95]==code[:95] and after[101:]==code[101:] and after[95:101]==replacement
orig=zipfile.ZipFile(base).read('classes24.dex');assert orig[32:off+16+95*2]==b[32:off+16+95*2] and orig[off+16+101*2:]==b[off+16+101*2:]
Path('/mnt/data/moa745_work/classes24.dex').write_bytes(b)
print('PASS exact DEX whole-file descriptor correction only; positive thumbnail AFD untouched')