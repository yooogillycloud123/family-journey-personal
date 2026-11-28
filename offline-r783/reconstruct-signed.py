"""Reconstruct exact locally original-signed APK bytes. No private key or signing operation."""
import pathlib,sys,json,zlib,base64,struct,hashlib
kit,delta,out=map(pathlib.Path,sys.argv[1:]); data=json.loads(delta.read_text()); out.mkdir(exist_ok=True)
expected={783:("a355ec1cf7dbce64ccef0775f78fc9aa5efe23f9034aacf18ea450635e678529",11037072,"29a557403dddce1375df7ff44d8abc5570b0e962"),784:("4f399e3e9692859662fc03e124cf26ae7b640366964374fa775cf99c99cb2a73",11032976,"ac2b0f9d0da459d0edb971fec48803e9ddff7f5e")}
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
