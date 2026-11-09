"""Create self-signed LAN TLS cert; pin its SHA256 fingerprint in MOA Android bridge.
The self-signed certificate is owned locally by the user, not by NAVER.
"""
import argparse,hashlib,ipaddress,os
from datetime import datetime,timedelta,timezone
from pathlib import Path
from cryptography import x509
from cryptography.x509.oid import NameOID
from cryptography.hazmat.primitives.asymmetric import ec
from cryptography.hazmat.primitives import hashes,serialization

def generate(ip,out):
    out=Path(out);out.mkdir(parents=True,exist_ok=True)
    if (out/'server-key.pem').exists():raise ValueError('KEY_ALREADY_EXISTS_DO_NOT_OVERWRITE')
    private=ec.generate_private_key(ec.SECP256R1())
    name=x509.Name([x509.NameAttribute(NameOID.COMMON_NAME,'MOA private LAN bridge')])
    cert=(x509.CertificateBuilder().subject_name(name).issuer_name(name)
        .public_key(private.public_key()).serial_number(x509.random_serial_number())
        .not_valid_before(datetime.now(timezone.utc)-timedelta(minutes=2))
        .not_valid_after(datetime.now(timezone.utc)+timedelta(days=180))
        .add_extension(x509.SubjectAlternativeName([x509.IPAddress(ipaddress.ip_address(ip))]),critical=False)
        .sign(private,hashes.SHA256()))
    key_file=out/'server-key.pem';cert_file=out/'server-cert.pem'
    key_file.write_bytes(private.private_bytes(serialization.Encoding.PEM,serialization.PrivateFormat.PKCS8,serialization.NoEncryption()))
    cert_file.write_bytes(cert.public_bytes(serialization.Encoding.PEM))
    if os.name!='nt':os.chmod(key_file,0o600)
    print('CERT_SHA256_PIN=',hashlib.sha256(cert.public_bytes(serialization.Encoding.DER)).hexdigest())
    print('CERT_PATH=',cert_file)
    print('KEY_PATH=',key_file)
if __name__=='__main__':
    a=argparse.ArgumentParser();a.add_argument('--ip',required=True);a.add_argument('--output',default='.moa-tls')
    p=a.parse_args();generate(p.ip,p.output)
