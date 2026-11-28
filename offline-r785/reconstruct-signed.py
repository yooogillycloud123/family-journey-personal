"""Reconstruct exact locally original-signed APK bytes. No private key or signing operation."""
import pathlib,sys,json,zlib,base64,struct,hashlib
kit,delta,out=map(pathlib.Path,sys.argv[1:]); data=json.loads(delta.read_text()); out.mkdir(exist_ok=True)
expected={785:("b3021949745299d47de71d424b0b29b5de94a726d3d77adf1ee434966e791f7d",11053533,"9ab8130a17d8a2a5446199461ca639dbb8ae4671"),786:("50dcbcc989e1b946ecd6706286a6d4d788c5ea02047d2da6c30abaaae5c04679",11037072,"8131216c5cd33a5b8459bdfc4bdc2f5876b405d8")}
sha=lambda b:hashlib.sha256(b).hexdigest()
for v,(digest,size,blob) in expected.items():
 d=data[str(v)];u=(kit/f"MOA_R{v}_UNSIGNED_DO_NOT_INSTALL.apk").read_bytes();assert sha(u)==d["unsigned_sha256"]
 raw=zlib.decompress(base64.b64decode(d["delta_b64"],validate=True)); pos=0; output=bytearray()
 while pos<len(raw):
  tag=raw[pos];pos+=1
  if tag==0:
   a,n=struct.unpack_from("<II",raw,pos);pos+=8;assert a+n<=len(u);output.extend(u[a:a+n])
  elif tag==1:
   n,=struct.unpack_from("<I",raw,pos);pos+=4;assert pos+n<=len(raw);output.extend(raw[pos:pos+n]);pos+=n
  else:raise ValueError("invalid delta operation")
  assert len(output)<=size
 assert len(output)==size and sha(output)==digest==d["signed_sha256"]
 assert hashlib.sha1(b"blob "+str(size).encode()+b"\0"+output).hexdigest()==blob==d["blob"]
 target=out/f"MOA_R{v}_ORIGINAL_SIGNED.apk"
 if target.exists():assert target.read_bytes()==output
 else:target.write_bytes(output)
 print(v,"exact local signed APK reconstructed",size,digest)
