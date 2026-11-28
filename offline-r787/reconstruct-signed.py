"""Reconstruct exact locally original-signed APK bytes. No private key or signing operation."""
import pathlib,sys,json,zlib,base64,struct,hashlib
kit,delta,out=map(pathlib.Path,sys.argv[1:]); data={str(v):json.loads((delta/f'r{v}.delta.json').read_text()) for v in (787,788)}; out.mkdir(exist_ok=True)
expected={787:("2b64ceac823bcb4ea587fc4482b2c0600670d697bbf33b88011059fafe089c91",11057629,"3a1ffac45574d844971837c8b04ec5ca69375b88"),788:("168cf028a7fa63658d7e21d99f919e2cd6a998ef39f11ca5b7712fb6e5db104a",11053533,"3fb6a46fc767690e18a4c3096c3dccc5a46704d5")}
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
