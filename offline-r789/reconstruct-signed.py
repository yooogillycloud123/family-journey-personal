import pathlib,sys,json,zlib,base64,struct,hashlib
kit,delta,out=map(pathlib.Path,sys.argv[1:]); data=json.loads(delta.read_text()); out.mkdir(exist_ok=True)
expected={789:("e7f5afbaf637d231f80f754b488d77f88d2e12a5ef85fcd0bfc972499a81fbf7",11065821,"38a38d6e3204754c4619a4f97e23d15d796129df"),790:("af0b79216493e811816763e6904dc763bfc0b30e6ff2a8f3dc3766be7e3b633f",11057629,"cfd8ffc3fa07768eb569f0174029663e671038b6")}
sha=lambda b:hashlib.sha256(b).hexdigest()
for v,(digest,size,blob) in expected.items():
 d=data[str(v)];u=(kit/f"MOA_R{v}_UNSIGNED_DO_NOT_INSTALL.apk").read_bytes();assert sha(u)==d["unsigned_sha256"]
 raw=zlib.decompress(base64.b64decode(d["delta_b64"],validate=True));pos=0;output=bytearray()
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
 (out/f"MOA_R{v}_ORIGINAL_SIGNED.apk").write_bytes(output)
 print(v,"exact signed APK reconstructed",size,digest)
