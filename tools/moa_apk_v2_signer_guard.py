#!/usr/bin/env python3
"""Public, no-key APK v2 structure + crypto + content digest guard.

MOA 2026-11-07: old in-house signing code omitted the signer-list envelope,
which Android rejects with INSTALL_PARSE_FAILED_NO_CERTIFICATES despite the
RSA signature verifying out of context. This verifier validates BOTH envelope
layers, alg ID, key, digest and ZIP layout. Does not prove on-device install.
"""
from __future__ import annotations
import argparse,hashlib,json,struct,sys,zipfile
from pathlib import Path
from cryptography import x509
from cryptography.hazmat.primitives import serialization,hashes
from cryptography.hazmat.primitives.asymmetric import padding

def u32(b,p): return struct.unpack_from('<I',b,p)[0]
def u64(b,p): return struct.unpack_from('<Q',b,p)[0]
def lp(b,p):
 if p+4>len(b):raise ValueError('missing v2 length prefix')
 n=u32(b,p);e=p+4+n
 if e>len(b):raise ValueError('v2 size exceeds block')
 return b[p+4:e],e

def guard(path:Path,expected_cert:str|None=None):
 b=path.read_bytes();e=b.rfind(b'PK\x05\x06')
 if e<0:raise ValueError('no ZIP EOCD')
 cd=u32(b,e+16)
 if cd<32 or b[cd-16:cd]!=b'APK Sig Block 42':raise ValueError('missing APK signing block')
 sz=u64(b,cd-24);start=cd-(sz+8)
 if start<0 or u64(b,start)!=sz:raise ValueError('signing block size mismatch')
 pairs=b[start+8:cd-24];p=0;blocks={}
 while p<len(pairs):
  n=u64(pairs,p);i=u32(pairs,p+8)
  if n<4 or p+8+n>len(pairs):raise ValueError('bad signature block pair')
  blocks[i]=pairs[p+12:p+8+n];p+=8+n
 if p!=len(pairs):raise ValueError('trailing signing block bytes')
 val=blocks.get(0x7109871a)
 if val is None:raise ValueError('missing APK Signature Scheme v2')
 signers,end=lp(val,0)
 if end!=len(val):raise ValueError('invalid signers list envelope')
 signer,end=lp(signers,0)
 if end!=len(signers):raise ValueError('missing or multiple unexpected signers')
 sd,q=lp(signer,0);sigs,q=lp(signer,q);pub,q=lp(signer,q)
 if q!=len(signer):raise ValueError('trailing signer bytes')
 digests,q=lp(sd,0);certs,q=lp(sd,q);attrs,q=lp(sd,q)
 if q!=len(sd):raise ValueError('signed data trailing bytes')
 dentry,end=lp(digests,0)
 if end!=len(digests):raise ValueError('unexpected digest count')
 dalg=u32(dentry,0);dval,e2=lp(dentry,4)
 if e2!=len(dentry):raise ValueError('bad digest value')
 sentry,end=lp(sigs,0)
 if end!=len(sigs):raise ValueError('unexpected signature count')
 salg=u32(sentry,0);signature,e2=lp(sentry,4)
 if e2!=len(sentry) or (salg,dalg)!=(0x0103,0x0103):raise ValueError('unsupported algorithm')
 der,end=lp(certs,0)
 if end!=len(certs):raise ValueError('unexpected certificate count')
 cert=x509.load_der_x509_certificate(der);pubkey=cert.public_key()
 actual_cert=hashlib.sha256(der).hexdigest()
 if expected_cert and actual_cert!=expected_cert:raise ValueError('signer certificate differs from golden')
 if pubkey.public_bytes(serialization.Encoding.DER,serialization.PublicFormat.SubjectPublicKeyInfo)!=pub:raise ValueError('public key differs')
 pubkey.verify(signature,sd,padding.PKCS1v15(),hashes.SHA256())
 eocd=bytearray(b[e:]);struct.pack_into('<I',eocd,16,start)
 chunks=[]
 for section in (b[:start],b[cd:e],bytes(eocd)):
  for i in range(0,len(section),1024*1024):
   block=section[i:i+1024*1024]
   chunks.append(hashlib.sha256(b'\xa5'+struct.pack('<I',len(block))+block).digest())
 full=hashlib.sha256(b'\x5a'+struct.pack('<I',len(chunks))+b''.join(chunks)).digest()
 if full!=dval:raise ValueError('APK v2 content digest mismatch')
 with zipfile.ZipFile(path) as z:
  if z.testzip() is not None:raise ValueError('ZIP CRC invalid')
  for entry in z.infolist():
   if entry.compress_type==zipfile.ZIP_STORED:
    header=b[entry.header_offset:entry.header_offset+30]
    n,ex=struct.unpack_from('<HH',header,26)
    if (entry.header_offset+30+n+ex)%4:raise ValueError('unaligned stored entry: '+entry.filename)
  count=len(z.infolist())
 return {'file':path.name,'bytes':len(b),'sha256':hashlib.sha256(b).hexdigest(),
   'signer_cert_sha256':actual_cert,'algorithm':'RSA_PKCS1_V1_5_SHA256_0x0103',
   'signed_data_verified':True,'content_digest_verified':True,'zip_crc_aligned':True,'members':count,
   'device_install':'NOT_TESTED'}

if __name__=='__main__':
 parser=argparse.ArgumentParser()
 parser.add_argument('apk',type=Path)
 parser.add_argument('--cert-sha256',default=None)
 a=parser.parse_args()
 try:print(json.dumps(guard(a.apk,a.cert_sha256),ensure_ascii=False,indent=2))
 except Exception as e:
  print(json.dumps({'file':a.apk.name,'verdict':'FAIL','error':str(e)},ensure_ascii=False),file=sys.stderr)
  sys.exit(1)