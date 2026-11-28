import pathlib,sys,json,zlib,base64,struct,hashlib
kit,delta,out=map(pathlib.Path,sys.argv[1:]); data=json.loads(delta.read_text()); out.mkdir(exist_ok=True)
expected={791:("d0c13a6e5fe73e9a0e520858a99430981c71494f8e238beb907a53af38d1815a",11065821,"47ddeb88166851a432993b407a6c7697991344cd"),792:("fb66db911ac3748a16561cba6053a9fe99ee12fd919ab05171d1a1f52cdc7ec0",11065821,"853d54ee0be36d5c6be14d7b60c3e170ac723f6f")}
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
